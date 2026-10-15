# Activity Log

This log records meaningful operating activity, approvals, closeouts, blockers, and handoffs. Newest entries are at the top.

## Index

Most recent entries (full reverse-chronological list follows below):

- More help work reassessed after today’s log updates (2026-10-15): #460 is merged; Chemistry2.5 is already published under standalone APPROVAL-0177 and removed from the prepared run. TASK-0076 covers four possibly mistagged expanded-octet questions. Fresh Production metadata: AB80/BC3 mapped versions lack references, Chemistry0;166 lack selected topic mappings. Preserve backend/app repair checkpoints and completed Development fixture/rollback QA; no new provider calls or deployments. Temporary synthetic QA setup restored. [Reassessment](../qa/MORE_HELP_REASSESSMENT_2026_10_15.md) names current evidence, remaining gates and revised next owners/actions.

- Help-coverage audit and Chemistry 2.5 session closed (2026-10-15): Units 1-3 audit found one real gap (Chemistry 2.5, 8 questions); entry published to Development and Production by Product Owner override (`APPROVAL-0177` standalone record), `TASK-0076` opened, the three logs rotated to 2026-10-01 onward, PRs #459 and #460 resolved and merged. Open items, owners and paths: `docs/handoffs/HELP_COVERAGE_AUDIT_SESSION_CLOSE_2026_10_15.md`.
- More help gap catalog and PR #457 merge (2026-10-15): [15 gaps with reasons/evidence/next owners](../qa/MORE_HELP_GAP_CATALOG_2026_10_15.md). Corrected stale restart surfaces: all four migrations and JWT-verified Production v1 are live; nine deployed files equal Development v10 and main. Publication request and bounded owner smoke already recorded in APPROVAL-0169/0170. Image questions are refused; multipart/figure grounding needs targeted tracing. Independent/full live matrix, human red-team and specific fixture/call proposal remain open. PR #457 merged as 04020e15 with all checks passing after main integration; no new runtime/data/provider change. Next owner independent reviewer/conductor: final-source review and smallest concrete QA packet.
- Reference pack session closed (2026-10-15): six skew figures live and re-ordered (`APPROVAL-0170`/`0172`), `DECISION-0124`, batch 4 (semi-log and diprotic titration) gated on a swapped reader slate, app published (`APPROVAL-0175`), loaded to Production (`APPROVAL-0176`, 88 figures / 96 uses) and confirmed by David; #456, #458 and `ap-prep-blueprint` #27 merged. Open items, owners and paths: `docs/handoffs/REFERENCE_PACK_SESSION_CLOSE_2026_10_15.md`.
- Question-visual session closed at David’s request (2026-10-15): [durable closeout](../handoffs/SESSION_CLOSE_2026_10_15_QUESTION_VISUAL_COMPLETENESS.md) records the reusable plan for finding missing visuals, semantic negative controls, rendering/private storage/delivery, the 726-source audit, ten scope resolutions, six live v2 images and bounded independent visual PASS. No new live changes at close. PR #457 remains open; latest main merged to retain separate batch-4 records. Next owner David: review/merge PR #457. Next implementation owner student-app maintainer: fix authored FRQ parts missing from apcalcab-frq-u13-002, preserving the approved images. Periodic-table link merged; its publication is not verified.
- Calculus AB/Chemistry Units 1–3 required-visual certificate issued PASS (2026-10-15; APPROVAL-0174):726 source reviews, 198 fresh independent semantic reviews, all 10 audit-unit uncertainties resolved; six live v2 privateimages. Phone QA found22px labels shrank below 16px; all six now26px with measured 17.638px minimum at 320 CSS. Both final attachment/recovery mutation rehearsals passed; six signed checksums/publicdenials and 12 desktop/phoneviews verified. Source/scoring/choices/taxonomy/VR unchanged. Certificate is limited to missing visuals: one FRQ screen omits authored parts, a teaching page has3px page overflow, ordinary-student authorization/expiry/scoring and knownsession defects remain separate. Link PR #28 merged/CIpass butappnotpublished becausemainincludes unrelated unpublishedrenderers. Chemistry1.5 andAB2.1 restored; concurrentPrecalc2.15active selectionpreserved. [Certificate](../qa/CALC_CHEM_U13_VISUAL_COMPLETENESS_CERTIFICATE_2026_10_15.md). Next owner app maintainer: partdisplay/session/overflow fixes; wider-subjectaudit isfuturework.
- Calculus AB/Chemistry image-certification audit completed (2026-10-15): all 726 published versions semantically reviewed, including keyword-negative and unit-uncertain rows; all ten uncertain candidates resolved for audit membership (1 strict Units 1–3, 9 later), no taxonomy writes. Four prior images live; two additional exact-source constructs built/tested and visually inspected, not uploaded/attached. Owner accepts existing periodic-table access; Chemistry-only official PDF-link patch prepared, 13 targeted app tests/build pass. Corpus/ledger/resolutions and review packet saved; fresh independent QA and final delivery checks remain before certification. Approval ID collision with concurrent main reconciled: four-image approval is now APPROVAL-0173 (original executed SQL comments retain 0168). Next owner Codex after independent-agent authorization: fresh QA, two attachments and bounded certification.
- Live browser follow-up for the four question visuals (2026-10-15): the existing sign-in resumed, and all four images rendered in app.cramapple.com: AB 1.3 worked example, both AB FRQs in practice, and Chemistry 3.8 worked example. Complete images have expected 680px natural width and 622.65625 CSS px display width; alt text present. No answers/grading submitted; one FRQ skipped, course selections restored. Screenshots and precise scope in [browser report](../qa/QUESTION_IMAGE_LIVE_BROWSER_CHECK_2026_10_15.md). Owner admin account in student-facing views, with separate prior authenticated-student RPC checks; no independent QA or phone-browser claim. Found a separate reproducible subject-switch defect: new topic heading can retain old subject’s worked question/answer until view remount. Next owner app maintainer: fix stale worked-example state; audit conductor: periodic-table and ten unresolved-unit queues. No new content/app/function/schema deployment.
- Four question visuals attached to live Production questions (2026-10-15 01:40:28 UTC; APPROVAL-0168): four checksum-pinned compact PNGs in private content-assets, four exact published-version paths, approved accessibility metadata and required/approved decisions. Rollback rehearsal and atomic source/scoring/taxonomy invariance checks passed. Four signed downloads match SHA-256; four public reads blocked. Authenticated student-role teaching RPCs select the correct Calculus AB 1.3 and Chemistry 3.8 examples with images. No app/function/schema deployment. Signed-in browser rendering unverified (signed out); ordinary RPC role probe unavailable (no AB-active student profile); no fresh independent QA verdict. Release evidence and guarded, unexecuted rollback in scripts/question-visuals-pilot/. Next owner David/signed-in QA: visually confirm the two worked examples and two FRQs; wider audit and periodic-table check remain separate.
- Four question visuals built on David's “Build the 4” instruction (2026-10-14 America/New_York): deterministic graphs for `apcalcab-frq-u13-002`, `apcalcab-frq-u13g-1-3`, `apcalcab-oht-1.3` plus exact 8/16-particle diagrams for `apchem-oht-3.8`. `scripts/question-visuals-pilot/` holds sources, renderer, 3 layouts each (12 SVG/PNG pairs), accessible descriptions, content/asset hashes, immutable-path proposals and preview. Eight tests pass including byte-identical rebuild, all layouts inspected; clipped compact y-axis title fixed. Live published source text hashes match all four. One unspecified curve's interpolation is documented, with no answer annotations. These are question build artifacts; reference figure catalogue unchanged, no database writes/uploads/deployments. Next owner independent reviewer/delivery implementation: review artifacts and wire an authorized Development batch; Production release remains separate.
- Question-visual pilot source review completed (2026-10-14 America/New_York): all 91 scoped Chemistry/AB candidates read question by question. **86 no missing prompt image identified; 4 visual-construct concerns (3 AB graphs, 1 Chemistry particle diagram); 1 periodic-table delivery dependency.** Per-question reasons, exact versions/digests and corrected source inputs saved in `question_image_pilot_review.json`; [report](../qa/QUESTION_IMAGE_PILOT_SOURCE_REVIEW_2026_10_14.md). Found and fixed the audit query's use of answer-bearing legacy `frq_criteria.learner_facing_text` as prompts; now reads authored `parts[].prompt` only. This was a source review, not blind independent QA or browser certification. Ten unit-unresolved rows remain separate; no database writes or images created. Next owner independent subject reviewer/audit conductor: adjudicate the four, verify periodic-table and actual student delivery, then prepare a repair manifest.
- ASCII Maths Cleanup Rulings Recorded (2026-10-14): Product Owner approved `TASK-0075` in two tiers (383 answer choices, then all 1,664 in-scope rows), LaTeX everywhere, exponents in units converted (`DECISION-0125`). Drafting starts with Tier A; no Production write without explicit approval of each batch.
- Question-visual pilot scope narrowed by David (2026-10-14): focus on Chemistry and Calculus AB, Units 1–4, within the original 350 candidates. Read-only repeat of the same candidate rule yields 105 across the two subjects: **91 in scope (Chemistry 20, AB 71), 10 unresolved unit labels, 4 beyond Unit 4**. No confidently resolved Unit 4 candidate; one Chemistry row provisionally includes 4. Query and all 105 version identities/unit evidence frozen in `question_image_pilot_scope.sql`/`.json`; [plan](../tasks/WORK-QUESTION-IMAGE-COMPLETENESS.md) and PR #455 updated. Full-catalogue census and Physics/Biology starting queue deferred. Next owner Codex: semantic classification of the 91 and separate scope reconciliation of the 10; no assets, paid calls or database writes.
- Required question visuals audit session opened (2026-10-14 America/New_York): read-only Production screen covers 2,915 published versions, three existing required/missing decisions, five Biology paths without approved metadata and zero question-targeted figure uses. Historical-rule screen returns 350 lexical leads, not confirmed defects; new all-published inventory query verified at 2,915 rows. Proposed [audit, rendering, storage and delivery plan](../tasks/WORK-QUESTION-IMAGE-COMPLETENESS.md) plus compact snapshot committed on `codex/question-image-audit-plan`. Deployed student-session-items v40 includes a teaching-image branch absent from backend main; reconcile before later deployment. No paid calls, assets, database writes or deployments. Next owner Codex: freeze inventory and classify all versions, starting with known-missing/metadata pilot; independent defect review and implementation/release approvals remain.
- More help browser QA and session close (2026-10-14): nested fraction digits fixed from 11.7px to 23.4px in tested expressions; local actual-component phase/pending-help/focus/layout checks, 1,144 app tests/typecheck/build and CI pass. David confirmed rendering. Backend #442, app #25 and QA docs #448 merged; independent/human/live coverage and fixture/call decisions remain open. Session ended at owner request, no Production release. [Handoff](../handoffs/MORE_HELP_SESSION_CLOSE_2026_10_14.md). Next owner David/independent QA session; next action updated independent prompt.
- ASCII Maths Inventory Done, Control-Character Fix Opened (2026-10-14): read-only `TASK-0075` inventory found 2,585 published rows with ASCII maths, 1,664 in scope (rubric text and FRQ stems excluded; the grader reads them); rulings requested before any drafting. Separately, PR #446 strips stray control characters from model-written grading text (no deployment). No Production write.
- LaTeX Rubric Edits Dropped, Grader Test Closed (2026-10-14): `TASK-0074` Gateway pilot (53 valid grades) could not show a LaTeX rubric grades the same (one borderline cell changed, p = 0.40; one stray-markup string; control characters in both forms). Product Owner chose Option A: the ten rubric rows stay plain (`DECISION-0122`); `TASK-0073` Phase 2 dropped, `TASK-0074` complete. Follow-up review written next to Codex's report; no model calls, writes or deployments.
- LaTeX Prose Pilot Phase 1 Written to Production (2026-10-14): on the Product Owner's explicit instruction, 21 `mcq_choices` edits (20 choice texts, 1 rationale) across Precalculus, Physics C E&M and Physics C Mechanics were applied in one all-or-nothing transaction (each edit guarded by exact before-text and pinned version; affected labels captured and restored). Second Codex QA findings (statement timeout, choice-to-version pinning) were fixed first. Verified after: 21 edited rows, 11 labels still `validated` and in sync with provenance intact, 0 stale. Deferred: 10 rubric edits (`TASK-0074`); dropped: 3 explanation edits. Private QA branch `qa/latex-prose-pilot` still to be deleted.
- More help PR #442 blocker (2026-10-14): unresolved Vercel conversation required resolution; all checks passed and branch was current. Confirmed missing zero-denominator/zero-change predicate, restored it with four regressions; 26 tests/typecheck pass. Development v10 source graph matches upload; no paid calls, database writes or Production changes. [Disposition](../qa/MORE_HELP_RELEASE_QA_REMEDIATION_2026_10_14.md).
- More help Claude follow-up QA remediation (2026-10-14): preserved follow-up e365d52b unchanged; fixed N1 setup false positives, added N2 explicit choice tripwires, reset N3 answer controls without losing pending help and covered N4 supplied rate conclusions. Backend 6e2de1b1 / integrated app c5c26997; 26 backend / 1,142 app tests, typechecks/build pass. Development v9 source graph matches deployed files byte-for-byte. No database writes, paid calls or Production changes; independent/browser/human QA and prior fixture/call decisions remain pending. [Disposition](../qa/MORE_HELP_RELEASE_QA_REMEDIATION_2026_10_14.md). Concurrent main changes preserved; original app #24 had merged externally, so phase reset is new draft #25.
- More help Claude release QA remediation (2026-10-14): preserved Claude report e5850eda; fixed whole-source leak scans, wider targeted disclosure checks, sibling rate phrasing, delivered-request recovery and grading-transition lifetime. 26 backend / 1,130 app tests, typecheck/build pass; Development v8 deployed. Prepared a pinned 3-MCQ Development mirror and 12-call synthetic-work Gateway QA plan; writes/calls await separate authorization. F6 and wider semantic/browser/grading coverage remain open. [Disposition](../qa/MORE_HELP_RELEASE_QA_REMEDIATION_2026_10_14.md).
- More help release QA prompt (2026-10-14): owner requested a QA prompt. New packet targets merged backend main 70f4a348 and private app main 75c0b18, separates code/release verdicts, requires subject/type/phase evidence and real submission/visual checks, preserves call/write authorization boundaries and orders remaining Production rollout gates. No reviewer dispatched or runtime changes. [Prompt](../qa/MORE_HELP_RELEASE_QA_PROMPT_2026_10_14.md).
- ASCII Maths Cleanup Queued (2026-10-14): published-app screenshots showed ASCII notation (`lambda`, `rho`, `sigma1*(2*pi*r*l)`, `E.dA`) left in stems and lesson notes, plus a bracket-free quotient the pilot detector missed. Product Owner asked to queue it; `TASK-0075` opened (inventory first, notation rulings, then the `TASK-0073` machinery). No Production write.
- LaTeX Pilot: Independent QA, Phase 1 Narrowed to MCQ Rows, Grader Test Opened (2026-10-14): Codex QA recommended no write of the first transaction; the Product Owner approved a 21-row MCQ-only Phase 1, dropped the explanation edits and opened `TASK-0074` to test whether the grader handles LaTeX before the 10 rubric edits. No Production write.
- LaTeX Prose Rollout Scoped to a Pilot (2026-10-14): David ruled display-only stacking for prose (`DECISION-0121`). A Production read showed the problem is about 1% of prose and concentrated in math-heavy courses, so he approved author-forward plus a targeted backfill, Precalculus and Physics C first (`TASK-0073`). Documentation only.
- More help Gateway fix verification (2026-10-14): owner approved bounded QA; three of six permitted calls returned validated 200 responses for AB, BC and Chemistry. Observed AB subpart answer withheld and answer-bearing fact excluded; BC valid; Chemistry now covered. All three receipts delivered and QA entitlement dates restored. Development v7, 22 backend tests/typecheck pass; independent/full release QA still open. [Verification](../qa/MORE_HELP_GATEWAY_FIX_QA_2026_10_14.md).
- More help first Anthropic Gateway live QA (2026-10-14): key present; owner explicitly approved three bounded calls. AB generated with a conceptual-subpart disclosure concern; BC failed validation; Chemistry not called. Two calls attempted, failed BC receipt not delivered. Three QA entitlements temporarily extended then restored. Backend #435 merged; app #21 draft. Release blocked. [Evidence](../qa/MORE_HELP_GATEWAY_LIVE_QA_2026_10_14.md).
- More help Claude QA remediation (2026-10-13): confirmed and fixed the runtime-role permission defect; owner selected targeted disclosure + human QA, separate delivery/request limits and Anthropic Gateway preparation. Role-correct SQL passed with the QA account and rolled back; 1,102 app / 18 backend tests pass. Gateway key, live QA, MCQ fixtures and private app follow-up pending; Production unchanged. [Disposition](../qa/MORE_HELP_CLAUDE_QA_DISPOSITION_2026_10_13.md).
- More help real-app implementation and Claude QA packet (2026-10-13): owner confirmed Calculus AB/BC and Chemistry in app.cramapple.com. Backend PR #435 is implemented in Development; app PR #21 is draft. Delivery-only assistance and UI remediation committed; 1,101 app tests and 9 backend tests pass. Actual generation remains blocked by exhausted API credits; Production unchanged. [Work order](../tasks/WORK-MORE-HELP-PRODUCTION.md) and [Claude adversarial prompt](../qa/MORE_HELP_CLAUDE_ADVERSARIAL_QA_PROMPT_2026_10_13.md) preserve exact SHAs and the API-versus-subscription review request.
- Session Close — LaTeX Rendering Live, Visual Size Standard Set, Figures Fixed on the Notes Page, Rollout Still Open (2026-10-13): closing the equation-presentation session. **Shipped and published:** the KaTeX renderer across three surfaces (`ap-prep-blueprint` #16), the legibility fix that made it readable (#19), and notes-sheet figures one per row (#20, `f0fbcdf`), with `DECISION-0119`, `DECISION-0120` and `TASK-0072` recorded. Confirmed in Production by the Product Owner, signed in. **The LaTeX rollout into question and teaching prose is NOT started** and is the reason to read the handoff: prose carries zero LaTeX product-wide, and the real target is **415 rows matching `(compound)/(compound)`** across ten columns — not the 7,214 slash-bearing rows, of which 969 are units and 553 are Leibniz notation that the rule keeps inline. **One design question must be ruled before anyone edits those rows:** the rule stacks a compound quotient, which applied literally stacks inline mid-sentence; display-only stacking for prose is a live alternative, and deciding it late means doing the pass twice. **Size standard:** the 16px floor binds on the smallest rendered glyph a student must read, not the element, and compliance is by measurement, never inspection. Maths complies; notes figures comply at ≥~1130px; the reference pane, narrower widths and phones do not, by ruling. **Traps recorded** because each cost real time: Production cannot be checked logged out (`curl -L` returns the marketing site), a 200 is not a body (the npm mirror served empty tarballs that hashed as a valid-looking match), the preset must be read off the calling component (the notes sheet renders `full`, not `compact`), and the decisions-log index head is stale. Record: `docs/handoffs/LATEX_ROLLOUT_AND_VISUAL_SIZE_SESSION_CLOSE_2026_10_13.md`. **Next Owner:** David Bloom. **Next Required Action:** rule inline-vs-display for prose maths, then open the rollout task and pilot one surface on one subject before widening.
- Rendered Maths Made Legible, a Size Standard Written, and the Published Figures Measured Below It (2026-10-13): the `DECISION-0119` renderer shipped and rendered correctly, but David's first reaction in Production was that the maths was **too small to read**. The cause was not the font size on the container — KaTeX's inline style renders a fraction's numerator and denominator at `size3` (0.7×), so a 17px container gave ~12px digits, and **raising the container could not fix it because the shrink is relative to it**. Fixed by rendering in display style at a 1.3em base (digits now ~20.8px against 16px prose); applying display style to one-symbol labels was itself a regression, caught in a screenshot — `\sum_i` became a full-height sigma with its index beneath, 48px against a 24px row — so labels render compact. Merged and published; David: "it looks much better". **The standard is now written** (`DECISION-0120`, `VISUAL_IDENTITY.md` → "Sizing what a student reads"): the 16px floor binds on the **smallest rendered glyph a student must read**, not on the element, and compliance is established by measurement, not inspection. **Applying it to the figures found a live problem:** across 47 rendered figures and 526 labels, **99.8% render below 16px and 87.1% below 12px** (median 9.8px, smallest 8px) — smaller than the maths that was rejected as unreadable — and the authored scale in `lib/figures/render.ts` is itself under the floor, so it is not an artefact of one layout width. **Documentation only; the figure remediation is open and deliberately not authorised here** — enlarging type inside a fixed viewBox costs layout room, so it needs its own task and the three-gate figure verification rather than a global constant bump. **Next Owner:** David Bloom. **Next Required Action:** decide whether the figure resize becomes a task, and whether the ~402-row prose retrofit does.
- Equation Presentation Rule Recorded; the Real Defect Is a Missing Renderer, Not Slashes in Content (2026-10-12): David asked for division to be stacked rather than written with a slash. Investigation found the premise was half right, and the halves live in different places. **Reference-pane formulas were already correct:** of 327 formula entries in Production (325 published), 144 use `\frac` and exactly four contain a slash — all four legitimate (`t_{1/2}`, `d/7`, `b^{1/k}`, the unit `m/s`). **Zero content violations.** The defect is that the app never renders any of it: `ReferencePane.jsx` prints formula bodies as monospace text, so **308 published formulas reach students as raw LaTeX backslashes** — already logged in the reference protocol as a non-blocking open design item, now reclassified as a tracked defect. **The slash problem is real but lives elsewhere:** question and teaching prose (stems, choices, rationales, FRQ criteria, explainers, briefs) carries **zero** LaTeX and writes compound quotients inline, e.g. `(x²−4)/(x−2)` and `(214 - 190)/(6 - 5)`. **A macro survey decided the renderer:** 74 distinct macros across the 308 formulas, including `\begin`/`\end` environments, `\oint`, `\binom` and `\mathcal` — a hand-rolled subset renderer would have silently broken a long tail. David chose KaTeX in its own faces against a side-by-side rendering of real published formulas (`docs/product/EQUATION_PRESENTATION_RENDERING_COMPARISON_2026_10_12.html`, zero render errors), which **amends** the `VISUAL_IDENTITY.md` STIX Two Math rule, annotated in place. Recorded as `DECISION-0119`; rule written into `docs/new_design/CONTENT_AND_PEDAGOGY.md` with the four conventional slashes that are kept. **Documentation only — no Production write, no migration, no app change.** **The renderer shipped the same session** (`ap-prep-blueprint` PR #16, `2bb35c6`, Lovable-published): three surfaces printed LaTeX source, not one, and all 321 distinct published formula bodies now render cleanly. **Confirmed in Production 2026-10-13** by the Product Owner, signed in: Lesson Notes renders the difference quotient and both derivative limit forms as stacked fractions. **The same screen also shows the prose gap exactly:** the Weak answer and Point-attaining answer sections sit directly above, still reading `(f(4)-f(1))/(4-1)` inline, because they are `topic_explainers` prose and carry no LaTeX to render. **Next Owner:** David Bloom. **Next Required Action:** decide whether the prose retrofit — ~402 genuine compound quotients, not the 7,214 slash-bearing rows — becomes its own task with a notation decision and a Production hard gate.
- Hooks Permitted in Hints and Targeted Help; Reference Packs Verified Already in Production (2026-10-12): David approved the D5 placement amendment (`DECISION-0118`, `APPROVAL-0164`). Live read-only comparison found 1,083 published entries and 13 hooks equal between Development and Production; no promotion needed. Policy and stale status pointers updated; no app, agent, schema, or deployment change.
- Session Close — Every `kind='diagram'` Entry Has a Figure; `function_plot` Still Development-Only (2026-10-12): the figures programme reached **0 published `kind='diagram'` entries without a figure in Production**, from 41 when it started. **Shipped and live:** the AP Statistics `density_curve` batch (10 figures, `APPROVAL-0160`) and the **five Lane B gaps** (`APPROVAL-0162`) — AP Biology 1.6/2.3/3.4/3.5 and AP Chemistry 9.8 — on four new renderer families (`organelle`, `dna_ladder`, `membrane_bilayer`, `electrochemical_cell`). Production moved 49 → **54 published figures, 18 → 22 families, 57 → 62 uses, 51 → 56 entries**. **The §4.4 question — artwork or renderer — was settled by the Product Owner with "build it properly", and the design that answers it generalises:** make the family DERIVE what it asserts, so the wrong picture is unrepresentable. The DNA spec names one strand and the partner base plus its hydrogen-bond count follow from the pairing rule; each membrane inclusion's geometry follows from its kind; every arrow in the galvanic cell follows from which side the anode is on. **The consequence is now protocol §4c:** a family that cannot draw a wrong picture leaves the property tests nothing to catch, so all remaining risk is in the words and the gate-4c controls must be TEXT controls — three of the five (reversed proton gradient, sugars on the cytoplasmic face, anode label left on the cathode) pass the property suite cleanly, and **both non-Anthropic readers rejected 5/5 controls and accepted 5/5 figures**. **Each gate caught something disjoint, again:** 3,848 property checks (0 failed) pinned what nobody eyeballs; the **eye** found four defects no test could see (a label laid across the hydrogen bonds it named, cristae floating free of the membrane they are folds of, a glycolipid drawn as a bare head with no tails, three overprinting labels), all now tests; the readers caught alt text asserting the anode loses mass when the figure names no electrode material; and the **219/219 byte-parity run across 23 families** caught a defect in code already shipped — the app painted open circles BEFORE the curves, so `precalc-hole`'s hole was filled in by the curve's own stroke at every size. **Verified on Production as a real authenticated student**, not `service_role`: each topic serves its own figure and family, a topic with no figure returns 0, AP Statistics 2.11 still serves its 5, and a planted draft stayed invisible before being rolled back; the five rows are byte-identical to Development by digest. **The correction that matters most:** the first draft of the session-close document claimed `function_plot` was live. It is not. Querying `app.figures` per family in both environments shows **`function_plot` — 19 figures over 15 entries — is built, gated, ported, merged and sitting in Development only**, and is the entire Dev/Prod difference (Dev 73/23/81/71 vs Prod 54/22/62/56), which means **AP Precalculus and AP Calculus AB still have no figure in Production**. Also fixed: `build_load_sql.py` accepted `--batch` and then tagged rows from `--prefix` (earlier batches had one prefix so they agreed by accident), and a Lesson Notes regression that an earlier publish in this session carried live from an unrelated merged commit — publishing ships every merged-but-unpublished commit. Record: `docs/handoffs/SESSION_CLOSE_2026_10_12_FIGURES_COMPLETE.md`. **Next Owner:** David Bloom. **Next Required Action:** approve the `function_plot` Production load — finished work sitting idle, two subjects have no figures without it; then a signed-in look at the five new figures, and a decision on whether the ~81 chart-shaped entries outside `kind='diagram'` become the next lane.
- Session Close — Current MCQ Answer Preload (2026-10-11): app PR #14 is merged with CI green; backend PR #421 is open and mergeable with every check green. Durable handoff: `docs/handoffs/SESSION_CLOSE_2026_10_11_CURRENT_MCQ_ANSWER_PRELOAD.md`. Production remains untouched; next action is merge #421, then separately approve the Edge Function deploy and app publish.
- Current-MCQ Answer Preload Implemented for Instant Feedback (`TASK-0071`, `DECISION-0117`, `APPROVAL-0161`) (2026-10-11): the app now requests answer metadata for exactly the MCQ currently displayed, retains only that answer in React memory, and renders correct/incorrect feedback immediately on click while the existing authoritative grade/persist/read-back chain continues in the background. The ordinary ten-question serving page remains answer-free; item changes clear the prior answer; navigation waits for persistence; failed persistence retains the local feedback and offers retry; failed preload falls back to the old server-only behavior. The Edge Function validates session ownership, active status, exam-pack membership, published MCQ status and exactly one correct choice. Direct table/view answer grants remain closed; this is the narrow `DECISION-0117` amendment to `DECISION-0089`, not a rollback of `TASK-0056`. Verified: backend `deno check`, 35/35 backend tests, 56/56 focused frontend tests, 1,011/1,011 full frontend tests, production build. Repo-wide frontend lint remains red on 6,008 baseline errors and was not bulk-formatted. **Production untouched:** `APPROVAL-0161` authorizes code and PRs only; function deploy and app publish are still a Hard Gate. **Next Owner:** David Bloom. **Next Required Action:** review/merge the backend and app PRs, then explicitly approve the coordinated Production function deploy followed by app publish if desired.
- Session Close 2026-10-11: Lane A Finished and Deployed, the Frontend Taught to Draw It, and a Handoff for the Lane's Real Remainder: closing the figures session. **Shipped and live in Production:** the Lane A toolchain recovered into the repo from an unpushed local branch (PR #409), the reference packs for eight subjects (`APPROVAL-0154`, 776 entries + 7 hooks), `app.figure_families` replacing a hard-coded CHECK so a renderer family is data (`DECISION-0115`/`APPROVAL-0156`), the nine AP Statistics figures (`APPROVAL-0157`) and the last six across Physics 2, Physics C Mechanics and Precalculus (`APPROVAL-0158`) — **25 figures, 13 families, Production identical to Development**. Three renderer layout defects fixed in the app and two defect classes turned into tests there (`ap-prep-blueprint` #6), then all seven new families ported and proven at **45/45 byte-for-byte parity** with the Python renderer (#10). **Verification worth repeating:** every deploy was probed as an authenticated student rather than `service_role`, with a pre-apply baseline, a planted draft row confirmed invisible, idempotent re-apply, and a cross-environment content checksum. **The lesson of the session, three times over:** the eye found defects no test could (an off-canvas y-axis title in *every* figure, a legend overprinting its own axis label, shaded areas that silently did not render while the figure claimed them), the model readers found defects the eye and the tests both missed (element names under the wrong part of a graph; residuals that alternated perfectly, which is a pattern), and a correct statement of mine was wrong anyway — the nine Statistics figures were never visible to students, because the client whitelists figure families and drops the rest in silence. Each of those is now a test. **What this session did NOT finish, written up so nobody re-triages it:** `docs/handoffs/LANE_A_GAPS_AND_LANE_B_EXECUTION_2026_10_11.md` records that **Lane A's `kind='diagram'` scope was the wrong filter** — about 24 chart-shaped entries live in other kinds, three of which need only a `figure_uses` row because the figure already exists — along with four labelling problems (kind is not lane; 19 candidates have no `items[]`; three cross-subject duplicate entries that one figure can serve, since the RPC does not filter figures by subject; `visual_asset_ref` still unused) and a full execution plan for all 18 Lane B entries as 15 figures in three sub-kinds. **Approval state:** no owner approval outstanding for work done; four decisions requested in the handoff §7. **Next Owner:** David Bloom. **Next Required Action:** publish the app in Lovable — until then not one figure outside AP Chemistry reaches a student, which is the single highest-value action left; then hand the new session the handoff document and start with Lane A §2a (the three zero-authoring reuse cases) or Lane B §4.1 (`arrow_diagram`). — 2026-10-11
- Lane A Complete: the Last Six Figures Deployed (`APPROVAL-0158`), and the Frontend Port Without Which None of Them Draw (2026-10-11): the five remaining Lane A entries — AP Physics 2 ×3, AP Physics C: Mechanics ×1, AP Precalculus ×1 — built as six figures across two new families and deployed to Production. **Every Lane A entry in the corpus now has a figure**, and the two environments hold identical figure content (13 families, 25 figures, 25 uses, checksum `56517690778`). One entry needed no new family at all: Physics 2's qualitative distribution is drawn by the AP Chemistry batch's renderer, the first time a family has paid for itself across subjects. **The gates:** 1,241 property checks, 0 failed, asserting physics rather than pedagogy this time — PV constant along the isotherm with the shaded area matching the work integral to 2 parts in 10,000, the adiabat obeying PV^γ and running steeper than the isotherm, the loop's rises and drops cancelling exactly (Kirchhoff), and v = dx/dt, a = dv/dt, area under v–t = displacement, area under a–t = Δv each checked numerically. **The eye found four defects the tests could not, one of which was the protocol's own warning from a new direction: the shaded areas did not render at all** — an area is shaded to the zero line and the v–t panel spanned 2 to 11, so there was no baseline, while the figure went on claiming "area under v–t curve" as a labelled part it covered. Declared coverage is not rendered coverage, now checked by counting the shapes in the SVG. The off-canvas check was also too narrow, inspecting only `<text>`, so it missed two tangents drawn near-vertical off the canvas by an inverted slope conversion — even though the defect that motivated it was an arrow; it covers lines and circles now. **Model review: controls 5/5 rejected**, and the readers found two real defects the tests missed (circuit element names under the flat wire rather than the step they name; residuals alternating +,−,+,− perfectly, which is a pattern when the entry's justification is "appears without pattern"), both fixed and both now checks; a third flag was accepted and the text corrected, since a funnel means non-constant variance rather than a wrong functional form. **A correction to this session's own earlier claim:** the nine AP Statistics figures deployed under `APPROVAL-0157` were never visible to students — the client whitelists known figure families and `mapFigure` silently drops the rest, so every one was filtered out of the payload before it could be drawn. No crash, which is the right failure, but no figure either. All seven new families are ported in `ap-prep-blueprint` PR #10 and **verified by parity rather than inspection: 45 of 45 figure-and-layout pairs byte-for-byte identical** to the Python renderer, which exposed four formatting divergences including JavaScript rounding half away from zero where Python rounds half to even (the fix also closed a divergence the app had documented as acceptable). **Next Owner:** David Bloom. **Next Required Action:** merge `ap-prep-blueprint` PR #10 and publish in Lovable — until then no figure outside AP Chemistry reaches a student; then Lane B, where free-body diagrams and particulate boxes are the cheapest start.
- App Accessibility, Consistency and Colour Pass Merged to the App's main (2026-10-11): after an accessibilitychecker.org audit scored `/question` 60, every app.cramapple.com page was axe-audited (signed-out live, plus signed-in pages via dev-harness fixtures) and fixed: one `<main>`, radiogroup semantics, `--surface-brand` (orange-700) darker top bar, one orange top bar app-wide (no floating subject picker), AA contrast tokens, Lesson Notes heading order, student sign-in redirect, phone wrap; hub Lesson Notes text 16px ink-700 and coloured curriculum categories; colour pass (cool desk, mode-tinted topic bar, role-tinted pane headers, rubric rows, hub header strips; subject accents declined). App PRs #7/#8/#9, `main` `d7e85cb`, CI green, 13 pages x 2 widths axe-clean. **Not Lovable-published** — waits on David's signed-in check. Record: `docs/handoffs/SESSION_CLOSE_2026_10_11_ACCESSIBILITY_AND_COLOUR_PASS.md`.
- AP Statistics Lane A Figures Built and Deployed to Production (`APPROVAL-0157`); Three Frontend Renderer Defects Fixed (2026-10-11): all seven AP Statistics Lane A entries, as **nine figures across five new renderer families**, built to the protocol's three gates and now live in Production. Because `DECISION-0115` had just made a renderer family a row rather than a CHECK, this was a **content load** rather than a Hard Gate schema deploy — the decision paid for itself on the first batch after it. **The gates:** property tests 934 checks / 0 failed, asserting the pedagogy rather than the drawing (bars separated for a categorical variable and contiguous for a quantitative one; segmented bars equal width against mosaic widths proportional to the category totals; one dot per observation; single-digit ordered leaves that reconstruct the data exactly; quartiles by the AP halves convention and whiskers stopping at the extreme non-outlier rather than at the fence). Two non-Anthropic readers with five planted controls — **controls 5/5 rejected, figures 9/9 accepted, $0.25** — where four of the five controls pass the property suite cleanly, so they measure what a reader adds over the tests; the committed default model was also corrected from `gemini-3.8-flash`, which §4c records as having voided a batch, back to the ratified `3.5-flash`. **The legibility pass found seven defects that no test could see**, four of them in figures already published. Two of those are listed in the protocol's own §4b table as defects the pilot *found* — found, written down, and left in the code. **So both defect classes are now tests** (nothing drawn outside the canvas at any layout; no two labels overprinting) in both the Python pilot and the app's own suite, failing on the pre-fix renderer and passing after; on their first run they found six further overflows. **A correction to this session's own earlier claim:** the app's TypeScript renderer had **three** of the seven, not all seven — the mass spectrum already truncated its peak labels at compact and captions already dropped a line each, so neither overprinted for a student. The three real ones (clipped rotated y-axis title in every figure, legend overprinting the x-axis title, long notes and captions running off the canvas) are fixed in `ap-prep-blueprint` PR #6, verified in a browser at 332px and 680px rather than in jsdom, tsc clean and 898/898. Production verification for the figures: correct per topic and per unit, `[]` where there is none, Chemistry and Biology unchanged, a draft row invisible to a student, 0 dead figures, idempotent, and the two environments identical on an AP Statistics content checksum. **Next Owner:** David Bloom. **Next Required Action:** merge `ap-prep-blueprint` PR #6 and publish in Lovable — until then the nine new figures render through the unfixed renderer; then the five remaining Lane A entries (Physics 2 ×3, Physics C Mechanics ×1, Precalculus ×1).
- A Figure's Renderer Family Became Data Rather Than Schema (`DECISION-0115`), **Deployed to Production the Same Day (`APPROVAL-0156`)** (2026-10-11): planning the next Lane A batch surfaced that `app.figures.family` was pinned by a hard-coded CHECK over the six AP Chemistry pilot families, which would have made the batch's seven new families a schema change and a Hard Gate deploy instead of a content load. **Asked why it was hard-coded, the answer was that nothing recorded a reason** — the constraint carries no comment and no pilot, design, protocol or architecture doc mentions it; it was written alongside `status in (...)` as house style for an enumerable text column. What it was really protecting is worth keeping, though: `family` is a dispatch key, so a figure whose family nobody implements renders *nothing*, and a published row that passes RLS and draws nothing is this project's recurring silent-absence failure. David chose the lookup-table option. Shipped `app.figure_families` (`family_key`, `title`, `summary`, `renderer_note`), seeded the six existing families, dropped `figures_family_check` and added `figures_family_fkey` with `on delete restrict` / `on update cascade`; RLS forced with no policies and no `anon`/`authenticated` grants, since nothing student-facing joins to it and foreign-key checks are not run under RLS. **Verified on Development, each test rolled back:** an unknown family is refused (`23503`, naming the key), seeding a family then inserting a figure that uses it succeeds, deleting a family in use is refused, renaming one cascades to the figure rows and leaves none behind, the migration's own guard raises and names the offending family, re-applying changes nothing (6 families, 10 figures, 1 FK, no probe residue), and `get_topic_point_guides` still hashes `25b6e08c…`. **The honest limit, recorded in the migration and the protocol:** enforcement of the *name* lives in the database while the drawing lives in the app's TypeScript and `scripts/lane-a-pilot/render.py`, so seeding a family with no renderer still fails at render time — which is why `renderer_note` exists and why a figure's mandatory 80-character `alt` is the real fallback. The remaining Lane A batch is now seven family rows plus fifteen figure rows: **a content load again.** **Deployed to Production the same day** on David's instruction (`APPROVAL-0156`), with the CLI pinned to the Production link and the ref confirmed with `--debug` before the write. Production pre-state captured first (10 figures, 10 uses, old CHECK present, no lookup table); afterwards the old CHECK is gone, the foreign key is in place, the six families are seeded, content is untouched, and `get_topic_point_guides` still hashes `25b6e08c…`. The three behavioural tests were re-run against Production inside rolled-back transactions — unknown family refused, a family in use undeletable, and seeding a family then inserting a figure that uses it accepted — plus a draft figure confirmed invisible to a student. **The two environments now agree exactly:** the column, constraint and seed signature hashes `e549ee74be244359e2faab2f63245aa0` in both. `db query` writes no ledger row, so one was inserted in both environments under version `20261011161500` with the committed filename and the migration text in `statements`; there was no `apply_migration` stamp to correct. **Next Owner:** David Bloom. **Next Required Action:** merge PR #409; the remaining Lane A batch can then be built as a content load.
- Production Google Login Repaired: Desktop OAuth Client Replaced With the Registered Web Client (2026-10-10/11): the live `/login` bundle initialized Google Identity Services with the project's Desktop client (`…ocd20…`), so Google rejected browser sign-in with `401 invalid_client` / `no registered origin` before Supabase. The existing `Cramapple_Supabase` Web client (`…1j6r…`) already carried all three Cramapple JavaScript origins and the Production Supabase callback. Lovable marketing commit `4aa50678` changed only `VITE_GOOGLE_CLIENT_ID`; typecheck, 85 tests and the production build passed. David approved the publish (`APPROVAL-0155`). The live bundle was fetched and confirmed to contain `…1j6r…`; the Google button rendered with no console errors, and David confirmed a successful Production login. This repairs `/login` only; TASK-0058 Work A (Google sign-in on `/checkout` with nonce/FedCM and verified-email checkout behavior) remains open. **Next Owner:** open. **Next Required Action:** none for this incident; continue TASK-0058 only when the post-pilot checkout work is intentionally resumed.
- A Figure's Renderer Family Became Data Rather Than Schema (`DECISION-0115`, Development; Production an Open Hard Gate) (2026-10-11): planning the next Lane A batch surfaced that `app.figures.family` was pinned by a hard-coded CHECK over the six AP Chemistry pilot families, which would have made the batch's seven new families a schema change and a Hard Gate deploy instead of a content load. **Asked why it was hard-coded, the answer was that nothing recorded a reason** — the constraint carries no comment and no pilot, design, protocol or architecture doc mentions it; it was written alongside `status in (...)` as house style for an enumerable text column. What it was really protecting is worth keeping, though: `family` is a dispatch key, so a figure whose family nobody implements renders *nothing*, and a published row that passes RLS and draws nothing is this project's recurring silent-absence failure. David chose the lookup-table option. Shipped `app.figure_families` (`family_key`, `title`, `summary`, `renderer_note`), seeded the six existing families, dropped `figures_family_check` and added `figures_family_fkey` with `on delete restrict` / `on update cascade`; RLS forced with no policies and no `anon`/`authenticated` grants, since nothing student-facing joins to it and foreign-key checks are not run under RLS. **Verified on Development, each test rolled back:** an unknown family is refused (`23503`, naming the key), seeding a family then inserting a figure that uses it succeeds, deleting a family in use is refused, renaming one cascades to the figure rows and leaves none behind, the migration's own guard raises and names the offending family, re-applying changes nothing (6 families, 10 figures, 1 FK, no probe residue), and `get_topic_point_guides` still hashes `25b6e08c…`. **The honest limit, recorded in the migration and the protocol:** enforcement of the *name* lives in the database while the drawing lives in the app's TypeScript and `scripts/lane-a-pilot/render.py`, so seeding a family with no renderer still fails at render time — which is why `renderer_note` exists and why a figure's mandatory 80-character `alt` is the real fallback. The remaining Lane A batch is now seven family rows plus fifteen figure rows: **a content load again.** **Next Owner:** David Bloom. **Next Required Action:** merge PR #409, and approve the same migration to Production when the environments should converge — it is not needed there until a new-family figure is promoted.
- Reference Packs for Eight Subjects Live in Production (`APPROVAL-0154`); Lane A Pilot Toolchain Recovered and Its Coverage Gate Repaired (2026-10-11): two threads, both starting from what the records got wrong. **(1) Figures.** The Lane A figures are live in Production and the Figure Production Protocol is on `main`, but everything the protocol's gates actually run existed only on an **unpushed local branch** — the six renderers, the property suite, the two-reader check, the export path, and `specs.json`, the authored source of the ten published figures. Two companion documents the protocol cites, and the lane classification of all 41 diagram entries, were not in the repository at all. Recovered verbatim (PR #409). Then the suite's own summary line gave away a real defect: `9 PUBLISHED entries covered (0 labelled parts)`. `verify.py --entries` defaulted to `/tmp/lane_a_chem.json`, outside the repository; once that scratch file was gone the loader fell back to `{}` and §4a's label-coverage gate — *"declared coverage is not rendered coverage"*, which exists because an annotation once rendered off-canvas while coverage still claimed it was shown — **ran over an empty set and reported a clean pass. The ten figures in Production passed it that way.** Fixed: the default is now the committed `prod_entries.json`, an entry with no authored `items[]` fails rather than passing (negative test: 9 failures), and the fixture carries the published `items[]` again, selected from this repository's own batch artifacts by matching `md5(label»meaning)` against the same digest computed in Production so no content was retyped. Re-run honestly: **471 checks, 0 failed, and the gate now checks 38 authored labelled parts across the nine published entries — all 38 covered.** The figures were correct; there was simply no evidence of it. Protocol gets an additive §4a note and a v1.1 line. **(2) Reference packs.** The 2026-10-10 handoff still said "Production untouched and still a Hard Gate", which was stale — AP Chemistry went up the same day under `APPROVAL-0147`/`0148`/`0149`. Read live: Production 307 entries, Development 1,083, so the real gate was the **776 entries and 7 hooks in eight batches**. Before asking, the one risk worth checking was settled by evidence: all 25 committed loaders were parsed to 829 natural keys and checksummed against Development per subject, and all eight in-scope subjects matched on count and checksum, proving the 43 escalation corrections were regenerated into the loaders rather than applied as one-off Development updates. The RPC was already byte-identical across environments, so this was data only. David approved all eight batches and chose to promote the duplicate hooks as-is. Applied 23 loader files; **Production 307 → 1,083 entries, 6 → 13 hooks**, equal to Development. Verified with 38 before/after authenticated-student probes: 29 changed, 9 controls byte-identical, AP Calculus BC inherits AB's units 1-3 through the alias with **zero BC rows of its own**, a planted draft row did not leak, re-applying is idempotent, QA checks 1-8 ok. **Known and accepted:** AP Physics 1 topic 1.5 serves SOH-CAH-TOA three times (three identical hooks on three different entries; the RPC does not de-duplicate) — the Product Owner's call is to fix it in serving, so de-duplication by `hookText` is an open front-end follow-up. Two files were deliberately excluded: the superseded Calculus BC re-key loader, and the Chemistry loaders, which are now themselves behind Production after `APPROVAL-0149`. **Next Owner:** David Bloom. **Next Required Action:** merge PR #409 and #410; then the remaining 13 Lane A entries (Statistics 7, Physics 4, Precalculus 1, one boxplot) can run on a toolchain whose coverage gate is real.
- Lane A Figures Built, Deployed and Published; Figure Production Protocol Written (2026-10-10/11): the reference entries' `kind='diagram'` rows had rendered as "Text only for now" since they shipped, because `visual_asset_ref` was a forward declaration pointing at nothing and TASK-0006 had been unapproved since 2026-06-12. Classified all 41 published diagram entries by lane, found roughly half are chart archetypes needing data rather than an artist, and built Lane A end to end: a dependency-free renderer (6 families, 3 layouts), 10 AP Chemistry figures, `app.figures` + `app.figure_uses` keyed so one figure can be recalled beside more than one entry, `get_topic_point_guides` returning `figures[]`, rendering on `/question` and the Lesson Notes sheet, and PNG rasterisation for Copy notes. Live in Production (`APPROVAL-0153`) and published in Lovable. Also deployed TASK-0070 (`APPROVAL-0152`), capped the `/question` pane grid, and removed four pieces of copy the Product Owner flagged. **Measured:** 0 models and $0 at render time; $0.18 for the two-reader review of 11 figures; 462 pilot checks plus 896 app tests. **The method's lesson:** property tests and visual inspection caught *disjoint* defects — the tests found what no one would eyeball, the eye found six legibility defects that passed a green suite. Protocol: `docs/product/FIGURE_PRODUCTION_PROTOCOL.md`. **Next Owner:** David Bloom. **Next Required Action:** signed-in check of a Chemistry diagram topic on the live app; then decide Lane A for the remaining 13 entries, and whether Lane B starts.
- TASK-0006 Lane A Figures Deployed to Production (2026-10-10): David authorised the deploy (APPROVAL-0153). Three migrations applied: `app.figures` and `app.figure_uses` with their policies, grants and student-readable views; the ten AP Chemistry figures with their uses; and `get_topic_point_guides` returning a top-level `figures` array. Verified on Production as a real authenticated student, not `service_role`: topic 5.5 returns one figure, topic 7.1 returns both approach-to-equilibrium charts, a topic with none returns `[]`, the subject returns ten, Statistics returns none, `public.figures` shows ten rows, and Chemistry unit 1 still returns its 26 reference entries — no regression. The seed resolves uses by natural key rather than by id, which is why it attached cleanly to Production's own entry UUIDs; Development and Production hold the same entries under different ids, and the foreign key caught that on the first attempt. Production's function now hashes identically to Development's (`25b6e08c…`), confirming the deployed body is exactly the reviewed one. Ledger versions corrected from `apply_migration`'s own stamps to the committed filenames. **No student sees a figure yet:** the app code that renders them is on an unmerged branch and the Lovable app has not been published, so the new `figures` key is simply ignored by the live frontend. Rollback: `update app.figures set status='retired';` empties the key without touching the function. **Next Owner:** David Bloom. **Next Required Action:** review the app branch `claude/lane-a-figure-renderer`, then publish in Lovable.
- TASK-0070 Deployed to Production: Calculus BC Can Now Read AB's Reference Content (2026-10-10): David authorised the deploy (APPROVAL-0152). Applied `app.subject_reference_aliases` (one row: `ap_calculus_bc` reads `ap_calculus_ab`, units 1-8) and the `CREATE OR REPLACE` of `get_topic_point_guides` to Production. Verified: Production's function definition now hashes identically to Development's, the alias table has RLS on and no policies (only the definer function reads it), and no regression for the subjects that have content — AP Chemistry unit 1 returns 26 reference entries and 1 hook, AP Statistics unit 1 returns 80, topic 1.2 returns 2. **No student-visible change today:** Production holds no Calculus reference entries at all (0 rows for either AB or BC), so the sharing branch has nothing to serve until a Calculus pack is published; the deploy is infrastructure ahead of that content. The branch itself was proven on Development, which does have AB content: BC unit 1 returns all 24 of AB's entries, every one carrying `sharedFromSubjectKey = ap_calculus_ab`, and BC unit 10 correctly returns 0 because it is outside the alias range. `apply_migration` stamped its own version (`20261011012939`) rather than the committed filename, so the ledger row was corrected to `20261010170000` — renaming the file instead would have ordered it after the pending TASK-0006 figures migrations, which build on it. Rollback remains `delete from app.subject_reference_aliases;`. **Next Owner:** David Bloom. **Next Required Action:** decide whether to deploy the TASK-0006 figures migrations, which replace the same function body again.
- /question Rebuilt to the Core Product Canvas and Merged to the App's main; AP Chemistry Reference Content Live for All Nine Units; Lovable Guardrails in Place (2026-10-10): After four failed Lovable rounds, the cause was found: Lovable built a second standalone `/question` page and edited mock files the live page never loads, and reviews were diff-only. Set up a local clone with a development-only visual harness, then rebuilt `/question` to the Core Product canvas boards and David's amendments (left pane = grade/score, right = information; one shared three-control top bar also used by BYOQ; Hint-gated panes in independent practice, recorded as guided help; Deep Dive Notes; revisit marks; Show another / Try myself; hand-drawn responses; 16px text). Two independent QA sweeps (Codex, then Lovable) passed; ap-prep-blueprint PR #1 merged (`1715994`). Added CI on every push to main, design-rule tests, and Lovable project knowledge; removed ~150 dead app files; updated the canvas boards (version 17) and marked the build handoff partly superseded. Backend for the question experience (APPROVAL-0145 and amendments, DECISION-0114) and AP Chemistry reference packs for units 1-9 (APPROVAL-0147-0151, DECISION-0112/0113) are live in Production. Unblocked Cramapple PRs #398/#400/#403/#404 (brought up to date with main; all merged). **Not yet published:** the new `/question` waits on David's signed-in checks in the Lovable preview; app PR #3 (cleanup into main + h1 fallback) is open. See `docs/handoffs/SESSION_CLOSE_2026_10_10_QUESTION_PAGE_AND_CHEMISTRY.md`. **Next Owner:** David Bloom. **Next Required Action:** merge app PR #3, run the signed-in checks, publish in Lovable, then send Lovable the stand-down prompt.
- TASK-0070 Opened and Applied to Development: Calculus BC Serves AB's Shared Reference Content, No Duplicate Rows (2026-10-10): David asked why BC needed its own units 1-3 pack; it did not — AB and BC share one CED, BC's units 1-5 topic sets are identical and 6-8 a superset, and only `subject_key` keying made BC serve nothing. Duplicating was rejected because the same duplication in `topic_explainers` has already drifted (all 81 shared AB/BC explainers differ; units 1-8 AB 35 of 81 repaired against BC 85 of 87), so copying would have hidden the same divergence and required mirroring today's 43 corrections. Shipped a general `app.subject_reference_aliases` table plus an RPC union with three guards (own row wins, unit range, requesting subject's taxonomy). No content row created, copied or deleted. Verified against a 30-probe pre-change baseline: 23 of 30 payloads byte-identical once the additive key is stripped, the 7 that differ are exactly BC units 1-3, both guards exercised and rolled back, alias table unreadable by `authenticated`, migration idempotent, all 8 QA checks ok. AB's stale explainers recorded as F2; anonymous BYOQ sharing as F1. Code change, so the PR goes to David; Production untouched.
- Extractor Prompt Fixed for Boundary Statements, Skills and Exam-Prep Text; Pipeline Scripts Given a Canonical Template (2026-10-10): the seven unit 1-3 entries that had to be dropped rather than corrected all came from CED sections that are not course content — Exclusion/Boundary Statements, SUGGESTED SKILL lists, "Preparing for the AP Exam", ILLUSTRATIVE EXAMPLES alone. New protocol §1.2 names the admissible source, keeps a boundary statement's legitimate use in a `caution`, and makes an LO/EK citation a hard gate; `extract.py` and `check.py` (b)(c) now enforce it. Scripts moved to a canonical baseline at `scripts/content-seed/reference-pack-template/` so prompt lessons stop being lost between batches. Verified by re-extracting Physics C: E&M unit 8 and Calculus AB unit 2: all three previously-inadmissible entries gone, no entry citing a non-LO/EK section. Test extractions not loaded; no batch re-run; Production untouched.
- Ownership Rule Written into the Reference-Content Protocol (2026-10-10): the protocol's "owned by the topic that first requires it" was being read by the checkers as earliest mention, which caused most of the ownership escalations in the units 1-3 run. New §1.1 states the rule the Product Owner has applied five times (the topic whose LO/EK requires the entry as stated), gives the test, lists the ruled examples, bars a pre-owner topic from `topic_codes`, tells a session to escalate rather than re-key to satisfy a checker, and carries the exact prompt wording for `extract.py` and `check.py`. The AP Chemistry inventory's matching phrasing was aligned. Codification of existing rulings, so no new decision id; docs only, no content or database change.
- Last Four Reference-Row Escalations Ruled and Loaded; Development Found to Be Shared Mid-Run (2026-10-10): David ruled owners 1.3, 2.7, 1.3 and 10.7, loaded via `load.py --po-accept`, so all 50 escalations are now dispositioned (43 corrected and loaded, 7 rejected for having no LO/EK basis). The ownership principle is now ruled three times and should be written into the production protocol. Separately, Development is shared: another session loaded PR #399's 2 Chemistry Unit 1 escalations and a new Chemistry units 5-9 batch (119 rows) during this run, so Development's 1,076 entries include 247 rows from outside this branch and only 829 are this session's. A Production approval must therefore name batches, not a row count. All 8 QA checks still pass. Production untouched.
- Escalation Correction Pass: 39 of 50 Escalated Reference Rows Corrected, Re-Checked and Loaded (2026-10-10): David directed the session to correct the escalations itself rather than regenerate them (a recorded deviation from the protocol's no-hand-edit rule, under his authority over escalations). Each correction restored the CED wording the checker had identified as missing and was re-checked by both independent checkers plus the reject-only veto; 39 passed and loaded, 7 were rejected as having no LO/EK basis (boundary statements, a suggested skill, exam-prep guidance), and 4 remain open — three are one ownership question David has already ruled on twice, and one is a genuine deadlock between the two checker families. Development: 951 entries, 11 hooks; all 8 QA checks ok. The earlier count of 45 escalations was wrong and is corrected to 50. Production untouched.
- Reference Packs Built for Units 1-3 of Nine Subjects: 786 Entries + 6 Hooks Loaded to Development, Controls 150/150, $37.80 (2026-10-10): David scoped units 1-3 for all subjects, Development only, and supplied the four missing Physics CEDs that had blocked Physics 1 / 2 / C Mechanics / C E&M; 25 unit batches run through the two-checker plus reject-only Haiku veto pipeline with six CED-verified controls each (6/6 every batch). Development now holds 912 entries and 10 hooks; all 8 QA checks ok and RPC probes correct. `load.py` gained a schema guard after one bad `topic_codes` row silently voided a whole batch load; `extract.py` now requires a caution on mnemonic hooks. Calculus BC units 1-3 left to a Product Owner call (identical taxonomy and CED to AB, re-key SQL generated not applied); 45 escalations open, grouped into three patterns. Production untouched.
- Reference Pack Build Protocol + Proposed Shared Question-Page Template Documented; Lovable Not Sent (2026-10-09): AP Chemistry's 91-topic inventory now carries the repeatable vocabulary/equation/memory-hook workflow, checker and control gates, Notes-vs-question projection rules, and BYOQ boundary; the compact three-pane template and `2/5`-only header are recorded in a session-close handoff. Docs and local rendering only; no app, database, Lovable, or Production change.
- Session Close: FRQ Coverage Audit, Topic Labels and FRQ Gap Fill, Units 1-3 (2026-10-10): handoff `docs/handoffs/SESSION_CLOSE_2026_10_10_FRQ_GAP_FILL_UNITS_1_3.md`; next owner David (merge PR #400; decide on the second FRQ for 202 single-FRQ topics).
- 126 New FRQs Published to Production and Development: Every Units 1-3 Topic Now Has an FRQ (APPROVAL-0146) (2026-10-10): 104 written in session after the Product Owner stopped paid authoring ($47 for 20 before; $21 for 106 after); three arbitration rounds; model answers 126/126 full credit (Biology also 10/10 on the production grader); 0 of 271 topics empty (was 126), 202 still have one FRQ.
- TASK-0069 in Production, Dark (APPROVAL-0144) (2026-10-10): seven migrations applied verbatim and recorded at repository versions (one file corrected first: the attachment delete guard it had dropped), four functions deployed byte-identical, secrets set, Lovable App published (`e8c11dce`); integrity test 8/8 on Production; ~3-minute selector window with no student activity; API smoke owed (no Production secret key locally). Counts corrected: 619 published FRQ items, 37 published hand-drawn. **Next Owner:** David Bloom. **Next Action:** live admin run (runbook step 6), then decide on widening `FRQ_PHOTO_SUBJECTS`.
- AP Chemistry Unit 1 Reference Pack to Production (APPROVAL-0147) (2026-10-10): the same generated SQL as Development; 24 entries + 1 hook; QA 8/8; probe counts identical to Dev; two escalations still unloaded.
- Question Experience Backend to Production (APPROVAL-0145) + BYOQ Reference for Signed-Out Visitors; AP Chemistry Unit 1 Reference Batch in Development; Shared Question-Page Shell in Lovable Preview (2026-10-10): `get_question_experience` RPC + session items + comparison answers live in Production (probed read-only); `byoq` v15 serves reference/hooks signed-out; Chem U1 24 entries + 1 hook in Dev, 2 PO escalations; Lovable `84f287f0` Preview only.
- TASK-0069 Codex QA Fail Remediated: Submission Integrity Moved Into the Database, photo_required Enforced Server-Side, Server-Driven Rollout, Resumable Redaction (2026-10-10): Codex found the confirmation was not content-bound (owner PATCH after confirm), a retake/submit TOCTOU (plus a second submit function that bypassed the Edge gate), a typed-submit path for `photo_required` (hand-drawn items were served to every student), and redaction false success; all fixed with migration `20261010002322`, a submission guard trigger, `app.confirm_response_transcript`, `FRQ_PHOTO_SUBJECTS`, and `_shared/attachment-redaction.ts`; Development integration test 8/8, two-connection race test, smoke, Deno 596/596; Lovable `e8c11dce`. **Next Owner:** Codex (re-QA per `docs/qa/QA_TASK0069_REMEDIATION_2026_10_09.md`), then David (PR #397). **Next Action:** re-QA.
- TASK-0069 Built: Hand-Drawn Responses on Every FRQ — Backend on Development, Frontend in Lovable Preview, Independent Review Fixed, Build PR Open (2026-10-09): `response_policy` on every FRQ, transcript propose/confirm with a digest-tied submit gate, retention by redaction, `SAME_DEVICE` capture; five migrations + three functions on Development, `scripts/frq_photo_smoke.mjs` all checks pass; Lovable App commits `42c5028e`/`700965bd` (dark default, 834 tests, unpublished); fresh-context review found 2 High/4 Medium/3 Low, all but one Low fixed; Codex QA handoff written. **Next Owner:** David Bloom (merge = Production go-ahead) and Codex (QA). **Next Action:** Codex runs `docs/handoffs/HANDOFF_TASK0069_CODEX_QA_2026_10_09.md`; on merge, execute the Production runbook in `docs/handoffs/TASK0069_FRQ_PHOTO_EXECUTION_2026_10_09.md`.
- Hand-Drawn Responses on Every FRQ: Session Opened, Stranded TASK-0038 Frontend Found, Plan Drafted, D1/D2(conditioned)/D4 Approved (DECISION-0109/0110/0111, APPROVAL-0142) (2026-10-09): live-verified that TASK-0038's Phase 3/4 frontend never reached the Lovable App (committed to `exam-buddy-wireframe` the day after the split); `response_attachments` still 0 rows; wrote `docs/product/HAND_DRAWN_RESPONSES_ALL_FRQS_PLAN_2026_10_09.md` (photo on every FRQ, student-confirmed transcript graded by the existing text grader, image-judgeable criteria to the human queue until Engine 4 gates pass, `response_policy` on every current and future FRQ, redaction-based retention). **Next Owner:** David Bloom. **Next Action:** answer D3, D5–D8; authorize Phase 0 (port the five frontend pieces, publish, run DECISION-0059 Stage 1).
- FRQ Units 1-3 Topic Coverage Audit + 181 FRQ Topic Cells Written to Production (APPROVAL-0143) (2026-10-09): 126 of 271 Unit 1-3 topics have no published FRQ (table in `docs/qa/FRQ_UNITS_1_3_TOPIC_COVERAGE_AUDIT_2026_10_09.md`); 339 untagged FRQs labelled with the runbook six-vote probe ($8.26); 183 Units 1-3 primary topic cells written, rehearsed, hash-verified (2 after resolving unit conflicts from the official course PDFs). No FRQs written yet.
- Session Close: TASK-0068 BYOQ Photo Extraction — Live for Students, QA Cycle Complete, Hand-Drawn Leverage Analysis (2026-10-09): plan → build → backend QA (Fail→Pass) → Sol browser QA (Fail→rerun pass; draft-routing P2 fixed) → Vercel review defect fixed → PR #393 merged. Open: Done decision (topic-ranking gate, S9 expiry checks), SOL-08 hint copy. Close record: `docs/handoffs/SESSION_CLOSE_2026_10_09_TASK0068_BYOQ_PHOTO_EXTRACTION.md`.
- TASK-0068 BYOQ Photo Extraction Built, QA'd and Deployed to Production for All Students (APPROVAL-0141) (2026-10-09): migration + extraction module + extract_question + phone review ops; benchmark 210 pages, gpt-4.1-mini chosen; backend QA Fail → three fixes → Pass; Dev and Prod smokes green; Lovable App published; Sol browser QA script written. Topic top-3 below gate, recorded.
- Unit Reference Content + Memory Hooks Moved to Production (APPROVAL-0140): Migration, 102 Entries + 3 Hooks, Lovable Publish of 71a9b751 (2026-10-09): CLI-driven apply and loads (no retyping), objects md5-identical to Development, data QA and RPC probes pass; PR #390 merged by David; CLI relinked to Development.
- TASK-0067/0066 Phase C Built in Lovable Preview (commit 71a9b751), Tests 770/770 (2026-10-09): reference pane, Deep Dive, Copy notes, Learn More; baseline fixture pins today's output for Production's payload; DECISION-0106 renumbered to 0107 (PR #391 had reserved 0106). Not published; Production untouched.
- DECISION-0107 Recorded (SOCS Loaded, 1.13 Owner, Veto → Haiku 5.5); TASK-0067/0066 Phase C Sent to Lovable Preview (2026-10-09): Development 102 entries + 3 hooks; Phase C brief covers the fetch/mapping layer, reference pane, Deep Dive, unit reference, Learn More page, tests; Production untouched.
- TASK-0067 + TASK-0066 Phase A and B Done in Development: Reference Tables + Hooks Schema (20261009003237), 101 Entries + 2 Hooks Loaded for Stats U1 / Chem U4, $20.29 (2026-10-09): two-checker + veto pipeline, controls 6/6 both units after one flawed control was replaced; aggregation bug fixed and recomputed; SOCS and one escalation for the PO; Production untouched; PR open for David.
- BYOQ Photo Extraction Plan v2 Approved at Gate A (DECISION-0108, APPROVAL-0139); TASK-0068 Opened; TASK-0039 Closed (2026-10-08): Codex's v1 critiqued against live sources; David answered eleven questions (photos only, subject/unit from context, OpenAI build-measure-switch, student answer marks stored, phone-side review, no policy change, no spend cap, Micah + Orly pilot); plan re-cut to three slices; PR #391 supersedes #387. Docs only; nothing built.
- TASK-0067 Approved and Opened; TASK-0066 Unblocked with D3 Amended (DECISION-0105, APPROVAL-0137) (2026-10-08): R1–R4 as recommended; one Development migration for both tables; hooks require a reference entry. Docs only; nothing built.
- TASK-0066 Blocked on Companion Content; TASK-0067 (Unit Reference Content: Formulas, Vocabulary, Lists, Diagrams) Drafted as Proposed (2026-10-08): David's point checked against the schema and task records; nothing structured exists for hooks to attach to; R1–R4 await David. Docs only.
- Memory Hooks Approved (DECISION-0104, APPROVAL-0136) and TASK-0066 Opened; Diagram Parts Added at Micah's Request (2026-10-08): D1–D7 as recommended; formulas were already in scope; `diagram_parts` kind added with a reference to existing visual-stimulus assets. Docs only; nothing built.
- Memory Hooks (Mnemonics / Acronyms / Phrases) Scoped as a Content Element, Awaiting PO Decisions (2026-10-08): Micah's idea placed against the records; the KPCOFGS example is not in the AP Biology CED, which yields the inclusion rule; topic-owned grain proposed; `docs/product/MEMORY_HOOKS_PROPOSAL_2026_10_08.md`. Docs only.
- Student Hub Slice 1 Built in Lovable Preview (DECISION-0103) (2026-10-08): evidence reads scoped to the active pack; unit-only saves clear the topic; save on change replaces the Confirm buttons in both stages; the Learn door gates on the saved topic, treats lookup failure as unknown and honours the resolver; one unit-only rule (heading, first available example, unit notes list). Lovable `a509b7d7`, 755 tests; published to production on David's instruction (deployment `10c9fc3b`, carries PR #380 packages 1–3 too); signed-in screenshots pending with David.
- Open Hand + Practice QA Findings Executed: Answer-Key Revoke Applied, Practice Queue Selector Live, Lovable Fix Packages Built in Preview (APPROVAL-0135) (2026-10-08): TASK-0056b revoke finally applied to Dev and Prod (view projects `prompt_json` as null); `select_student_practice_items` excludes answered/revealed items, topic-first, paged; `student-session-items` v28/v34; Lovable packages for delivery/safety, attempt integrity and flow built in Preview, publication by David.
- Chemistry Unit 2 Filled: 18 MCQs Published (APPROVAL-0134); Seed-vs-Seed Duplicate Gate Added (2026-10-08): Unit 2 practice MCQs 19 → 37; topics 2.2–2.4 went from 0 to 4 each; two same-concept seeds caught on read-through, a calibrated seed-vs-seed gate added, both regenerated before publish; the general selector serves all 18.
- Biology Unit 3 Filled: 20 MCQs Published to Production (APPROVAL-0133) (2026-10-07): via publish_mcq_batch.py; verified 20/20 on text, labels, cells and difficulty; the selector serves all 20; Biology Unit 3 practice MCQs 0 → 20 (Unit 2 has 22); Biology published MCQs 183.
- Legacy Retired MCQs Re-Checked (2 of 13 Pass, Republished Under APPROVAL-0132); Biology Unit 3 Batch Generated (20 MCQs, Controls 6/6) (2026-10-07): the 2026-08-08 retirements were mostly right (11 of 13 have real defects: old-CED content, factual errors); APBIO-MCQ-001/007 republished unchanged; Biology Unit 3 had 0 practice MCQs, so 10 seeds + 10 variants were generated across 3.1–3.5 and rehearsed on Production, awaiting the Product Owner's publish approval.
- Seed Labels Rules Adopted (DECISION-0101); PR #370 Merged (2026-10-07): David approved dropping difficulty as an author target (provisional label only), practice-level skill targeting, and variants inheriting the seed's labels; `seed_pipeline.mjs` updated, protocol §0.8 amended.
- 82 AP Biology Unit 1 Seed-Pilot MCQs Published to Production (APPROVAL-0131) (2026-10-07): 21 seeds + 61 variants from the no-edit generate-and-select pipeline; loaded as drafts, hash-matched 82/82, rehearsed, published; the real Biology selector serves all 82; Biology published MCQs 79 → 161.
- Human Review Removed for Generate-and-Select Items (DECISION-0102) (2026-10-07): Product Owner removed the per-subject human spot-check (protocol §0.3 rule 6) and made human confirmation of judge-dispute adjudications optional; the Production Hard-Gate approval remains.
- TASK-0065 Pipeline Cost Levers and Biology Unit 1 Seed Pilot (2026-10-07): Muse Spark replaced Kimi as the fourth checker and the unit-scoped fact pack became the default ($0.28 -> $0.20/item, blind re-judge 0 defects). Seed pilot (no DB writes): 21/21 seeds + 61/63 variants accepted with no edits; blind held-out judges 0 defects in 21 seeds + 21 sampled variants, planted 4/4 caught; $25.73 on the pre-lever config; difficulty targeting failed (no item voted Hard). Results: `scripts/content-seed/task0065-seed-pilot-bio-u1-2026-10-07/RESULTS.md`.
- Three Defective Live Teaching Items Replaced; Statistics 2.12 Brief Fixed (APPROVAL-0129) (2026-10-07): pipeline-made replacements for Stats 1.10, Stats 2.12, Bio 2.10 loaded to Dev and Prod (rehearsed, hash-verified, real RPC serves them); old items retired; 2.12 brief brought back to CED 2.12
- Content Authoring Protocol v0.6: Generate-and-Select Adopted (DECISION-0099) (2026-10-07): new §0 makes the no-edit, four-family method the default for new MCQs and required for Open Hand teaching items, with evidence, rules, escalation triage, evaluation method, live-replacement pattern, cost levers and scope
- TASK-0065 Method Test Run: Legacy vs Generate-and-Select (2026-10-07): 24 topics (units 1-3), blind held-out judges against CED PDF text, 4/4 planted defects caught; defective items legacy 4/24, pipeline 1/23, live 3/24 (not significant at n=24); pipeline cost 3.5-4.9x legacy per clean item; live defects and a Stats 2.12 brief overreach found; nothing written to any database
- Biology 2.10 Brief Fixed and 3.3 Fact-Pack Gap Closed (APPROVAL-0127); Biology Teaching Items 20/21; Method Test Designed (2026-10-06): CED PDF showed the 2.10 brief overreached and the fact pack dropped EK 3.3.A.2.ii; both topics regenerated and accepted; review page published; legacy-vs-pipeline test designed, not run
- Session Close (part 2): Live Purchase Test Passed; Deep Dive + Pane Layout Built; 198 MCQ Stems Cleaned (2026-10-07): an anonymous Safari purchase with Apple Pay and a coupon works, and Home goes to Open Hand; the Lovable build is reviewed and not published (Deep Dive restored, Rubric and How-points left, Reference and Deep Dive right, answer key after grading, red/blue tints); 198 MCQ stems are cleaned of repeated choices in Production (APPROVAL-0128); PRs #351, #352 and #357 are merged. **Next Owner:** David. **Next Action:** publish the Lovable build and re-check Practice.
- Session Close: Open Hand Live — 91 Teaching Items in Production, Plate Loop for All Subjects Built (2026-10-06): student-session-items deployed; teaching items hidden from student reads (RLS) and the attempt trigger re-enabled (APPROVAL-0124); 91 checked Units 1–3 teaching items live for Bio, Stats, Chem and Calc AB (APPROVAL-0125); Lovable all-subjects plate loop with the diagnostic removed is built but not yet published. **Next Owner:** David. **Next Action:** publish the Lovable build and do a signed-in check.
- TASK-0065 Generate-and-Select Pipeline Built; Biology Pilot 18/21 Accepted, 3 Escalated (2026-10-06): David replaced hand-patching with no-edit generation checked by four model families plus an own-family veto; 6/6 planted-defect controls caught; 2 escalations are brief-vs-fact-pack conflicts; nothing loaded to any database
- Orly Pooled Practice Sets: Clean-Room Drafts (AP Chemistry Units 1/3, AP Calculus AB 2.1) (2026-10-06): 24 pooled reworded-exam MCQs mapped to CED topics and compared with the bank. All 4 Calculus keys and 2 of 20 Chemistry keys were wrong (told to Orly). Units 1-3 items used as seeds through the clean-room path (DECISION-0098): 10 families, 30 drafts; 27 published to Production (APPROVAL-0126), 3 density items held
- TASK-0065 Checker Pilot (AP Biology) (2026-10-06): supplementary checks for generated Open Hand teaching items (named-trap audit, lint, CED-text topic probe) proven on a pilot (4 of 4 planted defects caught); reconciled with APPROVAL-0123 / PR #340 (pilot's 603-topic scope withdrawn, per-item habit-line check retired); run on the 91 drafts: lint 2 fail, named-trap 38 blocked (25 only on fact-vs-action fix lines), Biology topic probe 21/21; nothing written to any database
- Student Hub Stage A/B Mounted in Lovable Dev Preview; Dev View Fixed (TASK-0048) (2026-10-04): `/home` was rendering legacy `TopicHome` for everyone because the built Stage A/B components were unmounted; Lovable commit `08a042ca` now routes by `experienceStage`; Dev `public.student_course_positions` view refreshed; NOT published; code-level QA only, six findings in the task file.
- Session Close: Checkout User Testing, Post-Purchase Flow, Parent Pay, Student Home 400 (TASK-0060) (2026-10-04): final end-to-end QA on the live site passes; remaining checks need a signed-in session or a real inbox; handoff written.
- Six-Criteria Re-run; Calc AB Canonicals; Difficulty Inheritance (2026-10-04): re-ran the six servability criteria on Production (no subject six-of-six: criterion 5 failed for MCQ everywhere after about 1,300 variants were published without difficulty, and criterion 4 failed for 20 Calc AB FRQs). Wrote the 20 canonicals with label carry-forward (APPROVAL-0116). Rated 31 seeds and had 1,011 variants and BC copies inherit, plus 1 FRQ variant (DECISION-0096, APPROVAL-0117). Every published item now has a difficulty band (FRQ 572/572, MCQ 1,718/1,718). PRs #327, #328 merged. Handoff: `docs/handoffs/SESSION_CLOSE_2026_10_04_SIX_CRITERIA_CANONICALS_DIFFICULTY.md`. **Next Owner:** David Bloom. **Next Action:** none blocking; optional provenance columns for seed links.
- Parent Payment Short Links Live in Production (APPROVAL-0119) (2026-10-04): `cramapple.com/p/<code>` resolves to the live Stripe URL; new table, new function, two function changes, tested in Dev then verified live without payment.
- Student Home 400 Fixed: `student_course_positions` View Refreshed (APPROVAL-0120) (2026-10-04): the view lacked `topic_code` and `topic_source`, so every subject load failed; recreated in Production and verified, plus a view-drift check.
- TASK-0060: Browser Test Results After P4/P4b (2026-10-04): intro copy, payment order, picker limit, promo guard, coupon maths and wallet availability by browser all pass; Check 3, the in-place wallet row, the Firefox hydration flash and a real-inbox purchase remain.
- TASK-0060: F9 Decided (Layered Sign-In, Email Code as Fallback) and F10 Email Delivery Logged (2026-10-04): David chose Google sign-in, then wallet email, then one-email-with-code, always keeping the email code as the fallback; the missing confirmation email was a placeholder address, custom SMTP is enabled in Production, real-inbox delivery still to test.
- Checkout User Testing: P1–P4b Logged (TASK-0060) (2026-10-04): six Lovable fix prompts reviewed by reading the diffs; second live purchase ($1 promo) verified paid with access; remove-coupon bug root-caused; open question on why a paid buyer must verify email before entering the app.
- Checkout User Testing Opened (TASK-0060) (2026-10-04): wallet behaviour confirmed by browser (Chrome Google Pay, Safari Apple Pay, Firefox card only); live $39.99 Google Pay purchase succeeded but the return-page "Start Studying" button was silent because Supabase returned 429 on the OTP request; fix prompts drafted for Lovable.
- AP Physics C (Mechanics and E&M) Units 1-3 Pipeline (APPROVAL-0108 to 0113) (2026-10-04): 41 seeds repaired or cleaned and topic-tagged, 104 variants published (43 + 61), two skill grids built, 141 skill cells written. Mechanics MCQs 42 to 85, E&M 48 to 109. All AP subjects now have the Units 1-3 pipeline applied.
- AP Physics 2 Units 9-11 Pipeline (APPROVAL-0105 to 0107) (2026-10-03): 18 seeds repaired or cleaned and topic-tagged, 50 variants published, skill grid built, 68 skill cells written; Physics 2 MCQs now 92.
- Calculus BC Units 1-3 Finished (APPROVAL-0104) (2026-10-03): BC skill grid built; 263 skill cells copied from the AB twins, 16 native topics and 23 skill cells voted; 286 of 294 BC Units 1-3 MCQs now have topic and skill.
- Units 1-3 Skill and Topic Cleanup, Biology 025-v3, MCQ-005 Retired (APPROVAL-0098 to 0103) (2026-10-03): two stale labels re-issued; Biology `025-v3` restored; Physics 1 and Precalculus skill grids built; 679 + 66 skill cells and 36 topic cells written; `apcalcab-mcq-005` and its 5 variants retired. See the entry below.
- AP Biology: Last 4 Orphan Items Retired (APPROVAL-0096) (2026-10-03): `APBIO-FRQ-L-028`, `APBIO-MCQ-012` (test attempts only, per the Product Owner), `APBIO-FRQ-L-038` and `APBIO-FRQ-L-041` (latest version retired) set to `retired`; every published Biology item now has a published version (132 of 132); Biology published items 136 to 132.
- AP Biology: 38 Items With All Versions Retired Now Marked Retired (APPROVAL-0095) (2026-10-03): 38 of the 42 Biology items that were marked published with no published version (17 FRQ, 21 MCQ) set to `retired` at item level; no student-visible change (the selector already required a published version). Biology published items 174 to 136. Four left for a decision: `APBIO-FRQ-L-028` and `APBIO-MCQ-012` (attempts), `APBIO-FRQ-L-038` and `APBIO-FRQ-L-041` (unretired `reviewed_approved` v1).
- AP Biology: 3 More Items Retired (APPROVAL-0092) and DECISION-0095 Recorded (2026-10-03): `APBIO-MCQ-014` (70S/80S ribosomes), `063` (signal sequence) and `025` (kidney ADH outside the pack) retired, zero attempts; Biology published items 177 to 174. `DECISION-0095` records the rule that items stay within the CED vocabulary and that breaking items are retired. 42 older Biology items are marked published with no published version (not caused by this change).
- AP Biology: 7 Published Variants With Out-of-CED Terms Retired (APPROVAL-0091) (2026-10-03): a full-text scan of the 24 variants published under `APPROVAL-0080` found 7 using terms the CED does not name (70S/80S ribosomes, receptor-mediated endocytosis, binary fission, high-salt wash); all 7 retired (zero attempts), 17 remain published; Biology published items 184 to 177; validated serving labels unchanged.
- Google Sign-In Removed From Checkout; Post-Pilot Task Opened (TASK-0058) (2026-10-02): at David's direction Lovable removed the "Continue with Google" option from `/checkout` (commit `18666296`, only `checkout.index.tsx`, deletions only, not yet published). Reviewed Chrome's identity guidance against the redirect flow; improvements, layout wishes and Stripe hardening are collected in `docs/tasks/TASK-0058-POST-PILOT-CHECKOUT-AND-SIGN-IN.md`. Google branding/verification is David-owned and prepared there.
- Stripe Live Payment Proven in Production; Refund Round Trip Verified (2026-10-02): David paid \$39.99 with Link on the live checkout, the live webhook processed it, access was granted; a \$10 partial refund kept access (PR #310 fix) and the remaining \$29.99 revoked it. Coupon and new-student paths still untested.
- AP Biology Skill Re-vote (APPROVAL-0081) (2026-10-02): 73 topic-corrected items re-voted by four models; 69 skill cells rewritten (52 validated, 10 provisional, 7 held), 6 skills changed, 54 unchanged; 4 validated cells deliberately kept.
- AP Biology Variants Loaded and Published (APPROVAL-0080) (2026-10-02): 24 variant MCQs loaded in 3 chunks (md5 24 of 24) and published with validated labels (Unit 1: 3, Unit 2: 21).
- AP Biology Topic Correction (APPROVAL-0079) (2026-10-02): 73 primary topic cells replaced by three-family consensus (42 cross-unit), 21 skill cells moved to the new topic, MCQ-005 relabeled to Unit 2; 43 earlier-validated items topic-probed for the first time.
- AP Statistics Variants Published (APPROVAL-0078) (2026-10-02): 131 variants published with validated labels (Unit 1: 63, Unit 2: 33, Unit 3: 35); Statistics published 293, unit-gated servable 261, stale hashes 0; one variant held as a draft.
- AP Statistics Variants Loaded as Drafts; 8 Items Retired (APPROVAL-0077) (2026-10-02): 132 variant MCQs loaded in 12 chunks (md5 132 of 132), not yet published; 8 items on CED-removed topics retired.
- AP Statistics Units 1-3 Pipeline v2: Repairs, Labels, Skill Cells (APPROVAL-0076) (2026-10-02): 4 MCQ rationales repaired as version 2, 8 serving labels validated, 129 skill cells written (116 validated, 1 provisional, 12 held); blind plus audit for 129 items took 7 minutes and $2.56.
- AP Chemistry Variants Loaded and Published; Canonical Answers Filled (APPROVAL-0075) (2026-10-02): 72 variant MCQs loaded in 12 chunks (md5 72 of 72) and published with validated labels; 49 Chemistry MCQ canonical answers filled; Chemistry published 119 to 191, servable 82 to 154; MCQ grading found not to read canonical answers.
- AP Chemistry Units 1-3 Full Pipeline Run (APPROVAL-0074) (2026-10-02): steps 1-7 from scratch in about 86 minutes, 2,040 gateway calls, $7.55 gateway list price, about 0.9M Claude tokens; 8 seeds repaired, 36 topic cells, 28-skill grid, 37 labels, 34 skill cells, 75 variant drafts (not loaded); audit recall gap and missing seed CED check found.
- AP Biology Grid Created and 70 Live Items Relabeled for Serving (APPROVAL-0073) (2026-10-02): 22 skills x 60 topics = 1320-cell grid from the CED; Bio unit-gated servable 43 to 110 of 118; registered topic cells found wrong on about 58 items (36 across units), left unchanged for a decision; skill labels in progress.
- Cells Validation Check Relaxed in Production for Model-Consensus Labels (APPROVAL-0072, DECISION-0085 Route 1) (2026-10-02): `validated` now needs a human or a `model_run_id` plus a decision id and timestamp; rehearsed and applied as migration `20261002164510`; no rows changed.
- AP Precalculus Variants Published (APPROVAL-0097) (2026-10-03): 143 variants loaded (md5 143 of 143) and published with validated labels (Unit 1: 56, Unit 2: 42, Unit 3: 45); Precalculus published 116 to 259, servable 78 to 221.
- AP Precalculus Units 1-3 Seeds Repaired and Labeled (APPROVAL-0093, 0094) (2026-10-03): 25 rationales corrected on 15 items, duplicated A-D list removed from 22 stems, 34 labels validated, 47 topic cells, 3 defective MCQs fixed, 010 retired; Precalculus servable 53 to 78; 147 variants authored, not loaded.
- AP Calculus BC: 283 AB Units 1-3 Questions Mirrored (APPROVAL-0090) (2026-10-03): copied in-database from the AB pack with validated labels (Unit 1: 118, Unit 2: 83, Unit 3: 82); Calc BC published 130 to 413, servable 45 to 328.
- AP Physics 1: 89 Variants Published, Units 4-8 Stems Cleaned (APPROVAL-0088, 0089) (2026-10-03): 89 variants loaded (md5 89 of 89) and published with validated labels (Unit 1: 12, Unit 2: 36, Unit 3: 41); 21 Units 4-8 stems cleaned; Physics 1 published 113 to 202, servable 83 to 172.
- AP Physics 1: 4 Framework Questions Retired, 32 Stems Cleaned (APPROVAL-0087) (2026-10-03): np1-001/002/003/006 retired; duplicated A-D list removed from 32 published stems (24 relabeled, 8 held); 21 Units 4-8 items have the same defect, not touched.
- AP Physics 1 Units 1-3: 4 Rationales Repaired, Topic Cells Created (APPROVAL-0086) (2026-10-03): 32 topic cells from a three-family consensus, 4 published rationales repaired, 041 released to Unit 3; np1-002 released then returned to held (exam-scoring item); 89 variants authored and checked, not loaded; 4 course-framework questions recommended for retirement.
- Calc AB: 109 New Units 2-3 Questions Authored, Loaded and Published (APPROVAL-0085) (2026-10-03): 28 original seeds (14 Unit 2, 14 Unit 3) and 81 variants, md5 109 of 109, validated labels; Calc AB published 308 to 417, servable 237 to 346; 2 seeds and 6 variants dropped for needing Unit 4-5 content.
- Calc AB Pilot Variants Published (APPROVAL-0084) (2026-10-03): 30 variants loaded (md5 30 of 30), 29 published with validated labels (Unit 2: 14, Unit 3: 15), 1 held; Calc AB published 279 to 308, servable 208 to 237.
- Calc AB Seed Fixes Applied (APPROVAL-0083, originally numbered 0071): `apcalcab-mcq-026` Choice C Replaced, `apcalcab-mcq-028` Units Corrected to [1, 2] (2026-10-02): rehearsed then applied on Production; servable 207 to 208.
- Calc AB Launch-Readiness Pass, Serving-Label Repair (APPROVAL-0082, originally numbered 0069), Units 2-3 Pilot Started (2026-10-02): read-only readiness census, then relabelled 11 of 12 held/stale items on Production (servable 196 to 207); `frq-u13-003` left held; S0a audit of the 12 Unit 2-3 seeds found 0 key defects and 1 weak rationale (`026` C).
- Stripe Functions Tranche 2 Deployed to Production (APPROVAL-0071) (2026-10-02): `stripe-webhook` (partial-refund fix), `create-checkout-session`, `create-post-purchase-addon` and `create-parent-payment-link` deployed and verified (source identical to `main`, 400 probes, no data change, no charge). Production Stripe secrets re-set by David (key/webhook distinct, catalog exact match). Lovable not yet published; Gate D ($1 test) pending.
- Stripe Functions Tranche 1 Deployed to Production (APPROVAL-0070) (2026-10-02): `stripe-webhook` v21, `get-checkout-status` v1 and `send-parent-payment-email` v1 deployed and verified (source identical to `main`, 400/405 probes, no data change, no charge). Tranche 2 and the Lovable publish remain unapproved.
- Stripe Payment Migrations Applied to Production (APPROVAL-0069) (2026-10-02): the three TASK-0041 payment-schema migrations were applied to Production and verified (`stripe_customers`, `parent_payment_email_requests`, webhook replay columns + `claim_stripe_webhook_event`). No function, secret, or Stripe change. Next: deploy the six functions from David's Mac, then live Stripe setup.
- Seeded-Variant Runs: Status by Subject Documented; AP Biology Pilot Closed (2026-10-01): added protocol section 10, a table of which subjects have had a variant run (AP Calculus AB partly, AP Biology Units 1-2) and which still need one (Calculus BC, Chemistry, Physics 1, Physics 2, Physics C E&M, Physics C Mechanics, Precalculus, Statistics), plus a pre-run checklist. The label probe on the final AP Biology text is prepared (`probe_items_final.json`) but needs a run from the Product Owner's laptop.
- AP Biology Seeded-Variant Pilot: Seed Audit, 14 Variants, `APBIO-MCQ-023` Repair Approved (APPROVAL-0067) (2026-10-01): S0a found 7 of 8 Biology seeds clean and 1 defective rationale (`APBIO-MCQ-023` choice A, both models); 14 class-A variants written and content-checked by both models (3 DeepSeek-only wording defects fixed, patched items re-checked clean). The Product Owner approved the one-item Production repair, which was applied and verified.
- Stripe Production Cutover Checklist Drafted; Launch Shape Revised to a $1 Pilot Then 50% Off (2026-10-01): read-only audit found Production is on the August Stripe code (4 of 6 functions missing, `stripe_customers`/`parent_payment_email_requests`/webhook-replay schema missing). Checklist written; `DECISION-0094` supersedes `DECISION-0091`. No Production, Stripe, or secret change.
- Calc AB Repair Approved (APPROVAL-0066): `apcalcab-mcq-037` Key Letter, 10 Distractor-Rationale Repairs, Label Carry-Forward (2026-10-01): the Product Owner approved applying the 037 key-letter fix and the 10 audited distractor-rationale repairs (11 items) to Production, plus carrying their serving labels forward; scripts were tested in a rolled-back Production run first. Applied 2026-10-01; verified.
- Older entries (newest archive first): [`ACTIVITY_LOG-2026-09-22_to_2026-09-30`](archive/ACTIVITY_LOG-2026-09-22_to_2026-09-30.md), [`ACTIVITY_LOG-2026-06-09_to_2026-09-22.md`](archive/ACTIVITY_LOG-2026-06-09_to_2026-09-22.md)

*Rotated 2026-10-15: entries dated before 2026-10-01 moved to the archive above, with their index lines; nothing was discarded. This log now holds 2026-10-01 onward.*

**Rotation rule:** once this log exceeds ~400 lines, archive the older (bottom-of-file) entries to `docs/activity_log/archive/ACTIVITY_LOG-<range>.md` and update this index. Keep the index itself to the last ~10 entries.

<!-- INDEX_END -->

## 2026-10-15 — More help reassessed against current main

More help work reassessed after today’s log updates (2026-10-15): #460 is merged; Chemistry2.5 is already published under standalone APPROVAL-0177 and removed from the prepared run. TASK-0076 covers four possibly mistagged expanded-octet questions. Fresh Production metadata: AB80/BC3 mapped versions lack references, Chemistry0;166 lack selected topic mappings. Preserve backend/app repair checkpoints and completed Development fixture/rollback QA; no new provider calls or deployments. Temporary synthetic QA setup restored. [Reassessment](../qa/MORE_HELP_REASSESSMENT_2026_10_15.md) names current evidence, remaining gates and revised next owners/actions.


## 2026-10-15 — More help gaps reconciled and visual-audit PR merged

More help gap catalog and PR #457 merge (2026-10-15): [15 gaps with reasons/evidence/next owners](../qa/MORE_HELP_GAP_CATALOG_2026_10_15.md). Corrected stale restart surfaces: all four migrations and JWT-verified Production v1 are live; nine deployed files equal Development v10 and main. Publication request and bounded owner smoke already recorded in APPROVAL-0169/0170. Image questions are refused; multipart/figure grounding needs targeted tracing. Independent/full live matrix, human red-team and specific fixture/call proposal remain open. PR #457 merged as 04020e15 with all checks passing after main integration; no new runtime/data/provider change. Next owner independent reviewer/conductor: final-source review and smallest concrete QA packet.

Documentation-only cataloging is standing-approved. The feature remains In Progress; no new final QA PASS, task closure or permission for the unexecuted fixture/12-call proposal is inferred. Primary checkout changes, original independent reports and approved private images are preserved.


## 2026-10-14 — More help browser QA, owner visual confirmation and session close

More help browser QA and session close (2026-10-14): nested fraction digits fixed from 11.7px to 23.4px in tested expressions; local actual-component phase/pending-help/focus/layout checks, 1,144 app tests/typecheck/build and CI pass. David confirmed rendering. Backend #442, app #25 and QA docs #448 merged; independent/human/live coverage and fixture/call decisions remain open. Session ended at owner request, no Production release. [Handoff](../handoffs/MORE_HELP_SESSION_CLOSE_2026_10_14.md). Next owner David/independent QA session; next action updated independent prompt.

Original reports preserved. Current app code e1d49d9 / merge 7b81177, backend code 8c437bd4 / merge 953640f3; QA docs #448 merge c06860b3. Latest local browser transport/scoring/photo callbacks were mocked; no new provider call, database write, deployment or app publication. Temporary browser/server closed, primary unrelated work preserved. The handoff records exhausted separate grading allowance, proposed unapproved More help round, exact restart instructions and do-not-touch scope.


## 2026-10-14 — More help PR #442 review blocker

Owner asked why #442 was blocked. GitHub showed MERGEABLE/BLOCKED; required `test` and all Vercel checks passed, branch behind count zero, no required approval missing. Main requires conversation resolution. One unresolved Vercel thread correctly identified the removed zero-denominator/zero-change alternative. Restored it in backend 8c437bd4 and added spelled/numeric-zero regressions covering sources and generated copy. All 26 backend tests/typecheck pass. Deployed Development v10, JWT verification true, bundle `20c84b8c4dd2a2f1c81b1f4473f7d9dedc5b9c50f3a89e30884357b18d3a6aee`; all nine retrieved source files equal upload. No paid model/grading/photo calls, database writes or Production changes. Publish fix before resolving the addressed conversation; no PR merge performed. Full release gates remain open.


## 2026-10-14 — More help Claude follow-up findings remediated

Owner pointed to Claude's follow-up report (actual path `docs/qa/QA_MORE_HELP_RELEASE_FOLLOWUP_2026_10_14.md`). Preserved original commit e365d52b unchanged on the existing remediation branch. Confirmed N1 false-positive defect: case-insensitive letter matching rejected “matching exponents”, “eliminate a common factor” and a restated given value. Keywords now ignore case while bare choice letters require uppercase word tokens; explicit labelled/parenthesized choices remain recognized. Six supplied legitimate examples pass; original five disclosures still fail. Added N2 plain choice verdict coverage, while generic numeric/general conceptual paraphrases remain human-dependent under the selected policy. N3 answer-control state now resets on phase changes without remounting help; regressions cover comparisons, draft/choice resets and photo availability. N4 supplied rate conclusion synonyms now filtered.

Backend 6e2de1b1 and integrated app c5c26997 (phase-reset change d5ba602e): 26 backend tests/typecheck and 119 app files / 1,142 tests/typecheck/build pass. Development v9 ACTIVE/JWT verification true, bundle `246085a5eec94872dae2b290be3c98b90588481737972f1245ce54eacf8c07e0`; get_edge_function returned the same nine files/content as the upload graph. No migrations, database writes, model/grading/photo provider calls, Production changes or app publication. Signed-in browser/glyph, expanded human-reviewed live coverage, grading availability and independent follow-up remain release gates; the earlier fixture and 12-call proposals still await authorization. Preserved concurrent backend/main documentation and merged app #23/#24. Updated backend #442 and created new draft app phase-reset #25 and the QA prompt to pin these checkpoints. Producer remediation does not replace an independent PASS.


## 2026-10-14 — More help Claude release findings remediated

More help Claude release QA remediation (2026-10-14): preserved Claude report e5850eda; fixed whole-source leak scans, wider targeted disclosure checks, sibling rate phrasing, delivered-request recovery and grading-transition lifetime. 26 backend / 1,130 app tests, typecheck/build pass; Development v8 deployed. Prepared a pinned 3-MCQ Development mirror and 12-call synthetic-work Gateway QA plan; writes/calls await separate authorization. F6 and wider semantic/browser/grading coverage remain open. [Disposition](../qa/MORE_HELP_RELEASE_QA_REMEDIATION_2026_10_14.md).


## 2026-10-14 — More help release QA prompt

More help release QA prompt (2026-10-14): owner requested a QA prompt. New packet targets merged backend main 70f4a348 and private app main 75c0b18, separates code/release verdicts, requires subject/type/phase evidence and real submission/visual checks, preserves call/write authorization boundaries and orders remaining Production rollout gates. No reviewer dispatched or runtime changes. [Prompt](../qa/MORE_HELP_RELEASE_QA_PROMPT_2026_10_14.md).


## LaTeX Prose Rollout Scoped to a Pilot (2026-10-14)

David ruled the open design question from the 2026-10-13 session close: **display-only stacking** for compound
quotients in prose, slash kept inside sentences (`DECISION-0121`, amending `DECISION-0119` for prose only).
A read-only Production count showed the problem is about 1% of prose and concentrated in math-heavy courses, so he
approved author-forward plus a targeted backfill, with a pilot on Precalculus and Physics C (`TASK-0073`).
Prose maths is `\(…\)` inline and `\[…\]` display, not `$…$`, because published prose already uses `$` as
currency. Method: deterministic detection, one Sonnet-class draft per row, a validator that builds the edited
text itself so only the maths can change, then review. 33 edits are drafted across three subjects; none is applied.
The prose renderer is merged in `ap-prep-blueprint` (PR #22) and not yet published. Production writes of the content
edits remain a Hard Gate.

**Finding that matters:** the app's `.env` points at the Production database, so a Development copy cannot be viewed
in any app page; the dev harness renders the real components from sample data instead.

## 2026-10-14 — More help Gateway fixes verified on three live FRQs

More help Gateway fix verification (2026-10-14): owner approved bounded QA; three of six permitted calls returned validated 200 responses for AB, BC and Chemistry. Observed AB subpart answer withheld and answer-bearing fact excluded; BC valid; Chemistry now covered. All three receipts delivered and QA entitlement dates restored. Development v7, 22 backend tests/typecheck pass; independent/full release QA still open. [Verification](../qa/MORE_HELP_GATEWAY_FIX_QA_2026_10_14.md).


## 2026-10-14 — More help first live Gateway QA

More help first Anthropic Gateway live QA (2026-10-14): key present; owner explicitly approved three bounded calls. AB generated with a conceptual-subpart disclosure concern; BC failed validation; Chemistry not called. Two calls attempted, failed BC receipt not delivered. Three QA entitlements temporarily extended then restored. Backend #435 merged; app #21 draft. Release blocked. [Evidence](../qa/MORE_HELP_GATEWAY_LIVE_QA_2026_10_14.md).

Next: diagnose BC with content-free validation reasons, tighten and independently test the conceptual-subpart boundary, then resume the remaining authorized release QA with explicit live-call scope. No further provider calls, credit purchases, secret extraction or Production changes in this test.



## More help — Claude QA permission defect fixed, owner decisions and runtime-role tests (2026-10-13)

Claude's independent FAIL/BLOCKED report found missing service-role UPDATE on receipts and SELECT/INSERT on assistance events. Confirmed in Development and fixed with narrow grants, keeping delivery functions as invokers. Earlier producer assertions had run as owner and missed it. The [full disposition](../qa/MORE_HELP_CLAUDE_QA_DISPOSITION_2026_10_13.md) preserves this finding, the unchanged independent report and corrective evidence.

David chose targeted explicit pre-submit answer/key checks plus human red-team QA, separate delivered-help allowance / attempted-call limits, and preparation of the demo's Anthropic Gateway path. Added generation fencing, accurate private request timestamps, distinct status/reset copy, terminal refusal handling, uncertain-grade refusal, hook/item/choice allowlists, safe RPC diagnostics and server math-span filtering. No credential creation, billing purchase or billable model call occurred. Existing grader/provider secrets unchanged.

The SQL test was initially declined without a reason. David explicitly instructed “Execute using the qa account”; the full Development batch reused that account, created no Auth identity and rolled back. Service-role assertions passed grants, reserve/commit/fail/retry, current/future drafts, submitted preservation, foreign/entitlement denial, fresh-session independence, stale-worker fencing, delivered allowance versus failed calls and daily/burst attempt limits. App 115 files / 1,102 tests, typecheck/build pass; backend 18 tests/typecheck pass. Code checkpoints: backend `d2959e59`, app `172c540d`. Development migrations `20261014014023`/`20261014015127` applied and v5 ACTIVE; gateway key missing. App's private source snapshot stays local because the docs repo is public. Independent app/follow-up QA, Development MCQ fixtures, real generation and human red-team checks remain pending. Production unchanged; no Done decision.


## More help — Development remediation and Claude adversarial QA packet (2026-10-13)

David confirmed real Calculus AB/BC and Chemistry questions in app.cramapple.com, then asked why the implementation uses the OpenAI API instead of his subscription and requested a Claude adversarial code-review QA prompt. [The standalone prompt](../qa/MORE_HELP_CLAUDE_ADVERSARIAL_QA_PROMPT_2026_10_13.md) identifies exact backend/app SHAs, contracts, attack cases, test commands, evidence limits and a findings/verdict format. No Claude run or message is claimed.

Backend PR #435 code checkpoint `430fe2bd` commits delivery-only assistance with leased, bounded stable retries; app draft PR #21 checkpoint `30a65dae` commits assistance propagation, sanitized copy, one topic-relevant hook, intact math highlighting and existing-stylesheet layout. Development migration `20261014005146` is applied and function v4 is ACTIVE with JWT verification. App 115 files / 1,101 tests, TypeScript and build pass; backend 9 tests/typecheck and transactional Development assertions pass. Earlier independent review proposed FAIL on older source; new remediation still needs fresh independent QA. Scripted layout evidence is not live-generation evidence.

Approved Development generation failed with upstream `429 credit_balance_exhausted`. No retry after unchanged credit state, billing purchase or credential/provider change was made. API-key billing is separate from subscription usage; an explicit subscription integration is a different architecture and the Claude prompt challenges that choice. Production migrations/functions and app publication remain unchanged. See [work order](../tasks/WORK-MORE-HELP-PRODUCTION.md) for continuation and evidence boundaries.

## More help — positive mock feedback and production preparation (2026-10-13)

David reports “Student feedback on the mock design and content is very positive” and “I want to move calculus and chemistry into production”. The old handoff branch has been removed after PR #430 landed; current `main` contains the artifacts. Recorded the later direction in the design/handoff and created [WORK-MORE-HELP-PRODUCTION](../tasks/WORK-MORE-HELP-PRODUCTION.md) on `codex/more-help-production`.

Verified current backend main `6493417d`, App main/Lovable source `f0fbcdfff1c43bb7bbf4604efab204ad6b86a215`, healthy Production/Development projects and accessible Production RPC/reference inventory. Production has 51 Calculus AB entries in Units 1–3 and 227 Chemistry entries in Units 1–9; the existing parity record documents BC's AB alias. Identified real integration seams and a release-critical gap: question-page aid state is held in React until submission, so More help needs a durable pre-submission receipt and an explicit answer-disclosure contract. Existing grading results/repair hints can be reused without regrading.

The owner-facing destination question remains pending (real app integration versus publishing the saved two-question live demo). The work order makes the real-app assumption explicit and prepares acceptance/QA/release checks; neither feature code nor a deployment is claimed. No new model call, spending, invitation, Site audience edit, migration, app edit or production mutation occurred. Primary checkout dirty work was preserved. Next owner/action: David resolves the presented destination question; Codex implements the confirmed path from the work order.


## Session Close — LaTeX Rendering Live, Size Standard Set, Rollout Still Open — 2026-10-13

David: *"Document this thoroughly so we can revisit the LaTeX rollout soon."*

**Shipped and published to Production:** the KaTeX renderer across three surfaces, the legibility fix
that made it actually readable, and notes-sheet figures one per row. `DECISION-0119`, `DECISION-0120`
and `TASK-0072` carry the rules; the Product Owner confirmed the result signed in.

**The rollout is the open half, and it is a different kind of work.** The reference-pack formulas were
already authored in LaTeX and simply never rendered. Question and teaching prose is the opposite: it
renders fine and contains **no LaTeX at all**, product-wide. So the rollout is not a rendering change,
it is a notation decision plus a content pass plus a renderer on every prose surface.

**Size it from the targets, not the row counts.** 7,214 prose rows contain a slash, but 969 are
unit-like and 553 are Leibniz notation, both of which the rule keeps inline. The real target is **415
rows matching `(compound)/(compound)`** across ten columns, 1,044 at the looser pattern. Quoting table
sizes overstates the job about twentyfold, which an earlier draft in this session did.

**One question must be ruled first.** The rule stacks a compound quotient; applied literally to
`Let f(x) = (x²−x−6)/(x²−4). Which statement…` it stacks inline, mid-sentence. Display-only stacking
for prose is a legitimate alternative that has not been decided. Deciding it after the content pass
means doing the pass twice.

**A render-time transform was considered and rejected.** The `(…)/(…)` pattern is clean enough to
detect, but it would silently reformat 415 published, reviewed items on a pattern match. 415 rows is a
reviewable pass; author it.

Full record, including the per-surface target table, the measured size state of every surface, and the
verification traps this session hit:
`docs/handoffs/LATEX_ROLLOUT_AND_VISUAL_SIZE_SESSION_CLOSE_2026_10_13.md`.

**Next Owner:** David Bloom. **Next Required Action:** rule inline-vs-display for prose maths, then open
the rollout task and pilot one surface on one subject before widening.

## Rendered Maths Made Legible, and a Size Standard the Figures Do Not Meet — 2026-10-13

David, after the `DECISION-0119` renderer shipped: the formulas render, but they are **too small to
read**. Then, after the fix: "it looks much better". Then: "Document this size standard for future
equations, graphs and other visuals".

**The cause was not the font size on the container.** In KaTeX's inline (text) style a fraction's
numerator and denominator are rendered at `size3` — 0.7× — and marked `mtight`. A 17px container
therefore produced roughly 12px digits, and **no base size could have fixed it, because the shrink is
relative to the base**. Rendering the source in display style (`\displaystyle`) removes the shrink
while keeping the formula inline; `displayMode` proper would also have centred it on its own line,
which is a layout change rather than a legibility one. With a 1.3em base a fraction's digits now
measure ~20.8px against 16px prose.

**Applying display style everywhere was itself a regression**, and the screenshots caught it: a
one-symbol label such as `\sum_i` became a full-height sigma with its index set beneath it, 48px
against the 24px definition row it labels. Symbol labels now render compact, in inline style.

**The standard** (`DECISION-0120`, written into `VISUAL_IDENTITY.md` under "Sizing what a student
reads"): the 16px floor is a reading rule and binds on the **smallest character a student must read,
measured in rendered pixels**, not on the nominal size of the element. Chrome and the subordinate
characters of maths typography — subscripts, superscripts, limits — are exempt. Compliance is
established by measurement, never by inspection: three separate defects here were invisible to the
test suite and to reading the markup, and visible in one measurement.

**Applying it to the figures found a live problem.** Figure text is authored in SVG user units and
then scaled to its container, so the authored number is not the rendered size. Across 47 rendered
figures and 526 labels: **99.8% render below 16px, 87.1% below 12px**, median 9.8px, smallest 8px.
That is smaller than the mathematics David rejected as unreadable. The authored scale in the app's
`lib/figures/render.ts` is under the floor on its own terms (`tick: 10.5`, `mark: 11`, `axis: 12`), so
this does not depend on the width it was measured at.

**Documentation only, and the figure remediation is deliberately NOT authorised here.** Enlarging type
inside a fixed viewBox costs layout room, so it needs its own task, a pass over the affected families,
and the three-gate figure verification (property tests, eyes, model readers) rather than a global
constant bump. The 73 published figures stay as they are until then.

**Next Owner:** David Bloom. **Next Required Action:** decide whether the figure resize becomes a task,
and whether the ~402-row prose retrofit does.

## Equation Presentation Rule Recorded; the Real Defect Is a Missing Renderer — 2026-10-12

David directed: "start a cramapple session focused on equation presentation. Equations with division
should be stacked, not separated with /", then "use katex default fonts, write the rule first".

The premise was half right, and the halves live in different places.

**Reference-pane formulas were already correct.** `app.unit_reference_entries` holds 327 formula
entries, 325 published. 144 use `\frac`; exactly four contain a slash, and all four are legitimate
(`t_{1/2}`, `d/7`, `b^{1/k}`, and the unit `m/s`). There were no content violations of the rule.

**The defect is a renderer that was never built.** `ReferencePane.jsx` renders formula bodies as plain
monospace text, so 308 published formulas reach students as raw LaTeX backslashes — confirmed against
captured Production data (`\bar{m} = \sum_i m_i f_i` shown literally). The reference protocol had this
logged as a non-blocking open design item; it is now a tracked defect.

**The slash problem is real, but in prose.** Stems, choices, rationales, FRQ criteria, explainers and
briefs carry zero LaTeX and write compound quotients inline — `(x²−4)/(x−2)`, `(214 - 190)/(6 - 5)`,
`(3 - t)/(t^2 - 16)`. Sampling separated these from the conventional slashes that must stay: compound
units, Leibniz notation, simple reciprocals, and fractions inside arguments or subscripts.

**The renderer choice was decided by evidence.** A macro survey over the 308 published formulas found
74 distinct macros, including `\begin`/`\end` environments, `\oint`, `\binom` and `\mathcal`. A
hand-rolled subset renderer would have silently broken a long tail. David chose KaTeX in its own
bundled faces after comparing three renderings of real published formulas side by side
(`docs/product/EQUATION_PRESENTATION_RENDERING_COMPARISON_2026_10_12.html`; KaTeX rendered every
sampled body with zero errors). That amends `VISUAL_IDENTITY.md`'s STIX Two Math rule, annotated in
place rather than rewritten.

Recorded as `DECISION-0119`. Rule written into `docs/new_design/CONTENT_AND_PEDAGOGY.md`; pointers added
in `docs/INDEX.md` and the reference-pack protocol.

Documentation only at the time of writing: no Production write, no migration, no app change.

**UPDATE, later the same session — the renderer shipped.** `ap-prep-blueprint` PR #16, merged as
`2bb35c6` and Lovable-published. Reading the code had found one surface printing LaTeX source;
loading the real harness page found **three** — `LookUp`, `Entries` in `QuestionExperience.jsx`, and
deep-dive note sections — plus symbol-definition labels, which are LaTeX themselves. Deep-dive bodies
are flat strings, so maths is delimited with `$` where the section is built and stripped again for the
clipboard, leaving copied notes byte-identical. KaTeX renders in its own faces; a partial render is
rejected so a content defect shows as unrendered source rather than KaTeX's red, which this product's
palette has no place for. **All 321 distinct published formula bodies render cleanly (0 errors, 0
fallbacks)** and ship as a test fixture, so the next KaTeX upgrade fails in CI rather than in front of a
student. 1073 tests pass, build self-hosts 59 KaTeX font files. **A caution for the next session:**
Production cannot be checked anonymously — `app.cramapple.com` 302s to `cramapple.com` when logged out,
so `curl -L` hands you the marketing site and a 404 body reads as 'feature absent'. I made that mistake
twice. Check signed in, or not at all.

**Next Owner:** David Bloom. **Next Required Action:** decide whether to build the KaTeX renderer into
the app next, and whether the prose retrofit (~4,400 stems, 11,456 choices and rationales, 6,594 FRQ
criteria, 603 explainers and briefs) becomes its own task — it needs a notation decision for surfaces
that carry no LaTeX today, plus a Production hard gate.

## Hooks Permitted in Hints and Targeted Help; Reference Packs Verified Already in Production — 2026-10-12

David directed: "All reference packs should be in production. Update the rule about using hooks and hints."
Recorded `DECISION-0118` and `APPROVAL-0164`: relevant published hooks may be used in hints,
post-miss feedback, and student-requested targeted help, with expansions/cautions and existing
assistance timing and answer-disclosure rules. The new template/agent is not implemented by this change.

Live read-only queries against both Cramapple projects returned matching counts and content hashes
across all 33 stored subject-unit groups: 1,083 published reference entries and 13 hooks. A separate
Production query confirmed the raw totals, the Calculus BC → AB alias, and both demo formulas.
The earlier chat answer relied on an outdated Development-only handoff; the later Production
promotion was already recorded in `APPROVAL-0154`. Added a visible correction to the dated handoff
and refreshed the index. No data was loaded and no schema, function, or frontend was deployed.

Evidence and restart note: `docs/qa/REFERENCE_PACK_PARITY_AND_HOOK_HELP_POLICY_2026_10_12.md`.
Work isolated on `codex/hook-help-policy`; unrelated dirty primary-checkout files excluded.
**Next owner / action:** the implementation owner, once the targeted-help slice is approved, should
wire the selected reference content and existing assistance recording into the new surface.

## Current-MCQ Answer Preload Implemented for Instant Feedback — 2026-10-11

David accepted the browser-inspection risk and directed that answers be preloaded for the current question
and retained in memory. `TASK-0071` implements that direction without reopening the direct database reads
closed by `TASK-0056`.

The additive `student-session-items` request returns answer metadata for one version only after checking
that the signed-in caller owns an active session, the version belongs to its exam pack, the item and
version are published, the item is an MCQ, and exactly one choice is correct. The ordinary serving page
still carries no answer fields.

The app clears the old answer whenever the current item changes. On a choice click it constructs the
existing review shape locally, displays feedback immediately, and keeps the server grade, persistence and
read-back running. Navigation is disabled while that write is pending. A failed write leaves the feedback
visible and offers retry; a failed preload uses the old server-only flow.

Verification: `deno check`; 35/35 backend tests; 56/56 focused frontend tests; 1,011/1,011 full frontend
tests; production build passed. The repo-wide frontend lint command still reports 6,008 baseline errors,
mostly formatting, so no unrelated bulk-format change was made.

**Production is untouched.** `APPROVAL-0161` covers implementation and PRs only. The coordinated Edge
Function deploy and app publish require a separate Hard-Gate approval. Session closed with backend PR
[#421](https://github.com/david-bloom/Cramapple/pull/421) open and mergeable with all checks green, app PR
[#14](https://github.com/david-bloom/ap-prep-blueprint/pull/14) merged with CI green, and the durable handoff at
`docs/handoffs/SESSION_CLOSE_2026_10_11_CURRENT_MCQ_ANSWER_PRELOAD.md`.

## App Accessibility, Consistency and Colour Pass — 2026-10-11

An accessibilitychecker.org audit of `app.cramapple.com/question` scored 60. David asked for:
- the audit findings to be fixed;
- every other app page (hub, Lesson Notes, BYOQ, sign-in flows) to be reviewed for the same issues and for consistency;
- more colour without losing accessibility.

The marketing site was ruled out of scope.

Method: axe-core 4.10.2 ran signed out on the live site, and locally on every page and dev-harness state at 1440px and 375px. Signed-in pages were rendered from fixtures.

The App repo merged three PRs:
- **#7:** landmarks, radiogroup semantics, picker label, darker `--surface-brand` top bar.
- **#8:** one orange top bar app-wide; contrast tokens; heading order; student sign-in redirect; phone wrap; hub Lesson Notes text; coloured curriculum categories.
- **#9:** colour pass: cool desk, mode-tinted topic bar, role-tinted pane headers, rubric rows, hub header strips. David declined subject accents.

PR #7 merged before three of its commits were pushed. Those commits went in with #8, and every commit was verified on `main` at `d7e85cb` (CI green).

Result: 13 pages and states at both widths, 0 violations. New design-rule tests forbid faint or mid-tone text on any colour tint.

**Next Owner:** David. **Next Required Action:** check the hub, `/question` and Lesson Notes signed in on a real account, then approve a Lovable publish of App `56cae479` (Hard Gate). Re-run axe on the live site after the publish. Record: `docs/handoffs/SESSION_CLOSE_2026_10_11_ACCESSIBILITY_AND_COLOUR_PASS.md`.

## Production Google Login Repaired: Desktop OAuth Client Replaced With the Registered Web Client — 2026-10-10/11

David reported that Google login at `cramapple.com/login` was blocked by Google's `401 invalid_client` / `no registered
origin` page. The published login bundle and Lovable source both used
`158405956539-ocd20mf4i260gig8uhotbhj9p6aek228.apps.googleusercontent.com`; direct inspection in Google Cloud confirmed it was
the project's **Desktop** OAuth client, which cannot carry authorized JavaScript origins. Supabase Auth logs contained no
matching OAuth event, consistent with Google rejecting the browser client before a token reached Supabase.

The existing `Cramapple_Supabase` **Web application** client
`158405956539-1j6r2bit7ej1p2oavbftuddc2ukhhj3c.apps.googleusercontent.com` already had the three required origins
(`https://cramapple.com`, `https://www.cramapple.com`, `https://app.cramapple.com`) and
`https://pcntajvbdfqhbeewmdry.supabase.co/auth/v1/callback`. Lovable marketing commit
`4aa50678966d0a420d1cbeb6fa2b57f3a67f0c0d` changed only `.env`'s `VITE_GOOGLE_CLIENT_ID`. Typecheck passed, all 85 tests in
10 files passed, and the production build succeeded. David explicitly approved the Production publish (`APPROVAL-0155`);
Lovable deployment `428d147a-102f-4e0a-8930-16a25b5889a5` was triggered.

Post-publish verification fetched `https://cramapple.com/login` and its new `/assets/login-BRb5p0X7.js` bundle, confirmed the
Web client ID and `signInWithIdToken`, loaded the live page in Chrome, saw the personalized Google button render, and found zero
browser console warnings/errors. The agent did not click the button or complete sign-in. David then confirmed Google login was
successful in Production.

**Scope boundary:** this repairs `/login` only. TASK-0058 Work A remains open because its done condition is Google ID-token
sign-in on `/checkout`, with the nonce/FedCM and verified-email checkout behavior described there.

**Next Owner:** open. **Next Required Action:** none for the incident. Resume TASK-0058 only when the post-pilot checkout work is
intentionally scheduled. **Do not:** delete or repurpose the Desktop client merely because it caused this mismatch; it is no
longer referenced by the web app, and this repair did not require any Google Cloud configuration change.

## Lane A Figures: Built, Deployed, Published — 2026-10-10/11

**Where this started.** David asked how to turn descriptions of graphs into graphs with
descriptions. The honest answer was that the slot had been built and deliberately left empty:
`app.unit_reference_entries.visual_asset_ref` is a forward declaration pointing at no table, and
the governing design (`TASK-0006`) had sat unapproved since 2026-06-12.

**What was decided.** Rather than approve the whole four-lane model, the Product Owner approved a
narrow Lane A pilot. Two corrections to TASK-0006 §10 came out of reading the actual corpus: no
phylogenetic tree exists in any pack, so its proposed first Lane B prototype serves nothing
authored; and free-body/vector-arrow and particulate-box grammars are the cheapest real Lane B
start.

**What was built and shipped.**

- A dependency-free renderer: 6 chart families, 3 layout presets, ported to TypeScript and verified
  against the Python reference (32 of 33 outputs byte-identical; the exception is a 0.1-unit
  rounding split at an exact `.25` boundary).
- `app.figures` + `app.figure_uses` — a table and a join, not a column, so `usedBy` is a list and a
  figure can be recalled beside more than one entry or, later, a question.
- `get_topic_point_guides` returns `figures[]`, joined through `published_reference` so figures
  inherit that CTE's scoping including TASK-0070's shared entries.
- Rendered in the `/question` Graphs section and in a Figures section of its own on the Lesson
  Notes sheet, with an enlarge dialog. Copy notes rasterises to PNG.
- Live in Production (`APPROVAL-0153`), published in Lovable at `388b654`.

**Measured.** 0 models and $0 at render time; 0.57 ms mean render; $0.18 for the two-reader review
of 11 figures ($0.016 each) plus $0.39 of discarded exploration; 462 pilot checks and 896 app
tests.

**The methodological finding, which is the reusable part.** Property tests and visual inspection
caught *disjoint* sets of defects. The tests caught what nobody would eyeball — a missing
direction-of-change statement, undisclosed synthetic data, an entry needing two figures. The eye
caught six defects that passed a green suite: a legend heavier than its curve, an annotation
rendered off-canvas while coverage still claimed it, two pairs of overprinting labels, axis ticks
at fifths of the range, and a title running off the canvas. Neither gate substitutes for the other.
A third gate, two non-Anthropic model readers with five planted controls, caught three control
classes the tests cannot see — and a *newer* model (`gemini-3.8-flash`) accepted one with high
confidence while the ratified older one scored 5/5.

**Corrections made along the way, recorded so they are not repeated.** An early count of 30 diagram
entries was taken from a branch 95 commits behind main; it is 41. A claim that all 10 Chemistry
figures mapped to published entries came from pre-load seed artifacts; 9 do. Google Docs does strip
inline SVG — asserted before it was verified, then verified — but it does **not** strip `data:`
URIs, which a search had suggested and which would have led to building unnecessary hosting.

**Also in this session.** TASK-0070 deployed to Production (`APPROVAL-0152`); the `/question` pane
grid capped and centred so the question column stops absorbing the viewport (296/1240/360 at 2000px
became 340/696/460); the answer key and the worked example tied together with a shared mark; and
four pieces of copy removed on the Product Owner's instruction.

**Protocol.** `docs/product/FIGURE_PRODUCTION_PROTOCOL.md`.

**Open.** No human expert has reviewed the illustrative values. 13 Lane A entries outside
Chemistry and all 18 Lane B entries remain. `chem-mb-catalysis` has no published entry to attach
to. TASK-0006's five owner decisions are still formally open.

## TASK-0006 Lane A Figures Deployed to Production — 2026-10-10

**Authorisation.** David: "deploy the figures migrations" (APPROVAL-0153), immediately after
approving the TASK-0070 deploy that this one builds on.

**Applied, in order.**

1. `20261010210000_task0006_lane_a_figures` — `app.figures` (keyed by `figure_id`) and
   `app.figure_uses` (many-to-many), their constraints, RLS, grants, and the `security_invoker`
   views `public.figures` / `public.figure_uses`.
2. `20261010210100_task0006_lane_a_figures_seed_chemistry` — the ten AP Chemistry figures and
   their uses, with a guard that raises if any figure ends up unattached.
3. `20261010210200_task0006_guides_rpc_returns_figures` — `get_topic_point_guides` returning a
   top-level `figures` array.

**Pre-flight.** No name collisions for any of the four objects; all nine entry titles matched
published Production rows; `ap_chemistry` present in `app.subjects` for the RLS policy.

**Verification, as a real authenticated student rather than `service_role`.**

- Topic 5.5 returns 1 figure; topic 7.1 returns both `chem-approach-equilibrium` and
  `chem-approach-equilibrium-rate`; topic 1.1 returns `[]`; the whole subject returns 10;
  AP Statistics returns 0.
- `public.figures` shows 10 rows to a student.
- No regression: AP Chemistry unit 1 still returns 26 reference entries.
- Production's function now hashes to `25b6e08c84e5db9fac69741f93efa054`, identical to
  Development's — so the body deployed is exactly the reviewed one, assembled correctly.

**Why the seed attached cleanly.** Uses resolve by natural key (subject, kind, title), not by a
hardcoded `reference_entry_id`. Development and Production hold the same chemistry entries under
different UUIDs, and the foreign key rejected the first id-literal version on Development — which
is what prompted the portable form and is why the same file worked unchanged here.

**Student impact: none yet.** The app code that renders figures is on the unmerged branch
`claude/lane-a-figure-renderer` in `ap-prep-blueprint`, and the Lovable app has not been published.
The live frontend simply ignores the additive `figures` key. The database is ahead of the client on
purpose.

**Ledger.** `apply_migration` stamped its own versions again; all three rows were corrected to the
committed filenames (`20261010210000`/`210100`/`210200`), keeping file order and ledger order the
same.

**Rollback.** `update app.figures set status = 'retired';` — the RPC's `figures` key then returns
`[]` and the student views go empty, with no function or schema change. A full removal is
`drop view public.figure_uses, public.figures; drop table app.figure_uses, app.figures;` plus
restoring the previous function body from `20261010170000`.

## TASK-0070 Deployed to Production — 2026-10-10

**Authorisation.** David: "deploy task 0070" (APPROVAL-0152). The migration had been applied to
Development on 2026-10-10 and held; Production was untouched until now.

**What was applied** (`supabase/migrations/20261010170000_task0070_shared_reference_serving.sql`,
verbatim): `app.subject_reference_aliases` with its four check constraints, RLS enabled and forced
and no policies, seeded with the single row `ap_calculus_bc` reads `ap_calculus_ab` units 1-8; and a
`CREATE OR REPLACE` of `public.get_topic_point_guides` whose `published_reference` CTE unions the
requesting subject's rows with alias-sourced rows under three guards (own row wins, unit range, the
requesting subject's own taxonomy must contain the owner topic). No content row was created, copied
or modified.

**Preconditions checked first.** `app.subject_reference_aliases` absent, `app.taxonomy_source_versions`
and `app.unit_reference_entries` present, AP Calculus BC has one taxonomy source version, three
Calculus subjects registered, and zero Calculus reference rows.

**Verification.**

- Production's `get_topic_point_guides` now hashes to `70c93d71fceb7d0ed058fa27b1d4dab5`, byte-identical
  to Development's.
- Alias table: 1 row, RLS on, 0 policies — only the SECURITY DEFINER function reads it.
- No regression, queried as a real authenticated student rather than `service_role`: AP Chemistry
  unit 1 returns 26 reference entries and 1 memory hook, topic 1.2 returns 2; AP Statistics unit 1
  returns 80.
- The sharing branch itself cannot be exercised in Production, because it holds no Calculus reference
  entries. It was proven on Development, which runs the identical function: AB unit 1 has 24 entries,
  BC unit 1 returns all 24, all 24 carry `sharedFromSubjectKey = ap_calculus_ab`, and BC unit 10
  returns 0 — correctly outside the 1-8 alias range.

**Student impact today: none.** Production has 0 Calculus reference rows for AB and BC alike, so BC
students see no change until a Calculus reference pack is published. This deploy removes the blocker
rather than delivering content.

**Migration ledger.** `apply_migration` stamped version `20261011012939` instead of the committed
filename. The ledger row was corrected to `20261010170000`. The documented remedy is to rename the
local file, but that would have ordered TASK-0070 *after* the pending TASK-0006 figures migrations
(`20261010210000`-`210200`), which replace the same function and depend on this one.

**Rollback.** `delete from app.subject_reference_aliases;` — the unioned branch then matches nothing
and the function returns exactly its previous payload. No schema change needs reverting for that.

**Open.** The TASK-0006 Lane A figures migrations are applied to Development only and replace this
same function body a third time, adding a `figures` key. Deploying them to Production is a separate
decision.

## TASK-0070: Calculus BC Serves AB's Shared Reference Content — 2026-10-10

**The question.** David, on reviewing the proposed Calculus BC re-key: *"why do we need a separate reference
pack for units 1-3?"* Investigated rather than answered from the data model, and the answer was **we do not**.

**Evidence.** AB and BC share one CED PDF. BC's units 1-5 topic sets are *identical* to AB's (16/10/6/7/12,
zero asymmetric difference), units 6-8 BC is a *superset* (adds 3, 2, 1; `ab_only = 0` for every unit 1-8),
and units 9-10 are BC-only. The only thing making BC serve nothing was that `unit_reference_entries` is keyed
by `subject_key` and `get_topic_point_guides` filters on it.

**Why duplication was rejected, not just declined.** The precedent exists — `topic_explainers` and
`topic_point_briefs` do carry separate BC rows — but it has already failed. All 81 shared AB/BC explainers
differ in text, and units 1-8 show **AB 81 rows with 35 repaired against BC 87 with 85**: a 2026-08-21 repair
pass BC received and AB largely did not. An AB student on topic 1.1 currently gets a thinner explainer than a
BC student on the same topic. Duplicating per subject concealed a one-sided repair rather than keeping the
copies aligned, and copying the reference pack would have started the same clock plus required mirroring all
43 corrections made earlier today.

**Shipped to Development** (`supabase/migrations/20261010170000_task0070_shared_reference_serving.sql`): a
general `app.subject_reference_aliases` table, seeded with one row (`ap_calculus_bc` reads `ap_calculus_ab`,
units 1-8), and a `CREATE OR REPLACE` of `public.get_topic_point_guides` whose `published_reference` CTE
unions the requesting subject's rows with alias-sourced rows under three guards: the requesting subject's own
row always wins on `(owner_topic_code, kind, title)`, the unit range is bounded, and an alias row is served
only when its owner topic exists in the *requesting* subject's latest verified taxonomy. Reference objects
gain an additive `sharedFromSubjectKey`. **No content row was created, copied, re-keyed or deleted.**

**Verified against a 30-probe pre-change baseline:** 23 of 30 payloads byte-identical once the new additive
key is stripped, and the 7 that differ are exactly the BC units 1-3 probes (0 → 24/17/10 on the roll-ups,
matching AB topic for topic). BC units 6/9/10 stayed empty, correctly. Both guards were exercised in
rolled-back transactions — a BC row duplicating an AB row replaced it rather than doubling it, and an AB entry
on a topic absent from BC's taxonomy reached AB but never BC including in the roll-up — and the database
confirms nothing was left behind. The alias table is RLS-forced with no policies and no grants beyond
`postgres`; an `authenticated` role reading it gets `permission denied`. The migration applied twice with no
drift. All 8 QA checks ok.

**A mistake worth recording.** The first apply failed on a syntax error: `pg_get_functiondef` returns no
trailing semicolon, so the appended `commit;` was swallowed into the function body. Before diagnosing it the
migration ledger row had already been inserted, claiming a migration that had not applied. Both were
corrected — ledger row deleted, Development verified untouched (alias table absent, function md5 still
matching the pre-change hash) — before re-applying with the terminator fixed.

**Scoped out on purpose.** The anonymous BYOQ path reads the `public.unit_reference_entries` and
`public.topic_memory_hooks` views rather than this RPC, so a BC visitor there still sees nothing (0 BC rows
against 51 for AB). Those views are read by the edge function in the still-open PR #399, so widening them is
recorded as follow-up **F1** instead of being changed underneath work in flight. AB's apparently pre-repair
explainers are **F2** and need a Product Owner call.

Code change, so the PR goes to David. Production untouched.

## Extractor Prompt Fixed for Boundary Statements; Pipeline Scripts Given a Canonical Template — 2026-10-10

**Why.** Of the 50 escalations in the units 1-3 run, 7 could not be corrected at all, only dropped: each had no
learning-objective or essential-knowledge basis. Three came from **Exclusion/Boundary Statements**, two from
**SUGGESTED SKILL** lists printed beside the topic, one from **"Preparing for the AP Exam"**, and one from
**ILLUSTRATIVE EXAMPLES** alone. The extractor sees all of this because the unit page ranges necessarily include
the unit opener and the margins of each topic page, and nothing in the prompt told it those sections are not
content.

**Protocol §1.2 added.** It names the admissible source (LO/EK statements under Required Course Content), lists
the sections that may never be the basis for an entry, and keeps the two legitimate uses of a boundary statement:
deciding what to leave out, and being quoted in the `caution` of an entry that has its own LO/EK basis — the
accepted AP Physics 1 kinematic-equation entry does exactly that. It also makes an LO/EK citation in
`ced_evidence` a hard gate, and warns that code style differs by subject (`1.5.A.2` in the sciences,
`CHA-2.A.1` / `FUN-3.B.1` in Calculus), so an automated check of that field must accept both.

**Scripts now have a canonical baseline:** `scripts/content-seed/reference-pack-template/`. Until now each batch
copied scripts from a previous batch, so prompt lessons were lost whenever a session picked the wrong ancestor —
this run hit two prompt defects that had already been diagnosed. Protocol §3 now says to copy from the template.
Each batch still keeps its own copy so its artifacts stay honest about what produced them. The template's README
records every enforcement the scripts carry beyond the first pilot and notes that `gateway.py` resolves the
gitignored key at `parents[3]`, so the scripts only run from a directory at that depth.

**Verified rather than asserted.** Re-extracted two units that had produced inadmissible entries, against the
same CED pages and fact-pack sections:

| Unit | Previously produced | Under the fixed prompt |
|---|---|---|
| Physics C: E&M unit 8 | "Limit on discrete-charge force calculations" (8.1 boundary statement) | gone; 31 entries, 0 citing a non-LO/EK section |
| Calculus AB unit 2 | "Calculator answers: rounding" (exam-prep text) and "Keep notation precise" (Skill 4.C plus an invented rule) | both gone; 16 entries, 0 citing a non-LO/EK section |

Every entry in both runs cites a recognisable LO/EK code. A first pass of this check reported 16 Calculus
entries with no code; that was the check's own regex not accepting `CHA-`/`FUN-` style codes, not a defect in
the output.

The test re-extractions were a prompt test only: nothing from them was loaded to any database, no existing batch
was re-run or re-keyed, and the committed batch scripts still reflect what actually produced their rows.
Production untouched.

## Ownership Rule Written into the Reference-Content Protocol — 2026-10-10

**Why.** The protocol said an entry is "owned by the topic that first requires it". Both checker families read
that as *earliest mention*, so they rejected correctly-owned entries on `b_topic_codes`; that single phrase
produced most of the ownership escalations in the units 1-3 run across nine subjects, and the Product Owner
overrode the checkers on it five times.

**What changed.** New `§1.1 Ownership: which topic owns an entry` in
`MEMORY_HOOKS_AND_UNIT_REFERENCE_PRODUCTION_PROTOCOL.md`:

- the rule — the owner is the topic whose LO/EK requires the entry *as stated*, not the earliest topic to
  mention the idea;
- the test — which topic's LO/EK would be incomplete without this entry stated this way;
- `topic_codes` is the owner plus *later* reuse topics, and a topic preceding the owner is never a reuse tag;
  if an earlier topic needs its own lookup, that is a separate entry owned by that topic;
- five worked examples, each a ruling rather than an inference: AP Statistics 1.13 (`DECISION-0107` rule 2), AP
  Chemistry 1.7, AP Physics 1's kinematic equation (1.3) and normal force (2.7), AP Precalculus concavity (1.3);
- the instruction that a checker's ownership objection is not by itself grounds to move the owner — re-apply the
  test and escalate for an override instead of re-keying to satisfy the checker, and escalate rather than cycling
  encodings when the two checker families disagree with each other (AP Physics 2's 10.7 case took three attempts);
- the exact prompt wording for `extract.py` and `check.py`, so the next batch's copied-forward scripts apply the
  rule instead of re-escalating it.

The same loose phrasing in `AP_CHEMISTRY_CED_SCOPE_INVENTORY_2026_10_09.md` §3 was aligned, and its
`topic_codes` bullet now bars a pre-owner topic too.

**Governance.** This codifies `DECISION-0107` rule 2 and the Product Owner's 2026-10-10 rulings rather than
setting new policy, so it carries no new decision id; the protocol's RECORDS line and a change note say so. Docs
only: no content, database, migration or Production change, and no previously loaded row changes disposition.

## Last Four Escalations Ruled; Development Found to Be Shared Mid-Run — 2026-10-10

**Ruling.** David: keep **1.3, 2.7 and 1.3** as owners, and **10.7** for Physics 2. All four loaded with
`load.py --po-accept`, so each row's `source_note` carries the override and its reason. With these, **all 50
escalations are dispositioned: 43 corrected and loaded, 7 rejected as having no learning-objective or
essential-knowledge basis.**

**The ownership principle is now settled and should be written down.** Three rulings now agree that the topic
whose objective *requires* the entry owns it, not the earliest topic that merely mentions the idea
(`DECISION-0107` rule 2, the AP Chemistry Unit 1 periodic-trends call, and this one). The checkers systematically
prefer earliest mention, so until the protocol says otherwise every batch will keep escalating the same question.

For Physics 2 the 10.5 reuse code was dropped, because `topic_codes` means the owner plus *later* reuse topics and
10.5 precedes 10.7. Checked for a serving gap first: topic 10.5 carries its own `Electric potential difference`
entry and still returns 11 reference entries.

**Development is a shared database and moved mid-run.** While this session ran its correction pass, another
session loaded into the same Development project: PR #399's 2 Chemistry Unit 1 escalations at 11:37 UTC (the ones
this session had reported as not yet applied) and a new `task0067-chem-u5-u9-2026-10-10` batch of 119 rows at
11:49-11:53 UTC, a batch directory that does not exist in this session's working tree. Attribution by `created_at`
and the `batch=` tag: Development holds **1,076 entries and 13 hooks**, of which **829 entries are this session's**
(786 initial + 39 corrected + 4 ruled) and 247 belong to other batches.

Two consequences: a Production approval must **name batches rather than a row count**, because a count taken in a
shared Development database is not reproducible; and the earlier 912/951 figures in this log were accurate when
measured but are not comparable to the current total. All 8 QA checks still pass across the whole table, which
says the concurrent batch has not broken the invariants, not that its content has been reviewed here.

## Escalation Correction Pass — 2026-10-10

**Instruction.** David: correct the escalated rows in this session rather than regenerate them through the API
pipeline. The production protocol bars hand-editing a generated row (`§3` step 6), so this is a **recorded
deviation**, taken under the Product Owner's `§4` authority over every escalation. Two safeguards were kept: each
correction restores the CED's own wording or qualification that a checker had identified as missing, verified
against the CED PDF rather than the fact pack; and every corrected row went back through the same two independent
checkers and the reject-only own-family veto. Rationale text was deliberately kept out of the candidate files so
it could not bias a checker.

**Count correction.** The escalation total is **50, not 45**. The 45 in the preceding entry was computed before the
last three batches finished and was never recomputed; the per-subject table in the session record was always right
and sums to 50.

**Outcome: 39 corrected and loaded, 7 rejected, 4 open.** Development went from 912 entries and 10 hooks to **951
entries and 11 hooks**. One hook returned with its corrected entry (the Calculus AB implicit-differentiation
chain-rule hook, whose caution had over-claimed that every term containing y carries a factor of dy/dx). All 8 QA
checks returned ok and RPC probes serve the corrected rows.

**The 7 rejected could not be corrected, only dropped.** Each had no basis in a learning objective or
essential-knowledge statement, which the inclusion rule requires: three came from **boundary statements** (Physics 1
"action at a distance is gravitational only"; E&M's four-or-fewer-charges limit and its list of quantitatively
examinable capacitor geometries), two from **suggested skills** (Biology's graph components, Calculus AB's notation
rules), one from **"Preparing for the AP Exam"** (Calculus AB's three-decimal rounding), and one from
**illustrative examples only** (Biology's cellulose/starch/glycogen list). This is a systematic extractor failure
mode worth fixing in `extract.py`: it mines those sections as if they were course content.

**The 4 open are not arbitrary.** Three are the same ownership question, and David has answered it twice already
(`DECISION-0107` rule 2, and the AP Chemistry Unit 1 "Tools for explaining periodic trends" call): the checkers
assign ownership to the earliest topic that *mentions* an idea, while David has chosen the topic whose objective
*requires the entry as such*. Applying his precedent loads all three unchanged. The fourth, Physics 2's
ΔU_E = qΔV, is a real deadlock: GPT-6 Sol insists on owner 10.5, the veto rejected exactly that and insists on
10.7, and all three encodings tried were rejected by one or the other. The session did not self-override a veto or
a two-checker rejection in any of the four.

**Provenance.** Every corrected row's `source_note` carries `product-owner-directed correction by the Claude
session (David, 2026-10-10)`, so a corrected row is distinguishable in the database from a stateless
re-extraction. `load.py` gained a `correction_note` passthrough for this. Per-correction reasons are in each batch
README and in `docs/handoffs/REFERENCE_PACK_CORRECTION_RATIONALES_2026_10_10.json`.

**Cost.** The pass added 153 checker calls and $1.22; session total 4,165 calls and $39.02. Production untouched.

## Reference Packs Built for Units 1-3 of Nine Subjects — 2026-10-10

**What happened.** David scoped the session to **units 1-3 for all subjects, Development only**, ruled the two
AP Chemistry Unit 1 escalations carried in from PR #399, and then supplied the four Physics CEDs
(`ap-physics-1`, `ap-physics-2`, `ap-physics-c-mechanics`, `ap-physics-c-electricity-and-magnetism`) that had
been the one hard blocker: those subjects had fact packs but no CED PDF, and the protocol makes the PDF the
authority. They were copied from his gitignored `subject packs/` into `docs/teaching/` alongside the other six.

**Twenty-five unit batches** were taken through the governed pipeline (controls first, Claude Sonnet 5.5
extraction, independent Gemini 3.5 Flash and GPT-6 Sol checkers, reject-only Claude Haiku 5.5 own-family
veto, stateless Round 2, escalate rather than patch): Statistics 2-3, Chemistry 2-3, Biology 1-3, Calculus AB
1-3, Precalculus 1-3, Physics 1 1-3, Physics 2 9-11, Physics C: Mechanics 1-3, Physics C: E&M 8-10.
**786 entries and 6 hooks loaded**, taking Development to **912 published entries and 10 hooks**.

**Controls: 150 planted defects, 150 caught — 6/6 in every batch.** One control was found wrong *before* its
run and corrected rather than voiding it: the Biology Unit 2 "non-CED" control claimed the Na+/K+ pump is
absent from the CED, but it is at 2.8.A.1.ii and only the PDF's superscripts hid it from a text search. The
CED gives no pumping stoichiometry, so the planted defect stood and its justification was rewritten.

**Two script defects found and fixed.** `load.py` now refuses any accepted row that breaks a schema invariant
the checkers do not police: a Statistics Unit 3 row had `owner_topic_code` 3.3 with `topic_codes` `{3.4}`, all
three models passed its topic codes, and because the load is one transaction the whole batch silently wrote
nothing until the row was pulled. `extract.py` now requires a `caution` on any hook whose wording is not the
CED's point-earning wording — the Statistics Unit 2 BINS hook was otherwise correct and was rejected twice for
exactly that omission.

**Verified.** All 8 checks in `scripts/qa/unit_reference_and_memory_hooks_qa.sql` returned ok. Read-only RPC
probes (rolled back) returned 9 and 11 entries for two Physics 1 topics (3 hooks on 1.5), 47 for the Physics
C: Mechanics unit 2 roll-up, and empty arrays with unchanged briefs for Calculus BC. The RPC is
`public.get_topic_point_guides(_subject_key, _unit_number, _topic_code)`; earlier records naming
`app.get_topic_point_guides` with two arguments are wrong on both counts.

**Cost.** 4,012 gateway calls, **$37.80** at list prices, about $1.45 per unit against roughly $10 in the
pilot — the Haiku veto is 1,169 calls for $2.55 where GPT-6 Sol's pass alone is $21.99.

**Open for the Product Owner.** Calculus BC units 1-3 are not loaded: BC and AB units 1-3 share one CED and an
identical 32-topic taxonomy set (measured, zero difference either way), so a re-key of AB's checked rows would
produce the same content at no model cost, but the protocol describes no re-key path — the SQL is generated and
unapplied. 45 escalations are open, falling into three patterns (modality and hedging, over-generalised reuse
tags, missing qualifying caution) and best ruled by pattern.

**Not done.** No Production change, migration, schema change, Lovable build or frontend publish. Record:
`docs/handoffs/REFERENCE_PACKS_UNITS_1_3_ALL_SUBJECTS_2026_10_10.md`; per-batch READMEs under
`scripts/content-seed/ap-*-reference-*-2026-10-10/`.

## Reference Pack Build Protocol + Proposed Shared Question-Page Template Documented — 2026-10-09

**Direction:** David asked to document the protocol for building the Reference Pack (equations,
vocabulary, and memory hooks), document the question-page template changes, write a thorough activity
log, and close the session.

**Durable record added:**
`docs/product/AP_CHEMISTRY_CED_SCOPE_INVENTORY_2026_10_09.md` now contains a seven-part
**Reference Pack build protocol** directly above the 91-topic inventory. The repo index now identifies
the file as both the AP Chemistry scope map and the pack-building protocol. A full closeout is in
`docs/handoffs/REFERENCE_PACK_AND_QUESTION_PAGE_SESSION_CLOSE_2026_10_09.md`.

### How Reference Packs are made

The protocol makes the CED PDF authoritative and uses the AP Chemistry fact pack only as an indexed
aid, the 91-topic inventory as the completeness/boundary checklist, and current taxonomy rows as valid
keys. Work is one unit per batch. Unit 4's 22 already-checked Production entries are reused rather than
regenerated.

Inventory phrases are not cards. They are consolidated into one-entry/one-lookup-need candidates.
Synonyms and inseparable ideas combine; ideas with different meanings, conditions, or uses split. Each
entry is owned by the first topic that requires it, and later `topic_codes` are added only when those
topics' own CED objectives or essential knowledge use the entry. The candidate manifest carries stable
identity, kind, student content, use/non-use boundary, CED page and LO/EK evidence, provenance, equation
metadata, and hook linkage/no-hook disposition.

**Vocabulary:** use CED meaning and exam-safe language, define the useful distinction, include the
condition that prevents the predictable misconception, and put classroom-shorthand warnings in
`caution`.

**Equations and relationships:** include the accepted name, correct LaTeX, every symbol, units and
constraints, sign/temperature/standard-state conditions, what evidence calls for the relationship, and
when not to use it. Do not turn a proportional or qualitative relationship into a false equality.
Equation-sheet availability is recorded metadata, not an inclusion/exclusion rule.

**Memory hooks:** attach to exactly one accepted reference entry, inherit its topic scope, and expand
completely and in the right order. Use public-domain-common or Cramapple-authored phrasing with recorded
provenance; no publisher-specific novel wording, songs, lyrics, or audio. A hook is recall language, not
the exam answer, so it carries a caution when translation into CED language is required. “No hook” is
expected and must not be treated as missing work.

The checking workflow is generate-and-select, not hand repair:

1. Extract candidates from the unit's CED pages plus fact-pack section.
2. Create and CED-verify six planted defects: wrong formula/definition, excluded or non-CED content,
   wrong owner, wrong list/order, wrong hook expansion, and another-unit content.
3. Run two independent checker families against factual accuracy, CED inclusion, topic ownership/reuse,
   conditions/cautions, and evidence. Hooks are checked separately for expansion/order, linkage,
   admissibility, and provenance.
4. Run an extractor-family reject-only audit. It cannot rewrite content or rescue a checker rejection;
   rejecting a hook does not reject the linked entry.
5. Re-sample a flag once; only a repeated flag counts. Both checkers must accept and the audit must not
   repeatedly veto. All six controls must be rejected.
6. Re-extract rejected rows statelessly in Round 2 without checker reasons and without hand edits.
7. Escalate persistent disagreement to the Product Owner with the CED evidence and all reasons. Resolve
   against evidence; do not ask models to debate until they agree.

The documented 2026-10-09 roster remains Claude Sonnet 5.5 for extraction, Gemini 3.5 Flash and GPT-6
Sol as the independent checkers, and Claude Haiku 5.5 as the own-family reject-only audit. A changed
roster needs the protocol smoke test and batch-level Product Owner ratification.

A pack is complete only when every inventory phrase has an accepted/consolidated/excluded disposition,
ownership and reuse validate, duplicates are resolved, no-hook outcomes and all verdicts are retained,
controls pass, and the pack is compared back to every topic row and boundary. Generated SQL loads first
to Development; the zero-orphan/owner/linkage/view/RPC QA and populated/hook/unit/empty probes must pass.
Production remains a named approval plus same-SQL load and repeated QA. Hooks retire before their
entries.

### Lesson Notes versus a question page

The complete accepted pack belongs in Lesson Notes. A question page is only a relevance projection:
maximum three vocabulary terms, relevant equations/visuals, and at most one directly relevant memory
hook. Empty sections are omitted. The presentation limit never removes CED-required content from the
full Notes pack.

### Proposed question-page template

The compact shell is intended to be shared by Worked Example MCQ/FRQ, graded Practice MCQ/FRQ, and
BYOQ without sharing their grading behavior.

- **Orange bar:** Return to student hub, Change topic, and subject selector.
- **Lesson strip:** subject/unit/topic breadcrumb, lesson title/subtitle, mode label, and plain
  `current/total` only (example `2/5`). Remove `exam in __ days`, mastery summary, segmented progress,
  and `Save and stop` from the work page; leave the exam countdown on the Student Hub and preserve
  attempt persistence.
- **Left:** Worked Example choices/rationales or FRQ rubric plus what earns points/common point loss;
  Practice shows no answer truth before submission and only authorized feedback after; BYOQ shows
  ungraded topic guidance with no score/correctness/canonical-answer claim.
- **Center:** stimulus, question, response/worked response, and primary actions. Worked Example remains
  illustrative, Practice scored, BYOQ read-only support.
- **Right:** Skills; up to three vocabulary terms; relevant equations/graphs/diagrams/visuals; one
  Memory Hook; one Full Lesson Note link. Omit empty or placeholder sections.
- **BYOQ:** before both unit and topic confirmation, show a confirmation state and no guessed content.
  After both are confirmed, use `fetchTopicGuides` or the current equivalent to populate both support
  panes. Never call grading, expose `is_correct`, or fabricate missing content.
- **Responsive/accessibility:** desktop left/center/right; narrow screens center then left then right;
  wrapped navigation, semantic accordions, visible focus, and no color-only state.

### Verification and boundaries

The local 1440×900 @2x rendering was regenerated and visually checked: the top lesson strip now shows
the mode plus `2/5` only. The Lovable implementation prompt was prepared locally but **not sent**; the
question page was **not built in Preview or Production**. No model content run, database change, RPC
change, deployment, or Production action occurred. The local `output/` rendering/prompt are convenience
artifacts, not durable source of truth.

**Open:** deterministic relevance selection for the three vocabulary terms and one hook; MCQ, Practice,
BYOQ, mobile, and accessibility implementation/QA; existing Full Lesson Note destination; formula
rendering; AP Chemistry units outside the checked Unit 4 pilot.

**Next owner:** David Bloom or the next Lovable implementation session. **Next action:** review the
session-close handoff, send the documented shared-shell implementation to Lovable Preview, wait for its
commit/tests, and inspect the diff. Do not change backend/scoring contracts, remove the Student Hub exam
countdown, build the Notes page, publish Production, or touch unrelated dirty-tree files.

## Session Close: FRQ Coverage Audit, Topic Labels and FRQ Gap Fill, Units 1-3 — 2026-10-10

**Context:** David: "document using the end of session protocol and end the session."

**Recorded:** `docs/handoffs/SESSION_CLOSE_2026_10_10_FRQ_GAP_FILL_UNITS_1_3.md` (the ten close-out points, handoff packet, lessons, restart prompt); `docs/INDEX.md` pointer.

**State:** 126 FRQs live in Production (APPROVAL-0146) and Development; 0 of 271 Units 1-3 topics without an FRQ; 183 FRQ topic cells (APPROVAL-0143). PR #396 merged; **PR #400 open** (scripts, so David merges). **Open:** 202 topics with one FRQ; Units 4+; Development schema lag.

**Next Owner:** David Bloom. **Next Action:** merge PR #400; decide whether to fill the second FRQ for the 202 single-FRQ topics.

## FRQ Gap Fill, Units 1-3: 126 FRQs Published to Production and Development — 2026-10-10

**Context:** David asked for FRQ generation with existing FRQs as seeds, then: every Unit 1-3 topic needs FRQs (scope cut to one FRQ per topic with none; "Do not make FRQs if there is even a single FRQ in the topic"). After the paid-author run cost $47.09 for 20 accepted FRQs, he directed: "Don't use Opus as primary author - that is your job" and "Where there are edge cases, you should arbitrate and correct ambiguities." Later: "add FRQ content to dev" (content-only load chosen), "publish to dev as well", and Production publish approved (`APPROVAL-0146`).

**What was done:** 104 FRQs written in session (eight parallel sub-sessions with self-contained briefs built from the official CED PDFs in `subject packs/` and the unit-scoped fact packs), plus the Product Owner's own Calculus AB 1.1 and 2.1 drafts rewritten to their CED topics. Every item went through lint, an exact recompute, the six-vote topic probe and two checkers (GPT-6.1 Sol, DeepSeek V4 Pro); planted-defect controls 8/8 before and after calibrating the rules to AP level. Three arbitration rounds by Claude: genuine rubric defects fixed (method prescribed, unasked justification scored, bundled points, missing givens), wrong checker claims rejected after recomputation, topic overlaps ruled from the CED text. Follow-through credit is used for Calculus and Physics only (documented in those fact packs). Model answers 126/126 full credit by a third family; Biology also 10/10 on the production grader after publish.

**Result:** Production 126/126 published and verified (text hash, primary topic cell, hash-fresh validated label, difficulty). 0 of 271 Units 1-3 topics now lack an FRQ (was 126); the live selector serves the new items. Development: 126/126 published as a content-only copy (packs created for 8 subjects it lacked; no labels or difficulty there). Spend after the change of method: $21.24 for 106 FRQs. Batch record: `scripts/content-seed/frq-u13-gap-fill-2026-10-09/README.md`.

**Open:** 202 Units 1-3 topics have exactly one FRQ (the original two-per-topic goal is not met); Units 4+ untouched; Development's schema still lags Production (no difficulty, validation-decision tables or label hash function).

**Next Owner:** David Bloom. **Next Action:** merge the PR; decide whether to fill the second FRQ for the 202 single-FRQ topics with the same in-session method.

## TASK-0069 Hand-Drawn Responses in Production, Dark for Students (APPROVAL-0144) — 2026-10-10

**Context:** David merged PR #397 and said "run the production runbook". `APPROVAL-0144` was recorded and pushed before the first Production write.

**Done:** runbook steps 1–5 on Production `pcntajvbdfqhbeewmdry`. Seven migrations applied verbatim from the repository (CLI from a worktree temporarily linked to Production) and recorded at the repository versions, so the ledger matches the filenames. The pre-apply capture caught that `20261009230918` had dropped the "rows are never deleted" branch of the attachment guard; the file was corrected, `20261010031448` repairs Development and joins the set. Four functions deployed and verified byte-identical. Secrets set; `FRQ_PHOTO_SUBJECTS` left unset (admins only). Lovable App published (`e8c11dce`), live bundle verified. Rollback-only integration test on Production: 8/8, nothing persisted.

**Exceptions:** (1) a ~3-minute window between migration 1 and the serving deploy during which the old serving function could have handed hand-drawn items to students; checked: no attempts, no student sessions. (2) The Production API smoke did not run: no Production secret key is available to the session (masked by the CLI; reading the legacy key was refused by the permission guard). (3) The publish also carried two earlier preview edits (David's BYOQ navigation request; a privacy-policy markdown line that the app does not serve, since `/privacy` redirects to marketing).

**Correction:** earlier TASK-0069 records said 1,090 published FRQs and 40 hand-drawn items; those counted item versions. Production: 619 published FRQ items, 37 published hand-drawn items (52 all statuses). The plan, task record, and remediation record are corrected.

**Next Owner:** David Bloom. **Next Action:** step 6, the live admin run on `app.cramapple.com`; then step 7 (widen `FRQ_PHOTO_SUBJECTS`) at his call; then the Done decision.

## AP Chemistry Unit 1 Reference Pack to Production (APPROVAL-0147) — 2026-10-10

**Context:** David: "Move all changes to production." The question-experience backend and frontend were already live (APPROVAL-0145 + 2 amendments; PR #399 merged). The only Dev-only change left was the AP Chemistry Unit 1 reference batch.

**Done:** loaded `load_ap_chemistry_u1.sql` (md5 `6c28a760…`) to Production. QA checks 1–8 ok. `get_topic_point_guides` probes matched Development exactly. Signed-out BYOQ on 1.5 serves 8 entries + the diagonal-rule hook. The Development seed rows from the question-experience probes stay Development-only by design.

**Next Owner:** David Bloom. **Next Action:** decide the two Chemistry Unit 1 escalations (1.8 recommend reject, 1.7 recommend accept); choose the next AP Chemistry unit to build.

## Question Experience Backend to Production (APPROVAL-0145); Chem U1 Reference Batch (Dev); Question-Page Shell (Preview) — 2026-10-10

**Context:** David: "Start a session focused on the new question page design and adding the content from this document into the app: AP_CHEMISTRY_CED_SCOPE_INVENTORY_2026_10_09.md"; then the backend brief for the revised question experience; then "I approve the migration plus the byoq change for Production. send a single combined prompt".

**AP Chemistry Unit 1 (Development only):** batch `scripts/content-seed/task0067-chem-u1-2026-10-09/` — 26 extracted, 22 + 2 (round 2) accepted, **24 entries + 1 hook loaded to Dev**, controls 6/6, QA 8/8 ok. Haiku 5.5 veto smoke-tested and used for the first time. Two Product Owner escalations recorded in the batch README (1.8 "bond likelihood": recommend reject; 1.7 "tools for periodic trends": recommend accept, 1.7 owner). Production not loaded.

**Question experience backend (Production, APPROVAL-0145):** migration `20261010040000` (`app.learning_session_items`, `app.content_item_comparison_answers`, `public.get_question_experience`) built, seeded and probed on Dev, then applied to Production with read-only probes; `byoq` v15 (`3a55ec87`) returns topic `reference[]`/`memoryHooks[]` to signed-out BYOQ visitors. Contract and evidence: `docs/handoffs/QUESTION_EXPERIENCE_BACKEND_HANDBACK_2026_10_10.md`, `docs/qa/evidence/question_experience_2026_10_10/`.

**Frontend (Lovable App `56cae479`, Preview only):** shared question-page shell at `84f287f0` (854/854 tests). An independent diff review found the BYOQ signed-out gap (fixed in the backend above) and out-of-scope changes; one combined follow-up prompt is queued after David's own unified-route rebuild in the same project. Not published.

**Hazard found:** the Supabase CLI run from `/Users/davidbloom` is linked to **Production** (`/Users/davidbloom/supabase/.temp/project-ref`). Dev work must pin `--workdir` to the repository; nothing was written to Production by accident.

**Next Owner:** David Bloom. **Next Action:** review the Lovable Preview after the combined prompt; decide the two Chem U1 escalations; approve the `student-session-items` → `append_learning_session_items` wiring so `counter`/`resume` populate for real sessions.

## TASK-0069 Codex QA Fail Remediated — 2026-10-10

**Context:** David: "Codex qa report added to PR397". Codex recommended Fail / Blocked (`docs/qa/QA_TASK0069_CODEX_2026_10_09.md`).

**Verified and fixed (Development only):** P1-a confirmation not bound to the answer text — confirmation is now `app.confirm_response_transcript` storing a server-computed content digest; P1-b retake/submit TOCTOU — the rule is now `app.response_versions_guard_submission`, a trigger on the `is_submitted` transition inside `app.submit_response`'s locked transaction (this also covers the separate `submit-response` function, which had bypassed the Edge gate); P2-a `photo_required` typed bypass — refused in the database and by `evaluate-attempt`, withheld from serving where photo is off via the new server-side `FRQ_PHOTO_SUBJECTS` knob, and the Lovable screen renders no typed path for such items; P2-b redaction — lookup errors fail, stamping requires verified removal, retries resume; P3 — integration test, two-connection race test, smoke additions, unit tests. Evidence and the re-QA prompt: `docs/qa/QA_TASK0069_REMEDIATION_2026_10_09.md`. Lovable App `e8c11dce` (unpublished). Production unchanged; PR #397 unmerged.

**Next Owner:** Codex (re-QA), then David Bloom (merge = Production go-ahead). **Next Action:** Codex re-QA.

## TASK-0069 Built: Hand-Drawn Responses on Every FRQ — Development Verified, Frontend in Preview, Review Findings Fixed — 2026-10-09

**Context:** David: "once documents are complete, execute the build including Lovable front end work, and move hand drawn responses to production as a PR. I will review and merge the PR." Then: "Write a handoff document for codex which explains this work and gives qa prompt."

**Built (backend, branch `claude/hand-drawn-frq-build-2026-10-09`):** `app.content_items.response_policy` backfilled for all 1,090 published FRQs (40 hand-drawn → `photo_required`), insert default and publish-gate enforcement; `app.frq_criteria.judgement_kind`; `select_student_practice_items` returns `response_policy` and serves hand-drawn items; `_shared/drawn-response-extraction.ts` (closed schema, no answer-bearing field) and `_shared/response-transcript.ts`; `attempt-response` ops `propose_transcript`, `confirm_transcript`, `redact_attachment`, a digest-tied submit gate, extended `get_manual_grading_context`; `SAME_DEVICE` access path (phone-declared path now wins); retention by redaction (`redacted_at`, `redact_response_attachment()`, `response_attachments_due_for_redaction()`); `app.merge_response_parts()` and a reserved-keys trigger on `response_versions`. Five migrations and three functions on Development; `scripts/frq_photo_smoke.mjs` passes every check (serving is Production-only). Deno 587/587.

**Built (frontend, Lovable App `56cae479`, preview only, not published):** capture on the Practice FRQ screen (QR on desktop, same-device camera on phones), the "Is this your answer? … Anything we missed?" review (DECISION-0110), pending-review state with the reviewer's marks on arrival, consent copy, admin queue and RLS-safe grading page with redaction, PostHog events, flag default `none` (admins and `?photo=on` only). Commits `42c5028e`, `700965bd`; 834 vitest, `tsc`, `vite build` clean.

**Review:** a fresh-context agent reviewed the backend diff: stale confirmation after a retake (H1), propose/confirm overwrite race (H2), trigger search_path (M1), owner-writable reserved keys through the exposed `app` schema (M2), idempotency replay not actor-scoped (M3), redaction stamped without verified removal (M4), error mapping and constraint-name assumptions (L1, L3). All fixed and re-verified by the extended smoke (forged confirmation refused; retake re-closes the gate). L2 (per-student cap overshoot of a few cents under concurrency) accepted.

**Records:** `docs/tasks/TASK-0069-HAND-DRAWN-RESPONSES-EVERY-FRQ.md`, `docs/handoffs/TASK0069_FRQ_PHOTO_EXECUTION_2026_10_09.md` (status log, evidence, Production runbook, rollback), `docs/handoffs/FRQ_PHOTO_FRONTEND_PROMPT_2026_10_09.md`, `docs/handoffs/HANDOFF_TASK0069_CODEX_QA_2026_10_09.md`. Plan decisions D3, D5–D8 built at the plan's defaults and listed as assumptions. Nothing in Production changed.

**Next Owner:** David Bloom (merge of the build PR is the Production go-ahead) and Codex (independent QA). **Next Action:** Codex runs the QA brief; after merge, the Production runbook (five migrations, two secrets, three deploys, Production smoke, dark publish, live admin run, then widen the subject list).

## Hand-Drawn Responses on Every FRQ: Session Opened, Stranded Frontend Found, Plan Drafted, Three Decisions Approved — 2026-10-09

**Context:** David: "Start a cramapple session focused on hand drawn response deployment", then "create a plan for bringing Hand Drawn Responses to all FRQs and any FRQs we create in the future, including the workflow, image management, grading and storage", then approvals of D1, D4, and D2 with a condition.

**Found (verified against Production `pcntajvbdfqhbeewmdry` and Lovable App `56cae479`):**
- TASK-0038 Phases 1–4 are complete on the backend (selector, `hand_drawn_pilot` mode, `list_manual_grading_queue`/`get_manual_grading_context`, admin `sign_download`), and `APBIO-HDG-2026-GRAPH-002` is `human_graded_pilot_approved`. The matching frontend (`/session-hand-drawn-pilot`, grading queue, RLS-safe per-attempt page, `handDrawnPilot` serve branch, consent notice) exists only in `exam-buddy-wireframe` commits `e16c72d`/`d50a403`/`677728c` (2026-09-23) and was **never ported to the live Lovable App**. The App still carries the old single-attempt admin page that reads `attempts`/`response_attachments` directly, the read Phase 4 found blocked by owner-only RLS. `DECISION-0059` Stage 1 therefore cannot run until the port is done.
- Live counts: `response_attachments` 0, manual-review `grading_results` 0, attempts on the pilot item 0, `capture_pairing_tokens` 1 (David, 2026-08-21). 1,090 published FRQs, 40 hand-drawn-flagged; the Practice FRQ screen (`/practice-frq`) has no photo affordance.
- `docs/INDEX.md` has no hand-drawn topic row.

**Written:** `docs/product/HAND_DRAWN_RESPONSES_ALL_FRQS_PLAN_2026_10_09.md` — every FRQ (current and future) accepts a photographed answer; the model proposes a per-part transcript, the student confirms or completes it, the existing text grader scores the confirmed transcript; plotted values and scales become deterministic checks; image-judgeable criteria go to the human queue until Engine 4 gates pass per cell; `response_policy` is written on every FRQ by backfill and by the generation pipeline, enforced at publish; images are validated, metadata-stripped, quality-checked, bound immutably, and redacted (not deleted) on retention rules; phases 0–4 with gates; decisions D1–D8.

**Decided:** David approved D1 (same-device capture on phones, `DECISION-0109`), D2 with the condition that the confirmation screen prompts the student to confirm or add missing content so Cramapple can help (`DECISION-0110`), and D4 (retention by redaction, `DECISION-0111`); recorded as `APPROVAL-0142`. D3, D5–D8 remain open; no build, deployment, or publish is approved.

**Branch:** `claude/hand-drawn-deployment-2026-10-09` (worktree; the main checkout holds another session's uncommitted files and was not touched). Memory note written for the stranded-frontend finding.

**Next Owner:** David Bloom. **Next Action:** answer D3, D5–D8; authorize Phase 0 (port the five frontend pieces to the Lovable App, publish, run `DECISION-0059` Stage 1); then open the Hard-Gate task for Phase 1.

## FRQ Units 1-3 Topic Coverage Audit and Topic Cells Written to Production — 2026-10-09

**Context:** David asked for an FRQ generation session (concept generation protocol, existing FRQs as seeds), then: "Before you start writing FRQs audit the subjects to determine which Subject/Unit/Topics do not have FRQs", "We have a question labeling protocol. Find it and use it. Do only units 1-3 for every subject and then stop", and, after the report, "Write the labels to the database."

**Audit (read-only):** 572 published FRQs in Production. 233 already had a topic cell (Calculus AB, Statistics, Biology, 11 Chemistry); the other 339 had none in any subject's Units 1-3 terms. Those 339 were labelled with the Units 1-3 runbook topic probe, unchanged (`subject_label_probe.mjs --mode=serving`; gemini-3.8-flash, deepseek-v4-pro, gpt-6.1-sol, 2 samples each; accept at 5 of 6; $8.26, 0 failed calls). Six items below 5 of 6 that could change a missing-topic result were read against the CED topic text. Result: **126 of 271 Unit 1-3 topics have no published FRQ**; worst gaps AP Chemistry Unit 1 (8 of 8), AP Precalculus Unit 3 (11 of 15), AP Statistics Unit 3 (11 of 15). Report: `docs/qa/FRQ_UNITS_1_3_TOPIC_COVERAGE_AUDIT_2026_10_09.md`.

**Production write (`APPROVAL-0143`):** 181 `validated` primary topic-only cells in `app.content_item_cells` (154 at 6/6, 21 at 5/6, 6 `ced_text_tiebreak`), one per published FRQ version whose topic is in Units 1-3. Rehearsed on Production (rolled back), committed in one transaction, verified by `md5(content_key:topic_code)` = plan `189c15736205f01f633f003fedca9f09`, and re-read independently: 181/181 on published versions and in `content_item_topic_resolution`. Two items were first held (probe topic in Unit 3, serving label says Unit 2), then resolved the same day from the official course and exam description PDFs in `subject packs/` at David's direction and written (APPROVAL-0143 amendment): `apcalcbc-frq-u13-015` → 3.6, `apprecalc-frq-np2-004` → 3.10. **Total: 183 cells.** Their serving labels still say primary unit 2 (required units already include 3); left open. Script: `scripts/content-seed/frq-topic-labels-u13-2026-10-09/write_topic_cells.py`.

**Not done:** probe results for FRQs in Units 4+ (158 FRQs) were not written, per the Units 1-3 instruction; no serving labels or skills changed; no FRQs authored. The two held items do not change coverage: Calculus BC 3.6 and Precalculus 3.10 each have other FRQs with written cells.

**Next Owner:** David Bloom. **Next Action:** merge the PR; correct the two serving labels' primary unit (2 → 3) if wanted; then the FRQ generation run on the missing topics.

## Session Close: TASK-0068 BYOQ Photo Extraction — 2026-10-09

**Context:** David: "document according to end of session protocol with extra attention on how BYOQ can be leveraged by the hand drawn response system. Then end the session."

**Recorded:** `docs/handoffs/SESSION_CLOSE_2026_10_09_TASK0068_BYOQ_PHOTO_EXTRACTION.md` (what happened, where things are, open items, and eight concrete ways the hand-drawn response path can reuse BYOQ: student-confirmed transcript before grading, the extraction module as a drawn-response reader template, the benchmark harness with synthetic drawn fixtures, capability-scoped phone review, re-read-then-fill semantics, spend accounting, same-device QA technique, and what not to carry over). `docs/INDEX.md` row; `TASK-0068` points at the close record.

**State:** BYOQ photo extraction is live in Production for all students (`APPROVAL-0141`); PR #393 merged (`21836c4f`). **Open:** the Done decision (Sol's sign-off withheld on topic ranking and S9 expiry checks), SOL-08 hint copy (needs a `HintGate` copy prop), Sol's eight test questions kept until the 30-day purge. **Next owner:** David. **Next action:** decide the topic-accuracy gate (amend or invest) and the Done decision; optionally open the drawn-response transcript task sketched in the close record.

## TASK-0068 BYOQ Photo Extraction Built, QA'd and Deployed to Production — 2026-10-09

**Context:** David: "finish executing the plan and moving the new capabilities to production for use by students." Recorded as `APPROVAL-0141` (Gates B–D).

**Built:** see `docs/handoffs/TASK0068_BYOQ_PHOTO_EXTRACTION_EXECUTION_2026_10_09.md` §1 (backend), §3 (benchmark), §4 (Lovable frontend, commit `ea999aad`). Independent backend QA (`docs/qa/QA_TASK0068_BACKEND_2026_10_09.md`): round 1 Fail — a write race that could overwrite a mid-call student edit and clear a live leak flag, the raw proposal and `captured_work` readable by a signed-in owner over PostgREST, and unmetered retries plus no per-owner run cap; all fixed (re-read-then-fill, explicit column grants, fresh reservation per call, 40 runs per owner per day, fail closed without the shared cap) and round 2 Pass.

**Deployed:** migrations and the function to Development and Production; `BYOQ_EXTRACT_MODEL=gpt-4.1-mini` in both; Development's invalid OpenAI key reset; Lovable App published. Smokes on Production: extraction 27/27, TASK-0039 regression 24/24.

**Open:** Sol's browser QA (`docs/qa/QA_TASK0068_SOL_BROWSER_SCRIPT_2026_10_09.md`); benchmark topic top-3 86.5–88.8% vs the 90% gate (Statistics and Calculus weakest; topic is optional and editable); PR #393 merge; the Done decision. **Next owner:** Sol (browser QA), then David. **Next action:** run the Sol script against `app.cramapple.com/byoq`; merge PR #393.

## Unit Reference Content + Memory Hooks Moved to Production — 2026-10-09

**Direction:** David: "let's move it all to production." Recorded as `APPROVAL-0140` (all three Hard Gates).

**Done, in order:**
1. Pre-check on Production: no new tables; `get_topic_point_guides` md5 unchanged (`dfa85170…`); `app.set_updated_at()` present; both pilot subjects active.
2. CLI temporarily linked to Production; migration file applied with `supabase db query --linked -f` (begin/commit stripped), ledger row inserted under `20261009003237` with the full statement text (20,662 chars). Post-check: tables, views, RLS forced, no anon grants, triggers; RPC md5 `a76f2f71…` equal to Development; both guard functions and both views md5-equal to Development.
3. Rows loaded from `out/load_ap_statistics_u1.sql` and `out/load_ap_chemistry_u4.sql`: 102 entries, 3 hooks. Data QA all green; read-only RPC probes as expected (Stats 1.6: 9 entries + SOCS; Chem 4.9: 4 entries + OIL RIG; Biology: empty arrays, briefs unchanged).
4. CLI relinked to Development. PR #390 found already merged by David (`431cb9b8`).
5. Lovable `deploy_project` on `56cae479` at `71a9b751` (deployment `fb797370…`, status `pending` at call time; a second call returned the same published URL). **Not independently verified over HTTP:** every route on `app.cramapple.com` and the `lovable.app` host redirects anonymous requests (302 to the marketing site), and the preview host returns 401, so no asset of the new build could be fetched without a student session. The Product Owner's look at the live app is the confirming step.
6. Development's SOCS entry provenance aligned with Production's (the override marker had been added after Development's first load).

**Not done:** no visual check as a signed-in student; the Product Owner should look at Stats 1.6/1.7 and Chem 4.9 in the live app.

## TASK-0067/0066 Phase C Built in Lovable Preview — 2026-10-09

**Built (Lovable `56cae479`, commit `71a9b751`, "Added reference content & hooks", preview only):** nine files; details in `TASK-0067` §Phase C. Reviewed by diff: mapping tolerant of camel/snake and absent keys; `reference.rememberIt`/`lookUp` only present when content exists, so older payloads keep their exact shape; new vitest file with a baseline fixture asserting unchanged output for brief/explainer-only input. The agent ran the suite on request: 83 files, 770 passed, 0 failed; `tsgo --noEmit` clean.

**Not verified visually with data:** the app reads Production, which has neither the tables nor the RPC keys until the migration's Hard-Gate apply. The absent-key path is what the preview exercises today.

**Numbering:** DECISION-0106 renumbered to DECISION-0107 across this branch and the Development provenance rows; open PR #391 had reserved 0106.

**Next owner:** David Bloom. **Next action:** approve or defer the three Hard Gates (Production migration, Production publish of 102 + 3 rows, Lovable publish). PR #390 carries the migration and the batch; it is David's to merge.

## DECISION-0107 Recorded; Phase C Sent to Lovable Preview — 2026-10-09

**Decisions (David):** SOCS loaded (CED names it; CED wins over the veto's order objection); 1.13 confirmed as owner of the escalated entry; veto moves to Haiku 5.5 (GPT-6 Sol cannot be the veto while Sonnet extracts, because the veto is the own-family audit). Loader gained `--po-accept`, which records each override in the row's `source_note`. Development: **102 entries, 3 hooks**.

**Phase C:** the Lovable app (`56cae479`) reads Production, where the two RPC keys do not exist yet, so the brief requires every surface to render exactly today's output when `reference`/`memoryHooks` are absent, with a test for it. Scope sent: `topic-content.ts` types and mapping; `presentation.ts` (vocabulary from entries, `rememberIt`, `lookUp`, "Remember it" summary, "Formulas and rules" / "Lists and sequences" full sections, "Unit N reference" from a unit-level call); `deep-dive-export.ts`; `ReferencePane.jsx`; the Learn More route; a vitest file on a fixture taken from the Development payload. Preview only; no publish; no `.env` change. The tool call timed out waiting, but the project shows the agent running.

**Verification plan:** read the diff by commit SHA; run the tests; the preview cannot show real rows until the Production migration is applied (separate Hard Gate), so visual verification with data waits on that approval.

## TASK-0067 + TASK-0066 Phase A and B Done in Development — 2026-10-09

**Context:** David: "Go ahead and start the implementation branch." Branch `claude/task-0067-0066-phase-a`.

**Phase A (schema, Development):** one migration, two tables (`app.unit_reference_entries`, `app.topic_memory_hooks` with a required `reference_entry_id`), RLS forced, publish guards, two `security_invoker` views in the same migration, `public.get_topic_point_guides` returns `reference[]` and `memoryHooks[]` with every existing key unchanged (Dev and Prod definitions were md5-identical before the change). Keyed as `topic_explainers` because `TASK-0054`'s FK has not landed. Applied through the MCP; file renamed to the recorded version `20261009003237`. QA script added; 6/6 checks; guard triggers exercised and rolled back.

**Phase B (pilot content, Development):** `scripts/content-seed/task0067-reference-pilot-2026-10-09/`. Extraction from the CED PDF pages (pdftotext) plus the fact-pack section by Claude Sonnet 5.5; checkers Gemini 3.5 Flash and GPT-6 Sol (picked by the session from the live roster, pending David's ratification); reject-only veto Claude Opus 5.5; smoke 12/12. Loaded: **79 Statistics Unit 1 entries, 22 Chemistry Unit 4 entries, 2 hooks** via `supabase db query --linked -f` (no retyping). Verified independently after load (counts, orphans, units, views, RPC probes).

**Found on the way:**
- One of my Chemistry controls was wrong (CED 4.5 does name the ideal gas law); batch voided, control replaced with Hess's law, controls re-run 6/6. Checkers were right.
- A checker-aggregation bug let a rejected hook reject its entry; fixed, every verdict recomputed from stored samples, one entry changed.
- The Statistics CED names SOCS itself; both checkers accepted it; the veto rejected it twice on an entry-order mismatch. Not loaded under the no-hand-edit rule; for David.
- One escalation (Statistics 1.13 scope of conclusions: owner 1.10 vs 1.13); for David.
- 11 of 14 round-1 Statistics rejections were over-tagged `topic_codes`; a stateless round 2 cleared 12 of 13.
- Cost $20.29, 56% of it the Opus veto.

**Not done:** Production migration, Production publish, Phase C (Lovable surfaces). Each is its own Hard Gate / next step. The PR carries a migration, so it is David's to merge.

**Next owner:** David Bloom (ratify checkers; decide SOCS and the escalation; approve or defer the Production apply). **Next engineering action:** Phase C in Lovable preview (Deep Dive "Remember it" block, unit-reference list, Open Hand pane) reading `reference[]`/`memoryHooks[]` from the RPC on Development.

## BYOQ Photo Extraction Plan v2 Approved at Gate A; TASK-0068 Opened; TASK-0039 Closed — 2026-10-08

**Context:** David asked for a planning session on Codex's BYOQ attachment-extraction plan (PR #387) with the instruction "critique the plan, find weakness, ask questions, challenge assumptions. The goal is not to implement — it is to make a great plan."

**Checked, read-only:** the shipped `byoq_*` schema and `byoq` edge function; the Lovable App's BYOQ screens (`ByoqIntake`, `ByoqCapturePhone`, `ByoqPractice`, `shared`), which showed stems render as plain text with no formula renderer and that the phone leg holds only a pairing handle; `capture-pairing` already sends student photos to OpenAI with `store: false`; Production `app.byoq_*` counts (3 items, all internal, 2 photo-only, 0 responses) and published content counts (2,170 MCQ, 583 FRQ) as a rights-clean benchmark; the live privacy policy. Findings in `docs/product/BYOQ_ATTACHMENT_EXTRACTION_PLAN_CRITIQUE_2026_10_08.md`.

**Recorded:** `DECISION-0108` (the eleven answers plus the editability requirement), `APPROVAL-0139` (Gate A only), `TASK-0068` opened, `TASK-0039` → Done (Phases 1–2; Phase 3 superseded), v1 plan and `BYOQ_WORKSHEET_PARSING_DESIGN.md` annotated superseded, `docs/INDEX.md` row, one-pager D9 amended. Record numbers 0106/0107/0138 were already claimed by open PR #390, so this entry uses 0108/0139.

**Not done:** no migration, no extraction code, no Lovable message, no benchmark run. Gate B is a separate approval.

**Next owner:** Claude session. **Next action:** Slice 1 on a fresh implementation branch: render a stratified fixture set from published items, design the output schema and prompt, design the three capability-scoped review ops, then request Gate B with the migration and function diff.

## TASK-0067 Approved and Opened; TASK-0066 Unblocked with D3 Amended — 2026-10-08

**Context:** David: "Approve R1-R4 as recommended and open TASK-0067."

**Recorded:** `DECISION-0105` (R1 one shared Development migration; R2 hooks require `reference_entry_id`, own `topic_codes[]` dropped; R3 fact-pack extraction first, then v0.6 checks; R4 diagrams text-only until `TASK-0006` renders), `APPROVAL-0137` (scope only; Production apply, publish, and Lovable publish remain Hard Gates), `TASK-0067` → Approved, `TASK-0066` → unblocked with the D3 amendment written into its schema phase, `MASTER_TODO` register rows, `docs/INDEX.md` row.

**Not done:** no branch, migration, extraction run, or Lovable message.

**Next owner:** Claude session. **Next action:** open one implementation branch for `TASK-0067` + `TASK-0066` Phase A: read `TASK-0054`'s key state, draft the migration with both tables, the public views, and the `get_topic_point_guides` extension, apply to Development, then run the Stats Unit 1 / Chem Unit 4 fact-pack extraction with two checker families.

## TASK-0066 Blocked on Companion Content; TASK-0067 Drafted as Proposed — 2026-10-08

**Context:** David, after `DECISION-0104`: "Task 0066 only works if we have the formula, diagrams, lists, etc to accompany them."

**Checked, read-only:** no `formula`, vocabulary, glossary, or diagram table exists in `supabase/migrations`; the only `formula` column is on `app.provenance_claims`. Diagrams exist only as item-level `stimulus_image_path` prompt visuals; `TASK-0006` is Ready for Owner Review and `TASK-0021`'s Biology visuals are reviewer-visible, not student-delivered. The protocol scopes a unit reference for "shared formulas, vocabulary, representation guidance" and the 1.7 pilot page calls it "the next Phase 1 surface"; it is not built. The parsed 1.7 pilot packet already extracts `factPack.formulas` and `factPack.concepts` from the fact pack, which shows where a first extraction pass would come from. `CONTENT_AND_PEDAGOGY.md` names vocabulary as the third reference-pane section with nothing structured behind it.

**Conclusion:** David is right. As approved, `TASK-0066` would attach hooks to nothing.

**Recorded:** `docs/tasks/TASK-0067-UNIT-REFERENCE-CONTENT.md` (PROPOSED): `app.unit_reference_entries` with kinds formula / vocabulary / list_sequence / convention / diagram, owner topic plus `topic_codes[]`, fact-pack extraction first with v0.6 checks, diagrams text-only until `TASK-0006` renders them, same pilot units as the hooks. Proposed amendment to `TASK-0066` D3: hooks require a `reference_entry_id` and inherit scope from the entry. `TASK-0066` marked blocked; `MASTER_TODO` and `docs/INDEX.md` updated.

**Not done:** no approval claimed, no schema, no content. **Next owner:** David Bloom. **Next action:** answer `TASK-0067` R1–R4; on yes, one implementation session drafts both tables in a single Development migration.

## Memory Hooks Approved (DECISION-0104, APPROVAL-0136) and TASK-0066 Opened; Diagram Parts Added — 2026-10-08

**Context:** After PR #385 merged, David: "Approve D1-D7 as recommended and open the task. Micah was also interested in memory hooks for formulas and parts of diagrams. Why not include those?"

**Answered:** formulas were already in scope (the `acrostic` and `formula_sentence` kinds carry a formula's structure; the formula itself stays in the unit reference). Diagram parts had been left out for a rendering dependency, not on principle; a CED-required labelled diagram passes the inclusion rule. Added kind `diagram_parts` with a nullable `visual_asset_ref` to an existing visual-stimulus asset (`TASK-0006`), no new rendering path, text-only fallback.

**Recorded:** `DECISION-0104` (D1–D7 plus the amendment), `APPROVAL-0136` (scope approval; Production apply, publish, and Lovable publish remain Hard Gates), `docs/tasks/TASK-0066-MEMORY-HOOKS.md` (Phase A schema keyed to whatever `TASK-0054` settles, Phase B pilot authoring by generate-and-select with five checks, Phase C three surfaces in Lovable preview), proposal STATUS → APPROVED with §12, `docs/INDEX.md` row, `MASTER_TODO` register row.

**Not done:** no branch, migration, content, or Lovable message. **Next owner:** Claude session. **Next action:** start `TASK-0066` Phase A by reading `TASK-0054`'s state, then draft the migration in Development.

## Memory Hooks (Mnemonics / Acronyms / Phrases) Scoped as a Content Element — 2026-10-08

**Context:** David opened the session with Micah's idea: connect important formulas and lists to mnemonics, acronyms, songs, and phrases (example: "Kings Play Chess On Funny Glass Stools" for the Linnaean ranks).

**Found in the records before writing anything:**
- The idea already exists as the "memory aid" element of the skill-scaffold proposal in `COURSE_HOMEWORK_CONSOLIDATION_PLAN.md` §3, with its grain flagged OPEN by review and never resolved.
- One hook is already live in prose: the AP Chemistry 4.9 explainer's `practice_bridge` says "write OIL RIG in electron-placement form". It is not listable or QA-able as a hook.
- The AP Chemistry fact pack records that the CED states solubility in IMF-similarity language "rather than the mnemonic itself". A hook is for recall; the points come from CED language.
- The Deep Dive protocol's Unit reference is already scoped to hold shared formulas and vocabulary, and the Open Hand screen already renders a reference pane from the topic guide.
- **Micah's example is not in the AP Biology CED.** Topic 7.9 is cladograms and phylogenetic trees, not Linnaean ranks. That produced the proposal's inclusion rule: a hook is admissible only for a sequence, list, formula structure, or sign convention that a CED learning objective or scoring guideline requires.

**Wrote:** `docs/product/MEMORY_HOOKS_PROPOSAL_2026_10_08.md` (STATUS: PROPOSED). Topic-owned grain with `topic_codes[]` and unit roll-up, no skill grain; three student surfaces (Deep Dive "Remember it" block, unit-reference list, Open Hand pane), not hints; Option B table + public view + `get_topic_point_guides` extension recommended; songs excluded from v1 (no lyrics, no audio pipeline); authoring via the v0.6 generate-and-select method with a `source_note` rights value per row; a candidate inventory of eleven unvetted rows across seven subjects, one of them (KPCOFGS) explicitly excluded. Added a row to `docs/INDEX.md`.

**Not done:** no schema change, no content, no Lovable message, no approval. Seven Product Owner decisions (D1–D7) are listed in the proposal's §9.

**Dirty state noted, not mine:** this checkout carried an uncommitted 138-line addition to `docs/product/TOPIC_BRIEFS_AND_LEARN_MORE_PRODUCTION_PROTOCOL.md` (Sequential Unit Authoring, Phase 0, Phase 1 website pilot, row limits) plus untracked `AP_STATS_1_7_DEEP_DIVE_*` / `DEEP_DIVE_SIMPLE*` files from a separate Deep Dive session. Left untouched and uncommitted on this branch.

**Next owner:** David Bloom. **Next action:** answer D1–D7 in the proposal; if approved, open a Standard task for the Option B schema (sequenced after `TASK-0054`'s FK decision) and a content line item for the Stats Unit 1 + Chemistry Unit 4 pilot.

## Student Hub Slice 1 Built in Lovable Preview — 2026-10-08

**Context:** David answered the five Product Owner questions in the consolidated hub plan (`DECISION-0103`) and then: "Go ahead and implement slice 1 in Lovable." Slice 1 is truthfulness and route reliability: H1/N5, H3/N6, N1/H8, N2, H2 from `qa/QA_STUDENT_HUB_CONSOLIDATED_PLAN_2026_10_08.md`.

**What landed:** see `handoffs/STUDENT_HUB_SLICE1_EXECUTION_2026_10_08.md`. Lovable connector commit `a509b7d7` on baseline `926ac3fb`, Preview only: attempts and sessions reads scoped by `exam_pack_version_id`; unit-only saves send `topicCode: null`; save on change through one shared hook with a latest-wins gate and an inline Saving/Saved/retry line, Confirm buttons removed; Learn door with checking/available/unavailable/unknown states gated on the saved topic, honouring a `practice` resolver answer; "Studying: …" heading, unit-only Learn opens the first topic with an example and the plate says so, unit-only Notes lists the unit's topics with notes. 81 files / 755 tests, `tsgo` and build pass (agent report); Fable reviewed the diff.

**Published:** David instructed "Publish the Preview build to production"; deployment `10c9fc3b` requested ~15:27 UTC. The publish carries the whole Preview head, so PR #380 Lovable packages 1–3 went live with it. David confirmed the "Studying: …" heading live on `app.cramapple.com/home` ~16:20 UTC.

**Still open:** signed-in screenshots at desktop/390/320 (slice 2, David); Sol's independent re-QA of slice 1; slices 3–4.

**Next Owner:** David Bloom
**Next Required Action:** Run the slice 2 screenshot row on the live site; Sol re-QAs slice 1.

## Open Hand + Practice QA Findings Executed — 2026-10-08

**Context:** David asked for the findings of `qa/QA_OPEN_HAND_PRACTICE_TEMPLATES_2026_10_08.md` and the challenge review to be executed "to make the user experience as easy and helpful as possible." Decisions in-session: database changes to Development and Production without further check-in (`APPROVAL-0135`); Lovable built in Preview, David publishes; "Worked example" is the student-facing name everywhere; the practice selector fixed server-side.

**What landed:** see `handoffs/OPEN_HAND_PRACTICE_QA_EXECUTION_2026_10_08.md` for the full record. In short: TASK-0056b answer-key revoke applied in both environments (F10); new paged, answered-excluding practice selector and FRQ availability count (F2, A2, A3); `get_open_hand_item` revoked (F9); `student-session-items` redeployed; Lovable packages 1–3 covering stimulus rendering, mode-aware titles, paging, retired `/open-hand-frq`, attempt-integrity and the flow/copy findings.

**Still open:** topic resolution for FRQ packs and Calc AB Unit 1 MCQs (F1b, content pipeline); FRQ teaching pool (§2b); signed-in browser certification after David publishes.

**Next Owner:** David Bloom
**Next Required Action:** Publish the Lovable Preview build, then run §6 of the QA report on a screen.

## TASK-0065 Pipeline Cost Levers and Biology Unit 1 Seed Pilot — 2026-10-07

**Cost levers** (`scripts/content-seed/task0065-cost-levers-2026-10-07/RESULTS.md`):
- Meta Muse Spark replaced Kimi K3 as the fourth checker. In calibration it caught 9/9 known defects, flagged the same 2 of 24 clean items, and cost under half as much per audit.
- The unit-scoped fact pack is now the default.
- Same 24 topics: $0.28 → $0.20 per item, 24/24 accepted, controls 6/6, blind re-judge 0 defects.
- GPT and Gemini prompt caching is closed as a lever: the gateway reports no cached input for them.

**Seed pilot** (`scripts/content-seed/task0065-seed-pilot-bio-u1-2026-10-07/RESULTS.md`): Biology 1.1–1.7, three seeds per topic (each a different skill and target band) and three variants per seed, through generate-and-select with no hand edits. Nothing was written to any database.
- **Accepted:** 21/21 seeds and 61/63 variants. The 2 unfilled variant slots escalated after 4 rejected candidates each, as the protocol intends.
- **Quality:** the blind held-out panel (Mistral, GLM, MiniMax; 2 samples each) found 0 defects in 21 seeds and a 21-variant sample, and caught 4/4 planted defects. 15 single-judge disputes were adjudicated by Claude as non-defects; those adjudications are provisional and need human review.
- **Cost:** $25.73 ($0.31 per item), on the pre-lever config. About $0.22 per item expected on current defaults (estimate).
- **Labels:** seed practice matched its target 17/21 (exact sub-skill 14/21). Target band matched 10/21, and no item was ever voted Hard.

**Recommendations for David:**
- drop the band as an author target;
- have variants inherit the seed's validated skill instead of re-voting;
- target skills at the practice level.


## TASK-0065 Method Test Run: Legacy vs Generate-and-Select — 2026-10-07

**Design:** `docs/product/OPEN_HAND_CONTENT_METHOD_TEST_DESIGN_2026_10_06.md`. **Results:** `scripts/content-seed/task0065-method-test-2026-10-06/RESULTS.md`. David asked for units 1–3 in every subject.

**Run:**
- 24 topics.
- The legacy arm was re-run fresh to #340's spec and checker, timed: subagent authors, a two-model check, one fix session, a re-check.
- The pipeline arm ran unchanged, in two segments around a gateway credit outage. Candidates touched by the outage were discarded and regenerated.
- The 24 live Production items for the same topics were added as a third arm.
- Blind judging by Mistral Large 4, GLM-5.3 and MiniMax M3, two samples each, against CED PDF text: 900 calls, 0 failed, $4.32. MiMo was replaced after failing the schema in the smoke test.
- Four planted defects were caught on their intended measures. All numeric keys were recomputed.

**Results:**
- Defective items: legacy 4/24, pipeline 1/23, live 3/24. Every key was correct.
- Pipeline $0.77 per clean item vs legacy about $0.19, a ratio of 3.5–4.9×, which fails the proposed 3× rule.
- Speed: 13.7 min vs 10.3 min.
- p = 0.35 at n = 24.

**Scoring corrections, applied blind and uniformly, with the planted defects re-verified after each:**
- Q1 uses structured answers only.
- Q2 excludes a wrong choice's own text.
- Topic codes are parsed from the first number pair.

**Found:**
- Three live defective items (Stats 1.10, Stats 2.12, Bio 2.10).
- A Statistics 2.12 brief overreach into CED 4.1.
- My earlier env-loading one-liner echoed part of the AI Gateway key into tool output; David was told it may need rotating.

Nothing was written to any database. Production was read only.

## Biology 2.10 Brief Fixed and 3.3 Fact-Pack Gap Closed (APPROVAL-0127); Biology Teaching Items 20/21; Method Test Designed — 2026-10-06

**Checked against the CED PDF:**
- 2.10's point brief overreached: it asked for circular DNA and binary fission. It was fixed in Development and Production, with matching hashes and ledger rows in both.
- The Biology fact pack had dropped EK 3.3.A.2.ii (energy coupling). It was restored verbatim. The 3.3 brief was correct.

**Pipeline:** both topics were regenerated after the controls were re-run (6/6), and both were accepted in round 1. Biology units 1–3: 20 of 21 accepted. 1.5 awaits David's confirmation, because his premise ("taught previously") was inverted: 2.3 comes later. The 2.10 topic explainer still teaches the overreaching evidence; flagged, not changed.

**Review page:** https://claude.ai/artifact/CiBQWsfy6YHsJNfLaH45eh. Biology pilot cost: $20.13.

**Method test:** legacy patch loop vs generate-and-select, designed in `docs/product/OPEN_HAND_CONTENT_METHOD_TEST_DESIGN_2026_10_06.md`. It uses 24 topics, held-out judges from three other families working from the CED PDF text, planted defects, a numeric recompute and human review of disputes. Not run.

## Session Close (part 2): Live Purchase Test; Deep Dive + Pane Layout; 198 Stems Cleaned — 2026-10-07

**Approvals:** APPROVAL-0128. **PRs:** #351, #352, #357 (merged).
**Handoff:** `docs/handoffs/SESSION_CLOSE_2026_10_06B_PURCHASE_TEST_LAYOUT_STEM_CLEANUP.md`.

### Summary
- **Live purchase test (David):** an anonymous Safari purchase with Apple Pay and a coupon works. The diagnostic
  routes redirect to Home, and Home opens Open Hand with no duplicate rationales.
- **Lovable** (three edits, reviewed, not published):
  - Deep Dive restored to two bands, worked-example sections plus the full authored content.
  - Left pane holds Rubric and How-points; right pane holds Reference and Deep Dive.
  - Practice answer key restored after grading.
  - Red/blue tints on the answer rows, and review fixes.
- **Production (APPROVAL-0128):** 198 MCQ stems are cleaned of repeated choice lists. Labels were carried forward and
  servable stays at 148. Production records say APPROVAL-0127, renumbered in the log because of a collision.
- **Repo:** #351 reconciled (pipeline for Units 4+; Biology pilot items not to be loaded) and merged; #352 merged.

### Pending decisions
- Formula support: design and placement.
- The feedback model ("slip / check / habit" per distractor): authoring scope.
- Whether to replace the 95 older spare teaching items.

### Open risks / blockers
- The Lovable build is unpublished, so the regressed answer key and Deep Dive content are live until it is published.
- Polish issues are visible on Open Hand: an empty Vocabulary heading, a duplicate title, and explainer formatting.
- Biology Unit 1 practice is still thin.
- The import path can re-introduce inline choice lists, because the sync trigger misses identical copies.

### Next required action
- David publishes Lovable (latest edit `9ecbee88`) and checks Practice: the answer key under the buttons, the tints,
  and Deep Dive under Reference.

## Session Close: Open Hand Live — 91 Teaching Items in Production, Plate Loop for All Subjects Built — 2026-10-06

**Tasks:** TASK-0064, TASK-0065. **Approvals:** APPROVAL-0124, APPROVAL-0125. **PRs:** #340, #347, #349, #350 (all merged).
**Handoff:** `docs/handoffs/SESSION_CLOSE_2026_10_06_OPEN_HAND_LIVE.md`.

### Summary
- **Serving.** David deployed `student-session-items` with the teaching filter (Production v33, Development v21).
- **Database (Development and Production).** RLS on `content_item_versions` now hides active teaching items from student
  reads. This closes the legacy `/session` MCQ and `/session/mcq` client reads, which Fable had missed. The attempt
  trigger is re-enabled in Production.
- **attempt-response.** The 409 mapping for refused teaching-item attempts is merged but not deployed.
- **QA.** Fable re-checked the build. The three earlier blockers are fixed; Fable's new double-rationale finding is
  fixed and published.
- **Plate loop.** It went live for Statistics first (published). Then, at David's request, Lovable built a version
  with the loop on for every subject and every diagnostic/session entry retired. That build is **not yet published.**
- **Teaching items.** The outside checkers (Gemini 3.8 Flash, DeepSeek V4 Pro) ran on 91 Units 1–3 items. Every key
  was confirmed; 4 rationale errors were fixed; the 15 C3/lint-blocked items were rewritten.
- **Production load.** All 91 are loaded (Bio 21, Stats 29, Chem 21, Calc AB 20) and verified: content hashes match,
  Open Hand serves them, they are hidden from students, and scoring never serves them.

### Pending decisions
- Whether the Statistics skill rail should also move off `/session` into Practice (David).

### Open risks / blockers
- Biology Unit 1 Practice has only 4 items, all on topic 1.7. Chemistry U1 and Physics C Mechanics U1 are also thin.
- The live app has not had a human signed-in walkthrough.
- The `attempt-response` 409 is undeployed. Low risk: it is a backstop.
- Resume opens Practice at the start, not at the student's last topic.

### Next required action
- David publishes the Lovable all-subjects / no-diagnostic build (edit `edt-660b7fa5`) and does the signed-in check:
  a non-Statistics "Start" button opens a worked example or Practice, and `/session/setup` lands on Home.
- Then he deploys `attempt-response` via the CLI (Development, then Production).
## TASK-0065 Generate-and-Select Pipeline Built; Biology Pilot 18/21 Accepted, 3 Escalated — 2026-10-06

**Why:** David asked why repeatedly reviewed questions kept failing, and asked for a way to add questions without editing them, using at least 4 models and multiple sessions. Diagnosis: the rules were applied after writing (25 of the 38 C3 blocks), reviews checked other things, single model calls are noisy, patches need full re-checks, and two sessions worked to different specs. **Decision:** build the pipeline; regenerate the 38 C3-blocked topics; hold PR #348 (now a draft); discard the 13 unchecked rewrites.

**Built:** `scripts/vercel-gateway-check/teaching_pipeline/`.
- One rubric for authors and checkers, plus a deterministic lint.
- Stateless Claude Opus 5.5 and GPT-6.1 authors.
- Four non-author checker families: a blind solve, then a rubric audit with the CED fact pack and the unit's topic list.
- Re-sample on flag; own-family veto (can reject, never approve).
- Accept the first clean candidate or escalate.
- Six planted-defect controls gate every batch; per-topic claims for multiple sessions.

**Biology units 1–3:** controls 6/6 caught. 18 of 21 accepted (12 GPT-authored, 6 Claude), 3 escalated, 0 edited. About 600 calls, 0 failed, about 6.5M input tokens. Escalations: 2.10 and 3.3 have point briefs that require content the fact pack lacks; 1.5 overlaps 2.3. Not loaded to any database; human spot-check pending. Production was read only (point briefs).
## Orly Pooled Practice Sets: Clean-Room Drafts (AP Chemistry Units 1/3, AP Calculus AB 2.1) — 2026-10-06

**Source:** practice sets pooled by Orly and classmates: 20 AP Chemistry MCQs in a Google Doc and 4 AP Calculus AB MCQs pasted in chat. All are reworded released-exam items. Logged in `docs/research/orly_source_log/SOURCE_LOG.md`; insight note `2026-10-06_ap_chemistry_pooled_practice_mcqs.md`. **Decision:** `DECISION-0098` (class D seeds only through the clean-room spec path; the source is not stored).

**Assessment:**
- **AP Chemistry:** Unit 1 (7 items), Unit 3 (2), Unit 4 (9), Unit 9 (2). 2 of 20 keys are wrong.
- **AP Calculus AB:** topic 2.1 (3 items) and 5.1 (1). All 4 keys are wrong, and 3 of the 4 items have no correct choice.
- **Bank comparison:** we have no Chemistry content for Units 4 or 9. Topics 1.3 and 1.4 have one item each. Units 1-3 have no lab-procedure or error-analysis MCQs. The Calculus 2.1 polynomial pattern duplicates an existing family.

**Run (David's choices):**
- 10 families (Chemistry F1-F8, Calculus C1-C2), 3 members each, written by fresh authoring agents.
- Checkers: gpt-5.6-sol and deepseek-v4-pro-0813.
- Stop point: checked drafts.

**Result:** 30 drafts.
- **Checks:** both models solved all 30 to the key, and the independent re-derivation confirmed all 30 keys.
- **Divergence rewrites:** 4 drafts had converged on a source instance and were rewritten.
- **Patches:** 6 text patches, each re-checked clean.
- **Held:** F4 density (3 items) is outside the CED scope (readiness content), and f6-v2 is held for its topic label (3.7 vs 4.5).
- **Outcome:** 26 checked drafts. Batch: `scripts/content-seed/apchem-orly-cleanroom-2026-10-06/README.md`.

Production was read only. Nothing was written to any database.

**Update (same day, APPROVAL-0126):** David approved the scrub, held F4 (density, not published), set f6-v2 to 3.7 and approved loading. **27 items published to Production** (21 Chemistry, 6 Calc AB) with validated labels, topic cells, skill cells and difficulty; hash-verified. **Next Owner:** David Bloom. **Next Action:** none blocking; F4 stays held as readiness content.

## TASK-0065 Checker Pilot (AP Biology) — 2026-10-06

**Task:** `docs/tasks/TASK-0065-OPEN-HAND-TEACHING-QUESTION-GENERATION.md`. **Report:** `scripts/content-seed/task0065-bio-pilot-2026-10-06/PILOT_REPORT.md`. David named Claude the owner and approved a Biology pilot first, with an item failing a check if either checker flags it.

**Built:** `teaching_item_check.mjs` (C3 named-trap audit, C6 habit lines checked against `app.topic_point_briefs`) and `lint.py` (deterministic item-standard lint with a self-test). C1/C2/C4/C5 reuse the existing audit, CED and label-probe runners. Checkers: DeepSeek v4-pro + Gemini 3.8 flash; GPT-6.1 sol joins the 6-vote topic probe. Roster checked live.

**Result:** 5 clean items plus 4 controls with one planted defect each. All 4 defects were caught by the intended check, by both checkers, in both rounds. After one patch round, 2 of 5 clean items pass (3.1, 7.5); the checkers found real authoring defects in the others. **Open:** C6's "brief core covered" rule pulls against "pairs with item"; the topic probe sees titles only (2.5 vs 2.8); Production has 61 Biology topic briefs vs the task's 27. **Reconciled with APPROVAL-0123 / PR #340 (same day):** another session had run TASK-0065 in parallel, and its approval governs: 91 items, with habit lines from the point brief. This pilot's 603-topic scope is withdrawn and C6 is retired. C3, the lint and the CED-text probe were run on #340's 91 drafts. Lint: 2 fail. C3: 38 blocked, 13 for an unnamed temptation and 25 only because a fix line states a fact rather than an action (open for David). Biology topic probe: 21/21. Results feed #340's patch loop. **Fix lines (David: must be actions):** 44 fix lines rewritten across the 25 items in both file copies. On re-check all 25 clear lint, C3 and #340's solve and audit checks; two single-checker flags were adjudicated, one as variance and one as a wrong ozone-octet flag. 13 temptation-blocked items remain. **Earlier, round 3 (David's decisions applied):** C6 brief rule softened to "shares at least one move"; topic probe given per-topic CED text (2.5 votes went from 2/6 to 6/6); scope revised to the 603 topics with a published point brief. Controls still 4 of 4; clean items 4 of 5 (2.5 excluded because it had a second patch). Production was read only. Nothing written to any database. 486 model calls.

## Student Hub Stage A/B Mounted in Lovable Dev Preview; Dev View Fixed (TASK-0048) — 2026-10-04

**Task:** `docs/tasks/TASK-0048-HOME-REDESIGN-STAGE-A-B.md`. **Design:** `https://claude.ai/artifact/HoaRcFFv8GoiV9VeyDcgYh`. **Frontend:** Lovable `56cae479`, commit `08a042ca` (Dev preview, **not published**). **Dev database:** `public.student_course_positions` recreated with `topic_code`/`topic_source` (same SQL as `APPROVAL-0120`, Dev only, no new approval number used; Production untouched).

**Result:** backend prerequisites (`get_home_start_queue`, topic-level position) confirmed live in Dev and Production. Stage A/B were built but unmounted, so every student saw the legacy layout; they are now mounted by stage and the personalized path is unchanged. Gaps against the artboards fixed (threshold copy from real constants, Stage A start path, Stage B start hero). Authenticated visual QA not done; findings and next steps are in the task file.

**Next Owner:** David Bloom. **Next Action:** review the Dev preview signed in, decide on the findings, then approve or reject publishing.

## Session Close: Checkout User Testing, Post-Purchase Flow, Parent Pay, Student Home 400 (TASK-0060) — 2026-10-04

**Task and handoff:** `docs/tasks/TASK-0060-USER-TESTING-CHECKOUT.md` (E1–E10, F1–F13); `docs/handoffs/SESSION_CLOSE_2026_10_04_CHECKOUT_USER_TESTING.md`. **Production changes by Claude:** `APPROVAL-0119` (parent short links: table, `resolve-parent-link`, two function changes) and `APPROVAL-0120` (recreated `public.student_course_positions`), each rehearsed and verified without taking a payment. Lovable prompts P1–P8 reviewed by reading their commits; David publishes.

**Result:** the checkout (wallets, promo, picker, sticky bar), the post-purchase flow (return page code box, `/welcome`, login copy), and the parent-pay path (price, short link, redirect to Stripe at $1.00) all pass on the live site; the student home view bug that blocked every subject load is fixed.

**Still open (needs David):** a real-inbox purchase test, the Confirm sign up template, publishing and verifying the login fix and hub banner, the "Ask a parent to pay" panel's old Start Studying button, and the `TASK-0048` hub redesign decision. Details in the handoff.


## Parent Payment Short Links Live in Production (APPROVAL-0119) — 2026-10-04

**Approval:** `APPROVAL-0119` (David Bloom, chat). **Migration:** `supabase/migrations/20261004231126_parent_payment_short_links.sql`. **Task:** `TASK-0060`.

**Why:** the "Ask a parent to pay" link was Stripe's long hosted-checkout URL, unusable in SMS, and the parent modal showed the pre-promo price.

**Done:** Dev first (Stripe test mode, 12 cases including that a code can never reach a student session), then Production: migration rehearsed in a rolled-back transaction and applied; `resolve-parent-link` (new, public), `create-parent-payment-link` and `send-parent-payment-email` deployed. Live verification without payment: a `cs_live_` link resolves to an identical Stripe URL with its fragment, the promo case returns `amount_total` 100, malformed and unknown codes return 404, and anon cannot read the table.

**Open:** David publishes the Lovable frontend (`/p/<code>` page, modal price fix, short link in copy/share/SMS); the PR for the code is still to be reviewed and merged. A real email send through Loops has not been exercised.


## Student Home 400 Fixed: `student_course_positions` View Refreshed (APPROVAL-0120) — 2026-10-04

**Approval:** `APPROVAL-0120` (David Bloom, chat). **Migration:** `supabase/migrations/20261004223205_refresh_student_course_positions_view.sql`. **Task:** `TASK-0060`.

**Found:** after signing in, picking a subject showed "We couldn't load your home right now." The Production API logs showed `GET student_course_positions?select=...topic_code,topic_source` returning HTTP 400. The `app` table had the two columns (migration `20260927211703`) but the `public` view did not, so no student could load a subject home in Production.

**Done:** rehearsed in a rolled-back transaction, applied, verified (8 columns, options and grants unchanged, migration recorded, the app's request now resolves its columns). A read-only check of the 17 public mirror views found no other view producing errors; `topic_explainers` and `topic_point_briefs` omit `topic_code`, `status` and `source_note` and are flagged for a deliberate look.

**Open:** David retries picking a subject while signed in; the hub's behavior on a bare `/home` after login (subject picker) is expected.


## TASK-0060: Browser Test Results After P4/P4b — 2026-10-04

**Task:** `docs/tasks/TASK-0060-USER-TESTING-CHECKOUT.md` (E6, Test status). **No code, Production data or settings changed;** the only side effect was one unpaid Stripe session for a made-up address, which expires on its own.

**Passed:** intro copy, payment order, picker limit, promo guard and phone-width sticky bar (Claude, built-in browser); the same plus a $38.99 coupon on multi-subject orders, apply/remove, Google Pay in a signed-in Chrome window, Apple Pay in Safari including anonymous, and no wallets in Firefox (David). F1, F3, F6 and F7 are confirmed fixed.

**Remaining:** Check 3 (wallets return after a typed code is cleared), the wallet row appearing in place with no shift in Chrome and Safari, the Firefox hydration flash, a real-inbox purchase to close F10, and the "Ask a parent to pay" drawer from step 3.


## TASK-0060: F9 Decided and F10 Email Delivery Logged — 2026-10-04

**Task:** `docs/tasks/TASK-0060-USER-TESTING-CHECKOUT.md`. **No code, Production data or settings changed.** Read-only look at Production auth logs.

**Decision (David, chat):** a paid buyer still must prove the email (`DECISION-0090` stands), but friction is removed in layers: Google sign-in at checkout, else the wallet's email as proof (Google Pay and matching the typed email only), else one email carrying the 6-digit code and the link; the email code is always the fallback. Build order and gates are in the task (F9). No separate `DECISION-` number was minted.

**Found (F10):** no confirmation email arrived after the second live purchase. Supabase accepted the invite (200, `user_invited`), so the app did its part, and David confirmed the checkout used a placeholder address, which explains it. David confirmed custom SMTP is enabled in Production. Still to test: a purchase with a real inbox, checking that both the invite and a 6-digit code arrive (and not in spam).


## Checkout User Testing: P1–P4b Logged (TASK-0060) — 2026-10-04

**Task:** `docs/tasks/TASK-0060-USER-TESTING-CHECKOUT.md`. **No approvals used; no code, Production data or Stripe settings changed.** Read-only checks on Production (`pcntajvbdfqhbeewmdry`) and the Lovable frontend source (project `61dd6602`); the Lovable edits were sent at David's direction and published by David.

**Fix prompts:** P1 (Express Checkout loading/empty state), P2 (429 handling on Start Studying, spinners), P3 and P3b (promo control above wallets, typed-but-unapplied code blocks payment), P4 (remove-coupon bug, no-upsell copy, thin sticky bar, payment order wallet / card / parent) and P4b (picker limit, wallet slot from first paint). Each diff was read before David tested; P1 to P3b are published, P4 and P4b are built (Lovable head `a605ff12`) with publish not yet confirmed.

**Found:** removing a coupon left no payment option because the auto-session effect skips a key it already attempted (and re-applied a removed `?promo=` code on link visits); the P4 review found the picker had lost its 3-pick signal and the wallet row would shift the buttons. A second live purchase ($1 promo, Biology, 20:50 UTC) was verified paid with an active entitlement; its account is invited, unconfirmed, never signed in.

**Open:** why a paid buyer must verify email with a code before entering the app (`DECISION-0090`) and three ways to remove the friction without dropping the check; recorded as F9 in the task for David's decision. Browser tests for P4/P4b are listed in the task and not yet run.


## Checkout User Testing Opened (TASK-0060) — 2026-10-04

**Task:** `docs/tasks/TASK-0060-USER-TESTING-CHECKOUT.md`. **No approvals used; no code, Production data or Stripe settings changed.** Read-only checks on Production (`pcntajvbdfqhbeewmdry`) and the Lovable frontend source (project `61dd6602`).

**Found:** Express Checkout shows only the wallets a browser supports (Chrome Google Pay, Safari Apple Pay, Firefox none), so device detection is not needed. David's live $39.99 Google Pay purchase was recorded `paid` with an active entitlement ~2 s later, but the return page's "Start Studying Now" did nothing: the webhook's invite email used Supabase's one-email-per-minute allowance, so the page's `signInWithOtp` call returned 429 twice (19:31:48, 19:31:56), and the idle-state button never shows its error. Also: no spinner while a wallet payment completes, and an empty "Express Checkout" heading in Firefox.

**Next:** David sent fix prompt P1 (Express Checkout loading/empty state) to Lovable; P2 (silent-error and 429 handling, spinners) and P3 (promo before wallets) are drafted in the task file.


## Units 1-3 Skill and Topic Cleanup, Biology 025-v3, MCQ-005 Retired (APPROVAL-0098 to 0103) — 2026-10-03

**Approvals:** `APPROVAL-0098` to `APPROVAL-0103` (David Bloom, chat). **Scripts and votes:** `scripts/content-seed/skills-u13-2026-10-03/`, `scripts/content-seed/pipeline-v2-bio-u13-2026-10-02/load/restore_025v3.sql`.

**What was done (Production `pcntajvbdfqhbeewmdry`):** (1) the two real stale labels (`APBIO-MCQ-088`, `apphy1-mcq-049`) re-issued validated on the published version; the other ~50 census "mismatches" are never-validated labels. (2) Biology `APBIO-MCQ-SV-025-v3` restored (the only 025 variant that passed both checkers). (3) Skill grids built for Physics 1 (10 skills, 430 cells) and Precalculus (8 skills, 464 cells). (4) Four-voter skill votes on 140 Units 1-3 seeds, then variants inherited: 679 skill cells. (5) 32 topic cells for topic-less variants, 7 for untagged seeds (3 by CED-text tiebreak), 34 more skill cells, 6 seed skill cells with 2 inheriting variants. (6) `apcalcab-mcq-005` and its 5 variants retired.

**Verified:** every batch rehearsed with a rollback first; after each commit an md5 over the written rows equalled the locally computed plan.

**Known leftovers:** 4 variants with a 2-2 skill split; 6 variants and 26 more waiting on seeds without a skill; FRQs, Units 4 and above, and Calculus BC not covered; two documented drafts (`APSTATS-MCQ-SV-057-v2`, `apcalcab-mcq-sv-025-v1`) stay held.

## AP Biology: 38 Items With All Versions Retired Now Marked Retired (APPROVAL-0095) — 2026-10-03

**Approval:** `APPROVAL-0095` ("Clean up the 42"). **Script:** `scripts/content-seed/reviewer-qa-remediation/20261003_apbio_align_orphan_item_status.sql`. **Follows:** the 42-item finding recorded with `APPROVAL-0092`.

**What was found:** the 42 Biology items marked `published` with no published version were old pipeline retirements (item rows last touched 2026-07-16 to 2026-08-13) where only the versions had been retired. The practice selector requires both the item and its version to be `published`, so none was being served, and the census already counts the state as its own bucket. No student-visible effect.

**What was done:** 38 of the 42 (17 FRQ, 21 MCQ) set to `retired` at item level by a rule inside the script (all versions retired, no attempts). Verified: Biology published items 174 to 136; published versions and validated serving labels unchanged (132 and 163). **Held, not touched (4):** `APBIO-FRQ-L-028` (5 attempts) and `APBIO-MCQ-012` (1 attempt), where an item-status change might affect anything listing a student's history by item status (not checked); `APBIO-FRQ-L-038` and `APBIO-FRQ-L-041`, each with an unretired `reviewed_approved` version 1 beside retired versions 2 and 3.

**Per the Product Owner:** no rescan of other subjects' banks under `DECISION-0095`. **Update, same day:** the four held items were retired under `APPROVAL-0096` after the Product Owner confirmed the attempts were tests, not real students. Biology now has 132 published items, each with a published version. **Next Owner:** David Bloom. **Next Action:** none from this thread.

## AP Biology: 3 More Items Retired (APPROVAL-0092) and DECISION-0095 Recorded — 2026-10-03

**Approval:** `APPROVAL-0092` ("Retire all 3 and create a decision for stay within the CED"). **Decision:** `DECISION-0095`. **Script:** `scripts/content-seed/reviewer-qa-remediation/20261003_apbio_retire_014_063_025.sql`.

**What was done:** a read-only scan of the 41 published AP Biology seed-style MCQs found two with terms the CED does not name (`APBIO-MCQ-014`: 70S/80S ribosomes; `063`: signal sequence); with `025` (kidney ADH and aquaporin-2 physiology outside the pack, per `APPROVAL-0080`) all three were retired. This corrects the pilot's count: six of the eight pilot seeds, not five, used out-of-CED terms (`014` was missed). Verified afterwards: Biology published items 177 to 174, seed-style published MCQs 65 to 62, 17 variants and 163 validated serving labels unchanged.

**Finding, not caused by this change:** 42 Biology items (20 FRQ, 22 MCQ) are marked `published` at item level while every version is `retired`. Whether any is served was not checked. **Next Owner:** David Bloom. **Next Action:** decide whether to clean up those 42 and whether to scan other subjects' published banks under `DECISION-0095`.

## AP Biology: 7 Published Variants With Out-of-CED Terms Retired (APPROVAL-0091) — 2026-10-03

**Approval:** `APPROVAL-0091` (Product Owner: "some of the published ones use terms outside the CED. We should retire them. We have enough questions."). **Script:** `scripts/content-seed/reviewer-qa-remediation/20261003_apbio_retire_out_of_ced_variants.sql`. **Follows:** `APPROVAL-0080`, and the 2026-10-01 ruling that items stay within CED vocabulary.

**What was done:** a full-text scan (stimulus, stem, every choice and rationale) of all 24 published `APBIO-MCQ-SV-` variants against terms confirmed absent from the CED V.1 text found 7 matches; those 7 were retired in one transaction: `014-v1`, `014-v2`, `022-v3` (70S/80S ribosomes), `022-v1` (70S ribosomes, binary fission), `018-v1`, `018-v3` (receptor-mediated endocytosis), `023-v2` (high-salt wash). Zero attempts on all seven. `SV-005-v3` ("tripeptides") was kept on purpose. Verified: variants published 24 to 17, Biology published items 184 to 177, no published item without a published version, validated serving labels unchanged at 163.

**Not done:** no replacements written; this session's 16 drafts stay unloaded; the unit-gated servable count was not re-queried. **Next Owner:** David Bloom. **Next Action:** none required; the open items are in `docs/handoffs/SEEDED_QUESTIONS_SESSION_RECORD_2026_10_01.md`.

## Google Sign-In Removed From Checkout; Post-Pilot Task Opened (TASK-0058) — 2026-10-02

At David's direction (after the Google consent screen showed the Supabase project URL and the redirect flow left the page), Claude sent a tightly scoped instruction to the Lovable marketing project; Lovable commit `18666296` removed the Google button, the "or type your email" divider and the code that existed only for it. The diff was checked line by line: one file (`src/routes/checkout.index.tsx`), deletions only, signed-in handling untouched, nothing published. `TASK-0058` collects the post-pilot work (Google One Tap/FedCM with `signInWithIdToken`, step reorder and wallet layout, wallets-first email capture, a Dev-pointed frontend, Stripe hardening, email/SMTP, passkeys) and the Google Auth Platform branding checklist.

**Approval state:** documentation; the Lovable edit is unpublished. **Next Owner:** David Bloom. **Next Action:** publish the Lovable project when ready; start Google branding verification; the pre-pilot items listed in `TASK-0058`.

## Stripe Live Payment Proven in Production; Refund Round Trip Verified — 2026-10-02

Evidence is in `docs/product/STRIPE_PRODUCTION_CUTOVER_CHECKLIST_2026_09_30.md` ("Gate D evidence, part 1"). A full-price live Link payment ($39.99, Biology, existing admin student) was processed by the live webhook on the first attempt; a $10 partial refund left the entitlement active and the remaining $29.99 refund revoked it. David refunded the whole charge. Found and fixed (Lovable `230e0670`) the email conflict that stopped the card form loading; Bank, Cash App Pay, Klarna and Amazon Pay switched off in Stripe.

**Not approved / still open:** the Orly email; the new-student path (invite email, 6-digit code), which depends on Supabase email delivery (SMTP setting unverified); the $1 coupon on a live checkout; the `support@cramapple.com` alias; the go/no-go. **Next Owner:** David Bloom. **Next Action:** test a brand-new student in a private window with the `?promo=` link and a fresh email; check Supabase Auth SMTP settings.

## Stripe Functions Tranche 2 Deployed to Production (APPROVAL-0071) — 2026-10-02

**Approval:** `APPROVAL-0071`. All four functions deployed from `main` `fc2f3a6c` and verified (see the approval entry). Earlier the same day David re-set `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET` (Production had stored identical values for both, which was wrong) and `STRIPE_PRICE_CATALOG_JSON` (exact match to the validated JSON); a fifth event, `charge.refunded`, was added to the live webhook endpoint; the refund policy is live in the Terms; the "free until November" copy is gone.

**Approval state:** Hard Gate. Not approved: the Lovable publish, the Orly email, the go/no-go. **Next Owner:** David Bloom. **Next Action:** fix the `support@cramapple.com` alias; decide when to publish the Lovable project; then Gate D (your own \$1 purchase with the live code, refund it, confirm access and revocation).

## Stripe Functions Tranche 1 Deployed to Production (APPROVAL-0070) — 2026-10-02

**Approval:** `APPROVAL-0070` (tranche 1). `stripe-webhook` v20→v21, `get-checkout-status` v1, `send-parent-payment-email` v1, all `verify_jwt=false`, deployed source byte-identical to `main`; invalid-request probes returned 400/405; Production data unchanged. Live publishable key already sits in the Lovable `.env` but the project is unpublished (checkout still shows "Online payment isn't switched on yet"). Refund-policy draft is in PR #309; it exposed that the Contact Us form sends nothing.

**Approval state:** tranche 2 not approved. **Next Owner:** David Bloom. **Next Action:** confirm Stripe mode of Production's `STRIPE_SECRET_KEY`, the live webhook endpoint and signing secret, live price IDs, the support email and refund text; then approve tranche 2.

## Stripe Payment Migrations Applied to Production (APPROVAL-0069) — 2026-10-02

**Approval:** `APPROVAL-0069` (`DECISION-0094`). Three additive migrations applied to Production and checked one by one; ledger versions `20261002001232`, `…001253`, `…001308`; 5 existing webhook events backfilled to `processed`; entitlements unchanged (253); service-role-only access on the new objects; no new advisor findings. Dev evidence from the same day: `$1` coupon purchase and refund round trip pass on `stripe-webhook` v25 (PR #306). No function deployed, no secret, no Stripe or Lovable change.

**Approval state:** Hard Gate. Remaining Production steps are unapproved: six function deploys, live secrets, live Stripe setup, Lovable publishable key. **Next Owner:** David Bloom. **Next Action:** deploy the six functions with `--no-verify-jwt`; confirm refund/terms position and live Stripe setup.

## Seeded-Variant Runs: Status by Subject Documented; AP Biology Pilot Closed — 2026-10-01

**Doc:** `docs/research/SEEDED_ITEM_GENERATION_PROTOCOL_2026_09_30.md`, new section 10. **PRs:** #303 (merged), #305 (round-5 checks for the `005` variants, plus this documentation). No Production change in this entry; the Production changes of the day are `APPROVAL-0067` and `APPROVAL-0068`.

**Status (corrected 2026-10-03):** AP Calculus AB (Unit 1 complete, others sampled, Units 2-3 pilot started), AP Biology (this session's 16 drafts unloaded; a different 24-variant set published under `APPROVAL-0080`, overlapping), AP Chemistry (Units 1-3, 72 published) and AP Statistics (Units 1-3, 131 published) have had variant runs. AP Calculus BC, Physics 1, Physics 2, Physics C E&M, Physics C Mechanics and Precalculus have not. FRQs have had none. See protocol section 10.

**Session records (2026-10-02):** `docs/handoffs/SEEDED_QUESTIONS_SESSION_RECORD_2026_10_01.md` (generation, with the handoff packet) and, kept separate, `docs/handoffs/GRADING_NOTES_FROM_SEEDED_QUESTION_SESSION_2026_10_01.md`. **Open:** reconcile the two Biology variant sets, including published variants that use terms outside the CED (seeded-question record, addendum); label probe on this session's final text (input `probe_items_final.json`; only needed if the drafts are used); re-check of the 24 Calc variants against the repaired Calc seeds. (Seed topic relabelling was done by `APPROVAL-0079`.)

## AP Biology Seeded-Variant Pilot: Seed Audit, 14 Variants, `APBIO-MCQ-023` Repair Approved (APPROVAL-0067) — 2026-10-01

**Pilot:** `scripts/content-seed/apbio-seeded-pilot-2026-09-30/` (class A seeds only, Units 1-2, checkers `google/gemini-3.5-flash` + `deepseek/deepseek-v4-pro`, author Claude Sonnet 5.5). Reports: `S0A_AUDIT_REPORT.md`, `VARIANTS_MATH_CHECK_REPORT.md`. Total checker spend so far about $0.60.

**Findings:** 0 key errors anywhere (0 of 16 seed solves, 0 of 28 variant solves disagreed). Seeds: 1 of 8 had a defective rationale (`APBIO-MCQ-023` choice A). Variants: 2 of 14 had a real wording defect, all raised by DeepSeek only and hand-verified; patched and re-checked clean. Calc comparison and caveats are in the reports. Production's provisional topic tags on several seeds look wrong (for example `APBIO-MCQ-008` tagged 1.1 Structure of Water but about a protein mutation); the label probe will test this before any variant inherits a tag.

**Approval:** `APPROVAL-0067` covers the one-item Production repair of `APBIO-MCQ-023` choice A, tested first in a rolled-back run. **Applied 2026-10-01 and verified:** v2 published (v1 retired), only choice A's rationale changed, key still D, both labels restored and hash-fresh, Biology counts unchanged (118 published, 43 unit-gated, 69 validated). The 14 variants are not in any database. **Pilot closed 2026-10-01:** 16 variants (2 per seed incl. repaired 023), checker spend $2.45; all 16 ready for review preparation, with `021-v1`/`021-v2` conditional: the Product Owner directed on 2026-10-01 that signal sequences directing proteins to the ER are in the 2026-2027 AP Biology curriculum (not verified against the CED text; College Board site unreachable from the session), which released the hold. The repo's AP Biology fact pack appears to predate the 2026-27 curriculum and should be refreshed from the CED; final report `scripts/content-seed/apbio-seeded-pilot-2026-09-30/PILOT_REPORT.md`. **Follow-on, 2026-10-01:** after checking the CED (V.1, pp. 49-51) the Product Owner ruled that items stay within CED vocabulary. `021-v2` was rewritten at CED level; six more variants (`018-v1`, `018-v2`, `021-v1`, `022-v1`, `023-v1`, `023-v2`) were rewritten and checked (content clean; scope clean except two DeepSeek-only flags, `021-v1` and `022-v1`, adjudicated in the report); the `005` pair is held. Under `APPROVAL-0068` the five published seeds `APBIO-MCQ-005`, `018`, `021`, `022`, `023` were replaced with CED-vocabulary versions in Production (keyed letters unchanged, labels carried forward, counts unchanged). The variants still need a re-check against the new seeds.

## Stripe Production Cutover Checklist Drafted; Launch Shape Revised to a $1 Pilot Then 50% Off — 2026-10-01

**Decision:** `DECISION-0094`. **Doc:** `docs/product/STRIPE_PRODUCTION_CUTOVER_CHECKLIST_2026_09_30.md`. **Branch:** `claude/stripe-production-cutover`. Documentation only; no Production, Stripe, secret, or migration change.

Read-only Supabase audit (2026-09-30): Production runs `create-checkout-session` v21 and `stripe-webhook` v20 from August; `get-checkout-status`, `create-parent-payment-link`, `send-parent-payment-email`, and `create-post-purchase-addon` are not deployed; `app.stripe_customers`, `app.parent_payment_email_requests`, the `stripe_webhook_events` replay columns, and `app.claim_stripe_webhook_event` are missing (Dev has all). Deploying the new webhook before the three migrations would fail every student checkout. Dev's payment functions run `verify_jwt=false`; Production's `create-checkout-session` is `true`, so every deploy needs `--no-verify-jwt`. Not verified: live-mode Stripe state, Loops, the Lovable frontend.

**Approval state:** Hard Gate. Nothing for Production approved. **Next Owner:** David Bloom. **Next Action:** deploy `stripe-webhook` and `get-checkout-status` to Dev and run a $1 single-subject test-card purchase; confirm the coupon's Stripe mode; write the refund/terms position.

## Calc AB Repair Approved (APPROVAL-0066): `apcalcab-mcq-037` Key Letter, 10 Distractor-Rationale Repairs, Label Carry-Forward — 2026-10-01

**Approval:** `APPROVAL-0066` (`DECISION-0093`). **Scope:** 11 published AP Calc AB MCQs on Production; two scripts in `scripts/content-seed/reviewer-qa-remediation/` (`20260930_apcalcab_037_key_and_distractor_rationale_repair.sql`, `20260930_apcalcab_label_carry_forward.sql`), run back to back in one transaction.

**Why:** the seed audit found 10 of 20 audited published seeds with distractor rationales that do not produce their shown value (keys were all correct), and `apcalcab-mcq-037` with `canonical_answer_1 = 'A'` while choice B is the flagged-correct local maximum (grading reads `is_correct`, so students were graded correctly; the stored letter only reached reviewer snapshots). `TASK-0053` now shows the chosen distractor's rationale to students, so the false rationales were student-visible.

**Applied 2026-10-01** as one transaction: 11 items republished as new versions, 11 labels restored. Verified: one published version each, key letter equals correct choice (`037` now `B`), `is_correct` unchanged, no desync, no stale validated hashes; Calc AB counts unchanged (279 published, 196 unit-gated, 198 validated).

**Follow-up:** the 24 seeded Calc AB variants were written from some of these seeds; re-check them against the repaired seeds. About 150 other published MCQs remain unaudited (policy: audit a seed when it is varied).

**Tested first:** a rolled-back run on Production on 2026-09-30 passed every in-script assertion (11 repaired, key letter equals correct choice on all 11, `is_correct` unchanged, stem/choice sync, no duplicate published versions, labels restored and hash-fresh) and left Production unchanged.

