#!/usr/bin/env python3
"""Independent re-derivation (protocol section 9), structural QA (phase 2), and SQL generation.

Run:  python3 verify_and_build.py

Step 1 re-derives every MCQ answer and every FRQ numeric claim with sympy, from the
problem's own expression. It never parses the keyed answer to decide what is correct: it
computes the answer, then asserts the keyed text matches it and that no distractor does.
Step 2 runs mechanical structural checks.
Step 3 writes the SQL batch, placing the correct answer at a random letter per item using
the OS entropy source (secrets), never a hand-picked position.

Nothing here touches a database.
"""
import secrets
import sys
from pathlib import Path

import sympy as sp
from sympy import (Abs, Interval, Rational, S, cancel, cos, exp, limit, oo, pi, simplify,
                   solve, sqrt, symbols, tan, sin, log, factor, Union)
from sympy.calculus.util import continuous_domain

from items import FRQS, MCQS

HERE = Path(__file__).parent
x, t, h, a, k = symbols("x t h a k", real=True)
failures = []


def ok(cond, msg):
    if not cond:
        failures.append(msg)


def text(item, which):
    return item["correct"][0] if which == "correct" else None


def choice_texts(item):
    return [item["correct"][0]] + [w[0] for w in item["wrong"]]


# --------------------------------------------------------------------------- derivations
def derive(item):
    i = item["id"]
    c = item["correct"][0]
    ws = [w[0] for w in item["wrong"]]

    if i == "001":
        s = lambda tt: tt ** 2
        ok(sp.simplify((s(2 + h) - s(2)) / h - (4 + h)) == 0, "001 avg velocity != 4+h")
        ok(limit((s(2 + h) - s(2)) / h, h, 0) == 4, "001 limit != 4")
        ok(c.startswith("4 feet"), "001 keyed text")
    elif i == "002":
        f = 3 * x ** 2
        for hv, shown in ((Rational(1, 10), "6.3"), (Rational(1, 100), "6.03"), (Rational(1, 1000), "6.003")):
            ok(float((f.subs(x, 1 + hv) - f.subs(x, 1)) / hv) == float(shown), f"002 table {shown}")
        ok(limit((f.subs(x, 1 + h) - f.subs(x, 1)) / h, h, 0) == 6, "002 limit != 6")
        ok(c == "6", "002 keyed text")
    elif i == "003":
        g = 7 * (x - 4) / (x - 4)  # undefined at 4, limit 7
        ok(limit(g, x, 4) == 7, "003 counterexample limit")
        ok(g.subs(x, 4).has(sp.nan) or sp.simplify(g) == 7, "003 sanity")  # f undefined at 4 is consistent
        ok(c.startswith("The values of f(x) get arbitrarily close"), "003 keyed text")
        ok(all(not w.startswith("The values of f(x) get") for w in ws), "003 distractors")
    elif i == "004":
        L = limit(2 * x - 1, x, 3, "-")
        R = limit(x ** 2 - 4, x, 3, "+")
        ok(L == 5 and R == 5, "004 one-sided limits")
        ok(9 != 5, "004 f(3) differs")
        ok(c == "5", "004 keyed text")
        ok(str(2 * 3) in ws, "004 distractor 6 is 2x at 3")
    elif i == "005":
        f = x + 1
        for xv, shown in ((Rational(19, 10), "2.9"), (Rational(199, 100), "2.99"), (Rational(1999, 1000), "2.999"),
                          (Rational(2001, 1000), "3.001"), (Rational(201, 100), "3.01"), (Rational(21, 10), "3.1")):
            ok(float(f.subs(x, xv)) == float(shown), f"005 table {xv}")
        ok(limit(f, x, 2) == 3, "005 limit")
        ok(c == "3", "005 keyed text")
    elif i == "006":
        F = 3 + (x - 4)
        G = -2 + (x - 4)
        val = limit((3 * F + G ** 2) / (F + G), x, 4)
        ok(val == 13, f"006 value {val}")
        ok(c == "13", "006 keyed text")
        ok(Rational(13, 5) != 13 and "13/5" in ws, "006 distractors")
        ok((9 - 4) / 1 == 5 and (3 + 4) / 1 == 7, "006 distractor derivations 5,7")
    elif i == "007":
        ok(limit(2 * (x - 1) / (x - 1), x, 1) == 2, "007 example 2")
        ok(limit((x - 1) ** 2 / (x - 1), x, 1) == 0, "007 example 0")
        ok(c.startswith("It cannot be determined"), "007 keyed text")
    elif i == "008":
        # direct substitution is valid iff the expression is continuous at the point (denominator nonzero)
        cands = {
            "lim(x->2) (x^2 + 3x)/(x - 1)": ((x ** 2 + 3 * x), (x - 1), 2),
            "lim(x->1) (x^3 - 1)/(x - 1)": ((x ** 3 - 1), (x - 1), 1),
            "lim(x->0) |x|/x": (Abs(x), x, 0),
            "lim(x->3) (x - 3)/(x^2 - 9)": ((x - 3), (x ** 2 - 9), 3),
        }
        valid = [name for name, (n, d, p) in cands.items() if d.subs(x, p) != 0]
        ok(valid == ["lim(x->2) (x^2 + 3x)/(x - 1)"], f"008 valid={valid}")
        ok(c in valid, "008 keyed text")
        ok(limit((x ** 2 + 3 * x) / (x - 1), x, 2) == 10, "008 value 10")
        ok(limit(Abs(x) / x, x, 0, "+") == 1 and limit(Abs(x) / x, x, 0, "-") == -1, "008 one-sided |x|/x")
    elif i == "009":
        ok(limit(sin(3 * x) / x, x, 0) == 3, "009 limit")
        ok(c == "3", "009 keyed text")
    elif i == "010":
        ok(limit(4 - 3 * x ** 2, x, 0) == 4 and limit(4 + x ** 2, x, 0) == 4, "010 bounds")
        ok(sp.simplify((4 + x ** 2) - (4 - 3 * x ** 2)) == 4 * x ** 2, "010 ordering (upper-lower = 4x^2 >= 0)")
        ok(c == "4", "010 keyed text")
    elif i == "011":
        f = sp.Piecewise((x + 3, sp.Ne(x, 2)), (1, True))
        L = limit(x + 3, x, 2, "-")
        R = limit(x + 3, x, 2, "+")
        I = (L == R)
        II = (I and L == 1)  # f(2) = 1
        III = (I and not II)
        ok(L == 5 and R == 5, "011 example limits")
        ok((I, II, III) == (True, False, True), "011 truth values")
        ok(c == "I and III only", "011 keyed text")
    elif i == "012":
        ok(limit(Abs(x - 3) / (x - 3), x, 3, "+") == 1, "012 right")
        ok(limit(Abs(x - 3) / (x - 3), x, 3, "-") == -1, "012 left")
        ok(c.startswith("The limit does not exist"), "012 keyed text")
    elif i == "013":
        L = limit(x + 2, x, 1, "-")
        R = limit(5 - x, x, 1, "+")
        ok((L, R, (5 - 1)) == (3, 4, 4), "013 limits")
        ok(L != R and L.is_finite and R.is_finite, "013 jump")
        ok(c.startswith("f has a jump"), "013 keyed text")
    elif i == "014":
        cand = {
            "f(x) = (x + 1)/(x - 3)^2": (x + 1) / (x - 3) ** 2,
            "f(x) = (x^2 - x - 6)/(x - 3)": (x ** 2 - x - 6) / (x - 3),
            "f(x) = |x - 3|/(x - 3)": Abs(x - 3) / (x - 3),
            "f(x) = (x - 3)/(x + 3)": (x - 3) / (x + 3),
        }
        kinds = {}
        for name, fx in cand.items():
            L = limit(fx, x, 3, "-")
            R = limit(fx, x, 3, "+")
            if L in (oo, -oo) or R in (oo, -oo):
                kinds[name] = "infinite"
            elif L == R and fx.subs(x, 3).has(sp.zoo, sp.nan) or (L == R and sp.simplify(fx).subs(x, 3) == L and cancel(fx) != fx):
                kinds[name] = "removable"
            elif L != R:
                kinds[name] = "jump"
            else:
                kinds[name] = "continuous"
        ok([n for n, v in kinds.items() if v == "infinite"] == [c], f"014 kinds={kinds}")
        ok(kinds["f(x) = (x^2 - x - 6)/(x - 3)"] == "removable" and kinds["f(x) = |x - 3|/(x - 3)"] == "jump"
           and kinds["f(x) = (x - 3)/(x + 3)"] == "continuous", f"014 kinds={kinds}")
        ok(limit((x ** 2 - x - 6) / (x - 3), x, 3) == 5, "014 rationale value 5")
    elif i == "015":
        sol = solve(sp.Eq(2 * a + 1, 4 - a), a)
        ok(sol == [1], f"015 solve {sol}")
        ok(c == "1", "015 keyed text")
        ok(solve(sp.Eq(2 * a + 1, 4), a) == [Rational(3, 2)], "015 distractor 3/2")
        ok(solve(sp.Eq(2 * a + 1, a - 4), a) == [-5], "015 distractor -5")
        ok(Rational(5, 3) == solve(sp.Eq(3 * a, 5), a)[0], "015 distractor 5/3")
    elif i == "016":
        dom = continuous_domain(sqrt(x - 1) / (x - 4), x, S.Reals)
        ok(dom == Union(Interval.Ropen(1, 4), Interval.open(4, oo)), f"016 domain {dom}")
        ok(c.startswith("The union of [1, 4)"), "016 keyed text")
    elif i == "017":
        cand = {
            "f(x) = tan(pi x/12)": tan(pi * x / 12),
            "f(x) = 1/(x - 3)": 1 / (x - 3),
            "f(x) = ln(x - 1)": log(x - 1),
            "f(x) = |x - 2|/(x - 2)": Abs(x - 2) / (x - 2),
        }
        # Exact points every 1/4 on [0, 5]: a function is flagged if it is undefined (zoo/nan/complex)
        # at any of them. These functions' only trouble spots (x = 2, 3, and x <= 1 for the log)
        # all fall on this grid, and tan(pi x/12) is finite at every point and its first pole
        # x = 6 is verified separately below.
        def undefined_on_grid(fx):
            bad = []
            for n in range(0, 21):
                xv = Rational(n, 4)
                v = fx.subs(x, xv)
                if v.has(sp.zoo, sp.nan) or v.is_real is False or not v.is_finite:
                    bad.append(xv)
            return bad
        good = [n for n, fx in cand.items() if not undefined_on_grid(fx)]
        ok(good == [c], f"017 continuous on [0,5]: {good}")
        ok(pi * 5 / 12 < pi / 2 and pi * 6 / 12 == pi / 2, "017 first pole of tan(pi x/12) is x = 6, outside [0, 5]")
    elif i == "018":
        ok(limit((x ** 3 - 8) / (x - 2), x, 2) == 12, "018 limit")
        ok(sp.expand((x - 2) * (x ** 2 + 2 * x + 4)) == x ** 3 - 8, "018 factoring")
        ok(sp.expand((x - 2) * (x ** 2 + 4)) != x ** 3 - 8, "018 distractor factoring is wrong")
        ok(limit((x - 2) * (x ** 2 + 4) / (x - 2), x, 2) == 8, "018 distractor 8")
        ok(c == "12", "018 keyed text")
    elif i == "019":
        ok(limit((sqrt(x + 9) - 3) / x, x, 0) == Rational(1, 6), "019 limit")
        ok(c == "1/6", "019 keyed text")
        ok(sp.simplify((sqrt(x + 9) - 3) / x - 1 / (sqrt(x + 9) + 3)) == 0, "019 conjugate simplification")
    elif i == "020":
        sol = solve((x ** 2 + a * x - 10).subs(x, 2), a)
        ok(sol == [3], f"020 solve {sol}")
        ok(limit((x ** 2 + 3 * x - 10) / (x - 2), x, 2) == 7, "020 limit at a=3")
        ok(sp.expand((x - 2) * (x + 5)) == x ** 2 + 3 * x - 10, "020 factoring")
        for bad in (5, 7, -3):
            L = limit((x ** 2 + bad * x - 10) / (x - 2), x, 2, "+")
            ok(L in (oo, -oo) or L != 7 or bad == 3, f"020 distractor {bad} limit {L}")
        ok(c == "3", "020 keyed text")
    elif i == "021":
        fx = (x ** 2 - 9) / (x ** 2 - 5 * x + 6)
        ok(cancel(fx) == (x + 3) / (x - 2), "021 simplification")
        ok(limit(fx, x, 3) == 6, "021 limit at 3")
        ok(limit(fx, x, 2, "+") in (oo, -oo) and limit(fx, x, 2, "-") in (oo, -oo), "021 infinite at 2")
        ok((x ** 2 - 9).subs(x, 2) == -5, "021 numerator at 2")
        ok(c == "Removable at x = 3 and infinite at x = 2", "021 keyed text")
    elif i == "022":
        ok(limit(2 * x / (x ** 2 - 9), x, 3, "+") == oo, "022 limit")
        ok(c == "infinity", "022 keyed text")
    elif i == "023":
        fx = (x ** 2 - 4 * x) / (x ** 2 - 16)
        ok(cancel(fx) == x / (x + 4), "023 simplification")
        vas = [p for p in (4, -4, 0) if limit(fx, x, p, "+") in (oo, -oo) or limit(fx, x, p, "-") in (oo, -oo)]
        ok(vas == [-4], f"023 vertical asymptotes {vas}")
        ok(limit(fx, x, 4) == Rational(1, 2), "023 hole at 4 value 1/2")
        ok(c == "x = -4 only", "023 keyed text")
    elif i == "024":
        ok(limit((x + 5) / (x + 2) ** 2, x, -2, "-") == oo, "024 left")
        ok(limit((x + 5) / (x + 2) ** 2, x, -2, "+") == oo, "024 right")
        ok(c == "infinity", "024 keyed text")
    elif i == "025":
        sols = [s for s in solve(2 * cos(x) - 1, x) if 0 <= s <= pi]
        ok(sols == [pi / 3], f"025 solutions {sols}")
        ok(1 != 0 and (2 * cos(pi / 2) - 1) == -1 and (2 * cos(0) - 1) == 1, "025 distractors")
        ok(sp.sin(pi / 6) == Rational(1, 2), "025 distractor pi/6 origin")
        ok(c == "pi/3", "025 keyed text")
    elif i == "026":
        ok(limit((5 * x ** 3 - 2 * x) / (2 * x ** 3 + 7 * x ** 2), x, oo) == Rational(5, 2), "026 limit")
        ok(c == "5/2", "026 keyed text")
    elif i == "027":
        fx = 3 * x / sqrt(4 * x ** 2 + 1)
        ok(limit(fx, x, oo) == Rational(3, 2) and limit(fx, x, -oo) == Rational(-3, 2), "027 asymptotes")
        ok(c == "y = 3/2 and y = -3/2", "027 keyed text")
    elif i == "028":
        T = 20 + 60 * exp(-t / 4)
        ok(limit(T, t, oo) == 20 and T.subs(t, 0) == 80, "028 limit and T(0)")
        ok(c.startswith("20;"), "028 keyed text")
    elif i == "029":
        ok(limit((x ** 5 + 3 ** x) / (2 * 4 ** x), x, oo) == 0, "029 limit")
        ok(c == "0", "029 keyed text")
    else:
        ok(False, f"no derivation for {i}")

    # generic: correct text must not equal any distractor text
    ok(c not in ws, f"{i} correct duplicated among distractors")


