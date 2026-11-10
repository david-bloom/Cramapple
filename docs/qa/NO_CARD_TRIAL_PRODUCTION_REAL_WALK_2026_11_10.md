# No-card trial: real Production walk by David (2026-11-10, ~03:30 to 04:50 UTC)

Release packet step 5 (`docs/product/NO_CARD_TRIAL_PRODUCTION_RELEASE_PACKET_2026_11_10.md`). David walked the live trial in a private window with a real inbox (switch on under `APPROVAL-0212`); the paywall-to-prod session read Production read-only alongside. *Verified* = observed in Production data or the live site; *reported* = David's words.

## What worked (verified)
- Real email-code sign-up: account created 03:31:53, confirmed 03:32:34 UTC (about 40 s), profile `student`, privacy notice `2026-11-09`, empty touch data (no UTM that visit).
- Subject confirmation: `trial_v2` entitlement for AP Chemistry, 7 days (to 2026-11-17 03:32:40 UTC), `trial_started` outbox event, email marked consumed. Home bar read "7 days left… ends Monday, November 16, 2026 (Eastern)" with a "Keep your access" button (reported, screenshot).
- Practice and grading: 4 MCQs graded and 1 FRQ graded (scored 0 of 10; the answer was deliberately vague, reported), 5 `trial_grading_log` rows against the cap of 40. `/saved-work?session=` opened a read-only review ("Saved work 1 of 4").
- Marketing (live, read-only check): "Start free trial" links to `app.cramapple.com/start` (with `?subject=` on subject pages, UTM and promo carried); no "72-hour" or "8 free questions" wording; `/checkout` shows pay-now ("Total due today").

## Findings and what was done
| Finding | Disposition |
| --- | --- |
| Signed in, "Start free trial" landed on `/home` with no subject picker | By design: `/start` redirects signed-in visitors; picker only when `get_trial_state.can_start`; admin/paid read `superseded`. No change. |
| Code-step copy | App PR #54 (merged, published): the only message after the email is "Check [email] for your activation code and enter it below."; the "7 days of full access" intro removed. David asked about restoring a "No card needed" line on the email step: open. |
| No way to reach FRQs: MCQ sessions never contain FRQs; nothing on `/home` linked to `/practice-frq` | App PR #55 (merged, published): FRQ door on `/home`. |
| No save indicator, saved work only after the trial, footer said "Get access" during the trial | App PR #55: saved-work list on `/home` during the trial, "Your answer is saved." note, footer "Back to practice" while active. |
| "There aren't practice questions for 2.2 yet" after answering all 4 practice MCQs (topic exhausted, answered items never return; server cannot tell empty from exhausted) | App PR #56 (merged, published): exhausted topic says "finished"; neutral wording otherwise. David confirmed "success". Full-page empty state wording unchanged; a backend answered-count (option B) would be exact. |
| AP Chemistry 2.2 is thin: 4 practice MCQs, 1 FRQ, 1 teaching MCQ | Content pipeline matter, not changed. |
| Marketing prompts 1 and 2 were already live (sent by someone other than this session) | Noted; trial is public. |

## Cleanup (executed on David's "Delete it", 2026-11-10)
Deleted the test account `david@cramapple.com` and its rows in one atomic block, guarded to the single `trial_v2` student created that day: outbox event, `trial_v2` consumed-email row (so the address can be reused for a test), auth flow-state rows, attempts (cascading responses and grading results), learning sessions, then the auth user (cascading profile, entitlement, grading log, memory rows). A first attempt rolled back on the `response_versions.created_by` foreign key; attempts must be deleted before the user. After: user 0, `trial_v2` entitlements 0, grading log 0, consumed emails 0, outbox 0, no orphan profiles or attempts, 3 paid and 21 legacy trial rows unchanged, `cardless_trial_enabled=true`, `sample_access_enabled=false`.

## Still open
First real traffic watch (30/hour auth email cap, 40/day grading cap, cost); first real checkout after `APPROVAL-0213` (card trial off, not exercised); D6 analytics and D7 nurture; Reddit conversion definition (`DECISION-0129`); optional "No card needed" line; empty-state wording and backend answered count.
