# App Rebuild — Next Session Handoff

Status: Proposed | Date: 2026-09-22 | Owner: unassigned

Written at session close so the next context window can resume without re-deriving anything.
Format follows `docs/team_charter/HANDOFF_PACKET_TEMPLATE.md`.

**Read this first, then `docs/product/APP_REBUILD_MIGRATION_PLAN.md`.** The plan is the single
source for the redesign; this packet is only the state of play around it.

---

## Task

- No Task ID allocated (open decision 7 — David's to assign per `TASK_WORKFLOW.md`).
- Working scope: rebuild the app against the CramApple Design System, wired to the existing
  backend. Then marketing reskin, Stripe, new home page — in that order.

## Prompts Included

- [x] Implementation Agent
- [ ] QA Agent
- [ ] UX / Prompt Agent

## Current Source

- **Plan:** `docs/product/APP_REBUILD_MIGRATION_PLAN.md` — the consolidated plan. §15 lists
  every document it absorbs, so the companions do not need re-reading first.
- **Uncertainty:** `docs/product/UNCERTAINTY_LOG.md` — 22 entries; 1–5 closed, four of those
  because the claim was wrong.
- **Code:** `web/` — Vite + React, the five plate screens, 19 components, self-hosted fonts.
  `web/README.md` documents the product rules the code enforces mechanically.
- **Latest commits reviewed:** `main` at `df746f8`.
- **Branch / PR:** none open. **#152 merged** (`df746f8`, the frontend), **#153 merged**
  (`4a53d0f`, the plan). The only open PR in the repo is #144, unrelated SEO work.
- **Uncommitted / unpushed state (dirty-state handoff, R4): none.** Working tree clean, no
  stashes, both feature branches fully contained in `origin/main`.

## Approval State

- **Approved / decided by David:** rebuild rather than reskin; the four-phase sequence; mode
  consolidation onto the plate as the one surface; diagnostic and exam cram sequenced after the
  homework/course path; the Open Hand and Practice definitions (plan §4.2); AI-led topic
  labelling over human validation, with a second source to be sourced by David.
- **Not approved:** everything in plan §11 still marked OPEN — 15 of 25 decisions.
- **Required before execution:** Phase 0 in plan §12. Three items block real work:
  decision 21 (Open Hand's answer-key contract), decision 1 (fixed frame vs responsive),
  decision 11 (multi-part FRQ and typed math).

## Live / Tool State

- **Checked:** Supabase `Cramapple – Production` (`pcntajvbdfqhbeewmdry`), read-only, counts
  only, no PII. GitHub PRs #152 / #153. `main` after both merges.
- **Not checked / unavailable:** `docs.lovable.dev` (egress-blocked, so the one-repo-per-project
  claim remains unverified); the Vercel preview URLs (egress-blocked, so "Vercel is not serving
  `web/`" is inference); the values behind the key *names* in `exam-buddy-wireframe`'s committed
  `.env`.
- **Playwright layout checks could not be run in this environment** — the pinned Playwright
  wants Chromium build 1243 and the runner has 1194. Unit tests ran (12/12). The layout results
  quoted in the plan are from earlier runs on unchanged `web/` sources.

## Files / Systems Affected

- **Docs:** `docs/product/APP_REBUILD_MIGRATION_PLAN.md` (rewritten), `UNCERTAINTY_LOG.md`,
  `docs/activity_log/ACTIVITY_LOG.md`, `README.md`, this packet.
- **Code:** `web/` merged to `main`. Nothing else touched.
- **Data/schema:** **nothing written.** All database access this session was read-only.
- **Integrations:** none changed.
- **Frontend/routes:** `web/` only; `exam-buddy-wireframe` untouched and still deployed.

## Open Risks / Blockers

**P1**

1. **No published item in any subject carries a topic label** (plan §5.4). 1,346 items; the
   complete topic layer is unreachable from all of them. Gates six plate surfaces. This is the
   single blocking content gap.
2. **Open Hand's answer key has no serving contract and the current one forbids it by design**
   (plan §5.2, decision 21). Must not be solved by relaxing `public.mcq_choices` or restoring
   the revoked column grants — that would undo PR #106's answer-key protection everywhere at
   once (plan risk 3).
3. **Decision 1 compounds.** Every screen built on the fixed 1440×900 frame raises the cost of
   reversing it.

**P2**

4. **Multi-part FRQ is inconsistently modelled** — 168 of 563 carry structured
   `prompt_json.parts`; 323 carry parts only as prose inside the stem. Any multi-part design
   implies a content migration or a parser.
5. **The plate layout checks are not in CI.** `minimal-ci.yml` runs Deno backend tests and the
   AP Statistics Python checker only. A green tick has never meant the plates were measured.
6. **Course Mode regression risk** — seven shipped components with no design treatment; "merge
   the modes" is easy to misread as "drop the mode's components" (plan §9.1, risk 2).

**Pending owner decisions**

- Lovable's repo model (one project, one repo, at root?) — changes the monorepo recommendation.
- Whether the committed `.env` holds only publishable keys — a different severity if not.
- Whether the default student-facing copy written for real packages stands
  (`UNCERTAINTY_LOG.md` §10).
- Decision 18 (BYOQ default or alternative) and 19 (paste-first or camera/upload-first), both of
  which contradict something already written down (plan §13.3).
- Decision 16, the evidence basis behind the student signal — upstream of 12, 13 and 18.

## Do Not Touch

- **Scope exclusions:** the reviewer/admin routes (13 + 6 dashboards) are not migrating and
  `exam-buddy-wireframe` stays deployed for them until they are rehomed. Do not cut them —
  content authoring is the actual bottleneck.
- **Deferred features:** diagnostic and exam cram (Phase 1b, after the homework/course path).
- **Hard gates:** INV-3 / no unvetted generation; CM-D20 (no freelance pedagogy at response
  time); the double-approve publication rule; trunk protection (no direct commits to `main`);
  the answer-key boundary described above.
- **There is one paying customer.** Whatever happens to the live app and to the Stripe flow,
  that person's access has to survive it.

## Next Expected Output

- **Phase 0 decisions recorded**, then implementation. In plan §12 order: settle decision 21,
  then 1 and 11, then re-score the stored taxonomy runs for primary-topic agreement.
- **Required files to update:** `APP_REBUILD_MIGRATION_PLAN.md` §11 as decisions close;
  `DECISIONS_LOG.md` once David allocates numbers; `MASTER_TODO.md` if the work is promoted to a
  tracked Task ID.
- **Required evidence:** for any layout claim, a `verify:panes` / `verify:real` run — not a
  build and not a screenshot. For any content claim, a count against Production with the filter
  stated, because three of this session's four corrections were counts over the wrong source.

---

Recommended Prompt for Implementation Agent:

"""
Read `docs/product/APP_REBUILD_MIGRATION_PLAN.md` in full before doing anything; it is the
single source for this work and it absorbs the earlier companion documents.

Do not start building screens. Phase 0 (§12) is unfinished and three of its items are
decisions David has to make, not work to be done. Your first job is to make those decisions
cheap for him:

1. Draft the Open Hand answer-key contract (§5.2, decision 21) as a concrete proposal — a
   narrow `SECURITY DEFINER` RPC modelled on `public.get_review_mcq_choices` and
   `public.get_chosen_distractor_rationale`, plus the rule that makes an item served as an
   example ineligible to be scored for that student. Do not implement it, do not relax
   `public.mcq_choices`, and do not restore the revoked column grants on `app.mcq_choices`.
2. Re-score the 15 stored taxonomy model runs in `app.content_taxonomy_labels.source_payload`
   for *primary-topic* agreement rather than set equality (§6.2). This is read-only and it
   decides how much second-source work is actually needed. Report the number.
3. Render the existing plate against a multi-part FRQ and against one of the six AP Biology
   FRQs carrying a `stimulus_image_path`, and measure with `verify:panes`. That is the
   evidence decisions 1 and 11 are waiting on. Note that the pinned Playwright needs a
   matching Chromium build; do not run `playwright install` in a sandboxed environment
   without checking `PLAYWRIGHT_BROWSERS_PATH` first.

Read-only against Production unless David says otherwise, and state the filter behind any
count you report. If you find something that contradicts the plan, say so in the reply and
add it to `UNCERTAINTY_LOG.md` rather than quietly working around it.
"""
