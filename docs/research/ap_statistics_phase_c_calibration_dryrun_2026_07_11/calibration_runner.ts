import { resolveGradingRoute } from "../../../supabase/functions/_shared/grading-router.ts";
import { checkStatisticsDeterministicEvidence } from "../../../supabase/functions/_shared/statistics-verifier.ts";
import {
  buildEcfResult,
  coerceEcfQuestion,
  findStatisticsItem,
} from "../../../supabase/functions/_shared/math-verifier.ts";

type JsonRecord = Record<string, unknown>;
type Verdict = "pass" | "flag" | "abstain";
type Label = "earned" | "partially_earned" | "not_earned" | "unable_to_determine";

type CriterionKey = {
  kind: "conceptual" | "numeric" | "numeric+ecf" | "symbolic_only";
  parts?: string[];
  note?: string;
};

type KeyItem = {
  content_key: string;
  criteria: Record<string, CriterionKey>;
  ecf_parts: Array<{
    id: string;
    points: number;
    canonical_formula: string;
    givens?: Record<string, number>;
    deps?: Record<string, string>;
    canonical_answer?: number;
    sign_sensitive?: boolean;
  }>;
  corpus_defect?: string;
};

const ROOT = new URL("../../../", import.meta.url);
const OUT_DIR = new URL("./", import.meta.url);

const LABELS_PATH =
  "docs/research/ap_statistics_gold_set_candidate_2026_07_09/provisional_labels.json";
const MANIFEST_PATH =
  "docs/research/ap_statistics_gold_set_candidate_2026_07_09/manifest.json";
const MCQ_PATH =
  "docs/research/ap_statistics_mcq_launch_bank_2026_07_09/ap_statistics_mcq_launch_bank_2026_07_09.json";
const KEYS_PATH =
  "docs/research/statistics_phase_b_2026_07_08/statistics_item_keys.json";
const PROFILE_PATH = "docs/research/AP_STATISTICS_VERIFICATION_PROFILE.json";

function repoUrl(path: string) {
  return new URL(path, ROOT);
}

async function readJson<T>(path: string): Promise<T> {
  return JSON.parse(await Deno.readTextFile(repoUrl(path))) as T;
}

function asRecord(value: unknown): JsonRecord | null {
  return value && typeof value === "object" && !Array.isArray(value)
    ? value as JsonRecord
    : null;
}

function extractNumbers(text: string) {
  const cleaned = text.replace(/,/g, "");
  return cleaned.match(/[+-]?\d*\.?\d+(?:e[+-]?\d+)?/gi)?.map(Number).filter(Number.isFinite) ??
    [];
}

function matchesTarget(candidate: number, target: number, signSensitive = false) {
  if (signSensitive && Math.sign(candidate) !== Math.sign(target)) return false;
  const base = Math.abs(target);
  if (base === 0) return Math.abs(candidate) < 1e-12;
  return Math.abs(Math.abs(candidate) - base) <= base * 0.02;
}

function classifyLabel(label: Label): "credit" | "no_credit" | "unknown" {
  if (label === "earned") return "credit";
  if (label === "not_earned" || label === "partially_earned") return "no_credit";
  return "unknown";
}

function verdictAgrees(verdict: Verdict, label: Label) {
  const grouped = classifyLabel(label);
  if (verdict === "pass") return grouped === "credit";
  if (verdict === "flag") return grouped === "no_credit";
  return grouped === "unknown";
}

function labelOf(response: JsonRecord, criterionKey: string): Label | null {
  const criteria = asRecord(response.criteria);
  const row = asRecord(criteria?.[criterionKey]);
  const label = row?.provisional_label;
  return typeof label === "string" ? label as Label : null;
}

