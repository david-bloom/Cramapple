#!/usr/bin/env python3
"""
Render synthetic hand-drawn-style (xkcd) trace images for HDR (hand-drawn-response)
FRQ items, at three quality tiers per item: fully_correct, partially_correct,
subtly_wrong. Also emits a gold_labels.jsonl with per-criterion earned/not_earned
labels for each rendered image, matching the item's `criteria` array.

Usage:
    python3 render_hdr_traces.py <export_json_path> <out_dir> <content_key_prefix>
"""
import json
import os
import sys
import random

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

random.seed(20260707)

TIERS = ["fully_correct", "partially_correct", "subtly_wrong"]


def crit_labels(criteria, not_earned_keys):
    return {c["criterion_key"]: ("not_earned" if c["criterion_key"] in not_earned_keys else "earned")
            for c in criteria}


def find_group_col(row):
    for k in row:
        if not isinstance(row[k], (int, float)):
            return k
    return None


def norm(s):
    return "".join(ch for ch in s.lower() if ch.isalnum())


def match_axis_col(row_keys, axis_label):
    """Match a stimulus_table column name to an expected_graph_spec axis label,
    since jsonb key order is alphabetical, not semantic (x/y are NOT positional)."""
    target = norm(axis_label)
    best, best_score = None, -1
    for k in row_keys:
        nk = norm(k)
        score = 0
        if nk == target:
            score = 100
        elif nk in target or target in nk:
            score = 50
        else:
            # token overlap fallback
            score = len(set(axis_label.lower().split()) & set(k.lower().split()))
        if score > best_score:
            best_score, best = score, k
    return best


# ---------------------------------------------------------------- boxplot ----
def render_boxplot(ax, pj, tier):
    stim = pj["stimulus_table"]
    spec = pj["expected_graph_spec"]
    group_col = find_group_col(stim[0])
    groups = [r[group_col] for r in stim]
    stats = [(r["Min"], r["Q1"], r["Median"], r["Q3"], r["Max"]) for r in stim]

    scale_shift = 0
    swap_q_for_group = None
    if tier == "partially_correct":
        swap_q_for_group = 1  # second group gets Q1/Q3 swapped (malformed box)
    elif tier == "subtly_wrong":
        scale_shift = 1  # second group plotted on a shifted/inconsistent scale

    positions = [1, 2]
    for i, (mn, q1, med, q3, mx) in enumerate(stats):
        pos = positions[i]
        if swap_q_for_group == i:
            q1, q3 = q3, q1
        offset = scale_shift * 15 if i == 1 else 0
        mn, q1, med, q3, mx = mn + offset, q1 + offset, med + offset, q3 + offset, mx + offset
        box = ax.boxplot(
            [[mn, q1, med, q3, mx]], positions=[pos], widths=0.5, vert=True,
            manage_ticks=False, whis=(0, 100),
        )
        # matplotlib boxplot needs a real distribution-like input; instead draw manually
    ax.clear()
    for i, (mn, q1, med, q3, mx) in enumerate(stats):
        pos = positions[i]
        if swap_q_for_group == i:
            q1, q3 = q3, q1
        offset = scale_shift * 15 if i == 1 else 0
        mn, q1, med, q3, mx = mn + offset, q1 + offset, med + offset, q3 + offset, mx + offset
        ax.plot([pos, pos], [mn, q1], color="black")
        ax.plot([pos, pos], [q3, mx], color="black")
        box_h = q3 - q1
        ax.add_patch(plt.Rectangle((pos - 0.2, q1), 0.4, box_h, fill=False, edgecolor="black"))
        ax.plot([pos - 0.2, pos + 0.2], [med, med], color="black", linewidth=2)
        ax.plot([pos - 0.15, pos + 0.15], [mn, mn], color="black")
        ax.plot([pos - 0.15, pos + 0.15], [mx, mx], color="black")

    ax.set_xticks(positions)
    ax.set_xticklabels(groups)
    ax.set_xlabel(spec.get("x_axis", group_col))
    ax.set_ylabel(spec.get("y_axis", "value"))
    ax.set_xlim(0.3, 2.7)

    not_earned = []
    caption_bits = []
    if tier == "fully_correct":
        caption_bits.append(f"{groups[1]} has a higher median than {groups[0]}.")
        caption_bits.append(f"{groups[1]} also shows more variability (larger IQR/range).")
    elif tier == "partially_correct":
        not_earned = ["FIVE_NUMBER_VALUES", "CENTER_COMPARISON"]
        caption_bits.append(f"{groups[1]} looks kind of higher I guess.")
        caption_bits.append("not sure about the spread")
    elif tier == "subtly_wrong":
        not_earned = ["BOXPLOT_SCALE"]
        caption_bits.append(f"{groups[1]} has a higher median than {groups[0]}.")
        caption_bits.append(f"{groups[1]} shows more variability (larger IQR).")

    return " ".join(caption_bits), not_earned


