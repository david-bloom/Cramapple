import { streamObject } from 'ai';
import { createOpenAI } from '@ai-sdk/openai';
import { z } from 'zod';
import fs from 'node:fs';
import path from 'node:path';
import crypto from 'node:crypto';
import { checkMisattribution, shutdownMisattributionChecker } from './misattribution_bridge.mjs';

// SP-1 constrained pilot. See docs/research/GRADER_SPEED_SUBTASK_PROTOCOL.md.
//
// NOT a decision-grade SP-1 run. Known deviations from the protocol,
// documented up front so the report cannot misrepresent this run:
//   - Single FRQ (FRQ02) only. Protocol requires all six summer-beta FRQs.
//   - Ambiguity tagging is a proxy (the five named cluster IDs from
//     GRADER_SPEED_SUBTASK_PROTOCOL.md line 36), not frozen Learning Quality
//     review per protocol section 9.
//   - T1, T2, T6 are script-level placeholders (prompt assembly, schema
//     compile, JSONL write). They do not represent real grading-service
//     app overhead and cannot be used to evaluate the production
//     T1+T2+T6 < 15% gate.

const directOpenAI = process.env.OPENAI_API_KEY ? createOpenAI({ apiKey: process.env.OPENAI_API_KEY }) : null;

const ROOT = path.resolve(new URL('.', import.meta.url).pathname, '..', '..');
const LABELS_PATH = path.join(ROOT, 'docs', 'research', 'frq02_generated_answer_labels_codex_provisional.jsonl');
const DEFAULT_OUTPUT = '/private/tmp/cramapple-grader-sp1/sp1_pilot_2026-06-18.jsonl';
const FRQ_ID = 'FRQ02';
const AMBIGUOUS_CLUSTER = new Set(['S010', 'S020', 'S028', 'S066', 'S068']);

// Per-criterion escalation confidence thresholds, addressing protocol section 16
// open question 4 ("should the confidence < 0.7 threshold be tuned per criterion").
// Pre-registered here based on the prior constrained-pilot run
// (docs/research/grader_speed_sp1_report.md): gpt-4o-mini's self-reported
// confidence on this corpus never dropped below 0.7 even when wrong (correct
// calls averaged 0.938, wrong calls 0.880-0.908), so a flat 0.7 cutoff almost
// never fired. Errors were also wildly concentrated on FRQ02-C2 (16/37 wrong,
// 43%) versus FRQ02-C1 (1/37, 2.7%). A single global threshold can't be both
// cheap and protective given that split, so HIGH_RISK criteria get a much more
// sensitive threshold and everything else gets a cheaper one. This lands the
// overall escalation rate close to protocol section 11's expected 10-20% band
// while concentrating escalation where the actual error risk lives.
const HIGH_RISK_CRITERIA = new Set(['FRQ02-C2']);
const HIGH_RISK_CONFIDENCE_THRESHOLD = 0.95;
const DEFAULT_CONFIDENCE_THRESHOLD = 0.88;

function confidenceThresholdFor(criterionId) {
  return HIGH_RISK_CRITERIA.has(criterionId) ? HIGH_RISK_CONFIDENCE_THRESHOLD : DEFAULT_CONFIDENCE_THRESHOLD;
}
const CONCURRENCY = Number(process.env.SP1_CONCURRENCY ?? 10);

const PROMPT = `A population of wild wildflowers exhibits a single gene locus with two alleles (\`F\` and \`f\`) controlling flower color. A construction project randomly destroys 90% of the wildflower population. The remaining individual plants are left to randomly interbreed.

A. Identify the specific evolutionary mechanism responsible for the sudden alteration of allele frequencies in this small population.

B. Explain how the genetic diversity of this isolated population will compare to the original ancestral population over subsequent generations, assuming no mutation or gene flow occurs.`;

// Broad, FRQ-level topicality vocabulary for the prefilter's off-topic check (see
// PREFILTER_OFF_TOPIC_VOCAB below). This is deliberately NOT per-criterion: the
// original per-criterion key-term lists were acting as an insufficient-wording
// filter (e.g. flagging a wrong-but-on-topic Hardy-Weinberg/gene-flow misconception
// as "off-topic" because it didn't say "drift" or "bottleneck"), which protocol
// section 6.1 explicitly prohibits ("does not attempt accepted-variant or
// insufficient-wording matching, which would inherit any current rubric ambiguity").
// The prefilter's job is to catch genuinely non-substantive responses (empty,
// refusal, answering a different question entirely), not to pre-judge correctness.
const PREFILTER_OFF_TOPIC_VOCAB = [
  'allele', 'gene', 'population', 'evolution', 'select', 'drift', 'bottleneck',
  'mutation', 'diversity', 'frequenc', 'fitness', 'random', 'chance', 'mating',
  'flower', 'heterozygos', 'fixation', 'flow', 'trait', 'equilibrium', 'breed',
];

