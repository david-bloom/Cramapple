# More help — gap catalog for units 1–3 of the unsupported subjects (2026-10-16)

STATUS: CURRENT (a snapshot compiled from existing records; no new queries, writes, provider calls or deployments in this session)
**Scope:** catalog only. Nothing here enables a subject. Owner rules still apply: one subject at a time, units 1–3 only, ask before unit 4+ ([runbook](MORE_HELP_PER_SUBJECT_ROLLOUT_RUNBOOK_2026_10_16.md)).

## Evidence labels
**[R]** read in a dated repo record this session · **[D]** derived by me from those records · **[U]** unknown / not measured. Counts are content counts, not learner counts, and are as of the source record's date; rerun `scripts/more-help-readiness/` before relying on them.

## 1. Which subjects are "unsupported"
Live in Production **[R]** (Statistics launch close, APPROVAL-0183): Calculus AB, Calculus BC, Chemistry (all units), AP Statistics (units 1–3). Unsupported: **AP Biology, AP Physics 1, AP Physics C: Mechanics, AP Precalculus**, plus **AP Physics 2 (registry units 9–11)** and **AP Physics C: E&M (8–10)**.

**Owner ruling O1 (2026-10-16): Physics 2 and Physics C: E&M are out of scope.** In scope: Precalculus, Physics 1, Physics C Mechanics, Biology. Physics 2/E&M rows below are information only.

