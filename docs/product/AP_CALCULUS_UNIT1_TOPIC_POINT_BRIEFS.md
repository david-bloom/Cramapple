# AP Calculus Unit 1 Topic Point Briefs

Status: Draft content system seed for new-user home and unit selector planning.

Purpose: preserve Cramapple-original topic point brief content for AP Calculus
Unit 1. These briefs are meant to help a new student understand how each topic
turns into point-attainment behavior without replacing a full lesson.

Source basis: AP Calculus AB and BC Course and Exam Description, plus the local
CED fact pack in `docs/product/AP_CALCULUS_AB_BC_CED_FACT_PACK.md`.

Content rules:

- Do not include external links.
- Do not copy third-party study-guide language.
- Keep each topic subject-specific, unit-specific, and point-focused.
- Each brief should connect concept -> importance -> point behavior -> practice.
- The `Learn more` route can later open Cramapple-authored instruction.
- The `Start practicing` route should filter practice by subject, unit, and topic.

## Learn More Behavior

When a student selects `Learn more` from a topic card, Cramapple should open a
focused topic explainer for that exact subject, unit, and topic. This route is
not a generic article library and not a full replacement for class instruction.
Its job is to help the student understand how the topic becomes AP points, then
move them back into practice.

The learner should experience `Learn more` as:

```text
I understand what this topic is.
I understand why it matters for AP Calculus.
I understand what an AP-quality answer has to connect.
I can now try a practice question with that scoring move in mind.
```

### Page Entry

`Learn more` opens the route specified by `learnMorePath`.

The page should preserve context from the card:

- subject;
- unit;
- topic;
- selected course variant when relevant, such as AB or BC;
- return path to the home page or unit view;
- practice parameters for the `Start practicing` action.

### Page Structure

Each topic explainer should use the same basic structure:

1. Topic header
   - Topic ID and title.
   - Class importance and exam importance.
   - Unit name.
2. What it is
   - A short Cramapple-authored explanation of the concept.
   - Keep this concise. Do not teach the whole classroom lesson.
3. Why it matters
   - Connect the topic to later calculus work and AP score opportunities.
4. How this becomes points
   - Name the specific AP skill behavior the student needs.
   - Connect the topic to representation, procedure, justification, notation, or
     interpretation.
5. Answer move
   - Give the student one reusable sentence frame, checklist, or decision move.
6. Mini example
   - One small non-secure, Cramapple-authored example.
   - Show the difference between a weak answer and a point-attaining answer.
   - Do not reveal answer-bearing content from a diagnostic or cold assessment
     item.
7. Common point loss
   - Explain the mistake students make and what to do instead.
8. Actions
   - Primary: `Start practicing`.
   - Secondary: `Back to Unit 1`.
   - Optional tertiary: `Take diagnostic`, only if the student has not started
     or completed it.

### Content Standard

The `Learn more` page should stay point-attainment focused. It may explain a
concept just enough to make the scoring behavior meaningful, but it should not
become a full textbook lesson.

Allowed:

- original Cramapple-authored explanations;
- AP Calculus-specific wording;
- small examples designed for this page;
- scoring behavior such as setup, representation, justification, theorem
  conditions, notation, and interpretation;
- non-secure practice-style examples.

Not allowed:

- external links;
- copied third-party explanations;
- copied official AP secure questions;
- generic study advice that could apply to any course;
- long content lectures that delay practice;
- language that implies Cramapple is affiliated with or endorsed by College
  Board.

### State And Navigation

Selecting `Learn more` should not change the learner's diagnostic state,
practice history, or mastery evidence by itself. Reading the page may be tracked
as content engagement later, but it should not be treated as proof of learning.

Selecting `Start practicing` from the page should use the same `practiceParams`
as the originating topic card. The practice session should know that the student
entered from `Learn more`, so the first practice prompt can reinforce the
topic's answer move without exposing hidden scoring criteria.

### First Version Scope

For the first version, `Learn more` can be implemented as a single reusable page
template populated by the `TopicPointBrief` fields plus one optional mini-example
section. If mini-examples are not ready, ship the page without examples rather
than filling the space with generic advice.

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

