# More help reference-gap remediation — prepared batch

**STATUS: PREPARED; no provider calls, data writes or publish performed.**

> **Reassessed after the October 15 activity log:** Chemistry 2.5 has already been published in Development and Production under APPROVAL-0177. It is excluded from the executable scopes/target manifest; retained Chemistry preparation is historical source/control evidence only. The revised run covers 49 AB topics and 30 additional BC topics in ten subject-unit scopes, with 6.14 still requiring the interpretation below. The earlier slate/$60 question remains unapproved; no provider run is authorized by this note. Four expanded-octet question rulings belong to TASK-0076, not a duplicate reference entry.
**DATE:** 2026-10-15. **Owner:** David Bloom / execution conductor.
**Governing protocol:** `docs/product/MEMORY_HOOKS_AND_UNIT_REFERENCE_PRODUCTION_PROTOCOL.md`.
This README prepares the concrete content work authorized in principle by the request to resolve
PR #460's gaps and close reference-content gaps. The conductor records the work order before execution;
the protocol's model-slate, escalation and Production gates still apply.

## Coverage to produce

Fresh read-only Production inventory confirms the catalog's missing taxonomy-topic counts. Generate
AB's shared material once and retain the existing BC→AB Units 1–8 alias. Do not duplicate all shared
AB entries into BC. Alias coverage is resolved on topic code, not merely on unit number.

| Stored subject / unit | Target topics | CED PDF pages, 1-based |
| --- | --- | --- |
| `ap_calculus_ab` / 4 | 4.1–4.7 (7) | 87–93 |
| `ap_calculus_ab` / 5 | 5.1–5.12 (12) | 99–110 |
| `ap_calculus_ab` / 6 | 6.1–6.10 and 6.14 (11) | 118–131; exclude the three BC-only topics |
| `ap_calculus_ab` / 7 | 7.1–7.4 and 7.6–7.8 (7) | 137–145; exclude the two BC-only topics |
| `ap_calculus_ab` / 8 | 8.1–8.12 (12) | 152–164; exclude BC-only 8.13 |
| `ap_calculus_bc` / 6 | 6.11, 6.12, 6.13 (3) | 128–130 within unit 118–131; verify exact pages before run |
| `ap_calculus_bc` / 7 | 7.5, 7.9 (2) | unit 137–145; target only those topics |
| `ap_calculus_bc` / 8 | 8.13 (1) | 164 within unit 152–164 |
| `ap_calculus_bc` / 9 | 9.1–9.9 (9) | 171–179 |
| `ap_calculus_bc` / 10 | 10.1–10.15 (15) | 186–200 |
| `ap_chemistry` / 2 | 2.5 Lewis Diagrams (1) | 56; checker context may include adjacent unit topics |

These are **49 AB topics + 30 additional BC topics + 1 Chemistry topic**, across eleven subject-unit
scopes. BC's currently missing 79 topics consist of the shared 49 plus its own 30. All pages were
identified from the existing PDFs' `pdftotext -layout` page boundaries; verify the controlling LO/EK
and each planted defect against the PDF before execution. Front-matter topic-list matches are not
unit content (a naive search finds Unit 10 in the front matter too).

Inputs are the existing `docs/teaching/ap-calculus-ab-and-bc-course-and-exam-description.pdf`,
`docs/teaching/ap-chemistry-course-and-exam-description.pdf`, and matching unit sections of
`docs/product/AP_CALCULUS_AB_BC_CED_FACT_PACK.md` and
`docs/product/AP_CHEMISTRY_CED_FACT_PACK.md`. The CED governs. Chemistry 2.5.A requires representation
with a Lewis diagram, and 2.5.A.1 states that diagrams can be constructed according to established
principles; an entry must teach this required representation, rather than borrow 2.6 ownership.

## Model slate and cost proposal

Read-only roster fetch from `https://ai-gateway.vercel.sh/v1/models` on October 15 confirms all four
canonical IDs. Proposed unchanged slate, pending the owner's ratification for this batch:

