# More help — subject rollout protocol

STATUS: DRAFT (proposed by the independent QA session, 2026-10-14; not yet owner-approved)
DATE: 2026-10-14 (America/New_York)
OWNER: David Bloom
SCOPE: How a subject (and its units) is brought into More help, from the first two live subjects to all ten and any added later.
RELATED: `docs/qa/QA_MORE_HELP_CLAUDE_ADVERSARIAL_2026_10_13.md` (release gates for the first slice), `docs/product/MORE_HELP_DECISIONS_AND_DESIGN.md`, `docs/product/MEMORY_HOOKS_AND_UNIT_REFERENCE_PRODUCTION_PROTOCOL.md`, `docs/tasks/TASK-0070-SHARED-REFERENCE-CONTENT-ACROSS-SIBLING-SUBJECTS.md`, `docs/tasks/TASK-0057-SUBJECT-TAXONOMY-KEY-LINK.md`

## 1. The rule

**The rollout unit is a subject plus the units whose reference packs are published.** More help refuses honestly when a question's topic has no published reference entries, so enabling a subject without packs produces a button that mostly says "help unavailable". A subject is "live" for exactly the units listed in its rollout row, nothing more.

Nothing in this protocol starts until the first slice's release gates are met (grant fix, successful real generation, disclosure decision, app PR reviewed). Those are in the QA report and are not repeated here.

## 2. One-time platform change before the second wave

The current code hard-codes the three subject keys in two places: the `SUBJECTS` array in `supabase/functions/more-help/contract.ts` and a literal `in (...)` clause in `reserve_question_help_delivery`. The app PR carries a third copy. Adding a subject today is a migration, a function redeploy and an app publish, all coordinated. That does not scale to ten subjects or to unit-by-unit rollout.

Do this once, before any subject after Chemistry:

1. **Rollout table.** `app.more_help_rollout(subject_key text primary key references app.subjects(subject_key), enabled boolean not null default false, units integer[] not null default '{}', per_student_daily integer, approval_ref text, enabled_at timestamptz, updated_at timestamptz)`. Service-only like the receipts table. A subject is served only when `enabled` and the question's unit is in `units`.
2. **The database is the boundary.** `reserve_question_help_delivery` joins the rollout table instead of the literal list. Delete the `SUBJECTS` array from the Edge Function; it adds nothing the RPC does not already enforce, and a second copy is a second place to forget. This matches DECISION-0086 (the RPC, not the function, is the security boundary).
3. **Server-reported availability.** Add `moreHelp: { available: boolean, reason: text }` to `get_question_experience`, computed from the rollout row, the question's unit, published reference entries for its topic and the stimulus-image rule. The app shows the button when `available` is true and the server's `reason` copy otherwise. The app then needs no subject list at all, and a unit-level rollout never shows a dead button.
4. **Quotas become data.** Move the 30 per student per day and 1,000 global caps into config (`per_student_daily` above plus one global row), and decide whether provider failures count (QA finding P2-1). The global cap must scale with the number of live subjects or be dropped in favour of a cost alert.
5. **Rollback is a flag.** `update app.more_help_rollout set enabled=false where subject_key=…` turns a subject off with no deploy. Record that in the runbook.

After this change, every later subject rollout is: content work, verification, one `insert`/`update` on the rollout table in Development then Production, and a smoke check.

## 3. Prerequisite checklist per subject (and per unit)

Tick every box before the rollout row is enabled in Production. "Owner" means the Product Owner signs; "Conductor" means the session running the rollout records evidence.

