# QA script for Sol — TASK-0068 BYOQ photo extraction and student confirmation

STATUS: READY TO RUN once §1's precondition passes
DATE: 2026-10-09
OWNER: David Bloom (Product Owner); Claude (implementer, wrote this script); Sol (browser QA, independent)
BRANCH: `claude/task-0068-byoq-photo-extraction` (PR #393)
RELATED: `docs/product/BYOQ_PHOTO_EXTRACTION_PLAN_V2_2026_10_08.md` (§4 experience, §7.3 QA plan), `docs/tasks/TASK-0068-BYOQ-PHOTO-EXTRACTION.md` (acceptance criteria), `docs/handoffs/TASK0068_BYOQ_PHOTO_EXTRACTION_EXECUTION_2026_10_09.md` (what was built and deployed), `DECISION-0108`, `DECISION-0057`

## What this is

A student photographs a homework question. Cramapple now reads the photo with a model and proposes the question's type, text, answer choices, and a topic within the student's unit. The student sees every field prefilled beside the photo, can edit anything, and must press **"Yes, this is my question"** before the item is usable. Typing remains the fallback. **Nothing is graded and no correct answer is ever shown** (`DECISION-0057`): a BYOQ item never shows a verdict, a key, or which option is right.

David's standing instruction for QA applies: look for suboptimal experience as well as bugs. Distinguish the two.

## 0. Boundaries

- Anonymous use only, no sign-in, unless §8 is reached. No payment, no email, no account creation, no real student data, no publish, no deploy, no code change, no commit.
- Upload **only** the fixture pages in §2 (rendered from Cramapple's own published items) or one photo you take yourself of a printed page with no name on it. Never upload a page with a real person's name or a real school.
- Create at most **8** questions in total. **Delete every question you create** at the end (practice screen → "Delete question" → "Delete"). Anonymous questions also auto-purge after 30 days of inactivity.
- Each photo you finish costs one model call (about a cent). Do not loop.
- Evidence labels on every claim: **Observed**, **Code-reviewed: none** (source review is not your job here), **Inferred**, **Untested**. Pin the app build you tested (the Lovable commit shown in the editor, or the published URL and time).

## 1. Environment and precondition

Two surfaces exist. Use whichever the execution record's status log says is live:

- **Published app:** `https://app.cramapple.com/byoq`.
- **Lovable preview (pre-publish):** `https://id-preview--56cae479-f7c9-4988-b536-56538c38ee4e.lovable.app/byoq`. The preview talks to the **Production** backend.

Both need the Production `byoq` function deployed with extraction on. **Precondition check (do this first, with fixture 01):** complete §3 S1 through step 6. If after pressing **Done** the phone page shows "Reading your question…" and then **"Is this your question?"** with text filled in, proceed. If instead it shows "All set — go back to your computer" and no review screen, the backend is not live yet: stop, record **Blocked: Production function not deployed**, and report.

Viewports: desktop 1280 × 720; mobile 375 × 812 for every phone-leg screen (`/byoq/capture?t=…`) and for §7.

How to play the phone without a phone: the desktop QR panel has the button **"I'm on my phone — use this device"**. It opens the capture page in the same browser. The capture page's "Take photo" button opens a file picker; choose a fixture PNG. If your browser surface cannot pick files, record every phone-leg scenario as **Untested: no file upload** and run §5, §6 and §7's desktop parts only.

## 2. Fixtures

Repo path `scripts/byoq-extraction-benchmark/fixtures/sol/` (committed, 12 files). Ground truth is the published Cramapple item each page was rendered from.

| File | What it is | Ground truth / planted |
| --- | --- | --- |
| `01-stats-u1-mcq-clean.png` | AP Statistics Unit 1 MCQ, clean typeset | type mcq, 4 choices, topic 1.8 (five-number summary / boxplot) |
| `02-stats-u1-mcq-degraded.png` | Same item, rotated, blurred, uneven light, edge cut | same |
| `03-calcbc-u1-mcq-notation.png` | AP Calculus BC Unit 1 MCQ with ln, fractions, powers | type mcq, topic 1.12 |
| `04-biology-u2-frq.png` | AP Biology Unit 2 FRQ with parts (a), (b)… | type frq, no choices, topic 2.7 |
| `05-chem-u3-mcq-page1.png` | AP Chemistry Unit 3 MCQ with scientific notation | type mcq, topic 3.13 |
| `06-control-answer-key-calcab-u3.png` | Calc AB Unit 3 MCQ with a printed **ANSWER KEY** block naming option C | planted answer key |
| `07-control-circled-stats-u1.png` | Stats Unit 1 MCQ with option **D circled** in ink | planted circled option |
| `08-control-answer-line-calcab-u1.png` | Calc AB Unit 1 MCQ with a printed line **"Answer: B"** under it | planted answer line |
| `09-control-name-stats-u1.png` | Stats Unit 1 MCQ with "Name: Jordan Alvarez  Period 3" at the top | planted (fictional) name |
| `10-control-handwritten-stats-u5.png` | Stats Unit 5 MCQ with handwritten working below | planted student work |
| `11-control-blank.png` | A blank white page | not a question |
| `12-control-notes-not-a-question.png` | A page of class notes, no question | not a question |

## 3. Scenarios

Record for each: what you saw (quote copy exactly), step count, time from **Done** to the review screen, and every field that was wrong or missing versus the photo.

### S1 — Same-device photo intake, anonymous, with subject and unit context (fixture 01)

1. Open `/byoq/new?mode=photo&subject=ap-statistics&unit=1`. Expect the consent note ("Only upload questions you're allowed to share…"), a QR code, and **"I'm on my phone — use this device"**.
2. Press that button. Expect `/byoq/capture?t=…` with the three guidance steps, the privacy line, and **Take photo**.
3. Switch to 375 × 812 for the rest of this scenario.
4. Take photo → choose fixture 01. Expect "Page 1 saved" with a thumbnail, **Add another page**, **Retake this page**, **Done**.
5. Press **Done**. Expect "Reading your question…" (live region) and then, within about 10 s, **"Is this your question?"** and "Check every field and fix anything that's wrong. Nothing here is graded."
6. Check the review screen against the photo: photo thumbnails first (with "Show photos larger"), question type = Multiple choice, question text matches the printed stem, four choices in printed order with labels stripped, Subject = AP Statistics, Unit = 1, Topic prefilled (expect 1.8) with **"Cramapple suggests:"** chip and possibly **"Also possible:"** chips, **"I'm not sure"** available in the topic select.
7. Edit something: change one word of the question text and add "(edited)" to choice B.
8. Press **"Yes, this is my question"**. Expect "Done — your question is saved. Practise it here or on your computer." and **Back to your question**.
9. Press **Back to your question** (or open the desktop tab). Expect the practice screen: the photo above the question text, your edits present, choices A–D, "Nothing here is graded", hints and reference for topic 1.8.
10. Confirm nothing anywhere on the practice screen, hints, or reference says which option is correct.

Pass: steps 5–10 as expected; every field editable; the edit survived. Note the exact review-screen copy and the time at step 5.

### S2 — Desktop review after the phone finishes, and phone confirmation moving the desktop (fixture 05)

1. Desktop tab A: open `/byoq/new?mode=photo&subject=ap-chemistry&unit=3`; copy the capture link from the QR (the link under the QR, or use the button and copy the URL) and open it in tab B.
2. In tab B upload fixture 05 and press **Done**. Do **not** confirm there.
3. Return to tab A. Expect, within a few seconds, the same **"Is this your question?"** review prefilled, with the hint **"Finish on your phone, or here."** and a **"Try reading it again"** button.
4. In tab B press **"Yes, this is my question"**. Expect tab A to move to the practice screen within about 3 s without any click.

Pass: 3 and 4. Record whether tab A ever showed the old "Next: type the question" button instead.

### S3 — "Try reading it again" never overwrites an edit (fixture 02, degraded)

1. Desktop + phone as in S2 with fixture 02; on the desktop review, change the question text to "MY EDIT" and do not confirm.
2. Press **"Try reading it again"**. Expect "Reading your question…" then the review again.
3. Expect the question text to still read "MY EDIT" (the re-run fills only empty fields). Expect any notes such as "We couldn't read part of the photo…" to be listed above the form if the degraded page caused them.
4. Clear the text and press "Try reading it again" once more: expect the proposed text to return.

### S4 — Notation fidelity (fixture 03)

Upload fixture 03. On the review, compare the proposed question text and each choice to the photo character by character. Record every discrepancy (missing superscript, wrong fraction grouping, lost minus sign, LaTeX-looking text such as `\\frac`, `[see diagram in photo]` where there is no diagram). The product rule is plain Unicode text (x², √, ≤, a/b) and the photo stays visible as the reference. Grade **P2** if a discrepancy changes the mathematics, **P3** if it is cosmetic.

### S5 — FRQ with parts (fixture 04)

Upload fixture 04. Expect type = Free response, no answer-choice inputs, the parts (a), (b)… present in the question text, Subject AP Biology, Unit 2, topic prefilled (expect 2.7). Confirm, then on practice expect the free-response answer box and no choices.

### S6 — Answer material on the page (fixtures 06, 07, 08, 10)

For each, upload, reach the review, and record the notes and the question text. Then confirm and inspect the practice screen and hints.

| Fixture | Expected on review | Must never happen |
| --- | --- | --- |
| 06 printed answer key | Note **"This page looks like it includes an answer key. We kept only the question."**; the key block text absent from the question text and choices | The letter from the key appearing as an answer anywhere; any "correct" wording |
| 07 circled option | Question and four choices as printed; nothing says which is circled | Any text like "D is circled", "correct", a tick, or a pre-selected radio on practice |
| 08 printed "Answer: B" | Either the line is absent from the question text, or if it is present the text is **masked** ("▒▒▒") with "This looks like it includes the answer, so we've hidden it…" and a **Remove the answer text** button; confirmation blocked until removed | "Answer: B" readable in the question text or on practice |
| 10 handwritten working | Question as printed; the working not inside the question text | The working presented as part of the question or as an answer |

Any failure in the "must never happen" column is **P1**.

### S7 — Not a question, and personal information (fixtures 11, 12, 09)

- 11 blank: expect **"We couldn't find a question in this photo. Type it in, or retake the photo."** with empty fields; type a short FRQ in and confirm: it must still work.
- 12 notes page: same expectation as blank. Record if any sentence from the notes was turned into a "question".
- 09 name: expect **"This may include personal information. Review and remove it before continuing."** The detector is advisory (the benchmark caught 4 of 6); record whether it fired and whether the name appears in the question text. A name in the question text with no note is **P2**.

### S8 — Typed path unchanged (no upload)

Open `/byoq/new?mode=typed`. Type a stem containing "Answer: B" with two choices, press Continue: expect the masked view and **Remove the answer text**, then practice. Expect the typed flow, copy and controls to be exactly as before this change.

### S9 — Link lifecycle and errors

- Open the capture link from S1 again after the question was confirmed: expect "This link has expired — make a new QR code on your computer" or "This link has finished. Finish editing on your computer." (either is acceptable; record which).
- Open `/byoq/capture?t=bqcap_nonsense`: expect the dead-link message, no crash.
- On the desktop, press **Make a new code** after a code expired: expect a fresh QR.
- **Untested unless you have 30 minutes:** the phone review window closes 30 minutes after Done; after that the phone says "This link has finished. Finish editing on your computer."

### S10 — Multi-page (fixtures 05 then 04)

Take photo (05), **Add another page** (04), **Done**. Expect both thumbnails on the review and a question text that is not just page 1. Record what the model did with two different questions (the rule is: transcribe the most prominent complete one; this is an edge case, note the behaviour, not a defect unless it crashes or leaks).

## 4. Mobile layout (375 × 812)

On the capture page, the review screen, and the "Done" screen: no horizontal page scroll (`document.documentElement.scrollWidth` = 375), every control reachable and at least 44 px tall, chips wrap, "Show photos larger" works, the sticky/primary action visible without scrolling past the whole form is **not** required (record where the confirm button sits).

## 5. Accessibility (desktop, keyboard only)

On the desktop review: Tab through every control in order; the topic chips and "Yes, this is my question" are reachable and operable with Enter/Space; the notes region is announced (the form has `aria-describedby` pointing at the notes); after pressing **Done** on the phone, the status line "Reading your question…" is in a live region. Record anything that traps focus or is unreachable.

## 6. Friction (UX, not bugs)

Count steps and seconds for S1 from opening `/byoq/new?mode=photo` to the practice screen. Note every moment a student would hesitate: unclear copy, a wait with no feedback, a confirm button far from the fields, a chip whose meaning is unclear, a topic select that lists the wrong unit, a note that is alarming when it should be calm. Propose the shortest-flow improvement for each, as in the checkout QA.

## 7. Anonymous versus signed-in (optional, only with a test account)

If you have a Cramapple test student (never a real student): sign in, pick AP Statistics as the active subject, open `/byoq/new?mode=photo` **without** search params, and run S1 steps 2–9. Expect Subject and Unit prefilled from the account's saved position (or just the subject if no position is saved), and otherwise identical behaviour. Record any difference.

## 8. Report

Write `docs/qa/QA_TASK0068_SOL_BROWSER_REPORT_<date>.md` with:

1. **Verdict:** Pass / Fail, with the build pinned (Lovable commit or published URL and time) and which surface (§1) you used.
2. **Findings table** — `ID / severity / evidence | trigger and exact UI reference | student consequence | shortest-flow improvement`. Severity: **P1** = an answer, key, or "which option is correct" visible anywhere, another student's question visible, data loss, or the typed flow broken; **P2** = review flow blocked, a field silently wrong or missing with no note, a crash; **P3** = friction and cosmetic notation.
3. **Scenario matrix** — S1–S10 and §4–§7 with Observed / Untested and one line of evidence each, including Done-to-review time and the step count.
4. **Notation discrepancies** from S4 as a list.
5. **Side effects:** how many questions you created and that each was deleted.
6. **Untested** list, stated plainly.

QA proposes the verdict; David decides on expansion or rollback (the capability can be turned off with one configuration change and the typed flow remains).
