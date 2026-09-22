# Handoff — using this design system in other tools

Three layers, in order of how well they travel.

## 1. Tokens — `styles.css` + `tokens/`

Plain CSS custom properties. No build step, no preprocessor, no dependencies. Roughly 200 properties.

**Lovable / Vite / Next.js:** copy `tokens/` and `styles.css` into `src/`, then import once at the app root:

```js
import './styles.css';
```

**Tailwind:** point the theme at the variables rather than duplicating hex values, so there is one source of truth:

```js
// tailwind.config.js
theme: { extend: { colors: {
  brand:   'var(--orange-600)',
  earned:  'var(--blue-600)',
  lost:    'var(--maroon-600)',
  revisit: 'var(--clay-600)',
  hint:    'var(--yellow-500)',
  work:    'var(--purple-600)'
}, borderRadius: { none: '0px' } } }
```

Always consume the semantic aliases (`--text-earned`, `--surface-hint`, `--action-primary-bg`) rather than the raw scales (`--blue-600`, `--yellow-050`). The aliases are the contract; the scales are implementation.

## 2. The briefs — paste into the tool's knowledge field

`VISUAL_IDENTITY.md` and `CONTENT_AND_PEDAGOGY.md` are written to be pasted into Lovable's Knowledge, a Cursor rules file, or a `CLAUDE.md`. They are prose rules with specific values, not screenshots — which is what these tools act on reliably.

Minimum viable prompt preamble if you only have room for a paragraph:

> Square corners everywhere (radius 0). No motion, no transitions. Body text never below 16px. Colour is an assignment: orange #f54900 is brand chrome and the single primary action, blue #1f56a8 is rubric and points earned, green #2f9c67 is reference material only, yellow #edb90d is hints only and always costs the student something, purple #5f43ba is the student's own work, maroon #8a2f3f is points lost and incorrect, clay #8c4530 is the ↻ revisit mark. No emoji. A missed point is ↻, never ✕.

## 3. Components — 19 React components

Plain `.jsx`, React import only, no npm packages and no CSS-in-JS. They drop into `src/components/` and work as-is. Each ships a `.d.ts` props contract and a `.prompt.md` stating what it is and when to use it — feed the `.prompt.md` files to an agent and it will compose them correctly.

Do not re-implement `Button` inside a screen; `ActionButton` already carries the four treatments.

## Gotchas

- **Fonts load from Google Fonts** (`tokens/fonts.css`). If the network is blocked the wordmark falls back to system sans. Self-host the four families for production.
- **The plate is fixed at 1440×900 and must not scroll.** If a port introduces a scrollbar inside a plate, the port is wrong, not the content. Cut copy or restructure.
- **Light-only, by decision.** Dark mode was retired 2026-09-21; do not invent one by inverting the tokens — the voice colours will not survive it.
