# Cheat Sheet / Deep Dive digestibility — AP Chemistry 2.1 case study (2026-10-30)

Status: recommendation only. Uncommitted. Read-only investigation; nothing edited or deployed.

## Evidence limits
- `https://app.cramapple.com/learn/ap-chemistry/2/2.1` redirects to sign-in, and the session cannot authenticate. The rendered page and mobile layout were NOT seen.
- Findings come from the render path in `david-bloom/ap-prep-blueprint` (read via `gh`) and the 2.1 brief seed text in `docs/product/AP_CHEMISTRY_UNIT2_TOPIC_POINT_BRIEFS.md`. The live 2.1 explainer, reference entries and hooks were not read (they sit in Supabase). Verify against a signed-in view before sizing the work.

## Where it is generated, stored, rendered
- Authored: Markdown in `docs/product/AP_*_TOPIC_POINT_BRIEFS.md` and explainers. Protocol: `docs/product/TOPIC_BRIEFS_AND_LEARN_MORE_PRODUCTION_PROTOCOL.md`. Reference entries and memory hooks: `MEMORY_HOOKS_AND_UNIT_REFERENCE_PRODUCTION_PROTOCOL.md`, TASK-0054.
- Stored: `app.topic_point_briefs`, `app.topic_explainers`, reference entries, memory hooks. Read through `public.get_topic_point_guides`.
- Rendered: route `src/routes/_authenticated/learn.$subjectKey.$unitNumber.$topicCode.tsx` -> `selectedTopicNotes` (`src/components/home/HomeStudyActions.tsx`) -> `mapOpenHandGuides` (`src/lib/open-hand/presentation.ts:244-323`) -> `LessonNotesPage`. The `deepDive` it returns is one flat `sections[]` list.

## Duplication found
`mapOpenHandGuides` builds two groups: "worked" (explainer fields, falling back to the brief) and "full" (brief fields plus explainer extras). It de-duplicates only on exact string equality (`seen.has(body)`), so near-identical text survives. Sections that restate each other:
- "Core idea" (explainer.coreIdea or brief.whatItIs) vs "What it is" (brief.whatItIs).
- "What to understand" (explainer) vs "Why it matters" (brief).
- "How points are earned" appears twice, from explainer and brief, with different wording.
- "The answer move" and "Common point loss" echo the weak/point-attaining "Mini example", and the same answer move appears in the explainer, brief and practice bridge.
- "Vocabulary", "Formulas and rules" and "Unit N reference" repeat vocabulary and reference entries; "Remember it" repeats hooks that also sit in the Unit reference.
- Brief seed for 2.1: "What it is" = four sentences; "Why it matters" restates later topics 2.2/2.3/2.4/2.7; "How points are earned" and "Answer move" both say "state the electronegativity comparison and classify".

## Five recommendations (prioritized)
1. Collapse to one canonical section set; delete the "worked" vs "full" double render. [Frontend + content]
   Problem: the same facts render under 2-3 headings. Change: render once, in a fixed order — Core idea, Answer move, Common point loss, Worked example, Reference — taking each field from exactly one source (explainer wins, brief only as fallback, never both). Why: a cramming student reads each fact once.
2. Add a top "30-second" block, with everything else below it. [Frontend + content]
   Problem: no visible hierarchy; sections are flowing prose. Change: a block of at most 5 one-line bullets (what it is, the trap, the answer sentence, 1 formula/trend, 1 hook). Why: it is the real cheat sheet; the rest is the deep dive.
3. Turn prose into structured components. [Content/pipeline]
   Problem: "What it is" and "How points are earned" are 60-90-word paragraphs. Change: author these as short bullet fields, a trend table (electronegativity difference -> bond type -> evidence), and a "Weak vs point-earning" two-column pair. Why: scannable, comparable, memorable. Needs a schema/protocol change and a regeneration pass; bound by existing generate-and-check rules (never hand-patch).
