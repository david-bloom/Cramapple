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
- Owner decision: showing the $39.99 list price beside "Free for November" is intentional and accepted
- Required before execution: David's explicit approval before any live-page change

Live / Tool State:
- Environments checked: Production public homepage over HTTPS
- Services checked: `https://ap-prep-canvas.lovable.app/`, latest HTTP 200 at 2026-09-26 15:53:55 UTC
- Latest deployment checked:
  `psr2.a50725d9-53c2-4fce-b306-ecdfc3446f79.1791042834.tghII7hEsXfI48QgRVr36yy98_QmiaCvpleua3BBRC8`
- Latest delivered asset identifiers: `index-B04bdM1t.js`, `index-CmkzbPkJ.js`,
  `index-CLnVlhs5.css`, `index-D-MdByNs.css`, `styles-DcabbJId.css`
- Result: `Free for November` is live; two secondary purchase links were removed, but the primary paid
  CTA links to `/signup`
- Signup result: live `/signup` says "Which AP subject are you buying?" and deployed code offers
  "Continue to secure payment" through `/checkout/start`; no zero-charge November bypass was found
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
- Accepted: list price plus free banner presentation, per David
- P1: linked signup flow still presents purchase, secure payment, and `/checkout/start`
- P1: zero-charge November signup behavior has not been verified live
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
