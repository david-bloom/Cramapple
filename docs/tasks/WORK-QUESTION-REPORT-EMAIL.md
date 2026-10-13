# Question-pane issue reports with email

**Status:** Approved — implementation built; release requires verified delivery and review
**Owner:** David Bloom / Codex conductor
**Tier:** Standard implementation; Hard-Gate release
**Date:** 2026-10-12
**Branch:** codex/question-report-email (Cramapple backend and ap-prep-blueprint App)
**PR:** Pending creation

## Authorization

David requested replacing “Submitted answers are saved. What you are typing now is not” with “See something wrong or confusing?” and receiving an email identifying the current subject/question. Optional comments are authorized; comments must never be required. This is separate from the paused More help demo.

## Scope and acceptance

- Replace the current question-pane status text with the exact requested clickable copy.
- Offer reporting on MCQ/FRQ question states, preserving the answer and page.
- Let students send with no category selection or comment; optional bounded comment.
- Email the existing owner inbox (dbloom01@gmail.com) through the existing Loops service with authoritative subject, exact content-version ID, question text, mode and optional comment.
- Verify authentication and ownership of the served question; keep email credentials and recipient selection server-side.
- Prevent double sends, constrain report frequency, and show honest retry/error states.
- Do not email typed answers, grades, student identity, tokens or arbitrary page query strings.
- Validate desktop/mobile placement and a controlled inbox delivery before claiming live completion.

## Baseline evidence

App main/Lovable checkpoint 89888d6; text in src/screens/question-experience/QuestionExperience.jsx. Older ReportQuestionButton inserts into public.question_reports without email; this table exists in Production but not Development. Existing Loops transactional service is the relevant canonical email path. docs/INDEX.md has no current question-report notification entry; TASK-0061 and the transactional-email migration document are the nearest references. Primary Cramapple checkout has unrelated dirty work; isolated task branches are used.

## Release boundary

Implementation is authorized by the owner's explicit request. No claim of successful publication, delivery or Done until actual end-to-end evidence. Production publication must account for pending unrelated App changes; do not publish those as an incidental part of this task.

## Implementation checkpoint

See `docs/qa/QUESTION_REPORT_EMAIL_2026_10_12.md` for exact tests and Development state. All App tests/build/typecheck and backend handler/database checks pass. Full signed-in inbox test awaits a specifically authorized test account or an existing account; automatic approval review rejected creating an Auth fixture without that authorization. Production remains unchanged.
