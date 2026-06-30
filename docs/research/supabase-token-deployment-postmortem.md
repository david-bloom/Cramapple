# Supabase Token Deployment Postmortem

**Date:** 2026-06-26  
**Scope:** Trying to deploy and use a valid Supabase JWT so the `grade-frq`
function can be verified against the five synthetic cases in the
`Cramapple-Development` project (`wmgjsdkphcyhngaffbqf`).

## What we were trying to do

The goal was to run five verification calls against the deployed
`grade-frq` Edge Function in the development Supabase project:

- prove the function exists and is reachable;
- confirm the function accepts a valid authenticated user JWT;
- run the A-E synthetic grading cases end to end;
- use the result to confirm the grading pipeline before moving on.

The relevant development project is:

- `Cramapple-Development` - `wmgjsdkphcyhngaffbqf`

The relevant function URL is:

- `https://wmgjsdkphcyhngaffbqf.supabase.co/functions/v1/grade-frq`

## What worked

1. The development project was identified correctly.
2. The prototype schema migration was pushed successfully to the development
   project.
3. The synthetic question row was created successfully.
4. Five synthetic `student_attempts` rows were created successfully.
5. `grade-frq` was deployed successfully to the development project.
6. `supabase functions list` confirmed `grade-frq` was `ACTIVE`.

Those steps proved the backend plumbing was in place.

## What went wrong

### 1. We started in the wrong browser/session context

The first browser checks were run on the Lovable beta domain, which did not
show a Supabase auth token in storage.

Observed states included:

- root Lovable page with only `__lovable_session` and `__lovable_anonymous_id`;
- no `sb-...-auth-token` entry in localStorage;
- incognito on the beta page also returning `[]` for the auth-token lookup.

Lesson: the Lovable UI shell is not the same thing as a Supabase-authenticated
session. A visible app session does not guarantee the browser has a usable
Supabase JWT.

### 2. We initially looked at the wrong Supabase project

We spent time on the production project before settling on the development
project for verification.

That created avoidable confusion because:

- production and development are separate projects;
- the browser token and function URL must match the same project;
- a token from one project will fail against the other.

### 3. We hit the CLI login flow incorrectly

Several early attempts to authenticate the Supabase CLI failed because of
command and shell mistakes.

Observed problems:

- `supabase login` was run with the wrong token expectations;
- `supabase login` complained about an invalid token format when a token was
  not in the expected `sbp_...` shape;
- one shell session got stuck in `dquote>` because an opening quote was not
  closed cleanly;
- one command accidentally used a smart quote instead of a normal ASCII quote;
- one attempt pasted literal placeholders instead of real values;
- one attempt exported a token string with extra quote characters wrapped
  around it.

Lesson: token work is brittle when shell quoting is sloppy. Use one clean
terminal session, plain ASCII quotes only, and verify each exported variable
immediately with `echo` or a short `node` check.

### 4. We tried to use an expired JWT

At one point we had a token from the correct development project, but it had
expired. The function rejected it with:

- `UNAUTHORIZED_ASYMMETRIC_JWT`
- `Invalid JWT`

That was the key failure after the function was deployed: the endpoint existed,
but the bearer token was no longer valid.

Lesson: a token can be from the right project and still be unusable if the
session has expired.

### 5. We briefly deployed to the wrong mental model for auth

We expected the beta page to hand us a fresh token automatically. It did not.
The architecture documents indicate:

- anonymous session first;
- optional Google login only for save/resume;
- Supabase Auth is the identity authority;
- the browser may initiate auth, but the session must actually exist.

So the missing token was not just a tooling problem. It reflected a product
flow mismatch: the live page did not create the auth state we assumed it would.

## Important command history

These were the meaningful checkpoints:

```bash
supabase link --project-ref wmgjsdkphcyhngaffbqf --workdir /Users/davidbloom/Documents/Cramapple
supabase db push --linked --workdir /Users/davidbloom/Documents/Cramapple
supabase functions deploy grade-frq --project-ref wmgjsdkphcyhngaffbqf --workdir /Users/davidbloom/Documents/Cramapple
supabase functions list --project-ref wmgjsdkphcyhngaffbqf --workdir /Users/davidbloom/Documents/Cramapple
```

Those all succeeded.

The failed or misleading areas were mostly around token acquisition and shell
state, not around Supabase deployment itself.

## Problems to remember next time

1. **Do not assume a browser session equals a Supabase session.**
   Check `localStorage` for the actual `sb-...-auth-token` entry.
2. **Make sure the token and project match.**
   Development token against development project only.
3. **Do not reuse stale JWTs.**
   If the token is old, the function may reject it even if it decodes cleanly.
4. **Avoid shell-quote drift.**
   One missing quote can leave the terminal in `dquote>` and waste time.
5. **Do not use placeholder values in the final command.**
   The terminal will happily accept the command shape and fail later in a less
   obvious way.
6. **Do not assume Lovable root pages expose auth state.**
   If the app uses a separate route for beta or sign-in, inspect that route
   directly.

## Current best understanding

The verification blocker was not the function deployment. It was the lack of a
fresh, valid Supabase JWT for the `wmgjsdkphcyhngaffbqf` project session.

The `grade-frq` endpoint is deployed and reachable. The next successful step
will require either:

- a fresh development-project Supabase session token from the correct browser
  flow, or
- a clearer documented auth route in the beta app that reliably creates and
  exposes the session before testing.

## Recovery plan

The concrete recovery runbook now lives in
[`docs/research/supabase-token-recovery-runbook.md`](/Users/davidbloom/Documents/Cramapple/docs/research/supabase-token-recovery-runbook.md).

The short version is:

1. Use the development beta route, not the Lovable root shell.
2. Confirm a real Supabase Auth session exists.
3. Capture a fresh development-project access token.
4. Send that token in `Authorization: Bearer ...` when calling `grade-frq`.
5. If the beta route cannot surface a usable session, approve a dev-only
   diagnostics helper in non-production only.

This keeps the security-sensitive step squarely with you while letting the repo
carry the rest of the recovery path.

## Suggested next-session checklist

1. Confirm the browser is on the development beta route, not the production or
   root Lovable shell.
2. Confirm `Object.keys(localStorage)` contains `sb-wmgjsdkphcyhngaffbqf-auth-token`.
3. Extract the access token from that exact key.
4. Verify the token issuer decodes to the development project URL.
5. Run the five `grade-frq` case requests only after the token is confirmed
   fresh and valid.
