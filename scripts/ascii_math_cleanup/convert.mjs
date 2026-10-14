// TASK-0075 / DECISION-0123: convert ASCII-notation maths to LaTeX, deterministically (no model).
//
// The text is parsed into a small expression tree and the LaTeX is printed from the tree, so a term cannot be
// silently dropped. Prose is never rewritten: rows that mix words and maths are handled by stating exact
// find -> latex spans in a separate (private) file, and `buildFromSpans` builds the edited text from those spans.
//
// Stacking follows DECISION-0119 / DECISION-0121: in a standalone expression a quotient is stacked when its
// numerator or denominator is compound; a quotient of single symbols, a number over a symbol, a Leibniz
// derivative (dy/dx), or any fraction inside an exponent, subscript or function argument keeps the slash.
//
// This file holds no exam text. Data files (distinct texts, manual spans, drafts) stay private.

const FUNCS = new Set(["sin", "cos", "tan", "sec", "csc", "cot", "ln", "log", "exp"]);
const GREEK = {
  alpha: "\\alpha", beta: "\\beta", gamma: "\\gamma", delta: "\\delta", epsilon: "\\epsilon", theta: "\\theta",
  lambda: "\\lambda", mu: "\\mu", nu: "\\nu", pi: "\\pi", rho: "\\rho", sigma: "\\sigma", tau: "\\tau",
  phi: "\\phi", omega: "\\omega", kappa: "\\kappa",
};
const GREEK_CHAR = { "π": "pi", "λ": "lambda", "ν": "nu", "ε": "epsilon", "μ": "mu", "ω": "omega", "ρ": "rho", "κ": "kappa", "σ": "sigma", "θ": "theta" };
const SUB_DIGITS = { "₀": "0", "₁": "1", "₂": "2", "₃": "3" };
const SUP_DIGITS = { "²": "2", "³": "3" };

export class Unhandled extends Error {}

// ---- normalisation and tokenising -----------------------------------------------------------------------------

function preNormalise(s) {
  let t = s.replace(/\u2212/g, "-");
  t = t.replace(/⁻¹/g, "^(-1)");
  t = t.replace(/[²³]/g, (c) => "^" + SUP_DIGITS[c]);
  t = t.replace(/[₀₁₂₃]/g, (c) => "_" + SUB_DIGITS[c]);
  return t;
}

function tokenise(src) {
  const toks = [];
  let i = 0;
  const s = src;
  while (i < s.length) {
    const c = s[i];
    if (/\s/.test(c)) { i++; toks.push({ t: "ws" }); continue; }
    // Leibniz derivatives kept whole: dy/dx, dV/dx, d^2U/dx^2
    const lm = /^d(\^2)?([A-Za-z])\/d([a-z])(\^2)?/.exec(s.slice(i));
    if (lm && (i === 0 || !/[A-Za-z]/.test(s[i - 1]))) {
      const sq = lm[1] ? "^{2}" : "";
      toks.push({ t: "leib", tex: lm[1] ? `d^{2}${lm[2]}/d${lm[3]}^{2}` : `d${lm[2]}/d${lm[3]}` });
      i += lm[0].length; void sq; continue;
    }
    if (/[0-9]/.test(c)) {
      const m = /^\d+(\.\d+)?/.exec(s.slice(i));
      toks.push({ t: "num", v: m[0] }); i += m[0].length; continue;
    }
    if (/[A-Za-z]/.test(c)) {
      const m = /^[A-Za-z]+/.exec(s.slice(i))[0];
      // split into known words, else single letters
      let j = 0;
      while (j < m.length) {
        const rest = m.slice(j);
        const word = [...Object.keys(GREEK), ...FUNCS, "sqrt"].sort((a, b) => b.length - a.length).find((w) => rest.startsWith(w));
        if (word && (j > 0 || m.length === word.length || true)) {
          if (word === "sqrt") toks.push({ t: "sqrt" });
          else if (FUNCS.has(word)) toks.push({ t: "func", v: word });
          else toks.push({ t: "greek", v: word });
          j += word.length;
        } else {
          toks.push({ t: "id", v: rest[0] }); j += 1;
        }
      }
      i += m.length; continue;
    }
    if (GREEK_CHAR[c]) { toks.push({ t: "greek", v: GREEK_CHAR[c] }); i++; continue; }
    if (c === "√") { toks.push({ t: "sqrt" }); i++; continue; }
    if (c === "·") { toks.push({ t: "dot" }); i++; continue; }
    if (c === "*") { toks.push({ t: "star" }); i++; continue; }
    if (c === "≈") { toks.push({ t: "rel", tex: "\\approx" }); i++; continue; }
    if (c === "~") { toks.push({ t: "rel", tex: "\\approx" }); i++; continue; }
    if (c === "∝") { toks.push({ t: "rel", tex: "\\propto" }); i++; continue; }
    if (c === "=") { toks.push({ t: "rel", tex: "=" }); i++; continue; }
    if ("+-/^_(),".includes(c)) { toks.push({ t: c }); i++; continue; }
    throw new Unhandled(`character ${JSON.stringify(c)}`);
  }
  return toks;
}

