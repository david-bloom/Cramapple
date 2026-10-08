# Challenge QA — Open Hand and Practice, independent comparison with PR #380

**Date:** 2026-10-08  
**Reviewer:** Codex / Sol, independent challenge QA  
**Review target:** PR #380; Fable's `QA_OPEN_HAND_PRACTICE_TEMPLATES_2026_10_08.md` at `c173ca0215265965359518441b498590c04ccd4d`  
**Working branch:** `claude/open-hand-templates-qa-ig7na7` (continued under R1; companion report, original preserved)  
**Recommendation status:** Proposed; no implementation, production change, merge, or final QA approval.

## 1. Verdict and scope

I agree with most of Fable's underlying concerns, but not with the headline ranking or all proposed fixes. The largest newly identified problem is **question answerability**: the MCQ screen drops stimulus text that contains necessary givens. The second is **false FRQ availability**: seven subjects' FRQs are rejected by the frontend before a question plate is rendered. Repairing topic labels alone does not fix this.

The preferred plan is: (1) make questions complete and routes honestly available; (2) make submission, assistance and account ownership reliable; (3) make topic/unit serving and continuation real; (4) improve reading order, labels and stopping. These are proposed priorities, not newly approved implementation scope.

**This is independent source/contract QA with production read-only checks and limited public browser observation, not a signed-in usability certification.** It does not claim that a student completed the first seven minutes or that every defect has been found.

### Evidence boundary

- Lovable connector independently confirmed the latest head remains **`d5adcbc65f19877a0d95434c0899014fa95b5499`**, project `56cae479-f7c9-4988-b536-56538c38ee4e`. `is_published: true` does not identify the exact published commit.
- Read frontend source directly from that head, including containers, render adapters, question screens, hint/reference/scoring controls, navigation/queue helpers, local state, grading callers, hub doors, and shared controls.
- Read canonical backend source at PR base **`4913aa7291ad7e69af35dc267d2db172169a489c`**. Independently fetched the **deployed Production `student-session-items`, version 33**, bundle SHA256 `563deb4122411db5ed6f78e08127bf2c51f9e287713e5188a103d872d57a74fc`; its relevant entrypoint and delivery helper match inspected repository source.
- Verified Production project identity through the connector: **Cramapple - Production**, `pcntajvbdfqhbeewmdry`. Only SELECT/catalog/function-definition reads and read-only selectors were used. No student impersonation, grading, exclusions, migration or content writes.
- Executed actual TypeScript helper functions locally after Node's type stripping: FRQ adapter, practice chrome, teaching traversal and progress. Module imports were isolated for these pure-function probes; no network or database mutation.
- Browser: `https://app.cramapple.com/` redirected to marketing; `/home` loaded then redirected to `https://cramapple.com/login?redirect=%2Fhome`. Lovable preview redirected to Lovable sign-in. No signed-in test account was available in this browser. Screens beyond those walls, mobile visual behavior, real grade latency and account-switch reproduction remain unobserved.
- The actual Rev 1–4 canvas was not independently opened. Claims about those boards remain attributed to Fable; this review independently checks the implementation and approved plan.

### Governing scope

Read current session bootstrap, architecture/design one-pager, index, QA/workflow/approval rules, TASK-0064, the unified hub recommendation and approved minimal session-clarity plan. The latter explicitly:
- preserves **Open Hand** in the masthead;
- removes the first-question aid confirmation while still recording coached/guided work;
- defers pagination beyond 50, new FRQ teaching content, exact resume, revise/rescore and pane rebuilding.

An agreed deferral can still be a product risk. It must not be misreported as an implementation deviation. Conversely, meeting the minimal plan does not establish student readiness.

## 2. Findings added or materially changed by this review

Priority means proposed remediation order: **P0** = answerability/readiness before declaring affected flows usable; **P1** = correctness, relevance, ownership or trust; **P2** = usability/presentation. These are not new release gates.

### A1 — P0: Practice MCQ omits the problem's stimulus

**Source-confirmed defect; browser symptom pending.**

`live-practice-mcq/adapt.ts:toPracticeQuestion` preserves `raw.stimulus` as `question.stimuli`. `PracticeMcqScreen.jsx` renders only `Stem nodes={question.stem}` and choices. It never renders `question.stimuli` or `question.media`. Shared `QuestionPlate` renders chrome/overlays, not stimulus.

Production's first allowed-unit selector yields MCQs with nonempty text stimulus:

| Subject | Selected | Nonempty stimulus omitted by this screen |
|---|---:|---:|
| Statistics | 50 | 24 |
| Precalculus | 50 | 10 |
| Calculus AB | 50 | 3 |
| Calculus BC | 50 | 3 |
| Biology | 50 | 1 |

These are selector counts, not counts of unanswered items for a particular student. Not every stimulus has been manually checked for necessity. But one inspected example establishes the consequence: **APSTATS-MCQ-002** asks which student performed better relative to their test distribution; the scores, means and standard deviations are in the omitted stimulus. The displayed stem cannot support the calculation.

**Fix:** render existing stimulus before the stem in Practice MCQ; share a question-body renderer across supported templates. Render approved required media with alt/long description, or withhold the item with a specific reason. Never let a backend-approved asset silently disappear in the client. FRQ also preserves media but does not render it; its special scatterplot branch is unreachable for live-adapted items (`stimulus: null`).

**Acceptance:** the Statistics item contains every necessary given; at least one table/diagram/media fixture renders accessibly; missing/expired required media produces a recoverable unavailable-item state rather than a scorable incomplete question. Check the actual live teaching path too: its RPC returns an image path, but `toTeachingMcq` sets `media: []`.

### A2 — P0: Published FRQ counts do not mean renderable FRQs

**Source and deployed-contract confirmed; actual signed-in screen pending. This changes Fable F1.**

`live-practice-frq/adapt.ts:toFrqQuestion` accepts parts only when **`parts_source === "prompt"`**; otherwise it returns `null`. The deployed server only enables authored question parts for **Calculus AB, Statistics and Biology**. The other seven subjects therefore receive `parts_source: "criteria"` and their FRQs are dropped by the frontend, irrespective of topic labels.

Meanwhile `HomeStudyActions` exposes Practice FRQs when `usePublishedFrqs` says ready. That hook counts published selector items even with no usable parts, and uses a different serving path. It can advertise a door that leads to an empty adapted queue.

**The seven subjects are Calculus BC, Chemistry, Physics 1, Physics 2, Physics C E&M, Physics C Mechanics and Precalculus.** Fable's seven corresponding topic-less-plate examples cannot be inferred from raw selector rows; those rows do not survive this adapter.

The source filter is appropriately fail-closed: criteria-derived parts can contain answer-bearing scoring text. **Do not fix this by accepting criteria as prompts.**

A read-only probe of the actual seeded Biology/combined selectors, using synthetic seed `00000000-0000-4000-8000-000000000001`, produced:

| Subject | FRQs in capped mixed selector result | With complete authored prompt parts |
|---|---:|---:|
| Calculus AB | 8 | 4 |
| Statistics | 9 | 4 |
| Biology | 15 | 0 |

These are illustrative selector results **before media delivery, local/server answered filtering and per-user exclusions**; actual sessions use their own seed. They are not final delivered queue totals. All four acceptable Calc AB rows lacked a primary topic; all four acceptable Statistics rows had one. Thus Calc AB's topic-less title remains a real reachable source path.

Read-only whole-bank check of published, nonteaching, targeted-drill FRQs found complete authored parts on **34 AB, 54 Statistics, 1 Biology, 31 BC, 32 Precalculus**, and zero in the other five subjects. BC/Precalculus have usable-looking authored content the server's subject allowlist never forwards; widening requires content safety verification. Biology's problem is also sparse safe prompt coverage, not just topic coverage.

**Fix:** define FRQ readiness as a question surviving the same safety, prompt, media and rendering contract used by Practice. Preserve typed prompt whitelisting. Forward verified authored parts for eligible subjects; repair missing prompts through governed content QA. Until then, expose an honest availability explanation and working alternatives rather than silently advertising an empty route.

**Acceptance:** one owned controlled account per subject reaches either a complete FRQ or an explicit unavailable explanation; no criteria/answer-key fields become pre-submit question text; availability and serving agree.

### A3 — P1: FRQ bypasses the student's unit position

**Source/deployed selector confirmed, with read-only example counts.**

`fetchPracticeFrqItems` deliberately omits `mode: "unit_gated"`, based on a September 24 workaround. The default selectors have no course-position unit constraint. Topic bias runs afterwards and only reorders what survived; it does not filter.

In the seeded probe above, **one of four accepted AB FRQs and three of four accepted Statistics FRQs** had validated serving labels with `max_required_unit > 1`. These can enter a Unit 1 student's queue through this path. This is additional to the cap problem and to missing topic resolution.

