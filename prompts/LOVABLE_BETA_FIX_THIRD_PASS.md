# Lovable Patch - Third Pass

Tight follow-up to `LOVABLE_BETA_FIX_REVIEW_FINDINGS.md`. The previous round
landed almost everything correctly. This patch fixes the one P0 it introduced,
finishes one half-done item, and closes a handful of smaller issues found in
the third walkthrough.

UI-only. Do not change `submitRevisionFn` or any backend grading code.

The patch is organized so an iterator who stops after Section 1 still ships
the most important fix.

---

## Section 1 - P0

### P1. `TargetedChip is not defined` crashes any attempt with a submitted revision

Every attempt URL whose underlying state includes a submitted coached revision
crashes with a full-page error boundary:

```
Something went wrong
TargetedChip is not defined
Return to Practice   Resume another attempt
```

Console:

```
ReferenceError: TargetedChip is not defined
  at https://cramapple-beta.lovable.app/assets/beta.attempt._id-kiTSEqFm.js:5:14947
  at Array.map (<anonymous>)
```

Root cause: the new four-bucket comparison layout references `TargetedChip`
but the module never imports it. The component is `undefined` at runtime and
`Array.map`'s render throws.

**Fix.** Add the missing import for `TargetedChip` in
`beta.attempt._id-*.tsx` (or wherever the four-bucket layout lives). Verify
the import path resolves at build time.

**Redeploy, then run the A1 and A2 acceptance checks below on a freshly cold
submitted and revised attempt.** Do not verify against the historic
Photosynthesis row — that row was stored under the pre-merge backend and may
render differently regardless of import status.

#### A1. Revision earns the targeted point

Cold-submit a fresh Photosynthesis FRQ attempt with a deliberately partial
2/4 answer. Click `Fix this part` on the missed electron-path criterion.
Submit a revised paragraph that correctly traces `PSII → ETC → DCPIP`. The
comparison panel must render:

- `ORIGINAL 2 / 4`
- `REVISED 3 / 4`
- `Δ +1`
- `GAINED` bucket — one row, the electron-path criterion, with a `Targeted`
  chip and a `Missing` / `Try` evidence line specific to the revised text.
- `UNCHANGED — EARNED` bucket — two rows: `Identifies water as electron
  source` and `Predicts DCPIP stays blue with DCMU`, both at `1/1`.
- `STILL MISSING` bucket — one row: `Explains O₂ evolution`, at `0/1`, no
  `Targeted` chip.
- `TARGETED — NOT EARNED` bucket — empty, not rendered.

#### A2. Revision does not earn the targeted point

Repeat the cold submission. Click `Fix this part` on the same criterion.
Submit a deliberately weak revision. The comparison panel must render:

- `ORIGINAL 2 / 4`
- `REVISED 2 / 4`
- `Δ +0`
- `GAINED` bucket — empty, not rendered.
- `TARGETED — NOT EARNED` bucket — one row, the electron-path criterion,
  with a `Targeted` chip and a `Missing` / `Try` evidence line specific to
  the revised text.
- `UNCHANGED — EARNED` and `STILL MISSING` buckets — as in A1.

The revised total must never drop below the original.

#### A3. Multi-point criterion

Run A1 with a criterion worth more than 1 point (or extend an existing
fixture to include one). The coached-revision self-prediction options must
expand to `+0 / +1 / +2 …` up to the criterion's max, and the annotation
chip must read `Worth up to N more points.` where N is the missing
point count. Verify the comparison total adds correctly.

---

## Section 2 - Finish a half-done item

### F1. Live composer `Missing:` line is still answer-bearing, and `Try:` is missing

The third-pass walkthrough confirmed `Missing:` replaced `To earn the next
point:` in the live attempt page. Good. But:

1. The `Missing:` sentence still gives the answer in prose. Example from the
   live Cell signaling attempt:

   ```
   Missing: Needed transcription factor activation leading to expression
   of S-phase-promoting genes such as cyclins.
   ```

2. The `Try:` line (abstract action) is not present in the live composer.

The result-state preview at `/preview/result/confident_partial` already
ships the correct pattern. Adopt it verbatim in the live composer:

```
Missing: No mention of RNA polymerase binding or transcription initiation.
Try: Name the step that changes at the promoter.
```

Rule: `Missing:` names the absent concept by category, not by full
sentence completion. `Try:` is an abstract action verb plus the
discriminating step. Neither should be a sentence the learner could copy
into the revision and earn the point.

Acceptance: open the Cell signaling attempt at
`/beta/attempt/8da14ae2-…`. Every missed criterion card must show both a
`Missing:` and a `Try:` line. No `Missing:` sentence is long enough to
serve as a paste-in answer.

---

## Section 3 - Smaller fixes

### S1. `/preview/capture` state selector doesn't change the mock

