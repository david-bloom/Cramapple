# Swallowed-error and fire-and-forget write audit (Assessment 3)

**Verdict: 22 table rows are `must-fail` (the request should have errored or rolled back and instead returns success or loses state), concentrated in three places: `review-decision` (9), `admin-content` (10), `evaluate-attempt` (2: the two writes that store the grade itself), plus `capture-pairing` `cancel_pairing` (1). None of the money-moving files has a `must-fail` row.** The audit read about 213 call sites across 41 files (list in the appendix) and found no case where a swallowed error can double-charge or lose a charge. The most student-visible defects are: (1) `evaluate-attempt` `index.ts:1884` and `:2627` do not read the error on the update that stores the grade, so a failure returns the grade to the student while the stored `grading_results` row stays `processing`; (2) `recordGrowthEvent` throws on an analytics-outbox error, and six handlers call it after the real work committed, so students see 5xx errors for trials, checkouts and cancels that succeeded (`evaluate-attempt:2616` additionally has no try/catch around it); (3) `capture-pairing` `cancel_pairing` tells the student the QR is cancelled when the update failed.

**Status:** read-only assessment; findings are candidates, not fixes. **Date:** 2026-10-21. **Author:** Claude (Sonnet 5.5), with four read-only sub-readers (one per file group); I re-read `evaluate-attempt:1884`, `:2616-2627`, `review-decision:683-694`, `capture-pairing:870-882` and `_shared/growth-events.ts:94-116` myself and they match the reports.
**Reviewed against:** Cramapple `main` at `df39cd09` (all file:line cites refer to it).
**Evidence convention:** **Verified** = read in source at that commit. **Inferred** = a conclusion from verified code. **Not verified** = not demonstrated (stated per row; no database triggers, unique indexes or RPC bodies were read, so every consequence assumes no database backstop). A finding from source review is not a report of an incident.

## 1. Method and limits

- supabase-js never throws; `{ error }` is the only failure signal. A site list (`.insert( .update( .upsert( .delete( .rpc( storage upload/remove/createSignedUrl/createSignedUploadUrl` and `fetch(`, tests excluded) gave 213 lines in 41 files; readers also checked helper wrappers and sites the pattern missed.
- Each non-`ok` site is a row below. Sites whose error is read and acted on are counted as `ok` and not listed. **The 95 rows are not 95 call sites:** several rows group adjacent lines of one pattern (for example `403`/`1418`, the two `recordGrowthEvent` paths in a handler), and a few rows are error-ignoring reads that decide write behaviour, kept because they change outcomes. Per-file `ok` counts differ in definition between readers and are **not** consolidated; the totals that matter are the class counts of rows.
- Classes: `must-fail` (should return an error or roll back), `log-only` (should at least log; need not fail), `safe` (nothing depends on it). Money-movement sites were checked for double-charge, lost-charge and Stripe/database disagreement.

## 2. Counts

Rows by class: **must-fail 22, log-only 53, safe 20, total 95.**

| Function | must-fail | log-only | safe |
| --- | --- | --- | --- |
| admin-content | 10 | 2 | 1 |
| review-decision | 9 | 1 | 2 |
| evaluate-attempt | 2 | 7 | 2 |
| capture-pairing | 1 | 8 | 3 |
| _shared/growth-events.ts | 0 | 0 | 2 |
| _shared/public-rate-limit.ts | 0 | 1 | 0 |
| _shared/trial-actions.ts | 0 | 1 | 0 |
| _shared/trial-checkout.ts | 0 | 1 | 0 |
| _shared/trial-notices.ts | 0 | 2 | 1 |
| assign-for-review | 0 | 1 | 0 |
| attempt-response | 0 | 2 | 0 |
| byoq | 0 | 7 | 3 |
| cancel-trial | 0 | 1 | 0 |
| charge-due-trials | 0 | 1 | 1 |
| create-checkout-session | 0 | 2 | 2 |
| create-parent-payment-link | 0 | 1 | 1 |
| deliver-transactional-email | 0 | 1 | 0 |
| resolve-parent-link | 0 | 1 | 0 |
| send-parent-payment-email | 0 | 2 | 1 |
| session-event | 0 | 1 | 0 |
| start-trial | 0 | 2 | 0 |
| storage-sign-url | 0 | 3 | 0 |
| stripe-webhook | 0 | 4 | 1 |
| student-session-items | 0 | 1 | 0 |

