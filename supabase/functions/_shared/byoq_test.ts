import { assert, assertEquals } from "jsr:@std/assert@1";
import {
  BYOQ_LIMITS,
  detectAnswerLeaks,
  finalPath,
  generateCaptureHandle,
  generateItemCode,
  generateOwnerKey,
  isSafeByoqPath,
  isWellFormedCaptureHandle,
  isWellFormedOwnerKey,
  MASK_CHAR,
  maskedView,
  readinessProblem,
  removeFlaggedText,
  uploadPath,
  validateItemFields,
  validateResponseInput,
} from "./byoq.ts";

Deno.test("owner keys and capture handles are well-formed, distinct, and prefix-checked", () => {
  const key = generateOwnerKey();
  const handle = generateCaptureHandle();
  assert(isWellFormedOwnerKey(key));
  assert(isWellFormedCaptureHandle(handle));
  assert(!isWellFormedOwnerKey(handle));
  assert(!isWellFormedCaptureHandle(key));
  assert(!isWellFormedOwnerKey("byoq_short"));
  assert(generateOwnerKey() !== key);
});

Deno.test("item codes match the DB check and avoid ambiguous characters", () => {
  for (let i = 0; i < 200; i++) {
    const code = generateItemCode();
    assert(/^BQ-[23456789ABCDEFGHJKMNPQRSTUVWXYZ]{6}$/.test(code), code);
  }
});

Deno.test("leak heuristic flags labeled answers in the stem to end of line", () => {
  const stem = "Which is the median?\nAnswer: B\nShow work.";
  const flags = detectAnswerLeaks(stem, []);
  assertEquals(flags.length, 1);
  assertEquals(flags[0].rule, "answer_label");
  assertEquals(stem.slice(flags[0].start, flags[0].end), "Answer: B");
});

Deno.test("leak heuristic flags 'correct answer', 'ans =', and 'answer key'", () => {
  for (const s of ["Find x. Correct answer: 4", "Find x. Ans = 4", "Q1 ... Answer key: C"]) {
    assertEquals(detectAnswerLeaks(s, []).length, 1, s);
  }
});

Deno.test("leak heuristic ignores stemplot keys, chemistry solutions, blanks, and 'answer the'", () => {
  for (
    const s of [
      "Stemplot of heights. Key: 5|2 means 52 inches. What is the median?",
      "Solution: 0.10 M HCl is titrated with NaOH. Find the pH.",
      "Answer: ______________",
      "Answer the following question about the scatterplot.",
      "Justify your answer using the graph.",
      "Justify your answer: use the graph above.",
    ]
  ) {
    assertEquals(detectAnswerLeaks(s, []), [], s);
  }
});

Deno.test("leak heuristic flags a correct-marker on a choice", () => {
  const flags = detectAnswerLeaks("Pick one.", [
    { choice_key: "A", choice_text: "3" },
    { choice_key: "B", choice_text: "4 (correct)" },
    { choice_key: "C", choice_text: "5 ✓" },
  ]);
  assertEquals(flags.map((f) => [f.field, f.index, f.rule]), [
    ["choice", 1, "correct_marker"],
    ["choice", 2, "correct_marker"],
  ]);
});

Deno.test("leak heuristic flags a trailing bare answer letter under the question", () => {
  const flags = detectAnswerLeaks("Which choice best describes the association?\n(C)", []);
  assertEquals(flags.map((f) => f.rule), ["trailing_answer_line"]);
  // A stem that is only a letter is incomplete, not a leak.
  assertEquals(detectAnswerLeaks("B", []), []);
});

Deno.test("masked view never contains flagged text; removal strips it", () => {
  const stem = "What is the mean?\nAnswer: 12.5";
  const choices = [{ choice_key: "A", choice_text: "12.5 [answer]" }, { choice_key: "B", choice_text: "10" }];
  const flags = detectAnswerLeaks(stem, choices);
  const masked = maskedView(stem, choices, flags);
  assert(!masked.stem!.includes("12.5"));
  assert(masked.stem!.includes(MASK_CHAR));
  assert(!masked.choices[0].choice_text.includes("[answer]"));
  const cleaned = removeFlaggedText(stem, choices, flags);
  assertEquals(cleaned.stem, "What is the mean?");
  assertEquals(cleaned.choices[0].choice_text, "12.5");
  assertEquals(detectAnswerLeaks(cleaned.stem, cleaned.choices), []);
});

