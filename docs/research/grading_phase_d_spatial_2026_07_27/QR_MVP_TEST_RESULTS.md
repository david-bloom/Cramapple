# TASK-0016 Phase D — Stage D2: QR Capture MVP Test Results

**Run:** 2026-08-19. Companion to `QR_MVP_IMPLEMENTATION.md` and
`SECURITY_PRIVACY_ACCESSIBILITY_REVIEW.md`.

**Evidence class: Repository only.** Everything below is `deno test` / `deno check` / `deno lint` /
`tsc --noEmit` / `vitest` / `vite build` against the code as written. **No test below ran against
Development or Production**, no migration was applied, and no live row or storage object was
created. §4 states exactly which Stage D2 test cases this therefore does *not* cover.

---

## 1. Backend — new unit tests

### 1.1 `_shared/capture-pairing_test.ts` — 35 passed / 0 failed

```
$ deno test --allow-net --allow-env capture-pairing_test.ts

Check capture-pairing_test.ts
running 35 tests from ./capture-pairing_test.ts
capability is opaque: 32 bytes of entropy, no embedded record data ... ok (15ms)
two capabilities minted back to back never collide ... ok (2ms)
capability generation uses the injected CSPRNG for all 32 bytes ... ok (1ms)
only the hash is stable/storable, and it is not the capability ... ok (2ms)
malformed capabilities are rejected before they are ever hashed ... ok (1ms)
a live, unused capability is usable ... ok (0ms)
expiry: a lapsed capability is refused even while state looks live ... ok (0ms)
expiry boundary is inclusive: exactly at expires_at is already expired ... ok (0ms)
replay: a consumed capability reports already-used, not expired ... ok (0ms)
a consumed capability stays refused even after it also expires ... ok (0ms)
cancellation and revocation are distinguishable terminal refusals ... ok (0ms)
attempt budget: retakes are allowed up to the cap, then refused ... ok (0ms)
every terminal state is classified as terminal ... ok (0ms)
TTL is short-lived by construction ... ok (0ms)
purpose binding: an absent declaration is fine (capability is authoritative) ... ok (0ms)
purpose binding: a matching declaration passes ... ok (0ms)
purpose binding: wrong attempt is refused ... ok (0ms)
purpose binding: wrong submission slot is refused ... ok (0ms)
purpose binding: wrong response version or item version is refused ... ok (0ms)
purpose binding: a non-drawn-response purpose can never be used here ... ok (0ms)
mint rate limit allows normal use and blocks a scripted loop ... ok (0ms)
mint rate limit stays blocked past the threshold, not just at it ... ok (0ms)
capture paths are owner-scoped so they satisfy ownsLearnerPath ... ok (0ms)
a retake never overwrites the previous original's bytes ... ok (0ms)
the derived, stripped copy never collides with the original ... ok (0ms)
two capabilities for the same user cannot collide on a path ... ok (0ms)
extension mapping covers every accepted media type ... ok (0ms)
access path accepts only the two contract values ... ok (0ms)
generic retake guidance names no defect and no content ... ok (0ms)
provenance event carries every field pairing_submission_provenance_event.v1 requires ... ok (0ms)
provenance event stores only the capability HASH, never the capability ... ok (1ms)
provenance binding uses the opaque subject ref, never a name or email ... ok (0ms)
provenance event falls back to the attempt id when there is no learning session ... ok (0ms)
timestamps are ISO-8601, as the contract's date-time format requires ... ok (0ms)
a submission-accepted event records explicit confirmation and lineage ... ok (0ms)

ok | 35 passed | 0 failed (32ms)
```

### 1.2 `_shared/capture-quality-check_test.ts` — 28 passed / 0 failed

```
running 28 tests from ./capture-quality-check_test.ts
all PASS + identifier NONE is ACCEPT ... ok (7ms)
one FAIL, rest PASS, identifier NONE is RETAKE ... ok (0ms)
any UNCERTAIN forces HUMAN_REVIEW even with a FAIL present ... ok (0ms)
a possible incidental identifier forces HUMAN_REVIEW, never a retake ... ok (0ms)
every FAIL is reported, not just the first ... ok (0ms)
disposition maps onto both downstream vocabularies ... ok (0ms)
retake guidance is generic by default, even when defects are known ... ok (0ms)
specific guidance is opt-in and capped at two defects ... ok (0ms)
specific guidance falls back to generic when no defect is known ... ok (0ms)
no capture-quality message ever describes the drawn content ... ok (0ms)
the system prompt forbids content grading explicitly ... ok (0ms)
no API key configured means the check is unavailable, not a failure ... ok (0ms)
a refused spend reservation must not call the model at all ... ok (0ms)
a reservation that throws is treated as refused, not as permission ... ok (0ms)
an HTTP error is a technical failure, not a retake ... ok (6ms)
a network error is a technical failure ... ok (1ms)
a timeout is reported as a timeout, distinctly from a network error ... ok (0ms)
an unparseable model response is a technical failure, not HUMAN_REVIEW ... ok (0ms)
a response missing one label is rejected, not silently defaulted ... ok (2ms)
a healthy model response produces an assessed outcome ... ok (0ms)
the request never asks the vendor to retain the image ... ok (2ms)
timeout is clamped so an upload path cannot hang on this check ... ok (0ms)
parser reads both the flat and nested Responses-API output shapes ... ok (0ms)
parser rejects an out-of-enum identifier rather than coercing it ... ok (0ms)
parser rejects an out-of-enum label verdict ... ok (0ms)
parser rejects empty and non-object inputs ... ok (0ms)
an assessed outcome serializes to a capture_quality_result.v1 record ... ok (0ms)
a non-assessed outcome emits NO contract record (no fabricated evidence) ... ok (0ms)
```

