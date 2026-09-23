# Codex Work Order F Kickoff — 2026-09-23

Paste the block below into Codex. It is deliberately short: the amended charter on `main` is the
specification, and restating it here would create a second source of truth.

```text
Work order F is unblocked. You recorded a gate skip for it earlier today because Claude's QA report
did not yet exist; it exists now, and that skip is superseded. Re-enter F before continuing G.

Pull `main` first. The charter was amended after your skip and the amendments are the point of this
run — working from your earlier copy will produce the wrong output.

Read, in this order:

1. prompts/CODEX_PROJECT_2_CONTENT_COMPLETION_2026_09_23.md — shared rules, then work order F in
   full. Requirements 1a, 2a, 5 and 6 are new since you last read it.
2. docs/research/apbio_canonical_recovery_2026_09_22/qa_report.md
3. docs/research/apbio_canonical_recovery_2026_09_22/qa_findings.csv
4. docs/activity_log/DECISIONS_LOG.md — DECISION-0056 (index entry at the top).

Work order A's disposition is ACCEPTED, except APBIO-FRQ-S-073 criterion a, which is REJECTED.
Three of the five QA findings are yours to close and are written into F as requirements:

- A-QA-001 -> F 2a. Re-author S-073 criterion a yourself from the stem. The stem sets 2n=4, so the
  claim about what each cell holds after meiosis II is wrong. Do NOT copy a correction out of the QA
  report — the model that found the defect must not also author the fix. The meiosis I half of the
  existing span is correct.
- A-QA-002 -> F 1a. Score every span you author against that criterion's own learner_facing_text
  (case- and punctuation-normalised word tokens, difflib.SequenceMatcher). At or above 0.85, do not
  emit — re-author. Between 0.70 and 0.85, emit only with a restatement_justified flag naming what
  the span adds. Report the distribution in SUMMARY.md. scripts/qa/overnight_qa_harness.py now
  enforces this; the old second-person-phrasing regex did not catch declarative restatement, which
  is the failure that actually occurred.
- A-QA-004 -> F 5, under DECISION-0056. You MAY now remove an uncredited span that a span you
  authored in this run supersedes — four conditions, all of which must hold, and every removal
  logged to removals.csv. This is a scoped exception to "fill gaps; do not replace" for work order F
  only. It is a redundancy exception, not an editing licence: never remove a span that earns a
  criterion, and never remove text because you think it reads badly.

A-QA-003 and A-QA-005 are metadata defects in work order A's own directory and are NOT yours. Do not
edit that directory.

Unchanged: read-only against Production; propose in files; commit and push to
codex/project2-2026-09-23; no PR, no merge to main. Everything you produce is a proposal, and the
gate before anything serves a student is unchanged — AI build, then independent AI cross-model QA by
a different model, then Product Owner approval (DECISION-0055).

Report when F is complete: the 88 criteria re-authored, your similarity distribution, what
removals.csv contains, and anything you could not resolve.
```

## Why this exists

Work order F's gate opened when Claude's QA of work order A landed. Codex had already passed F and
recorded a skip, so without an explicit re-entry it would have carried on through G and I and never
returned. The amendments to F — the S-073 correction, the measurable anti-restatement guard, and
DECISION-0056's removal authorisation — all landed *after* that skip, so a Codex session working
from its earlier read of the charter would miss every one of them.

**Branch-hygiene note for whoever runs this:** the repository root checkout is shared. Do not switch
its branch while a Codex run is in flight — on 2026-09-23 doing so captured work order E's commit
onto a QA branch. Use `git worktree add` for parallel work instead.