## 2. Gaps common to every new subject (the release path)
| # | Gap | Status |
| --- | --- | --- |
| C1 | **Per-subject Dev proof**: policy row → fixtures → `run.mjs` → replay → private packet → agent read → **owner read of the packet**. Statistics' round-1 packets were never read by the owner; launch was directed without them. | Required per subject; none done for any of the six **[R]** |
| C2 | **Production sequence**: `02_enable_subject.sql` (units 1–3) → app `MORE_HELP_UNITS` PR merged → **publish app last**; wait for Lovable `latest_commit_sha` = `main`. Statistics failed with a 403 when the app was published first. | Procedure exists; per-subject approval rows needed **[R]** |
| C3 | **Identify/define FRQ protection** is Statistics-only. Other subjects' "state whether / state the direction / identify the governing law / state the midline" parts are guarded only by the system prompt. Statistics students on 3.5-type FRQs get "couldn't connect" because the validator refuses. | Owner ruling pending (widen? what counts as disclosure per subject) **[R]** |
| C4 | **Never re-tested live** after the Production function replacement: AB/BC/Chemistry More help, the graded ("after") phase, FRQ `after`. | Open **[R]** |
| C5 | **Quota/budget**: expansion cap 30 generations / $5 across all subjects, Statistics used 15; synthetic QA account limited to 30 delivered/24h and 6/min; its entitlement rows expire. Six subjects need roughly 6 × ~9–15 generations, so the cap will not cover them. | Owner must raise or re-scope **[D]** |
| C6 | **Held-label (no unit) questions**: ~94 are `held` with no unit (BC 39, Chemistry 30, Physics 1 12, Physics C Mech 12, Precalc 3); 10 rows published under APPROVAL-0179, ~77 not rerun. Labeler rule (identical unit sets vs primary unit) is the owner's call. | Low value for units 1–3 (1 of 17 piloted was in 1–3) **[R]** |
| C7 | **Questions with no unit at all** in the census (so not assignable to 1–3): Physics 1 45, Physics 2 35, E&M 42, Physics C Mech 41, Precalc 9. Some may be units-1–3 questions awaiting tags. | Not investigated **[R]** |
| C8 | **Repo hygiene on `main` (new finding):** PR #475 merged, and `main` now contains `supabase/migrations/20261015232212_more_help_all_subjects.sql`, the superseded **ungated ten-subject** function the session close said must be removed first. Prod's ledger also has no rows for the gate (`20261016000100`) and grounding (`20261015175446`) migrations. A blind `supabase db push` risks applying the ungated function to Production. | **Needs action** (remove or neutralise the file; repair ledger first) **[R]+[D]** — verify against `origin/main` before acting |
| C9 | **Approval numbering**: APPROVAL-0181/0182 live only on PR #476's branch; 0183 on the Statistics launch branch; `main` ends at 0180. Check open PRs before numbering the next. | Open **[R]** |
| C10 | **Per-topic zero-MCQ holes** are hidden by per-unit census (see §3). A zero is a gap to look at, not automatically a defect (the topic's FRQ and worked example still exist). | Policy call: block launch on them or not? **[R]** |
| C11 | **Image-bearing question support** is in Production but its six AB/Chemistry questions were never re-tested live. Matters only for the Biology 3.4 item among the new subjects. | Open **[R]** |

## 3. Per-subject gaps (units 1–3)
Census cells (MCQ/FRQ per unit, latest published, practice-adjusted corrections apply — the cell counts in the census still include worked examples, the per-topic table below does not) **[R]**.

| Subject | Topics | Zero practice MCQs | 1–2 MCQs | Image-bearing | Open topic-tag items | Readiness |
| --- | --- | --- | --- | --- | --- | --- |
| **AP Precalculus** | 44 | **11**: 1.1, 1.3, 1.11, 2.1, 2.2, 2.8, 2.9, 2.14, 3.4, 3.8, 3.15 | 5 | 0 | 3 of 4 tagged (APPROVAL-0180); held: `-020`, `-np2-007`, `-np2-010` (multi-topic FRQs); `-mcq-sv-037-v3` labelled unit 2 vs topic 1.13 (unit 1) | Cleanest content-wise (no images); largest MCQ hole count |
| **AP Physics 1** | 19 | 3: 1.1, 1.3, 2.2 | 0 | 0 | `apphy1-frq-np1-004` tagged →2.5 (done); 12 held-label no-unit | Small gap, no images; strongest next-subject candidate by gap count |
| **AP Physics C: Mechanics** | 20 | **10**: 1.1, 1.4, 1.5, 2.1, 2.3, 2.4, 2.6, 2.7, 2.8, 3.1 | 3 | 0 | `apphycm-frq-044` held (3.4 vs unit-7 7.4 — **owner call**); thinnest cells overall: U2 13, U1 15 MCQ | Weak: half of topics have no practice MCQ |
| **AP Biology** | 22 | 4: 2.2, 2.4, 2.5, 2.9 | 1 (2.10) | **1** (3.4) | none | Needs the 3.4 image/grounding ruling; unit 2 content incomplete |
| **AP Physics 2** (info) | **[U]** | **[U]** not computed | **[U]** | 0 | **[U]** | Cells: 24/22/26 MCQ, 10/7/11 FRQ (U9–11) |
| **AP Physics C: E&M** (info) | **[U]** | **[U]** not computed | **[U]** | 0 | **[U]** | Cells: 38/25/24 MCQ, 19/8/6 FRQ (U8–10); thinnest FRQ cell E&M U10 = 6 |

### 3a. Biology specifics **[R]** (Biology Units 1–3 survey)
- Thin (3–5 practice MCQs): 2.1, 2.3, 2.6, 2.8, 3.1, 3.2, 3.3, 3.4, 3.5; unit 1 healthy (11–16).
- No owned vocabulary entry: 1.2, 1.6, 2.2, 2.9 (learn screen shows "Vocabulary: None for this topic yet" on 1.2). 1.2 and 1.4 each rest on one reference entry. **No Biology memory hooks** at all.
- The 2026-10-04 runbook calls Biology units 1–3 "Done"; the data does not support that for unit 2.
- Key trap: reference/taxonomy key `ap_biology`, registry key `biology`.

### 3b. Cross-subject content-quality gaps not tied to a count
- **FRQ parts living inside stem text, not `parts[]`** (Physics 1: 37 of 46; E&M: 28 of 33): normal for Statistics round 1, but [H08](MORE_HELP_GAP_CATALOG_2026_10_15.md) (multipart prompt fidelity in model context) was never traced end-to-end **[R]**. Matters most for the Physics courses.
- **Reference quality, not just presence**: coverage counts show a usable entry exists per topic, not that it is pedagogically complete **[R]**.
- **Answer-disclosure red-team (H03)** is open for Physics (numeric paraphrases, direction/sign conclusions) and Precalculus (midline/period/domain values) **[R]**.

## 4. What I would NOT claim
- That a zero-MCQ topic breaks More help: More help serves questions that exist; the practical effect is that learn mode has nothing to "Show another" with **[D]**.
- Any Physics 2 / E&M per-topic figure — never computed.
- That the "~9–15 generations per subject" is a measured budget — it extrapolates from Statistics (15 used) **[D]**.

## 5. Owner rulings (2026-10-16) and open decisions
- **O1** Physics 2 / E&M out of scope.
- **O2** Zero-practice-MCQ topics are **not a launch blocker but a big problem**: close them (gap-fill) as a priority; they do not gate the launch decision.
- **O3** Budget: **$64.18 Vercel AI Gateway credits** available. The old 30-generation / $5 cap is superseded as a ceiling, but per-run spend still needs an approved count.
- **O4** Open: the owner asked what "disclosure" means. Plain meaning: More help must nudge without giving away the answer the student is supposed to produce. The validator refuses any output that states the final result of a question part (e.g. "the procedure is a two-sample t-test" when the part asks to identify it). A student then sees an error instead of help.
- **O6** Authorized and **done** — see APPROVAL-0184 (ungated migration removed; Production ledger repaired).
- **O7** Owner accepts a **live smoke test** in place of reading Dev packets (C1 resolved, as with Statistics).

## 5b. Suggested order and remaining open decisions
**Order (my recommendation, not a decision):** Physics 1 → Precalculus (after its MCQ holes and the 3 held FRQs are accepted as-is) → Physics C Mechanics (after the `-044` ruling and a decision on its 10 zero-MCQ topics) → Biology (after the 3.4 ruling and unit 2 MCQ fill). Physics 2 / E&M only on O1.

**Decisions for David:**
1. **O1:** are Physics 2 (9–11) and E&M (8–10) in scope now?
2. **O2:** is "zero practice MCQs in a topic" a launch blocker, or only a content backlog? (Controls whether Statistics-style gap-fill must precede each launch.)
3. **O3:** raise the 30-generation / $5 cap, and by how much, for six subjects?
4. **O4:** widen the identify/define protection beyond Statistics, and who rules on "disclosure" per subject?
5. **O5:** `apphycm-frq-044` topic: 3.4 or unit-7 7.4.
6. **O6:** authorise cleanup of C8 (remove the ungated migration from `main`, repair the Prod migration ledger) before anyone runs `db push`.
7. **O7:** does the owner read Dev packets per subject (C1), or accept a live smoke test as with Statistics?

## 6. Sources
[Statistics launch close](../handoffs/SESSION_CLOSE_2026_10_16_MORE_HELP_STATISTICS_LAUNCH.md) (on PR #475's former branch; verify it is on `main`) · [census and readiness](MORE_HELP_UNITS_1_3_CENSUS_AND_READINESS_2026_10_16.md) · [rollout runbook](MORE_HELP_PER_SUBJECT_ROLLOUT_RUNBOOK_2026_10_16.md) · [Oct 15 gap catalog](MORE_HELP_GAP_CATALOG_2026_10_15.md) · [topic gap result](MORE_HELP_TOPIC_GAP9_RESULT_2026_10_16.md) · [held-label pilot](MORE_HELP_HELD_LABEL_RERUN_PILOT_2026_10_16.md) · `BIOLOGY_UNITS_1_3_CONTENT_SURVEY_2026_10_16.md` (on PR #476's branch).

## 7. Answer-leak protection extended beyond Statistics (2026-10-16, code on PR #477, NOT deployed)
`supabase/functions/more-help/contract.ts` now has `statedConclusionKinds`, scoped to FRQs before submission. A subpart that asks the student to **state a direction/sign, a named law/principle/theorem, a read-off value (midline, period, amplitude, domain, range, asymptote, end behavior), or whether** something holds sets a new `coachingBoundary` for the model. Direction, value and law also get deterministic checks on generated copy (diagnostic codes `direction_subpart`, `value_subpart`, `law_subpart`); "verdict" is prompt-only. Conditional or hedged sentences ("if the force points up…", "decide which way…") are ignored, so setup guidance still passes. The Statistics rule is unchanged. Tests: `contract_test.ts` (35 pass).

**Blast radius on real units 1–3 FRQs (Production, read-only, whole `prompt_json` text, so approximate):**

| Subject | FRQs | direction | value | law | verdict (prompt only) |
| --- | ---: | ---: | ---: | ---: | ---: |
| Precalculus | 81 | 2 | **21** | 0 | 10 |
| Physics 1 | 47 | 1 | 0 | 0 | 0 |
| Physics C Mechanics | 28 | 3 | 0 | 1 | 3 |
| Biology | 34 | 0 | 0 | 0 | 0 |
| Calculus AB / BC (live) | 59 / 41 | 0 / 1 | 2 / 2 | 0 | 9 / 10 |
| Statistics (live) | 72 | 1 | 0 | 0 | 12 |
| Chemistry (live) | 31 | 0 | 0 | 0 | 0 |

Takeaways: Precalculus is the one subject materially affected (21 of 81 FRQs ask to state a midline/period/domain/range). The rule also reaches live subjects (AB 11, BC 12, Statistics 13 FRQs get the new boundary; deterministic checks hit AB 2, BC 3, Statistics 1). Refusals cost the student a "couldn't connect", so expect some on those FRQs; a live Dev run per subject should measure the refusal rate before Production.
**Not yet done:** Dev deploy (blocked this session by the permission classifier), live Dev run of sample FRQs, Production deploy (separate approval).
