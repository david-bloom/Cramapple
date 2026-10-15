# Reference Pack Production — Session Close and Open Items (2026-10-15)

STATUS: CURRENT
DATE: 2026-10-15
OWNER: David Bloom (Product Owner)
SESSION BRANCH: `claude/reference-pack-production-68juff` (both repos; everything from this session is merged to `main`)

This is the close note for the session that loaded the AP Statistics skew figures, fixed their order, and built, gated, published and loaded batch 4 (log axis and diprotic titration). It lists what is true now, every open item with its owner and blocker, and the path to finish each. Read `docs/handoffs/LANE_A_NEXT_LANE_BATCH4_2026_10_15.md` for the batch-4 evidence and `docs/product/FIGURE_PRODUCTION_PROTOCOL.md` for the method.

---

## 1. State at close

**Production (`pcntajvbdfqhbeewmdry`):** 88 published figures, 96 uses.
**Development (`wmgjsdkphcyhngaffbqf`):** 85 published figures, 93 uses. **Development is behind Production by the three batch-4 figures** (see item 6).

**App (`ap-prep-blueprint`):** `main` at `2fbb345` (renderer port of the log axis, text labels and diprotic branch), published through Lovable project `56cae479-f7c9-4988-b536-56538c38ee4e` (`APPROVAL-0175`). The Lovable source at that commit contains the new code; the deployed bundle could not be inspected from the agent session (the published host returns 403 through the session proxy). **David confirmed the live images himself** (`APPROVAL-0176`), which is the only live evidence.

**Merged this session:** Cramapple #456 (`DECISION-0124`, skew figure ids) and #458 (batch 4 records, specs, renderer, gate tooling), `ap-prep-blueprint` #27.

**Approvals and decisions recorded:** `APPROVAL-0170` (skew figures), `0171` (caption renumber, superseded), `0172` (id rename that actually fixed the order), `0175` (app publication), `0176` (batch-4 load). `DECISION-0124` (cross-subject duplicates allowed).

**Numbering reserved or taken, so nobody collides again:**

| Next free | Taken or reserved |
|---|---|
| `APPROVAL-0178` | `0173` and `0174` belong to #457 (question-image approvals); `0175`, `0176` are on `main`; `0177` is taken by the Chemistry 2.5 reference entry record (#462, standalone file `docs/activity_log/APPROVAL-0177_CHEMISTRY_TOPIC_2_5_REFERENCE_ENTRY_2026_10_15.md`, not in `APPROVALS_LOG.md`) |
| `DECISION-0126` | `0125` belongs to #449 (ASCII-cleanup rulings, renumbered from 0123); `0123`, `0124` are on `main` |

Check `APPROVALS_LOG.md` and `DECISIONS_LOG.md` on `main` and the open PRs before taking a number; two clashes already happened this session.

---

## 2. Open items

Ordered by what unblocks the most. "Owner" is who has to act; Claude can do the build work in every row, but the Production writes and publications need David's explicit approval and a log entry first (Hard Gate).

### Item 1. Subject-expert review of illustrative values (all batches) — standing risk

- **What:** no human subject expert has reviewed the illustrative values in any figure batch (Chemistry, Statistics, Physics, Precalculus, Calculus). Every approval repeats this as a standing risk. The gates catch internal contradictions and visible falsehoods; they do not certify that a value is pedagogically right.
- **Owner:** David (choose reviewers).
- **Path:**
  1. Decide the reviewer per subject and the scope (all 88 published, or the 30 or so highest-traffic first).
  2. Claude produces one review packet per subject from existing material: the eye sheets (`scripts/lane-a-pilot/out/eye_*.html`), each figure's title, caption, alt, note and `values_note`, and the entry text it illustrates. No new tooling is needed.
  3. Reviewers mark each figure accept, fix or retire. Record the outcome as a `DECISION-0126` and fix or retire through a normal Production approval (retire is one `update … set status = 'retired'`).
- **Done when:** every published figure has a recorded expert outcome, and the "standing risk" line can be dropped from new approvals.

### Item 2. Remaining drawable reference rows — four new chart families

Source of truth: `docs/product/LANE_A_GAP_CLASSIFICATION_2026_10_11.md` rows 68–71 and §8. Each needs a new renderer family built in the reference renderer, ported to the app, and gated before any load. Pattern to copy: batch 4 (`APPROVAL-0175` then `0176`).

