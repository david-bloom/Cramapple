# Fact-pack excerpt (paraphrase; the CED governs)

### Unit 2 — Exponential and Logarithmic Functions

2.1 Change in Arithmetic and Geometric Sequences; 2.2 Change in Linear and
Exponential Functions; 2.3 Exponential Functions; 2.4 Exponential Function
Manipulation; 2.5 Exponential Function Context and Data Modeling; 2.6
Competing Function Model Validation; 2.7 Composition of Functions; 2.8 Inverse
Functions; 2.9 Logarithmic Expressions; 2.10 Inverses of Exponential
Functions; 2.11 Logarithmic Functions; 2.12 Logarithmic Function Manipulation;
2.13 Exponential and Logarithmic Equations and Inequalities; 2.14 Logarithmic
Function Context and Data Modeling; 2.15 Semi-log Plots.


### Unit 2 — Exponential and Logarithmic Functions (25-40%)

*Zero boxed exclusions.* Two real scope nuances worth encoding even though the CED doesn't flag them as exclusions: (1) topic 2.10's Learning Objective restricts logarithm-as-inverse-of-exponential work to "an initial value of 1" even though the general logarithmic form given elsewhere (2.10.A.1) allows any nonzero a — don't author an inverse-derivation item assuming the general a≠1 case is in scope for that specific topic; (2) topic 2.12 gives the product, power, and change-of-base properties of logarithms plus the natural-log definition, but **does not give an explicit quotient property as a numbered Essential Knowledge statement** — a quotient-of-logs item is still fair game (it's directly derivable from the product property) but shouldn't be cited as "per EK 2.12.A.x" the way the other three properties can be.

*Key formulas confirmed:* general exponential f(x)=ab^x (a≠0, b>0, b≠1); general logarithmic f(x)=a·log_b(x); product property log_b(xy)=log_b(x)+log_b(y); power property log_b(x^n)=n·log_b(x); change-of-base log_b(x)=log_a(x)/log_a(b); natural log ln(x)=log_e(x); semi-log linearization (topic 2.15) — for y=ab^x, the semi-log-plotted linear form is y=(log_n b)x+log_n a, slope log_n b, intercept log_n a, with the constraint n>1 (not just n≠1) stated in the EK itself.

*Real, lowest-scoring points on the entire 2025 exam, both in Q4 (Symbolic Manipulations):* solving e^(2x)−e^x−12=0 as a hidden quadratic in eˣ scored a mean of 0.14/1 (setup) and 0.10/1 (final answer) — the two lowest point-means on the whole exam. Documented misconception, verbatim: **"No recognition of equation as quadratic in eˣ and not eliminating the possibility that eˣ=−3."** Students who don't substitute u=eˣ, factor, and explicitly reject the negative root (since eˣ>0 always) fail this near-universally. Any hidden-quadratic-in-exponential FRQ criterion should require the explicit rejection step, and any MCQ distractor for this pattern should include a wrong answer derived from not rejecting eˣ=−3 (e.g., an answer that includes ln(−3) or "no solution" when a valid solution does exist).

*Real, second-lowest scoring point, trig-identity simplification inside a Unit 2/3 boundary item:* simplifying 6/[tan(x)(csc²x−1)] to 6tan(x) using the Pythagorean identity csc²x−1=cot²x scored a mean of 0.28/1. CR report: "Lack of facility with trigonometric identities and algebraic manipulation." Note also confirmed: **domain restrictions on the simplification (tan x≠0, cot x≠0) are explicitly "not required... and not scored regardless if correct or incorrect"** — do not write a criterion that requires or penalizes domain-restriction notation on a pure symbolic-simplification task unless the prompt explicitly asks for domain.


### Front-matter rules that apply to every FRQ, regardless of unit (quote verbatim from the Scoring Guidelines and exam directions)

- **Calculator sections:** "Avoid rounding intermediate computations on the way to the final result. Unless otherwise specified, any decimal approximations reported in your work should be accurate to three places after the decimal point." Also: "Answers without supporting work may not receive credit in cases where supporting work is requested." And: "Unless otherwise specified, the domain of a function f is assumed to be the set of all real numbers x for which f(x) is a real number."
- **No-calculator sections:** "Solutions to equations must be real numbers. Determine the exact value of any expression that can be obtained without a calculator" (example given: log₂8, cos(π/2), sin⁻¹(1)). Also: "Unless otherwise specified, combine terms using algebraic methods and rules for exponents and logarithms, where applicable" (example given: 2x+3x, 5²·5³, x⁵/x², ln3+ln5 should be rewritten in equivalent forms — an unsimplified but otherwise correct answer can lose credit here, unlike Calculus's explicit "answers need not be simplified" rule — **this is a real cross-subject difference, do not port the Calculus simplification leniency into Precalculus rubrics**).
- **The decimal "forgive-once" rule, confirmed verbatim from the Scoring Guidelines' General Scoring Notes:** "A decimal presentation error occurs when a response is complete and correct, but the answer is reported to fewer digits than required. The first decimal presentation error in [the question] does not earn the point. For each additional part... that requires a decimal approximation and contains a decimal presentation error, the response is eligible to earn the point." In plain terms: **the first rounding/presentation slip in a question is forgiven; the second and later ones are not.** A rubric that docks every instance of under-rounding, or that never docks any, both diverge from real AP scoring — author against the forgive-once pattern specifically.
- **A 2026-dated tightening worth flagging:** 2025's exam directions read "You may use the available paper for scratch work, but you must write your answers in the free-response booklet." 2026 tightened this to "You may use the available paper for scratch work and planning, but only work written in the free-response booklet will be scored. Any work done on scratch paper will not be scored." Use the 2026 wording for anything framed as "current" exam policy.

