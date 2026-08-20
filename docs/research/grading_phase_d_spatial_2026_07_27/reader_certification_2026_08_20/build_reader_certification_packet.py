#!/usr/bin/env python3
"""
Build a reader-certification packet for the DECISION-0045 false-accept-rate audit.

Produces, per subject, a COLD packet a qualified human reader can work through with
zero access to gold/grader/verifier output:
  <subject>/packet/images/<OPAQUE_ID>.<ext>   selected photos, renamed to opaque IDs
                                              (real filenames leak archetype via CAT/SER/EST)
  <subject>/packet/index.html                 viewer: each photo + its question + rubric
  <subject>/packet/reader_worksheet.csv       fill-in grid (present/absent per criterion)
  <subject>/packet/READER_INSTRUCTIONS.md
  <subject>/<subject>_scoring_key.hidden.json  ANSWER KEY — kept OUTSIDE packet/, never shown to reader
  <subject>/selection_manifest.json            how the sample was drawn (auditable)

Deterministic: selection and opaque-ID assignment are seeded by sha256 of stable
fields, no RNG — rerunning reproduces the identical packet.

Nothing here changes any gold. Images are COPIED, originals untouched.
"""
import json, os, csv, hashlib, shutil, html

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "..", ".."))
OUT_ROOT = os.path.dirname(__file__)

WEAK_BIO = {"UNCERTAINTY_MARKS", "X_SCALE", "ZERO_INTERCEPT_ANNOTATION", "Y_SCALE", "PLOT_VALUES"}

SUBJECTS = {
    "biology": {
        "gold": "docs/research/hand_drawn_graph_real_photo_benchmark_2026_08_18/gold/real_photo_gold_labels_2026_08_18.json",
        "corpus": "docs/research/hand_drawn_graph_corpus_2026_06_29/hand_drawn_graph_questions_2026_06_29.jsonl",
        "stem_key": "stem",
        "sample_size": 100,        # stratified by archetype, over-weight weak-criterion negatives
        "weak_criteria": WEAK_BIO,
        "opaque_prefix": "BIO",
    },
    "statistics": {
        "gold": "docs/research/apstats_hdg_graph_real_photo_smoke_2026_08_19/gold/apstats_smoke_gold_labels_2026_08_19.json",
        "corpus": "docs/research/apstats_hdg_graph_corpus_2026_08_18/apstats_hdg_graph_questions_2026_08_18.jsonl",
        "stem_key": "student_prompt",
        "sample_size": None,       # None = whole corpus (28 photos)
        "weak_criteria": set(),
        "opaque_prefix": "STAT",
    },
}

ARCH_SHORT = {
    "categorical_comparison_supplied_uncertainty": "CAT",
    "continuous_measured_series_supplied_uncertainty": "SER",
    "continuous_relationship_graph_derived_estimate": "EST",
}


def sha(s):
    return hashlib.sha256(s.encode()).hexdigest()


def load_corpus(path):
    by_id = {}
    for line in open(os.path.join(ROOT, path)):
        if line.strip():
            r = json.loads(line)
            by_id[r["item_id"]] = r
    return by_id


def archetype_of(entry, corpus):
    a = corpus.get(entry["item_id"], {}).get("archetype")
    return ARCH_SHORT.get(a, a or "UNK")


def select_biology(gold, corpus, size, weak):
    # Archetype quotas proportional to corpus share, summing exactly to `size`.
    from collections import defaultdict
    buckets = defaultdict(list)
    for e in gold:
        buckets[archetype_of(e, corpus)].append(e)
    total = len(gold)
    archs = sorted(buckets)
    raw = {a: len(buckets[a]) / total * size for a in archs}
    quota = {a: int(raw[a]) for a in archs}
    # distribute rounding remainder to the largest fractional parts
    rem = size - sum(quota.values())
    for a in sorted(archs, key=lambda a: raw[a] - int(raw[a]), reverse=True)[:rem]:
        quota[a] += 1

    selected = []
    for a in archs:
        # weak-negative count = # weak criteria this photo's gold marks not_earned
        # (the FAR-measurable cases); higher = more audit power. Tie-break by stable hash.
        def rank(e):
            cs = e.get("criterion_statuses", {})
            neg = sum(1 for c in weak if cs.get(c) == "not_earned")
            return (-neg, sha(e["file_path"]))
        ordered = sorted(buckets[a], key=rank)
        selected.extend(ordered[: quota[a]])
    return selected, quota