function keyedCriterionVerdict(
  keyItem: KeyItem | undefined,
  criterionKey: string,
  responseText: string,
): { verdict: Verdict; source: string; detail: string; targets: string[] } {
  const criterion = keyItem?.criteria[criterionKey];
  if (!criterion) {
    return {
      verdict: "abstain",
      source: "no_key",
      detail: "No criterion-level deterministic key is present.",
      targets: [],
    };
  }
  if (criterion.kind === "conceptual") {
    return {
      verdict: "abstain",
      source: "keyed_conceptual",
      detail: criterion.note ?? "Criterion is explicitly conceptual in the key payload.",
      targets: [],
    };
  }
  if (criterion.kind === "symbolic_only") {
    return {
      verdict: "abstain",
      source: "symbolic_only_plain_text",
      detail: criterion.note ??
        "Criterion is method/formula-only; the plain-text corpus has no structured formula object for deterministic scoring.",
      targets: [],
    };
  }

  const partIds = criterion.parts ?? [];
  const keyedParts = keyItem?.ecf_parts.filter((part) => partIds.includes(part.id)) ?? [];
  if (keyedParts.length === 0) {
    return {
      verdict: "abstain",
      source: "no_numeric_part",
      detail: "The key marks this criterion numeric but has no canonical numeric part for this harness to compare.",
      targets: [],
    };
  }

  const numbers = extractNumbers(responseText);
  const missing = keyedParts.filter((part) =>
    typeof part.canonical_answer !== "number" ||
    !numbers.some((candidate) =>
      matchesTarget(candidate, part.canonical_answer!, Boolean(part.sign_sensitive))
    )
  );

  return {
    verdict: missing.length === 0 ? "pass" : "flag",
    source: "plain_text_numeric_adapter",
    detail: missing.length === 0
      ? "All keyed numeric target values appear in the synthetic response text within 2% relative tolerance."
      : `Missing keyed numeric target(s): ${missing.map((part) => part.id).join(", ")}.`,
    targets: keyedParts.map((part) =>
      `${part.id}=${part.canonical_answer}${part.sign_sensitive ? " sign-sensitive" : ""}`
    ),
  };
}

function maybeStructuredResponse(responseText: string): unknown | null {
  const trimmed = responseText.trim();
  if (!trimmed.startsWith("{") && !trimmed.startsWith("[")) return null;
  try {
    return JSON.parse(trimmed);
  } catch {
    return null;
  }
}

function likelyCheckableText(text: string) {
  return /\b(calculate|calculation|compute|z-score|test statistic|p-value|confidence interval|standard error|expected value|probability|regression|correlation|slope|mean|standard deviation|margin of error|percent|percentage|proportion)\b/i
    .test(text);
}

function markdownTable(headers: string[], rows: Array<Array<string | number>>) {
  const escape = (value: string | number) => String(value).replace(/\|/g, "\\|");
  return [
    `| ${headers.map(escape).join(" | ")} |`,
    `| ${headers.map(() => "---").join(" | ")} |`,
    ...rows.map((row) => `| ${row.map(escape).join(" | ")} |`),
  ].join("\n");
}

function pct(numerator: number, denominator: number) {
  return denominator === 0 ? "n/a" : `${((numerator / denominator) * 100).toFixed(1)}%`;
}

const disagreementReads = new Map<string, string>([
  [
    "APSTAT-MOD3-H001-INV|2|ci_calculation",
    "Response recomputes 120/sqrt(30) and gives (807, 893), which is arithmetically correct within rounding; deterministic flag is too strict because the SE value is not separately stated.",
  ],
  [
    "APSTAT-MOD4-H001-INV|1|hypothesis_test_execution",
    "Exact SE is about 1.56 and t is about -2.56; the response's 't approx -2.5' is arithmetically acceptable, so the deterministic flag is a missing-exact-SE artifact.",
  ],
  [
    "APSTAT-MOD6-M001|1|margin_of_error",
    "n approx 384 is the standard conservative 95%/5% sample-size result; partial provisional credit appears to reflect missing explanation rather than arithmetic error.",
  ],
  [
    "APSTAT-MOD6-M001|3|margin_of_error",
    "n approx 385 is arithmetically correct for the margin calculation; the not-earned label likely conflates this criterion with the separate bad sampling-design response.",
  ],
  [
    "APSTAT-MOD6-H001|1|test_calculation",
    "Exact SE is about 1.94 and |t| is about 2.06; the response's '2.0 to 2.1' is a reasonable rounded statistic, so the deterministic flag is too exacting for prose.",
  ],
  [
    "APSTAT-MOD7-M005|1|expected_value",
    "The keyed value 5 appears only inside a guess list ('4, 5, or 6'), not as a computed expected value; provisional not-earned is more likely correct.",
  ],
  [
    "APSTAT-MOD7-H001|2|calculation",
    "P(D)=0.023 and P(B|D) approx 0.65 are the keyed arithmetic values; provisional partial may be under-crediting a terse but numerically correct calculation.",
  ],
  [
    "APSTAT-MOD8-M002|1|r_squared_interpretation",
    "0.64 is present, but the interpretation says x explains x's variance instead of response-variable variance; provisional not-earned is more likely correct.",
  ],
  [
    "APSTAT-MOD8-M004|1|slope_interpretation",
    "The slope value 3 is present, but the interpretation is not contextual rate-of-change language; provisional not-earned is more likely correct.",
  ],
  [
    "STATS-MOD1-E004|1|mean_calculation",
    "18 appears as one raw data value, but the response divides by 4 and gives 22.5; provisional not-earned is more likely correct.",
  ],
]);

