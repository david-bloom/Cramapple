# TASK-0068 — independent BYOQ browser QA

Date: 2026-10-09. Reviewer: Sol. Proposed verdict: **FAIL**.

## Scope and tested build

Observed: tested the published app at `https://app.cramapple.com/byoq`, anonymously, on 2026-10-09; final test inventory verified at approximately 12:42 UTC (08:42 EDT). Desktop viewport 1280 × 720; phone simulation 375 × 812. No real phone, sign-in, deployment, configuration change, source edit, or commit. Eight questions created; eight fixture uploads, plus two extraction retries on the degraded Statistics item.

Code-reviewed: **none**. Implementation code and the implementer's backend QA report were not inspected. This is independent browser QA, not a fully pristine blind study: the supplied implementer-authored script and deployment/approval metadata were read, and those records exposed summaries of prior results. None of those results is treated as browser evidence here.

Reported metadata, not independently verified build identity: implementation branch `origin/claude/task-0068-byoq-photo-extraction`, SHA `a2a636d912d3a9d643800132024561ddfa0172fa`; Lovable commit `ea999aad`; publish record `22c855ae`; authorization `APPROVAL-0141`. The browser pin is the published URL and date/time above, not an assertion that the deployed JavaScript matches that Git SHA.

The supplied `/Users/davidbloom/Documents/Cramapple/docs/qa/QA_TASK0068_SOL_BROWSER_SCRIPT_2026_10_09.md` was unavailable at that filesystem path. The exact document and twelve fixture PNGs were obtained from the named implementation branch. Current checkout and unrelated dirty files were preserved. No existing report entry was found by exact filename in `docs/INDEX.md`; the report location is specified directly by the QA script.

## Outcome

Observed: the production extraction precondition passed: Done → “Reading your question…” → “Is this your question?” with proposed fields. Clean/degraded MCQs, a short FRQ, and blank-page fallback were usable. Both tested printed-answer controls removed answer material from extracted fields. Student edits survived ordinary confirmation.

Observed release-blocking failure: **“Try reading it again” overwrote a student's edited stem.** The script explicitly requires preservation; its severity rubric makes data loss P1. Other findings concern navigation, resumed-owner handoff, topic accuracy, and mobile review usability. Proposed Fail is based on this run, not on the implementer's conclusions. David decides expansion/rollback; no rollback was performed.

## Findings

