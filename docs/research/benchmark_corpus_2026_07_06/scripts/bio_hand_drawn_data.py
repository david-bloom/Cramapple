# AI-provisional (Claude-authored) Biology hand-drawn corpus data.
# NOT Learning-Quality-approved. Question stems, tables, and capture instructions
# are reused from the existing hand_drawn_graph_corpus_2026_06_30 item pool
# (HDG-2026-P2-*); this file adds the labeled response layer on top, condensing
# each source item's 6-9-criterion rubric to a 4-criterion grading contract.
#
# IMPORTANT: no real photographed student responses exist for these items.
# Each "response" below is a textual description of what a hypothetical drawn
# page would show, standing in for an actual photograph. This is explicitly
# NOT the same as real hand-drawn capture data and must not be represented as
# such downstream.

CAT_CRITERIA = [
    {"id": "C1", "text": "Uses an accepted categorical representation (bar-with-whisker or point-with-whisker graph) with all four treatments identifiable and in table order.", "notes": "Condensed from source REPRESENTATION_TYPE + CATEGORY_IDENTITY."},
    {"id": "C2", "text": "Y-axis is labeled with the correct variable and unit, and the scale is interpretable and can represent all four means and their SEM bars.", "notes": "Condensed from source Y_UNIT + Y_SCALE."},
    {"id": "C3", "text": "All four means are plotted at positions recoverable from the graph and consistent with the data table.", "notes": "Same as source PLOT_VALUES."},
    {"id": "C4", "text": "Each mean has centered, symmetric plus/minus one SEM error bars.", "notes": "Same as source UNCERTAINTY_MARKS."},
]

SER_CRITERIA = [
    {"id": "C1", "text": "Uses an accepted representation for a continuous measured series (points connected in x-order by line segments).", "notes": "Condensed from source REPRESENTATION_TYPE."},
    {"id": "C2", "text": "Both axes are labeled with the correct variable and unit, and both scales can represent the full range of the data.", "notes": "Condensed from source X_UNIT + Y_UNIT + X_SCALE + Y_SCALE."},
    {"id": "C3", "text": "All measured points are plotted at positions recoverable from the graph and consistent with the table, and adjacent points are connected in measured order.", "notes": "Condensed from source PLOT_VALUES + POINT_CONNECTION."},
    {"id": "C4", "text": "Each point has centered, symmetric plus/minus one SEM error bars.", "notes": "Same as source UNCERTAINTY_MARKS."},
]

EST_CRITERIA = [
    {"id": "C1", "text": "Uses a scatterplot representation with both axes correctly labeled with variable and unit and scaled to fit the data range.", "notes": "Condensed from source REPRESENTATION_TYPE + X_UNIT + Y_UNIT + X_SCALE + Y_SCALE."},
    {"id": "C2", "text": "All paired observations are plotted at positions recoverable from the graph and consistent with the table.", "notes": "Same as source PLOT_VALUES."},
    {"id": "C3", "text": "Draws one smooth best-fit relationship (line or curve) representing the trend through the plotted points, not a point-to-point connection.", "notes": "Same as source BEST_FIT_RELATIONSHIP."},
    {"id": "C4", "text": "Marks where the best-fit relationship crosses zero change and reports a numeric estimate with correct units consistent with the graph.", "notes": "Condensed from source ZERO_INTERCEPT_ANNOTATION + ESTIMATE_VALUE."},
]