4. Cap length per section, with a validator. [Content/pipeline]
   Problem: nothing stops overlong or overlapping text. Change: add word caps (about 40 per bullet block) and a pairwise near-duplicate check (embedding or n-gram overlap between brief and explainer fields) to the topic-guides QA gate. Why: stops regression after the rewrite and finds duplicates across all subjects, not just 2.1.
5. Progressive disclosure for the deep dive. [Frontend]
   Problem: everything is open at once (long flowing notes, plus Unit reference at the bottom). Change: Cheat Sheet always open; Deep dive sections (mini example, vocabulary, full unit reference) as instant-toggle disclosures, with print/copy export still expanding everything. Why: shorter first screen on mobile, and students can find a section by heading.

## Design-rule notes (cramapple-design skill, DECISION-0075)
- The skill's README still states the fixed never-scroll, never-collapsed plate; D3 supersedes it (responsive, vertical scroll allowed). The disclosure in #5 needs no motion (D4 zero motion; instant toggle, no animation) and should be checked against the "no collapsed region" wording; I treated that as stale per D3 but David should confirm.
- Square corners, light only, brand orange; teal cap is the "deep dive" pane voice, green for reference; reuse them rather than new colors.
- Plain 'hint gate' (cost shown before reveal) applies to hints, not to reading material; do not gate the cheat sheet.

---

# Follow-up (2026-10-30): data lineage, act-on paths, images
Labels: READ = seen in a query/file this session; INFERRED = reasoned, not verified. Data pulled from **Production** (`pcntajvbdfqhbeewmdry`), SELECT only, no writes.

## 1. What feeds the page (READ)
Route `learn.$subjectKey.$unitNumber.$topicCode.tsx` -> `fetchTopicGuides` -> `public.get_topic_point_guides(subject, unit, topic)` (plpgsql, SECURITY DEFINER, status='published'). It returns: `briefs` (`app.topic_point_briefs`), `explainers` (`app.topic_explainers`), `reference` (`app.unit_reference_entries`, matched by `topic_codes`), `memoryHooks` (`app.topic_memory_hooks` joined via reference entry), `figures` (`app.figures` joined via `app.figure_uses` to reference entries). `selectedTopicNotes` -> `mapOpenHandGuides` (`presentation.ts`) -> `NotesSheetContent` (`DeepDiveOverlay.jsx`): "worked" group = the five unlabeled cards, "full" group sits under the literal heading "Cheat Sheet" (`grouped && <SubTag>Cheat Sheet`).

## Field -> block for AP Chem 2.1 (READ rows, mapping READ from presentation.ts:288-307)
| Block on page | Source column | 2.1 note |
|---|---|---|
| Core idea (card) | explainer.core_idea | "doesn't sort bonds into three boxes... continuous scale" |
| What to understand (card) | explainer.what_students_need_to_understand | cross-topic payoff (2.7, 2.2/2.3, 2.4) |
| How points are earned (card) | explainer.how_this_becomes_points | |
| The answer move (card) | explainer.answer_move | **identical string** to brief.answer_move |
| Common point loss (card) | explainer.common_point_loss | **identical string** to brief.common_point_loss; shown once (exact dedupe works) |
| Remember it | topic_memory_hooks | **0 hooks for 2.1**, so none renders |
| What it is | brief.what_it_is | near-twin of Core idea (same continuum claim + electronegativity trend) |
| Why it matters | brief.why_it_matters | near-twin of What to understand (same 2.7/2.2/2.3/2.4 list) |
| How points are earned (2nd) | brief.how_points_are_earned | near-twin of explainer.how_this_becomes_points (same classify + justify + confirm-with-property) |
| Mini example / Weak / Point-attaining | explainer.mini_example_question, weak_answer, point_attaining_answer | unique |
| Practice bridge | explainer.practice_bridge | repeats the answer move ("write the comparison first") |
| Vocabulary | unit_reference_entries kind=vocabulary (3 rows: delocalized electrons, nonpolar covalent, polar covalent) | explainer carries no vocabulary field, so mapper falls back to reference rows |
| Formulas and rules | unit_reference_entries kind=convention (3 rows) | "Classifying a bond", "Direction and size of a bond dipole", "Electronegativity trends"; the trend sentence repeats brief.what_it_is |
Exact-string dedupe (`seen.has(body)`) removes only Common point loss; every other repeat is reworded, so it survives. Estimated brief-sourced duplicate text: about 240 of ~900 words (INFERRED, from the three brief paragraphs).

