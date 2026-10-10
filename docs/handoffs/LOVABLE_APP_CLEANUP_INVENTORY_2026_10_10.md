# Lovable app cleanup inventory — 2026-10-10

**Repo:** `david-bloom/ap-prep-blueprint` (Lovable `56cae479`, app.cramapple.com) at commit `efbd79b`. **Method:** a static import graph over every tracked file, resolving `@/`, `@packages/`, relative paths, `.js`→`.ts`, CSS `@import`/`url()` and dynamic `import()`. There are no `import.meta.glob` calls in `src`. Entry points: `router.tsx`, `server.ts`, `start.ts`, `styles.css`, `routeTree.gen.ts` and every route file. Routes were classified by source as live, redirect-only or `RetiredRouteGate`. **Nothing has been deleted.** Every removal waits for Product Owner approval, then goes in small commits, each followed by a build, the full test suite and the local visual harness.

## Summary

| Group | Files | Recommendation |
|---|---:|---|
| A. Not reachable from any route (non-test) | 129 | Delete, together with their tests (B) |
| B. Tests whose only subject is group A code | 25 | Delete with A |
| C. Reachable only through retired/redirect routes | 16 | Delete; the routes themselves stay as redirects |
| D. Legacy design mock at `/cramapple` (old `App.jsx` HashRouter + sample content) | 23 | **Decision:** keep as the visual reference until `/question` is rebuilt on its parts, then retire |
| E. Static and demo material outside `src` | see E | Delete the mocks; decide on `supabase/` and `remotion/` |
| F. Kept on purpose | see F | Keep |
| G. Duplicated question-page components | see G | Consolidate onto the design-system parts (separate step) |

## A. Not reachable from any route

**src/components/ui** (44)
- `src/components/ui/accordion.tsx`
- `src/components/ui/alert-dialog.tsx`
- `src/components/ui/alert.tsx`
- `src/components/ui/aspect-ratio.tsx`
- `src/components/ui/avatar.tsx`
- `src/components/ui/badge.tsx`
- `src/components/ui/breadcrumb.tsx`
- `src/components/ui/calendar.tsx`
- `src/components/ui/card.tsx`
- `src/components/ui/carousel.tsx`
- `src/components/ui/chart.tsx`
- `src/components/ui/checkbox.tsx`
- `src/components/ui/collapsible.tsx`
- `src/components/ui/command.tsx`
- `src/components/ui/context-menu.tsx`
- `src/components/ui/dialog.tsx`
- `src/components/ui/drawer.tsx`
- `src/components/ui/dropdown-menu.tsx`
- `src/components/ui/form.tsx`
- `src/components/ui/hover-card.tsx`
- `src/components/ui/input-otp.tsx`
- `src/components/ui/input.tsx`
- `src/components/ui/label.tsx`
- `src/components/ui/menubar.tsx`
- `src/components/ui/navigation-menu.tsx`
- `src/components/ui/pagination.tsx`
- `src/components/ui/popover.tsx`
- `src/components/ui/progress.tsx`
- `src/components/ui/radio-group.tsx`
- `src/components/ui/resizable.tsx`
- `src/components/ui/scroll-area.tsx`
- `src/components/ui/select.tsx`
- `src/components/ui/separator.tsx`
- `src/components/ui/sheet.tsx`
- `src/components/ui/sidebar.tsx`
- `src/components/ui/skeleton.tsx`
- `src/components/ui/slider.tsx`
- `src/components/ui/sonner.tsx`
- `src/components/ui/switch.tsx`
- `src/components/ui/tabs.tsx`
- `src/components/ui/textarea.tsx`
- `src/components/ui/toggle-group.tsx`
- `src/components/ui/toggle.tsx`
- `src/components/ui/tooltip.tsx`

**src/lib** (19)
- `src/lib/ai-grader.server.ts`
- `src/lib/attribution.ts`
- `src/lib/checkout-pending.ts` *(imported only by tests)*
- `src/lib/checkout.ts` — tests: `checkout.test.ts` *(imported only by tests)*
- `src/lib/competitors.ts`
- `src/lib/config.server.ts`
- `src/lib/cv-contrast.ts`
- `src/lib/frq-patterns-head.ts`
- `src/lib/frq-question-head.ts` — tests: `frq-question-page.test.ts` *(imported only by tests)*
- `src/lib/frq-question-registry.ts`
- `src/lib/grading-schema.ts`
- `src/lib/grading.functions.ts`
- `src/lib/lovable-auth.ts`
- `src/lib/seo-schemas.ts` *(imported only by tests)*
- `src/lib/student-invite.ts`
- `src/lib/subjects.ts`
- `src/lib/trial.ts`
- `src/lib/unit-route-head.ts`
- `src/lib/use-published-exam-pack-version.ts`