Not listed above (design stated and handled, or fail-closed): `student-session-items` reads, `submit-response`, `reviewer-invite`, `content-intake` (error-checked, but see 3.4), `more-help` and `report-question` (4 and 3 sites, all handled), `stripe-webhook/index.ts` (13 handled sites), `_shared/parent-email-lifecycle.ts`, `payment-email.ts`, `payer-email.ts`, `loops-transactional.ts` (all error-checked and thrown).

## 3. Cross-cutting patterns

1. **Authoritative write, then an unread projection or status update.** `admin-content` commits the artifact state event and then updates the legacy `content_items` / `content_item_versions` rows unread (`:645`, `:659`); `review-decision` commits the immutable decision and then advances `review_status` unread. Student serving and the publish gate read the second set, so a failure is a split state reported as success.
2. **The `review-decision` empty catch is doubly ineffective (`:685-693`, Verified).** The comment says "Log but don't surface", the body is empty, and supabase-js does not throw on `{error}`, so the failed updates inside `advanceWorkflow` never reach the catch. A reviewer cannot resubmit once the assignment is locked, so a stuck item can only be recovered by reconciliation.
3. **`recordGrowthEvent` is not best-effort.** `_shared/growth-events.ts:96-114` throws on an outbox upsert or lookup error (Verified). Callers after a committed write: `start-trial:87`, `create-checkout-session:252` and `:357`, `create-parent-payment-link:174` and `:249`, `cancel-trial:63`, `attempt-response:1490` (admin), and `evaluate-attempt:2616` (no try/catch at all, so an unhandled 500 before the final `grading_results` update). On retry the event is often skipped as already done, so it is lost for good.
4. **Try/catch gives false coverage.** `session-event`, `storage-sign-url`, `evaluate-attempt:2353` and `admin-content` wrap unread writes in try blocks whose catch only sees thrown errors. `content-intake` has three separate non-transactional writes (`:159`, `:200`, `:247`) whose errors return 500, but a failure at `:200` leaves an orphan batch row and a failure at `:247` leaves committed rows behind a 500 (an admin-side retry duplicates the batch; consequence for admins not traced).
5. **Idempotency records written unread.** `session-event:122`, `storage-sign-url:180/227/275` and `admin-content:948` store the idempotency anchor in `audit_events` without reading the error; a failure means a retry re-executes. This is the same finding as F2 in `REFACTOR_PLAN_REVIEW_2026_10_21.md`, extended to `admin-content`.
6. **Cleanup after commit is inconsistent in `byoq`.** Storage removals are swallowed with `.catch(()=>{})` while the DB writes beside them throw into a 500 after the data is committed (`index.ts:954-966`), so the student sees an error for a capture that worked and the phone cannot retry. `touchOwner` (`store.ts:395`) is unread, and it drives the 30-day anonymous purge, so a silent failure becomes data deletion later.
7. **Best-effort is stated at the call site in capture-pairing and the payment-email paths, and nearly nowhere else.** `persistGradingMemory`, `persistGradingTelemetry`, `persistCellState`: the helper bodies swallow and log; only `persistCellState` states "Best-effort -- never fails the grade" at both call sites (`evaluate-attempt:1976`, `:2692`), `persistGradingTelemetry` states it at `:2630` but not at `:1941`, and `persistGradingMemory` states it at neither site (Verified by the reader; I re-read none of these call sites).
8. **Clean-up that cannot retry.** `stripe-webhook/trial.ts:250-252` detaches a parent's saved card in the not-applied branch with an empty catch and, unlike the two sibling branches, does not record `payment_method_id`, so the clean-up worker has no id to retry from. Possible gap against DECISION-0126 item 2; Not verified whether another path records it.

## 4. Calibration sites (required by the brief)

