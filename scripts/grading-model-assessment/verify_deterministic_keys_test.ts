// Standing invariant tests for the deterministic Statistics keys (replan
// 2026-08-10 item 1.1). See verify_deterministic_keys.ts's header for the
// full rationale; the short version: STATISTICS_TARGETS entries were bare,
// untested constants, and APSTATS-SFRQ-008 shipped with values transcribed
// from a retired canonical answer, deterministically zeroing every correct
// response. These tests keep the keys tied to the gold-set evidence
// forever.

import {
  auditStatisticsKeys,
  KNOWN_FALSE_PASSES,
  loadGoldAnswers,
  NUMERIC_ELEMENT_CRITERIA,
} from "./verify_deterministic_keys.ts";
import { STATISTICS_TARGETS } from "../../supabase/functions/_shared/statistics-verifier.ts";

const audits = auditStatisticsKeys(loadGoldAnswers());

Deno.test("no gold answer containing the keyed evidence is ever flagged (production-harm invariant)", () => {
  const falseFlags = audits.flatMap((audit) => audit.falseFlags);
  if (falseFlags.length > 0) {
    throw new Error(
      "false flags -- a correct answer would be deterministically zeroed:\n" +
        falseFlags.map((v) => `  ${v.content_key} ${v.answer_type} (sig=${v.script_sig})`).join("\n"),
    );
  }
});

Deno.test("false passes match the documented detector-limitation allowlist exactly", () => {
  const actual = audits
    .flatMap((audit) => audit.falsePasses)
    .map((v) => `${v.content_key}/${v.answer_type}`)
    .sort();
  const expected = KNOWN_FALSE_PASSES
    .map((entry) => `${entry.content_key}/${entry.answer_type}`)
    .sort();
  if (JSON.stringify(actual) !== JSON.stringify(expected)) {
    throw new Error(
      `false-pass drift.\n  expected: ${expected.join(", ")}\n  actual:   ${actual.join(", ")}\n` +
        "A new false pass means a key stopped discriminating (or the corpus changed); " +
        "a vanished one means the allowlist is stale. Review, then update KNOWN_FALSE_PASSES.",
    );
  }
});

Deno.test("null entries abstain on every gold answer", () => {
  const violations = audits.flatMap((audit) => audit.abstainViolations);
  if (violations.length > 0) {
    throw new Error(
      "null (conceptual) entries must abstain:\n" +
        violations.map((v) => `  ${v.content_key} ${v.answer_type} -> ${v.actual}`).join("\n"),
    );
  }
});

Deno.test("APSTATS-SFRQ-008 corrected keys discriminate on all 8 gold answers", () => {
  // Regression pin for the 2026-08-11 correction ([1.8, 4.9] -> [-1.40,
  // 4.477]). Before the fix this item false-flagged 4/4 evidence-present
  // answers (A1, A2, A3, A6).
  const audit = audits.find((entry) => entry.content_key === "APSTATS-SFRQ-008");
  if (!audit || audit.verdicts.length !== 8) {
    throw new Error("expected 8 gold answers for APSTATS-SFRQ-008");
  }
  const wrong = audit.verdicts.filter((v) => !v.agree);
  if (wrong.length > 0) {
    throw new Error(
      "SFRQ-008 verdict mismatches: " +
        wrong.map((v) => `${v.answer_type} expected=${v.expected} actual=${v.actual}`).join(", "),
    );
  }
});

Deno.test("every keyed entry either has gold coverage or is on the known needs-canonical-fetch list", () => {
  // These entries have no gold-set answers in the repo, so the harness can
  // only validate them against the item's canonical answer (fetched
  // read-only from Production; see
  // docs/research/DETERMINISTIC_KEY_AUDIT_2026_08_11.md for the 2026-08-11
  // canonical validation of each). If gold answers are later generated for
  // one of them, remove it here so the answer-level audit becomes binding.
  const KNOWN_UNCOVERED = new Set([
    "APSTAT-MOD3-H001-INV",
    "APSTAT-MOD6-H001",
    "APSTAT-MOD7-H001",
    "APSTATS-SFRQ-011",
    "APSTATS-SFRQ-012",
    "APSTATS-SFRQ-013",
    "APSTATS-SFRQ-014",
    "APSTATS-SFRQ-015",
    "APSTATS-SFRQ-016",
    "APSTATS-SFRQ-017",
    "APSTATS-SFRQ-018",
  ]);
  for (const audit of audits) {
    if (audit.kind !== "keyed") continue;
    if (!audit.goldCoverage && !KNOWN_UNCOVERED.has(audit.content_key)) {
      throw new Error(
        `${audit.content_key} is keyed but has no gold coverage and is not on the known list -- ` +
          "new keys must ship with gold evidence or an explicit canonical-only registration",
      );
    }
    if (audit.goldCoverage && KNOWN_UNCOVERED.has(audit.content_key)) {
      throw new Error(
        `${audit.content_key} now has gold coverage -- remove it from KNOWN_UNCOVERED so the audit binds`,
      );
    }
  }
});

Deno.test("every gold-covered keyed entry declares its numeric-element criteria", () => {
  const coveredKeys = new Set(loadGoldAnswers().map((answer) => answer.content_key));
  for (const contentKey of Object.keys(STATISTICS_TARGETS)) {
    if (STATISTICS_TARGETS[contentKey] === null) continue;
    if (coveredKeys.has(contentKey) && !NUMERIC_ELEMENT_CRITERIA[contentKey]) {
      throw new Error(`missing NUMERIC_ELEMENT_CRITERIA mapping for ${contentKey}`);
    }
  }
});
