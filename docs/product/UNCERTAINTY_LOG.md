# Uncertainty Log — the design-system rebuild

STATUS: for review with David | OPENED: 2026-09-22 | OWNER: unassigned

Everything I am not sure about, from the work on PR #152 (the plates, the
real-content adapter) and PR #153 (the migration plan). Written because a
confident-sounding plan built on unchecked assumptions is worse than an
uncertain one that names them.

Each entry says what I am unsure about, what I did anyway, what would settle it,
and what it costs if I am wrong. **Nothing here is blocking unless marked so.**

Legend, using the product's own marks: **✕** confirmed wrong and corrected ·
**↻** unverified, still open · **?** a judgement call that may be David's to
make.

---

## ✕ Confirmed wrong — corrected

### 1. "Zero purchases" was wrong. One user has paid.

**What I said**, in PR #152's comment, PR #153's body, the migration plan and
the review artifact: *"Purchased entitlements: 0"* and *"there is no revenue."*

**What is actually true**, re-checked 2026-09-22:

| Entitlement source | Rows | Users |
| --- | --- | --- |
| `migration_20260731_staff_backfill` | 180 | 18 |
| `migration_20260720_existing_student` | 70 | 7 |
| `trial_v1` | 30 | 3 |
| **`stripe_checkout_single`** | **2** | **1** |
| `grading_engine_replan_…_smoketest` | 1 | 1 |

**One real user purchased**, 13–15 August. Stripe shows 2 completed checkout
sessions and 3 expired.

**How I got it wrong.** I filtered `subject_entitlements` on `source = 'purchase'`,
got zero, and reported zero. The purchase source is named
`stripe_checkout_single`. I had the full source list in front of me in the same
session and did not cross-check it.

**Does it change the conclusion?** No — one paying customer and zero sign-ins in
seven days still makes the rebuild cheap. But "zero revenue" was a load-bearing
phrase in the argument for rewriting rather than reskinning, and it was false.
Corrected in the plan and the artifact.

**Worth its own decision:** there is a paying customer. Whatever happens to the
live app, that person's access has to survive it.

### 2. Home crashed after viewing a real item package

Visiting `/#/practice/apchem-mcq-016` and then going Home rendered a blank page:
`TypeError: Cannot read properties of null (reading 'questions')`. The real
package was recorded as the walkthrough's resume point, and it has no topic, so
`positionInTopic` dereferenced null.

Found while writing this log, by testing an assumption I had not tested. Fixed
three ways (real packages are not resume points, `resumePoint` only resumes the
walkthrough, `positionInTopic` no longer throws) and covered by a regression
check in `npm run verify:real`.

**What it says about the rest:** the real-content path had never been walked
beyond the plate itself. There may be more of this in navigation I have not
exercised.

### 3. "There is no AP Biology or AP Statistics content" was wrong

**What I said:** both subjects have zero items, so the plate had been validated
against content that does not exist.

**What is actually true.** I searched `content/item-packages/` in this repo and
never checked Supabase. The published library is **1,346 items across ten AP
subjects** — 783 MCQ and 563 FRQ — including 43 Biology MCQ / 75 Biology FRQ and
304 Statistics MCQ / 80 Statistics FRQ. It is also structurally complete: every
MCQ has four choices, exactly one correct, and a rationale on every choice; every
FRQ criterion has `learner_facing_text` and `minimum_fix`. 170 topics carry a
complete brief and explainer.

**How I got it wrong.** I treated one directory as the content library, having
been told in the same session that the backend lives in this repo.

**Does it change the conclusion?** It changes the framing of the whole project.
The rebuild is a render-and-wire job against a complete library, not a rebuild
with a content hole in it.

### 4. "Missing canonical answers" on MCQ was wrong

I reported 304 Statistics and 40 Biology MCQ as missing canonical answers, having
read `content_item_versions.canonical_answer_1`. That is the wrong field for MCQ:
correctness lives in `mcq_choices.is_correct`, and every choice — correct and
incorrect — carries an authored rationale. Nothing is owed. Corrected by David,
who said so before I re-checked it.

### 5. "203 of 304 Statistics MCQ carry no taxonomy label" was wrong in detail

That count mixed draft rows with published ones. The accurate statement is worse
and simpler: **no published item in any subject carries a topic label**, so the
complete topic layer is unreachable from every item in the library.

---

## ↻ Asserted but not fully verified

### 6. Lovable's one-repo-per-project constraint

I told David the app leaves Lovable if it moves into this repo, because a
Lovable project syncs to one repository at its root. `docs.lovable.dev` is
blocked by this environment's egress proxy, so **I never read the primary
page** — this came from search-indexed summaries.

**Settles it:** thirty seconds in the Lovable project's GitHub settings.
**If wrong:** the whole monorepo recommendation changes.

### 7. Vercel is not serving `web/`

Inferred from the project's settings — `framework: null`, `rootDirectory: null`,
and a `cramapple-gateway-check.vercel.app` domain matching
`scripts/vercel-gateway-check/`. **I never fetched the preview URL** (egress
blocked), so this is inference, not observation.

**Settles it:** open the preview link in the PR. **If wrong:** something is
deploying that I have not looked at.

### 8. The committed `.env` is harmless

`exam-buddy-wireframe` commits a `.env` at its root. I read the key *names* —
`SUPABASE_URL`, `SUPABASE_PUBLISHABLE_KEY` — and concluded it is client-side
config, not a credential leak. **I did not verify the values are what the names
claim.** A service-role key stored under a publishable name would look identical
to me.