Deno.test("validateItemFields rejects any answer-shaped key on a choice", () => {
  const bad = validateItemFields({
    choices: [{ choice_key: "A", choice_text: "x", is_correct: true }, { choice_text: "y" }],
  });
  assertEquals(bad, { ok: false, error: "invalid_choice_shape" });
});

Deno.test("validateItemFields assigns choice keys by position, ignoring client keys", () => {
  const ok = validateItemFields({ choices: [{ choice_key: "D", choice_text: " x " }, "y"] });
  assert(ok.ok);
  if (ok.ok) {
    assertEquals(ok.value.choices, [
      { choice_key: "A", choice_text: "x" },
      { choice_key: "B", choice_text: "y" },
    ]);
  }
});

Deno.test("validateItemFields enforces limits and whitelists", () => {
  assertEquals(validateItemFields({ stem: "x".repeat(BYOQ_LIMITS.stemMaxChars + 1) }), { ok: false, error: "stem_too_long" });
  assertEquals(validateItemFields({ choices: Array(7).fill("x") }), { ok: false, error: "too_many_choices" });
  assertEquals(validateItemFields({ item_type: "essay" }), { ok: false, error: "invalid_item_type" });
  assertEquals(validateItemFields({ topic_code: "1; drop" }), { ok: false, error: "invalid_topic_code" });
  assertEquals(validateItemFields({ source_kind: "worksheet_split" }), { ok: false, error: "invalid_source_kind" });
  const hyphen = validateItemFields({ subject_key: "ap-statistics" });
  assert(hyphen.ok && hyphen.value.subject_key === "ap_statistics");
  // Unknown fields (status, owner, leak_flags) are simply not part of the output.
  const extra = validateItemFields({ status: "ready", leak_flags: [], owner_id: "x" });
  assert(extra.ok && Object.keys(extra.value).length === 0);
});

Deno.test("readinessProblem mirrors the DB ready check", () => {
  const base = { item_type: "mcq" as const, stem: "Q?", choices: [{ choice_key: "A", choice_text: "x" }], leak_flags: [] };
  assertEquals(readinessProblem(base), "mcq_needs_choices");
  assertEquals(readinessProblem({ ...base, choices: [...base.choices, { choice_key: "B", choice_text: "y" }] }), null);
  assertEquals(readinessProblem({ ...base, item_type: "frq" }), "frq_has_choices");
  assertEquals(readinessProblem({ ...base, item_type: null }), "item_type_required");
  assertEquals(readinessProblem({ ...base, stem: "  " }), "stem_required");
  assertEquals(
    readinessProblem({ ...base, leak_flags: [{ field: "stem", index: null, start: 0, end: 1, rule: "answer_label" }] }),
    "answer_text_detected",
  );
});

Deno.test("validateResponseInput checks choice keys against the item", () => {
  assertEquals(validateResponseInput({ selected_choice_key: "C" }, "mcq", 2), { ok: false, error: "unknown_choice_key" });
  assertEquals(validateResponseInput({ selected_choice_key: "A" }, "frq", 0), { ok: false, error: "frq_has_no_choices" });
  const ok = validateResponseInput({ selected_choice_key: "B", is_final: true }, "mcq", 2);
  assertEquals(ok, { ok: true, value: { selected_choice_key: "B", response_text: null, is_final: true } });
});

Deno.test("storage paths: recognized owners under their uid, anonymous under byoq-anon", () => {
  const anon = { id: "o2", user_id: null };
  const p1 = uploadPath({ storagePrefix: "u1/byoq/o1", itemId: "i", pairingId: "p", attempt: 1, mediaType: "image/jpeg" });
  const p2 = finalPath({ owner: anon, itemId: "i", role: "question", fileId: "f1", mediaType: "image/png" });
  assertEquals(p1, "u1/byoq/o1/i/incoming/p-1.jpg");
  assertEquals(p2, "byoq-anon/o2/i/question/f1.png");
  assert(isSafeByoqPath(p1) && isSafeByoqPath(p2));
  assert(!isSafeByoqPath("../x") && !isSafeByoqPath("/x") && !isSafeByoqPath("a//b"));
});
