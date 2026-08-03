# Lovable Prompt — Fix the reviewer unit picker (AP Statistics 5-unit CED + key mismatch)

**Target:** Lovable workspace for `exam-buddy-wireframe` (production build source for
cramapple.com). **Not** the `david-bloom/Cramapple` docs repo.
**Date:** 2026-08-01
**Scope:** one file — `src/data/taxonomy.ts`

Paste everything inside the fence below into Lovable.

---

```
Fix a silent data-loss bug in the reviewer unit picker, and update AP Statistics to
the current CED. Change ONE file: src/data/taxonomy.ts. Do not modify any other file.

## Bug 1 — subject-key mismatch makes the picker silently empty

src/routes/_authenticated/reviewer.review.$assignmentId.tsx derives subject keys from
the content_key prefix and returns HYPHEN forms:

  APBIO-*  -> "biology"
  APSTAT-* -> "ap-statistics"

But src/data/taxonomy.ts keys SUBJECT_UNITS and PLACEHOLDER_SUBTOPICS with UNDERSCORE
forms ("ap_biology", "ap_statistics"). So getUnitsForSubject("ap-statistics") looks up a
key that does not exist, returns [], and the reviewer sees an EMPTY unit dropdown.

This fails silently and twice over. The reviewer sees "no units" rather than an error.
And because the submit guard in that route reads:

  if (unitOptions.length > 0 && topicSelection.unitId == null) { ...block submit... }

an empty list ALSO disables the requirement to tag a unit at all — so reviews get
submitted with no unit tag and nothing warns anyone.

DO NOT fix this by renaming keys to match one convention. Both spellings are in use
across the codebase and persisted state, and a future rename would silently reintroduce
this. Normalize BOTH sides instead: the caller's key AND the map's own keys. Leave the
existing key spellings in SUBJECT_UNITS and PLACEHOLDER_SUBTOPICS exactly as they are.

Add these two helpers (after SUBJECT_UNITS is declared):

function normalizeSubjectKey(subjectKey: string): string {
  const key = subjectKey.trim().toLowerCase().replace(/[\s_]+/g, "-");
  return key === "ap-biology" ? "biology" : key;
}

function byNormalizedKey<T>(source: Record<string, T>): Map<string, T> {
  return new Map(
    Object.entries(source).map(([key, value]) => [normalizeSubjectKey(key), value]),
  );
}

Then build a normalized lookup for each map and read through it. Add after
SUBJECT_UNITS:

const UNITS_BY_SUBJECT = byNormalizedKey(SUBJECT_UNITS);

and after PLACEHOLDER_SUBTOPICS:

const SUBTOPICS_BY_SUBJECT = byNormalizedKey(PLACEHOLDER_SUBTOPICS);

Update the two exported functions to use them (keep their signatures and their
empty-array fallbacks unchanged):

export function getUnitsForSubject(subjectKey: string | null | undefined): ReadonlyArray<Unit> {
  if (!subjectKey) return [];
  return UNITS_BY_SUBJECT.get(normalizeSubjectKey(subjectKey)) ?? [];
}

...and inside getSubtopicsForSubject, replace the direct index with:

  const labels =
    SUBTOPICS_BY_SUBJECT.get(normalizeSubjectKey(subjectKey))?.[unitId] ?? [];

## Bug 2 — AP Statistics unit list is the retired 9-unit CED

The College Board replaced the 9-unit AP Statistics CED (effective Fall 2020) with a
5-unit structure effective Fall 2026, which is what the May 2027 exam tests. Our beta
cohort sits that exam, so reviewers must never be offered the old units.

Replace the entire AP_STATISTICS_UNITS array with exactly this:

const AP_STATISTICS_UNITS: ReadonlyArray<Unit> = [
  { id: 1, label: "Exploring One-Variable Data and Collecting Data", available: true },
  { id: 2, label: "Probability, Random Variables, and Probability Distributions", available: true },
  { id: 3, label: "Inference for Categorical Data: Proportions", available: true },
  { id: 4, label: "Inference for Quantitative Data: Means", available: true },
  { id: 5, label: "Regression Analysis", available: true },
];

Add a comment above it recording: this replaces the retired 9-unit CED; the old Unit 9
(Inference for Slopes) was removed from the course outright, along with chi-square
goodness-of-fit, the geometric distribution, combining random variables, and
re-expression to achieve linearity; and unit ids 1-5 now denote DIFFERENT content than
ids 1-5 did under the old CED, so tags recorded before this change are not comparable
to tags recorded after it.

Leave AP_BIOLOGY_UNITS completely untouched.

## Do not

- Do not touch any file other than src/data/taxonomy.ts.
- Do not rename subject keys anywhere, in this file or any other.
- Do not change the reviewer route, the submit guard, or any component.
- Do not change the Unit or Subtopic interfaces, the exported function signatures, or
  the deprecated UNITS / getSubtopics exports at the bottom of the file.
- Do not add a subtopic list for AP Statistics. It is intentionally absent for now.

## Verify before you finish

Confirm each of these returns what is shown:

  getUnitsForSubject("ap-statistics")  -> 5 units, first label "Exploring One-Variable Data and Collecting Data"
  getUnitsForSubject("ap_statistics")  -> the same 5 units
  getUnitsForSubject("biology")        -> 8 units, first label "Chemistry of Life"
  getUnitsForSubject("ap_biology")     -> the same 8 units
  getUnitsForSubject("chemistry")      -> [] (unknown subject still returns empty)
  getSubtopicsForSubject("ap_biology", 1) -> 7 subtopics
  getSubtopicsForSubject("ap-statistics", 1) -> [] (none defined yet)

The build must typecheck cleanly.
```

---

## Why this is going through Lovable rather than a GitHub PR

The production build is produced from the Lovable workspace, not directly from GitHub
`main`. The workspace fetched `main` at `537b09c` (2026-08-02 02:38 UTC), which is the
commit carrying the underscore keys — so the broken code is now in the build source and
the next publish would ship an empty unit picker. Applying the fix in the workspace and
letting it sync out to GitHub is the shortest path; pushing to `main` and waiting for a
fetch has already demonstrated a five-day lag (the mismatch landed 2026-07-27 and
production was still serving matched keys on 2026-08-01).

## Follow-up worth doing separately

Add a unit test for `getUnitsForSubject` / `getSubtopicsForSubject` covering both key
spellings. This bug class has no failure mode — a wrong key returns `[]`, which is
indistinguishable from "this subject has no units" — and it silently disabled a required
field for five days without anyone noticing. The seven assertions in the verify block
above are the entire test.