BIO_HAND_DRAWN_ITEMS = [
    {
        "id": "biology_hand_drawn_01",
        "source_item_id": "HDG-2026-P2-CAT-001",
        "archetype": "categorical_comparison_supplied_uncertainty",
        "title": "Chlorophyll Absorbance Across Four Light Treatments",
        "stem": "Researchers measured chlorophyll absorbance for four treatment groups. Use the data table to construct a graph that compares the group means. Include a categorical x-axis with the treatments in table order, a y-axis labeled with units, plotted means, and symmetric error bars showing plus or minus one SEM.",
        "display_table": [
            {"Treatment": "low blue", "Mean absorbance at 540 nm (a.u.)": 44.0, "SEM (a.u.)": 1.2},
            {"Treatment": "moderate blue", "Mean absorbance at 540 nm (a.u.)": 32.0, "SEM (a.u.)": 0.6},
            {"Treatment": "high blue", "Mean absorbance at 540 nm (a.u.)": 59.0, "SEM (a.u.)": 1.1},
            {"Treatment": "mixed light", "Mean absorbance at 540 nm (a.u.)": 52.0, "SEM (a.u.)": 0.7},
        ],
        "capture_instruction": "Draw one graph on one page. Write only the item ID at the top of the page, then photograph the full page with all graph evidence visible. Do not expose criterion definitions to the person drawing the graph.",
        "criteria": CAT_CRITERIA,
        "responses": [
            {
                "id": "R1",
                "description": (
                    "Bar graph with four bars in table order (low blue, moderate blue, high blue, mixed "
                    "light), x-axis labeled 'Treatment.' Y-axis labeled 'Mean absorbance at 540 nm (a.u.)' "
                    "with evenly spaced gridlines from 0 to 65 in steps of 5. Bar heights closely match "
                    "44, 32, 59, 52. Each bar has a centered whisker extending symmetrically above and below "
                    "the bar top, with cap widths roughly matching the reported SEM values (1.2, 0.6, 1.1, 0.7)."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit response. Graph type, category order, axis labeling/scale, plotted values, and error bars all match the source data.",
                "boundary_tags": [],
            },
            {
                "id": "R2",
                "description": (
                    "Bar graph with bars in the order high blue, low blue, mixed light, moderate blue (not "
                    "table order). Y-axis has no unit label, just 'Absorbance.' Bar heights are close to the "
                    "correct means. No error bars of any kind are drawn."
                ),
                "labels": {"C1": "not_earned", "C2": "not_earned", "C3": "earned", "C4": "not_earned"},
                "reviewer_note": "Category order does not follow the table, so C1 (which requires table-order category identity) is not earned even though the representation type itself is acceptable. Y-axis label is missing its unit, so C2 is not earned. Values are plotted reasonably accurately (C3 earned). No uncertainty marks appear at all -- clear miss, not an ambiguous case. Flags: category order not preserved, missing axis unit, missing evidence for uncertainty.",
                "boundary_tags": ["missing_evidence", "rubric_drift_category_order"],
            },
            {
                "id": "R3",
                "description": (
                    "Bar graph in correct table order, y-axis labeled 'Mean absorbance at 540 nm (a.u.)' with "
                    "an interpretable scale. Bar heights match the table well. Error bars are drawn, but they "
                    "appear only above each bar (not below), and the cap width looks closer to double the "
                    "reported SEM than to a single SEM."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "not_earned"},
                "reviewer_note": "Graph type, order, axis, and plotted values are all correct. Error bars are present but are one-sided rather than symmetric, and appear closer to +/-2 SEM in magnitude than +/-1 SEM as specified -- this does not meet the 'centered, symmetric, one-SEM' requirement. Flags: visual misread of uncertainty convention (one-sided bars), possible SEM-vs-2xSEM confusion.",
                "boundary_tags": ["visual_misread", "over_credit_risk_if_bars_uncounted"],
            },
            {
                "id": "R4",
                "description": (
                    "Point-with-whisker graph (dots instead of bars) in correct table order, y-axis correctly "
                    "labeled and scaled. Dots are placed at heights matching 44, 32, 59, 52, each with a "
                    "symmetric whisker matching the reported SEM."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Second full-credit response using the point-with-whisker variant explicitly listed as acceptable in the source item's accepted_variants; confirms grader tolerance for both bar and point representations.",
                "boundary_tags": [],
            },
            {
                "id": "R5",
                "description": (
                    "Bar graph in correct table order with a y-axis labeled 'Absorbance (a.u.)' but with an "
                    "unevenly spaced, hand-drawn scale that compresses the space between 40 and 60, making the "
                    "high blue (59) and mixed light (52) bars look nearly the same height even though they "
                    "should differ by 7 units. Error bars are present and roughly symmetric, but their exact "
                    "width is hard to measure precisely against the compressed scale."
                ),
                "labels": {"C1": "earned", "C2": "unable_to_determine", "C3": "unable_to_determine", "C4": "unable_to_determine"},
                "reviewer_note": "Graph type and category order are clearly correct. However, the compressed/uneven y-scale makes it genuinely hard to verify whether the plotted values and error-bar widths recover the reported numbers precisely -- this is a visual-ambiguity case rather than a clear pass or fail, and should not be scored as earned or not_earned without a second reviewer's measurement pass on the actual image. Flags: visual ambiguity from uneven scale, reviewer disagreement risk.",
                "boundary_tags": ["visual_ambiguity", "rubric_drift_scale_uniformity"],
            },
        ],
    },
    {
        "id": "biology_hand_drawn_02",
        "source_item_id": "HDG-2026-P2-CAT-002",
        "archetype": "categorical_comparison_supplied_uncertainty",
        "title": "Stomatal Density Across Four Light Exposure Treatments",
        "stem": "Researchers measured leaf pore density for four treatment groups. Use the data table to construct a graph that compares the group means. Include a categorical x-axis with the treatments in table order, a y-axis labeled with units, plotted means, and symmetric error bars showing plus or minus one SEM.",
        "display_table": [
            {"Treatment": "deep shade", "Mean stomatal density (stomata/mm^2)": 32.0, "SEM (stomata/mm^2)": 0.8},
            {"Treatment": "partial shade", "Mean stomatal density (stomata/mm^2)": 70.0, "SEM (stomata/mm^2)": 0.8},
            {"Treatment": "open sun", "Mean stomatal density (stomata/mm^2)": 20.0, "SEM (stomata/mm^2)": 0.3},
            {"Treatment": "reflected sun", "Mean stomatal density (stomata/mm^2)": 47.0, "SEM (stomata/mm^2)": 0.8},
        ],
        "capture_instruction": "Draw one graph on one page. Write only the item ID at the top of the page, then photograph the full page with all graph evidence visible. Do not expose criterion definitions to the person drawing the graph.",
        "criteria": CAT_CRITERIA,
        "responses": [
            {
                "id": "R1",
                "description": (
                    "Bar graph in table order (deep shade, partial shade, open sun, reflected sun), y-axis "
                    "labeled 'Mean stomatal density (stomata/mm^2)' with a clean 0-80 scale in steps of 10. "
                    "Bar heights closely match 32, 70, 20, 47. Each bar has a small, centered, symmetric "
                    "whisker consistent with the reported SEMs."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit response matching the source data on every criterion.",
                "boundary_tags": [],
            },
            {
                "id": "R2",
                "description": (
                    "A line graph connecting the four treatment means with straight segments, x-axis in "
                    "table order but treated as if it were a continuous numeric variable. Y-axis correctly "
                    "labeled and scaled. Error bars present and symmetric."
                ),
                "labels": {"C1": "not_earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Treatment is a categorical variable (four unordered light-exposure conditions), not a continuous quantity, so connecting the means with line segments as though it were a continuous series is not an accepted categorical representation -- this is the specific error the categorical-vs-series distinction is meant to catch, even though axis labeling, values, and uncertainty marks are otherwise correct. Flags: wrong representation type for a categorical variable, boundary case between CAT and SER archetypes.",
                "boundary_tags": ["wrong_representation_for_variable_type", "rubric_drift_categorical_vs_series"],
            },
            {
                "id": "R3",
                "description": (
                    "Bar graph in table order, y-axis labeled only 'Density' (no unit, no full variable "
                    "name). Bar heights match the table. Error bars present and symmetric, matching reported "
                    "SEMs."
                ),
                "labels": {"C1": "earned", "C2": "not_earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Everything is correct except the y-axis label drops both the specific variable name (stomatal density) and the unit (stomata/mm^2), leaving only the generic word 'Density' -- insufficient to identify what is actually being measured from the graph alone. Flags: axis label under-specified, over-credit risk if grader treats a generic label as sufficient.",
                "boundary_tags": ["over_credit_risk", "axis_label_underspecified"],
            },
            {
                "id": "R4",
                "description": (
                    "Point-with-whisker graph in table order, y-axis correctly labeled and scaled. Points "
                    "plotted at approximately 34, 68, 22, 46 -- each within about 2 units of the reported "
                    "means. Symmetric whiskers present and roughly matching reported SEMs."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Values are plotted slightly off the exact table numbers (within about 2 units), which is within the tolerance expected from hand-drawn graph reading against a ruled scale -- still earns PLOT_VALUES. Second full-credit response confirming the tolerance band for 'recoverable from the graph.'",
                "boundary_tags": [],
            },
            {
                "id": "R5",
                "description": (
                    "Bar graph in table order, y-axis correctly labeled and scaled, bar heights matching the "
                    "table. Error bars are drawn on only two of the four bars (deep shade and open sun); the "
                    "other two bars (partial shade and reflected sun) have no visible whiskers at all."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "not_earned"},
                "reviewer_note": "Uncertainty marks are required on every mean, not just some -- two of four bars are entirely missing whiskers, which is a clear (not ambiguous) partial failure of C4. Flags: partial/inconsistent uncertainty marking, under-credit risk if grader awards C4 for 'some bars have error bars.'",
                "boundary_tags": ["under_credit_risk", "partial_uncertainty_marking"],
            },
        ],
    },
    {
        "id": "biology_hand_drawn_03",
        "source_item_id": "HDG-2026-P2-CAT-004",
        "archetype": "categorical_comparison_supplied_uncertainty",
        "title": "Root Tip Mitotic Index Across Four Temperature Treatments",
        "stem": "Researchers measured root tip mitosis for four treatment groups. Use the data table to construct a graph that compares the group means. Include a categorical x-axis with the treatments in table order, a y-axis labeled with units, plotted means, and symmetric error bars showing plus or minus one SEM.",
        "display_table": [
            {"Treatment": "cool", "Mean mitotic cells (%)": 11.0, "SEM (%)": 0.3},
            {"Treatment": "room temp", "Mean mitotic cells (%)": 31.0, "SEM (%)": 1.0},
            {"Treatment": "warm", "Mean mitotic cells (%)": 36.0, "SEM (%)": 0.7},
            {"Treatment": "heat stress", "Mean mitotic cells (%)": 40.0, "SEM (%)": 1.6},
        ],
        "capture_instruction": "Draw one graph on one page. Write only the item ID at the top of the page, then photograph the full page with all graph evidence visible. Do not expose criterion definitions to the person drawing the graph.",
        "criteria": CAT_CRITERIA,
        "responses": [
            {
                "id": "R1",
                "description": (
                    "Bar graph in table order (cool, room temp, warm, heat stress), y-axis labeled 'Mean "
                    "mitotic cells (%)' with a 0-45 scale in steps of 5. Bar heights match 11, 31, 36, 40. "
                    "Symmetric whiskers on each bar matching the reported SEMs (0.3, 1.0, 0.7, 1.6)."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit response matching the source data on every criterion, including the largest SEM (heat stress, 1.6) drawn visibly wider than the smallest (cool, 0.3).",
                "boundary_tags": [],
            },
            {
                "id": "R2",
                "description": (
                    "Bar graph with bars for cool, room temp, warm, heat stress in table order, y-axis "
                    "labeled '% mitotic cells.' Bar heights for cool, room temp, and warm match the table, "
                    "but the heat stress bar is drawn noticeably shorter, at roughly 25 rather than 40."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "not_earned", "C4": "earned"},
                "reviewer_note": "Three of four bars are plotted accurately, but the fourth (heat stress) is off by roughly 15 percentage points -- well outside a reasonable hand-drawn reading tolerance, so C3 (all four means recoverable and consistent with the table) is not earned even though most of the graph is correct. Flags: partial plotting error, under-credit risk if grader treats 'mostly correct' as sufficient for a criterion requiring all four values.",
                "boundary_tags": ["under_credit_risk", "partial_plotting_error"],
            },
            {
                "id": "R3",
                "description": (
                    "Bar graph in table order, y-axis correctly labeled and scaled, all four bar heights "
                    "matching the table closely. All four bars have symmetric whiskers, but every whisker "
                    "appears to be the same fixed width regardless of the differing reported SEM values "
                    "(0.3 vs. 1.6)."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "not_earned"},
                "reviewer_note": "Error bars are present and visually symmetric, but they do not scale with the reported SEM magnitudes -- the cool treatment's much smaller SEM (0.3) should look visibly narrower than heat stress's (1.6), and here all four look identical. This does not meet the uncertainty-marks criterion, which requires the bars to represent the actual reported SEM per treatment, not a uniform decorative whisker. Flags: uncertainty marks present but not data-driven, over-credit risk if grader checks only for whisker presence.",
                "boundary_tags": ["over_credit_risk", "uncertainty_marks_not_data_driven"],
            },
            {
                "id": "R4",
                "description": (
                    "Point-with-whisker graph in table order, y-axis correctly labeled and scaled. Points at "
                    "approximately 11, 30, 37, 41 -- each within about 1-2 units of the table. Whisker widths "
                    "visibly scale with the reported SEMs, narrowest at cool and widest at heat stress."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Second full-credit response; confirms the point-with-whisker variant is scored identically to the bar variant when all criteria are met.",
                "boundary_tags": [],
            },
            {
                "id": "R5",
                "description": (
                    "Bar graph with bars in the order cool, room temp, heat stress, warm (heat stress and "
                    "warm swapped relative to the table). Y-axis correctly labeled and scaled. Bar heights "
                    "for the swapped pair match their own data (heat stress at 40, warm at 36) but appear in "
                    "the wrong x-axis position. Symmetric whiskers present matching each bar's own SEM."
                ),
                "labels": {"C1": "not_earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "The magnitudes and uncertainty bars are all individually correct for whichever treatment they're attached to, but two categories are swapped out of table order, which fails the category-identity half of C1 even though every other criterion checks out. Flags: category order violation, illustrates that C1 can fail independently of C3/C4 being otherwise clean.",
                "boundary_tags": ["rubric_drift_category_order"],
            },
        ],
    },
    {
        "id": "biology_hand_drawn_04",
        "source_item_id": "HDG-2026-P2-CAT-005",
        "archetype": "categorical_comparison_supplied_uncertainty",
        "title": "Enzyme Product Formed Across Four pH Treatments",
        "stem": "Researchers measured enzyme product for four treatment groups. Use the data table to construct a graph that compares the group means. Include a categorical x-axis with the treatments in table order, a y-axis labeled with units, plotted means, and symmetric error bars showing plus or minus one SEM.",
        "display_table": [
            {"Treatment": "pH 5", "Mean product formed in 5 min (umol)": 14.0, "SEM (umol)": 0.3},
            {"Treatment": "pH 6", "Mean product formed in 5 min (umol)": 31.0, "SEM (umol)": 0.9},
            {"Treatment": "pH 7", "Mean product formed in 5 min (umol)": 23.0, "SEM (umol)": 0.5},
            {"Treatment": "pH 8", "Mean product formed in 5 min (umol)": 35.0, "SEM (umol)": 0.7},
        ],
        "capture_instruction": "Draw one graph on one page. Write only the item ID at the top of the page, then photograph the full page with all graph evidence visible. Do not expose criterion definitions to the person drawing the graph.",
        "criteria": CAT_CRITERIA,
        "responses": [
            {
                "id": "R1",
                "description": (
                    "Bar graph in table order (pH 5, pH 6, pH 7, pH 8), y-axis labeled 'Mean product formed "
                    "in 5 min (umol)' with a 0-40 scale in steps of 5. Bar heights match 14, 31, 23, 35. "
                    "Symmetric whiskers matching the reported SEMs."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit response matching the source data on every criterion, including the non-monotonic pattern (pH 7 lower than both pH 6 and pH 8) reproduced correctly.",
                "boundary_tags": [],
            },
            {
                "id": "R2",
                "description": (
                    "Bar graph with bars reordered from low to high value: pH 5, pH 7, pH 6, pH 8 (sorted "
                    "by product amount rather than by table/pH order). Y-axis correctly labeled and scaled, "
                    "bar heights and error bars all individually correct."
                ),
                "labels": {"C1": "not_earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Reordering by value rather than preserving table order changes the apparent pH sequence and obscures the pH-7-dip pattern that the original table order is designed to show -- category identity/order is not preserved, so C1 is not earned even though all four bars are individually accurate. Flags: category order violation via value-sorting.",
                "boundary_tags": ["rubric_drift_category_order"],
            },
            {
                "id": "R3",
                "description": (
                    "Bar graph in table order, y-axis labeled 'Product (umol)' with a scale from 0 to 40. "
                    "Bar heights match the table. Whiskers are drawn, but they extend asymmetrically -- "
                    "notably longer above the bar top than below it on all four bars."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "not_earned"},
                "reviewer_note": "Everything else is correct, but the error bars are consistently asymmetric (longer above than below) rather than centered plus/minus one SEM -- this is a clear, not ambiguous, failure since the asymmetry is consistent across all four bars rather than a single measurement artifact. Flags: visual misread of symmetric-uncertainty convention.",
                "boundary_tags": ["visual_misread"],
            },
            {
                "id": "R4",
                "description": (
                    "Point-with-whisker graph in table order, y-axis correctly labeled and scaled. Points at "
                    "approximately 14, 32, 22, 36 -- each within about 1-2 units of the table. Symmetric "
                    "whiskers matching the reported SEMs."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Second full-credit response within normal hand-drawn reading tolerance; confirms grader consistency for the point-with-whisker variant.",
                "boundary_tags": [],
            },
            {
                "id": "R5",
                "description": (
                    "Bar graph in table order, y-axis labeled and scaled correctly. Bar heights approximately "
                    "match the table, but the page is a low-resolution photo with significant glare across "
                    "the pH 6 and pH 7 bars, making it difficult to tell whether whiskers are present on "
                    "those two bars specifically; pH 5 and pH 8 clearly show symmetric whiskers."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "unable_to_determine"},
                "reviewer_note": "Image quality (glare) genuinely obscures whether two of the four required error bars are present -- this should be routed back for a rescan/reshoot rather than scored as either earned or not_earned from this capture. Flags: visual ambiguity from image capture quality, distinct from a genuine drawing omission.",
                "boundary_tags": ["visual_ambiguity", "missing_evidence"],
            },
        ],
    },
    {
        "id": "biology_hand_drawn_05",
        "source_item_id": "HDG-2026-P2-SER-001",
        "archetype": "continuous_measured_series_supplied_uncertainty",
        "title": "Enzyme Reaction Rate Across a Temperature Series",
        "stem": "Researchers measured enzyme reaction rate at several values of temperature. Use the data table to construct a graph with temperature on the x-axis and mean reaction rate on the y-axis. Plot each mean at its measured x-value, connect adjacent measured values, and include symmetric error bars showing plus or minus one SEM.",
        "display_table": [
            {"temperature (deg C)": 10, "Mean reaction rate (umol/min)": 46.0, "SEM (umol/min)": 1.3},
            {"temperature (deg C)": 15, "Mean reaction rate (umol/min)": 63.0, "SEM (umol/min)": 1.9},
            {"temperature (deg C)": 20, "Mean reaction rate (umol/min)": 60.0, "SEM (umol/min)": 1.2},
            {"temperature (deg C)": 28, "Mean reaction rate (umol/min)": 48.0, "SEM (umol/min)": 1.0},
            {"temperature (deg C)": 42, "Mean reaction rate (umol/min)": 23.0, "SEM (umol/min)": 0.3},
            {"temperature (deg C)": 55, "Mean reaction rate (umol/min)": 12.0, "SEM (umol/min)": 0.3},
            {"temperature (deg C)": 60, "Mean reaction rate (umol/min)": 10.0, "SEM (umol/min)": 0.3},
        ],
        "capture_instruction": "Draw one graph on one page. Write only the item ID at the top of the page, then photograph the full page with all graph evidence visible. Do not expose criterion definitions to the person drawing the graph.",
        "criteria": SER_CRITERIA,
        "responses": [
            {
                "id": "R1",
                "description": (
                    "Points plotted at each of the seven temperature values, connected by straight line "
                    "segments in order of increasing temperature, correctly showing the rise from 10 to 15 "
                    "deg C and the fall from 15 deg C onward. X-axis labeled 'Temperature (deg C)' with an "
                    "evenly spaced numeric scale from 0 to 60; y-axis labeled 'Mean reaction rate (umol/min)' "
                    "with a 0-70 scale. Point heights match the table (46, 63, 60, 48, 23, 12, 10). Each point "
                    "has a small, symmetric error bar matching its reported SEM."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit response correctly reproducing the rise-then-fall (optimum-temperature) shape, with correct axes, values, connections, and uncertainty marks.",
                "boundary_tags": [],
            },
            {
                "id": "R2",
                "description": (
                    "Points plotted at even, artificial x-spacing (treating the seven temperatures as though "
                    "they were equally spaced categories rather than their true numeric values: 10, 15, 20, "
                    "28, 42, 55, 60 compressed into uniform gaps). Y-axis correctly labeled and scaled. Point "
                    "heights match the table and points are connected in order. Error bars present and "
                    "symmetric."
                ),
                "labels": {"C1": "earned", "C2": "not_earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "The x-axis fails to represent temperature on a true numeric scale -- treating unevenly spaced measured values as evenly spaced categories distorts the shape of the curve (e.g., the gap between 42 and 55 should be much larger than the gap between 10 and 15, but here they look the same), so the x-scale half of C2 is not earned even though the y-axis and everything else is correct. Flags: x-scale not proportional to true numeric spacing, rubric-drift risk between categorical and continuous x-axis treatment.",
                "boundary_tags": ["rubric_drift_x_scale_proportionality", "over_credit_risk"],
            },
            {
                "id": "R3",
                "description": (
                    "Points plotted at correct x-y positions for all seven temperatures, connected in order. "
                    "X and y axes both correctly labeled and scaled. No error bars appear anywhere on the "
                    "graph."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "not_earned"},
                "reviewer_note": "Clean, accurate graph in every respect except that uncertainty marks are entirely absent -- a clear miss rather than an ambiguous one. Flags: missing evidence for uncertainty representation.",
                "boundary_tags": ["missing_evidence"],
            },
            {
                "id": "R4",
                "description": (
                    "Points plotted at correct positions for all seven temperatures on correctly labeled and "
                    "scaled axes, each with a symmetric error bar matching its SEM. However, the points are "
                    "connected out of x-order -- the line jumps from 20 deg C directly to 42 deg C, then back "
                    "to 28 deg C, before continuing to 55 and 60."
                ),
                "labels": {"C1": "not_earned", "C2": "earned", "C3": "not_earned", "C4": "earned"},
                "reviewer_note": "Every individual point and its error bar is placed correctly, but the connecting lines are drawn out of measured order, which both breaks the point-connection requirement (part of C3) and makes the graph no longer read as a standard measured-series representation (affecting C1, since the resulting zig-zag isn't the accepted 'connect adjacent measured values' representation). Flags: connection-order error, illustrates that correct point placement alone doesn't satisfy C1/C3 if the connecting logic is wrong.",
                "boundary_tags": ["rubric_drift_connection_order", "under_credit_risk"],
            },
            {
                "id": "R5",
                "description": (
                    "Points plotted at correct positions for six of seven temperatures, connected in order, "
                    "correctly labeled/scaled axes, symmetric error bars on all visible points. The 15 deg C "
                    "point (the peak of the curve, reaction rate 63) is missing entirely from the graph -- the "
                    "line goes directly from 10 to 20."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "not_earned", "C4": "earned"},
                "reviewer_note": "Missing exactly the peak data point, which is the most informative value in the series (it establishes the optimum temperature). Six of seven points being correct is not sufficient for C3, which requires all measured points to be recoverable. Flags: single critical point omitted, under-credit risk if grader scores 'mostly complete' as sufficient given how much information the missing point carries.",
                "boundary_tags": ["under_credit_risk", "missing_evidence", "critical_point_omitted"],
            },
        ],
    },
    {
        "id": "biology_hand_drawn_06",
        "source_item_id": "HDG-2026-P2-SER-002",
        "archetype": "continuous_measured_series_supplied_uncertainty",
        "title": "Photosynthetic Oxygen Release Across a Light Intensity Series",
        "stem": "Researchers measured photosynthetic oxygen release at several values of light intensity. Use the data table to construct a graph with light intensity on the x-axis and mean oxygen release on the y-axis. Plot each mean at its measured x-value, connect adjacent measured values, and include symmetric error bars showing plus or minus one SEM.",
        "display_table": [
            {"light intensity (umol photons/m^2/s)": 0, "Mean oxygen release (umol O2/min)": 1.0, "SEM (umol O2/min)": 0.6},
            {"light intensity (umol photons/m^2/s)": 50, "Mean oxygen release (umol O2/min)": 2.0, "SEM (umol O2/min)": 0.3},
            {"light intensity (umol photons/m^2/s)": 350, "Mean oxygen release (umol O2/min)": 15.0, "SEM (umol O2/min)": 0.5},
            {"light intensity (umol photons/m^2/s)": 500, "Mean oxygen release (umol O2/min)": 21.0, "SEM (umol O2/min)": 0.3},
            {"light intensity (umol photons/m^2/s)": 900, "Mean oxygen release (umol O2/min)": 27.0, "SEM (umol O2/min)": 1.0},
            {"light intensity (umol photons/m^2/s)": 1100, "Mean oxygen release (umol O2/min)": 28.0, "SEM (umol O2/min)": 0.4},
            {"light intensity (umol photons/m^2/s)": 1400, "Mean oxygen release (umol O2/min)": 33.0, "SEM (umol O2/min)": 0.5},
        ],
        "capture_instruction": "Draw one graph on one page. Write only the item ID at the top of the page, then photograph the full page with all graph evidence visible. Do not expose criterion definitions to the person drawing the graph.",
        "criteria": SER_CRITERIA,
        "responses": [
            {
                "id": "R1",
                "description": (
                    "Points plotted at all seven light-intensity values, connected in order, correctly "
                    "showing a steep rise at low light intensity that levels off toward a plateau near 1400 "
                    "umol photons/m^2/s. X-axis labeled 'Light intensity (umol photons/m^2/s)' with a 0-1400 "
                    "numeric scale; y-axis labeled 'Mean oxygen release (umol O2/min)' with a 0-35 scale. "
                    "Point heights match the table. Each point has a symmetric error bar matching its SEM."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit response correctly reproducing the saturating (plateauing) light-response curve shape with correct axes, values, connections, and uncertainty marks.",
                "boundary_tags": [],
            },
            {
                "id": "R2",
                "description": (
                    "Points plotted at correct positions for all seven light intensities, connected in "
                    "order. X-axis labeled 'Light' with no unit; y-axis correctly labeled 'Mean oxygen "
                    "release (umol O2/min).' Error bars present and symmetric."
                ),
                "labels": {"C1": "earned", "C2": "not_earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "X-axis label drops both the specific variable name detail and the unit (umol photons/m^2/s), leaving just 'Light' -- insufficient on its own to recover the correct unit of measurement from the graph. Flags: axis label under-specified, over-credit risk if grader accepts a bare generic label for one of the two axes while the other is fully correct.",
                "boundary_tags": ["over_credit_risk", "axis_label_underspecified"],
            },
            {
                "id": "R3",
                "description": (
                    "Points plotted at correct x-y positions for all seven light intensities on correctly "
                    "labeled and scaled axes, connected in order. Error bars are present on the first four "
                    "points (0, 50, 350, 500) but are missing on the remaining three (900, 1100, 1400)."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "not_earned"},
                "reviewer_note": "Only some points have uncertainty marks -- a clear partial failure, not an ambiguous case, since three of seven points have no whisker at all. Flags: partial/inconsistent uncertainty marking.",
                "boundary_tags": ["partial_uncertainty_marking", "under_credit_risk"],
            },
            {
                "id": "R4",
                "description": (
                    "Points plotted at all seven light-intensity values on correctly labeled and scaled "
                    "axes, each with a symmetric error bar matching its SEM. Points are plotted correctly, "
                    "but no connecting lines are drawn between them -- the graph shows an unconnected scatter "
                    "of seven points."
                ),
                "labels": {"C1": "not_earned", "C2": "earned", "C3": "not_earned", "C4": "earned"},
                "reviewer_note": "The prompt specifically instructs connecting adjacent measured values, which is part of the accepted representation for this archetype (a connected series, not an unconnected scatter) -- since the points are not connected, both C1 (representation type) and the connection half of C3 are not earned, even though every point and error bar is individually placed correctly. Flags: missing point-connection, illustrates that accurate plotting alone is not sufficient for this archetype's representation requirement.",
                "boundary_tags": ["missing_evidence", "under_credit_risk"],
            },
            {
                "id": "R5",
                "description": (
                    "Points plotted at correct positions for all seven light intensities, connected in "
                    "order, on correctly labeled and scaled axes. Error bars are drawn on all seven points, "
                    "but for the 0 and 50 light-intensity points, the bars extend downward well below zero "
                    "(the 0-intensity point's bar reaches roughly -1 to 3, when 0 +/- 0.6 SEM should only "
                    "reach about 0.4 to 1.6)."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "unable_to_determine"},
                "reviewer_note": "Most of the graph is correct, but the error bars on the lowest two points appear to be drawn at roughly triple the reported SEM rather than a single SEM -- it's unclear from the description alone whether this is a genuine SEM-magnitude error or an artifact of the point being close to zero making a small absolute bar look visually larger; flagged unable_to_determine pending a reviewer re-measurement against the actual page rather than assumed as a clear miss. Flags: visual ambiguity in bar magnitude near a low baseline value, rubric-drift risk in judging bar width near zero.",
                "boundary_tags": ["visual_ambiguity", "rubric_drift_bar_magnitude_near_zero"],
            },
        ],
    },
    {
        "id": "biology_hand_drawn_07",
        "source_item_id": "HDG-2026-P2-SER-004",
        "archetype": "continuous_measured_series_supplied_uncertainty",
        "title": "Seedling Growth Across Days After Planting",
        "stem": "Researchers measured seedling growth at several values of days after planting. Use the data table to construct a graph with days after planting on the x-axis and mean height on the y-axis. Plot each mean at its measured x-value, connect adjacent measured values, and include symmetric error bars showing plus or minus one SEM.",
        "display_table": [
            {"days after planting (days)": 0, "Mean height (cm)": 19.0, "SEM (cm)": 0.4},
            {"days after planting (days)": 1, "Mean height (cm)": 18.0, "SEM (cm)": 0.3},
            {"days after planting (days)": 3, "Mean height (cm)": 24.0, "SEM (cm)": 0.6},
            {"days after planting (days)": 5, "Mean height (cm)": 29.0, "SEM (cm)": 0.9},
            {"days after planting (days)": 7, "Mean height (cm)": 36.0, "SEM (cm)": 0.9},
            {"days after planting (days)": 11, "Mean height (cm)": 45.0, "SEM (cm)": 0.8},
            {"days after planting (days)": 12, "Mean height (cm)": 53.0, "SEM (cm)": 1.0},
        ],
        "capture_instruction": "Draw one graph on one page. Write only the item ID at the top of the page, then photograph the full page with all graph evidence visible. Do not expose criterion definitions to the person drawing the graph.",
        "criteria": SER_CRITERIA,
        "responses": [
            {
                "id": "R1",
                "description": (
                    "Points plotted at all seven day values (0, 1, 3, 5, 7, 11, 12), connected in order, "
                    "correctly showing the slight early dip (day 0 to day 1) followed by a steady climb. "
                    "X-axis labeled 'Days after planting (days)' with a 0-12 numeric scale; y-axis labeled "
                    "'Mean height (cm)' with a 0-55 scale. Point heights match the table. Each point has a "
                    "symmetric error bar matching its SEM."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit response, notably including the small day-0-to-day-1 dip (19 to 18 cm) rather than smoothing it into a monotonic line, which some responses incorrectly do.",
                "boundary_tags": [],
            },
            {
                "id": "R2",
                "description": (
                    "Points plotted at all seven day values, but the day-0-to-day-1 dip is drawn as a flat "
                    "or slightly rising segment instead of the small decrease shown in the table (19 to 18 "
                    "cm), effectively smoothing over that one data point. All other points, axes, and error "
                    "bars are correct."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "not_earned", "C4": "earned"},
                "reviewer_note": "One of the seven measured values (day 1, height 18) is not accurately recoverable from the graph -- the connecting segment implies a value at or above 19 rather than the measured dip to 18. Even though this is a small, easy-to-overlook discrepancy, the criterion requires all measured points to be recoverable, and smoothing over a real (if small) non-monotonic dip changes the scientific reading of the graph (e.g., possible transplant shock in the first day). Flags: single point smoothed away, under-credit risk if grader treats a 1-unit-scale dip as negligible.",
                "boundary_tags": ["under_credit_risk", "small_dip_smoothed_over"],
            },
            {
                "id": "R3",
                "description": (
                    "Points plotted at correct x-y positions for all seven days, connected in order, on "
                    "correctly labeled and scaled axes. No error bars are drawn on any point."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "not_earned"},
                "reviewer_note": "Clean, accurate graph in every respect except uncertainty marks are completely absent -- a clear miss. Flags: missing evidence for uncertainty representation.",
                "boundary_tags": ["missing_evidence"],
            },
            {
                "id": "R4",
                "description": (
                    "Points plotted at all seven day values on correctly labeled and scaled axes, connected "
                    "in order, each with a symmetric error bar. However, the y-axis scale only runs from 15 "
                    "to 55 rather than starting at 0, without any axis-break indication."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "The y-axis criterion as scoped ('scale can represent the full range of the data') is satisfied even though the axis does not start at zero -- all seven values (18-53) fit within the 15-55 range shown, and the criteria as written do not require a zero-based axis for this archetype. Full-credit response; useful for confirming graders do not penalize a non-zero-based y-axis when it is not explicitly required by the rubric.",
                "boundary_tags": [],
            },
            {
                "id": "R5",
                "description": (
                    "Points plotted at all seven day values, connected in order, on correctly labeled and "
                    "scaled axes, each with a symmetric error bar. The days-11-and-12 points are extremely "
                    "close together on the compressed x-axis used for this hand-drawn page, and the error "
                    "bars on those two points visually overlap enough that it is hard to tell where one "
                    "point's bar ends and the next begins."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "unable_to_determine"},
                "reviewer_note": "The two closely spaced final points (11 and 12 days apart by only 1 day, unlike the earlier gaps) create a genuine visual-crowding issue for verifying individual error bar widths, distinct from a clear omission -- flagged unable_to_determine rather than scored, pending a closer re-measurement against the actual page or a redraw with more x-axis separation. Flags: visual ambiguity from point crowding, not a clear pass/fail case.",
                "boundary_tags": ["visual_ambiguity"],
            },
        ],
    },
    {
        "id": "biology_hand_drawn_08",
        "source_item_id": "HDG-2026-P2-EST-001",
        "archetype": "continuous_relationship_graph_derived_estimate",
        "title": "Water Movement in Model Cells Across External Solute Concentration",
        "stem": "Researchers measured water movement in model cells across a range of external solute concentration. Construct a graph with external solute concentration on the x-axis and percent mass change on the y-axis. Plot the paired observations, draw one best-fit relationship, mark where the relationship crosses zero change, and report the estimated external solute concentration at zero change with units.",
        "display_table": [
            {"external solute concentration (M)": 0.0, "percent mass change (%)": 18.0},
            {"external solute concentration (M)": 0.1, "percent mass change (%)": 14.0},
            {"external solute concentration (M)": 0.2, "percent mass change (%)": 9.0},
            {"external solute concentration (M)": 0.3, "percent mass change (%)": 3.0},
            {"external solute concentration (M)": 0.4, "percent mass change (%)": -1.0},
            {"external solute concentration (M)": 0.6, "percent mass change (%)": -13.0},
            {"external solute concentration (M)": 0.8, "percent mass change (%)": -20.0},
        ],
        "capture_instruction": "Draw one graph on one page. Write only the item ID at the top of the page, then photograph the full page with all graph evidence visible. Do not expose criterion definitions to the person drawing the graph.",
        "criteria": EST_CRITERIA,
        "responses": [
            {
                "id": "R1",
                "description": (
                    "Scatterplot with x-axis labeled 'External solute concentration (M)' on a 0-0.8 scale, "
                    "y-axis labeled 'Percent mass change (%)' on a -25 to +20 scale. All seven points plotted "
                    "at positions matching the table. A single smooth curve is drawn through the points "
                    "(not point-to-point segments), crossing the x-axis at approximately 0.35 M, which is "
                    "marked with a small circle and labeled 'x-intercept ~0.35 M.'"
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit response with correct axes, plotted points, a genuine best-fit relationship (not a point-to-point connection), and a marked, correctly estimated zero-crossing with units.",
                "boundary_tags": [],
            },
            {
                "id": "R2",
                "description": (
                    "Scatterplot with correctly labeled and scaled axes and all seven points plotted "
                    "accurately. Instead of a single smooth best-fit relationship, the points are connected "
                    "with straight point-to-point segments (a jagged line through every point). No "
                    "zero-crossing mark or estimate is given."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "not_earned", "C4": "not_earned"},
                "reviewer_note": "Point-to-point connection is a different representation than the required single best-fit relationship -- this archetype specifically calls for one smooth trend line/curve summarizing the relationship, not a line that passes through every individual point. Because there's no fit line, there's also nothing marked or estimated at the zero-crossing. Flags: point-to-point connection used instead of a best-fit relationship, missing evidence for the zero-crossing estimate.",
                "boundary_tags": ["wrong_representation_for_estimate_task", "missing_evidence"],
            },
            {
                "id": "R3",
                "description": (
                    "Scatterplot with correctly labeled and scaled axes, all seven points plotted "
                    "accurately, and a single smooth best-fit line drawn through the data. The line is "
                    "marked where it crosses zero, but the reported estimate is written as '0.35' with no "
                    "unit given."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "not_earned"},
                "reviewer_note": "Everything up through marking the zero-crossing point on the graph is correct, and the numeric estimate itself (0.35) is accurate, but the criterion requires the estimate to be reported with the correct unit (M) -- a bare number without units is not sufficient given the explicit prompt instruction to 'report the estimated ... concentration at zero change with units.' Flags: units omitted from final reported estimate, over-credit risk if grader accepts the bare number as equivalent.",
                "boundary_tags": ["over_credit_risk", "units_omitted"],
            },
            {
                "id": "R4",
                "description": (
                    "Scatterplot with correctly labeled and scaled axes and all seven points plotted "
                    "accurately. A single smooth best-fit line is drawn through the data, marked where it "
                    "crosses zero at approximately 0.34 M."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Second full-credit response with a slightly different but still reasonable zero-crossing estimate (0.34 vs. 0.35 M), confirming the grader should accept a small range of estimates consistent with reading a hand-drawn best-fit line rather than requiring one exact number.",
                "boundary_tags": [],
            },
            {
                "id": "R5",
                "description": (
                    "Scatterplot with correctly labeled and scaled axes and all seven points plotted "
                    "accurately. Two different best-fit lines are drawn on the same graph: one straight line "
                    "and one slightly curved line, crossing zero at two different points (approximately 0.33 "
                    "M and 0.38 M respectively), with no indication of which one is the intended final answer."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "unable_to_determine", "C4": "unable_to_determine"},
                "reviewer_note": "The rubric calls for one best-fit relationship, and this page shows two conflicting fit lines without a clear indication of which is final -- this is a genuine rubric-drift/ambiguity case (is a corrected/revised second attempt acceptable, or does showing two undermine 'one' relationship entirely?) rather than a clean pass or fail, and should be routed to a reviewer for a policy decision rather than scored outright. Flags: rubric ambiguity on multiple candidate fit lines, downstream estimate also ambiguous as a result.",
                "boundary_tags": ["rubric_ambiguity", "visual_ambiguity"],
            },
        ],
    },
    {
        "id": "biology_hand_drawn_09",
        "source_item_id": "HDG-2026-P2-EST-002",
        "archetype": "continuous_relationship_graph_derived_estimate",
        "title": "Dialysis Bag Mass Change Across Sucrose Concentration",
        "stem": "Researchers measured dialysis bag mass change across a range of sucrose concentration. Construct a graph with sucrose concentration on the x-axis and percent mass change on the y-axis. Plot the paired observations, draw one best-fit relationship, mark where the relationship crosses zero change, and report the estimated sucrose concentration at zero change with units.",
        "display_table": [
            {"sucrose concentration (M)": 0.0, "percent mass change (%)": 24.0},
            {"sucrose concentration (M)": 0.1, "percent mass change (%)": 19.0},
            {"sucrose concentration (M)": 0.2, "percent mass change (%)": 11.0},
            {"sucrose concentration (M)": 0.35, "percent mass change (%)": 4.0},
            {"sucrose concentration (M)": 0.5, "percent mass change (%)": -4.0},
            {"sucrose concentration (M)": 0.7, "percent mass change (%)": -14.0},
            {"sucrose concentration (M)": 0.9, "percent mass change (%)": -25.0},
        ],
        "capture_instruction": "Draw one graph on one page. Write only the item ID at the top of the page, then photograph the full page with all graph evidence visible. Do not expose criterion definitions to the person drawing the graph.",
        "criteria": EST_CRITERIA,
        "responses": [
            {
                "id": "R1",
                "description": (
                    "Scatterplot with x-axis labeled 'Sucrose concentration (M)' on a 0-0.9 scale, y-axis "
                    "labeled 'Percent mass change (%)' on a -25 to +25 scale. All seven points plotted at "
                    "positions matching the table. A single smooth best-fit line crosses the x-axis at "
                    "approximately 0.40 M, marked with a small tick and labeled '~0.40 M.'"
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit response with correct axes, accurate plotted points, a genuine single best-fit line, and a correctly marked and estimated zero-crossing with units.",
                "boundary_tags": [],
            },
            {
                "id": "R2",
                "description": (
                    "Scatterplot with axes swapped: sucrose concentration plotted on the y-axis and percent "
                    "mass change on the x-axis, both correctly labeled for their (swapped) positions and "
                    "correctly scaled. Points plotted consistently with the swapped axes. A best-fit line is "
                    "drawn and a zero-crossing estimate of 0.40 M is reported."
                ),
                "labels": {"C1": "not_earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "The prompt specifically instructs sucrose concentration on the x-axis and percent mass change on the y-axis -- swapping which variable goes on which axis, even when done consistently and correctly labeled, does not match the required graph orientation specified in the stem, so C1 (representation with the specified axis assignment) is not earned. Downstream values, fit line, and zero-crossing estimate are all internally consistent and happen to be numerically recoverable, so the later criteria are still earned despite the axis swap. Flags: axis assignment reversed relative to stem instructions.",
                "boundary_tags": ["axis_assignment_reversed"],
            },
            {
                "id": "R3",
                "description": (
                    "Scatterplot with correctly labeled and scaled axes. Six of the seven points are "
                    "plotted accurately; the point at 0.35 M is missing from the graph entirely. A best-fit "
                    "line is drawn through the remaining six points and crosses zero at approximately 0.40 M."
                ),
                "labels": {"C1": "earned", "C2": "not_earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "One of seven paired observations is missing entirely, so C2 (all paired observations plotted) is not earned, even though the omission happens not to shift the fit line's zero-crossing estimate much in this case. Flags: single point omitted, illustrates that a missing point can fail C2 even when downstream estimate criteria still happen to be reasonable.",
                "boundary_tags": ["missing_evidence", "under_credit_risk"],
            },
            {
                "id": "R4",
                "description": (
                    "Scatterplot with correctly labeled and scaled axes and all seven points plotted "
                    "accurately. A single smooth best-fit line crosses zero at approximately 0.39 M, marked "
                    "and labeled with units."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Second full-credit response with a slightly different but still reasonable zero-crossing estimate (0.39 vs. 0.40 M); confirms grader tolerance for small estimate variation from reading a hand-drawn fit line.",
                "boundary_tags": [],
            },
            {
                "id": "R5",
                "description": (
                    "Scatterplot with correctly labeled and scaled axes and all seven points plotted "
                    "accurately. A best-fit line is drawn, but it is a straight line forced through the "
                    "origin (0,0) rather than through the actual data trend, giving a zero-crossing estimate "
                    "of 0 M."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "not_earned", "C4": "not_earned"},
                "reviewer_note": "The forced-through-origin line does not represent the actual trend of the plotted data (which clearly crosses zero mass-change around 0.4 M, not at 0 M sucrose concentration) -- this is an invented/unsupported best-fit relationship rather than one derived from the data, so C3 is not earned, and the resulting zero-crossing estimate inherits that error. Flags: best-fit relationship not derived from plotted data, unsupported inference propagated into the final estimate.",
                "boundary_tags": ["unsupported_inference", "best_fit_not_derived_from_data"],
            },
        ],
    },
    {
        "id": "biology_hand_drawn_10",
        "source_item_id": "HDG-2026-P2-EST-004",
        "archetype": "continuous_relationship_graph_derived_estimate",
        "title": "Enzyme Inhibitor Response Across Inhibitor Concentration",
        "stem": "Researchers measured enzyme inhibitor response across a range of inhibitor concentration. Construct a graph with inhibitor concentration on the x-axis and change from control on the y-axis. Plot the paired observations, draw one best-fit relationship, mark where the relationship crosses zero change, and report the estimated inhibitor concentration at zero change with units.",
        "display_table": [
            {"inhibitor concentration (mM)": 0, "change from control (%)": 37.0},
            {"inhibitor concentration (mM)": 2, "change from control (%)": 31.0},
            {"inhibitor concentration (mM)": 5, "change from control (%)": 23.0},
            {"inhibitor concentration (mM)": 8, "change from control (%)": 14.0},
            {"inhibitor concentration (mM)": 12, "change from control (%)": 2.0},
            {"inhibitor concentration (mM)": 18, "change from control (%)": -16.0},
            {"inhibitor concentration (mM)": 25, "change from control (%)": -41.0},
        ],
        "capture_instruction": "Draw one graph on one page. Write only the item ID at the top of the page, then photograph the full page with all graph evidence visible. Do not expose criterion definitions to the person drawing the graph.",
        "criteria": EST_CRITERIA,
        "responses": [
            {
                "id": "R1",
                "description": (
                    "Scatterplot with x-axis labeled 'Inhibitor concentration (mM)' on a 0-25 scale, y-axis "
                    "labeled 'Change from control (%)' on a -45 to +40 scale. All seven points plotted at "
                    "positions matching the table. A single smooth best-fit line crosses the x-axis at "
                    "approximately 12.5 mM, marked with a tick and labeled '~12.5 mM.'"
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit response with correct axes, accurate plotted points, a genuine single best-fit line, and a correctly marked and estimated zero-crossing with units.",
                "boundary_tags": [],
            },
            {
                "id": "R2",
                "description": (
                    "Scatterplot with correctly labeled and scaled axes and all seven points plotted "
                    "accurately, with a single smooth best-fit line drawn through the data. The line is "
                    "marked at its zero-crossing, and the estimate is reported as 'about 12 or so mM' without "
                    "a more precise reading."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "The estimate is reported with appropriate hedging language for a hand-drawn reading ('about 12 or so') rather than false precision, and is consistent with the data (the 12 mM point itself is close to zero at +2%) -- this level of estimate precision is acceptable for a graph-derived value and should not be penalized relative to a more precisely stated '12.5 mM.' Full-credit response, useful for calibrating acceptable estimate precision.",
                "boundary_tags": [],
            },
            {
                "id": "R3",
                "description": (
                    "Scatterplot with correctly labeled and scaled axes and all seven points plotted "
                    "accurately. Instead of a single best-fit line, two separate straight-line segments are "
                    "drawn: one connecting the first four points and a second, differently-sloped segment "
                    "connecting the last three, meeting at a sharp angle at the 8 mM point. The zero-crossing "
                    "is marked at approximately 12 mM."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "not_earned", "C4": "earned"},
                "reviewer_note": "The two-segment piecewise line is not a single smooth best-fit relationship as required -- even though the resulting zero-crossing estimate happens to be reasonable, the relationship itself does not match the required representation (one smooth trend line/curve). Flags: piecewise line used instead of single best-fit relationship, illustrates that a reasonable final estimate doesn't retroactively validate an incorrect fit representation.",
                "boundary_tags": ["wrong_representation_for_estimate_task"],
            },
            {
                "id": "R4",
                "description": (
                    "Scatterplot with correctly labeled and scaled axes and all seven points plotted "
                    "accurately. A single smooth best-fit line is drawn, but no mark or annotation is made "
                    "at the zero-crossing, and no numeric estimate is reported anywhere on the page."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "not_earned"},
                "reviewer_note": "Graph, points, and fit line are all correct, but the response never completes the final step the stem explicitly asks for -- marking where the relationship crosses zero and reporting a numeric estimate with units. Flags: missing evidence for the final reported estimate, a clear omission rather than an ambiguous one.",
                "boundary_tags": ["missing_evidence"],
            },
            {
                "id": "R5",
                "description": (
                    "Scatterplot with correctly labeled and scaled axes and all seven points plotted "
                    "accurately. A single smooth best-fit line is drawn and marked at its zero-crossing, "
                    "reported as '12.5' with the unit written as '%' instead of 'mM.'"
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "not_earned"},
                "reviewer_note": "The numeric estimate itself is correct and the crossing is correctly marked, but the reported unit is wrong -- '%' is the unit of the y-axis variable (change from control), not the x-axis variable actually being estimated (inhibitor concentration in mM). This is a unit-mismatch error rather than an omission, distinct from R4's missing estimate. Flags: wrong unit attached to correct numeric estimate, over-credit risk if grader checks only the number and not the unit.",
                "boundary_tags": ["over_credit_risk", "unit_mismatch"],
            },
        ],
    },
]
