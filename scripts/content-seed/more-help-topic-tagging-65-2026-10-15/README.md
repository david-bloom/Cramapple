# More help priority topic tagging — 2026-10-15

Owner direction and bounded scope: [APPROVAL-0178](../../../docs/activity_log/APPROVAL-0178_MORE_HELP_PRIORITY_TOPIC_TAGGING_2026_10_15.md), [work order](../../../docs/tasks/WORK-MORE-HELP-TOPIC-TAGGING-65.md).

This directory contains metadata only. Full questions/keys/rubrics, raw model votes, private CED review artifacts and credentials remain under `/private/tmp` or the existing credential mechanism; never commit them here.

- `vote.mjs`: existing three-family/two-sample classification process, frozen input hashes, per-attempt full-cost reservations, single-runner lock,420-attempt/$20 internal ceiling. Uses the existing Gateway credential; no provider/key change.
- `run_evidence.json`:396 attempts,388 usable votes of390, conservative accounted cost about$3.42, private vote hashes. Two DeepSeek logical votes remained missing after bounded retries; missing responses are not votes.
- `manifest.json`:64 accepted primary-topic assignments, exact IDs/hashes, actual vote counts, independent CED citations and explicit adjudication. One CED-scope exception (`apchem-mcq-043`) remains owner-dependent. No skill or secondary-topic cells are written.
- `build_load.py`: builds the reproducible data-only transactions from the frozen private source and adjudication evidence. Registry topic IDs and subject spelling are checked against actual database seams.
- `rehearse.sql` / `apply.sql`: identical transaction body; rollback versus commit ending. Locks content/label/registry metadata briefly, rejects source/latest-version/subject/registry/label drift and any new cell, then inserts/verifies exactly64 new primary rows.
- `verify.sql`: read-only exact inserted-row projection and unchanged-source checks.
- `rehearse_recovery.sql`: insert and inverse the64 new rows inside a rolled-back transaction.
- `recovery.sql`: prepared inverse for this exact insertion into an originally empty mapping set. Requires a current recovery decision and unchanged sources/rows, no subsequent human validator or additional cells. It does not modify questions, unit labels or learner records.

Direct CED arbitration is deliberately stronger than topic-title vote agreement: Chemistry conjugate pairs map to4.8 rather than8.1; comparing Q/K for direction maps to7.7. BC6.14 is the CED's mixed-antidifferentiation selection topic and has no standalone LO/EK; its component objectives are cited rather than invented.

Current execution state is recorded in the work order and result report after rehearsals/application. The model pass and independent classifications are not themselves evidence that cells were loaded.
