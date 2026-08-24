# MCQ Answer-Key Exposure — Coordinated Fix

STATUS: ✅ COMPLETE on Dev AND Prod — leak closed & verified | DATE: 2026-08-24 | OWNER: David

## Done — Dev + Prod (2026-08-24, session 3)

The full three-part sequence was executed and verified on **both** Dev
(`wmgjsdkphcyhngaffbqf`) and Prod (`pcntajvbdfqhbeewmdry`), in order (PART 1 → publish
PART 2 → PART 3):
- **PART 1** — RPC `public.get_review_mcq_choices` applied to both envs; verified
  (SECURITY DEFINER, pinned search_path, correct return shape, `authenticated` may
  execute / `anon` may not, runs clean). Migration
  `20260824040000_reviewer_mcq_answer_key_rpc.sql`.
- **PART 2** — `review.functions.ts` reviewer read repointed at the RPC in Lovable
  (project `d334fed9`, commit `963aa34`, one-line diff) and **published** to
  `exam-buddy-wireframe.lovable.app`.
- **PART 3** — the CORRECTED revoke+regrant applied to both envs; promoted to migration
  `20260824060000_revoke_mcq_answer_key_from_authenticated.sql`.

**Verification (both envs), as the `authenticated` role:** `is_correct` → permission
denied (**leak closed**); `choice_key` → readable (**student serving path intact**).
Reviewer RPC still returns the key — positively confirmed on Prod against a real assigned
MCQ reviewer (RPC returned the full 4-row key post-revoke; Prod has 1,621 active MCQ
review assignments).

**Discovery (important):** the originally-staged PART 3 (a column-level revoke) was a
**no-op** — `authenticated` held a TABLE-level SELECT (`authenticated=r`) on both envs,
which a column revoke can't subtract from (proven live on Dev). The corrected fix (below)
drops the table-wide grant and re-grants only the non-secret columns.

**Note:** on Prod, a separate `content_reviewer` role also holds table-level SELECT — a
reviewer/back-office role, not student-assumable — left untouched.

**`content_reviewer` reachability CONFIRMED not student-exposed (2026-08-24, verified live
on Prod).** `content_reviewer` has `rolcanlogin = false`, and the PostgREST login role
`authenticator` is **not** a member of it, so no client JWT (`"role":"content_reviewer"`)
can `SET ROLE` into it — a request claiming that role fails at the gateway. Its only
members are `postgres` (owner/superuser). So its residual table-level SELECT on
`app.mcq_choices` is an owner/back-office grant, not a student-reachable path to the
answer key. Nothing to change.

**Post-fix re-verification (2026-08-24, read-only).** Re-confirmed the closed state
directly against both envs: no table-level SELECT for `authenticated`/`anon` on
`app.mcq_choices`; `authenticated` holds column SELECT on exactly the 5 non-secret
columns (`id, content_item_version_id, choice_key, choice_text, created_at`) and **not**
`is_correct`/`rationale`; as the `authenticated` role, `has_column_privilege` returns
false for `is_correct`/`rationale` and true for `choice_key`; and
`public.get_review_mcq_choices(uuid)` exists (SECURITY DEFINER, `authenticated` EXECUTE /
`anon` no). Leak remains closed on Prod and Dev.

## Verification (2026-08-24, session 3 — read-only, nothing applied)

All three parts were checked against live Dev (`wmgjsdkphcyhngaffbqf`), live Prod
(`pcntajvbdfqhbeewmdry`), and the `exam-buddy-wireframe` frontend (`HEAD a9b2c0c`):

- **Exposure still live on BOTH envs.** `authenticated` holds `SELECT` on
  `is_correct` + `rationale` on `app.mcq_choices` in Dev and Prod. `anon` holds no
  such grant (the PART 3 `anon` clause is a harmless no-op).
