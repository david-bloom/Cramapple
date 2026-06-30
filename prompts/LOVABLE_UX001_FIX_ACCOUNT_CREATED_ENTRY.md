# Lovable Fix - Restore the first-session entry point

## Problem

After account creation, `/account-created` redirects to `/account?welcome=1`,
which is the account page — a dead end. The UX-001 first-session flow
(`/account-created` → `/setup` → first practice item) is unreachable from
signup, so new students never reach the product.

## Required behavior

The post-signup path must be: **account created → `/account-created` welcome →
`/setup` (one-screen first-session setup) → first practice item.**

1. **Route new signups to `/account-created`**, not `/account?welcome=1`. Remove
   the `?welcome=1` redirect behavior from the account page.
2. **`/account-created` renders the UX-001 welcome screen** (do not redirect it
   to `/account`):
   ```text
   ACCOUNT READY

   Let’s make your first session useful.

   Cramapple helps you use the time you have to earn more AP Biology points.
   ```
   - Primary action: `Set up my first session` → navigates to `/setup`.
   - Secondary action: `How Cramapple works` → compact inline explanation.
3. **Guard against trapping returning users.** `/account-created` is only for a
   brand-new learner who has not completed setup. If a learner who has already
   completed setup (`setupStatus === "completed"`) lands on `/account-created`,
   forward them to `/home` instead. Do not loop.
4. The account page (`/account`) stays a normal account-management surface with
   no special `welcome` mode and is not part of the onboarding path.

## Acceptance criteria

- Creating a new account lands on `/account-created`, not `/account`.
- `/account-created` shows the welcome screen and its primary action reaches
  `/setup`.
- From `/setup`, `Start session` reaches the first practice item.
- A returning, setup-complete learner who hits `/account-created` is forwarded to
  `/home`, not parked on the account page.
- No route in the signup → first-session path dead-ends on `/account`.

## Do not do

- Do not reintroduce a `/prototype` route.
- Do not add a multi-step setup wizard; `/setup` remains one composed surface.
- Do not ask registration status or a target AP score in this flow.

## Completion output

Report: the signup redirect target, what `/account-created` now renders, the
returning-user guard behavior, branches tested, and a preview link.
