# Lovable Brief - Wire Topic Point Briefs And Learn More Content

## How To Use This File

Give this entire file to Lovable as the implementation prompt.

The Cramapple app currently renders the subject/unit/topic taxonomy, but the
selected topic card still says "Point brief coming soon." Production data is
present and verified. This is a frontend wiring issue, not a missing-content
issue.

If any instruction below conflicts with an existing mock-data fallback, follow
this file.

---

## Goal

Make the topic detail card and Learn More action use live Supabase topic-guide
content for the selected subject, unit, and topic.

The selected AP Biology Unit 1 Topic 1.1 screen must show the real point brief:

```text
Water is a polar molecule. Its uneven charge distribution allows water molecules
to form hydrogen bonds with each other and with other polar or charged
substances.
```

It must not show:

```text
Point brief coming soon.
```

---

## Data Source

Use Production Supabase:

```text
VITE_SUPABASE_URL=https://pcntajvbdfqhbeewmdry.supabase.co
```

Use the app's existing authenticated Supabase client. The topic-guide surfaces
are authenticated-only by design. Do not try to make anonymous reads work.

Primary data access path:

```ts
const { data, error } = await supabase.rpc("get_topic_point_guides", {
  _subject_key: selectedSubjectKey,
  _unit_number: selectedUnitNumber,
  _topic_code: selectedTopicCode,
});
```

The RPC accepts either student-facing keys such as `biology` / `ap-statistics`
or canonical keys such as `ap_biology` / `ap_statistics`. Prefer passing the
currently selected subject key from the app state. Do not manually convert
hyphens and underscores unless needed for a local lookup map.

Expected payload shape:

```ts
type TopicGuidesPayload = {
  subjectKey: string;
  unitNumber: number | null;
  topicCode: string | null;
  briefs: TopicPointBrief[];
  explainers: TopicExplainer[];
};

type TopicPointBrief = {
  subjectKey: string;       // canonical, e.g. "ap_biology"
  unitId: string;           // e.g. "unit-1"
  unitNumber: number;       // e.g. 1
  topicId: string;          // e.g. "1.1"
  topicCode: string;        // e.g. "1.1"
  title: string;
  classImportance: "not-important" | "somewhat-important" | "very-important";
  examImportance: "not-important" | "somewhat-important" | "very-important";
  whatItIs: string;
  whyItMatters: string;
  howPointsAreEarned: string;
  answerMove: string;
  commonPointLoss: string;
  learnMorePath: string;
  practiceParams: {
    subject: string;        // canonical, e.g. "ap_biology"
    unit: string;           // e.g. "1"
    topic: string;          // e.g. "1.1"
  };
};

type TopicExplainer = {
  subject: string;
  subjectKey: string;
  unitId: string;
  unitNumber: number;
  topicId: string;
  topicCode: string;
  title: string;
  coreIdea: string;
  whatStudentsNeedToUnderstand: string;
  howThisBecomesPoints: string;
  answerMove: string;
  miniExample: {
    question: string;
    weakAnswer: string;
    pointAttainingAnswer: string;
  };
  commonPointLoss: string;
  practiceBridge: string;
};
```

Fallback direct-read path, only if the RPC is awkward in the current code:

```ts
const { data: briefs, error } = await supabase
  .from("topic_point_briefs")
  .select("*")
  .eq("canonical_subject_key", canonicalSubjectKey)
  .eq("unit_number", selectedUnitNumber)
  .eq("topic_id", selectedTopicCode)
  .order("topic_sort_key");
```

For direct public-view reads, note the key distinction:

- `subject_key` is student-facing/registry-facing, e.g. `biology`,
  `ap-statistics`, `ap-physics-1`.
- `canonical_subject_key` is app-content-facing, e.g. `ap_biology`,
  `ap_statistics`, `ap_physics_1`.

If the app has canonical keys in state, filter public views by
`canonical_subject_key`, not `subject_key`.

---

## Required Frontend Behavior

1. On Home/topic-explore load, fetch topic guides for the active subject.
   Prefer one request per selected unit:

   ```ts
   supabase.rpc("get_topic_point_guides", {
     _subject_key: activeSubjectKey,
     _unit_number: selectedUnitNumber,
     _topic_code: null,
   });
   ```

2. Build lookup maps from the returned arrays:

   ```ts
   const briefByTopicCode = new Map(
     payload.briefs.map((brief) => [brief.topicCode, brief])
   );

   const explainerByTopicCode = new Map(
     payload.explainers.map((explainer) => [explainer.topicCode, explainer])
   );
   ```

