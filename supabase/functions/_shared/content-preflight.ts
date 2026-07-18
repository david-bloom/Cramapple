// Content completeness preflight — the machine-checkable form of the MCQ (§8)
// and FRQ (§9/§9.1) package contracts in
// docs/architecture/CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md.
//
// This is the single source of truth for "is this item package complete enough
// to exist?" It MUST run on EVERY content ingestion path (authoring compiler,
// bulk import, admin edit) BEFORE persistence/publication, and in CI — not only
// at human review. An item with any BLOCKING finding must be rejected; a
// parseable-but-empty package is exactly the failure this catches
// (§8: "Parseable JSON is necessary but not evidence of quality").
//
// Severity model mirrors the failure-card contract (§4 blocking_or_scored):
//   - "blocking": the item is non-functional or unsafe to grade/coach; reject.
//   - "warning":  recommended completeness; report, gate with { strict: true }.

export type ItemType = "mcq" | "frq";

export interface FrqCriterionInput {
  criterion_key?: string | null;
  learner_facing_text?: string | null;
  points_possible?: number | null;
  evidence_requirements?: string | null;
  minimum_fix?: string | null;
  accepted_variants?: unknown; // expected: array
}

export interface McqChoiceInput {
  choice_key?: string | null;
  choice_text?: string | null;
  is_correct?: boolean | null;
  rationale?: string | null;
}

export interface ContentItemPackage {
  content_key?: string | null;
  item_type: ItemType;
  status?: string | null;
  canonical_answer_1?: string | null;
  explanation?: string | null;
  criteria?: FrqCriterionInput[] | null; // FRQ
  choices?: McqChoiceInput[] | null; // MCQ
}

export type Severity = "blocking" | "warning";

export interface PreflightFinding {
  content_key: string;
  item_type: ItemType;
  severity: Severity;
  code: string;
  location: string; // e.g. "criterion:a1" or "choice:B" or "item"
  message: string;
}

export interface PreflightResult {
  ok: boolean; // false if any blocking finding (or any finding when strict)
  blocking: number;
  warnings: number;
  findings: PreflightFinding[];
}

const nonEmpty = (v: unknown): boolean =>
  typeof v === "string" && v.trim().length > 0;

function checkFrq(pkg: ContentItemPackage, out: PreflightFinding[]) {
  const key = pkg.content_key ?? "(unkeyed)";
  const push = (severity: Severity, code: string, location: string, message: string) =>
    out.push({ content_key: key, item_type: "frq", severity, code, location, message });

  const criteria = Array.isArray(pkg.criteria) ? pkg.criteria : [];
  if (criteria.length === 0) {
    push("blocking", "FRQ_NO_CRITERIA", "item", "FRQ has no scoring criteria.");
  }
  for (const c of criteria) {
    const loc = `criterion:${c.criterion_key ?? "?"}`;
    if (!nonEmpty(c.criterion_key)) push("blocking", "FRQ_CRITERION_KEY_MISSING", loc, "Criterion is missing a criterion_key.");
    if (!nonEmpty(c.learner_facing_text)) push("blocking", "FRQ_LEARNER_TEXT_EMPTY", loc, "Criterion has empty learner_facing_text.");
    if (typeof c.points_possible !== "number" || !Number.isFinite(c.points_possible) || c.points_possible < 1) {
      push("blocking", "FRQ_POINTS_INVALID", loc, "Criterion points_possible must be an integer >= 1.");
    }
    if (!nonEmpty(c.evidence_requirements)) push("blocking", "FRQ_EVIDENCE_REQ_EMPTY", loc, "Criterion has empty evidence_requirements (grader boundary). See §9.1.");
    if (!nonEmpty(c.minimum_fix)) push("blocking", "FRQ_MINIMUM_FIX_EMPTY", loc, "Criterion has empty minimum_fix (repair coaching). See §9.1.");
    if (!Array.isArray(c.accepted_variants) || c.accepted_variants.length === 0) {
      push("warning", "FRQ_ACCEPTED_VARIANTS_EMPTY", loc, "Criterion has no accepted_variants (accepted equivalent wording). §9 recommends >=1.");
    }
  }
  if (!nonEmpty(pkg.canonical_answer_1)) push("warning", "FRQ_CANONICAL_ANSWER_EMPTY", "item", "FRQ has no canonical answer of record.");
  if (!nonEmpty(pkg.explanation)) push("warning", "FRQ_EXPLANATION_EMPTY", "item", "FRQ has no teaching explanation (§9).");
}

