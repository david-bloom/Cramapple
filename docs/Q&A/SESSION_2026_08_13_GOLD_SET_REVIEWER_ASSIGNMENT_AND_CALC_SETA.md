# Session 2026-08-12/13 — gold-set reviewer assignment, Calculus Set A attempt

**Scope:** follow-on session to `REVIEWER_QA_SWEEP_2026_08_12.md`. Started from "which
active reviewers can take new gold-set assignments," moved into assigning specific
subjects, and ended trying (and not yet succeeding) to generate AP Calculus Set A
gold-set content. Documented here per owner request so the state is legible next
session rather than reconstructed from chat history.

## 1. Reviewer capacity snapshot (as of 2026-08-12 ~20:15 UTC)

Live query against `app.gold_set_verification_assignments` / `app.content_review_decisions`:

| Reviewer | Gold-set pending | Gold-set submitted | Last gold-set activity | General review activity today? |
|---|---:|---:|---|---|
| Jill Schmidlkofer | 0 | 70 | 08-11 | No (last general decision 08-11) |
| Abdul Hanan | 28 | 65 | 08-12 18:45 | No (last general decision 08-09) |
| Muhammad Saood | 34 | 90 | 08-12 10:57 | No (last general decision 08-10) |
| Chisom Anuba | 43 | 2 | 08-12 20:09 | No (last general decision 08-10) |
| Ghazanfar Ali | 54 | 0 | never submitted | — |
| Shazia Fazal | not on gold-set roster | — | — | Yes, 67 decisions, last 20:08 |
| Sarah Sohail | not on gold-set roster | — | — | Yes, 48 decisions, last 19:49 |
| Ahmed Ali | not on gold-set roster | — | — | Yes, 119 decisions, last 13:50 |

**Recommended for new work:** Jill (cleared queue, proven throughput) and Shazia/Sarah
(highly active generally, zero current gold-set load — fresh capacity). **Not
recommended:** Chisom (43 pending, barely started) and Ghazanfar (54 pending, zero
submitted, no throughput signal yet).

## 2. PR #86 merged

`2026-08-12 reviewer QA sweep + gold-set corpus status chart` — the short-FRQ
1-point-per-part Biology repair (29 items), the AP Chemistry `canonical_answer_1`
backfill (37 items), and the reviewer sweep + chart work. Merged to `main` at
`d5897d2`. Branch `claude/cramapple-reviewer-sweep-chart-kwke07` was deleted on merge
(GitHub auto-delete) and had to be restarted from `main` for this session's follow-on
commits — see `docs/research/CONTENT_AUTHORING_AND_QA_PROTOCOL.md`-adjacent convention:
a merged PR's branch is not reused, new commits get a fresh branch-from-main + new PR.

## 3. Assignment requests — what happened

**"Give Shazia and Jill the same 5 multipoint questions."** Confirmed by owner as AP
Statistics (the only subject with any Set A content). **Not executed** — deprioritized
when the Calculus Set A generation request came in, and a wrinkle surfaced that's worth
resolving with the owner before acting on it: **AP Statistics Set A is only 4 items
total** (30 individual `gold_set_answers` rows: `APSTATS-SFRQ-007` through `-010`), and
all 30 are already double-assigned to Jill Schmidlkofer + Muhammad Saood, fully
submitted (0 pending). So "5 questions" can't mean 5 items (only 4 exist) — it likely
means 5 of the 30 individual answer rows — and giving Jill a fresh assignment on them
would be her third pass over content she's already reviewed, not new ground. **Open
question for next session:** does the owner still want this (a supplementary audit
pass), or was the request made without knowing Jill already covers 100% of this pool?

**"Give Saood and Abdul the same 5 multipoint calculus questions for each calculus
subject."** Checked and reported: zero unassigned Set A calculus content existed at
all (Calculus AB/BC had never had Set A gold-set answers generated — only Set B).
Separately, **Set B Calculus is already fully assigned** — Abdul Hanan has cleared
100% of both AB (22/22 submitted) and BC (27/27 submitted); Chisom Anuba holds the
pending load there instead (20 pending AB, 23 pending BC). Owner chose to generate
Set A Calculus content rather than fall back to Set B.

## 4. Calculus Set A generation — Phase 0.5 done, blocked before Phase 1