3. When a topic is selected, find the live brief by exact topic code:

   ```ts
   const selectedBrief = briefByTopicCode.get(selectedTopicCode);
   const selectedExplainer = explainerByTopicCode.get(selectedTopicCode);
   ```

4. Render the selected topic card from `selectedBrief`:

   - Main brief text: `selectedBrief.whatItIs`
   - Why it matters: `selectedBrief.whyItMatters`
   - Points earned: `selectedBrief.howPointsAreEarned`
   - Answer move: `selectedBrief.answerMove`
   - Common point loss: `selectedBrief.commonPointLoss`
   - Importance chips: `selectedBrief.classImportance`,
     `selectedBrief.examImportance`

5. The "Learn more" button must use `selectedExplainer`, not only route text.
   It can either open an in-app panel/modal or navigate to
   `selectedBrief.learnMorePath`, but the destination must render:

   - `coreIdea`
   - `whatStudentsNeedToUnderstand`
   - `howThisBecomesPoints`
   - `answerMove`
   - `miniExample.question`
   - `miniExample.weakAnswer`
   - `miniExample.pointAttainingAnswer`
   - `commonPointLoss`
   - `practiceBridge`

6. Keep the existing "Get started" behavior, but source its params from
   `selectedBrief.practiceParams` when present.

7. Show "Point brief coming soon" only when all of these are true:

   - the RPC returned successfully,
   - the selected topic code is valid,
   - and no matching brief exists in the returned `briefs` array.

   Do not show the fallback while the query is loading or after an error.
   Loading and error states should be explicit.

---

## Common Bug To Fix

The current screen proves taxonomy is loading but topic-guide content is not.
Likely causes to search for and remove:

- Static/mock topic objects with fields like `description`, `summary`, or
  `brief` are being used instead of `payload.briefs`.
- The app expects snake_case fields (`what_it_is`) from the RPC. The RPC returns
  camelCase fields (`whatItIs`).
- The app filters by `subject_key = "ap_biology"` on the public view. In the
  public view, `subject_key` for Biology is `biology`; use the RPC or filter by
  `canonical_subject_key = "ap_biology"`.
- The app joins topic data by a generated topic id or slug instead of exact
  topic code (`"1.1"`).
- The query is being skipped because the authenticated session is not ready.
  Wait for `supabase.auth.getSession()` / auth state before querying.
- Errors are swallowed and the UI falls through to "coming soon." Log the error
  and show a non-alarming retry state.

---

## Live Smoke Test

With an authenticated session, this call must return one brief and one
explainer:

```ts
const { data, error } = await supabase.rpc("get_topic_point_guides", {
  _subject_key: "biology",
  _unit_number: 1,
  _topic_code: "1.1",
});
```

Expected checks:

```ts
expect(error).toBeNull();
expect(data.briefs).toHaveLength(1);
expect(data.explainers).toHaveLength(1);
expect(data.briefs[0].title).toBe("Structure of Water and Hydrogen Bonding");
expect(data.briefs[0].whatItIs).toContain("Water is a polar molecule");
expect(data.briefs[0].learnMorePath).toBe(
  "/learn/ap-biology/unit-1/water-and-hydrogen-bonding"
);
```

Also test canonical subject input:

```ts
await supabase.rpc("get_topic_point_guides", {
  _subject_key: "ap_biology",
  _unit_number: 1,
  _topic_code: "1.1",
});
```

This should return the same brief/explainer payload.

---

## Acceptance Checklist

- AP Biology Unit 1 Topic 1.1 no longer shows "Point brief coming soon."
- Unit switching fetches the selected unit's brief/explainer arrays.
- Topic switching updates the card without a full page reload.
- Learn More opens real explainer content for AP Biology 1.1.
- AP Chemistry Unit 3, AP Statistics Unit 3, AP Precalculus Unit 3, AP Physics
  1 Unit 3, AP Physics 2 Unit 11, AP Physics C: Mechanics Unit 3, and AP
  Physics C: E&M Unit 10 all show real brief cards where those units are
  selectable.
- Browser console has no Supabase errors, no anonymous-access errors after
  login, and no failed `.from("app.topic_point_briefs")` calls.
- Network logs show `/rest/v1/rpc/get_topic_point_guides` calls hitting
  `https://pcntajvbdfqhbeewmdry.supabase.co`.

---

## Do Not Change

- Do not write to `app.topic_point_briefs` or `app.topic_explainers` from the
  frontend.
- Do not query private `app.*` tables from Lovable.
- Do not duplicate topic-guide content into static frontend constants.
- Do not weaken RLS or grant anon access.
- Do not replace the subject/unit/topic taxonomy; only attach the live
  topic-guide payload to the already-rendered taxonomy UI.
