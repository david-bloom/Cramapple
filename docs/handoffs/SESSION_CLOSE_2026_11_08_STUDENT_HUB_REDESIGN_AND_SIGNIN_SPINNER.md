# Session close — student hub redesign direction (mock first) and the sign-in spinner fix

**Sessions:** 2026-11-02 to 2026-11-04 (documented 2026-11-08). **Owner:** David Bloom. **Status:** hub redesign is a clickable mock only, nothing for production; the spinner incident is closed (`APPROVAL-0205`).

## Part 1 — Student hub redesign

### Owner direction (in session; not yet ratified as a `DECISION-NNNN`)

1. **Audience:** a new trial student. The first screen must be obvious and guiding. Signup and the first experience are likely on a **phone**; laptop is the main surface for returning use. (Earlier "desktop only" scope was superseded by this.)
2. **Two big first choices, no emphasised default** (Codex's approach chosen over Fable's four tiles with one recommended): **Bring a question** and **Choose a topic**. Choosing a topic then offers **Show me how** (published worked example), **Practice**, **Get the notes**; none emphasised. This reopens the "worked example recommended, never required" line of `DECISION-0100`; needs a recorded decision.
3. **Mock first.** Lovable builds a clickable mock at `/hub-mock` (no production behaviour, no network calls, not linked, redirects away on the production domain); nothing is built for production until the mock is evaluated.
4. **Communication layer:** a config-driven "message from CramApple" slot (one at a time, dismissible, a dismissed message never returns) plus a skippable 30-second tour, so the team can prompt action or offer a tour without code changes. In-app only so far; email is not designed.
5. **Homework help ("Bring a question")** shows a left pane of how points are earned and lost and a right reference pane, never the student's answer; a toggle switches to a published, automatically topic-matched worked example (a different question, shown in full) and back without losing state. **MCQs show only the right pane.** David's stated vision is that CramApple *explains* to the student, not just shows relevant information; the live product does not yet write an explanation for the student's own question (BYOQ today reads a photo, the student confirms every field, then reference material is shown). The mock labels this "Vision - not built yet".
6. **Sharing:** a public Cheat Sheet page is acceptable; share worked examples and Cheat Sheet entries, never the student's own question, photo or scoring view; the friend enters their own email on the shared page (no sharer-typed friend emails, no address-book import). Under-18 students may share if they accepted the Terms and Privacy Policy, expected at registration. The security-review COPPA/FERPA counsel item remains open.
7. **Visual:** more colour, larger imagery, minimum text 18px in the mock (raises the 16px design-system floor; not ratified), 7-day trial day shown plus an exam countdown, white cards with a colour accent for secondary options.

### Findings (read-only reviews by Fable, from code; no student data exists, zero trials)

- New-student hub today (`HomeStageANew`): "Not set yet / can't estimate yet" strip, an exam arc, one box with two dropdowns, four small grey 14px doors in a 320px column (three disabled until a unit is saved), then empty curriculum and "What happens next" sections. Slice 3 "first-use clarity" of the 2026-10-08 plan never shipped.
- Returning students (1-2 attempts and 3+) both render `HomeStageBBuilding`; there is no separate personalized layout. The hub fires no PostHog events (autocapture and pageview off) and has no share feature.
- The 760px `.cm-content` cap makes the hub a narrow column on laptops (a CSS wrapper, laptop-only; harmless on phones).
- The best content (Cheat Sheet) sat at the bottom under four empty panels.

### State of the mock (from David's screenshots, not independently verified)

Phone first screen now fits hero band (welcome, trial day, countdown, headline), one-line tour strip and both main tiles (yellow, dark ink), then white "Already know how you want to study?" cards. Lovable app commits on `main` (ap-prep-blueprint) from 2026-11-03 are `/hub-mock` work (tip seen: `ba53fdf`). Not verified: that `/hub-mock` is unreachable on the production domain; that Lovable made no change to the shared shell (Lovable was told not to, and to list network requests); laptop layout; the clickable flows.

### Open

1. Five small fixes offered, not confirmed sent: "Day 1 of your 7-day free trial" wording; Demo button covering content; equal tile padding; "Get the notes" orphan word; icon alignment on cards.
2. Laptop screenshot and a click-through of the tour, topic picker, two-pane homework view, share preview and friend page.
3. A first-visit screenshot on a fresh account (phone and laptop), and 4-5 unprompted real-student tests of the phone version.
4. Hub analytics events before any production UI change; soft-paywall design (the hub will know trial start and end dates).
5. Decisions to record: two-path first screen; no emphasised door; 18px floor; sharing scope; homework-help "explains, no answer" boundary (accuracy and answer-leak checking before it is built; harder for MCQs).
6. Counsel path for friend-email capture and under-18 sharers.

## Part 2 — Sign-in spinner (closed)

Signed-in users saw a spinner because the published app called `get_study_subject_keys` and `has_study_pack_access`, which were not in Production; the subject-access migration was unreleased and the app had been published ahead of its backend. David approved the release; the migration and the `session-event` / `student-session-items` deploys went out, verified, and David confirmed sign-in works. Full record: `APPROVAL-0205` (PR #585, merged). Open: what the app shows a user whose subject list is empty (one recent unentitled user exists); independent QA of `WORK-SUBJECT-ACCESS`. Lesson: a Lovable publish ships everything merged to `main`; check for unreleased app PRs whose backend half is not in Production before publishing.
