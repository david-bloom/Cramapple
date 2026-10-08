# Student Hub — Consolidated QA Findings and Plan

STATUS: PROPOSED — the single StudentHub QA plan; not QA acceptance, not implementation authorization
DATE: 2026-10-08
OWNER: David Bloom
PREPARED BY: Claude (Fable), consolidating Sol's challenge QA and Fable's independent assessment at Sol's request (PR #381 review, 2026-10-08)
EVIDENCE RECORDS (findings stand; this document governs where they differ): `QA_STUDENT_HUB_CHALLENGE_2026_10_08.md` (Sol, H1–H15, Lovable `d5adcbc6`) · `QA_STUDENT_HUB_FABLE_REVISED_PROPOSAL_2026_10_08.md` (Fable, N1–N8, §5b–§5d, Lovable `8a97bdca`)
GOVERNING DECISION: `DECISION-0100` and its amendment; the unified recommendation `product/STUDENT_HUB_UNIFIED_RECOMMENDATION_2026_10_07.md` still governs the design model
SCOPE: `/home` for the new student first, the returning student second. Planning only. No application, schema, data or deployment change.
NEXT OWNER: implementation conductor for slice 1 (§5 decided, `DECISION-0103`); David for the slice 2 screenshots; Sol for independent re-QA after each slice.

## 1. Verdict

The four-door model (learn from a question · practice · notes · bring a question; the example recommended, never required; lesson before evidence) is right and is not reopened. Two things stand between it and a student who knows what to do: the doors are not yet truthful (the recommended door can open a "coming soon" plate; a unit-only lesson means three different things to three doors; evidence counts can come from another subject; a draft lesson is not the lesson that opens), and the first screen explains what Cramapple cannot do yet before it explains what the student will do. Both assessors agree on the order Sol set in review: **truthfulness and route reliability first, signed-in visual QA second, copy and layout third.**

| David's question | Answer | Evidence |
| --- | --- | --- |
| Does a new student understand what to do? | Partly: the form is unmistakable, the study choice is not. | Doors sit inside the form's box under its button (Fable §3; Sol H5). |
| Do they understand how Cramapple will help? | No. | Purpose line is note-sized under a button; nine negative statements precede the first door (Fable §3). |
| Are the paths obvious and clearly different? | The model is; the behaviour is not yet. | N1, N2, H3, H8. |
| Does it render and load as designed? | Unverified by either assessor. | No signed-in session (H15). |
| Are there defects? | Yes: five P1, nine P2 (§3). | — |

## 2. Checkpoints

