# Memory Hooks: Mnemonics, Acronyms, Phrases, and Songs as a Content Element

STATUS: PROPOSED — awaiting Product Owner decisions (§9). Nothing here is built, published, or approved.
DATE: 2026-10-08
OWNER: Product Owner (David Bloom). Idea source: Micah Bloom (co-founder, marketing / go-to-market).
RELATED: `COURSE_HOMEWORK_CONSOLIDATION_PLAN.md` §3 (skill scaffolds, "memory aid" element, grain OPEN);
`TOPIC_BRIEFS_AND_LEARN_MORE_PRODUCTION_PROTOCOL.md` (Deep Dive, unit reference, row limits);
`tasks/TASK-0054-REFERENCE-CONTENT-MODEL.md`; `research/CONTENT_AUTHORING_AND_QA_PROTOCOL.md` v0.6.

## 1. The ask

Micah's idea, relayed by David on 2026-10-08: whenever a subject has an important formula or
list, connect it to a memory device: a mnemonic, an acronym, a song, a phrase. The example given
was "Kings Play Chess On Funny Glass Stools" for the Linnaean ranks (Kingdom, Phylum, Class,
Order, Family, Genus, Species).

This document scopes that idea against the records that already exist, proposes a shape, and
lists the decisions David has to make before anything is authored.

## 2. What the records already say

1. **It is already on file as part of a larger proposal.** `COURSE_HOMEWORK_CONSOLIDATION_PLAN.md`
   §3 proposes a "skill scaffold" package (skill description, key vocabulary, diagram, memory
   aid), using the same taxonomy mnemonic as its example. Review flagged the grain as **OPEN**:
   the first draft said "one per skill", but a taxonomy mnemonic is content knowledge tied to a
   topic, not a cross-topic skill. That OPEN item was never resolved. This document resolves it
   for the memory-aid element only (§5); vocabulary and diagrams stay with §3.
2. **One memory hook is already live.** The AP Chemistry 4.9 explainer's `practice_bridge` says
   "write OIL RIG in electron-placement form" (migration
   `20260826125459_ap_chemistry_unit4_chemical_reactions_topic_guides.sql`). It is prose inside a
   free-text field, so nothing can list, count, render, or QA it as a hook.
3. **The CED sometimes avoids the mnemonic on purpose.** The AP Chemistry fact pack notes that
   the CED states solubility "via IMF-similarity language rather than the mnemonic itself"
   ("like dissolves like"). That is the pedagogical rule in one line: **a hook is for recall; the
   points come from CED language.** A hook must never be presented as the answer wording.
4. **The Deep Dive already has a home for this.** The protocol's Phase 1 website pilot (AP
   Statistics 1.7) defines a linked **Unit reference** "for shared formulas, vocabulary,
   representation guidance, cross-topic traps, and unit notes", plus a row-limited Deep Dive. A
   memory hook is a small, row-limited block that fits both. The Open Hand screen already renders
   a reference pane from the topic guide (`STUDENT_HUB_UNIFIED_RECOMMENDATION_2026_10_07.md` W3).
5. **The reference tables are plain-text keyed with no FK.** `app.topic_explainers` and
   `app.topic_point_briefs` key the taxonomy as text (`TASK-0054`). A new hooks table should not
   repeat that; it should land on whatever key `TASK-0054` settles, or at minimum use the same
   `(subject_key, topic_code)` pair and the same QA script.

## 3. The first check: does the example earn AP points?

**Micah's example does not.** The AP Biology CED has no Linnaean-rank learning objective. Topic
7.9 (Phylogeny) is about cladograms and phylogenetic trees: nodes as most recent common ancestor,
shared derived characters, molecular versus morphological evidence (`AP_BIOLOGY_CED_FACT_PACK.md`,
LO 7.9.A/B). KPCOFGS is a middle-school and Biology-1 staple, not an AP scoring move.

This is not a strike against the idea. It is the inclusion rule the idea needs:

> A memory hook is admissible only when the thing it helps recall is an ordered sequence, a
> list, a formula structure, or a sign/direction convention that a CED learning objective or
> scoring guideline actually requires a student to reproduce or apply.

