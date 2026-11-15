#!/usr/bin/env python3
"""Sequential 5-MCQ test: does coaching adapt to past performance?

One synthetic student, one session, graded strictly in sequence (each step's
history comes from the previous graded results). Pattern:
  Q1 topic 1.11 wrong | Q2 topic 1.2 correct | Q3 topic 1.11 wrong |
  Q4 topic 1.11 wrong | Q5 topic 1.9 correct
Arms per step (same item, same chosen answer):
  A  no history (control; what the system does today)
  B  history = counts, topic and outcomes only (the v2 plan's design)
  C  B + authored rationale of the distractors previously chosen (variant)
"""
import json, os, re, sys, time, random
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import run_test as R

D = R.D
R.PRICE["google/gemini-3-flash"] = (5e-7, 3e-6)
JUDGE = "google/gemini-3-flash"
random.seed(11)

BASE = R.VOICE


ORD = {1: "first", 2: "second", 3: "third", 4: "fourth", 5: "fifth"}


def history_block(hist, topic, arm, is_correct=False):
    if arm == "A" or not hist:
        return ""
    same = [h for h in hist if h["topic"] == topic]
    if arm == "D":
        prior_miss = sum(1 for h in same if not h["correct"])
        if prior_miss == 0:
            return ""            # nothing relevant: say nothing about history
        if is_correct:
            return (f"COMPUTED FACT: this is the student's first correct answer on this topic after {prior_miss} earlier misses on it. "
                    "DIRECTIVE: add one factual sentence noting the recovery. No gushing, no generalising.")
        n = prior_miss + 1
        if n == 2:
            d = "DIRECTIVE: say plainly that this is the second miss on this topic, and tie it to what the question requires."
        else:
            d = (f"DIRECTIVE: say plainly that this is the {ORD.get(n, str(n)+'th')} miss on this topic and recommend stepping back to the "
                 "topic's key idea before another attempt, instead of just retrying. Do not shame or generalise.")
        return f"COMPUTED FACT: this is the student's {ORD.get(n, str(n)+'th')} miss on this topic.\n{d}"
    lines = [f"Session history for this student (counts and outcomes only; no student wording):"]
    for i, h in enumerate(hist, 1):
        lines.append(f"- Q{i} [{h['topic']}]: {'missed' if not h['correct'] else 'correct'}")
    lines.append(f"On THIS question's topic ({topic}): {sum(1 for h in same if not h['correct'])} earlier miss(es), "
                 f"{sum(1 for h in same if h['correct'])} earlier correct.")
    if arm == "C":
        prior = [h for h in same if not h["correct"] and h.get("chosen_rationale")]
        if prior:
            lines.append("Authored reasons the previously chosen wrong answers on this topic were wrong:")
            for h in prior:
                lines.append(f"  * {R.clean(h['chosen_rationale'])}")
    lines.append(
        "How to use history: use it only when it changes what the student should do next. "
        "No earlier miss on this topic -> do not mention history. "
        "Second miss on the topic -> say plainly it is the second miss on this topic and tie it to what the question requires. "
        "Third or later miss -> recommend stepping back to the topic's key idea before another attempt, not just retrying. "
        "Correct after earlier misses on the topic -> one factual sentence noting the recovery, no gushing. "
        "Never shame or generalise ('you keep...'); never mention history from a different topic.")
    return "\n".join(lines)


def coach(item, chosen, correct, hist, topic, arm):
    is_corr = chosen['choice_key'] == correct['choice_key']
    q = R.clean(item["stem"])
    if chosen["choice_key"] == correct["choice_key"]:
        facts = (f"Question: {q}\nThe student chose {chosen['choice_key']}: {R.clean(chosen['choice_text'])} (correct, 1 of 1 point).\n"
                 + (f"Why it is right: {R.clean(correct['rationale'])}" if len(R.clean(correct.get('rationale'))) > 10 else "No authored reason is available for the correct choice; confirm it briefly using only the question and the choice text."))
    else:
        facts = (f"Question: {q}\nThe student chose {chosen['choice_key']}: {R.clean(chosen['choice_text'])}\n"
                 f"Authored reason this choice is wrong: {R.clean(chosen['rationale'])}\n"
                 f"The question is worth one point; the student missed it.")
    h = history_block(hist, topic, arm, is_corr)
    r = R.chat(R.COACH_MODEL, BASE, facts + ("\n\n" + h if h else ""), max_tokens=450)
    return r


