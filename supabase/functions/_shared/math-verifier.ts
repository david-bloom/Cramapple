import { detectAmbiguousTypedFormulaText, resolveFormulaActionHint, resolveFormulaRepairHint } from "./formula-notation.ts";

export type FormulaKind = "expression" | "antiderivative" | "numeric" | "conceptual";
export type FormulaVerdict = "PASS" | "FLAG" | "ABSTAIN";

export type FormulaCase = {
  kind: FormulaKind;
  canonical: string | null;
  response: string;
  variables?: string[];
  var?: string;
  domain?: [number, number];
  tol?: number;
};

export type FormulaCheckResult = {
  verdict: FormulaVerdict;
  reason: string | null;
};

export type EcfPartSpec = {
  id: string;
  points: number;
  canonical_formula: string;
  givens?: Record<string, number>;
  deps?: Record<string, string>;
  canonical_answer?: number;
  sign_sensitive?: boolean;
  note?: string;
};

export type EcfStudentPart = {
  stated_formula: string | null;
  shown_subs: Record<string, number> | null;
  student_answer: number;
};

export type EcfQuestion = {
  parts: EcfPartSpec[];
  student: Record<string, EcfStudentPart>;
};

export type EcfVerdict =
  | "CORRECT"
  | "CORRECT_VIA_ECF"
  | "CONCEPTUAL_COLLAPSE"
  | "COINCIDENTAL"
  | "NAKED_ANSWER"
  | "INCORRECT";

export type EcfPartResult = {
  part: string;
  verdict: EcfVerdict;
  points_awarded: number;
  points_possible: number;
  feedback: string;
};

export type EcfQuestionResult = {
  earned: number;
  possible: number;
  parts: EcfPartResult[];
};

type Token =
  | { type: "number"; value: number }
  | { type: "ident"; value: string }
  | { type: "op"; value: "+" | "-" | "*" | "/" | "^" | "**" }
  | { type: "lparen" }
  | { type: "rparen" };

type ExprNode =
  | { type: "number"; value: number }
  | { type: "ident"; value: string }
  | { type: "unary"; op: "+" | "-"; expr: ExprNode }
  | { type: "binary"; op: "+" | "-" | "*" | "/" | "^"; left: ExprNode; right: ExprNode }
  | { type: "func"; name: string; arg: ExprNode };

const DEFAULT_DOMAIN: [number, number] = [0.5, 2.5];
const DEFAULT_TOL = 1e-8;
const DEFAULT_NUM_TOL = 0.01;
const ECF_REL_TOL = 1e-3;
const SEED = 20260708;
const MIN_AGREE = 12;
const FUNCTIONS = new Set([
  "sin",
  "cos",
  "tan",
  "exp",
  "log",
  "sqrt",
  "abs",
]);
const CONSTANT_NAMES = new Set(["e", "pi", "C", "c"]);

function asString(value: unknown) {
  return typeof value === "string" ? value.trim() : "";
}

function isValueToken(token: Token | null | undefined) {
  return Boolean(token) &&
    (token!.type === "number" || token!.type === "ident" || token!.type === "rparen");
}

function canStartPrimary(token: Token | null | undefined) {
  return Boolean(token) &&
    (token!.type === "number" || token!.type === "ident" || token!.type === "lparen");
}

function normalizeTypedNotation(text: string) {
  return text
    .replace(/\b(sin|cos|tan)\^2\s*\(\s*([^)]+?)\s*\)/gi, "($1($2))^2")
    .replace(/\b(sin|cos|tan)\^2\s+([A-Za-z][A-Za-z0-9_]*)\b/gi, "$1($2)^2");
}