// ---- parser ---------------------------------------------------------------------------------------------------

function parse(src) {
  const toks = tokenise(src);
  let p = 0;
  const peek = () => toks[p];
  const peekNs = () => { let q = p; while (toks[q] && toks[q].t === "ws") q++; return toks[q]; };
  const skipWs = () => { while (toks[p] && toks[p].t === "ws") p++; };
  const next = () => toks[p++];

  function startsFactor(tk) {
    return tk && ["num", "id", "greek", "func", "sqrt", "(", "leib"].includes(tk.t);
  }

  function parseRel() {
    const parts = [parseExpr()];
    const rels = [];
    skipWs();
    while (peek() && peek().t === "rel") {
      rels.push(next().tex); skipWs();
      parts.push(parseExpr()); skipWs();
    }
    if (p < toks.length) throw new Unhandled("trailing tokens");
    return { k: "rel", parts, rels };
  }

  function parseExpr() {
    skipWs();
    let sign = null;
    if (peek() && (peek().t === "+" || peek().t === "-")) { sign = next().t; skipWs(); }
    let node = parseTerm();
    if (sign) node = { k: "sign", s: sign, e: node };
    skipWs();
    while (peek() && (peek().t === "+" || peek().t === "-")) {
      const op = next().t; skipWs();
      const rhs = parseTerm();
      node = { k: "bin", op, l: node, r: rhs };
      skipWs();
    }
    return node;
  }

  function parseTerm() {
    let node = parseFactor();
    for (;;) {
      const hadWs = peek() && peek().t === "ws";
      const tk = peekNs();
      if (!tk) break;
      if (tk.t === "star" || tk.t === "dot") {
        skipWs();
        const spaced = hadWs;
        const kind = tk.t;
        next(); const afterWs = peek() && peek().t === "ws"; skipWs();
        const rhs = parseFactor();
        node = { k: "mul", l: node, r: rhs, explicit: kind === "dot" ? "dot" : (spaced || afterWs ? "dot" : "star") };
      } else if (tk.t === "/") {
        skipWs(); next(); skipWs();
        const rhs = parseFactor();
        node = { k: "div", l: node, r: rhs };
      } else if (startsFactor(tk)) {
        skipWs();
        const rhs = parseFactor();
        node = { k: "mul", l: node, r: rhs, explicit: null };
      } else break;
    }
    return node;
  }

  function parseFactor() {
    skipWs();
    let base = parseAtom();
    if (peek() && peek().t === "^") {
      next(); skipWs();
      base = { k: "pow", b: base, e: parseExponent() };
    }
    return base;
  }

  function parseExponent() {
    if (peek() && peek().t === "(") {
      next(); const e = parseExpr(); skipWs();
      if (!peek() || peek().t !== ")") throw new Unhandled("exponent paren");
      next(); return { k: "group", e };
    }
    let sign = null;
    if (peek() && peek().t === "-") { next(); sign = "-"; }
    const tk = next();
    if (!tk || !["num", "id", "greek"].includes(tk.t)) throw new Unhandled("exponent");
    const a = atomFrom(tk);
    return sign ? { k: "sign", s: "-", e: a } : a;
  }

  function atomFrom(tk) {
    if (tk.t === "num") return { k: "num", v: tk.v };
    if (tk.t === "greek") return maybeSub({ k: "greek", v: tk.v });
    if (tk.t === "id") return maybeSub({ k: "id", v: tk.v });
    throw new Unhandled("atom");
  }

  function maybeSub(node) {
    if (peek() && peek().t === "_") {
      next();
      const tk = peek();
      let sub;
      if (tk && tk.t === "num") { next(); sub = tk.v; }
      else if (tk && (tk.t === "id" || tk.t === "greek" || tk.t === "func")) {
        // a run of letters forms the subscript word (E_s, g_E, Q_enclosed, I_enc)
        sub = "";
        while (peek() && (peek().t === "id" || peek().t === "greek" || peek().t === "func")) {
          const x = next(); sub += x.t === "id" ? x.v : x.v;
        }
      } else throw new Unhandled("subscript");
      return { k: "sub", b: node, s: sub };
    }
    return node;
  }

  function parseAtom() {
    skipWs();
    const tk = next();
    if (!tk) throw new Unhandled("unexpected end");
    if (tk.t === "num") return { k: "num", v: tk.v };
    if (tk.t === "leib") return { k: "leib", tex: tk.tex };
    if (tk.t === "id" || tk.t === "greek") return atomFrom(tk);
    if (tk.t === "(") {
      const e = parseExpr(); skipWs();
      if (!peek() || peek().t !== ")") throw new Unhandled("missing )");
      next(); return { k: "group", e };
    }
    if (tk.t === "sqrt") {
      skipWs();
      if (peek() && peek().t === "(") {
        next(); const e = parseExpr(); skipWs();
        if (!peek() || peek().t !== ")") throw new Unhandled("sqrt paren");
        next(); return { k: "sqrt", e };
      }
      return { k: "sqrt", e: parseFactor() };
    }
    if (tk.t === "func") {
      if (peek() && peek().t === "(") {
        next(); const e = parseExpr(); skipWs();
        if (!peek() || peek().t !== ")") throw new Unhandled("func paren");
        next(); return { k: "call", f: tk.v, e, paren: true };
      }
      skipWs();
      const arg = parseFactor();
      return { k: "call", f: tk.v, e: arg, paren: false };
    }
    throw new Unhandled(`token ${tk.t}`);
  }

  return parseRel();
}

