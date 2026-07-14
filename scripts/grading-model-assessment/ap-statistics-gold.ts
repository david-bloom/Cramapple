// Converts the AP Statistics calibration gold-set candidate
// (docs/research/ap_statistics_gold_set_candidate_2026_07_08/provisional_labels.json,
// schema "provisional_calibration_labels_v1") into the flat GoldCase[] the
// assessment harness scores against.
//
// Swap-in point: the same converter accepts the *adjudicated* label file when
// human dual-blind adjudication lands, as long as it keeps the per-response
// `criteria: { <criterion_key>: { provisional_label | gold_label } }` shape.
// Nothing else in the calibration pipeline changes -- that is what makes the
// launch-bar measurement push-button once real gold exists.

import type { GoldCase, GoldCriterion } from "./harness.ts";

const CANONICAL_LABELS = new Set([
  "earned",
  "not_earned",
  "partially_earned",
  "unable_to_determine",
]);

// The provisional file already stores full label strings; label_codes maps the
// short E/P/N/U forms in case an adjudicated export uses them instead.
const CODE_ALIASES: Record<string, GoldCriterion["gold_label"]> = {
  E: "earned",
  P: "partially_earned",
  N: "not_earned",
  U: "unable_to_determine",
};

function normalizeLabel(raw: unknown, where: string): GoldCriterion["gold_label"] {
  if (typeof raw !== "string") {
    throw new Error(`${where}: missing label`);
  }
  if (CANONICAL_LABELS.has(raw)) return raw as GoldCriterion["gold_label"];
  if (raw in CODE_ALIASES) return CODE_ALIASES[raw];
  throw new Error(`${where}: unrecognized label "${raw}"`);
}

export type CalibrationLabelDoc = {
  schema?: string;
  label_authority?: string;
  corpus_defects?: Array<{ content_key: string } | string>;
  items: Array<{
    content_key: string;
    rubric?: Array<{ criterion_key: string }>;
    responses: Array<{
      response_index: number;
      response_text: string;
      criteria: Record<
        string,
        { provisional_label?: unknown; gold_label?: unknown }
      >;
      expected_repair_criterion_key?: string | null;
      forbidden_repair_phrases?: string[];
    }>;
  }>;
};

export type ConversionResult = {
  cases: GoldCase[];
  label_authority: string;
  is_provisional: boolean;
  excluded_defects: string[];
  case_count: number;
  criterion_count: number;
};

export function convertCalibrationLabels(doc: CalibrationLabelDoc): ConversionResult {
  const defects = new Set(
    (doc.corpus_defects ?? []).map((entry) =>
      typeof entry === "string" ? entry : entry.content_key
    ),
  );
  const cases: GoldCase[] = [];
  const seen = new Set<string>();
  let criterionCount = 0;

  for (const item of doc.items ?? []) {
    if (defects.has(item.content_key)) continue;
    // Preserve rubric order when present so the gold criterion order is stable.
    const rubricOrder = (item.rubric ?? []).map((r) => r.criterion_key);
    for (const response of item.responses ?? []) {
      const id = `${item.content_key}#${response.response_index}`;
      if (seen.has(id)) throw new Error(`duplicate response: ${id}`);
      seen.add(id);

      const labelled = response.criteria ?? {};
      const keys = rubricOrder.length
        ? rubricOrder.filter((key) => key in labelled)
        : Object.keys(labelled);

      const criteria: GoldCriterion[] = keys.map((key) => {
        const entry = labelled[key];
        const raw = entry?.gold_label ?? entry?.provisional_label;
        return {
          criterion_key: key,
          gold_label: normalizeLabel(raw, `${id}/${key}`),
        };
      });
      if (!criteria.length) {
        throw new Error(`${id}: no labelled criteria`);
      }
      criterionCount += criteria.length;

      const goldCase: GoldCase = {
        content_key: item.content_key,
        response_index: response.response_index,
        response_text: response.response_text,
        criteria,
      };
      if (response.expected_repair_criterion_key != null) {
        goldCase.expected_repair_criterion_key = response.expected_repair_criterion_key;
      }
      if (response.forbidden_repair_phrases?.length) {
        goldCase.forbidden_repair_phrases = response.forbidden_repair_phrases;
      }
      cases.push(goldCase);
    }
  }

  const authority = doc.label_authority ?? "unspecified";
  return {
    cases,
    label_authority: authority,
    is_provisional: /provisional/i.test(authority) ||
      doc.schema === "provisional_calibration_labels_v1",
    excluded_defects: [...defects],
    case_count: cases.length,
    criterion_count: criterionCount,
  };
}
