# Course Mode Score-Impact Content Protocol

STATUS: operating draft | DATE: 2026-08-27 | SCOPE: Course Mode content and UX requirements

## North Star

Course Mode helps a student remember the part of today's class that will have the greatest impact on test and exam performance.

The product is not a class summary. It is a 50-minute-to-10-minute translation layer:

`unit -> topic -> skill -> test-facing move -> common mistake -> corrective nudge`

Every piece of content must answer one question:

> What changes about how the student answers because they saw this?

If content is true but does not change how the student answers, it does not belong in the core Course Mode lesson.

## Rights And Source Policy

Cramapple-authored Course Mode content must not use copyrighted third-party questions, rubrics, answer keys, or scoring-language passages. This is especially strict for College Board materials.

Allowed:
- original Cramapple examples
- general subject-matter knowledge
- course-aligned skill/topic vocabulary already represented in Cramapple taxonomy
- original descriptions of common student mistakes
- internal SME-authored guidance

Not allowed:
- copying or lightly paraphrasing official released questions
- copying official scoring guidelines or rubrics
- copying Chief Reader report language
- using official prompts as hidden templates
- building examples that are recognizably derivative of a copyrighted prompt

Source notes should say whether content is Cramapple-authored, which internal protocol it follows, and whether SME review is pending. They should not imply copyrighted source text was used.

## The Repeatable Lesson Unit

Each Course Mode topic lesson should have these student-facing parts.

### 1. Score-Impact Skill

Name the skill and define it in student language.

The skill should be an answer behavior, not just a noun:
- weak: "Variables"
- better: "Classify a variable by what the values mean, not by how they look."

### 2. Why This Matters Here

Connect the skill to the topic.

Use the sentence pattern:

> The reason this skill matters here is...

This section explains why the student should spend attention on this part of class instead of the full 50-minute period.

### 3. Essence

Give the smallest memorable version of the lesson.

Constraints:
- 2-4 sentences by default
- include a formula, diagram, decision rule, or contrast only when it changes the answer
- avoid generic background
- avoid motivational filler

The essence should be what the student can carry into a quiz or exam.

### 4. Open Hand

Before choices, formulas, or answer templates, show the question as an open task:

> What is this question asking you to do?

The open hand trains students to identify the underlying move before they chase answer choices.

For MCQ, the open hand asks what distinction the item is testing.

For FRQ, the open hand asks what response the student must construct.

### 5. Point-Max Move

This is not a rubric checklist. It is an answer-construction lesson.

Explain the pattern the student should use when building an answer:
- what to label
- what relationship or decision to state
- what evidence, calculation, or feature to cite
- what explanation connects evidence to conclusion
- what context must appear

It is fair, and often helpful, to tell students that the same pattern repeats. The lesson should explicitly say when a point-winning structure is recurring:

> This pattern repeats. The hard part is picking apart the question to see which labels, relationships, evidence, and context it requires today.

### 6. Point-Losing Move

Name the most common way students lose the point.

This should be concrete:
- weak: "Students confuse variables."
- better: "Students call ZIP code quantitative because it is written with digits, even though arithmetic on ZIP codes is meaningless."

Point-losing moves should correspond to missing or misusing a point-max move.

### 7. Question Format Split

MCQ and FRQ use the same skill differently.

MCQ = recognition under traps.

An MCQ lesson should emphasize:
- what distinction unlocks the item
- what makes a distractor tempting
- what makes that distractor fail
- how to eliminate answers that answer a different question

FRQ = production under scoring rules.

An FRQ lesson should emphasize:
- how to build a complete response
- what must be labeled
- what work or evidence must be visible
- how to write the conclusion in context

Use the broader term "Point-Max Move" instead of centering everything on "rubric requires." Rubric requirements are one expression of the answer behavior, mostly for FRQ.

### 8. Corrective Nudge

The nudge is a targeted repair loop, not a second mini-lesson.

A nudge must:
- explain why the chosen distractor or wrong move was tempting
- identify the specific flaw
- point back to the point-max move
- name the point-losing trap the student fell into
- invite the student to retry or re-read the exact relevant essence

Template:

> You may have chosen this because [partial truth]. But this loses the point because [specific flaw]. Go back to the point-max move: [needed action]. Avoid the point-loss trap: [named mistake].

Every nudge must connect to either the point-max move or the point-losing move.

## UX Requirements

The UX must make invisible scoring logic visible.

Recommended patterns:
- **Open Hand first:** reveal the underlying task before choices or solution.
- **Point lens:** highlight answer pieces by role: label, relationship, evidence, context, explanation.
- **Trap reveal:** for each distractor, show "tempting because" and "fails because."
- **Answer build:** for FRQ, reveal the response in layers instead of dumping a model answer.
- **Repair loop:** after a wrong answer, show what the student noticed correctly, where the answer stopped earning, and the exact fix.

Avoid showing essence, question, choices, point-max, point-loss, and nudge all at once. Reveal only the next thing that changes how the student answers.

## Authoring Checklist

For every Course Mode topic or item:
- [ ] Does this content change how the student answers?
- [ ] Is the skill named as an action?
- [ ] Is the topic connection explicit?
- [ ] Is the essence short enough to remember?
- [ ] Does the point-max section teach answer construction, not just list components?
- [ ] Is the point-losing move concrete and tied to the point-max move?
- [ ] Does the nudge explain the distractor and point back to point-max/point-loss?
- [ ] Is the example original Cramapple content?
- [ ] Does the source note avoid implying copyrighted materials were used?

## Unit 1 Pilot Constraint

Apply this protocol to AP Statistics Unit 1 first. Do not re-author Units 2 or 3 until Unit 1 has been reviewed in product and learning-quality terms.