Five of these exist specifically because the reverted Layer A version (`52efaef`) could not express
them: the three failure-mode tests (`http_error` / `network_error` / `timeout` /
`malformed_response` all being `technical_failure` rather than `HUMAN_REVIEW`), and the two
spend-metering tests (a refused *or throwing* reservation must not call the model).

### 1.3 `_shared/image-metadata_test.ts` — 19 passed / 0 failed

```
running 19 tests from ./image-metadata_test.ts
JPEG: EXIF (APP1) is removed and the image stays decodable ... ok (8ms)
JPEG: every APPn and COM segment is removed, structural ones kept ... ok (0ms)
JPEG: a file with no metadata is returned unchanged, and says so ... ok (0ms)
JPEG: scan data after SOS is copied byte for byte ... ok (0ms)
JPEG: the input buffer is never mutated ... ok (0ms)
JPEG: a truncated segment length is reported as NOT stripped ... ok (0ms)
JPEG: bytes that are not a JPEG are refused for the JPEG path ... ok (0ms)
PNG: eXIf/tEXt/iTXt/zTXt/tIME are removed, pixel chunks kept ... ok (0ms)
PNG: a metadata-free file is unchanged and reported complete ... ok (0ms)
PNG: a stream with no IEND is reported as NOT stripped ... ok (0ms)
PNG: an over-long chunk length cannot read past the buffer ... ok (0ms)
PNG: the input buffer is never mutated ... ok (0ms)
WEBP: EXIF/XMP chunks are removed and the RIFF size is corrected ... ok (0ms)
WEBP: odd-length chunks (RIFF padding) are handled ... ok (0ms)
WEBP: a chunk running past the buffer is reported as NOT stripped ... ok (0ms)
WEBP: a metadata-free file is unchanged ... ok (0ms)
audit summary records WHAT was removed, never the removed content ... ok (0ms)
audit summary distinguishes 'nothing present' from 'could not parse' ... ok (0ms)
metadata_status values are drawn from capture_image_record.v1's enum ... ok (0ms)
```

The strip tests do not stop at "the segment is gone": each container's happy-path test re-runs
`identifyImage` (the same validator `attach_capture` uses) on the stripped output and asserts the
same media type and the same declared dimensions, so a "stripper" that quietly corrupts the image
fails.

### 1.4 Combined new-test run — 82 passed / 0 failed

```
$ deno test --allow-net capture-pairing_test.ts capture-quality-check_test.ts image-metadata_test.ts
ok | 82 passed | 0 failed (166ms)
```

## 2. Backend — no regressions in the existing suite

```
$ cd supabase/functions/_shared && deno test --allow-net --allow-env .
...
ok | 260 passed | 0 failed (1s)
```

260 = 178 pre-existing + 82 new. **Zero failures.**

**One thing worth recording so it is not mistaken for a regression later.** The first full-suite run
used only `--allow-net` and produced 4 failures, all in `loops-client_test.ts`:

```
$ deno test --allow-net .
FAILED | 256 passed | 4 failed (1s)
  sendLoopsEvent no-ops without throwing when LOOPS_SECRET_KEY is unset => ./loops-client_test.ts:4:6
  sendLoopsEvent posts the event with the configured key                 => ./loops-client_test.ts:21:6
  sendLoopsEvent does not throw when the Loops API returns an error      => ./loops-client_test.ts:55:6
  sendLoopsEvent does not throw when fetch itself rejects               => ./loops-client_test.ts:69:6
```

This is **pre-existing and unrelated** — that file reads `LOOPS_SECRET_KEY` and needs
`--allow-env`. Confirmed by running it in isolation with the flag:

```
$ deno test --allow-net --allow-env loops-client_test.ts
ok | 4 passed | 0 failed (30ms)
```

None of this stage's files are involved. The correct invocation for this suite is
`--allow-net --allow-env`.

## 3. Type checks, lint, and the frontend

```
$ deno check supabase/functions/capture-pairing/index.ts
Check supabase/functions/capture-pairing/index.ts

$ deno check supabase/functions/attempt-response/index.ts \
             supabase/functions/_shared/capture-pairing.ts \
             supabase/functions/_shared/capture-quality-check.ts \
             supabase/functions/_shared/image-metadata.ts
Check supabase/functions/attempt-response/index.ts
Check supabase/functions/_shared/capture-pairing.ts
Check supabase/functions/_shared/capture-quality-check.ts
Check supabase/functions/_shared/image-metadata.ts

$ deno lint <the four new/touched modules>
Checked 4 files
```