Per `docs/research/GOLD_SET_GENERATION_PROTOCOL.md`, Set A generation requires (0.5)
AI-drafted element decomposition confirmed by an independent reader, then (1-4) real
multi-model writer/verification generation via the Vercel AI Gateway.

**Done:** drafted a 3-element decomposition for 30 multi-point (3pt) criteria across
10 items — 5 AP Calculus AB (`apcalcab-frq-001/002/003/008/011`) and 5 BC
(`apcalcbc-frq-002/003/004/005/007`), the first 5-per-subject eligible items by
`content_key`. 90 rows inserted into `app.gold_set_elements` on production,
**`confirmed_by`/`confirmed_at` left NULL (draft, unconfirmed)**.

**Certification approach:** no human reader was available in-session. Owner initially
asked to self-certify; redirected to an **independent-model blind check** instead —
same family-independence spirit as the writer/verifier rules (R1/R2) already used for
answer generation, applied here to the decomposition-confirmation step. Wrote
`scripts/vercel-gateway-check/verify_calc_setA_decomposition.mjs`: embeds all 30
criteria + drafted elements, sends each to `google/gemini-2.5-flash` blind (no
attribution, no hint of authorship), asks for a per-element valid/invalid verdict plus
a whole-criterion coverage judgment. Pure read/report, no DB writes — output is a
console summary and a JSON file meant to be reviewed by a human before any
`confirmed_by` write happens. Committed and pushed in **PR #87**, `Blind independent-model review script for
Calculus Set A decomposition` (draft, CI green, not yet merged).

**Blocked:** the script has not successfully run anywhere yet.
- From the Claude Code remote session: `ai-gateway.vercel.sh` is blocked at the
  network-policy level. Confirmed via `curl http://127.0.0.1:33995/__agentproxy/status`
  — `recentRelayFailures` showed `connect_rejected: gateway answered 403 to CONNECT
  (policy denial or upstream failure)`. This is an organization egress policy denial,
  not a credential problem, per the proxy's own diagnostic guidance — not something to
  route around from this environment.
- From the owner's own machine (no such network restriction): the script — and the
  repo's pre-existing `models.mjs` reachability probe — both fail every model with
  `GatewayAuthenticationError: Unauthenticated request to AI Gateway`. Extensive
  back-and-forth ruled out the obvious mechanical causes: confirmed `.env.local`
  existed in the right directory, confirmed no literal `<placeholder>` text remained
  (`grep -c '<'` → 0), confirmed a clean clipboard-to-file transfer of the key bypassing
  terminal paste/quoting issues entirely (`pbpaste > /tmp/key.txt`, byte count checked).
  Still `Unauthenticated` after all of that. **Root cause unresolved** — most likely
  candidates, per Vercel's own error messaging, are: the key isn't actually generated
  from AI Gateway → API Keys (as opposed to a general account/deployment token), AI
  Gateway isn't enabled/billed on whatever team the key belongs to, or the key belongs
  to the wrong team scope. None of these are diagnosable from a terminal — they need
  checking directly in the Vercel dashboard.

## 5. State left for next session

- **`app.gold_set_elements`**: 90 draft (unconfirmed) rows for the 10 Calculus items
  above, sitting idle until the blind-review script actually runs somewhere with
  working gateway access.
- **PR #87**: open, draft, CI green, contains only the review script — no content
  changes, no risk sitting open.
- **Shazia/Jill AP Statistics Set A assignment**: still not executed; needs a decision
  per §3 above (audit pass on already-reviewed content, or drop it).
- **Gateway credential**: needs to be sorted on the owner's end (Vercel dashboard
  checks per §4) before Calculus Set A — or any future gateway-dependent work — can
  proceed. Once a working key exists, running
  `node --env-file=.env.local verify_calc_setA_decomposition.mjs` from
  `scripts/vercel-gateway-check/` (on the `claude/cramapple-reviewer-sweep-chart-kwke07`
  branch, or wherever PR #87 lands) is the next concrete step; its JSON/console output
  feeds directly into confirming or correcting the 90 drafted elements.
- **Carried forward, untouched this session**: everything already logged as open in
  `REVIEWER_QA_SWEEP_2026_08_12.md`'s follow-ups (08-10 P0-B items, 08-10 disapprovals,
  AP Physics C: Mechanics gold-set review backlog, topic-selection-compliance gap).