| Role | Model | Input / output USD per million tokens |
| --- | --- | --- |
| Extract from CED | `anthropic/claude-sonnet-5.5` | 2.00 / 10.00 |
| Checker 1 | `google/gemini-3.5-flash` | 1.50 / 9.00 |
| Checker 2 | `openai/gpt-6-sol` | 2.00 / 10.00 |
| Reject-only own-family veto | `anthropic/claude-haiku-5.5` | 0.10 / 0.50 |

These are standard, short-context list prices; no cache discount is assumed. The unit excerpts have
about 14k–34k characters each, well below pricing tier thresholds. An estimate of **$20–45**, with a
proposed **$60 total cap**, is a planning allowance rather than a quote or spend authorization.
Expected candidate count is unknown until extraction (rough planning range 120–200). There are
eleven initial extraction calls, six controls per scope (66), two checker-family evaluations per
candidate/control, and a veto only after both checkers accept. A flag adds one resample; one stateless
re-extraction round may add up to eleven extraction calls plus checks on rejected candidates.
New pipeline models require 3/3 smoke evidence; the unchanged slate has prior pipeline evidence,
which the conductor must pin, or run the twelve-call four-model smoke again within the cap.

The copied batch `gateway.py` now enforces the cap through `budget.py`, while template originals
remain untouched. It requires `budget_authorization.json` naming the owner's approval, all four model
IDs, and exactly $60. Only a non-authorizing example file exists at preparation time. A free live
roster check rejects price/context increases before the first paid call of each process.

Every HTTP attempt, including a retry, reserves the **entire advertised context window** at the
highest input/output price tier plus the requested maximum output (at most 16,000 tokens). GPT's
8,000-output-token check reserves $4.32. A SQLite `BEGIN IMMEDIATE` transaction synchronizes all
workers and separate processes; committed/reserved amounts cannot exceed $60. Complete bounded
usage settles at undiscounted list price, including reasoning tokens in the completion count.
HTTP errors, timeouts, interrupted workers and missing/unbounded usage retain the full reservation;
an uncertain charge is never released speculatively. Reservations survive restarts. The bound
assumes the provider honors its advertised prices and token limits; unexpected metadata halts work.
Do not delete/reset the meter to recover blocked capacity. Preserve usage-only JSONL locally,
summarize actual list-price cost and unresolved reservations separately, and commit neither raw
logs nor `out/spend.sqlite3`.

## Exact reused pipeline and acceptance gates

Copy `.py` files directly from `scripts/content-seed/reference-pack-template/` into this directory,
never from an older batch. This retains the ownership/admissible-source wording, hook cautions and
pre-load schema guard. The directory depth preserves `gateway.py`'s `parents[3]` key lookup. Keep the
key in the canonical gitignored environment file; never print or copy it into the work order.

1. Export the latest verified taxonomy and the current published usable-reference inventory using
   the same own/alias lookup as `get_topic_point_guides` and the catalog's coverage SQL. Persist a
   small topic manifest: subject, taxonomy source version, unit, topic, title, expected source subject.
2. Write and PDF-check six planted controls for each subject-unit scope. Controls must catch wrong
   factual content, inadmissible/non-CED content, wrong ownership, wrong list/order, wrong hook
   expansion, and content from another unit. A hook control needs a valid entry with an invalid hook.
3. Prepare unit fact-pack excerpts and `CED_TXT_DIR/<subject>.txt`. Use `extract.py --subject ...
   --subject-key ... --unit ... --pages ... --factpack ...`. The Calc CED dump may be copied under
   the AB/BC subject filenames expected by `ced_pages`; both remain the same PDF content.
4. Restrict shared AB extraction to AB taxonomy topics, and BC supplementation to BC-only topics.
   `--only` can supply topic-owned titles from the CED for targeted extraction; preserve the request
   manifest. Selection may exclude out-of-scope candidates but must never rewrite generated rows.
   A BC-only substatement within a shared topic may require a separate BC-owned entry too: compare
   the PDF's BC markers, especially shared 6.14 technique selection, instead of assuming topic-code
   set subtraction alone proves pedagogical completeness.