- `audit_events` inserts: `session-event/index.ts:122` and `storage-sign-url/index.ts:180, 227, 275` are unread (Verified, rows below).
- `evaluate-attempt/index.ts` near `:1909`: the comment at `:1900-1912` records that the attempts update "was previously fire-and-forget" and that the truth columns were 0% populated in Production. The current code (`:1922`, `:2652`) reads the error and logs it, then continues; a repeat would again leave the columns empty with only a log line. It is `log-only` in the table.
- `recordGrowthEvent`, `persistGradingMemory`, `persistGradingTelemetry`: see patterns 3 and 7. `recordGrowthEvent` is not best-effort; the two persist helpers are, with the design stated at the helper definitions but not consistently at the call sites.

## 5. Findings


### must-fail rows

| file:line | Operation / target | Error read? | Consequence | Confidence |
| --- | --- | --- | --- | --- |
| `admin-content/index.ts:253` | UPDATE app.content_items (title/type/status), existing-item branch | not read | Artifact draft and state event already written; legacy row keeps old metadata while the call returns 200. | med |
| `admin-content/index.ts:301` | INSERT app.mcq_choices | not read | content_item_versions row committed with zero choices; 200 returned; item later omitted at serving as choices_missing. | high |
| `admin-content/index.ts:329` | INSERT app.frq_criteria | not read | FRQ version committed with no rubric criteria although lines 322-326 require them; 200 hides it. | high |
| `admin-content/index.ts:374` | UPSERT app.content_item_labels | not read | Item committed but unlabelled; label-driven selection and coverage silently miss it. | med |
| `admin-content/index.ts:384` | UPSERT app.artifact_label_assignments | not read | Artifact-side label links missing; legacy and artifact label state diverge. | med |
| `admin-content/index.ts:645` | UPDATE app.content_items status (publish/retire) | not read | artifact_state_events already says published/retired; if the legacy row (read by serving) keeps its old status a publish does not go live or a retire leaves the item live to students. Returns 200. | high |
| `admin-content/index.ts:659` | UPDATE app.content_item_versions status/published_at | not read | Same split-brain as 645 at version level; 200 returned. | high |
| `admin-content/index.ts:948` | INSERT app.audit_events (also the idempotency record) | not read | All work committed; no audit row and no idempotency anchor, so a client retry re-runs the operation. | med-high |
| `admin-content/index.ts:345/352` | SELECT exam_pack_versions, content_labels (data only) | error ignored | Failure yields an empty label map so all requested labels are dropped silently (feeds 374/384). | med |
| `admin-content/index.ts:637/650` | SELECT legacy item and latest version (data only) | error ignored | Legacy update skipped with no signal (adds to 645/659). | med |
| `review-decision/index.ts:176` | UPDATE content_item_versions.review_status (tutor stage, MCQ) | not read, inside empty catch (685-693) | Two tutor decisions committed and assignments locked; if the update fails the item is stuck below the publish gate; reviewers get 200 and cannot resubmit (assignment_locked). | high |
| `review-decision/index.ts:180` | same, FRQ -> question_review_approved | not read, empty catch | Same stuck item. | high |
| `review-decision/index.ts:194` | same, aggregate 3 -> modification_reserved | not read, empty catch | Item stays in review limbo; no student impact. | high |
| `review-decision/index.ts:199` | same, aggregate 4-6 -> excluded | not read, empty catch | Item never excluded; a content owner might publish it unaware. | med-high |
| `review-decision/index.ts:280` | UPDATE review_status (reader approve, MCQ) | not read, empty catch | Item stuck below ready-to-ship. | high |
| `review-decision/index.ts:285` | UPDATE review_status (reader approve, FRQ) | not read, empty catch | Same. | high |
| `review-decision/index.ts:290` | UPDATE review_status -> modification_reserved (reader recycle) | not read, empty catch | Review limbo. | high |
| `review-decision/index.ts:294` | UPDATE review_status -> excluded (reader exclude) | not read, empty catch | Item never excluded. | med-high |
| `review-decision/index.ts:120,138` | SELECT group assignments / decisions (data only) | error ignored | Failure makes advanceWorkflow return silently; the aggregate is never evaluated and the item stays at tutor_review_pending. | high |
| `evaluate-attempt/index.ts:1884` | UPDATE grading_results with final MCQ grade (keyed by request_id) | not read, no try | Response returns graded but the stored row stays processing with no score. | high |
| `evaluate-attempt/index.ts:2627` | UPDATE grading_results with the LLM grade | not read | Final grade not stored; response returns it but the row stays processing with no score. | high |
| `capture-pairing/index.ts:874` | UPDATE token -> cancelled (cancel_pairing) | ignored (data only) | Handler returns status ok with the unchanged row; the student believes the QR is cancelled while it remains a live write channel until expiry. | high |

