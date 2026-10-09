# Memory Hooks and Unit Reference Production Protocol

STATUS: CURRENT
DATE: 2026-10-09
OWNER: Product Owner / Learning Quality. Executed by a Claude session.
GOVERNS: `app.unit_reference_entries` (formulas, vocabulary, lists/sequences, conventions, diagrams) and
`app.topic_memory_hooks` (acronyms, acrostics, phrases, formula sentences, visual cues, diagram parts).
RECORDS: `DECISION-0104` (hooks), `DECISION-0105` (reference content is the companion), `DECISION-0107`
(CED-named hooks, veto model), `APPROVAL-0140` (first Production ship). Tasks `TASK-0066`, `TASK-0067`.
FIRST RUN: `scripts/content-seed/task0067-reference-pilot-2026-10-09/README.md` (AP Statistics Unit 1,
AP Chemistry Unit 4; 102 entries, 3 hooks, $20.29).

## 1. What this produces, and what it never produces

A **reference entry** is one thing a student may look up for a topic: a formula (LaTeX), a vocabulary
term with its CED definition, an ordered list or sequence, a sign or direction convention, or the
labelled parts of a diagram the CED requires. It is owned by the topic that first requires it
(`owner_topic_code`) and lists every later topic in the unit that reuses it (`topic_codes`).

A **memory hook** is a device for recalling exactly one reference entry. It never exists on its own
(`reference_entry_id` is required). It is for recall; the exam answer is written in CED language, and
the `caution` field says so whenever the hook's wording is not the wording that earns the point.

Inclusion rule (`DECISION-0104` D2, amended by `DECISION-0105`): an entry or hook is admissible only
when a CED learning objective or essential-knowledge statement for that unit requires a student to
reproduce or apply it. Textbook completeness, trivia, and content from other units fail. Most topics
get no hook. Expect roughly one hook per ten entries; the pilot produced 3 hooks for 102 entries.

Never: songs or lyrics (`DECISION-0104` D4); hooks inside hints or post-miss feedback (D5); hand
edits to a generated row; a publisher's novel phrasing (common mnemonics in general circulation are
`public-domain-common`; original ones are `cramapple-authored`).

## 2. Inputs, checked before the run

1. **CED PDF** for the subject, in `docs/teaching/<subject>-course-and-exam-description.pdf`. The PDF
   governs; the fact pack is paraphrase (protocol v0.6 §0.4).
2. **Fact-pack section** for the unit, from `docs/product/AP_*_CED_FACT_PACK.md`.
3. **Taxonomy** rows for the subject's latest verified source version (`app.taxonomy_topics`): every
   topic code the run emits must exist there, and the owner topic's unit must match.
4. **Live model roster** from the gateway (`https://ai-gateway.vercel.sh/v1/models`, key read in Python
   from `scripts/vercel-gateway-check/.env.local`, never echoed). Roles:
   - Extractor: `anthropic/claude-sonnet-5.5` (extraction from the CED pages, not authoring).
   - Checkers: two families, neither the extractor's. Current: `google/gemini-3.5-flash`,
     `openai/gpt-6-sol` (menu slots B and A).
   - Own-family veto (reject-only): `anthropic/claude-haiku-5.5` (`DECISION-0107`; Opus 5.5 was 56% of the
     pilot's spend). Any model new to the pipeline passes the smoke test (`smoke.py`, 3/3 structured
     output) before its verdicts count.
   - The Product Owner ratifies the slate per batch (`CONTENT_AUTHORING_AND_QA_PROTOCOL.md` §2.1); the
     session proposes it in the batch README.

## 3. The run, step by step

All scripts live in the batch directory and are copied forward per batch
(`scripts/content-seed/<subject>-reference-<units>-<date>/`). Set
`CED_TXT_DIR` to a scratch directory holding `pdftotext -layout` output of the CED PDF.

1. **Page range.** Find the unit's pages in the text dump (form feeds mark pages; `UNIT N` headers).
   Stats Unit 1 was pp. 28–59, Chem Unit 4 pp. 79–94.
