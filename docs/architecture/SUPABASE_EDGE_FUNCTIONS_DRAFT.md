# Cramapple Supabase Edge Functions Draft

**Status:** Draft for production plumbing
**Date:** 2026-06-20
**Project:** `pcntajvbdfqhbeewmdry`

## 1. Purpose

This document defines the intended Supabase Edge Function boundary for
Cramapple production.

The goals are to:

- keep browser code free of privileged secrets;
- centralize session orchestration and assessment submission;
- make grading, publishing, and storage operations server-authoritative;
- support idempotent retries and safe recovery;
- keep the draft aligned with the Supabase schema and RLS plan.

This document is a draft, not a deployment record.

## 2. Function Design Principles

1. The browser may request actions, but it does not authoritatively grade,
   publish, or grant access.
2. Supabase Auth establishes identity; Edge Functions enforce role and ownership
   rules before privileged work proceeds.
3. The service role key remains server-side only.
4. Every mutating request must support idempotency.
5. Grading and publish operations must record audit-safe metadata.
6. Student response text and grading outputs must never be sent to marketing
   systems.
7. The function layer should stay thin and orchestration-focused. Domain logic
   belongs in versioned services or database procedures, not in the browser.

## 3. Draft Function Catalog

### 3.1 `evaluate-attempt`

Primary purpose:

- grade initial FRQ attempts;
- select or generate the repair focus;
- grade revised attempts;
- grade transfer attempts.

Supported operations:

- `grade_initial_attempt`
- `select_repair`
- `grade_revision`
- `grade_transfer_attempt`

Required request fields:

- `operation`
- `idempotency_key`
- `attempt_id`
- `response_version_id`
- `content_item_id`
- `content_item_version_id`
- `rubric_version_id`
- `assistance_condition`
- `prompt_version`

Expected server behavior:

- verify the caller is authenticated or otherwise authorized for the target
  session;
- load released content and rubric versions from the database;
- enforce rate limits and the daily spend cap before any model request;
- call the model provider only from the server side;
- persist the grading result, usage, and audit trail;
- return only the structured grading result needed by the client.

Notes:

- This function is the main student-facing backend entrypoint for the beta
  assessment loop.
- It must support safe retries without creating duplicate grades.

### 3.2 `session-event`

Primary purpose:

- create anonymous sessions;
- start and resume study sessions;
- save autosave state;
- end a session;
- attach an anonymous session to an authenticated account after login.

Current implementation note:

- the production schema in this repository currently supports the authenticated
  `learning_sessions` lifecycle;
- anonymous-session attachment remains a draft-only contract until supporting
  schema tables and migrations are added.

Draft operations:

- `session_start`
- `session_save`
- `session_end`
- `session_resume`
- `attach_anonymous_session`

Required request fields:

- `operation`
- `idempotency_key`
- `session_id`
- `anonymous_session_token` when starting anonymous use
- `study_session_id`
- `payload`

Expected server behavior:

- hash any anonymous token before storing it;
- keep the original anonymous identifier for audit lineage;
- reject attempts to read or mutate another user's session;
- preserve incomplete work across retries and network failure;
- write a minimal analytics event without storing raw answers.

### 3.3 `storage-sign-url`

Primary purpose:

- issue short-lived signed upload or download URLs for private storage.

Draft operations:

- `sign_upload`
- `sign_download`
- `sign_delete` for internal cleanup only

Required request fields:

- `bucket`
- `path`
- `mode`
- `expires_in`
- `idempotency_key`

Expected server behavior:

- verify the caller may access the target path;
- restrict signed access to the narrowest bucket and object scope;
- never issue public object URLs for protected learner uploads.

### 3.4 `admin-content`

Primary purpose:

- support draft creation, editing, validation, publish, retire, and rollback
  workflows for content staff.

Draft operations:

- `create_draft`
- `update_draft`
- `publish`
- `retire`
- `unpublish`
- `bulk_import`

Required request fields:

- `operation`
- `idempotency_key`
- `content_item_id`
- `content_item_version_id`
- `exam_pack_version_id`
- `payload`

Expected server behavior:

- require a privileged role such as `admin` or `content_author` as appropriate;
- validate that content is complete and internally consistent before publish;
- reject incomplete media or malformed question structures;
- write audit events for every state transition.

## 4. Shared Runtime Rules

### 4.1 Environment Variables

Required server-side variables:

- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`
- `SUPABASE_SERVICE_ROLE_KEY`

Likely future variables:

- `OPENAI_API_KEY`
- `OPENAI_MODEL`
- `OPENAI_MAX_RETRIES`
- `OPENAI_DAILY_CAP_USD`
- `OPENAI_INPUT_PRICE_PER_1M`
- `OPENAI_OUTPUT_PRICE_PER_1M`

### 4.2 Common Request Headers

Every mutating call should accept:

- `Authorization`
- `X-Idempotency-Key`
- `X-Request-Id`

### 4.3 Common Response Rules

Responses should be:

- JSON;
- explicit about `status`;
- safe to display if the function fails;
- small enough for mobile clients and retry flows.

### 4.4 Error Classes

Draft functions should distinguish:

- unauthorized;
- forbidden;
- not found;
- invalid input;
- rate limited;
- budget capped;
- conflict / duplicate;
- temporary upstream failure;
- validation failure.

## 5. Security and Authorization

The edge boundary must enforce:

- authenticated student access for student-owned records;
- role-based access for content and admin actions;
- session ownership for anonymous work;
- object-level access for private storage.

The browser should never receive:

- service role credentials;
- private prompts;
- raw provider keys;
- unrestricted storage credentials.

## 6. Draft File Layout

Recommended structure:

```text
supabase/functions/
  _shared/
    cors.ts
    supabase.ts
    auth.ts
    types.ts
  evaluate-attempt/
    index.ts
  session-event/
    index.ts
  storage-sign-url/
    index.ts
  admin-content/
    index.ts
```

## 7. Implementation Notes

- Keep the grading function as a thin router over versioned prompt and rubric
  records.
- Keep the session function responsible for identity, ownership, and recovery,
  not pedagogy.
- Keep the storage function narrowly scoped to private uploads and content
  assets.
- Keep the admin content function responsible for lifecycle transitions only,
  not authoring ergonomics.

## 8. Open Follow-Ups

- Decide whether `content-ingest` should be separate from `admin-content`.
- Decide whether content bulk upload should live in Edge Functions or a Vercel
  server route.
- Decide whether grading calls should use a single function with an operation
  field or one function per grading mode.
- Decide whether anonymous session attachment should be an Edge Function or a
  server route alongside auth callbacks.