function tokenize(text: string): Token[] {
  const tokens: Token[] = [];
  const source = normalizeTypedNotation(text.replace(/\u2212/g, "-"));
  let i = 0;

  while (i < source.length) {
    const ch = source[i];
    if (/\s/.test(ch)) {
      i += 1;
      continue;
    }

    if (ch === "(") {
      tokens.push({ type: "lparen" });
      i += 1;
      continue;
    }
    if (ch === ")") {
      tokens.push({ type: "rparen" });
      i += 1;
      continue;
    }
    if (ch === "+" || ch === "-" || ch === "/" || ch === "*") {
      if (ch === "*" && source[i + 1] === "*") {
        tokens.push({ type: "op", value: "^" });
        i += 2;
      } else {
        tokens.push({ type: "op", value: ch as "+" | "-" | "*" | "/" });
        i += 1;
      }
      continue;
    }
    if (ch === "^") {
      tokens.push({ type: "op", value: "^" });
      i += 1;
      continue;
    }
    if (/[0-9.]/.test(ch)) {
      let j = i + 1;
      while (j < source.length && /[0-9.eE+-]/.test(source[j])) {
        const prev = source[j - 1];
        const curr = source[j];
        if ((prev === "e" || prev === "E") && (curr === "+" || curr === "-")) {
          j += 1;
          continue;
        }
        if (curr === "." && source.slice(i, j).includes(".")) break;
        if ((curr === "+" || curr === "-") && !/[eE]/.test(prev)) break;
        j += 1;
      }
      const raw = source.slice(i, j);
      const value = Number(raw);
      if (!Number.isFinite(value)) {
        throw new Error(`invalid_number:${raw}`);
      }
      tokens.push({ type: "number", value });
      i = j;
      continue;
    }
    if (/[A-Za-z_]/.test(ch)) {
      let j = i + 1;
      while (j < source.length && /[A-Za-z0-9_]/.test(source[j])) j += 1;
      const value = source.slice(i, j);
      tokens.push({ type: "ident", value });
      i = j;
      continue;
    }

    throw new Error(`invalid_character:${ch}`);
  }

  const withImplicitMultiplication: Token[] = [];
  for (let index = 0; index < tokens.length; index += 1) {
    const current = tokens[index];
    const next = tokens[index + 1] ?? null;
    withImplicitMultiplication.push(current);
    if (isValueToken(current) && canStartPrimary(next)) {
      if (
        current.type === "ident" &&
        FUNCTIONS.has(current.value.toLowerCase()) &&
        next?.type === "lparen"
      ) {
        continue;
      }
      withImplicitMultiplication.push({ type: "op", value: "*" });
    }
  }

  return withImplicitMultiplication;
}

function parserError(message: string) {
  return new Error(`parse_error:${message}`);
}

class Parser {
  private readonly tokens: Token[];
  private index = 0;

  constructor(tokens: Token[]) {
    this.tokens = tokens;
  }

  private peek() {
    return this.tokens[this.index] ?? null;
  }

  private next() {
    return this.tokens[this.index++] ?? null;
  }

  private expect(type: Token["type"]) {
    const token = this.next();
    if (!token || token.type !== type) {
      throw parserError(`expected_${type}`);
    }
    return token;
  }

  parseExpression(): ExprNode {
    const expr = this.parseAdditive();
    if (this.peek()) {
      throw parserError("unexpected_trailing_tokens");
    }
    return expr;
  }

  private parseAdditive(): ExprNode {
    let node = this.parseMultiplicative();
    while (true) {
      const token = this.peek();
      if (token?.type === "op" && (token.value === "+" || token.value === "-")) {
        this.next();
        const rhs = this.parseMultiplicative();
        node = { type: "binary", op: token.value, left: node, right: rhs };
        continue;
      }
      break;
    }
    return node;
  }

  private parseMultiplicative(): ExprNode {
    let node = this.parseUnary();
    while (true) {
      const token = this.peek();
      if (token?.type === "op" && (token.value === "*" || token.value === "/")) {
        this.next();
        const rhs = this.parseUnary();
        node = { type: "binary", op: token.value, left: node, right: rhs };
        continue;
      }
      if (canStartPrimary(token)) {
        const rhs = this.parseUnary();
        node = { type: "binary", op: "*", left: node, right: rhs };
        continue;
      }
      break;
    }
    return node;
  }

