# TASK-0078 — Submission replay ownership (UNAPPLIED)

Status: Ready for independent review; local fixtures pass. Database application is separately gated.

The new migration retains both pre-lock and post-lock replay probes, the row locks, hash format, grants, SECURITY DEFINER/search_path settings and submission transitions. Both probes now require the actor. A collision on the existing audit key index becomes `submit_response:idempotency_conflict`; the function's exception block rolls back both updates. Other unique violations retain their original error. No key namespace or hash migration is introduced.

The precondition permits only the two exact bodies freshly read from Production (`024e412aacf07cfd7ed0c0e03ef70d89`) and Development (`f15074ff69f68948034ab6d0e8f72615`) on 2026-10-21. Any concurrent body change aborts and requires re-review. This migration does not replace or disable the photo/transcript submission trigger.

The disposable Postgres fixture installs the actual Production body, applies the proposal, and checks legitimate replay, cross-actor refusal, changed hashes and atomic rollback after a colliding audit insertion. The new SQL workflow runs this on a fixture database without project credentials.

Release order: independently review; rehearse on Development with current source/trigger/grant fingerprints; verify its submission/entitlement/photo integration tests; approve the exact Production migration separately; then verify body hash, grants and triggers after application. Do not infer trigger integration coverage from the minimal local fixture. Development's entitlement flag parity remains a separate configuration gate.

Containment is a reviewed forward fix or disabling the affected operation. Reverting to the actor-unscoped body requires an explicit risk decision. No database or configuration write was performed by this PR.
