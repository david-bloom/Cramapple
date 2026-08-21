# AP Calculus BC Unit 1 Topic Point Briefs

Status: Draft content system seed for new-user home and unit selector planning.

Purpose: preserve Cramapple-original topic point brief content for AP Calculus
BC Unit 1 (Limits and Continuity). These briefs help a new student understand
how each topic turns into point-attainment behavior without replacing a full
lesson.

Source basis: AP Calculus AB and BC Course and Exam Description, Effective Fall
2020, plus the local taxonomy and fact pack in
`docs/product/AP_CALCULUS_AB_BC_CED_FACT_PACK.md`.

## Unit 1 Seed Content

Canonical database seed:
`supabase/migrations/20260821001000_ap_precalculus_and_calculus_bc_unit1_topic_point_briefs.sql`

```ts
const apCalculusBcUnit1TopicPointBriefs: TopicPointBrief[] = [
  {
    unitId: "unit-1",
    topicId: "1.1",
    title: "Introducing Calculus: Can Change Occur at an Instant?",
    classImportance: "very-important",
    examImportance: "somewhat-important",
    whatItIs:
      "This topic introduces the move from average change over an interval to change at a single instant. A limit describes what average rates approach as the interval around the instant shrinks.",
    whyItMatters:
      "This is the conceptual bridge into derivatives. BC students will keep using this limiting idea later for motion, parametric curves, polar change, and series approximations.",
    howPointsAreEarned:
      "You earn points by recognizing whether a question asks about an interval or an instant and by connecting the instant case to limiting behavior.",
    answerMove:
      "Ask: over an interval or at one point? If it is at one point, describe the instantaneous rate as the value approached by average rates over smaller intervals.",
    commonPointLoss:
      "Trying to compute an instantaneous rate as a direct quotient with zero change in x.",
    learnMorePath: "/learn/ap-calculus-bc/unit-1/instantaneous-change",
    practiceParams: { subject: "ap_calculus_bc", unit: "1", topic: "1.1" },
  },
  {
    unitId: "unit-1",
    topicId: "1.2",
    title: "Defining Limits and Using Limit Notation",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "A limit describes the value a function approaches as x gets close to a chosen input. Limit notation names that approaching behavior precisely.",
    whyItMatters:
      "Limit notation is the language used for continuity, derivatives, infinite behavior, improper integrals, and series convergence claims.",
    howPointsAreEarned:
      "You earn points by reading and writing the approaching input, function, direction when specified, and value approached.",
    answerMove:
      "Read the notation as: as x approaches c, f(x) approaches L. Keep approaches separate from equals.",
    commonPointLoss:
      "Replacing the limit with f(a) automatically, or dropping the direction marker on a one-sided limit.",
    learnMorePath: "/learn/ap-calculus-bc/unit-1/limit-notation",
    practiceParams: { subject: "ap_calculus_bc", unit: "1", topic: "1.2" },
  },
  {
    unitId: "unit-1",
    topicId: "1.3",
    title: "Estimating Limit Values from Graphs",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "A graph can show what y-value a function approaches as x moves toward a chosen input from the left, right, or both sides.",
    whyItMatters:
      "Graph-based limits train students to focus on nearby behavior instead of point values, a skill that returns in continuity, asymptotes, derivative graphs, and polar/parametric contexts.",
    howPointsAreEarned:
      "You earn points by identifying left-hand and right-hand behavior and concluding whether the two-sided limit exists.",
    answerMove:
      "Trace the graph toward the x-value from both sides before looking at the point on the graph.",
    commonPointLoss:
      "Using a filled or open point as the limit value without checking nearby graph behavior.",
    learnMorePath:
      "/learn/ap-calculus-bc/unit-1/estimating-limits-from-graphs",
    practiceParams: { subject: "ap_calculus_bc", unit: "1", topic: "1.3" },
  },
  {
    unitId: "unit-1",
    topicId: "1.4",
    title: "Estimating Limit Values from Tables",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "A table can suggest a limit by showing how function values behave for x-values close to a chosen input.",
    whyItMatters:
      "Tables appear when exact formulas are not given, and BC students also use tabular evidence later for rates, accumulation, and convergence reasoning.",
    howPointsAreEarned:
      "You earn points by using nearby table values from both sides and writing an estimate that matches the evidence.",
    answerMove:
      "Look inward from both sides of the table, then state the trend and estimated limit.",
    commonPointLoss:
      "Choosing one table entry instead of describing the trend across nearby entries.",
    learnMorePath:
      "/learn/ap-calculus-bc/unit-1/estimating-limits-from-tables",
    practiceParams: { subject: "ap_calculus_bc", unit: "1", topic: "1.4" },
  },
  {
    unitId: "unit-1",
    topicId: "1.5",
    title: "Determining Limits Using Algebraic Properties of Limits",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "Limit properties let students combine simpler limits to determine limits of sums, differences, products, quotients, and composite functions.",
    whyItMatters:
      "This is where limits become a reliable calculation tool instead of only a graphical or numerical idea.",
    howPointsAreEarned:
      "You earn points by applying a valid property, preserving expression structure, and showing setup that makes the final value follow.",
    answerMove:
      "Break the expression into parts, determine component limits, then apply the matching property.",
    commonPointLoss:
      "Applying quotient or composition rules mechanically when the needed conditions are not met.",
    learnMorePath:
      "/learn/ap-calculus-bc/unit-1/algebraic-properties-of-limits",
    practiceParams: { subject: "ap_calculus_bc", unit: "1", topic: "1.5" },
  },
  {
    unitId: "unit-1",
    topicId: "1.6",
    title: "Determining Limits Using Algebraic Manipulation",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "Some limit expressions hide their behavior until they are rewritten into an equivalent useful form.",
    whyItMatters:
      "Factoring, rationalizing, simplifying, or using identities can turn a blocked expression into a solvable limit, including forms that later resemble BC improper-integral and series work.",
    howPointsAreEarned:
      "You earn points by choosing a valid rewrite, showing the transformed expression, and evaluating from the simplified form.",
    answerMove:
      "When substitution is blocked, ask what equivalent form removes the obstacle.",
    commonPointLoss:
      "Stopping at 0/0, or canceling terms that are not common factors.",
    learnMorePath:
      "/learn/ap-calculus-bc/unit-1/algebraic-manipulation-for-limits",
    practiceParams: { subject: "ap_calculus_bc", unit: "1", topic: "1.6" },
  },
  {
    unitId: "unit-1",
    topicId: "1.7",
    title: "Selecting Procedures for Determining Limits",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "This topic is about choosing the method that fits the limit problem before carrying out the calculation.",
    whyItMatters:
      "AP questions often reward recognizing the right path: direct property use, graph or table reasoning, factoring, rationalizing, one-sided analysis, or later L'Hospital's Rule.",
    howPointsAreEarned:
      "You earn points by classifying the problem form and selecting a procedure that matches it.",
    answerMove:
      "Before solving, name the cue: direct substitution works, sides must be checked, factoring helps, or another strategy fits.",
    commonPointLoss:
      "Defaulting to a familiar technique without checking whether the problem calls for it.",
    learnMorePath:
      "/learn/ap-calculus-bc/unit-1/selecting-limit-procedures",
    practiceParams: { subject: "ap_calculus_bc", unit: "1", topic: "1.7" },
  },
  {
    unitId: "unit-1",
    topicId: "1.8",
    title: "Determining Limits Using the Squeeze Theorem",
    classImportance: "somewhat-important",
    examImportance: "somewhat-important",
    whatItIs:
      "The squeeze theorem finds a limit by trapping one function between two functions that approach the same value.",
    whyItMatters:
      "This is an early example of theorem-based limit reasoning where conditions force a conclusion, which is useful again in BC convergence and approximation arguments.",
    howPointsAreEarned:
      "You earn points by showing bounds, showing both bounding limits match, and then stating the squeezed conclusion.",
    answerMove:
      "Write the inequality first, find the outside limits, then conclude the middle limit.",
    commonPointLoss:
      "Naming the theorem without showing the bounding relationship and matching limits.",
    learnMorePath: "/learn/ap-calculus-bc/unit-1/squeeze-theorem",
    practiceParams: { subject: "ap_calculus_bc", unit: "1", topic: "1.8" },
  },
  {
    unitId: "unit-1",
    topicId: "1.9",
    title: "Connecting Multiple Representations of Limits",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "The same limit can be represented by notation, words, a graph, a table, or an equation.",
    whyItMatters:
      "AP Calculus regularly changes representation without changing the underlying mathematical claim, and BC adds more representations later through parametric, polar, and series contexts.",
    howPointsAreEarned:
      "You earn points by identifying the same limiting behavior across representations and keeping the claim consistent.",
    answerMove:
      "Convert each representation into: as x approaches c, f(x) approaches L.",
    commonPointLoss:
      "Matching a table or graph to a function value instead of to approach behavior.",
    learnMorePath:
      "/learn/ap-calculus-bc/unit-1/multiple-representations-of-limits",
    practiceParams: { subject: "ap_calculus_bc", unit: "1", topic: "1.9" },
  },
  {
    unitId: "unit-1",
    topicId: "1.10",
    title: "Exploring Types of Discontinuities",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "A discontinuity is a place where continuity fails. The type depends on whether the value, one-sided limits, or bounded behavior fails.",
    whyItMatters:
      "Naming the type helps students explain what failed rather than merely saying the graph is broken.",
    howPointsAreEarned:
      "You earn points by classifying the discontinuity and connecting that classification to limit evidence.",
    answerMove:
      "Check left-hand limit, right-hand limit, and f(c), then classify based on which part fails.",
    commonPointLoss:
      "Calling every gap removable or every discontinuity an asymptote without checking behavior.",
    learnMorePath: "/learn/ap-calculus-bc/unit-1/types-of-discontinuities",
    practiceParams: { subject: "ap_calculus_bc", unit: "1", topic: "1.10" },
  },
  {
    unitId: "unit-1",
    topicId: "1.11",
    title: "Defining Continuity at a Point",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "A function is continuous at a point when f(c) exists, the limit exists, and the limit equals f(c).",
    whyItMatters:
      "Continuity is a condition checklist used before applying theorems in derivatives, integrals, differential equations, and BC series-related function work.",
    howPointsAreEarned:
      "You earn points by checking all three conditions and using them to justify whether the function is continuous.",
    answerMove:
      "Use the checklist: value exists, limit exists, value equals limit, then state the conclusion.",
    commonPointLoss:
      "Saying a function is continuous because the graph looks connected without verifying conditions.",
    learnMorePath: "/learn/ap-calculus-bc/unit-1/continuity-at-a-point",
    practiceParams: { subject: "ap_calculus_bc", unit: "1", topic: "1.11" },
  },
  {
    unitId: "unit-1",
    topicId: "1.12",
    title: "Confirming Continuity over an Interval",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "Continuity over an interval means the function is continuous at every point in that interval.",
    whyItMatters:
      "Many AP conclusions depend on interval-level continuity, including theorem use, domain reasoning, accumulation, and convergence-adjacent function claims.",
    howPointsAreEarned:
      "You earn points by identifying the interval, checking special points, and naming domain restrictions or endpoints that matter.",
    answerMove:
      "Start with the function family and domain, then check special points inside the interval.",
    commonPointLoss:
      "Claiming continuity over an interval while ignoring holes, asymptotes, piecewise boundaries, or excluded domain values.",
    learnMorePath: "/learn/ap-calculus-bc/unit-1/continuity-over-an-interval",
    practiceParams: { subject: "ap_calculus_bc", unit: "1", topic: "1.12" },
  },
  {
    unitId: "unit-1",
    topicId: "1.13",
    title: "Removing Discontinuities",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "A removable discontinuity can be fixed by defining or redefining the function value so it equals the limit at that point.",
    whyItMatters:
      "This topic turns the definition of continuity into an action: find the value or parameter that makes the function continuous.",
    howPointsAreEarned:
      "You earn points by finding the relevant limit and setting the function value or parameter equal to it.",
    answerMove:
      "Find the limit at the discontinuity first, then set f(c) or the parameter expression equal to that limit.",
    commonPointLoss:
      "Solving for a value without showing that it matches the limiting behavior.",
    learnMorePath: "/learn/ap-calculus-bc/unit-1/removing-discontinuities",
    practiceParams: { subject: "ap_calculus_bc", unit: "1", topic: "1.13" },
  },
  {
    unitId: "unit-1",
    topicId: "1.14",
    title: "Connecting Infinite Limits and Vertical Asymptotes",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "An infinite limit describes function values growing without bound as x approaches a finite input.",
    whyItMatters:
      "Students need to distinguish unbounded behavior from finite limits, jumps, and ordinary function values; BC later reuses unbounded behavior in improper integrals.",
    howPointsAreEarned:
      "You earn points by using limit notation to describe unbounded behavior and connecting it to a vertical asymptote when appropriate.",
    answerMove:
      "Check each side of the input. If f(x) grows without bound, write the infinite limit and name x = c as the vertical asymptote.",
    commonPointLoss:
      "Writing only does not exist when the problem asks for behavior or an asymptote connection.",
    learnMorePath:
      "/learn/ap-calculus-bc/unit-1/infinite-limits-and-vertical-asymptotes",
    practiceParams: { subject: "ap_calculus_bc", unit: "1", topic: "1.14" },
  },
  {
    unitId: "unit-1",
    topicId: "1.15",
    title: "Connecting Limits at Infinity and Horizontal Asymptotes",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "A limit at infinity describes end behavior as x grows very large positive or negative.",
    whyItMatters:
      "End behavior helps students describe long-run function behavior analytically, graphically, verbally, and later in BC convergence contexts.",
    howPointsAreEarned:
      "You earn points by identifying end behavior, writing the correct limit at infinity, and connecting a finite result to y = L.",
    answerMove:
      "Ask what f(x) approaches as x goes far left or far right. If it approaches L, name y = L.",
    commonPointLoss:
      "Confusing vertical asymptotes with horizontal asymptotes or finite-input limits with limits at infinity.",
    learnMorePath:
      "/learn/ap-calculus-bc/unit-1/limits-at-infinity-and-horizontal-asymptotes",
    practiceParams: { subject: "ap_calculus_bc", unit: "1", topic: "1.15" },
  },
  {
    unitId: "unit-1",
    topicId: "1.16",
    title: "Working with the Intermediate Value Theorem",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "The Intermediate Value Theorem says a continuous function on a closed interval takes every value between its endpoint values somewhere inside the interval.",
    whyItMatters:
      "This is an early existence theorem: it proves a value occurs without finding its exact location, a style of reasoning BC students will keep using in more advanced settings.",
    howPointsAreEarned:
      "You earn points by verifying continuity, showing the target value lies between endpoint values, and stating the existence conclusion.",
    answerMove:
      "Write the conditions first: continuous on [a,b], target between f(a) and f(b), therefore some c exists in (a,b).",
    commonPointLoss:
      "Jumping to the conclusion without verifying continuity and the endpoint-value condition.",
    learnMorePath:
      "/learn/ap-calculus-bc/unit-1/intermediate-value-theorem",
    practiceParams: { subject: "ap_calculus_bc", unit: "1", topic: "1.16" },
  },
];
```

