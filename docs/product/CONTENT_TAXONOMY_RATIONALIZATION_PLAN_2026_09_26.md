# Content Taxonomy Rationalization Plan — 2026-09-26

**Status:** Draft for Product Owner review — a plan, not an implementation | **Owner:** David Bloom | **Tier:** Standard
**Follows on from:** `APP_REBUILD_MIGRATION_PLAN.md` §5.4 ("Nothing connects an item to its topic"), §6 ("Closing the
topic-label gap"), §8.1 ("Topic labels — blocking"); `TASK-0047` (the `rubric_type` backfill and item-package dual-read
adapter are the precedent for this class of fix)
**Scope of this document:** the four systems that each answer "which topic (and skill) does this content item
belong to." It recommends one canonical source, says what happens to the other three, phases the migration so the
AP Statistics Course Mode pilot keeps working throughout, and separates David's product/governance calls from
engineering calls. No code was written, no migration run, no Lovable message sent. Everything below was read from
**Cramapple – Production** (`pcntajvbdfqhbeewmdry`), **Cramapple – Development** (`wmgjsdkphcyhngaffbqf`), the
"New Cramapple App" Lovable project (`56cae479-f7c9-4988-b536-56538c38ee4e`) and this repository on 2026-09-26.
Counts are quoted with the query filter that produced them; where a prior document's count differs, the filter
difference is named rather than the discrepancy hidden.

---

## 0. The one-paragraph version

Four things currently express item-to-topic identity, and they have almost no overlap: the 203 AP Statistics pilot
items are tagged in `app.content_item_cells` and have **zero** rows in `app.content_taxonomy_labels`; the 112 AP
Biology items with a topic label are in `content_taxonomy_labels` and have **zero** rows in `content_item_cells`;
the other seven subjects' 727 published items resolve to a topic by **no** route at all; and the Stats frontend
ignores both tables and regex-parses the item's `content_key`, which already fails on 3 of the 203 pilot items in
Production today. The recommendation is to make **`app.content_item_cells`, generalized so that `skill_code` is
optional and a topic-only row is legal, the single write-side table of record for every subject**, with
`app.taxonomy_*` kept as the registry it already is, `content_taxonomy_labels` narrowed to the unit-level
*serving-label* job it actually performs in production, and content-key parsing retired from the frontend once the
served item carries its cell. The in-flight `student-session-items` change is the right *read seam* and should be
kept, but it does not touch the path the Stats pilot actually serves through, and its coarse fallback reads
provisional AI labels that `DECISION-0067` explicitly left unpromoted — so it is a building block, not the
convergence. Seven decisions need David; they are in §7.

---

## 1. The four systems, as verified

| # | System | Where | Grain | Keyed by | Rows (Prod) | Subjects with real data | Live consumers |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | **Content-key string parsing** | Lovable `src/lib/course-mode/stats-unit1-skills.ts` → `pilotCellFromContentKey()` | topic × skill | the item's `content_key` text | n/a (a regex + a 3-entry name map) | AP Statistics only; 200 of 203 pilot keys parse | `scope-mcqs.ts` (unit/topic/cell scoping of the pilot queue), `SessionFrame` skill rail, `retry-order.ts`, home skills rail |
| 2 | **`app.content_item_cells`** | Prod + Dev | topic × skill (`skill_code NOT NULL`) | `content_item_version_id` | **203** (Dev: 212) | AP Statistics only, all 203 published | `persistCellState` (mastery write, `_shared/cell-state-persist.ts`), `app.select_confirm_transfer_item` (RPC), `app.cm_d19_release_template`, and the in-flight `buildResolvedCells` |
| 3 | **`app.content_taxonomy_labels`** | Prod (Dev has 1 row) | `serving` scope = units; `coverage` scope = topics (array, no skill) | `content_item_id` (item, not version) | **2,856** rows across 2 scopes × 5 statuses | Serving/unit labels: all 10 subjects. **Topic labels (`assessed_topics` non-empty): AP Biology only — 112 rows, all `provisional_model` or `stale`, 0 `validated`** | `public.select_unit_gated_practice_items` (units only), `app.servable_items_census` (units only), 3 staleness triggers, and the in-flight `buildResolvedCells` fallback (topics) |
| 4 | **`app.taxonomy_source_versions` / `taxonomy_units` / `taxonomy_topics` / `taxonomy_skills` / `taxonomy_cells`** | Prod + Dev (identical counts: 10 / 72 / 617 / 18 / 131) | registry — what exists, not what is tagged | UUID `taxonomy_source_version` + code | 617 topics; skills and cells seeded for **AP Statistics only** (18 skills, 131 cells) | all 10 subjects | `public.get_student_taxonomy`, every FK on systems 2 and 3, `topic_point_briefs`/`topic_explainers` (by `(subject_key, topic_code)`) |