| Head | Who | What it established |
| --- | --- | --- |
| Lovable `d5adcbc6` | Sol | H1–H15 from source and executed `home-snapshot` helpers. |
| Lovable `8a97bdca` | Fable | Hub components byte-identical to `d5adcbc6`; N1–N8 with read-only Production counts; FRQ half of H8 already done (`count_practice_frqs_available`). |
| Lovable `926ac3fb` (PR #380 packages 2–3, current Preview head) | Fable, re-check for this plan | **Hub changed.** `HomeStudyActions` now gates the Learn door per **unit** (`learnDoorState`: any topic in the saved unit with a teaching item → ready; otherwise "No worked example for Unit N yet. Start with Practice MCQs, or pick another unit."). `DeepDiveOverlay` now has `role="dialog"`, `aria-modal`, `aria-labelledby`, focus entry, Tab trap and focus restore. The Open Hand "Next example" now skips visited topics and names its destination. Phone pane order on the plates is fixed. **Still open on the hub:** the click handler still ignores the resolver's `practice` answer, so a saved *topic* without an example inside a unit that has some still opens the "coming soon" plate; a lookup error collapses to "none" (unknown reads as unavailable); overlay `zIndex: 30` sits under the fixed subject switcher at 40; "Copy deep dive" label; no background inert. Everything else in §3 is unchanged. |

Production reads (read-only, `pcntajvbdfqhbeewmdry`, 2026-10-08) are in the Fable record §2 and §4.

## 3. Consolidated findings

Priority: P1 = fix before the new-student experience is accepted; P2 = material improvement; status is at `926ac3fb`.

| Id | Finding | P | Status | Agreed fix |
| --- | --- | --- | --- | --- |
| H1 / N5 | Stage, counts and "Based on your N graded attempts" use the latest 100 attempts and 25 sessions **user-wide**, not the active pack. Live: 3 of 6 students with attempts span packs; the owner's hub reads 7 vs 5. Zero null-pack rows exist, so the null exception protects nothing. | P1 | Open | `.eq("exam_pack_version_id", versionId)` on both reads, before the limits. Drop the null-pack rule. |
| H3 / N6 | Doors read the saved snapshot; the selects are a draft with no unsaved cue. Stage A sends `topicCode: undefined` on unit-only saves and the server keeps the old topic, so Unit 1 · 1.1 → Unit 2 leaves 1.1 under Unit 2 and every door opens 1.1. The Stage A test asserts the wrong behaviour. | P1 | Open | Send `topicCode: null` (as Stage B does) and fix the test. Then one selection contract: §5 decision (a), recommended **save on change**. |
| N1 / H8 | The Recommended door opened a "coming soon" plate for any lesson without a teaching item; in October that is most lessons outside Units 1–3 of Statistics, Chemistry, Biology and Calc AB and nearly all of Unit 4 (coverage table, Fable §4). | P1 | **Partly fixed at `926ac3fb`** (unit-level gate). Open: topic-level case; click handler ignores `practice`; error reads as unavailable. | Gate on the saved **topic** when one exists, the unit otherwise; honour the resolver's `practice` answer; three states (available · unavailable · unknown) with unknown keeping the door enabled. Practice carries the Recommended line when no example exists. |
| N2 | 5 of 10 saved positions are unit-only. Learn silently opens the unit's first topic (`resolveStartTopic`), Practice goes unit-wide, Notes disables. Three doors, three definitions of "this lesson". | P1 | Open | One rule, §5 decision (b). Save-on-change makes this a precondition, since every pause between the two selects writes a unit-only row. |
| H5 / H6 | The page explains uncertainty more than learning: "Start here · 2 minutes", "nothing to recommend honestly", "it will say it doesn't know", "no work yet", threshold line, "Based on position, not yet on performance"; the purpose line is the smallest text on the page. | P1 | Open | Slice 3: purpose in the headline position, doors in their own box, delete the copy listed in the Fable record §6.3. |
| H11 | Notes overlay accessibility. | P1 (a11y) | **Mostly fixed at `926ac3fb`.** Open: `zIndex` under the subject switcher, no background inert or scroll lock, "Copy deep dive" label, copy result not announced. | Render through the existing Radix `dialog.tsx` (portal, inert, scroll lock) or raise the overlay above the switcher and lock scroll; rename to "Copy notes"; `role="status"` on the copy result. |
| H2 | Stage A clears the saved selection while the taxonomy loads; the strip still shows it and the doors still work. | P2 | Open | Guard `units.length === 0` as Stage B does. |
| H4 | "Not sure" has no start. | P2 | Open | The decided line only: "Not sure? Start me at the beginning" saves the **first unit the taxonomy returns** (Physics 2 = 9, Physics C: E&M = 8) with `source: "estimated"`, strip reads "Starting point · Change". No lesson browser, no second position concept (one row per pack). |
| H7 / N4 | Every attempt is mapped with `unitId: null`, so every unit card says "Not enough evidence yet" forever. Backend only (unit lives in `content_taxonomy_labels`). | P2 | Open | Frontend: hide the labels and legend. Backend task: join the unit server-side. |
| N3 / H9 / H10 | "Worth revisiting" passes only AP Statistics Unit 1 pilot cells (`findPilotSkillByCell`); nine subjects see a permanent "Nothing due right now" under a second "Next best action". Explainer and deep-dive cards are not clickable. | P2 | Open | Remove the section (§5 decision (d)); cards open the notes overlay for their topic; one "Suggested next" heading. |
| H12 | No retry on the taxonomy and notes subsection errors; a failed Learn resolution shows nothing. | P2 | Open | Section retries; visible Learn failure. |
| H13 / N8 | 22 of 25 entitled accounts see "Which subject first?"; radios are never `aria-checked`, no saving state, no retry after a failed single-subject auto-select; the welcome banner says "Pick a unit" above it. | P2 | Open | Checked state, "Saving…", retry, welcome copy derived from the current step. |
| H14 | "minutes" is session start to last graded attempt, capped. | P2 | Open | Label "minutes (estimated)". |
| N7 | Notes exist for every topic in nine subjects (Physics C: E&M 17 of 31); the notes door is the most reliable and least prominent. | P2 | Open | When no example exists, the doors box points at notes and practice. |
| — | Edge cases from the Fable record §5c: save-on-change must key the mutation to the latest pick; E&M lessons with neither example nor notes must still offer Practice; on a phone the doors render below both selects and the Set button; "Welcome, jsmith2008" (email local part); the Recommended line is not `aria-describedby` on its door; welcome dismissal is per browser; the Radix dialog's animation is neutralised by the global zero-motion rule, confirm on a screenshot. | — | Open | Folded into the slices below. |
| H15 | No signed-in render at any width by either assessor. | Acceptance blocker | Open | Slice 2. |

## 4. Slices, in Sol's order

| Slice | Content | Findings | Owner / size |
| --- | --- | --- | --- |
| **1. Truthfulness and route reliability** | Scope attempts and sessions by active pack. Send `topicCode: null` on unit-only saves; fix the Stage A test. Stabilise saved vs draft lesson per §5(a). Stop the Learn door opening "coming soon": topic-level gate, honour the resolver, unknown ≠ unavailable. One rule for unit-only positions per §5(b). Guard the empty-taxonomy effect. | H1 N5 H3 N6 N1 H8 N2 H2 | Lovable, small: `home.functions.ts`, `HomeStageANew.tsx`, `HomeStageBBuilding.tsx`, `HomeStudyActions.tsx`, one test. |
| **2. Signed-in visual QA** on the named Preview commit that carries slice 1 | Desktop, 390px, 320px; Stage A with and without a saved lesson; Stage B; notes overlay open; long lesson names; 200% zoom; console and network. Doors visible on a phone without scrolling past the form is a pass condition. | H15 | David (ten minutes) or a controlled zero-attempt test account; Sol records. |
| **3. First-use clarity** | Purpose in the headline position; doors in their own box headed "Studying: [lesson] · Change"; "What did your class cover most recently?" with titles before codes; "Not sure? Start me at the beginning"; delete the negative copy; Stage B gets the same doors box and loses the threshold line; no dismissible panel. Door copy per the Fable record §6.2, except the Learn door line, which stays "See how a test-style question is asked and scored" (§5(c)). | H4 H5 H6 N7 | Lovable, medium. Re-run slice 2 after it. |
| **4. Shelves and access** | Remove "Worth revisiting"; hide unit evidence labels; cards open notes; finish H11 (portal or z-index, inert, "Copy notes", announced copy); subsection retries; subject picker states; "minutes (estimated)"; plain "Welcome"; `aria-describedby` on the doors. | N3 H9 H10 H7 N4 H11 H12 H13 N8 H14 | Lovable, small to medium. |
| Backend, separately scoped | Unit per attempt server-side (H7); B1–B9 from the unified recommendation; a real revisit list; per-topic practice availability if slice 2 shows empty queues. | — | Claude, backend tasks under `TASK-0048` successors. |

## 5. Product Owner decisions — DECIDED 2026-10-08 (David Bloom; recorded as `DECISION-0103`)

| # | Question | Sol | Fable | Decided |
| --- | --- | --- | --- | --- |
| (a) | Saved vs draft lesson | Persist before enabling doors, or an explicit "Apply lesson" with an unsaved cue. | Save on change; no Confirm button; inline "Saved". | **Save on change.** No Confirm button; inline "Saved"; the doors always read the saved lesson. Requires (b) and a mutation keyed to the latest pick. |
| (b) | Unit-only position | Not addressed as one rule. | One rule across all three doors. | **Unit-wide is a valid study scope.** Doors box reads "Studying: Unit 2 · pick a topic to narrow it"; Learn and Practice open unit-wide and say so on the plate; Notes lists the unit's topics. Never silently open topic X.1 under a "Unit X" heading. |
| (c) | Learn door line | "See an answered question and understand why the answer works." | "See a real test question answered, and why the right answer works." Neither says "scored", because the teaching pool is 186 MCQs and zero FRQs. | **"See how a test-style question is asked and scored."** The unified §3.1 sub-line stands; both assessors' alternatives are withdrawn. It is the line the hub already carries. |
| (d) | "Worth revisiting" | Honest empty, unavailable and error states with Retry. | Remove until a real revisit list exists. | **Remove.** It cannot render for nine subjects whatever its load state. |
| (e) | First-use explanation | Compact panel, dismissible, reopenable from "How Cramapple works". | Always on Stage A, absent on Stage B, no dismiss. | **No dismiss.** Shown on Stage A, absent on Stage B. |

## 6. Acceptance

Sol's matrix (challenge record) stands and is extended by these rows.

| Scenario | Expected |
| --- | --- |
| Saved topic with no teaching item inside a unit that has some (Calc BC 1.1; Precalculus 1.2) | Learn door reads "No worked example for this lesson yet"; Practice carries Recommended; the "coming soon" plate is unreachable from the hub. |
| Teaching-topics read fails or returns `entitlement_required` | Learn door stays enabled with its normal line; the plate explains. |
| Unit-only position | All three content doors describe the same scope; nothing silently opens the unit's first topic. |
| Change Unit 1 · 1.1 to Unit 2 with no topic | Stored `topic_code` is null; no door opens 1.1. |
| Student with attempts in two subjects | Stage, counts and "Based on your N graded attempts" use the active subject; switching to an untouched subject shows Stage A. |
| Returning Stage A student, cold load | Selects show the saved lesson while the taxonomy loads. |
| Any subject other than AP Statistics on Stage B | No "Worth revisiting"; one "Next best action". |
| Notes open, then the subject switcher | Switcher is not reachable above the open notes; closing notes restores focus to the door; "Copied" is announced. |
| Physics C: E&M Unit 11 | A lesson with neither example nor notes still offers Practice and says why the other doors are off. |
| Phone, 390px, Stage A | Doors visible without scrolling past both selects; no horizontal overflow; no clipped control. |
| Read-through by a student who does not know the word "unit" | Finds a way to start (Not sure link) and can say what the four doors do. |

## 7. Not verified by either assessor

Rendering at any width; whether the "coming soon" plate is what a student sees from the hub on the published build; comprehension (unified §5 protocol, unchanged); assistance attribution on the Independence bar (PR #380 package 2 validation).

## 8. Evidence and sources

Both evidence records carry their full source maps. Findings are cited by their original ids so either record can be checked without this document. App anchors at `926ac3fb`: `src/components/home/HomeV2.tsx`, `HomeStageANew.tsx`, `HomeStageBBuilding.tsx`, `HomeStudyActions.tsx`; `src/lib/home.functions.ts`, `home-snapshot.ts`, `practice-entry.ts`, `open-hand/teaching.ts`; `src/components/overlay/DeepDiveOverlay.jsx`; `src/routes/_ux.tsx`; `src/styles.css`.

**Approval state:** Lane 1 documentation only. **Unresolved:** §7. **Next action:** the implementation conductor scopes slice 1 under `DECISION-0103` against `926ac3fb` or later; Sol re-QAs each slice independently.