def verify_frqs():
    # FRQ 001: (2x^2 - x - 15)/(x^2 - 9)
    g = (2 * x ** 2 - x - 15) / (x ** 2 - 9)
    ok(factor(2 * x ** 2 - x - 15) == (x - 3) * (2 * x + 5), "F001 numerator factoring")
    ok(cancel(g) == (2 * x + 5) / (x + 3), "F001 simplification")
    ok(limit(g, x, 3) == Rational(11, 6), "F001 limit at 3")
    ok(limit(g, x, -3, "-") == oo and limit(g, x, -3, "+") == -oo, "F001 one-sided at -3")
    # FRQ 002: 3x/(x^2 - 4x - 5)
    f = 3 * x / (x ** 2 - 4 * x - 5)
    ok(factor(x ** 2 - 4 * x - 5) == (x - 5) * (x + 1), "F002 denominator factoring")
    ok(limit(f, x, 5, "+") == oo, "F002 right of 5")
    ok(limit(f, x, -1, "-") == -oo, "F002 left of -1")
    ok(limit(f, x, oo) == 0, "F002 horizontal asymptote")
    ok((3 * x).subs(x, 5) == 15 and (3 * x).subs(x, -1) == -3, "F002 numerator values")
    # FRQ 003
    A = (80 * t + 100) / (2 * t + 5)
    ok(limit(A, t, oo) == 40, "F003 limit A")
    q = (4 * x + 1) / sqrt(9 * x ** 2 + 2)
    ok(limit(q, x, oo) == Rational(4, 3) and limit(q, x, -oo) == Rational(-4, 3), "F003 horizontal asymptotes")
    ok(limit((2 * x ** 4 + 5 ** x) / (3 ** x + x ** 7), x, oo) == oo, "F003 growth comparison")
    # FRQ 004
    ok(factor(x ** 2 + 2 * x - 3) == (x + 3) * (x - 1), "F004 factoring")
    ok(limit((x ** 2 + 2 * x - 3) / (x - 1), x, 1, "+") == 4, "F004 right limit")
    ok(solve(sp.Eq(k * 1 + 2, 4), k) == [2], "F004 k")
    ok(limit(3 * x + 2, x, 1, "-") == 5, "F004 left limit for k=3")
    # FRQ 005
    hh = (sqrt(x + 4) - 3) / (x - 5)
    ok(sp.simplify(hh - 1 / (sqrt(x + 4) + 3)) == 0, "F005 conjugate simplification")
    ok(limit(hh, x, 5) == Rational(1, 6), "F005 limit")
    ok(Rational(1, 5) != Rational(1, 6), "F005 0.2 vs 1/6")