**src/components/marketing** (10)
- `src/components/marketing/FrqDemo.tsx`
- `src/components/marketing/FrqPatternsPage.tsx`
- `src/components/marketing/FrqQuestionPage.tsx` *(imported only by tests)*
- `src/components/marketing/HandDrawnExplainer.tsx`
- `src/components/marketing/LegalDoc.tsx`
- `src/components/marketing/RelatedFrqQuestions.tsx`
- `src/components/marketing/ScoreMaxCallout.tsx`
- `src/components/marketing/SeoArticle.tsx` *(imported only by tests)*
- `src/components/marketing/SkuMarketingPage.tsx`
- `src/components/marketing/UnitArticle.tsx`

**src/screens** (9)
- `src/screens/LiveOpenHand.jsx`
- `src/screens/LiveOpenHandFrq.jsx`
- `src/screens/LiveOpenHandMcq.jsx`
- `src/screens/LiveOpenHandTeaching.jsx` — tests: `p0-handoff-answered.test.tsx` *(imported only by tests)*
- `src/screens/LivePracticeFrq.jsx`
- `src/screens/LivePracticeMcq.jsx`
- `src/screens/OpenHandPreviewScreen.jsx`
- `src/screens/PracticeFrqScreen.jsx` — tests: `practice-qa-package1.test.tsx`, `practice-qa-package3.test.tsx`, `question-pane-aids.test.tsx`, `visual-qa-remediation.test.tsx` *(imported only by tests)*
- `src/screens/PracticeMcqScreen.jsx` — tests: `deep-dive-full.test.ts`, `plate-loop-followup.test.tsx`, `practice-qa-package1.test.tsx`, `practice-qa-package3.test.tsx`, `question-pane-aids.test.tsx`, `subject-switch-active-session.test.ts`, `visual-qa-remediation.test.tsx` *(imported only by tests)*

**src/lib/live-practice-frq** (5)
- `src/lib/live-practice-frq/adapt.ts` — tests: `open-hand-loop.test.ts`, `frq-photo.test.ts`, `live-practice-frq.test.ts` *(imported only by tests)*
- `src/lib/live-practice-frq/partial.ts` — tests: `practice-qa-package2.test.tsx` *(imported only by tests)*
- `src/lib/live-practice-frq/photo-review.ts` — tests: `frq-photo.test.ts` *(imported only by tests)*
- `src/lib/live-practice-frq/photo.ts` *(imported only by tests)*
- `src/lib/live-practice-frq/session.ts` — tests: `practice-cap-forwarding.test.ts` *(imported only by tests)*

**src/lib/question-experience** (5)
- `src/lib/question-experience/__fixtures__/draft-frq-resume.json` — tests: `question-experience-render.test.tsx` *(imported only by tests)*
- `src/lib/question-experience/__fixtures__/empty-session.json` — tests: `question-experience-render.test.tsx` *(imported only by tests)*
- `src/lib/question-experience/__fixtures__/graded-frq-retry.json` — tests: `question-experience-fixpass.test.tsx`, `question-experience-render.test.tsx` *(imported only by tests)*
- `src/lib/question-experience/__fixtures__/mcq-before-submission.json` — tests: `question-experience-fixpass.test.tsx`, `question-experience-render.test.tsx`, `question-topic-serve.test.tsx`, `question-topic-suggest.test.tsx`, `question-worked-example.test.tsx` *(imported only by tests)*
- `src/lib/question-experience/__fixtures__/mcq-graded.json` — tests: `question-experience-fixpass.test.tsx`, `question-experience-render.test.tsx`, `question-worked-example.test.tsx` *(imported only by tests)*

**src/screens/parts** (5)
- `src/screens/parts/FrqPhotoPanel.jsx` *(imported only by tests)*
- `src/screens/parts/Habits.jsx` *(imported only by tests)*
- `src/screens/parts/PracticeModeSelector.jsx` — tests: `visual-qa-remediation.test.tsx` *(imported only by tests)*
- `src/screens/parts/ScoringHelp.jsx` — tests: `practice-qa-package1.test.tsx` *(imported only by tests)*
- `src/screens/parts/StableLabel.jsx` *(imported only by tests)*

