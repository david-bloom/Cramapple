# Codex Work Order — Serving-Label Relabeling for the Two Still-Dark Subjects

**Context: FF-3, DECISION-0066** (`docs/activity_log/DECISIONS_LOG.md`). Read it in full first. Short
version: on 2026-09-24 the unit-gated serving path went from dark product-wide (8 servable) to 141
servable by promoting existing two-model-agreed serving labels to `validated`, wherever the label was
fresh (i.e. the item's published content postdates the label). Two subjects had zero fresh candidates
and are still fully dark on this path: **AP Physics C: Mechanics** and **AP Calculus BC**. This order
is to close that gap. Proposal only — no Production writes, no PR, no merge to main.

Paste the block below into Codex.

```text
Work order — produce fresh two-model serving labels for AP Physics C: Mechanics and AP Calculus BC.

Merge main first:

    git fetch origin
    git switch codex/physics-c-mech-calc-bc-relabel-2026-09-24
    # If that branch does not exist instead run:
    # git switch -c codex/physics-c-mech-calc-bc-relabel-2026-09-24 origin/main
    git merge origin/main

The checkout must be clean before starting. Commit and push to
codex/physics-c-mech-calc-bc-relabel-2026-09-24 as you go.

READ FIRST: docs/activity_log/DECISIONS_LOG.md, DECISION-0066 (both the original decision and the
same-day "Correction" section), for the promotion rule and the freshness check this work feeds.

THESE ARE TWO DIFFERENT PROBLEMS, NOT ONE

Verified directly against Production (project pcntajvbdfqhbeewmdry) before writing this order, so
treat this as ground truth, not an estimate:

=== AP Physics C: Mechanics — first-time labeling gap ===

Of its current (non-superseded, label_scope='serving') content_taxonomy_labels rows: 110 are
`legacy_unvalidated` (i.e. never run through the two-model serving-label lane at all -- these are
placeholder rows from the original legacy backfill, not stale candidates), 4 are `held`, 2 are
`stale`, 4 are `validated` (an earlier pass). This subject needs FIRST-TIME two-model serving
labeling for the bulk of its items, not a re-run of existing candidates.

=== AP Calculus BC — staleness gap ===

Of its current (non-superseded, label_scope='serving') rows: 17 are `provisional_model` but stale
(their content_item_version postdates the label -- the item was edited after the label was made, so
DECISION-0066's freshness rule correctly refused to promote them), 15 are `held`, 4 are `stale`, 40
are `legacy_unvalidated`, 4 are `validated`. This subject's 17-item gap needs the SAME items
re-labeled against their CURRENT published content, not new items labeled from scratch.

METHOD (same two-model lane DECISION-0066 already validated at 89% agreement)

For both subjects:
1. Pull every published item's current stem, stimulus, choices/criteria, and any existing
   `content_taxonomy_labels` row (for Calc BC, the existing stale label is useful context for the
   model, not a hint to be copied verbatim -- reject items that clearly need to fix its output).
2. Run two independently-architected models (same pairing as the original lane: e.g. a GPT-5.5-class
   model and a Gemini-2.5-class model via the AI gateway), each producing required_units,
   max_required_unit, primary_unit, and per-criterion evidence, same shape as the existing
   `source_payload.models[].output` structure already in the table (read a few existing rows for the
   exact shape before writing new ones).
3. Where the two models AGREE (same required_units set): record the agreed label as a
   `provisional_model` proposal, ready for the same validated-promotion step DECISION-0066 already
   authorized -- do not mark anything `validated` yourself, only Claude/David promotes.
4. Where they DISAGREE: record both outputs, leave status as a disagreement, same discipline as every
   other two-model gate in this project (no adjudication, no picking one).
5. Multi-unit agreements get NO special promotion path per the plan's own T6.b routing (multi-unit
   agreement still needs full human/third-opinion review, same as the 26-item correction) -- just
   report them as multi-unit agreements, do not imply they're promotable.

SCOPE

- AP Physics C: Mechanics: all published items currently `legacy_unvalidated`, `held`, or `stale` in
  serving scope (~116 items). Skip the 4 already `validated`.
- AP Calculus BC: the 17 `provisional_model`-but-stale items specifically (re-label these against
  current content). Do not touch its 40 `legacy_unvalidated`, 15 `held`, or 4 `stale`/`validated`
  rows -- those are out of scope for this order (a future order, if wanted).

DELIVERABLES

- A packet (JSONL) of per-item inputs, same pattern as prior labeling runs
  (docs/research/bio_stats_topic_tagging_remeasure_2026_09_24/packet.jsonl is a reasonable format
  reference, adapted for units instead of topics).
- Both models' raw outputs per item.
- An aggregated proposal CSV/JSONL: content_key, content_item_version_id, agreement (agree/disagree),
  proposed required_units, proposed max_required_unit, is_multi_unit.
- A SUMMARY.md with: item counts per subject, agreement rate, how many single-unit vs multi-unit
  agreements, and anything that looks like a labeling-lane defect (e.g. a subject-key mismatch like
  the one found in docs/research/bio_stats_topic_tagging_remeasure_2026_09_24/SUMMARY.md -- check for
  it here too before trusting a low agreement rate as a true negative).

WHAT WOULD MAKE THIS REJECTED AT QA

- Any Production write (this is proposal-only).
- Promoting or marking anything `validated` yourself.
- Silently collapsing a multi-unit agreement into a single-unit one, or vice versa.
- Copying the existing stale Calc BC label into the new proposal without independently re-deriving it
  from current content.
- Missing the freshness check itself -- if you can't tell whether an item's content changed since a
  prior label, say so rather than assuming either way.
```
