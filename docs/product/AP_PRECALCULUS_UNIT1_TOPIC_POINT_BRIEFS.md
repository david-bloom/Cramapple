# AP Precalculus Unit 1 Topic Point Briefs

Status: Draft content system seed for new-user home and unit selector planning.

Purpose: preserve Cramapple-original topic point brief content for AP
Precalculus Unit 1 (Polynomial and Rational Functions). These briefs help a
new student understand how each topic turns into point-attainment behavior
without replacing a full lesson.

Source basis: AP Precalculus Course and Exam Description, Effective Fall 2026,
plus the local taxonomy and fact pack in
`docs/product/AP_PRECALCULUS_CED_FACT_PACK.md`.

## Type

```ts
type Importance = "not-important" | "somewhat-important" | "very-important";

type TopicPointBrief = {
  unitId: string;
  topicId: string;
  title: string;
  classImportance: Importance;
  examImportance: Importance;
  whatItIs: string;
  whyItMatters: string;
  howPointsAreEarned: string;
  answerMove: string;
  commonPointLoss: string;
  learnMorePath: string;
  practiceParams: {
    subject: string;
    unit: string;
    topic: string;
  };
};
```

## Unit 1 Seed Content

Canonical database seed:
`supabase/migrations/20260821001000_ap_precalculus_and_calculus_bc_unit1_topic_point_briefs.sql`

