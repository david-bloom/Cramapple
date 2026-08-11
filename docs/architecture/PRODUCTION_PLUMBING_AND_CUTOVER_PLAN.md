# Cramapple Production Plumbing and Cutover Plan

**Status:** Draft for production plumbing
**Date:** 2026-06-20
**Project:** `pcntajvbdfqhbeewmdry`
**Source-of-truth inputs:**

- `docs/architecture/HIGH_LEVEL_SYSTEM_ARCHITECTURE.md`
- `docs/architecture/SYSTEM_CONTEXT_AND_LOGICAL_COMPONENT_ARCHITECTURE.md`
- `docs/architecture/SUPABASE_PRODUCTION_SCHEMA_AND_RLS_PLAN.md`
- `docs/architecture/SUPABASE_EDGE_FUNCTIONS_DRAFT.md`
- `docs/tasks/TASK-0012-PRODUCTION-PLUMBING-AND-CUTOVER.md`

## 1. Purpose

This document defines the production plumbing boundary for Cramapple beta to
production cutover. It is the operational companion to the schema, RLS, and
Edge Function drafts.

The goal is to make the following explicit before any cutover:

- which environment owns which responsibility;
- which credentials and accounts are required;
- which server-side boundaries protect learner data and content operations;
- which deployment, rollback, and observability controls must exist;
- which UX-001 and UX-006 conditions must be true before production launch.

This document does not change live secrets, deployments, or provider settings.

## 2. Operating Principles

1. Lovable remains frontend-only and never receives privileged secrets.
2. Lovable may host the presentation layer, but all authoritative backend work
   must live in Vercel or Supabase.
3. Vercel owns application delivery and server-side orchestration.
4. Supabase owns identity, durable data, storage, RLS, and Edge Functions.
5. The browser may request actions, but server code and the database remain authoritative.
6. Beta and production must be isolated by explicit environment config and separate provider resources where practical.
7. No cutover may depend on unreviewed beta state.
8. Any production change must have a rollback path before it is considered ready.

## 2.1 Current Known Gaps

The following issues are known from code review and live beta observation and
must be closed or explicitly accepted before cutover:

- The live beta assessment loop appears to be served from Lovable-hosted
  `_serverFn` traffic rather than the Supabase Edge Function boundary assumed by
  the target architecture. This must be confirmed and, if true, migrated off
  Lovable runtime before production launch.
- Current beta functionality is operating on Lovable Cloud. That is acceptable
  only for the UI/front-end layer; any authoritative backend behavior must be
  migrated into Vercel and Supabase before production cutover.
- Beta traffic may already be writing into the same Supabase project named in
  this plan. If beta and production share resources, the isolation strategy must
  be documented explicitly or separated before cutover.
- The content publishing path currently has known implementation defects in the
  `admin-content` function and governance migrations. Those defects must be
  fixed and verified before content publishing can be treated as cutover-ready.
- Environment startup must fail fast on missing required secrets; silent empty
  defaults are not acceptable for production readiness.

## 3. Environment Split

### 3.1 Environments

| Environment | Purpose | Typical owners | Notes |
| --- | --- | --- | --- |
| Local | Developer iteration and CI checks | Codex, engineers | May use local Supabase and local env files. |
| Preview | Branch-level UI and integration review | Lovable, engineers | Must never carry production secrets. |
| Beta | Product validation and QA | Product, QA, Lovable | Current beta runtime stays frontend-only in the target state. |
| Production | Real learner traffic | Product, ops, backend | Only environment that can support real launch. |

Reference Vercel projects:

- `cramapple-dev` (`prj_Vgjlo4aQKKtDnjw4iMzsT1znT7SQ`) for non-production work.
- `cramapple` (`prj_o6OPEaC541tFdI3VDjfhnLG9TlGG`) for production.

Reference Supabase projects:

- `Cramapple-Development` (`https://wmgjsdkphcyhngaffbqf.supabase.co`) for
  non-production work.
- `Cramapple-Production` (`https://pcntajvbdfqhbeewmdry.supabase.co`) for
  production.

Lovable itself is not a production runtime owner in the target architecture. If
any live beta behavior still executes inside Lovable infrastructure, that is a
temporary exception that must be remediated before production cutover or
documented as a named dependency with a migration plan.

Target state:

- Lovable: presentation only.
- Vercel: server-side orchestration, route handling, and provider adapters.
- Supabase: identity, database, RLS, storage, and Edge Functions.

### 3.2 Ownership Split