5. Run batch `check.py` with required per-scope controls and resumable verdicts. The batch copy now
   rejects malformed/inconsistent checker output, missing/extra/duplicate verdicts, incomplete vetoes,
   a leaked control, and a hook control rejected only because its correct entry was rejected. It
   writes a hash-pinned gate receipt only after complete candidate and six-control success. Batch
   `load.py` requires current receipts for every candidate round and reads only those verdict files.
6. Regenerate rejected candidates statelessly from title/owner only using `--only --round 2`.
   After two rounds, escalate repeated rejection with both reasons; do not hand-edit an entry.
   Apply the protocol's ownership test to LO/EK as stated. A checker's first-mention objection does
   not authorize moving an owner. Record any owner override before `--po-accept`.
7. Before load, check the accepted coverage set against the complete missing-topic manifest.
   Zero references on any target topic remains open even if every generated candidate passed.
   Do not add unrelated reuse tags just to make a coverage count zero. Parse every formula with the
   production KaTeX fixture/tooling. Record any topic that cannot support an admissible entry.
8. Generate Development SQL using `load.py`; run its schema checks plus the complete/control gate.
   Apply only after the execution work order covers the exact batch. Run
   `scripts/qa/unit_reference_and_memory_hooks_qa.sql` and rollback-only RPC probes of topic, alias,
   hook/no-hook, unit and empty retrieval. Record counts and content hashes.
9. Production is a separate named protocol gate: approved counts/rollback, identical reviewed SQL,
   repeated QA and own/alias coverage check. Retire hooks before entries on rollback. A reference
   data load needs no frontend publication by itself.

## The additional 166 versions without a topic cell

Read-only Production checks on October 15 found no active selected cell for AB 1, BC 84, Chemistry 81.
All 166 also have **zero rows** in `app.content_item_topic_resolution`, **zero validated same-item
cells** available on another version, and **zero nonempty assessed_topics arrays in any historical
content_taxonomy_labels row**. An exact stem/stimulus/canonical-answer comparison found no other
published version carrying a validated cell to serve as a trustworthy text twin. This rules out
the straightforward validated-label restoration paths; it does not establish that every possible
external authoring manifest has been exhausted.

Twenty BC and 45 Chemistry versions have active validated **serving labels**, which supply units,
not topics. Legacy `prompt_json.topic` hints exist on Chemistry 58 and BC 1. They are leads, not
validated topic decisions. Do not turn a unit label or legacy topic string into a validated cell.

Prepare a second, version-keyed labeling manifest with version ID/content key, current taxonomy,
hash, validated unit constraints, existing authored hint, actual full question/parts, and evidence.
First match exact content IDs into the applicable indexed authoring/QA batch if a trustworthy
already-validated decision exists. Otherwise inspect each item against CED LO/EK using the current
topic-labeling protocol; use its required blind voting/tiebreak process for unresolved cases.
Topic cells may have null skill codes: a skill tie must not prevent a sound topic-only assignment.
Record provenance and guard the version/hash before generating any insert. Rehearse in Development;
the existing serving-label status and unit gates remain authoritative.

For live-eligibility reporting, count the 65 versions with active validated serving labels separately
from provisional/held versions, and check taxonomy hash freshness and the selector's other gates.
The 166 catalog count is all published versions, not proof that all 166 are currently servable.
After each content and labeling tranche, rerun the catalog's coverage query and the actual
caller-scoped More help path. Zero missing references in metadata is necessary but does not prove
an answer-disclosure filter retains a usable source, that images are supported, or that a real help
response passes teaching QA.

## Prepared artifacts and offline verification

- `missing_topic_manifest.json`: 80 live taxonomy targets with exact source-version IDs.
- `scopes.json`: eleven exact extraction scopes, CED PDF page ranges, AB-only/BC-only restrictions.
- `inputs/`: eleven primary-CED unit excerpts and eleven canonical fact-pack excerpts; no generated
  reference rows. `source_provenance.json` pins source PDF/fact-pack and unmodified-template hashes.
