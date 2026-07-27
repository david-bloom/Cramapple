# Codex Task: Expand AP Calculus AB, AP Calculus BC, and AP Precalculus Content

**Context:** This mirrors a batch just completed for AP Chemistry (50 new MCQs + 50 new FRQs, authored, validated, inserted to Production, and assigned for review) — David asked for the same treatment for your three subjects. This doc is the handoff; you already have the schema and pipeline for this content family from your `codex/five-subject-harness-and-content` branch, so this prompt gives scope and sourcing, not a schema re-spec.

## Scope

For **each** of the three subjects — AP Calculus AB, AP Calculus BC, AP Precalculus — author:
- **50 new MCQs**
- **50 new FRQs**

That's 300 new items total across the three subjects. Continue your existing numbering:

| Subject | content_key prefix | Current max MCQ | Current max FRQ | New MCQ range | New FRQ range |
|---|---|---|---|---|---|
| AP Calculus AB | `apcalcab-` | `apcalcab-mcq-020` | `apcalcab-frq-016` | `apcalcab-mcq-021`..`070` | `apcalcab-frq-017`..`066` |
| AP Calculus BC | `apcalcbc-` | `apcalcbc-mcq-020` | `apcalcbc-frq-016` | `apcalcbc-mcq-021`..`070` | `apcalcbc-frq-017`..`066` |
| AP Precalculus | `apprecalc-` | `apprecalc-mcq-020` | `apprecalc-frq-016` | `apprecalc-mcq-021`..`070` | `apprecalc-frq-017`..`066` |

(Verify these max values against Production yourself before starting — this doc is a point-in-time snapshot from 2026-07-24.)

Follow your own established `content/item-packages/<subject>/<content_key>.json` file schema exactly, matching the structure of your existing files (e.g. `apcalcab-frq-001.json`, `apcalcab-mcq-001.json` from commit `96dd28a`) — `schema_version`, `package_id`, `exam_pack_ref`, `archetype_ref`, `taxonomy_refs`, `stimuli`, `parts`/`mcq_choices`, `criteria` with `required_evidence`/`deterministic_checks`/`accepted_variants`, `provenance`, `review_notes`, `accessibility`. Reuse your existing loader script to get these into Production once authored — don't hand-write SQL.

## CED sourcing — use the primary-source fact packs, not general knowledge

Both fact packs live in the shared Drive folder `0ADgrFwyVdiCFUk9PVA`:

- **"AP Calculus AB and BC 2026-27 — CED Fact Pack"** — this was independently re-verified against the actual College Board primary-source PDF on 2026-07-24 and confirmed **unchanged**: same 10-unit structure (Units 1–8 shared AB/BC, Units 9–10 BC-only), same topic numbering, same BC-only sub-topic flags. Use the existing fact pack topic map directly, no need to re-derive it.
- **"AP Precalculus 2026-27 — CED Fact Pack"** — already primary-source-verified (Fall 2026 edition, no prior fact pack existed before it since Precalculus is new to Cramapple). **Critical constraint: Unit 4 (parametric functions, vectors, and matrices) is explicitly NOT assessed on the AP Exam.** Do not author any exam-prep MCQs/FRQs against Unit 4 content — if you want illustrative Unit 4 material for study purposes it needs to be tagged separately from exam-prep content, not mixed into this batch.

Distribute the 50 MCQ + 50 FRQ per subject proportionally across units using each fact pack's exam-weighting table (heavier-weighted units get more items), same approach used for the Chemistry batch. Spread across topics within each unit — don't cluster all items on one topic.

## Quality bar

- **Original authorship only.** No adaptation of any official College Board released question, secure exam item, or copyrighted material — this repo's abstraction firewall policy (`docs/architecture/CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §3–4) applies. Write fresh scenarios/numbers from scratch.
- **Verify all math explicitly** — don't approximate arithmetic, re-derive it. A prior Chemistry batch had reviewer-caught errors from imprecise language (conflating a quantity with its *change*, e.g. "enthalpy" vs. "enthalpy change") — hold calculus/precalculus to the same precision (e.g. don't conflate a function with its derivative/limit, don't round intermediate steps sloppily, verify units and domain restrictions).
- **Avoid the known MCQ correct-answer-length pattern.** A quantitative check against Production this month (`supabase/functions/_shared/content-preflight.ts`, `MCQ_CORRECT_ANSWER_LENGTH_OUTLIER`) found the correct choice is systematically longer than distractors platform-wide — 75% of AP Statistics MCQs, 87% of AP Biology, correct answer averaging 1.6–1.7× a distractor's length. That's a detectable "pick the longest answer" tell, independent of subject knowledge. Vary your correct-answer length relative to distractors; don't let correctness correlate with length.
- Each MCQ: 4 choices, exactly one correct, every distractor's rationale should name the *specific* misconception it reflects (not just "incorrect").
- Each FRQ: mix short (~4 pt, 2–3 sub-parts) and long (~8–10 pt, 3–5 sub-parts) forms; every criterion should be a checkable claim, not a vague description.

## Validation pass — run before calling it done

Before treating any of this as ready for review, run a structural validation pass across the full 300-item batch (same discipline used for the Chemistry batch, which caught two real defects this way):
1. Every MCQ has **exactly one** `is_correct: true` among exactly 4 choices.
2. Every FRQ's summed criterion points match its declared form (short ≈ 4, long ≈ 8–10) — don't leave a "long" item under-pointed.
3. Grep all stem/rationale/criterion text for leftover scratch-work artifacts (self-corrections like "...actually X" that weren't cleaned up, stray mid-sentence recalculations, truncated sentences).
4. Confirm topic distribution roughly matches the fact pack's exam weighting — flag (don't silently drop) anything that doesn't fit cleanly into a single topic.

Report back: total counts per subject/type, any items you couldn't cleanly author (and why), and confirmation the validation pass came back clean (or what it caught and how you fixed it).

## After authoring: review assignment

Once inserted to Production, split each subject's 100 new items (50 MCQ + 50 FRQ) into review packs and assign them — check the current reviewer roster before assigning (SK MD Ferdous and Carlos Eduardo Hutchings are the two Calculus reviewers, both currently on a single small evaluation packet each with a pending performance decision; confirm with David whether this new batch goes to them, and how it should be split between them, before assigning — don't assume, this is a bigger volume than what either of them has been trusted with so far).
