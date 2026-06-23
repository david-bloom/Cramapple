# Lovable Build Prompt - Cramapple Homepage Demo FRQ

Build a polished, responsive homepage section for **Cramapple** that shows the product in action with a rotating FRQ demo. This is for the public landing page only.

This prompt is only for the homepage demo experience. Do not change the How It Works page, intake flow, or the student session routes.

## Goal

Add a homepage module that helps visitors understand Cramapple immediately by showing:

1. An AP Biology FRQ prompt.
2. A typed answer appearing in the answer box.
3. The submit action being pressed.
4. The graded response appearing next.
5. Rotation through 3 FRQ examples.

The demo should feel obvious as a demo, not as a live student session. It should be persuasive, calm, and credible.

## Design Intent

- Show the product working before explaining it.
- Keep the section compact enough to fit naturally below the hero.
- Make the transition from typing to grading feel smooth and intentional.
- Emphasize criterion-level feedback, not generic chatbot output.
- Avoid gimmicks, confetti, fake mastery meters, and loud marketing motion.
- Keep the main homepage CTA visible and stronger than the demo module.

## Routes

This work is for:

```text
/  landing page
```

Do not add new routes for this feature.

## Page Behavior

Add a new homepage section with this structure:

### Section title

```text
See Cramapple in action
```

### Section intro copy

```text
Watch a short AP Biology FRQ example from start to finish. The demo shows how Cramapple helps a student answer, submit, and see criterion-level feedback.
```

### Demo layout

- Left side or top: FRQ prompt card.
- Center: answer box with a typing animation or short looping replay of an answer being entered.
- Primary action inside the demo: `Submit answer`.
- Right side or below: graded response card that appears after submit.
- Include a small label that makes the demo state clear, such as `Demo replay` or `Sample FRQ`.

### Rotation

Rotate through 3 FRQ examples in a loop.

Each example should include:

- a short AP Biology FRQ prompt;
- a typed answer animation or scripted typing replay;
- a submit moment;
- a graded response summary;
- at least one criterion-level note;
- a small highlighted next step.

The rotation should support:

- manual previous/next controls;
- pause/play;
- reduced-motion fallback;
- keyboard access.

If animation is used, prefer a lightweight frontend animation or controlled replay state rather than a heavy video asset. If you use a GIF, keep it short, subtle, and clearly labeled as demo content.

## FRQ Demo Content

Use original AP Biology-style prompts only. Do not copy College Board content.

Suggested rotation set:

### FRQ 1

Topic: experimental design

Prompt idea:

```text
A student investigates whether light intensity affects photosynthesis rate in aquatic plants. Explain how the student should design the experiment and identify one control variable that must stay constant.
```

Graded response highlight:

- identifies the manipulated variable;
- names a valid control variable;
- explains why the control matters;
- next step: add the mechanism or evidence connection.

### FRQ 2

Topic: cell communication

Prompt idea:

```text
Explain how a signal received at a cell membrane can lead to a change in gene expression inside the cell.
```

Graded response highlight:

- receptor binding;
- signal transduction;
- response in the nucleus;
- next step: add the missing pathway detail.

### FRQ 3

Topic: inheritance and population genetics

Prompt idea:

```text
In a small population, a random event sharply reduces the number of individuals. Explain how this affects allele frequency and genetic diversity over time.
```

Graded response highlight:

- identifies genetic drift or bottleneck effect;
- explains random allele loss;
- connects to reduced diversity;
- next step: strengthen the causal chain.

## Copy

Use concise, credible copy that matches the rest of the site.

Suggested supporting lines:

```text
Try a sample FRQ to see how Cramapple works.
```

```text
Answer, submit, and see what Cramapple says the response earned.
```

```text
Three examples rotate here so you can see the experience without starting a session.
```

### Demo labels

Use one of these labels near the module:

- `Demo`
- `Sample session`
- `Rotating preview`

Do not imply the demo is a live score report or a validated grader.

## Visual Direction

- Warm off-white page background.
- Deep green primary accents.
- White or cream cards with clear borders.
- Calm academic tone.
- Strong typography and clear spacing.
- Mobile-first responsive layout.
- No chat bubbles.
- No fake dashboard treatment.
- No excessive motion.

The demo should feel like a serious product preview, not a social-media reel.

## Accessibility

- Full keyboard operation.
- Visible focus states.
- Semantic headings and button labels.
- Screen-reader text for the current demo step.
- Reduced-motion support.
- No auto-advancing motion that cannot be paused.
- Reflow cleanly at 390px width.

## Forbidden Behavior

- Do not change the How It Works page in this prompt.
- Do not make the demo interactive with real question submission.
- Do not collect user text in the demo module.
- Do not copy official College Board content.
- Do not imply official scoring, mastery, or guaranteed improvement.
- Do not hide the homepage hero CTA behind the demo.
- Do not use the demo section to request login.
- Do not call OpenAI from the browser.
- Do not add backend writes for grading truth, model usage, or learner records.
- Do not create a carousel that looks like the review portal.

## QA Expectations

Verify:

1. The homepage still clearly presents the main call to action.
2. The demo section appears as an obvious preview, not as a live session.
3. Three FRQ examples rotate cleanly.
4. The submit moment and graded response are easy to follow.
5. The demo is usable with keyboard and reduced-motion settings.
6. The layout remains calm and readable on mobile.
7. No protected content or official College Board text is used.

## Implementation Notes

- Use local frontend state only.
- Keep the demo content in a small typed configuration object.
- Reuse the site’s existing visual language.
- If the homepage already has a hero section, place this demo immediately below it.
- Keep the section modular so later work can swap in real rendered FRQ examples or richer motion.

