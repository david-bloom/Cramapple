# AI-provisional (Claude-authored) new HDR-capable Statistics FRQ items
# (GRAPH-013 through GRAPH-040). NOT Learning-Quality-approved. Schema
# mirrors ap_statistics_graph_response_seed_2026_07_02's 12 items exactly.
# These need real photographed hand-drawn responses (via trace pages) before
# they can be graded -- see trace_pages/ and README.md.

STD_CAPTURE_INSTRUCTION = (
    "Draw one graph on one page. Write only the item ID at the top of the "
    "page, then photograph the full page with all graph evidence visible. "
    "Do not expose criterion definitions to the person drawing the graph."
)

NEW_HDR_ITEMS = [
    # ---- boxplot_construction_interpretation (+5) ----
    {
        "item_id": "APSTATS-HDG-2026-GRAPH-013",
        "archetype": "boxplot_construction_interpretation",
        "stem": (
            "A nutritionist compared daily sugar intake (grams) for two diet "
            "groups. Construct side-by-side boxplots from the five-number "
            "summaries, using one common scale. Then write one sentence "
            "comparing the centers and one sentence comparing the variability.\n\n"
            "| Diet group | Min | Q1 | Median | Q3 | Max |\n"
            "| --- | --- | --- | --- | --- | --- |\n"
            "| Standard | 45 | 62 | 78 | 95 | 130 |\n"
            "| Low-sugar | 20 | 28 | 35 | 44 | 58 |"
        ),
        "display_table": [
            {"Diet group": "Standard", "Min": 45, "Q1": 62, "Median": 78, "Q3": 95, "Max": 130},
            {"Diet group": "Low-sugar", "Min": 20, "Q1": 28, "Median": 35, "Q3": 44, "Max": 58},
        ],
        "expected_graph_spec": {"representation": "side-by-side boxplots", "x_axis": "diet group", "y_axis": "daily sugar intake (grams)"},
        "canonical_answer": "Side-by-side boxplots with Standard min/Q1/median/Q3/max at 45/62/78/95/130 and Low-sugar at 20/28/35/44/58. Standard has the higher median sugar intake; Standard also has greater variability by both IQR and range.",
        "criteria": [
            {"id": "BOXPLOT_SCALE", "text": "Uses one interpretable common scale for both groups."},
            {"id": "FIVE_NUMBER_VALUES", "text": "Both boxplots recover the listed five-number summaries."},
            {"id": "CENTER_COMPARISON", "text": "Correctly compares medians in context."},
            {"id": "VARIABILITY_COMPARISON", "text": "Correctly compares IQR or range in context."},
        ],
    },
    {
        "item_id": "APSTATS-HDG-2026-GRAPH-014",
        "archetype": "boxplot_construction_interpretation",
        "stem": (
            "A tutoring center compared quiz scores for students who used the "
            "app daily versus weekly. Construct side-by-side boxplots from the "
            "five-number summaries using one common scale. Then compare the "
            "typical score and the spread in context.\n\n"
            "| Usage | Min | Q1 | Median | Q3 | Max |\n"
            "| --- | --- | --- | --- | --- | --- |\n"
            "| Daily | 68 | 78 | 85 | 91 | 99 |\n"
            "| Weekly | 40 | 55 | 66 | 76 | 90 |"
        ),
        "display_table": [
            {"Usage": "Daily", "Min": 68, "Q1": 78, "Median": 85, "Q3": 91, "Max": 99},
            {"Usage": "Weekly", "Min": 40, "Q1": 55, "Median": 66, "Q3": 76, "Max": 90},
        ],
        "expected_graph_spec": {"representation": "side-by-side boxplots", "x_axis": "app usage frequency", "y_axis": "quiz score"},
        "canonical_answer": "Side-by-side boxplots with Daily min/Q1/median/Q3/max at 68/78/85/91/99 and Weekly at 40/55/66/76/90. Daily users have the higher median score; Weekly users have greater variability by both IQR and range.",
        "criteria": [
            {"id": "BOXPLOT_SCALE", "text": "Uses one interpretable common scale for both groups."},
            {"id": "FIVE_NUMBER_VALUES", "text": "Both boxplots recover the listed five-number summaries."},
            {"id": "CENTER_COMPARISON", "text": "Correctly compares medians in context."},
            {"id": "VARIABILITY_COMPARISON", "text": "Correctly compares IQR or range in context."},
        ],
    },
    {
        "item_id": "APSTATS-HDG-2026-GRAPH-015",
        "archetype": "boxplot_construction_interpretation",
        "stem": (
            "A coach compared sprint times (seconds) for two training groups. "
            "Construct side-by-side boxplots from the five-number summaries "
            "using one common scale. Then compare the typical time and the "
            "spread in context.\n\n"
            "| Group | Min | Q1 | Median | Q3 | Max |\n"
            "| --- | --- | --- | --- | --- | --- |\n"
            "| Interval training | 11.2 | 11.8 | 12.1 | 12.5 | 13.0 |\n"
            "| Steady-state training | 12.0 | 12.9 | 13.4 | 14.1 | 15.2 |"
        ),
        "display_table": [
            {"Group": "Interval training", "Min": 11.2, "Q1": 11.8, "Median": 12.1, "Q3": 12.5, "Max": 13.0},
            {"Group": "Steady-state training", "Min": 12.0, "Q1": 12.9, "Median": 13.4, "Q3": 14.1, "Max": 15.2},
        ],
        "expected_graph_spec": {"representation": "side-by-side boxplots", "x_axis": "training group", "y_axis": "sprint time (seconds)"},
        "canonical_answer": "Side-by-side boxplots with Interval min/Q1/median/Q3/max at 11.2/11.8/12.1/12.5/13.0 and Steady-state at 12.0/12.9/13.4/14.1/15.2. Interval training has the lower (faster) median sprint time; Steady-state training has greater variability by both IQR and range.",
        "criteria": [
            {"id": "BOXPLOT_SCALE", "text": "Uses one interpretable common scale for both groups."},
            {"id": "FIVE_NUMBER_VALUES", "text": "Both boxplots recover the listed five-number summaries."},
            {"id": "CENTER_COMPARISON", "text": "Correctly compares medians in context."},
            {"id": "VARIABILITY_COMPARISON", "text": "Correctly compares IQR or range in context."},
        ],
    },
    {
        "item_id": "APSTATS-HDG-2026-GRAPH-016",
        "archetype": "boxplot_construction_interpretation",
        "stem": (
            "An HR analyst compared years of tenure for two departments. "
            "Construct side-by-side boxplots from the five-number summaries "
            "using one common scale. Then compare the typical tenure and the "
            "spread in context.\n\n"
            "| Department | Min | Q1 | Median | Q3 | Max |\n"
            "| --- | --- | --- | --- | --- | --- |\n"
            "| Engineering | 0.5 | 2.0 | 3.5 | 6.0 | 12.0 |\n"
            "| Sales | 0.2 | 1.0 | 1.8 | 2.9 | 5.0 |"
        ),
        "display_table": [
            {"Department": "Engineering", "Min": 0.5, "Q1": 2.0, "Median": 3.5, "Q3": 6.0, "Max": 12.0},
            {"Department": "Sales", "Min": 0.2, "Q1": 1.0, "Median": 1.8, "Q3": 2.9, "Max": 5.0},
        ],
        "expected_graph_spec": {"representation": "side-by-side boxplots", "x_axis": "department", "y_axis": "years of tenure"},
        "canonical_answer": "Side-by-side boxplots with Engineering min/Q1/median/Q3/max at 0.5/2.0/3.5/6.0/12.0 and Sales at 0.2/1.0/1.8/2.9/5.0. Engineering has the higher median tenure; Engineering also has greater variability by both IQR and range.",
        "criteria": [
            {"id": "BOXPLOT_SCALE", "text": "Uses one interpretable common scale for both groups."},
            {"id": "FIVE_NUMBER_VALUES", "text": "Both boxplots recover the listed five-number summaries."},
            {"id": "CENTER_COMPARISON", "text": "Correctly compares medians in context."},
            {"id": "VARIABILITY_COMPARISON", "text": "Correctly compares IQR or range in context."},
        ],
    },
    {
        "item_id": "APSTATS-HDG-2026-GRAPH-017",
        "archetype": "boxplot_construction_interpretation",
        "stem": (
            "A cafe manager compared customer wait times (minutes) on weekdays "
            "versus weekends. Construct side-by-side boxplots from the "
            "five-number summaries using one common scale. Then compare the "
            "typical wait time and the spread in context.\n\n"
            "| Day type | Min | Q1 | Median | Q3 | Max |\n"
            "| --- | --- | --- | --- | --- | --- |\n"
            "| Weekday | 2 | 4 | 6 | 8 | 12 |\n"
            "| Weekend | 5 | 9 | 13 | 18 | 26 |"
        ),
        "display_table": [
            {"Day type": "Weekday", "Min": 2, "Q1": 4, "Median": 6, "Q3": 8, "Max": 12},
            {"Day type": "Weekend", "Min": 5, "Q1": 9, "Median": 13, "Q3": 18, "Max": 26},
        ],
        "expected_graph_spec": {"representation": "side-by-side boxplots", "x_axis": "day type", "y_axis": "wait time (minutes)"},
        "canonical_answer": "Side-by-side boxplots with Weekday min/Q1/median/Q3/max at 2/4/6/8/12 and Weekend at 5/9/13/18/26. Weekend has the higher median wait time; Weekend also has greater variability by both IQR and range.",
        "criteria": [
            {"id": "BOXPLOT_SCALE", "text": "Uses one interpretable common scale for both groups."},
            {"id": "FIVE_NUMBER_VALUES", "text": "Both boxplots recover the listed five-number summaries."},
            {"id": "CENTER_COMPARISON", "text": "Correctly compares medians in context."},
            {"id": "VARIABILITY_COMPARISON", "text": "Correctly compares IQR or range in context."},
        ],
    },
    # ---- segmented_bar_graph_construction (+5) ----
    {
        "item_id": "APSTATS-HDG-2026-GRAPH-018",
        "archetype": "segmented_bar_graph_construction",
        "stem": (
            "A streaming service surveyed subscribers about how often they "
            "watch documentaries. Complete a segmented bar graph using relative "
            "frequencies for each age group. Then identify which group has the "
            "larger relative frequency of frequent viewing.\n\n"
            "| Age group | Never | Occasionally | Frequently |\n"
            "| --- | --- | --- | --- |\n"
            "| Under 30 | 25 | 50 | 25 |\n"
            "| 30 and over | 15 | 35 | 50 |"
        ),
        "display_table": [
            {"Age group": "Under 30", "Never": 25, "Occasionally": 50, "Frequently": 25},
            {"Age group": "30 and over", "Never": 15, "Occasionally": 35, "Frequently": 50},
        ],
        "expected_graph_spec": {"representation": "segmented bar graph", "x_axis": "relative frequency", "groups": ["Under 30", "30 and over"]},
        "canonical_answer": "Under 30 segmented bar: 0.25 never, 0.50 occasionally, 0.25 frequently. 30-and-over segmented bar: 0.15 never, 0.35 occasionally, 0.50 frequently. The 30-and-over group has the larger relative frequency of frequent viewing.",
        "criteria": [
            {"id": "RELATIVE_FREQUENCIES", "text": "Converts counts to correct within-group relative frequencies."},
            {"id": "SEGMENTED_BARS", "text": "Draws two complete segmented bars with total length 1 or 100%."},
            {"id": "CATEGORY_LABELS", "text": "Segments and age groups are identifiable."},
            {"id": "COMPARISON", "text": "Correctly identifies the larger frequent-viewing relative frequency."},
        ],
    },
    {
        "item_id": "APSTATS-HDG-2026-GRAPH-019",
        "archetype": "segmented_bar_graph_construction",
        "stem": (
            "A hospital tracked patient satisfaction ratings before and after a "
            "new scheduling system. Complete a segmented bar graph using "
            "relative frequencies for each period. Then state whether the "
            "relative frequency of 'satisfied' ratings increased.\n\n"
            "| Period | Dissatisfied | Neutral | Satisfied |\n"
            "| --- | --- | --- | --- |\n"
            "| Before | 40 | 35 | 25 |\n"
            "| After | 18 | 32 | 50 |"
        ),
        "display_table": [
            {"Period": "Before", "Dissatisfied": 40, "Neutral": 35, "Satisfied": 25},
            {"Period": "After", "Dissatisfied": 18, "Neutral": 32, "Satisfied": 50},
        ],
        "expected_graph_spec": {"representation": "segmented bar graph", "x_axis": "relative frequency", "groups": ["Before", "After"]},
        "canonical_answer": "Before segmented bar: 0.40 dissatisfied, 0.35 neutral, 0.25 satisfied. After segmented bar: 0.18 dissatisfied, 0.32 neutral, 0.50 satisfied. The relative frequency of satisfied ratings increased after the new scheduling system.",
        "criteria": [
            {"id": "RELATIVE_FREQUENCIES", "text": "Converts counts to correct within-group relative frequencies."},
            {"id": "SEGMENTED_BARS", "text": "Draws two complete segmented bars with total length 1 or 100%."},
            {"id": "CATEGORY_LABELS", "text": "Segments and period groups are identifiable."},
            {"id": "COMPARISON", "text": "Correctly states that satisfied ratings increased after the change."},
        ],
    },
    {
        "item_id": "APSTATS-HDG-2026-GRAPH-020",
        "archetype": "segmented_bar_graph_construction",
        "stem": (
            "A gym surveyed members about preferred workout time. Complete a "
            "segmented bar graph using relative frequencies for each membership "
            "type. Then identify which membership type has the larger relative "
            "frequency of morning workouts.\n\n"
            "| Membership | Morning | Afternoon | Evening |\n"
            "| --- | --- | --- | --- |\n"
            "| Standard | 20 | 30 | 50 |\n"
            "| Premium | 45 | 30 | 25 |"
        ),
        "display_table": [
            {"Membership": "Standard", "Morning": 20, "Afternoon": 30, "Evening": 50},
            {"Membership": "Premium", "Morning": 45, "Afternoon": 30, "Evening": 25},
        ],
        "expected_graph_spec": {"representation": "segmented bar graph", "x_axis": "relative frequency", "groups": ["Standard", "Premium"]},
        "canonical_answer": "Standard segmented bar: 0.20 morning, 0.30 afternoon, 0.50 evening. Premium segmented bar: 0.45 morning, 0.30 afternoon, 0.25 evening. Premium members have the larger relative frequency of morning workouts.",
        "criteria": [
            {"id": "RELATIVE_FREQUENCIES", "text": "Converts counts to correct within-group relative frequencies."},
            {"id": "SEGMENTED_BARS", "text": "Draws two complete segmented bars with total length 1 or 100%."},
            {"id": "CATEGORY_LABELS", "text": "Segments and membership groups are identifiable."},
            {"id": "COMPARISON", "text": "Correctly identifies the larger morning-workout relative frequency."},
        ],
    },
    {
        "item_id": "APSTATS-HDG-2026-GRAPH-021",
        "archetype": "segmented_bar_graph_construction",
        "stem": (
            "A university surveyed students on their primary transportation "
            "mode by class year. Complete a segmented bar graph using relative "
            "frequencies for each class year. Then identify which class year "
            "has the larger relative frequency of biking.\n\n"
            "| Class year | Walk | Bike | Drive |\n"
            "| --- | --- | --- | --- |\n"
            "| Freshman | 60 | 30 | 10 |\n"
            "| Senior | 30 | 15 | 55 |"
        ),
        "display_table": [
            {"Class year": "Freshman", "Walk": 60, "Bike": 30, "Drive": 10},
            {"Class year": "Senior", "Walk": 30, "Bike": 15, "Drive": 55},
        ],
        "expected_graph_spec": {"representation": "segmented bar graph", "x_axis": "relative frequency", "groups": ["Freshman", "Senior"]},
        "canonical_answer": "Freshman segmented bar: 0.60 walk, 0.30 bike, 0.10 drive. Senior segmented bar: 0.30 walk, 0.15 bike, 0.55 drive. Freshmen have the larger relative frequency of biking.",
        "criteria": [
            {"id": "RELATIVE_FREQUENCIES", "text": "Converts counts to correct within-group relative frequencies."},
            {"id": "SEGMENTED_BARS", "text": "Draws two complete segmented bars with total length 1 or 100%."},
            {"id": "CATEGORY_LABELS", "text": "Segments and class-year groups are identifiable."},
            {"id": "COMPARISON", "text": "Correctly identifies the larger biking relative frequency."},
        ],
    },
    {
        "item_id": "APSTATS-HDG-2026-GRAPH-022",
        "archetype": "segmented_bar_graph_construction",
        "stem": (
            "A restaurant chain tracked order type by location. Complete a "
            "segmented bar graph using relative frequencies for each location "
            "type. Then identify which location type has the larger relative "
            "frequency of delivery orders.\n\n"
            "| Location type | Dine-in | Takeout | Delivery |\n"
            "| --- | --- | --- | --- |\n"
            "| Downtown | 45 | 30 | 25 |\n"
            "| Suburban | 20 | 25 | 55 |"
        ),
        "display_table": [
            {"Location type": "Downtown", "Dine-in": 45, "Takeout": 30, "Delivery": 25},
            {"Location type": "Suburban", "Dine-in": 20, "Takeout": 25, "Delivery": 55},
        ],
        "expected_graph_spec": {"representation": "segmented bar graph", "x_axis": "relative frequency", "groups": ["Downtown", "Suburban"]},
        "canonical_answer": "Downtown segmented bar: 0.45 dine-in, 0.30 takeout, 0.25 delivery. Suburban segmented bar: 0.20 dine-in, 0.25 takeout, 0.55 delivery. Suburban locations have the larger relative frequency of delivery orders.",
        "criteria": [
            {"id": "RELATIVE_FREQUENCIES", "text": "Converts counts to correct within-group relative frequencies."},
            {"id": "SEGMENTED_BARS", "text": "Draws two complete segmented bars with total length 1 or 100%."},
            {"id": "CATEGORY_LABELS", "text": "Segments and location-type groups are identifiable."},
            {"id": "COMPARISON", "text": "Correctly identifies the larger delivery relative frequency."},
        ],
    },
    # ---- mosaic_plot_interpretation (+5) ----
    {
        "item_id": "APSTATS-HDG-2026-GRAPH-023",
        "archetype": "mosaic_plot_interpretation",
        "stem": (
            "Students were classified by primary transportation mode and "
            "commute-time satisfaction. Draw a mosaic plot from the table so "
            "that each mode's width is proportional to its total count and "
            "each vertical segment shows the conditional distribution of "
            "satisfaction within that mode. Then state which mode has the "
            "largest number of dissatisfied students.\n\n"
            "| Mode | Satisfied | Neutral | Dissatisfied |\n"
            "| --- | --- | --- | --- |\n"
            "| Car | 40 | 30 | 30 |\n"
            "| Bus | 20 | 30 | 50 |\n"
            "| Bike | 45 | 25 | 10 |"
        ),
        "display_table": [
            {"Mode": "Car", "Satisfied": 40, "Neutral": 30, "Dissatisfied": 30},
            {"Mode": "Bus", "Satisfied": 20, "Neutral": 30, "Dissatisfied": 50},
            {"Mode": "Bike", "Satisfied": 45, "Neutral": 25, "Dissatisfied": 10},
        ],
        "expected_graph_spec": {"representation": "mosaic plot", "x_axis": "transportation mode", "y_axis": "conditional satisfaction proportion"},
        "canonical_answer": "Mode widths are proportional to totals: Car 100, Bus 100, Bike 80 out of 280. Segment heights use within-mode proportions. Bus has the largest number of dissatisfied students: 50, compared with 30 for Car and 10 for Bike.",
        "criteria": [
            {"id": "WIDTHS_BY_TOTAL", "text": "Mode widths are proportional to mode totals."},
            {"id": "HEIGHTS_BY_CONDITIONAL_PROPORTION", "text": "Segment heights use within-mode proportions."},
            {"id": "SEGMENT_LABELS", "text": "Mode and satisfaction categories are identifiable."},
            {"id": "AREA_OR_COUNT_REASONING", "text": "Correctly identifies Bus as largest dissatisfied count."},
        ],
    },
    {
        "item_id": "APSTATS-HDG-2026-GRAPH-024",
        "archetype": "mosaic_plot_interpretation",
        "stem": (
            "Employees were classified by department and preferred meeting "
            "format. Draw a mosaic plot so each department width is "
            "proportional to its total count and each vertical segment shows "
            "the conditional distribution of format preference within that "
            "department. Then identify which department has the largest "
            "number of employees preferring in-person meetings.\n\n"
            "| Department | Video | Hybrid | In-person |\n"
            "| --- | --- | --- | --- |\n"
            "| Sales | 20 | 30 | 50 |\n"
            "| Engineering | 50 | 35 | 15 |\n"
            "| Support | 25 | 35 | 40 |"
        ),
        "display_table": [
            {"Department": "Sales", "Video": 20, "Hybrid": 30, "In-person": 50},
            {"Department": "Engineering", "Video": 50, "Hybrid": 35, "In-person": 15},
            {"Department": "Support", "Video": 25, "Hybrid": 35, "In-person": 40},
        ],
        "expected_graph_spec": {"representation": "mosaic plot", "x_axis": "department", "y_axis": "conditional meeting-format proportion"},
        "canonical_answer": "Department widths are proportional to totals: Sales 100, Engineering 100, Support 100 out of 300. Segment heights use within-department proportions. Sales has the largest number of employees preferring in-person meetings: 50, compared with 40 for Support and 15 for Engineering.",
        "criteria": [
            {"id": "WIDTHS_BY_TOTAL", "text": "Department widths are proportional to department totals."},
            {"id": "HEIGHTS_BY_CONDITIONAL_PROPORTION", "text": "Segment heights use within-department proportions."},
            {"id": "SEGMENT_LABELS", "text": "Department and meeting-format categories are identifiable."},
            {"id": "AREA_OR_COUNT_REASONING", "text": "Correctly identifies Sales as largest in-person count."},
        ],
    },
    {
        "item_id": "APSTATS-HDG-2026-GRAPH-025",
        "archetype": "mosaic_plot_interpretation",
        "stem": (
            "Shoppers were classified by store section visited most and "
            "membership status. Draw a mosaic plot so each section's width is "
            "proportional to its total count and each vertical segment shows "
            "the conditional distribution of membership status within that "
            "section. Then identify which section has the largest number of "
            "member shoppers.\n\n"
            "| Section | Member | Non-member |\n"
            "| --- | --- | --- |\n"
            "| Produce | 70 | 30 |\n"
            "| Electronics | 40 | 60 |\n"
            "| Clothing | 55 | 45 |"
        ),
        "display_table": [
            {"Section": "Produce", "Member": 70, "Non-member": 30},
            {"Section": "Electronics", "Member": 40, "Non-member": 60},
            {"Section": "Clothing", "Member": 55, "Non-member": 45},
        ],
        "expected_graph_spec": {"representation": "mosaic plot", "x_axis": "store section", "y_axis": "conditional membership proportion"},
        "canonical_answer": "Section widths are proportional to totals: Produce 100, Electronics 100, Clothing 100 out of 300. Segment heights use within-section proportions. Produce has the largest number of member shoppers: 70, compared with 55 for Clothing and 40 for Electronics.",
        "criteria": [
            {"id": "WIDTHS_BY_TOTAL", "text": "Section widths are proportional to section totals."},
            {"id": "HEIGHTS_BY_CONDITIONAL_PROPORTION", "text": "Segment heights use within-section proportions."},
            {"id": "SEGMENT_LABELS", "text": "Section and membership categories are identifiable."},
            {"id": "AREA_OR_COUNT_REASONING", "text": "Correctly identifies Produce as largest member count."},
        ],
    },
    {
        "item_id": "APSTATS-HDG-2026-GRAPH-026",
        "archetype": "mosaic_plot_interpretation",
        "stem": (
            "Patients were classified by clinic location and appointment "
            "outcome. Draw a mosaic plot so each location's width is "
            "proportional to its total count and each vertical segment shows "
            "the conditional distribution of outcome within that location. "
            "Then identify which location has the largest number of "
            "no-show appointments.\n\n"
            "| Location | Completed | Rescheduled | No-show |\n"
            "| --- | --- | --- | --- |\n"
            "| North clinic | 60 | 25 | 15 |\n"
            "| South clinic | 45 | 20 | 35 |\n"
            "| East clinic | 50 | 30 | 20 |"
        ),
        "display_table": [
            {"Location": "North clinic", "Completed": 60, "Rescheduled": 25, "No-show": 15},
            {"Location": "South clinic", "Completed": 45, "Rescheduled": 20, "No-show": 35},
            {"Location": "East clinic", "Completed": 50, "Rescheduled": 30, "No-show": 20},
        ],
        "expected_graph_spec": {"representation": "mosaic plot", "x_axis": "clinic location", "y_axis": "conditional outcome proportion"},
        "canonical_answer": "Location widths are proportional to totals: North 100, South 100, East 100 out of 300. Segment heights use within-location proportions. South clinic has the largest number of no-show appointments: 35, compared with 20 for East and 15 for North.",
        "criteria": [
            {"id": "WIDTHS_BY_TOTAL", "text": "Location widths are proportional to location totals."},
            {"id": "HEIGHTS_BY_CONDITIONAL_PROPORTION", "text": "Segment heights use within-location proportions."},
            {"id": "SEGMENT_LABELS", "text": "Location and outcome categories are identifiable."},
            {"id": "AREA_OR_COUNT_REASONING", "text": "Correctly identifies South clinic as largest no-show count."},
        ],
    },
    {
        "item_id": "APSTATS-HDG-2026-GRAPH-027",
        "archetype": "mosaic_plot_interpretation",
        "stem": (
            "Voters were classified by age bracket and preferred voting "
            "method. Draw a mosaic plot so each age bracket's width is "
            "proportional to its total count and each vertical segment shows "
            "the conditional distribution of voting method within that "
            "bracket. Then identify which age bracket has the largest number "
            "of mail-in voters.\n\n"
            "| Age bracket | In-person | Mail-in | Early voting |\n"
            "| --- | --- | --- | --- |\n"
            "| 18-34 | 40 | 20 | 40 |\n"
            "| 35-64 | 35 | 35 | 30 |\n"
            "| 65+ | 20 | 55 | 25 |"
        ),
        "display_table": [
            {"Age bracket": "18-34", "In-person": 40, "Mail-in": 20, "Early voting": 40},
            {"Age bracket": "35-64", "In-person": 35, "Mail-in": 35, "Early voting": 30},
            {"Age bracket": "65+", "In-person": 20, "Mail-in": 55, "Early voting": 25},
        ],
        "expected_graph_spec": {"representation": "mosaic plot", "x_axis": "age bracket", "y_axis": "conditional voting-method proportion"},
        "canonical_answer": "Age bracket widths are proportional to totals: 18-34 is 100, 35-64 is 100, 65+ is 100 out of 300. Segment heights use within-bracket proportions. The 65+ bracket has the largest number of mail-in voters: 55, compared with 35 for 35-64 and 20 for 18-34.",
        "criteria": [
            {"id": "WIDTHS_BY_TOTAL", "text": "Age-bracket widths are proportional to bracket totals."},
            {"id": "HEIGHTS_BY_CONDITIONAL_PROPORTION", "text": "Segment heights use within-bracket proportions."},
            {"id": "SEGMENT_LABELS", "text": "Age-bracket and voting-method categories are identifiable."},
            {"id": "AREA_OR_COUNT_REASONING", "text": "Correctly identifies 65+ as largest mail-in count."},
        ],
    },
    # ---- dotplot_distribution_shape (+4) ----
    {
        "item_id": "APSTATS-HDG-2026-GRAPH-028",
        "archetype": "dotplot_distribution_shape",
        "stem": (
            "A sample of 12 commute times (minutes) is shown below. Construct "
            "a dotplot of the data, then describe the distribution's shape and "
            "identify any possible outlier.\n\n"
            "| Commute time (min) |\n"
            "| --- |\n"
            "| 15 | 18 | 18 | 19 | 20 | 20 | 20 | 21 | 22 | 22 | 24 | 38 |"
        ),
        "display_table": [{"Commute time (min)": v} for v in [15, 18, 18, 19, 20, 20, 20, 21, 22, 22, 24, 38]],
        "expected_graph_spec": {"representation": "dotplot", "x_axis": "commute time (minutes)"},
        "canonical_answer": "Dotplot places dots at 15, two at 18, 19, three at 20, 21, two at 22, 24, and 38. The distribution is right-skewed, with 38 minutes a possible high outlier.",
        "criteria": [
            {"id": "DOT_COUNTS", "text": "Plots the correct number of dots at each commute time."},
            {"id": "AXIS_SCALE", "text": "Uses an interpretable numeric scale covering 15 through 38."},
            {"id": "SHAPE_DESCRIPTION", "text": "Describes the distribution as right-skewed in context."},
            {"id": "OUTLIER_NOTE", "text": "Identifies 38 minutes as a possible high outlier or unusual value."},
        ],
    },
    {
        "item_id": "APSTATS-HDG-2026-GRAPH-029",
        "archetype": "dotplot_distribution_shape",
        "stem": (
            "A sample of 12 test scores is shown below. Construct a dotplot of "
            "the data, then describe the distribution's shape and comment on "
            "whether there is a clear outlier.\n\n"
            "| Test score |\n"
            "| --- |\n"
            "| 62 | 78 | 80 | 81 | 82 | 83 | 84 | 84 | 85 | 86 | 87 | 88 |"
        ),
        "display_table": [{"Test score": v} for v in [62, 78, 80, 81, 82, 83, 84, 84, 85, 86, 87, 88]],
        "expected_graph_spec": {"representation": "dotplot", "x_axis": "test score"},
        "canonical_answer": "Dotplot places dots at 62, 78, 80, 81, 82, 83, two at 84, 85, 86, 87, and 88. The distribution is roughly left-skewed (a low tail toward 62); 62 is a possible low outlier, noticeably separated from the rest of the cluster (78-88).",
        "criteria": [
            {"id": "DOT_COUNTS", "text": "Plots the correct number of dots at each test score."},
            {"id": "AXIS_SCALE", "text": "Uses an interpretable numeric scale covering 62 through 88."},
            {"id": "SHAPE_DESCRIPTION", "text": "Describes the distribution as left-skewed (or notes the low tail) in context."},
            {"id": "OUTLIER_NOTE", "text": "Identifies 62 as a possible low outlier separated from the main cluster."},
        ],
    },
    {
        "item_id": "APSTATS-HDG-2026-GRAPH-030",
        "archetype": "dotplot_distribution_shape",
        "stem": (
            "A sample of 12 daily step counts (thousands) is shown below. "
            "Construct a dotplot of the data, then describe the distribution's "
            "shape and comment on whether there is a clear outlier.\n\n"
            "| Steps (thousands) |\n"
            "| --- |\n"
            "| 6 | 7 | 7 | 8 | 8 | 8 | 9 | 9 | 10 | 10 | 11 | 12 |"
        ),
        "display_table": [{"Steps (thousands)": v} for v in [6, 7, 7, 8, 8, 8, 9, 9, 10, 10, 11, 12]],
        "expected_graph_spec": {"representation": "dotplot", "x_axis": "daily steps (thousands)"},
        "canonical_answer": "Dotplot places dots at 6, two at 7, three at 8, two at 9, two at 10, 11, and 12. The distribution is roughly symmetric and unimodal, centered around 8-9 thousand steps, with no clear outlier.",
        "criteria": [
            {"id": "DOT_COUNTS", "text": "Plots the correct number of dots at each step count."},
            {"id": "AXIS_SCALE", "text": "Uses an interpretable numeric scale covering 6 through 12."},
            {"id": "SHAPE_DESCRIPTION", "text": "Describes the distribution as roughly symmetric/unimodal in context."},
            {"id": "OUTLIER_NOTE", "text": "Correctly notes there is no clear outlier in this dataset."},
        ],
    },
    {
        "item_id": "APSTATS-HDG-2026-GRAPH-031",
        "archetype": "dotplot_distribution_shape",
        "stem": (
            "A sample of 12 package delivery times (days) is shown below. "
            "Construct a dotplot of the data, then describe the distribution's "
            "shape and identify any possible outlier.\n\n"
            "| Delivery time (days) |\n"
            "| --- |\n"
            "| 1 | 2 | 2 | 2 | 3 | 3 | 3 | 3 | 4 | 4 | 5 | 11 |"
        ),
        "display_table": [{"Delivery time (days)": v} for v in [1, 2, 2, 2, 3, 3, 3, 3, 4, 4, 5, 11]],
        "expected_graph_spec": {"representation": "dotplot", "x_axis": "delivery time (days)"},
        "canonical_answer": "Dotplot places dots at 1, three at 2, four at 3, two at 4, 5, and 11. The distribution is right-skewed, with 11 days a possible high outlier, clearly separated from the rest of the cluster (1-5 days).",
        "criteria": [
            {"id": "DOT_COUNTS", "text": "Plots the correct number of dots at each delivery time."},
            {"id": "AXIS_SCALE", "text": "Uses an interpretable numeric scale covering 1 through 11."},
            {"id": "SHAPE_DESCRIPTION", "text": "Describes the distribution as right-skewed in context."},
            {"id": "OUTLIER_NOTE", "text": "Identifies 11 days as a possible high outlier."},
        ],
    },
    # ---- scatterplot_regression_context (+5) ----
    {
        "item_id": "APSTATS-HDG-2026-GRAPH-032",
        "archetype": "scatterplot_regression_context",
        "stem": (
            "A researcher recorded advertising spend (thousands of dollars) and "
            "monthly sales (thousands of dollars) for nine stores. Construct a "
            "scatterplot, sketch a reasonable least-squares trend line, and "
            "describe the direction, form, and strength of the association in "
            "context.\n\n"
            "| Ad spend | Sales |\n"
            "| --- | --- |\n"
            "| 2 | 30 | 3 | 34 | 4 | 40 | 5 | 44 | 6 | 47 | 7 | 53 | 8 | 58 | 9 | 62 | 10 | 68 |"
        ),
        "display_table": [
            {"Ad spend": 2, "Sales": 30}, {"Ad spend": 3, "Sales": 34}, {"Ad spend": 4, "Sales": 40},
            {"Ad spend": 5, "Sales": 44}, {"Ad spend": 6, "Sales": 47}, {"Ad spend": 7, "Sales": 53},
            {"Ad spend": 8, "Sales": 58}, {"Ad spend": 9, "Sales": 62}, {"Ad spend": 10, "Sales": 68},
        ],
        "expected_graph_spec": {"representation": "scatterplot with trend line", "x_axis": "advertising spend (thousands of dollars)", "y_axis": "monthly sales (thousands of dollars)"},
        "canonical_answer": "Scatterplot shows a strong positive roughly linear association between advertising spend and monthly sales. A reasonable trend line rises from about (2, 30) toward about (10, 68).",
        "criteria": [
            {"id": "POINTS_PLOTTED", "text": "Plots all nine ordered pairs at recoverable locations."},
            {"id": "AXIS_LABELS", "text": "Labels advertising spend and sales on the correct axes."},
            {"id": "TREND_LINE", "text": "Sketches a reasonable increasing line through the point cloud."},
            {"id": "ASSOCIATION_DESCRIPTION", "text": "Describes strong positive roughly linear association in context."},
        ],
    },
    {
        "item_id": "APSTATS-HDG-2026-GRAPH-033",
        "archetype": "scatterplot_regression_context",
        "stem": (
            "A mechanic recorded a car's age (years) and its resale value "
            "(thousands of dollars) for nine cars. Construct a scatterplot, "
            "sketch a reasonable least-squares trend line, and describe the "
            "direction, form, and strength of the association in context.\n\n"
            "| Age | Resale value |\n"
            "| --- | --- |\n"
            "| 1 | 28 | 2 | 25 | 3 | 22 | 4 | 19 | 5 | 17 | 6 | 14 | 7 | 12 | 8 | 9 | 9 | 7 |"
        ),
        "display_table": [
            {"Age": 1, "Resale value": 28}, {"Age": 2, "Resale value": 25}, {"Age": 3, "Resale value": 22},
            {"Age": 4, "Resale value": 19}, {"Age": 5, "Resale value": 17}, {"Age": 6, "Resale value": 14},
            {"Age": 7, "Resale value": 12}, {"Age": 8, "Resale value": 9}, {"Age": 9, "Resale value": 7},
        ],
        "expected_graph_spec": {"representation": "scatterplot with trend line", "x_axis": "car age (years)", "y_axis": "resale value (thousands of dollars)"},
        "canonical_answer": "Scatterplot shows a strong negative roughly linear association between car age and resale value. A reasonable trend line falls from about (1, 28) toward about (9, 7).",
        "criteria": [
            {"id": "POINTS_PLOTTED", "text": "Plots all nine ordered pairs at recoverable locations."},
            {"id": "AXIS_LABELS", "text": "Labels car age and resale value on the correct axes."},
            {"id": "TREND_LINE", "text": "Sketches a reasonable decreasing line through the point cloud."},
            {"id": "ASSOCIATION_DESCRIPTION", "text": "Describes strong negative roughly linear association in context."},
        ],
    },
    {
        "item_id": "APSTATS-HDG-2026-GRAPH-034",
        "archetype": "scatterplot_regression_context",
        "stem": (
            "A nutritionist recorded daily calorie intake (hundreds) and "
            "resting heart rate change (bpm) for nine participants in a "
            "controlled diet study. Construct a scatterplot, sketch a "
            "reasonable least-squares trend line, and describe the direction, "
            "form, and strength of the association in context.\n\n"
            "| Calorie intake (hundreds) | Heart rate change (bpm) |\n"
            "| --- | --- |\n"
            "| 14 | -2 | 16 | -1 | 18 | 0 | 20 | 1 | 22 | 1 | 24 | 3 | 26 | 3 | 28 | 5 | 30 | 6 |"
        ),
        "display_table": [
            {"Calorie intake (hundreds)": 14, "Heart rate change (bpm)": -2}, {"Calorie intake (hundreds)": 16, "Heart rate change (bpm)": -1},
            {"Calorie intake (hundreds)": 18, "Heart rate change (bpm)": 0}, {"Calorie intake (hundreds)": 20, "Heart rate change (bpm)": 1},
            {"Calorie intake (hundreds)": 22, "Heart rate change (bpm)": 1}, {"Calorie intake (hundreds)": 24, "Heart rate change (bpm)": 3},
            {"Calorie intake (hundreds)": 26, "Heart rate change (bpm)": 3}, {"Calorie intake (hundreds)": 28, "Heart rate change (bpm)": 5},
            {"Calorie intake (hundreds)": 30, "Heart rate change (bpm)": 6},
        ],
        "expected_graph_spec": {"representation": "scatterplot with trend line", "x_axis": "daily calorie intake (hundreds)", "y_axis": "resting heart rate change (bpm)"},
        "canonical_answer": "Scatterplot shows a strong positive roughly linear association between calorie intake and resting heart rate change. A reasonable trend line rises from about (14, -2) toward about (30, 6).",
        "criteria": [
            {"id": "POINTS_PLOTTED", "text": "Plots all nine ordered pairs at recoverable locations."},
            {"id": "AXIS_LABELS", "text": "Labels calorie intake and heart rate change on the correct axes."},
            {"id": "TREND_LINE", "text": "Sketches a reasonable increasing line through the point cloud."},
            {"id": "ASSOCIATION_DESCRIPTION", "text": "Describes strong positive roughly linear association in context."},
        ],
    },
    {
        "item_id": "APSTATS-HDG-2026-GRAPH-035",
        "archetype": "scatterplot_regression_context",
        "stem": (
            "A city planner recorded a neighborhood's distance from downtown "
            "(miles) and average commute time (minutes) for nine neighborhoods. "
            "Construct a scatterplot, sketch a reasonable least-squares trend "
            "line, and describe the direction, form, and strength of the "
            "association in context.\n\n"
            "| Distance (miles) | Commute time (min) |\n"
            "| --- | --- |\n"
            "| 1 | 12 | 3 | 18 | 5 | 24 | 7 | 27 | 9 | 33 | 11 | 38 | 13 | 41 | 15 | 47 | 17 | 52 |"
        ),
        "display_table": [
            {"Distance (miles)": 1, "Commute time (min)": 12}, {"Distance (miles)": 3, "Commute time (min)": 18},
            {"Distance (miles)": 5, "Commute time (min)": 24}, {"Distance (miles)": 7, "Commute time (min)": 27},
            {"Distance (miles)": 9, "Commute time (min)": 33}, {"Distance (miles)": 11, "Commute time (min)": 38},
            {"Distance (miles)": 13, "Commute time (min)": 41}, {"Distance (miles)": 15, "Commute time (min)": 47},
            {"Distance (miles)": 17, "Commute time (min)": 52},
        ],
        "expected_graph_spec": {"representation": "scatterplot with trend line", "x_axis": "distance from downtown (miles)", "y_axis": "average commute time (minutes)"},
        "canonical_answer": "Scatterplot shows a strong positive roughly linear association between distance from downtown and average commute time. A reasonable trend line rises from about (1, 12) toward about (17, 52).",
        "criteria": [
            {"id": "POINTS_PLOTTED", "text": "Plots all nine ordered pairs at recoverable locations."},
            {"id": "AXIS_LABELS", "text": "Labels distance and commute time on the correct axes."},
            {"id": "TREND_LINE", "text": "Sketches a reasonable increasing line through the point cloud."},
            {"id": "ASSOCIATION_DESCRIPTION", "text": "Describes strong positive roughly linear association in context."},
        ],
    },
    {
        "item_id": "APSTATS-HDG-2026-GRAPH-036",
        "archetype": "scatterplot_regression_context",
        "stem": (
            "A farmer recorded weekly irrigation amount (inches) and crop yield "
            "loss due to drought stress (percent) for nine plots, where more "
            "irrigation is associated with less drought stress. Construct a "
            "scatterplot, sketch a reasonable least-squares trend line, and "
            "describe the direction, form, and strength of the association in "
            "context.\n\n"
            "| Irrigation (in) | Yield loss (%) |\n"
            "| --- | --- |\n"
            "| 0.5 | 42 | 1.0 | 36 | 1.5 | 31 | 2.0 | 26 | 2.5 | 20 | 3.0 | 15 | 3.5 | 11 | 4.0 | 6 | 4.5 | 3 |"
        ),
        "display_table": [
            {"Irrigation (in)": 0.5, "Yield loss (%)": 42}, {"Irrigation (in)": 1.0, "Yield loss (%)": 36},
            {"Irrigation (in)": 1.5, "Yield loss (%)": 31}, {"Irrigation (in)": 2.0, "Yield loss (%)": 26},
            {"Irrigation (in)": 2.5, "Yield loss (%)": 20}, {"Irrigation (in)": 3.0, "Yield loss (%)": 15},
            {"Irrigation (in)": 3.5, "Yield loss (%)": 11}, {"Irrigation (in)": 4.0, "Yield loss (%)": 6},
            {"Irrigation (in)": 4.5, "Yield loss (%)": 3},
        ],
        "expected_graph_spec": {"representation": "scatterplot with trend line", "x_axis": "weekly irrigation (inches)", "y_axis": "yield loss from drought stress (%)"},
        "canonical_answer": "Scatterplot shows a strong negative roughly linear association between irrigation amount and drought-related yield loss. A reasonable trend line falls from about (0.5, 42) toward about (4.5, 3).",
        "criteria": [
            {"id": "POINTS_PLOTTED", "text": "Plots all nine ordered pairs at recoverable locations."},
            {"id": "AXIS_LABELS", "text": "Labels irrigation amount and yield loss on the correct axes."},
            {"id": "TREND_LINE", "text": "Sketches a reasonable decreasing line through the point cloud."},
            {"id": "ASSOCIATION_DESCRIPTION", "text": "Describes strong negative roughly linear association in context."},
        ],
    },
    # ---- graph_annotation_marking_value (+4) ----
    {
        "item_id": "APSTATS-HDG-2026-GRAPH-037",
        "archetype": "graph_annotation_marking_value",
        "stem": (
            "The table gives values from a curve showing the cumulative "
            "proportion of a batch of components that have failed as operating "
            "hours increase. Draw the curve on a graph with operating hours on "
            "the x-axis and cumulative failure proportion on the y-axis. Mark "
            "the point for 300 hours with an X, then estimate the corresponding "
            "failure proportion.\n\n"
            "| Hours | Failure proportion |\n"
            "| --- | --- |\n"
            "| 50 | 0.03 | 100 | 0.09 | 150 | 0.20 | 200 | 0.35 | 250 | 0.52 | "
            "300 | 0.68 | 350 | 0.81 | 400 | 0.90 | 450 | 0.96 |"
        ),
        "display_table": [
            {"Hours": 50, "Failure proportion": 0.03}, {"Hours": 100, "Failure proportion": 0.09},
            {"Hours": 150, "Failure proportion": 0.20}, {"Hours": 200, "Failure proportion": 0.35},
            {"Hours": 250, "Failure proportion": 0.52}, {"Hours": 300, "Failure proportion": 0.68},
            {"Hours": 350, "Failure proportion": 0.81}, {"Hours": 400, "Failure proportion": 0.90},
            {"Hours": 450, "Failure proportion": 0.96},
        ],
        "expected_graph_spec": {"representation": "curve with marked point", "x_axis": "operating hours", "y_axis": "cumulative failure proportion"},
        "canonical_answer": "Curve increases from about 0.03 toward 0.96. The marked X should be at 300 hours and failure proportion about 0.68. A reasonable estimate is approximately 0.68-0.70.",
        "criteria": [
            {"id": "CURVE_SHAPE", "text": "Draws an increasing curve consistent with the table."},
            {"id": "AXIS_SCALE_LABELS", "text": "Labels operating hours and failure proportion with interpretable scales."},
            {"id": "X_LOCATION", "text": "Places X at 300 hours and failure proportion about 0.68."},
            {"id": "PROBABILITY_ESTIMATE", "text": "Reports an estimate close to 0.68."},
        ],
    },
    {
        "item_id": "APSTATS-HDG-2026-GRAPH-038",
        "archetype": "graph_annotation_marking_value",
        "stem": (
            "The table gives values from a curve showing the proportion of "
            "survey respondents who recall a product name as advertising "
            "exposure (number of ad views) increases. Draw the curve on a "
            "graph with ad views on the x-axis and recall proportion on the "
            "y-axis. Mark the point for 6 ad views with an X, then estimate the "
            "corresponding recall proportion.\n\n"
            "| Ad views | Recall proportion |\n"
            "| --- | --- |\n"
            "| 1 | 0.08 | 2 | 0.18 | 3 | 0.30 | 4 | 0.42 | 5 | 0.53 | 6 | 0.63 | "
            "7 | 0.71 | 8 | 0.78 | 9 | 0.83 |"
        ),
        "display_table": [
            {"Ad views": 1, "Recall proportion": 0.08}, {"Ad views": 2, "Recall proportion": 0.18},
            {"Ad views": 3, "Recall proportion": 0.30}, {"Ad views": 4, "Recall proportion": 0.42},
            {"Ad views": 5, "Recall proportion": 0.53}, {"Ad views": 6, "Recall proportion": 0.63},
            {"Ad views": 7, "Recall proportion": 0.71}, {"Ad views": 8, "Recall proportion": 0.78},
            {"Ad views": 9, "Recall proportion": 0.83},
        ],
        "expected_graph_spec": {"representation": "curve with marked point", "x_axis": "number of ad views", "y_axis": "recall proportion"},
        "canonical_answer": "Curve increases from about 0.08 toward 0.83. The marked X should be at 6 ad views and recall proportion about 0.63. A reasonable estimate is approximately 0.63.",
        "criteria": [
            {"id": "CURVE_SHAPE", "text": "Draws an increasing curve consistent with the table."},
            {"id": "AXIS_SCALE_LABELS", "text": "Labels ad views and recall proportion with interpretable scales."},
            {"id": "X_LOCATION", "text": "Places X at 6 ad views and recall proportion about 0.63."},
            {"id": "PROBABILITY_ESTIMATE", "text": "Reports an estimate close to 0.63."},
        ],
    },
    {
        "item_id": "APSTATS-HDG-2026-GRAPH-039",
        "archetype": "graph_annotation_marking_value",
        "stem": (
            "The table gives values from a curve showing the power of a "
            "hypothesis test to detect a true effect as sample size increases. "
            "Draw the curve on a graph with sample size on the x-axis and power "
            "on the y-axis. Mark the point for sample size 60 with an X, then "
            "estimate the corresponding power.\n\n"
            "| Sample size | Power |\n"
            "| --- | --- |\n"
            "| 10 | 0.15 | 20 | 0.28 | 30 | 0.42 | 40 | 0.55 | 50 | 0.67 | "
            "60 | 0.77 | 70 | 0.85 | 80 | 0.91 | 90 | 0.95 |"
        ),
        "display_table": [
            {"Sample size": 10, "Power": 0.15}, {"Sample size": 20, "Power": 0.28},
            {"Sample size": 30, "Power": 0.42}, {"Sample size": 40, "Power": 0.55},
            {"Sample size": 50, "Power": 0.67}, {"Sample size": 60, "Power": 0.77},
            {"Sample size": 70, "Power": 0.85}, {"Sample size": 80, "Power": 0.91},
            {"Sample size": 90, "Power": 0.95},
        ],
        "expected_graph_spec": {"representation": "curve with marked point", "x_axis": "sample size", "y_axis": "power"},
        "canonical_answer": "Curve increases from about 0.15 toward 0.95. The marked X should be at sample size 60 and power about 0.77. A reasonable estimate is approximately 0.77.",
        "criteria": [
            {"id": "CURVE_SHAPE", "text": "Draws an increasing curve consistent with the table."},
            {"id": "AXIS_SCALE_LABELS", "text": "Labels sample size and power with interpretable scales."},
            {"id": "X_LOCATION", "text": "Places X at sample size 60 and power about 0.77."},
            {"id": "PROBABILITY_ESTIMATE", "text": "Reports an estimate close to 0.77."},
        ],
    },
    {
        "item_id": "APSTATS-HDG-2026-GRAPH-040",
        "archetype": "graph_annotation_marking_value",
        "stem": (
            "The table gives values from a curve showing the proportion of a "
            "population that has adopted a new technology as months since "
            "launch increase. Draw the curve on a graph with months on the "
            "x-axis and adoption proportion on the y-axis. Mark the point for "
            "month 8 with an X, then estimate the corresponding adoption "
            "proportion.\n\n"
            "| Month | Adoption proportion |\n"
            "| --- | --- |\n"
            "| 2 | 0.05 | 4 | 0.14 | 6 | 0.27 | 8 | 0.44 | 10 | 0.60 | 12 | 0.73 | "
            "14 | 0.83 | 16 | 0.90 | 18 | 0.95 |"
        ),
        "display_table": [
            {"Month": 2, "Adoption proportion": 0.05}, {"Month": 4, "Adoption proportion": 0.14},
            {"Month": 6, "Adoption proportion": 0.27}, {"Month": 8, "Adoption proportion": 0.44},
            {"Month": 10, "Adoption proportion": 0.60}, {"Month": 12, "Adoption proportion": 0.73},
            {"Month": 14, "Adoption proportion": 0.83}, {"Month": 16, "Adoption proportion": 0.90},
            {"Month": 18, "Adoption proportion": 0.95},
        ],
        "expected_graph_spec": {"representation": "curve with marked point", "x_axis": "months since launch", "y_axis": "adoption proportion"},
        "canonical_answer": "Curve increases from about 0.05 toward 0.95. The marked X should be at month 8 and adoption proportion about 0.44. A reasonable estimate is approximately 0.44.",
        "criteria": [
            {"id": "CURVE_SHAPE", "text": "Draws an increasing curve consistent with the table."},
            {"id": "AXIS_SCALE_LABELS", "text": "Labels months since launch and adoption proportion with interpretable scales."},
            {"id": "X_LOCATION", "text": "Places X at month 8 and adoption proportion about 0.44."},
            {"id": "PROBABILITY_ESTIMATE", "text": "Reports an estimate close to 0.44."},
        ],
    },
]
