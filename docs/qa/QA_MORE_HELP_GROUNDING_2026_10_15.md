# Independent More help backend review — 2026-10-15

Reviewer: fresh agent `/root/grounding_final_qa`.

## Verdict correction

The initial proposed source PASS is **superseded** by the conductor's actual failed Development apply. I missed a missing semicolon after the migration's closing `$function$` delimiter, before `revoke`. The saved `pg_get_functiondef` source lacked the terminator; reviewing its additive diff and passing TypeScript tests did not validate SQL execution. The conductor reports atomic apply failure and an unchanged Development function hash. No migration execution PASS should be inferred from my initial report.

The corrected migration diff changes exactly `$function$` to `$function$;`. After successful Development execution, its file is renamed `20261015175446_more_help_question_grounding.sql` to match the actual ledger. I independently confirmed the recorded ledger row, function MD5 `5c4799dfb8ca48d6e7f5491806e63803`, denied anon EXECUTE, and allowed authenticated EXECUTE. The conductor reports all six prepared real MCQ/FRQ session RPC assertions passed under transaction rollback.

**Revised proposed verdict: PASS for the reviewed source and successfully executed Development question-grounding migration.** This supersedes the initial syntax-unverified source verdict. It does not certify full feature release: browser authentication reaches RPC200, but the conductor reports a separate `student-session-items`500 from missing Development manifest/helper dependencies. No Production deployment or full browser lifecycle PASS is implied.

## Source and content checks completed

- Source implementation reviewed at `02e6978`, integrated HEAD `fce07915`; app wire compatibility at `c9c8d8b`.
- 31 backend tests passed, and `deno check` passed.
- All six pinned v2 paths/description MD5s match the reviewed manifest. Descriptions report graph observations or particle counts/volumes.
- Added authored-parts and source-figure paths maintain existing ownership/grading boundaries and server authority.
- Production 1,155 published versions (AB448, BC429, Chemistry278), including151 multipart versions: zero malformed/incomplete parts, blank/duplicate/>80-character keys, >26 parts, or empty-primary/nonempty-fallback cases.
- Development45 published versions (AB12, BC14, Chemistry19), including43 multipart versions: same zero results.
- Raw authored-parts JSON maximum Production2,131 characters, Development1,568; none near16,000.
- Exact local `helpContext` checks on content-only query results:120 Production mapped topics and44 Development topics; zero context-size failures, maximum6,149 characters versus32,000. Existing28 Production topic groups lack references; figures introduce no new refusals.
- No student/session/attempt tables read, live writes, or provider calls by this reviewer.

Reusable read-only evidence scripts: `/private/tmp/more-help-grounding-shape-audit-2026-10-15.sql`, `/private/tmp/more-help-grounding-context-audit-2026-10-15.sql`, `/private/tmp/more-help-grounding-context-audit-2026-10-15.ts`.

Outstanding: actual Development migration/runtime evidence, signed-in browser lifecycle, controlled provider output, and final release acceptance.

## Live output challenge — release FAIL

The conductor's first controlled provider request (`1/12`, saved privately at `/private/tmp/more-help-dev-ab-mcq-output-2026-10-15.json`) returns `ok:true`, `phase:before`, with headline **“Removable discontinuity: limit exists but differs from r(4)”**. The MCQ asks which assertions about existence of the limit, continuity, and a removable discontinuity are true. The headline answers those assessed assertions. Its safe-looking setup instructions below do not remove the disclosure.

**P1, release blocker:** before-submission generated copy discloses the requested conceptual conclusions. The source/migration PASS above does not imply a feature release PASS; this actual behavioral evidence requires remediation and re-QA before release.

Narrow proposed remedy: recognize the full-question continuity/limit statement-selection task, add a specific coaching boundary, and reject affirmative/negative verdicts about the assessed existence/continuity/removable statements across generated headline, explanation, next step, and follow-ups. Preserve generic reference definitions and question text; concept-word occurrence alone is not disclosure. Regression controls should include this exact captured headline and close verdict paraphrases, safe instructions to check the limit and point value separately, and permitted post-grade explanations. This follows the owner-directed targeted-checks-plus-human-review approach and does not require a universal semantic classifier.

### First repair challenge

The added task-specific boundary and validator reject the captured output, and32 local tests pass. Independent deterministic probes still accept these direct same-task headline conclusions: “r is not continuous at t = 4.”, “A removable discontinuity at t = 4.”, “Both I and III are true.”, and “Here, the limit exists.” The P1 remains pending repair of these obvious sibling forms. No additional provider requests were made by this reviewer.

### Revised targeted repair challenge

The four reported sibling forms are now added to the regression controls and rejected in all four generated fields. I reran32 tests successfully and independently checked that five safe conditional/general-definition forms remain accepted (including “If the limit exists, compare it with the recorded value.” and “Check whether r is continuous at t = 4.”). The guard remains task-specific; generic source definitions are unchanged and post-grade verdict controls remain allowed.

**Proposed PASS for the targeted repair and readiness for the next bounded Development replay.** This closes the concrete local validator findings; the original live-behavior release finding remains pending an actual corrected live output and human acceptance. This is not a universal semantic disclosure guarantee. No reviewer provider calls were made.

### Corrected actual Development replay (2/12)

I compared the preserved failed first output with the actual corrected `phase:before`, `ok:true` replay supplied by the conductor. **Proposed PASS for this sample's before-submit assistance boundary.** Its heading asks the student to check the limit and recorded value separately. The explanation gives a general conditional definition (“a limit that exists but differs from the function value is removable”) without asserting that this question satisfies it. The next step asks the student to factor, check cancellation, and compute the limit; it does not supply those results. All three follow-ups ask for checks or conceptual distinctions and do not confirm the requested assertions. The generic reference definitions remain permitted content.

The observed first-output P1 is remediated for this replay and its local regression controls. This assessment is an independent agent semantic review, not human acceptance or a general claim about all future model outputs. Other subject/type/lifecycle, image, grading, and release evidence remain separately required. No reviewer provider calls were made.