### log-only rows

| file:line | Operation / target | Error read? | Consequence | Confidence |
| --- | --- | --- | --- | --- |
| `admin-content/index.ts:613` | RPC app.project_artifact_state (read, data only) | error ignored | On failure priorState silently becomes "draft"; the state event records a wrong prior_state. | med |
| `admin-content/index.ts:222,261` | SELECT reads (data only) | error ignored | Read failure treated as "not found" / version 1; usually noisy via a unique violation. | low |
| `review-decision/index.ts:555,562` | SELECT canonical_answer for snapshot | error ignored | Immutable decision stores a null canonical_answer_snapshot. | med |
| `assign-for-review/index.ts:152-157` | UPDATE review_status -> tutor_review_pending | not read | Assignments inserted and 201 returned; review_status stays null (whether another reader needs it is not verified). | med |
| `student-session-items/index.ts:1081-1095` | RPC append_learning_session_items | logged only | Served-item list missing or partial; wrong N/M counter and resume position. Design stated at 1077-1079 ("Fail-soft"). | high |
| `session-event/index.ts:122` | INSERT app.audit_events (also idempotency record), 5 callers | not read | Session committed; a retry of a non-recommend session_start with the same key inserts a second learning_sessions row. | med |
| `storage-sign-url/index.ts:180` | INSERT audit_events (sign_delete) | not read | Object already deleted; audit trail lost; 200 says success. | high |
| `storage-sign-url/index.ts:227` | INSERT audit_events (sign_download) | not read | URL minted; no audit or idempotency record; replay re-signs. | high |
| `storage-sign-url/index.ts:275` | INSERT audit_events (sign_upload) | not read | Same as 227. | high |
| `evaluate-attempt/index.ts:1706-1712` | RPC reserve_model_usage via .then(r => r.data) | error dropped | An RPC error is reported as budget_capped (429, "reached today's research limit"); real error never logged. | med-high |
| `evaluate-attempt/index.ts:1720` | UPDATE grading_results -> failed (budget-failure path) | not read | Row stays processing; same-key retry returns 202 processing indefinitely. | med |
| `evaluate-attempt/index.ts:1922` | UPDATE app.attempts truth columns (MCQ) | logged only (1934) | The historical case (comment 1900-1912: columns were 0% populated in Production). Current code reads and logs the error but continues, so a repeat would again leave attempt columns empty with only a log line. | high |
| `evaluate-attempt/index.ts:2497` | RPC complete_model_usage in finally | not read | Ledger keeps the reserved cost, skewing the daily cap accounting. | med |
| `evaluate-attempt/index.ts:2616` | recordGrowthEvent(first_response_graded) | helper throws, no try/catch in the handler | An outbox error becomes an unhandled 500 before the final grading_results update (2627); the model call is paid for, and the row stays processing. | high |
| `evaluate-attempt/index.ts:2652` | UPDATE app.attempts truth columns (model route) | logged only (2665) | Same as 1922. | high |
| `evaluate-attempt/index.ts:1955,2672` | persistGradingMemory | helper catches and logs | memory_state silently stops updating for that student. Best-effort is not stated at the call sites. | high |
| `attempt-response/index.ts:1490` | recordGrowthEvent in record_manual_grade | helper throws; outer catch returns 500 | Manual grade already committed; admin sees a 500 and persistGradingMemory and recordIdempotentResult are skipped. | high |
| `attempt-response/index.ts:1498` | persistGradingMemory | helper logs | Memory not updated. | high |
| `byoq/store.ts:395` | UPDATE byoq_owners.last_seen_at (touchOwner) | not read | last_seen_at goes stale; the 30-day anonymous purge (index.ts:1303) selects on it and could delete an active student's questions. | medium |
| `byoq/store.ts:675` | RPC complete_model_usage | logged | Reservation stays counted as spend; not a leak. | high |
| `byoq/store.ts:739` | storage createSignedUrl (signRead) | null on error | Thumbnail does not render; no log. | low |
| `byoq/index.ts:950` | storage remove of stripped destination after bind failure | .catch(()=>{}) | Orphan object with no row; found only on item delete or owner purge. | med |
| `byoq/index.ts:954` | storage remove of raw upload after successful bind | .catch(()=>{}) | Photo with original EXIF/GPS lingers in incoming/ until a sweep runs; the sweep's caller was not verified. | med |
| `byoq/index.ts:959,966,653` | deleteAttachment / updateItem(source_kind) / last_practiced_at update after commit | throw -> 500 | The capture or response is already committed but the student gets a 500; the phone cannot retry because the raw upload is gone (959, 966) or a resubmit makes a second version row (653). | med |
| `byoq/index.ts:990` | extractForItem | .catch logs | Typed form is the fallback. Design stated: "A failure here never fails the capture". | high |
| `capture-pairing/index.ts:272` | INSERT audit_events (logAuditEvent) | logged | Audit row lost, incident_id null. Design stated. | high |
| `capture-pairing/index.ts:314` | UPDATE capture_pairing_tokens.failure_class | logged | Primary device never learns of a technical failure. Design stated ("Best-effort; never throws"). | high |
| `capture-pairing/index.ts:367` | RPC append_capture_pairing_event (7 call sites) | logged | Provenance event dropped from a stream described as complete. Design stated. | high |
| `capture-pairing/index.ts:718` | UPDATE token -> cancelled (supersede on re-mint) | ignored | Generation falls back to 1; the live-slot unique index should reject the insert (500). Index shape not verified. | med |
| `capture-pairing/index.ts:1342` | RPC reserve_model_usage (quality check) | ignored (data only) | A DB error reads as a cap refusal; the quality check is skipped and the photo accepted. | med |
| `capture-pairing/index.ts:1364` | RPC complete_model_usage | logged | Reservation leaks against the shared daily cap and can falsely reject unrelated students. Design stated. | high |
| `capture-pairing/index.ts:1403,1418` | storage upload + bind of derived copy | throws into log-only catch | Derived metadata-stripped copy absent or orphaned; original bound. Design stated. | med |
| `capture-pairing/index.ts:1481,1566` | UPDATE response_attachments.capture_quality_state | logged | Row annotation drifts from the verdict. Design stated. | high |
| `stripe-webhook/trial.ts:78-80` | paymentMethods.detach in refuse() | empty catch | Card stays attached; payment_method_id stored, clean-up worker retries (handler.ts:112-116). Design stated. | high |
| `stripe-webhook/trial.ts:101-103` | paymentMethods.detach in recordLateSetup() | empty catch | Same; design stated. | high |
| `stripe-webhook/trial.ts:249` | paymentIntents.cancel after not-applied activation | empty catch | Unconfirmed PaymentIntent stays open; no grant. Whether clean-up covers this state is not verified. | medium |
| `stripe-webhook/trial.ts:250-252` | paymentMethods.detach for a parent_share order, not-applied branch | empty catch | Parent's card stays saved and payment_method_id is not recorded on this path, so the clean-up worker has no id to retry from (possible gap against DECISION-0126 item 2). | medium |
| `_shared/trial-actions.ts:148-150` | catch {} around cancelTrialOrder in resumeUnsettledCancellations | empty catch, nothing logged | Access already ended; a persistent settlement failure (missed refund or uncancelled PaymentIntent) is invisible. Retried each run; double refund guarded by an idempotency key. Design stated ("next run tries again"). | high |
| `_shared/trial-notices.ts:322-323` | UPDATE trial_notice_jobs delivered_at after Loops send | not read | Email already sent; job is re-claimed and resent under the same Loops idempotency key (409 treated as accepted); a duplicate is possible outside the idempotency window. | med |
| `_shared/trial-notices.ts:330-334` | UPDATE trial_notice_jobs last_error/needs_review (in catch) | not read | Backoff and needs_review not recorded; lease expiry re-claims without the 8-try flag. | high |
| `_shared/trial-checkout.ts:431` | checkout.sessions.expire after losing compare-and-set | empty catch | Orphan setup session could be completed by the buyer; the webhook logs and never activates. No charge. | med |
| `charge-due-trials/handler.ts:166-169` | UPSERT trial_worker_heartbeat | not read | Worker may look dead to a monitor (monitor not verified); charge work already done. | high |
| `send-parent-payment-email/index.ts:167-171` | recordParentRequestLifecycle | logged (constant string) | Request email sent; reminder and expiry jobs may not be queued, with no error detail logged. Design stated. | high |
| `send-parent-payment-email/index.ts:178-186` | INSERT parent_payment_email_requests in finally | logged | This table is the per-session send rate-limit counter; a failed insert lets sends exceed the cap. | med |
| `start-trial/index.ts:87-97` | recordGrowthEvent(trial_started) | throws -> 500 | start_trial RPC already committed; the student sees trial_start_failed; on retry the event is skipped as already_started, so it is lost. | high |
| `start-trial/index.ts:102-110 + _shared/loops-client.ts` | fetch Loops /events/send | logs, never throws | The marketing journey event is not delivered; no retry. Design stated. | high |
| `create-checkout-session/index.ts:252-258` | recordGrowthEvent(checkout_started), trial path | throws -> 502 | Order and Stripe setup session exist, student sees checkout_session_failed and no client_secret; retry reuses the pending order. | high |
| `create-checkout-session/index.ts:357-366` | recordGrowthEvent(checkout_started), paid path | throws -> 502 | Stripe session created (unpaid) but buyer gets 502; a "failed" attempt row is written for a call that succeeded; retry makes an orphan session. | high |
| `create-parent-payment-link/index.ts:174-180, 249-258` | recordGrowthEvent(checkout_started), trial and paid paths | throws -> 502 | Orders/sessions exist but the student never receives the parent link or URL; retry reuses the order or makes another unpaid session. | high |
| `cancel-trial/index.ts:63-70` | recordGrowthEvent(trial_canceled) after cancelTrialOrder | throws -> 502 | Trial already canceled and any refund done, but the student or parent is told "cancel_failed"; retry skips the event so it is lost. | high |
| `deliver-transactional-email/index.ts:53-55` | whole worker body in catch {} | empty catch, 503, no log | If deliverPaymentEmails throws, parent-lifecycle and trial-notice delivery do not run that invocation and nothing is logged. | high |
| `_shared/public-rate-limit.ts:106-109,119-122` | RPC record_public_endpoint_hit | logged, fail-open | Any DB error disables the limiter on the card-testing-sensitive trial endpoints. Fail-open is not marked as deliberate in the code read. | med |
| `resolve-parent-link/index.ts:75-78` | Stripe sessions.retrieve (read) | logged | Any Stripe error, including transient, shows the parent {status:"expired"}. | med |