```ts
const apPrecalculusUnit1TopicPointBriefs: TopicPointBrief[] = [
  {
    unitId: "unit-1",
    topicId: "1.1",
    title: "Change in Tandem",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "This topic studies how two quantities change together and how one quantity can be treated as a function of another.",
    whyItMatters:
      "It is the entry point for modeling: AP Precalculus questions often ask students to connect a table, graph, equation, or description to how quantities vary together.",
    howPointsAreEarned:
      "You earn points by identifying the input and output quantities, describing how they change together, and using correct function language for the relationship.",
    answerMove:
      "Name the two quantities, decide which one depends on the other, then describe the change pattern using values, units, or graph behavior.",
    commonPointLoss:
      "Describing each variable separately without explaining how the change in one quantity connects to the change in the other.",
    learnMorePath: "/learn/ap-precalculus/unit-1/change-in-tandem",
    practiceParams: { subject: "ap_precalculus", unit: "1", topic: "1.1" },
  },
  {
    unitId: "unit-1",
    topicId: "1.2",
    title: "Rates of Change",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "Rate of change compares how much the output changes for a change in input over an interval.",
    whyItMatters:
      "It is the foundation for slope, linear comparison, average rate, model interpretation, and later calculus readiness.",
    howPointsAreEarned:
      "You earn points by computing change in output divided by change in input, preserving units, and interpreting the result in context.",
    answerMove:
      "Use the structure: change in output over change in input, then say what one input unit means for the output.",
    commonPointLoss:
      "Reporting a slope number without units or interpreting it as an output value instead of a rate.",
    learnMorePath: "/learn/ap-precalculus/unit-1/rates-of-change",
    practiceParams: { subject: "ap_precalculus", unit: "1", topic: "1.2" },
  },
  {
    unitId: "unit-1",
    topicId: "1.3",
    title: "Rates of Change and Behavior of Graphs",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "A graph shows where a function increases, decreases, changes quickly, changes slowly, or has different average rates over different intervals.",
    whyItMatters:
      "AP Precalculus often asks students to connect visual graph behavior to numerical or verbal statements about change.",
    howPointsAreEarned:
      "You earn points by using graph features to justify rate claims, including sign, steepness, and interval-specific behavior.",
    answerMove:
      "Pick the interval first, then describe slope sign and steepness from the graph before drawing a conclusion.",
    commonPointLoss:
      "Making a global statement about the whole graph when the question asks about a specific interval.",
    learnMorePath:
      "/learn/ap-precalculus/unit-1/rates-of-change-and-graphs",
    practiceParams: { subject: "ap_precalculus", unit: "1", topic: "1.3" },
  },
  {
    unitId: "unit-1",
    topicId: "1.4",
    title: "Polynomial Functions and Rates of Change",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "Polynomial functions have smooth graph behavior whose rates of change depend on degree, leading coefficient, and local shape.",
    whyItMatters:
      "This topic connects algebraic form to graph behavior and prepares students to analyze turning behavior and end behavior.",
    howPointsAreEarned:
      "You earn points by connecting a polynomial's expression or graph to intervals of increase and decrease, average rates, and qualitative change.",
    answerMove:
      "Use the polynomial's graph or values to compare how fast the output changes on named intervals.",
    commonPointLoss:
      "Treating all polynomial change as constant like a linear function.",
    learnMorePath:
      "/learn/ap-precalculus/unit-1/polynomial-functions-and-rates-of-change",
    practiceParams: { subject: "ap_precalculus", unit: "1", topic: "1.4" },
  },
  {
    unitId: "unit-1",
    topicId: "1.5",
    title: "Polynomial Functions and Complex Zeros",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "Polynomial zeros can be real or complex, and nonreal complex zeros occur in conjugate pairs for polynomials with real coefficients.",
    whyItMatters:
      "Zeros connect factored form, graph x-intercepts, equation solving, and polynomial structure.",
    howPointsAreEarned:
      "You earn points by using zeros to write factors, count degree, identify x-intercepts, and account for complex conjugate pairs.",
    answerMove:
      "List known zeros, convert each zero to a factor, and remember that a+bi brings a-bi when coefficients are real.",
    commonPointLoss:
      "Counting only visible x-intercepts and forgetting nonreal complex zeros when reasoning about degree or factors.",
    learnMorePath:
      "/learn/ap-precalculus/unit-1/polynomial-functions-and-complex-zeros",
    practiceParams: { subject: "ap_precalculus", unit: "1", topic: "1.5" },
  },
  {
    unitId: "unit-1",
    topicId: "1.6",
    title: "Polynomial Functions and End Behavior",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "End behavior describes what a polynomial does as x becomes very large positive or very large negative.",
    whyItMatters:
      "It helps students match equations to graphs and predict long-run behavior without plotting every point.",
    howPointsAreEarned:
      "You earn points by using degree parity and leading coefficient sign to describe left-end and right-end behavior.",
    answerMove:
      "Find the leading term first; its degree and coefficient control both ends of the graph.",
    commonPointLoss:
      "Using a lower-degree term or a local turning point to decide end behavior.",
    learnMorePath: "/learn/ap-precalculus/unit-1/polynomial-end-behavior",
    practiceParams: { subject: "ap_precalculus", unit: "1", topic: "1.6" },
  },
  {
    unitId: "unit-1",
    topicId: "1.7",
    title: "Rational Functions and End Behavior",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "Rational functions are ratios of polynomials, and their end behavior depends on how numerator and denominator compare for large input values.",
    whyItMatters:
      "This is central for asymptotes, long-run modeling, and distinguishing polynomial behavior from rational behavior.",
    howPointsAreEarned:
      "You earn points by comparing degrees or leading terms to describe horizontal or slant end behavior when appropriate.",
    answerMove:
      "Compare the numerator degree to the denominator degree, then state the long-run behavior that follows.",
    commonPointLoss:
      "Finding zeros first when the question is asking about what happens far left or far right.",
    learnMorePath:
      "/learn/ap-precalculus/unit-1/rational-functions-end-behavior",
    practiceParams: { subject: "ap_precalculus", unit: "1", topic: "1.7" },
  },
  {
    unitId: "unit-1",
    topicId: "1.8",
    title: "Rational Functions and Zeros",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "Zeros of a rational function occur where the numerator is zero and the denominator is not zero.",
    whyItMatters:
      "This topic prevents students from confusing x-intercepts with holes or undefined values.",
    howPointsAreEarned:
      "You earn points by solving the numerator for zeros, checking the denominator, and identifying valid intercepts separately from excluded inputs.",
    answerMove:
      "Factor numerator and denominator, cancel only common factors for holes, then use remaining numerator zeros for x-intercepts.",
    commonPointLoss:
      "Calling a canceled factor an x-intercept instead of recognizing it as a hole.",
    learnMorePath: "/learn/ap-precalculus/unit-1/rational-functions-and-zeros",
    practiceParams: { subject: "ap_precalculus", unit: "1", topic: "1.8" },
  },
  {
    unitId: "unit-1",
    topicId: "1.9",
    title: "Rational Functions and Vertical Asymptotes",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "Vertical asymptotes occur at input values where a rational function becomes unbounded because the denominator approaches zero without a removable cancellation.",
    whyItMatters:
      "They are a key way rational functions differ from polynomials and a frequent graph-equation matching feature.",
    howPointsAreEarned:
      "You earn points by finding non-canceled denominator zeros and connecting them to unbounded graph behavior.",
    answerMove:
      "Factor first, cancel common factors for holes, then set the remaining denominator equal to zero for vertical asymptotes.",
    commonPointLoss:
      "Listing every denominator zero as a vertical asymptote without checking for removable holes.",
    learnMorePath:
      "/learn/ap-precalculus/unit-1/rational-functions-vertical-asymptotes",
    practiceParams: { subject: "ap_precalculus", unit: "1", topic: "1.9" },
  },
  {
    unitId: "unit-1",
    topicId: "1.10",
    title: "Rational Functions and Holes",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "A hole is a removable discontinuity created when the numerator and denominator share a factor that cancels.",
    whyItMatters:
      "This topic builds precise graph reasoning from algebraic structure and keeps students from overcalling asymptotes.",
    howPointsAreEarned:
      "You earn points by identifying the canceled factor, finding the excluded x-value, and using the simplified function to find the hole's y-value when asked.",
    answerMove:
      "Cancel the common factor, keep the excluded x-value, then substitute that x-value into the simplified expression for the hole location.",
    commonPointLoss:
      "Canceling a factor and then forgetting that the original function is still undefined at that input.",
    learnMorePath: "/learn/ap-precalculus/unit-1/rational-functions-holes",
    practiceParams: { subject: "ap_precalculus", unit: "1", topic: "1.10" },
  },
  {
    unitId: "unit-1",
    topicId: "1.11",
    title: "Equivalent Representations",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "Equivalent representations show the same function or relationship through equations, graphs, tables, verbal descriptions, and rewritten algebraic forms.",
    whyItMatters:
      "AP Precalculus rewards students who can move between forms and use the form that exposes the needed feature.",
    howPointsAreEarned:
      "You earn points by matching features across representations, such as zeros, intercepts, rates, asymptotes, holes, and end behavior.",
    answerMove:
      "Before solving, choose the representation that makes the requested feature easiest to see.",
    commonPointLoss:
      "Treating two algebraically equivalent forms as different functions without checking whether domain restrictions changed.",
    learnMorePath: "/learn/ap-precalculus/unit-1/equivalent-representations",
    practiceParams: { subject: "ap_precalculus", unit: "1", topic: "1.11" },
  },
  {
    unitId: "unit-1",
    topicId: "1.12",
    title: "Transformations of Functions",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "Transformations move, stretch, compress, or reflect a parent function's graph using changes inside or outside the function rule.",
    whyItMatters:
      "They let students predict graph behavior efficiently and compare model families across units.",
    howPointsAreEarned:
      "You earn points by identifying horizontal and vertical shifts, stretches, compressions, and reflections from notation or graphs.",
    answerMove:
      "Separate inside changes from outside changes, then state the graph effect in order.",
    commonPointLoss:
      "Reversing horizontal transformation direction or mixing up input changes with output changes.",
    learnMorePath: "/learn/ap-precalculus/unit-1/function-transformations",
    practiceParams: { subject: "ap_precalculus", unit: "1", topic: "1.12" },
  },
  {
    unitId: "unit-1",
    topicId: "1.13",
    title: "Function Model Selection and Assumption Articulation",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "Model selection means choosing a function type that fits a pattern, context, or data set and stating the assumptions behind that choice.",
    whyItMatters:
      "This is a distinctive AP Precalculus point skill: students must justify why a model is reasonable, not only produce an equation.",
    howPointsAreEarned:
      "You earn points by citing evidence from data or context and explaining the assumptions and limits of the chosen model.",
    answerMove:
      "Name the model type, point to the pattern that supports it, and state one assumption the model depends on.",
    commonPointLoss:
      "Choosing a model because it is familiar without using the data or context as evidence.",
    learnMorePath:
      "/learn/ap-precalculus/unit-1/model-selection-and-assumptions",
    practiceParams: { subject: "ap_precalculus", unit: "1", topic: "1.13" },
  },
  {
    unitId: "unit-1",
    topicId: "1.14",
    title: "Function Model Construction and Application",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "Model construction turns information from a context, table, graph, or constraints into a usable function.",
    whyItMatters:
      "It is where algebraic skill becomes decision-making: students build, apply, and interpret a model for a real situation.",
    howPointsAreEarned:
      "You earn points by defining variables, constructing a function from given information, applying it to the requested input or output, and interpreting the result with units.",
    answerMove:
      "Define variables first, build the function from the constraints, then answer the contextual question rather than stopping at the equation.",
    commonPointLoss:
      "Giving an equation without checking whether it answers the question or makes sense in the stated domain.",
    learnMorePath:
      "/learn/ap-precalculus/unit-1/model-construction-and-application",
    practiceParams: { subject: "ap_precalculus", unit: "1", topic: "1.14" },
  },
];
```

