// Gold-set fixture builder — turns confirmed `app.gold_set_elements` rows into
// the fixture JSON `generate_gold_set.mjs` consumes, for any subject.
//
// Protocol: docs/research/GOLD_SET_GENERATION_PROTOCOL.md §6 Phase 0.5/1.1.
// This is the missing step between "elements confirmed" and "generation runs" —
// scripts/content-seed/gold-set/{precalc,physics,calc,apstats_multipoint}_fixture.json
// were all hand- or ad hoc-assembled; this replaces that for every subject going
// forward, Biology/Chemistry included.
//
// INPUT: a JSON array of raw rows from the query below (one row per criterion,
// or per criterion x element when the criterion has been decomposed). Produce it
// with the Supabase MCP `execute_sql` tool, `psql -c "\copy (...) to stdout"`, or
// any other client against Production (pcntajvbdfqhbeewmdry) -- this script does
// not connect to the database itself, so it works the same way regardless of
// which credentials the person running it has.
//
//   select
//     ci.content_key,
//     ep.exam_name as subject_label,
//     v.id as content_item_version_id,
//     v.content_hash,
//     v.stem,
//     v.stimulus,
//     fc.criterion_key,
//     fc.points_possible,
//     fc.learner_facing_text,
//     ge.element_index,
//     ge.element_label,
//     ge.confirmed_by
//   from app.frq_criteria fc
//   join app.content_item_versions v on v.id = fc.content_item_version_id
//   join app.content_items ci on ci.id = v.content_item_id
//   join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
//   join app.exam_packs ep on ep.id = epv.exam_pack_id
//   left join app.gold_set_elements ge on ge.frq_criterion_id = fc.id
//   where v.status = 'published' and v.review_status = 'question_review_approved'
//     and v.canonical_answer_1 is not null
//     and ep.exam_name = ANY(array['AP Biology','AP Chemistry'])  -- edit per run
//   order by ci.content_key, fc.criterion_key, ge.element_index;
//
// GATE (the only subject-specific logic lives here, and it isn't actually
// subject-specific -- it's a fact about each criterion, computed the same way
// for every subject):
//   points_possible = 1, no gold_set_elements row  -> pass through: synthesize
//     one implicit element from learner_facing_text. Nothing to decompose or
//     confirm for a single-point criterion (protocol §6: "Set B is 1:1 with
//     frq_criteria").
//   points_possible > 1, no gold_set_elements row  -> BLOCKED. Decomposition
//     (Phase 0.5) hasn't run for this criterion yet.
//   any criterion with gold_set_elements rows but not all confirmed_by set
//     -> BLOCKED regardless of points_possible. Never generate against
//     unconfirmed decomposition.
//   all criteria clear -> item is buildable.
// A single blocked criterion excludes the WHOLE item (generation operates on
// an item's full element set together; a partially-usable item isn't safe to
// generate against).
//
// KEY CONVENTION (already in production use -- see precalc/calc fixtures):
//   exactly 1 element under a criterion -> bare criterion_key ("part-a")
//   more than 1 element under a criterion -> "{criterion_key}-criterion-{n}",
//   where n is a LOCAL 1-based rank within that criterion -- NOT the raw
//   gold_set_elements.element_index value. Cross-checked against the existing
//   AP Statistics rows: element_index there is a running count across the
//   whole item (criterion a=1, criterion b=2,3, criterion c=4), not reset per
//   criterion, while this batch's Biology/Chemistry inserts used local
//   numbering (1,2,3 within each criterion). Both are schema-legal -- the
//   unique constraint is (frq_criterion_id, element_index), which doesn't
//   care which convention was used -- so the builder must not depend on the
//   stored value's numbering scheme. It sorts each criterion's elements by
//   element_index (to preserve authored order) and then assigns the suffix
//   from array position, which is correct under either convention.
//
// Usage:
//   node build_gold_set_fixture.mjs <rows.json> <fixture.json> [--include-unconfirmed]
//
// --include-unconfirmed produces a fixture from draft (unconfirmed) elements
// anyway, for dry-run/schema-check purposes only -- it prints a loud warning
// and the output is NOT meant to be fed to generate_gold_set.mjs for a real
// run. Default behavior (no flag) enforces the gate.

import fs from 'node:fs';

const [, , inPath, outPath, ...flags] = process.argv;
const includeUnconfirmed = flags.includes('--include-unconfirmed');

