import { streamObject } from 'ai';
import fs from 'node:fs';
import path from 'node:path';
import crypto from 'node:crypto';
import { z } from 'zod';

function loadEnvFile(envPath) {
  if (!fs.existsSync(envPath)) return;
  const lines = fs.readFileSync(envPath, 'utf8').split(/\r?\n/);
  for (const rawLine of lines) {
    const line = rawLine.trim();
    if (!line || line.startsWith('#') || !line.includes('=')) continue;
    const idx = line.indexOf('=');
    const key = line.slice(0, idx).trim();
    let value = line.slice(idx + 1).trim();
    if ((value.startsWith('"') && value.endsWith('"')) || (value.startsWith("'") && value.endsWith("'"))) {
      value = value.slice(1, -1);
    }
    if (key && !(key in process.env)) {
      process.env[key] = value;
    }
  }
}

const ROOT = path.resolve(new URL('.', import.meta.url).pathname, '..', '..');
const BENCHMARK_MANIFEST = path.join(ROOT, 'docs', 'research', 'hand_drawn_graph_benchmark_2026_06_30', 'benchmark_manifest.json');
const OUT_DIR = path.join(ROOT, 'docs', 'research', 'hand_drawn_graph_benchmark_2026_06_30', 'runs');
const OUTPUT_JSONL = path.join(OUT_DIR, 'hand_drawn_graph_benchmark_results.jsonl');
const TRACE_BASE = path.join(ROOT, 'docs', 'research', 'hand_drawn_graph_corpus_2026_06_29', 'trace_sets');

const ARMS = {
  VISION_FAST: {
    model: 'openai/gpt-4o-mini',
    reasoningEffort: null,
    maxOutputTokens: 300,
    providerOptions: {},
  },
  VISION_ACCURACY: {
    model: 'openai/gpt-5.5',
    reasoningEffort: 'medium',
    maxOutputTokens: 350,
    providerOptions: {},
  },
  VISION_FAST_ESC: {
    model: 'openai/gpt-4o-mini',
    reasoningEffort: null,
    maxOutputTokens: 300,
    providerOptions: {},
    escalationModel: 'openai/gpt-5.5',
    escalationReasoningEffort: 'medium',
    escalationMaxOutputTokens: 350,
  },
};

function fail(message) {
  console.error(`error: ${message}`);
  process.exit(1);
}

function stableHash(...parts) {
  return crypto.createHash('sha256').update(parts.join('\0')).digest('hex');
}

function loadJson(pathname) {
  return JSON.parse(fs.readFileSync(pathname, 'utf8'));
}

function loadCriterionContract(manifest, manifestDir) {
  if (manifest?.criterion_contract && typeof manifest.criterion_contract === 'object') {
    return manifest.criterion_contract;
  }
  if (typeof manifest?.criterion_contract_path === 'string' && manifest.criterion_contract_path.length > 0) {
    const contractPath = path.resolve(manifestDir, manifest.criterion_contract_path);
    if (fs.existsSync(contractPath)) {
      return loadJson(contractPath);
    }
  }
  return null;
}

function criterionIdsFromRow(row) {
  const defs = row?.criterion_definitions || [];
  return defs
    .map((entry) => entry?.criterion_id)
    .filter((criterionId) => typeof criterionId === 'string' && criterionId.length > 0);
}

function loadCorpusItemMap(corpusPath) {
  const map = new Map();
  if (!corpusPath || !fs.existsSync(corpusPath)) return map;
  const rows = fs.readFileSync(corpusPath, 'utf8').split(/\r?\n/).filter(Boolean);
  for (const line of rows) {
    const row = JSON.parse(line);
    if (row?.item_id) map.set(String(row.item_id), row);
  }
  return map;
}

function loadBenchmarkRecords(manifestPath) {
  const manifest = loadJson(manifestPath);
  const manifestDir = path.dirname(manifestPath);
  const sourceCorpusPath = manifest.source_corpus
    ? path.resolve(manifestDir, manifest.source_corpus)
    : manifest?.source_inputs?.synthetic_corpus
      ? path.resolve(ROOT, manifest.source_inputs.synthetic_corpus)
      : null;
  const corpusItemMap = loadCorpusItemMap(sourceCorpusPath);
  const records = (manifest.records || []).map((record) => {
    const sourceRow = corpusItemMap.get(String(record.item_id)) || {};
    return {
      ...sourceRow,
      ...record,
      criterion_ids: Array.isArray(record.criterion_ids) && record.criterion_ids.length > 0
        ? record.criterion_ids
        : criterionIdsFromRow(sourceRow),
    };
  });
  return { manifest, manifestDir, records };
}

