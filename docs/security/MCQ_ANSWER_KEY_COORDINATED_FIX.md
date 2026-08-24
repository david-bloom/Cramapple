# MCQ Answer-Key Exposure — Coordinated Fix

STATUS: staged (PART 1 written, not applied) | DATE: 2026-08-24 | OWNER: David

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
Promote this to a migration (e.g. `20260824060000_revoke_mcq_answer_key_from_authenticated.sql`)
and apply to Dev + Prod only AFTER the repointed reviewer front-end is published:

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