// ---- printer --------------------------------------------------------------------------------------------------

function isSymbol(n) { return n.k === "id" || n.k === "greek" || n.k === "sub"; }
function isSimple(n) {
  if (n.k === "num" || isSymbol(n) || n.k === "leib") return true;
  if (n.k === "sign") return isSimple(n.e);
  if (n.k === "pow") return (n.b.k === "num" || isSymbol(n.b)) ;
  return false;
}
function stripGroup(n) { while (n.k === "group") n = n.e; return n; }

function joinTex(a, b) {
  if (!a) return b;
  if (!b) return a;
  if (/\\[A-Za-z]+$/.test(a) && /^[A-Za-z]/.test(b)) return a + " " + b;
  return a + b;
}

function printNode(n, ctx) {
  // ctx.stack: stack compound quotients; ctx.inner: inside an exponent/subscript/argument (slash only)
  switch (n.k) {
    case "num": return n.v;
    case "id": return n.v;
    case "greek": return GREEK[n.v];
    case "leib": return n.tex;
    case "sub": {
      const base = n.b.k === "greek" ? GREEK[n.b.v] : n.b.v;
      const word = /^[A-Za-z]{2,}$/.test(n.s) && !GREEK[n.s] ? `\\mathrm{${n.s}}` : (GREEK[n.s] ?? n.s);
      return `${base}_{${word}}`;
    }
    case "sign": return (n.s === "-" ? "-" : "+") + printNode(n.e, ctx);
    case "bin": return printNode(n.l, ctx) + n.op + printNode(n.r, ctx);
    case "group": {
      const inner = stripGroup(n);
      if (ctx.stack && inner.k === "div") {
        const t = printDiv(inner, ctx);
        if (t.startsWith("\\frac")) return t; // a stacked quotient needs no parentheses
      }
      const t = printNode(n.e, ctx);
      return t.includes("\\frac") ? `\\left(${t}\\right)` : `(${t})`;
    }
    case "sqrt": return `\\sqrt{${printNode(n.e, { stack: false })}}`;
    case "call": {
      const arg = printNode(n.e, { stack: false });
      return n.paren ? `\\${n.f}(${arg})` : `\\${n.f} ${arg}`;
    }
    case "pow": {
      const base = printNode(n.b, ctx);
      const e = n.e.k === "group" ? printNode(n.e.e, { stack: false }) : printNode(n.e, { stack: false });
      return `${base}^{${e}}`;
    }
    case "mul": {
      const l = printNode(n.l, ctx), r = printNode(n.r, ctx);
      if (n.explicit === "dot") return `${l}\\cdot ${r}`.replace(/\\cdot\s+\\/g, "\\cdot\\");
      if (n.explicit === "star") {
        // an unspaced * before a letter or "(" is ordinary juxtaposition; before a digit keep a dot
        if (/^[0-9]/.test(r)) return `${l}\\cdot ${r}`;
        return joinTex(l, r);
      }
      return joinTex(l, r);
    }
    case "div": return printDiv(n, ctx);
    default: throw new Unhandled(`print ${n.k}`);
  }
}