Facts that shape the recommendation:

- **System 4 is complete and healthy.** 617 topics across 10 CED-verified source versions; `topic_point_briefs`
  and `topic_explainers` are published for 100% of topics in 9 subjects (AP Physics C E&M: 17 of 31). Every one of
  the 112 Biology `assessed_topics` codes resolves to a `taxonomy_topics` row. This layer is the spine; nothing
  here needs rationalizing.
- **Systems 2 and 3 are disjoint sets of items.** Join `content_item_cells` to `content_taxonomy_labels` on
  `content_item_id`: 203 cell items, **0** with any label row of any scope. Join the other way: 112 items with a
  topic label, **0** with a cell. There is no item today where the two tables can even be compared.
- **System 2 is version-keyed and FK-enforced; system 3 is item-keyed and hash-guarded.** `content_item_cells`
  has a composite FK to `taxonomy_cells (taxonomy_source_version, topic_code, skill_code)` — you cannot tag a
  nonexistent cell. `content_taxonomy_labels` has no FK from `assessed_topics` (an array) to `taxonomy_topics`;
  its integrity comes from a staleness hash (`validated_against_taxo_hash` vs `app.taxonomy_relevant_hash()`) and
  trigger functions, all designed for the *unit serving-label* use case.
- **System 3's scope CHECK forbids the hybrid.** `content_taxonomy_labels_scope_payload_check` requires
  `serving` rows to have empty `assessed_topics` and `coverage` rows to have empty `required_units`. The
  2026-08-23 migration that created `content_item_cells` chose a new table for exactly this reason (its header
  comment: "that table's scope CHECK allows only 'serving'/'coverage' and its payload columns are
  unit/topic-shaped, not (topic × skill)").
- **System 1 is a naming convention, not data.** `content_item_cells` and the regex agree on all 140
  `apstat-u1-<t>-<s><letter>` keys and all 60 named-prefix keys (`apstat-summary_stats`, `apstat-compare_stats`,
  `apstat-4b-compare`). The remaining **3 items — `apstat-lsrl_predict-005000/1/2`, tagged `5.3 / 3.B` in the
  database — return `null` from `pilotCellFromContentKey`.** They are published, cell-tagged, and invisible to
  the frontend's cell logic right now.
- **The Stats pilot does not go through `student-session-items` for MCQs.** `src/lib/course-mode/serving-path.ts`
  routes the pilot subject to a direct client read (`buildPublishedMcqQuery`, RLS-scoped) because the pilot items
  carry no validated serving label and the server selector "returns 0 rows for the pilot pack." The client cannot
  read `content_item_cells` (RLS enabled, no policy, grants only to `service_role`/`content_reviewer`/`postgres`),
  hence the regex.

### 1.1 Published-item resolvability today

Filter: `content_items.status = 'published' AND content_item_versions.status = 'published'`, subject via
`exam_pack_versions → exam_packs → subjects`. (The 2026-09-22 tagging run reported 384 AP Statistics items using
only the version filter; the 373 here additionally requires the parent item to be published.)

| Subject | Published | Resolves via cells | Resolves via topic label (any status) | Resolves via **validated** topic label | Has validated unit serving label | Has **no** label row at all | Content key parseable |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| ap-statistics | 373 | **203** | 0 | 0 | 44 | 203 | 200 |
| biology | 118 | 0 | **112** | 0 | 23 | 0 | 0 |
| ap-calculus-ab | 122 | 0 | 0 | 0 | 7 | 0 | 0 |
| ap-calculus-bc | 127 | 0 | 0 | 0 | 4 | 50 | 0 |
| ap-chemistry | 119 | 0 | 0 | 0 | 40 | 0 | 0 |
| ap-precalculus | 117 | 0 | 0 | 0 | 27 | 0 | 0 |
| ap-physics-1 | 117 | 0 | 0 | 0 | 7 | 34 | 0 |
| ap-physics-2 | 68 | 0 | 0 | 0 | 1 | 0 | 0 |
| ap-physics-c-mechanics | 77 | 0 | 0 | 0 | 0 | 0 | 0 |
| ap-physics-c-em | 97 | 0 | 0 | 0 | 1 | 17 | 0 |
| **Total** | **1,335** | **203** | **112** | **0** | 154 | 304 | 200 |

Read: **315 of 1,335 published items (23.6%) resolve to a topic by any route; 0 resolve to a validated one.**
This is the same gap `APP_REBUILD_MIGRATION_PLAN.md` §5.4 measured on 2026-09-22 as "zero of 1,346" — the 112
Biology rows landed on 2026-09-24 (`source = work_order_topic_tagging_2026_09_22`, `label_version = 2`,
`provisional_model`) and the 203 Stats cells pre-date that plan but were not counted by it because it looked only at
`content_taxonomy_labels`. That miscount is itself an instance of the problem this document is about.

### 1.2 A documented contradiction to resolve, not paper over

Three records point in three directions about the Biology topic labels the in-flight code now reads:

1. `APP_REBUILD_MIGRATION_PLAN.md` §6.6 (2026-09-22, David-approved): deferring `assessed_topics` "is off the
   table now — topic is load-bearing on every plate."
2. `DECISIONS_LOG.md` **DECISION-0067** (2026-09-24, David-approved): "Coverage labels stay deferred; no promotion
   work" — justified in part by "nothing in the live product reads `assessed_topics`."
3. The uncommitted `student-session-items` change (2026-09-26) reads `assessed_topics` and would make the Biology
   `provisional_model` labels student-visible (breadcrumb, brief, explainer selection) as soon as it deploys.

Each was reasonable in its moment. Together they mean a 44%-agreement, unvalidated label set becomes
student-facing by side effect of an engineering generalization. §7 item 2 puts that back in front of David.

---

## 2. The actual problem, stated as failure modes

Not "it is confusing." Each of the following is observable in Production today or follows mechanically from the
schema.

**F1 — A feature built against one system silently no-ops for every subject whose data lives in another.**
`needsConfirmTransfer` / `subjectHasCourseModeCells` / the skill rail / `retrySameSkill` / `moveOnToNextSkill` all
key on system 1 or 2. They work for 203 Stats items and do nothing for 1,132 others — including the 112 Biology
items whose topic *is* known, in system 3. Conversely, the unit-gated selector keys on system 3's serving labels
and returns 0 rows for the 203 Stats pilot items, which is why the pilot had to invent a client-side serving path.

**F2 — Two systems can disagree about the same item, and one of them is a string.** The 3 `apstat-lsrl_predict-*`
items are the live case: the database says `5.3 / 3.B`; the frontend says "not a pilot cell." Under any scoped
request (`scope-mcqs.ts` excludes unresolvable keys by design — "fail honest") they are never served; unscoped,
they render with no skill rail and no confirm-transfer beat. Any new generator prefix, or any content-key rename,
reproduces this without a test failing.

**F3 — Nobody can look in one place and answer "is this item's topic actually known?"** Four queries are needed
(cells; coverage labels by status; serving labels; the regex), and `app.servable_items_census` — the function built
to answer servability — reads only serving/unit labels. The migration plan's own §5.4 undercounted for this reason.

**F4 — Two mastery futures.** `app.student_cell_state` has a composite FK to `taxonomy_cells (…, skill_code)`
with `skill_code NOT NULL`. Only AP Statistics has skills seeded (18) and cells (131). Under the current schema, a
Biology item labeled `7.5` can never accrue mastery evidence, and Decision 20's rule ("2 full-point answers, with
hint") is unbuildable outside Statistics — not because the rule is hard, but because there is no row to write.
Today `student_cell_state` holds 6 rows for 2 users across 5 cells.

**F5 — The same subject is split across systems.** AP Statistics: 203 items in cells with no labels; ~170 items
with serving labels and no cells; the 384-label topic proposal QA-accepted on 2026-09-23 (minus 6 boxplot items)
sits on branch `codex/project2-2026-09-23`, applied to nothing. "Which Stats items assess topic 1.9?" has no
single true answer in the database.

**F6 — Item-keyed vs version-keyed labels drift on every new version.** `content_taxonomy_labels` labels the
*item*; `content_item_cells` labels the *version*. The label layer guards the drift with a hash and stale triggers;
the cell layer guards nothing (a new version simply has no cell until re-tagged). Any convergence has to pick one
key and one staleness rule.

**F7 — Dev cannot rehearse Prod's label state.** Dev has 212 cells (Prod 203) and **1** taxonomy label (Prod
2,856). The Dev-then-Prod pattern `TASK-0047` relied on is intact for DDL but meaningless for label data
migrations until Dev is re-seeded.