2. **Controls first.** Write six planted defects per unit in `controls_<subject>_u<N>.json`: a wrong
   formula or definition, a CED-excluded or non-CED item, a wrong owner topic, a wrong list member or
   order, a hook with a wrong expansion, content from another unit. **Verify each control against the
   CED PDF before relying on it**: the pilot's "ideal gas law is another unit" control was wrong (CED 4.5
   names it) and voided a run for nothing.
3. **Extract.** `extract.py --subject <ap-x> --subject-key <ap_x> --unit N --pages a-b --factpack <file>`.
   One call per unit; output `out/candidates_<subject>_u<N>.json`. Read the titles before checking:
   a glossary dump or a missing formula is visible at a glance.
4. **Check.** `check.py ... --controls <file> --workers 6`, run detached (`nohup`), resumable, writes
   after every candidate. Each checker judges the entry on (a) factual against the CED, (b) owner and
   reuse topic codes, (c) CED-required, (d) caution present where needed, and each hook on (e) expansion
   correct and in order, (f) admissible. A flag is re-sampled once; only a repeated flag counts. Both
   checkers must accept; then the veto may reject. **Entry and hook verdicts are independent**: a
   rejected hook never rejects its entry.
5. **Controls gate.** All six controls must be rejected or the batch is void. If a control leaks, first
   check the control against the CED; if the control was wrong, replace it and re-run the six controls
   only (`recompute.py` keeps candidate verdicts); if the control was right, the batch is void.
6. **Round 2.** Rejected entries are re-extracted statelessly with `--only` (titles and owner topics only,
   no checker reasons) and checked again. After two rounds, a still-rejected entry is **escalated** to
   the Product Owner with both checkers' reasons; it is never patched.
7. **Load to Development.** `load.py --subject-key ... --unit N --batch <name> [--po-accept <file>]`
   writes `out/load_<subject>_u<N>.sql`; apply with
   `supabase db query --linked --workdir <repo> -f <file>` (the CLI is linked to Development). Rows insert
   as `published` in Development. `--po-accept` records a Product Owner acceptance decision (an
   escalation ruling, or a CED-named hook the veto rejected) in the row's `source_note`; it never edits
   content.
8. **Verify Development** with `scripts/qa/unit_reference_and_memory_hooks_qa.sql` and a read-only RPC
   probe (`get_topic_point_guides` under a fake `request.jwt.claims`, raising at the end to roll back).
9. **Record** in the batch README: slate and prices, page ranges, counts per round, controls, escalations,
   overrides, cost from `out/logs_*` at gateway list prices. Commit the candidates, verdicts, load SQL
   and README; never the `logs_*` JSONL.

## 4. Product Owner decisions per batch

1. Ratify the model slate.
2. Each escalation (owner topic, or CED-required or not).
3. Any CED-named hook the veto rejected: the CED wins (`DECISION-0107` rule 1), recorded as an override.
4. The Production publish.

## 5. Production (Hard Gate every time)

1. Approval entry in `APPROVALS_LOG.md` naming the batch, counts and the rollback.
2. If the schema changed: apply the migration file with the CLI temporarily linked to Production
   (`supabase link --project-ref pcntajvbdfqhbeewmdry -p ""`, then `db query --linked -f`), insert the
   ledger row under the same version as Development so one file satisfies both ledgers, relink to
   Development. Compare `md5(pg_get_functiondef(...))` and `md5(pg_get_viewdef(...))` against
   Development before loading data.
3. Load the same generated SQL files the same way. Run the QA script and the RPC probe on Production.
4. Frontend: the app renders exactly its previous output when `reference[]`/`memoryHooks[]` are empty,
   so a data publish needs no frontend change. A frontend change is a Lovable preview build, reviewed by
   diff and tests, then `deploy_project`; the app has no anonymous route, so confirm the publish by
   signing in and opening a topic with hooks.
5. Rollback: retire the hooks, then the entries (`status = 'retired'`; the guard requires hooks first).

## 6. Order of work from here

Statistics Unit 2 and Chemistry Unit 5 next (the pilot subjects), then Biology Units 1–3 (day-1 subject),
then the remaining subjects by active-student count. One unit per run; two units per session is fine.
Open design items that do not block content: row limits for the pane's "Look up" block; a formula
renderer (formulas currently display as LaTeX source in monospace); `TASK-0054`'s taxonomy FK, which
both tables should adopt together when it lands.