const labels = await readJson<{
  items: JsonRecord[];
  deterministic_check_targets?: unknown;
}>(LABELS_PATH);
const manifest = await readJson<JsonRecord>(MANIFEST_PATH);
const mcq = await readJson<JsonRecord[]>(MCQ_PATH);
const keys = await readJson<{ items: KeyItem[] }>(KEYS_PATH);
const profile = await readJson<{
  status: string;
  key_payload: {
    items_keyed: string[];
    conceptual_only: string[];
    excluded_corpus_defect: string[];
    symbolic_only: string[];
  };
}>(PROFILE_PATH);

const keyByContent = new Map(keys.items.map((item) => [item.content_key, item]));
const profileConceptual = new Set(profile.key_payload.conceptual_only);
const profileExcludedKeys = new Set(
  profile.key_payload.excluded_corpus_defect.map((entry) => entry.split(" ")[0]),
);

const routeCounts = new Map<string, number>();
const shadowRoutes: Array<{ content_key: string; reason: string }> = [];
const criterionResults: Array<{
  content_key: string;
  response_index: number;
  criterion_key: string;
  deterministic_verdict: Verdict;
  source: string;
  provisional_label: Label;
  agrees: boolean;
  detail: string;
  targets: string[];
  response_text: string;
}> = [];
const itemCoverage = new Map<string, "checkable" | "conceptual" | "excluded" | "gap">();
const possibleGaps: Array<{ content_key: string; reason: string }> = [];
const ecfAttempts: Array<{ content_key: string; response_index: number; status: string }> = [];