HIST_WORDS = re.compile(r"\b(second|third|fourth|fifth|twice|earlier (?:miss|question|answer)|previous(?:ly)?|after (?:one|two|three|four|\d) (?:earlier )?(?:miss|misses)|first correct|recover|so far|again on|missed this topic)", re.I)


def checks(text, chosen, correct, step, hist_same_misses, arm):
    f = []
    t = text.lower()
    if chosen["choice_key"] != correct["choice_key"]:
        if re.search(rf"\b(choice|option|answer)\s*\(?{re.escape(correct['choice_key'].lower())}\)?\b", t):
            f.append("names_correct_letter")
        ct = R.clean(correct["choice_text"]).lower()
        if len(ct) > 12 and ct in t:
            f.append("quotes_correct_text")
    if re.search(r"you keep|you always|you never|careless|lazy", t):
        f.append("judgy_generalisation")
    refs = bool(HIST_WORDS.search(text))
    m = re.search(r"\b(first|second|third|fourth|fifth)\s+miss", t)
    if m:
        want = {"first": 1, "second": 2, "third": 3, "fourth": 4, "fifth": 5}[m.group(1)]
        if want != hist_same_misses + 1:
            f.append(f"wrong_ordinal(said {m.group(1)}, true {ORD.get(hist_same_misses + 1)})")
    m2 = re.search(r"after (one|two|three|four|\d) (?:earlier )?miss", t)
    if m2 and chosen["choice_key"] == correct["choice_key"]:
        w = {"one": 1, "two": 2, "three": 3, "four": 4}.get(m2.group(1)) or int(m2.group(1))
        if w != hist_same_misses:
            f.append("wrong_miss_count_on_recovery")
    return f, refs


LEAK_SYS = ("Does the coaching text state, name or clearly identify the correct answer to the question (not merely explain why the student's choice is wrong)? "
            'Return JSON only: {"leaks":true|false,"evidence":str}.')


def leak_check(item, correct, text):
    u = f"Question: {R.clean(item['stem'])}\nCorrect answer: {R.clean(correct['choice_text'])}\n\nCoaching text:\n{text}"
    r = R.chat(JUDGE, LEAK_SYS, u, json_mode=True, max_tokens=300)
    try:
        return json.loads(r["text"]).get("leaks"), r["cost"]
    except Exception:
        return None, r["cost"]


JUDGE_SYS = ("You compare two coaching texts for a student on one AP Statistics multiple-choice question. "
             "Return JSON only: {\"better\":\"X\"|\"Y\"|\"tie\",\"reason\":str,\"x_uses_history_well\":0-3,\"y_uses_history_well\":0-3,"
             "\"x_tone_ok\":bool,\"y_tone_ok\":bool}. 'uses history well' means it refers to the student's earlier results "
             "only when that changes what the student should do, accurately, without shaming (0=misuses or ignores when it should use, 3=ideal). "
             "You are told the history facts.")


def judge(step_desc, hist_txt, tx, ty):
    u = f"Situation: {step_desc}\nHistory facts: {hist_txt}\n\nText X:\n{tx}\n\nText Y:\n{ty}"
    r = R.chat(JUDGE, JUDGE_SYS, u, json_mode=True, max_tokens=700)
    try:
        return json.loads(r["text"]), r
    except Exception:
        return None, r