const CRITERIA = {
  'FRQ02-C1': {
    text: 'Identifies genetic drift as the mechanism (bottleneck effect is acceptable and more specific).',
    boundary: `FRQ02-C1 boundary table:

Earned:
- names genetic drift as the mechanism;
- names the bottleneck effect (a specific form of drift).

Not earned:
- names only natural selection, mutation, gene flow, or non-random mating as the mechanism;
- describes the population-size change without naming a mechanism.`,
  },
  'FRQ02-C2': {
    text: 'Explains that the construction event is random/non-selective with respect to flower-color fitness.',
    boundary: `FRQ02-C2 boundary table (v2 - revised after observing systematic under-credit on v1):

Earned - any of these satisfy the criterion:
- affirmatively states the construction destruction/survival event itself was random, by chance, or not based on which plants were fitter or better adapted (e.g. "randomly destroyed", "construction randomly killed plants", "random events like the construction");
- describes which plants survived as a random sample or random subset of the original population, stated affirmatively, not hedged (e.g. "the surviving population is a random sample"; "random survivors" WITHOUT a hedge like "not necessarily");
- affirmatively states the event was not natural selection.
A qualifying phrase needs to attach "random/by chance/randomly" to the destruction, survival, or selection ACT itself (who got destroyed or who survived), not only to the resulting allele-frequency number. Treat "the construction randomly destroyed/killed X" and "X were randomly selected/destroyed/survived" as earning credit even if the same sentence also mentions the frequency change.

Not earned:
- only says the population got smaller or allele frequencies changed, with no random/chance/non-selective language attached to the destruction or survival act anywhere in the response (e.g. "allele frequencies changed due to chance" or "changed randomly" with no mention of the construction/destruction/survival event being the random thing);
- only identifies bottleneck/genetic drift without explaining the construction event was random/non-selective;
- hedges with phrasing like "not necessarily the most fit" instead of affirmatively stating the event was non-selective;
- says construction selected the stronger/fitter/better-adapted flowers;
- says natural selection caused the allele-frequency change.

If you are uncertain whether "random/chance" modifies the destruction/survival act versus only the frequency outcome, prefer earned when the response also separately names the construction/destruction as the trigger in the same sentence or an adjacent one.`,
  },
  'FRQ02-C3': {
    text: 'Predicts reduced genetic diversity compared with the original population, addressing diversity over later generations, not only immediate mortality.',
    boundary: `FRQ02-C3 boundary table:

Earned:
- predicts genetic diversity will decrease/be reduced relative to the original population over subsequent generations.

Not earned:
- only describes the immediate population-size drop without a diversity prediction;
- predicts diversity stays the same or increases;
- predicts diversity will return to original levels via random mating alone (this is a distinct mechanism error, also not earned here).`,
  },
  'FRQ02-C4': {
    text: 'Explains that small isolated populations experience random allele-frequency change, allele loss/fixation, or reduced heterozygosity when no mutation or gene flow restores variation (random mating alone is insufficient).',
    boundary: `FRQ02-C4 boundary table:

Earned:
- explains random allele loss or fixation in a small population;
- explains reduced heterozygosity from drift in a small population;
- explains that without mutation or gene flow, lost variation cannot be restored.

Not earned:
- claims random mating alone restores or maintains original diversity;
- describes drift/bottleneck (covered by C1) without addressing allele loss, fixation, or heterozygosity consequences;
- omits the no-mutation/no-gene-flow condition when claiming diversity is permanently reduced.`,
  },
};
const CRITERION_IDS = Object.keys(CRITERIA);

const SCHEMA = z.object({
  status: z.enum(['earned', 'not_earned', 'unable_to_determine']),
  confidence: z.number().min(0).max(1),
  evidence_quote: z.string(),
  minimal_fix: z.string(),
  gate: z.enum(['pass', 'fail']),
});