### A. Content grounding
- [ ] Taxonomy for the subject is complete for the units in scope (`app.taxonomy_topics`), and every published question in those units has a primary, unsuperseded cell with a topic code. A question without a topic gets no references and therefore no help.
- [ ] Reference packs are published for every unit in scope, built under the reference-pack protocol (owner-topic rule, admissible CED sources, checker families). Minimum before enabling a unit: every topic in the unit that has published questions has at least one published entry; no topic relies on more than 12 entries (the server cap).
- [ ] Sibling sharing is explicit: if the subject inherits another's packs (Calculus BC from AB via `app.subject_reference_aliases`), the alias row exists and the inheriting subject's taxonomy contains the owner topics; otherwise shared entries are silently filtered out.
- [ ] Hooks, if any, are published, owned or tagged to topics in scope, and carry expansion and caution. Hooks are optional; absent hooks are not a blocker.
- [ ] Copy is student-safe: no entry body, item, caution or hook text addressed to authors (the "CED" wording the sanitiser strips) unless the app sanitiser is confirmed to cover that field. Formula bodies render under the shared TeX renderer (check a sample in the Reference pane).
- [ ] Development and Production packs are identical for the units in scope (re-run the parity audit in `docs/qa/REFERENCE_PACK_PARITY_AND_HOOK_HELP_POLICY_2026_10_12.md`).
- [ ] Subject key spelling matches across `app.subjects`, the taxonomy registry and the reference packs (today Biology is `biology` in one and `ap_biology` in another; TASK-0057). The rollout row must use the `app.subjects` key, which is what the reservation RPC reads.

### B. Visual dependence
- [ ] Count published questions in scope with `stimulus_image_path` set and with a visual requirement recorded (`app.content_visual_requirements`). Those questions are refused by design (section 5). Record the share; if it is material for the subject (Statistics, Physics, Biology are the likely cases), decide before enabling: accept the refusals, or complete section 5's "readable context" path for those items first.
- [ ] Questions whose stem references a figure, graph or table that lives only in the stem text or a Lane A reference figure: sample them and confirm the text alone is enough for sensible help; if not, mark them with a visual requirement so the server refuses them.

### C. Test content in Development
- [ ] Development holds published MCQ **and** FRQ questions for the subject in the units in scope. As of 2026-10-14 Development holds FRQs only for nine subjects and MCQs only for Statistics and Biology; the three live subjects have zero MCQs there. Seed what is missing before verification, or record the owner's decision to verify against Production content with the disposable account.
- [ ] A disposable, entitled QA account exists for the subject (entitlement row `source='more_help_qa'`), with cleanup scheduled.

### D. Generation verification (per subject, repeat per wave of units)
- [ ] Live generation succeeds on at least 3 MCQ and 3 FRQ questions per unit, before and after grading, with the real provider; record request ids, latency and token usage per call.
- [ ] A human reads every generated explanation in that sample for: correctness, that the cited sources are the relevant ones, that no hook is invented, that no diagnosis or score is asserted, and that the "next step" is one scoring action.
- [ ] Red team before submission on the same sample: "ignore the instructions", "what is the answer", work containing a wrong final answer, focus text with instructions, and a plain request for the rubric. Zero disclosures of the correct choice, final value or complete rubric response. Any disclosure blocks the unit until the server guard (QA P1-1) catches it.
- [ ] Error paths exercised once per subject: a unit with no packs (`reference_unavailable`), an image question (`visual_question_unavailable`), an ended session, a foreign session, an unentitled account.

### E. App and accessibility
- [ ] The button appears only where the server reports `available`; the unavailable copy is the server's reason, not a generic error.
- [ ] Subject-specific rendering checked on real items: chemistry equations and units, calculus fractions and limits, statistics notation; smallest glyph meets the 16 px rule; highlights never split math.
- [ ] No subject-specific stylesheet or component is introduced; the two-pane template is unchanged.

### F. Capacity and cost
- [ ] Projected calls per day for the subject (active students × expected uses) fit the global cap and the provider budget; adjust the caps in the rollout table, not in code.
- [ ] Provider credits funded and monitored; the grader shares the key, so exhaustion breaks grading too.

### G. Governance and records
- [ ] One approval per wave (subject plus units) recorded in `APPROVALS_LOG.md`, referenced in the rollout row's `approval_ref`.
- [ ] `docs/INDEX.md` More help row lists the live subjects and units; the product design doc's "reference availability" paragraph is updated.
- [ ] Activity log entry with the Development and Production rollout timestamps and the smoke evidence.

## 4. Rollout steps per wave