function printDiv(n, ctx) {
  const L = stripGroup(n.l), R = stripGroup(n.r);
  const simple = isSimple(L) && isSimple(R);
  if (!ctx.stack || simple) {
    // keep the slash; keep source grouping where it matters
    const l = printNode(n.l, ctx), r = printNode(n.r, ctx);
    return `${l}/${r}`;
  }
  return `\\frac{${printNode(L, ctx)}}{${printNode(R, ctx)}}`;
}

// ---- families -------------------------------------------------------------------------------------------------

const UNIT = (u) => {
  const t = u.trim();
  if (/^(kg\*m\/s)$/.test(t)) return "\\mathrm{kg\\cdot m/s}";
  if (/^(N\*m)$/.test(t)) return "\\mathrm{N\\cdot m}";
  if (/^s\^-1$/.test(t)) return "\\mathrm{s^{-1}}";
  if (/^m\/s$/.test(t)) return "\\mathrm{m/s}";
  if (/^[A-Za-z]{1,2}$/.test(t)) return `\\mathrm{${t}}`;
  throw new Unhandled(`unit ${t}`);
};

/** Convert a text that is entirely one math expression. Returns the LaTeX (without delimiters). */
export function convertPure(text, opts = {}) {
  const s = text.trim();
  // scientific notation with an optional unit: 7.50 x 10^-1 M, 5.5x10^-10
  let m = /^(\d+(?:\.\d+)?)\s*x\s*10\^(-?\d+)(?:\s+(\S+))?$/.exec(s);
  if (m) return `${m[1]}\\times10^{${m[2]}}` + (m[3] ? `\\,${UNIT(m[3])}` : "");
  // number then product unit: 3.0 kg*m/s, 2.5 N*m
  m = /^(\d+(?:\.\d+)?)\s+((?:kg\*m\/s)|(?:N\*m))$/.exec(s);
  if (m) return `${m[1]}\\,${UNIT(m[2])}`;
  // electron configuration: [Ar]3d^3 4s^2
  m = /^\[Ar\]((?:\d[spdf]\^\d\s*)+)$/.exec(s);
  if (m) {
    const parts = m[1].trim().split(/\s+/).map((o) => /^(\d)([spdf])\^(\d)$/.exec(o)).map((x) => `${x[1]}${x[2]}^{${x[3]}}`);
    return `[\\mathrm{Ar}]\\,${parts.join("\\,")}`;
  }
  // ion: SO4^2-
  m = /^([A-Z][a-z]?)(?:([A-Z][a-z]?)(\d)?)?(\d)?\^(\d)([+-])$/.exec(s);
  if (m && s === "SO4^2-") return "\\mathrm{SO_4^{2-}}";
  // limit prefix: lim(x->a) expression
  m = /^lim\(([a-z])->(-?[0-9a-z/]+)\)\s*(.+)$/.exec(s);
  if (m) {
    const body = convertExpr(m[3], { stack: true });
    return `\\lim_{${m[1]}\\to ${m[2]}}${body}`;
  }
  return convertExpr(s, { stack: opts.stack !== false });
}