| Row | Family needed | Teaching point the figure must keep |
|---|---|---|
| Statistics 2.8 ×2 (valid discrete probability distribution; cumulative probability distribution) | discrete probability chart: spikes plus the step function beside it | spikes sum to 1; the step function accumulates them |
| Statistics 2.12 ×4 (sampling distribution, randomization distribution, CLT, simulating a sampling distribution) | panel set on `density_curve` | the CLT entry needs the *narrowing with n* comparison, so it is a panel set, not one curve |
| Chemistry 5.3 (linear plot that identifies reaction order, 3 items) | three linearised panels: [A], ln[A], 1/[A] against t | *which one is straight*; three separate figures would destroy the point (same argument as `kinematic_panels`) |
| Chemistry 3.11 (spectral region and associated transition, 3 items) | labelled spectrum band | a band of the electromagnetic spectrum with regions marked, not a stick spectrum |

- **Owner:** Claude builds; David approves each load.
- **Path per family:** (1) add the builder to `scripts/lane-a-pilot/render.py`; (2) add `verify.py` property tests that read the numbers, not just the geometry; (3) add specs and fixtures to `specs.json` and `prod_entries.json`; (4) port byte-for-byte to `ap-prep-blueprint/src/lib/figures/{types,maths,render,catalogue}.ts`, regenerate the catalogue, run `export_for_parity.py` and the Bun parity script; (5) gates 4a, 4b and 4c; (6) merge and publish the app change first; (7) approval entry, `build_load_sql.py`, baseline probes, load, digest, planted-draft check; (8) David looks signed in.
- **Order suggested:** Chemistry 5.3 and Statistics 2.8 first (self-contained), then Chemistry 3.11, then Statistics 2.12 (the panel set is the most design work).

### Item 3. More help independent red-team QA

- **What:** More help (Calculus AB/BC and Chemistry; Statistics deliberately has none) is live. `APPROVAL-0169` records what is *not* closed: independent red-team QA, the real-generation outcome for multiple-choice questions, partial-work and graded states, and a signed-in smoke test by the Product Owner. Record: `docs/handoffs/MORE_HELP_SESSION_CLOSE_2026_10_14.md`.
- **Owner:** an independent session or person (not the one that built it); David for the signed-in smoke.
- **Path:** run the red-team against the live function (prompt injection, answer leakage on graded items, cross-subject leakage, rate-limit and daily-allowance behaviour from `APPROVAL-0168`); record findings; fix what is broken; David requests More help on a Calculus and a Chemistry question signed in and confirms an explanation comes back.
- **Done when:** the four "not closed" lines in `APPROVAL-0169` each have a recorded result.

### Item 4. Open PRs that are not this session's

| PR | State | What blocks it | Owner |
|---|---|---|---|
| #449 `TASK-0075` rulings (`DECISION-0125`) | open, not draft; main merged in and renumbered this session | its branch carries the commit from #447 (the inventory), so **merge #447 first**; its checks were still running at close; the branch has since had a further push by another session | the `TASK-0075` session |
| #457 question-image audit and two repairs (`APPROVAL-0173`, `0174`) | open draft, clean against `main` | the owner's own list: two repairs built but not uploaded or attached, fresh independent QA, phone widths not checked, and a subject-switch defect (the new subject heading can keep the previous subject's worked question and answer until the view remounts) with reproduction in `docs/qa/CALC_CHEM_U13_IMAGE_CERTIFICATION_2026_10_15.md` | the question-visuals session and an app maintainer for the defect |

Do not push to either branch without the owner or David asking; this session merged main into #449 only on David's explicit instruction.

### Item 5. Live-bundle verification from the agent session

- **What:** the agent session cannot reach `ap-prep-blueprint.lovable.app`, the Lovable preview host or `app.cramapple.com` (403 from the session proxy). So every "the live app draws it correctly" statement rests on David looking. The connector has no deployment-status call either.
- **Owner:** David (network policy) or accept the human check as the standard.
- **Path:** either allow those hosts in the environment's network policy (read `environment.network` in the session documentation), after which a check is `curl` the page, find the asset bundle, grep for the renderer keys (`y_scale`, `pkas`, `diproticPh`); or write into `FIGURE_PRODUCTION_PROTOCOL.md` §7 that a signed-in look by the Product Owner is the live check and stop carrying "not verified" lines.

### Item 6. Development is behind Production

