"""Shared helpers for the Unit 1 variant files (variants_*.py) and their verification.

A variant is a NEW item (its own content_key) that teaches the same skill and targets the same misconceptions as
an original in items.py, but with different numbers AND a different context or surface form.

Every variant carries `calc`: a zero-argument function that recomputes the correct choice's text from the
problem's own expression using sympy. The harness asserts calc() == the keyed correct text exactly. It never
reads the keyed text to decide what is correct. Distractors may carry `wrong_calc`, a function that recomputes the
value the misconception would produce; when given, it must equal that distractor's text.
"""
import re
from sympy import Rational, oo, S, Integer, Float, nan, zoo

FRQ_TOTAL_POINTS = 4


def fmt(v):
    """Canonical text for a sympy value: '5/2', '-3', 'infinity', '-infinity', '0'."""
    v = S(v)
    if v == oo:
        return "infinity"
    if v == -oo:
        return "-infinity"
    if v in (nan, zoo):
        raise ValueError("value is nan/zoo")
    if isinstance(v, Rational):
        return str(v)  # sympy prints Rational(5,2) as 5/2, Integer as 5
    return str(v)


def M(vid, of, diff, title, stem, correct, wrong, calc, wrong_calcs=None, change=""):
    """Define an MCQ variant.

    vid     'NNN-vK' where NNN is the original's id and K in 1..3
    of      original id, e.g. '018'
    correct (text, rationale)
    wrong   [(text, rationale)] * 3
    calc    () -> str, must equal correct[0]
    wrong_calcs  optional list of 3 items, each None or () -> str equal to that distractor's text
    change  one line: what changed in numbers and in context
    """
    return dict(kind="mcq", id=vid, of=of, diff=diff, title=title, stem=stem, correct=correct,
                wrong=wrong, calc=calc, wrong_calcs=wrong_calcs or [None, None, None], change=change)


def F(vid, of, diff, title, stimulus, stem, criteria, checks, archetype="mathematical_routines", change=""):
    """Define an FRQ variant.

    criteria  list of (criterion_key, learner_facing_text, points, evidence_requirements, minimum_fix, accepted_variants)
    checks    list of (description, () -> bool): every numeric claim in the rubric, recomputed with sympy
    """
    return dict(kind="frq", id=vid, of=of, diff=diff, title=title, stimulus=stimulus, stem=stem,
                criteria=criteria, checks=checks, archetype=archetype, change=change)


NON_ASCII = re.compile(r"[^\x00-\x7f]")


def check_variants(variants, originals_mcq, originals_frq):
    """Return a list of failure strings. Empty list means every variant passed."""
    fails = []
    seen = set()
    per_original = {}
    orig_stems = {m["id"]: m["stem"] for m in originals_mcq}
    orig_stems.update({("F" + f["id"]): f["stem"] for f in originals_frq})
    for v in variants:
        vid = v["id"]
        if (v["kind"], vid) in seen:
            fails.append(f"{v['kind']} {vid}: duplicate variant id")
        seen.add((v["kind"], vid))
        if not re.fullmatch(r"\d{3}-v[123]", vid):
            fails.append(f"{vid}: id must look like 001-v1")
        per_original.setdefault((v["kind"], v["of"]), []).append(vid)
        if v["kind"] == "mcq":
            fails += _check_mcq(v, orig_stems)
        else:
            fails += _check_frq(v, orig_stems)
    return fails, per_original


def _check_mcq(v, orig_stems):
    f = []
    vid = v["id"]
    c_text, c_rat = v["correct"]
    ws = v["wrong"]
    if len(ws) != 3:
        f.append(f"{vid}: needs exactly 3 distractors")
        return f
    texts = [c_text] + [w[0] for w in ws]
    if len({t.strip().lower() for t in texts}) != 4:
        f.append(f"{vid}: duplicate choice text {texts}")
    if any(not t.strip() for t in texts):
        f.append(f"{vid}: blank choice")
    if not c_rat.strip() or any(len(w[1]) <= 40 for w in ws):
        f.append(f"{vid}: thin or missing rationale")
    if len(v["stem"]) > 900 or not v["stem"].strip():
        f.append(f"{vid}: bad stem length")
    if NON_ASCII.search(v["stem"] + "".join(texts) + c_rat + "".join(w[1] for w in ws)):
        f.append(f"{vid}: non-ASCII characters (use ASCII math)")
    if v["stem"].strip() == orig_stems.get(v["of"], "").strip():
        f.append(f"{vid}: stem identical to original")
    try:
        got = v["calc"]()
    except Exception as e:  # noqa: BLE001
        f.append(f"{vid}: calc raised {e!r}")
        return f
    if got != c_text:
        f.append(f"{vid}: calc() = {got!r} but keyed correct text = {c_text!r}")
    for i, (w, wc) in enumerate(zip(ws, v["wrong_calcs"])):
        if wc is None:
            continue
        try:
            wg = wc()
        except Exception as e:  # noqa: BLE001
            f.append(f"{vid}: wrong_calc[{i}] raised {e!r}")
            continue
        if wg != w[0]:
            f.append(f"{vid}: wrong_calc[{i}] = {wg!r} but distractor text = {w[0]!r}")
        if wg == got:
            f.append(f"{vid}: wrong_calc[{i}] equals the correct answer")
    return f


def _check_frq(v, orig_stems):
    f = []
    vid = v["id"]
    crit = v["criteria"]
    if sum(c[2] for c in crit) != FRQ_TOTAL_POINTS:
        f.append(f"{vid}: criteria points sum to {sum(c[2] for c in crit)}, need {FRQ_TOTAL_POINTS}")
    if len({c[0] for c in crit}) != len(crit):
        f.append(f"{vid}: duplicate criterion keys")
    if any(not (c[3].strip() and c[4].strip()) for c in crit):
        f.append(f"{vid}: blank evidence or minimum_fix")
    if NON_ASCII.search(v["stem"] + v["stimulus"] + "".join(c[1] + c[3] + c[4] for c in crit)):
        f.append(f"{vid}: non-ASCII characters")
    if not v["checks"]:
        f.append(f"{vid}: no numeric checks supplied")
    for desc, fn in v["checks"]:
        try:
            if not fn():
                f.append(f"{vid}: check failed: {desc}")
        except Exception as e:  # noqa: BLE001
            f.append(f"{vid}: check raised {e!r}: {desc}")
    return f