- **PART 1 RPC verified correct.** Referenced objects all exist on both envs:
  `content_review_assignments(reviewer_id, status, content_item_version_id)`,
  `profiles.role`, and the four `mcq_choices` columns. `profiles.role` is a **text**
  column whose CHECK includes `admin`, so `role = 'admin'` is safe (no enum-cast
  error). The RPC's reviewer branch (`status in pending/in_progress/submitted`) is
  **behavior-identical to the existing RLS** policy `mcq_choices_select_assigned_reviewer`
  (same three statuses) → no reviewer regression. The added admin branch matches the
  frontend's own admin-can-open-any auth (`review.functions.ts:202-208`) and closes a
  latent gap (an admin opening another reviewer's assignment is currently blinded by
  RLS). The RPC does **not** yet exist on either env. Security hygiene is sound
  (SECURITY DEFINER, `search_path` pinned to `app,pg_temp`, execute revoked from
  `public`/`anon`, granted to `authenticated`/`service_role`).
- **PART 2 target confirmed as the SOLE authenticated reader.** A full frontend grep
  shows the only client-side `authenticated` DB read of `is_correct`/`rationale` is
  `review.functions.ts:221-224` (the exact query the Lovable prompt targets). The two
  other `mcq_choices` mapping sites (`review.functions.ts:80-88`, and the artifact
  path via `normalizeArtifact`) consume data returned by a **service_role edge
  function** (`invokeEdge`), not the column grant, so they are unaffected. The RPC
  returns the identical `{choice_key, choice_text, is_correct, rationale}` shape, so
  the `.map()` at `:252-257` is unchanged → clean drop-in.
- **PART 3 proven safe once PART 2 is live.** The student serving path
  (`use-published-mcq.ts:57`) selects only `mcq_choices!inner(id, choice_key,
  choice_text)` — it never reads the secret columns, so the revoke does not touch
  student serving. No other authenticated reader exists.

Ready-to-apply artifacts: PART 1 is `migrations/20260824040000_reviewer_mcq_answer_key_rpc.sql`;
PART 3 is staged at `docs/security/part3_revoke_mcq_answer_key.sql` (kept OUT of
`migrations/` on purpose). Applies are held for David's explicit per-step go.

## The exposure

`app.mcq_choices` grants column `SELECT` on **`is_correct`** and **`rationale`** to
the `authenticated` role on **both Dev (`wmgjsdkphcyhngaffbqf`) and Prod
(`pcntajvbdfqhbeewmdry`)**. `public.mcq_choices` is `security_invoker=true`, and RLS
policy `mcq_choices_select_published` returns any published item's choices to any
logged-in user. Net: **any authenticated student can read the correct-answer key for
every published MCQ.** Proven live on Prod 2026-08-24 (an authenticated read returned
`is_correct=true` for the correct choice + rationales). Same class as the #103
`grading_results` leak.

Practical risk is currently low (the app UI never shows students the key — the leak
needs a hand-crafted PostgREST call — and there are zero real students), but it is a
real hole in the live serving surface.

## Why a plain revoke is NOT safe

The reviewer UI reads the same secret columns through the same `authenticated` grant:
`exam-buddy-wireframe/src/lib/review.functions.ts` does
`sb.from("mcq_choices").select("choice_key, choice_text, is_correct, rationale")`,
and its `sb` is built from the **publishable key + the reviewer's Bearer token**
(`src/integrations/supabase/auth-middleware.ts`) — role `authenticated`. Reviewers get
their rows via `mcq_choices_select_assigned_reviewer` RLS, but read the columns via the
shared grant. A blanket `REVOKE ... FROM authenticated` closes the student leak **and
blinds reviewers** to the key of items under review. Postgres column grants can't
distinguish reviewer-on-assigned from student-on-published (RLS is row-level; there is
no per-user DB role). The only complete fix routes the reviewer read through a
SECURITY DEFINER RPC that checks assignment — a coordinated backend + front-end change.

## The three parts (do NOT reorder)

