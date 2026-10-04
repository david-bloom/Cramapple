# Units 1-3 Content Pipeline: Runbook, Lessons and Session Close (2026-10-03 to 2026-10-04)

Status: session close. Written at the end of the run that took every AP subject through the "Units 1-3" content pipeline.
Approvals for this run: `APPROVAL-0072` to `APPROVAL-0115` and `APPROVAL-0118` in `docs/activity_log/APPROVALS_LOG.md` (0116 and 0117 belong to other sessions). Scripts and raw checker output live in `scripts/content-seed/pipeline-v2-<subject>-u13-*/`, `skills-u13-2026-10-03/` and `release-held-four-2026-10-04/`.

## 1. Where every subject stands (Production `pcntajvbdfqhbeewmdry`)

"Units 1-3" means the first three units of each course in the registry. Three courses number differently, so the registry units are:

| Subject | Units treated as "1-3" | Pipeline status |
|---|---|---|
| Statistics, Biology, Calculus AB, Physics 1, Precalculus, Chemistry | 1, 2, 3 | Done (earlier in the run) |
| Calculus BC | 1, 2, 3 | Done: AB copies got skills from their AB twin; 16 native MCQs got topics and skills |
| Physics 2 | **9, 10, 11** (Thermodynamics; Electric Force, Field, Potential; Electric Circuits). The 2025 CED dropped Fluids and numbers units 9-15. | Done |
| Physics C: Mechanics | 1, 2, 3 (Kinematics; Force and Translational Dynamics; Work, Energy, Power) | Done |
| Physics C: E&M | **8, 9, 10** (Electric Charges, Fields, Gauss's Law; Electric Potential; Conductors and Capacitors). Units are numbered 8-13. | Done |

Published MCQ counts at the end of the run: Physics 2 95, Mechanics 88, E&M 109 (see the activity log for the other subjects).

Not done anywhere: Units 4 and above, all FRQs (except where another session did them), CED-vocabulary check (`DECISION-0095`) outside Biology (`TASK-0059`, parked), the variants of seeds whose votes tied.

## 2. The pipeline, step by step (what we actually ran)

1. **Seed audit (read-only).** Export the published MCQs in scope. Two blind solvers (gemini-3.8-flash, deepseek-v4-pro), a rationale audit, a CED scope check against the subject's fact pack, and a six-vote topic/unit probe (gemini-3.8-flash, deepseek-v4-pro, gpt-6.1-sol, 2 samples each). Every computational key is recomputed in python (sympy/mpmath; numpy and scipy are broken on this machine).
2. **Classify** each seed OK / REPAIR / RETIRE. Repairs keep the key and letter position and change only the defect. Retire only what is outside the CED or unfixable (`DECISION-0095`).
3. **Strip the inline A-D list** from every stem that still has one (a strip-only new version).
4. **Apply the seed fixes** as new versions with the validated label carried forward hash-fresh, plus validated primary topic cells.
5. **Author variants**, 3 per seed, v1 easy / v2 medium / v3 hard, same concept, topic and unit as the seed, new context and numbers. Distractors come from named student error patterns. Every number is recomputed in a `verify_cN.py`.
6. **Assemble** (similarity under 0.7, randomize answer letters once), **check** with the two blind solvers + rationale audit + CED scope check, **patch** fixable defects, **drop** the rest.
7. **Load** drafts in atomic chunks (md5 against a manifest), then **publish** with validated hash-fresh labels inherited from the seed and validated primary topic cells.
8. **Skills.** Build the subject's skill grid, vote on the seeds with four voters, let variants inherit the seed's skill.
9. **Log** an approval per change set, commit, open a PR for the Product Owner to merge.

Every production write was rehearsed in a transaction that deliberately raises `REHEARSAL OK (...)` and rolls back; the commit file differs only in ending with `COMMIT`. After each commit an md5 over the written rows was compared with the locally computed plan.

## 3. Rules that worked (reuse them)

- **Topic must match the seed.** Keep a variant only if both checkers put it in the seed's topic and unit. This dropped many variants at topic boundaries (1.2/1.3, 8.2/8.4/8.6, 9.2/9.3, 2.2/2.5). It is the right call: a variant on a neighbouring topic is a different skill.
- **Topic votes:** accept at 5 of 6; accept 4 of 6 only when it agrees with the plurality pooled over the seed's variants; otherwise read the item against the fact pack (CED text) or leave it without a cell. Do not guess.
- **Skill votes (four voters: claude-opus-5, gpt-5.5, gemini-2.5-pro, gemini-3.8-flash):** `validated` at 3 of 4; a unique 2 of 4 is `provisional_model`; a 2-2 tie or 1-1-1-1 split gets no cell. Variants inherit the seed's skill and status.
- **Restricted grids:** Calculus AB, Chemistry and Statistics only allow certain skills per topic (the CED's suggested pairs). Give the voters only the allowed skills (`CELLS_FILE`), or a first round will return skills the grid rejects (18 of 140 did in the first Calculus pass).
- **Full-cross-product grids** (Biology, Physics 1, Physics 2, Physics C, Precalculus) are right because the CEDs say any topic can pair with any skill. Physics, Physics C and Physics 2 all share the same 10 science-practice skills (Course Framework V.1, p. 10). Calculus BC copies Calculus AB's 23 skills and cells.
- **Variants of a retired seed are retired too** (done for Calculus AB `005` and its mirrors).
- **A variant of a held or untagged seed has nothing to inherit.** Tag the seed first (vote, then read the item), then its variants.
- **Do not trust one checker.** DeepSeek's rationale audit is nitpicky and its flags vary between passes; Gemini sometimes places "what charge is inside" items in 8.2. Use unanimous topic agreement, recompute numbers yourself, and re-audit after each patch.

## 4. Database facts that bite (all hit during this run)

- **Publishing path.** A new item cannot go draft -> published. Walk `draft -> assigned -> reviewed_approved -> published` on both the item and the version (the guard trigger `tg_content_pipeline_guard_publish` checks the item). Copy the Physics 2 `gen_sql.py` / `publish.sql` rather than rewriting.
- **Inserting a new version flips the old validated label to `stale`** (trigger). Snapshot the labels into a temp table before the loop and carry forward from the snapshot.
- **The census counts `serving_label_hash_mismatch` for any active label whose hash differs from the current one, including never-validated held/legacy labels with a NULL hash.** About 50 of the "stale hashes" were that artifact. Only two labels were truly stale (both on retired version 1 with a published version 2 and no new label): fixed in `APPROVAL-0098`.
- **Multi-statement `execute_sql` returns only the last statement's result.** Run one statement per call, or put the check last. Two columns with the same name collapse in the JSON (alias them).
- **A `DO` block that raises is the only way to see rehearsal counts.** Use `raise exception 'REHEARSAL %', msg` then `rollback`.
- **Cell rules:** a validated cell needs a `model_run_id`; the FK is `(taxonomy_source_version, topic_code, skill_code)` into `taxonomy_cells`, so a skill cell needs the pair in the grid; one primary cell per version; skill cells are non-primary.
- **Subagents cannot copy files programmatically.** A subagent that "runs" a SQL file retypes it into the tool call. That is workable with guards (exact counts, md5 manifests, the rehearsal message) and a post-commit hash compared with the locally computed plan; it is not safe without them. One agent was killed mid-run after all load chunks had committed; check the database before restarting and resume from the hash check rather than reloading.
- **Approval-number collisions are real.** Other sessions took 0092, 0095, 0096, 0116 and 0117 while this run was going. Before writing an entry, `git fetch` and check `main` and the open PRs for the highest number, and say so in the entry when you renumber.
- **PR merge timing.** Two PRs were merged before the last commit on their branch was pushed (the late commit never reached `main`). Check `gh pr view <n> --json state` before every push; if merged, branch from `origin/main` and cherry-pick.
- **Published item with no published version** is a lifecycle defect (`apprecalc-frq-008`, a few Physics rows from July). Not fixed here.

## 5. Mistakes made and corrected (so they are not repeated)

- Released a held item (`apphy1-mcq-np1-002`, an exam-scoring question) to Unit 2 by mistake; reverted to held. Releasing a held item needs its own probe, soundness check and a reason the hold no longer applies.
- Cleaned 8 held Physics 1 Units 4-7 items outside the requested scope (disclosed; the user then asked for Units 4-8 stems to be cleaned).
- First wrote per-pack variant counts into an approval entry from the wrong rehearsal; corrected from the second. Recount from raw results before writing numbers into a log (see also memory `feedback_verify_counts_before_reporting`).
- Reported "published MCQs" totals that were off by a few because some rows have a published item with no published version. Count with the same join the census uses.

## 6. Decisions the Product Owner made in this run (and the reasoning)

- Calculus AB seed `005` (product rule and chain rule in one item) and its 5 variants and BC copies: **retired**, because the topic could not be settled and the item was not clean enough for skills.
- E&M `019` (differential Gauss's law, answer given away), `np1-010` and its variant (equal flux through cube faces, outside the CED's symmetry limit): **retired**.
- Four held items released after a probe: E&M `003`, Mechanics `023` and `031`, Physics 2 `001` (they had only been held by failed labelling-model calls).
- Calculus BC: reversed the earlier "no action on BC MCQs" and finished it.
- Skill cells are voted on seeds only; variants inherit (cuts the vote count by about 60%).
- Tiebreaks on topics were made by Claude reading the item against the CED text (Precalculus `015`, `027`; Calculus BC `002`, `024`; Calculus AB `005` before it was retired); they are tagged `ced_text_tiebreak` and each is a one-row change.

## 7. Open items for the next session

1. **Decide the remaining held items** (all held by failed labelling calls or unit disagreement, not by quality): E&M `np1-005` (rationale B is wrong, fix first) and `016` (Unit 13); Mechanics `012`, `019`, `020`, `034`, `040` (Units 4-7); Physics 2 `019` (Unit 15).
2. **Units 4 and above** for every subject, and FRQs, have not been through this pipeline.
3. **Variants still owed:** Mechanics `023` (checkers split 2.2/2.5; the seed's own topic is debatable), Mechanics `022` and `029` (all variants dropped), E&M `002`, `023`, `028` (topic drift), Calculus AB seeds with ties.
4. **Skill ties without a cell:** 8 Calculus BC items, 4 Calculus AB variants, 1 Precalculus variant, E&M `np1-006` and its 3 variants, Mechanics `023`. Resolve by reading the items or by a re-vote with a fifth voter.
5. **E&M seed `028` topic** is 9.2 on a 4-to-2 plurality over 9.3 (same unit).
6. **`TASK-0059`**: run the CED-vocabulary check (`DECISION-0095`) on the subjects other than Biology.
7. **Physics 2 FRQ and the other FRQ batches** need the same strip/repair treatment; they were out of scope.
8. **Mechanics skills list** was inferred to be the same 10 science practices as Physics 1, 2 and E&M (the Mechanics course description PDF was too large to fetch). Confirm when convenient.
9. **Lifecycle defects** seen: published items with no published version (`apprecalc-frq-008`, July Physics rows), draft items intentionally held (`APSTATS-MCQ-SV-057-v2`, `apcalcab-mcq-sv-025-v1`).
