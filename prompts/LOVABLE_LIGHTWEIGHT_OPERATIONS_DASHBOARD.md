# Lovable Build Brief - Lightweight Operations Dashboard

Build a lightweight, frontend-only Cramapple dashboard for operational tracking.
The goal is to give the team a quick read on:

- subjects in the pipeline;
- questions in the pipeline by type; and
- student engagement signals; and
- grading speed, cost, and quality.

Do not include revenue, pricing, funnel, acquisition, or marketing metrics in
this version. Those are explicitly later.

Keep this dashboard calm, useful, and sparse. It should feel like an internal
operating surface, not a sales dashboard or a dense admin console.

## Goal

Create a compact dashboard that helps the team answer three questions at a
glance:

1. Which subjects are active and how far along are they?
2. What question inventory is moving through the pipeline, broken out by type?
3. Are students using the product and returning to it?
4. How fast, expensive, and reliable is grading by subject and question?

## Routes

```text
/prototype/dashboard
/prototype/dashboard/subjects
/prototype/dashboard/pipeline
/prototype/dashboard/engagement
/prototype/dashboard/quality
```

If a route already exists for internal operations, reuse the existing layout
language and add these dashboard sections rather than creating a separate visual
system.

## Page Behavior

### Dashboard Home

Show a simple three-column or card-based overview with:

- active subjects;
- question pipeline by type;
- student engagement;
- grading quality and speed;
- a small "needs attention" list for stalled or low-coverage areas.

The first screen should answer "what needs attention right now?" without
requiring navigation.

### Subjects View

Show each subject as a card or row with:

- subject name;
- pipeline status;
- content coverage progress;
- grading p50 time;
- grading p90 time;
- grading p99 time;
- cost per answer;
- rubric agreement rate;
- open blockers or missing pieces;
- latest update timestamp.

Keep the metric set small. Use counts, not heavy analytics.

### Pipeline View

Show question inventory by type:

- MCQ;
- short FRQ;
- long FRQ;
- investigative task;
- student-provided question intake items;
- review queue items.

For each type, show:

- total in pipeline;
- drafted;
- in review;
- approved;
- blocked;
- ready to ship.

For each type, also show:

- grading p50 time;
- grading p90 time;
- grading p99 time;
- cost per answer;
- rubric agreement rate.

### Engagement View

Show a lightweight student engagement snapshot using operational metrics such as:

- active students;
- sessions started;
- sessions completed;
- attempts per active student;
- return rate over a recent time window;
- time spent in session buckets;
- weekly trend.

Use simple trends, sparklines, or compact bars rather than elaborate charts.
Avoid any claim of learning mastery or score prediction.

### Quality View

Show grading reliability by subject and question type using compact tables or
cards. In this dashboard, grading quality means rubric agreement rate.

For each subject, show:

- grading p50 time;
- grading p90 time;
- grading p99 time;
- average cost per answer;
- rubric agreement rate.

For each question type, show the same metrics where available so the team can
spot slow or unreliable formats.

If a metric is unavailable, show `N/A` instead of inventing a substitute.

## Backend Calls

The source of truth for this dashboard is read-only operational summary data:

- approved summary queries;
- approved Supabase views or aggregation endpoints;
- existing internal analytics fixtures when no live summary source is approved.

Use frontend fixtures for the first version if no approved summary API exists.
If read-only data is available, only consume approved summary sources.

Allowed sources, if already present:

- read-only summary queries;
- approved Supabase views or aggregation endpoints;
- existing internal analytics fixtures.

Forbidden:

- any client-side write to operational truth;
- direct writes to subject status or content state;
- any purchase, entitlement, payment, or marketing write.

## States

Handle these states cleanly:

- loading;
- empty;
- partial data;
- stale data;
- error;
- no recent student activity.

If data is missing, say so plainly. Do not fabricate numbers or hide empty
states.

## Copy

Use straightforward operational copy:

- "Subjects in pipeline"
- "Questions by type"
- "Student engagement"
- "Needs attention"
- "Ready to ship"
- "Blocked"
- "In review"

Keep the tone practical and internal. Avoid sales language.

## Forbidden Behavior

- Do not include revenue, margin, conversion, CAC, or marketing attribution.
- Do not include acquisition funnels, campaign tracking, or ad performance.
- Do not present grading quality as student mastery or business revenue.
- Do not present engagement as mastery or learning outcome proof.
- Do not write to backend truth fields from the client.
- Do not introduce a full BI dashboard pattern or heavy chart wall.

## QA Expectations

- The dashboard loads with a useful summary even when only partial data is
  available.
- The three focus areas are visible without extra clicks on desktop.
- The grading-quality metrics are visible by both subject and question type.
- Mobile layout remains readable and compact.
- Empty states explain what is missing and what the user can do next.
- Revenue and marketing concepts are absent from the first release.
- The layout feels operational, not promotional.

## Design Direction

- Use a quiet, high-contrast interface with restrained color.
- Keep cards and tables compact.
- Prefer readable counts and status tags over decorative charts.
- Use one accent color for healthy state and one warning color for blocked
  state.
- Keep the page fast to scan.
