# Claude-proposed gold labels from visual inspection of the photographed
# hand-drawn responses. PROPOSED ONLY -- not authoritative until a human
# (David or Learning Quality) confirms them. See README.md.
#
# v2 update (2026-07-06, same day): David redrew 11 of the 12 items to add
# the written interpretive sentence that was missing from the v1 photos
# (see README's "v2 redraw" changelog). GRAPH-007 was NOT resubmitted and
# remains on v1. Each entry below records which image version the labels
# were graded against.

PROPOSED_LABELS = {
    "APSTATS-HDG-2026-GRAPH-001": {
        "image_version": "v2",
        "labels": {
            "BOXPLOT_SCALE": "earned",
            "FIVE_NUMBER_VALUES": "earned",
            "CENTER_COMPARISON": "earned",
            "VARIABILITY_COMPARISON": "earned",
        },
        "note": (
            "v2 redraw adds \"Interpretation: Urban routes have higher median "
            "delivery time, and greater variability by IQR and range.\" -- directly "
            "matches the canonical answer's center and variability comparisons. "
            "Full credit. (v1 photo had the graph only, no written comparison, and "
            "would have proposed not_earned on both interpretation criteria.)"
        ),
    },
    "APSTATS-HDG-2026-GRAPH-002": {
        "image_version": "v2",
        "labels": {
            "RELATIVE_FREQUENCIES": "earned",
            "SEGMENTED_BARS": "earned",
            "CATEGORY_LABELS": "earned",
            "COMPARISON": "earned",
        },
        "note": (
            "v2 redraw adds \"Interpretation: Upper class students have larger "
            "relative frequency of app use.\" Doesn't say \"weekly\" explicitly, "
            "unlike the canonical answer's exact phrasing -- flagged for review as "
            "a looser match. **Resolved by David (approver), 2026-07-06: earned.** "
            "Since the stem only asks about weekly use, \"relative frequency of app "
            "use\" in this context is unambiguous and the identification is "
            "correct -- confirmed as a rubric-interpretation call, not a gap."
        ),
    },
    "APSTATS-HDG-2026-GRAPH-003": {
        "image_version": "v2",
        "labels": {
            "WIDTHS_BY_TOTAL": "unable_to_determine",
            "HEIGHTS_BY_CONDITIONAL_PROPORTION": "earned",
            "SEGMENT_LABELS": "earned",
            "AREA_OR_COUNT_REASONING": "earned",
        },
        "note": (
            "v2 redraw adds \"Interpretation: Phone has the largest number of high "
            "stress students (40) compared to laptop (30) and tablet (20).\" -- "
            "exact match to the canonical answer's counts and conclusion. Full "
            "credit on AREA_OR_COUNT_REASONING now. WIDTHS_BY_TOTAL is unchanged "
            "from v1 -- still hard to confirm column-width proportionality (Phone "
            "100 / Laptop 100 / Tablet 80) with confidence from the photo alone, "
            "so still flagging unable_to_determine rather than guessing."
        ),
    },
    "APSTATS-HDG-2026-GRAPH-004": {
        "image_version": "v2",
        "labels": {
            "DOT_COUNTS": "earned",
            "AXIS_SCALE": "earned",
            "SHAPE_DESCRIPTION": "earned",
            "OUTLIER_NOTE": "earned",
        },
        "note": (
            "v2 redraw adds \"Interpretation: the graph is right skewed, with 14 a "
            "possible outlier.\" -- matches the canonical answer's shape "
            "description and outlier identification exactly. Full credit."
        ),
    },
    "APSTATS-HDG-2026-GRAPH-005": {
        "image_version": "v2",
        "labels": {
            "POINTS_PLOTTED": "earned",
            "AXIS_LABELS": "earned",
            "TREND_LINE": "earned",
            "ASSOCIATION_DESCRIPTION": "earned",
        },
        "note": (
            "v2 redraw adds \"Interpretation: There is a strong positive linear "
            "correlation between hours studied and test score.\" -- captures "
            "direction/form/strength correctly. Two minor terminology notes for a "
            "reviewer, neither treated as blocking here: (1) AP Statistics rubrics "
            "generally prefer \"association\" over \"correlation\" for this kind of "
            "descriptive claim (correlation technically refers to r); (2) the "
            "stem's variable is \"Quiz score,\" written here as \"test score\" -- "
            "likely harmless paraphrase, not a different variable, but worth a "
            "reviewer's eye. Proposing earned."
        ),
    },
    "APSTATS-HDG-2026-GRAPH-006": {
        "image_version": "v2",
        "labels": {
            "CURVE_SHAPE": "earned",
            "AXIS_SCALE_LABELS": "earned",
            "X_LOCATION": "earned",
            "PROBABILITY_ESTIMATE": "earned",
        },
        "note": (
            "Already full credit on v1 (the estimate was written as a page "
            "annotation, 'rate ~ 0.39', matching canonical ~0.39). v2 redraw adds "
            "an additional 'Interpretation' sentence about the curve's shape "
            "('increases before moderating ... after 40'), which isn't required by "
            "any of this item's 4 criteria but doesn't hurt. Still full credit."
        ),
    },
    "APSTATS-HDG-2026-GRAPH-007": {
        "image_version": "v2",
        "labels": {
            "BOXPLOT_SCALE": "earned",
            "FIVE_NUMBER_VALUES": "earned",
            "CENTER_COMPARISON": "earned",
            "VARIABILITY_COMPARISON": "earned",
        },
        "note": (
            "GRAPH-007 WAS resubmitted (IMG_7026.jpeg) -- it just hadn't finished "
            "syncing to the images folder when it was first checked (appeared ~8 "
            "minutes after the other 10 v2 files). Adds \"Interpretation: Bus "
            "commutes have the larger median and spread by IQR and range.\" -- "
            "matches the canonical answer's center and variability comparisons. "
            "Full credit, same as GRAPH-001's v2."
        ),
    },
    "APSTATS-HDG-2026-GRAPH-008": {
        "image_version": "v2",
        "labels": {
            "RELATIVE_FREQUENCIES": "earned",
            "SEGMENTED_BARS": "earned",
            "CATEGORY_LABELS": "earned",
            "COMPARISON": "earned",
        },
        "note": (
            "v2 redraw adds \"Interpretation: The relative frequency of correct "
            "explanations increased after lessons.\" -- exact match to the "
            "canonical answer's conclusion. Full credit."
        ),
    },
    "APSTATS-HDG-2026-GRAPH-009": {
        "image_version": "v2",
        "labels": {
            "WIDTHS_BY_TOTAL": "unable_to_determine",
            "HEIGHTS_BY_CONDITIONAL_PROPORTION": "earned",
            "SEGMENT_LABELS": "earned",
            "AREA_OR_COUNT_REASONING": "earned",
        },
        "note": (
            "v2 redraw adds \"Interpretation: Evening has the highest count of "
            "high caffeine use (46) compared to (32) for Afternoon and (12) for "
            "Morning.\" -- exact match to the canonical answer's counts and "
            "conclusion. Full credit on AREA_OR_COUNT_REASONING now. "
            "WIDTHS_BY_TOTAL is unchanged from v1 -- column-width proportionality "
            "to the group totals (Morning 90 / Afternoon 110 / Evening 100) is "
            "still hard to confirm confidently at this scale, so still flagging "
            "unable_to_determine."
        ),
    },
    "APSTATS-HDG-2026-GRAPH-010": {
        "image_version": "v2",
        "labels": {
            "DOT_COUNTS": "earned",
            "AXIS_SCALE": "earned",
            "SHAPE_DESCRIPTION": "earned",
            "OUTLIER_NOTE": "not_earned",
        },
        "note": (
            "v2 redraw adds \"Interpretation: The distribution is roughly unimodal "
            "with a slight right tail.\" -- matches the canonical shape description "
            "exactly, so SHAPE_DESCRIPTION now earned. **But the redraw still says "
            "nothing about 82 cm or an outlier at all** -- OUTLIER_NOTE remains "
            "not_earned regardless of which wording (original or corrected) is used, "
            "since the response doesn't address the question either way. Worth a "
            "specific call-out since it would be easy to assume 'redrawn = now "
            "complete' without checking each criterion individually.\n\n"
            "On whether 82 cm is 'definitively' an outlier: this correction is not "
            "something newly asserted in this package -- it's already documented in "
            "`ap_statistics_graph_response_seed_2026_07_02/README.md`'s own QA "
            "section, written 2026-07-02, before this conversation. The original "
            "item text is an eyeballed judgment call ('high but not clearly isolated "
            "enough'), which is a defensible informal read. The correction is a "
            "specific, narrower claim: by the formal 1.5xIQR rule AP Statistics "
            "grades by (Q1=71.5, Q3=75.5, IQR=4, upper fence=Q3+1.5xIQR=81.5), 82 "
            "exceeds 81.5 by only 0.5 -- so it is a *mild* outlier by that rule, not "
            "an obvious/extreme one by eye. Both readings are 'true' in their own "
            "terms; the rubric bug is that the item's rubric asserts the eyeballed "
            "conclusion as if the rule had been checked, when computing the rule "
            "actually flips the answer. This is a narrow, mechanical distinction, "
            "not a subjective call -- happy to re-verify the arithmetic again if "
            "useful."
        ),
    },
    "APSTATS-HDG-2026-GRAPH-011": {
        "image_version": "v2",
        "labels": {
            "POINTS_PLOTTED": "earned",
            "AXIS_LABELS": "earned",
            "TREND_LINE": "earned",
            "ASSOCIATION_DESCRIPTION": "earned",
        },
        "note": (
            "v2 redraw adds \"Interpretation: The scatterplot shows a strong "
            "negative, roughly linear association between screen brightness and "
            "battery remaining.\" -- near-verbatim match to the canonical answer. "
            "Full credit."
        ),
    },
    "APSTATS-HDG-2026-GRAPH-012": {
        "image_version": "v2",
        "labels": {
            "CURVE_SHAPE": "earned",
            "AXIS_SCALE_LABELS": "earned",
            "X_LOCATION": "earned",
            "RATE_ESTIMATE": "earned",
        },
        "note": (
            "Already full credit on v1 (the estimate was written as a page "
            "annotation, 'rate ~ 0.81', matching canonical ~0.81). v2 redraw adds "
            "an explicit 'Interpretation:' restating the same curve description and "
            "estimate. Still full credit."
        ),
    },
}
