# Orly External-Assignment Mining Protocol

**Status:** Draft operating protocol, proposed 2026-08-24.
**Related Tasks:** none yet — first applications are the AP Calculus AB, AP
Chemistry, and AP Calculus BC summer-assignment reviews this session; no
`content_items` inserted under this protocol yet.
**Product Owner:** David Bloom
**Learning Quality Owner / Source:** Orly Bloom
**Founding case study:** `AP Chemistry Summer Assignment.pdf` and `AP Calc AB
Summer Assignment 26.pdf` (Solebury School, teacher Michelle Gavin), reviewed
2026-08-24.

**Revision note (2026-08-24, same day):** applying the protocol to
`AP Calculus BC.pdf` (Solebury School, teacher Hannah Pritchett) surfaced a
source type the original draft didn't name: a licensed third-party platform's
own auto-generated content (DeltaMath "Corrective Assignment" exports), as
opposed to a teacher's original worksheet. Added to §2 below.

## 1. Purpose

Orly is a real AP student at a real school. Over the course of the year she
will keep bringing home real class materials — summer assignments, problem
sets, quizzes, teacher-made study guides, pacing calendars. Each one is a look
at how a working AP teacher actually sequences, paces, and assesses a unit —
information Cramapple cannot get from the College Board's CED alone, because
the CED specifies *what* is tested, not how a real class *teaches toward it*.

This protocol defines a repeatable pipeline for turning that raw material into
four separate outputs, each with its own handling rules:

1. **Original Cramapple practice items**, authored fresh through the existing
   content pipeline, tagged to the correct subject/unit/topic/skill.
2. **Pacing and structure insight**, fed into product decisions (unit sizing,
   diagnostic placement, self-assessment UX) — not content, no publish gate.
3. **Category distinctions**, i.e. recognizing when a document is *not* CED
   content at all (see §4) and should not be forced into the taxonomy.
4. **A source log**, so we always know what came from where and can answer
   "did we copy anything" with evidence, not memory.

**What this protocol is not:** a license to copy. See §2 before doing anything
else with a new document.

## 2. Rights boundary — read this first

Every document under this protocol is a real teacher's or school's original
work (a named teacher, a named school, sometimes a licensed third-party
curriculum referenced inside it, e.g. Flipped Math). It is not
Cramapple-owned, not public domain, and not released College Board material.
The same boundary [[Quarantined image workflow code sketch|used elsewhere in
this repo for rights-sensitive source material]] applies here:

- **Never** copy stem wording, specific numbers, specific graph data, answer
  choices, or rubric language verbatim into a `content_items` row, a doc, or
  a chat response beyond a single short quote for identification purposes.
- **Never** treat a document's problems as a seed gold set, a fact-pack input,
  or a source to paraphrase-then-ship. Paraphrasing a copyrighted problem is
  still derivative of it.
