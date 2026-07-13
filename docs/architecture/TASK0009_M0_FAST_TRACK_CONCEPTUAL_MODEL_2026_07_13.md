# TASK-0009 M0 Fast-Track Conceptual Model

**Status:** Proposed
**Date:** 2026-07-13
**Authority:** TASK-0009 / DECISION-0038
**Scope:** Conceptual model and TASK-0017 H1/H2 handoffs only; no physical DDL, migration, or environment application

## Ratification recommendation

Ratify the two fast-track slices below as the conceptual authority for TASK-0017 physical-design proposals, subject to Product Owner Hard-Gate review. The model is directional:

- `content_items` is the stable question identity within an `exam_pack_version`;
- `content_item_versions.id` is the only canonical immutable question-version identifier for authoring, review, grading, attempts, manifests, and serving;
- `artifact_versions` is not a parallel question record and receives no new question writes;
- the legacy `artifact_version_ids` manifest field is a compatibility carrier pending the separately approved manifest-relation migration; and
- taxonomy is versioned per `exam_pack_version`, so the prior nine-unit AP Statistics scheme and the 2026-27 five-unit scheme coexist without retagging history.

## M0 current-state and gap inventory

| Concern | Current repository model | Conceptual decision / gap |
|---|---|---|
| Stable question identity | `content_items.id`, unique content key within `exam_pack_version` | Retain as canonical stable identity. A new annual pack creates new pack-scoped identities; explicit lineage may connect equivalent questions across packs. |
| Immutable question version | `content_item_versions.id` + `version_num`, but payload/status columns remain updateable | Retain ID as canonical. Conceptually freeze learner-visible payload after review/publication; lifecycle changes become append-only events/projections. |
| Legacy artifact identity | `artifact_versions` exists from rejected governance proposal; reported 0 Production rows | Do not backfill or dual-write new question records. Preserve table only for non-question governance artifacts or later retirement decision. |
| Manifest members | `exam_pack_manifests.artifact_version_ids` UUID array | Values currently carry canonical content-version IDs. Replace with ordered `exam_pack_manifest_content_versions`; retain verified compatibility reads during migration. |
| Item shape | Stem/prompt JSON plus `mcq_choices` and `frq_criteria`; `frq_form` is coarse compatibility metadata | Compile the versioned ItemPackage into canonical content version plus immutable structured children. Archetype identity is separate and versioned; `frq_form` remains projection-only. |
| Stimuli/assets | Text/prompt JSON and response-asset work exist, but no unified immutable stimulus-package identity | Introduce versioned stimulus-package/asset concepts; manifest and item version pin exact versions. |
| Taxonomy | `content_labels` belongs to `exam_pack_id`, unique by `(exam_pack_id,label_key)`; assignment is on `content_items` | Cannot represent simultaneous nine-unit/five-unit schemes safely. Introduce scheme and scheme-version identity scoped to exact `exam_pack_version`; assign exact content versions to exact taxonomy-node versions. |
| Archetypes | Mostly strings/JSON (`frq_form`, rubric-routing fields) | Introduce stable archetype identity plus immutable archetype version; ItemPackage pins the exact version. |
| Historical attempts | `attempts.content_item_version_id` already pins exact canonical version | Preserve without remapping. Taxonomy reporting resolves through the assignment effective for that exact content version. |

## Slice A — immutable item-package and archetype identity

### Conceptual entities

```text
ExamPackVersion
  1 ── * ContentItem                 stable pack-scoped question identity
          1 ── * ContentItemVersion exact immutable learner-visible version
                   * ── 1 ArchetypeVersion
                   1 ── * ItemPartVersion
                   1 ── * StimulusUse ── 1 StimulusPackageVersion
                   1 ── * TaxonomyAssignment ── 1 TaxonomyNodeVersion

Archetype
  1 ── * ArchetypeVersion
          1 ── * ArchetypePartDefinition / criterion requirements
```

### Identity and immutability rules

1. `ContentItem` is identified by the existing `content_items.id`; its pack-scoped `content_key` is a durable natural key, not the version identifier.
2. `ContentItemVersion` is identified only by existing `content_item_versions.id`. `version_num` orders revisions within one item and may never be reused.
3. An ItemPackage creates or reconciles one exact `ContentItemVersion`. Package ID, content key, and package version do not create a parallel database identity.
4. Learner-visible payload includes stem, stimuli, parts/subparts, choices, criteria, accepted variants, accessibility representations, response modalities, deterministic-check declarations, and canonical content hash. Once review evidence targets that version, payload correction creates a successor version.
5. Status fields are rebuildable serving projections. Review decisions, publication events, retirement, withdrawal, and supersession are append-only authoritative records.
6. `Archetype` is the stable pattern identity (for example `frq-inference`). `ArchetypeVersion` is immutable and pins total points, allowed/required part structure, practices, modalities, and criterion contract. An ItemPackage pins one exact archetype version.
7. The four AP Statistics FRQ archetypes are separate versioned identities. Q1–Q4 are not encoded through `short`/`long`; that field is a legacy projection derived where necessary.
8. Stimulus packages and assets are immutable versions referenced by ordered use records. Alt text/long descriptions belong to the exact asset/stimulus version and are part of its hash.

### Package-to-canonical mapping

