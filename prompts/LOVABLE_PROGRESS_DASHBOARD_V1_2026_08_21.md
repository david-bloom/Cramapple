# Lovable Brief — Student `/progress` v1 (display-only)

**Date:** 2026-08-21
**Backend contract:** `progress_dashboard_v1_2026_08_21`
**RPC:** `public.get_student_progress_dashboard(_subject_key text default null)`
**Related:** `UX-007`, `DECISION-0003`,
`docs/product/PROGRESS_DASHBOARD_V1_PLAN_2026_08_21.md`

## The one rule

**Supabase is the sole producer of every progress number. Lovable is
display-only.**

Do **not** compute, derive, infer, round, re-scale, or "fix up" any of:
MCQ percent correct, FRQ points, estimated score, session counts, minutes,
topics, units, status, or colour. Render the backend's fields as given.

Do **not** read `attempts`, `grading_results`, `attempt_criterion_results`,
`learning_sessions`, `sessions`, or `progress_snapshots` for progress
statistics. The single call below is the entire data source for this page.

## Call

```ts
const { data, error } = await supabase.rpc("get_student_progress_dashboard", {
  _subject_key: subjectKey ?? null, // null = the student's active subject
});
```

`_subject_key` accepts either hyphen or underscore form (`ap-statistics` or
`ap_statistics`); the backend normalises it. Passing `null` means "the
student's active subject" — it does **not** mean "all subjects".

## Error states to handle

| Postgres code | Meaning | UI |
| --- | --- | --- |
| `28000` | not signed in | send to sign-in |
| `42501` | no active entitlement for that subject | subject-locked state |
| `22023` | malformed subject key | generic error; this is a bug, not a user state |

## Payload

```jsonc
{
  "version": "progress_dashboard_v1_2026_08_21",
  "generatedAt": "2026-08-21T15:40:30.997571+00:00",
  "state": "ready",              // or "no_subject"
  "subject": {
    "subjectKey": "ap_biology",
    "displayName": "AP Biology",
    "examPackVersionId": "…",
    "schoolYear": "2026",
    "officialExamDate": "2026-05-04"
  },
  "summary": {
    "mcq": {
      "correct": 1, "attempted": 2, "percentCorrect": 50,
      "uncertainExcluded": 0,
      "status": "insufficient_evidence",
      "statusLabel": "Not enough evidence yet"
    },
    "frq": {
      "gradedItems": 2, "earnedPoints": 9, "possiblePoints": 18,
      "uncertainExcluded": 1,
      "estimatedScore1To5": null,
      "confidence": "none",
      "isOfficial": false,
      "qualifier": "Cramapple estimate, not an official College Board score.",
      "evidenceGaps": ["…", "…"],
      "nextAction": "Complete a few more free-response items to unlock an estimate.",
      "status": "insufficient_evidence",
      "statusLabel": "Not enough evidence yet"
    },
    "activity": {
      "sessions": 0,
      "actualMinutes": 0,
      "sessionsWithoutDuration": 0,
      "unitsWithEvidence": null,
      "unitAttributionAvailable": false,
      "excludedNonIndependentItems": 0,
      "excludedOtherFormatItems": 0
    }
  },
  "units": [
    { "unitNumber": 1, "unitTitle": "Chemistry of Life", "isExamAssessed": true,
      "status": "attribution_unavailable",
      "statusLabel": "Unit-level breakdown not available yet" }
  ],
  "recentActivity": [
    { "contentKey": "APBIO-FRQ-L-021", "format": "frq", "gradeState": "graded",
      "gradeConfidence": "high", "pointsEarned": 0, "pointsAvailable": 9,
      "pointsWithheld": false, "attemptedAt": "…" }
  ],
  "notes": ["…"]
}
```

Note there is **no `topics` key**. Topic-level progress does not exist in v1 —
do not add a placeholder section for it.

## Status → colour mapping (the ONLY mapping Lovable owns)

The backend emits a semantic token, never a colour, so that theming, dark mode
and contrast stay a frontend concern. Map exactly these five; treat any
unknown token as `no_evidence`.

| `status` | Colour | Meaning |
| --- | --- | --- |
| `no_evidence` | neutral / grey | nothing attempted yet |
| `insufficient_evidence` | blue | work done, not enough to judge |
| `developing` | amber | enough evidence, still building |
| `strong` | green | enough evidence, performing well |
| `attribution_unavailable` | neutral / grey | we cannot attribute work here yet |

There is deliberately **no red**. Weak performance and thin evidence are
different things, and UX-007 requires that incomplete work is never framed as
learner failure. Do not introduce a failure colour.

Always render `statusLabel` alongside the colour. Colour must never be the only
carrier of meaning.

## Rules that are easy to get wrong

1. **`percentCorrect` may be `null`.** Render "—" or the empty state, never
   `0%`. Null means "not computable", which is not the same as zero.
2. **`unitsWithEvidence` is `null`, not `0`.** Do not render it as a count.
   When `unitAttributionAvailable` is `false`, show the units list with no
   per-unit evidence and say so; do not imply the student has done nothing in
   every unit.
3. **`pointsWithheld: true` means do not show a score.** Those rows come back
   with `pointsEarned: null` deliberately. Show the withheld state
   ("we could not grade this confidently"), never a number.
4. **Never show `estimatedScore1To5` without its companions.** If it is
   non-null you must also render `qualifier`, the `evidenceGaps` list, and
   `nextAction`, and you must not present it as an AP score. When it is `null`,
   show the gaps explaining what is still needed — that is the honest empty
   state, not a hidden section.
5. **`actualMinutes` is real elapsed time only.** Planned minutes are excluded
   by design. `sessionsWithoutDuration` counts sessions with no measurable
   duration; surface it rather than folding it into the total.
6. **`excludedNonIndependentItems` / `excludedOtherFormatItems`** are work the
   figures could not count. Surface them so a student never sees effort vanish.
7. **`state: "no_subject"`** returns `subject: null` and `summary: null`. Render
   the subject-picker empty state; do not crash on the nulls.

## Expected v1 reality

Most students will see mostly-empty sections, and that is correct. Unit
attribution is unavailable for every subject, so the units list always renders
with `attribution_unavailable`. Build the empty states as first-class UI, not
as afterthoughts — they are what v1 mostly shows.
