# Session close: TASK-0077 trial QA, sandbox journeys and Loops (2026-10-18 to 2026-10-20)

**Owner / Product Owner:** David Bloom. **Agent:** Claude (Claude Code desktop session "QA the 7-day trial").
**Task:** `TASK-0077` (`docs/tasks/TASK-0077-SEVEN-DAY-CARD-TRIAL.md`), governing decision `DECISION-0126`.
**Repositories:** backend `david-bloom/Cramapple` PR #507 (branch `claude/task-0077-trial-impl`, open, CI `test` green at
`deeb92a0`); app `david-bloom/ap-prep-blueprint` PR #37 (merged 2026-10-19 03:00 UTC) and PR #38 (open, CI green).
**Environments touched:** Development Supabase `wmgjsdkphcyhngaffbqf`, Stripe sandbox `acct_1U3K3SLrvKNd9sBp` ("Cramapple
Sandbox"), Loops team "Cramapple". **Nothing was changed on Production** (no Production query, write, deploy or setting).

A second Claude session ("7-day trial production launch") worked in the same backend worktree from 2026-10-20 (QA rounds 3 and
4, commits `fb1ace39` … `fedba7ce`). That work is recorded in the task record, not here; the two sessions coordinated by message
and committed only their own paths.

## 1. Outcome in one paragraph

The app's trial pages (PR #37) passed two Codex QA rounds and were merged. The backend (PR #507) passed several Codex rounds;
fixes are deployed to Development. A paired student/parent sandbox journey on Development passed end to end (charge, refund,
decline, recovery, parent cancel). It exposed that activation depended on the account-invite email, which was redesigned so a
trial starts with no email and the student signs in by email code. Link is off for trial checkout. All 20 Loops trial
templates are published, their IDs are in the manifest and set on Development, trial notices are on on Development and the
first 8 delivered to real inboxes. Open before launch: Production's sign-in code email (checklist item 9), the parent Terms
link (Stripe public business details), and the items in section 10.

## 2. App PR #37 (trial pages) — QA and merge

- **Codex round 1 (7 findings), all valid and fixed** (`a66b436`): recovery completion read from Stripe's PaymentIntent, not
  the voided link; cancel outcomes survive refresh/reload; permanent Account link in the Hub header; final-48-hour
  automatic-charge notice with a Cancel link; notice re-reads on focus/visibility/bfcache/billing change and every minute;
  Pay opens the form once (no wasted recovery attempts); reconciling/paid/refunded/disputed/expired orders shown honestly.
  Also fixed the inherited BYOQ test mock so the suite exits 0.
- **Codex round 2 (2 findings), fixed** (`38cd602`): Payment Element mounted with its container (failed 3-D Secure return
  works in either arrival order); parent cancel announces the change; throttled focus deferred, re-read at trial end and every
  10 minutes.
- **PR #38 (open):** American spelling in trial and capture copy (see section 8).

## 3. Terms and checkout wording

- David aligned Terms §12.2 (Free Trials). Because DECISION-0126 ends access on cancel, both mandate texts now say
  "Canceling ends trial access right away." Mandate versions: v2 (that sentence), v3 (parent mandate uses "AP Biology", not
  the subject key), v4 (American spelling). Every wording change bumps `MANDATE_TEXT_VERSION`.
- Release checklist item 7 (lawyer review) still covers Terms, mandates and notice emails.

## 4. Backend PR #507 — QA rounds handled in this session

- **Round 1 (6 findings, Codex review of `0dcf1639`), all fixed** (`ab43bd6a`, migration `20261019142835`): refund before
  success is terminal; checkout retry no longer replays an expired session; delayed charge only 48 h after its notice is
  actually sent; parent cancel links outlive delayed charges; cancellation settlement resumable; own promo reservation not
  self-exhausting.
- **Live-QA proposals (Codex), applied** (`c7ae7dc5`): card-only trial PaymentIntents; parent mandate subject labels;
  `trial_started` not sent after conversion; failed PI cancel no longer recorded as "pending" (refined: PI re-read, real race
  classified at once).
- **Activation redesign** (`b92c5b1e`, review fixes `e9a7d473`): new `_shared/trial-learner.ts` creates an unknown student
  **unconfirmed with the Admin API and sends no email**; duplicate race reuses the account; an address auth rejects is a durable
  `activation_refused` (`student_email_invalid`, parent card detached, card id stored so clean-up retries); outages retry. A
  learner version of the trial-started email tells a self-paying student to sign in by code. **Link off for trials** (David):
  `wallet_options.link.display = "never"` on both setup sessions, and activation refuses a non-card or Link-branded method.
  Codex reviewed `b92c5b1e`: design sound; two findings (refused-card clean-up, template variables with digits) fixed.

## 5. Development deployments and checks (this session)

| When (UTC) | What | Verification |
| --- | --- | --- |
| 2026-10-19 14:28 | Migration `20261019142835` (renamed to Development's recorded version) | Read-back: behaviours present, new function service-role only, 8 test orders unchanged |
| 2026-10-19 | Six functions at `fea1b911`, then mandate v2 fix | Pre-diff vs branch (only an older `trial-notices.ts`), post-download matched file for file, smoke 401/404/401/400, quote OK |
| 2026-10-19 | `c7ae7dc5` to six functions | Pre-diff only the version line; post-download match; smoke; worker ran cleanly |
| 2026-10-19 | `e9a7d473` to four functions | Pre-diff matched `c7ae7dc5`; post-download match; quote/start check (below) |

Quote/start check after `e9a7d473`: both starts 200 (Stripe accepts the Link setting); Stripe shows both sessions card-only with
Link `never`; the rendered parent page showed card only and "for Sam's AP Biology"; both check sessions expired, orders
`setup_expired`, no accounts created. Later deploys of rounds 3–4 were done by the other session.

## 6. Paired sandbox journey on Development (David approved)

Approved changes: five payment/dispute events added to webhook endpoint `we_1UKj4nLrvKNd9sBpasmGR65M` (sandbox only); test
orders moved back 7 days to reach day 7; cancel/recovery tokens inserted by hash (notices were off). Student emails were
`dbloom01+trial-…@gmail.com` aliases after example.com addresses were rejected.

| Journey | Order | Result |
| --- | --- | --- |
| A, student pays, 4242 → day-7 charge → refund | `0ba65ced` | Pass: converted, paid access; refund → `refunded`, access revoked |
| B, parent pays, 4000…0341 declines → recovery with 4242 | `87255cf7` | Pass: grace 24 h, one retry scheduled, recovery page paid, converted; parent card not mapped to student; replay idempotent |
| C, parent pays, 4242 → parent cancels from link | `9be34e2e` | Pass: view changed nothing; cancel → "won't be charged", PI canceled, link voided |
| D, new student, no-email activation + code sign-in | `7dc46674` | Activation with no email and card-only fresh PI pass; **code sign-in blocked on Development** (stock auth template, no code; Site URL old Vercel site). David's click confirmed the account but did not sign in |

Findings recorded in the task record ("Paired sandbox journey"): activation depended on the invite email (fixed);
Development auth email is Supabase built-in (~2/hour); parent mandate used subject keys (fixed); trial PI not card-only
(fixed for new PIs); Link "Bank" option (Link off); parent Terms link points at Stripe's placeholder (open); stale
`trial_started` after conversion (fixed).

## 7. Loops trial templates

- 20 templates (11–19 payer/student plus `11-trial-started-learner` and `20-parent-trial-request`) generated by
  `docs/email/transactional/build_trial_templates.py`; the variable regex now accepts digits (`cardLast4`).
- **Incident:** Loops disabled the team's sending domain on 2026-10-19 (~23:45 UTC): Publish stayed inactive and the API
  returned "No sending domain configured for this team". Development's queues had sent nothing in the prior 3 days, so trial
  testing did not cause it. David contacted support; Loops re-enabled it 2026-10-20. While disabled, nothing Loops-based sent
  for Development or Production.
- **Loops import format:** one zip per email containing a single file named exactly `index.mjml`. Loops' API cannot read or
  write MJML content ("MJML format is not supported via API"), so content can only be checked by a real send.
- **IDs:** all 20 recorded in `docs/email/transactional/manifest.json` (`transactionalId`, status `published`), commits
  `352f7ebe` and `deeb92a0`. The two `17-trial-canceled` templates were republished as new templates with new IDs
  (`cmvhbmhma02h20kxf8mo8f2h9` payer, `cmvhbrp6y02np0jxs89l6qtgp` student); the old two were deleted. Use the manifest, not
  earlier chat tables, for Production secrets.
- Internal name typo in Loops: "15-trial-grace-ender-payer" (cosmetic; code uses the ID).

## 8. American spelling (David)

User-facing "Cancelled"/"Cancelling" → "Canceled"/"Canceling" in the email generator and 8 templates, both mandates (v4) and
the cancel outcome messages (backend `722b5fd1`; the cancel messages were committed with the other session's round-3 commit by
agreement), and in app copy (PR #38). Identifiers and columns such as `cancelled_at` unchanged. The first 17 sends still showed
British body text; both 17 templates were then republished (new IDs above). **Not yet confirmed by a real send.**

## 9. Development secrets and trial notices (David approved)

- 21 secrets set on Development: the 20 `LOOPS_TRIAL_*` / `LOOPS_PARENT_TRIAL_REQUEST_TRANSACTIONAL_ID` IDs from the manifest
  and `TRIAL_NOTICES_ENABLED=true`; the two 17 secrets later updated to the new IDs.
- Before enabling, 4 queued notices to `trial-e2e-5@cramapple.com` / `trial-e2e-6@cramapple.com` (Oct 18 test orders) were
  cancelled (bounce risk). First worker runs (22:44–22:46 UTC Oct 20): **8 delivered, 9 stale skipped, 0 failed**; all 8 arrived
  in the Gmail aliases from `support@mail.cramapple.com` (refunded A, converted B/F payer and student, canceled C/D).

## 10. Open items (next owner)

1. **Release checklist item 9 (Hard-Gate, David):** on Production, a brand-new unconfirmed account's first code email must
   carry the 6-digit code (dashboard "Confirm sign up" template, or Loops `signup` if the Send Email hook is on). Development
   fails this today (stock templates, Site URL `cramapple-dev-bloom-llc.vercel.app`).
2. **Parent Terms link:** set Cramapple's Terms URL in Stripe public business details (sandbox and live), or per-session
   `custom_text.terms_of_service_acceptance`; verify the rendered checkbox link.
3. **Confirm the republished 17 templates** say "canceled" with one real canceled-trial send; spot-check 11, 12 and 16-payer
   Code tabs for "Cancell".
4. **Recovery page Link:** whether the app's Payment Element still shows Link for card-only PIs (rendered check).
5. **Oct 18 test orders `a80f04cc` / `e7fa3ec1`** (trialing, `trial-e2e-5/6@cramapple.com`): their Oct 26 charge will queue
   new notices to those addresses. Cancel the orders on Development if those mailboxes do not exist.
6. **Order D (`7dc46674`) and test accounts:** sandbox only; D is now `canceled` (not by this session; most likely the other session's later journeys). Leave as
   evidence or clean up deliberately.
7. **PR #38** (app spelling) and **PR #507** await David's merge decision (code PRs). Production deployment follows checklist
   item 8 and needs every secret from the manifest.
8. Not covered by any journey: 3-D Secure end to end, disputes (covered by the other session's journey G), a lost webhook.

## 11. Corrections and mistakes in this session (for trust in the record)

- I repeated a stale task-record line ("every trial switch off") about Development; trial admission and charges were **on**.
  Corrected in the task record and PR description.
- A read-only check query included `trial_claim_due(0)`, which claims due orders. No order was due; verified nothing was
  claimed.
- I first inferred that stuck Loops drafts were unsaved because they listed no variables; Loops only lists variables after
  publishing, so that inference was wrong. The real cause was the disabled sending domain.
- example.com student addresses were rejected by Supabase Auth and burned the Development email allowance, delaying journeys
  B and C by about two hours. This surfaced finding 1.

## 12. Approvals given by David in this session (chat)

Apply backend fixes to Development; add the five webhook events and shift test-order dates / insert tokens; use Gmail aliases;
cancel the stuck example.com order; build the activation redesign and turn Link off for trials; deploy `c7ae7dc5` and
`e9a7d473` to Development with quote check; run the new-student code sign-in test; add the Production code-email check to the
release checklist; American spelling; set Development secrets and turn notices on; cancel the four notices to the test inboxes.
