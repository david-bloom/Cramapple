# Reviewer Portal Rewrite Mapping Spec — content_review_* Canonical Path

**Scope:** Replace frontend `review.functions.ts` reads/writes that still target
legacy `review_assignments`, `review_decisions`, `has_role()`, or `user_roles`
with the Production `content_review_*` review pipeline.

**Live verification note:** This session could not query Production directly:
Supabase MCP returned `MCP error -32600: You do not have permission to perform
this action` for function lists, logs, and SQL. The spec below is verified
against repo migrations and Edge Function source, and includes exact SQL probes
for a Production-capable operator.

**Round-2 deploy note:** A later live check found deployed `review-queue` version
4 did **not** yet return `scope`, `review_queue_scope`, or
`can_see_all_pending`, and always filtered by `reviewer_id`. The current repo
source does implement those fields and the admin/all-pending branch. Treat this
spec as the target contract for the rewrite, but redeploy `review-queue` before
depending on it in Production.

## Canonical Rule

The reviewer portal must use:

- `review-queue` Edge Function for queue/submission reads.
- `review-decision` Edge Function for decision submission.
- `app.profiles.role` and `app.profiles.review_queue_scope` for authorization
  shape.

Do not query the legacy governance workflow for this UI:

- `app.review_assignments`
- `app.review_decisions`
- `has_role(...)`
- `user_roles`

## Role Mapping

| Old frontend assumption | New Production contract |
| --- | --- |
| `has_role(user_id, 'admin')` | `profiles.role = 'admin'` |
| `has_role(user_id, 'tutor')` | `profiles.role = 'tutor'` |
| `has_role(user_id, 'reader')` | `profiles.role = 'reader'` |
| `user_roles` table | No table; read `app.profiles.role` through server code |
| Admin can see all pending reviews | `profiles.review_queue_scope = 'all_pending'` |
| Reviewer sees own queue only | default `profiles.review_queue_scope = 'my_queue'` |

Frontend should not reimplement role checks with direct table reads. Let
`review-queue` / `review-decision` enforce `admin | tutor | reader`.

## Queue / Submissions Read Mapping

Preferred call:

```ts
await supabase.functions.invoke("review-queue", { method: "GET" });
```

The function returns:

```ts
{
  status: "ok",
  function: "review-queue",
  reviewer: {
    reviewer_id,
    reviewer_role,
    reviewer_name,
    review_queue_scope,
    can_see_all_pending
  },
  scope: "mine" | "all_pending",
  queue: ReviewQueueItem[],
  counts: Record<string, number>
}
```

### Old → New Field Mapping

| Old query / field | New source |
| --- | --- |
| `review_assignments.assignment_id` | `content_review_assignments.content_review_assignment_id` |
| `review_assignments.artifact_version_id` | `content_review_assignments.content_item_version_id` |
| `review_assignments.assigned_reviewer_id` | `content_review_assignments.reviewer_id` |
| `review_assignments.review_type` | `content_review_assignments.review_stage` |
| `review_assignments.status` | `content_review_assignments.status` |
| `review_assignments.due_at` | `content_review_assignments.due_at` |
| `review_decisions.review_decision_id` | `content_review_decisions.content_review_decision_id` |
| `review_decisions.assignment_id` | `content_review_decisions.content_review_assignment_id` |
| `review_decisions.difficulty_label` | `content_review_decisions.difficulty_label` |
| `review_decisions.score` | `content_review_decisions.tutor_score` |
| `review_decisions.decision` | stage-specific fields: `reader_decision`, `answer_approval`, `canonical_decision`, or `tutor_score` |
| nested artifact version content | `queue[].artifact` from `content_item_versions` + `content_items` |
| answer options | `queue[].artifact.mcq_choices` |
| FRQ rubric criteria | `queue[].artifact.frq_criteria` |

### Queue Item Shape To Use

