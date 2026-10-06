# QA — Student Hub, Open Hand, Practice (candidate build `3fee18a5`)

**Date:** 2026-10-06
**Reviewer:** independent QA (Fable), code- and data-level only. The live site could not be opened from this sandbox; every "what the student sees" statement below is derived from the Lovable source at commit `3fee18a59b769f976079dc30179144a5c32dfd9a`, the repo under `/home/user/Cramapple`, and read-only SELECTs against Production (`pcntajvbdfqhbeewmdry`). Where a judgment needs eyes on the screen, section 4 says so.
**Scope:** `/home` (HomeV2 Stage A / Stage B / TopicHome), `/open-hand-mcq` (LiveOpenHandTeaching), `/practice-mcq` and `/practice-frq`, plus the serving and grading paths behind them. Reviewed as if `isPlateLoopEnabled()` were ON; today-with-flag-OFF issues are called out separately.

---

## 1. Verdict

**No — not fit for new students if the plate loop is turned on, and one of the problems is live today with the flag OFF.** The Practice template can still be handed an Open Hand teaching item (the deployed `student-session-items` has no teaching filter, and the client falls back to a direct read of every published MCQ because the unit-gated selector returns zero MCQs for a `targeted_drill` session); when the student submits, the database trigger refuses the attempt and the screen shows an un-recoverable "We couldn't grade that one. Try again." Independently, the Practice result never shows the correct answer after a miss, and a brand-new AP Biology student whose class is in Unit 1 reaches an Open Hand page with no question and no way forward. Open Hand itself still hides the credited rationale behind a click and prints the literal "Credited." that David rejected.

---

## 2. Findings, ranked

Severity scale: **Blocker** (strands or misleads a student, or breaks a stated invariant) / **Major** (clearly wrong, student can still proceed) / **Minor** / **Polish**.

### Blockers

#### B1. Practice can serve a teaching item and then dead-ends on submit — today and under the flag

**Flow:** Open Hand → "Try one on your own" → `/practice-mcq`; also today's `/session` with the flag OFF.

**What I found.**
1. `LivePracticeMcq` fetches items with `mode: "unit_gated"` and a session started with `practice_format: "targeted_drill"` (`src/lib/live-practice-mcq/session.ts`, `PRACTICE_FORMAT`, `fetchPracticeMcqItems`). The edge function forwards `session.practice_format` to `select_unit_gated_practice_items`, which filters `ci.practice_format = _practice_format`. In Production that returns **0 MCQs** for both Day-1 packs:

   ```sql
   select count(*) from public.select_unit_gated_practice_items('2d88ba5e-…', 1, 'targeted_drill', 'mcq', 50); -- biology, unit 1 → 0
   select count(*) from public.select_unit_gated_practice_items('548f06be-…', 1, 'targeted_drill', 'mcq', 50); -- ap-statistics → 0
   -- same call with _practice_format = null → 4 (bio U1), 25 (bio U2), 31 (bio U4), 50 (stats)
   ```
2. On zero items the client falls back to `fetchPublishedMcqFallback` → `buildPublishedMcqQuery` (`src/lib/use-published-mcq.ts`), a direct PostgREST read of **every published MCQ in the pack**, ordered by `published_at`, with no unit scoping and **no teaching-item exclusion** (the TASK-0064 migration patched four SQL selectors, not this read). For the Biology pack, the 4th item in that order is `APBIO-MCQ-016`, a designated teaching item (`app.content_item_is_teaching` = true).
3. The deployed `student-session-items` (Supabase version 32, last updated ~2026-09-29) contains **no** `dropTeachingItems`, `open_hand_teaching_items` or `annotateOpenHandExclusions` (checked the deployed source: 0 occurrences of each; `cell_scoped` is present). So neither the `cell_scoped` path nor the `open_hand_excluded` mark exists in Production; `scorableOnly()` is a no-op.
4. When the student submits a teaching item, `attempt-response` `create_attempt` inserts into `app.attempts`, the trigger `trg_refuse_attempt_on_teaching_item` raises, and the function returns a generic **500 `attempt_create_failed`** (`supabase/functions/attempt-response/index.ts` ~L520). The client only special-cases codes containing `open_hand_item_not_scorable` (`src/lib/open-hand/loop.ts`), so `PracticeMcqScreen` shows "We couldn't grade that one. Try again." and the button becomes "Try again" — forever on that item. The only exit is the small "Skip for now" link.
5. **Today, flag OFF:** `/session` for the AP Statistics pilot uses the deployed `cell_scoped` mode (`src/lib/course-mode/serving-path.ts`), and non-pilot subjects with an explicit `mcq` format use the same client-side published read. Both can serve the 14 Statistics / 2 Biology teaching items designated on 2026-10-06. This is live now.

