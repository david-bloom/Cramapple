# Lovable Fix - Physics And Precalculus Units, Topics, Briefs

## Situation

AP Biology now renders units, topics, point briefs, and Learn More correctly.
AP Precalculus and all AP Physics subjects still do not.

This is a frontend wiring issue, not missing backend content.

Codex verified Production Supabase on 2026-08-21:

| Subject | Units | Topics | Published briefs | Published explainers |
| --- | ---: | ---: | ---: | ---: |
| AP Precalculus | 4 | 44 | 29 | 29 |
| AP Physics 1 | 8 | 43 | 10 | 10 |
| AP Physics 2 | 7 | 46 | 14 | 14 |
| AP Physics C: Mechanics | 7 | 41 | 10 | 10 |
| AP Physics C: E&M | 6 | 31 | 10 | 10 |

Production RPC smoke tests also pass for all five subjects:

- `public.get_student_taxonomy(subject_key)` returns the expected units/topics.
- `public.get_topic_point_guides(subject_key, unit_number, topic_code)` returns
  one brief and one explainer for known covered topics.

## Required Data Flow

Use the authenticated Supabase client. Do not use static AP Biology data,
hardcoded unit arrays, or frontend-generated topic lists.

### 1. Fetch Units And Topics From Supabase

For the active subject, call:

```ts
const { data, error } = await supabase.rpc("get_student_taxonomy", {
  _subject_key: activeSubjectKey,
});
```

The payload shape is:

```ts
type StudentTaxonomyPayload = {
  subjects: Array<{
    subjectKey: string; // canonical, e.g. "ap_precalculus"
    displayName: string;
    units: Array<{
      unitNumber: number;
      unitTitle: string;
      isExamAssessed: boolean;
      topics: Array<{
        topicCode: string;
        topicTitle: string;
        hasPointBrief: boolean;
        hasExplainer: boolean;
      }>;
    }>;
  }>;
};
```

Render unit tabs and topic chips from `data.subjects[0].units`.

Do not assume unit numbering starts at 1 or that all subjects have Unit 3
briefs. Use the unit numbers returned by the RPC.

### 2. Fetch Briefs And Learn More From Supabase

When a subject/unit/topic is selected, call:

```ts
const { data, error } = await supabase.rpc("get_topic_point_guides", {
  _subject_key: activeSubjectKey,
  _unit_number: selectedUnit.unitNumber,
  _topic_code: selectedTopic.topicCode,
});
```

Render from:

```ts
const brief = data?.briefs?.[0] ?? null;
const explainer = data?.explainers?.[0] ?? null;
```

Point brief card fields:

- `brief.whatItIs`
- `brief.whyItMatters`
- `brief.howPointsAreEarned`
- `brief.answerMove`
- `brief.commonPointLoss`
- `brief.classImportance`
- `brief.examImportance`

Learn More fields:

- `explainer.coreIdea`
- `explainer.whatStudentsNeedToUnderstand`
- `explainer.howThisBecomesPoints`
- `explainer.answerMove`
- `explainer.miniExample.question`
- `explainer.miniExample.weakAnswer`
- `explainer.miniExample.pointAttainingAnswer`
- `explainer.commonPointLoss`
- `explainer.practiceBridge`

## Subject Key Rules

The backend accepts either hyphen or underscore keys for these subjects:

| UI/registry key | Canonical key returned by RPC |
| --- | --- |
| `ap-precalculus` | `ap_precalculus` |
| `ap-physics-1` | `ap_physics_1` |
| `ap-physics-2` | `ap_physics_2` |
| `ap-physics-c-mechanics` | `ap_physics_c_mechanics` |
| `ap-physics-c-em` | `ap_physics_c_em` |

Do not pass display names such as `"AP Physics 1"` or `"AP Precalculus"` into
the RPC. Store and pass the stable subject key from app state.

## Critical Unit Number Edge Cases

These subjects do not all use Unit 1 / Unit 2 / Unit 3 in the same way:

| Subject | First unit | Covered brief units currently seeded |
| --- | ---: | --- |
| AP Precalculus | 1 | Units 1 and 3 |
| AP Physics 1 | 1 | Units 1 and 3 |
| AP Physics C: Mechanics | 1 | Units 1 and 3 |
| AP Physics 2 | 9 | Units 9 and 11 |
| AP Physics C: E&M | 8 | Units 8 and 10 |

Therefore:

- Do not create UI unit ids by array index.
- Do not call `get_topic_point_guides(..., 1, ...)` for Physics 2 unless the
  selected RPC-returned unit is actually 1. Physics 2 starts at Unit 9.