for (const item of labels.items) {
  const contentKey = String(item.content_key);
  const codex = asRecord(item.codex);
  const route = resolveGradingRoute({
    rubricType: item.rubric_type ?? codex?.rubric_type,
    evaluatorStrategy: item.evaluator_strategy ?? codex?.evaluator_strategy,
    itemType: typeof codex?.question_type === "string" ? codex.question_type : "frq",
    promptJson: item,
  });
  routeCounts.set(route.target, (routeCounts.get(route.target) ?? 0) + 1);
  if (route.target === "shadow_review") {
    shadowRoutes.push({ content_key: contentKey, reason: route.reason });
  }

  const keyItem = keyByContent.get(contentKey);
  const nonConceptualKinds = keyItem
    ? Object.values(keyItem.criteria).filter((criterion) => criterion.kind !== "conceptual")
    : [];
  if (profileExcludedKeys.has(contentKey)) {
    itemCoverage.set(contentKey, "excluded");
  } else if (nonConceptualKinds.length > 0) {
    itemCoverage.set(contentKey, "checkable");
  } else if (profileConceptual.has(contentKey) || nonConceptualKinds.length === 0 && keyItem) {
    itemCoverage.set(contentKey, "conceptual");
  } else {
    const rubricText = JSON.stringify(item.rubric ?? "") + " " + String(item.question_text ?? "");
    if (likelyCheckableText(rubricText)) {
      possibleGaps.push({
        content_key: contentKey,
        reason: "Rubric/question text contains calculation language, but no non-conceptual key is present.",
      });
      itemCoverage.set(contentKey, "gap");
    } else {
      itemCoverage.set(contentKey, "conceptual");
    }
  }

  for (const response of (item.responses as JsonRecord[] ?? [])) {
    const responseIndex = Number(response.response_index ?? 0);
    const responseText = String(response.response_text ?? "");
    const statsCheck = checkStatisticsDeterministicEvidence({
      contentKey,
      responseText,
    });

    const structured = maybeStructuredResponse(responseText);
    const mathItem = findStatisticsItem(contentKey);
    if (structured && mathItem?.ecf_parts.length) {
      const ecfQuestion = coerceEcfQuestion(mathItem, structured);
      if (ecfQuestion) {
        const result = buildEcfResult(ecfQuestion);
        ecfAttempts.push({
          content_key: contentKey,
          response_index: responseIndex,
          status: `${result.earned}/${result.possible}`,
        });
      } else {
        ecfAttempts.push({
          content_key: contentKey,
          response_index: responseIndex,
          status: "structured_response_not_coercible",
        });
      }
    } else if (mathItem?.ecf_parts.length) {
      ecfAttempts.push({
        content_key: contentKey,
        response_index: responseIndex,
        status: "plain_text_response_not_coercible",
      });
    }

    for (const [criterionKey] of Object.entries(asRecord(response.criteria) ?? {})) {
      const provisional = labelOf(response, criterionKey);
      if (!provisional) continue;
      const criterionVerdict = keyedCriterionVerdict(keyItem, criterionKey, responseText);
      const source = statsCheck?.status && criterionVerdict.verdict !== "abstain"
        ? `${criterionVerdict.source}; item_statistics_verifier=${statsCheck.status}`
        : criterionVerdict.source;
      criterionResults.push({
        content_key: contentKey,
        response_index: responseIndex,
        criterion_key: criterionKey,
        deterministic_verdict: criterionVerdict.verdict,
        source,
        provisional_label: provisional,
        agrees: verdictAgrees(criterionVerdict.verdict, provisional),
        detail: criterionVerdict.detail,
        targets: criterionVerdict.targets,
        response_text: responseText,
      });
    }
  }
}

const mcqChecks = mcq.map((item) => {
  const route = resolveGradingRoute({
    rubricType: item.rubric_type,
    evaluatorStrategy: item.evaluator_strategy,
    itemType: typeof item.item_type === "string" ? item.item_type : null,
    promptJson: item,
  });
  const choices = Array.isArray(item.choices) ? item.choices as JsonRecord[] : [];
  return {
    content_key: String(item.content_key),
    route_ok: route.target === "mcq_rule",
    correct_count: choices.filter((choice) => choice.is_correct === true).length,
  };
});

const comparable = criterionResults.filter((row) => row.deterministic_verdict !== "abstain");
const comparableAgreement = comparable.filter((row) => row.agrees);
const byVerdict = ["pass", "flag", "abstain"].map((verdict) => {
  const rows = criterionResults.filter((row) => row.deterministic_verdict === verdict);
  return [
    verdict,
    rows.length,
    rows.filter((row) => row.agrees).length,
    pct(rows.filter((row) => row.agrees).length, rows.length),
  ];
});
const disagreements = criterionResults.filter((row) =>
  row.deterministic_verdict !== "abstain" && !row.agrees
);
const abstainOnLabeled = criterionResults.filter((row) =>
  row.deterministic_verdict === "abstain" && classifyLabel(row.provisional_label) !== "unknown" &&
  Boolean(keyByContent.get(row.content_key)) &&
  keyByContent.get(row.content_key)?.criteria[row.criterion_key]?.kind !== "conceptual"
);

const coverageCounts = {
  checkable: [...itemCoverage.values()].filter((value) => value === "checkable").length,
  conceptual: [...itemCoverage.values()].filter((value) => value === "conceptual").length,
  excluded: [...itemCoverage.values()].filter((value) => value === "excluded").length,
  gap: [...itemCoverage.values()].filter((value) => value === "gap").length,
};