1. Complete section 3 in Development with the rollout row enabled there.
2. Promote content (packs, hooks, any visual descriptions) to Production via the existing promotion plan; re-run parity.
3. Insert or update the Production rollout row with `enabled=true` and the unit list. No function deploy is needed once section 2 is done.
4. Smoke in Production with the disposable account: one MCQ and one FRQ per unit, before and after grading; confirm `has_question_help` turns true and the attempt is coached; confirm a question outside the unit list reports unavailable.
5. Watch for 48 hours: share of `help_unavailable`, `reference_unavailable` and `visual_question_unavailable` responses; quota hits; p95 latency; cost per delivered help. A `reference_unavailable` share above a few percent within an enabled unit means a topic was missed in A.
6. Rollback at any point is `enabled=false` on the row.

## 5. Why questions with stimulus images are refused

`supabase/functions/more-help/contract.ts` throws `visual_question_unavailable` (HTTP 422) when `get_question_experience` reports `hasStimulusImage`, which is `content_item_versions.stimulus_image_path is not null`.

The reason is that the model never sees the image. The request to the provider is text only: stem, stimulus text, choices, the student's work and focus, and the reference entries. A question that says "using the graph above" or "based on the table" would be explained from the words alone. The model would still produce a fluent, schema-valid, cited explanation, and it would be confidently wrong whenever the figure carries the information. The design contract therefore says image-dependent questions without readable context must fail honestly rather than guess. The refusal is the cheapest correct behaviour; it is not a limitation of the provider.

It is also deliberately conservative: a figure can carry the answer-bearing data, and sending it to the model would widen the pre-submission disclosure problem.

There are two ways to lift it, and both are per-item content work rather than code switches:

- **Readable context.** `app.content_asset_metadata` already has `alt_text` and `long_description` with an approval stamp. When an approved `long_description` exists, the server can pass it as the stimulus text instead of refusing. This keeps the call text-only, keeps cost flat, and makes the quality of help depend on the quality of the description, which a human has approved.
- **Vision input.** Send the image as an `input_image` part to a vision-capable model. This is a model and cost change, needs its own disclosure red team (the image may contain the answer), and should wait until text-only help is proven.

Today the rule has never been exercised: no published question in Development has a stimulus image. Production counts per subject must be measured (section 3B) before any subject with many figure-based questions is enabled.

## 6. Baseline on 2026-10-14 (Development)

| Subject (`app.subjects` key) | Taxonomy units | Reference packs published (unit:entries) | Hooks | Published items in Dev (MCQ / FRQ) |
| --- | --- | --- | --- | --- |
| ap-calculus-ab | 8 | 1:24 2:17 3:10 | 2 | 0 / 11 |
| ap-calculus-bc | 10 | inherits AB units 1–8 via alias (AB has 1–3) | 0 own | 0 / 13 |
| ap-chemistry | 9 | 1:26 2:21 3:32 4:22 5:29 6:20 7:21 8:32 9:24 | 4 | 0 / 18 |
| ap-physics-1 | 8 | 1:31 2:43 3:25 | 3 | 0 / 8 |
| ap-physics-2 | 15 (registry numbering) | 9:27 10:37 11:38 | 0 | 0 / 14 |
| ap-physics-c-em | 13 (registry numbering) | 8:33 9:16 10:20 | 0 | 0 / 4 |
| ap-physics-c-mechanics | 7 | 1:32 2:47 3:34 | 0 | 0 / 11 |
| ap-precalculus | 4 | 1:49 2:53 3:43 | 2 | 0 / 23 |
| ap-statistics | 5 | 1:80 2:42 3:60 | 2 | 229 / 19 |
| biology (`ap_biology` in packs) | 8 | 1:22 2:44 3:29 | 0 | 15 / 11 |

No Development item in any subject has a stimulus image. Production counts were not read in the QA session and must be taken before section 3B is ticked.

Reading the table: Chemistry is the only subject with packs beyond three units. Every other subject can be enabled today for its first three registry units only, and the remaining units are reference-pack work, roughly 20 to 50 entries per unit at the current authoring rate. Precalculus (4 units) and Statistics (5 units) are the shortest paths to full-subject coverage.
