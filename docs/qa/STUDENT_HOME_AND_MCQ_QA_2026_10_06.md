# Student Home and MCQ QA - 2026-10-06

STATUS: PREVIEW IMPLEMENTED - release QA and content/backend gaps remain
Owner: Codex
Product Owner: David Bloom
Branch: `codex/student-home-practice-qa`
Related: TASK-0052, TASK-0047, TASK-0048
Frontend: Lovable `56cae479-f7c9-4988-b536-56538c38ee4e`

## Owner Request

David supplied four live screenshots and requested:

1. Entitled students can switch subjects while preserving practice progress.
2. "Where your class is" offers available units and topics.
3. Next Best Action is the Home hero; remove the top Live Session banner and put Resume session beside Start Practicing as a secondary action.
4. Restore practice hints with their existing assistance semantics.
5. MCQs have no rubric. The left Answer Key pane lists the correct answer and distractors with authored explanations; remove unintelligible scoring placeholders.
6. Keep center-pane choices compact and remove duplicate explanations so submission, grading feedback, and continuation are accessible.

Existing published topic notes must render when available; do not conceal them behind a blanket coming-soon message.

## Follow-Up: Study Navigation and Session Counter

Follow-up documentation branch: `codex/study-navigation-counter-qa`, based on current `origin/main` after PR #363 merged. Original workspace changes remain untouched.

Owner added two findings after the first preview: no mechanism to return to the student hub/change topic/change subject, and no count of questions seen in the session.

Baseline source confirms `QuestionPlate` disables the topic map for live/package questions, has no hub action or subject switcher, and uses a generic real-item status instead of progress. `LivePracticeMcq` and `LivePracticeFrq` own the real session ID and fetched queue; `SessionProvider.attempts` persists across sessions and is not a valid seen counter. The live routes wrap screens in a React Router MemoryRouter inside TanStack routing, so a memory-only `/home` navigation is not an actual app exit.

Build message: `umsg_01m4a21r2dfjk8nftzm9ppemng`. Preview only, based on `6aed5c8cbf1e4c8318d2a76a3f6eb88f12b6eea9`.

Required behavior: actual Student hub navigation, a working Change topic action to the real picker, reuse of the real subject-switch flow, unsent-answer/pending-grade guards, and a visible count of distinct items actually displayed (including skips), scoped to authenticated user/session/pack and resilient to reload, duplicate renders and unavailable storage. Do not count all fetched items, graded attempts, or answer-key disclosures; do not invent a total or cross-device server history.

First follow-up commit: `300c984d9b1d0b5cc76cd0cb9d6bdad1771cb82e` (connector-confirmed). Source adds `StudyNav` across live MCQ/FRQ/Open Hand states, real `/home` and `/home#change-topic` links, inline subject switching with a leave guard, picker anchors across Home stages, and browser-local distinct-item tracking keyed by user/pack/real learning session. Lovable reports 73 files / 654 tests passing, typecheck/build exit 0; no signed-in or phone browser checks.

Review correction message: `umsg_01m4b4g7wefngb3xzscmf01f9h`. Review found aggressive counter pruning deleting other resumable sessions' counts, potential old-queue/new-identity counting during subject/user changes, effect-only pending guards, unguarded existing exit actions, and animated anchor scrolling despite the no-motion rule. Requested corrections and actual shared-component mobile geometry checks.

Counter limitation: the current teaching-pool Open Hand MCQ route has no real learning session, so this build hides the real-session count there instead of inventing one. Practice MCQ/FRQ and session-backed Open Hand use their actual session IDs. Counts are browser-local, not cross-device server evidence. Change topic returns to the real hub picker and does not retain the previous MCQ/FRQ format.

Final follow-up commit: `64352ecbf26da46b26a235d142fefddf1043d82f` (connector-confirmed). Reviewed diff replaces aggressive pruning with a 30-session recency history per user, binds fetched queues to their owning user/pack before rendering/counting, reruns fetches on authenticated-user changes, adds synchronous in-flight locks around grading/feedback/reveal calls, routes existing outward buttons through the leave guard, makes selected-subject selection a no-op, and uses nonanimated picker focus. Inline subject controls and menus wrap within viewport constraints.

