# Hand-Drawn Graph Corpus Seed v0.2-research-seed - 2026-06-30

This package contains 150 draw-ready AP Biology graph-construction question slots.

Item-ID prefix: `HDG-2026-P2-*`. This package does **not** overwrite the
v0.1 `2026_06_29` corpus (prefix `HDG-2026-P1-*`), which stays frozen and bound
to the hand-drawn pages already captured for it.

## Counts

- `categorical_comparison_supplied_uncertainty`: 50
- `continuous_measured_series_supplied_uncertainty`: 50
- `continuous_relationship_graph_derived_estimate`: 50

## Data realism (changed from v0.1)

- Every displayed mean and SEM is derived from seeded synthetic replicate
  observations stored per point in `synthetic_data.points` (auditable and
  exactly reproducible).
- Two noise scales: between-condition scatter moves points off the smooth
  model; within-condition replicate spread produces an irregular, realistic SEM.
- Non-uniform but clean x-grids that vary across items (no fractional steps).
- Round-ish displayed values (integer means, one-decimal SEM) so number
  transcription is not itself the assessed task.
- RNG-varied shapes per item instead of a small recycled set.

## Files

- `hand_drawn_graph_questions_2026_06_30.jsonl`: full metadata, best source for Supabase/content-intake payloads.
- `hand_drawn_graph_questions_2026_06_30.csv`: spreadsheet-friendly export with JSON-encoded table/spec fields.
- `supabase_content_intake_payload_2026_06_30.json`: wrapper payload shaped for the current `content-intake` Edge Function.
- `scripts/generate_hand_drawn_graph_corpus.py`: deterministic generator (seed_base=20260630).

## Workflow

1. Give each drawer the `student_prompt`/`stem` and ask them to write the `item_id` on the page.
2. Save each photo using `expected_image_filename` or preserve that ID in upload metadata.
3. Upload images only after storage, consent, and retention rules are approved.
4. Send reviewers the image plus the matching row payload; keep `criterion_definitions` hidden from drawers.
5. Review capture quality before scoring graph criteria.

## Status

Research seed only. These items are independently authored synthetic prompts but have not yet passed Learning Quality, rights/similarity, accessibility, or production release review.
