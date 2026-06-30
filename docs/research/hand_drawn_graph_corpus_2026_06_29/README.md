# Hand-Drawn Graph Corpus Seed - 2026-06-29

This package contains 150 draw-ready AP Biology graph-construction question slots.

## Counts

- `categorical_comparison_supplied_uncertainty`: 50
- `continuous_measured_series_supplied_uncertainty`: 50
- `continuous_relationship_graph_derived_estimate`: 50

## Files

- `hand_drawn_graph_questions_2026_06_29.jsonl`: full metadata, best source for Supabase/content-intake payloads.
- `hand_drawn_graph_questions_2026_06_29.csv`: spreadsheet-friendly export with JSON-encoded table/spec fields.
- `supabase_content_intake_payload_2026_06_29.json`: wrapper payload shaped for the current `content-intake` Edge Function.
- `scripts/generate_hand_drawn_graph_corpus.py`: deterministic generator.

## Workflow

1. Give each drawer the `student_prompt`/`stem` and ask them to write the `item_id` on the page.
2. Save each photo using `expected_image_filename` or preserve that ID in upload metadata.
3. Upload images only after storage, consent, and retention rules are approved.
4. Send reviewers the image plus the matching row payload; keep `criterion_definitions` hidden from drawers.
5. Review capture quality before scoring graph criteria.

## Status

Research seed only. These items are independently authored synthetic prompts but have not yet passed Learning Quality, rights/similarity, accessibility, or production release review.
