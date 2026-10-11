"""Generate the load SQL for a batch of Lane A figures.

Writes `app.figure_families`, `app.figures` and `app.figure_uses` inserts from
specs.json. Generated, never hand-edited, for the same reason the reference-pack
loaders are: a hand-retyped row is a transcription error waiting to happen.

Two rules from the protocol are structural here, not advisory:

  §6  `figure_uses` resolves its entry by NATURAL KEY (subject, kind, title),
      never by a hardcoded reference_entry_id. Development and Production hold
      the same entries under different UUIDs, so an id baked in here would fail
      the foreign key in the other environment.
  §6  a guard raises if any figure ends up with no use, so a batch cannot ship
      dead rows that nothing will ever display.

Since DECISION-0115 a renderer family is a row rather than a CHECK constraint,
so the families this batch needs are inserted here too and the whole batch is a
content load rather than a schema change.

    python3 -I scripts/lane-a-pilot/build_load_sql.py --prefix stats- \
        --subject ap_statistics --out out/load_ap_statistics_figures.sql
"""
from __future__ import annotations

import argparse, json, pathlib, sys

HERE = pathlib.Path(__file__).resolve().parent

# The families this batch introduces, with where each one is implemented, so a
# family seeded without a renderer is findable rather than silently blank.
FAMILIES = {
    "categorical_bars": (
        "Categorical and binned bars",
        "Bar chart, histogram, side-by-side, segmented and mosaic, as five modes of one "
        "rectangle geometry. Separated bars for a categorical variable, contiguous bars for a "
        "quantitative one, and mosaic bar widths proportional to the category totals.",
    ),
    "pie_chart": (
        "Pie chart",
        "Slices whose angles are the relative frequencies and sum to exactly 360 degrees, "
        "drawn in a frame with no axes.",
    ),
    "dotplot": (
        "Dotplot",
        "One dot per observation, placed at its value and stacked where values repeat.",
    ),
    "stem_leaf": (
        "Stem-and-leaf plot",
        "Typography on a rule rather than a chart: stems and single-digit leaves, both ordered, "
        "with a key, reconstructing the original data exactly.",
    ),
    "xy_series": (
        "General x-y series",
        "Curves from explicit points, scatter, an optional shaded area under one curve and a zero "
        "line. Carries the PV diagram, electric potential around a circuit loop and the residual "
        "plot: different sciences, one geometry.",
    ),
    "kinematic_panels": (
        "Stacked kinematic panels",
        "Three panels sharing one time axis -- position, velocity and acceleration of a single "
        "motion -- with drawn tangents and shaded areas, because every labelled part of the entry "
        "is a relationship BETWEEN the panels.",
    ),
    "boxplot": (
        "Boxplot",
        "The five-number summary as a box from Q1 to Q3 with a median line, whiskers to the most "
        "extreme non-outliers, and outliers beyond the 1.5 IQR fences marked separately.",
    ),
}
RENDERER_NOTE = "scripts/lane-a-pilot/render.py; the app's figure renderer"

# Seeded by the TASK-0006 migration and already in both environments. A batch
# may reuse one without introducing it -- AP Physics 2's qualitative
# distribution is drawn by the chemistry batch's mb_distribution renderer.
PREEXISTING = {"mb_distribution", "energy_profile", "stick_spectrum",
               "pe_vs_distance", "approach_equilibrium", "titration_curve"}


def q(v) -> str:
    """SQL literal. None becomes NULL; strings are single-quote escaped."""
    if v is None:
        return "null"
    if isinstance(v, bool):
        return "true" if v else "false"
    if isinstance(v, (int, float)):
        return repr(v)
    return "'" + str(v).replace("'", "''") + "'"


