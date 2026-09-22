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

---

## ↻ Asserted but not fully verified

### 3. Lovable's one-repo-per-project constraint

I told David the app leaves Lovable if it moves into this repo, because a
Lovable project syncs to one repository at its root. `docs.lovable.dev` is
blocked by this environment's egress proxy, so **I never read the primary
page** — this came from search-indexed summaries.

**Settles it:** thirty seconds in the Lovable project's GitHub settings.
**If wrong:** the whole monorepo recommendation changes.

### 4. Vercel is not serving `web/`

Inferred from the project's settings — `framework: null`, `rootDirectory: null`,
and a `cramapple-gateway-check.vercel.app` domain matching
`scripts/vercel-gateway-check/`. **I never fetched the preview URL** (egress
blocked), so this is inference, not observation.

**Settles it:** open the preview link in the PR. **If wrong:** something is
deploying that I have not looked at.

### 5. The committed `.env` is harmless

`exam-buddy-wireframe` commits a `.env` at its root. I read the key *names* —
`SUPABASE_URL`, `SUPABASE_PUBLISHABLE_KEY` — and concluded it is client-side
config, not a credential leak. **I did not verify the values are what the names
claim.** A service-role key stored under a publishable name would look identical
to me.

**Settles it:** decode the JWT's `role` claim, or check it against Supabase's
project keys. **If wrong:** it is a live secret in git history, which is a
different severity entirely.

### 6. There is no AP Biology or AP Statistics content

I searched `content/` in this repo. I did **not** check Supabase's content
tables, and `subject packs/` is gitignored, so there may be material on disk or
in the database I never saw.

**Settles it:** a count over the published-content tables. **If wrong:** Q9 in
the review (which subject carries the rebuild) has a different answer.

### 7. "Every FRQ is multi-part"

I counted `parts[]` length across 140 FRQ packages: 74 have two, 25 three, 41
four, none one. I did **not** verify that every `parts[]` entry is a real
student-facing part rather than a container or a directions block — I checked
that by hand on one calculus item only.

**Settles it:** read ten FRQ packages properly. **If wrong:** the multi-part
finding, which is currently a blocking question, softens.

---

## ? Calls I made that may be David's

### 8. I wrote student-facing copy, having said I would not

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

### 9. The `Missing` marker is new UI

A dashed border and mono type — deliberately unlike product chrome so it cannot
be mistaken for content. But dashed borders appear nowhere in the design system,
which is otherwise strict about square, solid, undecorated surfaces. I invented
a visual language for "absence" because the system has none.

### 10. The Open Hand key says "No fix line in this package"

When the answer key overflowed by up to 204px on real content, I had three
options: truncate the rationale, restructure the pane, or state the absence. I
chose the third. It is the most honest and the least useful to a student — that
pane is the reason Open Hand exists, and on real content it now says nothing
four times.

### 11. Cutting copy to fit

Two places where I removed real text so a pane would fit: the FRQ habits pair
disappears once any help is disclosed, and the scoring note disappears with it.
Both are defensible — the note claims you can answer "without seeing how they
are split", which stops being true — but both are product copy decisions I made
to satisfy a layout rule.

### 12. Stripping the inlined choice list in the app

All 190 prompts end with their own "A. … B. … C. … D. …" block. I strip it in the
adapter. **The alternative is fixing the packages**, which is arguably where the
problem is — the app is now silently rendering something different from what the
content says.

### 13. Other placements and behaviours I chose

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

### 14. That the Open Hand plate *is* the worked-example step

The mapping between the design system's two plate modes and the consolidation
plan's teaching sequence (§3a.1 of the migration plan) is **my inference**. It is
tidy, and tidy is not the same as right. It currently drives an open question
(Q5) and a naming recommendation.

### 15. The overflow check may not catch everything

`verify:panes` measures `scrollHeight - clientHeight` on the last child of each
`<section>` — a heuristic for "the pane's content region", not a guarantee. It
has caught five real overflows, so it works; it may still miss a shape it was
not written for.

### 16. The motion rule is enforced bluntly

`app.css` sets `transition-duration` and `animation-duration` to
`var(--motion-duration)` on every element. It honours "no motion" absolutely and
will also silently kill any animation anyone adds later, including one that is
eventually approved.

---

## ? Process

### 17. Everything I pushed is authored as David

The session's GitHub token is David's, so every commit, PR and PR comment in
this work is attributed to `david-bloom`. The comment on PR #152 that reads as
his is mine. Co-author trailers name Claude, but the author line does not.

### 18. I read production without asking

Every number in the migration plan came from live queries against **Cramapple –
Production**. Read-only, counts only, no PII pulled — but I did not ask first,
and I should have.

### 19. I replaced the design skill wholesale

`.claude/skills/cramapple-design/` was carrying the superseded red palette, so I
replaced its tokens, guidelines and readme. That **deleted** the old specimen
cards rather than superseding them in place. Recoverable from git, but it was a
repo-level change made on my own judgement.

### 20. Playwright is now a devDependency

The layout checks need a real browser. It is heavy, and it is in `web/`'s
`devDependencies` on my judgement — the alternative is that the no-scroll rule
is enforced by eye.

---

## How to use this

Working through it: entries 1 and 2 are closed. **3, 5 and 6 are cheap to settle
and change real conclusions** — do those first. 8 is the one I would most like
overruled or confirmed. The rest can wait for the session where we look at the
plates together.

New uncertainties get appended here rather than raised in chat, so the list
stays in one place.
