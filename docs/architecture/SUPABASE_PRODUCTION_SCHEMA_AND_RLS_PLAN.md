# Cramapple Supabase Production Schema, RLS, and Storage Plan

**Status:** Draft for production plumbing
**Date:** 2026-06-20
**Project:** `pcntajvbdfqhbeewmdry`
**Source-of-truth inputs:**

- `docs/architecture/HIGH_LEVEL_SYSTEM_ARCHITECTURE.md`
- `docs/architecture/SYSTEM_CONTEXT_AND_LOGICAL_COMPONENT_ARCHITECTURE.md`
- `docs/architecture/CONTENT_GOVERNANCE_AND_VALIDATION.md`
- `docs/tasks/TASK-0012-PRODUCTION-PLUMBING-AND-CUTOVER.md`

## 1. Purpose

This document defines the exact Supabase shape for the production identity,
session, attempt, grading, progress, audit, and storage boundary for
Cramapple. It is written for a fresh production project and assumes:

- Supabase Auth is the identity authority.
- Supabase PostgreSQL is the durable system of record.
- Supabase RLS is mandatory on every exposed application table.
- Supabase Storage is private by default.
- Lovable is frontend-only and must not receive privileged keys.

This document does not deploy anything. It is the implementation plan to use
when creating migrations, policies, buckets, and server-side functions for the
operational learning boundary.

## 2. Schema Strategy

Use a dedicated application schema named `app` for all first-party tables and
views.

Recommended grants:

- `anon`: no table access unless an explicit read-only public exam metadata
  surface is approved.
- `authenticated`: read narrow student-safe surfaces and write only to
  self-owned operational tables through the row policies and server-side
  protections described below.
- `service_role`: full access for server-side code and administrative jobs.

Reasoning:

- keeps the application model separate from Supabase-managed schemas;
- reduces accidental exposure through the default public Data API surface;
- makes it easier to control which tables are meant for browser read access.

## 3. Core Tables

### 3.1 `app.profiles`

Purpose: one row per authenticated account.

Columns:

- `user_id uuid primary key references auth.users(id) on delete cascade`
- `full_name text not null`
- `role text not null default 'student'`
- `timezone text`
- `locale text`
- `onboarding_completed_at timestamptz`
- `created_at timestamptz not null default now()`
- `updated_at timestamptz not null default now()`

Role values:

- `student`
- `content_author`
- `validator`
- `support`
- `admin`

Notes:

- Users may update `full_name`, `timezone`, and `locale`.
- Users may not update `role`.
- `role` is provisioned server-side only.

### 3.2 `app.subjects`

Purpose: canonical subject registry shared across exam packs and coverage
targets.

Columns:

- `id uuid primary key default gen_random_uuid()`
- `subject_key text not null unique`
- `display_name text not null`
- `status text not null default 'active'`
- `created_at timestamptz not null default now()`
- `updated_at timestamptz not null default now()`

Status values:

- `active`
- `retired`

### 3.3 `app.exam_packs`

Purpose: stable subject-level exam container.

Columns:

- `id uuid primary key default gen_random_uuid()`
- `exam_code text not null unique`
- `exam_name text not null`
- `subject_id uuid not null references app.subjects(id)`
- `created_at timestamptz not null default now()`
- `updated_at timestamptz not null default now()`

Example:

- `exam_code = 'ap_biology'`
- `exam_name = 'AP Biology'`
- `subject_id -> app.subjects.id`

### 3.4 `app.exam_pack_versions`

Purpose: year-specific authoritative exam pack release.

Columns:

- `id uuid primary key default gen_random_uuid()`
- `exam_pack_id uuid not null references app.exam_packs(id) on delete cascade`
- `school_year text not null`
- `official_exam_date date not null`
- `status text not null`
- `source_uri text`
- `source_published_at date`
- `released_at timestamptz`
- `retired_at timestamptz`
- `created_by uuid references app.profiles(user_id)`
- `created_at timestamptz not null default now()`
- `updated_at timestamptz not null default now()`

Status values:

- `draft`
- `published`
- `retired`

### 3.5 `app.content_labels`

Purpose: reusable topical or operational labels.

Columns:

- `id uuid primary key default gen_random_uuid()`
- `exam_pack_id uuid not null references app.exam_packs(id) on delete cascade`
- `label_key text not null`
- `label_name text not null`
- `label_type text not null`
- `status text not null default 'draft'`
- `created_by uuid references app.profiles(user_id)`
- `created_at timestamptz not null default now()`
- `updated_at timestamptz not null default now()`

Label types:

- `topic`
- `unit`
- `skill`
- `difficulty`
- `workflow`

### 3.6 `app.content_items`

Purpose: stable logical content entity.

Columns:

- `id uuid primary key default gen_random_uuid()`
- `exam_pack_version_id uuid not null references app.exam_pack_versions(id) on delete cascade`
- `content_key text not null`
- `item_type text not null`
- `title text not null`
- `status text not null default 'draft'`
- `created_by uuid references app.profiles(user_id)`
- `created_at timestamptz not null default now()`
- `updated_at timestamptz not null default now()`

Item types:

- `mcq`
- `frq`
- `quantitative`

Status values:

- `draft`
- `published`
- `retired`

### 3.7 `app.content_item_versions`

Purpose: immutable versioned content body.

Columns:

- `id uuid primary key default gen_random_uuid()`
- `content_item_id uuid not null references app.content_items(id) on delete cascade`
- `version_num integer not null`
- `stem text not null`
- `stimulus text`
- `prompt_json jsonb not null default '{}'::jsonb`
- `explanation text`
- `help_text text`
- `content_hash text not null`
- `status text not null default 'draft'`
- `approved_at timestamptz`
- `approved_by uuid references app.profiles(user_id)`
- `published_at timestamptz`
- `created_by uuid references app.profiles(user_id)`
- `created_at timestamptz not null default now()`
- `updated_at timestamptz not null default now()`

Rules:

- one content item may have many versions;
- one published version is the active student-facing version at a time;
- attempts must always reference the exact version they used.

Note:

- The full content-governance model now lives alongside these operational
  tables in the production migration set. The simplified content tables are
  retained only for compatibility with the student practice loop until the app
  is rewired to the governance tables and manifest flow.

### 3.8 `app.mcq_choices`

Purpose: choices for MCQ versions.

Columns:

- `id uuid primary key default gen_random_uuid()`
- `content_item_version_id uuid not null references app.content_item_versions(id) on delete cascade`
- `choice_key text not null`
- `choice_text text not null`
- `is_correct boolean not null default false`
- `rationale text`
- `created_at timestamptz not null default now()`

Constraints:

- exactly one correct choice per MCQ version.

### 3.9 `app.frq_criteria`

Purpose: criterion-level rubric for FRQ and short-answer versions.

Columns:

- `id uuid primary key default gen_random_uuid()`
- `content_item_version_id uuid not null references app.content_item_versions(id) on delete cascade`
- `criterion_key text not null`
- `learner_facing_text text not null`
- `points_possible integer not null`
- `evidence_requirements text`
- `minimum_fix text`
- `accepted_variants jsonb not null default '[]'::jsonb`
- `created_at timestamptz not null default now()`

### 3.10 `app.content_item_labels`

Purpose: many-to-many labels.

Columns:

- `content_item_id uuid not null references app.content_items(id) on delete cascade`
- `content_label_id uuid not null references app.content_labels(id) on delete cascade`
- `primary key (content_item_id, content_label_id)`

Additional content ingestion and reviewer-workflow tables are introduced in the
production migration layer to support structured uploads and tutor/reader
review routing on top of the normalized subject and artifact tables. These
include `app.content_ingest_batches`, `app.content_ingest_rows`,
`app.artifact_label_assignments`, `app.content_review_assignments`,
`app.content_review_assignment_labels`, `app.content_review_decisions`, and
the `app.attempts.artifact_version_id` bridge for the student workflow.

