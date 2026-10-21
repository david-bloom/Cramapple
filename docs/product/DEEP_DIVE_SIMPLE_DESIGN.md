# Simple Deep Dive Design

Status: Local replacement prototype, 2026-10-08. Live app integration pending.

Owner direction: David Bloom requested replacing the current Deep Dive design
with the supplied Simple design, allowing the pasted notes to fit the destination
page width, defaulting to Letter portrait, and prioritizing printed document
layout. Stacking the five summaries is accepted. Content can continue onto
additional pages as needed.

Artifact: `DEEP_DIVE_SIMPLE.html`, a standalone browser document derived from
the supplied `Simple.dc.html`. The source attachment remains the design reference.
The topic text is preserved from that attachment; this change does not publish
or review instructional content.

The browser view retains the five colored summaries and full Deep Dive. It
uses fluid dimensions and reflows summary columns when space is limited.
Printing defaults to Letter portrait with one-inch margins, stacked summaries,
11-point body text, and one column. There is no fixed content height.

The Copy notes button produces both rich HTML and plain text. Rich HTML uses
inline formatting, ordinary headings and paragraphs, and no fixed widths,
heights, outer tables, or column layout. The destination document determines
the text width and page breaks. A clipboard payload cannot set Google Docs'
paper size or margins; the destination document should use Letter portrait.
Heading colors and summary rules are included; the destination's HTML importer
determines which decorative styles survive.

Verification: Playwright checked widths 320, 390, 768, and 1440 without horizontal
overflow, all five summaries, preservation of every source content paragraph,
and the copy button's HTML/plain-text payload. Chromium Letter renders of both
the print view and clipboard HTML produced two pages and were visually checked.
An actual paste into Google Docs has not been verified.

Live integration: apply the layout and `buildNotesExport` behavior to the live
Deep Dive renderer in the Lovable app. Its current source is outside this
checkout; this standalone artifact does not change the deployed app.

The current shared component was verified directly in Lovable project
`56cae479-f7c9-4988-b536-56538c38ee4e`, at commit
`a509b7d7e722cdb871a85b614bd6c19b50ecde9c`:
`src/components/overlay/DeepDiveOverlay.jsx`. Its question-screen copy action
in `src/screens/parts/QuestionPlate.jsx` currently exports plain text.

A preview-only implementation request was submitted as message
`umsg_01m4e86260fjat3g43hecb96s7` on thread `main`. Lovable created a reviewable
plan at `.lovable/plan.md` (commit `c6a7cd2b3ee46bc4740173113eac4142b170d7b9`)
and paused for human approval of `plan--show`. No preview implementation or
production deployment is confirmed. The approval question was presented to David.
