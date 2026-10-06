"""TASK-0065 check L: deterministic item-standard lint (no model).

usage: python3 lint.py items.json [out.json]      python3 lint.py --selftest
Reads the pilot shape or the batch shape (docs/research/open_hand_teaching_batch_2026_10_06/*.json).
Per-item habit lines are not checked: under APPROVAL-0123 they come from the topic's point brief.
An item fails L if any rule below fails. Model checks (C1-C6) still run on lint failures so the
pilot can compare, but a lint failure alone blocks publish.
"""
import json, re, sys

EMOJI = re.compile("[\U0001F000-\U0001FAFF☀-➿️]")
# Only a reference to a visual the student cannot see; a table or graph given in words is fine.
FIGURE = re.compile(r"\b(shown (?:above|below)|(?:the|this) (?:figure|graph|diagram|image|picture)(?: shown)? (?:above|below)|(?:refer to|in|from|using) the (?:figure|image|picture)|see (?:the )?(?:figure|graph|diagram))\b", re.I)
CALC = re.compile(r"\bcalculator\b", re.I)
GENERIC_CORRECT = re.compile(r"^\s*(credited\.?|correct\.?|this is (the )?correct( answer)?\.?)\s*$", re.I)

def normalize(it):
    if "keyed_label" in it: return it
    correct = [c["choice_key"] for c in it["choices"] if c.get("is_correct")]
    return {"key": f'{it["subject_key"]}:{it["topic_code"]}', "stem": it["stem"],
            "choices": [{"label": c["choice_key"], "text": c["choice_text"]} for c in it["choices"]],
            "keyed_label": correct[0] if len(correct) == 1 else None, "n_correct": len(correct),
            "rationales": {c["choice_key"]: c.get("rationale") or "" for c in it["choices"]}}

def lint(it):
    it = normalize(it)
    f = []
    if it.get("n_correct", 1) != 1: f.append(f'{it["n_correct"]} choices marked correct, need exactly 1')
    ch = it.get("choices", [])
    labels = [c["label"] for c in ch]
    if labels != ["A", "B", "C", "D"]: f.append(f"choices must be exactly A-D, got {labels}")
    if it.get("keyed_label") not in labels: f.append("keyed_label is not one of the choices")
    rat = it.get("rationales", {})
    if set(rat) != set(labels): f.append("a rationale is missing or extra")
    stem = it.get("stem", "")
    # Choices repeated in the stem: an inline A-D list, or any choice text (>= 12 chars) verbatim.
    if re.search(r"(^|\s)\(?A[.)]\s.*(^|\s)\(?B[.)]\s", stem, re.S): f.append("stem carries an inline A/B list")
    for c in ch:
        if len(c["text"]) >= 12 and c["text"].strip().rstrip(".").lower() in stem.lower(): f.append(f"stem repeats choice {c['label']}")
    if len({c['text'].strip().lower() for c in ch}) < len(ch): f.append("duplicate choice text")
    for l, r in rat.items():
        r = r or ""
        if len(r.strip()) < 25: f.append(f"rationale {l} under 25 chars")
        if GENERIC_CORRECT.match(r): f.append(f"rationale {l} is a bare verdict")
        if l != it.get("keyed_label") and not re.search(r"\b(Fix|Next time):", r): f.append(f"distractor {l} has no 'Fix:'/'Next time:' line")
    if "credited" in (rat.get(it.get("keyed_label"), "") or "").lower(): f.append("keyed rationale says 'Credited'")
    text = " ".join([stem] + [c["text"] for c in ch] + list(rat.values()))
    if EMOJI.search(text): f.append("emoji present")
    if "!=" in text: f.append("uses '!=' instead of the symbol \u2260")
    if "!" in text.replace("!=", ""): f.append("exclamation mark present")
    if CALC.search(text): f.append("calculator reference")
    if FIGURE.search(stem) and not it.get("asset"): f.append("stem refers to a figure/table with no asset")
    return f

def selftest():
    good = json.load(open(__file__.rsplit("/", 1)[0] + "/items.json"))[0] if "/" in __file__ else json.load(open("items.json"))[0]
    assert lint(good) == [], lint(good)
    import copy
    cases = {
      "inline list": lambda x: x.__setitem__("stem", x["stem"] + " A. one B. two"),
      "repeat choice": lambda x: x.__setitem__("stem", x["stem"] + " " + x["choices"][1]["text"]),
      "credited": lambda x: x["rationales"].__setitem__(x["keyed_label"], "Credited."),
      "no fix": lambda x: x["rationales"].__setitem__("B", "This is wrong because covalent bonds are not broken here."),
      "emoji": lambda x: x["rationales"].__setitem__("B", x["rationales"]["B"] + " \U0001F600"),
      "bang": lambda x: x.__setitem__("stem", x["stem"] + "!"),
      "figure": lambda x: x.__setitem__("stem", "Using the graph shown above, " + x["stem"]),
      "not-equal": lambda x: x.__setitem__("stem", x["stem"] + " for x != 4"),
      "three choices": lambda x: x.__setitem__("choices", x["choices"][:3]),
    }
    for name, mut in cases.items():
        y = copy.deepcopy(good); mut(y)
        assert lint(y), f"selftest: {name} not caught"
    print(f"selftest ok: clean item passes, {len(cases)} planted defects caught")

if __name__ == "__main__":
    if sys.argv[1:] == ["--selftest"]: selftest(); sys.exit()
    items = json.load(open(sys.argv[1]))
    res = {normalize(it)["key"]: lint(it) for it in items}
    for k, v in res.items(): print(f"{k:14} {'PASS' if not v else 'FAIL: ' + '; '.join(v)}")
    if len(sys.argv) > 2: json.dump(res, open(sys.argv[2], "w"), indent=1)
