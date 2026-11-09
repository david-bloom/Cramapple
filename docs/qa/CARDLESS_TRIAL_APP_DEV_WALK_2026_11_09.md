# Cardless trial: app-side Development walk (2026-11-09)

**Author-run, NOT independent QA.** Development only (`wmgjsdkphcyhngaffbqf`). Authority: `APPROVAL-0208`. The backend migration `20261109215704` (trial_v2) was applied to Development by the backend session on David's direct word; the app build (ap-prep-blueprint draft PR #53, flag `VITE_CARDLESS_TRIAL=on`) was run locally against Development. Nothing touched Production.

## Method and limits
Three throwaway Development users (password sign-in; the session was placed in the browser cookie the app reads; a real email-code sign-in was NOT possible because no inbox exists for test addresses). The Development switch `cardless_trial_enabled` was turned on for the walk and **back off** afterwards; all rows were removed in the backend session's order (entitlements, grading log, acquisition profiles, consumed-email hashes, outbox, identities, users); counts verified 0.

## Verified (API and app UI)
| Check | Result |
| --- | --- |
| `get_trial_state` new account | `phase none`, `can_start true` |
| `start_subject_trial` bad subject / blank notice | `trial:subject_unavailable` / `trial:missing_privacy_notice_version` |
| start `ap-statistics` | `active`, `ends_at` +7 days, `days_remaining 7`, `ends_eastern "Monday, November 16, 2026"`, `checkout_subject_key` set |
| replay same / other subject | same state (idempotent); other subject adds `replayed_other_subject: true`, subject unchanged |
| Access | `get_study_subject_keys` returns only `ap-statistics` |
| `/home`, account with a trial | "7 days left in your free trial of AP Statistics. Your trial ends Monday, November 16, 2026 (Eastern)." + "Keep your access" linking to `https://cramapple.com/checkout?subject=ap-statistics`; the normal AP Statistics hub below |
| `/home`, new account, no subject | "Pick your subject to start your 7 days" with all published subjects; choose AP Statistics -> confirm text -> "Start my 7 days" -> trial starts and the hub appears with the 7-day bar |
| `/home?subject=ap-statistics&utm_source=walkthrough`, new account | trial auto-confirmed for that subject with no picker (**after a fix, below**); `acquisition_profiles` stored `privacy_notice_version = 2026-11-09` and `first_touch = {"utm_source":"walkthrough"}`, marketing opt-in false |
| Trial ended (set by SQL) | bar "Your free trial of AP Statistics has ended ... Get access" linking to checkout; account no longer lists the subject |

## Bugs found by the walk (fixed in PR #53)
1. The existing `useApplySubjectParam` strips `?subject=` from the URL before the picker read it, so a landing-page subject was never auto-confirmed. The route now keeps the requested subject and passes it down.
2. An ended-trial account saw "Which subject first? No subjects are available on this account" under the pay prompt; that card is now hidden for ended and already-used trials.

## Not verified
- A real email code sign-up (`/start` was rendered but its submit was not exercised against Auth); Production Auth settings were verified separately by the backend session.
- Practice and grading during the trial (Development has no serving labels, so the unit-gated queue is empty there), the daily grading cap, and More help.
- The after-day-7 readback of saved work: the backend allows it, but **the app has no entry point to it** (an ended student sees only the pay prompt). Not built.
- Checkout itself, the pay-now page, the marketing "Start free trial" buttons (Lovable prompts unsent), and the card trial path.
- Production anything.
