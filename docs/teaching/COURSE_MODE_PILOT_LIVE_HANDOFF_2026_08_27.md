# Course Mode Pilot — Live Handoff (2026-08-27)

STATUS: resume guide for the next session (LLM + David). Read this first, then the
per-task files (`docs/tasks/TASK-0029..0036`) for detail.

## TL;DR — where we are

The **AP Statistics Unit-1 Course Mode pilot serves live on cramapple.com** — first
time ever (`pilot_sessions_ever` was 0 before tonight). Full loop proven in prod edge
logs 2026-08-27 01:04 UTC (session_start → published-MCQ read → attempt ×3 → graded);
confirm-transfer fired. Getting there cleared a **five-fault chain** (TASK-0029, 0032,
0033, 0034, 0035) and built the session experience (0030 params+bar, 0031 learn door,
0036 completion). Everything is on **PR #138** (green, mergeable). It works **on the
currently-live front-end build because of reversible prod data unblocks**; the code
fixes are on `main` but **not yet republished**.

## Key IDs / facts

| Thing | Value |
|---|---|
| Prod Supabase | `pcntajvbdfqhbeewmdry` · Dev `wmgjsdkphcyhngaffbqf` |
| Pilot pack (canonical now) | `7c5a2975-8f0e-45b9-8fcc-7ec9b8d81ada` (203 published Unit-1 MCQs) |
| General pack (retired-in-effect) | `548f06be-ccf4-426d-b82b-b424137a4438` |
| David's prod user | `f5a26c6b-3566-4d58-9e97-979fbb947564` (admin, also the test student here) |
| Front-end | `david-bloom/exam-buddy-wireframe`, Lovable project `d334fed9-…`, served to cramapple.com via Lovable/Cloudflare (NOT Vercel) |
| Front-end HEAD (all fixes) | `a711e7c` on `main` |
| Docs branch / PR | `claude/home-to-session-migration-e65jmk` / PR #138 (david-bloom/Cramapple) |

## Reversible prod data changes made this session (David to ratify or revert)

1. **Pilot pack date bump** — `app.exam_pack_versions.official_exam_date` for
   `7c5a2975`: `2027-05-11 → 2027-05-18`, so it wins the active-subject resolver's
   "newest published pack per subject" dedup. **This is effectively the pilot-cutover
   decision** (pilot pack is now the canonical AP Statistics pack; general pack still
   published but the resolver ignores it). **Revert:** `update app.exam_pack_versions
   set official_exam_date='2027-05-11' where id='7c5a2975-…';` — safe to revert **once
   TASK-0034's code fix (`resolveActiveAgainstPublishedPacks`) is republished**, since
   that honors the explicit active pack regardless of dedup.
2. **Profile active pack** — David's `active_exam_pack_version_id` set to `7c5a2975`
   (restored recorded Phase-4 state).
3. **Stale sessions** — ~44 general-pack `active` `learning_sessions` set to
   `completed` (they were being revived by `session_resume` and hijacking `/session`).
4. **`public.mcq_choices` view** — recreated without `is_correct`/`rationale`
   (migration `20260827010000`). Not a "revert" item — it completes PR #106 and is
   security-positive; keep it.

## What's still OPEN (all David's calls)

1. **Republish latest `main`** to cramapple.com (Lovable publish — NOT Vercel; Vercel
   doesn't serve the apex). Lands the code fixes: resolver, serving path, resume guard,
   scope fallback, params+bar, learn door, completion. Then revert the date bump (#1
   above) if desired.
2. **Ratify or revert** the pilot-pack canonicity (date bump).
3. **Done decisions + merge PR #138** (TASK-0029..0036). Only David sets Done.
4. **SME content feedback** — fill in `COURSE_MODE_STATS_UNIT1_SME_FEEDBACK_2026_08_27.md`
   (cell-level) and return; next session translates defects into generator fixes +
   re-runs D8 harness / Gate-2.
5. **Kick the Units 1–3 content build** — send Codex
   `prompts/CODEX_STATS_UNITS_1_2_3_PILOT_CONTENT_2026_08_26.md` (starts at a Phase-0
   cell-slate sign-off gate).

## Gotchas for the next session

- **cramapple.com is served by Lovable via Cloudflare, not Vercel.** A Vercel redeploy
  does nothing to the apex. To ship front-end code, republish in Lovable. Confirm the
  live bundle via the document response's `x-deployment-id` header.
- **Two ap-statistics packs still both published** — the resolver bug (TASK-0034) is
  fixed in `main` but only live after republish; until then the date bump is what keeps
  the pilot pack winning. Don't set the profile to the general pack or it re-hangs on
  the un-republished build.
- **Network from the agent container is walled off from cramapple.com and *.supabase.co**
  (proxy 403). Diagnose the front-end via HARs from David + the Supabase MCP against
  prod logs; can't curl the site.
- **`pilotCellFromContentKey` parses only `apstat-u1-…`** — extend for `apstat-u2-…` /
  `apstat-u3-…` when Unit 2/3 content ships (flagged in the Codex prompt).
- The QA browser scenarios (invariants 1,2,5,6; B/C) still want a formal scripted pass
  for the record — A (confirm-transfer) and D (serve/grade/advance) are proven live.

## Resume prompt (copy-paste)

> Continue the Cramapple Course Mode pilot. Read
> `docs/teaching/COURSE_MODE_PILOT_LIVE_HANDOFF_2026_08_27.md` first. The pilot serves
> live on prod via reversible data unblocks; all front-end fixes (TASK-0029..0036) are
> on `exam-buddy-wireframe` main (`a711e7c`) on PR #138, not yet republished. Pick up
> with [one of]: (a) I've republished — verify the live bundle + revert the pilot-pack
> date bump; (b) here's my filled-in SME feedback — turn it into generator fixes;
> (c) send the Codex Units 1–3 content prompt; (d) something I'll specify.