if (!inPath || !outPath) {
  console.error('Usage: node build_gold_set_fixture.mjs <rows.json> <fixture.json> [--include-unconfirmed]');
  process.exit(1);
}

const rows = JSON.parse(fs.readFileSync(inPath, 'utf8'));
if (!Array.isArray(rows) || rows.length === 0) {
  console.error(`No rows in ${inPath} (expected a JSON array from the query in this script's header comment).`);
  process.exit(1);
}

if (includeUnconfirmed) {
  console.warn('--include-unconfirmed: building from DRAFT elements. This output is for schema/dry-run checks only -- do not feed it to generate_gold_set.mjs for a real generation run.');
}

// Group rows -> version -> criterion -> element rows.
const versions = new Map();
for (const r of rows) {
  if (!versions.has(r.content_item_version_id)) {
    versions.set(r.content_item_version_id, {
      content_key: r.content_key,
      subject_label: r.subject_label,
      content_item_version_id: r.content_item_version_id,
      content_hash: r.content_hash,
      stem: r.stem,
      stimulus: r.stimulus,
      criteria: new Map(),
    });
  }
  const v = versions.get(r.content_item_version_id);
  if (!v.criteria.has(r.criterion_key)) {
    v.criteria.set(r.criterion_key, {
      criterion_key: r.criterion_key,
      points_possible: r.points_possible,
      learner_facing_text: r.learner_facing_text,
      elementRows: [],
    });
  }
  const c = v.criteria.get(r.criterion_key);
  // A criterion with no gold_set_elements row still produces one joined row
  // (element_index/element_label/confirmed_by all null) -- don't record that
  // as a real element row.
  if (r.element_index != null) {
    c.elementRows.push({ element_index: r.element_index, element_label: r.element_label, confirmed: r.confirmed_by != null });
  }
}

const fixture = [];
const blocked = [];

for (const v of versions.values()) {
  let itemBlocked = null;
  const elements = [];

  for (const c of v.criteria.values()) {
    let useRows;
    if (c.elementRows.length === 0) {
      if (c.points_possible > 1) {
        itemBlocked = { criterion_key: c.criterion_key, reason: `points_possible=${c.points_possible}, no gold_set_elements row (Phase 0.5 decomposition hasn't run)` };
        break;
      }
      // Single-point pass-through: nothing to decompose or confirm.
      useRows = [{ element_index: 1, element_label: c.learner_facing_text, confirmed: true }];
    } else {
      const allConfirmed = c.elementRows.every((e) => e.confirmed);
      if (!allConfirmed && !includeUnconfirmed) {
        const n = c.elementRows.filter((e) => !e.confirmed).length;
        itemBlocked = { criterion_key: c.criterion_key, reason: `${n}/${c.elementRows.length} elements not yet confirmed` };
        break;
      }
      useRows = [...c.elementRows].sort((a, b) => a.element_index - b.element_index);
    }

    const bare = useRows.length === 1;
    useRows.forEach((e, i) => {
      const rank = i + 1; // local 1-based rank, not e.element_index -- see header note
      elements.push({
        criterion_key: bare ? c.criterion_key : `${c.criterion_key}-criterion-${rank}`,
        label: e.element_label,
      });
    });
  }

  if (itemBlocked) {
    blocked.push({ content_key: v.content_key, ...itemBlocked });
    continue;
  }

  if (!v.stem || !v.stem.trim()) {
    blocked.push({ content_key: v.content_key, criterion_key: null, reason: 'missing stem' });
    continue;
  }

  fixture.push({
    content_key: v.content_key,
    subject_label: v.subject_label,
    content_item_version_id: v.content_item_version_id,
    content_hash: v.content_hash,
    stem: v.stem,
    stimulus: v.stimulus,
    elements,
  });
}

fixture.sort((a, b) => a.content_key.localeCompare(b.content_key));
fs.writeFileSync(outPath, JSON.stringify(fixture, null, 2) + '\n');

const totalElements = fixture.reduce((n, i) => n + i.elements.length, 0);
console.log(`Wrote ${fixture.length} items (${totalElements} elements) -> ${outPath}`);
if (blocked.length) {
  console.log(`\nBlocked (${blocked.length} items excluded):`);
  for (const b of blocked) console.log(`  ${b.content_key}${b.criterion_key ? ` [${b.criterion_key}]` : ''}: ${b.reason}`);
}
