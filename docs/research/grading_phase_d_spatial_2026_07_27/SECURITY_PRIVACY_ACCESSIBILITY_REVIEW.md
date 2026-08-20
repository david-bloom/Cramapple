# TASK-0016 Phase D — Stage D2: Security, Privacy and Accessibility Review

**Written:** 2026-08-19. Companion to `QR_MVP_IMPLEMENTATION.md` (design and file inventory) and
`QR_MVP_TEST_RESULTS.md` (raw command output).

**Evidence class: Repository only.** Every verdict below is from code review plus automated tests
against the code as written. **No verdict below is "Live verified" or "Deployed verified"** — nothing
is deployed. Where a requirement can only truly be confirmed against a running system or by a human,
that is stated as such rather than being claimed as a pass.

---

## 1. Stage D2 security requirements — verdict per line

The Phase D prompt's Stage D2 section lists eleven security requirements. Each is quoted verbatim
and given an explicit verdict.

### 1.1 "no service-role credential in a client" — **PASS**

Three separate credential paths, none of which puts a service-role key in a browser:

- Primary device → `capture-pairing`: the student's own JWT, via `requireSupabaseAuth`'s
  user-scoped client. Authenticated by `requireProfile` in the function.
- Phone → app server: no Supabase credential at all. The phone holds only the capability.
- App server → `capture-pairing`: the service-role key, held in the app server process
  (`client.server.ts`, already the established pattern), never serialized to a response.

The phone's only credential-shaped artifact is a Supabase Storage **signed-upload URL plus its
upload token**, scoped by Storage to one exact object path that the server chose. It cannot write
any other path.

Verified additionally by the frontend build: `capture.functions.ts` imports
`client.server.ts` only inside a handler via `await import(...)`, matching that file's own warning
that top-level imports of it would ship to the client bundle.

### 1.2 "capability contains no readable learner PII and cannot access other records" — **PASS**

*No readable PII:* the capability is 32 bytes of `crypto.getRandomValues` output, base64url-encoded,
with a cosmetic `cap_` prefix. It is not a JWT, is not signed, and encodes nothing. Test
`capability is opaque: 32 bytes of entropy, no embedded record data` asserts that no field of a
realistic binding (user id, attempt id, response version id, item version id, slot) appears in the
handle in either dashed or undashed form. A second test asserts all 32 bytes come from the injected
CSPRNG, so a future edit that shrinks the buffer fails loudly.

*Cannot access other records:* every binding fact is resolved server-side from the row the
capability's hash indexes. The token-leg operations accept **no** record identifiers as
authorization input:

- `create_capture_upload` takes no path — the path is built server-side from the capability's own
  user id and pairing id.
- `submit_capture` does take a path, and rejects anything that is not
  `<owner_user_id>/captures/<this_pairing_id>/original-*`. The folder name is the capability's own
  id, which the holder of a *different* capability cannot produce.
- Any echoed binding field (`attempt_id`, `submission_slot_id`, …) must match exactly, or the
  request is refused with `pairing_binding_mismatch`. An *absent* echo is fine (the capability is
  authoritative); a *present-but-different* one is fatal. Silently ignoring a mismatch would make
  the check decoration.

*At rest:* only `sha256(handle)` is persisted, mirroring
`pairing_submission_provenance_event.v1`'s `pairing.handle_sha256`. A leak of
`app.capture_pairing_tokens` yields no usable capability. RLS is enabled on that table with **no
policies for `authenticated`** — it is not client-readable at all.

*On the wire:* one projection function, `publicPairingView`, decides what a capability holder may
learn: state, slot id, generation, expiry, attempts remaining, quality state, and whether an
attachment exists. No user id, no attempt id, no response version id, no storage path, no handle
hash. A frontend test asserts those keys are absent.

### 1.3 "bind capability to user/session, item version, attempt, and submission slot" — **PASS**

`app.capture_pairing_tokens` carries all five as NOT NULL (except `learning_session_id`, nullable
only because admin/pilot attempts genuinely have none), plus
`upload_purpose = 'DRAWN_RESPONSE'` as a checked column so a future second upload purpose cannot
reuse a drawn-response capability.

