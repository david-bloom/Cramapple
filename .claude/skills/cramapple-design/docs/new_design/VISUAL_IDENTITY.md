# Cramapple Visual Identity — canonical

Supersedes `docs/product/CRAMAPPLE_VISUAL_IDENTITY_BRIEF.md` and `..._v2.md`. See `README.md` in this folder for what changed and why.

**The plate.** Every template is a fixed 1440×900 frame that never scrolls and never has a collapsed region. `overflow: hidden` at the frame, a 70px orange masthead, a 48px breadcrumb bar, then a three-column grid — 352px / fluid / 324px with 20px gaps inside 40px gutters — and a single 10px caption line at the bottom. **Content is sized to fit; it is never made reachable by scrolling or expanding.** If something does not fit, cut copy or restructure the layout. This is a hard rule and the most common way to break the system.

**Corners are square.** Radius 0 on every surface — panes, cards, buttons, chips, inputs. The only round thing in the product is a radio dot. Do not introduce rounded cards.

**Panes are capped, not tinted.** Each pane is white with a 1px `--rule-300` border and a 3px colored top rule that names its voice: blue for the rubric/answer key, green for reference materials, yellow for a hint pane, purple for the student's work, teal for the deep dive. The question pane is not capped — it is outlined in 2px brand orange, which is what makes it read as the primary surface. Pane shadow is `--shadow-pane`; the question pane carries the slightly heavier `--shadow-section`.

**Color is assignment, not decoration.** Five voices, each with one job:

| Voice | Owns |
| --- | --- |
| Orange `--orange-600` | Masthead, active breadcrumb, the one primary button per screen. Never used for error. |
| Blue `--blue-600` | Rubric, points earned, credited answers, ✓ marks. |
| Green `--green-500` | Reference materials only. |
| Yellow `--yellow-500` | Hints only. Every yellow surface costs the student something. |
| Purple `--purple-600` | The student's own work: answer field, options, feedback, deep dive. |

Maroon `--maroon-600` #8a2f3f carries points lost, incorrect verdicts and eliminated options — cool enough never to be read as the brand orange, because a lost point is a correction and not an alarm. Clay `--clay-600` #8c4530 is the ↻ revisit mark: come back to this, the point is still available. Amber is gone — the warm lane is now brand orange only. Teal appears only as one accent rule inside the deep dive.

**Type.** Bungee is the wordmark and nothing else. Passion One sets pane titles, scores and overlay titles at 22–32px; it is used at display sizes only, never for prose. Source Sans 3 does all reading and all controls. STIX Two Math is reserved for set mathematics. **Body copy never goes below 16px** — chrome (breadcrumb 13px, counts 12px, eyebrows 12px, the plate caption 10px) is the only exception, and never for content a student must read to answer. Eyebrows are 12px, 700 weight, uppercase, `.15em` tracking.

**Backgrounds and imagery.** Paper white plates on a `--paper-100` desk; chrome bars in `--paper-050`. Graphics are the question's own data — a scatterplot, a table — drawn as inline SVG on a `--purple-tint-05` field with a `--purple-rule` border, axis labels in `--purple-500`. Influence points and other called-out marks are yellow. There is no photography, no illustration, no gradient, and no texture anywhere in the product.

**Depth and transparency.** Shadows are wide, soft, and low-opacity (`0 12px 30px rgba(20,40,50,.07)`), read as paper lift rather than elevation levels. The feedback card is the one purple-cast shadow. Transparency appears only as flat color tints (`--purple-tint-06`) and the modal scrim (`--scrim`); there is no blur, no glass, no protection gradient.

