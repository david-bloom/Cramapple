# LaTeX prose pilot validator (TASK-0073, DECISION-0121)

`validate.mjs` checks drafted prose-maths edits. The drafting step never rewrites prose: it states which exact
span of the original becomes which LaTeX, and this script builds the edited text, so nothing outside the maths
can change.

    npm install            # katex only
    node validate.mjs records.json validated.json

Hard failures (exit 1): LaTeX does not parse, `$` or a bare `|` in the LaTeX, `find` not in the original,
overlapping spans, a display span that is not on its own line, an edit that is not stacked. A `roundtripFlag` is
not a failure; it means the paren-free form of the LaTeX differs from the original span, which usually means a
changed digit or sign and needs a human look.

Record files hold published question text and answer keys. Do not commit them to this public repository.