## 2. Act-on paths (recommendation -> who/where)
| # | Change | Type | Path | Approval |
|---|---|---|---|---|
| 1 | One source per fact (field precedence) | Frontend-only | Suppress brief.what_it_is / why_it_matters / how_points_are_earned in the "full" group whenever an explainer row exists; keep practice bridge but fold it into the answer-move card. Edit `presentation.ts` mapper + tests. App-repo change (david-bloom/ap-prep-blueprint) | Frontend PR, owner merge; live only after Lovable publish |
| 2 | 30-second block | Frontend + small content | Frontend can ship a first version from existing fields (answer move, common point loss, 1 hook/trend). Cleaner version needs a new authored `quick_take` field | Frontend PR first; field = schema migration (Hard-Gate for Prod) + generate-select (DECISION-0099) |
| 3 | Structured bullets/tables | Content + schema | Regeneration of explainer/brief under generate-select, never hand-patched; new columns or jsonb | Migration approval, content publish approval (APPROVAL numbers; check open PRs first) |
| 4 | Length caps + overlap check | Pipeline | Add to the topic-guides QA/validator scripts and protocol doc | Docs-only protocol PR (docs PR merge authority applies) |
| 5 | Disclosure for deep dive | Frontend-only | Same PR family as #1; instant toggle, no motion (D4), export still expands all | Frontend PR |
**Order:** (1) frontend dedupe by field precedence (cheapest, no content or DB change, removes ~25% of text, unblocks the rest) -> (5) label the groups ("Cheat Sheet" on top, "Deep Dive" below; today the labels are inverted/missing) and collapse the deep dive -> (4) validator to lock the gain -> (2)/(3) schema + regeneration for the new authored shape, one subject/unit first (AP Chem Unit 2). A Lovable prompt is the delivery path for the frontend steps if the app repo is Lovable-synced; either way review by commit SHA (INFERRED from repo topology memory; I did not open a PR).

## 3. Images (READ unless marked; revised 2026-10-31 per David: need-based, no fixed count)
Revision note: the earlier "one figure slot per topic, with a 'no figure yet' fallback" proposal is withdrawn. There is no required number of figures and no placeholder. Each topic gets what its content needs: zero, one or several.

### What exists today (READ)
- Render path supports figures: the RPC returns `figures` (`app.figures`: family, title, caption, alt, params; `figure_uses` links to reference entries). `NotesSheetContent` renders them in a separate "Figures" grid after the notes (`<Figure layout="full">`); copy/export rasterises them. Briefs and explainers have no image column; `unit_reference_entries.visual_asset_ref` is NULL on all 1,084 published rows.
- Production (queried 2026-10-31, SELECT only): 88 published figures in 23 families, all linked to reference entries, none with missing or short alt. Families: approach_equilibrium, arrow_diagram, boxplot, categorical_bars, circuit_symbols, density_curve, dna_ladder, dotplot, electrochemical_cell, energy_profile, field_map, function_plot, kinematic_panels, mb_distribution, membrane_bilayer, organelle, particulate_box, pe_vs_distance, pie_chart, stem_leaf, stick_spectrum, titration_curve, xy_series.

### Policy: a figure when the content needs one (design recommendation)
1. **Need rubric.** A topic calls for a figure when understanding or the exam answer depends on a picture the words cannot carry well. Triggers:
   - a particulate or molecular picture (arrangements of particles, bonding, structure, phase, mixtures);
   - a trend or relationship a student must read off or sketch (graph, curve, energy profile, distribution);
   - apparatus or a setup (cell, titration, circuit, experiment);
   - a comparison along a scale or continuum (a number line or strip) where position is the point;
   - a spatial or geometric arrangement (shapes, fields, orientation).
   Not a trigger: definitions, vocabulary, rules, or procedures that a sentence or a short table handles. A decorative figure never qualifies.
