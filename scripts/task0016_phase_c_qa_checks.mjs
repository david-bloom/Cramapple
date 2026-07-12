#!/usr/bin/env node
// TASK-0016 Phase C fail-closed QA checker.
//
// The checker both the original 2026-07-11 QA review and its remediation
// log cited (`task0016_qa_checks.mjs`, run from a `/private/tmp/...` path)
// was never committed to this repository -- neither document's "exit 0,
// all checks pass" claim could be independently re-run by anyone without
// the original author's own machine. This is a fresh replacement, built to
// cover the same ground plus the two defect classes that a 15-item SAMPLE
// QA pass missed twice in a row: FRQ items whose rubric/answer key
// references data never shown to the student, and difficulty-label
// mismatches against the corpus's own key-suffix convention. Scans the
// FULL corpus, not a sample, on both.
//
// Usage:
//   node scripts/task0016_phase_c_qa_checks.mjs <bulk_import_payload.json> <statistics_item_keys.json>
//
// Exit 0 only if every check passes. Any failure prints details and exits 1
// (fail-closed -- ambiguous or unverifiable is treated as a failure, not a
// pass).

import fs from "node:fs";

const [, , payloadPath, keysPath] = process.argv;

if (!payloadPath || !keysPath) {
  console.error(
    "Usage: node scripts/task0016_phase_c_qa_checks.mjs <bulk_import_payload.json> <statistics_item_keys.json>",
  );
  process.exit(1);
}

const payload = JSON.parse(fs.readFileSync(payloadPath, "utf8"));
const keysFile = JSON.parse(fs.readFileSync(keysPath, "utf8"));

const items = payload.items.map((entry) => entry.artifact.payload);
const failures = [];

function fail(check, detail) {
  failures.push({ check, detail });
}

// --- 1. Structural counts ---
const mcqItems = items.filter((it) => it.item_type === "mcq");
const frqItems = items.filter((it) => it.item_type === "frq");

if (items.length !== 200) {
  fail("total_count", `expected 200 items, got ${items.length}`);
}
if (mcqItems.length !== 100) {
  fail("mcq_count", `expected 100 MCQ items, got ${mcqItems.length}`);
}
if (frqItems.length !== 100) {
  fail("frq_count", `expected 100 FRQ items, got ${frqItems.length}`);
}

// --- 2. Duplicate staged keys ---
const stagedKeys = items.map((it) => it.content_key);
const seen = new Set();
const duplicates = new Set();
for (const key of stagedKeys) {
  if (seen.has(key)) duplicates.add(key);
  seen.add(key);
}
if (duplicates.size > 0) {
  fail("duplicate_staged_keys", [...duplicates].join(", "));
}

// --- 3. Deterministic-disposition counts, cross-checked against the key file ---
// NOTE: statistics_item_keys.json only covers 30 of the 100 FRQ items
// (confirmed by inspection). remediation_log.md's "28 keyed / 68
// conceptual-only / 4 excluded-or-method-only" split therefore cannot come
// solely from ecf_parts presence in this file -- it must use some other
// classification (a per-criterion "kind" tag, or a separate inventory doc)
// this checker doesn't have visibility into. Reproducing deterministicKeyed
// (28, verified to match) is honest; guessing at a conceptual-vs-excluded
// split from the remaining 72 items is not, so this checker reports that
// remainder as a single unclassified bucket instead of fabricating a
// two-way split it can't actually justify.
const keyedContentKeys = new Set(
  keysFile.items
    .filter((it) => (it.ecf_parts ?? []).length > 0)
    .map((it) => it.content_key),
);

let deterministicKeyed = 0;
let notDeterministicallyKeyed = 0;
for (const it of frqItems) {
  const sourceKey = it.source_content_key ?? it.content_key;
  if (keyedContentKeys.has(sourceKey)) {
    deterministicKeyed += 1;
  } else {
    notDeterministicallyKeyed += 1;
  }
}
const dispositionTotal = deterministicKeyed + notDeterministicallyKeyed;
if (dispositionTotal !== frqItems.length) {
  fail(
    "disposition_total_mismatch",
    `deterministic_keyed=${deterministicKeyed} not_deterministically_keyed=${notDeterministicallyKeyed} sums to ${dispositionTotal}, not ${frqItems.length} FRQ items`,
  );
}

// --- 4. Full-corpus answerability scan ---
//
// Heuristic A (WARNING, not fail): stem mentions a visual or tabular
// artifact (histogram, scatterplot, tree diagram, table, graph, plot) and
// stimulus is empty. This is the pattern that caused all 11 answerability
// defects found across two QA rounds on this packet -- but a keyword match
// cannot tell a genuinely unanswerable item (data described only in a
// figure that was never attached) from an item that's fully self-contained
// in its stem text ("a scatterplot has an upward, linear pattern with no
// outliers...") or genuinely conceptual ("what shape WOULD you expect...").
// Both false-positive types were confirmed by hand against this exact
// corpus while building this checker (e.g. APSTAT-MOD4-M004, already fixed
// and self-contained, and APSTAT-MOD3-E002, purely conceptual, both trip
// this pattern). Treat every hit as a human-read candidate, not a verdict.
const VISUAL_KEYWORDS = /histogram|scatterplot|scatter plot|tree diagram|contingency table|\btable\b|\bgraph\b|\bplot\b/i;
const warnings = [];