**Why it matters.** A student's first scored question can be one whose full key is face-up elsewhere, and their first submit fails with an error that blames the grader. The TASK-0064 invariant "teaching items are excluded from all scored practice" does not hold in Production.

**Fix.** (a) Deploy `student-session-items` with `dropTeachingItems` before any further designation, as TASK-0064 already requires. (b) Either make the Practice session format compatible with MCQ serving (pass `null`/an MCQ-compatible `practice_format`, or start the session without `targeted_drill`) so `unit_gated` actually returns MCQs, or delete the client fallback; a scored path must never read `content_item_versions` directly. (c) Map the trigger's `open_hand_item_not_scorable` to a 409 with that code in `create_attempt`, so the existing client handling fires. (d) Until (a) is deployed, release the 16 Biology/Statistics spare items or keep the flag OFF **and** accept that `/session` is exposed today.

#### B2. Practice MCQ result never reveals the correct answer; the picked row is always tagged "Distractor"

**Flow:** Practice → submit → result.

**What I found.** Live choices arrive without `is_correct` (server strips it; `toPracticeQuestion` keeps only `choice_key`/`text`). After submit, `PracticeMcqScreen` does:

```js
const shown = submitted ? question.choices.filter((c) => c.is_correct || c.choice_key === attempt.picked) : question.choices;
… <RadioOptionRow verdict={c.is_correct ? 'correct' : 'distractor'} showVerdict={submitted} …
```

So `shown` is only the picked row, its tag is **"DISTRACTOR" even when the answer was correct** (`is_correct` is undefined), and the caption "The 3 options you did not pick are explained in the Answer Key" is false: `toRecordedAttempt` (`src/lib/live-practice-mcq/grade.ts`) builds exactly one mark, for the picked choice. `EvaluateAttemptResult` carries no `correct_choice_key`, so a student who misses never learns which option was credited, and a student who is right sees a "Correct" verdict chip next to a "Distractor" tag.

**Why it matters.** The pedagogy rule is "per-choice (MCQ) mark list" after one submission; instead the student gets a contradictory screen and no key.

**Fix.** Return the credited key (and ideally per-choice rationales) in the graded response for MCQ, build `marks` for every choice, and stop deriving `verdict` from a field the live item does not have.

#### B3. New Biology student: "Start practice" lands on a page with no question and no next step

**Flow:** Home Stage A → set position (Unit 1) → "Start practice →" → `/open-hand-mcq`.

**What I found.** Teaching coverage in Production (`app.open_hand_teaching_items`, released_at is null): **AP Biology 2 of 60 topics** (2.7, 4.3) — none in Units 1, 3, 5, 6, 7, 8. **AP Statistics 14 of 55** — Unit 1 has 4 of 13 (1.6, 1.7, 1.11, 1.13). `resolveStartTopic` picks `?topic=` → saved topic → first topic of the saved unit. For a Biology student at Unit 1 (or any topic other than 2.7/4.3) `get_open_hand_teaching_item` returns null (verified with a simulated entitled student: `biology/1.1 → null`, `ap-statistics/1.1 → null`), and `LiveOpenHandTeaching` renders the placeholder plate: both the Answer Key and Question panes say "A worked example for this topic is coming soon." The placeholder has **no "Next question"** — only "Try one on your own" (→ B1) and "Return Home". `findNextTeachingTopic` is only reachable from a loaded question, and it probes **later topics in the same unit only** (`laterTopicsInUnit`), never other units.