# --------------------------------------------------------- segmented bar ----
def render_segmented_bar(ax, pj, tier):
    stim = pj["stimulus_table"]
    group_col = find_group_col(stim[0])
    cats = [k for k in stim[0] if k != group_col]
    groups = [r[group_col] for r in stim]

    use_raw_counts_for = None
    reverse_stack_for = None
    if tier == "partially_correct":
        use_raw_counts_for = 1  # forgets to convert 2nd group to relative freq
    elif tier == "subtly_wrong":
        reverse_stack_for = 1  # stacks 2nd group's segments in reverse order

    colors = ["#888888", "#bbbbbb", "#444444"]
    max_stack = 1.0
    totals = [sum(row[c] for c in cats) for row in stim]
    for gi, g in enumerate(groups):
        row = stim[gi]
        vals = [row[c] for c in cats]
        total = totals[gi]
        if use_raw_counts_for == gi:
            grand_total = sum(totals)  # divides by the grand total across all groups, not its own
            heights = [v / grand_total for v in vals]
        else:
            heights = [v / total for v in vals]
        max_stack = max(max_stack, sum(heights))
        order = list(range(len(cats)))
        if reverse_stack_for == gi:
            order = list(reversed(order))
        bottom = 0
        for oi in order:
            ax.bar(gi, heights[oi], bottom=bottom, width=0.5, color=colors[oi % len(colors)],
                   edgecolor="black")
            bottom += heights[oi]

    ax.set_xticks(range(len(groups)))
    ax.set_xticklabels(groups)
    ax.set_ylabel("relative frequency")
    ax.set_ylim(0, max_stack * 1.15)

    not_earned = []
    if tier == "fully_correct":
        caption = f"{groups[1]} has the larger weekly relative frequency."
    elif tier == "partially_correct":
        not_earned = ["RELATIVE_FREQUENCIES", "SEGMENTED_BARS"]
        caption = f"{groups[1]} bar is taller so it has more weekly users."
    else:
        not_earned = ["COMPARISON"]
        caption = f"{groups[0]} has the larger weekly relative frequency."
    return caption, not_earned


# --------------------------------------------------------------- mosaic -----
def render_mosaic(ax, pj, tier):
    stim = pj["stimulus_table"]
    group_col = find_group_col(stim[0])
    cats = [k for k in stim[0] if k != group_col]
    groups = [r[group_col] for r in stim]
    totals = [sum(r[c] for c in cats) for r in stim]
    grand_total = sum(totals)

    equal_widths = tier == "partially_correct"
    use_overall_props = tier == "subtly_wrong"

    colors = ["#cccccc", "#999999", "#555555"]
    x = 0.0
    for gi, g in enumerate(groups):
        row = stim[gi]
        w = (1.0 / len(groups)) if equal_widths else (totals[gi] / grand_total)
        y = 0.0
        for ci, c in enumerate(cats):
            if use_overall_props:
                overall_total = sum(r[c] for r in stim)
                h = row[c] / overall_total if overall_total else 0
                h = h  # deliberately uses cross-group share instead of within-group share
                h_norm = row[c] / sum(row[cc] for cc in cats)  # keep bars summing to 1 visually but mislabel logic in caption
                h = h_norm
            else:
                h = row[c] / totals[gi]
            ax.add_patch(plt.Rectangle((x, y), w, h, facecolor=colors[ci % len(colors)], edgecolor="black"))
            y += h
        ax.text(x + w / 2, -0.05, g, ha="center", va="top", fontsize=9)
        x += w

    ax.set_xlim(0, 1)
    ax.set_ylim(-0.12, 1.05)
    ax.set_xlabel(pj["expected_graph_spec"].get("x_axis", group_col))
    ax.set_ylabel(pj["expected_graph_spec"].get("y_axis", "proportion"))

    not_earned = []
    if tier == "fully_correct":
        caption = "Phone has the largest number of high-stress students."
    elif tier == "partially_correct":
        not_earned = ["WIDTHS_BY_TOTAL"]
        caption = "Phone has the largest number of high-stress students."
    else:
        not_earned = ["HEIGHTS_BY_CONDITIONAL_PROPORTION"]
        caption = "Phone has the largest number of high-stress students."
    return caption, not_earned


