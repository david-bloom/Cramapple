# Course Mode Pilot — Session Log, 2026‑08‑26

Scope: launch the Course Mode **AP Statistics Unit‑1 confirm‑transfer pilot** end‑to‑end and
promote it to production. This log captures the Prod cutover and the cramapple.com
Dev→Prod diagnosis, plus the state to resume from.

## Outcome (headline)

- ✅ Backend promoted to **prod** (`pcntajvbdfqhbeewmdry`): confirm‑transfer selector RPC,
  reconciled `student-session-items` edge function, 203 pilot MCQs loaded, 10 templates
  released, pilot pack **`7c5a2975`** published.
- ✅ **Root‑caused and fixed** the "only Statistics & Biology / can't start a session" report:
  cramapple.com was serving a **stale Lovable‑published bundle wired to Dev**. A republish
  against the prod `.env` cut it over. Verified via prod gateway logs (traffic now hits
  `pcntajvbdfqhbeewmdry`).
- ⏳ Remaining before true QA: entitle a throwaway **prod student on pack `7c5a2975`**, ship
  the `/session/setup` routing fix, and run the front‑end confirm‑transfer QA (handed to a
  separate Fable session — see `COURSE_MODE_PILOT_QA_PROMPT_FABLE.md`).

## The cramapple.com Dev→Prod incident (what "something changed" was)

**Symptoms reported:** only AP Statistics + Biology on Home; "Could not start a session:
Failed to send a request to the Edge Function"; Start routed through `/session/setup`.

**Diagnosis (evidence‑backed):**
- Prod's `home_quick_start_subjects` returns **all 10 subjects** eligible; Dev's returns
  exactly **Statistics + a 2nd Statistics row + Biology** — the exact list the user saw.
- Prod edge/gateway logs showed **zero** session traffic; **Dev** logged live `session-event`
  preflights during the user's test window.
- The shipped bundle `index-ZOUzQDdH.js` (from the user's HAR) had the **Dev** ref
  (`wmgjsdkphcyhngaffbqf`) **compiled in**, zero prod refs. `.env` in the repo is **committed**
  (not gitignored) and already pointed at prod — so the deployed JS predated the flip.

**Topology confusion resolved:** the Vercel `cramapple` project builds
`exam-buddy-wireframe` but its production deploy is aliased only to `*.vercel.app` —
cramapple.com is **not** on it. The apex domain is **Lovable's published deployment served
via Lovable's Cloudflare** (owner has no Cloudflare account). "Served by Cloudflare" appears
with no Vercel fingerprints (`x-vercel-id`/`x-vercel-cache` absent; Cloudflare `cf-ray` +
`x-deployment-id` present).

**Fix:** since `wmgjsdkphcyhngaffbqf` is nowhere in the repo, this was a **stale published
build**, not a dashboard env override. **Republishing** the Lovable project rebuilt against
the prod `.env`. The follow‑up HAR proved the cutover: at **20:09:34** Cloudflare began
serving deployment `9567e1f1…` (HTML → `index-CIpdKPEu.js`, prod baked in); every request
after that hit prod. All Dev hits in the recording pre‑date the flip (cached old bundle).

**Housekeeping for the user:** hard‑reload (Cmd+Shift+R) / private window to drop the cached
Dev bundle, and **sign in fresh** (browser still holds `sb-wmgjsdkphcyhngaffbqf-auth-token`).

## Activity log (this session)

1. Verified prod `home_quick_start_subjects` returns 10 eligible subjects; Dev returns the
   Statistics+Biology set the user saw.
2. Pulled recent edge logs: **Dev** receiving live `session-event` preflights at the user's
   test time; **Prod** receiving none.
3. Enumerated Vercel projects/deployments (team `bloom-llc`): `cramapple` builds
   `exam-buddy-wireframe`; latest prod deploy `fc015d7a` aliased only to `*.vercel.app`.
   cramapple.com absent from the alias set and project domain list.
4. Parsed the user's first HAR: no Vercel fingerprints anywhere; document + all assets served
   by Cloudflare; **shipped bundle bakes the Dev ref**. Confirmed the apex is a
   Cloudflare‑served (Lovable) deploy pulling from Dev.
5. Read repo `.gitignore` (`.env` is tracked) and Lovable `.env` (all vars → prod). Confirmed
   the code/preview are correct; only the published build was stale.
6. Converged with Lovable's own agent: republish is the fix. User set prod `ALLOWED_ORIGINS`
   and republished ("Fixed!").
7. Verified cutover on the backend (prod gateway logs now show `home_quick_start_subjects`,
   `get_student_taxonomy`, `get_topic_point_guides` from `pcntajvbdfqhbeewmdry`) and in the
   follow‑up HAR (deployment `9567e1f1…`, prod bundle `index-CIpdKPEu.js`).
8. Identified the two published Statistics packs and confirmed the **pilot pack** is
   `7c5a2975` (203 published Unit‑1 MCQs) vs the general `548f06be` (118 MCQ + 178 FRQ).
9. Wrote the Fable QA prompt and this log.

## Key IDs / reference

- Prod Supabase: `pcntajvbdfqhbeewmdry` · Dev Supabase: `wmgjsdkphcyhngaffbqf`
- AP Statistics subject_id (prod): `30660307-eebd-4caf-a521-ca425ffa3017`
- **Pilot pack (use for QA):** `7c5a2975-8f0e-45b9-8fcc-7ec9b8d81ada` (203 MCQ, released 2026‑08‑26)
- General pack (Home default): `548f06be-ccf4-426d-b82b-b424137a4438`
- Owner prod login: `f5a26c6b-3566-4d58-9e97-979fbb947564` (**admin**, not a pilot student)
- Front‑end: cramapple.com → Lovable project `d334fed9-5a97-4e76-906e-7c0ad7082212`
  (repo `david-bloom/exam-buddy-wireframe`), published via Lovable/Cloudflare.
- Confirm‑transfer RPC: `app.select_confirm_transfer_item(_exam_pack_version_id, _source_content_item_version_id)`
- Grading op for transfers: `evaluate-attempt` `operation:"grade_transfer_attempt"`

## Next steps

1. **QA** — run `COURSE_MODE_PILOT_QA_PROMPT_FABLE.md` in a fresh session. First provision a
   throwaway prod student on pack **`7c5a2975`**, then exercise scenarios A–D / invariants 1–7.
2. **Routing fix (Lovable)** — Home quick‑start should go **straight to `/session`**, not via
   `/session/setup?…&mode=quick`. Keep the setup wizard for other entry points. Then republish.
3. **Two published Statistics packs** — decide whether `548f06be` should be retired or whether
   the pilot should merge into it, and make sure the Home manifest points students at the pack
   that actually carries the pilot items. Today they diverge.
4. **Prod `GET 400` on `/rest/v1/sessions`** (`select=id,started_at,ended_at,goal…`) — likely
   a schema drift prod‑vs‑dev; investigate and reconcile.
5. **Housekeeping** — confirm prod `ALLOWED_ORIGINS` includes `https://cramapple.com`;
   after the routing fix + a clean QA pass, close out the open pilot docs PR.