### PART 1 — backend RPC (additive, safe anytime) ✅ written
`supabase/migrations/20260824040000_reviewer_mcq_answer_key_rpc.sql` adds
`public.get_review_mcq_choices(uuid)` — returns `is_correct`/`rationale` only to an
assigned reviewer (pending/in_progress/submitted) or an admin. SECURITY DEFINER, so it
keeps working after PART 3. Apply to Dev + Prod first.

### PART 2 — repoint the reviewer front-end (Lovable, then publish)
In `exam-buddy-wireframe`, change the reviewer artifact loader in
`src/lib/review.functions.ts` (~line 221) from the direct table read to the RPC. The
RPC returns the identical row shape, so the downstream mapping is unchanged.

**Lovable prompt:**

> In `src/lib/review.functions.ts`, the reviewer artifact loader currently reads the
> MCQ answer key directly:
> ```ts
> sb.from("mcq_choices")
>   .select("choice_key, choice_text, is_correct, rationale")
>   .eq("content_item_version_id", versionId)
> ```
> Replace **only that one query** with a call to the new Postgres RPC
> `get_review_mcq_choices`, which returns the same columns
> (`choice_key, choice_text, is_correct, rationale`) but only for the caller's
> assigned items (or admin):
> ```ts
> sb.rpc("get_review_mcq_choices", { p_content_item_version_id: versionId })
> ```
> The result is still an array of `{ choice_key, choice_text, is_correct, rationale }`,
> so leave the mapping that builds `mcq_choices` on the artifact unchanged. Do not
> touch the student serving path (`usePublishedMcqs`) — it never selects those columns.
> This is a prerequisite for a backend change that revokes student read access to the
> answer key; after this ships, reviewers must get the key via this RPC, not the table.

Verify in the reviewer UI that an assigned item still shows the keyed-correct choice
and rationales before proceeding to PART 3.

### PART 3 — close the leak (apply LAST, after PART 2 is live) — CORRECTED
**A column-level revoke does NOT work here.** `authenticated` holds a **table-level**
SELECT grant (ACL `authenticated=r`, on both Dev and Prod), which confers every column;
`revoke select (is_correct, rationale) ... from authenticated` is a no-op against it
(proven live on Dev — the column read still succeeded after it). The correct fix drops
the table-wide SELECT and re-grants only the non-secret columns.

The corrected SQL is staged at `docs/security/part3_revoke_mcq_answer_key.sql` (kept OUT
of `supabase/migrations/` so it can't be db-pushed to Prod before PART 2 lands). Promote
to a migration or run directly, on Dev + Prod, only AFTER the repointed reviewer
front-end is published:

```sql
begin;
revoke select on app.mcq_choices from authenticated;
grant select (id, content_item_version_id, choice_key, choice_text, created_at)
  on app.mcq_choices to authenticated;
commit;
```

`anon` holds no grant on this table (no-op there). On **Prod** an extra role
`content_reviewer` also has table-level SELECT — a reviewer/back-office role, NOT
student-assumable, so left as-is (confirm its purpose).

Post-checks (A: no table-level grant; B: secret columns absent; C: functional):
```sql
-- A
select privilege_type from information_schema.role_table_grants
where table_schema='app' and table_name='mcq_choices' and grantee='authenticated';  -- expect: none
-- B
select column_name from information_schema.column_privileges
where table_schema='app' and table_name='mcq_choices'
  and grantee='authenticated' and privilege_type='SELECT' order by column_name;      -- expect: no is_correct/rationale
-- C
set local role authenticated;
select is_correct from app.mcq_choices limit 1;   -- expect: permission denied
select choice_key from app.mcq_choices limit 1;   -- expect: OK
reset role;
```

## Verification after all three parts
- Student (non-reviewer) `select is_correct from public.mcq_choices where <published item>` → **0 cols / permission denied**.
- Assigned reviewer `rpc('get_review_mcq_choices', {p_content_item_version_id})` → returns the key.
- Student serving read (`usePublishedMcqs`) → unaffected (never selected those columns).
