// Converts human-verified gold-set answers from the Production DB
// (app.gold_set_answers / app.gold_set_elements / app.gold_set_verification_assignments /
// app.gold_set_element_marks, schema in supabase/migrations/20260803120000_gold_set_verification.sql)
// into the flat GoldCase[] the assessment harness scores against.
//
// Unlike ap-statistics-gold.ts (which converts the AI-provisional
// provisional_labels.json file), this reads real human-verified ground truth --
// see docs/research/exemplar_grading_pilot_2026_08/ for the pilot this was built for.
//
// Input shape: pre-fetched raw rows (see RawAnswerRow / RawMarkRow below), not a
// live DB connection -- the caller is responsible for querying
// app.gold_set_answers/app.gold_set_element_marks (joined through
// app.gold_set_verification_assignments where status='submitted') and passing the
// rows in. This keeps the converter itself pure/testable and DB-client-agnostic.

import type { GoldCase, GoldCriterion } from "./harness.ts";

export type RawAnswerRow = {
  content_key: string;
  content_item_version_id: string;
  gold_set_answer_id: string;
  answer_text: string;
};

export type RawMarkRow = {
  content_key: string;
  gold_set_answer_id: string;
  gold_set_verification_assignment_id: string;
  reviewer: string;
  criterion_key: string;
  points_possible: number;
  element_index: number;
  present: boolean;
};

export type ConversionResult = {
  cases: GoldCase[];
  label_authority: "human_verified_gold_set";
  is_provisional: false;
  case_count: number;
  criterion_count: number;
  disagreement_count: number;
  disagreements: Array<{ gold_set_answer_id: string; criterion_key: string }>;
};

/**
 * Aggregation rule for collapsing element-level present/absent marks into one
 * gold_label per criterion_key, across however many reviewers submitted marks
 * for this answer (1, usually; 2 for the subset of Statistics answers that got
 * double-reviewed by both Jill Schmidlkofer and Muhammad Saood).
 *
 * - If reviewers disagree on the present/absent value of ANY element under this
 *   criterion, the criterion is "unable_to_determine" (an abstention, not a
 *   forced pick of one reviewer over the other -- scoreRun already excludes
 *   abstentions from the accuracy denominator, so this is the safe default
 *   rather than silently preferring whichever reviewer's row happened to sort
 *   first).
 * - Otherwise (unanimous per element): all elements present -> "earned"; none
 *   present -> "not_earned"; some present (multi-element criterion only) ->
 *   "partially_earned".
 */
function aggregateCriterion(
  marksByElementIndex: Map<number, Set<boolean>>,
): { label: GoldCriterion["gold_label"]; disagreed: boolean } {
  let disagreed = false;
  let anyPresent = false;
  let anyAbsent = false;
  for (const values of marksByElementIndex.values()) {
    if (values.size > 1) {
      disagreed = true;
      continue;
    }
    const value = [...values][0];
    if (value) anyPresent = true;
    else anyAbsent = true;
  }
  if (disagreed) return { label: "unable_to_determine", disagreed: true };
  if (anyPresent && anyAbsent) return { label: "partially_earned", disagreed: false };
  if (anyPresent) return { label: "earned", disagreed: false };
  return { label: "not_earned", disagreed: false };
}

export function convertGoldSetFromDb(
  answers: RawAnswerRow[],
  marks: RawMarkRow[],
): ConversionResult {
  const marksByAnswer = new Map<string, RawMarkRow[]>();
  for (const mark of marks) {
    const list = marksByAnswer.get(mark.gold_set_answer_id) ?? [];
    list.push(mark);
    marksByAnswer.set(mark.gold_set_answer_id, list);
  }

  // Stable response_index per content_key: sort answers within each item by
  // gold_set_answer_id so re-running the converter against the same DB state
  // always produces the same case IDs (the capture script in Phase 4 depends
  // on this to line up with the exported exemplars/split).
  const answersByItem = new Map<string, RawAnswerRow[]>();
  for (const answer of answers) {
    const list = answersByItem.get(answer.content_key) ?? [];
    list.push(answer);
    answersByItem.set(answer.content_key, list);
  }

  const cases: GoldCase[] = [];
  const disagreements: ConversionResult["disagreements"] = [];
  let criterionCount = 0;

  for (const [contentKey, itemAnswers] of answersByItem) {
    const sorted = [...itemAnswers].sort((a, b) =>
      a.gold_set_answer_id.localeCompare(b.gold_set_answer_id)
    );
    sorted.forEach((answer, responseIndex) => {
      const answerMarks = marksByAnswer.get(answer.gold_set_answer_id) ?? [];
      if (!answerMarks.length) {
        throw new Error(
          `${contentKey}#${responseIndex} (${answer.gold_set_answer_id}): no marks found -- ` +
            `every answer in the held-out pool must have at least one submitted verification`,
        );
      }
      const byCriterion = new Map<string, Map<number, Set<boolean>>>();
      for (const mark of answerMarks) {
        const byElement = byCriterion.get(mark.criterion_key) ?? new Map<number, Set<boolean>>();
        const values = byElement.get(mark.element_index) ?? new Set<boolean>();
        values.add(mark.present);
        byElement.set(mark.element_index, values);
        byCriterion.set(mark.criterion_key, byElement);
      }

      const criteria: GoldCriterion[] = [];
      for (const [criterionKey, byElement] of byCriterion) {
        const { label, disagreed } = aggregateCriterion(byElement);
        criteria.push({ criterion_key: criterionKey, gold_label: label });
        if (disagreed) disagreements.push({ gold_set_answer_id: answer.gold_set_answer_id, criterion_key: criterionKey });
      }
      criteria.sort((a, b) => a.criterion_key.localeCompare(b.criterion_key));
      criterionCount += criteria.length;

      cases.push({
        content_key: contentKey,
        response_index: responseIndex,
        response_text: answer.answer_text,
        criteria,
      });
    });
  }

  cases.sort((a, b) =>
    a.content_key === b.content_key
      ? a.response_index - b.response_index
      : a.content_key.localeCompare(b.content_key)
  );

  return {
    cases,
    label_authority: "human_verified_gold_set",
    is_provisional: false,
    case_count: cases.length,
    criterion_count: criterionCount,
    disagreement_count: disagreements.length,
    disagreements,
  };
}

if (import.meta.main) {
  const args = new Map<string, string>();
  for (let i = 0; i < Deno.args.length; i += 2) {
    args.set(Deno.args[i].replace(/^--/, ""), Deno.args[i + 1]);
  }
  const answersPath = args.get("answers");
  const marksPath = args.get("marks");
  const outPath = args.get("out");
  if (!answersPath || !marksPath || !outPath) {
    console.error(
      "usage: deno run --allow-read --allow-write gold-set-db.ts --answers ANSWERS.json --marks MARKS.json --out GOLD.json",
    );
    Deno.exit(1);
  }
  const answers: RawAnswerRow[] = JSON.parse(await Deno.readTextFile(answersPath));
  const marks: RawMarkRow[] = JSON.parse(await Deno.readTextFile(marksPath));
  const result = convertGoldSetFromDb(answers, marks);
  await Deno.writeTextFile(outPath, JSON.stringify(result.cases, null, 2));
  console.log(JSON.stringify(
    {
      case_count: result.case_count,
      criterion_count: result.criterion_count,
      disagreement_count: result.disagreement_count,
      disagreements: result.disagreements,
    },
    null,
    2,
  ));
}