  private parsePower(): ExprNode {
    let node = this.parsePrimary();
    const token = this.peek();
    if (token?.type === "op" && token.value === "^") {
      this.next();
      const rhs = this.parseUnary();
      node = { type: "binary", op: "^", left: node, right: rhs };
    }
    return node;
  }

  private parseUnary(): ExprNode {
    const token = this.peek();
    if (token?.type === "op" && (token.value === "+" || token.value === "-")) {
      this.next();
      const expr = this.parseUnary();
      return token.value === "+"
        ? expr
        : { type: "unary", op: "-", expr };
    }
    return this.parsePower();
  }

  private parsePrimary(): ExprNode {
    const token = this.next();
    if (!token) {
      throw parserError("unexpected_eof");
    }
    if (token.type === "number") {
      return { type: "number", value: token.value };
    }
    if (token.type === "ident") {
      const next = this.peek();
      if (next?.type === "lparen" && FUNCTIONS.has(token.value.toLowerCase())) {
        this.next();
        const arg = this.parseAdditive();
        this.expect("rparen");
        return { type: "func", name: token.value.toLowerCase(), arg };
      }
      return { type: "ident", value: token.value };
    }
    if (token.type === "lparen") {
      const expr = this.parseAdditive();
      this.expect("rparen");
      return expr;
    }
    throw parserError("unexpected_token");
  }
}

function parseExpression(text: string) {
  const tokens = tokenize(text);
  return new Parser(tokens).parseExpression();
}

function collectSymbols(node: ExprNode, into = new Set<string>()) {
  if (node.type === "ident") {
    into.add(node.value);
  } else if (node.type === "unary") {
    collectSymbols(node.expr, into);
  } else if (node.type === "binary") {
    collectSymbols(node.left, into);
    collectSymbols(node.right, into);
  } else if (node.type === "func") {
    collectSymbols(node.arg, into);
  }
  return into;
}

function evaluate(node: ExprNode, env: Record<string, number>): number {
  switch (node.type) {
    case "number":
      return node.value;
    case "ident": {
      const key = node.value;
      if (key === "pi") return Math.PI;
      if (key === "e") return Math.E;
      if (key === "C" || key === "c") return env[key] ?? 0;
      const value = env[key];
      if (typeof value !== "number" || !Number.isFinite(value)) {
        throw new Error(`missing_variable:${key}`);
      }
      return value;
    }
    case "unary": {
      const value: number = evaluate(node.expr, env);
      return node.op === "-" ? -value : value;
    }
    case "binary": {
      const left: number = evaluate(node.left, env);
      const right: number = evaluate(node.right, env);
      switch (node.op) {
        case "+":
          return left + right;
        case "-":
          return left - right;
        case "*":
          return left * right;
        case "/":
          return left / right;
        case "^":
          return left ** right;
      }
    }
    case "func": {
      const arg: number = evaluate(node.arg, env);
      switch (node.name) {
        case "sin":
          return Math.sin(arg);
        case "cos":
          return Math.cos(arg);
        case "tan":
          return Math.tan(arg);
        case "exp":
          return Math.exp(arg);
        case "log":
          return Math.log(arg);
        case "sqrt":
          return Math.sqrt(arg);
        case "abs":
          return Math.abs(arg);
      }
    }
  }

  throw new Error("unsupported_expression_node");
}