2. **Count follows need.** A topic may need none, one, or several (for example a particulate picture plus a trend plot). No quota, no empty slot and no "no figure yet" label; absence is simply absence. Gaps are tracked in the content backlog, not shown to students.
3. **Placement.** Each figure sits next to the block it explains (for example beside the Core idea or Worked example card), not in a bottom grid. This needs a frontend change: attach figures to the section they illustrate via `figure_uses` -> reference entry -> block, and render inline there. The bottom "Figures" grid is the interim fallback only for figures with no attached block. (INFERRED: the existing `figure_uses` -> reference entry link is enough to choose the block; the mapping rule is not yet designed.)
4. **Alt text is required**, as today (the DB already enforces non-empty alt). Caption at most one line.
5. **Size floor.** The smallest rendered glyph holds to the DECISION-0119/0120 floor at every viewport, including 375px; figures scale up, not down, and are not shrunk to fit a column.
6. **Export.** Copy/export keeps figures in the same position as on the page.
7. **Authoring.** New figures follow the figure lane's three verification gates (property tests, eyes, model readers) and DECISION-0099 generate-select. Figures are a content-lane task, not a frontend one.

### AP Chem Unit 2: topics that need a figure but lack one (READ counts, INFERRED need)
Published reference entries and figures per topic (READ): 2.1: 6/0, 2.2: 3/1 (pe_vs_distance), 2.3: 1/0, 2.4: 3/1 (particulate_box), 2.5: 1/0, 2.6: 4/0, 2.7: 4/0. The counts show what exists, not what is missing. Whether a topic needs one is a content judgement against the rubric above; the table below is my first-pass reading of the topic titles and has NOT been checked against the briefs, so a content owner should confirm each row.
| Topic | Likely figure need (INFERRED) | Has one now |
|---|---|---|
| 2.1 Types of chemical bonds | Yes: bond type as a continuum of electronegativity difference (strip or number line); optionally one dipole drawing | No |
| 2.2 Intramolecular force and potential energy | Yes: PE vs distance | Yes (pe_vs_distance) |
| 2.3 Structure of ionic solids | Likely: lattice / particulate picture | No |
| 2.4 Structure of metals and alloys | Likely: particulate picture | Yes (particulate_box) |
| 2.5 Lewis diagrams | Probably: worked drawings; check whether text-only Lewis structures suffice | No |
| 2.6 Resonance and formal charge | Probably: resonance structures | No |
| 2.7 VSEPR and bond hybridization | Yes: molecular shapes | No |
So the open question for Unit 2 is not "2 of 7 have a figure" but "which of 2.1, 2.3, 2.5, 2.6 and 2.7 pass the rubric", and whether 2.2 and 2.4 need a second figure.

### AP Chem 2.1 specifically
- **Does the content call for a figure? Yes (INFERRED from the 2.1 text I read).** The Core idea is that bonds sit on a continuous scale of electronegativity difference, not in three boxes, and the exam answer is "compare electronegativities, then classify". A strip showing electronegativity difference against nonpolar covalent, polar covalent and ionic character, with the bond's position marked, carries that better than the paragraph. A bond-dipole arrow drawing (direction and size) is a possible second figure for "Direction and size of a bond dipole".
- **What to check in the figure lane (none done yet):**
  1. Whether any of the 23 families fits. By name, `arrow_diagram` and `xy_series` are the nearest candidates for a continuum strip or a difference-vs-character plot, and `particulate_box` for a dipole or charge-distribution picture. None is confirmed; read the family specs (`specs.json`) before deciding.
  2. Whether a continuum strip needs a new family. If so, that is a lane build (property tests, eyes, model readers), not a one-off.
  3. Whether any existing figure is already linked to a 2.1 reference entry (current read: 0 of 6 entries have one).
  4. Legibility at the 0119/0120 floor on a 375px screen, since the strip has labelled endpoints and a marker.
  5. Alt text that states the relationship (difference rises, character moves from nonpolar to ionic), not just "a bond strip".
- Figures for the other Unit 2 topics are a content-lane task, not a frontend one.
