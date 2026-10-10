# TASK-0068 — S1, S2, S3, S4 and S9 browser rerun

Date: 2026-10-09. Reviewer: Sol. Published surface: `https://app.cramapple.com/byoq`.

## Verdict

**The previously failing edit-preservation and completion-navigation checks now pass. Overall sign-off remains withheld:** the Calculus topic mismatch is reproducible, and S9's code-regeneration/timed-expiry portions were not tested. An unconfirmed-draft practice-rendering concern was also observed during cleanup; backend answer-saving enforcement was not tested.

This is a targeted rerun, not a new full BYOQ certification. Initial results remain in [the first report](QA_TASK0068_SOL_BROWSER_REPORT_2026_10_09.md).

Evidence convention: all UI results below are **Observed** unless explicitly marked **Untested** or **Inferred**. **Code-reviewed: none.** No implementation or deployment changes, sign-in, or commit. Tested anonymously in the in-app browser; no real phone. Mobile 375 × 812, desktop 1280 × 720; viewport override reset afterward.

Build pin: published URL and observed time, not an independently verified frontend hash. First interrupted capture began around 13:14 UTC; continued complete scenarios had Done timestamps 17:32:51 UTC (S1), 17:34:42 (S2), 17:35:53 (S3), and 17:37:01 (S4), or 13:32–13:37 EDT. No new deployment hash is asserted.

## Scenario results

| Scenario | Result | Fresh browser evidence |
| --- | --- | --- |
| **S1 — same-device clean MCQ** | **Pass tested flow** | The script's `subject=ap-statistics` now normalizes to `ap_statistics`, preserving Unit 1. Correct MCQ, four ordered choices, Statistics/Unit 1/topic 1.8 prefilled; no subject-mismatch warning. Changed `times` to `durations` in the stem and appended `(edited)` to choice B. Both survived confirmation. “Back to your question” linked to the **current practice route** `/byoq/3dfe18c9-398f-411e-ba32-3fd0f237e8b2`; clicking reached practice directly. All four hints, points guidance, and Lesson Notes inspected: no explicit correct-option letter, grading verdict, or preselected option observed. [Review](evidence/task0068-sol-rerun-2026-10-09/s1-review.jpg), [completion](evidence/task0068-sol-rerun-2026-10-09/s1-done.jpg), [practice](evidence/task0068-sol-rerun-2026-10-09/s1-practice.jpg), [reference](evidence/task0068-sol-rerun-2026-10-09/s1-reference.jpg). |
| **S2 — desktop/phone handoff** | **Pass functional resumed-owner variant; strict timing unverified** | Chemistry hyphen key normalized; subject Chemistry, Unit 3/topic 3.13 correct. Owner page opened after Page 1 saved, **before** phone Done, initially showing empty manual form. It automatically became filled “Is this your question?” with “Finish on your phone, or here.” and “Try reading it again” without reload. Phone confirmation automatically moved the owner to current Chemistry practice. Phone link pointed to `/byoq/c51ccd13-2542-4ebe-aa4d-d0d696b46dee`, not previous Statistics. [Owner review](evidence/task0068-sol-rerun-2026-10-09/s2-owner-review.jpg), [phone completion](evidence/task0068-sol-rerun-2026-10-09/s2-phone-done.jpg), [owner practice](evidence/task0068-sol-rerun-2026-10-09/s2-owner-practice.jpg). |
| **S3 — degraded photo / retry** | **Pass** | Correct stem and four choices; topic 1.8 selected. Owner again automatically received review. Filled stem `MY EDIT`, immediately pressed “Try reading it again”: after completed retry, `MY EDIT` remained and retry was enabled. Then cleared stem and retried once: original full transcription returned. Confirmed on desktop. [Before](evidence/task0068-sol-rerun-2026-10-09/s3-edit-before-retry.jpg), [after](evidence/task0068-sol-rerun-2026-10-09/s3-edit-after-retry.jpg), [empty field refilled](evidence/task0068-sol-rerun-2026-10-09/s3-empty-refilled.jpg). |
| **S4 — Calculus notation** | **Pass notation; topic discrepancy remains (P2)** | Exact formula meaning/grouping preserved: `f(x) = ln(6 - 2x)/(x + 1)`, interval endpoints, open parentheses, minus signs and all four choices correct. No LaTeX commands, fabricated diagram placeholder or semantic notation error. **Still selected topic 1.11**, alternatives 1.10 and 1.13; script ground truth **1.12 absent from top three**. Confirmation reached current practice route `/byoq/7b80277c-3b9a-442b-8acc-418f47973cdb`, showing guidance for 1.11. [Review](evidence/task0068-sol-rerun-2026-10-09/s4-review.jpg). |
| **S9 — lifecycle/errors** | **Pass tested portions; partial coverage** | Reopened the newly confirmed S1 capture: “This link has expired — make a new QR code on your computer.” Malformed `bqcap_nonsense` now gives the same actionable message instead of generic “Something went wrong”; no crash. [Consumed link](evidence/task0068-sol-rerun-2026-10-09/s9-consumed-link.jpg), [invalid link](evidence/task0068-sol-rerun-2026-10-09/s9-invalid-link.jpg). **Make a new code after QR expiry and the 30-minute review-window expiry remain Untested.** |

S2/S3 setup qualification: the QR image did not expose a separate copyable link in the observed UI. Used “I'm on my phone — use this device” to obtain the capture URL, opened it in the phone tab, then resumed the exact owner's item URL from the question list after upload and before Done. No browser Back and no reload were used to get review. This explicitly re-tests the prior resumed-owner failure; the original fresh QR-panel polling path is still **Untested**.

