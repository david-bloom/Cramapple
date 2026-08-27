# Lovable Build Brief — Session parameters + progress bar on the running session

STATUS: build brief (sent 2026-08-26) | TARGET: `exam-buddy-wireframe` (Lovable project
`d334fed9-5a97-4e76-906e-7c0ad7082212`) | TASK: `docs/tasks/TASK-0030`.

## The ask (David, 2026-08-26)

On the session question pages (the running session serving MCQ or FRQ items), show the
student **the parameters of their session** and **a progress bar**, and let them **edit
the session if they choose** — inline, per the §3.1 decision ("changeable defaults are
surfaced inline on `/session` — an unobtrusive, adjustable line the student can tweak
in-flow — not on a separate config screen").

## Integration target (pinned)

- The live session is `/session`: `session.index.tsx` → `SessionFrame.tsx` →
  `SessionShell.tsx` / `use-session.ts`. It renders MCQ, short-FRQ, and long-FRQ items,
  so one implementation covers both "mcq" and "frq". Do **not** touch the legacy
  `_ux.session.mcq` / `_ux.session.frq` routes.
- Everything needed already exists in state: the `SessionContract`
  (`mode`, `availableMinutes`, `selectedUnit`, `selectedTopicIds`, `entryPath`),
  `questionIndex` / `questionTotal` (via `useSession`), the pinned display index from
  `progressLabel()` (`confirm-transfer.ts`), `setAvailableMinutes`, and the
  `onChangeTopic` action. Frontend-only; no backend, no Lovable Cloud, no `.env` change.

## The job

1. **Session-parameters line** in the session header (SessionShell Region 1), unobtrusive,
   e.g. `Quick · ~10 min · Unit 1 · Comparing distributions`:
   - Length mode label (Quick / Focused / Buckle Down) + minutes, **estimate-qualified**
     ("~10 min"), from the contract.
   - Scope: `Unit N` plus the **plain-language topic name(s)** resolved from the taxonomy
     data (never a bare skill/letter code — INV-1; a topic code like "1.1" must render as
     its name, falling back to `Unit N` alone if no label resolves). For
     `entryPath: "recommendation"` with no unit, say something honest like
     "Your top-priority skills".
2. **Items-primary progress bar** alongside/below the existing "Question k of N" text:
   - Fill = counted items completed ÷ `questionTotal`, driven by the **same pinned index**
     `progressLabel()` uses — teach and confirm-transfer sub-beats must NOT advance it
     (the meter stays on "k of N" through both attempts of a counted item).
   - Keep the "Question k of N" text; the bar is visual reinforcement.
   - **Never a time-based bar, countdown, or "~N min remaining"** — timers are banned on
     the session (hard constraint). Accessible: `role="progressbar"`,
     `aria-valuenow/-valuemin/-valuemax`, and a text alternative.
3. **Inline edit affordance** on the params line (e.g. an "Adjust" control / the line
   itself opens a small popover) exposing the **existing** actions:
   - Change available minutes (reuse `setAvailableMinutes`; "this session only" wording
     as today).
   - Change topic or question type (the existing `onChangeTopic` action, unchanged).
   - End session (existing).
   Promote these from the hamburger menu to this visible affordance; avoid duplicate
   competing controls (fold the hamburger's session items into it or keep one source —
   your call, but one clear home). Keyboard accessible, Escape closes, focus returns.
4. **Mobile:** the params line truncates/wraps gracefully and the bar stays visible;
   nothing may push the answer control off-screen.

## Do not do

- No countdown timer, no time-remaining display, no time-based progress (items-primary
  only).
- No projected score, no miss/failure counters.
- No new backend calls, schema, or Lovable Cloud; no change to grading/serving calls.
- No changes to the confirm-transfer state machine or queue advancement — read the
  pinned index, don't alter it.
- Don't touch the legacy `_ux.session.*` routes or the first-run `/setup` wizard.
- Do not publish/deploy — the owner republishes himself.

## Validation

- Vitest: bar value pinned (unchanged) while a confirm-transfer sub-beat is on screen;
  advances exactly once when the counted item resolves; a11y attributes present.
- Build green, existing tests pass.

## Completion output

Report: (a) components changed; (b) how the params line renders for each entryPath
(recommendation / self-guided) and where topic names come from; (c) how the bar derives
its value and how sub-beat pinning is guaranteed; (d) what happened to the hamburger
menu; (e) a preview link.
