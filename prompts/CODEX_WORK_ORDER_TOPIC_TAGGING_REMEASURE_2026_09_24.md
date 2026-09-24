# Codex Work Order — Re-run Topic Classification With the Subject-Key Bug Fixed

**This is a remeasurement, not a promotion.** No label gets written to Production, no `label_status`
changes. The only question this answers is: does two-model topic-agreement improve once the models
actually see `app.topic_explainers`, instead of silently getting zero rows back and tagging blind?
If yes, that's new evidence for revisiting DECISION-0067 (FF-9, currently deferred on a 44%
agreement measurement). If no, DECISION-0067 stands as-is with stronger confidence.

## The bug, precisely

`public.content_items.subject_key` uses one namespace (`biology`, `ap-statistics` — hyphenated,
Biology irregular); `app.topic_explainers.subject_key` uses another (`ap_biology`, `ap_statistics`
— underscored, `ap_` prefix always present). The original run
(`prompts/CODEX_BIO_STATS_TOPIC_TAGGING_AND_FRQ_CANONICAL_REVIEW_2026_09_22.md`) queried
`topic_explainers` directly with the content table's own `subject_key` and got **zero rows back,
silently** — its own `SUMMARY.md` records this ("the model-side explainer table returned 0 rows for
the queried subject keys") but the run proceeded anyway, with `explainer` marked `na` throughout
rather than stopping. Both models classified topics with no curriculum grounding beyond a bare
topic-code list, which is very likely why measured agreement was only 44%.

Paste the block below into Codex.

```text
Work order — remeasure two-model topic-classification agreement with topic_explainers grounding
actually reaching the prompt (Biology + Statistics, the same two subjects the original run covered).

Merge main first:

    git fetch origin
    git switch codex/topic-tagging-remeasure-2026-09-24
    # If that branch does not exist instead run:
    # git switch -c codex/topic-tagging-remeasure-2026-09-24 origin/main
    git merge origin/main

The checkout must be clean before starting. Commit and push to
codex/topic-tagging-remeasure-2026-09-24 as you go. Do not open a PR and do not merge to main.
Read-only against Production throughout -- this produces a proposal and a measurement, nothing more.

READ FIRST:
  1. docs/activity_log/DECISIONS_LOG.md -- DECISION-0062 (why the original Biology rows landed
     provisional_model and Statistics' 384 rows were rejected outright) and DECISION-0067 (why FF-9
     stays deferred on the 44% figure this work order is testing).
  2. prompts/CODEX_BIO_STATS_TOPIC_TAGGING_AND_FRQ_CANONICAL_REVIEW_2026_09_22.md -- the original
     work order. Its scope, closed-list sourcing (section 2.2), and output schema (the
     content_item_id/subject_key/.../agreement_with_explainer_retrieval/rationale/needs_human
     columns) are UNCHANGED. The only thing this order changes is section 2.3's explainer lookup.
  3. docs/research/bio_stats_topic_tagging_2026_09_22/SUMMARY.md -- the original run's own
     admission that the explainer table returned 0 rows -- and qa_findings.csv in that same
     directory for the four systematic Statistics error classes DECISION-0062 references.

THE FIX

app.topic_explainers.subject_key uses a different namespace than public.content_items.subject_key.
Verified live on Production 2026-09-24:

    content_items.subject_key:  'biology', 'ap-statistics'  (hyphenated; Biology has no 'ap-' prefix)
    topic_explainers.subject_key: 'ap_biology', 'ap_statistics'  (underscored; always 'ap_' prefixed)

Before doing anything else, write and run a one-off query that normalizes content_items.subject_key
to the topic_explainers namespace (strip a leading 'ap-', replace remaining '-' with '_', prepend
'ap_' if not already present -- 'biology' -> 'ap_biology', 'ap-statistics' -> 'ap_statistics') and
confirm you now get non-zero topic_explainers rows for both subjects. Report the exact row counts
per subject before proceeding -- do not assume the fix worked, verify it the same way the original
run's silent failure should have been caught.

Also check apphy2-frq-006-style content_keys were unaffected -- i.e. confirm this bug is scoped to
Biology and Statistics topic lookups only and didn't also silently affect any other subject's prior
topic-labeling runs. If it did, report that as a separate finding; do not silently expand this
order's scope to fix it.

RE-RUN, using the original work order's full methodology (sections 2.1-2.4, unchanged) with ONLY
the explainer retrieval fixed:

  - AP Biology: 118 items (43 MCQ, 75 FRQ), closed list = 60 topics,
    taxonomy_source_version 'c676d1fc-3b58-4896-89e3-852d9bd1f81b'.
  - AP Statistics: verify current published count yourself (384 at the time of the original run;
    confirm it hasn't moved), closed list = 55 topics,
    taxonomy_source_version 'dae3c72e-82ca-4960-9552-1b034bd347e5'.

Two independent models classify each item's primary topic (and any others it assesses), each now
with real topic_explainer content (core_idea, what_students_need_to_understand,
how_this_becomes_points) available for every candidate topic it's choosing between -- not just a
bare topic-code/title list. Record agreement exactly as the original run's schema does: full
per-item output plus an honest agreement rate, not just a headline number.

MEASURE AND REPORT

  - New two-model agreement rate on topic classification, Biology and Statistics reported
    separately. Compare directly against the original 44% figure (DECISION-0062's cited number).
  - Whether explainer coverage gaps limited the result -- Biology is 60/61 topics published,
    Statistics's topic_explainers coverage may differ; report the actual denominator you had
    grounding for vs. items where explainer content was still missing and the model had to fall back
    to the bare topic list (flag these separately in the output, don't blend them into one number).
  - For Statistics specifically: does this re-run's error pattern still show the four systematic,
    template-shaped error classes DECISION-0062's rejection was based on (see qa_findings.csv), or
    does grounding fix them? This determines whether Statistics's rejected 384 rows can be treated
    as rebuilt by this run, or still need further work.

DO NOT promote anything, write assessed_topics to Production, or change any label_status. This is
purely a measurement to inform whether DECISION-0067 should be revisited. Produce the same
packet.jsonl / topic_labels_proposal.csv / SUMMARY.md shape as the original run, in a NEW directory
(docs/research/bio_stats_topic_tagging_remeasure_2026_09_24/ -- do not overwrite the original
run's directory, which stays as the historical record of the bug).

Report plainly if the new agreement rate is NOT meaningfully better than 44% -- that is a real,
useful result (confirms the task is genuinely hard, not just previously blind) and should be stated
as such, not soft-pedaled.
```

## What stays with Claude

- QA of the remeasurement (spot-check that `topic_explainers` rows were actually retrieved and used,
  not just present in a count).
- Deciding, with David, whether the new agreement rate changes DECISION-0067's calculus — this work
  order only produces the evidence, it doesn't re-decide FF-9.