- **What:** the three batch-4 figures exist only in Production. Development has 85 figures and 93 uses against Production's 88 and 96, so Development no longer mirrors Production for figure work, and a digest comparison against Development is impossible for these three.
- **Owner:** Claude, with David's approval for a Development write (low risk, but log it).
- **Path:** run `scripts/lane-a-pilot/out/load_next4.sql` against Development (`wmgjsdkphcyhngaffbqf`; the SQL is natural-key based and portable), then compare counts (expect 88 and 96) and the per-figure digest of `alt`, `subtitle`, `params`, `labels` against Production. Record in `APPROVALS_LOG.md`.

### Item 7. Gate tooling and protocol follow-through

- **What:** the gate rule is unchanged (any accepted control voids the batch; swap the reader, never re-run to fish for a pass). Findings from this session that are not yet in the protocol:
  - `google/gemini-3.5-flash` accepted CONTROL-P3 (pKa values on the wrong half-equivalence points) in two full runs: a repeatable blind spot for label-to-curve position checks. Batch 4's slate was `openai/gpt-6.1-sol` plus `deepseek/deepseek-v4-pro`.
  - `deepseek/deepseek-v4-pro` returned empty output at `--max-tokens 4000` (reasoning used the budget) and needed `16000`. An empty reply is an error, not a vote.
  - The default `MODELS` in `scripts/lane-a-pilot/ced_check.py` still lists gemini-3.5-flash; the slate is ratified per batch.
- **Owner:** Claude (docs change), David to ratify the default slate.
- **Path:** add these three findings to `FIGURE_PRODUCTION_PROTOCOL.md` §4c next to the `gemini-3.8-flash` finding; make `ced_check.py` fail loudly (not silently count an error) when a reader returns empty output, and print the token cap used; decide whether the default slate becomes gpt-6.1-sol plus deepseek-v4-pro and record it.

### Item 8. Session-environment notes for the next session (no action, but save time)

- The stop hook (`~/.claude/stop-hook-git-check.sh`) repeatedly reported "unpushed commits" that were false alarms: the `ap-prep-blueprint` clone only tracked `main`, and after a merge the Cramapple branch is reset to `main` with no remote branch. Verify with `git ls-remote origin refs/heads/<branch>` against `git rev-parse HEAD` before believing it. The `ap-prep-blueprint` clone's fetch refspec now includes this branch.
- After a PR merges, restart the designated branch from `origin/main` (`git checkout -B <branch> origin/main`) and open a new draft PR; never stack commits on merged history. A force-push is denied by the auto-mode classifier.
- Editing another session's PR branch was blocked by the auto-mode classifier until David explicitly authorised it in chat. Ask first.
- `execute_sql` times out at about 60 seconds. A one-statement `DO` block with a temp table timed out twice; plain statements in sequence worked. Wrap a rollback test in a `DO` block that raises an exception carrying the result.
- Production writes need an `APPROVALS_LOG.md` entry before they run, and the result recorded after.

---

## 3. Facts that cost time to learn (carry forward)

1. **Figure order in the app is alphabetical by `figure_id`.** `get_topic_point_guides(_subject_key, _unit_number, _topic_code)` serves `order by f.figure_id`. To change the display order, rename the ids (copy as draft, copy the uses, publish new and delete old atomically, because `figure_uses` has no update cascade); changing a caption or subtitle does nothing. That is the whole story of `APPROVAL-0171` versus `0172`.
2. **An entry serves on every topic in its `topic_codes`.** The Statistics 1.6 skew entry also appears in the 1.8 guide, so 1.8 returns seven figures.
3. **Cross-subject duplicate entries are allowed** (`DECISION-0124`): no alias, no normalisation; a shared figure's `covers` must list every wording.
4. **The three reference-pack gates are 4a (`verify.py`), 4b (eye pass at 272, 460, 680 and 980 px) and 4c (two non-Anthropic readers plus five planted controls).** A control must be a visible mistake. Port parity is `export_for_parity.py` plus the Bun script, and every renderer change goes to the app byte-for-byte.
5. **Log axis design:** values are mapped through log10 in the family builder so the shared renderer stays linear; decade ticks are `[position, label]` pairs. The diprotic curve is solved by bisection on pH from the charge balance.
6. **Illustrative values are disclosed as illustrative** in every figure's note and alt. That is intended and is not a defect.

---

## 4. Definition of done for the lane

The lane is finished when: items 2 (all four families loaded and confirmed by David), 1 (expert review recorded), 3 (More help QA recorded) and 6 (Development parity) are closed, #449 and #457 are resolved by their owners, and the protocol carries the item-7 findings. Until then, `docs/product/LANE_A_GAP_CLASSIFICATION_2026_10_11.md` is the live list of what is drawable and not yet drawn.