| ID | Severity / evidence | Trigger and exact UI reference | Student consequence | Shortest-flow improvement |
| --- | --- | --- | --- | --- |
| SOL-01 | **P1 — Observed** | S3: on desktop review for BQ-FCJV3P, filled Question text with `MY EDIT`, then clicked “Try reading it again”. The in-flight DOM showed `MY EDIT`; after the retry button became enabled, Question text contained the full original commute-time stem instead. [Post-retry evidence](evidence/task0068-sol-2026-10-09/s3-retry-preserves-edit.jpg). | A student's correction is silently lost. This contradicts the explicit edit-safety acceptance criterion. Backend persistence versus frontend rehydration is **Inferred/unknown**, not diagnosed. | Preserve current local edits through retry and merge only empty fields; test both persisted and unsaved edits. |
| SOL-02 | **P2 — Observed** | S1 after successful phone confirmation: “Back to your question” linked to `/byoq/new?mode=photo&item=11a6a343-0aec-471c-868c-defc70df1658`; clicking it opened an editor with “Save changes”, not practice. Later confirmations also used intake/editor URLs. [Editor evidence](evidence/task0068-sol-2026-10-09/s1-back-link-editor.jpg). | The promised immediate practice path needs a detour through Your questions → Open. | Point the completion link at the current item's practice route once ready. |
| SOL-03 | **P2 — Observed once; not reproduced on later items** | S2: phone heading BQ-REPB8E and saved-success status, but the link href was `/byoq/new?mode=photo&item=11a6a343-0aec-471c-868c-defc70df1658` (the first Statistics question), rather than Chemistry item `db1e5072-3e4b-4b9f-9bf7-bab517f9d2d9`. [Completion screen](evidence/task0068-sol-2026-10-09/s2-completion-wrong-back-link.jpg); href verified from rendered DOM. | A completion link can point at the owner's previous question. No evidence of another student's data. Duration/transience **Untested**. | Derive the target from the current pairing/item, and test multiple consecutive captures in one browser session. |
| SOL-04 | **P2 — Observed, resumed-owner variant only** | S3: opened the existing owner's intake URL after Page 1 saved, before phone Done. Phone reached review by 7.7 s; desktop remained the old empty form with “Continue” on two checks. Reload immediately produced the filled review with “Finish on your phone, or here.” [Stale owner form](evidence/task0068-sol-2026-10-09/s3-owner-stale-form.jpg). | An owner returning to an unfinished draft can be asked to transcribe already-extracted material until reload. Fresh QR-panel polling was not established by this variant. | Keep resumed drafts subscribed to extraction/ready transitions too. |
| SOL-05 | **P2 — Observed sample failure** | S4 Calculus BC interval-continuity fixture: selected 1.11 “Defining Continuity at a Point”; alternatives 1.10 and 1.13. Script ground truth 1.12 “Confirming Continuity over an Interval” was absent from top three. [Mobile review](evidence/task0068-sol-2026-10-09/s4-calculus-mobile.jpg). | Student may accept a neighboring topic and get less relevant guidance. This single result does not establish aggregate topic accuracy. | Include interval-continuity in the regression set; retain an easy “I'm not sure” override. |
| SOL-06 | **P3 — Observed; script/app contract mismatch** | S1's prescribed `subject=ap-statistics` was dropped from the URL; review had Choose a subject, disabled Unit/Topic, and “This doesn't look like a this subject question. Check the subject below.” Selecting AP Statistics left “This doesn't look like a AP Statistics question…” despite a Statistics photo. Underscore `ap_chemistry`, `ap_statistics`, etc. worked in later tests. [Missing context](evidence/task0068-sol-2026-10-09/s1-missing-context.jpg). | Extra manual subject/unit/topic steps and an alarming warning. This does **not** prove normal in-app subject links are broken. | Align test links and route key normalization; suppress mismatch warnings when context is absent and reassess them after context changes. |
| SOL-07 | **P3 — Observed** | At 375 px, long answer choices are single-line inputs with only a prefix visible. Topic buttons measured 36.5 px high for two Calculus chips, below the script's 44 px target. Confirm was at the bottom of a roughly 1,900 px review page, which the script explicitly permits. [Mobile review](evidence/task0068-sol-2026-10-09/s4-calculus-mobile.jpg). | Hard to compare full choice text and tap short chips while reviewing on a phone. | Use wrapping/auto-height choice editors and minimum 44 px chip targets. |
| SOL-08 | **P3 — Observed** | On ungraded practice, Scoring → “How points are earned” and Deep dive confirmations use “Sure you need a hint?” and say the hint will be listed on feedback, alongside “Nothing here is graded.” | Students may think a hint affects a score or tracked feedback. No incorrect-option verdict observed. | Use ungraded BYOQ-specific confirmation copy, or remove this extra confirmation. |
| SOL-09 | **P3 — Observed** | Chemistry stem retained `10^-5`, `10^4`, `M^-1 cm^-1`; answer-line control retained `f(x)^2`; answer-key control retained `e^x`. | Caret notation is readable but falls short of the approved plain-Unicode intent. Source images themselves use caret notation; no mathematics-changing discrepancy observed. | Normalize safe superscripts without altering grouping; keep the photo as reference. |

Additional observations: navigating Back after using the same-device capture button created an extra empty draft BQ-K8TE5G, which was subsequently reused for the blank control. This is a history-navigation friction observation, not proof that an ordinary QR scan duplicates drafts. Invalid `bqcap_nonsense` showed “Something went wrong. Please try again.” without crashing; clearer dead-link guidance would help.

Observed incidental browser-console errors on the desktop tab: Clarity reported “Multiple Clarity tags detected” and `Cannot read properties of undefined (reading 'unshift')` from its remote tag at 12:40–12:41 UTC. Their relationship to the BYOQ defects is **Untested**; do not treat them as a diagnosis. The application screens continued working in these tests.

## Scenario matrix

Timing method: wall-clock samples from clicking Done to the first observed review snapshot. These are **upper bounds**, not precise render timings; intermediate browser/tool round trips affect them. S1 was still reading at 6.3 s and ready at 14.9 s. The initial upload tool call had an approximately 573 s control/approval delay; do not attribute that delay to app processing. No statistically valid median-latency gate is claimed.