**F8 — Governance is attached to the wrong table.** `content_taxonomy_labels` carries the full validation
apparatus (`label_status`, `validation_decision_id`, `validated_by/at`, `superseded_by`, `source_payload`,
`model_run_id`). `content_item_cells` carries none of it — its 203 rows are "emission-time authoritative" from the
generator with no status column. Whichever table becomes canonical has to inherit the apparatus or the double-approve
rule in `CONTENT_GOVERNANCE_AND_VALIDATION.md` has nothing to attach to.

---

## 3. Recommended target state

### 3.1 Principle

**One write-side table of record for item → topic (→ skill), keyed by `content_item_version_id`, FK-enforced against
the registry, carrying a primary-topic flag and a validation status. The registry stays the registry. Everything
else is a read-only projection of the table of record.**

### 3.2 Canonical: `app.content_item_cells`, generalized

Keep the table, keep its name (renames are churn with three live consumers), and extend it additively:

| Change | Why |
| --- | --- |
| `skill_code` becomes **nullable**; a row with `skill_code IS NULL` means "topic-level assignment, skill not asserted" | Lets every subject use the one table today without seeding science-practice skills for 9 subjects first. A topic-only row is a genuinely coarser grain, not a missing value — the comment on `RenderCell.skill_code` in the in-flight code already draws this distinction correctly. |
| New FK `(taxonomy_source_version, topic_code) → app.taxonomy_topics` | Postgres does not enforce a composite FK when any column is NULL, so the existing cell FK would silently stop guarding topic-only rows. This FK keeps "cannot tag a nonexistent topic" true for every row. The existing cell FK continues to guard skill-bearing rows. |
| Unique constraint re-declared `UNIQUE NULLS NOT DISTINCT (content_item_version_id, topic_code, skill_code)` (PG 17 supports it; both projects are on 17.6) | Otherwise two topic-only rows for the same topic are legal. |
| `is_primary boolean NOT NULL DEFAULT true` + partial unique index on `(content_item_version_id) WHERE is_primary` | §6.2 of the migration plan: "the new design needs exactly one topic per item." Breadcrumb, brief and explainer are singular. Secondary rows remain legal for coverage reporting. |
| `assignment_status text NOT NULL` with the **same** vocabulary as `content_taxonomy_labels.label_status` (`provisional_model`, `validated`, `stale`, `held`, plus `authored` for generator/author-emitted) and the same `source`, `model_run_id`, `validated_by/at`, `validation_decision_id`, `superseded_by` columns | Moves the governance apparatus onto the table of record instead of leaving it on the table being narrowed. Reusing the vocabulary means the existing `content_taxonomy_validation_decisions` table and the double-approve workflow apply unchanged. |
| A `content_item_topic_resolution` **view**: one row per published version with `topic_code`, `skill_code`, `topic_title`, `unit_number`, `assignment_status`, `is_primary` | This is the "one place to look" (F3). `servable_items_census` gains a topic-known column from it. |