### safe rows

| file:line | Operation / target | Error read? | Consequence | Confidence |
| --- | --- | --- | --- | --- |
| `admin-content/index.ts:598` | SELECT latest artifact_versions | error ignored | Reports artifact_not_found (400); fails closed. | med |
| `review-decision/index.ts:273` | UPSERT content_review_assignments (optional secondary QA fan-out) | not read, empty catch | Secondary QA assignments not created. Design stated: "optional secondary QA, not the gate" (222-223). | high |
| `review-decision/index.ts:244` | SELECT original tutor assignments | error ignored | Empty tutorIds; no fan-out (harmless). | med |
| `evaluate-attempt/index.ts:2354` | UPDATE grading_results -> processing + model columns | not read, in try | Metadata refresh only. | med |
| `evaluate-attempt/index.ts:2366` | UPDATE model_usage_ledger -> running | not read | Status stays reserved; completed later; cosmetic. | med |
| `_shared/growth-events.ts:144,150` | UPDATE growth_event_outbox (delivered_at / last_error) | not read | Analytics may double-send or lose the error; no money or student impact. | med |
| `_shared/growth-events.ts:128` | fetch PostHog /capture/ | response.ok checked | No timeout or abort signal, so a hung connection blocks the grading caller. Analytics only. | high |
| `byoq/index.ts:903,910,919` | storage remove of invalid raw uploads | .catch(()=>{}) | Raw object (up to 20 MB, one with unproven metadata strip) stays in incoming/ until the closed-token sweep. | high/med |
| `byoq/index.ts:958` | storage remove of superseded attachment object | .catch(()=>{}) | Object orphaned until item delete or owner purge. | med |
| `byoq/index.ts:1323` | background purgeStaleAnonymousOwners via waitUntil | .catch logs | Purge skipped about 10 minutes. | med |
| `capture-pairing/index.ts:823` | UPDATE token -> expired on poll | ignored | Stale "waiting" state until the sweep. | med |
| `capture-pairing/index.ts:852` | storage createSignedUrl (preview) | ignored | No thumbnail. | high |
| `capture-pairing/index.ts:926` | UPDATE token issued -> paired (describe_capture) | ignored | Primary device shows "waiting" until the upload claim advances it. | high |
| `stripe-webhook/index.ts:888` | UPDATE stripe_webhook_events -> failed (inside outer catch) | not read | Ledger row stays processing; handler still returns 500 so Stripe retries. | high |
| `_shared/trial-notices.ts:285-286` | UPDATE trial_notice_jobs cancelled_at | not read | Job re-claimed and re-checked later. | high |
| `charge-due-trials/handler.ts:70-87` | record() inside the confirm try/catch | throws into Stripe-error catch | A DB error after a successful confirm is misclassified as transport_error; reconcile and the payment_intent.succeeded webhook recover. Misclassification, not a swallow. | med |
| `send-parent-payment-email/index.ts:95-100` | SELECT parent_payment_links | error ignored | Email carries the long Stripe URL instead of the short link. | high |
| `create-checkout-session/index.ts:207-210` | SELECT stripe_customers | error ignored | A saved customer is not reused; a duplicate Stripe customer is created. No charge. | med |
| `create-checkout-session/index.ts:389-404` | INSERT stripe_checkout_session_attempts | not read; empty catch guards only client creation | Attempt-audit row for failed Stripe calls silently lost. Design stated ("never mask the checkout failure"). | high |
| `create-parent-payment-link/index.ts:184-189` | INSERT parent_payment_links, trial path | any non-23505 error breaks | short_url null, long url still returned; no log line on the trial path. | high |