const routeRows = ["mcq_rule", "llm_text", "symbolic_ecf", "shadow_review"].map((target) => [
  target,
  routeCounts.get(target) ?? 0,
]);
const mcqRoutePass = mcqChecks.filter((row) => row.route_ok).length;
const mcqOneCorrectPass = mcqChecks.filter((row) => row.correct_count === 1).length;
const labelsTargetsRestored = Array.isArray(labels.deterministic_check_targets);
const manifestTargetsRestored = Array.isArray(manifest.deterministic_check_targets);
const mod6h007 = labels.items.find((item) => item.content_key === "APSTAT-MOD6-H007");
const mod6Text = JSON.stringify(mod6h007 ?? {});
const mod6FixLanded = mod6Text.includes("58.9") && !mod6Text.includes("approximately 67% confidence");

const disagreementRows = disagreements.map((row) => [
  row.content_key,
  row.response_index,
  row.criterion_key,
  row.deterministic_verdict,
  row.provisional_label,
  row.targets.join("; "),
  disagreementReads.get(`${row.content_key}|${row.response_index}|${row.criterion_key}`) ??
    (row.deterministic_verdict === "pass"
      ? "Keyed numeric target appears in the response; provisional non-earned label needs human review."
      : "Keyed numeric target is absent from the response; deterministic flag looks plausible unless the rubric accepts an alternate expression."),
]);

const abstainRows = abstainOnLabeled.map((row) => [
  row.content_key,
  row.response_index,
  row.criterion_key,
  row.source,
  row.provisional_label,
  row.detail,
]);

const possibleGapRows = possibleGaps.map((row) => [row.content_key, row.reason]);
const shadowRows = shadowRoutes.map((row) => [row.content_key, row.reason]);
const badMcqRows = mcqChecks
  .filter((row) => !row.route_ok || row.correct_count !== 1)
  .map((row) => [row.content_key, row.route_ok ? "ok" : "bad_route", row.correct_count]);

const report = `# AP Statistics Phase C Calibration Dry-Run

**Date:** 2026-07-11
**Task:** TASK-0016 Phase C deterministic-layer calibration dry-run
**Runner:** \`deno run --allow-read --allow-write docs/research/ap_statistics_phase_c_calibration_dryrun_2026_07_11/calibration_runner.ts\`

This is a tooling and measurement pass against AI-provisional labels, not the launch-gate calibration against human-adjudicated gold labels. Agreement rates below are dry-run diagnostics only.

## Inputs

- FRQ labels: \`${LABELS_PATH}\`
- MCQ bank: \`${MCQ_PATH}\`
- deterministic keys: \`${KEYS_PATH}\`
- verification profile: \`${PROFILE_PATH}\`
- profile status: ${profile.status}

## R1/R3 Staleness Check

- \`APSTAT-MOD6-H007\` R1 fix in \`provisional_labels.json\`: ${mod6FixLanded ? "landed" : "not confirmed"}.
- \`provisional_labels.json.deterministic_check_targets\`: ${labelsTargetsRestored ? "restored list-of-objects shape" : "still stale"}.
- \`manifest.json.deterministic_check_targets\`: ${manifestTargetsRestored ? "restored list-of-objects shape" : `still stale (${JSON.stringify(manifest.deterministic_check_targets)})`}.

## Coverage

${markdownTable(["bucket", "FRQ items"], [
  ["at least one non-conceptual deterministic key", coverageCounts.checkable],
  ["fully conceptual / correctly abstaining", coverageCounts.conceptual],
  ["excluded or method-only corpus defect", coverageCounts.excluded],
  ["possible checkable criterion with no key", coverageCounts.gap],
])}

The key file currently contains ${keys.items.length} item entries; ${coverageCounts.checkable} have at least one non-conceptual criterion in the local key payload. The profile's \`items_keyed\` list has ${profile.key_payload.items_keyed.length} entries, which excludes conceptual-only \`APSTAT-MOD5-H001-INV\` and excluded/method-only \`APSTAT-MOD8-H001\` even though both appear in \`statistics_item_keys.json\`.

${possibleGapRows.length ? `### Possible Coverage Gaps\n\n${markdownTable(["content_key", "reason"], possibleGapRows)}\n` : "No keyword-suspected unkeyed numeric coverage gaps were found beyond the profile's stated conceptual/excluded dispositions.\n"}
## Agreement Against Provisional Labels

