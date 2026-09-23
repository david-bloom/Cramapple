# Codex Work Order H Kickoff — 2026-09-23

Paste the block below into Codex. It is deliberately short: the amended charter on `main` is the
specification, and restating it here would create a second source of truth.

```text
Work order H is unblocked. You recorded a gate skip for it earlier today because Claude's QA of work
order D did not yet exist; it exists now, D was ACCEPTED, and that skip is superseded.

FIRST, bring main into your branch. The H amendments are on main and not on
codex/project2-2026-09-23, so your working copy has the pre-amendment text.

    git fetch origin
    git merge origin/main          # from your worktree on codex/project2-2026-09-23

Confirm before continuing: `grep -c "Gate status, 2026-09-23: OPEN" \
prompts/CODEX_PROJECT_2_CONTENT_COMPLETION_2026_09_23.md` must return 1. The same merge brings you
D's qa_report.md and qa_findings.csv, which are not on your branch either.

Read, in this order:

1. prompts/CODEX_PROJECT_2_CONTENT_COMPLETION_2026_09_23.md — the shared rules and the shared
   QA-preparation contract, then work order H in full. The closed-list table and the per-item
   content_check requirement are new.
2. docs/research/calcab_chem_topic_labels_2026_09_22/qa_report.md — D's QA. H repeats D's method at
   scale, so read what was verified to work and what could not be checked.
3. docs/research/apstats_topic_labels_rework_2026_09_23/qa_report.md — E's QA. E is the other
   labelling run, and its failure mode is the one that scales worst.

What is different from your earlier read of H:

- The six closed lists are now named with their exact taxonomy_source_version, topic count and unit
  count. Confirm each count yourself and report any disagreement. Earlier H named none, which left
  the most important input to inference.
- For each of the 149 items that already carry an author-time code, emit an explicit per-item
  content_check verdict (agrees | disagrees | unclear) and report the distribution. D reported zero
  disagreements across 241 rows and QA could not prove the check had run on each one; sampling made
  it credible but not evidenced. 149 individual verdicts make it evidenced.
- Confidence must track topical ambiguity, not metadata quality — see the shared QA contract. E
  reported 370 high, 0 low, 0 undetermined and every item QA rejected was marked high. Where two
  topics both plausibly fit, that item is medium at best however clean its metadata.

Carry E's lessons even though this is a different subject set: build evidence from stem + stimulus +
rubric, run a template pre-pass before classifying, allow undetermined with needs_human, and report
topic concentration as a diagnostic without engineering it. The failure mode is not inventing codes,
which the closed list prevents — it is confidently assigning the wrong one to a whole template
family. That is what got E's AP Statistics run rejected on 56 items.

Physics topic strings need care: several Physics FRQ carry unit names rather than topic codes in
prompt_json.topic ("Fluids", "Oscillations", "Electric Circuits"). Those are unit-level hints, not
recoverable codes.

Unchanged: read-only against Production; propose in files; one directory per work order; never
create or edit qa_findings.csv or qa_report.md; commit and push to codex/project2-2026-09-23, no PR
and no merge to main. Everything you produce is a proposal, and the gate before anything serves a
student is unchanged — AI build, then independent AI cross-model QA by a different model, then
Product Owner approval (DECISION-0055).

Sequencing note: H is 603 items across six subjects, the largest labelling job in the project. Work
subject by subject and commit after each, as G does. A truthful "three subjects complete, three not
attempted" is a good outcome; six half-done subjects is not.

Report when done or when you stop: items labelled per subject, the recover/derive split, your
content_check distribution, confidence distribution, topic concentration per subject, and anything
you could not resolve.
```

## Why this exists

H's gate opened when Claude's QA of work order D landed. Codex had already passed H and recorded a
skip, so without an explicit re-entry it would never return to it — the same situation as work order
F earlier the same day.

Two substantive changes went in with the gate:

- **The six closed lists are now named.** D's work order pinned its two `taxonomy_source_version`
  UUIDs with their topic and unit counts, so both builder and QA could confirm they were working from
  the same registry. H said only "that subject's closed list". All six exist and are `verified`; the
  UUIDs are in the work order now.
- **QA finding D-QA-003 is closed by specification.** D's `content_disagrees=false` across all 241
  rows could not be verified as a check that ran rather than a field left at its default. Sampling
  made it credible. Requiring a per-item verdict makes the next 149 evidenced instead.

**Branch-hygiene note:** Codex works in `/private/tmp/cramapple-project2` on
`codex/project2-2026-09-23`, and these amendments are on `main`. A session that skips the merge reads
the pre-amendment work order, and every change above silently does not exist.