**States.** Selection is a 2px purple border plus a filled radio dot plus a bolder label — never a background wash. Disabled is a desaturated fill (`--action-primary-disabled`) with `cursor: not-allowed`, not opacity. Eliminated/struck content is maroon ink with a line-through and ~55% opacity. Hover darkens a fill by one step (`--action-primary-bg-hover`) and does nothing else — no lift, no shadow change. Press has no separate treatment. Secondary actions are underlined text links (3px underline offset), never outlined buttons. Quiet actions are white with a `--rule-400` border and `--ink-500` label. There is no motion in the system: no transitions, no fades, no bounces, no easing. State changes are instant, because the product's rhythm is read-decide-see.

**Overlays.** Two, both square-cornered and both full-bleed within their region: the study map drops under the breadcrumb across the full width over a `--scrim`; the deep dive covers the entire frame below the breadcrumb (all three panes) — it must be full-frame, because at the center pane's ~664px it cannot fit its content without scrolling.

## The mark

**The name, set in Bungee, IS the mark.** Use the `Wordmark` component; never retype it by hand, because the ink changes with the ground and that is the part people get wrong:

| Ground | Ink | Token |
| --- | --- | --- |
| Brand orange `--orange-600` (the masthead) | White | `--wordmark-on-brand` |
| White or paper | `--orange-700` #ca3500 | `--wordmark-on-light` |
| `--ink-900`, or a solid plate over imagery | White | `--wordmark-on-dark` |
| Print, mono, low-fidelity output | `--ink-900` | `--wordmark-mono` |

**#ca3500 is the only orange dark enough to be ink.** `--orange-500` #ff6900 reads about 2.3:1 on white and `--orange-600` #f54900 about 3.5:1 — both fail as type on a light ground, even at display size. On photography or any busy ground, set the white wordmark on a solid `--orange-600` or `--ink-900` plate rather than directly on the image; there is no outline, scrim or shadow treatment for the mark.

Never: shadow it, outline it, stack it over two lines, letter-space it beyond `--type-wordmark-tracking`, set it in two colours, put it in a box or a circle, or set it below 16px.

### About an actual logo

There isn't one, and I won't invent it — a drawn apple, a monogram or anything else I produced would be a guess that consumers of this system would then treat as the brand. A type-set wordmark is a legitimate permanent answer (it is what ships today and it works at every size), so the decision is genuinely open:

- **Keep the wordmark as the mark.** No further work; it is already tokenised for every ground.
- **Commission or supply a mark.** Drop the files into `assets/logo.svg` (plus a mono variant) and tell me the clear-space and minimum-size rules; I will wire it into `Wordmark` as a lockup, replace the masthead's type, and rebuild the project tile. An SVG with the type as outlines is ideal — it removes the Bungee webfont dependency from the mark.

Until a file exists, every `Wordmark` call renders type, and that is the correct behaviour rather than a placeholder.

## Iconography

There is no icon library in the product and none should be added. The system uses three things:

1. **Typographic glyphs** for status and navigation: ✓ (credit), ✕ (take the point — Open Hand only), ↻ (revisit), ? (hint), ▸ ▼ (disclosure), ⌂ (home), · (separator), — (no score yet).
2. **Two 24×24 stroke SVGs**, inline, `stroke-width` 1.9, round caps, `currentColor`: a camera (attach hand-drawn work, used in `AnswerField`) and a copy/duplicate mark (copy the deep dive, used in `DeepDiveOverlay`). They also live as files in `assets/icons/`. **These two are reconstructions from the written style guide, not the original files** — the source SVGs were not supplied. Replace them if the originals exist.
3. **Data SVG** — the question's chart, drawn per question from coordinates. No chart library.

If a genuine icon need appears, match that inline stroke style (1.9–2px, round caps, `currentColor`, 24px box) rather than importing a set. No emoji. No PNG icons exist.

## Fonts

Bungee, Passion One, Source Sans 3 and STIX Two Math are loaded from Google Fonts by `tokens/fonts.css`. No binaries were supplied, so no local `@font-face` rules ship with this system and the compiler reports zero bundled fonts — consumers get the families over the network. If the brand has licensed files, drop them into `assets/fonts/` and swap the `@import` for real `@font-face` rules.