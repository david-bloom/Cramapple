#!/usr/bin/env python3
"""Test of three ideas for improving MCQ coaching (offline, synthetic, no DB writes).

Idea 1  Lean prompt: three rules instead of a long rule list.
Idea 2  Code computes history facts + directive (vs. model computing them).
Idea 3  Prohibitions enforced by post-generation checks (with one retry) instead of in the prompt.

Part A: 20 wrong-answer MCQs, single shot. Arms: BASE (current prompt) vs LEAN (+ checks, + one retry).
Part B: 3 scripted 5-question sequences. Arms: LM (model computes history) vs CODE (code computes), both LEAN prompt.
"""
import json, os, re, sys, time, random
from concurrent.futures import ThreadPoolExecutor
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import run_test as R
import seq_test as S

D = R.D
JUDGES = ["google/gemini-3-flash", "openai/gpt-5.4-mini"]
R.PRICE["openai/gpt-5.4-mini"] = (7.5e-7, 4.5e-6)
random.seed(21)

BASE = R.VOICE
LEAN = ("You write coaching for a high-school AP student who just missed a multiple-choice question. Three rules:\n"
        "1. Explain the error using only the reason supplied. Add no facts of your own.\n"
        "2. End with one question the student can answer to try the problem again themselves.\n"
        "3. If a DIRECTIVE is given, follow it.\n"
        "Plain words, about 80 words, no praise filler, no headings.")

LEAK_SYS = ("Does the coaching text state, name or clearly identify the correct answer to the question (not merely explain why the student's choice is wrong)? "
            'Return JSON only: {"leaks":true|false,"evidence":str}.')


def leak(item, correct, text):
    u = f"Question: {R.clean(item['stem'])}\nCorrect answer: {R.clean(correct['choice_text'])}\n\nCoaching text:\n{text}"
    res, cost = [], 0.0
    for m in JUDGES:
        r = R.chat(m, LEAK_SYS, u, json_mode=True, max_tokens=500)
        cost += r["cost"]
        try:
            res.append(bool(json.loads(r["text"]).get("leaks")))
        except Exception:
            res.append(None)
    return res, cost


STATE_CLAIM = re.compile(r"(clicking|you're getting it|you are getting it|improving|you keep|you always|careless|lazy|great job|well done)", re.I)


def other_checks(text, chosen, correct):
    f, t = [], text.lower()
    if re.search(rf"\b(choice|option|answer)\s*\(?{re.escape(correct['choice_key'].lower())}\)?\b", t):
        f.append("names_correct_letter")
    ct = R.clean(correct["choice_text"]).lower()
    if len(ct) > 12 and ct in t:
        f.append("quotes_correct_text")
    if re.search(r"partial credit|half (a )?point|\d+ of \d+ points", t):
        f.append("invents_partial_credit")
    if STATE_CLAIM.search(text):
        f.append("state_claim")
    n = len(text.split())
    if not (35 <= n <= 170):
        f.append("length")
    return f


def facts_for(item, chosen):
    return (f"Question: {R.clean(item['stem'])}\nThe student chose {chosen['choice_key']}: {R.clean(chosen['choice_text'])}\n"
            f"Authored reason this choice is wrong: {R.clean(chosen['rationale'])}\nThe question is worth one point; the student missed it.")


def gen(system, facts, extra=""):
    return R.chat(R.COACH_MODEL, system, facts + (("\n\n" + extra) if extra else ""), max_tokens=450)


def evaluate(item, chosen, correct, text):
    f = other_checks(text, chosen, correct)
    lk, lc = leak(item, correct, text)
    leaked = any(x for x in lk if x)
    if leaked:
        f.append("leaks_answer")
    ends_q = "?" in text[-220:]
    return {"checks_failed": f, "leak_judges": lk, "ends_with_question": ends_q, "judge_cost": lc}


def part_a(m_items):
    def one(x):
        subj, it, v, cs, wrong = x
        correct = next(c for c in cs if c["is_correct"]); chosen = random.Random(it["content_key"]).choice(wrong)
        facts = facts_for(v, chosen)
        out = {"key": it["content_key"], "subject": subj, "chosen": chosen["choice_key"], "arms": {}}
        rb = gen(BASE, facts); eb = evaluate(v, chosen, correct, rb["text"])
        out["arms"]["BASE"] = {"text": rb["text"], "coach_s": rb["total_s"], "cost": rb["cost"], **eb}
        rl = gen(LEAN, facts); el = evaluate(v, chosen, correct, rl["text"])
        out["arms"]["LEAN"] = {"text": rl["text"], "coach_s": rl["total_s"], "cost": rl["cost"], **el}
        # one retry on failure (idea 3)
        if el["checks_failed"]:
            why = "; ".join(el["checks_failed"])
            r2 = gen(LEAN, facts, f"Your previous draft failed these checks: {why}. Rewrite it so it passes. Never state or name the correct answer; make the final sentence a question for the student.")
            e2 = evaluate(v, chosen, correct, r2["text"])
            out["arms"]["LEAN_RETRY"] = {"text": r2["text"], "coach_s": r2["total_s"] + rl["total_s"], "cost": r2["cost"] + rl["cost"], **e2}
        else:
            out["arms"]["LEAN_RETRY"] = dict(out["arms"]["LEAN"], retried=False)
        return out
    with ThreadPoolExecutor(4) as ex:
        return list(ex.map(one, m_items))