- `controls/controls_*.json`: exactly 66 planted controls. Expected defects/source pages live in the
  separate `control_evidence.json`; they are never included in checker prompts. Eleven baseline
  source pages were rendered and visually inspected from the primary PDFs.
- `label_inventory.sql`: SELECT-only version-keyed inventory for the distinct 166-topic-linkage
  investigation. Its Production `EXPLAIN` parsed successfully; it makes no writes.
- `test_guards.py`: **13 offline tests passed**. Concurrent reservation test launches 100 attempts
  across 24 workers and admits exactly thirteen $4.32 reservations (total $56.16); a restarted meter
  refuses the next reservation. A second test launches forty attempts across four separate processes
  and likewise admits only thirteen reservations. Retry tests prove ambiguous attempts remain reserved individually;
  authorization tests prove no transport occurs without approval; control/completeness/hash tests
  reject missing verdicts, leaked controls, hook-only false passes and changed source artifacts.
  All batch Python files compile. No provider call was made by these tests.

Runtime CED page dumps are prepared at `/private/tmp/more-help-reference-ced-text` for this checkout;
set `CED_TXT_DIR` to that directory. They use the expected `ap-calculus-ab.txt`, `ap-calculus-bc.txt`,
and `ap-chemistry.txt` names. Recreate them with `pdftotext -layout` from the pinned PDFs on another
machine. Do not run smoke/extract/check until the owner authorization has been recorded.

## Topic 6.14 source exception — proposed ruling, not applied

The combined Calculus CED **PDF page 131 / printed page126**, topic6.14, contains no Required Course
Content LO/EK block. Instead it states: “Students should be given opportunities to practice when and
how to apply all learning objectives relating to antidifferentiation.” A standalone6.14-owned entry
cannot honestly cite a6.14 LO/EK under protocol §§1.1–1.2. `scopes.json` therefore excludes6.14 as both
owner and reuse until the conductor records the applicable ruling; no override has been applied.

**Proposed owner interpretation:** permit a legitimate earlier-owned integration entry (e.g.6.8 or
6.9, with its actual LO/EK citation and checked content) to include later reuse tag6.14, because6.14
explicitly incorporates all antidifferentiation learning objectives. Preserve the earlier owner and
source evidence, add only the justified reuse tag through re-extraction, and verify AB/BC scope
separately (AB must never inherit BC-only techniques through a6.14 tag). This is a narrow interpretation
of reuse, not permission to invent an entry, a missing LO/EK, or a fictitious source code. If the owner
does not ratify it, leave6.14 explicitly open and report its affected-version count.

## Topic-labeling execution plan and authority

The index routes taxonomy work to `CONTENT_TAXONOMY_RATIONALIZATION_PLAN_2026_09_26.md` and
`TAXONOMY_LABELING_PLAN_V3_2026_08_04.md`; rationalization §Phase3 points to
`APP_REBUILD_MIGRATION_PLAN.md` §6 for the primary-topic method. Its required second source is
author prose or explainer-example retrieval, not simply a second model reading the same CED.
The Units1–3 execution runbook supplies the tested six-vote/tiebreak implementation but does not
make an unresolved topic automatically validated.

Export `label_inventory.sql` and make blind classification packets from full stem/stimulus/choices,
authored parts, rubric/criteria and canonical answers (v3 T5.a), withholding legacy topic/unit tags
from blind measurement packets (T5.b). Keep authored topic prose in a separate second-source lane;
compare it and explainer-example retrieval against the closed current taxonomy. An existing validated
unit label constrains serving and must remain separate from coverage evidence. Require FRQ rubric
preflight before criterion-dependent classification (T4.b), distinguish failed calls from content
risk, and route disagreements through the documented reconciliation/validation flow. Do not use
model self-confidence as a gate. Topic-only cells may use a null skill. Generate version/hash-guarded
inserts with truthful assignment provenance only after evidence is sufficient; do not promote the
59 legacy hints or the conductor's synthetic QA fixture metadata as live topic validation.