**Fix:** use a safe FRQ serving contract that enforces current unit, format and eligibility before selection. Verify supported registry unit numbers, especially Physics 2/E&M. Do not simply switch to unit-gated without proving the older zero-item blocker is resolved.

**Acceptance:** a Unit 1 account receives no above-position item; earlier-topic review is explicit; a requested topic with no safe questions gets an honest choice instead of an unexplained substitution.

### A4 — P1: FRQ cannot submit partial work, and feedback promises an unavailable next attempt

**Source-confirmed.**

`PracticeFrqScreen` enables submission only when **every** part has nonempty text. A student who can answer (a) but not (b) must invent text for (b) or skip all their work. This undermines learning from partial credit.

After grading, the rubric says **"the point is still available next attempt"**, but there is no revise action and `buildPracticeQueue` excludes submitted/graded item versions. Normal return does not offer that attempt.

**Fix:** permit a deliberate partial submission with unattempted parts represented explicitly; retain the one-submission rule. Validate backend/grader behavior for blanks before shipping. Replace the next-attempt promise with a truthful route to another eligible question or notes. Same-item revise/rescore stays a separately approved product/scoring change.

**Acceptance:** answer only one part, receive appropriate partial credit and useful feedback; skipped parts are not silently filled; feedback's next action actually exists.

### A5 — P1: Empty help can still classify the answer as coached

**Source-confirmed.**

`ScoringHelp` always renders the points-help gate, even when `pointBrief` has neither earned nor lost guidance. Opening it shows **"No topic notes for this topic yet."** `PracticeFrqScreen` includes `POINTS_HINT` in its tracked hint list, so opening this empty panel can mark the submitted answer coached.

This is different from Fable F5: the problem is not merely a missing pre-click disclosure; no aid was actually delivered.

**Fix:** show a passive unavailable status when help is absent/error/loading; do not record use until usable aid content is delivered. Keep guided classification for real help, including first-question direct open.

**Acceptance:** empty/error panels do not create assistance receipts or coached classification; delivered help does; failed assistance-event writes are distinguished from no help used.

### A6 — P1: Answer inputs and help remain editable while grading

**Source-confirmed race; timed browser reproduction pending.**

Only the Submit button is disabled by `grading`. MCQ rows retain selection handlers; FRQ `AnswerField` receives no `readOnly={grading}`; help controls remain live. The submit chain captures the response and aid list at click time. A student can change text or open help during the request, yet the returned grade concerns the earlier snapshot. Aid opened after capture is absent from that attempt's aid list.

**Fix:** freeze the committed response and scoring-relevant aid controls during submission/grading, show the submitted snapshot, and preserve it on failure. If editing after a terminal error is permitted, make it an explicit new draft; do not accidentally resubmit a different answer under an old response id.

**Acceptance:** delayed grade/retry tests cannot mismatch displayed response, persisted response and assistance receipt. This must be integrated with F7's retry state machine, not fixed with a cache alone.

### A7 — P2: Example traversal cycles despite "never loops" reasoning

**Executed actual helper, confirmed.**

With two available topics in different units, `pickNextTeachingTopic` returns:

`1.1 → 2.1 → 1.1 → 2.1 → 1.1`

It recomputes earlier-unit candidates from the current topic and has no visited set/start boundary. Fable's §4 "never loops" is incorrect as a multi-step traversal claim. The approved plan permits optional backward/cross-unit exploration, so backward navigation itself is not a defect.

**Fix:** distinguish **next unseen example** from **revisit an earlier unit**. Use an in-memory visit boundary if a bounded browse journey is wanted; no fictitious saved session. Preserve explicit optional exploration and real counts.

**Acceptance:** after all available examples in the visit, offer practice/hub plus an explicitly labelled revisit; never imply endlessly revisited examples are new progress.

### A8 — P2: Set finish does not explain work completed versus skipped

**Source-confirmed.**

Next/Skip advance the same index; a student can skip ten questions and reach the same endpoint as ten graded answers. Current copy is narrowly truthful ("end of this practice set"), but the count does not tell them what they accomplished or what remains.

**Fix:** at the existing endpoint show a lightweight visit tally such as answered / skipped. Keep skipped items available later. This is a proposed addition to scope; the approved slice deferred a new summary screen.

**Acceptance:** all-skipped, mixed and all-graded sets are distinguishable; no completion or mastery claim comes from traversal alone. Continue after the three-answer pause should advance once, while preserving feedback access.

### A9 — P1/P2: Accessibility gaps in the primary study controls

**Source-confirmed omissions; assistive-technology reproduction pending.**

