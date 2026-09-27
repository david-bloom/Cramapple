# Lovable Prompt: Course Mode Score-Impact UX, AP Statistics Unit 1 Pilot

## Objective

Update the Course Mode student experience so AP Statistics Unit 1 content is presented as a score-impact lesson, not as a generic topic summary.

Do not touch AP Statistics Units 2 or 3. This is a Unit 1 pilot only.

The learning model is:

`unit -> topic -> skill -> test-facing move -> common mistake -> corrective nudge`

The screen should answer:

> This is the part of today's class that is most important to your success on the test and exam.

## Content Contract

Use the existing topic guide fields, but render them through the new protocol:

- `title` -> topic label
- `what_it_is` or `core_idea` -> Score-Impact Skill / Essence
- `why_it_matters` or `what_students_need_to_understand` -> Why This Matters Here
- `how_points_are_earned` or `how_this_becomes_points` -> Point-Max Move
- `answer_move` -> Open Hand / answer construction move
- `common_point_loss` -> Point-Losing Move
- `mini_example_question`, `weak_answer`, `point_attaining_answer`, `practice_bridge` -> example, repair, and practice loop

If the backend later provides explicit fields named `score_impact_skill`, `open_hand`, `point_max_move`, `point_losing_move`, or `nudge`, prefer those fields. Until then, map the current fields as above.

## Required UX

Build a compact, usable lesson surface. This is not a landing page.

### 1. Lesson Header

Show:
- subject
- unit
- topic
- time estimate
- a concise line: "The score-impact skill from this class"

Do not use marketing copy.

### 2. Open Hand Card

Before showing answer choices or explanations, show a focused prompt:

> What is this asking you to do?

Render the answer move as the student's task. This should feel like the student is opening their hand to identify the move before grabbing an answer.

### 3. Essence

Render a short essence block with:
- skill name
- why it matters here
- decision rule, formula, or diagram if present

Keep it visually tight. This is the memorable 10-minute version of the 50-minute class.

### 4. Point-Max Move

Render this as an answer-construction guide, not a rubric list.

Use visual labels for:
- Label
- Decide
- Evidence
- Explain
- Context

Only show labels that are present in the content. Avoid empty boilerplate.

### 5. Point-Losing Move

Render the common mistake next to the point-max move. The relationship should be obvious:

- Point-Max: what earns/protects points
- Point-Loss: what breaks that move

Use restrained color; do not make the screen alarmist.

### 6. Practice And Nudge

For MCQ:
- show the original Cramapple-authored question
- require the student to answer
- after submission, show:
  - "Tempting because..."
  - "Fails because..."
  - "Go back to the point-max move..."
  - "Avoid the point-loss trap..."

For FRQ:
- show a short response builder
- allow the model answer to reveal in layers
- highlight answer parts by role: label, relationship, evidence, explanation, context

### 7. Point Lens Highlighting

When displaying a strong answer, visually annotate why it works:

- green: earns/protects points
- yellow: incomplete/risky
- red: loses point/misconception
- blue: key evidence/context

Keep this accessible with text labels, not color alone.

## Interaction Rules

- Do not show every block at once on mobile.
- Start with Open Hand and Essence.
- Reveal Point-Max and Point-Loss next.
- Reveal Nudge only after a student action.
- Keep content dense but readable.
- Do not add decorative cards inside cards.
- Use existing Cramapple design patterns.
- Use icons for reveal, retry, check, and continue actions when the app already has an icon library.

## Guardrails

- Do not include or fetch copyrighted third-party questions, rubrics, answer keys, or scoring language.
- Do not add AP Statistics Unit 2 or Unit 3 content.
- Do not change the taxonomy.
- Do not change authentication, payments, reviewer flows, or unrelated routes.
- Do not create a new marketing page.

## Acceptance Checks

With AP Statistics Unit 1 Topic 1.2 selected:
- The student sees a score-impact lesson, not a generic definition card.
- The first interaction asks what the question is asking them to do.
- The point-max move explains answer construction.
- The point-losing move is visibly tied to the point-max move.
- A wrong MCQ answer produces a nudge that explains the distractor and points back to both point-max and point-loss.
- Units 2 and 3 are unchanged.
