// Deterministic-key invariant harness (replan 2026-08-10 item 1.1).
//
// For every STATISTICS_TARGETS entry in
// supabase/functions/_shared/statistics-verifier.ts, this module runs
// checkStatisticsDeterministicEvidence against every repo gold-set answer
// for that content_key and compares the checker's verdict with what the
// answer's generation script says about the keyed numeric elements:
//   - script marks every keyed numeric element PRESENT  -> expect "pass"
//   - script marks any keyed numeric element ABSENT     -> expect "flag"
//
// Why this exists: the checker's keys were authored as bare constants with
// no test tying them to any answer. APSTATS-SFRQ-008 shipped with values
// [1.8, 4.9] transcribed from the item's RETIRED v1 canonical_answer_1;
// the published item (v3, content_hash 975e2fdf9139370feef4597f46c61d73)
// keys E(X) = -1.40 / SD ~ 4.477, so every correct student response was
// deterministically flagged and zeroed. The invariant this harness makes
// standing: a gold answer that contains the keyed evidence must never be
// flagged (that is the learner-harming direction).
//
// Two failure directions are deliberately treated differently:
//   - FALSE FLAG (all keyed elements present, checker says "flag"): hard
//     test failure, always. This is the production-harm direction -- the
//     deterministic gate zeroes the response and the model never sees it.
//   - FALSE PASS (a keyed element absent, checker says "pass"): the
//     lenient direction -- the response continues to the LLM grader, so
//     the cost is a missed cheap catch, not a wrong grade. These are
//     tracked against an explicit allowlist (KNOWN_FALSE_PASSES) so any
//     NEW false pass still fails the suite, but the documented detector
//     limitations (keyed values colliding with stimulus givens, ECF-style
//     mentions of the correct value inside a wrong computation, and
//     answers whose script sig is contested by the verifier families) do
//     not produce a permanently red test.
//
// Run directly for the markdown audit table
// (docs/research/DETERMINISTIC_KEY_AUDIT_2026_08_11.md was generated from
// this output):
//   deno run --allow-read scripts/grading-model-assessment/verify_deterministic_keys.ts

import {
  checkStatisticsDeterministicEvidence,
  NUMERIC_ELEMENT_CRITERIA,
  STATISTICS_TARGETS,
} from "../../supabase/functions/_shared/statistics-verifier.ts";

// NUMERIC_ELEMENT_CRITERIA now lives in statistics-verifier.ts (replan O2,
// 2026-08-13) -- it's runtime-consumed there (per-criterion flag scoping),
// not just an audit input, so that's the single source of truth. Re-exported
// here so this script's own imports (and existing callers of this module)
// don't need to change.
export { NUMERIC_ELEMENT_CRITERIA };

// Documented detector limitations with the current gold corpus: answers
// whose script marks a keyed element absent but whose text still trips the
// substring number-match. Each carries its mechanism. Adding a new key or
// regenerating the corpus that changes this set fails the suite until the
// change is reviewed and this list is updated.
export const KNOWN_FALSE_PASSES: Array<{
  content_key: string;
  answer_type: string;
  mechanism: string;
}> = [
  // Script-contested answers: the writer's script planned the omission but
  // the produced text contains the computation anyway; the verifier
  // families disagreed with the script and the answers were routed
  // discard/reader_queue. The checker is arguably CORRECT on these -- the
  // values are literally present.
  { content_key: "APSTATS-SFRQ-002", answer_type: "A4", mechanism: "script-contested (route=discard): text computes both z-scores despite script sig 0101" },
  { content_key: "APSTATS-SFRQ-002", answer_type: "A8", mechanism: "script-contested (route=discard): text computes both z-scores despite script sig 1000" },
  { content_key: "APSTATS-SFRQ-003", answer_type: "A8", mechanism: "script-contested (route=discard): text reaches 76.6 and -2.6 despite script sig 1000" },
  { content_key: "APSTATS-SFRQ-004", answer_type: "A4", mechanism: "script-contested (route=reader_queue): text computes 5.25 and -0.25 despite script sig 0101" },
  // Genuine detector limitations on unanimously-accepted answers:
  { content_key: "APSTATS-SFRQ-004", answer_type: "A5", mechanism: "ECF-mention collision: b1 miscomputed (14.35) but the text hypothesizes 'if the predicted was 5.25' and computes the residual from it" },
  { content_key: "APSTATS-SFRQ-007", answer_type: "A5", mechanism: "given-value collision: keyed mean 5 matches the '5' in 'P(X = 5)' even though the mean is stated as 2.24" },
  { content_key: "APSTATS-SFRQ-007", answer_type: "A7", mechanism: "given-value collision: keyed mean 5 matches the '5' in 'P(X = 5)'/'(20 choose 5)'; mean never computed" },
  { content_key: "APSTATS-SFRQ-009", answer_type: "A4", mechanism: "given-value collision: keyed mean 0.28 equals the stimulus's given p = 0.28, quoted inside the sd formula" },
];

export type GoldAnswer = {
  content_key: string;
  answer_type: string;
  route: string;
  script_sig: string;
  answer_text: string;
  present: Record<string, boolean>;
};

const REPO_ROOT = new URL("../../", import.meta.url);
const GOLD_ANSWER_FILES = [
  "scripts/content-seed/gold-set/stage1_answers.jsonl",
  "scripts/content-seed/gold-set/apstats_multipoint_answers.jsonl",
];