| Capability | Owner | Must stay server-side? | Notes |
| --- | --- | --- | --- |
| Identity and sessions | Supabase Auth | Yes | Browser may initiate auth flow but not mint tokens. |
| Durable learner and content data | Supabase PostgreSQL | Yes | RLS and GRANTs enforce access. |
| Private uploads | Supabase Storage | Yes | Signed URLs only. |
| Student UI | Lovable frontend deployed through Vercel | No | Presentation only. |
| Assessment orchestration | Vercel or approved server runtime | Yes | Includes session, grading, and retries. |
| Content governance | Supabase Edge Functions plus database | Yes | Audit-safe and privileged. |
| Observability and alerting | Approved monitoring stack | Yes | Must receive redacted operational telemetry only. |
| Marketing events | Approved lifecycle tools | Yes | No raw learner evidence. |

Current-state verification is required for any surface that today may still be
served from Lovable-hosted backend logic. The target owner split is only valid
once grading, publish, and session mutation are confirmed to run in the intended
server boundary.

Migration note:

- if the beta currently uses Lovable Cloud for backend execution, that backend
  logic is part of the migration scope and must be removed from Lovable before
  cutover;
- the browser-facing Lovable UI may remain as the front-end host if it is only
  rendering and calling out to Vercel/Supabase for authoritative operations.

## 4. Required Production Accounts and Credentials

### 4.1 Required for Cutover

| Service | Required account or secret | Purpose | Notes |
| --- | --- | --- | --- |
| Vercel | Production project, team access, deployment access | Hosts app and server routes | Must support separate preview and production env vars. |
| Supabase | Production project `pcntajvbdfqhbeewmdry` / `Cramapple-Production` (`https://pcntajvbdfqhbeewmdry.supabase.co`) | Auth, database, storage, edge functions | Database migration owner and service role access required. |
| Supabase | `SUPABASE_URL` | Server and client connectivity | Same project URL for production runtime. |
| Supabase | `SUPABASE_ANON_KEY` | Browser-safe auth and public reads | Never expose service role. |
| Supabase | `SUPABASE_SERVICE_ROLE_KEY` | Server-side privileged operations | Server only. |
| Domain/DNS | Production domain control | Cutover routing | Required for public launch. |
| Observability | Logging/error alerting account | Production monitoring | Provider can be finalized later if not already chosen. |
| Lovable | None in the target state | No privileged runtime role | If Lovable is still executing backend logic today, that must be resolved as a cutover blocker. |
| Stripe | Production account `acct_1TddjmLwoRHzBJ1O` (live mode), `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET` | Checkout, entitlement grants, webhook verification | Per `TASK-0023`. Server-only; never exposed to the browser. Live-mode keys for production, test-mode keys for beta/preview — never cross-wired. |

### 4.2 Conditional / Future-Cutover Accounts

| Service | Required when | Notes |
| --- | --- | --- |
| AI gateway or provider account | Any server-side model calls are live | Prefer gateway-based routing from the architecture docs. |
| Email provider | Account verification, alerts, or support messaging are live | Keep credentials server-side. |
| Analytics / lifecycle tooling | Approved product events are emitted | Must not receive protected learner content. |
| Secrets manager | Team decides to move beyond env vars | Must support access scoping and rotation. |

## 5. Environment-Variable Matrix

### 5.1 Local

| Variable | Owner | Used by | Notes |
| --- | --- | --- | --- |
| `SUPABASE_URL` | Backend developer | Local server functions and tests | May point to local or dev Supabase. |
| `SUPABASE_ANON_KEY` | Backend developer | Browser-facing local app | Must not be committed. |
| `SUPABASE_SERVICE_ROLE_KEY` | Backend developer | Local server functions only | Never exposed to browser. |
| `OPENAI_API_KEY` or gateway equivalent | Backend developer | Server-only AI calls | Only if local AI tests need live access. |

### 5.2 Preview

| Variable | Owner | Used by | Notes |
| --- | --- | --- | --- |
| `SUPABASE_URL` | Platform owner | Preview app | Beta or preview Supabase target, likely `https://wmgjsdkphcyhngaffbqf.supabase.co` for `Cramapple-Development`. |
| `SUPABASE_ANON_KEY` | Platform owner | Preview app | Browser-safe only. |
| `SUPABASE_SERVICE_ROLE_KEY` | Platform owner | Preview server routes | Server-only. |
| `NEXT_PUBLIC_*` or equivalent frontend vars | Platform owner | Preview client | Only public values. |

### 5.3 Beta

