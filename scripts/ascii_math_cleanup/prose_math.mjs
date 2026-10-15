// TASK-0075: find maths runs inside question/teaching prose and convert each to LaTeX (no model, deterministic).
//
// A "run" is a chain of maths atoms (numbers with units, symbols with sub/superscripts, Greek letters, functions,
// parenthesised groups, |x|, roots, integrals) joined by operators or juxtaposition. A run is kept only when it carries
// a trigger (an operator, a script, a Greek letter, a unit, a root, an integral ...), so ordinary words and bare numbers
// stay plain. Each run is converted with convert.mjs. The text outside the runs never changes.
//
// DECISION-0121: inside a sentence a compound quotient keeps the slash (explicit grouping); only a field that is one
// single expression is stacked. `draftField` therefore passes stack:true only when the whole field is one run.
//
// This file holds no exam text.
import { convertExpr, isPure, Unhandled } from "./convert.mjs";

const SUPS = "⁰¹²³⁴⁵⁶⁷⁸⁹⁻⁺ᴿᴸᵀᵇⁿ";
const SUBS = "₀₁₂₃₄₅₆₇₈₉ₓₐ";
const GREEK_RE = "[αβγδεζηθικλμνξπρστυφχψωΑΒΓΔΕΖΗΘΙΚΛΜΝΞΠΡΣΤΥΦΧΨΩµ]";
const GREEK_NAMES = new Set(["alpha", "beta", "gamma", "delta", "epsilon", "theta", "lambda", "mu", "nu", "pi", "rho", "sigma", "tau", "phi", "omega", "kappa", "Delta", "Omega", "Phi"]);
const FUNCS = new Set(["sin", "cos", "tan", "sec", "csc", "cot", "ln", "log", "exp", "sqrt"]);
const STOP = new Set(("is of to as at by in on so or it if no be do we an he me my up us go am and the but for not are was can has had its one two per via how why who all any new old out off use add set get see may yet nor too yes also only each both than then that this with from into over same when what them they their here there been have does done will would such some more most less many much near away half full zero four five nine each less rod").split(" "));

// units
const PREFIX = "[kcmMGnpμµ]";
const BASE = "(?:mol|Hz|Pa|eV|rad|Ohm|Ω|N|C|V|J|W|A|F|H|T|s|m|g|L|K)";
const UATOM = `(?:${PREFIX}?${BASE})(?:[⁰¹²³⁴⁵⁶⁷⁸⁹⁻⁺]+|\\^-?\\d)?`;
const UPROD = `${UATOM}(?:[·*]${UATOM})*`;
const UNIT = `${UPROD}(?:/(?:\\(${UPROD}\\)|${UPROD}))?`;
const SUPC = "[⁰¹²³⁴⁵⁶⁷⁸⁹⁻⁺]";
const EXP = ` ?[×x] ?10(?:${SUPC}+|\\^\\(?[-−]?\\d+\\)?)`;
const NOTCONT = "(?![A-Za-z0-9_₀-₉ₓ])";
const QUANT = new RegExp(`\\d+(?:\\.\\d+)?(?:${EXP})?(?:(?: |(?=[μµ]))(${UNIT})${NOTCONT})?`, "y");
const NUMBER = /\d+(?:\.\d+)?/y;
const CURATED_UNITS = new RegExp(`(?:V/m|N/C|m/s²|m/s|N·m²/C²|N·m²/C|C²/N·m²|kg·m/s|J/C|N·m|J/kg|W/m²)(?![A-Za-z0-9])`, "y");

function unitTex(u) {
  let t = u.replace(/Ohm/g, "Ω");
  let pre = "";
  const m = /^([μµ])/.exec(t);
  if (m) { pre = "\\mu"; t = t.slice(1); }
  t = t.replace(/[⁰¹²³⁴⁵⁶⁷⁸⁹⁻⁺]+/g, (r) => "^{" + [...r].map((c) => "0123456789-+"["⁰¹²³⁴⁵⁶⁷⁸⁹⁻⁺".indexOf(c)]).join("") + "}");
  t = t.replace(/\^(-?\d)/g, "^{$1}");
  t = t.replace(/[·*]/g, "\\cdot ").replace(/Ω/g, "\\Omega").replace(/\\cdot\s+$/, "");
  if (/[μµ]/.test(t)) throw new Unhandled("unit prefix in the middle");
  return `${pre}\\mathrm{${t}}`;
}

// ---- scanner --------------------------------------------------------------------------------------------------------

const isLetter = (c) => /[A-Za-z]/.test(c || "");
const isDigit = (c) => /[0-9]/.test(c || "");
const OPS = "=≈~∝+−×·*/<>≤≥≠±→÷";

