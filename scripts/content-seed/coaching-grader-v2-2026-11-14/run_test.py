#!/usr/bin/env python3
"""Coaching-via-grader timing/cost test (offline harness; no DB writes).

Per item: synthetic submit -> grade leg -> coaching leg -> post-checks.
Grade leg for FRQ is a STAND-IN (gpt-5.4-mini, the model the Dev grader uses),
not the deployed evaluate-attempt. MCQ grade leg is the deterministic composer
(no model). Render leg is measured separately in a browser (render_test.mjs).
"""
import json, os, re, sys, time, random, urllib.request, statistics

D = os.path.dirname(os.path.abspath(__file__))
KEY = os.environ["AI_GATEWAY_API_KEY"]
GW = "https://ai-gateway.vercel.sh/v1/chat/completions"
PRICE = {  # $/token from gateway /v1/models
    "anthropic/claude-haiku-5.5": (1e-7, 5e-7),
    "openai/gpt-5.4-mini": (7.5e-7, 4.5e-6),
}
COACH_MODEL = "anthropic/claude-haiku-5.5"
GRADE_MODEL = "openai/gpt-5.4-mini"
random.seed(7)


def chat(model, system, user, json_mode=False, max_tokens=700):
    body = {"model": model, "stream": True, "stream_options": {"include_usage": True},
            "max_tokens": max_tokens, "reasoning": {"enabled": False},
            "messages": [{"role": "system", "content": system}, {"role": "user", "content": user}]}
    if json_mode:
        body["response_format"] = {"type": "json_object"}
    req = urllib.request.Request(GW, json.dumps(body).encode(),
                                 {"Authorization": f"Bearer {KEY}", "Content-Type": "application/json"})
    t0 = time.perf_counter(); ttft = None; text = []; usage = {}; rs = [0]
    with urllib.request.urlopen(req, timeout=90) as r:
        for raw in r:
            line = raw.decode().strip()
            if not line.startswith("data:"):
                continue
            payload = line[5:].strip()
            if payload == "[DONE]":
                break
            ev = json.loads(payload)
            if ev.get("usage"):
                usage = ev["usage"]
            for ch in ev.get("choices", []):
                d = ch.get("delta") or {}
                if d.get("reasoning") or d.get("reasoning_content"):
                    rs[0] += 1
                piece = d.get("content")
                if piece:
                    if ttft is None:
                        ttft = time.perf_counter() - t0
                    text.append(piece)
    total = time.perf_counter() - t0
    pi, po = PRICE[model]
    ti, to = usage.get("prompt_tokens", 0), usage.get("completion_tokens", 0)
    return {"text": "".join(text), "ttft_s": ttft, "total_s": total,
            "reasoning_chunks": rs[0], "in_tok": ti, "out_tok": to, "cost": ti * pi + to * po}


VOICE = """You write coaching for a high-school AP student on a feedback card.
Voice: a teacher showing how to earn points. Plain words. Short (60-110 words). No praise filler, no emoji, no judging the student.
Structure: (1) what the question required, (2) what the student did or did not do against it, (3) why that piece is required, (4) one concrete next move.
Use ONLY the facts given below. Do not add facts. Do not state or hint at the correct choice letter or its wording for multiple choice."""


def clean(s):
    return re.sub(r"\s+", " ", (s or "")).strip()


def load():
    I = {i["id"]: i for i in json.load(open(f"{D}/items.json"))}
    V = json.load(open(f"{D}/versions.json"))
    ch, cr = {}, {}
    for c in json.load(open(f"{D}/choices.json")):
        ch.setdefault(c["content_item_version_id"], []).append(c)
    for c in json.load(open(f"{D}/criteria.json")):
        cr.setdefault(c["content_item_version_id"], []).append(c)
    return I, V, ch, cr


