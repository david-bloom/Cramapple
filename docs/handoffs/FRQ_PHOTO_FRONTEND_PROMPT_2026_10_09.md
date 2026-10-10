# Frontend build prompt — photographed FRQ answers (Lovable App `56cae479`)

**Status:** Sent to the Lovable App agent on 2026-10-09 by Claude; recorded verbatim so the frontend contract is reviewable from this repo. Backend contract: `supabase/functions/attempt-response/index.ts` (`propose_transcript`, `confirm_transcript`, `redact_attachment`, extended `get_manual_grading_context`), `student-session-items` (`response_policy`), `capture-pairing` (`SAME_DEVICE`). Plan: `docs/product/HAND_DRAWN_RESPONSES_ALL_FRQS_PLAN_2026_10_09.md`. Decisions: `DECISION-0109`, `DECISION-0110`, `DECISION-0111`.

---

We are adding "photograph your work" to every free-response question on the Practice FRQ screen, behind a feature flag. The backend is already built and deployed to Development; this message is the frontend. Please read the files named below before changing them, keep the existing design system (the orange/Bungee tokens and the shared components in `src/components`), do not publish, and do not touch any BYOQ file (`src/screens/byoq/*`, `src/lib/byoq/*`, `src/routes/byoq*`).

## 1. Serving: `response_policy` on every FRQ

`student-session-items` now returns `response_policy` on each item: `"typed_only" | "photo_allowed" | "photo_required"`. In `src/lib/live-practice-frq/adapt.ts`, pass it through to the question as `responsePolicy`, defaulting to `"typed_only"` when the field is absent (so nothing changes until the backend that sends it is live). Add a unit test next to the existing adapt tests.

## 2. Feature flag

In `src/lib/feature-flags.ts` add `isFrqPhotoEnabled(subjectKey, isAdmin)`:
- `?photo=on` / `?photo=off` is a one-off override, persisted in `localStorage` under `cramapple.flag.frq-photo`;
- admins (`useIsAdmin`) are always on;
- otherwise on when the canonical subject key is in `VITE_FRQ_PHOTO_SUBJECTS` (comma-separated), default `ap-biology,ap-statistics`; `VITE_FRQ_PHOTO_SUBJECTS=all` means every subject, `none` means off.
Unit-test the pure part.

## 3. The student flow on `PracticeFrqScreen` (`src/screens/PracticeFrqScreen.jsx`, container `src/screens/LivePracticeFrq.jsx`)

When the flag is on and `question.responsePolicy !== "typed_only"`, show a "Photograph your work" control under the answer fields while the question is unsubmitted. For `photo_required` lead with it and say "This question needs a drawn answer. Photograph your page." The typed fields stay available in both cases (a student may type some parts and photograph others).

Put the logic in a new module `src/lib/live-practice-frq/photo.ts` (thin wrappers over `callAttemptResponse` from `src/lib/attempt-response-client.ts`, same invoke pattern as `grade.ts`) and the review-screen rules in a pure module `src/lib/live-practice-frq/photo-review.ts` with vitest tests.

**a. Prepare the slot.** On first click: `create_attempt` (same arguments `gradeLiveFrq` uses: `learning_session_id`, `content_item_version_id`, `attempt_mode: "frq"`, `assistance_state`), then `save_response` with `response_parts: { capture: "pending" }` and no `response_text`. Keep `attemptId` and `responseVersionId` in the screen state. From this point the photo path owns submission for this question: the ordinary Submit path must not create a second attempt (either seed the grading-chain record for this key with `{ attemptId, responseVersionId, stage: "saved" }` or route the Submit button through the photo path once a slot exists).

**b. Capture.** New shared component `src/components/session/ResponseCapture.tsx`, built from the logic in `src/components/session/CaptureItem.tsx` (mint via `mintCapturePairing`, poll `getCapturePairingStatus`, cancel via `cancelCapturePairing`, the same failure classification from `src/lib/capture-schema.ts`). Two presentations by `getDeviceClass()` from `src/lib/device-capability.ts`:
- desktop: QR code + the typed link + polling, exactly as `CaptureItem` does today ("Cancel pairing", "Take a new photo");
- mobile/tablet: a primary "Use this phone's camera" action that runs the phone leg inline. Extract the body of `src/routes/capture-phone.tsx` into a component `src/components/session/CapturePhoneFlow.tsx` taking `{ pairingHandle, accessPath, onBound }`; the `/capture-phone` route keeps using it with `accessPath: "QR"`, the inline use passes `"SAME_DEVICE"`. Extend the `access_path` enums in `src/lib/capture.functions.ts` (`createCaptureUpload`, and add an optional `access_path` to `describeCapture`) and in `src/lib/capture-schema.ts` to include `"SAME_DEVICE"`; the backend already accepts it on `describe_capture` and `create_capture_upload`.
Under the control, always show: "By submitting a photo, you agree to our Terms and Privacy Policy. Don't include names or other personal information in the photo." with links to `/terms` and `/privacy`.

**c. Read the page.** When the pairing status reports `attachment_id` and the quality state is not `retake_required` (or the student chose to keep the photo), call `attempt-response` `propose_transcript` with `{ attempt_id, response_version_id }`. Result: `{ transcript, parts, reused }` where `transcript` is `{ status: "proposed" | "failed" | "unavailable", proposed: { parts: [{ part_key, text, unreadable_regions, visual_elements }], unassigned_text, page_blank, printed_answer_key_present, possible_personal_information } | null, warnings: string[], failure }` and `parts` is the item's answer parts `[{ part_key, prompt_text }]`.