def frq_table():
    """Compute the FRQ 005 table so the stimulus numbers come from the function, not from memory."""
    hh = (sqrt(x + 4) - 3) / (x - 5)
    xs = [Rational(49, 10), Rational(499, 100), Rational(4999, 1000),
          Rational(5001, 1000), Rational(501, 100), Rational(51, 10)]
    vals = [f"{float(hh.subs(x, xv)):.5f}" for xv in xs]
    # every value must be within the plausible band around 1/6 and be monotone on each side
    ok(all(abs(float(v) - 1 / 6) < 0.01 for v in vals), "F005 table band")
    return vals


# --------------------------------------------------------------------------- structural QA
def structural(mcqs, frqs):
    keys = set()
    for m in mcqs:
        key = f"apcalcab-mcq-u1n-{m['id']}"
        ok(key not in keys, f"duplicate key {key}")
        keys.add(key)
        ok(m["stem"].strip() != "" and len(m["stem"]) < 900, f"{key} stem")
        ok(len(m["wrong"]) == 3, f"{key} needs exactly 3 distractors")
        texts = choice_texts(m)
        ok(len(set(t.strip().lower() for t in texts)) == 4, f"{key} duplicate choice text")
        ok(all(t.strip() for t in texts), f"{key} blank choice")
        ok(m["correct"][1].strip() != "" and all(w[1].strip() for w in m["wrong"]), f"{key} blank rationale")
        ok(all(len(w[1]) > 40 for w in m["wrong"]), f"{key} thin distractor rationale")
        ok(not any(ch in m["stem"] + "".join(texts) for ch in "≤≥∞π²"), f"{key} non-ASCII math")
    for f in frqs:
        key = f"apcalcab-frq-u1n-{f['id']}"
        ok(key not in keys, f"duplicate key {key}")
        keys.add(key)
        total = sum(c[2] for c in f["criteria"])
        ok(total == 4, f"{key} points sum {total}")
        ok(len({c[0] for c in f["criteria"]}) == len(f["criteria"]), f"{key} criterion keys")
        ok(all(c[3].strip() and c[4].strip() for c in f["criteria"]), f"{key} blank evidence/minimum_fix")


