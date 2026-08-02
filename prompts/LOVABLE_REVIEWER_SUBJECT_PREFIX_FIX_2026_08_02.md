# Lovable Prompt — Reviewer unit picker never appears for 78% of AP Statistics items

**Target:** Lovable workspace for `exam-buddy-wireframe` (production build source).
**Date:** 2026-08-02
**Scope:** one function in one file — `src/routes/_authenticated/reviewer.review.$assignmentId.tsx`
**Follows:** `LOVABLE_REVIEWER_UNIT_PICKER_FIX_2026_08_01.md` (taxonomy fix — already applied and published)

Paste everything inside the fence into Lovable.

---

```
The reviewer unit picker never renders for most AP Statistics questions. Fix ONE
function in ONE file: src/routes/_authenticated/reviewer.review.$assignmentId.tsx.
Do not change any other file.

## The bug

subjectKeyFromContentKey() matches the content_key prefix by exact string equality:

  const prefix = contentKey.split("-")[0]?.toUpperCase();
  if (prefix === "APBIO") return "biology";
  if (prefix === "APSTAT") return "ap-statistics";
  return null;

AP Statistics content uses THREE different content_key prefixes, not one:

  APSTAT   —  60 items   (matches, picker works)
  APSTATS  — 176 items   ("APSTATS" !== "APSTAT", returns null, NO picker)
  STATS    —  40 items   (returns null, NO picker)

So 216 of 276 AP Statistics items — 78% — silently get no unit picker at all. This is
confirmed in production data: of every AP Statistics review decision ever submitted,
100% of the unit tags sit on APSTAT-* items. APSTATS-* has 138 decisions and 0 tags;
STATS-* has 21 decisions and 0 tags.

It fails silently in both directions. The reviewer sees no Unit field rather than an
error, and because the submit guard reads `unitOptions.length > 0 && ...`, an empty
list also switches off the requirement to tag a unit — so the review submits clean
with no warning.

## The fix

Recognize all three prefixes. Replace the body of subjectKeyFromContentKey with:

function subjectKeyFromContentKey(contentKey: string | null | undefined): string | null {
  if (!contentKey) return null;
  const prefix = contentKey.split("-")[0]?.toUpperCase() ?? "";
  if (prefix === "APBIO") return "biology";
  if (prefix === "APSTAT" || prefix === "APSTATS" || prefix === "STATS") {
    return "ap-statistics";
  }
  return null;
}

Update the comment above it to list all three Statistics prefixes and to say that an
unrecognized prefix returns null, which renders no picker AND disables the tagging
requirement — so any new subject prefix must be added here.

Use exact equality against an explicit list. Do NOT use startsWith("APSTAT") — it
would match a future unrelated prefix like APSTATE while still missing STATS.

## Do not

- Do not touch src/data/taxonomy.ts. It was fixed and published on 2026-08-01 and is correct.
- Do not change the submit guard, the topicSelection state, or any component.
- Do not rename content keys or subject keys anywhere.
- Do not add prefixes for Calculus, Chemistry, Physics or Precalculus. Those subjects
  have no unit taxonomy yet, and returning null for them is correct today.

## Verify before you finish

Confirm subjectKeyFromContentKey returns:

  "APSTAT-MOD8-H001"          -> "ap-statistics"
  "APSTATS-MCQ-002-CAL"       -> "ap-statistics"
  "APSTATS-HDG-2026-GRAPH-005"-> "ap-statistics"
  "STATS-MOD4-M009"           -> "ap-statistics"
  "APBIO-FRQ-L-001"           -> "biology"
  "apstats-mcq-002-cal"       -> "ap-statistics"   (case-insensitive)
  "APCALCAB-MCQ-010"          -> null              (still no picker, correct)
  null                        -> null

Then open a review for APSTATS-MCQ-002-CAL and confirm the Unit dropdown appears with
5 options, starting "Exploring One-Variable Data and Collecting Data". The build must
typecheck cleanly.
```

---

## The durable fix (do NOT ask Lovable for this — it spans two repos)

Deriving subject from the content_key is the root cause; the prefix list is a patch on
a patch. **The database already has the answer.** `content_item_versions.subject_key` is
populated correctly for every item, in exactly the hyphen form the taxonomy expects:

| content_key prefix | items | `subject_key` |
| --- | ---: | --- |
| APBIO | 254 | `biology` |
| APSTAT | 60 | `ap-statistics` |
| APSTATS | 176 | `ap-statistics` |
| STATS | 40 | `ap-statistics` |

Two changes retire the string parsing permanently:

1. **`supabase/functions/review-queue/index.ts`** — add `subject_key` to the
   `content_item_versions` select (it is not currently fetched) and include it on the
   `artifact` payload.
2. **The reviewer route** — use `artifact.subject_key` directly and delete
   `subjectKeyFromContentKey` entirely.

That removes the whole bug class: no prefix list to maintain, and a new subject works
the moment its content is seeded. It needs an edge-function deploy, so it is a separate
change from the hotfix above.

## Why this matters beyond the picker

This is the third independent defect in the same tagging path in two days:

1. Unit list was the retired 9-unit CED — fixed and published 2026-08-01.
2. Subject-key underscore/hyphen mismatch — fixed and published 2026-08-01.
3. Content-key prefix exact-match — this one.

All three share a failure signature: **a lookup miss returns an empty array, which is
indistinguishable from "this subject legitimately has no units," and the empty array
then silently disables the requirement to tag.** No error, no log, no visible
difference. Whatever fix lands, the tagging requirement should fail loudly — or at
minimum the reviewer UI should distinguish "no units configured for this subject" from
"units failed to load."
