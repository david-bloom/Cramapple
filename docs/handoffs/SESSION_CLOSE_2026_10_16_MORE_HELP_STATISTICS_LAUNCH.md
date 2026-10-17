# Session close — More help: Statistics launch, content gaps and what blocks the next subject (2026-10-16)

STATUS: HISTORICAL (a dated record). Current rollout rules and steps live in `docs/qa/MORE_HELP_PER_SUBJECT_ROLLOUT_RUNBOOK_2026_10_16.md`.

> **Integration correction, 2026-10-17:** use [the later restart handoff](MORE_HELP_REMAINING_TASKS_2026_10_17.md) for the recorded current state, not the launch/version/branch claims below. PRs #475 and #476 have merged; Production and approval-ledger claims below are historical and were not reverified here. The Statistics launch approval had a duplicate identifier; [the full-path legacy record](../activity_log/LEGACY_APPROVAL_STATISTICS_MORE_HELP_LAUNCH_2026_10_16.md) preserves it. Canonical `APPROVAL-0183` is the BC image mirror. The code integration preserves current main's runtime leak checks, MCQ coaching boundary, FRQ conclusion guards and tests, and adds only the missing procedure-name variants. No new deployment is authorized.


## 1. Where things stand
**Live in Production for More help:** Calculus AB, Calculus BC, Chemistry (all units) and **AP Statistics units 1–3** (`APPROVAL-0183`). Every other subject, and Statistics unit 4+, is refused by the backend policy table (`app.more_help_subject_policy`) and hidden by the app's `MORE_HELP_UNITS` map. Owner rules: **one subject at a time, units 1–3 only, ask before unit 4+**; Physics 2 (units 9–11) and Physics C: E&M (8–10) are out of scope until the owner says.

**Also done this session:** units 1–3 census and readiness audit; reusable Development QA tooling; per-subject rollout runbook and Production release packet; topic probe for the untagged units 1–3 questions (4 cells written, `APPROVAL-0180`); 10 serving labels from the held-label rerun pilot (`APPROVAL-0179`); `student-session-items` merged and deployed (v41, `APPROVAL-0181`); learn-mode answer key and Statistics-off app changes (`APPROVAL-0182`); Statistics launch (`APPROVAL-0183`); a Codex prompt for the Statistics MCQ gap fill.

## 2. Remaining content gaps (units 1–3)
**Census (per subject and unit): no cell is short** (minimum 13 practice MCQs and 7 FRQs; Physics C: Mechanics unit 2). That check hid per-topic holes, and an earlier count had included worked examples (corrected). **Per topic, 51 of 237 topics in units 1–3 have zero practice MCQs; every topic has at least one FRQ and one worked example:**

| Subject | Topics | Zero practice MCQs | 1–2 MCQs |
| --- | --- | --- | --- |
| AP Statistics | 40 | 15: 1.1, 1.3, 1.4, 2.1, 2.3, 2.8, 2.11, 2.12, 3.7, 3.9, 3.10, 3.11, 3.12, 3.13, 3.14 | 1 (2.2) |
| AP Precalculus | 44 | 11: 1.1, 1.3, 1.11, 2.1, 2.2, 2.8, 2.9, 2.14, 3.4, 3.8, 3.15 | 5 |
| AP Physics C: Mechanics | 20 | 10: 1.1, 1.4, 1.5, 2.1, 2.3, 2.4, 2.6, 2.7, 2.8, 3.1 | 3 |
| AP Biology | 22 | 4: 2.2, 2.4, 2.5, 2.9 | 1 (2.10) |
| AP Calculus BC | 32 | 3: 1.1, 1.9, 1.16 | 1 |
| AP Chemistry | 28 | 3: 3.3, 3.8, 3.11 | 0 |
| AP Physics 1 | 19 | 3: 1.1, 1.3, 2.2 | 0 |
| AP Calculus AB | 32 | 2: 1.1, 1.9 | 2 |

Physics 2 and Physics C: E&M were not computed. A topic with zero practice MCQs gives a learn-mode student the worked example and nothing to practise on; More help only helps questions that exist.