**Why it matters.** The most likely first click for a new Biology student in the fall (Unit 1 or 2) produces a dead end dressed as a product screen, and the Home button that got them there is labelled "Start practice".

**Fix.** Either gate the plate-loop entry per subject/topic on real coverage (fall back to `/session` when the topic has no teaching item), or make the placeholder search forward across the whole course for the nearest teaching item and say which topic it jumped to. Do not turn the flag on for Biology with 2 items.

### Major

#### M1. Open Hand does not "show everything on load"; it still prints "Credited."

**Flow:** Open Hand with a loaded question.

**What I found.** In `OpenHandMcqScreen.jsx` the Answer Key row renders `c.is_correct ? 'Credited.' : (c.minimum_fix || 'No fix line in this package.')`. The RPC sets `minimum_fix = rationale`, so distractors show their rationale, but the **credited choice shows the literal word "Credited."** — the exact output David rejected on 2026-10-06 (TASK-0064 "Why"). In the Question pane, `explanation={picked === c.choice_key ? c.rationale : undefined}`: **every rationale is hidden until the student clicks that option**. "Nothing is gated" (CONTENT_AND_PEDAGOGY.md) is not met; the key is face-up, the explanations are not. "No fix line in this package." is internal vocabulary.

**Fix.** Render every rationale on load (key pane or question pane, not both), show the credited rationale in the key row, and drop "No fix line in this package."

#### M2. Practice panes are full of developer placeholders

**Flow:** Practice, before and after submit.

**What I found.** Live items have `scoringNote: null`, `hints: []`, `deepDive: null`, `habits: null`, `reference: null` (`src/lib/live-practice-mcq/adapt.ts`). `PracticeMcqScreen` therefore renders four `<Missing>` blocks in the Scoring pane, each headed "NOT IN THIS PACKAGE" with bodies such as "How points are earned / lost — not in the package schema." and "No hint is defined, so nothing says which distractors an elimination hint would strike." (`src/content/adapter.js` `MISSING`). The Reference pane shows "Topic, skills, vocabulary, on-the-exam — not in the package schema." (`ReferencePane.jsx` falls to `MISSING.reference` because Practice passes no `emptyMessage`). After submit the single mark says "No fix in the package" when the grader returns no explanation. `Missing.jsx` says it is "deliberately not styled like product UI"; it is still on a student screen.

**Fix.** Give Practice the same guide-backed reference/deep dive Open Hand has (`fetchTopicGuides` already works per topic), and replace every `MISSING.*` string with student-safe empty states or omit the block.

#### M3. Subject picking and Home ignore entitlements

**Flow:** First load of `/home` with no active subject; subject switching.

**What I found.** `NeedsSubject` lists `activeSubj.available` = **every active subject with a published pack (10 today)**, not the student's entitled subjects (`useAvailableSubjects` never reads `subject_entitlements`). The "exactly one → auto-select" branch can therefore never fire. `complete_onboarding` and `set_active_exam_pack_version` validate only `exam_pack_version_is_selectable` (checked `pg_get_functiondef`; neither references `subject_entitlements`). `loadStudentHome` has no entitlement check either. So a student who bought one subject (`stripe_checkout_single*`: 5 users in Production) can pick AP Chemistry, see a full Chemistry Home, press Start, and be told by Open Hand "This subject isn't unlocked on your account" → "Return Home" → loop. In Practice, `session_start` and `student-session-items` do no entitlement check (0 matches in those functions); only `submit_response`/`evaluate-attempt` do, so an unentitled or expired student answers a question and then gets the generic "We couldn't grade that one. Try again." Stage A also prints "10 subjects available" to that single-subject purchaser.