- Deep Dive/standalone notes are visual overlays with Escape support, but no dialog semantics, focus entry/trap/restore or background inertness in the inspected component/hook.
- FRQ `AnswerField` has a generic placeholder but no explicit part-specific label/label association.
- MCQ custom radios handle Space/Enter but every row is tabbable and there is no radio-group arrow navigation.
- Practice action-row wrapping on narrow phones is not covered by the Open Hand-only stacking rule. Clipping is a risk, not a visually verified defect.

**Fix:** use accessible shared dialog/radio/input primitives; bind each answer field to its part prompt; announce grading/errors and restore focus on close/next. Check phone controls and long mathematical copy visually.

**Acceptance:** keyboard-only study and notes access work; screen reader distinguishes each part and score; focus does not disappear behind the overlay; 390px/320px actions and equations remain usable.

## 3. Comparison with every Fable finding

| Finding | Disposition | Challenge / preferred remedy |
|---|---|---|
| F1: topic-less Practice says Worked example, lacks guides | **Agree on code defect; materially correct FRQ symptom/coverage.** | Seven subjects' FRQs are filtered out before the plate (A2). Fix mode-aware chrome now, but prompt/readiness contract precedes bulk topic repair. Do not hide all topic-less FRQs: an intact unlabelled item can support explicitly broad practice; it must not promise lesson alignment. |
| F2: same 50 forever | **Agree; known deferred backend gap.** | Seeded randomization is a mitigation, not the preferred fix: it cannot guarantee unseen inventory or requested-topic inclusion, and a reused seed can still repeat the same subset. Filter by authenticated user's answer state, topic/type/unit and safe deliverability before LIMIT; return a stable cursor and truthful reasons. Raw offset can skip rows when eligibility changes. |
| F3: hub ignores Practice destination | **Agree on branch mismatch; change solution.** | Blindly navigating Learn from a question to scored Practice replaces one expectation failure with another. Preserve four doors: explain that this topic's example is unavailable, with Practice/notes/BYOQ choices, or an explicitly announced fallback. Distinguish unavailable from failed availability lookup. |
| F4: crossing note too quiet | **Agree.** | Note above the question, plus requested-versus-delivered topic and an explicit destination before navigation. Last-unit cross-unit buttons are already labelled Explore Unit; do not claim every crossing is currently hidden. |
| F5: first-question aid silently coached | **Agree on insufficient disclosure; disagree with calling direct-open/free a policy violation.** | First-question confirmation removal is explicitly approved. Keep it. Say help is welcome and recorded as guided; no confirmation reinstatement without a new decision. A5 separately fixes coached classification when nothing was shown. |
| F6: four names, replace Open Hand everywhere | **Agree on comprehension risk; disagree with immediate global rename.** | Approved plan explicitly preserves Open Hand masthead. Put the plain-language purpose alongside it; replacing the masthead is an owner decision. "Face-up" is a state description, not necessarily a competing mode. The claim all teenagers cannot decode it needs student evidence. |
| F7: retry duplicates attempts | **Agree with source diagnosis; challenge production inference and cache-only fix.** | Aggregate duplicate user/item pairs do not prove failed retries caused every extra attempt. Persist logical operation identity/stage and resume the appropriate stage. Handle uncertain/budget/auth/content errors distinctly. Do not blindly rerun evaluate for all statuses; integrate A6 and recovery after reload. |
| F8: browser state not user scoped | **Agree; raise priority.** | Namespace/reset attempts, hints/read receipts and session ids by authenticated user; clear in-memory state on auth transitions. Do not migrate ownerless legacy answers onto whichever user logs in next. Backend session ownership helps, but does not protect frontend assistance/queue state. Reproduce with two controlled accounts. |
| F9: legacy FRQ reveal route burns practice | **Agree on obsolete reachable route and callable RPC; qualify scale.** | Independently verified authenticated EXECUTE remains and exclusions count is zero. Actual route uses the filtered/capped FRQ fetch (A2), so removing most of every subject's 25–50 FRQs in minutes is not established. Retire route, audit every caller/grant before restricting RPC; production revocation requires existing approval. Consent/scoring exclusion is intended containment, not itself an answer-key bypass. |

### Minor findings