## 6. Questions for David

1. `review-decision` stuck items: do you want a one-off read-only query of items whose decisions are complete but whose `review_status` has not advanced, to see whether the silent failure has happened? I did not run it (the audit is source-only).
2. `evaluate-attempt:1884` / `:2627`: should a failed grade write return an error to the student, or fall back to retry? This is Standard tier for Codex; I have not drafted either.
3. Should `recordGrowthEvent` be made non-throwing (log and return) so analytics can never fail a handler? That would remove six student-visible 5xx paths in one change.
4. Is `capture-pairing` `cancel_pairing` (`:874`) reachable from the live app today? Its student-visible effect depends on the capture feature being live (TASK-0069 is dark per memory; not re-verified).
5. Each `must-fail` row is a candidate PR for Codex; do you want them grouped by function (four PRs) or by pattern?

## 7. Appendix: commands and method

```text
cd supabase/functions
grep -rnE "\.(insert|update|upsert|delete|rpc|upload|remove|createSignedUrl|createSignedUploadUrl)\(|[^a-zA-Z.]fetch\(" --include='*.ts' . | grep -v "_test.ts" | grep -v "/_test_setup"
  -> 213 lines (counts by file in the readers' reports: byoq/store.ts 24, admin-content 21, capture-pairing 19, evaluate-attempt 15, attempt-response 14, review-decision 11, stripe-webhook/trial.ts 10, byoq/index.ts 10, student-session-items 9, stripe-webhook/index.ts 9, ... 41 files)
```

Four read-only sub-readers each took a file group and read ~30 lines around every site: (1) `byoq/store.ts`, `byoq/index.ts`, `capture-pairing/index.ts`; (2) `admin-content`, `review-decision`, `assign-for-review`, `reviewer-invite`, `content-intake`, `submit-response`, `student-session-items`; (3) `evaluate-attempt`, `attempt-response`, `session-event`, `storage-sign-url`, `more-help`, `report-question`, and the `_shared` grading/memory/telemetry/growth helpers; (4) `stripe-webhook`, `charge-due-trials`, checkout/trial/payment functions and their `_shared` helpers. The sub-readers called no database tools and edited nothing. I re-read five of their highest-impact claims myself (see header). The remaining rows are the readers' findings, confidence as they reported it; the files and lines were not individually re-verified by me.