function loadTraceImageMap() {
  const map = new Map();
  for (const setName of ['set_01', 'set_02', 'set_03']) {
    const pagesDir = path.join(TRACE_BASE, setName, 'pages');
    for (const file of fs.readdirSync(pagesDir)) {
      if (!file.endsWith('.png')) continue;
      const itemId = file.replace(/^\d+_/, '').replace(/\.png$/, '');
      map.set(itemId, path.join(pagesDir, file));
    }
  }
  return map;
}

function criterionSchema(record) {
  return z.object({
    criterion_statuses: z.array(
      z.object({
        criterion_id: z.enum(record.criterion_ids),
        status: z.enum(['earned', 'not_earned', 'unable_to_determine']),
      }),
    ),
    confidence: z.enum(['high', 'medium', 'low']),
    rationale: z.string(),
  });
}

function renderCriterionDefinitions(definitions, fallbackCriterionIds) {
  if (Array.isArray(definitions) && definitions.length > 0) {
    return definitions
      .map((entry) => {
        if (!entry || typeof entry !== 'object') return null;
        const criterionId = typeof entry.criterion_id === 'string' ? entry.criterion_id : '';
        const metRule = typeof entry.met_rule === 'string' ? entry.met_rule : '';
        if (!criterionId || !metRule) return null;
        return `- ${criterionId}: ${metRule}`;
      })
      .filter(Boolean)
      .join('\n');
  }
  return (fallbackCriterionIds || [])
    .map((criterionId) => `- ${criterionId}: satisfy the corresponding graph-evidence requirement for this item`)
    .join('\n');
}

function buildPrompt(record, contract) {
  const archetypeRules = contract?.archetype_rules && record?.archetype ? contract.archetype_rules[record.archetype] : null;
  const criteria = renderCriterionDefinitions(
    Array.isArray(record?.criterion_definitions) && record.criterion_definitions.length > 0
      ? record.criterion_definitions
      : archetypeRules?.criterion_definitions,
    record.criterion_ids,
  );
  const globalRules = Array.isArray(contract?.global_rules) && contract.global_rules.length > 0
    ? contract.global_rules.map((rule) => `- ${rule}`).join('\n')
    : '';
  const archetypeNotes = Array.isArray(archetypeRules?.notes) && archetypeRules.notes.length > 0
    ? archetypeRules.notes.map((note) => `- ${note}`).join('\n')
    : '';
  return [
    `Item ID: ${record.item_id}`,
    `Archetype: ${record.archetype}`,
    `Prompt:`,
    record.item_prompt || record.student_prompt || record.stem || '',
    '',
    contract?.contract_id ? `Contract: ${contract.contract_id}` : 'Contract: 4-criterion graph-evidence contract',
    contract?.purpose ? `Contract purpose: ${contract.purpose}` : '',
    globalRules ? ['Global rules:', globalRules].join('\n') : '',
    archetypeNotes ? ['Archetype notes:', archetypeNotes].join('\n') : '',
    '',
    'Rubric criteria:',
    criteria,
    '',
    'Inspect the image and return criterion statuses only for the visible response.',
  ].filter(Boolean).join('\n');
}

function buildMessages(prompt, imageBuffer) {
  return [
    {
      role: 'user',
      content: [
        { type: 'text', text: prompt },
        { type: 'image', image: imageBuffer },
      ],
    },
  ];
}

function estimateCost(usage, modelName) {
  const pricing = modelName === 'openai/gpt-5.5'
    ? { input: 5.0, cached: 0.5, output: 30.0 }
    : { input: 0.15, cached: 0.075, output: 0.6 };
  const inputTokens = Number(usage.inputTokens || 0);
  const cachedTokens = Number(usage.cachedTokens || 0);
  const outputTokens = Number(usage.outputTokens || 0);
  const uncached = Math.max(inputTokens - cachedTokens, 0);
  return ((uncached * pricing.input) + (cachedTokens * pricing.cached) + (outputTokens * pricing.output)) / 1_000_000;
}

