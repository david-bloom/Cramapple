# Lovable prompt (unsent: workspace out of credits, 2026-10-10)

Send to project 56cae479 once credits are added. Backend pieces: `get_practice_topic_availability`
(migration 20261010160000) and `student-session-items { teaching_image }` (commit 2fde897d). Both are LIVE in
Production (APPROVAL-0151: RPC applied; student-session-items v40). The prompt's fallbacks stay as defensive handling.

---

Three `/question` changes (your commit e4034ced). **Frontend only**: no Lovable Cloud, no database, no backend. Preview only; **do not publish**. Do not edit `AGENTS.md`, `roadmap.md`, or `__fixtures__`. Two new backend calls are described below. They reach Production after approval, so each needs a graceful fallback.

## 1. "You've seen the worked example" survives the switch to practice
Leaving the worked example navigates to `mode=practice`, and `key={searchStr}` remounts the page, so `sawWorked` is lost.
- Add `worked=1` to the URL when leaving the worked example, and keep it through practice for that topic.
- Derive `sawWorked` from `worked=1`.
- Drop `worked=1` when the topic changes.

## 2. Worked-example figure via `student-session-items` (not `storage-sign-url`)
`storage-sign-url` refuses students the `content-assets` bucket, so the figure can never load for a student.

**Request:** `POST student-session-items { teaching_image: { subject_key, topic_code } }`. No learning session is needed.

**Response:**
- `result: { mode: "teaching_image", content_item_version_id, image: null | { url, alt, long_description, expires_at }, reason }`.
- `reason` is `null`, `no_teaching_item`, `no_image` or `image_not_approved`.
- Errors: 401 `unauthorized`, 403 `forbidden`, 500 `*_failed`.

**How to use it:**
- Only call it when the worked example has `stimulus_image_path`.
- Render `image.url` with `image.alt`, plus `long_description` when present.
- Show the existing "Figure not available" note when:
  - `image` is null,
  - the call errors, or
  - the backend doesn't recognise `teaching_image` yet. Until it is deployed, the request falls through to `missing_required_fields` for `learning_session_id`.
- Never call `storage-sign-url` for this.

## 3. Suggest the nearest topic that has questions
Applies wherever a topic has no practice questions:
- the TopicNotice,
- the off-topic-first case,
- the full-page empty state, including the no-topic "no published questions of this type for your current unit yet".

In each of these, recommend the closest earlier and later topics that still have questions for this student.

**RPC:** `supabase.rpc('get_practice_topic_availability', { p_exam_pack_version_id, p_item_type, p_practice_format })` returns `{ currentUnit, itemType, topics: [{ unitNumber, topicCode, topicTitle, availableNow, availableLater, unlocksAtUnit }] }`, with topics in course order. `availableNow` uses the server's serving rules for this student.

**Behaviour:**
- **When a topic was requested:** offer the nearest earlier topic with `availableNow > 0` as a button: "Go back to {code} {title} — {n} questions". Offer the nearest later one the same way: "Go ahead to {code} {title} — {n} questions". Each button goes to `/question` with that `topic` and `unit`, and `mode=practice`.
- **When no topic was requested:** offer the nearest topics at or after the start of `currentUnit`, and the nearest before it.
- **Topics that only unlock later:** a quiet line "{code} unlocks when you reach Unit {unlocksAtUnit}", never a button.
- Keep **Continue** and **Change topic**.
- **Fallback:** if the RPC is missing or errors, or nothing has `availableNow > 0`, show the current copy without suggestions. Never invent a count.

## Tests (render the screen)
1. `worked=1` is added on leaving the worked example, and the "seen" line shows after the remount.
2. **Figure:**
   - The `teaching_image` request is sent with the subject and topic.
   - `image.url` renders with its alt text.
   - A null image, an error, or an unrecognised request each show "Figure not available".
   - `storage-sign-url` is never called.
3. **Nearest topics:**
   - When 1.2 has 0 questions and 1.1 and 1.3 have some, both buttons appear with correct counts and URLs.
   - Topics with only later questions produce no button.
   - A missing RPC shows the plain copy.

Report: files changed, tests and results, the real final commit hash, Preview URL, and confirm Production was not published.
