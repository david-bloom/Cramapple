# TASK-0069 — Remediation of Codex QA (Fail / Blocked) and re-QA brief

**Date:** 2026-10-09 (late) / 2026-10-10 UTC. **Author:** Claude (implementer). **Responds to:** `docs/qa/QA_TASK0069_CODEX_2026_10_09.md` (Codex, recommended verdict Fail — Blocked, at `5ff9e31e`).
**State:** every finding remediated and verified on Development; Lovable preview updated (unpublished); Production unchanged; PR #397 still unmerged. The task returns to **Ready for Review** pending Codex re-QA. Only Codex (QA Agent) recommends the new verdict; only David merges.

## Finding by finding

| Codex finding | Verified? | Fix | Evidence (Development) |
| --- | --- | --- | --- |
| **P1-a** confirmation not bound to the answer text; owner can PATCH `response_text` after confirming | Yes. `response_versions_owner_update_draft` and the `UPDATE` grant are identical on Production. | Confirmation is now one SQL function, `app.confirm_response_transcript`, which writes the text and stores `_confirmed_content_digest = app.response_content_digest(response_text, non-reserved parts)` computed server-side. The digest is recomputed at submission. | Integration test case 4 (owner edits through the RLS path, then submit → `transcript_confirmation_required`); smoke "submit after a post-confirm edit is refused" via real PostgREST PATCH. |
| **P1-b** retake/submit TOCTOU; the gate ran in the Edge Function before the submit RPC | Yes. Also found: a second public function, `submit-response`, calls `app.submit_response` directly and never ran the Edge gate at all. | The gate moved into the database: trigger `app.response_versions_guard_submission` fires on the `is_submitted` false→true transition, inside `app.submit_response` after it has locked the attempt and response version. `bind_response_attachment` takes the attempt lock first, so the two serialize. The Edge preflight was removed (one rule, one place). Covers both submit functions. | `scripts/frq_photo_race_test.py`: two real connections forced into both orderings with `pg_sleep` — retake holds the lock → submit waits ~4 s then is refused; submit holds the lock → retake waits then is refused and the graded photo is still the confirmed one. Integration test cases 1, 5, 6. |
| **P2-a** `photo_required` submittable typed-only and auto-graded | Yes, and wider than reported: the selector change served the 40 hand-drawn items to every student regardless of the client flag. | (1) The same DB trigger refuses a `photo_required` submission with no bound photo (`submit_response:photo_required`). (2) `evaluate-attempt` refuses `photo_required` items (`human_review_required`), keeping them in the human queue. (3) Server-side rollout `_shared/frq-photo-rollout.ts`, knob `FRQ_PHOTO_SUBJECTS` (default `none` = admins only; `all`; or a subject list): `student-session-items` withholds `photo_required` items where photo is off (reported in `omitted` as `photo_capture_not_enabled`, never silently) and returns `photo_enabled`; `attempt-response` transcript ops refuse with `feature_disabled` where photo is off. (4) Lovable: `photo_required` items render no typed fields and no typed Submit from first render; the flag now follows the server's `photo_enabled` (`?photo=on` and the client subject list removed; `?photo=off` remains a local opt-out). | Integration test case 7 (typed `photo_required` refused) and 8 (typed `photo_allowed` still submits); Lovable test "photo_required render rule"; rollout unit tests. |
| **P2-b** redaction false success after a lineage-query failure; not resumable after partial completion | Yes. | Lineage read error → 500 `redaction_lookup_failed`, nothing recorded. The sequence moved to `_shared/attachment-redaction.ts`: a row is stamped only when storage reports it removed or a follow-up existence check says it is absent; any storage error, unverifiable check, or still-present object stops before stamping; a failed run is never recorded as an idempotent result, so a retry with the same key resumes. | `attachment-redaction_test.ts` failure injection: storage error, object still present, unverifiable check, stamp failure then clean retry, already-redacted no-op. Smoke: admin redaction, row survives with digest, object gone. |
| **P3** no tests on the submission integrity boundary | Yes. | `supabase/tests/task0069_submission_integrity.integration.sql` (rolled back, 8 cases), `scripts/frq_photo_race_test.py` (2 orderings, 7 checks), smoke additions, new Deno tests (rollout, redaction). | See below. |

## What else changed with the fixes

- `confirm_transcript` returns 409 `photo_changed` when the photo was retaken after the page was read; Lovable re-reads and says "Your photo changed — check the new reading below."
- New 409 codes: `submit_response` → `transcript_confirmation_required`, `photo_required`; `evaluate-attempt` → `human_review_required`; Lovable classifies all four (with `feature_disabled`) as expected refusals, never as our bug.
- The legacy admin-only `/hand-drawn-pilot` page and the legacy `/session` `CaptureItem` path submit photos without a transcript; they are now refused at the database. Both are superseded and unreachable for students; noted, not repaired.
- Accepted residual (unchanged): the per-student daily read cap is read-then-act and can overshoot by a few cents under concurrent requests.