Frontend, on branch `phase-d2-qr-capture-rebuild` (off `origin/main` @ `e8b65e9`):

```
$ npx tsc --noEmit
(no output, exit 0)

$ npx vitest run src/lib/__tests__/capture-contract.test.ts
 Test Files  1 passed (1)
      Tests  16 passed (16)

$ npx vitest run
 Test Files  24 passed (24)
      Tests  229 passed (229)

$ npx vite build
✓ built in 1.97s
[nitro] ✔ You can preview this build using npx vite preview
```

229 = 213 pre-existing + 16 new. **Zero failures.** The production build is included because this
repo has a known failure mode where a build breaks while dev and `tsc` stay clean
(`feedback_lightning_css_comment_bug`), so `tsc` alone would not have been sufficient evidence.

The 16 new frontend tests are contract guards on the DECISION-0051 split. Two are worth naming:
`classifies an unknown or unexpected error as technical, not image quality` (the safe default — if
we cannot tell what broke, we must not tell a student their photo is bad), and
`requires a real attachment id on submission -- never a placeholder string`, which makes the old
`[hand-drawn capture submitted — capture:<id>]` shape that Stage D0 found unrepresentable in the
type.

## 4. Stage D2's named test cases — coverage, honestly

Stage D2 says: "Test cross-device binding, expiry, reuse, wrong-user access, wrong-slot access,
cutoff, blur, glare, perspective, malformed files, oversized files, and cleanup."

| Case | Covered how | Verdict |
|---|---|---|
| Cross-device binding | Unit tests on the binding resolution + a structural argument: the phone supplies no user/attempt/slot identifier that is used for authorization. | **Covered by construction + unit test** |
| Expiry | 3 unit tests incl. the inclusive boundary; plus DB-side re-check under row lock in `claim_capture_pairing_upload`. | **Covered (code path not executed against a DB)** |
| Reuse / replay | 2 unit tests + the `consume_capture_pairing` compare-and-set + `response_attachments_one_current_original`. | **Unit-covered; the CAS itself is unexecuted** |
| Wrong-user access | Structural (no user id is an input) + owner-scoped queries + `ownsLearnerPath` on the path. | **Covered by construction** |
| Wrong-slot access | 2 unit tests + the one-live-capability-per-slot partial unique index + folder-name-is-the-pairing-id path rule. | **Unit-covered; the index is unexecuted** |
| Malformed files | 7 unit tests across three containers + reuse of `validateCaptureObject` (already covered by the pre-existing `capture-attachment_test.ts`). | **Covered** |
| Oversized files | `MAX_CAPTURE_BYTES` / `MAX_DECLARED_DIMENSION_PX`, pre-existing tests in `capture-attachment_test.ts`. | **Covered (reused, not re-tested)** |
| Cutoff, blur, glare, perspective | **NOT COVERED.** These are *model-accuracy* cases: they require real photographs with those defects, run against the live vision model, and a measured agreement rate. The disposition *rollup* for a FAIL/UNCERTAIN verdict is unit-tested; whether the model returns the right verdict on a glared photo is unmeasured. | **NOT TESTED — needs real photos + a model run** |
| Cleanup | `expire_capture_pairing_tokens` is written but **has no scheduler**, and abandoned storage objects are deliberately not deleted (§6 of the implementation doc). | **PARTIAL — mechanism written, not exercised, not scheduled** |

**What no test here establishes, stated plainly:**

1. **Nothing has executed against a database.** The three SQL functions, both triggers, the partial
   unique index, and the RLS posture are reviewed and reasoned about, not run. The atomicity claims
   (row lock, compare-and-set) are the load-bearing ones and are exactly the claims a unit test
   cannot make. `supabase/tests/response_attachments.integration.sql` is the precedent for how this
   repo verifies that kind of thing — an equivalent script for the pairing tables does not exist
   yet and is the obvious next verification step.
2. **No end-to-end run happened.** No real phone, no real photo, no real upload, no real bind. The
   full-path claim in this stage is "the code composes correctly and type-checks", not "the flow
   works".
3. **The capture-quality check has never been called with a real image.** Its parsing, rollup,
   metering and failure classification are tested against synthetic responses. Its *accuracy* is
   entirely unmeasured — which is consistent with Stage D2's scope (capture MVP, not accuracy) but
   means no quality-gate claim can be made from this stage.
4. **Accessibility was not tested by a human.** See
   `SECURITY_PRIVACY_ACCESSIBILITY_REVIEW.md` §3.2.

## 5. Boundaries respected

- No `supabase functions deploy`, no `supabase db push`, no MCP `apply_migration` or `execute_sql`
  against any live project. The migration file exists and is unapplied.
- No Development or Production rows or storage objects created.
- Frontend committed locally only (`phase-d2-qr-capture-rebuild`, `6dd89ff`). No push, no PR, no
  Lovable publish.
- The stale shared `.worktrees/task0019-frontend` checkout was not modified; a fresh worktree off
  `origin/main` was used instead.