export function convertExpr(s, ctx = { stack: true }) {
  const tree = parse(preNormalise(s));
  const parts = tree.parts.map((e) => printNode(e, ctx));
  let out = parts[0];
  for (let i = 0; i < tree.rels.length; i++) out = joinTex(joinTex(out, tree.rels[i]), parts[i + 1]);
  return out;
}

// ---- purity gate and connector rows ---------------------------------------------------------------------------

const KNOWN_WORDS = new Set([...Object.keys(GREEK), ...FUNCS, "sqrt", "lim"]);
const STOP = new Set(["at", "of", "to", "is", "as", "or", "in", "by", "be", "so", "it", "on", "an", "if", "no"]);

/** True when every alphabetic run is a function, a Greek name, a subscript word, or one or two variable letters. */
export function isPure(text) {
  const t = text.replace(/\[0-9a-z]/g, "");
  const re = /(_)?([A-Za-z]+)/g;
  let m;
  while ((m = re.exec(t))) {
    const afterUnderscore = !!m[1], run = m[2];
    if (afterUnderscore) continue; // subscript words (E_enclosed) are allowed
    if (KNOWN_WORDS.has(run)) continue;
    // a run made only of known words and single letters, e.g. "2pi", "pix" is split by the tokenizer
    if (run.length <= 2 && !STOP.has(run)) continue;
    // known word glued to a letter (pi x written "pix") is not accepted: be strict
    return false;
  }
  return true;
}

/** Rows that are pure maths joined by "and", "only" or "at" (pi/6 and 5pi/6, f(x) = 3x^2 at x = 2). */
export function convertConnectorRow(text) {
  const parts = text.split(/(\s+and\s+|\s+at\s+|\s+only$)/);
  if (parts.length < 2) throw new Unhandled("no connector");
  const spans = [];
  for (let i = 0; i < parts.length; i += 2) {
    const seg = parts[i];
    if (!seg.trim()) continue;
    if (!isPure(seg)) throw new Unhandled("segment not pure");
    spans.push({ find: seg, latex: convertPure(seg) });
  }
  return spans;
}

// ---- span-built edits (for rows that mix words and maths) -----------------------------------------------------

/** Build the edited text from `spans: [{find, latex, occurrence?}]`; the text outside the spans never changes. */
export function buildFromSpans(original, spans) {
  const found = spans.map((sp) => {
    let idx = -1, from = 0;
    for (let n = 0; n < (sp.occurrence ?? 1); n++) { idx = original.indexOf(sp.find, from); if (idx === -1) break; from = idx + 1; }
    if (idx === -1) throw new Unhandled(`span not found: ${sp.find}`);
    return { ...sp, idx, end: idx + sp.find.length };
  }).sort((a, b) => a.idx - b.idx);
  for (let i = 1; i < found.length; i++) if (found[i].idx < found[i - 1].end) throw new Unhandled("overlapping spans");
  let out = "", pos = 0;
  for (const sp of found) { out += original.slice(pos, sp.idx) + "\\(" + sp.latex + "\\)"; pos = sp.end; }
  return out + original.slice(pos);
}