async function runCall(modelName, reasoningEffort, maxOutputTokens, prompt, imageBuffer, providerOptions = {}) {
  const model = modelName;
  const started = performance.now();
  const result = streamObject({
    model,
    schema: z.object({
      criterion_statuses: z.array(
        z.object({
          criterion_id: z.string(),
          status: z.enum(['earned', 'not_earned', 'unable_to_determine']),
        }),
      ),
      confidence: z.enum(['high', 'medium', 'low']),
      rationale: z.string(),
    }),
    messages: buildMessages(prompt, imageBuffer),
    ...(reasoningEffort ? { providerOptions: { ...providerOptions, openai: { reasoningEffort } } } : { providerOptions }),
    maxOutputTokens,
  });
  let firstChunkAt = null;
  try {
    for await (const _chunk of result.partialObjectStream) {
      if (firstChunkAt === null) firstChunkAt = performance.now();
    }
    const final = await result.object;
    const usage = await result.usage;
    const total = performance.now() - started;
    const ttfb = firstChunkAt === null ? total : firstChunkAt - started;
    return {
      ok: true,
      final,
      usage: {
        inputTokens: usage?.inputTokens ?? 0,
        outputTokens: usage?.outputTokens ?? 0,
        reasoningTokens: usage?.reasoningTokens ?? 0,
        cachedTokens: usage?.cachedInputTokens ?? usage?.cachedTokens ?? 0,
      },
      latencyMs: total,
      ttfbMs: ttfb,
      costUsd: estimateCost(
        {
          inputTokens: usage?.inputTokens ?? 0,
          outputTokens: usage?.outputTokens ?? 0,
          cachedTokens: usage?.cachedInputTokens ?? usage?.cachedTokens ?? 0,
        },
        modelName,
      ),
    };
  } catch (error) {
    return {
      ok: false,
      error: error?.message || String(error),
      final: null,
      usage: { inputTokens: 0, outputTokens: 0, reasoningTokens: 0, cachedTokens: 0 },
      latencyMs: performance.now() - started,
      ttfbMs: firstChunkAt === null ? null : firstChunkAt - started,
      costUsd: 0,
    };
  }
}

function stablePick(records, perArchetype) {
  const grouped = new Map();
  for (const record of records) {
    if (record.split !== 'external_challenge') continue;
    const list = grouped.get(record.archetype) || [];
    list.push(record);
    grouped.set(record.archetype, list);
  }
  const chosen = [];
  for (const [archetype, list] of [...grouped.entries()].sort(([a], [b]) => a.localeCompare(b))) {
    const ordered = list.slice().sort((a, b) => stableHash(a.item_id).localeCompare(stableHash(b.item_id)));
    chosen.push(...ordered.slice(0, perArchetype));
  }
  return chosen;
}

function parseArgs(argv) {
  const out = { arm: '', manifest: BENCHMARK_MANIFEST, perArchetype: 10, output: OUTPUT_JSONL };
  for (let i = 2; i < argv.length; i += 1) {
    const arg = argv[i];
    if (arg === '--arm' && argv[i + 1]) {
      out.arm = argv[++i];
    } else if (arg === '--manifest' && argv[i + 1]) {
      out.manifest = argv[++i];
    } else if (arg === '--per-archetype' && argv[i + 1]) {
      out.perArchetype = Number(argv[++i]);
    } else if (arg === '--output' && argv[i + 1]) {
      out.output = argv[++i];
    }
  }
  return out;
}

function goldStatuses(record) {
  if (record && record.gold_criterion_statuses && typeof record.gold_criterion_statuses === 'object') {
    const explicit = {};
    for (const [criterionId, status] of Object.entries(record.gold_criterion_statuses)) {
      if (typeof criterionId === 'string' && typeof status === 'string') {
        explicit[criterionId] = status;
      }
    }
    if (Object.keys(explicit).length > 0) {
      return explicit;
    }
  }
  const out = {};
  for (const criterionId of record.criterion_ids) {
    out[criterionId] = 'earned';
  }
  return out;
}

