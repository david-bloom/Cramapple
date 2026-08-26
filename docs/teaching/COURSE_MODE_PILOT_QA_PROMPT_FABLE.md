# QA Prompt — Course Mode AP Statistics Unit‑1 Confirm‑Transfer Pilot (PRODUCTION)

> Paste the block below into a new session to run QA. It is self‑contained.
> Context date: 2026‑08‑26. Target: the **live** production app — be careful.

---

You are QA‑ing a newly launched pilot on the **live production** app. This is prod:
make **no destructive changes** to shared data, create only a **throwaway QA student**,
and clean it up when done (or when asked).

## What you're testing — the "confirm‑transfer" beat (§7.1(b) guess‑floor)

In Course Mode, after a student answers a **counted** multiple‑choice question, the app
fetches **one different, same‑skill MCQ** (the "transfer item") and has the student answer
it to **confirm the skill transferred** before the counted question advances. This stops a
lucky guess from being scored as mastery. Your job is to prove the beat behaves correctly
and never makes a **false "same skill" / false mastery** claim.

## Environment

- **Front‑end (prod):** https://cramapple.com — Lovable‑published, served via Cloudflare.
  As of 2026‑08‑26 it is correctly wired to the **prod** Supabase project (verify: DevTools →
  Network requests go to `pcntajvbdfqhbeewmdry.supabase.co`, **not** `wmgjsdkphcyhngaffbqf`).
- **Prod Supabase project ref:** `pcntajvbdfqhbeewmdry` (us‑east‑2). Use the Supabase MCP
  tools against this `project_id`.
- **Repos:** backend `david-bloom/cramapple`; front‑end `david-bloom/exam-buddy-wireframe`
  (Lovable project `d334fed9-5a97-4e76-906e-7c0ad7082212`).
- **Browser:** prefer the pre‑installed Chromium via Playwright
  (`PLAYWRIGHT_BROWSERS_PATH=/opt/pw-browsers`; do **not** run `playwright install`).

## CRITICAL — the pilot pack (get this wrong and nothing works)

There are **two** published AP Statistics exam‑pack versions on prod:

| exam_pack_version_id | what it is | contents |
|---|---|---|
| `548f06be-ccf4-426d-b82b-b424137a4438` | original general pack — what Home surfaces & admins default to | 118 MCQ + 178 FRQ. **No pilot items.** |
| `7c5a2975-8f0e-45b9-8fcc-7ec9b8d81ada` | **PILOT pack** (released 2026‑08‑26) | **203 published Unit‑1 MCQs.** Confirm‑transfer QA runs here. |

The QA student's **`active_exam_pack_version_id` must be `7c5a2975`**, not `548f06be`.
Home may route to `548f06be`; if so, force the student's active pack and/or start the
session directly against `7c5a2975`. Subject: `ap-statistics`,
`subject_id = 30660307-eebd-4caf-a521-ca425ffa3017`.

## Prerequisite — provision a throwaway QA student

The owner login (`f5a26c6b`) is an **admin**, not a student, and won't exercise the flow.

1. Create a disposable auth user on the prod project (Supabase Auth admin) with a known
   email + password — or ask the owner to sign one up and hand you the login.
2. Wire it as a student: grant the `student` role, entitle it to AP Statistics, and set
   `active_exam_pack_version_id = 7c5a2975`. **Discover the exact mechanism** by inspecting
   how an existing student on `548f06be` is wired (role table, entitlement/enrollment table,
   `profiles.active_exam_pack_version_id`) and mirror it pointing at `7c5a2975`.
3. Verify signed in as this student: `home_quick_start_subjects` and the taxonomy return AP
   Statistics, and the app starts a Unit‑1 session **sourced from `7c5a2975`**.

## Backend contract (reference / for API‑level cross‑checks)

