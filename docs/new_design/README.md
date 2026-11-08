# Cramapple Design System — canonical

**Status: approved direction. This folder supersedes the earlier visual identity briefs.**

> **CORRECTION (2026-09-27): the no-scroll plate is SUPERSEDED — the frame is now responsive.**
> The "Decided" bullet and the "The plate vs. page length" section below record the state as of
> 2026-09-21 ("no-scroll plate stays for now"). On **2026-09-26 David decided go responsive**
> (`docs/product/LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md`, "DECIDED, 2026-09-26" #1); implemented in
> Lovable `56cae479` commit `44a0f59e` and verified 2026-09-27. Everything else in this folder
> (orange/light palette, square corners, zero motion, type stack, the two plate templates) remains
> CURRENT. Canonical current summary: `docs/product/ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md`
> (row D3).

Per `docs/README.md` authority order, this is a canonical product document. It replaces:

- `docs/product/CRAMAPPLE_VISUAL_IDENTITY_BRIEF.md` (v1)
- `docs/product/CRAMAPPLE_VISUAL_IDENTITY_BRIEF_v2.md` (v2)

Both are retained as historical inputs only. Where they conflict with this folder, this folder wins.

## What changed from v2, and why

v2 specified warm forest/emerald green, Plus Jakarta Sans with a JetBrains Mono student voice, a dark-first palette, and gold for full marks. The system that was actually built and validated against the four working question templates went a different way on every one of those:

| Dimension | v2 brief | Built system |
| --- | --- | --- |
| Brand colour | Warm emerald green (`#1A8A4A` / `#36D47D`) | Brand orange (`#f54900`, `#ca3500` for ink) |
| Surface | Dark-first, green-tinted near-black | Light paper plates on a warm grey desk |
| Type | Plus Jakarta Sans + JetBrains Mono | Bungee (wordmark), Passion One (display), Source Sans 3 (all reading); equations render in KaTeX |
| Full marks | Gold (`#F5B942` / `#C17A10`) | Green, the `--full-*` scale (`--full-600` `#2b7a24`), decided 2026-11-08. Blue `--blue-600` still owns every other earned point |
| Corners | Unspecified | Square everywhere; radius 0 |
| Motion | Unspecified | None at all |

Two v2 decisions **survive and are load-bearing here**: colour carries semantic meaning in feedback rather than decoration (v2's "Color" section) and the student's own work is visually separated from the system's voice (v2 used mono for this; the built system uses the purple voice). The warm-precision lane survives too — orange is warm, and the plate is calm.

What v2 called for and this system deliberately does **not** have: a dark mode. **Retired 2026-09-21 (David).** The plate is light-only, and that is a decision rather than a gap — do not add one by inverting the tokens, because the voice colours do not survive inversion. If late-night comfort needs addressing later, it should be a warmer paper ramp, not a dark theme.

## The system in one paragraph

A student works one question at a time inside a fixed 1440×900 three-pane plate: how it is scored on the left, the question and their own work in the centre, what they may look up on the right. Every question type exists in two modes — **Open Hand** (rubric face-up and manipulable, nothing scored) and **Practice** (scoring withheld behind hints that cost something, the student's work scored). Colour is an assignment, not decoration: five voices, each owning exactly one job.

## Files

| File | What it is |
| --- | --- |
| `VISUAL_IDENTITY.md` | Canonical visual foundations — plate, colour voices, type, states, overlays, the mark. Replaces v1/v2. |
| `CONTENT_AND_PEDAGOGY.md` | Voice, copy rules, and the pedagogy rules that are design rules (the hint economy, the mark vocabulary). |
| `COMPONENT_INVENTORY.md` | The nine component families and five screens, with what each one is for. |
| `TOKENS.md` | The token contract — what exists, what it means, what not to do. |
| `HANDOFF.md` | How to wire this into Lovable, Cursor, Claude Code or a React app. |
| `tokens/`, `styles.css` | The implementation. Plain CSS custom properties, no build step. |

The full system — components, UI kits, specimen cards — lives in the design-system project and is downloadable as a zip. This folder is the durable record of the decisions.

## Decided

- **Full marks are green** (2026-11-08, David; `DECISION-0131`). Not gold, not blue. The `full-*` scale is a yellower green than the cooler reference green (`--green-500`), and the two never share a component. It appears only at the maximum score and always sits beside a ✓ and the words "Full marks", so the colour is never the only signal. Any score short of the maximum stays blue (earned) and maroon (lost). Tokens: `--full-050…700`, `--text-full-marks`, `--surface-full-marks`, `--border-full-marks`, `--chip-full-marks-bg`.
- **Wordmark only, permanently** (2026-11-08, David). There is no logo and none is to be drawn.
- **Type stack confirmed** (2026-11-08, David), read from the live pages cramapple.com (marketing) and app.cramapple.com (app): Bungee 400 for the wordmark, Passion One 700 for headings, Source Sans 3 400/600/700 for body and controls.
- **Every equation is KaTeX** (2026-11-08, David; restates the 2026-10-12 amendment, `DECISION-0119`). STIX Two Math remains only for set-notation glyphs in prose.
- **One system for every subject** (2026-11-08, David). AP Statistics Unit 2 is the sample content the plates were validated against, not a limit on the system. A subject never gets its own hue, type or layout.
- **The name is written "Cramapple"** (2026-11-08, David), initial capital then lower case, including the browser tab title (`Question | Cramapple`).
- **Dark mode: retired** (2026-09-21, David). Light-only. Supersedes v2's dark-first requirement.
- **The no-scroll plate stays for now** (2026-09-21, David) — held as-is to see how it plays out under real content, with the page-length question explicitly open. See "The plate vs. page length" below. **[SUPERSEDED 2026-09-26: go responsive — see CORRECTION at top.]**

## Open items needing a David decision

1. **Full-marks versus reference green.** They are one family, split by hue and by rule. If they read as too close in real screens, separate them further.
2. **AP Biology.** Its FRQs are longer and its stimulus is diagrammatic; the plates have not been tested against that yet.

## The plate vs. page length

The system's hardest rule is that a plate is fixed at 1440×900 and never scrolls: content is sized to fit, and if it does not fit, copy gets cut. That rule is doing real pedagogical work — the rubric, the question and the reference material stay simultaneously visible, which is the product's whole argument.

**It is also in tension with a finding David raised: students avoid clicking, so longer scrolling pages perform better than paginated ones.** Both can be true — the finding is about navigation cost across a session, while the no-scroll rule is about a single question being apprehensible at a glance.

Held as-is for now, deliberately, to see how it behaves under real AP Biology content. The failure mode to watch for is a plate that only fits because the copy was cut below what a student actually needs — at which point the rule is costing more than it earns. Two directions if that happens, neither designed yet:

- **Scroll the centre pane only.** The scoring and reference panes stay pinned; the question and the student's work scroll. Cheapest change, preserves the argument, breaks the "no scrolling inside a plate" rule in exactly one place.
- **Let the plate become a page.** The three panes reflow to a single column with the rubric pinned. This is a genuinely different design, not a tweak, and would need the fixed-frame components (`Plate`, `PlateGrid`) reworked.

Revisit once Biology content exists. Do not let individual screens quietly start scrolling in the meantime — that is how a system loses a rule without deciding to.