The 10 state buttons (`QR ready`, `QR expired`, `Permission explanation`,
`Framing`, `Photo review`, `Looks ready`, `Retake recommended`,
`Cannot determine`, `Submitted`, `Accessible alternative`) currently swap
only the caption text at the top of the page. The Desktop pair / Mobile
viewfinder / Flow / Planned feature panel sections render identically
across every state. A reviewer cycling the selector sees the same
`PRV-7421` pairing code and `Fake viewfinder` mock for `QR expired`,
`Permission explanation`, and `Accessible alternative`. Misleading.

**Fix.** Each state needs its own fixture render. Minimum viable, per
state:

- `QR ready` — current QR + pairing code render.
- `QR expired` — greyed QR, message `Pairing code expired`, `Refresh`
  action.
- `Permission explanation` — the pre-prompt copy from UX-008 §7
  (`Cramapple needs camera access to photograph this graph. You can
  review or retake the image before submitting.`) plus `Continue to
  camera` / `Choose an existing photo` / `Use another method` / `Cancel`.
- `Framing` — viewfinder mock with framing guides overlay; brief
  framing guidance.
- `Photo review` — captured-image preview with `Rotate` / `Crop` /
  `Retake` / `Remove` / `Use this photo` controls.
- `Looks ready` — green confirmation + `Capture accepted does not mean
  the graph is correct.` disclaimer + `Submit graph` action.
- `Retake recommended` — yellow warning with a specific fixable issue
  (`The x-axis label is cut off.`) + `Retake` / `Review image` /
  `Use another method`.
- `Cannot determine` — neutral message `We cannot confirm that every
  required part is readable. This capture needs human review or another
  submission method.` (note: per the patch, use `Saved for review`
  language, not `human review`, so adjust to `This capture needs to be
  saved for review or another submission method.`)
- `Submitted` — confirmation + cross-device status copy.
- `Accessible alternative` — non-camera path layout: file upload
  affordance (disabled with tooltip), manual pairing code field,
  keyboard-operable photo-review note, coordinate-entry alternative
  panel.

Each state's fixture can stay simple — labeled boxes are fine. The
goal is to show that the state taxonomy maps to distinct screens, not
to ship pixel-perfect mocks.

### S2. Resume row with non-4-point total

Row reads `Enzyme kinetics and temperature — 1d ago · Complete · 3 / 3`.
Every other Enzyme kinetics row is `4 / 4`. Either backfill the stored
row to the canonical 4-point rubric or filter rows with non-canonical
totals from the Resume list.

### S3. Align coached-vs-independent vocabulary between preview and live

The `/preview/result/coached_vs_independent` fixture uses two blocks
labeled `INDEPENDENT EVIDENCE` / `COACHED EVIDENCE` listing the source
of each rendered claim. The live attempt page uses the four-bucket
layout with a `Targeted` chip. Both convey "what came from where" with
different vocabularies.

**Fix.** Use one taxonomy for both surfaces. Suggested: keep the
four-bucket layout for the live revision-comparison panel (`GAINED /
UNCHANGED — EARNED / TARGETED — NOT EARNED / STILL MISSING`), and on
the preview fixture relabel `INDEPENDENT EVIDENCE` → `UNCHANGED —
EARNED (from cold submission)` and `COACHED EVIDENCE` → `GAINED via
revision`. Or invert: keep `INDEPENDENT / COACHED` framing in both
places and rework the bucket names to match. Pick one and apply.

### S4. React hydration error #418

Console throws `Minified React error #418` (text content did not
match) on multiple routes. Not user-blocking but produces flicker on
first paint and can mask real issues. Investigate which component
renders different text on server vs. client; likely candidates are
the time-ago label on Resume or the dynamic disclosure banner copy.

---

## Acceptance Sweep

Run the following after the patch:

1. A1, A2, A3 from Section 1 — the comparison panel renders correctly
   on fresh attempts with single-point and multi-point targeted
   criteria.
2. Open `/beta/attempt/8da14ae2-…` (Cell signaling 1/4). Every missed
   criterion card shows `Missing:` (abstract) and `Try:` (abstract). No
   `Missing:` sentence is a paste-in answer.
3. Toggle every state on `/beta/preview/capture`. Each state renders a
   visually distinct fixture.
4. Open `/beta/resume`. No row shows a non-4-point total for an FRQ.
5. Open `/beta/preview/result/coached_vs_independent` and a freshly
   revised attempt. Same vocabulary on both surfaces.
6. Console on every beta route shows no React error #418 and no
   `ReferenceError`.

---

## Reference Specs

- `docs/product/STUDENT_PRACTICE_AND_GRADING_DESIGN.md` (UX-006) §§6.1,
  6.2, 9
- `docs/product/HANDWRITTEN_GRAPH_CAPTURE_EXPERIENCE_DESIGN.md` (UX-008)
  §§7, 10