Step counts below count substantive actions (route open, same-device button, picker selection, Done, edits, confirmation, navigation), exclude observation calls, and are not an instrumented clickstream.

| Scenario | Evidence / result | Actions and Done-to-review timing |
| --- | --- | --- |
| S1 clean MCQ | **Observed partial / Fail:** correct MCQ and four ordered choices; missing subject/unit/topic with the script's hyphen key; manual selections and stem/choice-B edits survived confirmation. Completion link went to editor. Practice reached via list; no selected/correct option shown. Statistics hint, points guide, and deep dive inspected without an explicit key/verdict. | 4 actions to extraction; ~13 substantive actions to practice including context repairs, two edits, and list detour. Review >6.3 and ≤14.9 s. Total task elapsed not a useful student metric because of tool delay and QA inspections. |
| S2 desktop/phone handoff | **Observed partial:** Chemistry subject/unit/topic 3.13 and four choices correct using underscore key. Original desktop waiting tab was lost by browser Back, creating another draft; owner resumed correct item from list. Phone confirmation then moved that owner tab to practice without a click by 4.7 s. Wrong-item completion href observed. Initial QR-waiting transition and strict 3 s target **Untested**. | 4 capture actions, plus owner-resume actions; review ≤7.6 s. |
| S3 degraded / retry | **Observed / Fail:** degraded page transcribed, 4 choices; expected topic 1.8 initially among alternatives. `MY EDIT` overwritten after retry. Clearing stem and retrying restored proposed text. Desktop confirmation succeeded. | 4 capture actions; 4 retry/edit actions; 1 confirmation. Initial review ≤7.7 s; retry timing not recorded. |
| S4 notation | **Observed partial / Fail topic:** fixture 03 stem and all four choices preserved meaning and grouping; no missing minus sign or invented diagram. Topic 1.12 absent from top three. This fixture does not actually contain the rich superscript/fraction notation implied by its script description. | 4 capture actions + confirmation. Review ≤11.5 s. |
| S5 FRQ | **Observed partial / Pass tested portion:** selected Free response, no choice inputs, exact single-sentence stem, AP Biology Unit 2/topic 2.7; practice showed Write your answer and no radios. Subparts **Untested** because fixture 04 has none. | 4 capture actions + confirmation + practice navigation. Review ≤8.4 s. |
| S6 answer material | **Observed partial / Pass extracted-text portion:** fixtures 06 and 08 showed “This page looks like it includes an answer key. We kept only the question.” Keys absent from extracted stems/choices and practice; no preselection. First topic hint on each had no direct key. Circled option/handwritten work and full hint/reference traversal on both controls **Untested**. | Each 4 capture actions + confirmation + practice/hint inspection. Review ≤5.8 s (06), ≤9.9 s (08). |
| S7 non-question / PII | **Observed partial / Pass blank portion:** blank page abstained, empty stem/type and no choices. “We couldn't find a question in this photo. Type it in, or retake the photo.” Also unreadable/type-selection notes. Selecting FRQ and typing a synthetic sentence confirmed successfully; practice retained it. Notes-page and fictional-name controls **Untested**. | Existing draft reused; 4 capture actions + radio selection + stem entry + confirmation + practice navigation. Review ≤10.2 s. |
| S8 typed path | **Untested:** no ninth question created; photo-review manual fallback is not a substitute for the fresh typed flow/answer-mask regression. | — |
| S9 lifecycle | **Observed partial:** reopening S1 capture after confirmation gave “This link has expired — make a new QR code on your computer.” Malformed handle returned generic error without crash. Make a new code and 30-minute expiry **Untested**. | Two lifecycle navigations. |
| S10 multipage | **Untested:** stayed within eight-question limit; no multipage model call. | — |
| Mobile layout (§4) | **Observed partial:** capture/review/completion exercised at 375 × 812. Measured scrollWidth 375 on inspected screens; Show photos larger worked. Chips wrapped, but two topic buttons were 36.5 px. Long choice text clipped inside inputs. Not every control's effective label hit target measured. | No horizontal page overflow observed on measured screens. |
| Accessibility (§5) | **Observed partial:** Reading/Ready status had `role=status` and polite live region. Warning-bearing phone form had `aria-describedby=byoq-review-notes-phone`. Desktop chip Tab moved to next chip; Enter changed topic, Enter on confirm initiated save. Full keyboard traversal, screen-reader announcement and focus-trap audit **Untested**. | Confirmed DOM association and limited keyboard operations, not full accessibility certification. |
| Friction (§6) | **Observed:** context repair/stale warning; editor detour; long mobile form/choice clipping; hint confirmation inconsistent with ungraded context; duplicate draft after Back. Improvements listed above. | Instrumented end-to-end time **Untested**. |
| Signed-in (§7) | **Untested:** anonymous only; no test-account sign-in or permission change. | — |

