// Tests for stripping stray control characters from model-written grading text.
//
// Origin: the TASK-0074 pilot (2026-10-14) found stray control characters in
// 5 of 159 model-written fields across 4 of 53 graded calls: U+001A, U+007F and
// U+0012/U+0013 around a quoted equation, and an ANSI colour sequence. They
// appeared with plain and LaTeX rubrics alike, so they are an output-hygiene
// problem, not a LaTeX one. These fields are stored and shown to students.
// Removing non-printing characters cannot change what a student reads; the
// ANSI case needs the whole sequence removed, or "[1m" is left on screen.

import {
  asCleanString,
  sanitizeModelResult,
  stripStrayControlChars,
} from "./grading-feedback.ts";

const RESPONSE =
  "The net force is 25 N - 15 N = 10 N, so a = F/m = 2.0 m/s^2 to the right.";

function source(key = "c1", points = 1) {
  return {
    criterion_key: key,
    learner_facing_text: `criterion ${key}`,
    points_possible: points,
    evidence_requirements: null,
    minimum_fix: `fix ${key}`,
    accepted_variants: null,
  };
}

function grade(
  model: Record<string, unknown>,
  response: string = RESPONSE,
  summary: string | null = "summary",
) {
  return sanitizeModelResult(
    {
      criteria: [{ criterion_key: "c1", status: "earned", points_awarded: 1, ...model }],
      student_facing_summary: summary,
      confidence: "high",
      uncertainty_reason: null,
    },
    [source()],
    { responseText: response, responseParts: null },
  );
}

function assertEquals(actual: unknown, expected: unknown, what: string) {
  if (actual !== expected) {
    throw new Error(
      `${what}: expected ${JSON.stringify(expected)}, got ${JSON.stringify(actual)}`,
    );
  }
}

// --- the stripper -------------------------------------------------------

Deno.test("removes the control characters seen in the pilot", () => {
  assertEquals(
    stripStrayControlChars("calculation \x7f(25 N - 15 N)\x7f or"),
    "calculation (25 N - 15 N) or",
    "U+007F pair",
  );
  assertEquals(
    stripStrayControlChars("show \x1a(25 N - 15 N)/5.0 kg\x1a."),
    "show (25 N - 15 N)/5.0 kg.",
    "U+001A pair",
  );
  assertEquals(
    stripStrayControlChars("from \x125 N - 15 N\x13 divided"),
    "from 5 N - 15 N divided",
    "U+0012 and U+0013",
  );
});

Deno.test("removes an ANSI colour sequence whole, leaving no bracket junk", () => {
  assertEquals(
    stripStrayControlChars("evaluates \x1b[1m\x1b[0m\x1b[0mthe exact value as 2."),
    "evaluates the exact value as 2.",
    "ANSI sequences",
  );
  assertEquals(
    stripStrayControlChars("\x1b[38;5;196mred\x1b[0m"),
    "red",
    "ANSI with parameters",
  );
});

Deno.test("keeps tab, newline and carriage return", () => {
  const text = "line one\r\nline two\n\tindented";
  assertEquals(stripStrayControlChars(text), text, "whitespace controls");
});

Deno.test("leaves ordinary text, symbols and backslashes exactly as they were", () => {
  const text = "Use \\( \\frac{a}{b} \\) and a=(25-15)/5=2.0\\,\\mathrm{m/s^2}; ρ ε₀ π ≈ 55 – 3 “quoted”.";
  assertEquals(stripStrayControlChars(text), text, "no control characters present");
});

Deno.test("a lone ESC or an unterminated sequence loses only the control byte", () => {
  assertEquals(stripStrayControlChars("a\x1bb"), "ab", "lone ESC");
  assertEquals(stripStrayControlChars("a\x1b[1"), "a[1", "unterminated CSI");
});

Deno.test("asCleanString passes non-strings through as null", () => {
  assertEquals(asCleanString(null), null, "null");
  assertEquals(asCleanString(12), null, "number");
  assertEquals(asCleanString("a\x7fb"), "ab", "string");
});

// --- in the sanitizer ---------------------------------------------------

Deno.test("explanation, minimum fix and summary are cleaned before they are stored", () => {
  const result = grade(
    {
      evidence_quote: "a = F/m = 2.0 m/s^2",
      decision_explanation: "uses \x7f(25 N - 15 N)\x7f correctly",
      minimum_fix: "State \x1a10 N\x1a.",
    },
    RESPONSE,
    "Good\x1b[0m work",
  );
  const c = result.criteria[0];
  assertEquals(c.decision_explanation, "uses (25 N - 15 N) correctly", "explanation");
  assertEquals(c.minimum_fix, "State 10 N.", "minimum fix");
  assertEquals(result.student_facing_summary, "Good work", "summary");
  assertEquals(c.status, "earned", "grade unchanged");
  assertEquals(c.points_awarded, 1, "points unchanged");
  assertEquals(result.integrity_issues.length, 0, "no integrity issue");
});

Deno.test("a missing minimum fix still falls back to the rubric's own", () => {
  const result = grade({
    evidence_quote: "a = F/m = 2.0 m/s^2",
    decision_explanation: "ok",
    minimum_fix: null,
  });
  assertEquals(result.criteria[0].minimum_fix, "fix c1", "rubric fallback");
});

Deno.test("an evidence quote with control characters inside is cleaned and still grounded", () => {
  const result = grade({
    evidence_quote: "a = F/m =\x7f 2.0 m/s^2",
    decision_explanation: "ok",
    minimum_fix: null,
  });
  const c = result.criteria[0];
  assertEquals(c.evidence_quote, "a = F/m = 2.0 m/s^2", "stored quote is clean");
  assertEquals(c.status, "earned", "still earned");
  assertEquals(result.integrity_issues.length, 0, "grounded, no issue");
});

Deno.test("a quote that is only control characters is no evidence at all", () => {
  const result = grade({
    evidence_quote: "\x1a\x7f",
    decision_explanation: "ok",
    minimum_fix: null,
  });
  const c = result.criteria[0];
  assertEquals(c.evidence_quote, null, "no quote");
  assertEquals(c.status, "unable_to_determine", "credit needs evidence");
  assertEquals(c.points_awarded, 0, "no points");
});

Deno.test("a quote that matches only with the student's own control character stays grounded", () => {
  const pasted = "The mass is 5.0\x0bkg and a = 2.0 m/s^2.";
  const result = grade(
    {
      evidence_quote: "5.0\x0bkg and a = 2.0",
      decision_explanation: "ok",
      minimum_fix: null,
    },
    pasted,
  );
  const c = result.criteria[0];
  assertEquals(c.status, "earned", "grounded through the raw quote");
  assertEquals(c.evidence_quote, "5.0kg and a = 2.0", "but the stored copy is clean");
  assertEquals(result.integrity_issues.length, 0, "no integrity issue");
});

Deno.test("an ungrounded quote is still rejected after cleaning", () => {
  const result = grade({
    evidence_quote: "something the student never wrote\x7f",
    decision_explanation: "ok",
    minimum_fix: null,
  });
  assertEquals(result.criteria[0].status, "unable_to_determine", "ungrounded");
  assertEquals(result.integrity_issues.length, 1, "one integrity issue");
});