Everything else is trivia, and a student who studies trivia for a cram exam is being misled by
the product. "A forced mnemonic is worse than none" (§3 of the consolidation plan) stands.

## 4. What a memory hook is (and is not)

| Kind | Example (unvetted) | Notes |
| --- | --- | --- |
| Acronym | SOCS: shape, outliers, center, spread (AP Statistics 1.6–1.7) | Letters stand for list items. |
| Acrostic | "Lo d-hi minus hi d-lo, over lo lo" (quotient rule, Calculus 2.9) | A sentence encodes an ordered structure. |
| Phrase / rule of thumb | "The mean chases the tail" (mean vs median under skew, Statistics 1.8) | Direction or sign conventions. |
| Formula sentence | "Oxidation Is Loss, Reduction Is Gain" (Chemistry 4.9, already live) | Spoken form of a definition. |
| Visual cue | Right-hand rule gesture (Physics 2 / C: E&M magnetism) | Only where the visual-stimulus architecture already renders it. |
| Song / jingle | — | **Excluded from v1.** See below. |

**Songs.** Existing songs are out: Cramapple never reproduces lyrics, and a student-facing
product cannot carry a third-party song without a licence. Original Cramapple jingles are
possible but are an audio production line (recording, rights, accessibility captions, playback
in the plate) with no existing pipeline. Recommend: out of v1, revisit if a text-hook pilot shows
students using hooks at all.

**Not a hook:** restating the formula, a definition, a worked example, or the CED wording. Those
already have fields.

## 5. Grain (resolves the §3 OPEN item for this element)

**Proposed: topic-owned, unit-rolled-up, never skill-grain.**

- A hook belongs to one or more **topic codes** in one subject. The owning topic is where the
  student first needs it; additional topic codes let the same hook surface again later (OIL RIG
  belongs to Chemistry 4.9 and is useful again in Unit 9 electrochemistry).
- The **unit reference** lists every hook owned by any topic in that unit. No separate
  unit-level authoring.
- No `skill_code`. A memory hook recalls content, not a skill. This is the exact objection the
  review raised against "one per skill", and it holds.
- Subject-wide hooks (a rule that applies across units) are simply hooks with topic codes in
  several units; no third grain is needed.

## 6. Where the student sees it

1. **Deep Dive, "Remember it" block.** One hook, owned by the topic, under `Understand`. Row
   limit 2 (hook text) + 2 (expansion), overflow treatment: cut the expansion to the list
   itself. Shown only when a published hook exists; no empty block.
2. **Unit reference, "Memory hooks" list.** Every published hook in the unit, hook text plus
   expansion, grouped by owning topic.
3. **Open Hand reference pane.** Same payload as the Deep Dive block, because the pane already
   renders from the topic guide.
4. **Not in hints, not in post-miss feedback, in v1.** Hint use is now recorded and counted
   (`APPROVAL-0130`); pushing hooks into the hint path changes what a hint is and what the
   assistance events mean. Defer to a separate decision.

Each surface must carry the one-line caution with the hook when the CED wording differs from
the hook ("Say it in IMF terms on the exam, not as 'like dissolves like'").

## 7. Data model

**Option A: a nullable `memory_hook` text column on `app.topic_explainers`.** Smallest change.
Limits: one hook per topic, no kind, no multi-topic reuse, no caution field, and the public view
must be recreated in the same migration or PostgREST returns 400 (recorded trap).

**Option B (recommended): a small table.**

```
app.topic_memory_hooks
  memory_hook_id   uuid pk
  subject_key      text        -- canonical underscored key, same check as topic_explainers
  owner_topic_code text        -- ^[0-9]+\.[0-9]+$
  topic_codes      text[]      -- includes owner; every element must exist in taxonomy_topics
  kind             text        -- acronym | acrostic | phrase | formula_sentence | visual
  hook_text        text        -- the thing the student says
  expands_to       jsonb       -- ordered [{"cue":"S","means":"shape"}, ...]
  when_to_use      text        -- one sentence
  caution          text null   -- CED-language warning, when the hook is not the answer wording
  status           text        -- draft | published | retired
  source_note      text        -- cramapple-authored | public-domain-common | ...
  published_at, created_at, updated_at
```

