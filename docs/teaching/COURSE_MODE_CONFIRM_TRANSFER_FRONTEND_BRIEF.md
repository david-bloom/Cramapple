# Reliable same-skill confirm-transfer — FRONTEND-ONLY Lovable brief

STATUS: build brief | DATE: 2026-08-26 | TARGET: `exam-buddy-wireframe` (Lovable) front-end.

## Why this is frontend-only (no Lovable Cloud)

The backend serving change is **already done in the Cramapple repo** and deploys through
the app's own Supabase (external to Lovable) via the normal migration/CLI flow — see
"Backend provided" below. Lovable's job here is **purely the client**: the `useSession`
state machine and rendering. It **calls** existing Supabase edge functions; it does not
build or deploy any server code, run a migration, or need a database. Therefore **Lovable
Cloud is not required** — the earlier plan asked Lovable to build server logic, which is
what triggered its "enable Lovable Cloud" gate. Everything below is React/TS only.

Cramapple's backend is a self-managed Supabase project, not Lovable-managed. Do **not**
enable Lovable Cloud; it would provision a second, unrelated backend.

## Backend provided (already in the repo — do not rebuild)

- `app.select_confirm_transfer_item(exam_pack_version_id, source_content_item_version_id)`
  — fail-closed selector: one different published/approved MCQ tagged to the SAME content
  cell as the source item; numeric cells (1.7×3.B, 1.9×3.B) excluded; returns nothing when
  no valid parallel item exists.
  (`supabase/migrations/20260826120000_course_mode_confirm_transfer_item_selector.sql`)
- `student-session-items` edge function extended with a **confirm-transfer request shape**
  that returns one render-ready item out-of-band from the ordinary queue, or a fail-closed
  no-match. It never mutates any queue (there is no server-side "displayed question" cursor;
  that lives entirely in `useSession`).
- The transfer **attempt** reuses the existing `attempt-response` + `evaluate-attempt`
  functions unchanged — no new endpoint.

## API contract

All calls are `POST https://<PROJECT>.supabase.co/functions/v1/<fn>` with headers:
```
apikey: <SUPABASE_ANON_KEY>
Authorization: Bearer <the signed-in student's access_token>
Content-Type: application/json
```
Every `attempt-response` / `evaluate-attempt` call needs a **fresh** `idempotency_key`
(UUID; 8–200 chars). `selected_choice_key` is the choice letter/key (e.g. `"B"`), the same
value the ordinary MCQ submit uses. Render the item from its `stem` exactly as an ordinary
item — the A–D options are embedded in the stem (enforced by the stem↔choices sync gate),
so the transfer item needs no special rendering.

### 1. Request the confirm-transfer item — `student-session-items`
Request:
```jsonc
{
  "learning_session_id": "<uuid>",
  "confirm_transfer": { "source_content_item_version_id": "<uuid of the item just answered>" }
}
```
Success — an item is available:
```jsonc
{
  "status": "ok",
  "function": "student-session-items",
  "result": {
    "mode": "confirm_transfer",
    "source_content_item_version_id": "<uuid>",
    "item": {
      "content_item_version_id": "<uuid>",   // use this for the transfer attempt
      "content_item_id": "<uuid>",
      "content_key": "…",
      "title": null,
      "stem": "…question text with A–D options embedded…",
      "stimulus": null,
      "frq_form": null,
      "practice_format": null,
      "parts": [],
      "media": [ /* signed image(s) if the item needs one; usually [] */ ]
    },
    "reason": null,
    "signed_url_ttl_seconds": 900,
    "omitted": []
  }
}
```
Fail-closed — **no** valid parallel item (no same-cell approved MCQ, a numeric-answer cell,
an untagged source, or a candidate withheld by the media gate):
```jsonc
{ "status": "ok", "result": { "mode": "confirm_transfer",
  "source_content_item_version_id": "<uuid>", "item": null,
  "reason": "no_parallel_item", "omitted": [ /* possibly one entry */ ] } }
```
**`item === null` (any `reason`) ⇒ do not attempt a transfer; close the original counted
item without making a "same skill" claim** (see state machine).

Error statuses to handle: `400 missing_required_fields` (bad/absent source id),
`404 source_item_not_found`, `409 session_content_mismatch` (source not in this session's
exam pack), `401 unauthorized`, `403 forbidden`, `409 session_not_active`.

