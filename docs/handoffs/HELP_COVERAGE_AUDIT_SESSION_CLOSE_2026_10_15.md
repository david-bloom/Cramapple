# More help Coverage Audit and Chemistry 2.5 — Session Close (2026-10-15)

STATUS: CURRENT
DATE: 2026-10-15
OWNER: David Bloom (Product Owner)
SESSION: https://claude.ai/code/session_01Pv4WYomQRcghMyf4WttwmA

This closes the session that audited which Units 1-3 questions lack More help content, filled the one real gap (Chemistry Topic 2.5), rotated the oversized logs, and cleared PRs #459 and #460. Everything below is merged to `main` unless it says otherwise.

---

## 1. What the audit measured

**Definition used:** a published question "has More help content" when its topic has at least one published `app.unit_reference_entries` row (own subject, or an aliased subject such as BC from AB). That is the gate the `more-help` function enforces (`reference_unavailable` when nothing usable). Questions counted: published item, latest published version, primary unsuperseded non-held cell. Production and Development were read-only; "missing" and "in Development but not Production" were computed per topic.

**Production, published questions in Units 1-3 (U1 / U2 / U3):**

| Subject | U1 | U2 | U3 | Missing at audit | In Development, not Production |
|---|---:|---:|---:|---|---|
| Biology | 104 | 48 | 37 | 0 | 0 |
| Calculus AB | 175 | 107 | 85 | 0 | 0 |
| Calculus BC | 148 | 105 | 89 | 0 | 0 |
| Chemistry | 59 | 51 | 87 | **8** (all U2, Topic 2.5) | 0 |
| Physics 1 | 30 | 66 | 69 | 0 | 0 |
| Physics C: Mechanics | 22 | 27 | 44 | 0 | 0 |
| Precalculus | 108 | 97 | 98 | 0 | 0 |
| Statistics | 330 | 78 | 76 | 0 | 0 |
| Physics 2, Physics C: E&M | — | — | — | n/a: no question has a primary topic cell (packs sit under registry units 9-11 and 8-10) | 0 |

- **Development holds nothing Production lacks.** Published reference-entry counts match per subject and unit. Only counts were compared (entry ids differ between databases). Development has 380 published questions against Production's 2,926.
- **Published questions with no usable primary topic cell** (no help possible, unit unknown): Calc BC 84, Chemistry 81, Physics 1 45, Physics C: Mechanics 41, Physics C: E&M 42, Physics 2 35, Precalculus 9, Biology 3, Calc AB 1.
- **The audit did not test the live app.** It is a database inventory.

## 2. What shipped