## Evidence summary

| Check | Result |
| --- | --- |
| `deno test --allow-env --allow-read --allow-net supabase/functions` | 596 passed, 0 failed |
| `supabase/tests/task0069_submission_integrity.integration.sql` on Development | `TASK0069_INTEGRITY ALL PASS` (8 cases) |
| `python3 -I scripts/frq_photo_race_test.py <linked repo root>` on Development | `ALL RACE CHECKS PASSED` (both orderings) |
| `scripts/frq_photo_smoke.mjs` on Development (with Development admin) | `ALL CHECKS PASSED` (serving check Production-only, as before) |
| Lovable App `56cae479` commit `e8c11dce` | 838 vitest passing, `tsc` and `vite build` clean (agent-reported); source read by Claude |

Development state after remediation: migrations `20261009230917`, `…230918`, `…231314`, `…233521`, `…233645`, and `20261010002322_frq_photo_submission_integrity`; functions `attempt-response`, `student-session-items`, `evaluate-attempt`, `capture-pairing` deployed; secrets `FRQ_PHOTO_RESPONSES_ENABLED=true`, `FRQ_TRANSCRIPT_MODEL=gpt-4.1-mini`, `FRQ_PHOTO_SUBJECTS=ap-statistics`.

## Re-QA outcome (2026-10-10)

Codex re-QA: **Pass** (`docs/qa/QA_TASK0069_CODEX_2026_10_09.md`, "Re-QA update"). Its one non-blocking P3 (the legacy `supabase/functions/submit-response/index.ts` wrapper mapped the two new database refusals to a generic 500) is fixed: both now return 409 with their own code. That wrapper is not in the TASK-0069 deploy set.

## Re-QA prompt for Codex (as used)

"""
You are the independent QA Agent re-testing TASK-0069 after remediation. Fresh context. Read docs/team_charter/CRAMAPPLE_SESSION_START.md, your own report docs/qa/QA_TASK0069_CODEX_2026_10_09.md, and this file (docs/qa/QA_TASK0069_REMEDIATION_2026_10_09.md). Work on branch claude/hand-drawn-frq-build-2026-10-09 at the head named in PR #397, in a worktree or fresh clone; never git stash in the shared checkout. Same boundaries as before: no Production writes, deploys, migrations, secrets, publishes, or merges.

1. For each of your five findings, decide independently whether the fix closes it. Read the code, not this file's claims: supabase/migrations/20261010002322_frq_photo_submission_integrity.sql (app.response_content_digest, app.confirm_response_transcript, app.response_versions_guard_submission and its trigger), supabase/functions/attempt-response/index.ts (confirm, the removed Edge preflight, mapSubmitError, redaction, the rollout check), supabase/functions/_shared/{attachment-redaction,frq-photo-rollout,response-transcript}.ts, supabase/functions/student-session-items/index.ts (photo_required withholding, photo_enabled), supabase/functions/evaluate-attempt/index.ts (human_review_required).

2. Try to break it again. In particular: any write path that sets response_versions.is_submitted without firing the guard (search every function and migration); any way to change response_text or a non-reserved part after confirmation without changing the content digest (e.g. key ordering, whitespace, JSON vs string response_parts, a part named "capture"); whether a retake via capture-pairing's submit_capture takes the attempt lock before the guard can read the attachment; whether a student can reach a photo_required item or the transcript ops in a subject where FRQ_PHOTO_SUBJECTS is off; whether evaluate-attempt can still grade a photo_required attempt; whether redaction can stamp a row whose object still exists.

3. Run: the Deno suite; supabase/tests/task0069_submission_integrity.integration.sql against Development (`supabase db query --linked --workdir <linked repo root> -f <absolute path>`; expect an error message starting "TASK0069_INTEGRITY ALL PASS"); scripts/frq_photo_race_test.py against Development; scripts/frq_photo_smoke.mjs against Development (admin checks need an existing Development admin — ask David for credentials or skip them and say so). All three Development scripts create rows owned by smoke+frqphoto-* users; that is expected.

4. Frontend: read the Lovable App source at commit e8c11dce (src/screens/PracticeFrqScreen.jsx, src/screens/parts/FrqPhotoPanel.jsx, src/lib/feature-flags.ts, src/lib/live-practice-frq/{session,photo,photo-review}.ts, src/lib/capture-schema.ts). Confirm photo_required renders no typed path, the flag follows result.photo_enabled with no client-side way to turn it on, and the photo_changed re-read path keeps the student's text only where the new reading is empty.

5. Update your report (append a "Re-QA" section with SHAs, per-finding verdicts, new findings with P1/P2/P3 and evidence labels) and the task record's QA Result. Recommend Pass or Fail. Do not set Done, merge, or touch Production.
"""