**d. "Is this your answer?" (this is the required behaviour, DECISION-0110).** Show the photo thumbnail (`attachment_preview_url` from the pairing status) beside the per-part answer fields, prefilled with the proposed text. Every field is editable. Then, generated by `photo-review.ts`:
- each `[unreadable]` marker in a part: highlight it and show "We couldn't read part of this — type what you wrote";
- a part whose proposed text is empty: "We didn't find an answer for part (x) in your photo. Add it here, or leave it blank.";
- each `[see photo: …]` marker: leave it in the text (it tells the grader a drawing is there) with a small note "Drawings stay in your photo; add any values or labels as text";
- `unassigned_text` non-empty: an "Also on your page" box with a button "Add to part (x)" per part;
- `printed_answer_key_present`: "We noticed a printed answer key on the page. Only your own work is scored.";
- `possible_personal_information`: repeat the no-personal-information reminder;
- always close with: "Anything we missed? Add it so we can score your whole answer and show you what to fix."
If `transcript.status` is not `proposed`: "We couldn't read your photo this time. Your photo is saved — type your answer below so we can score it.", empty fields, and one "Try reading again" button that calls `propose_transcript` with `force: true` (once).

**e. Confirm and submit.** Button "Confirm and submit": `confirm_transcript` with `{ attempt_id, response_version_id, parts: { [part_key]: text } }` (a 422 `transcript_empty` means "Add at least one answer before submitting"; `unknown_part` is a bug, report it), then `submit_response` with the same ids, then:
- if `responsePolicy === "photo_required"`: do **not** call `evaluate-attempt`. Record the attempt locally as pending and show "Sent to a reviewer. A Cramapple reviewer scores drawn graphs by hand, usually within 24 hours. We'll show the result here when it's ready." Poll `public.grading_results` by `attempt_id` (owner-readable) every 5 seconds for up to 60 seconds, then stop with the same copy. Fire `frq_photo_pending_review`.
- otherwise: call `evaluate-attempt` exactly as `gradeLiveFrq`'s evaluate step does and render the ordinary result. On the feedback card, "Your answer" shows the confirmed text, with a small photo thumbnail and a "View photo" link to the signed preview URL.
Error handling: a 409 `transcript_confirmation_required` on submit returns the student to the review step; `feature_disabled` hides the control and leaves the typed flow; `no_attachment` restarts capture; everything else goes through `classifyCaptureError` with the existing blameless copy.

## 4. Admin grading

- New route `src/routes/admin.grade-response.index.tsx` at `/admin/grade-response`: lists `list_manual_grading_queue` (`attempt_id`, `content_key`, `title`, `submitted_at`, `captured_at`, `student_display_name`), newest last, each linking to the per-attempt page. Admin-gated the same way `admin.grade-response.$attemptId.tsx` is today.
- Rewrite `src/routes/admin.grade-response.$attemptId.tsx` to call `get_manual_grading_context` (`{ attempt_id }`) instead of reading `attempts` / `response_versions` / `response_attachments` directly (those reads only ever worked for an admin's own attempts). The context now returns `content_key`, `title`, `stem`, `attachment_id`, `storage_bucket`, `storage_path`, `media_type`, `attachment_redacted_at`, `response_text`, `response_source`, `transcript_parts` (per part), `student_added` (per part, spans typed at review), `transcript_confirmed_at`, `item_parts`, and `criteria` with `judgement_kind` (`"text"` or `"image"`). Show the stem, the photo (sign it with `storage-sign-url` `sign_download` from the returned bucket/path; show "Photo redacted" when `attachment_redacted_at` is set), the confirmed transcript per part with student-added spans visibly marked, and each criterion with a text/image badge. Grading submission stays `record_manual_grade` as today.
- Add a "Redact photo" button (confirm dialog) calling `redact_attachment` with `{ attachment_id }`; on success show the redacted state.

## 5. Analytics (`src/lib/posthog.ts`)

Add, using only already-allow-listed property names (`subject_key`, `device`, `status`, `warnings_count`, `latency_band`, `edited_fields`, `seconds_band`): `frq_photo_offered`, `frq_photo_started`, `frq_photo_bound` (`status` = capture quality state), `frq_transcript_proposed` (`status`, `warnings_count`, `latency_band`), `frq_transcript_confirmed` (`edited_fields` = part keys the student changed, `seconds_band`), `frq_photo_graded` (`status`), `frq_photo_pending_review`. Never send answer text, image data, or ids.

## 6. Tests

Vitest for the pure modules: `photo-review.ts` prompts (unreadable, empty part, see-photo, unassigned, answer key, PII, closing prompt), `editedFields`, the flag logic, the `responsePolicy` adapt default, the `access_path` enum. Run `tsc --noEmit` and the vitest suite; `vite build` must register the new route.

## 7. Leave alone

`src/components/session/SessionFrame.tsx`, `src/components/session/CaptureItem.tsx` (read it, reuse its logic, but the `/session` surface keeps working as is), `src/routes/hand-drawn-pilot.tsx`, everything BYOQ, and the marketing components.