| Finding | Disposition |
|---|---|
| m1: Continue then Next takes two taps | Agree; combine once with guarded next action and retain grade context. |
| m2: phone Answer Key precedes question | Agree on DOM/CSS order; elevate reading order. Use question → answer explanation → references for face-up learning, and question → aids before submission / feedback after submission for practice. Prefer responsive DOM design that also preserves screen-reader order, not visual CSS order alone. No signed-in phone screenshot yet. |
| m3: Your answer on unscored example | Agree; Selected avoids implying a recorded attempt. |
| m4: duplicated options | Agree on repetition; test progressive rationale expansion/highlight before removing essential option context. Combine with m2. |
| m5: criterion keys become labels | Agree; use reviewed learner-facing labels in post-grade feedback. Do not automatically expose full criteria pre-submit; earlier answer-exposure findings show why a safe whitelist is needed. |
| m6: sparse FRQ pre-submit scoring orientation | Agree; total points/part structure already exist. But "no placeholder" in §2b is inaccurate: AnswerField defaults to **Write your answer**. The needed change is meaningful prompt/label orientation, not inventing a missing generic placeholder. |
| m7: Hints with none available | Agree; passive unavailable state, retain independent attempt. A5 is the more harmful related case. |
| m8: raw markdown/LaTeX | Agree that plain Stem cannot parse those forms. Did not independently recount Fable's six MCQ/one FRQ items. A lint alone detects but does not repair published display; use a vetted math/text renderer or governed conversion. Check choices, stimuli and notes as well as stems. |
| m9: session churn between MCQ/FRQ | Agree with source path; low priority unless it loses context or corrupts reporting. Keep storage/session-format repair separate from product mode redesign. |

## 4. Product judgment: protect the lesson-learning promise

Fable's summary understates the impact by calling almost everything a template/data seam. **The seam is the product:** a student expects the lesson they picked, a complete question, useful help, feedback they can act on, and a credible return path.

The four doors and optional worked example are still the right approved model. An MCQ worked example can deliver genuine learning; it is not inherently a failed version of an FRQ board. Its value needs to be specific: why the right answer works, what mistake each distractor represents, then a different relevant question to try. Validate that sequence before adding unbuilt comparison tabs or a full FRQ exemplar bank.

Conversely, do not let the marketing promise of rubric-based FRQ learning be stronger than reachable teaching content. Browser-observed marketing uses rubric/FRQ language; Production has **186 active teaching designations, all MCQ**, independently confirmed. Decide whether to narrow that promise now or authorize an FRQ teaching slice. Content creation, grading-policy changes and new product scope retain their gates.

Exact resume was deferred, not forgotten. Until built, keep stop/save wording honest. A later lightweight recap/return cue can explain which lesson was studied and what to try next without claiming restoration of unsent drafts or an exact queue.

## 5. Proposed improvement plan and validation

| Order | Work package | Why first / boundary | Exit evidence |
|---|---|---|---|
| 1 | **Question completeness and truthful FRQ readiness**: A1/A2, mode-aware F1 fallback, required media, empty help A5 | A complete answerable question precedes taxonomy polish. Preserve criteria filtering. | End-to-end delivered-payload → adapter → rendered question checks for every subject/type; no answer exposure; availability matches actual route. |
| 2 | **Attempt integrity and account isolation**: F7/F8, A6, partial FRQ A4, honest error recovery | Scores and assistance must belong to the right answer and user. | Inject failures at create/save/submit/grade/feedback; recover one logical attempt; delayed grading; two-account browser switch; partial-answer grade. |
| 3 | **Targeting and inventory**: F2/F3, A3, content topic resolution | Server eligibility/targeting before cap, then owned stable continuation. | Topic exists beyond first 50; first 50 all answered; no future-unit FRQ; no-match vs query failure; exclusion/media omission refill; stable pagination. |
| 4 | **Learning flow, comprehension and access**: F4/F5/F6, A7–A9, m1–m8 | Approved vocabulary/first-question aid behavior preserved; changes requiring new product choices marked. | Desktop + 390px + 320px; keyboard/screen reader; last example/set; pause; skip; unavailable guides; math-heavy content. |
| 5 | **Legacy containment and larger decisions**: F9 audit, FRQ teaching slice, exact return | Route retirement can be a small contained change; RPC revoke is separately gated. New teaching/resume/rename needs scope decisions. | Caller/grant audit; controlled student cannot use obsolete route; approved publication evidence; no fake save or revise promise. |

F9 route containment can proceed alongside packages 1–2 after impact review; it does not need to wait for a new FRQ teaching bank. These packages are proposed for implementation planning; the current request authorizes review/documentation, not production execution.

### Challenge acceptance cases