def build(subject, cfg):
    gold = json.load(open(os.path.join(ROOT, cfg["gold"])))
    corpus = load_corpus(cfg["corpus"])
    subj_dir = os.path.join(OUT_ROOT, subject)
    pkt = os.path.join(subj_dir, "packet")
    img_dir = os.path.join(pkt, "images")
    os.makedirs(img_dir, exist_ok=True)

    if cfg["sample_size"] is None:
        selected = list(gold)
        quota = {"ALL": len(selected)}
    else:
        selected, quota = select_biology(gold, corpus, cfg["sample_size"], cfg["weak_criteria"])

    # Opaque IDs assigned in hash order so ordering can't leak the selection ranking.
    selected_sorted = sorted(selected, key=lambda e: sha(e["file_path"] + "salt"))
    key = {}          # opaque_id -> full truth (hidden)
    worksheet_rows = []
    html_cards = []
    for i, e in enumerate(selected_sorted, 1):
        oid = f"{cfg['opaque_prefix']}-{i:04d}"
        ext = os.path.splitext(e["file_path"])[1].lower()
        dst_name = f"{oid}{ext}"
        shutil.copyfile(e["file_path"], os.path.join(img_dir, dst_name))

        item = corpus.get(e["item_id"], {})
        stem = item.get(cfg["stem_key"]) or item.get("student_prompt") or item.get("stem") or ""
        crit_defs = item.get("criterion_definitions", [])
        # rubric shown = criterion_id + met_rule ONLY (cold format)
        rubric = [(c["criterion_id"], c.get("met_rule", "")) for c in crit_defs]

        key[oid] = {
            "item_id": e["item_id"],
            "real_file": os.path.relpath(e["file_path"], ROOT),
            "archetype": archetype_of(e, corpus),
            "gold_criterion_statuses": e.get("criterion_statuses", {}),
        }
        for cid, rule in rubric:
            worksheet_rows.append({
                "photo_id": oid, "criterion_id": cid,
                "criterion_rule": rule, "reader_mark_present_or_absent": "",
                "reader_notes": "",
            })

        crit_html = "".join(
            f"<tr><td class='cid'>{html.escape(cid)}</td><td>{html.escape(rule)}</td>"
            f"<td class='mark'>&#9744; present &nbsp; &#9744; absent</td></tr>"
            for cid, rule in rubric)
        html_cards.append(
            f"<section><h2>{oid}</h2>"
            f"<img src='images/{html.escape(dst_name)}' alt='{oid}'>"
            f"<p class='stem'><b>Question shown to the student:</b> {html.escape(stem)}</p>"
            f"<table><thead><tr><th>Criterion</th><th>What counts as met</th><th>Your mark</th></tr></thead>"
            f"<tbody>{crit_html}</tbody></table></section>")

    # write worksheet
    with open(os.path.join(pkt, "reader_worksheet.csv"), "w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=["photo_id", "criterion_id", "criterion_rule",
                                          "reader_mark_present_or_absent", "reader_notes"])
        w.writeheader()
        w.writerows(worksheet_rows)

    # write viewer html
    style = ("body{font-family:system-ui,sans-serif;max-width:900px;margin:2rem auto;padding:0 1rem}"
             "section{border-top:2px solid #ccc;padding:1.5rem 0}img{max-width:100%;border:1px solid #ddd}"
             "table{border-collapse:collapse;width:100%;margin-top:.75rem}"
             "td,th{border:1px solid #ccc;padding:.4rem .6rem;text-align:left;vertical-align:top;font-size:.9rem}"
             ".cid{font-family:monospace;white-space:nowrap}.mark{white-space:nowrap}.stem{background:#f6f6f6;padding:.6rem}")
    with open(os.path.join(pkt, "index.html"), "w") as f:
        f.write(f"<!doctype html><meta charset=utf-8><title>{subject} reader certification</title>"
                f"<style>{style}</style><h1>{subject.title()} — reader certification packet</h1>"
                f"<p>{len(selected_sorted)} photos. For each criterion mark <b>present</b> or "
                f"<b>absent</b> based only on the photo and the rule. Record your marks in "
                f"<code>reader_worksheet.csv</code>. Do not score points or totals.</p>"
                + "".join(html_cards))

    # hidden key OUTSIDE packet
    json.dump(key, open(os.path.join(subj_dir, f"{subject}_scoring_key.hidden.json"), "w"), indent=1)

    # selection manifest (auditable, no gold)
    manifest = {
        "subject": subject, "n_selected": len(selected_sorted),
        "corpus_total": len(gold), "archetype_quota": quota,
        "weak_criteria_overweighted": sorted(cfg["weak_criteria"]),
        "cold_format": "photo + criterion_id/met_rule only; no gold/grader/verifier output; opaque IDs hide archetype",
        "selection_rule": ("whole corpus" if cfg["sample_size"] is None else
                           "archetype quotas proportional to corpus share; within archetype, "
                           "rank by weak-criterion not_earned count (FAR power), tie-break sha256(file_path)"),
        "photo_ids": sorted(key.keys()),
    }
    json.dump(manifest, open(os.path.join(subj_dir, "selection_manifest.json"), "w"), indent=1)

    # reader instructions
    open(os.path.join(pkt, "READER_INSTRUCTIONS.md"), "w").write(READER_MD.format(
        subject=subject.title(), n=len(selected_sorted)))

    print(f"{subject}: {len(selected_sorted)} photos, {len(worksheet_rows)} criterion rows, quota={quota}")


READER_MD = """# {subject} — reader certification instructions

You are certifying an answer key by independently judging **{n} real hand-drawn graph photos**.

## What to do
1. Open `index.html` in a browser (or open the images in `images/` alongside this sheet).
2. For **each criterion** of each photo, decide from the **photo and the stated rule only**
   whether that element is **present** or **absent** in the student's drawing.
3. Record your decision in `reader_worksheet.csv`, column
   `reader_mark_present_or_absent` — type `present` or `absent`. Add a note if unsure.

## Rules
- Judge **only** what you see against the rule. Do **not** award points or a total.
- You are **not** shown any machine grade, any prior label, or the "right" answer — that is
  deliberate. Your independent judgment is the whole point.
- If a photo is too unclear to judge a criterion, mark `absent` and note "illegible".

When you finish, return `reader_worksheet.csv`. Scoring (false-accept rate + 95% bound) is
computed separately against the held-back key.
"""


if __name__ == "__main__":
    for subject, cfg in SUBJECTS.items():
        build(subject, cfg)