async function main() {
  const args = parseArgs(process.argv);
  loadEnvFile(path.join(ROOT, 'scripts', 'vercel-gateway-check', '.env.local'));
  if (!process.env.AI_GATEWAY_API_KEY && process.env.VERCEL_OIDC_TOKEN) {
    process.env.AI_GATEWAY_API_KEY = process.env.VERCEL_OIDC_TOKEN;
  }

  const { manifest, manifestDir, records } = loadBenchmarkRecords(path.resolve(ROOT, args.manifest));
  const contract = loadCriterionContract(manifest, manifestDir);
  const traceImages = loadTraceImageMap();
  const hasInlineImagePaths = records.some((record) => Boolean(record.image_path));
  const runnable = hasInlineImagePaths
    ? records
    : stablePick(records, args.perArchetype).filter((record) => traceImages.has(record.item_id));
  if (runnable.length === 0) {
    fail('no runnable images were found');
  }

  fs.mkdirSync(OUT_DIR, { recursive: true });
  fs.mkdirSync(path.dirname(args.output), { recursive: true });

  const output = fs.createWriteStream(args.output, { flags: 'w' });
  const arms = args.arm ? [args.arm] : Object.keys(ARMS);
  if (args.arm && !ARMS[args.arm]) {
    fail(`unknown arm ${args.arm}`);
  }

  for (const armName of arms) {
    const arm = ARMS[armName];
    for (const record of runnable) {
      const prompt = buildPrompt(record, contract);
      const imagePath = record.image_path
        ? path.resolve(manifestDir, record.image_path)
        : traceImages.get(record.item_id);
      if (!imagePath) {
        fail(`no image path available for ${record.item_id}`);
      }
      const imageBuffer = fs.readFileSync(imagePath);
      const promptHash = stableHash(armName, record.item_id, prompt);

      const primary = await runCall(arm.model, arm.reasoningEffort, arm.maxOutputTokens, prompt, imageBuffer, arm.providerOptions);
      let final = primary;
      let modelIdUsed = arm.model;
      let escalationTriggered = false;
      let escalationModelId = '';
      let escalationLatencyMs = 0;
      let escalationCostUsd = 0;

      if (arm.escalationModel) {
        const primaryStatusesList = Array.isArray(primary.final?.criterion_statuses)
          ? primary.final.criterion_statuses.map((entry) => entry.status)
          : [];
        const needsEscalation = !primary.ok
          || primaryStatusesList.some((status) => status !== 'earned')
          || primary.final?.confidence === 'low';
        if (needsEscalation) {
          escalationTriggered = true;
          escalationModelId = arm.escalationModel;
          const escalated = await runCall(
            arm.escalationModel,
            arm.escalationReasoningEffort,
            arm.escalationMaxOutputTokens,
            prompt,
            imageBuffer,
          );
          escalationLatencyMs = escalated.latencyMs;
          escalationCostUsd = escalated.costUsd;
          if (escalated.ok) {
            final = escalated;
            modelIdUsed = arm.escalationModel;
          }
        }
      }

      const predictedStatuses = {};
      for (const entry of final.final?.criterion_statuses || []) {
        if (entry && entry.criterion_id) {
          const criterionId = String(entry.criterion_id).toUpperCase();
          predictedStatuses[criterionId] = entry.status;
        }
      }
      const gold = goldStatuses(record);
      const schemaValid = final.ok && Object.keys(gold).every((criterionId) => predictedStatuses[criterionId]);
      const result = {
        item_id: record.item_id,
        split: record.split,
        experiment_arm: armName,
        source_type: record.source_type,
        source_package: record.source_package,
        item_version: record.item_version,
        archetype: record.archetype,
        relation_subtype: record.relation_subtype,
        expected_image_filename: record.expected_image_filename,
        image_path: record.image_path || '',
        prompt_hash: promptHash,
        model_id: modelIdUsed,
        escalation_model_id: escalationModelId,
        escalation_triggered: escalationTriggered,
        schema_valid: schemaValid,
        latency_ms: final.latencyMs + escalationLatencyMs,
        ttfb_ms: final.ttfbMs,
        cost_usd: final.costUsd + escalationCostUsd,
        input_tokens: (final.usage?.inputTokens || 0) + (escalationTriggered ? 0 : 0),
        output_tokens: final.usage?.outputTokens || 0,
        reasoning_tokens: final.usage?.reasoningTokens || 0,
        cached_tokens: final.usage?.cachedTokens || 0,
        criterion_statuses: predictedStatuses,
        gold_criterion_statuses: gold,
        confidence: final.final?.confidence || 'low',
        rationale: final.final?.rationale || '',
        ok: final.ok,
        error: final.error || '',
      };
      output.write(`${JSON.stringify(result)}\n`);
      process.stdout.write(`${armName} ${record.item_id} ${final.ok ? 'ok' : 'err'} ${Math.round(result.latency_ms)}ms\n`);
    }
  }

  output.end();
  await new Promise((resolve) => output.on('finish', resolve));
  console.log(`wrote ${args.output}`);
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