Lovable-run final checks: `npx tsgo --noEmit` exit 0, `bunx vitest run` exit 0 (73 files / 673 tests passing), `npm run build` exit 0, with command statuses captured rather than merely the status of `tail`. An initial build failed on an FRQ variable-name collision; it was repaired before the final checks. Test coverage combines pure helper behavior, static markup and source assertions, not mounted end-to-end interaction tests.

Lovable also measured a headless isolated harness rendering the real `StudyNav` and `SubjectSwitcher` with the real stylesheet, stubbed authenticated subject/router data, the long Physics C E&M name and counter 12. At 320, 390 and 1280px: no page overflow, control overlap or off-screen controls; open-menu horizontal bounds were 12-304, 12-304 and 305-612px. This verifies shared-component geometry, not the complete signed-in question screen.

Remaining limitations: browser-local count only (30 recent real-session counters retained); no counter for the sessionless teaching route; Change topic does not carry the previous MCQ/FRQ format; blocked older outward buttons do not show the study bar's blocking message. The sessionless teaching route was not given the fetched-queue identity guard, so its existing transient old-item display during switching remains a separate gap. Signed-in desktop/mobile walkthrough and fresh independent release QA remain required. No publishing or backend/data changes were performed by this preview build.

Browser check (2026-10-07): the actual Lovable editor preview at `/practice-mcq` rendered Student hub and Change topic in the no-subject state. Clicking Student hub navigated the real iframe to the Home loading screen, then Sign in. This verifies a real app navigation, not signed-in hub behavior or the session counter. The preview remains unauthenticated; owner was asked to sign in for full walkthrough QA. No sign-in email was sent, question answered, key disclosed, or subject/course position changed by this check.

## Verified Baseline

- Production account has current, nonexpiring beta entitlements for all ten active subjects. No entitlement writes were necessary.
- Live browser inspection reproduced MCQ Rubric and scoring placeholders, duplicate center-pane rationales, and the reference-pane coming-soon message.
- Production has three active Chemistry sessions for the account. The switch RPC rejects a change while any session on the current pack remains active.
- `parkCurrentSession` only uses browser session pointers, swallows save failures, records parking even when ending fails, and clears pointers before knowing the switch succeeded. A session absent from those pointers remains blocking.
- The authenticated Production taxonomy RPC returns all nine Chemistry units, topics, and published guide availability.
- The early-evidence Home component takes unit options from `snapshot.units`; the snapshot builds those with static `getUnitsForSubject`, unlike the later TopicHome's live taxonomy query.
- A fresh live Home load showed the later TopicHome with working Chemistry unit/topic options, confirming the screenshot's unavailable-unit issue depends on the Home stage. This does not verify topic persistence in the early stage.
- Production course-position storage already has `topic_code` and `topic_source`. The frontend server function writes these columns directly under authenticated access; no schema change is established as necessary.

## Implementation Checkpoint

Baseline frontend commit: `9ecbee88f4a4901ced859464396b5ec0cb0e6ac1`.
Lovable build message: `umsg_01m4a0phm9fk58wrjqan6q2zay`.
First build commit: `d148d31492e5dfdab28df8687970a3cc8301dd16` (connector-confirmed).
Review-correction message: `umsg_01m4a188fzftwr0hvh9paa51sz`.
Second build commit: `319c9346476df08e182334ddf508339a83d6878e` (connector-confirmed).
Final focused review message: `umsg_01m4a1m6dmevnsx1crg3qx7brj`.
Final implementation commit: `6aed5c8cbf1e4c8318d2a76a3f6eb88f12b6eea9` (connector-confirmed).
Verification-only message: `umsg_01m4a1v1vyfhstf1gkw2mk7bbp`.
Instructions require real entitlement checks, progress preservation, live taxonomy, gated answer disclosure, authored hints and rationales, and FRQ rubric preservation.

The build is restricted to preview code. Production publishing, Edge Function deployment, migrations, and production data changes are separate actions.