The corresponding server-side touchpoints are `content-intake` for upload
batch ingestion, `review-queue` for reviewer assignment reads, and
`review-decision` for locked reviewer submissions.

### 3.11 `app.learning_sessions`

Purpose: a user-visible study session.

Columns:

- `id uuid primary key default gen_random_uuid()`
- `user_id uuid not null references app.profiles(user_id) on delete cascade`
- `exam_pack_version_id uuid not null references app.exam_pack_versions(id)`
- `entry_path text not null`
- `session_mode text not null`
- `available_minutes integer not null`
- `status text not null default 'active'`
- `started_at timestamptz not null default now()`
- `ended_at timestamptz`
- `created_at timestamptz not null default now()`
- `updated_at timestamptz not null default now()`

Entry paths:

- `recommend`
- `topic`
- `check_work`
- `bring_question`

Session modes:

- `quick`
- `focused`
- `buckle_down`

### 3.11 `app.attempts`

Purpose: immutable submission record for MCQ, FRQ, or quantitative work.

Columns:

- `id uuid primary key default gen_random_uuid()`
- `user_id uuid not null references app.profiles(user_id) on delete cascade`
- `learning_session_id uuid references app.learning_sessions(id) on delete set null`
- `exam_pack_version_id uuid not null references app.exam_pack_versions(id)`
- `content_item_version_id uuid not null references app.content_item_versions(id)`
- `attempt_mode text not null`
- `status text not null default 'draft'`
- `assistance_state text not null default 'independent'`
- `started_at timestamptz not null default now()`
- `submitted_at timestamptz`
- `graded_at timestamptz`
- `score_points integer`
- `score_possible integer`
- `confidence_level text`
- `result_state text`
- `result_summary text`
- `created_at timestamptz not null default now()`
- `updated_at timestamptz not null default now()`

Attempt modes:

- `mcq`
- `frq`
- `quantitative`

Assistance states:

- `independent`
- `coached`
- `exam_practice`

Status values:

- `draft`
- `submitted`
- `grading`
- `graded`
- `uncertain`
- `failed`

### 3.12 `app.attempt_responses`

Purpose: answer text and structured response parts.

Columns:

- `id uuid primary key default gen_random_uuid()`
- `attempt_id uuid not null references app.attempts(id) on delete cascade`
- `part_key text not null`
- `response_text text`
- `response_json jsonb not null default '{}'::jsonb`
- `created_at timestamptz not null default now()`
- `updated_at timestamptz not null default now()`

### 3.13 `app.attempt_criterion_results`

Purpose: criterion-level grading output.

Columns:

- `id uuid primary key default gen_random_uuid()`
- `attempt_id uuid not null references app.attempts(id) on delete cascade`
- `criterion_key text not null`
- `status text not null`
- `points_awarded integer not null default 0`
- `evidence_quote text`
- `decision_explanation text`
- `minimum_fix text`
- `evaluator_version text not null`
- `created_at timestamptz not null default now()`

Status values:

- `earned`
- `not_yet_earned`
- `unable_to_determine`
- `not_applicable`

### 3.14 `app.progress_snapshots`

Purpose: materialized progress views for the student UI.

Columns:

- `id uuid primary key default gen_random_uuid()`
- `user_id uuid not null references app.profiles(user_id) on delete cascade`
- `exam_pack_version_id uuid not null references app.exam_pack_versions(id)`
- `snapshot_kind text not null`
- `snapshot_json jsonb not null`
- `source_version text`
- `generated_at timestamptz not null default now()`

Snapshot kinds:

- `daily`
- `weekly`
- `on_demand`

### 3.15 `app.audit_events`

Purpose: append-only operational and content audit log.

Columns:

- `id uuid primary key default gen_random_uuid()`
- `actor_user_id uuid references app.profiles(user_id)`
- `subject_user_id uuid references app.profiles(user_id)`
- `object_type text not null`
- `object_id uuid`
- `action text not null`
- `payload jsonb not null default '{}'::jsonb`
- `created_at timestamptz not null default now()`

Rules:

- append only;
- no client updates or deletes;
- service-side only writes.

## 4. Recommended Indexes

