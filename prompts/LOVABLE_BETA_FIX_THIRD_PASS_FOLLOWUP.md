# Lovable Patch - Third Pass Follow-Up

Three small follow-ups after the `TargetedChip` fix and A1/A2 verification.
Two are new; one is a status check on items already in
`LOVABLE_BETA_FIX_THIRD_PASS.md` that may or may not have shipped in the
same deploy.

UI-only. No backend grading changes.

---

## 1. Predicted-gain default should be "no selection," not `+0`

A1 verification reported `Your predicted gain: +0` even though the
Playwright bot did not click any prediction option. That's the cold
composer and coached revision conflating two distinct states:

- "Learner predicted no gain" (deliberate `+0` choice).
- "Learner made no prediction" (the control was skipped).

The earlier patch said default to **no selection**, not `0`. Today's
panel appears to fall through to `+0` when the user doesn't choose.

**Fix.** When no prediction is selected:

- The cold-submit control stores `null`, not `0`.
- The coached-revision control stores `null`, not `0`.
- The comparison panel renders `Your predicted gain: —` (em dash) or
  hides the line entirely. Do not render `+0`.
- The `Cramapple observed gain:` line still renders the actual delta
  (including `+0` when the revision earned nothing).

**Acceptance.** Run A1 without selecting a prediction. The comparison
panel must show `Your predicted gain: —` and `Cramapple observed gain:
+1` (or whatever the delta is). Run A1 again and explicitly select
`+1 point` before submitting. The panel must show `Your predicted gain:
+1`. The two states must look different on screen.

---

## 2. Add a multi-point criterion to the seeded corpus, then run A3

The A1/A2 verification only exercised 1-point criteria. The four-bucket
layout, the `Worth up to N more points.` annotation, and the discrete
prediction options (`+0 / +1 / +2 …`) need to be tested against a
criterion worth more than 1 point.

**Fix.** Either pick an existing FRQ and edit one criterion to be worth
2 points, or add a new FRQ to the corpus that includes a 2-point
criterion. Document which one you changed/added so it stays stable
across future deploys.

**Acceptance — A3 multi-point criterion.**

Cold-submit a fresh attempt against the multi-point criterion's FRQ.
Earn 0 of N on that criterion in the original submission. Click
`Fix this part` on that criterion.

In the coached-revision workspace:

- The annotation chip on the targeted criterion reads
  `Worth up to N more points.` where N is the missing-point count
  (`2` for a 2-point criterion with 0 earned originally).
- The self-prediction control shows discrete options `+0 / +1 / +2 …`
  up to N. No option above N is rendered.

Submit a revision that earns the full criterion. The comparison panel
must render:

- `Δ +N`
- `Cramapple observed gain: +N`
- The targeted criterion in the `GAINED` bucket showing `0 → N / N`.
- The rest of the buckets behave as in A1.

Then run a second pass where the revision only partially earns the
criterion (1 of 2). The criterion must appear in the `GAINED` bucket
showing `0 → 1 / 2`, with `Δ +1` and `Cramapple observed gain: +1`.

If the seeded grader cannot return partial credit on a multi-point
criterion, note that as a constraint and the test is satisfied by the
full-earn case alone.

---

## 3. Status check on the remaining Section 2 and Section 3 items

The third-pass patch (`LOVABLE_BETA_FIX_THIRD_PASS.md`) included four
items beyond the P0 fix. Please confirm whether each shipped in the
same deploy and, if so, point at the acceptance evidence. If not,
queue them.

- **F1.** Live composer rewrites `Missing:` to be abstract (matching
  the result-state preview's `Missing:` / `Try:` pattern) and adds a
  `Try:` line on every missed criterion card. Acceptance: open
  `/beta/attempt/8da14ae2-…` (Cell signaling 1/4) and every missed
  criterion card shows both `Missing:` (no full-sentence answer) and
  `Try:`.
- **S1.** `/beta/preview/capture` state selector renders a visually
  distinct fixture per state (`QR ready`, `QR expired`, `Permission
  explanation`, `Framing`, `Photo review`, `Looks ready`, `Retake
  recommended`, `Cannot determine`, `Submitted`, `Accessible
  alternative`). Acceptance: each state shows a different
  Desktop/Mobile mock, not just a different caption.
- **S2.** Resume row showing `Enzyme kinetics and temperature — 3 / 3`
  either backfilled to the canonical 4-point rubric or filtered from
  the list. Acceptance: no row on `/beta/resume` shows a non-4-point
  total for an FRQ.
- **S3.** Coached-vs-independent vocabulary aligned between
  `/beta/preview/result/coached_vs_independent` and the live
  attempt-page comparison panel. Acceptance: both surfaces use the
  same bucket / source labels.
- **S4.** React error #418 (hydration mismatch) investigated.
  Acceptance: console on every beta route shows no React error #418.

If any are unshipped, please apply the fixes from
`LOVABLE_BETA_FIX_THIRD_PASS.md` Sections 2 and 3 verbatim. If any
shipped but the acceptance test fails, treat that as a regression in
this follow-up.

---

## Reference Specs

- `docs/product/STUDENT_PRACTICE_AND_GRADING_DESIGN.md` (UX-006)
  §§6.1, 6.2, 9
- `docs/product/HANDWRITTEN_GRAPH_CAPTURE_EXPERIENCE_DESIGN.md`
  (UX-008) §§7, 10
- Prior patch: `prompts/LOVABLE_BETA_FIX_THIRD_PASS.md`