function makeRng(seed: number) {
  let state = seed >>> 0;
  return () => {
    state += 0x6D2B79F5;
    let t = state;
    t = Math.imul(t ^ (t >>> 15), t | 1);
    t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

function finite(value: unknown): value is number {
  return typeof value === "number" && Number.isFinite(value);
}

function isComparableValue(value: unknown) {
  return finite(value) && Number.isFinite(value);
}

function buildSamplePoints(domain: [number, number], count: number) {
  const rng = makeRng(SEED);
  const [lo, hi] = domain;
  const points: number[] = [];
  for (let i = 0; i < count; i += 1) {
    points.push(lo + (hi - lo) * rng());
  }
  return points;
}

function compareNumbers(a: number, b: number, tol: number) {
  return Math.abs(a - b) <= tol * (1 + Math.abs(a) + Math.abs(b));
}

function compareExpressions(
  aText: string,
  bText: string,
  variables: string[],
  domain: [number, number],
  tol = DEFAULT_TOL,
) {
  const a = parseExpression(aText);
  const b = parseExpression(bText);
  const free = new Set<string>([
    ...Array.from(collectSymbols(a)),
    ...Array.from(collectSymbols(b)),
    ...variables,
  ]);
  for (const symbol of ["e", "pi", "C", "c"]) {
    free.delete(symbol);
  }

  const freeVars = Array.from(free).sort();
  if (freeVars.length === 0) {
    const env: Record<string, number> = { C: 0, c: 0, e: Math.E, pi: Math.PI };
    const av = evaluate(a, env);
    const bv = evaluate(b, env);
    return compareNumbers(av, bv, tol);
  }

  const rng = makeRng(SEED ^ freeVars.length);
  let agree = 0;
  for (let i = 0; i < 80; i += 1) {
    const env: Record<string, number> = { C: 0, c: 0, e: Math.E, pi: Math.PI };
    for (const variable of freeVars) {
      env[variable] = domain[0] + (domain[1] - domain[0]) * rng();
    }
    try {
      const av = evaluate(a, env);
      const bv = evaluate(b, env);
      if (!Number.isFinite(av) || !Number.isFinite(bv)) continue;
      if (!compareNumbers(av, bv, tol)) return false;
      agree += 1;
      if (agree >= MIN_AGREE) return true;
    } catch {
      continue;
    }
  }
  return false;
}

function derivativeAt(node: ExprNode, variable: string, value: number) {
  const h = Math.max(1e-6, Math.abs(value) * 1e-6);
  const envLeft: Record<string, number> = { C: 0, c: 0, e: Math.E, pi: Math.PI };
  const envRight: Record<string, number> = { C: 0, c: 0, e: Math.E, pi: Math.PI };
  envLeft[variable] = value - h;
  envRight[variable] = value + h;
  const left = evaluate(node, envLeft);
  const right = evaluate(node, envRight);
  return (right - left) / (2 * h);
}

function detectConstantToken(text: string) {
  return /\b[Cc]\b/.test(text);
}

function result(verdict: FormulaVerdict, reason: string | null): FormulaCheckResult {
  return { verdict, reason };
}

function checkSingleFormula(
  caseInput: FormulaCase,
): FormulaCheckResult {
  const responseText = asString(caseInput.response);
  const canonicalText = caseInput.canonical?.trim() ?? "";
  if (caseInput.kind === "conceptual" || !canonicalText) {
    return result("ABSTAIN", null);
  }

  const ambiguity = detectAmbiguousTypedFormulaText(responseText);
  if (ambiguity.ambiguous) {
    return result("ABSTAIN", ambiguity.reason);
  }

  const variables = caseInput.variables ?? [];
  const domain = caseInput.domain ?? DEFAULT_DOMAIN;
  const tol = caseInput.tol ?? DEFAULT_TOL;

  try {
    if (caseInput.kind === "expression") {
      return compareExpressions(responseText, canonicalText, variables, domain, tol)
        ? result("PASS", null)
        : result("FLAG", "not_equivalent");
    }
    if (caseInput.kind === "numeric") {
      const response = parseExpression(responseText);
      const canonical = parseExpression(canonicalText);
      const env: Record<string, number> = { C: 0, c: 0, e: Math.E, pi: Math.PI };
      const responseValue = evaluate(response, env);
      const canonicalValue = evaluate(canonical, env);
      return compareNumbers(responseValue, canonicalValue, caseInput.tol ?? DEFAULT_NUM_TOL)
        ? result("PASS", null)
        : result("FLAG", `numeric_mismatch: got ${responseValue}, want ${canonicalValue}`);
    }
    if (caseInput.kind === "antiderivative") {
      if (!detectConstantToken(responseText)) {
        return result("FLAG", "missing_constant");
      }
      const response = parseExpression(responseText);
      const canonical = parseExpression(canonicalText);
      const variable = caseInput.var ?? "x";
      const samples = buildSamplePoints(domain, 80);
      let agree = 0;
      for (const sample of samples) {
        const derivative = derivativeAt(response, variable, sample);
        const env: Record<string, number> = { C: 0, c: 0, e: Math.E, pi: Math.PI };
        env[variable] = sample;
        const target = evaluate(canonical, env);
        if (!Number.isFinite(derivative) || !Number.isFinite(target)) continue;
        if (!compareNumbers(derivative, target, tol)) {
          return result("FLAG", "derivative_mismatch");
        }
        agree += 1;
        if (agree >= MIN_AGREE) {
          return result("PASS", null);
        }
      }
      return result("FLAG", "derivative_mismatch");
    }
  } catch (error) {
    const message = error instanceof Error ? error.message : "parse_error";
    return message.startsWith("parse_error:")
      ? result("ABSTAIN", message)
      : result("ABSTAIN", `numeric_eval_error: ${message}`);
  }

  return result("ABSTAIN", null);
}

export function checkFormulaCase(caseInput: FormulaCase): FormulaCheckResult {
  return checkSingleFormula(caseInput);
}

export function buildEcfResult(input: EcfQuestion): EcfQuestionResult {
  const studentAnswers = new Map<string, number>();
  const canonAnswers = new Map<string, number>();
  const parts: EcfPartResult[] = [];
  let earned = 0;

  for (const part of input.parts) {
    const student = input.student[part.id];
    if (!student) {
      parts.push({
        part: part.id,
        verdict: "NAKED_ANSWER",
        points_awarded: 0,
        points_possible: part.points,
        feedback: `No response provided for part ${part.id}.`,
      });
      continue;
    }

    const deps = part.deps ?? {};
    const shownSubs = student.shown_subs ?? null;
    const stated = asString(student.stated_formula);
    const y = student.student_answer;
    const canonicalInputs = {
      ...(part.givens ?? {}),
      ...Object.fromEntries(
        Object.entries(deps).map(([symbol, source]) => [symbol, canonAnswers.get(source) ?? 0]),
      ),
    };
    const studentInputs = {
      ...(part.givens ?? {}),
      ...Object.fromEntries(
        Object.entries(deps).map(([symbol, source]) => [symbol, studentAnswers.get(source) ?? 0]),
      ),
      ...(shownSubs ?? {}),
    };

    let canonicalValue: number;
    try {
      canonicalValue = evaluate(parseExpression(part.canonical_formula), canonicalInputs);
    } catch (error) {
      const message = error instanceof Error ? error.message : "parse_error";
      parts.push({
        part: part.id,
        verdict: "NAKED_ANSWER",
        points_awarded: 0,
        points_possible: part.points,
        feedback:
          `Could not parse the canonical formula for part ${part.id}: ${message}.`,
      });
      continue;
    }

    const noWorkShown = !stated && (!shownSubs || Object.keys(shownSubs).length === 0);
    if (noWorkShown) {
      parts.push({
        part: part.id,
        verdict: "NAKED_ANSWER",
        points_awarded: 0,
        points_possible: part.points,
        feedback:
          `No work shown for part ${part.id}, so we can't trace how you reached ${y}. Consistency (ECF) credit can't be applied without shown work. Opening help.`,
      });
      studentAnswers.set(part.id, y);
      canonAnswers.set(part.id, canonicalValue);
      continue;
    }

    let workSupports: boolean | null = null;
    let workValue: number | null = null;
    if (stated && shownSubs && Object.keys(shownSubs).length > 0) {
      try {
        workValue = evaluate(parseExpression(stated), studentInputs);
        workSupports = compareNumbers(workValue, y, ECF_REL_TOL);
      } catch (error) {
        const message = error instanceof Error ? error.message : "parse_error";
        parts.push({
          part: part.id,
          verdict: "NAKED_ANSWER",
          points_awarded: 0,
          points_possible: part.points,
          feedback:
            `Could not parse the shown work for part ${part.id}: ${message}.`,
        });
        studentAnswers.set(part.id, y);
        canonAnswers.set(part.id, canonicalValue);
        continue;
      }
    }

    const responseComparable = compareNumbers(y, canonicalValue, ECF_REL_TOL);
    const responseStructuralOk = stated
      ? compareExpressions(stated, part.canonical_formula, Object.keys({ ...(part.givens ?? {}), ...deps }), DEFAULT_DOMAIN, DEFAULT_TOL)
      : true;

    if (!responseStructuralOk) {
      parts.push({
        part: part.id,
        verdict: "CONCEPTUAL_COLLAPSE",
        points_awarded: 0,
        points_possible: part.points,
        feedback:
          `Part ${part.id} uses the wrong relationship: you wrote ${stated ?? "(no formula)"}, but this step needs ${part.canonical_formula}.`,
      });
      studentAnswers.set(part.id, y);
      canonAnswers.set(part.id, canonicalValue);
      continue;
    }

    if (responseComparable && workSupports === false) {
      parts.push({
        part: part.id,
        verdict: "COINCIDENTAL",
        points_awarded: 0,
        points_possible: part.points,
        feedback:
          `Your final number for part ${part.id} matches, but your shown work (${stated} with your values) does not produce it.`,
      });
      studentAnswers.set(part.id, y);
      canonAnswers.set(part.id, canonicalValue);
      continue;
    }

    if (workSupports === false) {
      parts.push({
        part: part.id,
        verdict: "INCORRECT",
        points_awarded: 0,
        points_possible: part.points,
        feedback:
          `Arithmetic error in part ${part.id}: ${stated} with your values gives ${workValue?.toFixed(4)}, but you wrote ${y}.`,
      });
      studentAnswers.set(part.id, y);
      canonAnswers.set(part.id, canonicalValue);
      continue;
    }

    const shownInputsOk =
      !shownSubs ||
      Object.entries(part.givens ?? {}).every(([key, value]) =>
        key in shownSubs && compareNumbers(shownSubs[key], value, DEFAULT_TOL)
      ) &&
      Object.entries(deps).every(([symbol, source]) =>
        symbol in shownSubs && compareNumbers(shownSubs[symbol], studentAnswers.get(source) ?? 0, DEFAULT_TOL)
      );

    if (!shownInputsOk) {
      parts.push({
        part: part.id,
        verdict: "INCORRECT",
        points_awarded: 0,
        points_possible: part.points,
        feedback:
          `Part ${part.id} uses a value that doesn't match the problem's givens or your earlier answers.`,
      });
      studentAnswers.set(part.id, y);
      canonAnswers.set(part.id, canonicalValue);
      continue;
    }

    if (responseComparable) {
      earned += part.points;
      parts.push({
        part: part.id,
        verdict: "CORRECT",
        points_awarded: part.points,
        points_possible: part.points,
        feedback: `Part ${part.id} correct.`,
      });
    } else {
      earned += part.points;
      parts.push({
        part: part.id,
        verdict: "CORRECT_VIA_ECF",
        points_awarded: part.points,
        points_possible: part.points,
        feedback:
          `Your value from an earlier part was off, but your setup for part ${part.id} is the right relationship and you computed it correctly on your own number — full credit for part ${part.id}.`,
      });
    }

    studentAnswers.set(part.id, y);
    canonAnswers.set(part.id, canonicalValue);
  }

  return {
    earned,
    possible: input.parts.reduce((sum, part) => sum + part.points, 0),
    parts,
  };
}

export function findStatisticsItem(contentKey: string | null | undefined) {
  return contentKey ? STATISTICS_ITEM_KEYS[contentKey] ?? null : null;
}

function asRecord(value: unknown) {
  return value && typeof value === "object" && !Array.isArray(value)
    ? value as Record<string, unknown>
    : null;
}

function asNumber(value: unknown) {
  return typeof value === "number" && Number.isFinite(value) ? value : null;
}

function extractStudentPart(value: unknown): EcfStudentPart | null {
  const record = asRecord(value);
  if (!record) {
    return null;
  }

  const studentAnswer = asNumber(record.student_answer) ??
    asNumber(record.studentAnswer);
  if (studentAnswer === null) {
    return null;
  }

  const shownSubRecord = asRecord(record.shown_subs ?? record.shownSubs);
  const shownSubs = shownSubRecord
    ? Object.fromEntries(
      Object.entries(shownSubRecord).flatMap(([key, item]) => {
        const numeric = asNumber(item);
        return numeric === null ? [] : [[key, numeric]];
      }),
    )
    : null;

  const statedFormula = typeof record.stated_formula === "string"
    ? record.stated_formula
    : typeof record.statedFormula === "string"
    ? record.statedFormula
    : null;

  return {
    stated_formula: statedFormula,
    shown_subs: shownSubs,
    student_answer: studentAnswer,
  };
}

export function coerceEcfQuestion(
  item: { ecf_parts: EcfPartSpec[] } | null | undefined,
  responseParts: unknown,
): EcfQuestion | null {
  if (!item?.ecf_parts?.length) {
    return null;
  }

  const source = asRecord(responseParts);
  if (!source) {
    return null;
  }

  const directParts = asRecord(source.student ?? source.parts ?? source.responses);
  const wrappedParts = Array.isArray(source.parts)
    ? source.parts
    : Array.isArray(source.responses)
    ? source.responses
    : null;

  const student: Record<string, EcfStudentPart> = {};
  for (const part of item.ecf_parts) {
    const candidate = directParts?.[part.id] ??
      wrappedParts?.find((entry) => asRecord(entry)?.id === part.id) ??
      source[part.id];
    const extracted = extractStudentPart(candidate);
    if (!extracted) {
      return null;
    }
    student[part.id] = extracted;
  }

  return {
    parts: item.ecf_parts,
    student,
  };
}

export function detectTypedFormulaFeedback(
  responseText: string | null,
  canonical: string | null,
  kind: FormulaKind,
  variables?: string[],
  variable?: string,
) {
  return checkFormulaCase({
    kind,
    canonical,
    response: responseText ?? "",
    variables,
    var: variable,
  });
}

const STATISTICS_ITEM_KEYS: Record<string, {
  content_key: string;
  form: string;
  criteria: Record<string, { kind: "conceptual" | "numeric" | "numeric+ecf" | "symbolic_only"; verdict?: "ABSTAIN"; parts?: string[]; note?: string }>;
  ecf_parts: EcfPartSpec[];
  ecf_note: string;
  corpus_defect?: string;
}> = {
  "APSTAT-MOD3-H001-INV": {
    content_key: "APSTAT-MOD3-H001-INV",
    form: "long",
    criteria: {
      bias_identification: { kind: "conceptual", verdict: "ABSTAIN" },
      improved_sampling_design: { kind: "conceptual", verdict: "ABSTAIN" },
      ci_calculation: { kind: "numeric+ecf", parts: ["SE", "CI_low", "CI_high"] },
      ci_interpretation: { kind: "conceptual", verdict: "ABSTAIN" },
      hypothesis_test: { kind: "numeric+ecf", parts: ["t_stat"], note: "H0/H1 setup + conclusion are conceptual (ABSTAIN)." },
    },
    ecf_parts: [
      { id: "SE", points: 1, canonical_formula: "s/sqrt(n)", givens: { s: 120, n: 30 }, canonical_answer: 21.90890, note: "s/sqrt(n)" },
      { id: "CI_low", points: 1, canonical_formula: "xbar - z*SE", givens: { xbar: 850, z: 1.96 }, deps: { SE: "SE" }, canonical_answer: 807.05863 },
      { id: "CI_high", points: 1, canonical_formula: "xbar + z*SE", givens: { xbar: 850, z: 1.96 }, deps: { SE: "SE" }, canonical_answer: 892.94137 },
      { id: "t_stat", points: 1, canonical_formula: "(xbar - mu0)/SE", givens: { xbar: 850, mu0: 800 }, deps: { SE: "SE" }, canonical_answer: 2.28217 },
    ],
    ecf_note: "SE feeds both CI and hypothesis-test parts.",
  },
  "APSTAT-MOD5-H001-INV": {
    content_key: "APSTAT-MOD5-H001-INV",
    form: "long",
    criteria: {
      causation_vs_correlation: { kind: "conceptual", verdict: "ABSTAIN" },
      confounding_variables: { kind: "conceptual", verdict: "ABSTAIN" },
      experimental_advantage: { kind: "conceptual", verdict: "ABSTAIN" },
      experimental_conclusion: { kind: "conceptual", verdict: "ABSTAIN" },
    },
    ecf_parts: [],
    ecf_note: "Fully conceptual item — no deterministic keys.",
  },
  "APSTAT-MOD6-H001": {
    content_key: "APSTAT-MOD6-H001",
    form: "long",
    criteria: {
      hypotheses_setup: { kind: "conceptual", verdict: "ABSTAIN" },
      test_calculation: { kind: "numeric+ecf", parts: ["SE_diff", "t_stat"] },
      conclusion: { kind: "conceptual", verdict: "ABSTAIN" },
    },
    ecf_parts: [
      { id: "SE_diff", points: 1, canonical_formula: "sqrt(s1**2/n1 + s2**2/n2)", givens: { s1: 8, n1: 30, s2: 7, n2: 30 }, canonical_answer: 1.94079 },
      { id: "t_stat", points: 1, canonical_formula: "(m1 - m2)/SEd", givens: { m1: 72, m2: 76 }, deps: { SEd: "SE_diff" }, canonical_answer: -2.06104, sign_sensitive: true },
    ],
    ecf_note: "Two-sample pooled-SE feeds the t-statistic.",
  },
  "APSTAT-MOD7-H001": {
    content_key: "APSTAT-MOD7-H001",
    form: "long",
    criteria: {
      bayes_theorem_setup: { kind: "conceptual", verdict: "ABSTAIN" },
      calculation: { kind: "numeric+ecf", parts: ["P_D", "P_BgivenD"] },
    },
    ecf_parts: [
      { id: "P_D", points: 1, canonical_formula: "pda*pa + pdb*pb + pdc*pc", givens: { pda: 0.02, pa: 0.30, pdb: 0.03, pb: 0.50, pdc: 0.01, pc: 0.20 }, canonical_answer: 0.023 },
      { id: "P_BgivenD", points: 1, canonical_formula: "(pdb*pb)/PD", givens: { pdb: 0.03, pb: 0.50 }, deps: { PD: "P_D" }, canonical_answer: 0.65217 },
    ],
    ecf_note: "Total probability feeds the Bayes posterior.",
  },
  "APSTAT-MOD8-H001": {
    content_key: "APSTAT-MOD8-H001",
    form: "long",
    corpus_defect:
      "NO DATASET. The item asks to compute r and the regression line from data on 25 students, but no data table exists; numeric claims must be isolated/excluded.",
    criteria: {
      correlation_calculation: { kind: "numeric", verdict: "ABSTAIN" },
      regression_equation: { kind: "symbolic_only" },
      interpretation: { kind: "conceptual", verdict: "ABSTAIN" },
    },
    ecf_parts: [],
    ecf_note: "Excluded from numeric ECF cascade until repaired with a dataset.",
  },
};