All of them are **immutable after insert**, enforced by
`capture_pairing_tokens_guard_immutable_fields()` — a trigger, so it binds `service_role` too. A
capability cannot be repointed at a different attempt or slot after it has been handed to a phone.
`expires_at` is in the immutable set as well, so a capability cannot be silently extended.

The slot binding is a real constraint, not a naming convention: a partial unique index
(`capture_pairing_tokens_one_live_per_slot`) permits at most one non-terminal capability per
`(attempt_id, submission_slot_id)`. `mint_pairing` therefore cancels any live capability for the
slot before inserting — which is also the correct behaviour: re-minting a QR code must invalidate
the previous one, or the old code remains a valid write channel.

### 1.4 "HTTPS, private storage, RLS/policy enforcement, signed short-lived retrieval" — **PASS (repository-level), with one deployment-time item**

- *HTTPS:* all endpoints are Supabase Functions / Storage URLs (`https://` only). The one absolute
  URL in new code is `https://api.openai.com/v1/responses`.
- *Private storage:* `learner-uploads`, reused unchanged. `app.response_attachments`'s own migration
  constrains `storage_bucket = 'learner-uploads'`, so this bridge cannot write elsewhere. No public
  bucket is created or used.
- *RLS:* `app.response_attachments` keeps owner-select-only with no client insert/update/delete
  policy. Both new tables enable RLS with no `authenticated` policies; only `service_role` is
  granted. `app.capture_pairing_events` additionally rejects UPDATE and DELETE for every role via
  trigger.
- *Signed short-lived retrieval:* the desktop thumbnail is a 120-second signed URL minted inside
  `pairing_status`, only after the row was fetched with `.eq("user_id", user.id)` — so producing the
  URL *is* the ownership check, and no client needs read access to the attachments table. The
  phone's upload URL is a Storage signed-upload URL for a single path.
- **Deployment-time item, not a code gap:** `capture-pairing` must be deployed with `verify_jwt`
  left at its default. The design does not need it relaxed (§1.1), but nobody should deploy it with
  `--no-verify-jwt` "to make the phone leg work" — the phone leg does not call it directly. This
  repo has no `supabase/config.toml`, so the flag is a deploy-command decision and cannot be pinned
  in code. **Flagged for whoever deploys.**

### 1.5 "MIME/signature/decode, size, dimension, and page-count validation" — **PASS on MIME/signature/decode/size/dimension; N-A on page count**

`submit_capture` calls the same `validateCaptureObject` that `attach_capture` calls, on bytes
downloaded from storage — never on client assertions. It enforces: magic-signature identification
(PNG/JPEG/WEBP), a real header parse for dimensions (a signature match with no parseable header is
rejected, not accepted with unknown dimensions), 1 KB minimum, 20 MB maximum, a 40,000 px dimension
ceiling, media-type match against any client declaration, and SHA-256 match against any client
declaration. Media type, digest, byte size and dimensions written to the database are the
**re-derived** values.

*Page count is N-A:* the accepted media types are single-image formats only. There is no
multi-page container in the pipeline — PDF and TIFF are not accepted, and HEIC is rejected client-side
with readable copy and server-side by signature. If a multi-page format is ever accepted, this
requirement becomes live and is not currently satisfied.

### 1.6 "EXIF/metadata stripping on derived/downstream images while retaining controlled audit provenance" — **PASS**

The original is bound first and left byte-for-byte untouched, EXIF included — Stage D2 also requires
the immutable original be preserved. Stripping therefore produces a **separate** object at a
**separate** path, bound as a **separate** `kind = 'derived'` attachment.

`_shared/image-metadata.ts` removes, at container level: JPEG APP0–APP15 and COM (covering EXIF,
XMP, ICC, Photoshop/IPTC, and the JFIF thumbnail — a second copy of the frame); PNG `eXIf`, `tEXt`,
`zTXt`, `iTXt`, `tIME`; WEBP `EXIF` and `XMP `, with the RIFF size field rewritten (omitting that
rewrite would make every decoder read the file as truncated). Colour/structural chunks are kept, so
the derivative renders identically. Tests assert a planted GPS string is absent from the output,
that the derivative still passes `identifyImage` with the same dimensions, that the input buffer is
never mutated, and that a container the parser cannot walk end to end is reported as **not
stripped** rather than "nothing to strip".

