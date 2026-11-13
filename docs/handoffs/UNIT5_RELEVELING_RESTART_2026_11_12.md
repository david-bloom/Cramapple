# Unit 5 question re-leveling restart (2026-11-12)

## Current task and source

David directed execution of Unit 5 for AP Statistics, AP Biology, AP Calculus AB, and AP Calculus BC, followed by a results report. AB and BC require separately authored questions on the same topic codes. Physics 2 and both Physics C subjects remain on hold. The governing task prompt is `docs/handoffs/CODEX_PROMPT_QUESTION_RELEVELING_2026_11_12.md`, with David's later Production instruction superseding its stop-before-Production step for these four named batches. David also approved a one-time exception for these four batches to use the prompt's two-model blind solve and tier audit instead of the standing four-checker/planted-control protocol. Add a third four-item family where the 12-item topic floor requires it.

## Completed and live

AP Statistics Unit 5 is fully executed on Production `pcntajvbdfqhbeewmdry` (served pack `548f06be-ccf4-426d-b82b-b424137a4438`). PR #640, stacked on PR #635, contains the package and the execution record. Approval `APPROVAL-0259` and `docs/product/STATS_UNIT5_RELEVELING_STATUS_2026_11_12.md` are the durable evidence. Sixty new MCQs were published with validated serving labels, 15 published R1 items retired, all 60 hashes verified, and the student selector returned new items in all five topics. Independent read-only Production counts and valid-serving counts are 12/12, 12/12, 13/13, 14/14, 12/12 for topics 5.1–5.5. Three unserved pilot R1 items remain outside the served pack; do not include their keys in a served-pack retirement package.

## Remaining batches

Read-only Unit 5 audits were run 2026-11-12. Their results are in `/private/tmp/cramapple-unit5-evidence/` (scratch only); re-run for a durable status document when authoring each batch. The taxonomy and pack identifiers below were verified from Production. No new questions were authored or published for these three subjects in this session.

| Subject | Unit 5 topics | Published before | R1 | R2 | R3 | Valid serving labels before | New items needed for a 12/topic floor |
|---|---:|---:|---:|---:|---:|---:|---:|
| AP Biology | 5.1–5.5 | 5 | 0 | 4 | 1 | 5 | 56 (three families except two in 5.4) |
| AP Calculus AB | 5.1–5.12 | 12 | 3 | 9 | 0 | 4 | 144 (three families/topic) |
| AP Calculus BC | 5.1–5.12 | 3 | 0 | 2 | 1 | 3 | 144 (three separately authored families/topic) |

AP Biology served pack `2d88ba5e-a6a3-43b8-bfae-9e5505a178a7`, taxonomy version `c676d1fc-3b58-4896-89e3-852d9bd1f81b`. AP Calculus AB pack `826c8cf1-bc1b-4f2a-bd33-61a758e1487d`, taxonomy version `33b4408b-0ecc-4c7a-b0b1-612db81164a1`. AP Calculus BC pack `3778d753-273a-403d-8f02-55dc64ec6a27`, taxonomy version `ab088009-dc9a-4f93-8824-803e1913505b`.

The AB audit found one disputed old key; that old item must be hand-derived before a retirement decision. These audits include published items beyond valid serving labels; status reports must reconcile the served-pack denominator separately. The R2/R3 tiers are uncalibrated model judgments.

## Branch and tool state

- PR #635 carries the handoff prompt and `process_batch.sh` changes. PR #640 is stacked on it. Statistics branch `codex/unit5-statistics-releveling` is clean and pushed at the session close.
- A separate Biology worktree exists at `/private/tmp/cramapple-unit5-biology`, branch `codex/unit5-biology-releveling`, based on PR #635's original head. It contains only a temporary `bio_ced.txt` and audit scratch. Do not treat it as an authored package.
- The Statistics PR fixes `make_package.py` Unit 5 metadata and `exec_package.py` to require a pinned Production-linked `--workdir`. Carry those fixes to later subject branches before package execution. The pinned project ref must be `pcntajvbdfqhbeewmdry`; never use `~/supabase` as an implicit Production link.
- Use `docs/INDEX.md` to route, and keep the CED reads exact and scoped: `docs/teaching/ap-biology-course-and-exam-description.pdf` and `docs/teaching/ap-calculus-ab-and-bc-course-and-exam-description.pdf`. Do not scan the prohibited directories broadly.

## Next owner and step

The next Cramapple content session should author **AP Biology Unit 5** in its separate worktree, first adding the Unit 5 serving-label requirements from Production to `scripts/content-seed/_tools/label_cfg.json`. Write 56 original MCQs as 14 seed families and variants, hand-check the premises and rationales, run the approved two-model checks, record before/after counts and an approval record, then publish only after the checks and package are complete. Continue with separate AB and BC packages. Do not redo Statistics Unit 5, do not mirror AB questions into BC, and do not touch held Physics subjects.