**Fix.** Filter the picker and the switcher by active entitlements; refuse `complete_onboarding`/`set_active_exam_pack_version` for unentitled packs; surface `entitlement_required` in Practice with a purchase/renew action.

#### M4. Home evidence is wrong for returning students (undercounted and cross-subject)

**Flow:** `/home` for anyone with history.

**What I found.** `loadStudentHome` maps `attempts.status` through `gradingStatusFrom`, counting only `graded|scored|complete|completed`. Production attempts: **50 `submitted` MCQ + 6 `submitted` FRQ attempts have `grading_results` rows with points, but `status` is still `submitted`; 28 `draft` FRQ attempts also have grades; only 2 attempts are `graded`.** The heaviest real user (`f5a26c6b…`, 46 graded MCQ results) would therefore render **Stage B with "You're at 2"** of 3; the user with 28 graded FRQs renders **Stage A "Cramapple has no work from you yet."** Separately, `summarizeEvidence(attempts, …)` is computed over **all** of the student's attempts regardless of `exam_pack_version_id` (only independence and point capture are scoped), so switching to a never-touched subject inherits the other subject's stage and evidence count.

**Fix.** Derive evidence from `grading_results` (or the authoritative graded state), not `attempts.status`; scope stage/evidence to the active pack.

#### M5. "Try one on your own" does not stay on the topic

**Flow:** Open Hand (e.g. Biology 2.7) → Practice.

**What I found.** `biasItemsToTarget` matches on `item.taxonomy.topic`. For fallback items (B1 path) that is derived by `readTopicFromKey` with `/-(\d+)-(\d+)-/`, which matches none of the real keys (`APBIO-MCQ-016`, `APSTATS-MCQ-SV-027-v1`), so topic is null and the bias is inert. The first Practice question for any Biology student is the oldest published MCQ in the pack (`APBIO-MCQ-017`, Na⁺/K⁺ pump, Unit 2) regardless of their unit or the topic they just studied. Unit position is also ignored by the fallback.

