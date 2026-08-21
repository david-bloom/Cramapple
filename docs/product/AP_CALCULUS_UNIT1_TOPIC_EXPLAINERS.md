# AP Calculus Unit 1 Learn More Explainers

Status: Draft content seed for `Learn more` pages.

Purpose: define Cramapple-original explainer content for AP Calculus AB Unit 1
topic pages. These pages teach the topic just enough to make the scoring move
meaningful, then connect the teaching to point maximization.

Source basis: AP Calculus AB and BC Course and Exam Description, plus
`docs/product/AP_CALCULUS_AB_BC_CED_FACT_PACK.md`.

Content rules:

- No external links.
- No copied third-party explanations.
- No copied official AP questions.
- Teach the concept, then connect it to AP point-attainment behavior.
- Keep the student moving toward practice.

## Page Template

Each `Learn more` page should contain:

1. Topic header.
2. Core idea.
3. What students need to understand.
4. How this becomes points.
5. Answer move.
6. Mini example.
7. Weak answer versus point-attaining answer.
8. Common point loss.
9. Practice bridge.

## Unit 1 Explainers

### 1.1 Introducing Calculus: Can Change Occur at an Instant?

Core idea:

Calculus begins with a strange problem: average rate of change is easy over an
interval, but an instant has no interval width. If the change in x is zero, the
usual average-rate fraction does not work. The limit idea lets us ask what the
average rate approaches as the interval around the instant gets smaller and
smaller.

What students need to understand:

Average rate of change compares two inputs. Instantaneous rate of change is the
value those average rates approach near one input. The point is not to divide by
zero. The point is to use nearby intervals to describe behavior at a single
moment.

How this becomes points:

AP Calculus rewards students who can tell whether a question is asking about an
interval or an instant. A point-attaining answer connects the instant case to a
limiting process instead of treating it like an ordinary slope between two
visible points.

Answer move:

Ask, "Over an interval or at one point?" If it is at one point, say that the
instantaneous rate is approached by average rates over smaller intervals around
that point.

Mini example:

Question: A car's position is measured near t = 4 seconds. What does it mean to
ask for the car's speed at exactly t = 4?

Weak answer:

"Use position divided by time at t = 4."

Point-attaining answer:

"The speed at t = 4 is the instantaneous rate of change of position. It is the
limit of average velocities over intervals containing t = 4 as the interval
width approaches 0."

Common point loss:

Trying to compute an instantaneous rate by making the denominator zero.

Practice bridge:

Practice should ask students to distinguish interval questions from instant
questions and explain the role of a limit in the instant case.

### 1.2 Defining Limits and Using Limit Notation

Core idea:

A limit describes what value a function approaches as x gets close to a chosen
input. The function may equal that value, miss that value, or even be undefined
at that input. Limit notation is the compact language for naming the approaching
behavior.

What students need to understand:

The phrase "as x approaches c" means x gets close to c, not necessarily that
x equals c. The limit statement is about nearby behavior. One-sided notation
adds direction: from the left or from the right.

How this becomes points:

Students earn points by translating notation accurately. The scorer needs to see
the approaching input, the function being considered, the direction if one is
specified, and the value approached. Clear notation prevents a correct idea from
looking like a guess.

Answer move:

Read the notation as a sentence: "As x approaches c, f(x) approaches L." Keep
"approaches" separate from "equals."

Mini example:

Question: Explain what `lim f(x) = 5 as x approaches 2` means.

Weak answer:

"f(2) = 5."

Point-attaining answer:

"As x gets close to 2, the values of f(x) get close to 5. The statement is about
nearby behavior and does not by itself tell us the value of f(2)."

Common point loss:

Replacing a limit statement with a function-value statement.

Practice bridge:

Practice should mix notation, words, graphs, and tables so students learn to
read limit claims across representations.

### 1.3 Estimating Limit Values from Graphs

Core idea:

A graph can show what y-value a function approaches as x moves toward a chosen
input. The important visual action is tracing the curve toward the input from
the left and from the right.

What students need to understand:

The filled point at x = c shows f(c). The open point or nearby curve behavior
may show the limit. For a two-sided limit to exist, the left-hand and right-hand
approaches must lead to the same y-value.

