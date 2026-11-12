# Codex prompt: re-level published AP MCQs (other subjects and units)

Written 2026-11-12. Paste the "Prompt" section into a new Codex session started in a fresh worktree off `origin/main`. The "Reference" sections after it are the detail the prompt points to.

## Prompt

You are continuing a campaign to raise the difficulty and quality of published AP multiple-choice questions in Cramapple. The method is a fixed loop, already run for dozens of subject/unit batches: audit, author harder seeds, package, check, then (only on the owner's instruction) publish and retire the weakest old families.

Read first, in this order: `AGENTS.md`, `docs/INDEX.md` (find the task area; do not scan `docs/research`, `prompts`, `tmp`, `output`), `docs/product/QUESTION_DIFFICULTY_IMPROVEMENT_PLAN_2026_11_11.md`, then the status docs `docs/product/UNIT1_RELEVELING_STATUS_2026_11_12.md`, `UNIT2_...`, `UNIT3_...`, `UNIT4_BUILDOUT_STATUS_2026_11_12.md`, and `PHYSICS_C_MECH_UNIT1_RELEVELING_STATUS_2026_11_12.md`. Those say what is already live. Do not redo any subject/unit listed as executed.

**Your scope this session:** pick the next un-done subject/unit batches from the Scope section below, one batch at a time. A batch is one subject, one unit, up to about 8 topics (split larger units into `a`/`b` batches).

**Per batch, do exactly this:**

1. **Audit (read-only).** Run `scripts/difficulty-audit/audit.py` for the subject/unit (see its README). Record, per topic: published MCQ count, R1/R2/R3 counts, R1 share, and which seed families are R1. Write the summary to your scratchpad, not the repo.
2. **Author seeds yourself, in this session.** Do not pay a gateway model to author. For each topic write **2 new seeds at R3 level, each with 3 variants** (8 new MCQs per topic: each seed is a base item plus 3 variants, so 2 x 4; use the structure in an existing `source_draft.md`, e.g. `scripts/content-seed/apphycm-harder-seeds-u1-2026-11-12/source_draft.md`, and copy its format exactly). R3 means: multi-step, requires combining two ideas or interpreting a representation, plausible distractors built from real misconceptions, not recall or one-step plug-in. Stay inside the College Board CED for the course and unit; consult the CED PDF for the topic wording. Randomize the correct-answer letter across A/B/C/D. Every rationale must explain why each wrong choice is wrong.
3. **Logical-consistency check of your own premises (mandatory, by hand).** The automated key checks cannot detect a stem whose premises contradict each other (a live Precalculus item shipped with an impossible turning-point count and both checkers agreed with the key). For each item, derive the answer from the stem yourself and confirm every stated fact is mutually consistent. Be especially careful with: polynomial degree vs turning points and end behaviour (even degree means ends point the same way and an odd number of turning points; odd degree means opposite ends and an even number), counts of extrema/zeros, units and sign conventions, limiting cases in physics and chemistry, and any numbers that must satisfy a constraint.
4. **Package and check.** Use `scripts/content-seed/_tools/process_batch.sh <folder> "<Subject>" <prefix> <tag> <date>` with `UNIT=<n>` set. It validates the draft, builds the package, runs the blind solve (DeepSeek only, the default `BLIND_MODELS`), and runs the two-model tier audit. Add the subject to `_tools/label_cfg.json` if it is missing (copy the shape of an existing entry: pack id, taxonomy version id, `label_req`, and `label_req_uN` per unit; get the ids from the database, do not guess). Folder naming: `scripts/content-seed/<subjectprefix>-harder-seeds-u<N>[a|b]-<date>/`.
5. **Fix and re-run** until: validation passes, every key dispute is resolved by your own derivation (a disputed key is a real signal; do not wave it through), and no seed is rated R1. A seed the tool rates R1 or R1/R2 must be rewritten, not kept.
6. **Retire list.** Retire whole families whose seed's final tier is R1 (the lower of the two models' tiers), excluding `-oht-` teaching items. Only list keys that are published in the subject's served pack. Keep each topic at 12 or more published MCQs after the swap; if a topic would drop below 12, keep the best-rated old family instead.
7. **Stop before Production.** Commit the package folder, a status doc, and a PR. Do not run `exec_package.py` and do not run any write against Production.

**Hard rules (these have each caused real incidents):**