**Fix.** Serve via a selector that carries the resolved cell/topic (the repo's `cell_scoped` path does) and never fall back to the unscoped read.

#### M6. Home's call to action is labelled "Start practice" but opens a not-scored worked example

**Flow:** Stage A / Stage B / TopicHome → `/open-hand-mcq`.

**What I found.** `practiceEntry` (flag ON) sends every "Start practice →" / "Start →" / "Get started →" to Open Hand. The student arrives on a plate stamped "Worked example", "Not scored", "Selecting an option is free". Stage A's "What happens next" copy promises "After 3 graded attempts…"; the button it points to produces zero graded attempts. The intended flow (teach first, then score) is reasonable, but nothing on Home says so.

**Fix.** Label the button for what it does ("See a worked example, then practice") or add the one-line explanation on Home.

### Minor

- **m1. Open Hand "Next question" and end state.** Only later topics in the current unit are probed, never earlier ones or other units; the end copy "You've seen every worked example in this unit" is wrong when the student started mid-unit (`laterTopicsInUnit`). For Statistics Unit 1 starting at 1.1 the student sees the placeholder, not 1.6 — there is no "next" from the placeholder at all (see B3).
- **m2. `?topic=` is not validated against the active subject.** `/open-hand-mcq?topic=2.7` kept in a tab after switching subjects renders another subject's topic code in the breadcrumb, or "coming soon".
- **m3. `cramapple.session.v1` localStorage is never cleared** on logout or subject switch (`SessionProvider.jsx`; `SUBJECT_SCOPED_STORAGE_KEYS` does not include it). On a shared device the next student sees the previous student's "✓ read" marks and, if the same `content_item_version_id` is served again, a pre-filled "submitted" attempt.
- **m4. Stage B unit list is a static table for Biology and Statistics only** (`src/data/taxonomy.ts`). Any other subject in Stage B gets "Unit not available" and "Curriculum details are not available yet" while Stage A (RPC-driven) showed a full curriculum the day before.
- **m5. Entitlement check timing in Practice** (see M3): answering is allowed, submitting is refused; the refusal reads as a grader fault.
- **m6. Teaching RPC with a canonical key.** `get_open_hand_teaching_item('ap_statistics', …)` raises `open_hand:item_not_accessible`, which the client maps to "coming soon". Today's caller passes the raw `subjects.subject_key`, so it works, but any future caller using the canonical key will silently show the empty state.
- **m7. Stage A exam ring.** The SVG arc is a fixed ~135° stroke regardless of `daysToExam` — a decorative pseudo-progress indicator next to copy that promises "no fake bars".

### Polish

- **p1.** Two orange primary buttons side by side in Stage A after a position is saved ("Set my position →" and "Start practice →"); VISUAL_IDENTITY: one primary per screen.
- **p2.** `firstNameFrom` falls back to the email local part: "Welcome, dbloom01".
- **p3.** Open Hand `QuestionHeader` shows "1 point" beside "Not scored".
- **p4.** `LockedSubjectModal` in `SubjectSwitcher.tsx` uses `borderRadius: 16` / `999` and a green button (`#1c7c54`) — square-corner and colour rules broken on a flow a single-subject student will hit.
- **p5.** Legacy `.cv-*` classes in `src/styles.css` still carry transitions and `@keyframes` (reveal/spin). Not used by the three flows reviewed, but present in the bundle.

### Verified OK (so nobody re-litigates)

- **Answer-key exposure.** `public.mcq_choices` view (security_invoker) exposes `choice_key, choice_text` only — no `is_correct`, no `rationale`. `public.content_item_versions` exposes no `canonical_answer_*`; `public.frq_criteria` exposes `learner_facing_text, points_possible` only; there is no public `canonical_answer_spans` view. `app.open_hand_teaching_items` is RLS-forced, service-role read only. A student cannot read a scored item's key directly through PostgREST. (`prompt_json` and `help_text` are exposed on `content_item_versions`; I did not audit whether any item's `prompt_json` embeds an answer — see section 4.)
- `get_open_hand_teaching_item`: null for a topic without an item, full key with 4 choices and one `is_correct` for Biology 2.7 ("Tonicity and Osmoregulation", unit 2) and Statistics 1.6, entitlement-scoped; `get_student_taxonomy('biology')` returns 8 units starting "Chemistry of Life".
- `guideStateFor` fixes the "Loading topic notes…" hang (a disabled query renders the empty state).
- Topic guides exist for every Biology topic in Units 1, 2, 4 and every Statistics topic in Units 1, 2, 4 (briefs and explainers published), so the Open Hand reference pane and deep dive load for the teaching topics.
- The five Day-1 teaching items (Bio 2.7, 4.3; Stats 1.6, 1.7, plus others) have text stimuli, no image dependence, four choices, a rationale ≥25 chars on every choice, no inline "A./B." lists in the stem. Content quality of these items is good.
- Phone width: `--grid-columns` collapses to one column at ≤899px, gutters drop to 16px, `.ca-open-hand-actions` stacks its buttons full-width, Stage A stacks at ≤900px and ≤560px; `--motion-duration: 0ms`; `--radius-all` used throughout the plate components.
- `student_course_positions` is granted to `anon` at the view level but the base table is RLS-forced with authenticated-only policies, so anon reads nothing.

---

## 3. New-student walkthrough (flag ON)

A student who just paid for AP Biology (single purchase) signs in and lands on `/home`.

