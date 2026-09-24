# FF-2 and FF-13 — Verified 2026-09-24

Both were rated on assumption. Both were wrong, in opposite directions.

---

## FF-13 — CLOSED. The answer-key exposure is already fixed.

The tracker rated this "becomes High the moment FF-1 lands", on a memory note from 2026-08-24
describing a live exposure with a 3-part fix staged but unapplied. **All three parts are live on
Production.**

Verified functionally with a `set role` probe, not from grant tables:

| Role | `choice_text` | `is_correct` | `rationale` |
| --- | --- | --- | --- |
| `authenticated` | **readable** (3132 rows) | `permission denied` | `permission denied` |
| `anon` | denied | denied | denied |
| `content_reviewer` | readable | readable | readable |

`public.mcq_choices` (a view) does not carry `is_correct` or `rationale` at all.
`public.get_review_mcq_choices(uuid)` exists as SECURITY DEFINER with EXECUTE to `authenticated`,
so reviewers keep their path.

**The mechanism is column-level grants**, which is exactly right: serve the choices, withhold the
key. `authenticated` has SELECT on `id`, `content_item_version_id`, `choice_key`, `choice_text`,
`created_at` and on nothing else.

### A methodological trap worth recording

My first pass read `information_schema.role_table_grants` and saw no `authenticated` grant at all,
then a `count(*)` probe returned 3132 rows — an apparent contradiction that looked like an exposure.
Both readings were misleading:

- `role_table_grants` **only shows grants the current user can see**, and it omitted the column
  grants entirely.
- `count(*)` succeeds with SELECT on **any one column**, so it proves nothing about which columns
  are readable.

`has_column_privilege()` plus a projection probe (`select is_correct ...`) is what actually answers
the question. Recorded because the first two methods are the obvious ones and both give a wrong
answer here.

**Consequence: FF-1 is not gated on a security fix.** The coupling the tracker asserted between FF-1
and FF-13 does not exist.

---

## FF-2 — Real, but low severity, and not the problem I described.

`full_exam_frq` **is accepted** by `session-event`, which validates client-supplied
`practice_format` against an allowlist of exactly `targeted_drill` and `full_exam_frq`. So any
client can start a Biology full-exam session.

But:

- **No session has ever used it.** 117 learning sessions across 6 users, all time, every one either
  `targeted_drill` or null.
- Biology has **0** items with that format, so such a session returns an empty queue.
- 76 items across other subjects do carry it (Calc AB 18, Calc BC 21, Precalculus 20, the Physics
  packs 13). Biology, Chemistry and Statistics have none.

So this is **not a day-one risk** — nothing in the product creates such a session today. It is one
frontend toggle away from being one.

### The real finding is broader than `full_exam_frq`

`student-session-items` returns an empty result as:

```json
{ "status": "ok", "result": { "items": [], "omitted": [] } }
```

with **no reason field**. That is indistinguishable from "you have finished everything available".
The function already distinguishes one case — it returns `reason: "session_practice_format_unset"`
when the format is missing — so the shape exists; it simply is not used when a *set* format matches
no content.

**FF-2-001.** An empty item queue should say why. "No content for this practice_format in this
subject" and "you have completed everything" are different states and the API reports them
identically. This is the same silent-failure class as the three serving failures found earlier
today: the system treats "nothing matched" as an ordinary answer rather than a condition worth
naming. A `reason` on the empty branch is a small change to one edge function and would have made
two of today's three failures self-announcing.

---

## Both findings share a root

Three times today a predicate quietly excluded content and the system reported success: the taxonomy
hash mismatch, the missing `validated` status, and now an empty queue with no reason. None of them
is a bug in the sense of wrong code. Each is a **design choice to report absence as normality**, and
that choice is why a six-week-old regression needed a human to notice it.