def pick(I, V, ch, cr):
    mcq, frq = [], []
    for v in V:
        it = I.get(v["content_item_id"])
        if not it:
            continue
        key = it["content_key"].lower()
        subj = "bio" if key.startswith("apbio") else "stats" if key.startswith(("apstat",)) else None
        if not subj:
            continue
        if it["item_type"] == "mcq":
            cs = ch.get(v["id"], [])
            wrong = [c for c in cs if not c["is_correct"] and len(clean(c.get("rationale"))) > 40]
            if len(cs) >= 4 and len(wrong) >= 2 and sum(c["is_correct"] for c in cs) == 1:
                mcq.append((subj, it, v, cs, wrong))
        elif it["item_type"] == "frq" and v["evaluator_strategy"] == "llm_discrete_text":
            cs = cr.get(v["id"], [])
            if len(cs) >= 2 and len(clean(v["stem"])) > 30:
                frq.append((subj, it, v, cs))
    random.shuffle(mcq); random.shuffle(frq)
    m = [x for x in mcq if x[0] == "bio"][:5] + [x for x in mcq if x[0] == "stats"][:5]
    f = [x for x in frq if x[0] == "bio"][:5] + [x for x in frq if x[0] == "stats"][:5]
    return m, f


def run_mcq(subj, it, v, cs, wrong):
    chosen = random.choice(wrong)                       # synthetic submit: a wrong answer
    correct = next(c for c in cs if c["is_correct"])
    t_submit = time.perf_counter()
    # grade leg: deterministic (rule-based). Verdict is a key comparison.
    t0 = time.perf_counter(); graded = chosen["choice_key"] != correct["choice_key"]
    grade_s = time.perf_counter() - t0
    facts = (f"Question: {clean(v['stem'])}\nThe student chose {chosen['choice_key']}: {clean(chosen['choice_text'])}\n"
             f"Authored reason this choice is wrong: {clean(chosen['rationale'])}\n"
             f"The question is worth one point; the student missed it.")
    r = chat(COACH_MODEL, VOICE, facts, max_tokens=400)
    # post-checks (deterministic, fail closed)
    txt = r["text"].lower(); fails = []
    if correct["choice_key"] != chosen["choice_key"] and re.search(
            rf"\b(choice|option|answer)\s*\(?{re.escape(correct['choice_key'].lower())}\)?\b", txt):
        fails.append("names_correct_choice_letter")
    ctext = clean(correct["choice_text"]).lower()
    if len(ctext) > 12 and ctext in txt:
        fails.append("quotes_correct_choice_text")
    if re.search(r"partial credit|half (a )?point|\d+ of \d+ points", txt):
        fails.append("invents_partial_credit")
    if not (30 <= len(r["text"].split()) <= 160):
        fails.append("length")
    return {"type": "mcq", "subject": subj, "key": it["content_key"], "grade_s": grade_s,
            "ttft_s": r["ttft_s"], "coach_s": r["total_s"], "in_tok": r["in_tok"], "out_tok": r["out_tok"],
            "coach_cost": r["cost"], "grade_cost": 0.0, "grade_model": "rule-based", "checks_failed": fails,
            "text": r["text"], "submit_to_text_s": (time.perf_counter() - t_submit)}


GRADE_SYS = ("You grade an AP free-response answer against rubric criteria. Return JSON: "
             '{"criteria":[{"criterion_key":str,"status":"earned|partially_earned|not_yet_earned",'
             '"points_awarded":number,"evidence_quote":str|null,"decision_explanation":str,"minimum_fix":str|null}]}. '
             "evidence_quote must be copied verbatim from the student response or null.")