Create indexes on:

- `app.profiles(role)`
- `app.exam_pack_versions(exam_pack_id, status)`
- `app.content_items(exam_pack_version_id, item_type, status)`
- `app.content_item_versions(content_item_id, status, version_num)`
- `app.learning_sessions(user_id, started_at desc)`
- `app.attempts(user_id, started_at desc)`
- `app.attempts(content_item_version_id)`
- `app.attempt_responses(attempt_id)`
- `app.attempt_criterion_results(attempt_id)`
- `app.progress_snapshots(user_id, generated_at desc)`
- `app.audit_events(subject_user_id, created_at desc)`

## 5. RLS Model

### 5.1 Helper predicates

Use helper functions or equivalent in-policy subqueries for:

- `auth.uid()`
- `app.is_self(user_id)`
- `app.is_staff()`
- `app.is_content_staff()`
- `app.is_validator()`
- `app.is_admin()`

Do not rely on browser state for role checks.

### 5.2 `app.profiles`

Policies:

- `select`: owner can read own profile; staff can read as needed through server-side access only.
- `insert`: authenticated user may create own profile row only.
- `update`: owner may update only self-owned, non-role fields.
- `delete`: none for client; service role only.

Column restrictions:

- forbid client updates to `role`.

### 5.3 `app.exam_packs` and `app.exam_pack_versions`

Policies:

- `select`: authenticated users may read `published` versions only.
- `select` for `anon`: optional, only if the team wants the landing page to show exam metadata before login.
- `insert/update/delete`: service role only, or server-side admin function only.

### 5.4 `app.content_labels`, `app.content_items`, `app.content_item_versions`,
`app.mcq_choices`, `app.frq_criteria`, `app.content_item_labels`

Policies:

- `select`:
  - authenticated students may read published content only;
  - staff may read draft and published content only when acting through server-side access or an approved staff-facing route;
  - `anon` should not read draft content.
- `insert/update/delete`:
  - service role only for production release writes;
  - staff-facing authoring flows should go through server-side functions or privileged routes, not direct browser writes.

Publication rule:

- a content version is student-visible only when the version status is `published`
  and its exam-pack version status is `published`.

### 5.5 `app.learning_sessions`

Policies:

- `select`: owner only.
- `insert`: owner only.
- `update`: owner only while active; service role may update for system actions.
- `delete`: none for client; service role only.

### 5.6 `app.attempts`

Policies:

- `select`: owner only.
- `insert`: owner only.
- `update`: owner may update only while `status = 'draft'` or `status = 'failed'`
  and only before final submission; service role may update for grading and
  correction states.
- `delete`: none for client; service role only.

Hard rule:

- once an attempt is submitted, the client may not mutate the authoritative
  score fields or criterion results.

Add a BEFORE UPDATE trigger that rejects client-side writes to grading-truth
columns unless `current_setting('request.jwt.claim.role', true) = 'service_role'`.
Protected columns include:

- `score_points`
- `score_possible`
- `graded_at`
- `confidence_level`
- `result_state`
- `result_summary`
- status transitions into `graded` or `uncertain`

### 5.7 `app.attempt_responses`

Policies:

- `select`: owner only through attempt ownership.
- `insert/update`: owner only while parent attempt is draft.
- `delete`: none for client; service role only.

### 5.8 `app.attempt_criterion_results`

Policies:

- `select`: owner only through attempt ownership.
- `insert/update/delete`: service role only.

### 5.9 `app.progress_snapshots`

Policies:

- `select`: owner only.
- `insert/update/delete`: service role only.

### 5.10 `app.audit_events`

Policies:

- `select`: service role only, or narrowly scoped admin/support server routes.
- `insert/update/delete`: service role only.

## 6. Storage Plan

### 6.1 Bucket: `content-assets`

Purpose: question images, stimulus files, diagrams, and approved content media.

Settings:

- private bucket
- no public object URLs
- signed URLs required for access

Access:

- write: service role only
- read: server-generated signed URLs only
- browser should not list the bucket directly

Path convention:

- `content/{exam_code}/{content_item_id}/{version_id}/{filename}`

HDR response photos use the same private bucket and should be tracked with
sidecar metadata in Supabase instead of relying on repo-local paths alone.
Recommended HDR path convention:

- `content/{exam_code}/hdr/{content_key}/{capture_version}/{filename}`

Where practical, the HDR photo metadata row should record the storage object
path, the originating ingest row, and the later promoted content item version
if one exists.

### 6.2 Bucket: `learner-uploads`

Purpose: student-submitted images, screenshots, photographs, and documents.

Settings:

- private bucket
- no public object URLs
- signed URLs and short-lived access only

Access:

- write: authenticated user may upload only to a prefix that begins with their
  `user_id`
- read: authenticated user may read own objects only
- service role may read/write for grading, moderation, or recovery

Path convention:

- `{user_id}/{learning_session_id}/{attempt_id}/{uuid}.{ext}`

Rules:

- original upload is immutable after write;
- derived crops, thumbnails, or normalized derivatives must use a separate path;
- storage objects must never be used as a substitute for canonical records.
- configure allowed MIME types and file-size limits explicitly;
- add malware-scanning or quarantine handling in the upload pipeline before
  any file is processed by grading or storage-side workflows.

### 6.3 Bucket: `validation-artifacts`

Purpose: internal validation files, reviewer exports, audit images, and release
evidence.

Settings:

- private bucket
- signed access only

Access:

- write: service role only
- read: validators, release approvers, and support only through server-side
  authorization

Path convention:

- `validation/{artifact_type}/{exam_pack_version_id}/{uuid}`

### 6.4 Optional bucket: `public-marketing`

Use only if a later approved workflow requires public assets.

Rules:

- never store learner data here;
- never store private validation artifacts here;
- keep it separate from student and reviewer files.

## 7. Server-Side Boundary

The browser and Lovable may:

- create and update the signed-in user profile;
- create and resume sessions;
- create attempts and response drafts;
- submit attempts;
- read published content and own progress;
- request signed URLs for allowed assets.

The browser and Lovable may not:

- publish content;
- alter exam-pack versions;
- write audit records;
- change entitlements;
- write grading truth;
- read other users' learner data;
- use service-role credentials.

Any privileged action should go through a server-side route or Edge Function.

Client-facing write paths remain limited to self-owned operational tables and
must not allow direct writes to grading truth, audit rows, content releases, or
entitlement state.

## 8. Deployment and Environment Split

### 8.1 Local

- separate local project or local dev instance
- disposable seed data
- fake or test email only

### 8.2 Beta

- isolated beta project
- short-lived sample data
- no production secrets

### 8.3 Production

- `pcntajvbdfqhbeewmdry`
- real auth
- real learner records
- real content publication workflow

### 8.4 Environment variables

Client-side:

- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`

Server-side only:

- `SUPABASE_SERVICE_ROLE_KEY`
- any email provider key
- any signing or webhook secrets

Never expose server-side secrets to Lovable or the browser.

## 9. Suggested Migration Order

1. Create `app` schema.
2. Create helper functions for staff / owner predicates.
3. Create `profiles`.
4. Create exam pack tables.
5. Create content tables.
6. Create attempt and session tables.
7. Create progress and audit tables.
8. Enable RLS on every table.
9. Add policies.
10. Create private storage buckets.
11. Add storage policies.
12. Add service-side functions for publishing and grading.

## 10. Recommended Cutover Test Cases

- sign up a new student
- sign in and sign out
- reset password
- create a session
- save a draft attempt
- submit an MCQ attempt
- submit an FRQ attempt
- confirm another user cannot read the record
- confirm unpublished content is invisible to students
- confirm storage object access is private

## 11. Open Implementation Notes

- Staff-facing authoring and release flows should be implemented as server-side
  routes or Edge Functions before any direct browser write access is allowed.
- If Google login is added later, it should be treated as an auth provider
  configuration change, not a schema change.
- If future parent access is added, do not reuse student RLS shortcuts; model it
  explicitly.