def pick_items():
    I, V, ch, cr = R.load()
    T = {t["content_item_version_id"]: t for t in json.load(open(f"{D}/topics.json"))}
    bio, stats, pool = [], {}, {}
    for v in V:
        it = I.get(v["content_item_id"])
        if not it or it["item_type"] != "mcq":
            continue
        k = it["content_key"].lower()
        cs = ch.get(v["id"], [])
        wrong = [c for c in cs if not c["is_correct"] and len(R.clean(c.get("rationale"))) > 40]
        if not (len(cs) >= 4 and len(wrong) >= 2 and sum(c["is_correct"] for c in cs) == 1):
            continue
        t = T.get(v["id"])
        if k.startswith("apbio"):
            bio.append(("bio", it, v, cs, wrong))
        elif k.startswith("apstat") and t:
            pool.setdefault(t["topic_code"], []).append(("stats", it, v, cs, wrong, t["topic_title"]))
    random.shuffle(bio)
    stats = []
    for tc in ["1.2", "1.7", "1.9", "1.11", "1.13", "5.3", "1.3", "1.4", "1.5", "2.1", "1.1", "2.2"]:
        if tc in pool:
            random.shuffle(pool[tc]); stats.append(pool[tc][0][:5])
    return bio[:10] + stats[:10], pool


def lean_history_coach(item, chosen, correct, hist, topic, arm):
    is_corr = chosen["choice_key"] == correct["choice_key"]
    if is_corr:
        facts = (f"Question: {R.clean(item['stem'])}\nThe student chose {chosen['choice_key']}: {R.clean(chosen['choice_text'])} (correct, 1 of 1 point).")
        system = ("You write brief coaching for a high-school AP student who answered a multiple-choice question correctly. "
                  "One or two plain sentences on what made the choice right, no praise filler. If a DIRECTIVE is given, follow it.")
    else:
        facts, system = facts_for(item, chosen), LEAN
    block = S.history_block(hist, topic, arm, is_corr)
    return gen(system, facts, block), is_corr


def part_b(pool):
    patterns = [("1.11", "1.2"), ("1.13", "1.9"), ("1.7", "1.9")]
    plan_tpl = [(0, False), (1, True), (0, False), (0, False), (0, True)]

    def seqrun(idx):
        main, other = patterns[idx]
        rng = random.Random(100 + idx)
        items = {main: list(pool[main]), other: list(pool[other])}
        for k in items:
            rng.shuffle(items[k])
        out = {}
        # One script of (item, chosen answer) per step, fixed BEFORE the arms run, so
        # both arms see identical questions and identical wrong answers and rationales.
        script, used0 = [], {main: 0, other: 0}
        for which, want in plan_tpl:
            tc = main if which == 0 else other
            sub, it, v, cs, wrong, title = items[tc][used0[tc]]; used0[tc] += 1
            correct = next(c for c in cs if c["is_correct"])
            chosen = correct if want else rng.choice(wrong)
            script.append((tc, v, cs, title, correct, chosen))
        for arm in ("LM", "CODE"):
            hist, steps = [], []
            for step, (tc, v, cs, title, correct, chosen) in enumerate(script, 1):
                is_c = chosen["choice_key"] == correct["choice_key"]
                topic = f"{tc} {title}"
                same_miss = sum(1 for h in hist if h["topic"] == topic and not h["correct"])
                r, _ = lean_history_coach(v, chosen, correct, hist, topic, "B" if arm == "LM" else "D")
                f, refs = S.checks(r["text"], chosen, correct, step, same_miss, arm)
                if not is_c:
                    f += [x for x in other_checks(r["text"], chosen, correct) if x not in f]
                    lk, _lc = leak(v, correct, r["text"])
                    if any(x for x in lk if x):
                        f.append("leaks_answer")
                steps.append({"step": step, "topic": topic, "correct": is_c, "prior_same_topic_misses": same_miss,
                              "history_language": refs, "checks_failed": f, "text": r["text"], "coach_s": r["total_s"], "cost": r["cost"],
                              "step_back": bool(re.search(r"step back|key idea|back to the (?:basics|idea|topic)|review the topic|before (?:another|trying)", r["text"], re.I))})
                hist.append({"topic": topic, "correct": is_c, "chosen_rationale": None})
            out[arm] = steps
        return {"seq": idx, "topics": patterns[idx], "arms": out}
    with ThreadPoolExecutor(3) as ex:
        return list(ex.map(seqrun, range(3)))


def main():
    items, pool = pick_items()
    print("items", len(items), file=sys.stderr)
    t0 = time.time()
    A = part_a(items)
    print("part A done", round(time.time() - t0), "s", file=sys.stderr)
    B = part_b({k: v for k, v in pool.items()})
    print("part B done", round(time.time() - t0), "s", file=sys.stderr)
    json.dump({"A": A, "B": B}, open(f"{D}/lean_results.json", "w"), indent=1)


if __name__ == "__main__":
    main()