function checkMcq(pkg: ContentItemPackage, out: PreflightFinding[]) {
  const key = pkg.content_key ?? "(unkeyed)";
  const push = (severity: Severity, code: string, location: string, message: string) =>
    out.push({ content_key: key, item_type: "mcq", severity, code, location, message });

  const choices = Array.isArray(pkg.choices) ? pkg.choices : [];
  if (choices.length < 2) {
    push("blocking", "MCQ_TOO_FEW_CHOICES", "item", "MCQ has fewer than 2 answer choices.");
  }
  const correct = choices.filter((c) => c.is_correct === true).length;
  if (correct !== 1) {
    push("blocking", "MCQ_KEY_NOT_UNIQUE", "item", `MCQ must have exactly one correct choice; found ${correct}.`);
  }
  for (const c of choices) {
    const loc = `choice:${c.choice_key ?? "?"}`;
    if (!nonEmpty(c.choice_text)) push("blocking", "MCQ_CHOICE_TEXT_EMPTY", loc, "Answer choice has empty text.");
    if (!nonEmpty(c.rationale)) push("blocking", "MCQ_RATIONALE_EMPTY", loc, "Answer choice has empty rationale (every distractor needs one). See §8.");
  }
  if (choices.length !== 4) push("warning", "MCQ_NOT_FOUR_CHOICES", "item", `MCQ has ${choices.length} choices; §8 expects 4 unless the exam pack specifies otherwise.`);
  if (!nonEmpty(pkg.explanation)) push("warning", "MCQ_EXPLANATION_EMPTY", "item", "MCQ has no teaching explanation (§8).");
}

/** Validate a single normalized content item package. */
export function preflightItem(pkg: ContentItemPackage, opts: { strict?: boolean } = {}): PreflightResult {
  const findings: PreflightFinding[] = [];
  if (pkg.item_type === "frq") checkFrq(pkg, findings);
  else if (pkg.item_type === "mcq") checkMcq(pkg, findings);
  else {
    findings.push({
      content_key: pkg.content_key ?? "(unkeyed)",
      item_type: pkg.item_type,
      severity: "blocking",
      code: "UNKNOWN_ITEM_TYPE",
      location: "item",
      message: `Unknown item_type "${pkg.item_type}".`,
    });
  }
  const blocking = findings.filter((f) => f.severity === "blocking").length;
  const warnings = findings.filter((f) => f.severity === "warning").length;
  const ok = opts.strict ? findings.length === 0 : blocking === 0;
  return { ok, blocking, warnings, findings };
}

/** Validate a batch; ok is the AND of all items. */
export function preflightBatch(pkgs: ContentItemPackage[], opts: { strict?: boolean } = {}): PreflightResult {
  const findings: PreflightFinding[] = [];
  for (const p of pkgs) findings.push(...preflightItem(p, opts).findings);
  const blocking = findings.filter((f) => f.severity === "blocking").length;
  const warnings = findings.filter((f) => f.severity === "warning").length;
  const ok = opts.strict ? findings.length === 0 : blocking === 0;
  return { ok, blocking, warnings, findings };
}

/**
 * Throw if any blocking finding exists (or any finding when strict). Ingestion
 * paths (bulk import, authoring compiler, admin publish) should call this before
 * persisting/publishing so incomplete content cannot enter the system.
 */
export function assertPreflight(pkgs: ContentItemPackage[], opts: { strict?: boolean } = {}): void {
  const res = preflightBatch(pkgs, opts);
  if (!res.ok) {
    const lines = res.findings
      .filter((f) => f.severity === "blocking" || opts.strict)
      .map((f) => `  [${f.severity}] ${f.content_key} ${f.location} ${f.code}: ${f.message}`);
    throw new Error(
      `Content preflight failed: ${res.blocking} blocking, ${res.warnings} warning(s).\n${lines.join("\n")}`,
    );
  }
}
