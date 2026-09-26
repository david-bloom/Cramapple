# TASK-0040 — Independent QA Handoff

Task:
- TASK-0040 — Marketing Home Page — October 2, 2026 Free-Launch Readiness

Prompts Included:
- [ ] Implementation Agent
- [x] QA Agent
- [ ] UX / Prompt Agent

Current Source:
- Task doc: `docs/tasks/TASK-0040-LAUNCH-MARKETING-HOME-PAGE.md`
- Related docs: `docs/product/LAUNCH_RUNBOOK_2026_10_02.md` §§1, 5, 6 and
  `docs/product/LAUNCH_PLAN_MARKETING_HOME_PAGE_2026_09_26.md`
- Relevant issue/comment: none
- Latest baseline commit reviewed: `29e8dacb`
- Branch / PR: `codex/task-0040-home-page-audit`; no PR yet
- Uncommitted / unpushed state: none expected at QA handoff; verify with `git status`

Approval State:
- Approved: David instructed Codex to execute TASK-0040 on 2026-09-26; read-only audit and evidence
  updates only. David later approved continuing that audit while Lovable added the free-access banner;
  this was not approval for Codex to edit Production or accept residual risk.
- Not approved: any Lovable/Production change, deployment, brand or public-claim finalization, or risk
  acceptance
- Required before execution: David's explicit approval before any live-page change

Live / Tool State:
- Environments checked: Production public homepage over HTTPS
- Services checked: `https://ap-prep-canvas.lovable.app/`, initial HTTP 200 at 2026-09-26 15:38:29 UTC;
  follow-up deployment HTTP 200 at 15:47:35 UTC
- Latest deployment checked:
  `psr2.ca3ff895-7537-417a-8ab9-114518dc7d57.1791042456.BD1MZZqiUn51mL_W21qGywpl1jSpfenNA8_Q8_GahN8`
- Latest delivered asset identifiers: `index-D8VnhNPE.js`, `index-DHyVGulG.js`,
  `index-B-RszSsD.css`, `index-D-MdByNs.css`
- Banner result: `Free for November` is live, but the paid CTA and pricing copy remain
- Not checked / unavailable: rendered screenshots, interactive CTA/BYOQ behavior, actual photo retention,
  canonical-answer boundary, and rendered contrast. The supported browser could not start because the
  workspace path contains a symlink; cached Lovable state was not substituted.

Files / Systems Affected:
- Docs: TASK-0040 record and this handoff only
- Code: none
- Data/schema: none
- Integrations: none changed
- Frontend/routes: Production homepage inspected; no route changed
- Other: no Production writes

Open Risks / Blockers:
- P1: `Free for November` is contradicted by the live header CTA `Get it · $39.99`
- P1: the same price row still says `$39.99 / one subject / no subscription`
- P1: live price section still says `Get AP Statistics`, `Ask a parent to buy it`, and `Bundles`
- P1: the free-launch promise is not consistent or unambiguous across the page
- P1: BYOQ retention/canonical-answer behavior remains functionally unverified
- P2: social metadata says `Maximum AP exam score in minimal time` without a cited evidence source
- Pending owner decisions: approve/perform the free-launch CTA and pricing-copy change; decide residual
  BYOQ privacy/rights/academic-integrity risk

Do Not Touch:
- Scope exclusions: Stripe/backend checkout and pricing-policy decisions
- Deferred features: campaign landing pages and post-launch paid flow
- Hard gates: all live Lovable changes, public claims, brand finalization, risk acceptance, and launch

Next Expected Output:
- Independent QA verdict on the recorded audit evidence: Pass / Fail, blockers, residual risks, and
  exact environment/version checked
- Required files to update: TASK-0040 `QA Result`; runbook/readiness index only after Main Conductor
  reconciliation
- Required evidence: fresh live page read; rendered screenshot/interaction evidence if browser access is
  available; exact deployment/version

Recommended Prompt for QA Agent:
"""
Independently review TASK-0040 in a fresh context. Re-read the live Production homepage rather than
trusting this handoff. Verify whether it clearly promises free launch access, whether every primary CTA
avoids payment implications, whether only AP Biology and AP Statistics are marked live, and whether
BYOQ exposes a canonical answer or makes inaccurate retention/privacy claims. Check rendered WCAG AA
contrast if browser access is available. Confirm the exact deployment/version reviewed. Return a
proposed Pass or Fail with blockers and residual risks. Do not change Production, accept risk, close the
task, or declare launch readiness.
"""