**src/lib/open-hand** (4)
- `src/lib/open-hand/adapt-frq.ts` — tests: `open-hand-loop.test.ts` *(imported only by tests)*
- `src/lib/open-hand/adapt-mcq.ts` — tests: `open-hand-loop.test.ts` *(imported only by tests)*
- `src/lib/open-hand/practice-guides.ts` — tests: `subject-switch-active-session.test.ts` *(imported only by tests)*
- `src/lib/open-hand/unit-progress.ts` — tests: `session-clarity.test.ts` *(imported only by tests)*

**src/lib/research-interview** (4)
- `src/lib/research-interview/fixtures.ts` — tests: `research-interview.test.ts` *(imported only by tests)*
- `src/lib/research-interview/instructions.ts` — tests: `research-interview.test.ts` *(imported only by tests)*
- `src/lib/research-interview/interviewer.ts` — tests: `research-interview.test.ts` *(imported only by tests)*
- `src/lib/research-interview/synthesis.ts` — tests: `research-interview.test.ts` *(imported only by tests)*

**src/components/home** (3)
- `src/components/home/ByoqHomeLink.tsx`
- `src/components/home/HomeMilestonesBanner.tsx`
- `src/components/home/TopicHome.tsx`

**src/lib/study-nav** (3)
- `src/lib/study-nav/practice-tally.ts` — tests: `practice-qa-package3.test.tsx` *(imported only by tests)*
- `src/lib/study-nav/practice-visit.ts` — tests: `practice-qa-package1.test.tsx`, `session-clarity.test.ts` *(imported only by tests)*
- `src/lib/study-nav/seen-counter.ts` — tests: `study-nav.test.tsx` *(imported only by tests)*

**src/components/score-check** (2)
- `src/components/score-check/ProgressSteps.tsx`
- `src/components/score-check/Shell.tsx`

**src/components/session** (2)
- `src/components/session/ResponseCapture.tsx` *(imported only by tests)*
- `src/components/session/SessionHamburgerMenu.tsx`

**src/content** (2)
- `src/content/privacy-policy.md`
- `src/content/terms-and-conditions.md`

**src/content/reviewer** (2)
- `src/content/reviewer/body.html`
- `src/content/reviewer/script.js`

**src/lib/live-practice-mcq** (2)
- `src/lib/live-practice-mcq/answered.ts` — tests: `p0-handoff-answered.test.tsx`, `session-clarity.test.ts` *(imported only by tests)*
- `src/lib/live-practice-mcq/bias.ts` — tests: `practice-bias.test.ts` *(imported only by tests)*

**src/components** (1)
- `src/components/CriterionCard.tsx`

**src/components/dashboard** (1)
- `src/components/dashboard/ui.tsx`

**src/content/ap-biology** (1)
- `src/content/ap-biology/units.ts`

**src/content/ap-calculus-ab** (1)
- `src/content/ap-calculus-ab/frq-2026-3.ts` — tests: `frq-question-page.test.ts` *(imported only by tests)*

**src/lib/api** (1)
- `src/lib/api/example.functions.ts`

**src/lib/course-mode** (1)
- `src/lib/course-mode/home-skills-rail.ts` — tests: `home-skills-rail.test.ts` *(imported only by tests)*

**src/main.jsx** (1)
- `src/main.jsx`

**src/session** (1)
- `src/session/grade.js`

Notes: `src/components/ui` holds the unused shadcn primitives. The marketing components moved to the separate marketing project (`61dd6602`) on 2026-09-22. `src/content/privacy-policy.md` and `terms-and-conditions.md` are referenced nowhere in this app.

## C. Reachable only through retired/redirect routes

Retired routes (`RetiredRouteGate`): _ux.session.frq.tsx, _ux.session.mcq.tsx, _ux.session.uncertain.tsx, _ux.setup.index.tsx, _ux.setup.subject.tsx, _ux.topic.tsx, open-hand-frq.tsx, session.index.tsx, session.setup.tsx. Redirect-only routes: _ux.bring-question.tsx, _ux.setup-paused.tsx, byoq-scaffold.tsx, open-hand-mcq.tsx, practice-frq.tsx, practice-mcq.tsx, reviewer-login.tsx. The route files and their helpers (`RetiredRouteGate.tsx`, `retired-routes.ts`, `legacy-question-search.ts`) **stay**, so old links and bookmarks keep working.