### 2–4. Create → save → submit the transfer attempt — `attempt-response`
Three calls, each returns `{ status: "ok", result: … }`:
```jsonc
// 2. create_attempt  → result.attempt.id
{ "operation": "create_attempt", "idempotency_key": "<uuid>",
  "learning_session_id": "<uuid>",
  "content_item_version_id": "<transfer item's content_item_version_id>",
  "attempt_mode": "mcq", "assistance_state": "independent" }

// 3. save_response  → result.response_version.id
{ "operation": "save_response", "idempotency_key": "<uuid>",
  "attempt_id": "<from step 2>",
  "response_parts": { "selected_choice_key": "<chosen key, e.g. \"B\">" } }

// 4. submit_response
{ "operation": "submit_response", "idempotency_key": "<uuid>",
  "attempt_id": "<step 2>", "response_version_id": "<step 3>" }
```

### 5. Grade the transfer attempt — `evaluate-attempt`
```jsonc
{ "operation": "grade_attempt", "idempotency_key": "<uuid>",
  "attempt_id": "<step 2>", "response_version_id": "<step 3>" }
```
Response: `{ "status": "graded", "result": { "points_earned": 0|1, "points_available": 1,
"student_facing_summary": "…", … } }`. `points_earned === 1` ⇒ correct (transfer confirmed);
`0` ⇒ miss. Cell mastery is updated server-side automatically (the same cell as the source),
so the client does not compute mastery — it only reacts to correct/miss.

## `useSession` state machine (the actual work)

Represent the transfer item **separately** from `items[itemCursor]`. Add explicit
transitions; **do not reuse `moveOn()`** — it owns ordinary queue advancement.

- **`beginConfirmTransfer(sourceItem)`**: called after the student answers a counted MCQ
  that requires transfer confirmation (per §7.1). Fetch the transfer item (call 1).
  - `item` present ⇒ enter a `confirm_transfer` sub-state that renders the transfer item
    **without touching `itemCursor`**. Progress stays `Question k of N` (the counted item is
    still "open"). Help/assistance and confidence UI are scoped to this one transfer item.
  - `item === null` (fail-closed) ⇒ **do not** relabel or consume `items[itemCursor+1]` as
    "same skill." Resolve the original counted item honestly (no false transfer claim) and
    hand back to the ordinary flow (call `finishConfirmTransfer({ transferred: false })`).
- **`finishConfirmTransfer(result)`**: after the transfer attempt is graded (calls 2–5).
  - correct ⇒ close the counted item as confirmed.
  - miss ⇒ enter the **existing Course Mode repair state** for the counted item (do not
    advance).
  - Then resume the ordinary queue and increment the displayed question **exactly once**
    (`k → k+1`) — the single call to `moveOn()`/the ordinary advance for this counted item.
    Never advance twice (once for the transfer, once for the counted item).

Invariants to hold (and test):
- `itemCursor` and `Question k of N` are **unchanged** while the transfer item is on screen.
- After a transfer resolves, the displayed question advances by **exactly one**.
- A transfer **miss** routes to repair; a **fail-closed no-match** does not.
- Help/assistance stays scoped to a single item (never leaks the counted item's help into
  the transfer item or vice-versa).
- Confidence stays **calibration-only** (never changes grading or tiering).
- **Numeric-cell exclusion (1.7, 1.9):** do not offer/trigger confirm-transfer for the
  numeric-answer cells. The server also fails closed for them, so if a request slips through
  you will get `item: null` — handle it as the honest close, never a false "same skill" label.

## Validation (frontend)

- Vitest — the reducer/state machine: cursor unchanged during transfer; `k → k+1` exactly
  once afterward; miss → repair; fail-closed no-match → honest close (no relabel/consume of
  the next item); help scoped to one item; confidence never affects grade/tier.
- Vitest — the API client: correct request bodies for calls 1–5; handling of `item: null`
  and of the `4xx`/`409` errors above.
- Playwright — an authenticated Statistics session: answer a counted MCQ that requires
  transfer, complete the transfer item, assert the progress text and the single advance,
  with screenshots. (Auth against Dev; no production data.)

## Notes / assumptions

- The transfer item is delivered with the **same `RenderItem` fields** as an ordinary served
  item, so render it with your existing item component. If structured MCQ choices are later
  added to the serve payload, the transfer item gets them automatically (same delivery path).
- No production DB migration or frontend deploy is bundled here. The backend migration ships
  through the app's normal Supabase migration flow, independently of this Lovable build.
