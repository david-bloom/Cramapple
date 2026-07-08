# AI-provisional (Claude-authored) Statistics hand-drawn corpus data.
# NOT Learning-Quality-approved. Question stems, tables, and the 4-criterion
# rubrics are reused directly from the existing
# ap_statistics_graph_response_seed_2026_07_02 item pool (already exactly
# 4 criteria per item); this file adds the labeled response layer on top.
#
# IMPORTANT: no real photographed student responses exist for these items.
# Each "response" below is a textual description of what a hypothetical drawn
# page would show, standing in for an actual photograph (this pool's real
# reference images live in ap_statistics_graph_response_seed_2026_07_02/
# reference_images/ but are canonical answers, not student responses). This
# must not be represented as real hand-drawn capture data downstream.

STATS_HAND_DRAWN_ITEMS = [
    {
        "id": "statistics_hand_drawn_01",
        "source_item_id": "APSTATS-HDG-2026-GRAPH-001",
        "archetype": "boxplot_construction_interpretation",
        "title": "Side-by-Side Boxplots for Delivery Times by Route Type",
        "stem": "A logistics teacher recorded delivery times for two route types. Construct side-by-side boxplots from the five-number summaries, using one common horizontal or vertical scale. Then write one sentence comparing the centers and one sentence comparing the variability.",
        "display_table": [
            {"Route type": "Rural", "Min": 24, "Q1": 28, "Median": 31, "Q3": 38, "Max": 42},
            {"Route type": "Urban", "Min": 30, "Q1": 33, "Median": 37, "Q3": 45, "Max": 49},
        ],
        "criteria": [
            {"id": "C1", "text": "Uses one interpretable common scale for both groups.", "notes": "Reused directly from source BOXPLOT_SCALE."},
            {"id": "C2", "text": "Both boxplots recover the listed five-number summaries.", "notes": "Reused directly from source FIVE_NUMBER_VALUES."},
            {"id": "C3", "text": "Correctly compares medians in context.", "notes": "Reused directly from source CENTER_COMPARISON."},
            {"id": "C4", "text": "Correctly compares IQR or range in context.", "notes": "Reused directly from source VARIABILITY_COMPARISON."},
        ],
        "responses": [
            {
                "id": "R1",
                "description": (
                    "Two boxplots drawn on one shared horizontal scale from 20 to 50. Rural box spans "
                    "24-28-31-38-42 with whiskers to the min/max; Urban box spans 30-33-37-45-49, positioned "
                    "clearly higher along the scale. Written sentences: 'Urban routes have a higher median "
                    "delivery time (37 min) than rural routes (31 min).' and 'Urban routes also have more "
                    "variability, with a larger IQR (12 vs. 10 minutes) and a larger range (19 vs. 18 minutes).'"
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit response. Both boxplots correctly recover the five-number summaries on one shared scale, and both comparison sentences are correct and reference specific numeric values in context.",
                "boundary_tags": [],
            },
            {
                "id": "R2",
                "description": (
                    "Two boxplots drawn on separate scales: Rural on a 20-45 scale and Urban on a 25-50 "
                    "scale, positioned side by side but not aligned to the same axis. Five-number summaries "
                    "for each box otherwise match the table. Sentences: 'The two routes have different "
                    "times.' and 'They also have different spreads.'"
                ),
                "labels": {"C1": "not_earned", "C2": "earned", "C3": "not_earned", "C4": "not_earned"},
                "reviewer_note": "Using two different scales for the two boxplots defeats the purpose of a side-by-side comparison -- visually, box positions can no longer be compared directly, so C1 is not earned even though each box individually recovers its own five-number summary. Both comparison sentences are also too vague to earn credit -- neither references the median values or IQR/range numbers, just 'different,' which doesn't demonstrate the required comparison. Flags: non-common scale defeats comparison purpose, vague generality in both comparison sentences.",
                "boundary_tags": ["rubric_drift_non_common_scale", "vague_generality"],
            },
            {
                "id": "R3",
                "description": (
                    "Two boxplots on one common scale from 20 to 50, five-number summaries matching the "
                    "table for both groups. Sentences: 'Urban has a higher median (37) than rural (31).' "
                    "'Urban and rural have about the same spread.'"
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "not_earned"},
                "reviewer_note": "Scale, five-number values, and the center comparison are all correct. But the variability comparison is wrong -- Urban's IQR (12) and range (19) are both larger than Rural's (10 and 18), so 'about the same spread' misreads the visually larger Urban box and whisker span. Flags: visual misread of relative box/whisker widths.",
                "boundary_tags": ["visual_misread"],
            },
            {
                "id": "R4",
                "description": (
                    "Two boxplots on one common vertical scale from 20 to 50, five-number summaries matching "
                    "the table for both groups, drawn as vertical boxplots side by side rather than "
                    "horizontal. Sentences: 'The median delivery time for urban routes (37 minutes) is "
                    "higher than for rural routes (31 minutes).' 'Urban routes also show greater variability, "
                    "with both a larger IQR (45-33=12 vs. 38-28=10) and a larger range (49-30=19 vs. "
                    "42-24=18).'"
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Second full-credit response using the vertical-orientation variant explicitly allowed by the stem ('horizontal or vertical scale'); confirms grader tolerance for either orientation.",
                "boundary_tags": [],
            },
            {
                "id": "R5",
                "description": (
                    "Two boxplots on one common scale. Rural box matches the table exactly. Urban box has "
                    "Min/Q1/Median/Q3 matching the table (30/33/37/45) but the max whisker is drawn extending "
                    "to 55 instead of 49, apparently transcribing a value from a different row. Sentences "
                    "correctly compare medians and correctly note urban has greater variability, referencing "
                    "the (incorrect) whisker-implied range."
                ),
                "labels": {"C1": "earned", "C2": "not_earned", "C3": "earned", "C4": "unable_to_determine"},
                "reviewer_note": "One of the ten required five-number-summary values (Urban max) does not match the table, so C2 is not earned. The center comparison is unaffected and correct. The variability comparison's conclusion (urban has greater spread) is still directionally correct, but since it's partly based on the mis-transcribed max, it's unclear whether to credit the reasoning or treat it as tainted by the upstream data error -- flagged unable_to_determine for reviewer judgment on how to handle a correct conclusion built on an incorrect plotted value. Flags: single five-number-summary value error, reviewer judgment call on downstream criteria.",
                "boundary_tags": ["rubric_ambiguity", "correct_conclusion_tainted_by_data_error"],
            },
        ],
    },
    {
        "id": "statistics_hand_drawn_02",
        "source_item_id": "APSTATS-HDG-2026-GRAPH-002",
        "archetype": "segmented_bar_graph_construction",
        "title": "Segmented Bar Graph for Homework App Use by Class Group",
        "stem": "A school surveyed students about how often they use a homework planning app. Complete a segmented bar graph using relative frequencies for each class group. Then identify which group has the larger relative frequency of weekly app use.",
        "display_table": [
            {"Class group": "Underclass", "Never": 20, "Monthly": 45, "Weekly": 35},
            {"Class group": "Upperclass", "Never": 12, "Monthly": 38, "Weekly": 50},
        ],
        "criteria": [
            {"id": "C1", "text": "Converts counts to correct within-group relative frequencies.", "notes": "Reused directly from source RELATIVE_FREQUENCIES."},
            {"id": "C2", "text": "Draws two complete segmented bars with total length 1 or 100%.", "notes": "Reused directly from source SEGMENTED_BARS."},
            {"id": "C3", "text": "Segments and class groups are identifiable.", "notes": "Reused directly from source CATEGORY_LABELS."},
            {"id": "C4", "text": "Correctly identifies the larger weekly relative frequency.", "notes": "Reused directly from source COMPARISON."},
        ],
        "responses": [
            {
                "id": "R1",
                "description": (
                    "Two full-height segmented bars, each running 0 to 100%. Underclass bar divided into "
                    "20% Never, 45% Monthly, 35% Weekly (bottom to top), each segment labeled with its "
                    "percentage. Upperclass bar divided into 12% Never, 38% Monthly, 50% Weekly, similarly "
                    "labeled. Both bars labeled with class group names underneath, and a legend/key "
                    "identifying the three segment colors. Written answer: 'Upperclass students have the "
                    "larger relative frequency of weekly app use (50% vs. 35%).'"
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit response with correctly computed relative frequencies, complete 100%-total bars, clear labeling, and a correct, numerically-referenced comparison.",
                "boundary_tags": [],
            },
            {
                "id": "R2",
                "description": (
                    "Two segmented bars, but built directly from the raw counts (20, 45, 35 for Underclass; "
                    "12, 38, 50 for Upperclass) without converting to relative frequencies, so the Underclass "
                    "bar totals 100 units tall and the Upperclass bar totals 100 units tall by coincidence of "
                    "similar group sizes, but the segment labels show raw counts rather than percentages or "
                    "proportions. Written answer: 'Upperclass has more weekly users (50 vs. 35).'"
                ),
                "labels": {"C1": "not_earned", "C2": "earned", "C3": "earned", "C4": "not_earned"},
                "reviewer_note": "Segments are labeled with raw counts, not relative frequencies -- the criterion specifically requires converting to within-group proportions, and comparing raw counts (50 vs. 35) is misleading if the two class groups have different total sizes (here they coincidentally are both 100, but the response never computes or shows that, and the comparison itself is about relative frequency, not raw count). Flags: relative frequency conversion skipped, comparison made on raw counts rather than proportions.",
                "boundary_tags": ["relative_frequency_conversion_skipped", "comparison_uses_raw_counts"],
            },
            {
                "id": "R3",
                "description": (
                    "Two segmented bars correctly showing relative frequencies (20/45/35 and 12/38/50 "
                    "converted to 0.20/0.45/0.35 and 0.12/0.38/0.50), both bars totaling 1.0, with segment "
                    "and class-group labels. No written comparison sentence is included anywhere on the page."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "not_earned"},
                "reviewer_note": "The graph itself is fully correct, but the response never states which group has the larger weekly relative frequency, which the stem explicitly asks for as a separate step. Flags: missing evidence for the required comparison statement, a clear omission.",
                "boundary_tags": ["missing_evidence"],
            },
            {
                "id": "R4",
                "description": (
                    "Two segmented bars correctly showing relative frequencies (0.20/0.45/0.35 and "
                    "0.12/0.38/0.50), both bars totaling 100%, with clear segment and class-group labels and "
                    "a small legend. Written answer: 'The relative frequency of weekly app use is 0.50 for "
                    "Upperclass and 0.35 for Underclass, so Upperclass students have the larger relative "
                    "frequency of weekly use.'"
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Second full-credit response with a more detailed comparison statement; confirms grader consistency.",
                "boundary_tags": [],
            },
            {
                "id": "R5",
                "description": (
                    "Two segmented bars correctly showing relative frequencies and totaling 100% each. "
                    "Segment order within each bar is Weekly (bottom), Monthly (middle), Never (top) for "
                    "Underclass, but Never (bottom), Monthly (middle), Weekly (top) for Upperclass -- the "
                    "two bars use inconsistent segment orderings, making the two bars hard to visually align "
                    "and compare segment-by-segment even though each bar's own segments are individually "
                    "labeled and correctly sized."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "unable_to_determine", "C4": "earned"},
                "reviewer_note": "Each segment is individually labeled and sized correctly, and the response still reaches the correct comparison conclusion, but the inconsistent stacking order between the two bars undermines the visual side-by-side readability that 'segments are identifiable [and comparable]' is meant to capture -- flagged unable_to_determine rather than a clean earned/not_earned, since the labels are technically all present but the graph's comparative clarity is compromised. Flags: rubric ambiguity on cross-bar segment order consistency, visual comparison undermined despite correct individual labels.",
                "boundary_tags": ["rubric_ambiguity", "visual_ambiguity"],
            },
        ],
    },
    {
        "id": "statistics_hand_drawn_03",
        "source_item_id": "APSTATS-HDG-2026-GRAPH-003",
        "archetype": "mosaic_plot_interpretation",
        "title": "Mosaic Plot for Study Device and Stress Level",
        "stem": "Students were classified by primary study device and reported stress level. Draw a mosaic plot from the table so that each device width is proportional to its total count and each vertical segment shows the conditional distribution of stress level within that device. Then state which device group has the largest number of high-stress students.",
        "display_table": [
            {"Device": "Phone", "Low": 24, "Medium": 36, "High": 40},
            {"Device": "Laptop", "Low": 18, "Medium": 52, "High": 30},
            {"Device": "Tablet", "Low": 30, "Medium": 30, "High": 20},
        ],
        "criteria": [
            {"id": "C1", "text": "Device widths are proportional to device totals.", "notes": "Reused directly from source WIDTHS_BY_TOTAL."},
            {"id": "C2", "text": "Segment heights use within-device proportions.", "notes": "Reused directly from source HEIGHTS_BY_CONDITIONAL_PROPORTION."},
            {"id": "C3", "text": "Device and stress-level categories are identifiable.", "notes": "Reused directly from source SEGMENT_LABELS."},
            {"id": "C4", "text": "Correctly identifies Phone as largest high-stress count.", "notes": "Reused directly from source AREA_OR_COUNT_REASONING."},
        ],
        "responses": [
            {
                "id": "R1",
                "description": (
                    "Mosaic plot with three columns: Phone (width proportional to 100/280), Laptop (width "
                    "proportional to 100/280), Tablet (width proportional to 80/280). Within each column, "
                    "vertical segments for Low/Medium/High sized to that device's own within-device "
                    "proportions (Phone: 24/100, 36/100, 40/100). All columns and segments labeled clearly. "
                    "Written answer: 'Phone has the largest number of high-stress students (40), compared "
                    "with 30 for Laptop and 20 for Tablet.'"
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit response with correctly proportioned widths and heights, clear labeling, and a correct count-based comparison distinguishing area/proportion from raw count.",
                "boundary_tags": [],
            },
            {
                "id": "R2",
                "description": (
                    "Mosaic plot with three columns of equal width (Phone, Laptop, Tablet each drawn at the "
                    "same width, not scaled by their totals of 100, 100, and 80). Within each column, "
                    "segment heights correctly reflect within-device proportions and are clearly labeled. "
                    "Written answer: 'Phone has the largest number of high-stress students.'"
                ),
                "labels": {"C1": "not_earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Column widths are drawn equal rather than proportional to each device's total count (100, 100, 80 out of 280) -- this is the specific feature that distinguishes a mosaic plot from a simple set of separate segmented bars, so C1 is not earned even though the within-device segment heights and the final comparison are both correct. Flags: mosaic-plot width-proportionality omitted, reduces the graph to a set of equal-width segmented bars.",
                "boundary_tags": ["mosaic_width_proportionality_omitted"],
            },
            {
                "id": "R3",
                "description": (
                    "Mosaic plot with correctly proportioned column widths and correctly proportioned "
                    "within-device segment heights, all clearly labeled. Written answer: 'Phone has the "
                    "highest proportion of high-stress students, since its High segment looks the tallest.'"
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "not_earned"},
                "reviewer_note": "The graph itself is fully correct, but the final answer confuses proportion with count -- the question asks which device has the largest *number* (count) of high-stress students, not the largest proportion. Phone's High segment does happen to be tallest by proportion (40%) as well as largest by count (40 students), so the response reaches the numerically correct device but through proportion-based reasoning rather than the count-based reasoning the criterion specifically requires (since these two forms of reasoning give different answers in other datasets, this distinction matters for grading generalizably). Flags: proportion-vs-count reasoning conflation, correct device via unsound justification.",
                "boundary_tags": ["proportion_count_conflation", "correct_conclusion_wrong_reasoning"],
            },
            {
                "id": "R4",
                "description": (
                    "Mosaic plot with column widths proportional to device totals (100, 100, 80 out of 280) "
                    "and segment heights proportional to within-device stress-level distributions, all "
                    "columns and segments labeled with device names and stress levels. Written answer: "
                    "'Phone has the largest number of high-stress students: 40 students, compared with 30 "
                    "for Laptop and 20 for Tablet, even though Phone and Laptop have the same total number "
                    "of students (100 each).'"
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Second full-credit response with an additional, correct observation distinguishing Phone from Laptop despite equal totals; useful for confirming the grader rewards this extra correct reasoning without penalizing length.",
                "boundary_tags": [],
            },
            {
                "id": "R5",
                "description": (
                    "Mosaic plot with column widths proportional to device totals and correctly labeled "
                    "device names. Within each column, segments are present and roughly sized, but none of "
                    "the three stress-level segments (Low/Medium/High) are labeled anywhere on the page, and "
                    "there is no legend or key indicating which segment corresponds to which stress level."
                ),
                "labels": {"C1": "earned", "C2": "unable_to_determine", "C3": "not_earned", "C4": "unable_to_determine"},
                "reviewer_note": "Column widths are correctly proportioned and device names are labeled, but with no stress-level segment labels or legend anywhere, it is impossible to verify from the image alone whether segment heights actually correspond to Low/Medium/High in the correct order, or to confirm which segment the response intends as 'High' when identifying the largest count -- both flagged unable_to_determine pending clarification from the drawer rather than assumed correct or incorrect. Flags: missing evidence for segment identity, downstream count-comparison criterion unverifiable without that label.",
                "boundary_tags": ["missing_evidence", "rubric_ambiguity"],
            },
        ],
    },
    {
        "id": "statistics_hand_drawn_04",
        "source_item_id": "APSTATS-HDG-2026-GRAPH-004",
        "archetype": "dotplot_distribution_shape",
        "title": "Dotplot of Customer Wait Times",
        "stem": "A sample of 12 customer wait times is shown below. Construct a dotplot of the data, then describe the distribution's shape and identify any possible outlier.",
        "display_table": [{"Wait time (min)": v} for v in [4, 5, 5, 6, 6, 6, 7, 7, 8, 11, 12, 14]],
        "criteria": [
            {"id": "C1", "text": "Plots the correct number of dots at each wait time.", "notes": "Reused directly from source DOT_COUNTS."},
            {"id": "C2", "text": "Uses an interpretable numeric scale covering 4 through 14.", "notes": "Reused directly from source AXIS_SCALE."},
            {"id": "C3", "text": "Describes the distribution as right-skewed in context.", "notes": "Reused directly from source SHAPE_DESCRIPTION."},
            {"id": "C4", "text": "Identifies 14 minutes as a possible high outlier or unusual value.", "notes": "Reused directly from source OUTLIER_NOTE."},
        ],
        "responses": [
            {
                "id": "R1",
                "description": (
                    "Dotplot on a numeric axis from 4 to 14 minutes, with dots stacked correctly: one at 4, "
                    "two at 5, three at 6, two at 7, one at 8, one at 11, one at 12, one at 14. Written "
                    "answer: 'The distribution of wait times is right-skewed, with most wait times clustered "
                    "between 4 and 8 minutes and a longer tail toward higher values. The wait time of 14 "
                    "minutes is a possible high outlier compared to the rest of the data.'"
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit response with correct dot counts, an interpretable axis covering the full range, a correctly directed and contextualized shape description, and correct outlier identification.",
                "boundary_tags": [],
            },
            {
                "id": "R2",
                "description": (
                    "Dotplot with dots stacked at 4, 5, 5, 6, 6, 6, 7, 7, 8, 11, 12, 14 on a numeric axis "
                    "from 4 to 14, matching the table exactly. Written answer: 'The distribution is "
                    "left-skewed since most of the data is bunched up on the right side near 14.' No mention "
                    "of an outlier."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "not_earned", "C4": "not_earned"},
                "reviewer_note": "Dot counts and axis are both correct, but the shape description reverses the skew direction -- the data is actually clustered at the low end (4-8) with a long tail toward the higher values (11-14), which is right-skewed, not left-skewed as described. No outlier is mentioned at all. Flags: skew direction reversed, missing evidence for outlier identification.",
                "boundary_tags": ["skew_direction_reversed", "missing_evidence"],
            },
            {
                "id": "R3",
                "description": (
                    "Dotplot with correct dot counts on a correct numeric axis. Written answer: 'The "
                    "distribution is right-skewed. There's a possible outlier.'"
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "not_earned"},
                "reviewer_note": "Shape description correctly identifies right-skew. However, the outlier note never identifies which value (14 minutes) is the possible outlier -- 'there's a possible outlier' without naming it does not demonstrate the specific identification the criterion requires. Flags: over-credit risk if grader accepts a vague outlier mention without the specific value.",
                "boundary_tags": ["over_credit_risk", "vague_generality"],
            },
            {
                "id": "R4",
                "description": (
                    "Dotplot with correct dot counts (one at 4, two at 5, three at 6, two at 7, one at 8, "
                    "one at 11, one at 12, one at 14) on an interpretable numeric axis from 4 to 14. Written "
                    "answer: 'This distribution is right-skewed, since most wait times are low (4-8 minutes) "
                    "with a few unusually long waits stretching the distribution toward higher values. The "
                    "14-minute wait time stands out as a possible high outlier, well beyond the rest of the "
                    "cluster.'"
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Second full-credit response with more detailed shape/outlier reasoning; confirms grader consistency.",
                "boundary_tags": [],
            },
            {
                "id": "R5",
                "description": (
                    "Dotplot with 11 dots total instead of 12 -- appears to be missing one of the three dots "
                    "at wait time 6 (only two dots shown at 6 instead of three). Axis and remaining dot "
                    "placements otherwise correct. Written answer correctly describes right-skew and "
                    "correctly identifies 14 minutes as the possible outlier."
                ),
                "labels": {"C1": "not_earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "One dot is missing from the required 12, which fails the dot-count criterion even though the overall shape and outlier conclusions (which are somewhat robust to losing a single interior data point) remain correct. Flags: single dot omitted, illustrates that a shape/outlier conclusion can still be correct even when the underlying plot has a minor count error.",
                "boundary_tags": ["under_credit_risk", "single_dot_omitted"],
            },
        ],
    },
    {
        "id": "statistics_hand_drawn_05",
        "source_item_id": "APSTATS-HDG-2026-GRAPH-005",
        "archetype": "scatterplot_regression_context",
        "title": "Scatterplot of Hours Studied and Quiz Score",
        "stem": "A teacher recorded hours studied and quiz score for nine students. Construct a scatterplot, sketch a reasonable least-squares trend line, and describe the direction, form, and strength of the association in context.",
        "display_table": [
            {"Hours studied": 2, "Quiz score": 41}, {"Hours studied": 3, "Quiz score": 45},
            {"Hours studied": 4, "Quiz score": 48}, {"Hours studied": 5, "Quiz score": 53},
            {"Hours studied": 6, "Quiz score": 55}, {"Hours studied": 7, "Quiz score": 59},
            {"Hours studied": 8, "Quiz score": 65}, {"Hours studied": 9, "Quiz score": 68},
            {"Hours studied": 10, "Quiz score": 72},
        ],
        "criteria": [
            {"id": "C1", "text": "Plots all nine ordered pairs at recoverable locations.", "notes": "Reused directly from source POINTS_PLOTTED."},
            {"id": "C2", "text": "Labels hours studied and quiz score on the correct axes.", "notes": "Reused directly from source AXIS_LABELS."},
            {"id": "C3", "text": "Sketches a reasonable increasing line through the point cloud.", "notes": "Reused directly from source TREND_LINE."},
            {"id": "C4", "text": "Describes strong positive roughly linear association in context.", "notes": "Reused directly from source ASSOCIATION_DESCRIPTION."},
        ],
        "responses": [
            {
                "id": "R1",
                "description": (
                    "Scatterplot with x-axis labeled 'Hours studied' and y-axis labeled 'Quiz score,' all "
                    "nine points plotted at positions matching the table, closely following an increasing "
                    "linear pattern. A single straight trend line sketched rising from about (2, 41) to "
                    "about (10, 72). Written answer: 'There is a strong, positive, roughly linear association "
                    "between hours studied and quiz score -- students who studied more hours tended to earn "
                    "higher quiz scores, and the points fall close to a straight increasing line.'"
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit response with all points plotted accurately, correct axis labels, a reasonable trend line, and a correctly contextualized direction/form/strength description.",
                "boundary_tags": [],
            },
            {
                "id": "R2",
                "description": (
                    "Scatterplot with axes swapped: quiz score on the x-axis, hours studied on the y-axis, "
                    "but labeled correctly for their (swapped) positions and all nine points plotted "
                    "consistently with that swap. A trend line rises through the point cloud. Written answer "
                    "correctly describes a strong positive roughly linear association in context."
                ),
                "labels": {"C1": "earned", "C2": "not_earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "The stem does not specify a strict axis assignment the way some regression items do, but by convention (and by matching how the variables are introduced in the stem, hours studied first as the explanatory variable), hours studied is expected on the x-axis and quiz score on the y-axis; swapping them is inconsistent with that expected convention even though internally consistent and correctly labeled for the swap. Flags: axis assignment reversed relative to expected explanatory/response convention, boundary case for how strictly axis assignment should be enforced.",
                "boundary_tags": ["axis_assignment_reversed", "rubric_ambiguity"],
            },
            {
                "id": "R3",
                "description": (
                    "Scatterplot with correct axis labels and all nine points plotted accurately, closely "
                    "following an increasing linear pattern. No trend line is sketched anywhere on the graph. "
                    "Written answer: 'There is a strong positive linear association between hours studied "
                    "and quiz score.'"
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "not_earned", "C4": "earned"},
                "reviewer_note": "Points and labels are correct, and the written description is also correct, but the stem specifically asks the drawer to sketch a trend line on the graph itself, which is missing. Flags: missing evidence for the trend-line sketch specifically, despite a correct verbal description of the same relationship.",
                "boundary_tags": ["missing_evidence"],
            },
            {
                "id": "R4",
                "description": (
                    "Scatterplot with correct axis labels, all nine points plotted accurately, and a "
                    "reasonable increasing trend line sketched through the point cloud from about (2, 40) "
                    "to about (10, 71). Written answer: 'The scatterplot shows a strong, positive, roughly "
                    "linear relationship between the number of hours a student studied and their quiz score: "
                    "as hours studied increases, quiz score tends to increase as well, and the points cluster "
                    "tightly around the increasing trend line.'"
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Second full-credit response with a slightly different but still reasonable trend-line endpoint reading; confirms grader tolerance for hand-drawn line variation.",
                "boundary_tags": [],
            },
            {
                "id": "R5",
                "description": (
                    "Scatterplot with correct axis labels and all nine points plotted accurately, closely "
                    "following the increasing pattern. A trend line is sketched, but it is drawn as a "
                    "slightly curved line bowing upward, rather than straight, following the point cloud a "
                    "bit more closely than a straight line would. Written answer: 'There is a strong "
                    "positive, roughly linear association, though the relationship might curve slightly "
                    "upward at higher study-hour values.'"
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "unable_to_determine", "C4": "earned"},
                "reviewer_note": "The written description correctly matches the requested 'roughly linear' framing, but the drawn line itself is curved rather than straight, and it's genuinely ambiguous whether a slightly curved 'reasonable' line sketched to hug a mostly-linear cloud should count as satisfying 'a reasonable increasing line' (which could be read as requiring a straight line specifically) -- flagged unable_to_determine pending a rubric-drift decision on how strictly 'line' should be interpreted for a roughly-linear-but-not-perfectly-linear cloud. Flags: rubric ambiguity on straight-vs-curved trend line, visual judgment call.",
                "boundary_tags": ["rubric_ambiguity"],
            },
        ],
    },
    {
        "id": "statistics_hand_drawn_06",
        "source_item_id": "APSTATS-HDG-2026-GRAPH-007",
        "archetype": "boxplot_construction_interpretation",
        "title": "Side-by-Side Boxplots for Commute Times by Transportation Type",
        "stem": "A city planner compared commute times for students who usually ride the bus and students who usually bike. Construct side-by-side boxplots from the five-number summaries using one common scale. Then compare the typical commute time and the spread in context.",
        "display_table": [
            {"Transportation": "Bus", "Min": 18, "Q1": 24, "Median": 29, "Q3": 41, "Max": 55},
            {"Transportation": "Bike", "Min": 12, "Q1": 16, "Median": 19, "Q3": 25, "Max": 31},
        ],
        "criteria": [
            {"id": "C1", "text": "Uses one interpretable common scale for both groups.", "notes": "Reused directly from source BOXPLOT_SCALE."},
            {"id": "C2", "text": "Both boxplots recover the listed five-number summaries.", "notes": "Reused directly from source FIVE_NUMBER_VALUES."},
            {"id": "C3", "text": "Correctly compares medians in context.", "notes": "Reused directly from source CENTER_COMPARISON."},
            {"id": "C4", "text": "Correctly compares IQR or range in context.", "notes": "Reused directly from source VARIABILITY_COMPARISON."},
        ],
        "responses": [
            {
                "id": "R1",
                "description": (
                    "Two boxplots on one shared scale from 10 to 55. Bus box spans 18-24-29-41-55; Bike box "
                    "spans 12-16-19-25-31, both matching the table. Written answer: 'The typical (median) "
                    "commute time is longer for bus riders (29 minutes) than for bike riders (19 minutes).' "
                    "'Bus commute times also have much greater spread than bike commute times, both by IQR "
                    "(17 vs. 9 minutes) and by range (37 vs. 19 minutes).'"
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit response with correctly recovered five-number summaries on a shared scale and correct, numerically-referenced center and spread comparisons.",
                "boundary_tags": [],
            },
            {
                "id": "R2",
                "description": (
                    "Two boxplots on one shared scale from 10 to 55, matching the table for both groups. "
                    "Written answer: 'Bike commutes are typically shorter and less spread out than bus "
                    "commutes.' No numeric values referenced."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "not_earned", "C4": "not_earned"},
                "reviewer_note": "The direction of both comparisons is correct, but neither sentence references any of the actual median, IQR, or range values from the graph -- this is a vague restatement of the correct conclusion rather than a comparison grounded in the specific five-number summaries, which the criteria (as demonstrated by the reference answer's use of specific numbers) expect. Flags: over-credit risk if grader accepts direction-only comparisons without values, vague generality.",
                "boundary_tags": ["over_credit_risk", "vague_generality"],
            },
            {
                "id": "R3",
                "description": (
                    "Two boxplots on one shared scale, matching the table for both groups. Written answer: "
                    "'Bus has a higher median commute time (29 vs. 19 minutes).' 'Bike has more spread, since "
                    "its box looks wider on the page.'"
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "not_earned"},
                "reviewer_note": "Center comparison is correct and grounded in the right numbers. But the spread comparison reverses the correct conclusion -- Bus actually has the larger IQR (17 vs. 9) and range (37 vs. 19) -- and the stated reasoning ('looks wider on the page') suggests a visual misread of box width, possibly confusing Bike's narrower box position on the shared scale with a wider one. Flags: variability comparison reversed, visual misread of box width.",
                "boundary_tags": ["visual_misread"],
            },
            {
                "id": "R4",
                "description": (
                    "Two boxplots on one shared scale from 10 to 55, five-number summaries for both groups "
                    "matching the table. Written answer: 'The median commute time for bus riders (29 minutes) "
                    "is noticeably higher than for bike riders (19 minutes). Bus commute times are also much "
                    "more variable than bike commute times: the bus IQR (41-24=17 minutes) is nearly double "
                    "the bike IQR (25-16=9 minutes), and the bus range (55-18=37 minutes) is almost twice the "
                    "bike range (31-12=19 minutes).'"
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Second full-credit response with fully shown IQR/range arithmetic; confirms grader consistency for a more detailed answer.",
                "boundary_tags": [],
            },
            {
                "id": "R5",
                "description": (
                    "Two boxplots drawn on one shared scale. The Bus box's five-number summary matches the "
                    "table exactly. The Bike box's Q1, Median, and Q3 match the table (16, 19, 25), but its "
                    "whiskers are drawn extending to 10 and 35 instead of 12 and 31, apparently smoothing the "
                    "range outward slightly. Written answer correctly compares medians and correctly "
                    "identifies bus as having greater spread by both IQR and range."
                ),
                "labels": {"C1": "earned", "C2": "not_earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Bike's min and max are drawn slightly outside the reported values (10/35 instead of 12/31), so C2 (both boxplots recover the listed five-number summaries) is not earned even though the error is small and doesn't change the direction of either comparison conclusion. Flags: whisker endpoint transcription error, illustrates that correct conclusions can coexist with a failed values criterion.",
                "boundary_tags": ["under_credit_risk"],
            },
        ],
    },
    {
        "id": "statistics_hand_drawn_07",
        "source_item_id": "APSTATS-HDG-2026-GRAPH-008",
        "archetype": "segmented_bar_graph_construction",
        "title": "Segmented Bar Graph for Explanation Quality Before/After a Simulation Lesson",
        "stem": "A teacher scored short written explanations before and after a simulation lesson. Complete a segmented bar graph using relative frequencies for each lesson timing group. Then state whether the relative frequency of correct explanations increased after the lesson.",
        "display_table": [
            {"Lesson timing": "Before lesson", "Incorrect": 30, "Partially correct": 42, "Correct": 28},
            {"Lesson timing": "After lesson", "Incorrect": 14, "Partially correct": 30, "Correct": 56},
        ],
        "criteria": [
            {"id": "C1", "text": "Converts counts to correct within-group relative frequencies.", "notes": "Reused directly from source RELATIVE_FREQUENCIES."},
            {"id": "C2", "text": "Draws two complete segmented bars with total length 1 or 100%.", "notes": "Reused directly from source SEGMENTED_BARS."},
            {"id": "C3", "text": "Segments and lesson timing groups are identifiable.", "notes": "Reused directly from source CATEGORY_LABELS."},
            {"id": "C4", "text": "Correctly states that correct explanations increased after the lesson.", "notes": "Reused directly from source COMPARISON."},
        ],
        "responses": [
            {
                "id": "R1",
                "description": (
                    "Two full-height segmented bars. Before-lesson bar divided into 30% Incorrect, 42% "
                    "Partially correct, 28% Correct, each labeled. After-lesson bar divided into 14% "
                    "Incorrect, 30% Partially correct, 56% Correct, each labeled. Both bars labeled with "
                    "lesson timing beneath them and a legend. Written answer: 'Yes, the relative frequency "
                    "of correct explanations increased after the lesson, from 28% before to 56% after.'"
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit response with correctly computed relative frequencies, complete 100%-total bars, clear labeling, and a correct, numerically-referenced comparison.",
                "boundary_tags": [],
            },
            {
                "id": "R2",
                "description": (
                    "Two segmented bars with correctly computed relative frequencies (0.30/0.42/0.28 and "
                    "0.14/0.30/0.56), each totaling 100%, but with no labels identifying which bar is "
                    "'Before lesson' and which is 'After lesson,' and no legend distinguishing the three "
                    "segment colors from each other. Written answer correctly states that correct "
                    "explanations increased."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "not_earned", "C4": "earned"},
                "reviewer_note": "Relative frequencies and bar totals are correct, and the final comparison happens to be stated correctly (perhaps from the drawer's own memory of which bar was which), but without any labels on the graph itself, a reviewer working only from the image could not verify which bar represents which group or which color represents which category -- this is exactly what the category-labels criterion is meant to require. Flags: missing evidence for category/group labels, correct conclusion despite unlabeled graph.",
                "boundary_tags": ["missing_evidence"],
            },
            {
                "id": "R3",
                "description": (
                    "Two segmented bars correctly showing relative frequencies, correctly totaling 100%, "
                    "clearly labeled with lesson-timing groups and a legend. Written answer: 'The relative "
                    "frequency of correct explanations changed after the lesson.'"
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "not_earned"},
                "reviewer_note": "The graph is fully correct, but the written answer only says the relative frequency 'changed' rather than specifically stating it increased, which is what the stem asks the response to determine and state. 'Changed' is technically true but doesn't answer the specific yes/no direction the question requires. Flags: vague generality, direction not stated despite being directly askable from the correct graph.",
                "boundary_tags": ["vague_generality"],
            },
            {
                "id": "R4",
                "description": (
                    "Two segmented bars correctly showing relative frequencies (0.30/0.42/0.28 and "
                    "0.14/0.30/0.56), each totaling 100%, clearly labeled with lesson timing and a legend "
                    "identifying Incorrect/Partially correct/Correct. Written answer: 'Yes -- the relative "
                    "frequency of correct explanations rose from 0.28 (28%) before the lesson to 0.56 (56%) "
                    "after the lesson, a clear increase.'"
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Second full-credit response with slightly more detail in the comparison statement; confirms grader consistency.",
                "boundary_tags": [],
            },
            {
                "id": "R5",
                "description": (
                    "Two segmented bars with segment sizes computed from the raw counts directly (30, 42, "
                    "28 stacked to a total of 100 for Before; 14, 30, 56 stacked to a total of 100 for "
                    "After) without ever explicitly labeling the segments as relative frequencies or "
                    "percentages -- the bars happen to total 100 because the raw group sizes are both 100, "
                    "but the segment labels just show the raw counts (e.g., '28' rather than '28%' or "
                    "'0.28'). Written answer correctly states that correct explanations increased."
                ),
                "labels": {"C1": "unable_to_determine", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Because both groups happen to have exactly 100 total responses, the raw counts and the relative frequencies (as percentages) are numerically identical in this specific dataset, making it genuinely ambiguous from the image alone whether the drawer understood the relative-frequency conversion conceptually or simply plotted raw counts that happened to coincide with percentages -- flagged unable_to_determine rather than earned, since the criterion is meant to test the conversion step specifically and this dataset doesn't distinguish the two approaches. Flags: rubric ambiguity from coincidental equal group totals, cannot distinguish conceptual understanding from coincidence.",
                "boundary_tags": ["rubric_ambiguity"],
            },
        ],
    },
    {
        "id": "statistics_hand_drawn_08",
        "source_item_id": "APSTATS-HDG-2026-GRAPH-009",
        "archetype": "mosaic_plot_interpretation",
        "title": "Mosaic Plot for Study Time and Caffeine Use",
        "stem": "Students were grouped by usual study time and caffeine use level. Draw a mosaic plot so each study time width is proportional to its total count and each vertical segment shows the conditional distribution of caffeine use within that study time. Then identify which study-time group has the largest number of high-caffeine students.",
        "display_table": [
            {"Study time": "Morning", "Low": 36, "Medium": 42, "High": 12},
            {"Study time": "Afternoon", "Low": 28, "Medium": 50, "High": 32},
            {"Study time": "Evening", "Low": 16, "Medium": 38, "High": 46},
        ],
        "criteria": [
            {"id": "C1", "text": "Study-time widths are proportional to group totals.", "notes": "Reused directly from source WIDTHS_BY_TOTAL."},
            {"id": "C2", "text": "Segment heights use within-group proportions.", "notes": "Reused directly from source HEIGHTS_BY_CONDITIONAL_PROPORTION."},
            {"id": "C3", "text": "Study-time and caffeine-use categories are identifiable.", "notes": "Reused directly from source SEGMENT_LABELS."},
            {"id": "C4", "text": "Correctly identifies Evening as largest high-caffeine count.", "notes": "Reused directly from source AREA_OR_COUNT_REASONING."},
        ],
        "responses": [
            {
                "id": "R1",
                "description": (
                    "Mosaic plot with three columns: Morning (width proportional to 90/300), Afternoon "
                    "(width proportional to 110/300), Evening (width proportional to 100/300). Within each "
                    "column, segments sized to that group's own within-group proportions. All columns and "
                    "segments labeled clearly with a legend. Written answer: 'Evening has the largest number "
                    "of high-caffeine students (46), compared with 32 for Afternoon and 12 for Morning.'"
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit response with correctly proportioned widths and heights, clear labeling, and a correct count-based comparison.",
                "boundary_tags": [],
            },
            {
                "id": "R2",
                "description": (
                    "Mosaic plot with column widths that only roughly follow group totals -- Morning and "
                    "Evening columns are drawn nearly the same width even though Evening's total (100) is "
                    "noticeably larger than Morning's (90), and Afternoon (110, the largest) is drawn only "
                    "slightly wider than the other two rather than clearly the widest. Segment heights within "
                    "each column are correctly proportioned and labeled. Written answer correctly identifies "
                    "Evening as having the largest high-caffeine count."
                ),
                "labels": {"C1": "unable_to_determine", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "The three group totals (90, 110, 100) are close enough to each other that visually distinguishing 'roughly proportional' from 'not proportional' column widths from a hand-drawn page is genuinely difficult without a ruler measurement against the actual image -- flagged unable_to_determine rather than a clean fail, since the differences between the totals are small (a maximum 20-unit spread out of 300) and reasonable hand-drawing imprecision could produce this same appearance even from a correctly-intended proportional drawing. Flags: visual ambiguity in width proportionality with closely-spaced group totals.",
                "boundary_tags": ["visual_ambiguity"],
            },
            {
                "id": "R3",
                "description": (
                    "Mosaic plot with correctly proportioned column widths and within-group segment heights, "
                    "all clearly labeled. Written answer: 'Evening has the largest proportion of high-"
                    "caffeine students.'"
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "not_earned"},
                "reviewer_note": "The graph is fully correct, and Evening does happen to have both the largest proportion and the largest count of high-caffeine students, but the response answers a different question than the one asked (proportion rather than count) -- the criterion specifically requires count-based reasoning ('largest number'), which is a distinct comparison from proportion and would give a different answer with a different dataset. Flags: proportion-vs-count conflation, same failure pattern as statistics_hand_drawn_03's R3.",
                "boundary_tags": ["proportion_count_conflation"],
            },
            {
                "id": "R4",
                "description": (
                    "Mosaic plot with column widths proportional to group totals (90, 110, 100 out of 300) "
                    "and segment heights proportional to within-group caffeine-use distributions, all "
                    "columns and segments labeled with study-time and caffeine-level names. Written answer: "
                    "'Evening has the largest number of high-caffeine students: 46, compared with 32 for "
                    "Afternoon and 12 for Morning, even though Afternoon has the largest total group size "
                    "(110 students).'"
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Second full-credit response with an additional correct observation distinguishing the largest-count group from the largest-total-group; useful for confirming the grader rewards the extra correct distinction.",
                "boundary_tags": [],
            },
            {
                "id": "R5",
                "description": (
                    "Mosaic plot with correctly proportioned column widths and correctly labeled study-time "
                    "groups. Within each column, segment heights are drawn but two of the nine total segments "
                    "(Afternoon-Medium and Evening-Low) look visually similar in height to their neighbors "
                    "due to close underlying proportions, making it hard to be fully certain from the drawing "
                    "alone whether those two specific segments are proportioned correctly or just eyeballed "
                    "close. The final high-caffeine count comparison is stated correctly."
                ),
                "labels": {"C1": "earned", "C2": "unable_to_determine", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Most of the mosaic plot is clearly correct and the final answer is right, but two specific segments are close enough in apparent size that a confident earned/not_earned call on the height-proportionality criterion isn't possible without measuring the actual page -- flagged unable_to_determine rather than assumed correct just because the final answer is right. Flags: visual ambiguity in a subset of segments, correct final answer does not resolve an upstream ambiguous criterion.",
                "boundary_tags": ["visual_ambiguity"],
            },
        ],
    },
    {
        "id": "statistics_hand_drawn_09",
        "source_item_id": "APSTATS-HDG-2026-GRAPH-010",
        "archetype": "dotplot_distribution_shape",
        "title": "Dotplot of Plant Heights After Four Weeks",
        "stem": "A biology class measured the heights of 12 plants after four weeks. Construct a dotplot of the data, then describe the distribution's shape and comment on whether there is a clear outlier.",
        "display_table": [{"Height (cm)": v} for v in [68, 70, 71, 72, 72, 73, 74, 74, 75, 76, 78, 82]],
        "criteria": [
            {"id": "C1", "text": "Plots the correct number of dots at each plant height.", "notes": "Reused directly from source DOT_COUNTS."},
            {"id": "C2", "text": "Uses an interpretable numeric scale covering 68 through 82.", "notes": "Reused directly from source AXIS_SCALE."},
            {"id": "C3", "text": "Describes the distribution as roughly unimodal with slight right tail or similar.", "notes": "Reused directly from source SHAPE_DESCRIPTION."},
            {"id": "C4", "text": "Does not overstate 82 cm as a definite outlier; explains it is high or possibly unusual.", "notes": "Reused directly from source OUTLIER_NOTE."},
        ],
        "responses": [
            {
                "id": "R1",
                "description": (
                    "Dotplot on a numeric axis from 68 to 82 cm, dots correctly stacked at 68, 70, 71, two "
                    "at 72, one at 73, two at 74, one at 75, one at 76, one at 78, one at 82. Written answer: "
                    "'The distribution of plant heights is roughly unimodal with a slight right tail, with "
                    "most heights clustered between 70 and 78 cm. The height of 82 cm is on the high end and "
                    "somewhat separated from the rest of the data, but it is not clearly isolated enough to "
                    "call it a definite outlier.'"
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit response with correct dot counts, an interpretable axis, and a shape/outlier description that avoids overstating 82 cm as a definite outlier while still noting it is high, matching the source item's specific intent of testing appropriately hedged outlier language.",
                "boundary_tags": [],
            },
            {
                "id": "R2",
                "description": (
                    "Dotplot with dots correctly stacked matching the table, on an axis from 68 to 82. "
                    "Written answer: 'The distribution is roughly symmetric and bell-shaped. 82 cm is "
                    "definitely an outlier and should be removed from the data before further analysis.'"
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "not_earned", "C4": "not_earned"},
                "reviewer_note": "Dot counts and axis are correct. But the shape description misses the slight right-skew (the distribution has a bit more spread on the high side, from 76 to 82, than on the low side) by calling it simply 'symmetric and bell-shaped.' The outlier statement also overreaches -- 82 cm is only 4 cm above the next-highest value (78) and 14 cm above the minimum (68), which is high but not dramatically separated enough to be called 'definitely' an outlier, and recommending removal goes beyond what this single description task calls for. Flags: shape description overlooks slight skew, outlier claim overstated exactly as this item's OUTLIER_NOTE criterion is designed to catch.",
                "boundary_tags": ["overstated_certainty", "shape_description_overlooks_skew"],
            },
            {
                "id": "R3",
                "description": (
                    "Dotplot with correct dot counts on a correct axis. Written answer: 'Roughly unimodal, "
                    "slight right tail. 82 might be unusual.'"
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Brief but complete and correctly hedged -- 'might be unusual' appropriately avoids overstating 82 as a definite outlier while still flagging it as noteworthy, matching the criterion's intent. Full-credit response demonstrating that terse phrasing can still meet the bar if the substance is correct.",
                "boundary_tags": [],
            },
            {
                "id": "R4",
                "description": (
                    "Dotplot with correct dot counts (68, 70, 71, two at 72, one at 73, two at 74, one at "
                    "75, one at 76, one at 78, one at 82) on a numeric axis from 68 to 82. Written answer: "
                    "'The plant heights form a roughly unimodal distribution with a slight tail toward higher "
                    "values. The 82 cm plant is noticeably taller than the rest but not isolated enough from "
                    "the cluster (which extends up to 78 cm) to be confidently labeled an outlier -- it may "
                    "simply be a naturally taller plant.'"
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Second full-credit response with more detailed reasoning about why 82 cm shouldn't be called a definite outlier; confirms grader consistency for a more elaborated answer.",
                "boundary_tags": [],
            },
            {
                "id": "R5",
                "description": (
                    "Dotplot with dots correctly stacked at all values except only one dot shown at 72 "
                    "instead of two (missing one of the two plants at 72 cm). Axis and all other placements "
                    "correct. Written answer correctly describes the shape and appropriately hedges on the "
                    "82 cm value."
                ),
                "labels": {"C1": "not_earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "One dot is missing at 72 cm, failing the dot-count criterion even though the shape and outlier descriptions (which depend mainly on the overall spread and the top value, not on this specific interior duplicate) remain correct and appropriately hedged. Flags: single dot omitted at an interior value, illustrates the dot-count criterion can fail independently of the shape/outlier criteria.",
                "boundary_tags": ["under_credit_risk", "single_dot_omitted"],
            },
        ],
    },
    {
        "id": "statistics_hand_drawn_10",
        "source_item_id": "APSTATS-HDG-2026-GRAPH-011",
        "archetype": "scatterplot_regression_context",
        "title": "Scatterplot of Screen Brightness and Battery Remaining",
        "stem": "A technology club measured screen brightness and battery remaining after one hour for nine phones. Construct a scatterplot, sketch a reasonable least-squares trend line, and describe the direction, form, and strength of the association in context.",
        "display_table": [
            {"Screen brightness (%)": 12, "Battery remaining (%)": 88}, {"Screen brightness (%)": 14, "Battery remaining (%)": 84},
            {"Screen brightness (%)": 15, "Battery remaining (%)": 82}, {"Screen brightness (%)": 17, "Battery remaining (%)": 79},
            {"Screen brightness (%)": 18, "Battery remaining (%)": 77}, {"Screen brightness (%)": 20, "Battery remaining (%)": 73},
            {"Screen brightness (%)": 21, "Battery remaining (%)": 70}, {"Screen brightness (%)": 23, "Battery remaining (%)": 66},
            {"Screen brightness (%)": 25, "Battery remaining (%)": 63},
        ],
        "criteria": [
            {"id": "C1", "text": "Plots all nine ordered pairs at recoverable locations.", "notes": "Reused directly from source POINTS_PLOTTED."},
            {"id": "C2", "text": "Labels screen brightness and battery remaining on the correct axes.", "notes": "Reused directly from source AXIS_LABELS."},
            {"id": "C3", "text": "Sketches a reasonable decreasing line through the point cloud.", "notes": "Reused directly from source TREND_LINE."},
            {"id": "C4", "text": "Describes strong negative roughly linear association in context.", "notes": "Reused directly from source ASSOCIATION_DESCRIPTION."},
        ],
        "responses": [
            {
                "id": "R1",
                "description": (
                    "Scatterplot with x-axis labeled 'Screen brightness (%)' and y-axis labeled 'Battery "
                    "remaining (%),' all nine points plotted at positions matching the table, closely "
                    "following a decreasing linear pattern. A single straight trend line sketched falling "
                    "from about (12, 88) to about (25, 63). Written answer: 'There is a strong, negative, "
                    "roughly linear association between screen brightness and battery remaining -- phones "
                    "with higher screen brightness tended to have less battery remaining after one hour, and "
                    "the points fall close to a straight decreasing line.'"
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit response with all points plotted accurately, correct axis labels, a reasonable decreasing trend line, and a correctly contextualized direction/form/strength description.",
                "boundary_tags": [],
            },
            {
                "id": "R2",
                "description": (
                    "Scatterplot with correct axis labels and all nine points plotted accurately, closely "
                    "following the decreasing pattern. Trend line sketched, but drawn increasing (rising) "
                    "from lower-left to upper-right instead of falling, which does not match the visibly "
                    "downward-sloping point cloud. Written answer: 'There is a strong positive linear "
                    "association between screen brightness and battery remaining.'"
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "not_earned", "C4": "not_earned"},
                "reviewer_note": "Points and axis labels are correct, but both the sketched trend line and the written description invert the direction of the association -- the data clearly decreases (higher brightness, less battery remaining), and both the line and the words describe it as increasing/positive instead. Flags: direction reversed in both the sketched line and the written description.",
                "boundary_tags": ["direction_reversed"],
            },
            {
                "id": "R3",
                "description": (
                    "Scatterplot with correct axis labels, all nine points plotted accurately, and a "
                    "reasonable decreasing trend line. Written answer: 'Screen brightness and battery "
                    "remaining are related.'"
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "not_earned"},
                "reviewer_note": "The graph and trend line are both correct, but the written description never states the direction (negative), form (linear), or strength (strong) of the association -- 'are related' is far too vague to demonstrate the specific description the criterion requires. Flags: vague generality, over-credit risk if grader accepts a bare association claim without direction/form/strength.",
                "boundary_tags": ["vague_generality", "over_credit_risk"],
            },
            {
                "id": "R4",
                "description": (
                    "Scatterplot with correct axis labels, all nine points plotted accurately, and a "
                    "reasonable decreasing trend line sketched from about (12, 87) to about (25, 64). "
                    "Written answer: 'The scatterplot shows a strong, negative, roughly linear association: "
                    "as screen brightness increases, battery remaining after one hour tends to decrease, and "
                    "the points cluster tightly around the falling trend line.'"
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Second full-credit response with a slightly different but still reasonable trend-line reading; confirms grader tolerance for hand-drawn line variation.",
                "boundary_tags": [],
            },
            {
                "id": "R5",
                "description": (
                    "Scatterplot with correct axis labels and all nine points plotted accurately. Trend line "
                    "is sketched correctly decreasing, but it is drawn noticeably steeper than the actual "
                    "data trend, running from about (12, 95) to about (25, 55) -- overshooting both ends of "
                    "the point cloud's actual range. Written answer correctly describes a strong negative "
                    "roughly linear association."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "unable_to_determine", "C4": "earned"},
                "reviewer_note": "The trend line's direction is correct but its slope is visibly steeper than the point cloud actually supports, overshooting the data range at both ends rather than passing through it -- it's a judgment call whether this still counts as 'a reasonable decreasing line through the point cloud' given the correct direction but poor fit, or whether the overshoot is severe enough to fail the criterion; flagged unable_to_determine for a reviewer to judge against the actual drawn line rather than assumed from this description alone. Flags: rubric ambiguity on trend-line fit quality vs. mere direction correctness.",
                "boundary_tags": ["rubric_ambiguity", "visual_ambiguity"],
            },
        ],
    },
]
