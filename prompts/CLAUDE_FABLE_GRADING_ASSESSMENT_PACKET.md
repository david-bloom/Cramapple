# Claude Fable Grading Assessment Packet

```text
You are giving a second-opinion assessment of Cramapple's grading process and
grading capabilities.

Goal:
- identify ways to improve grading quality, speed, and cost across multiple
  subjects before new subjects and new question sets go live.
- keep the review practical, skeptical, and easy to act on.

First read these documents:

1. docs/research/README.md
2. docs/research/GRADING_RESEARCH_CANONICAL_PROCESS.md
3. docs/architecture/CONTENT_GOVERNANCE_AND_VALIDATION.md
4. docs/architecture/RUBRIC_AUDIT_AND_SAMPLING_POLICY.md
5. docs/tasks/TASK-0010-GRADER-CONFIDENCE-AND-CALIBRATION.md
6. docs/research/grading_test_packet_requirements.md
7. docs/research/grading_packet_backlog_2026_07_07.md
8. docs/research/bio_reference_layer_reporting_standard.md
9. docs/research/grader_speed_sp1_report.md
10. docs/research/ap_statistics_grading_experiment_report_2026_07_07.md
11. docs/research/ap_statistics_frq_bootstrap_calibration_report_2026_07_07.md
12. docs/research/ap_statistics_phase4_mcq_smoke_batch_2026_07_01/README.md
13. docs/research/ap_stats_hdr_experiment_2026_07_07/README.md
14. docs/research/ap_stats_hdr_experiment_2026_07_06/README.md
15. docs/research/ap_biology_hdr_trace_ready_2026_07_07/README.md
16. docs/research/apbio_short_frq_canonical_pair_review_report.md
17. docs/research/apbio_short_frq_boundary_table_test_report.md
18. docs/research/apbio_nuanced_boundary_calibration_takeaways.md
19. docs/research/apbio_primary_fallback_comparison_report.md
20. docs/research/bio_reference_layer_oracle_boundary_test_report.md
21. docs/research/bio_reference_layer_flywheel_volume_test_report.md
22. docs/research/bio_reference_layer_gated_prompt_test_report.md
23. docs/research/bio_reference_layer_exemplar_test_report.md
24. docs/research/bio_reference_layer_next_experiment_plan.md
25. docs/research/bio_reference_layer_strict_context_v2_takeaways.md

Use this order of authority when docs conflict:
- approvals and decisions
- task docs
- architecture and governance docs
- research reports and takeaways
- draft prompts

What to look for:
- where quality is protected well today
- where quality is fragile or overfit to one subject
- where speed is unnecessarily lost
- where cost can be reduced without weakening boundary handling
- whether corpora, gold sets, holdouts, and challenge sets are cleanly split
- whether the naming/indexing system makes lessons easy to find and reuse
- whether it is obvious what is canonical versus exploratory
- what should be standardized across subjects
- what should stay subject-specific

Output format:
1. Executive summary: 5-8 bullets, ranked by impact.
2. Highest-priority improvements: for each, include why it matters, affected
   subject(s), and expected quality/speed/cost effect.
3. Risks and blind spots: what could still go wrong if we keep the current
   process as-is.
4. Shared defaults: which parts should become standard across subjects.
5. Subject-specific exceptions: what should remain different for Biology,
   Statistics, HDR work, or other subject families.
6. Next experiments: the minimum follow-up runs needed to validate the
   recommendations.

Be concrete. Prefer evidence-backed operational advice over broad critique.
If a source doc points to a gap, call it out directly.
```