## Notation comparison

Observed S4 source: `f(x) = ln(6 - 2x)/(x + 1)`; proposal preserved this formula and its grouping. All interval boundaries, negative signs, open parentheses and unions survived. Choice labels/question number/header stripped as intended. The image spells `infinity`; the proposal also spells it, rather than introducing ∞. No semantic discrepancy found in this fixture.

Observed elsewhere: caret powers/scientific exponents retained (SOL-09); `f⁻¹` in fixture 06 was preserved; multiplication in the degraded Statistics stem appeared as `x` rather than × (cosmetic, context clear). No LaTeX command or fabricated diagram placeholder observed in tested proposals. Dense notation across Physics or richer Calculus images **Untested**.

## Answer-safety interpretation

Observed: no app-generated answer key, grading verdict, “which option is correct” indicator, or preselected answer appeared in inspected extracted fields/practice/hints. This is limited coverage, not a universal safety certification.

Observed: the original uploaded photograph is retained and shown; an answer printed on that source photograph remains visible there. The approved plan explicitly keeps the photo as reference and the practice photo display unchanged. This report therefore distinguishes removal from **extracted/app-generated text** from removal/redaction of the **source image**. The script's literal “visible anywhere” phrasing conflicts with retained source photos; source-image redaction was not performed or assumed. Product decision needed if “anywhere” is intended literally.

## Side effects and cleanup

Observed: eight anonymous questions were created, all practice-ready by the end. No answer submitted; no real student data. Exact cleanup targets:

| Code | Item ID | Fixture / purpose |
| --- | --- | --- |
| BQ-RJ7C9V | `11a6a343-0aec-471c-868c-defc70df1658` | 01 clean Statistics + edit persistence |
| BQ-REPB8E | `db1e5072-3e4b-4b9f-9bf7-bab517f9d2d9` | 05 Chemistry / owner handoff |
| BQ-K8TE5G | `50cbd5e9-5eab-4b8a-80df-6f5d7bf5e063` | Back-created draft reused for 11 blank/fallback |
| BQ-W5ZPH2 | `1fb589de-3fc3-453a-ba08-d8eb586e3dea` | 03 Calculus notation |
| BQ-FCJV3P | `9b306e6f-8814-47f3-9ab6-02197694c2d0` | 02 degraded / two retries |
| BQ-MCGRXN | `141ef358-060e-4dff-9665-fa980ecf7baf` | 04 Biology FRQ |
| BQ-WJG859 | `ba9ce7a6-5b69-4df8-90fa-cab0729361ce` | 06 printed answer key |
| BQ-23BVWV | `545a6f9f-825b-4c8b-a6cd-67d2a4fecde1` | 08 printed answer line |

Cleanup status: **not yet deleted; action-time approval requested from David**. Browser deletion requires fresh confirmation even though the supplied script instructs cleanup. [Inventory evidence](evidence/task0068-sol-2026-10-09/qa-created-questions.jpg). Do not interpret this report as successful cleanup or independently verified storage deletion/30-day purge.

Local evidence saved in `docs/qa/evidence/task0068-sol-2026-10-09/`. Report and screenshots are uncommitted. Pairing tokens/owner secrets are not recorded here.

## Untested / next QA coverage

Fresh typed-path leak masking; circled answer; handwritten work; fictional-name advisory; notes-as-non-question; true multipart FRQ; multipage and retake; physical camera/real-phone QR scan; original fresh-desktop QR waiting transition; Make a new code; 30-minute capability expiry; signed-in parity/claim; extraction-off/timeout/provider-failure paths; aggregate quantitative benchmarks; browser/network/backend persistence inspection; full keyboard/screen-reader audit; storage/purge verification. These require a follow-up scope, not a pass assumption.

Recommended next step: fix and re-test SOL-01 before expanding use, then verify same-device completion and resumed-owner transitions. No implementation changes are authorized or made by this report.