1. **New student, Statistics Unit 1:** enter a worked example, explain what activity it is, then practice an unanswered relevant item. All problem data is visible. Ask what the rationale teaches, not only whether the button was found.
2. **Sparse example subject:** Physics C Mechanics Unit 2. No first-click dead end and no silently unrelated scored question.
3. **Calc AB topic-less practice:** activity clearly says Practice; unavailable aids are passive; actual content context is not borrowed from selected lesson.
4. **Every FRQ subject:** raw published count never substitutes for a valid rendered prompt. Safely unavailable subjects say why and retain alternatives.
5. **Unit 1 FRQ account:** no above-position required unit, even where broad/combined selectors used to serve it.
6. **Failure ladder:** timeout after create, save, submit, evaluation success with lost response, feedback failure; distinguish graded work awaiting explanation from an ungraded draft. Exactly one logical attempt unless a new attempt is deliberately authorized.
7. **Partial FRQ and delayed grade:** blanks allowed under verified grader contract; response and help snapshot cannot mutate underneath scoring.
8. **Account A → B on one browser:** A's answers, hints, queue exclusions, session and reading state do not affect B; include A opens help without submitting.
9. **Question 1 aids / question 2 aids:** first aid opens once as approved; meaningful guidance recorded; no aid-use classification on empty/loading/error content; neutral disclosure explains guided work.
10. **Inventory beyond 50:** target question beyond old cap reachable; all previously fetched items answered does not imply topic-bank exhaustion; pagination remains stable when questions are excluded.
11. **Browse/skip/finish/return:** repeated examples are labelled revisits; all-skipped finish differs from graded work; exact resume/draft save never implied.
12. **Keyboard and phone:** field labels, radio navigation, modal focus, long captions/options, all actions and math/media work without horizontal clipping.
13. **Legacy route:** inspect/retire without revealing scored keys on a real student's account. Do not generate permanent exclusions merely to demonstrate F9.

For comprehension, use neutral tasks with a fresh student and a returning student; ask what they expect before action, what they learned, whether help changed the meaning of the score, what remains, and how they would return. Record hesitation/misunderstanding independently of source-test pass results. No learning-gain claims from this QA.

## 6. Reproducible evidence notes

All counts are dated snapshots. Selector counts are not delivered-queue counts. The original report's raw `select_practice_frqs` counts do not reproduce the live Biology/AB/Statistics branch, which uses mixed seeded selectors.

Executed pure-function results:

- `toFrqQuestion({parts_source:"criteria", ...validQuestion})` → **null**
- Same fixture with `parts_source:"prompt"` → **valid question**
- `realQuestionChromeLabels(applyOpenHandContext(topiclessQuestion), "practice")` → **topic: Worked example; status: Practice**
- Two-unit teaching helper walk → **1.1, 2.1, 1.1, 2.1, 1.1**

Read-only SQL recipes:

```sql
-- Verify deployed selector contracts, not remembered migrations.
select n.nspname, p.proname, pg_get_functiondef(p.oid)
from pg_proc p join pg_namespace n on n.oid = p.pronamespace
where p.proname in (
  'select_unit_gated_practice_items', 'select_practice_frqs',
  'select_biology_practice_items', 'select_ordinary_combined_practice_items',
  'get_open_hand_item', 'get_open_hand_teaching_item');

select has_function_privilege(
  'authenticated', 'public.get_open_hand_item(uuid,uuid)', 'EXECUTE'),
  (select count(*) from app.open_hand_scoring_exclusions);
-- true; 0 at review.

select ci.item_type, count(*)
from app.open_hand_teaching_items t
join app.content_items ci on ci.id = t.content_item_id
where t.released_at is null group by ci.item_type;
-- mcq: 186.
```

To reproduce A1, find the active published pack per subject, call `select_unit_gated_practice_items(pack, first_allowed_unit, null, 'mcq', 50)`, count nonempty `stimulus`, and follow it through `toPracticeQuestion` into `PracticeMcqScreen`. A2/A3 use the actual branch: Biology's seeded Biology selector; AB/Statistics's seeded combined selector; generic `select_practice_frqs` for other subjects. Apply authored-part extraction only for the deployed three-subject allowlist, then `parts_source`, media gates, type filtering and adapter rejection. Only the final question queue supports screen counts.

**Next required action:** implementation owner/conductor converts this proposed order into approved repair slices, beginning with A1/A2; QA then runs the controlled signed-in acceptance cases on an identified Preview build. Product Owner decisions remain for scope expansion, global rename, FRQ teaching and exact resume. No final Pass/Done/production readiness is asserted here.
