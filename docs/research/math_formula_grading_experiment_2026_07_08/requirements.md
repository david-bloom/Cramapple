# Mathematical Formula Grading — Cross-Subject Requirements Map

**Status:** Session scoping document, 2026-07-08
**Owner:** Product Owner with Learning Quality Owner
**Related:** DECISION-0034 (deterministic-check layer is a required per-subject
artifact), `../grading_cross_subject_takeaways.md` Lesson 3,
`../deterministic_check_experiment_2026_07_08/` (numeric sibling),
`../../architecture/CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §7/§7.1,
`../../tasks/TASK-0015-AP-PHYSICS-LAUNCH.md` (Phase 3: verification profile),
`../AP_PHYSICS_1_VERIFICATION_PROFILE.json`

## The gap this session addresses

The proven deterministic layer (`deterministic_check_experiment_2026_07_08/checker.py`,
100% specificity on 69 canonicals) checks **numeric presence only**. The
math-heavy subject family answers in **formulas**: derivatives, antiderivatives,
symbolic physics derivations, econ formula selection, statistics formula setup.
A wrong formula with no final number — or a *correct* formula in a different
algebraic form — is invisible to a numeric checker. The AP Physics 1
verification profile already names "symbolic manipulation consistency" as a
required check with no implementation behind it.

The capability needed is **algebraic-equivalence checking**: given a keyed
canonical expression (authored into the question package's
`verification_profile`), decide whether the student's expression is equivalent
— accepting *any* correct form (AP rubrics accept unsimplified answers) and
flagging any non-equivalent one, without needing to anticipate the specific
error.

## Per-subject requirements

| Subject | Formula-answer shapes | Deterministic checks needed | Stays with LLM grader |
| --- | --- | --- | --- |
| **AP Calculus AB** | derivatives, antiderivatives (+C), tangent lines, limit values, definite-integral values | expression equivalence; antiderivative check (derivative-of-response ≡ integrand **and** +C present); numeric | justification points (IVT/MVT/EVT language), method points, interpretation-in-context |
| **AP Calculus BC** | AB shapes + series coefficients/intervals, parametric/polar derivatives, Euler's method values | same as AB + numeric | convergence-test reasoning, error-bound arguments |
| **AP Precalculus** | function transformations, inverses, trig identities, exponential/log forms | expression equivalence incl. identity rewrites (needs sampling, not just `simplify`); **domain-aware sampling** (log/root answers equivalent only on shared domain) | modeling interpretation, verbal descriptions of behavior |
| **AP Physics 1 / 2** | symbolic answers in given variables (√(2gh), rs/(r+s)), numeric answers **with units** | expression equivalence over declared variable set; numeric; **unit check (not yet built)** | conceptual/justification points, diagram reasoning (TASK-0011 territory) |
| **AP Physics C (Mech, E&M)** | derivation *endpoints* (drag ODE solutions, ring-axis fields, RC transients) | expression equivalence — catches sign-in-exponent and wrong-power errors that read plausibly | derivation *path* credit (setup, limits of integration, applying Gauss's law correctly) |
| **AP Macro/Micro** | mostly numeric (multipliers, elasticities, rates) + simple formula selection | numeric (existing class); light expression equivalence (real rate = n − i) | graph drawing, chain-of-reasoning points (the bulk of econ FRQs) |
| **AP Statistics** | formula *setup* (s/√n vs s/n), computed values | expression equivalence at the formula level catches the known SE-error class **before** arithmetic; numeric (already keyed for 3 gold items) | conditions/assumptions checks, conclusions in context |

## Shared platform capabilities (build once, declare per profile)

1. **Canonical-expression keys** in `verification_profile` — per item: expression
   string, variable set, kind (`expression` / `antiderivative` / `numeric`),
   optional sampling domain and tolerance. Authored at question-authoring time,
   independently validated (same rule as numeric keys).
2. **Equivalence engine** — CAS `simplify(a−b)==0` plus seeded multi-point
   numeric sampling fallback (identities and radical forms defeat `simplify`
   alone; multi-point agreement defeats single-point coincidences such as a
   wrong tangent line agreeing at the point of tangency).
3. **Student-notation normalization** — caret powers, implicit multiplication,
   `e^x`, `sin^2 x`. This is the highest-risk layer (see hazards in
   `report.md`): the typed flat fraction `3t^2/2t` parses to the wrong tree and
   would false-flag correct work. Production needs either structured math input
   (equation editor / LaTeX from the frontend) or an ambiguity detector that
   routes ambiguous strings to the LLM grader instead of flagging.
4. **Unit handling** (Physics, some Chem) — not built; `pint` or a dimension
   table per item. Required before a Physics numeric criterion can be owned by
   the deterministic layer, since AP awards/withholds for units.

## Explicitly out of scope for the deterministic layer

Inequality/interval answers, "both roots shown, wrong one chosen" (known
boundary from the numeric experiment), vector direction conventions, diagram
and graph responses (TASK-0011), and all reasoning/justification credit — these
stay with the LLM grader per the single-fast-grader default (Takeaways
Lesson 2).

## Notation intake position (product dependency)

The false-flag risk concentrates entirely in free-text math typing. Options,
in increasing build cost: (a) treat unparseable/ambiguous input as ABSTAIN →
LLM grader (zero false-flag by construction, loses some coverage); (b) frontend
structured math input for formula-keyed items; (c) LLM-assisted
notation-to-expression normalization as a pre-step (adds a model call, keeps
the equivalence decision deterministic). Recommendation: (a) immediately —
it preserves the 100%-specificity property — with (b) as the Lovable frontend
ask when a math-heavy subject enters Phase 5.