# -------------------------------------------------------------- dotplot -----
def render_dotplot(ax, pj, tier):
    stim = pj["stimulus_table"]
    col = list(stim[0].keys())[0]
    vals = sorted(r[col] for r in stim)

    drop_one = tier == "partially_correct"
    plot_vals = vals[:-1] if drop_one else vals

    from collections import Counter
    counts = Counter(plot_vals)
    for x, n in counts.items():
        for i in range(n):
            ax.plot(x, i + 1, "o", color="black", markersize=8)

    ax.set_xlabel(pj["expected_graph_spec"].get("x_axis", col))
    ax.set_yticks([])
    ax.set_xlim(min(vals) - 2, max(vals) + 2)
    ax.set_ylim(0, max(counts.values()) + 1)

    not_earned = []
    if tier == "fully_correct":
        caption = "The distribution is right-skewed with a possible high outlier."
    elif tier == "partially_correct":
        not_earned = ["DOT_COUNTS", "OUTLIER_NOTE"]
        caption = "The distribution is right-skewed."
    else:
        not_earned = ["SHAPE_DESCRIPTION"]
        caption = "The distribution is left-skewed with a possible high outlier."
    return caption, not_earned


# ------------------------------------------------------------- scatter ------
def render_scatter(ax, pj, tier):
    stim = pj["stimulus_table"]
    keys = list(stim[0].keys())
    spec = pj["expected_graph_spec"]
    xk = match_axis_col(keys, spec.get("x_axis", ""))
    yk = match_axis_col(keys, spec.get("y_axis", ""))
    xs = [r[xk] for r in stim]
    ys = [r[yk] for r in stim]

    ax.plot(xs, ys, "o", color="black", markersize=7)

    import statistics
    xbar, ybar = statistics.mean(xs), statistics.mean(ys)
    sxx = sum((x - xbar) ** 2 for x in xs)
    sxy = sum((x - xbar) * (y - ybar) for x, y in zip(xs, ys))
    slope = sxy / sxx
    intercept = ybar - slope * xbar

    no_line = tier == "partially_correct"
    flat_line = tier == "subtly_wrong"

    if not no_line:
        xr = [min(xs), max(xs)]
        if flat_line:
            yr = [ybar, ybar]  # drawn roughly flat despite clear positive trend
        else:
            yr = [slope * x + intercept for x in xr]
        ax.plot(xr, yr, "-", color="black", linewidth=2)

    ax.set_xlabel(pj["expected_graph_spec"].get("x_axis", xk))
    ax.set_ylabel(pj["expected_graph_spec"].get("y_axis", yk))

    not_earned = []
    if tier == "fully_correct":
        caption = "Strong, positive, roughly linear association between hours studied and quiz score."
    elif tier == "partially_correct":
        not_earned = ["TREND_LINE"]
        caption = "Strong, positive, roughly linear association between hours studied and quiz score."
    else:
        not_earned = ["ASSOCIATION_DESCRIPTION"]
        caption = "Weak or no clear association between hours studied and quiz score."
    return caption, not_earned


# ---------------------------------------------------- curve annotation ------
import re


def find_target_index(criteria, xs):
    """The correct point to mark is stated in the X_LOCATION criterion's
    learner_facing_text (e.g. "Places X at sample size 20..."). Extract the
    number that exactly matches a value in xs -- do NOT assume a fixed index,
    since different items place their marked point at different positions."""
    for c in criteria:
        if c.get("criterion_key") == "X_LOCATION":
            text = c.get("learner_facing_text", "")
            for tok in re.findall(r"-?\d+\.?\d*", text):
                n = float(tok)
                for i, x in enumerate(xs):
                    if float(x) == n:
                        return i
    return len(xs) // 2