**AP Biology units 1–3 (22 topics), full survey: `docs/qa/BIOLOGY_UNITS_1_3_CONTENT_SURVEY_2026_10_16.md` (on the #476 branch).** Gaps are identified, not closed:
- No practice MCQ: **2.2, 2.4, 2.5, 2.9**; one MCQ: **2.10**; thin (3–5): 2.1, 2.3, 2.6, 2.8, 3.1–3.5. Unit 1 is healthy (11–16 per topic). Unit 3's earlier zero-MCQ gap is closed. The 2026-10-04 runbook calls Biology units 1–3 "Done"; the data does not support that for unit 2.
- No owned vocabulary entry for 1.2, 1.6, 2.2, 2.9 (the learn screen shows "Vocabulary: None for this topic yet" on 1.2); 1.2 and 1.4 each rest on one reference entry. No Biology memory hooks at all.
- One image-bearing question (3.4) needs a grounding ruling. A key reminder: reference keys use `ap_biology`, registry keys use `biology`; a naive join shows Biology as 100% ungrounded.

**Untagged questions.** 9 units-1–3 questions had no topic cell: 4 written (Physics 1 `apphy1-frq-np1-004`→2.5; Precalculus `-frq-016`→3.13, `-frq-u12-002`→2.12, `-mcq-sv-037-v3`→1.13). **5 held:** Physics C Mechanics `apphycm-frq-044` (3.4 vs unit 7's 7.4, owner call), BC `apcalcbc-frq-017` and Precalculus `-020`, `-np2-007`, `-np2-010` (multi-topic FRQs, not forced). A further **~94 questions are `held` serving-label with no unit** (BC 39, Chemistry 30, Physics 1 12, Physics C Mechanics 12, Precalculus 3; mostly unit 4+ content, 1 of the 17 piloted was in units 1–3). `apprecalc-mcq-sv-037-v3`'s validated label says unit 2 while topic 1.13 is unit 1.

**Reference gaps seen earlier:** 19 BC questions tagged in the 65-question pass still lack unit-6+ reference content; AB 80 / BC 22 mapped versions missing reference entries (outside units 1–3). In units 1–3 every question had reference grounding at the census.

**Statistics fill-in:** Codex prompt `docs/handoffs/CODEX_PROMPT_STATISTICS_MCQ_GAP_FILL_2026_10_16.md`: Stage A 31 seeds (≤$12, then stop at a gate), Stage B up to 93 cheaper-checked variants (≤$22, validated first). Real cost basis: Biology seed pilot $0.314 per accepted item, about $0.22 after the levers.

## 3. Other gaps before More help can launch in the next subject
Per-subject steps are in the runbook; these are the blockers and caveats found this session.
1. **Content readiness (census SQL):** no image-bearing questions, authored parts complete, reference grounding present, topic gaps closed. Cleanest candidates: Precalculus (after its topic gaps; 3 of 4 written) and Physics 1 / Physics C Mechanics (one gap each). Biology needs the 3.4 image ruling and has unit 2 MCQ holes. Statistics is done.
2. **Images:** 7 image-bearing questions in scope (AB unit 1: 4, Chemistry unit 3: 2, Biology unit 3: 1). The image-support repair is now in Production (grounding migration + `more-help`), but **those six AB/Chemistry questions have not been re-tested live**.
3. **Output review:** the Development output packets for Statistics (8 outputs, round 1) were never read by the owner; the launch was directed without them. Each new subject needs a Development run (fixtures → `run.mjs` → replay → private packet), agent read, and owner read.
4. **Identify/define FRQs:** the pre-submit rule and a tightened validator now refuse FRQ parts that ask to identify the procedure/parameter (3.5-type). Students see "More help couldn't connect" there instead of help. Needs prompt/validator work; not generalised to other subjects (the trap matched 12 of 72 Statistics FRQs and 0–5 elsewhere; other subjects' "state whether…", "state the direction", "identify the governing law" parts are unprotected beyond the system prompt).
5. **Not yet re-tested live after the Production function replacement:** More help on Calculus AB/BC/Chemistry; the graded ("after") phase for any subject; FRQ `after`.
6. **Backend sequence per subject:** gate migration (once, done) → `more-help` v17+ (done) → `02_enable_subject.sql` with the unit list → **publish the app last**. Statistics' failure (a 403 "More help couldn't connect") happened because app #30 was published before the backend; always enable the backend first. Wait until Lovable's `latest_commit_sha` equals `main` before publishing (it lags merges by ~2 minutes).
7. **Quota and budget:** the synthetic QA account's 30-delivered-per-24h and 6-per-minute limits stall reruns; its entitlement rows expire (a temporary Development row was added and removed). Expansion cap 30 generations / $5 across all subjects: Statistics used **15**.
8. **Reference/entry gaps per subject** affect More help quality (vocabulary, hooks) but do not block launch.

## 4. Repository and Production state to reconcile
- **Backend PR #475 (`codex/more-help-all-subjects-u1-u3`) is not merged and must not be merged as-is:** it still contains `supabase/migrations/20261015232212_more_help_all_subjects.sql` (the **ungated ten-subject** function, superseded). Remove that file first. It also holds the gate migration `20261016000100`, the QA/rollout/release docs, tooling, `APPROVAL-0179/0180/0183`, the Statistics function fixes (`more-help` identify/define rule, commits through `c58ff339`) and the Codex prompt.
- **Backend PR #476 (`claude/student-session-items-answer-preload-merge`)**: merged `student-session-items` (deployed as Production v41), `APPROVAL-0181/0182`, and the Biology survey. Unmerged; `main` still lacks the `teaching_image` branch that Production runs.
- **Production migration ledger:** the gate (`20261016000100`) and grounding (`20261015175446`) migrations were applied with `supabase db query`, so the ledger has no rows for them. Do not `db push` blindly; record or repair them first. Rollback files: `docs/qa/more_help_release/03–04`; grounding rollback is the saved prior definition (private, `/private/tmp/more-help-held-pilot-2026-10-16/`).
- **App PRs #31, #32, #33** are merged (`main` at `6ee28af`) and published.
- **Approval numbers 0179–0183 live on branches (#475, #476), not on `main`.** Check branches before numbering a new one.
- **Stalled scheduled task `more-help-stats-frq-rerun`** (session `local_c10655da-02c0-4711-a429-58df7c8bad16`): waiting on a permission prompt since 18:06 UTC and superseded (I ran the FRQ checks myself). Dismiss it; do not approve it. A stop request was blocked by the auto-mode classifier.
- **Development leftovers:** synthetic sessions for the QA identity (Statistics units 1–3, plus one unit 5), a leftover "tmp"-source entitlement row that is not from this session, and `more-help` at v17 in Development.
- Private artifacts (full questions, model outputs, votes) are in `/private/tmp/more-help-*` and the gitignored `tmp/`; they will not survive a reboot.

## 5. Decisions waiting on the Product Owner
1. Send the Codex prompt (seeds first); approve variants at the gate.
2. Which subject next, and the Biology unit 2 MCQ fill.
3. Physics C Mechanics `apphycm-frq-044` topic (3.4 or unit-7 7.4).
4. Whether to widen the identify/define protection to other subjects' "state/identify" FRQ parts, and what counts as disclosure there.
5. Whether the labeler should compare primary unit rather than identical unit sets (revisit when units 4–7 open).
6. Read the Statistics output packets, or accept the live smoke test as sufficient.