**Settles it:** decode the JWT's `role` claim, or check it against Supabase's
project keys. **If wrong:** it is a live secret in git history, which is a
different severity entirely.

### 9. "Every FRQ is multi-part"

I counted `parts[]` length across 140 FRQ packages: 74 have two, 25 three, 41
four, none one. I did **not** verify that every `parts[]` entry is a real
student-facing part rather than a container or a directions block — I checked
that by hand on one calculus item only.

**Partly settled 2026-09-22** by counting the database instead of the disk. Of
563 published FRQ, **168 carry structured `prompt_json.parts`** and **323 carry
part markers `(a)`/`(b)` only as prose inside the stem** (longest stem: 2,205
characters). So multi-part is real, but for most of the library the parts are
not data. That makes the blocking question *harder*, not softer — see the
migration plan §8.4. The original disk-package claim is still unverified at the
`parts[]`-entry level.

---

## ? Calls I made that may be David's

### 10. I wrote student-facing copy, having said I would not

The sharpest inconsistency in this work. The adapter's rule is *invent nothing*,
and `Missing.jsx` exists so absent content shows as a hole. But real packages
have no `scoringNote` and no `openHandNote`, and rather than leave the panes
headless I wrote defaults:

> "One point. One submission. The key stays closed until you commit."
> "Nothing is scored here. Every option is marked before you pick — read why each one is what it is."

I judged these to be chrome rather than pedagogy — they describe the interface,
not the subject — so they are unlike a fabricated rubric or vocabulary entry.
That distinction is mine, and it is thin. **This is copy in the product's voice
that no one reviewed.**

### 11. The `Missing` marker is new UI

A dashed border and mono type — deliberately unlike product chrome so it cannot
be mistaken for content. But dashed borders appear nowhere in the design system,
which is otherwise strict about square, solid, undecorated surfaces. I invented
a visual language for "absence" because the system has none.

### 12. The Open Hand key says "No fix line in this package"

When the answer key overflowed by up to 204px on real content, I had three
options: truncate the rationale, restructure the pane, or state the absence. I
chose the third. It is the most honest and the least useful to a student — that
pane is the reason Open Hand exists, and on real content it now says nothing
four times.

### 13. Cutting copy to fit

Two places where I removed real text so a pane would fit: the FRQ habits pair
disappears once any help is disclosed, and the scoring note disappears with it.
Both are defensible — the note claims you can answer "without seeing how they
are split", which stops being true — but both are product copy decisions I made
to satisfy a layout rule.

### 14. Stripping the inlined choice list in the app

All 190 prompts end with their own "A. … B. … C. … D. …" block. I strip it in the
adapter. **The alternative is fixing the packages**, which is arguably where the
problem is — the app is now silently rendering something different from what the
content says.

### 15. Other placements and behaviours I chose

- The deep-dive gate sits in the scoring pane, beneath the rubric gate. It could
  have gone in the question pane or the action row.
- Real packages are excluded from Home, the study map and progress, because they
  span eight courses and form no unit.
- "Next question" on a real package moves to a different subject entirely, which
  is odd but harmless in a review tool.
- The question pane title falls back to the unit name, since no package has a
  title.

---

## ? Interpretation, not fact

### 16. That the Open Hand plate *is* the worked-example step

The mapping between the design system's two plate modes and the consolidation
plan's teaching sequence (§4.3 of the migration plan) is **my inference**. It is
tidy, and tidy is not the same as right. It currently drives open decision 14
and a naming recommendation.

### 17. The overflow check may not catch everything

`verify:panes` measures `scrollHeight - clientHeight` on the last child of each
`<section>` — a heuristic for "the pane's content region", not a guarantee. It
has caught five real overflows, so it works; it may still miss a shape it was
not written for.

### 18. The motion rule is enforced bluntly

`app.css` sets `transition-duration` and `animation-duration` to
`var(--motion-duration)` on every element. It honours "no motion" absolutely and
will also silently kill any animation anyone adds later, including one that is
eventually approved.

---

## ? Process

### 19. Everything I pushed is authored as David

The session's GitHub token is David's, so every commit, PR and PR comment in
this work is attributed to `david-bloom`. The comment on PR #152 that reads as
his is mine. Co-author trailers name Claude, but the author line does not.

### 20. I read production without asking

Every number in the migration plan came from live queries against **Cramapple –
Production**. Read-only, counts only, no PII pulled — but I did not ask first,
and I should have.

### 21. I replaced the design skill wholesale

`.claude/skills/cramapple-design/` was carrying the superseded red palette, so I
replaced its tokens, guidelines and readme. That **deleted** the old specimen
cards rather than superseding them in place. Recoverable from git, but it was a
repo-level change made on my own judgement.

### 22. Playwright is now a devDependency

The layout checks need a real browser. It is heavy, and it is in `web/`'s
`devDependencies` on my judgement — the alternative is that the no-scroll rule
is enforced by eye.

---

## How to use this

Working through it: entries 1–5 are closed, four of them because the claim was
wrong. **6 and 8 are cheap to settle and change real conclusions** — do those
first. 10 is the one I would most like overruled or confirmed. The rest can wait
for the session where we look at the plates together.

The pattern in 3, 4 and 5 is worth naming: each was a confident count over the
wrong source — one directory instead of the database, one column instead of the
table that actually holds the answer, draft rows mixed with published. Counting
something is not the same as counting the right thing, and all three read as
authoritative until checked.

New uncertainties get appended here rather than raised in chat, so the list
stays in one place.
