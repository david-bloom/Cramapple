# MCQ Answer-Key Exposure — Coordinated Fix

STATUS: verified & ready to sequence (PART 1 written + verified, PART 3 staged; nothing applied) | DATE: 2026-08-24 | OWNER: David

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

### PART 3 — revoke the broad grant (apply LAST, after PART 2 is live)
The revoke is staged, ready to run, at `docs/security/part3_revoke_mcq_answer_key.sql`
(kept OUT of `supabase/migrations/` on purpose so it can't be db-pushed to Prod before
PART 2 lands). Promote it to a migration (e.g.
`20260824060000_revoke_mcq_answer_key_from_authenticated.sql`) or run it directly, on
Dev + Prod, only AFTER the repointed reviewer front-end is published. Contents:

```sql
begin;
-- Close the student answer-key leak. Reviewers now read is_correct/rationale via
-- public.get_review_mcq_choices (SECURITY DEFINER), so this no longer blinds them.
revoke select (is_correct, rationale) on app.mcq_choices from authenticated, anon;
commit;
```

Post-check (should return no `authenticated` grant on the two columns):
```sql
select grantee, string_agg(privilege_type||':'||column_name, ', ')
from information_schema.column_privileges
where table_schema='app' and table_name='mcq_choices'
  and grantee in ('authenticated','anon') and column_name in ('is_correct','rationale')
group by grantee;
```

## Verification after all three parts
- Student (non-reviewer) `select is_correct from public.mcq_choices where <published item>` → **0 cols / permission denied**.
- Assigned reviewer `rpc('get_review_mcq_choices', {p_content_item_version_id})` → returns the key.
- Student serving read (`usePublishedMcqs`) → unaffected (never selected those columns).