Timing observations (wall-clock from Done to first observed review; round trips make these upper bounds, not precise rendering durations): S1 ≤6.9 s, S2 phone ≤7.7 s and owner ≤7.8 s, S3 ≤5.8 s, S4 ≤6.5 s. S3 preserved-edit retry ≤6.4 s; emptied-stem refill ≤9.0 s. S2's URL-wait helper timed out, but the next snapshot showed automatic practice navigation at ≤10.4 s. **The strict approximately-3-second confirmation target is not certified**, and the helper failure alone is not an app failure.

S1 substantive actions: open intake, same-device button, pick fixture, Done, two field edits, confirm, click Back to your question — eight actions to practice, excluding QA observations and reference inspection. The other capture flows each used four substantive capture actions, plus the owner-tab setup/retry/confirmation actions specified above. No end-to-end student-time claim is made.

## Changes relative to the first report

| Previous finding | Rerun status |
| --- | --- |
| SOL-01 edit overwritten by retry (P1) | **Not reproduced; acceptance test passed:** `MY EDIT` retained after completed retry, emptied stem repopulated. |
| SOL-02 completion link opens editor (P2) | **Not reproduced:** S1, S2 and S4 completion links use current practice routes. |
| SOL-03 link points at previous item (P2) | **Not reproduced** across consecutive captures. |
| SOL-04 resumed-owner stale form (P2) | **Not reproduced:** S2 and S3 transitioned automatically without reload. |
| SOL-05 Calculus topic mismatch (P2) | **Reproduced:** same 1.11/1.10/1.13 suggestions, expected 1.12 missing. One fixture is not an aggregate accuracy estimate. |
| SOL-06 hyphen context dropped / malformed warning (P3) | **Not reproduced** for Statistics, Chemistry and Calculus BC; normalization visible in URL. |
| SOL-07 clipped single-line choices / small chips (P3) | **Improved in measured screens:** choices now multiline and wrapping. S4 buttons measured 44, 61 and 44 px; other measured buttons 47.5 px. Document width and scrollWidth both 375. No full accessibility audit claimed. |
| SOL-08 grading/feedback hint wording (P3) | **Still observed:** “Sure you need a hint?” / “listed on your feedback” next to “Nothing here is graded.” Deep dive is now named Lesson Notes. |
| SOL-09 caret notation (P3) | **Still observed in Chemistry:** `10^-5`, `10^4`, `M^-1 cm^-1`; no changed mathematical meaning. |

Additional concern — **Observed frontend behavior; P2 investigation recommended:** the interrupted first S1 item BQ-D9JQ6M stayed **Draft** in the list and was never confirmed. During approved cleanup, directly visiting `/byoq/70ec9ed9-676d-4911-b522-a20ed69b9d42` nevertheless rendered the practice question, answer radios, hints and reference controls without a confirmation gate. [Evidence](evidence/task0068-sol-rerun-2026-10-09/unconfirmed-draft-practice.jpg). This does not prove answer persistence works for drafts: no choice selected or answer submitted. Backend gating **Untested**. Consider redirecting draft practice routes to review to match the explicit-confirmation requirement.

## Side effects and cleanup

Five anonymous questions created in this rerun, below the script's eight-new-question limit for a run. The first S1 capture was interrupted; its extracted draft survived but its phone tab/session handle was lost, so a second fresh S1 was used for complete phone confirmation. Five fixture uploads total (two clean Statistics, Chemistry, degraded Statistics, Calculus), plus two retries on S3. No answer submitted or real student data uploaded. The original eight QA records were neither edited nor deleted.

| Code | Item ID | Purpose / final cleanup |
| --- | --- | --- |
| BQ-D9JQ6M | `70ec9ed9-676d-4911-b522-a20ed69b9d42` | Interrupted S1 draft — deleted |
| BQ-DW4CES | `3dfe18c9-398f-411e-ba32-3fd0f237e8b2` | Complete S1 — deleted |
| BQ-2QH8WW | `c51ccd13-2542-4ebe-aa4d-d0d696b46dee` | S2 Chemistry — deleted |
| BQ-75GFCD | `731b2ebb-e9a8-485c-8909-a619c13d41cd` | S3 degraded/retry — deleted |
| BQ-QQ2K3N | `7b80277c-3b9a-442b-8acc-418f47973cdb` | S4 notation — deleted |

David explicitly approved deletion of exactly these five records at action time. Each was deleted with Delete question → Delete. Final refreshed list contained only the **original eight records**, none of the five rerun targets. [Verified cleanup](evidence/task0068-sol-rerun-2026-10-09/cleanup-verified.jpg). No normal recovery mechanism was verified; treat these deletions as potentially irreversible. Storage-byte deletion and timed purge are **Untested**. Local screenshots/report retained, uncommitted; pairing handles and owner secrets omitted.

## Coverage limits / next checks

S9 regeneration and timed expiry; original fresh-QR desktop polling; strict S2 3-second latency; backend practice enforcement for unconfirmed drafts; full mobile/keyboard/screen-reader audit; signed-in and physical-phone parity; full typed-path/answer-material/multipage regression; aggregate model quality. No other scenario was silently promoted to Pass.

Recommended follow-up: retain the retry/navigation fixes, investigate topic ranking and draft practice rendering, then complete the remaining S9 checks. No implementation change made or authorized by this report.
