#!/usr/bin/env python3
"""
Score a returned reader worksheet against the held-back gold key and report the
DECISION-0045 certification result.

Usage:
  python3 score_reader_worksheet.py <subject_dir>
    e.g. python3 score_reader_worksheet.py biology
  (expects <subject_dir>/packet/reader_worksheet.csv filled in and
   <subject_dir>/<subject>_scoring_key.hidden.json present)

Certification is of the GOLD answer key: the qualified reader's cold judgment is
treated as truth for the sampled photos. The headline number is the gold's
FALSE-ACCEPT rate — how often gold credits ('earned') an element the reader judges
absent — with a 95% upper confidence bound. Gate (DECISION-0045):
  <=5% upper bound  -> CERTIFIES
  5-15%             -> diagnose and re-pilot
  >15%              -> rejects

Self-test: `python3 score_reader_worksheet.py <subject> --selftest` fills the
worksheet FROM the gold key (perfect reader) to validate the pipeline — expect
0 disagreements and a small non-zero upper bound (the rule-of-three ceiling).
"""
import json, os, csv, sys, math

HERE = os.path.dirname(__file__)
MARK_TO_STATUS = {"present": "earned", "absent": "not_earned"}


def wilson_upper(k, n, z=1.96):
    """Wilson score interval upper bound for a binomial proportion (dependency-free)."""
    if n == 0:
        return None
    p = k / n
    denom = 1 + z * z / n
    center = p + z * z / (2 * n)
    margin = z * math.sqrt(p * (1 - p) / n + z * z / (4 * n * n))
    return min(1.0, (center + margin) / denom)


def clopper_pearson_upper(k, n, alpha=0.05):
    """Exact (Clopper-Pearson) upper bound if scipy is available; else Wilson."""
    if n == 0:
        return None
    try:
        from scipy.stats import beta
        if k == n:
            return 1.0
        return float(beta.ppf(1 - alpha, k + 1, n - k))
    except Exception:
        return wilson_upper(k, n)


def load_reader(path, selftest_key=None):
    marks = {}  # (photo_id, criterion_id) -> status
    with open(path) as f:
        for row in csv.DictReader(f):
            pid, cid = row["photo_id"], row["criterion_id"]
            if selftest_key is not None:
                g = selftest_key[pid]["gold_criterion_statuses"].get(cid)
                marks[(pid, cid)] = g
                continue
            raw = (row.get("reader_mark_present_or_absent") or "").strip().lower()
            if raw in MARK_TO_STATUS:
                marks[(pid, cid)] = MARK_TO_STATUS[raw]
    return marks


def main():
    if len(sys.argv) < 2:
        print(__doc__); sys.exit(1)
    subject = sys.argv[1].rstrip("/")
    selftest = "--selftest" in sys.argv
    subj_dir = os.path.join(HERE, subject)
    key = json.load(open(os.path.join(subj_dir, f"{subject}_scoring_key.hidden.json")))
    ws = os.path.join(subj_dir, "packet", "reader_worksheet.csv")
    reader = load_reader(ws, selftest_key=key if selftest else None)

    scored = 0
    gold_earned = gold_false_accept = 0     # gold=earned; reader says absent -> gold over-credited
    gold_notearned = gold_false_reject = 0  # gold=not_earned; reader says present -> gold under-credited
    agree = 0
    unfilled = 0

    for pid, truth in key.items():
        for cid, g in truth["gold_criterion_statuses"].items():
            r = reader.get((pid, cid))
            if r is None:
                unfilled += 1
                continue
            scored += 1
            if r == g:
                agree += 1
            if g == "earned":
                gold_earned += 1
                if r == "not_earned":
                    gold_false_accept += 1
            elif g == "not_earned":
                gold_notearned += 1
                if r == "earned":
                    gold_false_reject += 1

    far = gold_false_accept / gold_earned if gold_earned else None
    far_ub = clopper_pearson_upper(gold_false_accept, gold_earned) if gold_earned else None
    frr = gold_false_reject / gold_notearned if gold_notearned else None

    def gate(ub):
        if ub is None:
            return "no data"
        if ub <= 0.05:
            return "CERTIFIES (<=5% upper bound)"
        if ub <= 0.15:
            return "DIAGNOSE-AND-REPILOT (5-15%)"
        return "REJECTS (>15%)"

    print(f"subject: {subject}{'  [SELFTEST: reader==gold]' if selftest else ''}")
    print(f"criterion judgments scored: {scored}  (unfilled/blank: {unfilled})")
    print(f"overall reader-vs-gold agreement: {agree}/{scored} = {agree/scored*100:.1f}%" if scored else "nothing scored")
    print()
    print(f"GOLD FALSE-ACCEPT (gold=earned, reader=absent): {gold_false_accept}/{gold_earned}"
          f" = {far*100:.1f}%" if gold_earned else "no gold-earned cases")
    print(f"  95% upper bound: {far_ub*100:.1f}%   -> {gate(far_ub)}" if far_ub is not None else "")
    print(f"gold false-reject (gold=not_earned, reader=present): {gold_false_reject}/{gold_notearned}"
          f" = {frr*100:.1f}%" if gold_notearned else "")
    if unfilled and not selftest:
        print(f"\nNOTE: {unfilled} criterion rows are still blank — fill the worksheet completely before certifying.")


if __name__ == "__main__":
    main()