- **No Production write without the owner's explicit instruction in chat** (for example "execute", "move to production"). Preparing, packaging, rehearsing in a rolled-back transaction, and read-only queries are fine. Approval in one batch does not carry to the next.
- Run the Supabase CLI from the repo with `--workdir` pinned. Running it from `~/supabase` links **Production**. Dev is not Prod: Dev lags main and entry ids differ, so never assume a Dev result proves a Prod result.
- Never print or paste the AI Gateway key or any Supabase secret. Gateway key lives in `scripts/vercel-gateway-check/.env.local`; symlink it into a worktree, do not copy it into a file you commit.
- Stagger Supabase logins (about 50 s apart) when running many in parallel; many at once trip the circuit breaker.
- Editing a published item's stem or choices marks its serving label stale and removes it from serving. If a live item needs correcting, the fix must also insert a validation decision and revalidate the label. See `scripts/content-seed/apprecalc-harder-seeds-u1a-2026-11-12/fix_1_4_b_2026_11_12.sql` for the pattern.
- Check open PRs and `origin/main` for the next free `APPROVAL-NNNN` number before writing a record. Unmerged PRs claim numbers and collisions have already happened (two APPROVAL-0236 files exist). Record approvals in `docs/activity_log/APPROVAL-NNNN_*.md` plus index lines in `APPROVALS_LOG.md` and `ACTIVITY_LOG.md` (read only up to `<!-- INDEX_END -->` first).
- Do not hand-patch seeds after the checkers have run without re-running them.
- Tiers are uncalibrated model judgements. Say so in every status doc. Do not claim a subject-expert review that did not happen.
- Report counts from the raw results, recounted, not from memory.

**Deliverable per batch:** a PR with the package folder, `docs/product/<SUBJECT>_UNIT<N>_RELEVELING_STATUS_<date>.md` (audit table before, new/retire counts, checks run and results, hand-derivation notes for any disputed key, caveats), and no Production changes. End with a short message to the owner: what is ready, the counts, the weakest items, and a request for the go-ahead to execute.

## Scope (determine from the status docs and the audit, then confirm with the owner)

Already live (do not redo): Unit 2 for Biology, Calc AB/BC, Chemistry, Physics 1, Precalculus (Stats earlier); Unit 3 and Unit 4 for all subjects except those on hold; Unit 1 for Biology, Calc AB/BC, Chemistry, Physics 1, Precalculus, Statistics, and Physics C: Mechanics.

Candidate next work, in suggested order:

1. **Physics C: Mechanics Units 2 and onward** (Unit 1 is done; check the status doc and audit for Units 2 to 4).
2. **Physics 2** (course starts at Unit 9, so its first three units are 9 to 11) and **Physics C: E&M** (starts at Unit 8, first three are 8 to 10). These have never been touched. Check the subject's pack and taxonomy ids and serving-label requirements before authoring.
3. **Unit 5 and later units** for subjects where the audit shows many R1 families or thin topics. Statistics Units 5 to 9 are the likeliest to benefit.
4. **Thin-topic top-ups** (fewer than 12 published): Statistics 1.1 to 1.5 and 1.9 (9 each), Physics 1 topic 1.4 (8), Chemistry 1.1 and 1.8 (11), Physics C Mechanics 1.1 (8). These need new seeds only, no retirements.
5. **Logic-consistency re-audit** of already-live Unit 1 and Unit 2 seeds, Precalculus and Calculus first. Read-only: derive each answer by hand from the stem and list any item whose premises conflict. Report findings; do not edit live items without the owner's instruction.

Tell the owner which batch you chose and why before authoring it.

## Reference: tools

| Tool | Path | Purpose |
|---|---|---|
| Audit | `scripts/difficulty-audit/audit.py`, `README.md` | read-only tier audit of published items |
| Draft validator | `scripts/content-seed/_tools/validate_draft.py` | checks `source_draft.md` format |
| Packager | `scripts/content-seed/_tools/make_package.py` | builds items, load chunks, publish/retire SQL |
| Blind solve | `scripts/content-seed/_tools/blind_solve.py` | independent answer check (DeepSeek by default; set `BLIND_MODELS` to add Kimi) |
| Batch driver | `scripts/content-seed/_tools/process_batch.sh` | validate, package, blind solve, tier audit, read-only |
| Executor | `scripts/content-seed/_tools/exec_package.py` | **Production write**, owner-gated; preflight, load, hash check, rehearsal, publish, retire, verify, selector check |
| Config | `scripts/content-seed/_tools/label_cfg.json` | per-subject pack, taxonomy, per-unit label requirements |

## Reference: how serving works (why the traps exist)

- An item is served only with a validated serving label whose `validated_against_taxo_hash` equals `app.taxonomy_relevant_hash(version)`. The hash covers stem, stimulus, prompt_json, canonical answers, mcq_choices and FRQ criteria.
- Variants inherit their seed's tier.
- Statistics has two packs: the general pack `548f06be` is served; the pilot pack `7c5a2975` has no serving labels and is unserved. Retire lists must contain only items in the served pack, or `exec_package.py` preflight fails (it counts published items in the package's pack).
- Subject keys use hyphens in the registry (`ap-calculus-ab`) and underscores in the guides and taxonomy (`ap_calculus_ab`).
- `exec_package.py` stops on its first failure and its stdout is buffered when redirected; run it only when the owner has said to.
