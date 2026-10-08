# Student Hub Slice 1 — Execution Record

**Status:** Built in Lovable Preview; diff reviewed; publication and signed-in QA pending (David publishes)
**Date:** 2026-10-08
**Owner / Conductor:** Claude (Fable), session `claude/studenthub-qa-optimization-v8j16i`
**Authorization:** David Bloom, 2026-10-08: "Go ahead and implement slice 1 in Lovable." Contracts per `DECISION-0103`.
**Governing plan:** `docs/qa/QA_STUDENT_HUB_CONSOLIDATED_PLAN_2026_10_08.md` §4 slice 1 (findings H1/N5, H3/N6, N1/H8, N2, H2)
**Implementation:** Lovable project `56cae479-f7c9-4988-b536-56538c38ee4e`, user message `main:user#00000000000687#usr:J33ALEBP`
**Baseline:** `926ac3fbb0876bc10d97916441980afb3dcabccc` (PR #380 packages 2–3)
**Connector commit (authoritative):** `a509b7d7e722cdb871a85b614bd6c19b50ecde9c` (agent-reported internal hash `d21b0ab2` is not the external checkpoint)
**Preview:** https://id-preview--56cae479-f7c9-4988-b536-56538c38ee4e.lovable.app
**Tier:** Standard. Frontend only. No backend, migration, grading, content, dependency or publication change.

## What was built

| Part | Finding | Change | Verified in diff |
| --- | --- | --- | --- |
| A | H1 / N5 | `loadStudentHome` attempts (latest 100) and sessions (latest 25) reads now carry `.eq("exam_pack_version_id", versionId)` before order and limit. Stage, evidence count, "Based on your N graded attempts", completed-session count and the trend flag use the active subject only. | Yes: two `.eq` lines and the replaced comment in `src/lib/home.functions.ts`. |
| B | H3 / N6 | `stageAPositionPayload(unitId, null)` sends `topicCode: null`, so a unit-only save clears the stored topic instead of keeping the previous unit's. `home-stage-a.test.ts` asserts the new behaviour. | Yes. |
| C | H3, H2, `DECISION-0103` #1 | Save on change in both stages through one hook, `src/lib/use-course-position-save.ts`: a unit or topic pick persists at once; a monotonic request gate lets only the newest pick change state or trigger the hub refetch; selects keep the saved lesson while the taxonomy loads (nothing is cleared while `units` is empty); the selection re-syncs to outside changes unless a newer pick is in flight. "Set my position →" and "Confirm" removed. Shared `PositionSaveStatus` line: "Saving…" / "Saved" (`role="status"`), "We couldn't save your lesson." + "Try again" (`role="alert"`). Stage A's "Why this: … nothing to recommend honestly" paragraph removed; eyebrow "Start here · 2 minutes" → "Your lesson". | Yes. |
| D | N1 / H8 | Learn door has four states (checking · available · unavailable · unknown), gated on the saved topic when one exists and on the unit otherwise. Only "unavailable" disables the door; a failed or refused lookup is "unknown" and leaves it usable. Unavailable copy names the lesson or the unit and links to Practice; the Recommended line then moves under "Practice on my own" ("Recommended: answer questions on this lesson. Every answer comes with an explanation."). The Learn line stays "Recommended: see how a test-style question is asked and scored." `learn()` honours a `practice` resolver answer (navigates to `/practice-mcq`) and shows "We couldn't open a worked example. Try again." on failure. Each door is `aria-describedby` its note. | Yes. |
| E | N2, `DECISION-0103` #2 | Heading above the doors: "Studying: 2.3 · Title · Change", "Studying: Unit 2 · pick a topic to narrow it · Change", or "Studying: pick a lesson above"; "Change" focuses the picker. Unit-only Learn opens the unit's first topic with a worked example and the plate shows "Studying Unit N · this is the first worked example available in the unit." (route passes `from: "home-unit"`). Unit-only Notes toggles a list of the unit's topics that have notes, each opening the existing notes overlay; "No notes for this unit yet." when none. "Set your position first" removed. Practice destination unchanged. | Yes. |

Files: new `src/lib/use-course-position-save.ts`, `src/components/home/PositionSaveStatus.tsx`, `src/lib/__tests__/home-hub-slice1.test.ts` (9 tests); edited `src/lib/home.functions.ts`, `src/components/home/HomeStageANew.tsx`, `HomeStageBBuilding.tsx`, `HomeStudyActions.tsx`, `src/screens/LiveOpenHandTeaching.jsx`, `src/routes/open-hand-mcq.tsx`, `src/styles.css` (one rule for the notes list), `src/lib/__tests__/home-stage-a.test.ts`, `practice-qa-package3.test.tsx` (door state names). `src/lib/practice-entry.ts` untouched.

## Validation evidence

| Evidence | Result / boundary |
| --- | --- |
| Lovable full suite | 81 files / 755 passed / 0 failed (agent report). |
| Standalone TypeScript | `npx tsgo --noEmit` exit 0 (agent report). |
| Build | `npm run build` exit 0 (agent report). |
| Fable diff review `926ac3fb → a509b7d7` | 12 files; every part A–E present as specified; no PR #380 package change reverted; no backend, dependency or publication change. |
| Signed-in behaviour | **Not verified.** No signed-in session was available. Save-on-change, scoped counts and door states are covered by unit tests only. |

## Deviations recorded by the agent

- Inline link in the unavailable copy reads "Practice", not "Practice MCQs", to match the new sentence.
- One line added to `src/styles.css` (not on the file list) to remove list bullets on the unit notes list.
- When opened from a unit-only lesson, the worked-example page waits for the taxonomy before loading so the note can name the unit.

## Known behaviour worth a look during slice 2

- Learn with state "unknown" (teaching-topics lookup failed) and a unit-only lesson resolves through the existing resolver, which sends the student to Practice rather than the plate. Acceptable; noted so it is not mistaken for a regression.
- After a failed save, the selects show the unsaved pick while the doors still read the last saved lesson; the "Try again" line makes that visible. This is the one case where draft and saved can differ.
- "Saved" stays visible once shown; it does not reset on a later subject switch.

## Next

**Slice 2 (David, ten minutes):** publish or open the Preview at `a509b7d7` signed in and take: desktop, 390px and 320px of Stage A with and without a saved lesson, Stage B, the notes overlay open, a long lesson name, 200% zoom; check the console and network for errors. Pass conditions are in the consolidated plan §4 and §6 (doors visible on a phone without scrolling past the form is a slice 3 condition, not this one). Then Sol re-QAs slice 1 against this commit.

**Approval state:** owner-authorized frontend implementation completed in Preview. No publication instruction granted. **Next owner:** David (publish / screenshots), then Sol (independent re-QA).
