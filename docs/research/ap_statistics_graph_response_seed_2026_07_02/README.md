# AP Statistics Graph-Response Seed Set - 2026-07-02

This package contains twelve original AP Statistics graph-response FRQs for
hand-drawn grading experiments. It is research seed content only; it has not
passed Learning Quality, rights/similarity, accessibility, or production
release review.

## Source Rationale

The six archetypes match graph forms confirmed in publicly available College
Board AP Statistics free-response materials and Chief Reader Reports for
2023-2025. The set contains two original FRQs for each archetype:

- boxplot construction / interpretation;
- segmented bar graph construction;
- mosaic plot interpretation;
- dotplot distribution-shape reasoning;
- scatterplot / regression-context reasoning;
- graph annotation / marking a value.

Normal-curve shading is intentionally excluded from this v0.1 seed because it
is curriculum-relevant but was not confirmed as a student-drawn graph response
task in the 2023-2025 public AP Central materials reviewed.

## Files

- `ap_statistics_graph_response_seed_2026_07_02.jsonl`: complete item metadata.
- `ap_statistics_graph_response_seed_2026_07_02.csv`: spreadsheet-friendly export.
- `reference_images/`: clean generated answer-key images, one per item, plus
  `contact_sheet.png` for quick review.
- `scripts/generate_ap_statistics_graph_response_seed.py`: deterministic generator.

## Workflow

1. Give drawers the `stem` / `student_prompt` and ask them to write the
   `item_id` on the page.
2. Keep `criterion_definitions` hidden from drawers.
3. Use `reference_images/` only as reviewer/calibration answer references,
   not as student-facing exemplars.
4. Collect blind human scores before making any grader-agreement claims.
