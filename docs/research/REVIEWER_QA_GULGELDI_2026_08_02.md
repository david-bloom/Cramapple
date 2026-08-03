# Reviewer QA — Gulgeldi Darrynow (AP Chemistry) — 2026-08-02

## Scope

- Production project: `pcntajvbdfqhbeewmdry`
- Reviewer: Gulgeldi Darrynow (`119817d1-96c9-4cbc-8fdc-4962e03b1b12`, role `tutor`)
- All 70 submitted `tutor_question` decisions, 2026-07-31 18:15 UTC through
  2026-08-03 02:10 UTC (includes and extends the 20-item Zeeshan comparison
  packet assigned 2026-07-29)
- Decision mix: 63 approve (41 MCQ, 22 FRQ), 7 approve_with_edits (all FRQ),
  0 disapprove
- Notes: 10 of 70 decisions carry a note (all FRQ). All 41 MCQ approvals are
  note-free.

## Method

- Independent correctness check of 13 MCQ approvals with no prior peer note
  (all stems, keys, and distractors re-derived by hand).
- Version-level verification of every approval on an item with a known owner-QA
  defect (`apchem-mcq-026`, `-029`, `-038`, `apchem-frq-l-013`, `-l-014`).
- Full-text review of all 10 notes for technical accuracy.
- Cross-reference against every peer decision (Saood, Zeeshan) on the same
  content versions.
- Difficulty-label comparison against the authored difficulty in `prompt_json`.

## Findings

### 1. One confirmed false clear: `apchem-mcq-038`

He approved version 1 — the known azeotrope defect (simple distillation keyed
as fully separating ethanol/water; the stem's premise "significantly different
boiling points" is itself wrong: 78.4 °C vs 100 °C with a 95.6 % azeotrope) —
note-free, in 1.7 minutes. Saood had disapproved the same version on 2026-07-30
with the correct fractional-distillation reasoning, and owner QA on 2026-07-31
listed the item as a confirmed Zeeshan false approval. The item now carries a
2-1 approve/disapprove split and remains `reviewed_approved` on the defective
v1. He also did not flag that the stem duplicates all four choices inline.

### 2. No other false clears found

- `apchem-mcq-026` and `-029`: he reviewed the **corrected v2 successors**, not
  the retired defective v1s. Approvals correct.
- All 13 independently re-derived MCQ approvals (`-004`, `-013`, `-031`,
  `-032`, `-036`, `-040`, `-041`, `-047`, `-048`, `-054`, `-058`, `-060`,
  `-065`) key correctly with sound distractors.
- His plain approvals on items where Saood filed approve_with_edits
  (`frq-l-010`, `-l-011`, `-l-016`, `-l-017`, `-l-021`, `-l-023`, `-l-026`,
  `-l-028`, `sfrq-002`, `-004`, `-007`, `-009`, `-016`, `-018`, `-019`) are
  defensible: Saood's notes on those open "the calculations are correct" and
  request polish-level edits. Saood is the roster's most stringent reviewer.
- Minor miss: `apchem-sfrq-021` extraneous unused stimulus data (0.100 M,
  50 mL) that Zeeshan flagged; Gulgeldi approved note-free.

### 3. He catches real mistakes (FRQ side)

- `apchem-frq-l-001`: independently identified the carbonate-identity
  ambiguity that drove Saood's disapproval, plus prompt-leaks in (c)/(d), and
  supplied a full four-part rewrite. Best note of the set.
- `apchem-sfrq-024`: independently caught the missing question prompt (the
  same defect behind Zeeshan's disapproval) and drafted replacement prompts —
  though he routed it as approve_with_edits rather than disapprove.
- `apchem-sfrq-008` / `-010`: correctly identified the answer-leak pattern
  (prompts that state the assumption or formula the student should produce)
  and noted "many questions are like that" — a real systemic authoring defect.
- `apchem-sfrq-010`: correctly noted Cu³⁺ is not stable in aqueous solution
  (the item's M³⁺ with molar mass 63.5 implies copper).

### 4. Defects in his own work

- **Scientific error in a note**: the `sfrq-010` note recommends "Use
  Zn2+/Zn3+" as the replacement redox couple. Zn³⁺ does not exist in aqueous
  chemistry (zinc is +2 only); the suggestion repeats the exact defect class he
  was flagging. His fallback suggestion ("keep it generic M") is fine.
- **Decision/note mismatches**: `sfrq-008` note says "Approved with edits
  because… Rewrote the prompt" but the submitted decision is plain `approve`;
  `sfrq-018` note claims a rubric-label fix was made, also filed as `approve`.
  Plain approvals do not enter the edit workflow, so both requested edits are
  silently dropped. (Compounds the known approve_with_edits-leaves-edit-unmade
  P0.)
- **Zero MCQ notes**: 41/41 MCQ approvals note-free at a 1.5–3 min cadence.
  Accuracy held up in the sample, but this produces no distractor-rationale
  auditing (contrast Abdul Hanan) and gives no evidence trail.
- **Difficulty calibration weak**: 19/70 labels match the authored difficulty;
  12 Hard/Very-Hard items rated Easy or Medium (e.g. `apchem-mcq-019` and
  `-020`, authored Very Hard, rated Easy/Medium; `sfrq-010` authored Very
  Hard, rated Medium).
- Topic selections empty on all 70 — schema-wide gap, not reviewer-specific.

## Assessment

Scientifically accurate on everything he asserts about chemistry in a decision,
with one wrong repair suggestion (Zn³⁺) inside an otherwise-valid note. FRQ
notes are specific, actionable, and twice independently reproduced defects that
peers caught. The failure mode is on the MCQ side: fast, note-free approvals
that missed the one planted known-bad item in his queue (`mcq-038`). He has
never used `disapprove` in 70 decisions — items he agrees are broken
(`sfrq-024`) still get approve_with_edits.

Suggested calibration items if retained: (1) never approve without checking
stem premises, not just the keyed answer's internal logic; (2) route
edit-requiring findings as approve_with_edits, never as approve-with-a-note;
(3) difficulty labels; (4) MCQ distractor-rationale review expectations.

## Follow-ups (owner)

- `apchem-mcq-038` v1 is still `reviewed_approved` with a 2-1 split and a
  confirmed defect; needs adjudication/retirement — third sweep in a row it
  appears in.
- The `sfrq-008` and `sfrq-018` edits exist only in note text and are not in
  any edit workflow.