- **Do** treat the following as free to use, because they are facts/methods,
  not the teacher's original expression:
  - the topic list, its sequence, and which CED topic codes it covers;
  - the skill categories being practiced (e.g., "estimate a limit from a
    table" is a skill description, not an expression of it);
  - pacing numbers (minutes per lesson, total hours, assessment timing);
  - structural devices in general (a 0–4 self-assessment scale, a "day 3
    quiz" checkpoint) — the *idea* of a rubric-scale or checkpoint, not its
    specific wording;
  - the fact that a document exists, what school/teacher/year it is from, and
    what it tells us about how AP classes are actually paced.
- Every batch of items authored under this protocol must carry an
  `originality_statement` in `review_notes` (see the schema in
  `docs/research/CONTENT_AUTHORING_AND_QA_PROTOCOL.md`) confirming no
  released, secure, or third-party wording was used, extended here to name
  the source document mined for topic scope.
- **Platform-generated content is a distinct, higher-sensitivity case.** Some
  documents are not a teacher's own writing at all — they are exports from a
  licensed third-party platform's own item bank (e.g. a DeltaMath "Corrective
  Assignment" printout). That content belongs to the platform vendor, not the
  school, and the specific problems are drawn from the vendor's proprietary
  bank rather than authored ad hoc. Treat these as *more* restricted than a
  teacher-authored worksheet: mine only the topic/skill scope and pacing
  signals (§5), and do not use individual problem instances as structural
  templates ("same shape, new numbers") the way a one-off teacher problem
  might be loosely echoed — go from the topic code straight to an
  independently designed item.
- If a document is ambiguous — e.g., it looks like it was itself lifted from
  a textbook the school licenses — treat it as *more* restricted, not less,
  and flag it in the source log (§3) rather than resolving the ambiguity
  yourself.

## 3. Intake and source log

Every new document Orly brings home gets logged before any content work
starts. Maintain a running table (new file:
`docs/research/orly_source_log/SOURCE_LOG.md`, one row per document) with:

| Field | Example |
| --- | --- |
| Date received | 2026-08-24 |
| School / teacher | Solebury School / Michelle Gavin |
| Subject | AP Calculus AB |
| Document type | Summer assignment (Unit 1 Part I) |
| CED units/topics covered | 1.1–1.8 |
| Category (§4) | CED-aligned unit content |
| Mined for | topic scope, pacing, self-assessment rubric |
| Items authored from it | apcalcab-mcq-060, -070, -080, -090 (draft) |
| Rights notes | Flipped Math video links referenced, not ours to embed |

This log is the answer to "did we copy anything from a specific school" if
ever asked, and it is also how we notice patterns across documents over
multiple years (e.g., "three different schools all treat Unit 1 topics 1.9+
as second-semester material" is a real signal; one document is an anecdote).

## 4. Category distinctions

Not every document Orly brings home is the same *kind* of thing, and treating
them all as "Unit N content" loses information. Classify each document into
one of:

- **CED-aligned unit content** — directly teaches/practices topics inside a
  published `taxonomy_units`/`taxonomy_topics` unit (the Calc AB packet:
  every LT maps to a real 1.x topic code).
- **Prerequisite / readiness content** — skills assumed *before* Unit 1
  starts, not tested by the CED as its own unit (the Chemistry packet: sig
  figs, unit conversion, subatomic particles — none of this is AP Chem's
  actual Unit 1, Atomic Structure). This is a distinct product category we do
  not currently model explicitly (see §6) and should not be shoehorned into
  a real CED unit's topic codes.
- **Study-skill / logistics content** — pacing calendars, academic-integrity
  policy, materials lists, grading-rubric framing. Not question material at
  all; mine for insight only (§5), never for items.
- **Assessment/answer-key material** — if a document includes a teacher's
  answer key or grading key, it is the most rights-sensitive category of all
  (it's graded intellectual work product, not just a worksheet) and should
  be logged but not mined for anything beyond confirming our own independent
  derivation matches, the way `CONTENT_AUTHORING_AND_QA_PROTOCOL.md` §9
  already requires for all authored items regardless of source.

## 5. Insight capture (non-content)

Some of the most useful information in these documents is not a question at
all — it is a signal about how real AP classes run. Capture it separately
from item authoring, in a short dated note under
`docs/research/orly_source_log/`, one per document, covering whatever of the
following actually appears:

- **Pacing** — how long a real teacher expects a topic/unit to take a
  student, and how that compares to Cramapple's own unit sizing.
- **Sequencing** — the order topics are actually taught in, versus the CED's
  numbering (they aren't always the same).
- **Diagnostic/readiness gaps** — prerequisite skills a teacher assumes
  in class but that a Cramapple student jumping straight to practice might
  not have (see §4's readiness-content category — this is where it feeds
  product thinking).
- **Self-assessment framing** — how a real teacher asks students to rate
  their own understanding, and whether that framing would work as a
  Cramapple UX pattern (confidence rating before/after practice, etc.).
- **Checkpoint structure** — when and how a teacher checks whether the work
  actually got done (e.g., a day-3 quiz), which is a signal about how
  Cramapple might structure its own "prove you did the practice" moments if
  it ever adds one.

These notes are read by product, not graded against a publish gate — they are
explicitly allowed to be speculative ("this might inform X") rather than
decided.

## 6. Turning it into Cramapple content

Once a document is classified as CED-aligned unit content (§4) and logged
(§3), authoring original items from it follows the **existing** content
pipeline unchanged — this protocol adds sourcing discipline in front of it,
it does not replace it:

1. Confirm the exact `topic_code`(s) via `app.taxonomy_topics` for the
   subject (do not trust the source document's own numbering — verify
   against our taxonomy, as Calc AB's LT numbers happened to match but are
   not guaranteed to for other subjects/schools).
2. Author brand-new stems, numbers, and (for MCQ) distractors targeting the
   same skill and difficulty band the source document implied, matching the
   schema of a real published item (`content_items` / `content_item_versions`
   / `mcq_choices` or `frq_criteria`, `content_taxonomy_labels`) — see the
   worked example from this session (`apcalcab-mcq-060` through `-090`).
3. Tag full metadata at authoring time, not after:
   - `taxonomy_refs`: unit node key, topic node key (`topic-X.Y`), and the
     relevant AP practice/skill node key(s);
   - `practice_format` on `content_items` when the item is an FRQ
     (`targeted_drill` vs `full_exam_frq`, per the publish-gate cluster
     mirrored into Dev this week);
   - `difficulty` and `calculator_mode` in `prompt_json`;
   - `review_notes.originality_statement` naming the source document per §2.
4. Insert as `status = 'draft'` only. Never insert directly as `published` —
   run through the standard taxonomy-labeling and content-review pipeline
   (`CONTENT_AUTHORING_AND_QA_PROTOCOL.md`), which now enforces the
   publish-gate and content-review-invariant triggers in both Dev and Prod.
5. Record the resulting `content_key`s back in the source log (§3) so the
   provenance chain (school → document → items) stays intact.

If a document reveals a **category gap** — a skill or checkpoint type
Cramapple's schema has no place for (e.g., readiness/prerequisite content per
§4) — stop and raise it as a product question rather than force-fitting it
into an existing unit/topic. That is a §5 insight, not a §6 authoring task.

## 7. What this protocol deliberately does not cover

- Grading or evaluating Orly's own submitted work — this is about Cramapple's
  content pipeline, not tutoring her personally.
- Any document that isn't hers or isn't shared with explicit intent for this
  use — do not go looking for more.
- Bulk/automated ingestion — every document under this protocol is reviewed
  by a person (this session, David) before anything is mined, at least until
  the source log (§3) has enough volume to justify tooling.
