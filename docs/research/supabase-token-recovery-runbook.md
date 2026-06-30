# Supabase Token Recovery Runbook

**Date:** 2026-06-26  
**Purpose:** Get a fresh, project-matched Supabase JWT into the exact place the
`grade-frq` Edge Function reads it, without repeating the earlier browser or
project mismatch.

## 1. Problem This Runbook Solves

`grade-frq` does not read a Lovable session cookie or anonymous UI state. It
calls `auth.getUser()` from the `Authorization` header and only proceeds when
that header contains a valid Supabase access token for the correct project.

This runbook converts that into an execution path with a single security-gated
handoff point: you perform the auth action or approve the dev-only auth helper;
the repo work prepares everything else.

## 2. Non-Negotiable Constraints

1. Development and production Supabase projects must not be mixed.
2. A browser shell session is not evidence of a Supabase Auth session.
3. Anonymous product-session tokens are not substitutes for a Supabase JWT.
4. A stale JWT is worse than no JWT because it creates false confidence.
5. The token must be sent to the function in `Authorization: Bearer <token>`.
6. No production bypass, debug token, or secret-bearing helper may be added.

## 3. What Codex Can Prepare

These steps are safe for me to do in-repo:

- document the exact auth contract and verification order;
- add a dev-only prompt or checklist for surfacing session state;
- write a manual token capture checklist;
- add a request-shape example for the verification call;
- update any repo-side docs that currently imply anonymous UI state is enough.

## 4. What Requires Your Action

These are the only security-gated steps:

- sign into the development Supabase project from the correct browser context;
- approve any dev-only UI helper that would expose session state in non-prod;
- copy or relay the fresh access token;
- run the verification request if you do not want me to execute it from the
  same authenticated context;
- confirm whether the dev-only helper should exist at all.

## 5. Recovery Paths

### Path A: Existing Dev Auth Flow Works

Use this if the beta already exposes a real Supabase sign-in flow in the dev
route.

1. Open the development beta route, not the Lovable root shell.
2. Complete the intended Supabase sign-in path.
3. Verify the browser now has a Supabase session, not only `__lovable_*`
   storage keys.
4. Confirm the token belongs to `wmgjsdkphcyhngaffbqf`.
5. Confirm the JWT is fresh enough to use immediately.
6. Send it in the `Authorization` header when calling `grade-frq`.
7. Run the five synthetic grading cases right away.

### Path B: Dev Flow Does Not Surface a Usable Session

Use this if the current beta route still does not expose a usable Supabase JWT.

1. Add a dev-only session diagnostics surface in non-production only.
2. Show the current Supabase project ref.
3. Show whether `supabase.auth.getSession()` returns a session.
4. Show whether the session has an access token.
5. Offer a copy action for the access token only in the dev surface.
6. Keep the helper impossible to render in production.
7. Re-run Path A from the dev surface once the session is visible.

## 6. Verification Request Shape

Use the JWT in the header and keep the body as the existing grading payload:

```bash
curl -X POST \
  "https://wmgjsdkphcyhngaffbqf.supabase.co/functions/v1/grade-frq" \
  -H "Authorization: Bearer <fresh_dev_access_token>" \
  -H "Content-Type: application/json" \
  -d '{
    "attempt_id": "<uuid>",
    "question_id": "<uuid>",
    "session_id": "<uuid>",
    "response_text": "..."
  }'
```

If this returns `401`, assume one of three problems first:

- wrong project;
- expired token;
- token not sent in the header the function reads.

## 7. Suggested Session Order

1. Confirm the beta route and project ref.
2. Confirm whether the app exposes a real Supabase session anywhere in the dev
   route.
3. If not, approve a dev-only diagnostics helper.
4. Capture a fresh access token.
5. Verify issuer and expiry immediately.
6. Run the A-E synthetic `grade-frq` calls.
7. Record the exact winning path back into this runbook.