function scan(text) {
  const n = text.length;
  const at = (i) => text[i];
  const ws = (i) => { while (i < n && text[i] === " ") i++; return i; };

  function sticky(re, i) { re.lastIndex = i; const m = re.exec(text); return m && m.index === i ? m : null; }

  function postfix(i, flags) {
    for (;;) {
      const c = at(i);
      if (c && (SUPS.includes(c) || SUBS.includes(c))) { while (i < n && (SUPS.includes(at(i)) || SUBS.includes(at(i)))) i++; flags.script = true; continue; }
      if (c === "′" || c === "″" || c === "°") { i++; flags.script = true; continue; }
      if (c === "'" && /[A-Za-z)]/.test(at(i - 1) || "")) {
        const m = sticky(/'{1,2}(?![A-Za-z])/y, i);
        if (m) { i += m[0].length; flags.script = true; continue; }
      }
      if (c === "^") {
        let j = i + 1;
        if (at(j) === "{") { const k = text.indexOf("}", j); if (k < 0) break; i = k + 1; flags.script = true; continue; }
        if (at(j) === "(") { const g = group(j); if (g < 0) break; i = g; flags.script = true; continue; }
        if (at(j) === "-" || at(j) === "−") j++;
        const m = sticky(/[0-9]+|[A-Za-z]/y, j);
        if (!m) break;
        i = j + m[0].length; flags.script = true; continue;
      }
      if (c === "_" && /[A-Za-z0-9]/.test(at(i + 1) || "")) {
        const m = sticky(/[A-Za-z]+|[0-9]/y, i + 1);
        i = i + 1 + m[0].length; flags.script = true; continue;
      }
      break;
    }
    return i;
  }

  function group(i, outer) { // "(" chain ")" -> end index after ")" or -1
    if (at(i) !== "(") return -1;
    const flags = {};
    const e = chain(i + 1, flags);
    if (e < 0) return -1;
    const j = ws(e);
    if (at(j) !== ")") return -1;
    if (outer) for (const k of Object.keys(flags)) outer[k] = outer[k] || flags[k];
    return j + 1;
  }

  function wordOk(w, i, j) {
    if (FUNCS.has(w) || GREEK_NAMES.has(w)) return true;
    if (STOP.has(w)) return false;
    if (/^[A-Z][a-z]+$/.test(w) && STOP.has(w.toLowerCase()) && at(j) === " ") return false;
    if (w.length <= 2) return true;
    if (w.length <= 4) {
      const before = at(i - 1), after = at(j);
      const adj = (c) => c && ("/·*_^(×".includes(c) || SUPS.includes(c) || SUBS.includes(c) || c === "′");
      return adj(before) || adj(after);
    }
    return false;
  }

  // one atom; returns end index or -1; flags accumulate triggers
  let absDepth = 0;
  function atom(i, flags) {
    let c = at(i);
    if (c === undefined) return -1;
    // curated standalone units (V/m, N/C ...)
    if (/[A-Za-z]/.test(c) && !isLetter(at(i - 1))) {
      const u = sticky(CURATED_UNITS, i);
      if (u) { flags.unit = true; return i + u[0].length; }
    }
    if (isDigit(c)) {
      const q = sticky(QUANT, i);
      if (q) {
        if (q[1]) flags.unit = true;
        if (/×|x ?10|^\d+(\.\d+)? ?x ?10/.test(q[0])) flags.script = true;
        return atomTail(postfix(i + q[0].length, flags), flags);
      }
      const m = sticky(NUMBER, i);
      return atomTail(postfix(i + m[0].length, flags), flags);
    }
    if (new RegExp(GREEK_RE).test(c)) { flags.greek = true; return atomTail(postfix(i + 1, flags), flags); }
    if (c === "½") { flags.script = true; return atomTail(i + 1, flags); }
    if (c === "∞") { flags.script = true; return i + 1; }
    if (c === "[") {
      const flagsIn = {};
      const e = chain(i + 1, flagsIn);
      if (e < 0 || at(ws(e)) !== "]") return -1;
      flags.script = flags.script || !!flagsIn.script;
      return atomTail(postfix(ws(e) + 1, flags), flags);
    }
    if (c === "√") {
      flags.root = true;
      const j = ws(i + 1);
      const e = at(j) === "(" ? group(j) : atom(j, flags);
      return e < 0 ? -1 : e;
    }
    if (c === "∫" || c === "∮") {
      flags.integral = true;
      let j = i + 1;
      for (;;) {
        if (j < n && (SUPS.includes(at(j)) || SUBS.includes(at(j)))) { j++; continue; }
        if (at(j) === "^" && /[∞A-Za-z0-9]/.test(at(j + 1) || "")) { j += 2; continue; }
        break;
      }
      // integrand: atoms separated by single spaces
      let e = j, last = j;
      for (;;) {
        const k = ws(e);
        const a = chainAtomOrSpaced(k, flags);
        if (a < 0) break;
        last = a; e = a;
      }
      return last;
    }
    if (c === "|") {
      const flagsIn = {};
      absDepth++;
      const e = chain(i + 1, flagsIn);
      absDepth--;
      if (e < 0 || at(ws(e)) !== "|") return -1;
      flags.abs = true;
      return atomTail(postfix(ws(e) + 1, flags), flags);
    }
    if (c === "(") {
      const g = group(i, flags);
      return g < 0 ? -1 : atomTail(postfix(g, flags), flags);
    }
    if (isLetter(c)) {
      const m = sticky(/[A-Za-z]+/y, i);
      const w = m[0];
      const j = i + w.length;
      if (!wordOk(w, i, j) && w.length > 1) {
        // a long word may still start with a Greek-name prefix glued to letters (piR); keep simple: reject
        return -1;
      }
      if (w.length === 1 || w.length === 2 || FUNCS.has(w) || GREEK_NAMES.has(w) || wordOk(w, i, j)) {
        if (FUNCS.has(w) && w !== "sqrt") {
          flags.func = true;
          let k = at(j) === " " ? j + 1 : j;
          const e = at(k) === "(" ? group(k) : atom(k, flags);
          return e < 0 ? j : e;
        }
        if (w === "sqrt") { flags.root = true; const g = group(j); return g < 0 ? -1 : g; }
        if (GREEK_NAMES.has(w)) flags.greek = true;
        return atomTail(postfix(j, flags), flags);
      }
      return -1;
    }
    return -1;
  }

  // juxtaposed atoms with no space: kq, q₁q₂, ρπr²L, Q₀e^{...}
  function atomTail(i, flags) {
    for (;;) {
      const c = at(i);
      if (!c || c === " ") return i;
      if (c === "|" && absDepth > 0) return i;
      if (isDigit(c) || isLetter(c) || new RegExp(GREEK_RE).test(c) || c === "(" || c === "[" || c === "√" || c === "|" || c === "½") {
        const e = atom(i, flags);
        if (e < 0 || e === i) return i;
        i = e; continue;
      }
      return i;
    }
  }

  function chainAtomOrSpaced(i, flags) {
    const c = at(i);
    if (c === undefined) return -1;
    if (isLetter(c) || new RegExp(GREEK_RE).test(c) || isDigit(c) || c === "(" || c === "|") {
      const m = isLetter(c) ? sticky(/[A-Za-z]+/y, i) : null;
      if (m && m[0].length > 2 && !FUNCS.has(m[0]) && !GREEK_NAMES.has(m[0])) return -1;
      if (m && STOP.has(m[0])) return -1;
      return atom(i, flags);
    }
    return -1;
  }

  function isOpAt(i) {
    const c = at(i);
    if (c === undefined) return false;
    if (c === "-") {
      // ASCII hyphen: a minus only when not glued between two letters
      return !(isLetter(at(i - 1)) && isLetter(at(i + 1)));
    }
    if (c === "−") return true;
    return OPS.includes(c);
  }

  // chain: atom (op atom | atom)* ; returns end or -1
  function chain(i, flags) {
    let j = ws(i);
    // leading sign
    if ((at(j) === "+" || at(j) === "−" || at(j) === "-" || at(j) === "±") && !isLetter(at(j - 1)) && !isDigit(at(j - 1)) && /[0-9A-Za-z(√|∫∮½αβγδεζηθικλμνξπρστυφχψω]/.test(at(j + 1) || "")) { j++; flags.op = true; }
    let e = atom(j, flags);
    if (e < 0) return -1;
    for (;;) {
      let k = ws(e);
      const spaced = k > e;
      if (isOpAt(k)) {
        const op = at(k);
        let m = ws(k + 1);
        if ("+−-±".includes(op) && spaced && m === k + 1) break; // " +3.0": a sign on the next item, not a binary operator
        // leading sign after an operator
        if ((at(m) === "−" || at(m) === "-" || at(m) === "+" || at(m) === "±") && /[0-9A-Za-z(√|∫∮½∞αβγδεζηθικλμνξπρστυφχψω]/.test(at(m + 1) || "")) m++;
        const a = atom(m, flags);
        if (a < 0) break;
        if (op !== "/" ) flags.op = true;
        if ("=≈~∝×·*±<>≤≥≠".includes(op)) flags.op = true;
        e = a;
        continue;
      }
      break;
    }
    return e;
  }

  const runs = [];
  let i = 0;
  while (i < n) {
    const c = at(i);
    const startable = isDigit(c) || isLetter(c) || new RegExp(GREEK_RE).test(c) || "(√|∫∮+−±½[∞".includes(c) || c === "-";
    if (!startable || (isLetter(c) && isLetter(at(i - 1))) || (isLetter(c) && (isDigit(at(i - 1)) && false))) { i++; continue; }
    // do not start inside a word or right after an underscore/caret
    if (i > 0 && (isLetter(at(i - 1)) || at(i - 1) === "_" || at(i - 1) === "^")) { i++; continue; }
    if (c === "-" && (isLetter(at(i - 1)) || isDigit(at(i - 1)))) { i++; continue; }
    const flags = {};
    const e = chain(i, flags);
    if (e > i) {
      let end = e;
      // trailing spaces never belong to a run
      while (text[end - 1] === " ") end--;
      const piece = text.slice(i, end);
      const triggered = flags.script || flags.greek || flags.unit || flags.root || flags.integral || flags.abs || flags.func || flags.op || /[=≈∝×·^_√∫∮±°′<>≤≥≠]/.test(piece) || /[⁰¹²³⁴⁵⁶⁷⁸⁹₀-₉ₓ]/.test(piece);
      // a bare quotient of letters (kq/r) counts; a bare quotient of digits does not
      const letterSlash = /[A-Za-z]\/|\/[A-Za-z]/.test(piece);
      if (triggered || letterSlash) { runs.push({ start: i, end }); i = end; continue; }
      i = Math.max(i + 1, end); continue;
    }
    i++;
  }
  return runs;
}

// ---- conversion -----------------------------------------------------------------------------------------------------

function toTexRun(piece, stack) {
  const units = [];
  let p = piece;
  // number + unit -> number + placeholder
  p = p.replace(new RegExp(`(\\d+(?:\\.\\d+)?(?:${EXP})?)(?: |(?=[μµ]))(${UNIT})${NOTCONT}`, "g"), (m, num, u) => {
    if (!/[A-Za-zΩμµ]/.test(u)) return m;
    units.push(unitTex(u));
    return num + `\u0001${units.length - 1}\u0002`;
  });
  // curated standalone units
  p = p.replace(new RegExp(`(?<![A-Za-z0-9_])(?:V/m|N/C|m/s²|m/s|N·m²/C²|N·m²/C|C²/N·m²|kg·m/s|J/C|N·m|J/kg|W/m²)(?![A-Za-z0-9])`, "g"), (u) => {
    units.push(unitTex(u));
    return `\u0001${units.length - 1}\u0002`;
  });
  // ASCII sci notation "5.0x10^5" -> "5.0 × 10^5"
  p = p.replace(/(\d)\s?x\s?(10\^)/g, "$1×$2");
  // an ASCII "x" glued between a number and a quantity ("2.00 A x 3.00 h") is multiplication
  p = p.replace(/(\u0002|\d) x (\d)/g, "$1×$2");
  p = p.replace(/\bOhm\b/g, "Ω");
  p = p.replace(/\^\{([^{}]*)\}/g, "^($1)").replace(/_\{([^{}]*)\}/g, "_($1)").replace(/ᴿ/g, "^R");
  return convertExpr(p, { stack, units });
}

/** Draft spans for one text. `whole` = the field is one expression (may stack). Returns { spans, failures }. */
export function draftRow(text, { whole = false } = {}) {
  if (whole) {
    // a field that is nothing but maths (factors separated by single spaces) converts as one expression
    const t = text.trim();
    if (t === text && isPure(text.replace(/[ᴿᴸᵀᵇⁿ]/g, ""))) {
      try {
        const latex = toTexRun(text, true);
        if (/[=≈∝×·^_√∫∮±°′<>≤≥≠⁰¹²³⁴⁵⁶⁷⁸⁹₀-₉ₓ]|[α-ωΑ-Ω]|\d ?[A-Za-zμµΩ]|\//.test(text)) return { spans: [{ find: text, latex }], failures: [], single: true };
      } catch (e) { /* fall through to the run scanner */ }
    }
  }
  const runs = scan(text);
  const spans = [], failures = [];
  const single = whole && runs.length === 1 && runs[0].start === 0 && runs[0].end === text.length;
  for (const r of runs) {
    const find = text.slice(r.start, r.end);
    try {
      const latex = toTexRun(find, single);
      let occ = 1, from = 0;
      for (;;) { const idx = text.indexOf(find, from); if (idx === r.start || idx < 0) break; occ++; from = idx + 1; }
      spans.push(occ === 1 ? { find, latex } : { find, latex, occurrence: occ });
    } catch (e) {
      failures.push({ find, why: String(e.message) });
    }
  }
  return { spans, failures, single };
}

export { scan as findRuns };