Plus: a `public` view with the student-safe columns; `public.get_topic_point_guides` extended to
return `memoryHooks[]` alongside the brief and explainer (so the frontend keeps one read path);
the `TASK-0054` zero-orphan QA script extended to cover `topic_codes`. Follow the same publish
rules as briefs (subject active, `published_at` preserved on idempotent re-runs).

Either option is a Standard-tier schema task with a **Hard-Gate Production apply**. Nothing in
this document changes the schema.

## 8. Governance and authoring

- **INV-3 applies.** Hooks are authored content: no unvetted generation reaches a student.
- **Authoring path:** reuse the generate-and-select method (`CONTENT_AUTHORING_AND_QA_PROTOCOL.md`
  v0.6 §0): candidates proposed per topic from the CED fact pack, two checker families from
  different model families verify (a) the expansion is factually right against the fact pack,
  (b) the owning topic code is right, (c) the inclusion rule in §3 is met, (d) the caution is
  present where the CED wording differs. Reject-only; no hand edits. Expect most topics to
  produce **no** hook, and treat that as the correct outcome.
- **Rights and originality.** Common mnemonics (OIL RIG, SOCS, ROYGBIV) are short public phrases
  in general circulation; record them as `public-domain-common` in `source_note`. Do not lift a
  publisher's novel phrasing or any lyric. Cramapple-original acrostics are `cramapple-authored`.
  The consolidation plan already names this as "a narrower version of the sourcing question in
  §4"; the `source_note` value is how it gets answered per row.
- **No College Board implication.** Same rule as every other guide row.

## 9. Decisions needed (Product Owner)

| # | Decision | Recommendation |
| --- | --- | --- |
| D1 | Grain | Topic-owned with `topic_codes[]`, unit roll-up, no skill grain (§5). |
| D2 | Inclusion rule | CED point-bearing sequences, lists, formula structures, sign conventions only (§3). |
| D3 | Data model | Option B table + view + RPC extension (§7). |
| D4 | Songs | Out of v1; text hooks only (§4). |
| D5 | Surfaces | Deep Dive block, unit reference list, Open Hand pane; not hints (§6). |
| D6 | Pilot | AP Statistics Unit 1 (the Deep Dive pilot unit) plus AP Chemistry Unit 4 (OIL RIG already live), ≤ 8 hooks total, before any wider survey. |
| D7 | Priority | Not launch gating. Sequence after `TASK-0054`'s FK decision so the table lands on the right key. |

## 10. Candidate inventory (sizing only; every row unvetted)

Topic codes marked `?` were not checked against the CED fact pack this session and must be
before authoring. This list exists to show the element is thin by design, not a glossary.

| Subject | Hook | Recalls | Topic |
| --- | --- | --- | --- |
| AP Statistics | SOCS | shape, outliers, center, spread | 1.6–1.7 |
| AP Statistics | "mean chases the tail" | mean vs median under skew | 1.8 |
| AP Chemistry | OIL RIG | oxidation = loss, reduction = gain | 4.9 (live) |
| AP Chemistry | HOFBrINCl ("Have No Fear Of Ice Cold Beer") | the seven diatomic elements | ? |
| AP Chemistry | "like dissolves like" | solubility by IMF similarity; **caution required** | 3.10 |
| AP Biology | PMAT | mitosis phase order | 4.5? |
| AP Biology | KPCOFGS | Linnaean ranks | **excluded, not in CED** |
| AP Calculus AB/BC | "lo d-hi minus hi d-lo, over lo lo" | quotient rule structure | 2.9 |
| AP Calculus BC | LIATE | integration-by-parts choice of u | 6.11 (BC) |
| AP Precalculus | ASTC ("All Students Take Calculus") | sign of trig functions by quadrant | ? |
| AP Physics 2 / C: E&M | right-hand rule | direction of force / field | ? |

Physics 1 and Physics C: Mechanics produced no obvious candidate in this pass; that is
consistent with the inclusion rule, not a gap to fill.

## 11. What this document does not do

No schema change, no content authored or published, no frontend change, no Lovable message, no
approval claimed. The Deep Dive protocol's row-limit table is not edited; the proposed "Memory
hook" row (2 + 2) is added there only if D5 is approved.
