// One-off: convert the APSTATS-HDG-2026-GRAPH-001..040 prompt_json pulled
// from Supabase production (app.content_item_versions, evaluator_strategy=
// human_shadow) into a local corpus file, same field shape as the existing
// Biology corpus (docs/research/hand_drawn_graph_corpus_2026_06_29/
// hand_drawn_graph_questions_2026_06_29.jsonl) so the same benchmark/gold
// scripts can be pointed at Stats without a rewrite.
//
// Source: /tmp/apstats_hdg_raw.json (raw SQL result, one row per DB item;
// GRAPH-033's duplicate `retired` row already excluded by the query).
// Skips one true duplicate item_id if present (keeps the first/most-recent).

import fs from 'node:fs';
import path from 'node:path';

const ROOT = path.resolve(new URL('.', import.meta.url).pathname, '..', '..');
const RAW_PATH = '/tmp/apstats_hdg_raw.json';
const OUT_DIR = path.join(ROOT, 'docs', 'research', 'apstats_hdg_graph_corpus_2026_08_18');
const OUT_PATH = path.join(OUT_DIR, 'apstats_hdg_graph_questions_2026_08_18.jsonl');

function main() {
  const raw = JSON.parse(fs.readFileSync(RAW_PATH, 'utf8'));
  const seen = new Set();
  const lines = [];

  for (const row of raw) {
    if (seen.has(row.item_id)) continue;
    seen.add(row.item_id);
    const pj = row.prompt_json;
    const criteria = pj.criteria || [];
    const record = {
      item_id: row.item_id,
      content_item_version_id: row.content_item_version_id,
      status: row.status,
      archetype: pj.archetype,
      subject: pj.subject,
      student_prompt: pj.stimulus || pj.parts?.[0]?.prompt_text || '',
      capture_instruction: pj.capture_instruction || '',
      criterion_definitions: criteria.map((c) => ({
        criterion_id: c.criterion_key,
        met_rule: c.learner_facing_text,
        points_possible: c.points_possible,
      })),
      display_table: pj.stimulus_table || [],
      expected_graph_spec: pj.expected_graph_spec || {},
      rubric_type: pj.rubric_type,
      label_status: pj.label_status,
      rights_status: pj.rights_status,
    };
    lines.push(JSON.stringify(record));
  }

  fs.mkdirSync(OUT_DIR, { recursive: true });
  fs.writeFileSync(OUT_PATH, `${lines.join('\n')}\n`);
  console.log(`wrote ${OUT_PATH}: ${lines.length} items (${raw.length - lines.length} duplicate item_id(s) skipped)`);

  const byArchetype = {};
  for (const l of lines) { const r = JSON.parse(l); byArchetype[r.archetype] = (byArchetype[r.archetype] || 0) + 1; }
  console.log('by archetype:', JSON.stringify(byArchetype, null, 1));
}

main();