- **Selection RPC** (service‑role only):
  `app.select_confirm_transfer_item(_exam_pack_version_id uuid, _source_content_item_version_id uuid)`
  → returns **one different** published/approved MCQ tagged to the **same content cell** as
  the source; **excludes numeric‑answer cells (1.7×3.B, 1.9×3.B)**; returns nothing when no
  valid parallel item exists.
- **Delivery:** edge function `student-session-items` accepts a confirm‑transfer shape:
  `{ learning_session_id, confirm_transfer: { source_content_item_version_id } }` →
  `{ mode:"confirm_transfer", item | null, reason }`. **`item:null` (any `reason`) ⇒ no
  transfer**; close the counted item honestly.
- **Attempt:** reuse `attempt-response` (`create_attempt` → `save_response{selected_choice_key}`
  → `submit_response`) then `evaluate-attempt` with `operation: "grade_transfer_attempt"`.
  `points_earned === 1` ⇒ correct; `0` ⇒ miss. Cell mastery updates server‑side.
- **Cell‑state engine:** correct ⇒ cell → **independent**; miss ⇒ cell → **fragile**
  (tier unchanged; INV‑6).

## Invariants — the heart of the QA (verify each with evidence)

1. While the transfer item is on screen, `itemCursor` and the **"Question k of N"** text are
   **unchanged** (the counted item is still open).
2. After the transfer resolves, the displayed question advances by **exactly one** (k → k+1) —
   never twice.
3. A transfer **miss** routes into the existing Course Mode **repair** state for the counted
   item (does not advance past it).
4. A **fail‑closed no‑match** (`item:null`) does **not** relabel/consume the next queued item
   as "same skill" — the counted item closes honestly (no false transfer claim), then normal
   flow resumes.
5. **Help/assistance stays scoped to one item** — the counted item's help never leaks into
   the transfer item or vice‑versa.
6. **Confidence is calibration‑only** — selecting any confidence never changes grading/tiering.
7. **Numeric‑cell exclusion:** cells **1.7** and **1.9** (numeric, skill 3.B) never
   offer/trigger confirm‑transfer; a slipped‑through request returns `item:null` and must be
   handled as an honest close.

## Scenarios (browser E2E against cramapple.com as the QA student)

- **A — correct transfer:** start a Unit‑1 quick session, answer a counted MCQ in a
  **non‑numeric** cell (e.g. 1.1/1.2/1.3), answer the transfer item **correctly**. Assert
  invariants 1, 2, 5, 6 and cell → **independent**.
- **B — transfer miss:** same setup, answer the transfer item **incorrectly**. Assert
  invariant 3 (repair) and cell → **fragile**.
- **C — fail‑closed no‑match:** choose a cell with no valid parallel MCQ, or a numeric cell
  (1.7/1.9). Assert invariants 4/7 (honest close, no relabel).
- **D — regression:** ordinary (non‑transfer) items still advance normally; progress text
  correct; **no double‑advance** anywhere.

Capture a screenshot at each key state plus the Network entries showing
`student-session-items` (confirm_transfer), `attempt-response`, and `evaluate-attempt`
hitting `pcntajvbdfqhbeewmdry`. Cross‑check cell tier transitions with a prod DB read.

## Known issues (already logged — confirm, don't re‑file)

- **Routing:** Home quick‑start currently routes through
  `/session/setup?…&mode=quick&unit=1&topic="1.1"` instead of straight into `/session`. A
  scoped Lovable fix is planned. Note it if it blocks reaching a session; it is **not** the
  pilot behavior under test.
- **Prod `GET 400`** on `/rest/v1/sessions?select=id,started_at,ended_at,goal…` (a "recent
  sessions" side query; likely schema drift prod‑vs‑dev). Confirm and note; not blocking.

## Report

Produce a **pass/fail table** over invariants 1–7 and scenarios A–D, each with evidence
(screenshot names + network/DB notes). Flag any deviation from the **honest‑close /
no‑false‑mastery** guarantees as **high severity**. Do not modify shared prod content; remove
the throwaway student when finished (or on request).