1. **`/home` loads.** `loadStudentHome` finds no `active_exam_pack_version_id` → `NeedsSubject`: "Which subject first? Pick a subject to get started." with **ten** radio buttons (every published subject), none of which is marked as the one they bought. *(M3)* A trial user sees the same ten and happens to be entitled to all of them. If they pick Chemistry by mistake nothing stops them.
2. **They pick AP Biology.** `complete_onboarding` succeeds; Home refetches; `experienceStage = "new"` → Stage A. They see "Welcome, dbloom01" *(p2)*, "AP Biology · 10 subjects" *(M3)*, "Where your class is: Not set yet", the exam countdown (static arc, *m7*), and the orange "Tell us where your class is" box. There is **no Start button yet** — correct, the first action is to set a position. Curriculum shows 8 units with empty cells.
3. **They choose Unit 1 · 1.2 and press "Set my position →".** Saved. The page now shows "Unit 1 · 1.2 Confirmed by you", explainers for Unit 1, and two orange buttons *(p1)*. "What happens next" says Cramapple will say something after 3 graded attempts.
4. **They press "Start practice →".** `practiceEntry` → `/open-hand-mcq?topic=1.2&from=home` (full-page navigation). "Loading worked examples…", then the RPC returns null for Biology 1.2. **The plate renders "A worked example for this topic is coming soon." in both the Answer Key and Question panes**, with "Try one on your own" and "Return Home". There is no Next. *(B3)* The breadcrumb says "AP Biology · 1.2 · Elements of Life · Worked example" — labels are correct. The Reference pane shows the real Unit 1.2 notes; the deep dive opens. This is the whole of Open Hand for a Unit 1 Biology student.
   - *If instead their class were in Unit 2 topic 2.7*, the question loads. Every choice is tagged Credited/Distractor, but the Answer Key row for the credited choice says only "Credited." and no rationale is visible until they click each option *(M1)*. "Next question" probes 2.8, 2.9, 2.10 (no items) and shows "You've seen every worked example in this unit" after one example *(m1)*.
5. **They press "Try one on your own".** `/practice-mcq?from=open-hand&topic=1.2`. `startOrResumeSession` creates a `targeted_drill` session; `student-session-items unit_gated` returns zero MCQs; the client silently reads all 58 published Biology MCQs. The first question is `APBIO-MCQ-017` (Unit 2, Na⁺/K⁺ pump) — not Unit 1, not 1.2 *(M5)*. The Scoring pane shows four "NOT IN THIS PACKAGE" placeholders; the Reference pane says "…not in the package schema." *(M2)*
6. **They answer and press "Submit answer".** If the item is one of the two Biology teaching items (4th in serving order), the trigger refuses, the client gets `attempt_create_failed`, and the screen says "We couldn't grade that one. Try again." indefinitely *(B1)*; "Skip for now" is the only exit. Otherwise `evaluate-attempt` grades it.
7. **Result.** A "Feedback · Correct/Incorrect · 1/1 or 0/1" card with the grader's summary. The option list collapses to only their pick, tagged **DISTRACTOR even if correct**, and says the other three "are explained in the Answer Key", where exactly one mark appears. If they were wrong they never see which option was right *(B2)*.
8. **"Next question"** advances through the unscoped list. **Returning Home** (browser back or the masthead) recomputes the stage: the attempt is `graded` by the new path, so after 3 attempts on ≥2 items they reach "personalized" → `TopicHome`, a different visual language from Stage A/B (architecture doc O17). Their Biology evidence will also count toward any other subject they switch to *(M4)*.

**Returning student with a lot of history (e.g. `f5a26c6b…`, ~50 graded MCQ results from `/session`).** Home counts 2 graded attempts → **Stage B**: "Welcome back… We're still building a reliable picture… You're at 2." *(M4)*. Pulse shows 0 questions/0 minutes this week unless they practised in the last 7 days. "Start practice →" → Open Hand at their saved topic (same B3/M1 behaviour). TopicHome (if they do reach "personalized") shows the Learn/Points modes, "Nothing due right now" for Biology (start queue is Statistics-pilot only), and "Start →" into Open Hand.

