import { streamObject } from 'ai';
import { z } from 'zod';
import fs from 'node:fs';
import path from 'node:path';

// DIAGNOSTIC PROBE ONLY -- not a gate run, not scoring evidence.
// Question: are the 3 Arm B v2 schema failures reparable by raising the token
// cap, and what does the fix cost in latency? Reruns ONLY the 3 failed items
// with a generous 4000-token cap. Results must NOT be cited as gate evidence
// (the items were already seen); they answer "reparable?" only.

const ROOT = '/Users/davidbloom/Documents/Cramapple';
const PHASE_C_DIR = path.join(ROOT, 'docs/research/grading_phase_c_calibration_2026_07_27');
const SCRATCH = '/private/tmp/claude-503/-Users-davidbloom-Documents-Cramapple/1b488fc3-9769-4bf0-b750-f8e409a3b774/scratchpad/phase_c';

const MANIFEST = JSON.parse(fs.readFileSync(path.join(PHASE_C_DIR, 'frozen_arm_manifest.json'), 'utf8'));
const SELECTED = JSON.parse(fs.readFileSync(path.join(SCRATCH, 'stage5v2_selected_20.json'), 'utf8'));

const FAILED = ['apchem-frq-l-003', 'apphycm-frq-037', 'apphycm-frq-035'];
const GENEROUS_CAP = 4000;
const MODEL = MANIFEST.model_config.model_id;
const PROVIDER_OPTIONS = { google: { thinkingConfig: { thinkingBudget: 0, includeThoughts: false } } };
const P = MANIFEST.pricing_table;

const PER_CRITERION_SCHEMA = z.object({
  criterion_key: z.string(),
  status: z.enum(['earned', 'not_earned', 'unable_to_determine']),
  confidence: z.enum(['low', 'medium', 'high']),
  evidence_quote: z.string(),
  withheld_point_reason: z.string(),
  minimum_fix: z.string(),
  improved_answer: z.string(),
  error_classification: z.enum(['missing_evidence','conceptual_error','arithmetic_error','wrong_scope','contradiction','equivalent_form_rejected_incorrectly','ambiguous','none']),
  gate_schema_status: z.enum(['valid', 'invalid']),
});
const ARM_B_SCHEMA = z.object({ criteria: z.array(PER_CRITERION_SCHEMA) });

function fillTemplate(t, vars) {
  let out = t;
  for (const [k, v] of Object.entries(vars)) out = out.split(`{${k}}`).join(typeof v === 'string' ? v : JSON.stringify(v));
  return out;
}

function armBPrompt(item) {
  const block = item.criteria.map((c) =>
    `  - criterion_key: ${c.criterion_key}\n    points_possible: ${c.points_possible}\n    learner_facing_text: ${c.learner_facing_text}\n    evidence_requirements: ${c.evidence_requirements || ''}\n    minimum_fix (rubric-authored): ${c.minimum_fix || ''}\n    accepted_variants: ${JSON.stringify(c.accepted_variants || [])}`
  ).join('\n');
  return fillTemplate(MANIFEST.arm_b_v2.prompt_template, {
    subject: item.subject, content_key: item.content_key,
    stem: item.stem || '', stimulus: item.stimulus || '',
    criteria_contracts_block: block, deterministic_check_results: {},
    response_text: item.response_text,
  });
}

let cost = 0;
const out = [];
for (const ck of FAILED) {
  const item = SELECTED.find((i) => i.content_key === ck);
  const prompt = armBPrompt(item);
  const t0 = performance.now();
  let firstAt = null;
  try {
    const res = streamObject({ model: MODEL, schema: ARM_B_SCHEMA, prompt, providerOptions: PROVIDER_OPTIONS, maxOutputTokens: GENEROUS_CAP });
    for await (const _ of res.partialObjectStream) { if (firstAt === null) firstAt = performance.now(); }
    const final = await res.object;
    const u = await res.usage;
    const inTok = Number(u.inputTokens ?? 0), outTok = Number(u.outputTokens ?? 0);
    const c = ((inTok * P.input_usd_per_1m_tokens) + (outTok * P.output_usd_per_1m_tokens)) / 1e6;
    cost += c;
    const lat = performance.now() - t0;
    const nReturned = (final.criteria || []).length;
    out.push({ content_key: ck, n_criteria: item.criteria.length, n_returned: nReturned, ok: true, outputTokens: outTok, latencyMs: Math.round(lat), costUsd: c });
    console.log(`${ck}: OK  n_crit=${item.criteria.length} returned=${nReturned} out_tok=${outTok} lat=${Math.round(lat)}ms cost=$${c.toFixed(5)}`);
  } catch (e) {
    const lat = performance.now() - t0;
    out.push({ content_key: ck, n_criteria: item.criteria.length, ok: false, error: e.message, latencyMs: Math.round(lat) });
    console.log(`${ck}: FAIL lat=${Math.round(lat)}ms err=${e.message}`);
  }
}
fs.writeFileSync(path.join(PHASE_C_DIR, 'raw', 'armb_uncapped_diagnostic.jsonl'), out.map((r) => JSON.stringify(r)).join('\n') + '\n');
console.log(`\nDiagnostic total cost: $${cost.toFixed(5)}`);