const REFUSAL_PATTERNS = [/^i don'?t know$/i, /^skip$/i, /^n\/a$/i, /^not sure$/i, /^pass$/i];
const MIN_LENGTH_FLOOR = 15;

const Arms = {
  'BM-Control': { model: 'openai/gpt-5.5', reasoningEffort: 'medium', boundaryMemory: false, maxOutputTokens: 200, parallelCriteria: false, prefilter: false, escalates: false },
  'SP-1': { model: 'openai/gpt-5.5', reasoningEffort: 'low', boundaryMemory: true, maxOutputTokens: 160, parallelCriteria: true, prefilter: false, escalates: false, criterionTimeoutMs: 8000 },
  'SP-1-Serial': { model: 'openai/gpt-5.5', reasoningEffort: 'low', boundaryMemory: true, maxOutputTokens: 160, parallelCriteria: false, prefilter: false, escalates: false, criterionTimeoutMs: 8000 },
  'SP-1-Medium': { model: 'openai/gpt-5.5', reasoningEffort: 'medium', boundaryMemory: true, maxOutputTokens: 160, parallelCriteria: true, prefilter: false, escalates: false, criterionTimeoutMs: 8000 },
  'SP-FAST': { model: 'openai/gpt-4o-mini', boundaryMemory: true, maxOutputTokens: 150, parallelCriteria: true, prefilter: true, escalates: false, criterionTimeoutMs: 4000 },
  'SP-FAST-ESC': { model: 'openai/gpt-4o-mini', boundaryMemory: true, maxOutputTokens: 150, parallelCriteria: true, prefilter: true, escalates: true, criterionTimeoutMs: 4000, escalationTimeoutMs: 8000, escalationModel: 'openai/gpt-5.5', escalationReasoningEffort: 'medium' },
  'SP-FAST-Haiku': { model: 'anthropic/claude-haiku-4-5', boundaryMemory: true, maxOutputTokens: 150, parallelCriteria: true, prefilter: true, escalates: false, criterionTimeoutMs: 4000 },
  'SP-FAST-Gemini': {
    model: 'google/gemini-2.5-flash',
    boundaryMemory: true,
    maxOutputTokens: 150,
    parallelCriteria: true,
    prefilter: true,
    escalates: false,
    criterionTimeoutMs: 4000,
    providerOptions: { google: { thinkingConfig: { thinkingBudget: 0, includeThoughts: false } } },
    // First test of the misattribution audit against a non-gpt-5.5-routed arm.
    // Gemini's n=40 boundary-v2 numbers (146/160, $0.00141, 935ms p50) beat every
    // gpt-5.5-routing arm built this session on accuracy, cost, and speed at once -
    // this checks whether it has its own version of the S020/S028 misattribution
    // pattern, since the audit has only ever been tested against gpt-5.5-routed
    // verdicts before now.
    misattributionAudit: {
      'FRQ02-C2': {
        escalateToModel: 'openai/gpt-5.5',
        escalateToReasoningEffort: 'medium',
        escalateToMaxOutputTokens: 1000,
      },
    },
  },
  // Kimi (Moonshot) grading experiment - does a reasoning-capable open model
  // help students by grading FRQ criteria more accurately, and at what speed /
  // cost? Both arms grade with the model alone (no gpt-5.5 escalation, no
  // misattribution audit) so the numbers are a clean read on Kimi's own
  // grading, directly paired against BM-Control (gpt-5.5 medium) and
  // SP-FAST-Gemini on the same FRQ02 corpus. Priority order stays
  // Speed > Quality > Cost (see the pre-registration doc).
  //
  // SP-Kimi-Thinking: the headline arm. kimi-k2-thinking reasons natively -
  // NOT via the OpenAI `reasoningEffort` knob - so reasoningEffort is left
  // unset (runOneCall then attaches no openai providerOptions). Two settings
  // differ deliberately from every fast arm above, and both are required for
  // the arm to measure anything real rather than time out into garbage:
  //   - maxOutputTokens is large: thinking tokens are billed and counted as
  //     output, so a 150-token cap would truncate the model mid-reasoning
  //     before it ever emits the JSON verdict.
  //   - criterionTimeoutMs is large: a thinking pass can take tens of seconds;
  //     a 4-8s cap (tuned for fast models) would time out every call and we'd
  //     learn nothing about its true latency. This generous bound still catches
  //     a genuine hang without pre-judging the speed result.
  'SP-Kimi-Thinking': {
    model: 'moonshotai/kimi-k2-thinking',
    boundaryMemory: true,
    maxOutputTokens: 2000,
    parallelCriteria: true,
    prefilter: true,
    escalates: false,
    criterionTimeoutMs: 45000,
  },
  // SP-FAST-Kimi: same model family WITHOUT native thinking (kimi-k2 instruct),
  // as the speed/cost baseline that isolates what the reasoning actually buys.
  // Configured like the other SP-FAST-* provider arms so it is comparable to
  // them, not just to its thinking sibling.
  'SP-FAST-Kimi': {
    model: 'moonshotai/kimi-k2',
    boundaryMemory: true,
    maxOutputTokens: 200,
    parallelCriteria: true,
    prefilter: true,
    escalates: false,
    criterionTimeoutMs: 8000,
  },
  // SP-FAST-ESC-Kimi: Kimi-thinking as the SELECTIVE ESCALATION target rather
  // than a primary grader - the role gpt-5.5 plays in SP-FAST-ESC today. Fast
  // gpt-4o-mini grades every criterion; only low-confidence / invariant-
  // violating verdicts escalate to kimi-k2-thinking. This is the arm to reach
  // for if SP-Kimi-Thinking proves accurate but too slow to be a speed-first
  // primary: the thinking cost/latency is paid only on the ~10-20% of criteria
  // that actually need it, so the p50 stays on the fast path while the hard
  // cluster gets the reasoning model. Identical to SP-FAST-ESC except the
  // escalation model is Kimi, which forces two thinking-model accommodations:
  //   - escalationMaxOutputTokens: 2000 (new knob; a thinking model needs room
  //     to reason + emit JSON, unlike gpt-5.5 at the default 200).
  //   - escalationTimeoutMs: 45000 (a thinking pass can take tens of seconds;
  //     SP-FAST-ESC's 8000 ms would time out the escalation and silently fall
  //     back to the fast verdict on exactly the cases that triggered escalation).
  // escalationReasoningEffort is left unset - Kimi reasons natively.
  'SP-FAST-ESC-Kimi': {
    model: 'openai/gpt-4o-mini',
    boundaryMemory: true,
    maxOutputTokens: 150,
    parallelCriteria: true,
    prefilter: true,
    escalates: true,
    criterionTimeoutMs: 4000,
    escalationTimeoutMs: 45000,
    escalationModel: 'moonshotai/kimi-k2-thinking',
    escalationMaxOutputTokens: 2000,
  },
  // Follow-up to SP-FAST-ESC: that arm's prior run showed FRQ02-C2 escalating on
  // 72.5% of responses, and since criteria run in parallel (end-to-end = max
  // across criteria), that one criterion dominated the whole response's latency
  // via a wasted sequential fast-then-escalate double call. This arm tests routing
  // C2 straight to the reasoning model (single call, no fast-primary attempt),
  // while C1/C3/C4 keep the existing fast-primary + selective-escalation path
  // unchanged, since their escalation rates were already low (0%, 7.5%, 15%).
  'SP-FAST-ESC-C2Direct': {
    model: 'openai/gpt-4o-mini',
    boundaryMemory: true,
    maxOutputTokens: 150,
    parallelCriteria: true,
    prefilter: true,
    escalates: true,
    criterionTimeoutMs: 4000,
    escalationTimeoutMs: 8000,
    escalationModel: 'openai/gpt-5.5',
    escalationReasoningEffort: 'medium',
    criterionOverrides: {
      'FRQ02-C2': {
        model: 'openai/gpt-5.5',
        reasoningEffort: 'medium',
        maxOutputTokens: 200,
        escalates: false,
        criterionTimeoutMs: 8000,
      },
    },
    // Deterministic misattribution audit (scripts/misattribution-check/checker.py).
    // Runs only when C2 resolves to 'earned'. If the parser finds no qualifying
    // event-level attachment for the randomness claim, that's a disagreement -
    // escalate to gpt-5.5 medium for adjudication rather than trust either
    // verdict alone. See docs/research/grader_speed_sp1_report.md.
    misattributionAudit: {
      'FRQ02-C2': {
        escalateToModel: 'openai/gpt-5.5',
        escalateToReasoningEffort: 'medium',
        escalateToMaxOutputTokens: 1000,
      },
    },
  },
  // Same as SP-FAST-ESC-C2Direct, but the C2 direct route uses gpt-5.5 LOW
  // reasoning instead of medium (matching SP-1's choice), to test whether the
  // ~4.5s per-call latency floor on FRQ02-C2 can be reduced without losing the
  // quality gain from routing C2 straight to the reasoning-capable model.
  'SP-FAST-ESC-C2Direct-Low': {
    model: 'openai/gpt-4o-mini',
    boundaryMemory: true,
    maxOutputTokens: 150,
    parallelCriteria: true,
    prefilter: true,
    escalates: true,
    criterionTimeoutMs: 4000,
    escalationTimeoutMs: 8000,
    escalationModel: 'openai/gpt-5.5',
    escalationReasoningEffort: 'medium',
    criterionOverrides: {
      'FRQ02-C2': {
        model: 'openai/gpt-5.5',
        reasoningEffort: 'low',
        maxOutputTokens: 200,
        escalates: false,
        criterionTimeoutMs: 8000,
      },
    },
    misattributionAudit: {
      'FRQ02-C2': {
        escalateToModel: 'openai/gpt-5.5',
        escalateToReasoningEffort: 'medium',
        escalateToMaxOutputTokens: 1000,
      },
    },
  },
  // Parse-first: run the misattribution parser BEFORE any model call for C2,
  // and use its verdict to choose the route - not to double-check after the
  // fact. If the parser finds trigger words with no qualifying event-level
  // attachment (the S020/S028 shape), route straight to gpt-5.5 low (the
  // "hard path", same config validated in SP-FAST-ESC-C2Direct-Low). If the
  // parser finds a clean qualifying attachment, or finds no trigger words at
  // all, route to gpt-4o-mini (the "fast path") with the existing per-
  // criterion confidence-based escalation as a remaining safety net.
  //
  // Unlike the post-hoc misattribution audit, this is NOT free: the parser
  // must complete before any model call can start, so every C2 call here
  // pays the parser's latency serially (single-digit milliseconds, expected
  // to be small relative to either model call). The bet this arm tests is
  // that avoiding gpt-5.5 entirely on the structurally-clean majority is
  // worth that small fixed cost on every call.
  'SP-FAST-ESC-C2ParseFirst': {
    model: 'openai/gpt-4o-mini',
    boundaryMemory: true,
    maxOutputTokens: 150,
    parallelCriteria: true,
    prefilter: true,
    escalates: true,
    criterionTimeoutMs: 4000,
    escalationTimeoutMs: 8000,
    escalationModel: 'openai/gpt-5.5',
    escalationReasoningEffort: 'medium',
    parseFirstRouting: {
      'FRQ02-C2': {
        hardPath: {
          model: 'openai/gpt-5.5',
          reasoningEffort: 'low',
          maxOutputTokens: 200,
          escalates: false,
          criterionTimeoutMs: 8000,
        },
        // escalates: false (not the arm's default true) - the parser's
        // pre-screening IS the gate for this path. Keeping the old
        // confidence-based escalation active here (found via n=40 testing)
        // caused 19/28 "fast" calls to redundantly re-escalate to gpt-5.5
        // medium anyway, costing more latency than C2Direct-Low's single
        // always-gpt-5.5 call - the opposite of this arm's purpose.
        fastPath: {
          model: 'openai/gpt-4o-mini',
          maxOutputTokens: 150,
          escalates: false,
          criterionTimeoutMs: 4000,
        },
      },
    },
  },
};

function fail(message) {
  console.error(`error: ${message}`);
  process.exit(1);
}

function loadRows(filePath) {
  const rows = fs.readFileSync(filePath, 'utf8').split('\n').filter(Boolean).map((line) => JSON.parse(line));
  for (const row of rows) {
    if (row.label_status !== 'learning_quality_approved' || row.use_as_ground_truth !== true) {
      fail(`row ${row.response_id} is not approved ground truth`);
    }
  }
  return rows;
}

function selectCorpus(rows, limit) {
  const cluster = rows.filter((r) => AMBIGUOUS_CLUSTER.has(r.response_id));
  const rest = rows.filter((r) => !AMBIGUOUS_CLUSTER.has(r.response_id)).sort((a, b) => a.response_id.localeCompare(b.response_id));
  const fillCount = Math.max(0, limit - cluster.length);
  const stride = Math.max(1, Math.floor(rest.length / fillCount));
  const filled = [];
  for (let i = 0; i < rest.length && filled.length < fillCount; i += stride) filled.push(rest[i]);
  return [...cluster, ...filled].sort((a, b) => a.response_id.localeCompare(b.response_id));
}

function clarityOf(responseId) {
  return AMBIGUOUS_CLUSTER.has(responseId) ? 'ambiguous' : 'clear';
}

function gatewayAvailable() {
  return Boolean(process.env.AI_GATEWAY_API_KEY || process.env.VERCEL_OIDC_TOKEN);
}

function resolveModel(modelName) {
  if (gatewayAvailable()) return modelName;
  if (modelName.startsWith('openai/')) {
    if (!directOpenAI) fail('OPENAI_API_KEY not set for direct fallback');
    return directOpenAI(modelName.slice('openai/'.length));
  }
  return null;
}

function routingFor(modelName) {
  if (gatewayAvailable()) return 'vercel_ai_gateway';
  if (modelName.startsWith('openai/')) return 'direct_openai_fallback';
  return 'unavailable';
}

function promptHash(s) {
  return crypto.createHash('sha256').update(Buffer.from(s, 'utf8')).digest('hex').slice(0, 16);
}

function usageCounts(usage) {
  usage = usage || {};
  const inputDetails = usage.inputTokenDetails || {};
  const outputDetails = usage.outputTokenDetails || {};
  return {
    inputTokens: Number(usage.inputTokens ?? 0),
    outputTokens: Number(usage.outputTokens ?? 0),
    reasoningTokens: Number(outputDetails.reasoningTokens ?? 0),
    cachedTokens: Number(usage.cachedInputTokens ?? inputDetails.cachedInputTokens ?? 0),
  };
}

const PRICING = {
  'openai/gpt-5.5': { input: 5.0, cached: 0.5, output: 30.0 },
  'openai/gpt-4o-mini': { input: 0.15, cached: 0.075, output: 0.6 },
  'anthropic/claude-haiku-4-5': { input: 0.8, cached: 0.08, output: 4.0 },
  'google/gemini-2.5-flash': { input: 0.3, cached: 0.03, output: 2.5 },
  // Kimi (Moonshot) - PROVISIONAL per-1M-token pricing, must be reconciled
  // against the actual Vercel AI Gateway Moonshot line items before any cost
  // number from a Kimi arm is cited (reporting-standard integrity gate). These
  // are Moonshot's own list prices as of the wiring date; the gateway may mark
  // them up. kimi-k2-thinking bills its reasoning tokens as output tokens, so
  // the `output` rate dominates that arm's cost - watch the Avg output tok /
  // Avg reasoning tok columns in the report.
  'moonshotai/kimi-k2-thinking': { input: 0.6, cached: 0.15, output: 2.5 },
  'moonshotai/kimi-k2': { input: 0.6, cached: 0.15, output: 2.5 },
};

function estimateCost(usage, modelName) {
  const p = PRICING[modelName] || PRICING['openai/gpt-4o-mini'];
  const uncached = Math.max(usage.inputTokens - usage.cachedTokens, 0);
  return ((uncached * p.input) + (usage.cachedTokens * p.cached) + (usage.outputTokens * p.output)) / 1_000_000;
}

function buildInstructions(criterionId, useBoundary) {
  const c = CRITERIA[criterionId];
  const memory = useBoundary ? `\n${c.boundary}\nUse the boundary table to calibrate this criterion. Do not add criteria. Do not require exact wording.\n` : '';
  return `You are Cramapple's AP Biology FRQ grader.
Grade only criterion ${criterionId}.
Criterion: ${c.text}
${memory}
Return only valid JSON with this shape:
{
  "status": "earned|not_earned|unable_to_determine",
  "confidence": 0,
  "evidence_quote": "verbatim phrase or empty string",
  "minimal_fix": "short repair move or empty string",
  "gate": "pass|fail"
}`;
}

function buildInput(row, criterionId) {
  return `Question ID: ${FRQ_ID}

Prompt:
${PROMPT}

Criterion to grade:
${criterionId}: ${CRITERIA[criterionId].text}

Student response ID: ${row.response_id}
Student response:
${row.answer_text}`.trim();
}

function prefilterCheck(row, criterionId) {
  const t1 = performance.now();
  const text = String(row.answer_text || '').trim();
  let result = null;
  if (text.length < MIN_LENGTH_FLOOR) {
    result = { status: 'not_earned', gate: 'fail', evidence_quote: '', reason: 'empty_or_below_length_floor' };
  } else if (REFUSAL_PATTERNS.some((re) => re.test(text))) {
    result = { status: 'not_earned', gate: 'fail', evidence_quote: '', reason: 'refusal_pattern' };
  } else {
    const lower = text.toLowerCase();
    // FRQ-level (not per-criterion) topicality check - see PREFILTER_OFF_TOPIC_VOCAB
    // comment. A response that uses none of this broad vocabulary is answering a
    // different question entirely, not just missing one criterion's preferred wording.
    const isOnTopic = PREFILTER_OFF_TOPIC_VOCAB.some((term) => lower.includes(term));
    if (!isOnTopic) {
      result = { status: 'unable_to_determine', gate: 'fail', evidence_quote: '', reason: 'off_topic_no_frq_vocab' };
    }
  }
  const t1Ms = performance.now() - t1;
  return result ? { ...result, t1Ms } : null;
}

async function withTimeout(promise, ms) {
  let timer;
  const timeout = new Promise((resolve) => {
    timer = setTimeout(() => resolve({ timedOut: true }), ms);
  });
  const result = await Promise.race([promise.then((v) => ({ timedOut: false, value: v })), timeout]);
  clearTimeout(timer);
  return result;
}

async function runOneCall(modelName, instructions, input, reasoningEffort, maxOutputTokens, providerOptions) {
  const tCallStart = performance.now();
  const model = resolveModel(modelName);
  if (!model) {
    return { final: null, usage: { inputTokens: 0, outputTokens: 0, reasoningTokens: 0, cachedTokens: 0 }, costUsd: 0, t3Ms: 0, t4Ms: 0, ok: false, error: `model ${modelName} unavailable`, schemaValid: false };
  }
  let firstChunkAt = null;
  let lastChunkAt = null;
  const mergedProviderOptions = {
    ...(reasoningEffort ? { openai: { reasoningEffort } } : {}),
    ...(providerOptions || {}),
  };
  const result = streamObject({
    model,
    schema: SCHEMA,
    prompt: `${instructions}\n\n${input}`,
    ...(Object.keys(mergedProviderOptions).length ? { providerOptions: mergedProviderOptions } : {}),
    maxOutputTokens,
  });
  try {
    for await (const _chunk of result.partialObjectStream) {
      if (firstChunkAt === null) firstChunkAt = performance.now();
      lastChunkAt = performance.now();
    }
    const final = await result.object;
    const usage = usageCounts(await result.usage);
    const schemaValid = Boolean(final && typeof final === 'object' && typeof final.status === 'string' && typeof final.confidence === 'number');
    return {
      final,
      usage,
      costUsd: estimateCost(usage, modelName),
      t3Ms: firstChunkAt ? firstChunkAt - tCallStart : performance.now() - tCallStart,
      t4Ms: firstChunkAt && lastChunkAt ? lastChunkAt - firstChunkAt : 0,
      ok: true,
      error: '',
      schemaValid,
    };
  } catch (err) {
    return {
      final: null,
      usage: { inputTokens: 0, outputTokens: 0, reasoningTokens: 0, cachedTokens: 0 },
      costUsd: 0,
      t3Ms: firstChunkAt ? firstChunkAt - tCallStart : performance.now() - tCallStart,
      t4Ms: 0,
      ok: false,
      error: err?.message ?? String(err),
      schemaValid: false,
    };
  }
}

async function gradeCriterionModelResolved(row, criterionId, arm, armName) {
  const t1Start = performance.now();
  const instructions = buildInstructions(criterionId, arm.boundaryMemory);
  const input = buildInput(row, criterionId);
  const t1Ms = performance.now() - t1Start;

  const t2Start = performance.now();
  const phash = promptHash(`${instructions}\n\n${input}`);
  const t2Ms = performance.now() - t2Start;

  // Bug found via Codex QA (2026-06-18): this previously awaited runOneCall()
  // BEFORE racing it against the timeout, so withTimeout was racing an
  // already-resolved value against the clock - it could never actually time
  // out. Every arm sets criterionTimeoutMs, so this meant no timeout had ever
  // fired in any run this session. Fixed by racing the call's own promise.
  // Note: the underlying call isn't cancelled on timeout (no AbortController
  // wired in) - it keeps running server-side, we just stop waiting on it.
  const attemptPromise = runOneCall(arm.model, instructions, input, arm.reasoningEffort, arm.maxOutputTokens, arm.providerOptions);
  let retried = false;
  let timedOut = false;
  let attempt;

  if (arm.criterionTimeoutMs) {
    const raced = await withTimeout(attemptPromise, arm.criterionTimeoutMs);
    if (raced.timedOut) {
      timedOut = true;
      attempt = { final: null, usage: { inputTokens: 0, outputTokens: 0, reasoningTokens: 0, cachedTokens: 0 }, costUsd: 0, t3Ms: arm.criterionTimeoutMs, t4Ms: 0, ok: false, error: 'criterion_call_timeout', schemaValid: false };
    } else {
      attempt = raced.value;
    }
  } else {
    attempt = await attemptPromise;
  }

  if (!timedOut && !attempt.schemaValid) {
    retried = true;
    attempt = await runOneCall(arm.model, instructions, input, arm.reasoningEffort, arm.maxOutputTokens, arm.providerOptions);
  }

  let escalationTriggered = false;
  let escalationReason = '';
  let escalationTimedOut = false;
  let finalAttempt = attempt;
  let combinedUsage = attempt.usage;
  let combinedCost = attempt.costUsd;
  let combinedT3 = attempt.t3Ms;
  let combinedT4 = attempt.t4Ms;

  if (arm.escalates && !timedOut) {
    const parsed = attempt.final || {};
    const confidenceThreshold = confidenceThresholdFor(criterionId);
    const lowConfidence = typeof parsed.confidence === 'number' ? parsed.confidence < confidenceThreshold : true;
    const needsEscalation =
      !attempt.ok ||
      !attempt.schemaValid ||
      lowConfidence ||
      (parsed.evidence_quote === '' && parsed.status === 'earned') ||
      (parsed.gate === 'fail' && parsed.status === 'earned');

    if (needsEscalation) {
      escalationTriggered = true;
      escalationReason = !attempt.ok || !attempt.schemaValid
        ? 'schema_or_primary_error'
        : (parsed.gate === 'fail' && parsed.status === 'earned')
          ? 'gate_status_invariant'
          : (parsed.evidence_quote === '' && parsed.status === 'earned')
            ? 'empty_evidence_invariant'
            : 'low_confidence';
      const escInstructions = buildInstructions(criterionId, true);
      // maxOutputTokens defaults to 200 (unchanged for every existing arm), but
      // is overridable so a thinking model used as the escalation target gets
      // enough headroom to reason AND emit the JSON verdict - a 200-token cap
      // would truncate it mid-reasoning, the same failure mode the primary
      // Kimi-thinking arm avoids.
      const escPromise = runOneCall(arm.escalationModel, escInstructions, input, arm.escalationReasoningEffort, arm.escalationMaxOutputTokens || 200);
      const escRaced = arm.escalationTimeoutMs ? await withTimeout(escPromise, arm.escalationTimeoutMs) : { timedOut: false, value: await escPromise };
      const escResult = escRaced.value;
      if (escRaced.timedOut) {
        escalationTimedOut = true;
      } else {
        finalAttempt = escResult;
        combinedUsage = {
          inputTokens: attempt.usage.inputTokens + escResult.usage.inputTokens,
          outputTokens: attempt.usage.outputTokens + escResult.usage.outputTokens,
          reasoningTokens: attempt.usage.reasoningTokens + escResult.usage.reasoningTokens,
          cachedTokens: attempt.usage.cachedTokens + escResult.usage.cachedTokens,
        };
        combinedCost = attempt.costUsd + escResult.costUsd;
        combinedT3 += escResult.t3Ms;
        combinedT4 += escResult.t4Ms;
      }
    }
  }

  const t6Start = performance.now();
  const t6Ms = performance.now() - t6Start; // placeholder for persistence write; actual write happens by caller

  const totalTimedOut = timedOut || escalationTimedOut;
  const parsedFinal = totalTimedOut ? {} : (finalAttempt.final || {});
  const modelStatus = totalTimedOut ? 'unable_to_determine' : (parsedFinal.status || 'unable_to_determine');

  return {
    response_id: row.response_id,
    criterion_id: criterionId,
    experiment_arm: armName,
    resolved_by: 'model',
    prefilter_reason: '',
    model_status: modelStatus,
    confidence: typeof parsedFinal.confidence === 'number' ? parsedFinal.confidence : 0,
    evidence_quote: parsedFinal.evidence_quote || '',
    minimal_fix: parsedFinal.minimal_fix || '',
    gate: parsedFinal.gate || 'fail',
    schema_valid: !totalTimedOut && Boolean(finalAttempt.schemaValid),
    retried,
    timed_out: totalTimedOut,
    escalation_triggered: escalationTriggered,
    escalation_reason: escalationReason,
    escalation_timed_out: escalationTimedOut,
    model_id_used: escalationTriggered ? arm.escalationModel : arm.model,
    reasoning_effort_used: escalationTriggered ? arm.escalationReasoningEffort : (arm.reasoningEffort || 'n/a'),
    usage: combinedUsage,
    cost_usd: combinedCost,
    t1_ms: t1Ms,
    t2_ms: t2Ms,
    t3_ms: combinedT3,
    t4_ms: combinedT4,
    t5_ms: 0,
    t6_ms: t6Ms,
    prompt_hash: phash,
    error: totalTimedOut ? 'criterion_timeout' : (finalAttempt.error || ''),
  };
}

async function gradeCriterion(row, criterionId, arm, armName) {
  if (arm.prefilter) {
    const pre = prefilterCheck(row, criterionId);
    if (pre) {
      return {
        response_id: row.response_id,
        criterion_id: criterionId,
        experiment_arm: armName,
        resolved_by: 'prefilter',
        prefilter_reason: pre.reason,
        model_status: pre.status,
        confidence: 1,
        evidence_quote: pre.evidence_quote,
        minimal_fix: '',
        gate: pre.gate,
        schema_valid: true,
        retried: false,
        timed_out: false,
        escalation_triggered: false,
        escalation_reason: '',
        escalation_timed_out: false,
        model_id_used: '',
        reasoning_effort_used: 'n/a',
        usage: { inputTokens: 0, outputTokens: 0, reasoningTokens: 0, cachedTokens: 0 },
        cost_usd: 0,
        t1_ms: pre.t1Ms,
        t2_ms: 0,
        t3_ms: 0,
        t4_ms: 0,
        t5_ms: 0,
        t6_ms: 0,
        prompt_hash: '',
        error: '',
        audit_run: false,
        audit_flagged: false,
        audit_escalated: false,
        audit_escalation_retried: false,
        audit_parser_status: 'n/a',
        parse_first_parser_status: 'n/a',
        parse_first_routed_to: 'n/a',
      };
    }
  }
  let override = arm.criterionOverrides && arm.criterionOverrides[criterionId];
  let parseFirstStatus = 'n/a';
  let parseFirstRoutedTo = 'n/a';

  const routing = arm.parseFirstRouting && arm.parseFirstRouting[criterionId];
  if (routing) {
    const parserResponse = await checkMisattribution(row.response_id, row.answer_text);
    parseFirstStatus = parserResponse.ok ? parserResponse.result.parser_status : `error: ${parserResponse.error}`;
    const useHardPath = parseFirstStatus === 'not_earned';
    parseFirstRoutedTo = useHardPath ? 'hard' : 'fast';
    override = useHardPath ? routing.hardPath : routing.fastPath;
  }

  const effectiveArm = override ? { ...arm, ...override } : arm;
  const result = await gradeCriterionModelResolved(row, criterionId, effectiveArm, armName);
  const withRouting = { ...result, parse_first_parser_status: parseFirstStatus, parse_first_routed_to: parseFirstRoutedTo };
  return applyMisattributionAudit(row, criterionId, arm, withRouting);
}

async function applyMisattributionAudit(row, criterionId, arm, result) {
  const auditConfig = arm.misattributionAudit && arm.misattributionAudit[criterionId];
  const base = { ...result, audit_run: false, audit_flagged: false, audit_escalated: false, audit_escalation_retried: false, audit_parser_status: 'n/a' };
  if (!auditConfig || result.model_status !== 'earned' || result.timed_out) {
    return base;
  }

  base.audit_run = true;
  const parserResponse = await checkMisattribution(row.response_id, row.answer_text);
  if (!parserResponse.ok) {
    base.audit_parser_status = `error: ${parserResponse.error}`;
    return base;
  }
  const parserStatus = parserResponse.result.parser_status;
  base.audit_parser_status = parserStatus;

  if (parserStatus !== 'not_earned') {
    // Parser agrees (or abstains via unable_to_determine) - no disagreement, nothing to escalate.
    return base;
  }

  base.audit_flagged = true;
  base.audit_escalated = true;
  const instructions = buildInstructions(criterionId, true);
  const input = buildInput(row, criterionId);
  let escalated = await runOneCall(
    auditConfig.escalateToModel,
    instructions,
    input,
    auditConfig.escalateToReasoningEffort,
    auditConfig.escalateToMaxOutputTokens || 200,
  );
  let escalationRetried = false;
  if (!escalated.schemaValid) {
    // Bounded retry, matching the primary path's behavior - found via smoke
    // testing that gpt-5.5 has an elevated schema-failure rate on exactly the
    // hard-cluster cases this audit exists to catch, and without a retry here
    // the escalation silently does nothing on the cases that need it most.
    escalationRetried = true;
    escalated = await runOneCall(
      auditConfig.escalateToModel,
      instructions,
      input,
      auditConfig.escalateToReasoningEffort,
      auditConfig.escalateToMaxOutputTokens || 200,
    );
  }
  base.audit_escalation_retried = escalationRetried;
  if (!escalated.schemaValid) {
    // Escalation itself failed to produce valid output even after retry -
    // keep the original verdict rather than discard a result for an invalid one.
    base.error = base.error || `audit_escalation_failed: ${escalated.error}`;
    return base;
  }

  const finalParsed = escalated.final;
  return {
    ...base,
    model_status: finalParsed.status || 'unable_to_determine',
    confidence: typeof finalParsed.confidence === 'number' ? finalParsed.confidence : 0,
    evidence_quote: finalParsed.evidence_quote || '',
    minimal_fix: finalParsed.minimal_fix || '',
    gate: finalParsed.gate || 'fail',
    schema_valid: true,
    model_id_used: auditConfig.escalateToModel,
    reasoning_effort_used: auditConfig.escalateToReasoningEffort,
    usage: {
      inputTokens: base.usage.inputTokens + escalated.usage.inputTokens,
      outputTokens: base.usage.outputTokens + escalated.usage.outputTokens,
      reasoningTokens: base.usage.reasoningTokens + escalated.usage.reasoningTokens,
      cachedTokens: base.usage.cachedTokens + escalated.usage.cachedTokens,
    },
    cost_usd: base.cost_usd + escalated.costUsd,
    t3_ms: base.t3_ms + escalated.t3Ms,
    t4_ms: base.t4_ms + escalated.t4Ms,
  };
}

async function gradeResponseForArm(row, armName) {
  const arm = Arms[armName];
  const startedAt = performance.now();
  let criterionResults;
  if (arm.parallelCriteria) {
    criterionResults = await Promise.all(CRITERION_IDS.map((cid) => gradeCriterion(row, cid, arm, armName)));
  } else {
    criterionResults = [];
    for (const cid of CRITERION_IDS) {
      criterionResults.push(await gradeCriterion(row, cid, arm, armName));
    }
  }
  const endToEndMs = arm.parallelCriteria
    ? Math.max(...criterionResults.map((r) => r.t1_ms + r.t2_ms + r.t3_ms + r.t4_ms + r.t5_ms + r.t6_ms))
    : criterionResults.reduce((sum, r) => sum + r.t1_ms + r.t2_ms + r.t3_ms + r.t4_ms + r.t5_ms + r.t6_ms, 0);

  return criterionResults.map((r) => ({
    ...r,
    frq_id: FRQ_ID,
    clarity: clarityOf(row.response_id),
    human_status: row.criterion_labels[r.criterion_id],
    answer_text: row.answer_text,
    boundary_tags: row.boundary_tags || [],
    reviewer_note: row.reviewer_note || '',
    routing: routingFor(arm.model),
    primary_model_id: r.model_id_used || arm.model,
    escalation_model_id: r.escalation_triggered ? arm.escalationModel : '',
    reasoning_effort: r.reasoning_effort_used || arm.reasoningEffort || 'n/a',
    parallel_criteria: arm.parallelCriteria,
    frq_end_to_end_ms: Math.round(endToEndMs * 1000) / 1000,
    run_started_at: new Date().toISOString(),
  }));
}

async function mapWithConcurrency(items, limit, fn) {
  const results = new Array(items.length);
  let next = 0;
  async function worker() {
    while (next < items.length) {
      const i = next++;
      results[i] = await fn(items[i], i);
    }
  }
  await Promise.all(Array.from({ length: Math.min(limit, items.length) }, worker));
  return results;
}

function parseArgs(argv) {
  const out = { limit: 40, output: DEFAULT_OUTPUT, arms: Object.keys(Arms) };
  for (let i = 2; i < argv.length; i += 1) {
    const arg = argv[i];
    if (arg === '--limit') out.limit = Number(argv[++i]);
    else if (arg === '--output') out.output = argv[++i];
    else if (arg === '--arms') out.arms = argv[++i].split(',').map((s) => s.trim()).filter(Boolean);
    else if (arg === '--dry-run') out.dryRun = true;
    else fail(`unknown argument ${arg}`);
  }
  return out;
}

async function main() {
  const args = parseArgs(process.argv);
  const modelAuthPresent = gatewayAvailable() || Boolean(process.env.OPENAI_API_KEY);
  if (!modelAuthPresent && !args.dryRun) fail('AI_GATEWAY_API_KEY, VERCEL_OIDC_TOKEN, or OPENAI_API_KEY is not set');

  const allRows = loadRows(LABELS_PATH);
  const corpus = selectCorpus(allRows, args.limit);

  if (args.dryRun) {
    console.log(`Dry run OK. Corpus n=${corpus.length}. Cluster present: ${corpus.filter((r) => AMBIGUOUS_CLUSTER.has(r.response_id)).length}/5.`);
    console.log(`Arms: ${args.arms.join(', ')}`);
    console.log(`Planned criterion calls: ${corpus.length * args.arms.length * CRITERION_IDS.length} (excluding escalation/retry)`);
    console.log(`Response IDs: ${corpus.map((r) => r.response_id).join(', ')}`);
    return;
  }

  fs.mkdirSync(path.dirname(args.output), { recursive: true });
  const done = new Set();
  if (fs.existsSync(args.output)) {
    for (const line of fs.readFileSync(args.output, 'utf8').split('\n').filter(Boolean)) {
      const row = JSON.parse(line);
      done.add(`${row.experiment_arm}:${row.response_id}`);
    }
  }

  const stream = fs.createWriteStream(args.output, { flags: 'a' });
  const work = [];
  for (const armName of args.arms) {
    if (!Arms[armName]) fail(`unknown arm ${armName}`);
    for (const row of corpus) {
      const key = `${armName}:${row.response_id}`;
      if (done.has(key)) continue;
      work.push({ armName, row });
    }
  }

  console.log(`Total response x arm units to run: ${work.length} (criteria run within each unit)`);
  let completed = 0;
  await mapWithConcurrency(work, CONCURRENCY, async ({ armName, row }) => {
    const criterionRows = await gradeResponseForArm(row, armName);
    for (const r of criterionRows) {
      // t6_ms already set by gradeCriterionModelResolved/prefilter path (persistence write only).
      // Do not overwrite here - a prior version of this line measured from before the model
      // call instead of after validation, which double-counted T3+T4 into T6.
      stream.write(`${JSON.stringify(r)}\n`);
    }
    completed += 1;
    if (completed % 10 === 0 || completed === work.length) {
      console.log(`${completed}/${work.length} response x arm units complete`);
    }
  });

  await new Promise((resolve) => stream.end(resolve));
  shutdownMisattributionChecker();
  console.log(`Wrote SP-1 pilot JSONL: ${args.output}`);
}

await main();