```ts
const apCalculusUnit1TopicPointBriefs: TopicPointBrief[] = [
  {
    unitId: "unit-1",
    topicId: "1.1",
    title: "Introducing Calculus: Can Change Occur at an Instant?",
    classImportance: "very-important",
    examImportance: "somewhat-important",
    whatItIs:
      "This topic introduces the central calculus move from change over an interval to change at a single instant. Average rate of change compares two inputs. Instantaneous rate of change asks what that comparison approaches as the interval shrinks toward one point.",
    whyItMatters:
      "This is the conceptual bridge into derivatives. Students who understand why a rate at an instant needs a limit are better prepared to interpret slope, velocity, and change throughout the course.",
    howPointsAreEarned:
      "You earn points by recognizing whether a question is asking about change over an interval or change at an instant, and by connecting the instant case to limiting behavior rather than treating it like an ordinary fraction with zero change in x.",
    answerMove:
      "Ask: 'Is the change measured over an interval or at one point?' If it is at one point, describe it as the value approached by average rates of change over smaller intervals around that point.",
    commonPointLoss:
      "Trying to compute an instantaneous rate as a direct quotient with zero change in x, instead of explaining it through a limiting process.",
    learnMorePath: "/learn/ap-calculus-ab/unit-1/instantaneous-change",
    practiceParams: {
      subject: "ap_calculus_ab",
      unit: "1",
      topic: "1.1",
    },
  },
  {
    unitId: "unit-1",
    topicId: "1.2",
    title: "Defining Limits and Using Limit Notation",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "A limit describes the value a function approaches as x gets close to a chosen input. Limit notation is the precise way AP Calculus asks you to name that approaching behavior.",
    whyItMatters:
      "Limit notation is the language used for continuity, derivatives, infinite behavior, and many justifications. If the notation is unclear, the mathematical claim is unclear.",
    howPointsAreEarned:
      "You earn points by reading and writing limit statements accurately: the approaching input, the function being considered, the direction if one is specified, and the value being approached.",
    answerMove:
      "Read the notation as a sentence: 'As x approaches ___, f(x) approaches ___.' Keep the approaching input separate from the actual function value at that input.",
    commonPointLoss:
      "Replacing the limit with f(a) automatically, or dropping the direction marker on a one-sided limit.",
    learnMorePath: "/learn/ap-calculus-ab/unit-1/limit-notation",
    practiceParams: {
      subject: "ap_calculus_ab",
      unit: "1",
      topic: "1.2",
    },
  },
  {
    unitId: "unit-1",
    topicId: "1.3",
    title: "Estimating Limit Values from Graphs",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "A graph can show what y-value a function approaches as x moves toward a chosen input from the left, from the right, or from both sides.",
    whyItMatters:
      "Graph-based limits train students to focus on nearby behavior instead of point values. This representation skill carries into continuity, asymptotes, derivative graphs, and accumulation graphs.",
    howPointsAreEarned:
      "You earn points by using the graph to identify left-hand and right-hand behavior and by concluding whether the two-sided limit exists. If the sides approach the same y-value, the limit exists. If they do not, the two-sided limit does not exist.",
    answerMove:
      "Trace the graph toward the x-value from both sides. Say what y-value each side approaches before giving the final limit statement.",
    commonPointLoss:
      "Using a filled or open point as the limit value without checking what the graph approaches from nearby x-values.",
    learnMorePath: "/learn/ap-calculus-ab/unit-1/estimating-limits-from-graphs",
    practiceParams: {
      subject: "ap_calculus_ab",
      unit: "1",
      topic: "1.3",
    },
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
      "Tables appear throughout AP Calculus, especially when exact formulas are not given. Students need to use numerical evidence carefully without pretending an estimate is exact unless the problem supports it.",
    howPointsAreEarned:
      "You earn points by using nearby table values from both sides of the input, identifying the trend they support, and writing an estimate with language that matches the evidence.",
    answerMove:
      "Look at x-values approaching from below and above. If the y-values trend toward the same number, state the limit as an estimate and connect it to that trend.",
    commonPointLoss:
      "Using only one table entry, or treating a table estimate as exact when the table only supports an approximation.",
    learnMorePath: "/learn/ap-calculus-ab/unit-1/estimating-limits-from-tables",
    practiceParams: {
      subject: "ap_calculus_ab",
      unit: "1",
      topic: "1.4",
    },
  },
  {
    unitId: "unit-1",
    topicId: "1.5",
    title: "Determining Limits Using Algebraic Properties of Limits",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "Limit properties allow you to determine limits of sums, differences, products, quotients, and composite functions when the component limits behave in a usable way.",
    whyItMatters:
      "This is where limits become a reliable calculation tool. Students begin deciding when a limit can be evaluated by applying known rules instead of only estimating from a graph or table.",
    howPointsAreEarned:
      "You earn points by applying the correct limit property and preserving the structure of the expression. For quotients, you must notice whether the denominator's limit creates a problem before using direct substitution.",
    answerMove:
      "Break the expression into parts, find the relevant component limits, then apply the matching property only when its conditions make sense.",
    commonPointLoss:
      "Applying quotient or composition rules mechanically when the denominator approaches zero or when the component limit does not exist.",
    learnMorePath: "/learn/ap-calculus-ab/unit-1/algebraic-properties-of-limits",
    practiceParams: {
      subject: "ap_calculus_ab",
      unit: "1",
      topic: "1.5",
    },
  },
  {
    unitId: "unit-1",
    topicId: "1.6",
    title: "Determining Limits Using Algebraic Manipulation",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "Some limits cannot be determined from the original expression immediately. Algebraic manipulation rewrites the expression into an equivalent form that reveals the limiting behavior.",
    whyItMatters:
      "This topic teaches students that an expression's first form is not always the useful form. Factoring, simplifying, rationalizing, or using equivalent trigonometric forms can turn an indeterminate-looking expression into a solvable limit.",
    howPointsAreEarned:
      "You earn points by choosing a valid algebraic rewrite, showing the transformed expression, and then evaluating the limit from the simplified form. The work matters because it explains why the final value is justified.",
    answerMove:
      "When substitution gives 0/0 or another blocked form, ask: 'What equivalent form removes the obstacle?' Then simplify before evaluating.",
    commonPointLoss:
      "Canceling or rewriting expressions in a way that is not algebraically equivalent near the point of interest.",
    learnMorePath: "/learn/ap-calculus-ab/unit-1/algebraic-manipulation-for-limits",
    practiceParams: {
      subject: "ap_calculus_ab",
      unit: "1",
      topic: "1.6",
    },
  },
  {
    unitId: "unit-1",
    topicId: "1.7",
    title: "Selecting Procedures for Determining Limits",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "This topic is about choosing the right method for a limit problem, not just carrying out a method after someone names it for you.",
    whyItMatters:
      "AP questions often reward procedure selection. A student may know several limit techniques but still lose points if they do not recognize which one fits the expression or representation in front of them.",
    howPointsAreEarned:
      "You earn points by classifying the form of the problem and selecting a procedure that matches it: direct property use, graph or table reasoning, factoring, rationalizing, trigonometric rewriting, one-sided analysis, or another valid limit strategy.",
    answerMove:
      "Before calculating, name the obstacle or cue: direct substitution works, left and right sides must be checked, the expression can be factored, a conjugate helps, or a known limit form applies.",
    commonPointLoss:
      "Defaulting to a familiar technique without first checking whether the problem's form calls for that technique.",
    learnMorePath: "/learn/ap-calculus-ab/unit-1/selecting-limit-procedures",
    practiceParams: {
      subject: "ap_calculus_ab",
      unit: "1",
      topic: "1.7",
    },
  },
  {
    unitId: "unit-1",
    topicId: "1.8",
    title: "Determining Limits Using the Squeeze Theorem",
    classImportance: "somewhat-important",
    examImportance: "somewhat-important",
    whatItIs:
      "The squeeze theorem determines a limit by trapping a function between two other functions that approach the same value.",
    whyItMatters:
      "This topic is a first major example of theorem-based limit reasoning. The student is not only calculating; the student is verifying conditions that force a conclusion.",
    howPointsAreEarned:
      "You earn points by identifying lower and upper bounds, showing that both bounding functions approach the same limit, and then using that shared limit to justify the squeezed function's limit.",
    answerMove:
      "Write the inequality first, find the limits of the lower and upper functions, then conclude the middle function has the same limit.",
    commonPointLoss:
      "Stating the squeeze theorem result without showing the bounding relationship and the matching endpoint limits.",
    learnMorePath: "/learn/ap-calculus-ab/unit-1/squeeze-theorem",
    practiceParams: {
      subject: "ap_calculus_ab",
      unit: "1",
      topic: "1.8",
    },
  },
  {
    unitId: "unit-1",
    topicId: "1.9",
    title: "Connecting Multiple Representations of Limits",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "This topic asks students to move between graphs, tables, equations, verbal descriptions, and limit notation that describe the same limiting behavior.",
    whyItMatters:
      "AP Calculus regularly changes representation without changing the underlying idea. Students who can translate between forms can recognize the same limit claim even when it looks different.",
    howPointsAreEarned:
      "You earn points by identifying the same mathematical information across representations and keeping the limit claim consistent as the form changes.",
    answerMove:
      "For each representation, say the same sentence: 'As x approaches ___, f(x) approaches ___.' Then check whether the graph, table, equation, or words support that same sentence.",
    commonPointLoss:
      "Treating each representation as a separate problem and missing that they are giving the same limit information.",
    learnMorePath: "/learn/ap-calculus-ab/unit-1/multiple-representations-of-limits",
    practiceParams: {
      subject: "ap_calculus_ab",
      unit: "1",
      topic: "1.9",
    },
  },
  {
    unitId: "unit-1",
    topicId: "1.10",
    title: "Exploring Types of Discontinuities",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "Discontinuities are places where a function fails to be continuous. Common AP Calculus types include removable discontinuities, jump discontinuities, and discontinuities caused by vertical asymptotes.",
    whyItMatters:
      "Naming the type of discontinuity helps students explain what failed: the function value, the matching of one-sided limits, or bounded behavior near the input.",
    howPointsAreEarned:
      "You earn points by identifying the discontinuity type and connecting it to evidence from limits and function values, not just by saying the graph is broken.",
    answerMove:
      "Check what happens to the left-hand limit, right-hand limit, and function value. Use that evidence to classify the discontinuity.",
    commonPointLoss:
      "Calling every gap a removable discontinuity or every non-continuous point an asymptote without checking the limit behavior.",
    learnMorePath: "/learn/ap-calculus-ab/unit-1/types-of-discontinuities",
    practiceParams: {
      subject: "ap_calculus_ab",
      unit: "1",
      topic: "1.10",
    },
  },
  {
    unitId: "unit-1",
    topicId: "1.11",
    title: "Defining Continuity at a Point",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "A function is continuous at a point when the function value exists, the limit exists, and the limit equals the function value.",
    whyItMatters:
      "This is one of the clearest places where AP Calculus rewards condition-checking. Continuity is not just a visual impression; it is a definition with required parts.",
    howPointsAreEarned:
      "You earn points by checking all three conditions and using them to justify whether the function is continuous at the point.",
    answerMove:
      "Use the three-part checklist: f(c) exists, lim as x approaches c exists, and the limit equals f(c). Then state the conclusion.",
    commonPointLoss:
      "Saying a function is continuous because the graph looks connected, without verifying the function value and limit conditions.",
    learnMorePath: "/learn/ap-calculus-ab/unit-1/continuity-at-a-point",
    practiceParams: {
      subject: "ap_calculus_ab",
      unit: "1",
      topic: "1.11",
    },
  },
  {
    unitId: "unit-1",
    topicId: "1.12",
    title: "Confirming Continuity over an Interval",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "Continuity over an interval means the function is continuous at every point in that interval, with endpoint behavior handled according to the interval.",
    whyItMatters:
      "Many AP conclusions depend on interval-level continuity. Students need to know when common function families are continuous on their domains and when domain restrictions create exceptions.",
    howPointsAreEarned:
      "You earn points by identifying the interval, checking whether the function is continuous throughout it, and naming any domain restrictions, breakpoints, or endpoints that matter.",
    answerMove:
      "Start with the function family and its domain. Then check special points inside the interval and state the interval where continuity holds.",
    commonPointLoss:
      "Claiming continuity over an interval while ignoring holes, asymptotes, piecewise boundaries, or excluded domain values.",
    learnMorePath: "/learn/ap-calculus-ab/unit-1/continuity-over-an-interval",
    practiceParams: {
      subject: "ap_calculus_ab",
      unit: "1",
      topic: "1.12",
    },
  },
  {
    unitId: "unit-1",
    topicId: "1.13",
    title: "Removing Discontinuities",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "A removable discontinuity can be fixed by defining or redefining the function value so it equals the limit at that point. Piecewise functions may also require matching expressions at a boundary.",
    whyItMatters:
      "This topic turns the definition of continuity into an action: find the value or parameter that makes the function continuous.",
    howPointsAreEarned:
      "You earn points by finding the relevant limit, setting the function value or parameter equal to that limit, and showing that the continuity condition is satisfied.",
    answerMove:
      "Find the limit at the discontinuity first. Then set f(c), or the unknown parameter expression, equal to that limit.",
    commonPointLoss:
      "Solving only for a function value or parameter without showing that it matches the limiting behavior from the surrounding pieces.",
    learnMorePath: "/learn/ap-calculus-ab/unit-1/removing-discontinuities",
    practiceParams: {
      subject: "ap_calculus_ab",
      unit: "1",
      topic: "1.13",
    },
  },
  {
    unitId: "unit-1",
    topicId: "1.14",
    title: "Connecting Infinite Limits and Vertical Asymptotes",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "An infinite limit describes function values that grow without bound as x approaches a finite input. This behavior is connected to vertical asymptotes.",
    whyItMatters:
      "Students need to distinguish a limit that does not exist because of unbounded behavior from a finite limit or a jump. This helps explain graph features precisely.",
    howPointsAreEarned:
      "You earn points by using limit notation to describe unbounded behavior and by connecting that behavior to the presence or absence of a vertical asymptote.",
    answerMove:
      "Check each side of the input. If f(x) increases or decreases without bound as x approaches the value, write the appropriate infinite limit and name the vertical asymptote.",
    commonPointLoss:
      "Writing 'does not exist' without explaining whether the function is unbounded, or treating infinity as a regular limit value.",
    learnMorePath: "/learn/ap-calculus-ab/unit-1/infinite-limits-and-vertical-asymptotes",
    practiceParams: {
      subject: "ap_calculus_ab",
      unit: "1",
      topic: "1.14",
    },
  },
  {
    unitId: "unit-1",
    topicId: "1.15",
    title: "Connecting Limits at Infinity and Horizontal Asymptotes",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "A limit at infinity describes a function's end behavior as x grows very large in the positive or negative direction. A finite limit at infinity is connected to a horizontal asymptote.",
    whyItMatters:
      "End behavior helps students describe the long-run behavior of functions. AP questions may ask for this behavior analytically, graphically, or verbally.",
    howPointsAreEarned:
      "You earn points by identifying the end behavior, writing the correct limit at infinity, and connecting a finite end-behavior value to a horizontal asymptote when appropriate.",
    answerMove:
      "Ask: 'What does f(x) approach as x goes to positive or negative infinity?' If it approaches L, connect that to the horizontal asymptote y = L.",
    commonPointLoss:
      "Confusing vertical asymptotes with horizontal asymptotes, or using finite-input limit reasoning when the question is about x going to infinity.",
    learnMorePath: "/learn/ap-calculus-ab/unit-1/limits-at-infinity-and-horizontal-asymptotes",
    practiceParams: {
      subject: "ap_calculus_ab",
      unit: "1",
      topic: "1.15",
    },
  },
  {
    unitId: "unit-1",
    topicId: "1.16",
    title: "Working with the Intermediate Value Theorem",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "The Intermediate Value Theorem says that a continuous function on a closed interval must take every value between its endpoint values somewhere inside that interval.",
    whyItMatters:
      "This is a major early example of existence reasoning. The theorem lets students prove that a solution or value exists without finding its exact location.",
    howPointsAreEarned:
      "You earn points by verifying the function is continuous on the closed interval, showing the target value lies between the endpoint values, and then stating the existence conclusion.",
    answerMove:
      "Write the conditions before the conclusion: continuous on [a, b], target value between f(a) and f(b), therefore there exists c in (a, b) such that f(c) equals the target value.",
    commonPointLoss:
      "Jumping to the conclusion that a value exists without explicitly verifying continuity and the endpoint-value condition.",
    learnMorePath: "/learn/ap-calculus-ab/unit-1/intermediate-value-theorem",
    practiceParams: {
      subject: "ap_calculus_ab",
      unit: "1",
      topic: "1.16",
    },
  },
];
```
