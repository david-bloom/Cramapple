# Lovable Build Prompt - Cramapple Homepage Demo FRQ

Build a polished, responsive homepage section for **Cramapple** that shows the product in action with a rotating FRQ demo. This is for the public landing page only.

This prompt is only for the homepage demo experience. Do not change the How It Works page, intake flow, or the student session routes.

## Goal

Add a homepage module that helps visitors understand Cramapple immediately by showing:

1. An FRQ prompt from one of Cramapple's published subjects.
2. A typed answer appearing in the answer box.
3. The submit action being pressed.
4. The graded response appearing next.
5. Rotation through 4 FRQ examples, alternating between AP Biology and AP Statistics.

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
Watch a short FRQ example from start to finish. The demo shows how Cramapple helps a student answer, submit, and see criterion-level feedback — across subjects.
```

### Demo layout

- Left side or top: FRQ prompt card.
- Center: answer box with a typing animation or short looping replay of an answer being entered.
- Primary action inside the demo: `Submit answer`.
- Right side or below: graded response card that appears after submit.
- Include a small label that makes the demo state clear and names the current subject, e.g. `Sample AP Biology FRQ` or `Sample AP Statistics FRQ` — derive this from the current example's `subject` field, not a fixed string. Do not hardcode the label to `Sample FRQ` or to any single subject.

### Rotation

Rotate through 4 FRQ examples in a loop, alternating subjects (AP Biology, AP Statistics, AP Biology, AP Statistics) so a visitor sees both subjects within one full loop.

Each example should include:

- a `subject` field (`AP Biology` or `AP Statistics`) that drives the demo label described above;
- a short FRQ prompt in that subject's style;
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

Use original prompts in the style of each subject's exam. Do not copy College Board content for either subject.

Suggested rotation set (alternate subjects in this order):

### FRQ 1 — AP Biology

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

### FRQ 2 — AP Statistics

Topic: random assignment in experimental design

Prompt idea:

```text
A researcher wants to know whether a new study technique improves quiz scores. Explain why students should be randomly assigned to the new technique or the old technique, rather than letting them choose which one to use.
```

Graded response highlight:

- identifies random assignment as the key design element;
- explains that it balances confounding variables between groups;
- connects it to supporting a cause-and-effect conclusion;
- next step: add why this couldn't be concluded from an observational study alone.

### FRQ 3 — AP Biology

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

### FRQ 4 — AP Statistics

Topic: confidence interval interpretation

Prompt idea:

```text
A pollster reports a 95% confidence interval of (0.42, 0.50) for the proportion of voters who support a proposal. Explain what this interval means.
```

Graded response highlight:

- avoids saying there is a 95% probability the true proportion falls in this exact interval;
- ties the confidence level to the method's long-run reliability across many samples;
- states the interval estimates the population proportion, not any single voter's chance;
- next step: connect margin of error to sample size.

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
Examples rotate between AP Biology and AP Statistics so you can see the experience without starting a session.
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
3. All 4 FRQ examples rotate cleanly, alternating AP Biology and AP Statistics.
4. The demo label updates to name the correct subject for each example (no leftover hardcoded `Sample FRQ` or fixed-subject string).
5. The submit moment and graded response are easy to follow.
6. The demo is usable with keyboard and reduced-motion settings.
7. The layout remains calm and readable on mobile.
8. No protected content or official College Board text is used for either subject.

## Implementation Notes

- Use local frontend state only.
- Keep the demo content in a small typed configuration array, one object per example, each with a `subject` field (`AP Biology` | `AP Statistics`) alongside the existing prompt/answer/graded-response fields. The demo label and any subject-specific styling should read from `subject`, not be hardcoded.
- Reuse the site’s existing visual language.
- If the homepage already has a hero section, place this demo immediately below it.
- Keep the section modular so later work can add more subjects by appending to the configuration array, without touching the rotation, label, or layout logic.