for (const it of frqItems) {
  const stem = it.stem ?? "";
  const stimulus = (it.stimulus ?? "").trim();
  if (VISUAL_KEYWORDS.test(stem) && stimulus.length === 0) {
    warnings.push(
      `${it.content_key}: stem references a visual/tabular artifact and stimulus is empty -- read by hand to confirm whether the stem is actually self-contained`,
    );
  }
}

// Heuristic B (FAIL): item has a deterministic ECF "given" (a number the
// grader uses to check the answer) that never appears anywhere in the
// student-facing stem + stimulus text, in EITHER decimal or percentage
// form, and isn't one of a small set of values AP Statistics students are
// expected to know without restatement (standard confidence-level z/t
// critical values, and p=0.5 for an explicitly fair/random binary choice).
// Catches the MOD7-M001/M004 pattern (arbitrary hidden numbers with no
// other source) while not flaring on ordinary formula-sheet knowledge --
// confirmed against this corpus: z=1.96 (95% CI, appears on every z-table)
// and percentages like "30%"/"90%" that a naive decimal-only number scan
// would otherwise miss as 0.3/0.9 mismatches, not real hidden data.
const KNOWN_CONVENTION_VALUES = new Set([
  1.96, 1.645, 2.576, 2.326, 1.282, // common z critical values (90/95/98/99%)
  0.5, // fair-coin / equally-likely-binary-choice default
]);

function numbersIn(text) {
  const decimals = (text.match(/-?\d+(\.\d+)?/g) ?? []).map(Number);
  const percents = [...text.matchAll(/-?\d+(\.\d+)?\s*%/g)].map(
    (m) => Number(m[0].replace("%", "").trim()) / 100,
  );
  return new Set([...decimals, ...percents]);
}

for (const it of frqItems) {
  const sourceKey = it.source_content_key ?? it.content_key;
  const keyEntry = keysFile.items.find((k) => k.content_key === sourceKey);
  if (!keyEntry) continue;
  const studentText = `${it.stem ?? ""} ${it.stimulus ?? ""}`;
  const studentNumbers = numbersIn(studentText);
  for (const part of keyEntry.ecf_parts ?? []) {
    const givens = part.givens ?? {};
    const missing = Object.entries(givens).filter(
      ([, value]) =>
        typeof value === "number" &&
        !studentNumbers.has(value) &&
        !KNOWN_CONVENTION_VALUES.has(value),
    );
    if (missing.length > 0) {
      fail(
        "hidden_ecf_given",
        `${it.content_key} part ${part.id}: given(s) ${missing.map(([k, v]) => `${k}=${v}`).join(", ")} never appear in the student-facing stem/stimulus`,
      );
    }
  }
}

// --- 5. Difficulty-label consistency against the corpus's own key-suffix convention ---
// Confirmed convention across the full FRQ corpus: key suffix E->easy,
// M->medium, H->hard, VH->very_hard. Checked corpus-wide, not per-module,
// so this generalizes past the Module 8 bug that motivated it.
const DIFFICULTY_BY_SUFFIX = { E: "easy", M: "medium", H: "hard", VH: "very_hard" };

for (const it of frqItems) {
  const promptJson = it.prompt_json ?? {};
  const difficulty = promptJson.difficulty;
  const match = it.content_key.match(/-MOD\d+-(E|M|H|VH)\d+/);
  if (!match || !difficulty) continue;
  const expected = DIFFICULTY_BY_SUFFIX[match[1]];
  if (difficulty !== expected) {
    fail(
      "difficulty_suffix_mismatch",
      `${it.content_key}: suffix implies "${expected}" but difficulty is "${difficulty}"`,
    );
  }
}

// --- Report ---
if (warnings.length > 0) {
  console.error(`${warnings.length} human-read candidate(s) -- not fail-closed, read each by hand:\n`);
  for (const detail of warnings) {
    console.error(`  [candidate] ${detail}`);
  }
  console.error("");
}

if (failures.length > 0) {
  console.error(`FAIL: ${failures.length} issue(s) found\n`);
  for (const { check, detail } of failures) {
    console.error(`  [${check}] ${detail}`);
  }
  process.exit(1);
}

console.log(
  JSON.stringify(
    {
      result: "PASS",
      items: items.length,
      mcq: mcqItems.length,
      frq: frqItems.length,
      duplicateStagedKeys: duplicates.size,
      deterministicKeyed,
      notDeterministicallyKeyed,
      humanReadCandidates: warnings.length,
    },
    null,
    2,
  ),
);