export function loadGoldAnswers(): GoldAnswer[] {
  const answers: GoldAnswer[] = [];
  for (const relative of GOLD_ANSWER_FILES) {
    const text = Deno.readTextFileSync(new URL(relative, REPO_ROOT));
    for (const line of text.split("\n")) {
      if (!line.trim()) continue;
      const record = JSON.parse(line);
      const present: Record<string, boolean> = {};
      for (const element of record.script.expected) {
        present[element.criterion_key] = element.present;
      }
      answers.push({
        content_key: record.content_key,
        answer_type: record.answer_type,
        route: record.route,
        script_sig: record.script_sig,
        answer_text: record.answer_text,
        present,
      });
    }
  }
  return answers;
}

export type AnswerVerdict = {
  content_key: string;
  answer_type: string;
  route: string;
  script_sig: string;
  expected: "pass" | "flag";
  actual: string;
  agree: boolean;
};

export type EntryAudit = {
  content_key: string;
  kind: "keyed" | "null";
  goldCoverage: boolean;
  verdicts: AnswerVerdict[];
  falseFlags: AnswerVerdict[];
  falsePasses: AnswerVerdict[];
  abstainViolations: AnswerVerdict[];
};

export function auditStatisticsKeys(
  answers: GoldAnswer[] = loadGoldAnswers(),
): EntryAudit[] {
  const byKey = new Map<string, GoldAnswer[]>();
  for (const answer of answers) {
    const list = byKey.get(answer.content_key) ?? [];
    list.push(answer);
    byKey.set(answer.content_key, list);
  }

  const audits: EntryAudit[] = [];
  for (const contentKey of Object.keys(STATISTICS_TARGETS)) {
    const target = STATISTICS_TARGETS[contentKey];
    const goldAnswers = byKey.get(contentKey) ?? [];
    const audit: EntryAudit = {
      content_key: contentKey,
      kind: target === null ? "null" : "keyed",
      goldCoverage: goldAnswers.length > 0,
      verdicts: [],
      falseFlags: [],
      falsePasses: [],
      abstainViolations: [],
    };

    for (const answer of goldAnswers) {
      const actual = checkStatisticsDeterministicEvidence({
        contentKey,
        responseText: answer.answer_text,
      })?.status ?? "none";

      if (target === null) {
        // Null entries must abstain on every answer -- they are declared
        // conceptual/corpus-defective for numeric checking.
        if (actual !== "abstain") {
          audit.abstainViolations.push({
            content_key: contentKey,
            answer_type: answer.answer_type,
            route: answer.route,
            script_sig: answer.script_sig,
            expected: "pass",
            actual,
            agree: false,
          });
        }
        continue;
      }

      const numericCriteria = NUMERIC_ELEMENT_CRITERIA[contentKey];
      if (!numericCriteria) {
        throw new Error(
          `Keyed entry ${contentKey} has gold answers but no NUMERIC_ELEMENT_CRITERIA mapping -- add one before trusting the audit`,
        );
      }
      const expected = numericCriteria.every((key) => answer.present[key])
        ? "pass" as const
        : "flag" as const;
      const verdict: AnswerVerdict = {
        content_key: contentKey,
        answer_type: answer.answer_type,
        route: answer.route,
        script_sig: answer.script_sig,
        expected,
        actual,
        agree: expected === actual,
      };
      audit.verdicts.push(verdict);
      if (!verdict.agree && expected === "pass" && actual === "flag") {
        audit.falseFlags.push(verdict);
      }
      if (!verdict.agree && expected === "flag" && actual === "pass") {
        audit.falsePasses.push(verdict);
      }
    }
    audits.push(audit);
  }
  return audits;
}

function rate(numerator: number, denominator: number) {
  return denominator === 0
    ? "n/a"
    : `${numerator}/${denominator} (${(100 * numerator / denominator).toFixed(0)}%)`;
}

if (import.meta.main) {
  const audits = auditStatisticsKeys();
  console.log(
    "| entry | kind | gold answers | expect-pass correct (specificity) | expect-flag correct (sensitivity) | false flags | false passes |",
  );
  console.log("| --- | --- | --- | --- | --- | --- | --- |");
  for (const audit of audits) {
    if (audit.kind === "null") {
      const note = audit.goldCoverage
        ? (audit.abstainViolations.length === 0
          ? "abstains on all gold answers"
          : `ABSTAIN VIOLATIONS: ${audit.abstainViolations.length}`)
        : "abstains by construction (no gold answers)";
      console.log(
        `| ${audit.content_key} | null | ${audit.goldCoverage ? "yes" : "no"} | ${note} | | | |`,
      );
      continue;
    }
    if (!audit.goldCoverage) {
      console.log(
        `| ${audit.content_key} | keyed | none | no repo evidence -- needs canonical fetch | | | |`,
      );
      continue;
    }
    const expectPass = audit.verdicts.filter((v) => v.expected === "pass");
    const expectFlag = audit.verdicts.filter((v) => v.expected === "flag");
    console.log(
      `| ${audit.content_key} | keyed | ${audit.verdicts.length} | ${
        rate(expectPass.filter((v) => v.agree).length, expectPass.length)
      } | ${rate(expectFlag.filter((v) => v.agree).length, expectFlag.length)} | ${
        audit.falseFlags.map((v) => v.answer_type).join(",") || "none"
      } | ${audit.falsePasses.map((v) => v.answer_type).join(",") || "none"} |`,
    );
  }
}
