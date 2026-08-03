import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const here = path.dirname(fileURLToPath(import.meta.url));
const research = path.resolve(here, '..');
const sourcePath = path.join(research, 'frq02_generated_answer_labels_codex_provisional.jsonl');
const auditPath = path.join(here, 'audit_overrides.json');
const outputPath = path.join(here, 'frq02_adjudicated_final_gold_2026_07_27.jsonl');

const rows = fs.readFileSync(sourcePath, 'utf8').trim().split('\n').map(JSON.parse);
const audit = JSON.parse(fs.readFileSync(auditPath, 'utf8'));
const overridesByResponse = new Map();

for (const change of audit.overrides) {
  const changes = overridesByResponse.get(change.response_id) || [];
  changes.push(change);
  overridesByResponse.set(change.response_id, changes);
}

const seen = new Set();
const outputRows = rows.map((row) => {
  const changes = overridesByResponse.get(row.response_id) || [];
  const labels = { ...row.criterion_labels };
  for (const change of changes) {
    if (labels[change.criterion_id] !== change.from) {
      throw new Error(`${row.response_id}/${change.criterion_id}: expected ${change.from}, found ${labels[change.criterion_id]}`);
    }
    labels[change.criterion_id] = change.to;
    seen.add(`${change.response_id}:${change.criterion_id}`);
  }

  const earned = Object.entries(labels).filter(([, value]) => value === 'earned').map(([key]) => key);
  const notEarned = Object.entries(labels).filter(([, value]) => value === 'not_earned').map(([key]) => key);
  const unable = Object.entries(labels).filter(([, value]) => value === 'unable_to_determine').map(([key]) => key);
  const summary = [
    `Final adjudication: ${earned.length}/4 earned.`,
    `Earned: ${earned.length ? earned.join(', ') : 'none'}.`,
    `Not earned: ${notEarned.length ? notEarned.join(', ') : 'none'}.`,
    unable.length ? `Unable to determine: ${unable.join(', ')}.` : '',
  ].filter(Boolean).join(' ');

  return {
    ...row,
    label_status: 'adjudicated_final_gold',
    use_as_ground_truth: true,
    criterion_labels: labels,
    points_labeled: earned.length,
    reviewer_note: summary,
    gold_adjudication: {
      status: 'final',
      date: '2026-07-27',
      adjudicated_by: 'Codex rubric-boundary audit, promoted to final gold by repository owner',
      source_file: 'docs/research/frq02_generated_answer_labels_codex_provisional.jsonl',
      changed_criteria: changes.map((change) => ({
        criterion_id: change.criterion_id,
        from: change.from,
        to: change.to,
        reason: change.reason,
      })),
      legacy_boundary_tags_note: 'boundary_tags are retained as source provenance and are not adjudicated gold labels',
    },
  };
});

if (seen.size !== audit.overrides.length) {
  throw new Error(`applied ${seen.size} of ${audit.overrides.length} overrides`);
}

fs.writeFileSync(outputPath, `${outputRows.map((row) => JSON.stringify(row)).join('\n')}\n`);
console.log(`Wrote ${outputRows.length} final-gold rows with ${seen.size} adjudicated label changes to ${outputPath}`);