- Do not call `get_topic_point_guides(..., 1, ...)` for Physics C: E&M. It
  starts at Unit 8.
- Do not remap displayed unit numbers to zero-based or local sequential
  numbers. Use `unit.unitNumber` exactly as returned.

## Likely Bugs To Remove

Search for and remove/fix these patterns:

- AP Biology route has a special working path, while other subjects use static
  fallback data.
- Unit/topic data comes from local constants instead of `get_student_taxonomy`.
- Subject selection uses display labels instead of stable keys.
- The code filters by `subject_key` on public views while holding canonical
  underscore keys. Prefer RPCs.
- The code assumes every subject has Unit 1 topic briefs.
- The code assumes every subject's "Unit 3" is the third array item.
- The fallback "Point brief coming soon" renders while RPC calls are still
  loading, after errors, or before auth is ready.
- Topic lookup uses slugs or generated ids instead of exact `topicCode`.

## Required Smoke Tests

Run these in the logged-in app, using the same Supabase client the UI uses.
Each must return one subject for taxonomy and one brief/one explainer for the
guide call.

```ts
await supabase.rpc("get_student_taxonomy", {
  _subject_key: "ap-precalculus",
});

await supabase.rpc("get_topic_point_guides", {
  _subject_key: "ap-precalculus",
  _unit_number: 3,
  _topic_code: "3.1",
});

await supabase.rpc("get_student_taxonomy", {
  _subject_key: "ap-physics-1",
});

await supabase.rpc("get_topic_point_guides", {
  _subject_key: "ap-physics-1",
  _unit_number: 3,
  _topic_code: "3.1",
});

await supabase.rpc("get_student_taxonomy", {
  _subject_key: "ap-physics-2",
});

await supabase.rpc("get_topic_point_guides", {
  _subject_key: "ap-physics-2",
  _unit_number: 11,
  _topic_code: "11.1",
});

await supabase.rpc("get_student_taxonomy", {
  _subject_key: "ap-physics-c-mechanics",
});

await supabase.rpc("get_topic_point_guides", {
  _subject_key: "ap-physics-c-mechanics",
  _unit_number: 3,
  _topic_code: "3.1",
});

await supabase.rpc("get_student_taxonomy", {
  _subject_key: "ap-physics-c-em",
});

await supabase.rpc("get_topic_point_guides", {
  _subject_key: "ap-physics-c-em",
  _unit_number: 10,
  _topic_code: "10.1",
});
```

Expected assertions:

```ts
expect(taxonomy.error).toBeNull();
expect(taxonomy.data.subjects).toHaveLength(1);
expect(taxonomy.data.subjects[0].units.length).toBeGreaterThan(0);
expect(taxonomy.data.subjects[0].units[0].topics.length).toBeGreaterThan(0);

expect(guides.error).toBeNull();
expect(guides.data.briefs).toHaveLength(1);
expect(guides.data.explainers).toHaveLength(1);
```

## Acceptance Criteria

- AP Precalculus renders unit tabs from Supabase and shows topics.
- AP Precalculus Unit 3 Topic 3.1 shows a real point brief and Learn More.
- AP Physics 1 renders unit tabs from Supabase and shows topics.
- AP Physics 1 Unit 3 Topic 3.1 shows a real point brief and Learn More.
- AP Physics 2 renders Unit 9 through Unit 15, not Unit 1 through Unit 7.
- AP Physics 2 Unit 11 Topic 11.1 shows a real point brief and Learn More.
- AP Physics C: Mechanics renders unit tabs from Supabase and shows topics.
- AP Physics C: Mechanics Unit 3 Topic 3.1 shows a real point brief and Learn More.
- AP Physics C: E&M renders Unit 8 through Unit 13, not Unit 1 through Unit 6.
- AP Physics C: E&M Unit 10 Topic 10.1 shows a real point brief and Learn More.
- The browser network panel shows calls to:
  - `/rest/v1/rpc/get_student_taxonomy`
  - `/rest/v1/rpc/get_topic_point_guides`
- No topic-guide surface uses hardcoded AP Biology-only data.
- "Point brief coming soon" appears only after a successful guide RPC returns
  zero matching briefs.

## Do Not Change

- Do not write topic-guide content from the frontend.
- Do not query private `app.*` tables from Lovable.
- Do not weaken RLS.
- Do not grant anonymous access.
- Do not duplicate Supabase topic/brief content into frontend constants.