**Today, flag OFF.** Home's buttons go to `/session`. For AP Statistics the pilot path uses the deployed `cell_scoped` mode without the teaching filter; for Biology with the `mcq` format the client-side published read is used. Both can serve a designated teaching item whose attempt the trigger then refuses *(B1 §5)*.

---

## 4. What I could not verify without eyes on the live app — checklist for David

- [ ] On a 390px phone, open `/open-hand-mcq?topic=2.7` (Biology) and confirm the three panes stack in a readable order (Answer Key, Question, Reference) and the action buttons are full-width and not clipped.
- [ ] Confirm the Open Hand placeholder for a topic with no item (Biology 1.1) looks like an intentional empty state and not a broken page; confirm there is no "Next question" on it.
- [ ] After submitting a **correct** Practice MCQ, confirm the picked row visibly says "Distractor" next to a "Correct" verdict (B2) — screenshot it for the fix ticket.
- [ ] After a **wrong** Practice MCQ, confirm nothing on screen reveals the credited option (B2).
- [ ] Trigger B1 deliberately: in Biology Practice, advance to `APBIO-MCQ-016` (celery/tonicity stem) and submit; confirm the "We couldn't grade that one. Try again." loop and that "Skip for now" is the only exit.
- [ ] Confirm the four "NOT IN THIS PACKAGE" blocks render in the Practice Scoring pane on desktop and phone (M2).
- [ ] As a single-subject purchaser with no active subject, confirm the picker shows all ten subjects (M3) and that choosing an unpaid one is accepted.
- [ ] Deep dive overlay: open from Open Hand on a phone and confirm it covers the frame below the breadcrumb and can be closed (Esc and the close control).
- [ ] Reference pane in Open Hand for Statistics 1.6: confirm it shows Topic / Skills / Vocabulary in that order and no "Loading topic notes…" hang.
- [ ] Home Stage A: confirm the two orange buttons after setting a position read as one primary action (p1), and that the exam ring is not read as progress (m7).
- [ ] Audit a sample of `content_item_versions.prompt_json` / `help_text` for any embedded answer text, since both columns are readable by any authenticated user through the public view.
- [ ] Confirm which `student-session-items` version is actually serving (dashboard shows v32); if a newer deploy happened after this review, re-check for `dropTeachingItems`.

---

### Appendix — key evidence queries (all read-only)

```sql
-- Teaching coverage per subject
select s.subject_key, count(*) from app.open_hand_teaching_items t
join app.content_items ci on ci.id=t.content_item_id
join app.exam_pack_versions epv on epv.id=ci.exam_pack_version_id
join app.exam_packs ep on ep.id=epv.exam_pack_id join app.subjects s on s.id=ep.subject_id
where t.released_at is null group by 1;            -- biology 2, ap-statistics 14, … (95 total)

-- Taxonomy size
-- ap_biology: 60 topics / 8 units; ap_statistics: 55 topics / 5 units (verified source versions)

-- Attempt status vs grades
select a.status, a.attempt_mode, count(*), count(g.id) from app.attempts a
left join app.grading_results g on g.attempt_id=a.id group by 1,2;
-- submitted/mcq 50 attempts, 49 grading_results; graded/mcq 2; draft/frq 34 attempts, 28 grades

-- Unit-gated selector under the Practice session format
select count(*) from public.select_unit_gated_practice_items('2d88ba5e-a6a3-43b8-bfae-9e5505a178a7',1,'targeted_drill','mcq',50); -- 0

-- Public view columns (no key fields)
select pg_get_viewdef('public.mcq_choices'::regclass, true);
```

Deployed edge function check: `mcp__Supabase__get_edge_function(student-session-items)` → version 32; source contains `cell_scoped` ×4, `dropTeachingItems` ×0, `open_hand_teaching_items` ×0, `annotateOpenHandExclusions` ×0.