- `src/components/session/CaptureItem.tsx`
- `src/components/session/GradeResultView.tsx`
- `src/components/session/RecheckDialog.tsx`
- `src/components/session/ReportQuestionButton.tsx`
- `src/components/session/SessionFrame.tsx`
- `src/components/session/SessionParamsBar.tsx`
- `src/components/ux/HelpPanel.tsx`
- `src/lib/course-mode/confirm-transfer.ts`
- `src/lib/course-mode/lesson-openers.ts`
- `src/lib/course-mode/pilot-subjects.ts`
- `src/lib/device-capability.ts`
- `src/lib/session-celebration.ts`
- `src/lib/session/session-params.ts`
- `src/lib/use-grade-practice.ts`
- `src/lib/use-published-frq.ts`
- `src/lib/use-session-items.ts`

## D. `/cramapple` legacy design mock

`src/routes/cramapple.tsx` ("CramApple Design System Mock") mounts the old `App.jsx` HashRouter with sample Statistics content. It is the only path to these 23 files: `App.jsx`, `content/index.js`, `content/real.js`, `content/sample/apstats-2-2-frq-001.js`, `content/sample/apstats-2-2-mcq-001.js`, `content/sample/apstats-2-3-frq-001.js`, `content/sample/apstats-2-3-frq-002.js`, `content/sample/apstats-2-3-mcq-001.js`, `content/sample/apstats-2-3-mcq-002.js`, `lib/Scatterplot.jsx`, `routes/cramapple.tsx`, `screens/HomeScreen.jsx`, `screens/OpenHandFrqScreen.jsx`, `screens/OpenHandMcqScreen.jsx`, `screens/QuestionRoute.jsx`, `screens/parts/AnswerKeyRows.jsx`, `screens/parts/QuestionBody.jsx`, `screens/parts/QuestionPlate.jsx`, `screens/parts/Stem.jsx`, `screens/parts/radioKeys.js`, `session/progress.js`, `styles/app.css`, `styles/styles.css`. It is also the closest working implementation of the design-system question plate (`QuestionPlate`, `AnswerKeyRows`, `Stem`, `QuestionBody`). **Recommendation:** keep it until `/question` is rebuilt on those parts, then retire the route and these files together.

## E. Outside `src`

- `public/course-mode/*.html` (6) and `public/progress-mock-v2.html`: static mocks, referenced nowhere. **Delete.**
- `public/video/handdrawn-explainer.mp4` + `.jpg` (1.1 MB): referenced nowhere in this app. The marketing site may use its own copy. **Delete here** after checking the marketing project.
- `public/img/handdrawn-*.png`: used only by the unreachable marketing components (group A). **Delete with them.**
- `content/item-packages/*` (8): used only through `/cramapple` (`content/real.js`). **Goes with D.**
- `remotion/` (13 files): a separate video-rendering project for the hand-drawn explainer, not part of the app build. **Decision:** move it to its own repo, or delete it if the video is final.
- `supabase/` (23 migrations dated June–July 2026, `config.toml`, `pending/`, `tests/`): Lovable Cloud–era backend files. **The live backend is the Cramapple repo**, so this is a second, stale migration history. Nothing in the app build reads it. **Recommendation: delete.** Lovable Cloud is disabled for this project.
- `.lovable/plan/*.md` (25) and `.lovable/plan.md`: Lovable's own planning notes. They are platform-written; deleting them is harmless, but Lovable may write new ones. **Optional.**
- `tests/e2e` (2): kept. To be revived as real rendered checks.

## F. Kept on purpose

- `src/components/session/ConfettiBurst.tsx` — D10 keep (`ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md`)
- `src/components/session/ConfirmTransferBeat.tsx` — D11 generalize (`ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md`)
- `src/components/session/StreakBadge.tsx` — D11 keep (`ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md`)
- `src/components/session/WorkedExample.tsx` — D11 fold LessonOpener in (`ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md`)
- `src/components/auth/RetiredRouteGate.tsx` — needed by the redirect/retired routes
- `src/lib/retired-routes.ts` — needed by the redirect/retired routes
- `src/lib/study-nav/legacy-question-search.ts` — needed by the redirect/retired routes
- `src/imported-js.d.ts` — platform-managed (Lovable or Supabase scaffolding, type shims)
- `src/integrations/lovable/index.ts` — platform-managed (Lovable or Supabase scaffolding, type shims)
- `src/integrations/supabase/auth-attacher.ts` — platform-managed (Lovable or Supabase scaffolding, type shims)
- `src/integrations/supabase/client.ts` — platform-managed (Lovable or Supabase scaffolding, type shims)
- `src/routes/README.md` — platform-managed (Lovable or Supabase scaffolding, type shims)
- `src/routeTree.gen.ts` — generated by the router plugin