How this becomes points:

Students earn points by naming the left-side behavior, naming the right-side
behavior, and using those observations to decide whether the two-sided limit
exists. The reasoning matters because a graph may contain holes, jumps, or
unbounded behavior.

Answer move:

Trace toward the x-value from both sides before looking at the point on the
graph. Say, "From the left, f(x) approaches ___. From the right, f(x) approaches
___."

Mini example:

Question: A graph has an open circle at (3, 4) and a filled point at (3, 1), and
the curve approaches y = 4 from both sides. Estimate `lim f(x)` as x approaches
3.

Weak answer:

"The limit is 1 because the filled point is at y = 1."

Point-attaining answer:

"The limit is 4 because as x approaches 3 from both sides, the graph approaches
y = 4. The filled point gives f(3), not the limit."

Common point loss:

Using the plotted function value instead of the approaching graph behavior.

Practice bridge:

Practice should include holes, jumps, removable discontinuities, and matching
one-sided limits.

### 1.4 Estimating Limit Values from Tables

Core idea:

A table can suggest a limit by showing function values for x-values close to the
input. The table is evidence of a trend, not automatic proof of an exact value.

What students need to understand:

To estimate a two-sided limit from a table, inspect x-values approaching from
below and from above. If the function values on both sides move toward the same
number, the table supports that limit estimate.

How this becomes points:

Students earn points by using values near the target input, using both sides
when available, and writing the answer as an estimate when the table only
supports approximation.

Answer move:

Look inward from both sides of the table: values less than c and values greater
than c. Then state the trend and the estimated limit.

Mini example:

Question: As x approaches 2, table values of f(x) are 4.9, 4.99, 5.01, and 5.1
near x = 2. Estimate the limit.

Weak answer:

"The limit is 5.1 because that is in the table."

Point-attaining answer:

"The limit appears to be 5 because the function values near x = 2 approach 5
from both sides."

Common point loss:

Choosing one table entry instead of describing the trend across nearby entries.

Practice bridge:

Practice should ask students to identify the best-supported estimate and explain
what numerical evidence supports it.

### 1.5 Determining Limits Using Algebraic Properties of Limits

Core idea:

Limit properties let students combine simpler limits to determine limits of
sums, differences, products, quotients, and composite functions. These rules work
when the component limits behave in a usable way.

What students need to understand:

Algebraic limit properties are not magic shortcuts. They are valid procedures
when the expression and the component limits meet the needed conditions. A
quotient needs special care if the denominator approaches zero.

How this becomes points:

Students earn points by applying a valid limit property, preserving the
expression's structure, and showing enough setup that the final value follows
from the rule.

Answer move:

Break the expression into parts. Determine the relevant component limits. Then
apply the property that matches the expression's structure.

Mini example:

Question: If `lim f(x) = 3` and `lim g(x) = 2` as x approaches 1, determine
`lim (f(x) + 4g(x))`.

Weak answer:

"It is 7."

Point-attaining answer:

"Using limit properties, `lim (f(x) + 4g(x)) = lim f(x) + 4 lim g(x) = 3 + 4(2)
= 11`."

Common point loss:

Applying a property without checking whether the expression has the form the
property requires.

Practice bridge:

Practice should ask students to identify the property being used, not only
compute the final number.

### 1.6 Determining Limits Using Algebraic Manipulation

Core idea:

Some limit expressions hide their behavior. Algebraic manipulation rewrites the
expression into an equivalent form that makes the limit visible.

What students need to understand:

If direct substitution produces a blocked form such as 0/0, the expression may
need to be factored, rationalized, simplified, or rewritten using a known
identity. The replacement expression must be equivalent near the input, even if
the original expression is undefined exactly at that input.

How this becomes points:

Students earn points by choosing a valid rewrite, showing the algebra, and using
the simplified form to determine the limit. The rewrite is often where the point
is earned because it justifies the final value.

Answer move:

When substitution is blocked, ask, "What algebraic obstacle is causing the
problem, and what equivalent form removes it?"

Mini example:

Question: Determine `lim (x^2 - 9)/(x - 3)` as x approaches 3.

Weak answer:

"It is undefined because plugging in 3 gives 0/0."

Point-attaining answer:

"For x near 3, `(x^2 - 9)/(x - 3) = ((x - 3)(x + 3))/(x - 3) = x + 3`, so the
limit is 6."

Common point loss:

Stopping at 0/0, or canceling terms that are not common factors.

Practice bridge:

Practice should require students to name the manipulation: factor, conjugate,
common denominator, or trig rewrite.

### 1.7 Selecting Procedures for Determining Limits

Core idea:

This topic is about deciding which limit method fits the problem. The student is
not just calculating; the student is reading the form of the expression or
representation and choosing a procedure.

What students need to understand:

Different limit problems give different cues. A graph asks for visual approach
behavior. A table asks for numerical trend. An expression might allow direct
properties, factoring, rationalizing, one-sided analysis, or another method.

How this becomes points:

Students earn points by selecting a procedure that matches the problem's form.
On AP-style work, the first scoring move is often recognizing the right path
before doing the calculation.

Answer move:

Before solving, classify the problem: direct substitution works, one-sided
behavior matters, algebraic simplification is needed, the graph gives the
answer, or the table supports an estimate.

Mini example:

Question: Direct substitution into a rational expression gives 0/0. What should
you consider first?

Weak answer:

"Use L'Hospital's Rule."

Point-attaining answer:

"In Unit 1, first look for algebraic simplification such as factoring,
canceling a common factor, or using a conjugate. Then evaluate the simplified
expression's limit."

Common point loss:

Using a familiar method because it feels comfortable, not because the problem
calls for it.

Practice bridge:

Practice should include mixed limit items where students choose the method
before solving.

### 1.8 Determining Limits Using the Squeeze Theorem

Core idea:

The squeeze theorem finds a limit by trapping one function between two other
functions that approach the same value.

What students need to understand:

The theorem is not just a calculation. It is a justification. If the lower
function and upper function both approach L, and the target function is between
them near the input, the target function must also approach L.

How this becomes points:

Students earn points by showing the bounding inequality, determining the limits
of both bounds, and then stating the squeezed conclusion. All three pieces
matter.

Answer move:

Write the bounds first. Then show both outside limits approach the same value.
Only then conclude the middle limit.

Mini example:

Question: Near x = 0, suppose `-x^2 <= h(x) <= x^2`. Determine the limit of
h(x) as x approaches 0.

Weak answer:

"The limit is 0 by the squeeze theorem."

Point-attaining answer:

"Since `-x^2 <= h(x) <= x^2`, and both `lim -x^2` and `lim x^2` as x approaches
0 equal 0, the squeeze theorem gives `lim h(x) = 0`."

Common point loss:

Naming the theorem without verifying the bounds and their matching limits.

Practice bridge:

Practice should emphasize the condition checklist: lower bound, upper bound,
matching limits, conclusion.

### 1.9 Connecting Multiple Representations of Limits

Core idea:

The same limit can be represented by a formula, table, graph, verbal statement,
or notation. This topic trains students to recognize the same mathematical claim
across different forms.

What students need to understand:

Representations look different, but the underlying limit sentence is the same:
as x approaches one value, f(x) approaches another value. A point-attaining
student can translate without changing the meaning.

How this becomes points:

Students earn points by matching information across representations and using a
representation to support the same limit claim. This is especially important
when a problem gives one form and asks for another.

Answer move:

Convert every representation into one sentence: "As x approaches ___, f(x)
approaches ___." Then check whether each form says the same thing.

Mini example:

Question: A table suggests f(x) approaches 4 as x approaches 2. Which graph
feature should match that statement?

Weak answer:

"The graph should have f(2) = 4."

Point-attaining answer:

"The graph should approach y = 4 as x approaches 2 from the relevant side or
sides. The value of f(2) may be different."

Common point loss:

Matching a table's limit trend to a function value instead of to graph approach
behavior.

Practice bridge:

Practice should ask students to choose the graph, table, or notation that
represents the same limit claim.

### 1.10 Exploring Types of Discontinuities

Core idea:

A discontinuity is a place where continuity fails. The type of discontinuity
depends on what fails: the function value, matching one-sided behavior, or
bounded behavior.

What students need to understand:

Removable discontinuities often involve a hole where the limit exists but the
function value is missing or different. Jump discontinuities involve different
one-sided limits. Infinite discontinuities involve unbounded behavior and are
connected to vertical asymptotes.

How this becomes points:

Students earn points by naming the discontinuity and tying that name to limit
evidence. The classification should come from the behavior, not from a visual
guess.

Answer move:

Check left-hand limit, right-hand limit, and f(c). Then classify based on which
part fails.

Mini example:

Question: At x = 1, the left-hand limit is 3 and the right-hand limit is 5. What
type of discontinuity is suggested?

Weak answer:

"It is discontinuous."

Point-attaining answer:

"It is a jump discontinuity because the left-hand and right-hand limits are
finite but not equal, so the two-sided limit does not exist."

Common point loss:

Naming the discontinuity without explaining the limit behavior that creates it.

Practice bridge:

Practice should ask students to classify discontinuities and cite the evidence
from one-sided limits or function values.

### 1.11 Defining Continuity at a Point

Core idea:

A function is continuous at x = c only if three things are true: f(c) exists,
the limit as x approaches c exists, and that limit equals f(c).

What students need to understand:

Continuity is a definition with conditions. A graph that "looks connected" can
help, but AP point-earning explanations must use the definition when the prompt
asks for justification.

How this becomes points:

Students earn points by checking each condition and drawing a conclusion from
the checklist. This is one of the first Unit 1 places where condition-checking
directly protects points.

Answer move:

Use the three-part checklist: value exists, limit exists, value equals limit.
Then state continuous or not continuous.

Mini example:

Question: If `lim f(x) = 7` as x approaches 2 and f(2) = 7, is f continuous at
x = 2?

Weak answer:

"Yes, because the graph is connected."

Point-attaining answer:

"Yes. f(2) exists, the limit as x approaches 2 exists, and the limit equals
f(2), so f is continuous at x = 2."

Common point loss:

Checking only the limit or only the function value.

Practice bridge:

Practice should ask students to decide continuity from graphs, tables,
piecewise definitions, and limit statements.

### 1.12 Confirming Continuity over an Interval

Core idea:

A function is continuous over an interval if it is continuous at every point in
that interval. Common function families are continuous on their domains, but
domain restrictions and piecewise boundaries still matter.

What students need to understand:

Interval continuity is broader than continuity at one point. Students must scan
the whole interval for holes, jumps, vertical asymptotes, endpoints, and domain
restrictions.

How this becomes points:

Students earn points by stating the interval, identifying any points that need
checking, and using known continuity facts or direct checks to support the
conclusion.

Answer move:

Start with the function's domain and family. Then check special points inside
the interval before saying where the function is continuous.

Mini example:

Question: Is `f(x) = 1/(x - 2)` continuous on [0, 4]?

Weak answer:

"Yes, rational functions are continuous."

Point-attaining answer:

"No. Rational functions are continuous on their domains, but x = 2 is not in
the domain and lies in [0, 4], so f is not continuous on the whole interval."

Common point loss:

Using a general continuity fact while ignoring the function's domain.

Practice bridge:

Practice should include polynomial, rational, radical, trigonometric, and
piecewise functions over specified intervals.

### 1.13 Removing Discontinuities

Core idea:

Some discontinuities can be removed by defining or redefining the function value
to equal the limit at that point. Piecewise functions may require matching the
expressions on both sides of a boundary.

What students need to understand:

A discontinuity is removable only when the limiting behavior has a single finite
target. If the left and right sides do not match, or the behavior is unbounded,
there is no single function value that fixes continuity.

How this becomes points:

Students earn points by finding the limit at the discontinuity and setting the
function value or parameter equal to that limit. For piecewise functions, they
must make the boundary value match both side expressions.

Answer move:

Find the limit first. Then set f(c), or the parameter expression, equal to that
limit.

Mini example:

Question: A function has `lim f(x) = 6` as x approaches 3, but f(3) = 1. How
could the discontinuity be removed?

Weak answer:

"Change the graph so it is connected."

Point-attaining answer:

"Redefine f(3) to be 6, because continuity at x = 3 requires f(3) to equal the
limit as x approaches 3."

Common point loss:

Solving for the visible point value without first finding the limit that the
function must match.

Practice bridge:

Practice should include removable holes and piecewise parameters that make a
function continuous.

### 1.14 Connecting Infinite Limits and Vertical Asymptotes

Core idea:

An infinite limit describes a function growing without bound as x approaches a
finite input. This behavior is connected to vertical asymptotes.

What students need to understand:

Infinity is not a regular real-number limit. It describes unbounded behavior.
The function may approach positive infinity from one side and negative infinity
from the other, so one-sided behavior matters.

How this becomes points:

Students earn points by writing the correct one-sided or two-sided infinite
limit statement and connecting it to the vertical asymptote when appropriate.

Answer move:

Check what happens as x approaches the finite input from each side. If the
function grows without bound, state the infinite limit and identify the vertical
asymptote x = c.

Mini example:

Question: As x approaches 2 from the right, f(x) increases without bound. What
limit statement describes this behavior?

Weak answer:

"The limit is DNE."

Point-attaining answer:

"The right-hand limit is positive infinity: as x approaches 2 from the right,
f(x) grows without bound. This supports a vertical asymptote at x = 2 if the
unbounded behavior occurs near that input."

Common point loss:

Writing only "does not exist" when the problem asks for the type of behavior or
an asymptote connection.

Practice bridge:

Practice should ask students to move between infinite limit notation, graphs,
and vertical asymptote statements.

### 1.15 Connecting Limits at Infinity and Horizontal Asymptotes

Core idea:

A limit at infinity describes end behavior: what f(x) approaches as x becomes
very large positive or very large negative. A finite end-behavior limit connects
to a horizontal asymptote.

What students need to understand:

Limits at infinity are about x moving far left or far right, not about x
approaching a finite input. Horizontal asymptotes describe long-run y-values,
not places where the graph becomes undefined.

How this becomes points:

Students earn points by identifying end behavior, writing the correct limit at
positive or negative infinity, and connecting a finite result to y = L.

Answer move:

Ask, "As x goes far left or far right, what y-value does the function approach?"
If the answer is L, name the horizontal asymptote y = L.

Mini example:

Question: If `lim f(x) = 3` as x approaches infinity, what graph feature is
suggested?

Weak answer:

"There is a vertical asymptote at x = 3."

Point-attaining answer:

"The graph has end behavior approaching y = 3 as x goes to infinity, so y = 3
is a horizontal asymptote to the right."

Common point loss:

Confusing x = c vertical asymptotes with y = L horizontal asymptotes.

Practice bridge:

Practice should ask students to interpret end behavior from formulas, graphs,
and limit notation.

### 1.16 Working with the Intermediate Value Theorem

Core idea:

The Intermediate Value Theorem says that if a function is continuous on a closed
interval, then it must take every y-value between the endpoint values somewhere
inside the interval.

What students need to understand:

IVT is an existence theorem. It proves that a value occurs, but it does not tell
you exactly where unless additional work is done. The theorem only applies when
its conditions are met.

How this becomes points:

Students earn points by verifying continuity on the closed interval, showing the
target value lies between the endpoint values, and then stating the guaranteed
existence conclusion.

Answer move:

Write the conditions first: continuous on [a, b], target value between f(a) and
f(b). Then conclude that there is some c in (a, b) where f(c) equals the target
value.

Mini example:

Question: Suppose f is continuous on [1, 5], f(1) = 2, and f(5) = 10. Explain
why f(c) = 7 for some c between 1 and 5.

Weak answer:

"Because 7 is between 1 and 5."

Point-attaining answer:

"Because f is continuous on [1, 5] and 7 is between f(1) = 2 and f(5) = 10, the
Intermediate Value Theorem guarantees some c in (1, 5) such that f(c) = 7."

Common point loss:

Comparing the target value to the x-values instead of comparing it to the
endpoint function values.

Practice bridge:

Practice should ask students to verify IVT conditions before making an
existence conclusion.