```ts
type ReviewQueueItem = {
  content_review_assignment_id: string;
  assigned_role: string | null;
  reviewer_id: string;
  reviewer_name: string | null;
  reviewer_role: string | null;
  review_stage:
    | "tutor_question"
    | "tutor_answer"
    | "tutor_frq_canonical"
    | "reader_question";
  review_kind: "mcq" | "frq" | null;
  blind_group_id: string | null;
  due_at: string | null;
  status: "pending" | "in_progress" | "submitted" | "skipped" | string;
  created_at: string;
  artifact: {
    content_item_version_id: string;
    content_item_id: string;
    version_num: number;
    content_key: string | null;
    item_type: "mcq" | "frq" | "quantitative" | string | null;
    title: string | null;
    stem: string;
    stimulus: string | null;
    explanation: string | null;
    frq_form: string | null;
    review_status: string | null;
    mcq_choices: Array<{
      content_item_version_id: string;
      choice_key: string;
      choice_text: string;
      is_correct: boolean;
      rationale: string | null;
    }>;
    frq_criteria: Array<{
      content_item_version_id: string;
      criterion_key: string;
      learner_facing_text: string;
      points_possible: number;
    }>;
  } | null;
  decisions: unknown[];
  sibling_decisions: unknown[];
  review_labels: unknown[];
};
```

## Decision Write Mapping

Preferred call:

```ts
await supabase.functions.invoke("review-decision", {
  body: {
    content_review_assignment_id,
    ...stageSpecificPayload
  }
});
```

The function accepts `assignment_id` / `assignmentId` aliases, but the rewrite
should use `content_review_assignment_id` explicitly.

### Stage-Specific Payloads

| Stage | Required fields | Optional fields |
| --- | --- | --- |
| `tutor_question` | `content_review_assignment_id`, `tutor_score`, `difficulty_label` | `diagnostic_flag`, `concern_codes`, `note`, `topic_selections`, `supersedes_id` |
| `tutor_answer` | `content_review_assignment_id`, `answer_approval` | `answer_key`, `note`, `supersedes_id` |
| `tutor_frq_canonical` | `content_review_assignment_id`, `canonical_decision` | `note`, `supersedes_id` |
| `reader_question` | `content_review_assignment_id`, `reader_decision` | `note`, `supersedes_id` |

Valid values:

- `tutor_score`: `1 | 2 | 3`
- `difficulty_label`: `"Easy" | "Moderately easy" | "Medium" | "Hard" | "Very hard"`
- `answer_approval`: `"approved" | "rejected"`
- `canonical_decision`: `"approved" | "rejected" | "edited"`
- `reader_decision`: `"agree" | "disagree"`

Do not update decision rows in place. Decisions are append-only. To revise, send
`supersedes_id` and insert a new decision through `review-decision`.

## Direct Table Fallback

If the rewrite temporarily needs direct reads, use the curated public views only:

- `public.content_review_assignments`
- `public.content_review_decisions`

Avoid direct writes from the browser. The canonical write path is
`review-decision`, which validates stage-specific payloads, enforces assignment
ownership/admin access, inserts the immutable decision, marks the assignment
`submitted`, and advances downstream workflow.

## Production Verification SQL

Run these against `pcntajvbdfqhbeewmdry` with a Production-capable account:

```sql
select table_schema, table_name
from information_schema.tables
where table_schema in ('app', 'public')
  and table_name in (
    'review_assignments',
    'review_decisions',
    'content_review_assignments',
    'content_review_decisions',
    'profiles'
  )
order by table_schema, table_name;

select table_schema, table_name, column_name, data_type
from information_schema.columns
where table_schema = 'app'
  and table_name in (
    'content_review_assignments',
    'content_review_decisions',
    'profiles'
  )
order by table_name, ordinal_position;

select routine_schema, routine_name
from information_schema.routines
where routine_name = 'has_role';

select grantee, table_schema, table_name, privilege_type
from information_schema.role_table_grants
where table_schema in ('app', 'public')
  and table_name in ('content_review_assignments', 'content_review_decisions')
  and grantee in ('anon', 'authenticated', 'service_role')
order by table_schema, table_name, grantee, privilege_type;
```

Expected outcome:

- `app.content_review_assignments` and `app.content_review_decisions` exist.
- `public.content_review_assignments` and `public.content_review_decisions` exist
  if the curated interface migration is applied.
- No frontend rewrite should depend on `has_role`, even if a routine exists.
- `anon` has no grants on the curated views after the revoke-anon hardening
  migration.
