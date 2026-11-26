// MCQ wrong-answer feedback and selected-choice parsing (TASK-0079 S1: moved
// verbatim from index.ts).

// Wrong-answer MCQ feedback used to be one fixed string on every item:
// "Select the answer choice that matches the published correct answer." That
// tells a student nothing they did not already know, and it said it while the
// item's own authored distractor rationales sat unread two variables away in
// mcqChoices. On 2026-09-29, 34 of the 63 recorded highest_value_gap rows were
// that placeholder, spread over 19 items which carry 76 authored rationales
// between them.
//
// Feedback is built from what the item already knows, in three moves:
//   1. orient  — name the skill the question is FOR (content_item_cells ->
//                taxonomy_skills.label)
//   2. point   — the CHOSEN distractor's authored rationale, aimed at the exact
//                spot the student went wrong
//   3. redirect— hand back a question, never a correction
// The "Not quite." opener carries the verdict and deliberately none of the
// substance. Three moves and no more: the brief is to fix one conceptual error,
// not to enumerate every fault.
//
// The moves degrade independently: an unlabelled item loses move 1 and keeps 2
// and 3; a distractor with no authored rationale loses move 2.
//
// Deliberately absent: the CORRECT choice's rationale. It names the answer, and
// this item may be served to the same student again. Two further strategies are
// out of reach here and are NOT silently approximated — naming what the student
// got right first (a 1-point MCQ has no partial credit to praise), and handing
// them a similar bite-sized problem immediately (a serving decision, not a
// feedback string).
//
// Pure and exported so the wording is testable without a database.

// Skill labels are lifted verbatim from the CED and written in the register of a
// curriculum document, not of a student: every one of the 41 labels registered
// across the labelled subjects is an imperative verb phrase ("Calculate summary
// statistics, relative positions, predicted responses"). Dropped straight into
// "This question is testing <label>" the result is ungrammatical, so a
// verb-initial label is bent into "how to calculate ...".
//
// The verb list is an allowlist rather than a "lowercase the first letter" rule
// because the bend is only valid for a verb. A subject whose grid lands later
// with a noun-initial label ("Models and representations") simply will not
// match, and falls back to a colon form that is grammatical for any label
// shape. That is the failure mode worth having: a new subject reads slightly
// stiffly instead of emitting broken English.
const SKILL_VERBS = new Set([
  "analyze",
  "apply",
  "argue",
  "calculate",
  "compare",
  "confirm",
  "construct",
  "derive",
  "describe",
  "determine",
  "estimate",
  "evaluate",
  "explain",
  "identify",
  "interpret",
  "justify",
  "model",
  "perform",
  "predict",
  "provide",
  "represent",
  "select",
  "use",
]);

function asHowTo(label: string): string | null {
  const trimmed = label.replace(/\.$/, "").trim();
  const firstWord = trimmed.split(/\s+/)[0] ?? "";
  // "Calculate/estimate expected counts ..." — the slash form is a single token
  // whose leading half is the verb.
  const head = firstWord.split("/")[0].toLowerCase();
  if (!SKILL_VERBS.has(head)) return null;
  return trimmed.charAt(0).toLowerCase() + trimmed.slice(1);
}

// A single template, however well built, is formulaic by the third question:
// a student working twenty MCQs would read the same three-move skeleton twenty
// times and stop reading it. So the three ingredients are held constant and the
// SHAPE rotates — some variants tell and then ask, some open with the pointer,
// some orient by unit first, in the manner of "This is Unit 2 material. Keeping
// <skill> in mind, how would you answer it now?".
//
// Rotation is by a hash of the item and the chosen key, not by random(): the
// same student re-reading the same result sees the same words, two different
// items in one session almost certainly differ, and the output stays
// reproducible in tests and in support.
function variantIndex(seed: string, count: number): number {
  // FNV-1a. Any cheap avalanche would do; what matters is that it is stable
  // across deploys, which Math.random and Date.now are not.
  let hash = 0x811c9dc5;
  for (let index = 0; index < seed.length; index++) {
    hash ^= seed.charCodeAt(index);
    hash = Math.imul(hash, 0x01000193) >>> 0;
  }
  return count > 0 ? hash % count : 0;
}