Comparable deterministic verdicts exclude abstains. Raw comparable agreement: ${comparableAgreement.length}/${comparable.length} (${pct(comparableAgreement.length, comparable.length)}).

${markdownTable(["deterministic verdict", "criterion rows", "agreement rows", "agreement"], byVerdict)}

Important caveat: this is not the >=95% launch-bar criterion-agreement number. The label source is AI-provisional rather than adjudicated gold, and plain-text synthetic responses do not provide the structured typed-response object needed for a full production ECF cascade.

## Disagreements

${disagreementRows.length ? markdownTable([
  "content_key",
  "response",
  "criterion",
  "deterministic",
  "provisional",
  "keyed targets",
  "arithmetic read",
], disagreementRows) : "No pass/flag disagreements were found among comparable deterministic rows."}

## Deterministic Abstains On Non-Unknown Labels

These rows are abstains, not agreement failures. They are useful because they identify criteria where the current deterministic layer or this plain-text dry-run adapter cannot produce a comparable verdict.

${abstainRows.length ? markdownTable([
  "content_key",
  "response",
  "criterion",
  "source",
  "provisional",
  "detail",
], abstainRows) : "No non-conceptual abstain rows were found."}

## Router Dispatch

${markdownTable(["FRQ route target", "count"], routeRows)}

${shadowRows.length ? `### Shadow Review Routes\n\n${markdownTable(["content_key", "reason"], shadowRows)}\n` : "No FRQ items routed to shadow_review."}
All 100 FRQ corpus entries used the legacy \`codex.question_type: "frq"\` fallback and therefore route to \`llm_text\`; no item currently declares \`rubric_type: "structured_formula"\` in the provisional corpus JSON.

## MCQ Sanity

- MCQ route check: ${mcqRoutePass}/${mcqChecks.length} route to \`mcq_rule\`.
- MCQ answer-key shape: ${mcqOneCorrectPass}/${mcqChecks.length} have exactly one \`is_correct: true\` choice.

${badMcqRows.length ? markdownTable(["content_key", "route", "correct_count"], badMcqRows) : "No MCQ sanity failures."}

## ECF Harness Note

The runner imports \`findStatisticsItem()\`, \`coerceEcfQuestion()\`, and \`buildEcfResult()\`. The 2026-07-09 provisional FRQ corpus stores synthetic responses as prose strings, not structured per-part typed-response JSON, so ${ecfAttempts.filter((row) => row.status === "plain_text_response_not_coercible").length} ECF-capable response rows were not coercible into the production ECF input shape. The comparable numeric rows above therefore use a plain-text numeric adapter that checks whether keyed canonical part values appear in the response text within the same broad tolerance style as the statistics verifier. Re-pointing the harness at adjudicated labels later only requires changing \`LABELS_PATH\` (and preserving the same item/response/criteria shape).
`;

await Deno.writeTextFile(new URL("report.md", OUT_DIR), report);
await Deno.writeTextFile(
  new URL("summary.json", OUT_DIR),
  JSON.stringify(
    {
      coverageCounts,
      comparable: comparable.length,
      comparableAgreement: comparableAgreement.length,
      disagreements: disagreements.length,
      routeCounts: Object.fromEntries(routeCounts),
      mcqRoutePass,
      mcqOneCorrectPass,
      mod6FixLanded,
      labelsTargetsRestored,
      manifestTargetsRestored,
    },
    null,
    2,
  ) + "\n",
);

console.log(`Wrote ${new URL("report.md", OUT_DIR).pathname}`);
console.log(`Comparable agreement: ${comparableAgreement.length}/${comparable.length} (${pct(comparableAgreement.length, comparable.length)})`);
console.log(`Disagreements: ${disagreements.length}`);
