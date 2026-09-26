# Student Home Design Handoff — 2026-09-26

## Current task

Define the next visual direction for the logged-in Cramapple Student Home and prepare the design intent for a Lovable mockup. This session was product/design planning only; no frontend, backend, schema, routing, or production changes were made.

## What changed this session

The Home direction was tightened from a broad dashboard concept into a smaller number of visual systems.

### Core product hierarchy

The Home should answer, primarily through visual hierarchy:

1. Where am I?
2. What should I do next?
3. How am I doing?

The page should feel like a personalized study cockpit, not a reporting dashboard.

### Dominant visual hierarchy

Use three visual layers:

1. **Steering** — subject context, exam countdown, and one dominant Next Best Action.
2. **Map** — curriculum location/navigation plus honest evidence/progress states.
3. **Ambient intelligence** — compact momentum, opportunity, workload, independence, deep-dive, resume, and message signals.

The **Next Best Action is the true hero**. The curriculum map is the strong secondary visual backbone, not a co-hero.

### Color and motivation

The Home must use the Cramapple palette range as information architecture, not decoration.

Color and shape should communicate:
- current/recommended;
- strong evidence;
- developing;
- opportunity;
- little evidence;
- not yet reached.

Do not rely on color alone. Pair state color with fill, outline, shape, iconography, or position.

Every major visual should communicate **direction, progress, or next opportunity**, not merely current state. Motivation should come from visible movement such as:
- accuracy trend improving;
- fewer hints needed;
- a unit moving to a stronger evidence state;
- recent FRQ points earned;
- reachable next milestone.

Avoid generic streak mechanics and avoid making low activity itself the definition of success.

### Multi-subject model

For students with multiple purchased subjects:
- keep one active subject as the main Home context;
- do not blend mastery/performance into one cross-subject score;
- add a compact whole-student workload signal so a student is not falsely framed as inactive because effort shifted to another subject;
- subject switching should be immediate;
- promotions to add subjects should live in/near the subject switcher, not compete with study actions.

### Exam countdown

Days until the official AP exam should be persistently visible near subject context. It is orientation, not the hero, and should not become an anxiety mechanic.

### Curriculum map

The map should be a signature visual and support:
- current class position;
- easy backward/forward movement;
- unit/topic navigation;
- evidence/no-evidence states immediately;
- stronger mastery/readiness states only when backend evidence supports them.

Do not create a visually persuasive heatmap that invents certainty.

### Coverage, performance, mastery

These should remain distinct concepts in the model but should not become three large labeled gauges on Home.

Suggested visual mapping:
- coverage -> course-map fill/state;
- performance -> small trend/points/accuracy signal;
- mastery/readiness -> state marker only where evidence is defensible.

### Momentum / motivation

Use compact ambient visuals rather than KPI cards:
- accuracy trend / sparkline;
- recent improvement;
- questions answered;
- study time;
- independence trend.

Hint use should be framed as independence (e.g. less help needed), not raw hint counts.

### Growth opportunities

Show a small number of actionable opportunities, preferably including cross-topic skills or point-loss behaviors (for example experimental design or FRQ specificity), not only weak curriculum units.

These should have a different visual grammar from curriculum nodes and deep-dive content cards.

### Deep dives

Include a visually browseable shelf/library for quick skims and student-controlled exploration.

Examples:
- cell respiration in 5 minutes;
- experimental controls;
- Hardy-Weinberg refresher;
- what earns the FRQ point;
- common graph mistakes.

Deep dives are distinct from Next Best Action:
- NBA = Cramapple recommendation;
- Deep Dives = student-controlled exploration.

### Resume / recent work

If an unfinished session exists, Resume may temporarily replace the normal NBA hero. Otherwise recent activity should stay heavily demoted and detailed history should remain on Progress.

### Messages / alerts / promotions

Use a small subordinate message slot. Never default to a full-width promotional banner.

Academic alerts may be stronger than promotions. Promotions should preferably appear inside the subject-switching context.

### Experience stages

The Lovable mock should render the same design system in three separate states:

1. **New** — subject, countdown, class position, course map, first calibration/diagnostic; no fake empty analytics.
2. **Building evidence** — early NBA, partial map evidence, cautious trend signal.
3. **Personalized** — full NBA, meaningful evidence map, momentum, growth opportunity, independence, personalized deep dives.

The purpose is to prove that the interface grows gracefully with evidence rather than only designing the mature state.

## Claude second-opinion incorporated

The following critique was accepted and incorporated:
- reduce first-class regions;
- make NBA the sole hero;
- keep visual state encoding understandable with micro-labels / legend / first-use guidance;
- mock all three evidence stages;
- enforce distinct visual treatments for curriculum, growth opportunities, and deep dives;
- specify message placement so builders do not default to a full-width banner.

One modification: the exam countdown remains persistent context, not one of the three dominant visual sections.

## Feature viability summary

High / near-term viable:
- exam countdown;
- subject switching;
- current class position;
- curriculum structure/navigation;
- accuracy trend;
- study time;
- questions answered;
- resume;
- messages/alerts.

High value but dependent on honest evidence / logic:
- Next Best Action sophistication;
- mastery/readiness states;
- growth-opportunity detection;
- independence/hint telemetry.

Design now, instrument/build progressively:
- cross-topic opportunity detection;
- assisted-vs-independent answer model;
- next-state milestone messaging;
- personalized deep-dive ordering.

## Open questions

- Exact state vocabulary and palette mapping under the current canonical design system.
- Whether “mastery” is the right student-facing label versus a softer evidence/readiness term.
- Evidence thresholds required before a unit/topic may display a strong/developing/opportunity state.
- Exact structure of hint telemetry needed for an independence signal.
- Exact cross-subject workload treatment in the subject switcher.
- Whether deep dives are backed by existing topic explainers or require a distinct content object.
- Where the compact message slot lives on desktop and mobile.

## Risks / do not touch

- Do not invent mastery, readiness, or progress states for visual completeness.
- Do not merge cross-subject academic performance into one score.
- Do not let activity/streak metrics become the primary motivational mechanism.
- Do not turn every concept into a card or section.
- Do not implement backend/schema/production changes from this design session without a separately approved task.

## Files and systems checked

Canonical Cramapple:
- `docs/team_charter/CRAMAPPLE_SESSION_START.md`
- `docs/product/CRAMAPPLE_VISION.md`
- `prompts/CLOSE_SESSION_PROMPT.md`
- existing Home/Progress task and product references via GitHub search.

Frontend reference (read earlier in the session):
- `exam-buddy-wireframe/src/components/home/HomeV2.tsx`
- `exam-buddy-wireframe/src/components/home/TopicHome.tsx`
- `exam-buddy-wireframe/src/routes/_ux.progress.tsx`

## Verification

No code, data, schema, environment, or production changes were made.

The only durable change for this session is this handoff document on branch:
`chatgpt/student-home-design-handoff`.

## Approval state

This is a design handoff / working direction, not a final approved product specification. No hard gate was crossed. Product Owner review remains required before treating the design direction as an approved implementation specification.

## Exact next step

**Next owner: David / Lovable design pass.**

Use this handoff plus the current Cramapple design system to create a responsive Student Home mock with three frames (New, Building Evidence, Personalized). The first review should focus on:
1. hierarchy;
2. use of color as information;
3. motivation through visible movement;
4. density;
5. whether the Home still answers “where am I / what next / how am I doing” within seconds.

Do not wire new backend logic in the mockup pass.
