# Design System Cutover Plan — Current App → Project-Crux

STATUS: draft for Product Owner review | DATE: 2026-09-22 | AUDIENCE: David,
LLM-first entry point for any session picking this up.

This plan compares the live Cramapple product's current design system against
the new one produced by the Project-Crux design project, names every gap
between them, and proposes a cutover sequence. It does not move or relocate
any files — David is separately building a repo folder for the design system
and related artifacts; this doc should be cross-linked to that folder once it
exists, but its content stands on its own.

**Revision note (2026-09-22):** David decided to split the single
`exam-buddy-wireframe` codebase into two separate deployed projects —
`app.cramapple.com` (logged-in product) and `cramapple.com` (marketing +
signup funnel) — while this plan was still in draft. §6 (new) folds that
decision into the cutover: it's not a separate initiative, because both
projects need to launch on the same design system this plan is already
sequencing, and the split itself changes what "cut over" means (two
deploy targets, not one).

## 0. What was compared

- **Current, live system**: `exam-buddy-wireframe` (the production frontend,
  `david-bloom/exam-buddy-wireframe`), specifically `src/styles.css` (the
  `--ca-*` base tokens and `--cv-*` semantic aliases) and the live
  `/style-guide` route that documents them. Read directly from the repo, not
  from memory or the visual-identity brief docs (which describe an earlier,
  different direction — see §5).
- **New system**: `.claude/skills/cramapple-design/` in this repo — tokens,
  `readme.md` (the style guide), and `guidelines/` specimen cards. Per its own
  README, this was extracted from four HTML templates built in the
  Project-Crux design project (`Open Hand FRQ`, `FRQ`, `Open Hand MCQ`, `MCQ`)
  — no codebase, Figma file, or brand guideline document was given to that
  project, so everything in it is inferred from those four screens.

## 1. Side-by-side: what actually differs

| Dimension | Current (live) | New (Project-Crux) |
| --- | --- | --- |
| Background | Cream/newsprint paper (`--ca-bg-base` `#FAF8F3` light / `#14140F` dark) | White plate on a `--paper-100` desk; no dark mode defined |
| Brand/accent | Red `#E63946` (light) / `#FF5A66` (dark) | Red `#F5442E` — close in hue, different exact value, no dark-mode variant |
| Primary action color | Blue `#1D4ED8` (`--ca-action`), used product-wide for buttons/links/focus | Blue `#2B6CB0` reserved **only** for the rubric/credited-answer voice — not a general action color |
| Correct/credit | Green `#2D6A4F` | Green is reserved for **reference materials**, not correctness. Credit is marked with a `--blue-600` ✓, not green |
| Partial/warning | Gold `#E0A800` | No direct equivalent — closest is amber `#B5870B`, scoped narrowly to "revisit" marks, not general warning |
| Error/incorrect | Red `--ca-incorrect` `#E63946` (same hue as brand) | Clay `#B5502F` — deliberately **not** brand red, because "a lost point is a correction, not an alarm" (a real philosophical difference, not a palette substitution) |
| Student's own work | No dedicated voice — themed like everything else | Purple `#5B45A6` is a first-class, exclusive voice for the student's answer/input/feedback |
| Hints | No cost-gated hint system in the token/color model | Yellow is reserved exclusively for hints, and hints are a three-state economy (idle → asking-for-confirmation → open-with-receipt) — a **behavioral** system, not just a color |
| Typography | Single family: Plus Jakarta Sans (sans) + JetBrains Mono (mono), used for everything | Four families, each with one job: Bungee (wordmark only, never body), Passion One (display/titles only), Source Sans 3 (all reading/controls), STIX Two Math (set math only) |
| Corner radius | Rounded throughout: 6/8/10/12/16px scale, pill badges at 999px | Square, radius 0, everywhere, on every surface — "the most common way to break the system" per its own README |
| Motion | Defined easing/duration tokens (`--cv-ease-standard/entrance`, `--cv-dur-micro/default/reveal`) — the live product animates (confetti burst, transitions) | Explicitly none: "no transitions, no fades, no bounces... state changes are instant" |
| Layout model | Responsive React SPA, ~85 routes, scrolling pages, adapts to viewport | Fixed 1440×900 non-scrolling three-pane plate (352px / fluid / 324px), `overflow: hidden` at the frame — content must be cut or restructured to fit, never scrolled |
| Iconography | Not audited here (uses a component icon set per current routes) | No icon library at all — typographic glyphs (✓ ✕ ↻ ? ▸ ▼ ⌂ · em dash) plus two hand-drawn inline SVGs; explicitly rejects importing an icon set |

