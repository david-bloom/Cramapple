# Open Hand — Resolving Two Competing Implementations (2026-09-29)

**Status:** CURRENT — plan awaiting Product Owner decisions (§4)
**Owner:** David Bloom (decisions); executing agent TBD
**Area:** Open Hand / answer-key exposure / scoring integrity
**Branches in scope:** `codex/task-0049-open-hand-answer-key` (pushed 2026-09-29, no PR), `claude/plate-loop-open-hand-rebased` (PR #256, draft)

## 0. Step 0 results (executed 2026-09-29, read-only) — read before §2 and §3

Step 0 ran. It changes the severity, not the plan.

**Finding 0a — the exposure is not reachable today. `open-hand-item` has no caller.** The Open Hand
screens in the live app (`src/screens/OpenHandMcqScreen.jsx`, `OpenHandFrqScreen.jsx`, mounted at
`/cramapple` via `QuestionRoute`) are **demo-only presentation components**. `OpenHandMcqScreen`
takes its `question` as a prop, makes **no network call of any kind**, and renders `is_correct`,
`rationale` and `minimum_fix` from whatever it is handed; `useSession()` is used only for local
read-tracking. Per the front end's own findings doc
(`.lovable/plan/gate-the-four-aids-in-practice-findings-and-plan-2026-09-27.md`) these screens run on
local sample content (`src/content/sample/*`) with no server grading, and *"the four plate templates
are not what students practise in"* — a logged-in student goes to bare `/session` → `SessionFrame`,
which has no Plate, no rubric pane, no Deep Dive and no Open Hand.

Corroborated in Dev: `app.open_hand_scoring_exclusions` holds **0 rows**.

**This corrects an overstatement in §2 and in the comment on #256.** Saying "Dev currently has the
reader live and the enforcement not live" was accurate about *deployment* and misleading about
*exposure*. The function is deployed in Dev and nothing calls it. No student can read a real answer
key through Open Hand today, so no student can be scored on an item whose real key they saw. This is
a **latent design gap in work that is not yet wired up**, not a live hole.

**Consequence for sequencing — the one thing that must not slip.** The gap becomes real the moment
the plate loop is wired to live data, which is precisely what #256's `PLATE_LOOP_BUILD_PLAN` sets out
to do. So the exclusion mechanism has to land **with** that wiring, in the same change, not as a
follow-up afterwards. That is the single scheduling constraint this plan exists to protect.

**Finding 0b — the bundle blocker is real and not marginal.** `evaluate-attempt/index.ts` is 89,616
bytes; with its 20 direct `_shared` imports it is **289,938 bytes**, and that is a floor (transitive
imports are not counted) against the platform safety reviewer's 200,000-byte limit. Splitting would
have to shed ~90KB+ of the import closure. This blocks the enforcement half's deployment to **both**
Dev and Production, under either §4 D2 option.

**Finding 0c — not established: whether Dev's deployed `evaluate-attempt` contains the `409` check.**
Three routes were tried and none is conclusive: the Supabase MCP returns `PLACEHOLDER` for the
deployed source; the timestamps are ambiguous (the migration is stamped 2026-09-28 02:38 UTC and the
Dev function was updated 2026-09-28 13:05 UTC — after, but 2026-09-28 also carried unrelated
TASK-0041 deploys); and the behavioural test needs a Dev user JWT plus a submitted attempt, which
requires Dev auth credentials this session does not hold and should not mint. Finding 0a makes this
low-stakes — with no caller, no exclusion row is ever written, so the `409` path cannot fire either
way. **Treat enforcement as not deployed until proven.** Step 2's redeploy settles it definitively;
do not spend further effort proving it beforehand.

## 1. What happened

Open Hand — the teaching mode that deliberately shows a student the full answer key — was built
twice, independently, by two agents who could not see each other's work. One branch was local-only
until 2026-09-29, which is why the duplication stayed invisible. The two implementations split the
feature along different lines and make **different assumptions about what the risk is**.

| Concern | `codex/task-0049-open-hand-answer-key` | `claude/plate-loop-open-hand-rebased` (#256) |
| --- | --- | --- |
| Serves the answer key | RPC `public.get_open_hand_item` | Edge function `open-hand-item` |
| Records a scoring exclusion | **Yes** — atomic, idempotent insert into `app.open_hand_scoring_exclusions` | **No** |
| Blocks later scoring | **Yes** — `evaluate-attempt` returns `409 open_hand_item_not_scorable` before loading any answer-bearing record | **No** |
| Who may view | Owner of an **active learning session**, item published in that session's exact exam pack; **no admin bypass** | Any authenticated profile with a **subject entitlement**, on a servable pack; **staff/QA roles allowed** |
| Extra payload | MCQ `minimum_fix` derived from rationale | `topic_explainers`, `topic_point_briefs`, `canonical_answer_spans` |

Verified directly against #256's source: `open-hand-item/index.ts` does not call `get_open_hand_item`
and never references the exclusions table; it reads `mcq_choices.is_correct`/`rationale`,
`frq_criteria` and `canonical_answer_spans` through `createServiceClient()`. Zero matches for insert,
exclusion, or scoring anywhere in the file.

## 2. Verified environment state (2026-09-29, read-only)

| Object | Development | Production |
| --- | --- | --- |
| `app.open_hand_scoring_exclusions` | **present** | absent |
| `public.get_open_hand_item` | **present** | absent |
| `open-hand-item` edge function | **ACTIVE, v9** | **absent** |
| `evaluate-attempt` `409` exclusion check | **believed absent — verify first (§5 step 0)** | absent |

**Production is clean.** No part of Open Hand is deployed there, so there is no production exposure
and no urgency measured in hours.

**Development currently has the reader live and the enforcement not live.** `open-hand-item` is
serving answer keys in Dev while `evaluate-attempt` (per the TASK-0050 record's own unchecked
verification box, and its note that the Dev deploy was *blocked by the platform safety reviewer
because the bundle exceeded the 200,000-byte review limit*) does not yet refuse to score an excluded
item. That combination is exactly the gap this plan exists to close, and it is live in a real
environment today.

## 3. The substantive disagreement

#256's header states its safety case as: *"Practice/exam grading never calls this function, so the
answer key cannot leak into a graded attempt."* That is **true about code paths** — the grader does
not read from that function. It does not address the **student**: nothing prevents a student opening
Open Hand on item X, reading the correct choice and rationale, then being served item X on the
practice path and scored on it. Same published pool, same exam pack.

The codex branch treats the student as the risk, which is why it is a writer (exclusion row) and not
only a reader.

`DECISION-0080` supports the codex framing: the four gated aids — rubric, how-points, deep dive,
reference — **all** count as pre-submission hint use for mastery. Open Hand exposes strictly more
than those aids. It would be incoherent for rubric-viewing to affect mastery eligibility while
answer-key-viewing affected nothing.

**Not verified:** whether the front end actually surfaces Open Hand for items that are also in a
student's practice pool. If those sets were disjoint the gap would be theoretical. The codex RPC's
contract requires a published item in the session's own exam pack, which implies overlap — but that
is inference from a contract, not a front-end check. **This is the single cheapest thing that could
shrink the whole problem, so §5 checks it first.**

## 4. Decisions needed from the Product Owner

These are not resolvable by an executing agent.

**D1 — Access model. Which rule governs who may see an answer key?**
- (a) Session-scoped (codex): must own an active learning session containing the item. Tightest; no
  staff bypass, so admins/QA cannot preview Open Hand content.
- (b) Entitlement-scoped (#256): any authenticated user entitled to the subject, plus staff/QA.
  Broader, and supports reviewer workflows.
- (c) Entitlement-scoped **plus** a mandatory exclusion write. Combines #256's reach with the codex
  integrity guarantee. **Recommended** — it keeps reviewer/QA access, which (a) removes, while
  closing the gap (b) leaves open. Staff/QA roles should be exempt from the exclusion write, since
  excluding a reviewer from scoring is meaningless.

**D2 — One gate or two doors?**
- (a) **Unify on the RPC (recommended).** `open-hand-item` calls `get_open_hand_item` instead of
  reading answer tables directly. The exclusion insert and the key read happen in **one statement**,
  so there is no window in which a student has seen the key but no exclusion row exists. Non-answer
  payload (`topic_explainers`, `topic_point_briefs`) stays as direct reads — it is not answer-bearing
  and does not need to be inside the RPC.
- (b) Keep both, add an exclusion write to `open-hand-item`. Faster, but the read and the write are
  two statements (a crash between them leaves a student who has seen the key with no exclusion), and
  two independent code paths to the same answer data must then be kept in sync forever.

**D3 — Task numbering.** Both bodies of work have carried TASK-0050. The skill-dimension rollout now
holds it (`DECISION-0085`, `APPROVAL-0060`); this Open Hand work needs a fresh number — TASK-0051 is
free. The codex branch has now renumbered twice, so whichever number it lands on should be recorded
in the branch's own task file rather than assumed.

## 5. Execution sequence

**Step 0 — Verify before building (no writes).**
- Confirm whether Dev's deployed `evaluate-attempt` contains the exclusion check. The Supabase MCP
  returns a placeholder for its source, so verify behaviourally: create a Dev exclusion row for a
  test user/item and submit a matching attempt, expecting `409 open_hand_item_not_scorable`.
- Answer the §3 open question: does the front end surface Open Hand for items in the practice pool?
  If not, re-scope this plan before spending anything further on it.

**Step 1 — Product Owner decides D1, D2, D3.** Record as a DECISION entry.

**Step 2 — Resolve the bundle-size blocker.** `evaluate-attempt` exceeds the 200,000-byte platform
safety-review limit, which blocked its Dev deploy. **This blocks the enforcement half under either
D2 option**, so it is on the critical path regardless of D1/D2. Two routes: request the explicit
Product Owner approval the reviewer asks for and retry, or split `evaluate-attempt`. Do not attempt
a workaround — the original session correctly did not.

**Step 3 — One branch, one PR.** Consolidate onto a single branch implementing the D1/D2 outcome.
Close the loser with a pointer rather than deleting it, so the reasoning stays on record. Carry
across #256's non-duplicated assets (its `minimal-ci.yml` wiring, its tests, and
`PLATE_LOOP_BUILD_PLAN_2026_09_27.md`) and the codex branch's migration and task record.

**Step 4 — Dev verification, end to end.** The acceptance test is a single sequence, not two: view
an item's key through Open Hand, then submit an attempt on that same item, and assert the refusal.
Also assert the negative: an item never viewed in Open Hand still scores normally.

**Step 5 — Fresh independent QA**, in a new context, not a continuation of the implementing session.

**Step 6 — Production Hard Gate.** Migration and both function deploys need David's explicit
approval. Production has none of this today, so it goes in as one coherent change rather than a
reader now and enforcement later.

## 6. Interim risk control

Until Step 6, **`open-hand-item` must not reach Production.** Deploying the reader ahead of the
enforcement would move today's Dev-only gap into the live environment. `#256` should stay in draft
and be marked blocked on this plan. Dev's existing exposure is acceptable to leave in place
short-term — Dev has no real students — but it should not be forgotten, and Step 0 will confirm its
actual extent.