| Variable | Owner | Used by | Notes |
| --- | --- | --- | --- |
| `SUPABASE_URL` | Platform owner | Beta app and beta server routes | Beta-specific target, likely `https://wmgjsdkphcyhngaffbqf.supabase.co` for `Cramapple-Development`. |
| `SUPABASE_ANON_KEY` | Platform owner | Beta client | Browser-safe only. |
| `SUPABASE_SERVICE_ROLE_KEY` | Platform owner | Beta server routes and Edge Functions | Server-only. |
| `OPENAI_API_KEY` or Vercel AI Gateway config | Platform owner | Beta server routes | Only if beta uses live model calls. |
| Monitoring tokens | Operations owner | Beta logging and error reporting | Must be separate from production where practical. |
| `STRIPE_SECRET_KEY` | Platform owner | `create-checkout-session`, `stripe-webhook` Edge Functions | **Not yet provisioned.** Must be a **test-mode** key — no Stripe test-mode catalog exists yet (only the live-mode catalog does; see `TASK-0023`), so this cannot be safely set until one is built. |
| `STRIPE_WEBHOOK_SECRET` | Platform owner | `stripe-webhook` Edge Function | **Not yet provisioned.** Signing secret for the beta Stripe webhook endpoint (test-mode). |
| `STRIPE_PRICE_CATALOG_JSON` | Platform owner | `create-checkout-session` Edge Function | **Not yet provisioned.** JSON map of `subject_key` → test-mode Price ID plus `bundle_2`/`bundle_3`/`unlimited`; see `_shared/stripe-catalog.ts`. The `Cramapple-Development` project currently only has 4 of the 10 launch subjects seeded (`biology`, `ap-chemistry`, `ap-physics-1`, `ap-statistics`) — confirm subject parity before wiring this up. |
| `APP_BASE_URL` | Platform owner | `create-checkout-session` Edge Function | Beta app origin, used to build the Checkout Session `success_url`/`cancel_url`. |

### 5.4 Production

| Variable | Owner | Used by | Notes |
| --- | --- | --- | --- |
| `SUPABASE_URL` | Production platform owner | Production server routes | Production Supabase project only. |
| `SUPABASE_ANON_KEY` | Production platform owner | Browser and public SSR reads | Public key only. |
| `SUPABASE_SERVICE_ROLE_KEY` | Production platform owner | Server routes and Edge Functions | Protected secret. |
| `OPENAI_API_KEY` or gateway OIDC config | Production platform owner | Server-side model calls | Prefer gateway-based auth where approved. |
| `SENTRY_DSN` or equivalent | Production ops owner | Server and client error reporting | Must avoid raw learner data in payloads. |
| Support/contact integration secrets | Operations owner | Support workflows | Optional, if support tooling is live. |
| `STRIPE_SECRET_KEY` | Production platform owner | `create-checkout-session`, `stripe-webhook` Edge Functions | **Not yet provisioned in Supabase.** Live-mode secret key for `acct_1TddjmLwoRHzBJ1O`. Protected secret. |
| `STRIPE_WEBHOOK_SECRET` | Production platform owner | `stripe-webhook` Edge Function | **Not yet provisioned.** Signing secret for the live Stripe webhook endpoint once it is registered against the deployed `stripe-webhook` function URL. |
| `STRIPE_PRICE_CATALOG_JSON` | Production platform owner | `create-checkout-session` Edge Function | **Not yet provisioned.** Live-mode value is the full catalog recorded in `TASK-0023`'s Live Catalog Inventory: `{"subjects":{"biology":"price_1U3INlLwoRHzBJ1OyQ39k1pa","ap-chemistry":"price_1U3IOKLwoRHzBJ1OFiAhGBSp","ap-calculus-ab":"price_1U3IPVLwoRHzBJ1ORy4CtabU","ap-calculus-bc":"price_1U3IPvLwoRHzBJ1OD3HluYsw","ap-precalculus":"price_1U3IQQLwoRHzBJ1Oyt5XMyww","ap-physics-1":"price_1U3IQuLwoRHzBJ1O0amAJ5AI","ap-physics-2":"price_1U3IRmLwoRHzBJ1OdjKrTZMK","ap-physics-c-em":"price_1U3ISaLwoRHzBJ1OrHupALNo","ap-physics-c-mechanics":"price_1U3IT5LwoRHzBJ1OGNddcGk1","ap-statistics":"price_1U3ITWLwoRHzBJ1O4WFXqTsj"},"bundle_2":"price_1U3IVNLwoRHzBJ1OFc4H9iVD","bundle_3":"price_1U3IW8LwoRHzBJ1Oxew8VHHI","unlimited":"price_1U3Ia0LwoRHzBJ1OBG1vlN1b"}`. Subject keys match `app.subjects.subject_key` in `Cramapple-Production`, confirmed 2026-08-11. |
| `APP_BASE_URL` | Production platform owner | `create-checkout-session` Edge Function | Production app origin, used to build the Checkout Session `success_url`/`cancel_url`. |

## 6. Server-Side Trust Boundaries

### 6.1 Auth

- Auth sessions are created and restored through Supabase Auth.
- Client code may read public profile-safe state but never decides authorization.
- Server routes must verify the authenticated user before sensitive operations.

### 6.2 Content

- Content creation, editing, publish, retire, and rollback remain server-side.
- Content publishing must require validated gates and a manifest.
- Content uploads and content-assets remain protected in Supabase Storage.

### 6.3 Assessment