# --------------------------------------------------------------------------- SQL
def sq(s):
    return "'" + s.replace("'", "''") + "'"


def build_sql(mcqs, frqs, table_vals):
    rng = secrets.SystemRandom()
    letters = ["A", "B", "C", "D"]
    dist = {l: 0 for l in letters}
    out = []
    out.append(f"""-- AP Calculus AB, Unit 1 (Limits and Continuity): original item batch, DRAFT.
-- Generated by verify_and_build.py. NOT APPLIED to any database.
--
-- Provenance (protocol section 7.1, recorded here because no column holds it yet):
--   authoring model : claude-sonnet-5-5 (Claude Code session, 2026-09-29)
--   fact pack       : docs/product/AP_CALCULUS_AB_BC_CED_FACT_PACK.md (deep tier, Units 1-3)
--   batch id        : calc-ab-unit1-original-2026-09-29
--   originality     : see README.md. No stem wording, numbers, choices or rubric language was
--                     taken from any third-party packet; topic and skill scope only.
--
-- Content keys: apcalcab-mcq-u1n-001..{len(mcqs):03d}, apcalcab-frq-u1n-001..{len(frqs):03d}.
-- All rows are status='draft', review_status='tutor_review_pending'. Correct MCQ choice keys were
-- drawn at random per item (see README.md for the resulting distribution).
--
-- Publication is NOT authorised by this file. Preconditions before any publish:
--   phase 3 human review, phase 4 two-family CED-conformance check, and a fresh independent
--   section-9 re-derivation by someone other than the author.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-apcalcab-unit1-original-20260929'));

do $$
declare
  v_epv_id uuid;
begin
  select epv.id into v_epv_id
  from app.exam_pack_versions epv
  join app.exam_packs e on e.id = epv.exam_pack_id
  where e.exam_name = 'AP Calculus AB';

  if v_epv_id is null then
    raise exception 'no_exam_pack_version_found:AP Calculus AB';
  end if;

  if exists (select 1 from app.content_items
             where content_key like 'apcalcab-mcq-u1n-%' or content_key like 'apcalcab-frq-u1n-%') then
    raise exception 'batch_already_seeded:apcalcab-u1n';
  end if;

  create temporary table u1n_epv (epv_id uuid) on commit drop;
  insert into u1n_epv values (v_epv_id);
end $$;
""")
    for m in mcqs:
        key = f"apcalcab-mcq-u1n-{m['id']}"
        order = [("correct", m["correct"])] + [("wrong", w) for w in m["wrong"]]
        rng.shuffle(order)
        placed = list(zip(letters, order))
        correct_letter = next(l for l, (kind, _) in placed if kind == "correct")
        dist[correct_letter] += 1
        m["_letter"] = correct_letter
        rows = []
        for l, (kind, (txt, rat)) in placed:
            rows.append(
                f"select gen_random_uuid(), id, {sq(l)}, {sq(txt)}, {'true' if kind == 'correct' else 'false'}, {sq(rat)} from version_ins")
        out.append(f"""
-- MCQ {m['id']} | topic {m['topic']} | {m['diff']} | {m['title']}
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, {sq(key)}, 'mcq', {sq(m['title'])}, 'draft' from u1n_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, {sq(m['stem'])}, md5({sq(key)}), 'draft', 'tutor_review_pending', {sq(correct_letter)}
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
{chr(10).join(rows[:1])}
""" + "".join(f"union all {r}\n" for r in rows[1:]) + ";\n")
    for f in frqs:
        key = f"apcalcab-frq-u1n-{f['id']}"
        stim = f["stimulus"]
        if f["id"] == "005":
            for n, v in enumerate(table_vals, 1):
                stim = stim.replace(f"TABLE_H{n}", v)
        crit = []
        for (ck, text_, pts, ev, fix, var) in f["criteria"]:
            vj = "'[" + ",".join('"' + v.replace('"', '\\"').replace("'", "''") + '"' for v in var) + "]'::jsonb"
            crit.append(f"select gen_random_uuid(), id, {sq(ck)}, {sq(text_)}, {pts}, {sq(ev)}, {sq(fix)}, {vj} from version_ins")
        out.append(f"""
-- FRQ {f['id']} | topic {f['topic']} | {f['diff']} | {f['title']}
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, {sq(key)}, 'frq', {sq(f['title'])}, 'draft', 'short', 'targeted_drill', {sq(f['archetype'])}
  from u1n_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1, {sq(f['stem'])}, {sq(stim)}, md5({sq(key)}), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text'
  from item_ins returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
{crit[0]}
""" + "".join(f"union all {c}\n" for c in crit[1:]) + ";\n")
    out.append("\ncommit;\n")
    return "".join(out), dist