def run_frq(subj, it, v, cs):
    # synthetic student response (setup, not timed as part of submit path)
    rub = "\n".join(f"- {c['criterion_key']} ({c['points_possible']} pt): {clean(c['learner_facing_text'])}" for c in cs)
    setup = chat(COACH_MODEL, "Write a realistic 3-5 sentence high-school student answer. Satisfy roughly half the criteria, "
                 "miss the rest naturally (omit or be vague). Output only the answer.",
                 f"Question: {clean(v['stem'])}\nCriteria:\n{rub}", max_tokens=300)
    response = clean(setup["text"])
    t_submit = time.perf_counter()
    gu = (f"Question: {clean(v['stem'])}\nCriteria:\n" +
          "\n".join(f"- {c['criterion_key']} ({c['points_possible']} pt): {clean(c['learner_facing_text'])} | evidence: "
                    f"{clean(c.get('evidence_requirements'))}" for c in cs) + f"\nStudent response: {response}")
    g = chat(GRADE_MODEL, GRADE_SYS, gu, json_mode=True, max_tokens=1200)
    try:
        crit = json.loads(g["text"])["criteria"]
    except Exception:
        return {"type": "frq", "subject": subj, "key": it["content_key"], "error": "grade_json_failed",
                "grade_s": g["total_s"], "grade_cost": g["cost"]}
    byk = {c["criterion_key"]: c for c in cs}
    # sanitizer stand-ins: known keys, clamped points, quote must be in response
    for c in crit:
        k = byk.get(c.get("criterion_key"))
        if k:
            c["points_awarded"] = max(0, min(float(c.get("points_awarded") or 0), float(k["points_possible"])))
        q = c.get("evidence_quote")
        if q and clean(q).lower() not in response.lower():
            c["evidence_quote"] = None; c["status"] = "not_yet_earned"; c["points_awarded"] = 0
    earned = sum(c["points_awarded"] for c in crit); avail = sum(float(c["points_possible"]) for c in cs)
    payload = "\n".join(f"- {c['criterion_key']}: {c['status']}, {c['points_awarded']} pts; quote={c.get('evidence_quote')!r}; "
                        f"why={clean(c.get('decision_explanation'))}; fix={clean(c.get('minimum_fix'))}" for c in crit)
    facts = (f"Question: {clean(v['stem'])}\nStudent response: {response}\nGrader verdicts ({earned:g} of {avail:g} points):\n{payload}\n"
             "Criterion requirements:\n" + "\n".join(f"- {c['criterion_key']}: {clean(c['learner_facing_text'])}" for c in cs))
    r = chat(COACH_MODEL, VOICE + "\nName the single highest-value missing criterion first. Quote the student only with words they wrote.",
             facts, max_tokens=500)
    txt = r["text"]; fails = []
    nums = re.findall(r"(\d+(?:\.\d+)?)\s*(?:of|out of|/)\s*(\d+(?:\.\d+)?)\s*points?", txt.lower())
    for a, b in nums:
        if abs(float(a) - earned) > 1e-6 or abs(float(b) - avail) > 1e-6:
            fails.append(f"points_mismatch({a}/{b} vs {earned:g}/{avail:g})")
    for q in re.findall(r"[\"“]([^\"”]{6,})[\"”]", txt):
        if clean(q).lower().rstrip(".") not in response.lower():
            fails.append("quote_not_in_response")
    if not (30 <= len(txt.split()) <= 180):
        fails.append("length")
    return {"type": "frq", "subject": subj, "key": it["content_key"], "grade_s": g["total_s"], "grade_cost": g["cost"],
            "grade_model": "gpt-5.4-mini (stand-in)", "ttft_s": r["ttft_s"], "coach_s": r["total_s"],
            "in_tok": r["in_tok"], "out_tok": r["out_tok"], "coach_cost": r["cost"], "checks_failed": fails,
            "points": f"{earned:g}/{avail:g}", "text": txt, "response": response,
            "submit_to_text_s": time.perf_counter() - t_submit}


def main():
    I, V, ch, cr = load()
    m, f = pick(I, V, ch, cr)
    print(f"selected {len(m)} mcq, {len(f)} frq", file=sys.stderr)
    out = []
    for x in m:
        out.append(run_mcq(*x)); print("mcq", out[-1]["key"], round(out[-1]["coach_s"], 2), file=sys.stderr)
    for x in f:
        out.append(run_frq(*x)); print("frq", out[-1]["key"], round(out[-1].get("coach_s", 0), 2), file=sys.stderr)
    json.dump(out, open(f"{D}/results.json", "w"), indent=1)


if __name__ == "__main__":
    main()