export function composeMcqFeedback(
  input: {
    earned: boolean;
    rationale?: string | null;
    skillLabels?: string[];
    unitNumber?: number | null;
    variantSeed?: string | null;
  },
): { summary: string; actionableFix: string; redirect: string } {
  const cleanedLabels = (input.skillLabels ?? [])
    .filter((label): label is string => typeof label === "string")
    .map((label) => label.replace(/\.$/, "").trim())
    .filter((label) => label.length > 0);

  const howToLabels = cleanedLabels.map(asHowTo);
  const skillPhrase = cleanedLabels.length === 0
    ? null
    : howToLabels.every((label) => label !== null)
    ? `how to ${howToLabels.join(", and how to ")}`
    : null;
  // Set only when the label could not be bent into the "how to" form; the
  // sentence is then built with a colon, which accepts any label shape.
  const skillColonPhrase = skillPhrase === null && cleanedLabels.length > 0
    ? cleanedLabels.join("; ")
    : null;
  const skillTell = skillPhrase
    ? `This question is testing ${skillPhrase}.`
    : skillColonPhrase
    ? `The skill this question is testing: ${skillColonPhrase}.`
    : "";

  // Authored rationales come in two styles and nothing constrains which:
  // subject-less fragments ("Reported a standard deviation instead of the
  // mean") from the bulk-generated Stats items, and whole sentences ("The
  // magnitude of residuals alone doesn't establish appropriateness; ...") from
  // the hand-authored ones. Spliced in as a bare sentence the first style reads
  // clipped, so every variant introduces it after a colon, which is grammatical
  // for a fragment and a sentence alike. Terminal punctuation is not enforced
  // either, so do not rely on it.
  const authored = typeof input.rationale === "string"
    ? input.rationale.trim()
    : "";
  const pointed = authored
    ? (/[.!?]$/.test(authored) ? authored : `${authored}.`)
    : "";

  const unitSentence = typeof input.unitNumber === "number" &&
      Number.isFinite(input.unitNumber)
    ? `This is Unit ${input.unitNumber} material.`
    : "";

  // Every variant ends on a question: the student is always left holding
  // something to do, never a verdict to absorb.
  const askKeepingInMind = skillPhrase
    ? `Keeping ${skillPhrase} in mind, how would you answer it now?`
    : "How would you answer it now?";
  const askAgainPlain = "How would you answer it now?";
  const askWorkItThrough = skillPhrase || skillColonPhrase
    ? "What would you need to work out to answer the question as asked?"
    : "What is the question actually asking you to find, and how does that differ from what you chose?";

  // Each variant is a list of fragments; empty ones drop out, so a missing
  // skill, rationale or unit degrades the shape without breaking its grammar.
  const variants: string[][] = [
    // tell, then point, then ask
    ["Not quite.", skillTell, pointer(pointed), askWorkItThrough],
    // orient by unit, point, then ask in the "keeping X in mind" voice
    ["Not quite.", unitSentence, pointer(pointed), askKeepingInMind],
    // lead with the pointer, tell second
    [
      "Not quite.",
      pointed ? `Here is the catch with the one you chose: ${pointed}` : "",
      skillTell,
      askWorkItThrough,
    ],
    // orient by unit and skill together, then point and ask. The ask is the
    // plain one: this shape has already named the skill, and repeating it
    // inside "keeping ... in mind" reads as padding, especially with a label
    // as long as "calculate summary statistics, relative positions, predicted
    // responses".
    ["Not quite.", unitSentence, skillTell, pointer(pointed), askAgainPlain],
  ];

  const chosen = variants[
    variantIndex(input.variantSeed ?? "", variants.length)
  ];
  const summary = input.earned ? "Correct." : chosen.filter(Boolean).join(" ");

  // The authored rationale is the closest thing the item writers produced to
  // "what to fix", so it carries the field even though the field is named for a
  // fix rather than a diagnosis.
  const actionableFix = authored ||
    "Identify which quantity the question asks for before choosing.";

  return { summary, actionableFix, redirect: chosen[chosen.length - 1] };
}

function pointer(pointed: string): string {
  return pointed ? `Look again at the choice you picked: ${pointed}` : "";
}

export function summarizeSelectedChoice(responseJson: Record<string, unknown>) {
  const candidates = [
    responseJson.selected_choice_key,
    responseJson.selectedChoiceKey,
    responseJson.choice_key,
    responseJson.choiceKey,
    responseJson.selected_choice_id,
    responseJson.selectedChoiceId,
    responseJson.answer,
    responseJson.selected_answer,
    responseJson.selectedAnswer,
  ];

  for (const candidate of candidates) {
    if (typeof candidate === "string" && candidate.length > 0) {
      return candidate;
    }
  }

  return null;
}