Existing consumers survive unchanged: `select_confirm_transfer_item` joins on `topic_code AND skill_code` (a NULL
skill never matches — correct, a topic-only row can't confirm a *skill* transfer); `buildResolvedCells` already
prefers cells; `cm_d19_release_template` writes skill-bearing rows. **One consumer needs a one-line guard:**
`persistCellState` iterates every cell row for the version and would attempt a `student_cell_state` write with a
NULL `skill_code` — it must filter to skill-bearing rows until §7 item 3 is decided.

### 3.3 Why not the alternatives

| Candidate canonical source | Rejected because |
| --- | --- |
| **System 3, `content_taxonomy_labels.assessed_topics`** | Item-keyed, not version-keyed (F6); an array with no FK to the registry; a scope CHECK that forbids carrying units and topics on one row; a hash/trigger apparatus built for unit serving that would have to be re-derived for topics; and 0 of the 203 items with the only skill-grain data in the product have a row in it. Its live production job — validated unit serving-labels gating `select_unit_gated_practice_items` — is real and should not be disturbed by piling topic semantics onto it. |
| **System 1, content-key parsing** | It is not data. It already fails on 3 items (F2), encodes nothing for 9 subjects, and depends on a generator's naming discipline. Nothing to converge onto. |
| **A brand-new fifth table** | It would have the right shape but no consumers, no rows, and no FKs — and `content_item_cells` already has all three (version key, registry FKs, three live readers). Building a fifth system to retire four is how this situation arose. |
| **A read-only view over cells ∪ labels, no write-side change** | This is what the in-flight `buildResolvedCells` is, in TypeScript. It gives one place to *read* but leaves two places to *write*, so the disjoint-sets problem (F5) and the governance gap (F8) persist. Keep it as the Phase 0 seam, not the end state. |

### 3.4 What happens to the other three

- **System 1 (content-key regex): retired.** `stats-unit1-skills.ts` keeps only what it is documented as — plain-
  language names and descriptors keyed by `(topicCode, skillCode)` — and `pilotCellFromContentKey`,
  `NAMED_PILOT_CELLS`, and the regex are deleted once every served item carries its cell (Phase 2). The `PilotCell`
  type stays; its *source* changes from string to server payload.
- **System 3 (`content_taxonomy_labels`): kept, narrowed to what it does in production — unit serving-labels.**
  `label_scope = 'coverage'` and `assessed_topics` are **frozen**: no new writes, existing 112 Biology rows and the
  177/181 legacy stub rows retained for audit and as the migration source in Phase 1. The staleness triggers,
  `taxonomy_relevant_hash`, and `select_unit_gated_practice_items` are untouched. A follow-up (not this plan) can
  decide whether `required_units` should itself become a derived projection of the primary topic's unit — that
  would collapse the table further, but it is a serving-path change with its own QA and is out of scope here.
- **System 4 (`taxonomy_*` registry): kept as-is.** Only additive seeding if §7 item 1 decides skills matter
  beyond Statistics.

---

## 4. Verdict on the in-flight `student-session-items` generalization

Read in full from the working tree (`git diff` of `_shared/student-item-delivery.ts` and
`student-session-items/index.ts`, +446 lines, uncommitted, not deployed).

**Keep the shape; change what it reads; do not treat it as the convergence.**

What is right about it, and should be preserved:
- `RenderItem.cell: RenderCell | null` with the "absent, never fabricated" rule is exactly the read contract the
  target state needs. When Phase 1 lands, `buildResolvedCells` collapses from two sources to one
  (`content_item_topic_resolution`) with the interface unchanged. No client rework.
- Populating `topic_title` from `taxonomy_topics` uniformly, and refusing to invent a skill on the coarse path, are
  both correct and match §3.2.
- Tests were added on both files (+222 lines), following the repo's pure-function-first pattern.

What is wrong about it as a standalone fix:
1. **It does not reach the surface the Stats pilot uses.** The pilot's MCQ queue comes from the client's
   `buildPublishedMcqQuery`, not from `student-session-items` (`serving-path.ts`). The regex stays load-bearing for
   the only subject with skill-grain data. The edge-function change therefore removes zero of the four systems.
2. **Its fallback path reads `provisional_model` labels with no status filter.** As written, deploying it makes
   the 112 unvalidated Biology topics student-visible, contrary to `DECISION-0067`'s posture and to Risk 5 in the
   migration plan ("labels nobody trusts"). Either gate the fallback on `label_status = 'validated'` (honest: 0
   items today) or get an explicit decision that provisional topics may drive breadcrumb/brief selection (§7 item 2).
3. It reads `assessed_topics[0]` — a "first element of an array" tie-break that is deterministic but not a primary
   flag. Fine while every Biology array has one element (verified: 0 multi-topic rows), fragile the moment a
   coverage-style multi-topic label appears.

Recommendation: commit it behind the status filter in (2), deploy it as the Phase 0 seam, and re-point it in Phase 1.
Do not add more logic to it; the more the dual-read learns, the harder it becomes to retire.

---

## 5. Migration path

Each phase is independently shippable, additive-only where it touches schema, and follows the `TASK-0047`
pattern: Dev first, `get_advisors` after every DDL step, then Production; the Statistics pilot's current behaviour
must be byte-for-byte preserved until its consumers are explicitly switched.

### Phase 0 — Stop the bleeding (this week, no schema, no policy decision needed)

| Step | Risk | Notes |
| --- | --- | --- |
| Record this plan's direction as a decision (`DECISION-00xx`), superseding the "which table?" ambiguity and explicitly noting the §1.2 contradiction as *open*, not resolved | none | Governance only |
| Land the in-flight edge-function change with the coarse fallback gated on `label_status = 'validated'` | low | Yields 0 topic-resolved non-Stats items today, which is the truth. Tests stay green. |
| Add the 3 `apstat-lsrl_predict-*` keys to `NAMED_PILOT_CELLS` **or** accept that they stay dark until Phase 2 | low | A 3-line frontend patch fixes a live defect, but it also deepens system 1. My recommendation: patch it, because it is student-visible today, and delete the whole map in Phase 2. David's call whether a Lovable message is worth it now. |
| Extend `app.servable_items_census` with `topic_known_via_cells` / `topic_known_via_labels` columns | low | Read-only function; makes §1.1 reproducible on demand |
| Re-seed Dev's `content_taxonomy_labels` from a Prod snapshot | low | Prerequisite for any label-data rehearsal (F7). Dev is the CLI-linked project. |

### Phase 1 — Generalize the table of record (Dev → Prod, additive DDL; needs §7 items 1, 5)

1. `ALTER TABLE app.content_item_cells`: drop `NOT NULL` on `skill_code`; add FK to `taxonomy_topics`; replace the
   unique constraint with `NULLS NOT DISTINCT`; add `is_primary`, `assignment_status`, `source`, `model_run_id`,
   `validated_by`, `validated_at`, `validation_decision_id`, `superseded_by`. Backfill the 203 existing rows with
   `is_primary = true`, `source = 'course_mode_generator_f4'`, and the status §7 item 5 decides.
2. Create `app.content_item_topic_resolution` (view) and grant it to `service_role` and `content_reviewer`.
3. Patch `persistCellState` to skip `skill_code IS NULL` rows. Add a test.
4. Migrate the 112 Biology `assessed_topics` rows into cells as topic-only, `is_primary = true`,
   `assignment_status = 'provisional_model'`, `source`/`model_run_id` copied verbatim, keyed to the item's
   current published version. Leave the label rows in place, frozen.
5. Re-point `buildResolvedCells` at the view; delete the label-fallback branch. Interface unchanged.
6. `get_advisors` (security + performance) on Dev and Prod after each DDL step, per precedent.

Nothing in Phase 1 changes what any student sees: the Stats pilot still resolves via regex on its client path, and
non-Stats subjects still resolve to nothing unless §7 item 2 says provisional labels may show.

### Phase 2 — Retire content-key parsing (Lovable project; needs §7 item 7)

The client cannot read `content_item_cells`. Two ways to get the cell onto the pilot's served item:

- **(a) Route the pilot's MCQ queue through `student-session-items`** — a new `mode: "cell_scoped"` that selects
  published MCQs for the pack (mirroring `buildPublishedMcqQuery`'s filters) and returns `cell` per item. Keeps
  codes server-side (INV-1 "store fine, present coarse"). Larger change; touches `use-session.ts`'s serve effect.
- **(b) A student-readable view** `public.published_item_cells (content_item_version_id, topic_code, skill_code)`
  restricted to published versions, joined client-side. Smaller change; exposes codes to the client — though the
  `content_key` already leaks them, so this is not a new exposure in practice.

Then: `scope-mcqs.ts`, `retry-order.ts`, `SessionFrame` and `home-skills-rail.ts` read `item.cell` instead of
`pilotCellFromContentKey(item.contentKey)`; the regex, `NAMED_PILOT_CELLS`, and
`course-mode-pilot-cell-resolution.test.ts` are deleted; `stats-unit1-skills.ts` keeps names/descriptors only.
Regression bar: the 10 pilot skills scope identically on all 203 items (now 203, not 200).

### Phase 3 — Run the topic-labelling protocol into the table of record (needs §7 items 2, 6)

`APP_REBUILD_MIGRATION_PLAN.md` §6 already sets the method (AI-led, closed list, primary-topic agreement, second
source from author prose and explainer retrieval, humans on disagreement). This plan only fixes *where it writes*:
`content_item_cells`, topic-only, `is_primary = true`, `assignment_status = 'provisional_model'` → `'validated'`
through the existing `content_taxonomy_validation_decisions` flow. Seed with the QA-accepted AP Statistics proposal
(378 of 384) if §7 item 6 ratifies it. Target: the remaining 1,020 published items with no assignment.

### Phase 4 — Close the authoring path (needs §7 item 4)

A publish-time check (`content_item_versions.status → 'published'`) that requires exactly one `is_primary` row for
the version — hard or soft per David. Plus the census column from Phase 0 promoted to a launch-readiness criterion in
`SUBJECT_SERVABILITY_CRITERIA.md`. Only after this does "is this item's topic known?" stop being a question.

### What is deliberately not sequenced here

- Collapsing `required_units` into a projection of the primary topic (would touch `select_unit_gated_practice_items`).
- Seeding `taxonomy_skills`/`taxonomy_cells` for non-Statistics subjects (content work; gated on §7 item 1).
- Topic-level mastery (`student_cell_state` with NULL skill) — gated on §7 item 3 and Decision 20.

---

## 6. Low-risk / immediate vs. needs David

| Immediate, engineering-owned | Needs David first |
| --- | --- |
| Phase 0 entirely (status-gate the fallback; census columns; Dev re-seed; 3-key patch) | Whether provisional AI topics may be student-visible (§7 item 2) — blocks any non-Stats topic surface |
| Phase 1 DDL design and Dev rehearsal | Skill granularity beyond Statistics (§7 item 1) — decides whether topic-only rows are the end state or a stopgap |
| Phase 2 code change | Client-visible codes vs server-side routing (§7 item 7) |
| Phase 3 tooling (write target) | Ratifying the 378 Stats labels (§7 item 6); the 203 generator tags' status (§7 item 5) |
| — | Publish gate hard/soft and start date (§7 item 4); topic-level mastery (§7 item 3) |

---

## 7. Open decisions for David

These are product or governance calls. Engineering recommendations are given but are not decisions.

1. **Does skill-level (topic × skill) granularity matter for subjects beyond AP Statistics, or is topic-level
   enough?** Every other subject's CED has science/mathematical practices that could be seeded as skills, but that
   is content work per subject and no product surface outside the Stats pilot uses skill today. *Recommendation:*
   topic required, skill optional; do not seed skills for other subjects until a surface needs them. The schema in
   §3.2 leaves the door open either way.

2. **May `provisional_model` AI topic assignments drive student-facing surfaces (breadcrumb, brief, explainer,
   Open Hand example selection) before validation?** This is the §1.2 contradiction: §6.6 says topic is
   load-bearing now; DECISION-0067 says coverage labels stay unpromoted; the in-flight code shows them. A wrong
   topic here mis-selects the brief and explainer a student reads, not just a report. *Recommendation:* no for
   Oct 2 without a stated error bound — but the cheapest way to get one is the §6.2 re-score of the 15 stored model
   runs for primary-topic agreement, which is nearly free and should be run before this is decided.

3. **Should a topic-only assignment accrue mastery?** `student_cell_state` cannot hold a NULL skill today. Either
   (a) mastery stays cell-only (Statistics) until skills exist per subject, or (b) a topic-level row type is added
   and Decision 20's rule applies at topic grain for everything else. Interacts directly with the mastery-derivation
   rule already recorded in `LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md`. *Recommendation:* (b), because the year-long
   course-mode pivot (per `project_learning_system_course_mode`) already decided the mastery unit is a topic × skill
   cell *with practice as a roll-up*; a topic-only row is that roll-up with no skill yet.

4. **Publish gate: hard or soft, and from when?** A hard gate ("no publish without a primary topic") is the only
   thing that stops the gap reopening, but applied today it would block re-publishing 1,020 items until Phase 3
   completes. *Recommendation:* soft (warning + census) at Phase 1; hard for *new* items from the day Phase 3
   starts; hard for all once Phase 3 hits 100% for a subject.

5. **Status of the 203 generator-emitted Statistics tags.** The 2026-08-23 migration calls them "emission-time
   authoritative" and they carry the AP Stats §3/§10 tags under the D2 SME gate. Mark them `authored` (trusted,
   no further validation) or `provisional_model` (route through the same validation as everything else)?
   *Recommendation:* `authored` — they are deterministic outputs of a template whose cell was chosen by a human, not
   a classifier's guess — but this is a governance call under the double-approve rule.

6. **Ratify the AP Statistics 384-label proposal (QA-accepted 378 / rejected 6) as the Phase 3 seed?** It has
   passed the DECISION-0055 cross-model gate and is unapplied. *Recommendation:* yes, as `provisional_model`, with
   the 6 boxplot items re-labelled `1.9` first.

7. **Client-visible topic/skill codes vs. server-side resolution only (Phase 2a vs 2b).** INV-1 says "store fine,
   present coarse"; the frontend's HARD RULE says never render a code. A student-readable view exposes codes to
   the client though not to the screen, and the `content_key` already does. *Recommendation:* 2a (route through
   `student-session-items`) if the pilot MCQ queue is being touched anyway for the canonical-session-flow work;
   otherwise 2b as the smaller change.

---

## 8. Risks of not doing this

Concrete, from what was observed — not generic.

1. **Every topic-keyed plate feature works for Statistics and silently no-ops for seven subjects.** Breadcrumb,
   habits pair, reference pane, deep dive, Open Hand example selection and study-map aggregation all need a topic
   (§5.4 of the migration plan). With `cell` gated on validated labels: 203 of 1,335 items light up. Ungated: 315.
   For AP Chemistry, Calculus AB/BC, Precalculus and all four Physics courses — 727 published items — the number is
   0 either way, and nothing in the UI says so.

2. **Three published items are already wrong in production**, and the mechanism that made them wrong (a new
   generator prefix, `lsrl_predict`) will recur with every new template family. The next Course Mode content batch
   ships dark for skill features unless someone remembers to edit a regex in a different repository.

3. **Decision 20 cannot be built for any subject but Statistics.** The mastery rule David specified on 2026-09-26
   has no row to write for a topic-labelled item. Launching Biology on the practice path (DECISION-0063) with no
   mastery accrual is a product regression relative to the Stats pilot that will look like a bug.

4. **The topic-labelling run (§6, 1,020 items) will land in the wrong place or two places.** Without a stated
   write target, the natural move is to append to `content_taxonomy_labels.assessed_topics` — item-keyed, array,
   un-FK'd, and unreadable by the pilot — which perpetuates F5/F6 at 5× today's volume. Or worse, a second run
   writes cells for one subject and labels for another.

5. **Launch readiness is being reported from a census that cannot see topics.** `servable_items_census` and the
   per-subject `*_LAUNCH_READINESS_2026_09_2x.md` documents count validated *unit* labels. A subject can pass
   servability with 0% topic coverage; the migration plan's own 2026-09-22 census got the Stats number wrong for
   this reason.

6. **Dev cannot rehearse.** With 1 label row in Dev versus 2,856 in Prod, any label-data migration goes to
   Production untested — the exact failure `TASK-0027` and `feedback_dev_verification_drift` warn about.

7. **The count of systems goes up, not down.** The in-flight change adds a fourth *reader* of topic identity
   (`buildResolvedCells`) beside the regex, the confirm-transfer RPC and the mastery hook. Each is individually
   defensible; collectively they guarantee the next engineer picks a fifth.

---

## 9. Non-goals and boundaries

- This plan does not re-open the labelling *method* (§6 of the migration plan) or DECISION-0055's QA gate; it fixes
  the write target and the read seam.
- It does not change `select_unit_gated_practice_items`, `taxonomy_relevant_hash`, or the serving-label staleness
  triggers. The unit-gated path stays as it is (dark for 8 items product-wide, per `project_serving_path_topology`).
- It does not touch `prompt_json->subtopics` / `modules`; those remain the non-authoritative author hints §6.3 uses
  as a second source.
- It does not decide the Oct 2 launch's dependence on topic coverage — that is §7 items 2 and 4.

---

## 10. Sources verified for this document

**Production SQL (`pcntajvbdfqhbeewmdry`), all read-only:** `information_schema.columns` for the seven tables;
`pg_constraint` (FKs, uniques, CHECKs on `content_item_cells`, `content_taxonomy_labels`, `taxonomy_*`,
`student_cell_state`); `pg_class.relrowsecurity` + `role_table_grants`; `pg_policies` (none on any of the seven);
`pg_proc.prosrc` grep for every function referencing the four systems, with full source of
`select_unit_gated_practice_items`, `select_confirm_transfer_item`, `servable_items_census`,
`get_student_taxonomy`; row counts and the per-subject/scope/status matrix of `content_taxonomy_labels`; the
cells-vs-labels disjointness join; the regex-vs-table agreement check over all 203 cells; the published-item
resolvability matrix in §1.1; briefs/explainers coverage per taxonomy; `student_cell_state` row count.
**Development SQL (`wmgjsdkphcyhngaffbqf`):** row counts of the same tables.
**Lovable "New Cramapple App" (`56cae479-…`):** `src/lib/course-mode/{stats-unit1-skills,confirm-transfer,
pilot-subjects,serving-path,scope-mcqs,home-skills-rail}.ts`, `src/hooks/use-session.ts`,
`src/lib/use-published-mcq.ts`, `src/components/session/{SkillRail,CourseModeRepairPanel}.tsx`.
**Repository:** `APP_REBUILD_MIGRATION_PLAN.md` §1, §5.4–§6.6, §11, §14; `TASK-0047-APP-REBUILD-SECTIONS-7-11.md`;
`LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md` (Decision 17/20 record); `DECISIONS_LOG.md` DECISION-0067;
`TAXONOMY_LABELING_PLAN_V3_2026_08_04.md` header and §7a; migrations `20260804170000_taxonomy_label_layer.sql`,
`20260823130000_course_mode_f4_servable_content_path.sql`; `supabase/functions/_shared/{student-item-delivery,
cell-state-persist}.ts` and `student-session-items/index.ts` including the uncommitted working-tree diff;
`docs/research/bio_stats_topic_tagging_2026_09_22/SUMMARY.md`;
`docs/research/apstats_topic_labels_rework_2026_09_23/qa_report.md`;
`docs/proposals/2026-09-20-topic-reference-layer.md`.
