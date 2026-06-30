# Cramapple Visual Identity Brief — v2

Status: Working draft. Evolved from v1 (`CRAMAPPLE_VISUAL_IDENTITY_BRIEF.md`) to address feedback that v1 landed too cold/clinical. The green direction is confirmed; this version shifts toward warmth and visual richness.

Deliverable order: **voice → typography → color → fonts → logo/wordmark.**

## What changed from v1

v1 resolved the right tensions (tech-category not edtech, precision over encouragement, web-first/dark-friendly, wordmark-led mark). What it got wrong: leaning too hard into Chrome/terminal aesthetics made the product feel cold, stark, and severe. "Precision" doesn't require coldness. The student is stressed, not a sysadmin. v2 corrects this — same structural decisions, warmer execution.

## Overview

Cramapple is an AI-native AP exam prep system. It identifies and drives students down the highest-yield path to the best possible score in the least time. One-time purchase. Launches summer 2026, major GTM push winter 2026 ahead of spring 2027 exams. Not a course, not a tutor replacement, not gamified — it optimizes one thing: points on the exam.

## Audience

Primary user and buyer: AP student (rising 10th–12th grade), leaning female-majority, wants to move a 3 to a 4 or a 4 to a 5. Uses the product at a desk, late at night, likely alone, with real time pressure. Wants precision and efficiency — but this student is a person, not a user-agent, and the product should feel like something she's glad she opened.

Secondary buyer: parent (40–55). Inherits the student-facing identity — trust is earned through precision and results, not a separate "credibility" visual register.

**Usage context:** Web-first, desktop, late night. Contrast and legibility are hard requirements. Warm color choices can and should be dark-mode-friendly without being cold.

## Competitive Lane

Every competitor (Fiveable, Albert.io, Khan Academy, Kaplan) is visually coded as either education-warm (teacher/classroom tropes) or utility-cold (institutional test-prep blue, generic SaaS dashboard). Neither is right.

Cramapple's lane: **warm precision** — beautiful and trustworthy, not clinical and not cozy. A product the student is glad she has, not one that feels like homework.

## Vibe

> Warm precision. The quiet confidence of a product that knows exactly what it's doing — closer to Arc or Craft than to Chrome or a terminal. It respects the student's intelligence and her time. It earns trust through accuracy, not aesthetic severity.

The brand holds calm in the face of urgency — still never manufactures more. But "calm" in v2 is warm and human, not cold and clinical. There's a person behind the screen at 11pm who just needs to know what to fix before the exam.

## Style References

**Primary — warm premium tech (v2 additions/shifts):**
- **Arc Browser** — warm, beautiful, product-forward without being decorative; feels like someone cared about every pixel
- **Craft** — editorial warmth, typographic precision, premium feel; proves functional tools don't have to be cold
- **Notion** — warm off-white surfaces, editorial hierarchy, confident but not severe

**Supporting — still relevant from v1:**
- **Apple** — restrained palette, product-led, earns authority through craft; Apple's warmth (amber, cream, linen) is available to draw from
- **Instagram** — aspirational, geometric mark, premium; color discipline

**Stature-only, not style (unchanged from v1):**
Khan Academy, Quizlet, Duolingo — how important Cramapple should be to a student's life; not visual references.

**Anti-references:**
- Cold/terminal aesthetics — pure black background, neon signal green, monospace energy (where v1 was drifting)
- Fiveable's bouncy Gen-Z edtech
- Classroom/teacher/school-supply iconography
- Kaplan/Princeton Review institutional blue

## Voice (v2 — slightly warmer delivery, same precision standard)

Precise, direct, and human. Like a very sharp tutor who respects your intelligence and your time — not a cheerleader, not a machine.

- Speaks with earned warmth, not performed enthusiasm
- Still honest about gaps: *"Criterion 3 is worth 2 points and you're currently getting 0. Here's the exact fix."* — no softening the truth, but delivered as a guide who's on your side
- Acknowledges the student is a person: efficient doesn't mean cold
- Never condescending, never excited for no reason

**Use:** precise, clear, direct, grounded, human.
**Avoid:** clinical, robotic, hype, exclamation-heavy, warm-fuzzy-teacher.

## Typography

- **Primary typeface: Plus Jakarta Sans** — geometric, warm, expressive at display sizes without losing precision at body sizes. Load weights 400, 500, 600, 700 via Google Fonts.
- **Monospace accent: JetBrains Mono** (400, 500) — used exclusively for student-written FRQ answers. Creates a clear semantic break between system voice (Plus Jakarta Sans) and student voice (mono). Reinforces that the tool is evaluating what the student actually wrote.
- Weight usage: 400 body, 500 label/secondary, 600 wordmark and UI emphasis, 700 score display numbers only.
- Tracking: wordmark at −0.015em; uppercase labels at +0.06em; all other uses default.
- Web/desktop-first: generous line-height (1.65 body, 1.0 display), comfortable sizes for long sessions.

## Color

The direction is **warm forest/emerald green** — a step away from the cold signal-green of v1 toward a green with life and warmth in it (emerald, forest, sage register rather than terminal/neon).

**Key principles:**
- Tinted backgrounds rather than pure black/white. A near-black with a faint green tint (`#0C1209`) reads warmer than pure `#0A0A0A`. A near-white with a faint green tint (`#FAFEF5`) reads warmer than pure `#FFFFFF`.
- The accent reads as a living color (emerald, not neon) — more forest than signal.
- Two-token system: dark-bg accent (`#36D47D`) and light-bg accent (`#1A8A4A`) — same hue family, different weight for contrast compliance on each surface.
- Secondary accent (gold/amber, strictly semantic): used **only** when a student earns full marks on any scoreable unit — a criterion at max (4/4, 3/3, 2/2, 1/1, 5/5, etc.) or a correct MCQ. The trigger is "full marks on this item," not any specific point value. When triggered: the progress bar (fully filled), score number, card left-border, and status label all shift to gold. On a correct MCQ, the answer highlight and confirmation indicator shift to gold. Never used decoratively, never used for partial scores. Gold means "you got this one" — nothing else. Suggested tokens: dark-mode `#F5B942`, light-mode `#C17A10`.

**Built for late-night, at-a-desk use:** dark-first by default. Warm tinted darks are easier on the eyes than cold pure-black surfaces.
**Contrast:** WCAG AA minimum built into the core token system.

## Logo / Wordmark

Designed after the above is settled. Decisions carried from v1:
- Abstract/geometric mark, used sparingly (browser tab, small lockup companion)
- Wordmark-led, not icon-led — web product, not mobile app icon
- Inter weight 600, tight tracking — confirmed warmer than the 800-weight v1 used
- Mark: two options still open from the last session — (A) faceted polygon silhouette (faint apple echo, no leaf/stem), (B) fully abstract open-ring (no literal apple reference). The warmer palette makes both options feel less severe; (A) likely benefits more from the warmer direction since its geometric softness becomes more legible in warm context.

## Visual Anti-Patterns (v2 updates)

- No cold/terminal aesthetic — pure black backgrounds, signal-green neon, monospace visual language
- No classroom/teacher/school-supply iconography
- No mascots, no gamification elements
- No "rainbow of fun" multi-accent palettes
- No manufactured urgency devices
- No encouraging-teacher copy tone
- **New in v2:** No clinical severity for its own sake — warmth is not a compromise of precision, and the identity should reflect that

## Anti-Information (unchanged)

Cramapple is not: a complete AP course, a teacher replacement, a general-purpose chatbot, a homework answer generator, a guaranteed score outcome, an official College Board product, or a live tutoring marketplace in MVP.