## G. Duplicates to consolidate (separate step, after deletions)

- The reference pane exists twice: `QuestionExperience.jsx` has its own `ReferencePane`, while `screens/parts/ReferencePane.jsx` provides `LookUp`/`RememberIt`, which `CompactReference.jsx` uses on BYOQ and Lesson Notes.
- The question plate exists twice: `qx-*` panes in `QuestionExperience.jsx` + `styles/question-experience.css`, versus the design-system `Plate`/`PlateGrid`/`PaneShell` and `QuestionPlate`/`AnswerKeyRows`/`Stem`.
- The app bar exists twice: `QuestionExperience.jsx` `AppBar` versus `StudyNav` with the `brand` prop.

Target: `/question` rendered on the design-system parts, with one reference component and one app bar. The duplicates are then retired the same way, with harness screenshots before and after.

## Status (2026-10-10)

- **`supabase/` and `remotion/` deleted**: `ap-prep-blueprint` commit `4834b1b`, approved by the Product Owner.
- **Groups A and B deleted** (approved): commit `2b8d053`. That commit removed 99 group-A source files and 4 group-B tests. Its message says 101; the two missing are `privacy-policy.md` and `terms-and-conditions.md`, which were restored because legal-wording tests read them from disk. The tests went from 105 files / 965 tests to 101 / 889, all passing. tsc and the build are clean.
- **Correction to group B:** only 4 tests cover nothing but group-A code. The earlier count of 25 included 21 tests that also cover live code. Those 21 stay. Five of them read deleted screens by file path; only those path entries were removed.
- **Held back: 28 group-A files** that surviving tests still import. Five of them are the `question-experience` fixtures, which are permanent (tests and the local harness use them). The rest are dead screens and helpers. Each one can go once the test cases that import it are removed:
  - `src/components/session/ResponseCapture.tsx`
  - `src/lib/course-mode/home-skills-rail.ts`
  - `src/lib/live-practice-frq/adapt.ts`
  - `src/lib/live-practice-frq/partial.ts`
  - `src/lib/live-practice-frq/photo-review.ts`
  - `src/lib/live-practice-frq/photo.ts`
  - `src/lib/live-practice-frq/session.ts`
  - `src/lib/live-practice-mcq/answered.ts`
  - `src/lib/open-hand/adapt-frq.ts`
  - `src/lib/open-hand/adapt-mcq.ts`
  - `src/lib/open-hand/practice-guides.ts`
  - `src/lib/open-hand/unit-progress.ts`
  - `src/lib/question-experience/__fixtures__/draft-frq-resume.json`
  - `src/lib/question-experience/__fixtures__/empty-session.json`
  - `src/lib/question-experience/__fixtures__/graded-frq-retry.json`
  - `src/lib/question-experience/__fixtures__/mcq-before-submission.json`
  - `src/lib/question-experience/__fixtures__/mcq-graded.json`
  - `src/lib/study-nav/practice-tally.ts`
  - `src/lib/study-nav/practice-visit.ts`
  - `src/lib/study-nav/seen-counter.ts`
  - `src/screens/LiveOpenHandTeaching.jsx`
  - `src/screens/PracticeFrqScreen.jsx`
  - `src/screens/PracticeMcqScreen.jsx`
  - `src/screens/parts/FrqPhotoPanel.jsx`
  - `src/screens/parts/Habits.jsx`
  - `src/screens/parts/PracticeModeSelector.jsx`
  - `src/screens/parts/ScoringHelp.jsx`
  - `src/screens/parts/StableLabel.jsx`
- **Finding:** a Lovable commit (`4a68e39`, 2026-10-10 03:29 UTC) aimed at the live `/question` page edited `QuestionPlate.jsx` and `OpenHandMcqScreen.jsx`. Only the `/cramapple` mock uses those two files, so Lovable is editing duplicate files the live page never loads.