def jq(v) -> str:
    return q(json.dumps(v, ensure_ascii=False)) + "::jsonb"


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--prefix", required=True)
    ap.add_argument("--subject", default=None,
                    help="single subject; omit when the batch spans subjects and each spec carries its own")
    ap.add_argument("--out", required=True)
    ap.add_argument("--batch", default=None, help="source_note batch tag")
    ap.add_argument("--entry-kind", default="diagram",
                    help="the kind of the reference entries these figures attach to")
    args = ap.parse_args()
    args.batch = args.batch or (args.prefix.split(",")[0].rstrip("-") + "-figures-2026-10-11")

    prefixes = tuple(x.strip() for x in args.prefix.split(",") if x.strip())
    specs = {k: v for k, v in json.load(open(HERE / "specs.json")).items()
             if k.startswith(prefixes)}
    if not specs:
        raise SystemExit(f"no specs with prefix {args.prefix!r}")

    fams = sorted({s["family"] for s in specs.values()})
    new_fams = [f for f in fams if f not in PREEXISTING]
    missing = [f for f in new_fams if f not in FAMILIES]
    if missing:
        raise SystemExit(f"no catalogue entry for families: {missing}")

    L = [f"-- Lane A figures for {args.subject}: generated by build_load_sql.py, do not hand-edit.",
         f"-- {len(specs)} figures across {len(fams)} families, from scripts/lane-a-pilot/specs.json.",
         "-- Entries are resolved by natural key, so this file is portable between environments.",
         "", "begin;", ""]

    L.append("-- 1. The renderer families this batch INTRODUCES (DECISION-0115: a row, not a CHECK).")
    L.append(f"-- Reused without introducing: {', '.join(sorted(set(fams) & PREEXISTING)) or 'none'}")
    for f in new_fams:
        title, summary = FAMILIES[f]
        L.append("insert into app.figure_families (family_key, title, summary, renderer_note)")
        L.append(f"values ({q(f)}, {q(title)}, {q(summary)}, {q(RENDERER_NOTE)})")
        L.append("on conflict (family_key) do nothing;")
    L.append("")

    L.append("-- 2. The figures.")
    cols = ("figure_id, subject_key, family, title, short_title, subtitle, caption, alt, "
            "x_label, y_label, note, synthetic, values_note, labels, params, y_tick_fmt, "
            "x_tick_fmt, status, source_note, published_at")
    for sid, s in specs.items():
        vals = ", ".join([
            q(sid), q(s.get("subject_key") or args.subject), q(s["family"]), q(s["title"]), q(s.get("short_title")),
            q(s.get("subtitle", "")), q(s.get("caption")), q(s["alt"]),
            q(s["x_label"]), q(s["y_label"]), q(s.get("note")),
            q(bool(s.get("synthetic", True))), q(s.get("values_note")),
            jq(s.get("labels", [])), jq(s["params"]),
            q(s.get("y_tick_fmt")), q(s.get("x_tick_fmt")),
            "'published'", q("cramapple-authored; batch=" + args.prefix.rstrip("-") +
                             "-figures-2026-10-11"), "now()",
        ])
        L.append(f"insert into app.figures ({cols})")
        L.append(f"values ({vals})")
        L.append("on conflict (figure_id) do nothing;")
    L.append("")

    L.append("-- 3. Where each figure is shown, resolved by natural key (protocol §6).")
    for sid, s in specs.items():
        L.append("insert into app.figure_uses (figure_id, reference_entry_id, role)")
        L.append(f"select {q(sid)}, e.reference_entry_id, 'primary'")
        L.append("  from app.unit_reference_entries e")
        L.append(f" where e.subject_key = {q(s.get('subject_key') or args.subject)} "
                 f"and e.kind = {q(s.get('entry_kind', args.entry_kind))}")
        L.append(f"   and e.title = {q(s['entry_title'])} and e.status = 'published'")
        # The unique index is PARTIAL (`where reference_entry_id is not null`,
        # because the question target is nullable), so the conflict target has
        # to repeat that predicate or Postgres cannot match the index.
        L.append("on conflict (figure_id, reference_entry_id) "
                 "where reference_entry_id is not null do nothing;")
    L.append("")

    ids = ", ".join(q(k) for k in specs)
    L += [
        "-- 4. Guards: no dead figure, and every entry this batch covers got its figures.",
        "do $$",
        "declare v_dead text; v_n int;",
        "begin",
        f"  select string_agg(f.figure_id, ', ') into v_dead",
        f"    from app.figures f left join app.figure_uses u on u.figure_id = f.figure_id",
        f"   where f.figure_id in ({ids}) and u.figure_id is null;",
        "  if v_dead is not null then",
        "    raise exception 'figures with no use, refusing to ship dead rows: %', v_dead;",
        "  end if;",
        f"  select count(*) into v_n from app.figures where figure_id in ({ids});",
        f"  if v_n <> {len(specs)} then",
        f"    raise exception 'expected {len(specs)} figures, found %', v_n;",
        "  end if;",
        "end $$;",
        "",
        "commit;",
        "",
    ]

    subs = sorted({sp.get("subject_key") or args.subject for sp in specs.values()})
    if any(x is None for x in subs):
        raise SystemExit("a spec has no subject_key and --subject was not given")
    out = HERE / args.out
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text("\n".join(L))
    print(f"wrote {out.relative_to(HERE.parent.parent)}: {len(specs)} figures, "
          f"{len(new_fams)} new families ({', '.join(new_fams) or 'none'}); subjects: {', '.join(subs)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