| ItemPackage field | Canonical conceptual target |
|---|---|
| `content_key` | `ContentItem.content_key` within exact `ExamPackVersion` |
| `content_version` | `ContentItemVersion.version_num`; compiler resolves/creates canonical UUID |
| `exam_pack_ref` | Exact `ExamPackVersion`, never inferred latest |
| `archetype_ref` | Exact `ArchetypeVersion` |
| `taxonomy_refs` | Exact `TaxonomyNodeVersion` assignments |
| `stimuli[]` | Ordered `StimulusUse` records to immutable stimulus/asset versions |
| `parts[]` / `subparts[]` | Ordered immutable item-part versions |
| criteria/checks | Immutable criterion definitions and data-only verifier requirements |
| `provenance.content_sha256` | Input assertion; compiler recomputes canonical hash server-side |
| `legacy_projection.frq_form` | Rebuildable compatibility output; never identity or authoring authority |

### Compatibility/migration decision

- No question ItemPackage creates an `artifact_versions` row.
- Existing `artifact_versions` rows, if any later appear in an environment, require classification by artifact type before retirement; they are never automatically mapped by UUID shape.
- Legacy `exam_pack_manifests.artifact_version_ids` values are accepted as content-version references only when every UUID resolves unambiguously to `content_item_versions.id`. Ambiguity blocks migration.
- The new ordered manifest relation is the eventual authority. Pre-cutover manifests remain immutable historical evidence and may use a compatibility view.

### TASK-0017 H1 handoff

H1 may now propose physical storage/compiler design for the ItemPackage schema under these constraints:

1. write/reconcile `content_items` and `content_item_versions`, not `artifact_versions`;
2. create immutable archetype-version references capable of representing AP Statistics Q1–Q4;
3. preserve exact version IDs through review, validation, attempt, grading, and manifest paths;
4. make structured stimuli/parts/criteria canonical or losslessly referenced, with deterministic semantic snapshot tests;
5. reject executable verifier code and unsupported modalities before persistence; and
6. remain design-only until a separate physical-design/migration approval ID is recorded.

## Slice B — multi-scheme taxonomy per exam-pack version

### Conceptual entities

```text
ExamPackVersion
  1 ── * TaxonomyScheme             e.g. College Board framework, internal skill map
          1 ── * TaxonomySchemeVersion
                  1 ── * TaxonomyNodeVersion
                          * ── * TaxonomyNodeRelation

ContentItemVersion
  1 ── * TaxonomyAssignment ── 1 TaxonomyNodeVersion
```

### Scope and version rules

1. A `TaxonomyScheme` has a stable scheme key within one exact `exam_pack_version`; several schemes may coexist for that pack.
2. `TaxonomySchemeVersion` is immutable. Changes to node labels, hierarchy, source mapping, or semantics produce a successor scheme version.
3. `TaxonomyNodeVersion` carries stable node key, node type, label, ordinal, source references, and scheme-version identity. Node relationships support hierarchy and future non-tree relationships without overwriting prior structure.
4. `TaxonomyAssignment` attaches an exact `content_item_version_id` to an exact node version with assignment role (primary/secondary/practice/objective) and evidence/provenance.
5. Assignments are version-level, not `content_items`-level, because a revised payload can assess different skills while retaining stable item identity.
6. Historical attempts and reports resolve the taxonomy pinned to the attempted content version. Publishing a new scheme never retags old attempts.
7. Crosswalks between schemes/packs are explicit versioned evidence records with relationship type and confidence; they never collapse two node identities.

### AP Statistics coexistence

- The May 2026 pack retains its historical nine-unit taxonomy and labels.
- The May 2027 / `2026-27` pack receives a distinct five-unit scheme plus the four statistical practices.
- Remapped content creates explicit crosswalk/assignment evidence; no in-place rename of old units occurs.
- Removed-topic nodes remain historical and may be marked out-of-scope for the new pack, but are not deleted.
- The new Q1–Q4 archetypes reference practices/nodes in the exact 2026-27 scheme version.

### Legacy-label compatibility

`content_labels` and `content_item_labels` remain projections during transition. Because they are scoped to `exam_pack_id` and item identity, they cannot be authoritative for multi-year or version-specific taxonomy. A compatibility projector may emit unique display labels from the canonical scheme/node assignments; conflicting label keys must be namespaced or block projection rather than overwrite history.

### TASK-0017 H2 handoff

H2 may now propose a physical taxonomy compiler under these constraints:

1. every scheme/version is scoped to an exact `exam_pack_version_id`;
2. assignments target canonical `content_item_versions.id`;
3. annual revision is additive and preserves prior schemes, content, attempts, and calibration evidence;
4. `create-subject` and `create-exam-pack-version` are idempotent explicit operations;
5. crosswalks/remaps are explicit versioned records, never inferred from matching labels;
6. AP Chemistry reconciliation remains scaffold-only and invokes no publication path; and
7. no DDL or environment application occurs without the separate approval required by DECISION-0038/0039.

## M0 blocking questions for physical design

These do not block conceptual ratification but must be resolved before physical DDL approval:

1. Whether structured item children are normalized authoritative rows or canonical JSON plus indexed projections; either choice must preserve one deterministic content hash and lossless round-trip.
2. Whether archetype definitions share the generic immutable-version mechanism for non-question governance artifacts or use dedicated tables. They must not reuse question `artifact_versions` as a second question identity.
3. Exact retention/withdrawal behavior for source-linked stimuli and assets after rights expiration.
4. Compatibility-view lifetime and observed-zero-reader threshold before retiring legacy taxonomy/manifest fields.
5. Required indexes, RLS policies, grants, triggers, and concurrency controls; these are intentionally deferred to the separately approved physical-design task.

## Review decision requested

Product Owner/TASK-0009 reviewer should approve, request changes, or reject each slice independently. Approval authorizes preparation of slice-specific physical-design proposals only. It does not authorize schema creation, migration application, Dev staging, Production publication, or task closure.
