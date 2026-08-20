# Reader-Certification Packets — DECISION-0045 FAR audit (2026-08-20)

**What this is.** The concrete, reader-ready packets for the human false-accept-rate certification
that Stage D3 is blocked on — the step no AI agent can do (see `../ABSTENTION_CALIBRATION.md`,
`../D3_D4_D5_STATUS.md`). Prior to this, only a *prose proposal* for the sample existed (in the two
`decision_0045_verification_2026_08_19/README.md` files); the actual packets — specific photos
pulled out, rubric attached, gold hidden, blank scoring sheet — had never been assembled. This
directory builds them.

**Why certification is needed** (short version): the benchmark gold is `ai_provisional` — AI-written.
Measuring an AI grader against an AI-written key is circular. A qualified human must cold-verify a
sample and bound the gold's false-accept rate (≤5% upper-95%) before any accuracy number here
becomes release-grade instead of R&D-tier.

## Layout

```
build_reader_certification_packet.py   deterministic builder (source of truth)
score_reader_worksheet.py              scorer: reader worksheet -> FAR + 95% upper bound + gate
biology/ , statistics/
  selection_manifest.json              how the sample was drawn (auditable; no gold)
  <subject>_scoring_key.hidden.json     the ANSWER KEY (gold subset) — NOT given to the reader
  packet/                              << git-ignored, regenerable; this is what the reader gets >>
    images/<OPAQUE_ID>.<ext>           selected photos, renamed to opaque IDs (real names leak archetype)
    index.html                         viewer: each photo + its question + rubric checkboxes
    reader_worksheet.csv               fill-in grid: mark each criterion present/absent
    READER_INSTRUCTIONS.md
```

`packet/` is **git-ignored** — 281 MB of images that are copies of the (also-git-ignored) sample
store. It is fully **regenerated deterministically** by the builder wherever the samples exist:

```bash
python3 build_reader_certification_packet.py
```

## The two packets

| Subject | Photos | Selection | Criterion judgments |
|---|---:|---|---:|
| Biology | 100 (of 200) | Archetype quotas proportional to corpus (CAT 32 / SER 34 / EST 34); within each, over-weighted toward photos exercising the weak criteria (`UNCERTAINTY_MARKS`, `X_SCALE`, `ZERO_INTERCEPT_ANNOTATION`, `Y_SCALE`, `PLOT_VALUES`) — sample averages 1.64 weak-negative cases/photo vs 0.87 in the full corpus | 770 |
| Statistics | 28 (all) | Whole corpus — small enough to audit entirely | 112 |

## How to run the audit

1. Give the reader the `packet/` folder (open `index.html`, or the images alongside the CSV).
2. The reader marks each criterion `present`/`absent` in `reader_worksheet.csv` — **from the photo
   and rule only**, no scores, no totals. They never see gold/grader/verifier output.
3. Score it:
   ```bash
   python3 score_reader_worksheet.py biology      # or statistics
   ```
   Reports the gold false-accept rate (gold says `earned`, reader says absent) with a 95% upper
   bound and the DECISION-0045 gate: ≤5% certifies / 5–15% diagnose-and-repilot / >15% rejects.
   `--selftest` fills the worksheet from gold (perfect reader) to validate the pipeline.

## Known constraint worth the owner's attention

**Statistics has almost no error budget.** Its 28 photos yield only 99 gold-`earned` judgments, so
even a *perfect* audit (0 false-accepts) produces a 95% upper bound of ~3.7% — it certifies, but a
single reader-vs-gold false-accept (1/99) pushes the bound to ~5.5–6% and fails the ≤5% gate. In
practice Statistics certification is close to all-or-nothing on this corpus; more real Statistics
photos (the D3 volume gap) would be needed to certify with any margin. Biology (484 gold-`earned`
judgments across 100 photos) has real room — a perfect audit bounds at ~0.8%, and it tolerates a
few disagreements before failing.

## Discipline

- No gold, grader, verifier output, or archetype label appears anywhere in `packet/` (verified).
  Real filenames encode archetype (`…CAT…`/`…SER…`/`…EST…`) and are replaced with opaque IDs.
- Builder is deterministic (seeded by sha256 of stable fields; no RNG) — reruns reproduce the exact
  packet. Source images are copied, never modified.
- The reader's cold judgment is treated as truth for the sample; this certifies the **gold**, which
  is the benchmark everything else in Phase D is measured against.