- Attempt submission and grading remain server-authoritative.
- The browser may capture answers and request grading, but it must not mint the grade.
- Retry paths must be idempotent.

### 6.4 Storage

- `content-assets` is service-only.
- `learner-uploads` is private and path-scoped by learner identity.
- `validation-artifacts` is service-only.
- Signed URLs are required for any controlled access.

## 7. Logging, Metrics, and Alerting

Minimum production observability:

- request logs for server routes and Edge Functions;
- auth failures and RLS denials;
- grading failures, publish failures, and rollback events;
- upload failures and signed URL issuance failures;
- deployment failures and migration failures;
- error reporting with enough context to debug, but without raw learner evidence in alert payloads;
- dashboard or alerting view for S0 and S1 incidents.

Operational rules:

- logs should include a request or idempotency identifier;
- error messages returned to clients should be generic for unexpected failures;
- learner data must stay out of marketing and generic analytics by default;
- monitoring should separate product failures from infrastructure failures.

Verification note:

- smoke tests must exercise actual read/write paths for each server boundary,
  not only confirm that a migration applied cleanly;
- idempotency must be verified on real writes, including content publishing and
  grading-adjacent operations where applicable;
- missing-secrets behavior must be tested at startup, not only on first request.

## 8. Deployment and Rollback Flow

### 8.1 Deployment Sequence

1. Merge approved schema and function changes.
2. Apply database migrations in order.
3. Deploy or update Edge Functions and server routes.
4. Deploy the frontend to preview.
5. Run smoke tests against preview or beta.
6. Promote to production only after cutover criteria pass.

Smoke tests must cover:

- auth/session creation and restore;
- at least one assessment submission and retry path;
- at least one content draft/write/publish flow;
- storage sign and access flows where applicable;
- failure behavior when required secrets are missing.

### 8.2 Rollback Sequence

1. Pause new releases or content publication if the issue is content-related.
2. Revert the server-side deployment or function bundle.
3. Apply the prior approved manifest or content state where required.
4. Restore environment config if the issue is secret or routing related.
5. Escalate to incident review if learner evidence or content integrity is at risk.

### 8.3 Rollback Guardrails

- rollback must be documented before production launch;
- partial rollback is only allowed if the plan explicitly supports it;
- learner evidence should not be overwritten during rollback;
- content rollback should prefer versioned state changes over destructive edits.

## 9. Cutover Readiness Criteria

### 9.1 UX-001 Account Flow

- account creation and sign-in complete successfully;
- session restore works across reloads;
- unauthorized routes are blocked;
- account state is stable across beta and production boundaries;
- no critical auth regressions remain open.

### 9.2 UX-006 Assessment Flow

- MCQ and FRQ attempts complete end to end;
- submission, resume, and feedback states work consistently;
- grading remains server-authoritative;
- retries are idempotent;
- no real learner data leaks into preview surfaces;
- no fake or unsupported score claims are shown.

### 9.3 Content Publishing Flow

- governance tables and content workflows are wired together;
- publish requires validated gates and an approved manifest;
- content-author roles cannot self-authorize publication;
- rollback and retire behavior are documented and rehearsed;
- storage and audit paths are working.

Known blockers for this gate include:

- the `app.audit_events` shape collision must be resolved and verified;
- the governance migration must grant the required service-role write access;
- publish authorization must distinguish authoring from release authority;
- gate fields must fail closed rather than defaulting to pass;
- the publish path must be exercised against a freshly migrated database.

### 9.4 Launch Gates

- production secrets are present and scoped;
- monitoring and alerting are active;
- rollback has been tested;
- a production support/contact path exists;
- privacy policy and terms are published if the public launch depends on them.
- no grading, publish, or session-mutation logic remains inside Lovable-hosted backend runtime;
- beta and production resource isolation is explicit and reviewed.

## 10. Secret Storage and Rotation

Rules:

- secrets live only in platform secret stores or environment variables intended for server use;
- browser-exposed variables must be public by design;
- service role keys and provider credentials must never enter Lovable output or client bundles;
- rotate secrets on suspicion of exposure, environment rebuild, or provider policy change.

Rotation sequence:

1. Provision new secret.
2. Update server-side runtime.
3. Verify preview or beta behavior.
4. Promote the new secret to production.
5. Revoke the old secret.
6. Record the change and incident history if applicable.

## 11. Open Decisions

- Which monitoring provider will be standard for production alerts?
- Which environment will host beta model calls, if any?
- Which workflows remain in Supabase Edge Functions versus Vercel routes?
- Which secrets will be managed in env vars versus an external secrets manager?
- What exact smoke tests are required before cutover approval?
- What is the current beta runtime boundary if Lovable-hosted backend logic still exists, and what migration plan removes it?
- Is beta sharing the same Supabase project as production today, and if so what explicit isolation or migration plan applies?