## 2. Coverage gap: what the new system has never touched

The new system was extracted from exactly four screens (Open Hand FRQ, FRQ,
Open Hand MCQ, Open Hand MCQ... i.e., FRQ and MCQ each in two modes). The
current product has roughly 85 routes. The new system has **zero** design
coverage for nearly all of them, including:

- **Entry/orientation**: `/home` (`HomeV2`, `TopicHome`), `/setup*`,
  `/onboard`, `/topic`, account creation, trial flow.
- **Course Mode-specific UI**: `SkillRail`, `ConfirmTransferBeat`,
  `CourseModeRepairPanel`, `StreakBadge`, `WorkedExample`, `LessonOpener`,
  `RepairBlock` — none of these concepts (skill rail, confirm-transfer beat,
  repair panel, streak) exist in the four extracted templates.
- **Homework Mode / bring-your-own-question**: `/bring-question`,
  `homework-help` components, capture flows (`CaptureItem`,
  `SameDeviceCapture`, `capture-phone`, `capture-demo`) — entirely
  undesigned in the new system.
- **Progress and review**: `/progress`, `dashboard`, `GradeResultView`
  outside the four templates' specific feedback-card treatment.
- **Marketing and top-of-funnel**: home page, `/how-it-works`, `/compare/*`,
  `/blog`, `/plan`, `pedagogy`, `about`, `contact-us` — the new system has no
  marketing surface at all; it was built for the in-session product only.
- **Commercial**: `/checkout/*` (Stripe), `/signup`, `/join`, `/trial*`.
- **Operational surfaces**: reviewer portal (`src/components/reviewer`),
  admin grading (`admin.grade-response`), tutor/reviewer login — none
  designed.
- **Motion-bearing moments**: `ConfettiBurst` and any other celebratory or
  transition-driven UI have no home in a system that defines zero motion.
- **Mobile/responsive**: the new system's plate is a fixed desktop frame;
  the current product is a responsive SPA. Nothing in the new system says
  what happens below 1440px, and the extracted templates were explicitly
  never asked to handle it.

This is the same shape of finding the four-source README itself flags in its
own "Status" section (components and UI kits "pending," several surfaces
explicitly "no tokens or components here yet") — this plan just makes the
product-surface consequence of that explicit.

## 3. Philosophical/behavioral gaps, not just visual ones

A few differences aren't reconcilable by re-skinning existing components —
they change what the product *does*:

1. **Color as assignment vs. color as theme.** The current system uses one
   accent (red/blue/green/gold) as a general-purpose brand palette applied
   wherever it reads well. The new system assigns each color a single,
   exclusive job (blue = rubric only, green = reference only, purple =
   student's own work only, yellow = hints only) and calls deviation from
   that assignment a violation of the system, not a style choice. Any
   component carried over has to be re-audited for what voice it's actually
   expressing, not just recolored.
2. **Square corners as a hard rule.** The current product's rounded-corner
   language (buttons, cards, the 999px pill badges used for status chips)
   has no equivalent — this touches essentially every existing component.
3. **No motion, ever.** The current product has an animation system
   (`--cv-ease-*`/`--cv-dur-*`) and at least one deliberately delightful
   moment (`ConfettiBurst`). The new system's "instant, no transitions" rule
   is a stated pedagogical choice ("the product's rhythm is read-decide-see"),
   not an oversight — reconciling this means either dropping celebratory
   motion or explicitly scoping an exception, not just swapping easing
   curves.
4. **Fixed-frame vs. responsive.** The three-pane plate assumes a
   1440×900 desktop viewport with `overflow: hidden` and content that is
   "sized to fit... never made reachable by scrolling." The current product
   is a normal responsive web app. This is the single biggest open
   architecture question in this plan (see §7, open decision 1) — everything
   else is downstream of how it's resolved.
5. **Hint economy is new product behavior, not new paint.** The three-state
   hint gate (idle → cost-disclosed confirm → open-with-receipt, receipt
   persists into the feedback card) doesn't exist in the current product's
   interaction model at all. This is a feature to build, not a component to
   restyle.
6. **No logo exists.** Both the current brief (`CRAMAPPLE_VISUAL_IDENTITY_BRIEF_v2.md`,
   still "Working draft") and the new system's README confirm this
   independently — the new system sets the wordmark in Bungee type wherever
   a mark would go and says explicitly "do not draw one." Any cutover needs
   its own answer to the logo question; neither source resolves it.

## 4. What transfers cleanly

Not everything is a gap. Genuinely reusable as-is or with light adaptation:

- The underlying React/TanStack Router architecture, data layer, and all
  session/grading logic — none of this is a design-system concern and none
  of it needs to change for a visual cutover.
- The MCQ/FRQ question-and-scoring data model the new system's templates
  render against is the same one the current product already serves from
  (per the new system's own sample content: AP Statistics Unit 2).
  The plate is a new presentation layer over the same underlying content,
  not a new content system.
- The pedagogical posture (name the error, don't judge the student; verdicts
  are one word; second-person imperative copy) is compatible with — and in
  places more precise than — the current product's existing tone. This is a
  copy-level tightening, not a rebuild.

## 5. A third document exists and should be reconciled, not ignored

`docs/product/CRAMAPPLE_VISUAL_IDENTITY_BRIEF_v2.md` (still `Working draft`)
describes a **third**, different direction: warm tinted darks, a two-token
emerald green accent system, Inter typography, geometric/abstract mark
options — explicitly reacting against a "cold/terminal" v1 aesthetic. This
is neither the current live `--ca-*` system (cream/red/blue) nor the new
Project-Crux system (white/red/blue/green/purple, square, no motion). Before
a cutover plan can be final, David needs to say whether the visual-identity
brief is superseded by Project-Crux, still in play for a future direction,
or was an earlier exploration that's now moot — otherwise there are three
competing "next design" references in the repo instead of one.

## 6. Repo split: app.cramapple.com vs. cramapple.com

David decided (2026-09-22) to split the current single-repo product into two
separately deployed Lovable projects: **`app.cramapple.com`** for the
logged-in experience, **`cramapple.com`** for marketing pages and the signup
funnel (folded together, not a third project — the funnel is the handoff
between "convince" and "log in," not a separate product). This section maps
today's ~85 routes to that split and names what it adds to the cutover.

### 6.1 Proposed route mapping

Using the same groupings as §2's coverage-gap analysis:

| Goes to `app.cramapple.com` | Goes to `cramapple.com` | Needs an explicit decision |
| --- | --- | --- |
| Entry/orientation once authenticated: `/home`, `/topic`, `/setup*`, `/onboard`, `/account` | Marketing/top-of-funnel: home page, `/how-it-works`, `/compare/*`, `/blog`, `/plan`, `/pedagogy`, `/about`, `/contact-us`, `/help`, `/privacy`, `/terms` | `/login`, `/logout`, `/reset-password`, `/account-created` — publicly reachable before auth, so likely live on `cramapple.com` and redirect into `app.cramapple.com` on success, but need to be assigned explicitly, not assumed |
| Course Mode + Homework Mode session UI: `/session/*`, `/bring-question`, `/progress`, `/dashboard`, capture flows (`capture-demo`, `capture-phone`, `hand-drawn-pilot`, `hand-drawn-responses`) | Commercial/funnel: `/signup`, `/join`, `/trial`, `/trial/verify`, `/checkout/*` | Operational/internal: `/reviewer-login`, `/tutor-login`, `admin.grade-response`, `beta.admin.health`, the reviewer portal (`src/components/reviewer`) — not student-facing marketing and not the student app either; needs its own home, possibly a third internal surface out of scope for this split |
| Subject content pages if they require entitlement/session state (`ap-statistics.unit-*`, etc. — needs a per-route check, not assumed) | Subject content pages if they're public SEO/reference content (`ap-*.glossary`, `ap-*.frq-tips`, `ap-*.practice-questions`, `ap-*.scoring`, `ap-*.study-plan` — these read as public marketing/reference content today) | `/attempt/$id`, `/resume`, `/ask`, `/ask-parent`, `/byoq`, `/check-work` — need a route-by-route check against whether they require an active session |
| | | `beta.*` routes — likely retired rather than mapped, but confirm nothing live depends on them before dropping |

This table is a first pass from route names and existing groupings, not a
verified audit — it needs a real pass against each route's actual auth
requirement before it becomes a migration ticket list.

### 6.2 What the split adds to the cutover, beyond the mapping

1. **Two deploy targets for one design system.** Whatever this plan decides
   in §5–§7 about tokens, components, and sequencing has to ship
   identically to both Lovable projects, or the product reads as two
   different brands depending on which subdomain a student is on. The
   design-system artifacts folder David is building (§ intro) becomes the
   single source both projects consume from — this makes that folder's
   existence a harder prerequisite than it was before the split decision,
   not just a nice-to-have.
2. **Auth/session handoff across subdomains.** A student reaches
   `cramapple.com`, signs up or logs in, and needs to land authenticated on
   `app.cramapple.com`. Cookies scoped to `.cramapple.com` (not
   `app.cramapple.com` alone) are the standard way to make this work without
   a token-passing redirect dance — this needs to be an explicit technical
   decision (§7 item 8), not an assumption that it'll "just work" because
   both are subdomains of the same root domain.
3. **Shared vs. duplicated non-design code.** Session/grading logic,
   Supabase client config, and the taxonomy/content layer currently live in
   one codebase. Splitting into two Lovable projects means deciding what's
   duplicated (acceptable for marketing-side read-only content queries) vs.
   what must stay single-sourced (grading, entitlements, anything
   security-sensitive) — this is a real architecture question, not a design
   one, but it's created by this split and belongs in this plan's tracking
   even though it's outside the design-system scope proper.
4. **Sequencing interacts with §7's cutover sequence.** Splitting the repo
   and cutting over the design system are two migrations happening at
   once. Doing both simultaneously multiplies risk; the sequencing options
   in §8 assume they're ordered relative to each other, not concurrent by
   default.

## 7. Open decisions (David's call) before sequencing is final

1. **Fixed-frame vs. responsive.** Does the three-pane 1440×900 plate become
   the product's actual layout (meaning the current responsive SPA gets
   rebuilt around a fixed frame — a major architecture change with real
   accessibility and mobile-access consequences), or does the new system's
   *visual* language (color assignment, type, square corners, glyph
   iconography) get adapted onto the current responsive architecture instead
   (meaning the plate itself is a reference mock, not a literal target)?
   This is the single decision the rest of the plan depends on.
2. **Visual-identity brief status.** Resolve §5 — is
   `CRAMAPPLE_VISUAL_IDENTITY_BRIEF_v2.md` superseded, parallel, or moot?
3. **Motion.** Does "no motion, ever" ship as stated, or is an explicit
   exception carved out for specific moments (e.g., `ConfettiBurst`)?
4. **Scope for v1 of the cutover.** Given the new system only covers
   MCQ/FRQ practice (§2), does the first cutover ship *only* that surface
   (leaving Home, marketing, progress, etc. on the current system until
   designed), or does David want the new system's principles extended to
   the undesigned surfaces before anything ships, so the product isn't
   visually split mid-migration?
5. **Logo.** Neither source has one. Does this block the cutover, or ship
   with the type-only wordmark treatment the new system already specifies?
6. **Dark mode.** The current product has one; the new system doesn't define
   one. Decide whether dark mode is in scope for v1 or deferred.
7. **Owner and reviewer for the folder David is building.** Once the
   design-system artifacts folder exists, this plan should be moved or
   linked into it, and a Task ID/owner assigned per the repo's normal
   `TASK_WORKFLOW.md` process — not done here since that folder isn't
   in place yet.
8. **Auth/session handoff between the two subdomains (new, §6.2 item 2).**
   Confirm the cookie-scoping approach (`.cramapple.com`) as the mechanism,
   or specify an alternative, before either Lovable project is built —
   this is foundational to both, not a detail either can defer.
9. **Route mapping and shared-vs-duplicated code (new, §6.1–§6.2 item 3).**
   Turn §6.1's first-pass table into a verified route-by-route assignment,
   and decide what session/grading/content code is shared (how) vs.
   duplicated between the two projects.
10. **Repo-split vs. design-cutover sequencing (new, §6.2 item 4).**
    Decide whether the subdomain split happens before, after, or alongside
    the design-system cutover — §8 proposes an order below, pending this
    decision.

## 8. Proposed cutover sequence (pending decisions 1, 4, and 10 above)

This sequencing assumes decision 1 resolves toward "adapt the new visual
language onto the current responsive architecture" (the lower-risk path),
decision 4 resolves toward "ship MCQ/FRQ practice first," and decision 10
resolves toward doing the design cutover **before** splitting repos (design
cutover in the single current codebase, then split into two projects that
both start from the already-cut-over state — fewer moving parts than
splitting first and cutting over twice). If any of these resolve the other
way, this sequence needs to be rewritten, not just relabeled.

0. **Repo split (if decision 10 puts it first instead — otherwise this step
   moves to the end).** Stand up `app.cramapple.com` and `cramapple.com` per
   §6.1's verified route mapping, with the auth/cookie handoff from §7 item 8
   working end-to-end, before either project touches the design system.
1. **Token layer swap.** Replace `--ca-*`/`--cv-*` values with the new
   token set where a direct mapping exists (§1 table); add new tokens
   (clay, purple, amber, teal) as additive, not replacing existing
   semantic names, so nothing downstream breaks silently.
2. **Typography swap.** Load Bungee/Passion One/Source Sans 3/STIX Two Math;
   replace Plus Jakarta Sans role-by-role per the new system's type-role
   table, not as a blanket find-replace (display vs. body vs. math each
   have different rules).
3. **Corner radius and motion.** Flip the radius scale to 0 and either
   remove or explicitly exempt motion, per decision 3.
4. **Build the missing component families.** The new system's own README
   lists nine pending component families (pane shell + score chip, hint
   gate, radio option row, rubric criterion row, feedback card + verdict
   chip, breadcrumb + study map, deep dive overlay, action row, question
   header + graph frame) — these need to exist before MCQ/FRQ practice can
   actually cut over, not just the four full-screen templates.
5. **Cut over MCQ/FRQ practice screens** (`session/mcq`, `session/frq`,
   `GradeResultView`, `WorkedExample`, hint-related components) onto the
   new components once built.
6. **Everything else (§2's list) stays on the current system** until each
   surface gets its own design pass, tracked as follow-on work once the
   design-system folder and its owner are established (§7 item 7).
7. **Repo split (if decision 10 puts it last instead of first — see step 0).**
   Once the design system is cut over in the single codebase, split into
   `app.cramapple.com` and `cramapple.com` per §6.1's route mapping, with
   both projects already sharing one design-system source rather than
   forking it mid-split.

## 9. What this plan does not do

It does not move any files, does not create the design-system artifacts
folder (David is building that separately), does not resolve any of §7's
open decisions, and does not commit to the sequence in §8 as final — that
sequence is explicitly conditional on decisions 1, 4, and 10. Once those are
made, this doc should be revised to drop the conditionals and, per §7 item
7, relocated into the folder David is setting up.