| Item | Where | Result |
|---|---|---|
| Chemistry 2.5 reference entry "Principles for constructing a Lewis diagram" | Development `71bdd801-bd6d-477f-bb46-330a76a2b965`, Production `fc3b546c-b200-4151-bab5-57331728bdf6` | Production entries 1,083 -> 1,084; Chemistry 227 -> 228; Unit 2 21 -> 22. All 8 published 2.5 questions now resolve to it (database check only). |
| Batch record and approval record | PR #462: `scripts/content-seed/ap-chemistry-reference-u2-topic-2-5-2026-10-15/`, `docs/activity_log/APPROVAL-0177_CHEMISTRY_TOPIC_2_5_REFERENCE_ENTRY_2026_10_15.md` | Merged. The approval record is a **standalone file**, deliberately not pasted into `APPROVALS_LOG.md` (David's direction). |
| `TASK-0076` Chemistry 2.5 tagging investigation | `docs/tasks/` (PR #462) | Created, Not Started. |
| Log rotation | PR #462, commit 12ba249 | Entries before 2026-10-01 moved to `docs/activity_log/archive/` (see section 4). |
| PR #459 (reference pack close) and PR #460 (More help gap catalog) | merged at `c7572f9` and `906f416` | Each had a conflict in `ACTIVITY_LOG.md` caused by the rotation; resolved by merge commit, not rebase. #460's catalog now carries a note that 2.5 is covered. |

**How the 2.5 entry was made.** The CED gives Topic 2.5 one essential-knowledge statement (2.5.A.1, "established set of principles") and does not print the principles, so the 2026-10-10 extraction produced no 2.5 candidate. Entries were hand-authored under David's approval, then checked with the standard slate (`google/gemini-3.5-flash`, `openai/gpt-6-sol`; six controls reused from the Unit 2 batch, 6/6 rejected). Round 1 (three candidates) was all rejected: expanded octet was dropped because the 2.7.A.3 Exclusion Statement says that with more than four electron pairs students are "only responsible for the shape"; the ion electron count was merged into the steps. Round 2 ("Principles", four items): Gemini accepted, GPT rejected twice (the CED does not require the principles as stated; "remaining electrons are lone pairs" and "octet where possible" overstate for odd-electron species, 2.6.A.3). Two rounds exhausted, escalated, and David ruled **"Override and publish"**. The row's caution says the CED does not print the principles and cites 2.6.A.3. No worked example is included, so the entry cannot disclose an answer. Gateway spend was under a dollar (exact figures not pulled). Round-1 verdicts (about 32 KB) are not committed; round 2 is, in condensed form (flagged inside the file).

## 3. Open items

| # | Item | Owner | Path |
|---|---|---|---|
| 1 | **Check a Chemistry 2.5 question signed in** at app.cramapple.com and confirm More help returns an explanation. Verified in the database only. | David | One look; record the result. |
| 2 | **Four "2.5" questions may belong elsewhere.** `apchem-mcq-026`, `apchem-mcq-sv-026-v1/v2/v3` ask about expanded octets, which the 2.7.A.3 Exclusion Statement says is not assessed beyond shape. The new entry deliberately does not cover them. | David (ruling), Claude (investigation) | `TASK-0076`: read-only findings plus a proposed re-tag table; any re-tag is a Hard-Gate Production metadata change. |
| 3 | **Image-bearing questions are refused.** `main` (`supabase/functions/more-help/contract.ts`) throws `visual_question_unavailable` (422) when `item.hasStimulusImage === true` (catalog item H06). Seven published Units 1-3 questions are affected (Biology U3 1, Calc AB U1 4, Chemistry U3 2). Reference-pane figures (Lane A) are a different thing and are published. Not tested live. | David (decide), engineering | Catalog H06: quantify, then choose the smallest grounded visual-context design. |
| 4 | **Questions with no primary topic cell** (section 1) get no help. Catalog item H12 says the same of 166 versions in the three live subjects. | Taxonomy owner | Separate linkage work; not part of `TASK-0076`. |
| 5 | **Approvals log is still large** (about 274 KB live) because 109 of 134 approvals were filed in October. A one-week window would be about 120 KB. | David | Say so and re-run the rotation. |
| 6 | **Calculus Units 4-8 and BC later units have no reference entries** (catalog H12). Outside the Units 1-3 audit. | Content owner | Reference-pack production under `MEMORY_HOOKS_AND_UNIT_REFERENCE_PRODUCTION_PROTOCOL.md`. |

## 4. Log rotation record

`ACTIVITY_LOG.md`, `APPROVALS_LOG.md` and `DECISIONS_LOG.md` now hold entries dated 2026-10-01 onward. Older entries and their index lines are in `docs/activity_log/archive/ACTIVITY_LOG-2026-09-22_to_2026-09-30.md` (127 KB), `APPROVALS_LOG-0041_to_0065.md` (38 KB) and `DECISIONS_LOG-0066_to_0093.md` (99 KB). Each live log's "Older entries" line links the new archive first, then the previous one. Every entry and index line was checked to appear exactly once across live plus archive; no text was edited. Live sizes: activity 235 KB (was 361), approvals 274 KB (312), decisions 81 KB (179). The activity log's index holds a full summary for every entry, which is why it stays large; the stated rule ("keep the index to the last ~10 entries") is not what the logs do. The splitter is `scripts/maintenance/rotate_activity_logs.py` (edit `CUT` and `ROT`, run from the repo root; it asserts nothing is lost).

## 5. Numbering

Next free: `APPROVAL-0178` (`0177` is the standalone Chemistry 2.5 record), `DECISION-0126`, `TASK-0077` (`TASK-0076` taken). Check `main` and open PRs before taking a number.

## 6. Facts that cost time to learn

1. **Repo docs were stale about rollout state, twice.** The Oct 14 close and rollout protocol said More help was undeployed in Production; it is live (`more-help` v1, JWT-verified; four migrations applied). Verify live state (Supabase, `main` source) before asserting it from a doc.
2. **Chemistry is already allowed** in `reserve_question_help_delivery` and `contract.ts` (`ap-calculus-ab`, `ap-calculus-bc`, `ap-chemistry`). Nothing besides content gated the 2.5 questions.
3. **More help needs only a usable reference entry on the question's topic**, not a complete pack. Adding an entry whose `topic_codes` contains the topic is enough; no function deploy or rollout row.
4. **The permission classifier blocked several shell actions** during the session: `load.py --po-accept` (twice), a compound `git commit`/`git push`, and a forced `git checkout -B`. David approved a direct, equivalent SQL insert and the GitHub connector for small pushes; plain `git push` of a normal commit later worked. The connector cannot carry files this large (the logs), so use shell git for those and say so.
5. **Editing someone else's PR branch** (#459, #460) was done only on David's explicit request, by merge commit, never rebase or force-push.
6. **A claim in this session was corrected twice.** Image handling: first stated as "refused by design", then withdrawn on David's statement that reference images are accepted, then restored after reading `main`. The accurate split is in open item 3.