## Source Review and Known Limits

- First-build source moves authored MCQ rationales to the left Answer Key, removes MCQ rubric/scoring-help controls, and keeps center answer choices compact. FRQ still uses scoring help.
- First-build automated results are Lovable-reported: 626 passing tests, clean typecheck and build. They are not a signed-in browser certification.
- Review requested corrections to the default Learn-mode hero/resume, current-pack session scoping, failure handling, entitlement checks before parking, and narrow-screen unit/topic layout.
- Second-build source adds the default Learn-mode Next Best Action hero and secondary active-session Resume, moves its orientation controls below the action, makes Stage B position controls stack below 560px, and pages server session lookup by user/previous pack. Lovable reports 635 passing tests and clean typecheck/build; standalone selector layout checked at 320, 390, 700 and 1280px, not signed-in end to end.
- Further review found two remaining frontend defects: Open Hand MCQs still use rubric controls and center rationales; initial local-pointer parking can precede authoritative pack validation. The final focused message requests these corrections and honest archived-resume semantics.
- Final source diff resolves those two defects: Open Hand MCQs have no scoring-help controls, render authored rationales once in the left key, and keep center choices compact; subject switching queries the authoritative current-pack active-session list before any archive and retries once on a concurrent session blocker. Browser-only/stale other-pack pointers are no longer authority for archiving. FRQ rubrics remain intact.
- Final implementation tests are Lovable-reported: 632 pass, typecheck clean. The obsolete local-pointer parking test file was removed and replaced with authoritative-switch tests. These use static rendering and mocked server replies, not an authenticated real switch. A fresh final build was requested separately because the implementation response could not confirm its build postdated the edits.
- The live switch RPC does not enforce entitlements itself: selectable-pack checks and active-session checks are distinct from access checks. Do not describe a frontend access check as a backend security boundary.
- Production `session-event` v45 and repository source show `session_resume` reading the stored session without reactivating it. An archived session remains archived; the client accepts only active sessions. Exact parked-session resume is therefore not verified and cannot be claimed as fixed by a frontend-only change.
- The sampled spectator-ion item `apchem-mcq-010` has no resolved topic label. Published Chemistry taxonomy/guides exist, but topic guidance cannot attach reliably to this item. The topic requested in a Home URL is not proof of the served question's topic.
- Served practice-item payloads contain no authored item hints. The preview offers authored topic-brief guidance on labeled items, with assisted-attempt tracking. This does not restore item-specific hints for every question.
- The authenticated editor preview reaches Sign in; a signed-in custom-domain tab can be inspected, but cannot be reliably bound to an unpublished commit. No magic-link email was sent and no account/session data was changed for QA.

## Verification and Release

Source review complete for the three implementation checkpoints above.

Verification-only turn confirms a clean frontend tree at `6aed5c8cbf1e4c8318d2a76a3f6eb88f12b6eea9`, then reports `npx tsgo --noEmit` with no errors, `bunx vitest run` with 72 files / 632 tests passing, and `npm run build` completing client/server bundles (`built in 10.32s`). These are Lovable-run checks, not local reruns. Its displayed typecheck/build commands pipe output through `tail` without `pipefail`, so the displayed pipeline exit code alone is not an independent underlying-command exit-code check; the reported completion/output is the build evidence.

QA record: draft documentation PR #363, `https://github.com/david-bloom/Cramapple/pull/363`. This PR contains documentation only; frontend code lives in the Lovable project.

Still required before production release:

1. Signed-in desktop/mobile checks of subject switching, each Home stage's position controls, secondary active-session Resume, labeled-question hints, and both MCQ layouts.
2. Fresh independent QA under TASK-0052 and explicit owner publish go-ahead.
3. Separate resolution of missing item topic labels/authored item hints and the archived-session reactivation gap. The current preview is not a complete fix for hints on every question or exact parked-session resumption.

No production data, entitlement, schema, function, or publishing changes were made in this session.
Do not mark the work Done or claim signed-in end-to-end certification from screenshots, source inspection, or mocked tests alone.