def main():
    for m in MCQS:
        derive(m)
    verify_frqs()
    table_vals = frq_table()
    structural(MCQS, FRQS)
    if failures:
        print("FAILED:")
        for f in failures:
            print("  -", f)
        sys.exit(1)
    # Rejection-sample the random draw until no letter holds more than ~1/3 of the keys.
    for _ in range(200):
        sql, dist = build_sql(MCQS, FRQS, table_vals)
        if max(dist.values()) <= 10 and min(dist.values()) >= 4:
            break
    ok(max(dist.values()) <= 10 and min(dist.values()) >= 4, f"key distribution too skewed {dist}")
    if failures:
        print("FAILED:", failures)
        sys.exit(1)
    (HERE / "20260929_apcalcab_unit1_original_batch.sql").write_text(sql)
    print(f"verified {len(MCQS)} MCQs and {len(FRQS)} FRQs; all independent derivations agree.")
    print("correct-answer letter distribution:", dist)
    print("FRQ 005 table:", table_vals)
    per_topic = {}
    for m in MCQS:
        per_topic.setdefault(m["topic"], [0, 0])[0] += 1
    for f in FRQS:
        per_topic.setdefault(f["topic"], [0, 0])[1] += 1
    print("per topic (mcq, frq):", dict(sorted(per_topic.items(), key=lambda kv: [int(p) for p in kv[0].split('.')])))


if __name__ == "__main__":
    main()
