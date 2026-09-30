# Runbook §5 — BYOQ and Safety Boundary: Evidence

**Date:** 2026-09-30 · **Ran by:** Claude (implementation thread) · **Status:** Ready for Review — not Done
**Scope:** `LAUNCH_RUNBOOK_2026_10_02.md` §5. **Production read-only SQL and public page fetches only.**
No writes, no deploys, no migrations, no test student.

This records evidence. It does not declare §5 passed; per the runbook's authority split only the Main
Conductor sets work Done and only David authorizes launch.

## §5.1 — Anonymous BYOQ does not expose a canonical answer

**Verified. The exposure is structurally impossible, not merely unobserved.**

| Check | Result |
|---|---|
| Answer-bearing columns on `app.byoq_*` | **None exist.** Full column inventory across `byoq_items`, `byoq_responses`, `byoq_attachments`, `byoq_owners`, `byoq_capture_pairing_tokens` has no `is_correct`, `canonical_answer`, `rubric`, `explanation`, `rationale` or equivalent |
| `anon` grants | **Zero** on every BYOQ table |
| `authenticated` grants | Present on `byoq_items` / `byoq_responses` / `byoq_attachments` only; none on `byoq_owners` or `byoq_capture_pairing_tokens` |
| RLS | Enabled on all five tables. `byoq_items`: `user_id = auth.uid()`. `byoq_responses` / `byoq_attachments`: owner via `EXISTS` join to `byoq_items`. Roles `{authenticated}` only |
| MCQ choice shape | `CHECK app.byoq_choices_are_answer_free(choices)` — an **exact key allowlist**, `array['choice_key','choice_text']`, `is distinct from` comparison |

The allowlist was evaluated directly against candidate payloads (pure function call, no write):

| Payload | `byoq_choices_are_answer_free` |
|---|---|
| `{choice_key, choice_text}` ×2 | `true` (accepted) |
| `+ is_correct` | `false` → CHECK rejects |
| `+ correct` | `false` → CHECK rejects |
| `+ answer` | `false` → CHECK rejects |
| `+ rationale` | `false` → CHECK rejects |

Because the constraint is an exact-key allowlist rather than a denylist, **any** future answer-shaped key
is rejected without needing to be enumerated. `byoq_items_ready_is_complete` additionally blocks `ready`
status while `jsonb_array_length(leak_flags) <> 0`.

Frontend rule is enforced in code, not only convention: `src/lib/byoq/scaffold.ts` carries the product rule
("BYOQ never grades, submits, or shows a correct answer"), with `src/lib/__tests__/byoq-no-grading.test.ts`
and the no-graded-import test standing behind it.

Deployed Production `byoq` function: **v2**, `verify_jwt=false` (expected — anonymous owner keys),
`ezbr_sha256 5c2b4b00…4735`, deployed 2026-09-28.

## §5.2 — Live copy states retention/privacy behavior

**Partly verified. The marketing page is accurate; the privacy policy has not caught up.**

`https://cramapple.com` (fetched 2026-09-30) states:

- "Questions you add without an account are deleted after 30 days of inactivity."
- "Location data is removed from photos."
- "Snap a photo of it or paste it in — no account needed. We won't answer it for you."

All three match the implementation: the purge keys on `byoq_owners.last_seen_at`, EXIF/GPS stripping
fails closed, and §5.1 above establishes the no-answer claim.

**Finding B1 (open).** `https://cramapple.com/privacy`, **last updated 2026-08-22 — five weeks before BYOQ
shipped on 2026-09-28** — documents neither the 30-day anonymous purge nor EXIF/location stripping. It says
only that data is kept "for as long as needed." That is not false, but the specific commitment a student
reads on the homepage is absent from the document that is supposed to govern it.

**Finding B2 (open).** The same policy says "Some student-submitted questions may be eligible for public,
anonymous publication if that feature is enabled and the submission passes the required product checks."
No publication path exists — RLS is owner-only in both schema and policy. The clause is conditional so it
is not false today, but it describes a capability the product does not have.

## §5.3 — Retention mechanism

The purge is scheduled and healthy, but **it has never deleted anything.**

- `cron.job` id 4 `task0039-byoq-purge`, `7,22,37,52 * * * *`, active. 190 runs in 48h, all `succeeded`.
- `cron.job` id 3 `task0039-expire-byoq-pairings`, `*/15 * * * *`, active. 191 runs, all `succeeded`.
- The cron row succeeding only proves `app.byoq_invoke_purge()` returned; it dispatches via pg_net. The
  actual HTTP results in `net._http_response` are **200**, body `{"status":"ok","operation":"purge",
  "result":{"purged_owners":0,"swept_captures":0}}`. So the edge function really is being reached.

**Finding B3 (open).** Every purge has returned zero. BYOQ launched 2026-09-28; Production holds **1**
anonymous owner row, oldest `last_seen_at` 2026-09-28, and **0** rows older than 30 days. The 30-day
deletion path is therefore **wired and reachable but never exercised on real data** — the first genuine
purge falls around 2026-10-28. The homepage promise is not yet demonstrated, only plumbed.

## Not verified

- **Real-phone QR capture on Production.** Needs a physical phone; carried over from TASK-0039's own
  follow-up list. **Not an AI-testable check** — David or Orly.
- **In-app `/byoq` screen copy.** `app.cramapple.com` is disallowed to the fetch tool by robots.txt. The
  backend contract and the marketing copy are verified; the in-app wording at the moment of submission is not.
- Rate-limit behavior under real load. `BYOQ_IP_HMAC_KEY` is still unset (TASK-0039 known limit), so IP
  hashing falls back to the service-role key.

## For David's risk decision (§5 item 3)

B1 and B2 are privacy-document accuracy, not product defects — a policy refresh, not a code change.
B3 is a timing fact, not a fault. None of the three is a launch stop condition on the runbook's own list.
Recorded rather than silently accepted, per §5's instruction.