def render_curve_annotation(ax, pj, tier):
    stim = pj["stimulus_table"]
    keys = list(stim[0].keys())
    spec = pj["expected_graph_spec"]
    xk = match_axis_col(keys, spec.get("x_axis", ""))
    yk = match_axis_col(keys, spec.get("y_axis", ""))
    xs = [r[xk] for r in stim]
    ys = [r[yk] for r in stim]

    ax.plot(xs, ys, "-", color="black", linewidth=2)
    ax.plot(xs, ys, "o", color="black", markersize=4)

    target_idx = find_target_index(pj["criteria"], xs)
    wrong_idx = target_idx - 2 if target_idx >= 2 else target_idx + 2
    target_x = xs[target_idx]
    target_y = ys[target_idx]

    wrong_x_loc = tier == "partially_correct"
    wrong_y_read = tier == "subtly_wrong"

    mark_x = xs[wrong_idx] if wrong_x_loc else target_x
    mark_y = (target_y + 0.15) if wrong_y_read else (ys[wrong_idx] if wrong_x_loc else target_y)

    ax.plot(mark_x, mark_y, "x", color="black", markersize=14, markeredgewidth=3)
    ax.set_xlabel(pj["expected_graph_spec"].get("x_axis", xk))
    ax.set_ylabel(pj["expected_graph_spec"].get("y_axis", yk))

    not_earned = []
    if tier == "fully_correct":
        caption = f"At {xk}={target_x}, the estimated {yk} is about {target_y}."
    elif tier == "partially_correct":
        not_earned = ["X_LOCATION", "PROBABILITY_ESTIMATE"]
        caption = f"At {xk}={xs[wrong_idx]}, the estimated {yk} is about {ys[wrong_idx]}."
    else:
        not_earned = ["PROBABILITY_ESTIMATE"]
        caption = f"At {xk}={target_x}, the estimated {yk} is about {round(target_y + 0.15, 2)}."
    return caption, not_earned


RENDERERS = {
    "boxplot_construction_interpretation": render_boxplot,
    "segmented_bar_graph_construction": render_segmented_bar,
    "mosaic_plot_interpretation": render_mosaic,
    "dotplot_distribution_shape": render_dotplot,
    "scatterplot_regression_context": render_scatter,
    "graph_annotation_marking_value": render_curve_annotation,
    # Biology archetype aliases will map onto these same generic shapes below
}


def main():
    export_path, out_dir, prefix = sys.argv[1], sys.argv[2], sys.argv[3]
    with open(export_path) as f:
        data = json.load(f)
    items = data["items"]

    images_dir = os.path.join(out_dir, "images")
    os.makedirs(images_dir, exist_ok=True)

    gold_labels = []
    skipped = []

    for item in items:
        pj = item["prompt_json"]
        archetype = pj.get("archetype")
        renderer = RENDERERS.get(archetype)
        content_key = item["content_key"]
        if renderer is None:
            skipped.append((content_key, archetype))
            continue

        for tier in TIERS:
            with plt.xkcd():
                fig, ax = plt.subplots(figsize=(6.5, 5), dpi=140)
                try:
                    caption, not_earned = renderer(ax, pj, tier)
                except Exception as e:
                    plt.close(fig)
                    skipped.append((content_key, f"{archetype} ERROR: {e}"))
                    continue
                ax.set_title(content_key, fontsize=8, loc="left")
                fig.tight_layout(rect=[0, 0.08, 1, 1])
                fig.text(0.02, 0.01, f"Written response: {caption}", fontsize=8, wrap=True)
                fname = f"{content_key}__{tier}.png"
                fpath = os.path.join(images_dir, fname)
                fig.savefig(fpath)
                plt.close(fig)

            criteria = pj["criteria"]
            labels = crit_labels(criteria, not_earned)
            points_possible = sum(c["points_possible"] for c in criteria)
            points_earned = sum(c["points_possible"] for c in criteria if labels[c["criterion_key"]] == "earned")
            gold_labels.append({
                "content_key": content_key,
                "archetype": archetype,
                "tier": tier,
                "image_path": os.path.relpath(fpath, out_dir),
                "written_response": caption,
                "criterion_labels": labels,
                "points_earned": points_earned,
                "points_possible": points_possible,
                "label_status": "synthetic_generated_gold",
            })

    with open(os.path.join(out_dir, "gold_labels.jsonl"), "w") as f:
        for rec in gold_labels:
            f.write(json.dumps(rec) + "\n")

    print(f"Rendered {len(gold_labels)} images across {len(items) - len(skipped)} items.")
    if skipped:
        print(f"Skipped {len(skipped)}:")
        for ck, reason in skipped:
            print(f"  {ck}: {reason}")


if __name__ == "__main__":
    main()