The derivative is re-validated before binding; if it cannot be re-validated it is not bound at all
(an unvalidatable derivative is worse than none), and the failure is logged. A derive failure never
fails the submission — the gradeable original is already safe.

*Controlled audit provenance:* `summarizeMetadataStrip` records the `metadata_status`
(drawn from `capture_image_record.v1`'s enum), the segment labels removed, and the byte count — and
**not** the removed content. A test asserts the planted GPS string does not appear in the audit
summary, because writing stripped EXIF into an audit row would merely relocate it.

### 1.7 "incidental-identifier handling" — **PARTIAL — mechanism present, effectiveness unmeasured**

The capture-quality check returns an `INCIDENTAL_IDENTIFIER` verdict (`NONE`/`PRESENT`/`UNCERTAIN`)
for a visible name, face or school marking. Any value other than `NONE` forces `HUMAN_REVIEW`
(`'indeterminate'`) and **never** a retake prompt — telling a student "retake this, we saw your
name" would relocate the privacy problem rather than contain it. Tested. The phone page also warns
before capture to keep names and unrelated things out of frame.

**What is not established:** whether the model actually detects identifiers reliably. There is no
measurement, no labelled set, and no accuracy claim here. The rollup is correct; its input is
unvalidated. Treat this as a mechanism that exists, not a control that works.

### 1.8 "malware/malformed-image failure behavior" — **PASS on malformed; PARTIAL on malware**

*Malformed:* rejected with a 422 and `failure_class: "blocked"` — explicitly not classified as an
image-quality problem (we never got far enough to judge the photo) and not as a bug. Truncated
JPEG segment lengths, PNG chunk lengths that would read past the buffer, WEBP chunks running past
EOF, missing IEND, and unrecognised signatures are all covered by tests. The metadata stripper
fails closed on all of them.

*Malware:* **no antivirus scanning exists, and this stage did not add any.** The mitigations are:
objects are never executed, never rendered server-side, stored in a private bucket, served only via
short-lived signed URLs, and must pass signature+header validation. That bounds the risk; it does
not eliminate it. Stated as a gap.

### 1.9 "replay prevention, rate limiting, audit trail, retention, and deletion" — **PASS on replay/rate-limiting/audit; PARTIAL on retention/deletion**

*Replay prevention:* single use is a database compare-and-set. `consume_capture_pairing` updates
only rows in `'paired'`/`'uploaded'`; a replayed submit updates zero rows and raises
`capture_pairing:not_consumable`, surfaced as `pairing_already_used`. The claim step
(`claim_capture_pairing_upload`) takes a `for update` row lock and re-checks state and expiry under
it, so two concurrent claims cannot both pass the attempt budget. Layered on top,
`app.bind_response_attachment`'s own row lock and the `response_attachments_one_current_original`
partial unique index mean a duplicate original cannot be created even if the capability layer were
bypassed. Tests pin that a consumed capability reports `pairing_already_used` **even after it also
expires** — ordering matters, so a replay is never misreported as a timing problem the student might
retry around.

*Rate limiting:* minting is limited per authenticated user (12 per 10 minutes, fixed window),
returning 429 with `Retry-After` and writing an audit row. Each capability permits at most 5 upload
attempts, enforced atomically in the claim function; exhaustion moves the capability to `rejected`.
TTL is 15 minutes. **Gap:** no per-IP limiting on the unauthenticated leg (§1.11 of
`QR_MVP_IMPLEMENTATION.md` §6.4) — `describe_capture` on a valid capability is unlimited. It
requires an unguessable 43-character handle and does no expensive work, but this is a real
limitation, not a covered case.

*Audit trail:* two independent trails. `app.audit_events` gets mint, rate-limit refusal, quality
assessment, each technical failure, and submission — hash-chained, and never containing the
capability (only its hash). `app.capture_pairing_events` gets a
`pairing_submission_provenance_event.v1`-conforming record per lifecycle transition, append-only by
trigger. A test asserts a generated capability never appears in a serialized provenance event and
that `learner_subject_ref` is the internal UUID, never an email or name (the contract's own rule).

*Retention/deletion:* **PARTIAL and honestly so.** `app.response_attachments` rows are
non-deletable by design (trigger + revoked grant), which is the intended immutability but means
"deletion" is a policy question this stage cannot answer. Abandoned unbound storage objects are not
cleaned up — deliberately, since deleting there could race a concurrent bind and a bound original is
immutable evidence. A bucket retention policy is project configuration, not code.
`expire_capture_pairing_tokens` exists for capability hygiene but has no scheduler (`pg_cron` is not
set up); expiry is still enforced on every read and claim, so correctness does not depend on it.

### 1.10 "no public bucket and no model-training use without separate approval" — **PASS**

No bucket is created. `learner-uploads` is private and reused unchanged. The vision request sends
`store: false`, so the vendor is asked not to retain the image — asserted by a test that inspects
the outgoing request body. No image is written to any research corpus, dataset, or training
artifact anywhere in this stage's code.

### 1.11 Cross-cutting: the one requirement the design satisfies structurally rather than by check

"Wrong-user access" and "wrong-slot access" (both named in Stage D2's test list) are not enforced by
a comparison that could be forgotten — they are unrepresentable. The phone supplies no user id, no
attempt id and no slot id that is used for authorization; all three are read from the capability
row. The only client-supplied identifier that reaches a decision is the storage path in
`submit_capture`, and it must sit inside the capability's own folder.

## 2. Privacy review

| Concern | Finding |
|---|---|
| Data minimisation in the capability | The capability encodes nothing. The phone-facing projection contains no identifiers. |
| Data minimisation to the vendor | One image plus a fixed prompt. No student name, no item text, no rubric, no prior answers. `store: false`. |
| Data minimisation in telemetry | Frontend error reports carry stage, error code and (for the QR component) the item ref — no image, no capability, no answer text. PostHog is deliberately not used for errors: its allowlist forbids exactly this kind of payload. |
| Metadata leakage | GPS/device/timestamp metadata is stripped from the derivative and confined to the private original (§1.6). |
| URL leakage | The capability travels in the phone URL — unavoidable for a QR code, and the reason it is 15-minute and single-use. Mitigated with `robots: noindex, nofollow` and `referrer: no-referrer` on `/capture-phone`, so the URL is not indexed and is not sent to third parties in a referrer header. |
| Answer-revealing copy | Every student-facing capture string is asserted by test to be free of "correct" / "wrong" / "answer" / "should be". The quality checker's prompt explicitly forbids judging correctness, and every label is defined in the prompt. |
| Identifier detection | Mechanism present, effectiveness unmeasured (§1.7). |

## 3. Accessibility review — what I could actually assess, and what I could not

**I am not a human tester and did not run a screen reader, a switch device, or a magnifier. Nothing
below is an accessibility pass.** What follows separates what is *structurally addressed in the
code* from what genuinely needs human testing.

### 3.1 Structurally addressed (verifiable by reading the code)

- **Non-QR fallback — a Stage D2 requirement (step 4), and the most important item here.** The
  pairing URL is rendered as real, selectable, focusable link text next to the QR image, not as a
  tooltip or an image alt. A student who cannot scan a QR code — no camera, a screen reader, low
  vision, a tremor, or simply a locked-down phone — can read or copy the link. This is the same
  fallback the previous implementation had, preserved deliberately.
- **The QR image is correctly marked decorative.** It is now `alt=""` with `aria-hidden="true"`
  (previously `alt="Scan to pair your phone"`, which announced an instruction a screen-reader user
  cannot follow while the real, usable link sat unannounced beside it).
- **Status changes are announced.** The desktop status region and the phone's `<main>` carry
  `aria-live="polite"`, so the phone-connected → photo-received → ready transitions reach a screen
  reader without a focus change. This flow is asynchronous and driven by a *different device*, so
  without a live region a screen-reader user would have no way to know anything happened.
- **Images have meaningful alt text where they are content.** The captured photo is
  "The hand-drawn work you photographed" / "The photo you just took" rather than a generic label.
- **Touch targets exceed guidance.** The phone's primary and secondary buttons are 56 px and 52 px
  minimum height, above WCAG 2.5.5's 44 px.
- **Text contrast, by computation.** The phone page's body text (`#374151` on `#fff`) is ≈10.4:1,
  and stays above 7:1 on the tinted panels — comfortably past WCAG AA's 4.5:1 for the values as
  written. Note this is arithmetic on hard-coded hex values, not a rendered-page measurement.
- **The file input is labelled.** `aria-label="Take a photo of your hand-drawn work"` on the
  visually hidden `<input type="file">`, which previously had no accessible name at all.
- **Failure copy is plain-language and blameless.** Technical failures say "on our side"; the
  generic retake copy is four concrete physical actions, not diagnostic jargon.
- **Colour is never the only signal.** Every tone-coded panel also carries a text heading
  ("A clearer photo would help", "Something went wrong on our side").
- **Native controls throughout.** Real `<button type="button">` and `<a href>` elements, so keyboard
  focus and activation come from the platform rather than being re-implemented.

### 3.2 Needs real human accessibility testing — not assessed

- Screen-reader behaviour end to end on **iOS VoiceOver and Android TalkBack**, which is where this
  flow actually runs. In particular whether the `aria-live` announcements fire usefully during the
  upload→check→review sequence rather than interrupting each other.
- Whether "photograph a sheet of paper, framed and in focus" is achievable at all for a student with
  low vision or a motor impairment. This is the deepest accessibility question in the whole feature
  and code cannot answer it. If it is not achievable, the mitigation is a policy one (an alternative
  submission route), and `DECISION-0051` removed the direct-upload fallback — worth an explicit
  owner decision rather than an assumption.
- Whether the 15-minute TTL is enough time for a student using assistive technology. It was chosen
  for security, not measured against assisted task completion. This is a plausible WCAG 2.2.1
  (Timing Adjustable) concern and I am flagging it as unresolved rather than claiming it is fine.
- Zoom/reflow to 400% and 320 px-width reflow.
- Focus order and visible focus indicators as rendered (the shared `cv-btn` styles were not audited).
- Keyboard-only completion of the desktop leg.
- Whether the QR code's rendered size and contrast are scannable for a low-vision user.

### 3.3 Accessibility regressions introduced: none identified

Every interaction the previous implementation offered is still present, and the four changes above
(decorative QR, live regions, labelled input, meaningful alt text) are improvements over it. The one
UX addition — an explicit review-then-submit step on the phone — adds a step, which is a small cost
against the Stage D2 requirement that the learner "reviews... and explicitly submits".

## 4. Summary table

| Requirement | Verdict |
|---|---|
| No service-role credential in a client | PASS |
| Capability has no readable PII, cannot access other records | PASS |
| Bound to user/session, item version, attempt, submission slot | PASS |
| HTTPS, private storage, RLS, signed short-lived retrieval | PASS + one deploy-time flag to respect |
| MIME/signature/decode, size, dimension validation | PASS |
| Page-count validation | N-A (single-image formats only) |
| EXIF stripping on derivatives, audit provenance retained | PASS |
| Incidental-identifier handling | PARTIAL — mechanism present, effectiveness unmeasured |
| Malformed-image failure behaviour | PASS |
| Malware handling | PARTIAL — no scanning; risk bounded, not eliminated |
| Replay prevention | PASS |
| Rate limiting | PASS on authenticated mint + per-capability budget; GAP on per-IP |
| Audit trail | PASS (durable log, not alerting) |
| Retention and deletion | PARTIAL — needs a bucket retention policy and a deletion policy decision |
| No public bucket, no training use without approval | PASS |
| Non-QR fallback | PASS (structural) |
| Screen-reader / assisted-completion accessibility | NOT ASSESSED — needs human testing |