def main():
    I, V, ch, cr = R.load()
    T = {t["content_item_version_id"]: t for t in json.load(open(f"{D}/topics.json"))}
    pool = {}
    for v in V:
        it = I.get(v["content_item_id"])
        if not it or it["item_type"] != "mcq" or not it["content_key"].lower().startswith("apstat"):
            continue
        cs = ch.get(v["id"], [])
        wrong = [c for c in cs if not c["is_correct"] and len(R.clean(c.get("rationale"))) > 40]
        t = T.get(v["id"])
        if t and len(cs) >= 4 and len(wrong) >= 2 and sum(c["is_correct"] for c in cs) == 1:
            pool.setdefault(t["topic_code"], []).append((it, v, cs, wrong, t["topic_title"]))
    for k in pool:
        random.shuffle(pool[k])
    print({k:len(v) for k,v in pool.items()}, file=sys.stderr)
    plan = [("1.11", False), ("1.2", True), ("1.11", False), ("1.11", False), ("1.11", True)]
    used = {k: 0 for k in pool}
    hist, out = [], []
    for step, (tc, want_correct) in enumerate(plan, 1):
        it, v, cs, wrong, title = pool[tc][used[tc]]; used[tc] += 1
        correct = next(c for c in cs if c["is_correct"])
        chosen = correct if want_correct else random.choice(wrong)
        t_submit = time.perf_counter()
        is_correct = chosen["choice_key"] == correct["choice_key"]      # grade leg (rule-based)
        topic = f"{tc} {title}"
        rec = {"step": step, "item": it["content_key"], "topic": topic, "correct": is_correct, "arms": {}}
        same_miss = sum(1 for h in hist if h["topic"] == topic and not h["correct"])
        for arm in ("A", "B", "C", "D"):
            r = coach(v, chosen, correct, hist, topic, arm)
            f, refs = checks(r["text"], chosen, correct, step, same_miss, arm)
            lk, lk_cost = (None, 0.0) if is_correct else leak_check(v, correct, r["text"])
            rec["arms"][arm] = {"leaks_correct_answer": lk, "text": r["text"], "coach_s": r["total_s"], "ttft_s": r["ttft_s"], "cost": r["cost"],
                                "in_tok": r["in_tok"], "out_tok": r["out_tok"], "checks_failed": f, "history_language": refs}
        rec["same_topic_prior_misses"] = same_miss
        # blinded pairwise judge: B vs A, C vs A, randomised order
        hist_txt = "; ".join(f"Q{i} {h['topic']} {'missed' if not h['correct'] else 'correct'}" for i, h in enumerate(hist, 1)) or "none (first question)"
        desc = f"Question {step} of 5, topic {topic}; the student {'answered correctly' if is_correct else 'missed it'}."
        rec["judge"] = {}
        for arm in ("B", "C", "D"):
            flip = random.random() < 0.5
            x, y = (rec["arms"]["A"]["text"], rec["arms"][arm]["text"]) if not flip else (rec["arms"][arm]["text"], rec["arms"]["A"]["text"])
            j, jr = judge(desc, hist_txt, x, y)
            if j:
                a_is = "X" if not flip else "Y"; arm_is = "Y" if not flip else "X"
                better = j["better"]
                rec["judge"][arm] = {"flip": flip, "winner": ("tie" if better == "tie" else ("A" if better != arm_is else arm)),
                                     "reason": j["reason"], "arm_uses_history": j[f"{arm_is.lower()}_uses_history_well"],
                                     "ctrl_uses_history": j[f"{a_is.lower()}_uses_history_well"],
                                     "arm_tone_ok": j[f"{arm_is.lower()}_tone_ok"], "judge_cost": jr["cost"]}
        hist.append({"topic": topic, "correct": is_correct, "chosen_rationale": None if is_correct else chosen["rationale"]})
        rec["wall_s"] = time.perf_counter() - t_submit
        out.append(rec)
        print("step", step, topic, "correct" if is_correct else "missed", "prior same-topic misses", same_miss, file=sys.stderr)
    json.dump(out, open(f"{D}/seq_results.json", "w"), indent=1)


if __name__ == "__main__":
    main()
