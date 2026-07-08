# Codex QA Prompt — Benchmark Corpus 2026-07-06 (PR #30)

Use per `docs/team_charter/AGENT_OPERATING_MODEL.md`'s QA Agent role: an
independent, skeptical review — not a relabeled continuation of whoever
implemented this. Treat yourself as having no prior context on this work;
verify everything from source, not from the PR description's claims.

## Task

Review GitHub PR #30 ("Add 40 AI-provisional benchmark-grade grading corpus
packages") on branch `claude/benchmark-corpus-2026-07-06` against `main`.
Pull the actual diff (`gh pr diff 30` or equivalent) rather than trusting
the description.

## Background

This PR adds 40 new packages under `docs/research/benchmark_corpus_2026_07_06/`
(10 `biology_frq_*`, 10 `statistics_frq_*`, 10 `biology_hand_drawn_*`, 10
`statistics_hand_drawn_*`), each with `README.md`, a packet doc, `corpus.jsonl`,
and `label_validation.md`, plus a `scripts/` folder with the Python data files
and generator that produced them. Every response, criterion label, reviewer
note, and boundary tag was authored by Claude in a single pass, with no
independent human or subject-matter-expert review. Every file is explicitly
stamped `ai_provisional_unapproved` and each `label_validation.md` states the
package is not ready for benchmark execution. This is docs-only — it should
not touch any application code, migration, or edge function.

## What to verify, not assume

1. **Diff is docs-only.** `git diff origin/main --stat` for this branch
   should show changes exclusively under
   `docs/research/benchmark_corpus_2026_07_06/`. Flag anything touching
   `supabase/`, `apps/`, or any other functional path — this PR should have
   zero behavior change to anything live.
2. **Subject-matter accuracy is the real risk here, not formatting.** Pick at
   least 3 `biology_frq_*` and 3 `statistics_frq_*` packages at random and
   independently verify the rubric criteria and the "full-credit" (all-4-
   `earned`) response against actual AP Biology / AP Statistics content
   knowledge — not against the package's own reviewer notes, which were
   written by the same model that wrote the content. Look specifically for:
   reversed mechanisms/directions (e.g., proton-pumping direction, allele-
   frequency math, hypothesis-test null values), incorrect formulas (e.g.,
   standard error, chi-square degrees of freedom, confidence-interval
   critical values), and AP-scope violations. Report any factual error found,
   even a single one — a benchmark-grade grading corpus with a wrong
   "correct" answer is worse than no corpus.
3. **Hand-drawn packages must faithfully reuse existing source items, not
   drift from them.** For at least 2 `biology_hand_drawn_*` packages, diff
   the `stem` and `display_table` in that package's `hand_drawn_input_packet.md`
   against the matching `item_id` row in
   `docs/research/hand_drawn_graph_corpus_2026_06_30/hand_drawn_graph_questions_2026_06_30.jsonl`
   — every number and word should match exactly (this data was supposed to be
   reused, not re-authored). Do the same for at least 2 `statistics_hand_drawn_*`
   packages against
   `docs/research/ap_statistics_graph_response_seed_2026_07_02/ap_statistics_graph_response_seed_2026_07_02.jsonl`.
   Confirm exactly 10 of the 12 available AP Statistics graph-response items
   were used (2 were deliberately dropped per the package README) and that
   this is documented, not silently done.
4. **Bio hand-drawn 4-criterion condensation is defensible.** Each
   `biology_hand_drawn_*` package condenses the source item's original 6-9
   criteria down to 4. For at least 3 packages, check the condensation in
   `scripts/bio_hand_drawn_data.py` (`CAT_CRITERIA`/`SER_CRITERIA`/`EST_CRITERIA`)
   against the original `criterion_definitions` in the source JSONL — confirm
   nothing substantive was silently dropped rather than merged, and that the
   "notes" field correctly states which original criteria each merged
   criterion maps to.
5. **`corpus.jsonl` internal consistency.** For every one of the 40
   `corpus.jsonl` files: confirm every line is valid JSON; confirm
   `points_labeled` equals the count of `"earned"` values in
   `criterion_labels` for that record (a mechanical check you can script);
   confirm `label_status` is `"ai_provisional_unapproved"` and
   `use_as_ground_truth` is `false` on every single record with no
   exceptions. A script checking all 40 files is more reliable than spot
   sampling here.
6. **`label_validation.md` stats match `corpus.jsonl`, not just each other.**
   For at least 5 packages, independently recompute the response count, ID
   range, labeled-point distribution, and criterion-level distribution
   directly from `corpus.jsonl` and confirm they match what
   `label_validation.md` claims — don't trust that because both files came
   from the same generator they're automatically consistent.
7. **No overclaimed approval anywhere.** Grep all 160 files for `approved`,
   `Learning Quality`, `Orly`, and `ready for benchmark` — confirm every hit
   is phrased as *not yet approved* / *pending review*, with no file (even a
   throwaway sentence) implying these labels already carry real sign-off.

## Authority boundaries

You may propose a verdict and findings. You may **not** approve, merge, mark
this reviewed/`Done`, or represent any package as Learning-Quality-approved —
see `AI_COLLABORATION_RULES.md`. David is the only one who closes this out.

## Required Output

1. Proposed verdict: Pass / Fail.
2. Blocking findings, with file:line (or file:package_id), if any — factual
   content errors found under item 2 are blocking by default.
3. Non-blocking risks or gaps (e.g., packages not sampled).
4. Evidence actually checked (files read, commands/scripts run) — not just
   claims restated from the PR description.
5. Required remediation, if any.

Keep the report under 500 words.
