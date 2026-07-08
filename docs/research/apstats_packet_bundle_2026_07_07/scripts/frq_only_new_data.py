# AI-provisional (Claude-authored) new Statistics FRQ-only items (11-40).
# NOT Learning-Quality-approved. Schema mirrors apbio_frq_tutor_ready_packet.json
# (content_key, stem, criteria_json, points_possible) but lighter: no synthetic
# labeled response corpus, since a grading TEST packet only needs the FRQ
# definition itself (grading_test_packet_requirements.md section 2).

NEW_FRQ_ONLY_ITEMS = [
    # ---- Unit 1: Exploring One-Variable Data ----
    {
        "content_key": "APSTATS-FRQ-011",
        "unit": "Unit 1",
        "difficulty": "Easy",
        "subtopics": ["histograms", "shape/center/spread"],
        "stem": (
            "A gym records the number of visits per member over one month for two "
            "membership tiers.\n\n"
            "Standard tier (n=60): mean = 6.2 visits, median = 5, SD = 4.1\n"
            "Premium tier (n=40): mean = 11.8 visits, median = 11.5, SD = 3.0\n\n"
            "**A.** Using the relationship between mean and median, describe the "
            "likely shape of each tier's distribution.\n\n"
            "**B.** Compare the two tiers' typical number of visits and their "
            "spread, using appropriate statistics and referencing the shapes from "
            "part A."
        ),
        "canonical_answer": (
            "Standard tier is right-skewed (mean 6.2 > median 5). Premium tier is "
            "roughly symmetric (mean 11.8 close to median 11.5). Since Standard is "
            "skewed, compare medians: Premium's median (11.5) is much higher than "
            "Standard's (5). Standard also has more spread by SD (4.1 vs 3.0), "
            "though IQR would be preferred for the skewed Standard tier if available."
        ),
        "criteria": [
            {"key": "a1", "points": 1, "text": "Identifies Standard tier as right-skewed based on mean > median.", "evidence": "Must state mean (6.2) exceeds median (5) and conclude right-skew."},
            {"key": "a2", "points": 1, "text": "Identifies Premium tier as roughly symmetric based on mean ≈ median.", "evidence": "Must note mean (11.8) and median (11.5) are close and conclude roughly symmetric."},
            {"key": "b1", "points": 1, "text": "Correctly compares centers using resistant/appropriate statistics.", "evidence": "Should use median for the skewed Standard tier when comparing centers; concludes Premium has a higher typical value."},
            {"key": "b2", "points": 1, "text": "Correctly compares spread and references the shape distinction.", "evidence": "States Standard has greater SD-based spread, and ideally notes SD is less trustworthy for the skewed Standard distribution than for Premium."},
        ],
    },
    {
        "content_key": "APSTATS-FRQ-012",
        "unit": "Unit 1",
        "difficulty": "Medium",
        "subtopics": ["z-scores", "standard deviation"],
        "stem": (
            "On a standardized test, scores are approximately normally distributed "
            "with mean 500 and standard deviation 100. A student scores 650.\n\n"
            "**A.** Calculate the student's z-score and interpret it in context.\n\n"
            "**B.** A second student has a z-score of -1.5 on a different, "
            "unrelated test (mean 20, SD 4). Explain which student performed "
            "better relative to their own test, and justify using the z-scores "
            "rather than the raw scores."
        ),
        "canonical_answer": (
            "z = (650-500)/100 = 1.5. The first student scored 1.5 standard "
            "deviations above the mean. The first student (z=1.5) performed "
            "better relative to their test than the second student (z=-1.5, "
            "1.5 SD below the mean). Raw scores cannot be compared directly "
            "since the tests have different means and SDs; z-scores put both "
            "students on a common standardized scale."
        ),
        "criteria": [
            {"key": "a1", "points": 1, "text": "Correctly calculates z = 1.5.", "evidence": "Shows (650-500)/100 = 1.5."},
            {"key": "a2", "points": 1, "text": "Interprets z-score in context.", "evidence": "States the student scored 1.5 standard deviations above the mean test score."},
            {"key": "b1", "points": 1, "text": "Correctly identifies the first student as relatively higher-performing.", "evidence": "z=1.5 > z=-1.5."},
            {"key": "b2", "points": 1, "text": "Justifies using z-scores over raw scores.", "evidence": "Explains raw scores aren't comparable across tests with different means/SDs, while z-scores standardize both onto the same scale."},
        ],
    },
    {
        "content_key": "APSTATS-FRQ-013",
        "unit": "Unit 1",
        "difficulty": "Medium",
        "subtopics": ["percentiles", "boxplots"],
        "stem": (
            "A runner's finishing time in a race is at the 85th percentile of all "
            "finishers.\n\n"
            "**A.** Interpret the 85th percentile in context.\n\n"
            "**B.** The race has 400 finishers. Explain whether you can determine "
            "the runner's exact rank (e.g., 42nd place) from the percentile alone, "
            "and if so, estimate it; if not, explain what additional information "
            "would be needed."
        ),
        "canonical_answer": (
            "The runner finished faster than (or as fast as) approximately 85% of "
            "all finishers (assuming faster time = better, lower percentile of "
            "time corresponds to faster runners depending on convention; stated "
            "generally as 85% of finishing times were at or below this runner's "
            "value). With 400 finishers, being at the 85th percentile means "
            "roughly 0.85 x 400 = 340 finishers had times at or below this "
            "runner's time, placing the runner at approximately rank 60-61 from "
            "the front (400-340) depending on rounding and ties -- this is an "
            "estimate, not an exact rank, since percentile is a relative "
            "position, not an exact count without knowing how ties are handled."
        ),
        "criteria": [
            {"key": "a1", "points": 1, "text": "Interprets percentile in context.", "evidence": "States approximately 85% of finishers had a time at or below this runner's time (or equivalent context-appropriate statement)."},
            {"key": "b1", "points": 1, "text": "Correctly estimates the approximate count/rank.", "evidence": "Computes 0.85 x 400 = 340 and derives an approximate rank near 60-61st place."},
            {"key": "b2", "points": 1, "text": "Explains the estimate is approximate, not exact.", "evidence": "Notes percentile gives a relative position, and the exact rank depends on how ties or exact counts are handled, so it's an estimate."},
            {"key": "b3", "points": 1, "text": "Does not confuse percentile with percentage of the maximum score or similar misconception.", "evidence": "Response should not describe the percentile as 85% of the race distance/time value itself, only as a relative standing among finishers."},
        ],
    },
    # ---- Unit 2: Exploring Two-Variable Data ----
    {
        "content_key": "APSTATS-FRQ-014",
        "unit": "Unit 2",
        "difficulty": "Medium",
        "subtopics": ["residual plots", "linear model fit"],
        "stem": (
            "A least-squares regression line predicts a car's stopping distance "
            "from its speed. The residual plot shows residuals that are negative "
            "at low speeds, positive at moderate speeds, and negative again at "
            "high speeds (a clear U-then-down curved pattern).\n\n"
            "**A.** Explain what this residual pattern indicates about the "
            "appropriateness of a linear model for these data.\n\n"
            "**B.** Stopping distance is known to be proportional to the square "
            "of speed in physics. Explain how this fact is consistent with the "
            "residual plot pattern observed."
        ),
        "canonical_answer": (
            "The curved residual pattern indicates the true relationship between "
            "speed and stopping distance is not linear -- a linear model "
            "systematically over- and under-predicts across the range of speeds. "
            "This is consistent with the physics: since stopping distance grows "
            "with the square of speed (a quadratic relationship), a straight "
            "line will underestimate stopping distance at both very low and very "
            "high speeds relative to a curve, producing exactly this kind of "
            "curved residual pattern."
        ),
        "criteria": [
            {"key": "a1", "points": 1, "text": "States the curved pattern means a linear model is not appropriate.", "evidence": "Must explicitly connect the residual curve to inappropriateness of linearity, not just describe the pattern."},
            {"key": "a2", "points": 1, "text": "Explains residuals should be patternless/random for a good linear fit.", "evidence": "States that if linear were appropriate, residuals would scatter randomly around zero with no discernible pattern."},
            {"key": "b1", "points": 1, "text": "Connects the quadratic physics relationship to the observed residual curvature.", "evidence": "Explains that a quadratic true relationship, when fit with a line, produces systematic over/under-prediction matching the observed pattern."},
            {"key": "b2", "points": 1, "text": "Does not claim the quadratic relationship makes correlation/R-squared meaningless.", "evidence": "Should not conflate 'nonlinear relationship' with 'no relationship' -- a strong quadratic relationship can still produce a high r if the range is narrow, but that's a separate point from model-fit appropriateness."},
        ],
    },
    {
        "content_key": "APSTATS-FRQ-015",
        "unit": "Unit 2",
        "difficulty": "Easy",
        "subtopics": ["correlation vs causation", "lurking variables"],
        "stem": (
            "A researcher finds a strong positive correlation (r = 0.82) between "
            "the number of firefighters sent to a fire and the amount of damage "
            "caused by the fire, across many fires. A newspaper headline claims "
            "'Firefighters Cause More Fire Damage.'\n\n"
            "**A.** Explain why the headline's causal claim is not justified by "
            "this correlation alone.\n\n"
            "**B.** Propose a plausible lurking variable that could explain the "
            "observed correlation, and explain how it affects both variables."
        ),
        "canonical_answer": (
            "Correlation does not imply causation; this is an observational "
            "association, not a randomized experiment, so other explanations "
            "for the relationship cannot be ruled out. A plausible lurking "
            "variable is the size/severity of the fire: larger, more severe "
            "fires require more firefighters to be sent AND cause more damage, "
            "so fire size drives both variables rather than firefighters causing "
            "damage."
        ),
        "criteria": [
            {"key": "a1", "points": 1, "text": "States correlation does not imply causation.", "evidence": "Must explicitly invoke this principle, not just say 'it's not proven.'"},
            {"key": "a2", "points": 1, "text": "Explains this is observational data, not an experiment, so causal claims aren't justified.", "evidence": "Should note lack of random assignment/control as the reason causation can't be inferred."},
            {"key": "b1", "points": 1, "text": "Proposes a plausible lurking variable (e.g., fire size/severity).", "evidence": "Any variable that plausibly drives both firefighter count and damage is acceptable."},
            {"key": "b2", "points": 1, "text": "Explains how the lurking variable affects both the explanatory and response variable.", "evidence": "Must explain the mechanism connecting the lurking variable to both firefighter count and damage, not just name it."},
        ],
    },
    {
        "content_key": "APSTATS-FRQ-016",
        "unit": "Unit 2",
        "difficulty": "Medium",
        "subtopics": ["least-squares regression equation", "prediction", "extrapolation"],
        "stem": (
            "A least-squares regression line for predicting a house's sale price "
            "(in thousands of dollars) from its square footage is: "
            "`predicted price = 45 + 0.18(square footage)`. The data used to fit "
            "this line ranged from 800 to 3200 square feet.\n\n"
            "**A.** Interpret the slope of this regression line in context.\n\n"
            "**B.** A real estate agent wants to use this equation to predict the "
            "price of a 6000 square foot mansion. Predict the price, then explain "
            "why this specific prediction should not be trusted."
        ),
        "canonical_answer": (
            "Slope: for each additional square foot of house size, predicted "
            "sale price increases by about $0.18 thousand ($180), on average. "
            "Predicted price for 6000 sq ft: 45 + 0.18(6000) = 45 + 1080 = 1125, "
            "or $1,125,000. This prediction should not be trusted because 6000 "
            "square feet is far outside the range of the data used to fit the "
            "line (800-3200 sq ft) -- this is extrapolation, and there's no "
            "guarantee the same linear relationship holds for houses that much "
            "larger than any in the original dataset."
        ),
        "criteria": [
            {"key": "a1", "points": 1, "text": "Interprets the slope with correct direction, magnitude, units, and 'on average' language.", "evidence": "Must state $180 (or 0.18 thousand) increase per additional square foot, on average/predicted."},
            {"key": "b1", "points": 1, "text": "Correctly computes the predicted price as $1,125,000 (or 1125 thousand).", "evidence": "Shows 45 + 0.18(6000) = 1125."},
            {"key": "b2", "points": 1, "text": "Identifies this as extrapolation.", "evidence": "Names the concept of extrapolation (or equivalent description) explicitly."},
            {"key": "b3", "points": 1, "text": "Explains why extrapolation is untrustworthy here specifically.", "evidence": "Notes 6000 sq ft is well outside the 800-3200 sq ft range of the original data, so the linear relationship isn't verified to hold there."},
        ],
    },
    # ---- Unit 3: Collecting Data ----
    {
        "content_key": "APSTATS-FRQ-017",
        "unit": "Unit 3",
        "difficulty": "Easy",
        "subtopics": ["sampling bias", "convenience sampling"],
        "stem": (
            "A city wants to estimate the proportion of residents who support a "
            "new park. A researcher stands outside a single grocery store on a "
            "weekday afternoon and surveys the first 100 shoppers who pass by.\n\n"
            "**A.** Identify the sampling method used, and explain why it is "
            "likely to produce biased results.\n\n"
            "**B.** Describe a specific sampling method that would better "
            "represent the city's residents, and explain why it improves on the "
            "original method."
        ),
        "canonical_answer": (
            "This is convenience sampling (sampling whoever is easiest to reach). "
            "It's likely biased because shoppers at one store on a weekday "
            "afternoon are not representative of all city residents -- it "
            "systematically excludes people who don't shop there, work during "
            "that time, or live far from that store, likely skewing toward a "
            "particular demographic. A simple random sample of all residents "
            "(e.g., using a complete list of addresses and randomly selecting "
            "from it) would better represent the population because every "
            "resident would have an equal, known chance of selection, removing "
            "the systematic exclusion of certain groups."
        ),
        "criteria": [
            {"key": "a1", "points": 1, "text": "Correctly identifies convenience sampling.", "evidence": "Names the method as convenience sampling or an equivalent accurate description."},
            {"key": "a2", "points": 1, "text": "Explains why this produces biased results.", "evidence": "Identifies that the sample systematically excludes/underrepresents certain groups (non-shoppers, different times, distant residents), not just 'it's a small sample.'"},
            {"key": "b1", "points": 1, "text": "Describes a valid improved sampling method.", "evidence": "Simple random sample, stratified sample, or similar probability-based method described with enough specificity to be implementable."},
            {"key": "b2", "points": 1, "text": "Explains why the proposed method improves representativeness.", "evidence": "Connects the method to giving all (or defined strata of) residents a known chance of selection, removing the systematic exclusion."},
        ],
    },
    {
        "content_key": "APSTATS-FRQ-018",
        "unit": "Unit 3",
        "difficulty": "Medium",
        "subtopics": ["stratified sampling", "cluster sampling"],
        "stem": (
            "A school district with 20 schools wants to survey students about "
            "cafeteria food quality. Plan X: randomly select 4 entire schools and "
            "survey every student in those 4 schools. Plan Y: divide students by "
            "grade level (9th-12th) and randomly select a proportional number of "
            "students from each grade level.\n\n"
            "**A.** Identify the sampling method used in Plan X and in Plan Y.\n\n"
            "**B.** Explain one advantage Plan Y has over Plan X for this "
            "research question."
        ),
        "canonical_answer": (
            "Plan X is cluster sampling (entire naturally-occurring groups -- "
            "schools -- are randomly selected and everyone within them is "
            "surveyed). Plan Y is stratified sampling (the population is divided "
            "into subgroups -- grade levels -- and a random sample is taken from "
            "each). Advantage of Plan Y: it guarantees representation from every "
            "grade level in every school district context, whereas Plan X could "
            "by chance select 4 schools that are not representative of the "
            "district as a whole (e.g., all 4 happen to have unusually good or "
            "bad cafeteria food), introducing more sampling variability between "
            "different possible samples."
        ),
        "criteria": [
            {"key": "a1", "points": 1, "text": "Correctly identifies Plan X as cluster sampling.", "evidence": "Names cluster sampling specifically, not simple random or stratified."},
            {"key": "a2", "points": 1, "text": "Correctly identifies Plan Y as stratified sampling.", "evidence": "Names stratified sampling specifically."},
            {"key": "b1", "points": 1, "text": "Explains a valid advantage of stratified over cluster sampling for this scenario.", "evidence": "Should note stratified sampling guarantees representation across strata (grade levels) and tends to reduce sampling variability compared to cluster sampling, which risks an unrepresentative set of clusters."},
        ],
    },
    {
        "content_key": "APSTATS-FRQ-019",
        "unit": "Unit 3",
        "difficulty": "Medium",
        "subtopics": ["blocking", "experimental design"],
        "stem": (
            "A researcher is testing whether a new fertilizer increases crop "
            "yield. She has access to two very different field types: sandy soil "
            "and clay soil, and she suspects soil type strongly affects yield "
            "regardless of fertilizer.\n\n"
            "**A.** Explain how the researcher should use blocking by soil type in "
            "this experiment, including how plants would be randomly assigned to "
            "treatment within the design.\n\n"
            "**B.** Explain why blocking by soil type is expected to make it "
            "easier to detect a true fertilizer effect, if one exists, compared "
            "to not blocking."
        ),
        "canonical_answer": (
            "The researcher should divide the plots into two blocks by soil type "
            "(sandy, clay). Within each block, plots are randomly assigned to "
            "receive the new fertilizer or a control (standard fertilizer/no "
            "fertilizer). This ensures each soil type has both treatment "
            "groups represented, with randomization only occurring within each "
            "block. Blocking is expected to make a true fertilizer effect "
            "easier to detect because it removes the variability in yield due "
            "to soil type from the comparison -- since soil type affects yield a "
            "lot, comparing fertilizer effects within the same soil type "
            "isolates the fertilizer's effect from a major source of "
            "variability that would otherwise be lumped into random error, "
            "reducing power to detect a real effect."
        ),
        "criteria": [
            {"key": "a1", "points": 1, "text": "Correctly describes blocking by soil type (two blocks, sandy and clay).", "evidence": "States the two blocks are formed based on soil type."},
            {"key": "a2", "points": 1, "text": "Correctly describes random assignment within each block.", "evidence": "States plots are randomly assigned to fertilizer/control separately within each soil-type block, not randomized across the whole field ignoring soil type."},
            {"key": "b1", "points": 1, "text": "Explains that blocking removes soil-type variability from the treatment comparison.", "evidence": "Must state that a major source of variability (soil type) is controlled for/removed from the comparison, not just 'it's more organized.'"},
            {"key": "b2", "points": 1, "text": "Connects reduced variability to easier detection of the fertilizer effect.", "evidence": "Explains that removing this variability from what's treated as random error increases the ability to detect a real fertilizer effect (increases power / reduces noise)."},
        ],
    },
    # ---- Unit 4: Probability ----
    {
        "content_key": "APSTATS-FRQ-020",
        "unit": "Unit 4",
        "difficulty": "Medium",
        "subtopics": ["conditional probability", "two-way tables"],
        "stem": (
            "A survey of 300 adults classified them by whether they exercise "
            "regularly and whether they report good sleep quality.\n\n"
            "| | Good sleep | Poor sleep | Total |\n"
            "| --- | --- | --- | --- |\n"
            "| Exercises regularly | 105 | 45 | 150 |\n"
            "| Does not exercise | 60 | 90 | 150 |\n"
            "| Total | 165 | 135 | 300 |\n\n"
            "**A.** Find the probability that a randomly selected adult reports "
            "good sleep quality, GIVEN that they exercise regularly.\n\n"
            "**B.** Determine whether exercising regularly and good sleep quality "
            "are independent, showing the comparison that supports your "
            "conclusion."
        ),
        "canonical_answer": (
            "P(good sleep | exercises) = 105/150 = 0.70. Overall P(good sleep) = "
            "165/300 = 0.55. Since P(good sleep | exercises) = 0.70 is "
            "substantially different from the overall/unconditional P(good "
            "sleep) = 0.55 (or from P(good sleep | does not exercise) = "
            "60/150 = 0.40), exercise and good sleep are NOT independent -- "
            "they are associated."
        ),
        "criteria": [
            {"key": "a1", "points": 1, "text": "Correctly calculates P(good sleep | exercises) = 105/150 = 0.70.", "evidence": "Must divide by the row total (150), not the grand total (300)."},
            {"key": "b1", "points": 1, "text": "Calculates a valid comparison value (overall P(good sleep) or P(good sleep | does not exercise)).", "evidence": "Either 165/300=0.55 or 60/150=0.40, correctly computed."},
            {"key": "b2", "points": 1, "text": "Correctly concludes the variables are not independent, based on the numeric comparison.", "evidence": "States the two probabilities differ substantially, so independence does not hold, explicitly referencing both values being compared."},
        ],
    },
    {
        "content_key": "APSTATS-FRQ-021",
        "unit": "Unit 4",
        "difficulty": "Easy",
        "subtopics": ["complement rule", "addition rule"],
        "stem": (
            "At a car dealership, 40% of customers who visit purchase a sedan, "
            "25% purchase an SUV, and no customer purchases both in the same "
            "visit (a customer buys at most one vehicle per visit).\n\n"
            "**A.** Find the probability that a customer purchases either a sedan "
            "or an SUV.\n\n"
            "**B.** Find the probability that a customer purchases neither a "
            "sedan nor an SUV, and explain which probability rule you used."
        ),
        "canonical_answer": (
            "Since purchasing a sedan and purchasing an SUV are mutually "
            "exclusive (a customer buys at most one), P(sedan or SUV) = "
            "P(sedan) + P(SUV) = 0.40 + 0.25 = 0.65 (addition rule for mutually "
            "exclusive events). P(neither) = 1 - P(sedan or SUV) = 1 - 0.65 = "
            "0.35, using the complement rule."
        ),
        "criteria": [
            {"key": "a1", "points": 1, "text": "Correctly calculates P(sedan or SUV) = 0.65.", "evidence": "Shows 0.40 + 0.25 = 0.65, using the mutually-exclusive addition rule (no need to subtract an intersection since it's given as zero/mutually exclusive)."},
            {"key": "b1", "points": 1, "text": "Correctly calculates P(neither) = 0.35.", "evidence": "Shows 1 - 0.65 = 0.35."},
            {"key": "b2", "points": 1, "text": "Correctly names the complement rule as the rule used in part B.", "evidence": "Explicitly identifies the complement rule (P(not A) = 1 - P(A))."},
        ],
    },
    {
        "content_key": "APSTATS-FRQ-022",
        "unit": "Unit 4",
        "difficulty": "Hard",
        "subtopics": ["binomial distribution", "binomial conditions"],
        "stem": (
            "A quality inspector tests light bulbs from a large production run "
            "known to have a 5% defect rate. She randomly selects 20 bulbs to "
            "test, and each bulb's test result is independent of the others.\n\n"
            "**A.** Verify that the number of defective bulbs in this sample can "
            "be modeled by a binomial distribution, checking all necessary "
            "conditions.\n\n"
            "**B.** Using this binomial model, set up (but do not necessarily "
            "fully compute) the expression for the probability that exactly 2 of "
            "the 20 bulbs are defective."
        ),
        "canonical_answer": (
            "Binomial conditions: (1) Binary outcome -- each bulb is either "
            "defective or not; (2) Independent trials -- stated in the problem; "
            "(3) Fixed number of trials -- n=20 is fixed; (4) Constant "
            "probability of success -- p=0.05 for each bulb, reasonable since "
            "the production run is large (sampling without replacement from a "
            "large population approximately preserves independence/constant p). "
            "All conditions are satisfied, so X = number of defective bulbs is "
            "approximately Binomial(n=20, p=0.05). "
            "P(X=2) = C(20,2)(0.05)^2(0.95)^18."
        ),
        "criteria": [
            {"key": "a1", "points": 2, "text": "Checks all 4 binomial conditions (binary, independent, fixed n, constant p) with justification specific to this scenario.", "evidence": "Must address each of the 4 conditions individually, not just list them generically -- e.g., note independence is explicitly stated, n=20 is fixed, p=0.05 is constant since the production run is large."},
            {"key": "b1", "points": 1, "text": "Correctly sets up the binomial probability expression for P(X=2).", "evidence": "Shows C(20,2)(0.05)^2(0.95)^18 or equivalent correct notation with correct n, k, p values."},
        ],
    },
    {
        "content_key": "APSTATS-FRQ-023",
        "unit": "Unit 4",
        "difficulty": "Medium",
        "subtopics": ["expected value", "discrete random variables"],
        "stem": (
            "A raffle sells 500 tickets for $5 each. One ticket wins a $750 "
            "prize; all other tickets win nothing.\n\n"
            "**A.** Construct the probability distribution for X = net winnings "
            "(prize value minus ticket cost) for a single ticket, and calculate "
            "the expected value of X.\n\n"
            "**B.** Interpret the expected value in context, and explain what it "
            "does NOT mean for any individual ticket buyer."
        ),
        "canonical_answer": (
            "X can be 745 (win: 750-5) with probability 1/500, or -5 (lose: "
            "0-5) with probability 499/500. E(X) = 745(1/500) + (-5)(499/500) = "
            "1.49 - 4.99 = -3.50. On average, a ticket buyer loses $3.50 per "
            "ticket over many, many raffles/tickets -- this is a long-run "
            "average, not a prediction of what any single buyer actually wins "
            "or loses (no individual buyer will actually lose exactly $3.50 -- "
            "each individual either wins $745 or loses $5)."
        ),
        "criteria": [
            {"key": "a1", "points": 1, "text": "Correctly constructs the probability distribution (values and probabilities).", "evidence": "X=745 with p=1/500, X=-5 with p=499/500, or equivalent correct setup."},
            {"key": "a2", "points": 1, "text": "Correctly calculates E(X) = -$3.50.", "evidence": "Shows 745(1/500) + (-5)(499/500) = -3.50."},
            {"key": "b1", "points": 1, "text": "Interprets expected value as a long-run average.", "evidence": "States this represents the average outcome over many repetitions/many tickets, not a single-ticket prediction."},
            {"key": "b2", "points": 1, "text": "Explicitly explains what E(X) does not mean for an individual.", "evidence": "States no individual buyer actually experiences a loss of exactly $3.50 -- each individual either wins 745 or loses 5, never the average value itself."},
        ],
    },
    # ---- Unit 5: Sampling Distributions ----
    {
        "content_key": "APSTATS-FRQ-024",
        "unit": "Unit 5",
        "difficulty": "Medium",
        "subtopics": ["sampling distribution of a proportion", "CLT"],
        "stem": (
            "A population has a true proportion p = 0.30 of adults who own an "
            "electric vehicle. Researchers plan to take a random sample of "
            "n = 150 adults and compute the sample proportion.\n\n"
            "**A.** Describe the shape, center, and spread of the sampling "
            "distribution of the sample proportion, verifying any necessary "
            "conditions.\n\n"
            "**B.** Explain what would happen to the spread of this sampling "
            "distribution if the sample size were increased to n = 600, and "
            "explain the practical implication."
        ),
        "criteria": [
            {"key": "a1", "points": 1, "text": "Verifies large-counts condition and states shape is approximately normal.", "evidence": "Checks np=150(0.3)=45>=10 and n(1-p)=150(0.7)=105>=10, concludes approximately normal shape."},
            {"key": "a2", "points": 1, "text": "States center = p = 0.30.", "evidence": "Correctly states the mean of the sampling distribution equals the true population proportion."},
            {"key": "a3", "points": 1, "text": "Correctly calculates spread (standard deviation) using sqrt(p(1-p)/n).", "evidence": "Computes sqrt(0.3*0.7/150) ≈ 0.0374."},
            {"key": "b1", "points": 1, "text": "Explains spread decreases as n increases to 600, and the practical implication (more precise estimates).", "evidence": "Computes or reasons that sqrt(0.3*0.7/600) ≈ 0.0187 is smaller, and explains sample proportions will cluster more tightly around 0.30, giving a more precise/reliable estimate."},
        ],
        "canonical_answer": (
            "Shape: approximately normal, since np=45>=10 and n(1-p)=105>=10. "
            "Center: 0.30 (equal to the true population proportion). Spread: "
            "SD = sqrt(0.3*0.7/150) ≈ 0.0374. At n=600, SD = "
            "sqrt(0.3*0.7/600) ≈ 0.0187, about half of the n=150 value (since "
            "SD scales with 1/sqrt(n)). Practically, sample proportions from "
            "n=600 will be more tightly clustered around the true 0.30, making "
            "the sample proportion a more precise estimator."
        ),
    },
    {
        "content_key": "APSTATS-FRQ-025",
        "unit": "Unit 5",
        "difficulty": "Medium",
        "subtopics": ["unbiased estimators"],
        "stem": (
            "A statistics student claims: 'A sample mean from a single random "
            "sample is always equal to the true population mean, since it is an "
            "unbiased estimator.'\n\n"
            "**A.** Explain what it means for the sample mean to be an unbiased "
            "estimator of the population mean, and explain why the student's "
            "claim is incorrect.\n\n"
            "**B.** Explain how taking the average of many different sample "
            "means (from many repeated samples) relates to the concept of "
            "unbiasedness."
        ),
        "canonical_answer": (
            "An unbiased estimator means that the mean of the sampling "
            "distribution of the sample mean (i.e., the average value of the "
            "sample mean across all possible samples) equals the true "
            "population mean. It does NOT mean any single sample's mean will "
            "exactly equal the population mean -- individual sample means vary "
            "from sample to sample due to sampling variability, so the "
            "student's claim is incorrect. If you took many different random "
            "samples and averaged all of their sample means together, that "
            "average would center on (equal, in the long run) the true "
            "population mean -- this long-run centering is exactly what "
            "unbiasedness describes."
        ),
        "criteria": [
            {"key": "a1", "points": 1, "text": "Correctly defines unbiasedness in terms of the sampling distribution's mean equaling the population parameter.", "evidence": "Must reference the mean of the sampling distribution (across repeated samples), not a single sample."},
            {"key": "a2", "points": 1, "text": "Explains why the student's claim is incorrect.", "evidence": "States individual sample means vary due to sampling variability and generally will not exactly equal the population mean."},
            {"key": "b1", "points": 1, "text": "Explains the long-run averaging interpretation of unbiasedness.", "evidence": "States that averaging sample means across many repeated samples would converge to/center on the true population mean."},
        ],
    },
    {
        "content_key": "APSTATS-FRQ-026",
        "unit": "Unit 5",
        "difficulty": "Hard",
        "subtopics": ["sampling distribution of a difference in proportions"],
        "stem": (
            "Two independent random samples are taken: n1=100 from Population A "
            "(true proportion p1=0.60) and n2=120 from Population B (true "
            "proportion p2=0.45).\n\n"
            "**A.** Verify the conditions for the sampling distribution of "
            "(p1-hat - p2-hat) to be approximately normal.\n\n"
            "**B.** Calculate the mean and standard deviation of the sampling "
            "distribution of (p1-hat - p2-hat)."
        ),
        "canonical_answer": (
            "Conditions: both samples random/independent (given); large counts "
            "for both: n1*p1=60>=10, n1*(1-p1)=40>=10, n2*p2=54>=10, "
            "n2*(1-p2)=66>=10 -- all satisfied. Mean of (p1-hat - p2-hat) = "
            "p1 - p2 = 0.60 - 0.45 = 0.15. SD = sqrt(p1(1-p1)/n1 + "
            "p2(1-p2)/n2) = sqrt(0.6*0.4/100 + 0.45*0.55/120) = "
            "sqrt(0.0024 + 0.0020625) ≈ sqrt(0.0044625) ≈ 0.0668."
        ),
        "criteria": [
            {"key": "a1", "points": 1, "text": "Verifies independence/random sampling for both samples.", "evidence": "States both samples are random and independent of each other."},
            {"key": "a2", "points": 1, "text": "Verifies large-counts condition for both samples with all 4 values shown.", "evidence": "Shows n1p1, n1(1-p1), n2p2, n2(1-p2) all >= 10."},
            {"key": "b1", "points": 1, "text": "Correctly calculates the mean as 0.15.", "evidence": "Shows p1 - p2 = 0.60 - 0.45 = 0.15."},
            {"key": "b2", "points": 1, "text": "Correctly calculates the standard deviation ≈ 0.0668.", "evidence": "Shows the correct formula sqrt(p1(1-p1)/n1 + p2(1-p2)/n2) with correct substitution and arithmetic."},
        ],
    },
    # ---- Unit 6: Inference for Proportions ----
    {
        "content_key": "APSTATS-FRQ-027",
        "unit": "Unit 6",
        "difficulty": "Hard",
        "subtopics": ["two-sample z-test for proportions"],
        "stem": (
            "A company tests two versions of a website checkout page. Version A "
            "is shown to 400 visitors, and 68 complete a purchase. Version B is "
            "shown to 380 visitors, and 95 complete a purchase. The company wants "
            "to know if Version B has a higher true conversion rate.\n\n"
            "**A.** State appropriate hypotheses for a two-sample z-test, and "
            "verify the conditions.\n\n"
            "**B.** The test produces a p-value of 0.012. State a conclusion in "
            "context at alpha = 0.05."
        ),
        "canonical_answer": (
            "H0: p_A = p_B (or p_B - p_A = 0); Ha: p_B > p_A, where p_A and p_B "
            "are the true conversion rates for each version. Sample proportions: "
            "p_A-hat = 68/400 = 0.17, p_B-hat = 95/380 = 0.25. Conditions: both "
            "groups randomly assigned/independent (given as separate visitor "
            "groups); large counts using pooled proportion "
            "p-hat_pooled = (68+95)/(400+380) = 163/780 ≈ 0.209: "
            "n_A*p-hat_pooled ≈ 83.6>=10, n_A*(1-p-hat_pooled) ≈ 316.4>=10, "
            "n_B*p-hat_pooled ≈ 79.4>=10, n_B*(1-p-hat_pooled) ≈ 300.6>=10 -- all "
            "satisfied. Since p-value (0.012) < alpha (0.05), there is "
            "convincing evidence that Version B has a higher true conversion "
            "rate than Version A."
        ),
        "criteria": [
            {"key": "a1", "points": 1, "text": "States correct hypotheses in context with a one-sided alternative.", "evidence": "H0: p_A = p_B, Ha: p_B > p_A (or equivalent), with p_A/p_B defined as true conversion rates."},
            {"key": "a2", "points": 1, "text": "Verifies large-counts condition using the pooled proportion.", "evidence": "Computes pooled p-hat and checks all 4 values (n_A*p-hat, n_A*(1-p-hat), n_B*p-hat, n_B*(1-p-hat)) are >=10 -- using the pooled estimate, not each sample's own proportion, since this is a hypothesis test for equality."},
            {"key": "b1", "points": 1, "text": "Correctly compares p-value to alpha and states significance.", "evidence": "States 0.012 < 0.05, so the result is statistically significant."},
            {"key": "b2", "points": 1, "text": "States a properly contextualized conclusion with correct direction.", "evidence": "Concludes there is convincing evidence Version B's true conversion rate is greater than Version A's, in context."},
        ],
    },
    {
        "content_key": "APSTATS-FRQ-028",
        "unit": "Unit 6",
        "difficulty": "Medium",
        "subtopics": ["confidence interval for a proportion", "margin of error"],
        "stem": (
            "A pollster surveys a random sample of 800 voters and finds 456 "
            "support a ballot measure. A 95% confidence interval for the true "
            "proportion of support is calculated to be (0.535, 0.605).\n\n"
            "**A.** Interpret this confidence interval in context.\n\n"
            "**B.** The pollster wants to reduce the margin of error to half its "
            "current size for a future poll on the same measure. Explain "
            "(without recomputing exactly) what would need to change about the "
            "sample size, and why."
        ),
        "canonical_answer": (
            "We are 95% confident that the interval (0.535, 0.605) captures the "
            "true proportion of all voters who support the ballot measure. "
            "Since margin of error is proportional to 1/sqrt(n), halving the "
            "margin of error requires quadrupling the sample size (multiplying "
            "n by 4), because sqrt(4n) = 2*sqrt(n), so the margin of error "
            "(which is inversely proportional to sqrt(n)) is cut in half only "
            "when n increases by a factor of 4."
        ),
        "criteria": [
            {"key": "a1", "points": 1, "text": "Correctly interprets the CI referencing the true population proportion.", "evidence": "States 95% confident the interval captures the true proportion of all voters supporting the measure -- not a claim about 95% of voters or about this specific sample."},
            {"key": "b1", "points": 1, "text": "States the sample size must be quadrupled (multiplied by 4).", "evidence": "Correct numeric relationship stated."},
            {"key": "b2", "points": 1, "text": "Explains why, referencing the inverse-square-root relationship between margin of error and n.", "evidence": "Explains margin of error is proportional to 1/sqrt(n), so to halve it, n must increase by a factor of 4 (since sqrt(4)=2)."},
        ],
    },
    {
        "content_key": "APSTATS-FRQ-029",
        "unit": "Unit 6",
        "difficulty": "Hard",
        "subtopics": ["Type I and Type II errors"],
        "stem": (
            "A pharmaceutical company tests a new drug, with H0: the drug has no "
            "effect on blood pressure, versus Ha: the drug lowers blood "
            "pressure. Based on the test, the company decides to bring the drug "
            "to market.\n\n"
            "**A.** Describe what a Type I error would mean in this context, and "
            "describe a consequence of making this error.\n\n"
            "**B.** Describe what a Type II error would mean in this context, "
            "and describe a consequence of making this error. Then explain which "
            "error you believe is more serious in this specific scenario, with "
            "justification."
        ),
        "canonical_answer": (
            "Type I error: concluding the drug lowers blood pressure (rejecting "
            "H0) when it actually has no effect. Consequence: an ineffective "
            "drug is brought to market, potentially exposing patients to side "
            "effects/costs with no real benefit. Type II error: concluding "
            "there's not enough evidence the drug works (failing to reject H0) "
            "when it actually does lower blood pressure. Consequence: an "
            "effective drug is not brought to market, denying patients a "
            "beneficial treatment. Which is more serious is a judgment call: a "
            "reasonable answer might argue Type I is more serious since "
            "patients could be exposed to an ineffective drug's risks/side "
            "effects with no benefit, or that Type II is more serious since "
            "patients lose access to a genuinely helpful treatment -- either "
            "answer should be accepted if justified with a clear, relevant "
            "consequence-based argument."
        ),
        "criteria": [
            {"key": "a1", "points": 1, "text": "Correctly describes Type I error in context.", "evidence": "Concluding the drug works (rejecting H0) when it actually doesn't."},
            {"key": "a2", "points": 1, "text": "Describes a relevant consequence of the Type I error.", "evidence": "An ineffective/unhelpful drug reaches the market, e.g. exposing patients to costs or side effects without benefit."},
            {"key": "b1", "points": 1, "text": "Correctly describes Type II error in context.", "evidence": "Failing to conclude the drug works (failing to reject H0) when it actually does."},
            {"key": "b2", "points": 1, "text": "Describes a relevant consequence of the Type II error.", "evidence": "A genuinely effective drug fails to reach patients who could benefit."},
            {"key": "b3", "points": 1, "text": "States a judgment on which error is more serious, with a coherent justification.", "evidence": "Either answer (Type I or Type II) is acceptable if backed with a clear, scenario-relevant reason -- reviewer should not penalize for the choice itself, only for missing or incoherent justification."},
        ],
    },
    # ---- Unit 7: Inference for Means ----
    {
        "content_key": "APSTATS-FRQ-030",
        "unit": "Unit 7",
        "difficulty": "Medium",
        "subtopics": ["paired vs two-sample design"],
        "stem": (
            "A researcher wants to test whether a new training program improves "
            "employees' typing speed. Design 1: measure the same 30 employees' "
            "typing speed before and after the program. Design 2: randomly split "
            "60 employees into two groups of 30 -- one group gets the training, "
            "the other doesn't -- then compare typing speeds between groups.\n\n"
            "**A.** Identify which design calls for a paired t-procedure and "
            "which calls for a two-sample t-procedure, and explain why.\n\n"
            "**B.** Explain one statistical advantage the paired design (Design "
            "1) has over the two-sample design (Design 2) for this specific "
            "research question."
        ),
        "canonical_answer": (
            "Design 1 (before/after on the same 30 employees) calls for a "
            "paired t-procedure, since each employee is measured twice and the "
            "two measurements are naturally linked (not independent). Design 2 "
            "(two separate, independently assigned groups of 30) calls for a "
            "two-sample t-procedure, since the two groups consist of different, "
            "independent employees. Advantage of pairing: by comparing each "
            "employee to themselves, individual differences in baseline typing "
            "ability (which vary a lot from person to person) are removed from "
            "the comparison, reducing variability and making it easier to "
            "detect a true training effect if one exists."
        ),
        "criteria": [
            {"key": "a1", "points": 1, "text": "Correctly identifies Design 1 as paired.", "evidence": "States Design 1 requires a paired t-procedure since the same employees are measured twice."},
            {"key": "a2", "points": 1, "text": "Correctly identifies Design 2 as two-sample.", "evidence": "States Design 2 requires a two-sample t-procedure since the groups are independent, different employees."},
            {"key": "b1", "points": 1, "text": "Explains the statistical advantage of pairing.", "evidence": "Must explain that pairing removes person-to-person baseline variability from the comparison, reducing variability/noise and making a true effect easier to detect -- not just 'it's a better design' without mechanism."},
        ],
    },
    {
        "content_key": "APSTATS-FRQ-031",
        "unit": "Unit 7",
        "difficulty": "Medium",
        "subtopics": ["one-sample t-test for a mean"],
        "stem": (
            "A cereal manufacturer claims boxes contain 16 oz of cereal on "
            "average. A consumer group weighs a random sample of 25 boxes and "
            "finds a sample mean of 15.6 oz with a sample standard deviation of "
            "0.9 oz. They want to test whether the true mean weight is less than "
            "claimed.\n\n"
            "**A.** State the hypotheses and calculate the test statistic.\n\n"
            "**B.** With 24 degrees of freedom, the p-value for this test "
            "statistic is 0.019. State a conclusion in context at alpha = 0.05."
        ),
        "canonical_answer": (
            "H0: mu = 16, Ha: mu < 16, where mu is the true mean weight of all "
            "cereal boxes. t = (15.6 - 16)/(0.9/sqrt(25)) = (-0.4)/(0.18) ≈ "
            "-2.22. Since the p-value (0.019) is less than alpha (0.05), the "
            "result is statistically significant. There is convincing evidence "
            "that the true mean weight of cereal boxes is less than the claimed "
            "16 oz."
        ),
        "criteria": [
            {"key": "a1", "points": 1, "text": "States correct hypotheses in context with one-sided alternative.", "evidence": "H0: mu = 16, Ha: mu < 16, with mu defined as the true mean box weight."},
            {"key": "a2", "points": 1, "text": "Correctly calculates the t test statistic ≈ -2.22.", "evidence": "Shows (15.6-16)/(0.9/sqrt(25)) = -2.22."},
            {"key": "b1", "points": 1, "text": "Compares p-value to alpha and states significance.", "evidence": "States 0.019 < 0.05, so the result is statistically significant."},
            {"key": "b2", "points": 1, "text": "States a properly contextualized, directional conclusion.", "evidence": "Concludes convincing evidence that the true mean weight is less than 16 oz, contradicting the manufacturer's claim."},
        ],
    },
    {
        "content_key": "APSTATS-FRQ-032",
        "unit": "Unit 7",
        "difficulty": "Hard",
        "subtopics": ["paired t confidence interval"],
        "stem": (
            "A running coach measures 15 athletes' mile times before and after "
            "an 8-week training program. The differences (before minus after, in "
            "seconds) have a sample mean of 12.4 seconds and a sample standard "
            "deviation of 9.8 seconds.\n\n"
            "**A.** Construct a 90% confidence interval for the true mean "
            "improvement in mile time, showing the critical value and "
            "calculation (use t* = 1.761 for df=14, 90% confidence).\n\n"
            "**B.** Based on this interval, is there convincing evidence that "
            "the training program produces a true mean improvement greater than "
            "0 seconds? Explain."
        ),
        "canonical_answer": (
            "12.4 +/- 1.761(9.8/sqrt(15)) = 12.4 +/- 1.761(2.531) = "
            "12.4 +/- 4.457, giving an interval of approximately (7.94, 16.86) "
            "seconds. Since this entire interval is above 0, there is "
            "convincing evidence that the training program produces a true "
            "mean improvement greater than 0 seconds (a plausible range of "
            "true mean improvement, 7.94 to 16.86 seconds, does not include the "
            "no-improvement value of 0)."
        ),
        "criteria": [
            {"key": "a1", "points": 2, "text": "Correctly constructs the interval with correct formula, critical value, and arithmetic.", "evidence": "Shows 12.4 +/- 1.761(9.8/sqrt(15)) with correct arithmetic to (7.94, 16.86)."},
            {"key": "b1", "points": 1, "text": "Correctly concludes there is convincing evidence of improvement, based on the interval excluding 0.", "evidence": "Must explicitly reference that the entire interval lies above 0 (does not contain 0) as the justification, not just assert the conclusion."},
        ],
    },
    # ---- Unit 8: Chi-Square ----
    {
        "content_key": "APSTATS-FRQ-033",
        "unit": "Unit 8",
        "difficulty": "Hard",
        "subtopics": ["chi-square test for homogeneity"],
        "stem": (
            "Independent random samples of students from three different high "
            "schools were asked whether they prefer online, hybrid, or in-person "
            "classes. Researchers want to test whether the distribution of "
            "preference is the same across all three schools.\n\n"
            "| | Online | Hybrid | In-person | Total |\n"
            "| --- | --- | --- | --- | --- |\n"
            "| School A | 40 | 35 | 25 | 100 |\n"
            "| School B | 30 | 45 | 45 | 120 |\n"
            "| School C | 20 | 30 | 30 | 80 |\n"
            "| Total | 90 | 110 | 100 | 300 |\n\n"
            "**A.** State the hypotheses for a chi-square test for homogeneity, "
            "and calculate the expected count for School A / Online.\n\n"
            "**B.** The resulting chi-square statistic is 7.42 with 4 degrees of "
            "freedom (p-value = 0.115). State a conclusion in context at "
            "alpha = 0.05."
        ),
        "canonical_answer": (
            "H0: the distribution of class-format preference is the same across "
            "all three schools. Ha: the distribution of class-format preference "
            "differs across at least one school. Expected count for School A / "
            "Online = (row total x column total)/grand total = "
            "(100 x 90)/300 = 30. Degrees of freedom = (3-1)(3-1) = 4, matching "
            "the given statistic. Since the p-value (0.115) is greater than "
            "alpha (0.05), the result is not statistically significant -- there "
            "is not convincing evidence that class-format preference "
            "distributions differ across the three schools."
        ),
        "criteria": [
            {"key": "a1", "points": 1, "text": "States correct hypotheses for a homogeneity test.", "evidence": "H0: distributions are the same across schools; Ha: at least one school's distribution differs."},
            {"key": "a2", "points": 1, "text": "Correctly calculates the expected count for School A/Online as 30.", "evidence": "Shows (100 x 90)/300 = 30."},
            {"key": "b1", "points": 1, "text": "Verifies df = 4 matches the given statistic.", "evidence": "Shows (3-1)(3-1) = 4."},
            {"key": "b2", "points": 1, "text": "States a correct, properly contextualized conclusion (fail to reject H0).", "evidence": "Since 0.115 > 0.05, concludes there is not convincing evidence of a difference in preference distributions across schools -- must not claim the distributions ARE the same, only that there's insufficient evidence of a difference."},
        ],
    },
    {
        "content_key": "APSTATS-FRQ-034",
        "unit": "Unit 8",
        "difficulty": "Medium",
        "subtopics": ["chi-square test of independence"],
        "stem": (
            "A survey asked 250 employees about their preferred work "
            "arrangement (remote, hybrid, in-office) and their department "
            "(Sales, Engineering). Researchers want to test whether preferred "
            "work arrangement is associated with department.\n\n"
            "**A.** State the hypotheses for a chi-square test of independence "
            "in this context.\n\n"
            "**B.** The test yields chi-square = 12.6 with 2 degrees of freedom "
            "(p-value = 0.0018). State a conclusion in context at alpha = 0.05, "
            "and explain what 'independence' would have meant if the null "
            "hypothesis had not been rejected."
        ),
        "canonical_answer": (
            "H0: preferred work arrangement and department are independent. "
            "Ha: preferred work arrangement and department are associated (not "
            "independent). Since the p-value (0.0018) is less than alpha "
            "(0.05), there is convincing evidence of an association between "
            "preferred work arrangement and department. If H0 had not been "
            "rejected, independence would have meant that the distribution of "
            "work-arrangement preference is roughly the same regardless of "
            "which department an employee is in -- knowing someone's department "
            "would not help predict their work-arrangement preference."
        ),
        "criteria": [
            {"key": "a1", "points": 1, "text": "States correct hypotheses for a test of independence.", "evidence": "H0: the two variables are independent; Ha: the two variables are associated."},
            {"key": "b1", "points": 1, "text": "States a correct, contextualized conclusion (reject H0).", "evidence": "Since 0.0018 < 0.05, convincing evidence of association between work arrangement and department."},
            {"key": "b2", "points": 1, "text": "Correctly explains what independence would mean in this context.", "evidence": "States that under independence, work-arrangement preference distribution would be the same across departments / department wouldn't help predict preference."},
        ],
    },
    {
        "content_key": "APSTATS-FRQ-035",
        "unit": "Unit 8",
        "difficulty": "Medium",
        "subtopics": ["chi-square goodness-of-fit"],
        "stem": (
            "A candy company claims its bags of mixed candy contain 30% red, "
            "30% yellow, 20% green, and 20% blue candies. A quality tester opens "
            "a large sample bag with 200 candies and counts: 70 red, 52 yellow, "
            "44 green, 34 blue.\n\n"
            "**A.** State the hypotheses and calculate the expected count for "
            "each color under the company's claim.\n\n"
            "**B.** The chi-square statistic is 9.13 with 3 degrees of freedom "
            "(p-value = 0.028). State a conclusion in context at alpha = 0.05."
        ),
        "canonical_answer": (
            "H0: the true color distribution matches the claimed proportions "
            "(30% red, 30% yellow, 20% green, 20% blue). Ha: at least one "
            "color's true proportion differs from the claim. Expected counts: "
            "red = 200(0.30) = 60, yellow = 200(0.30) = 60, green = "
            "200(0.20) = 40, blue = 200(0.20) = 40. Since the p-value (0.028) "
            "is less than alpha (0.05), there is convincing evidence that the "
            "true color distribution does not match the company's claimed "
            "proportions."
        ),
        "criteria": [
            {"key": "a1", "points": 1, "text": "States correct hypotheses in context.", "evidence": "H0: true proportions match the claim (30/30/20/20); Ha: at least one proportion differs."},
            {"key": "a2", "points": 1, "text": "Correctly calculates all 4 expected counts (60, 60, 40, 40).", "evidence": "Shows 200 x each claimed proportion for all four colors."},
            {"key": "b1", "points": 1, "text": "States a correct, contextualized conclusion.", "evidence": "Since 0.028 < 0.05, convincing evidence the true distribution doesn't match the claim."},
        ],
    },
    # ---- Unit 9: Inference for Slope ----
    {
        "content_key": "APSTATS-FRQ-036",
        "unit": "Unit 9",
        "difficulty": "Hard",
        "subtopics": ["t-test for slope"],
        "stem": (
            "A researcher fits a least-squares regression line predicting plant "
            "height (cm) from days of sunlight exposure, using a random sample "
            "of 18 plants. The regression output shows: slope b1 = 0.85, "
            "SE_b1 = 0.31. The researcher wants to test whether there is a true "
            "positive linear relationship between sunlight exposure and plant "
            "height.\n\n"
            "**A.** State the hypotheses and calculate the t test statistic for "
            "the slope.\n\n"
            "**B.** With 16 degrees of freedom, the p-value is 0.014. State a "
            "conclusion in context at alpha = 0.05."
        ),
        "canonical_answer": (
            "H0: beta1 = 0 (no true linear relationship between sunlight "
            "exposure and plant height); Ha: beta1 > 0 (a true positive linear "
            "relationship exists). t = b1/SE_b1 = 0.85/0.31 ≈ 2.74. Since the "
            "p-value (0.014) is less than alpha (0.05), there is convincing "
            "evidence of a true positive linear relationship between sunlight "
            "exposure and plant height in the population."
        ),
        "criteria": [
            {"key": "a1", "points": 1, "text": "States correct hypotheses for slope inference with one-sided alternative.", "evidence": "H0: beta1 = 0, Ha: beta1 > 0, defined in terms of the true population slope."},
            {"key": "a2", "points": 1, "text": "Correctly calculates t = b1/SE_b1 ≈ 2.74.", "evidence": "Shows 0.85/0.31 = 2.74."},
            {"key": "b1", "points": 1, "text": "Compares p-value to alpha and states significance.", "evidence": "States 0.014 < 0.05, statistically significant."},
            {"key": "b2", "points": 1, "text": "States a properly contextualized, directional conclusion about the true slope.", "evidence": "Concludes convincing evidence of a true positive linear relationship between sunlight exposure and plant height."},
        ],
    },
    {
        "content_key": "APSTATS-FRQ-037",
        "unit": "Unit 9",
        "difficulty": "Medium",
        "subtopics": ["confidence interval for slope"],
        "stem": (
            "Using the same plant height / sunlight data as above (n=18, "
            "b1 = 0.85, SE_b1 = 0.31, df=16), construct and interpret a 95% "
            "confidence interval for the true slope (use t* = 2.120 for df=16, "
            "95% confidence).\n\n"
            "**A.** Calculate the confidence interval, showing your work.\n\n"
            "**B.** Interpret the interval in context."
        ),
        "canonical_answer": (
            "0.85 +/- 2.120(0.31) = 0.85 +/- 0.657, giving an interval of "
            "approximately (0.193, 1.507). We are 95% confident that the true "
            "slope of the relationship between sunlight exposure (days) and "
            "plant height (cm) is captured by this interval -- that is, for "
            "each additional day of sunlight exposure, true mean plant height "
            "increases by somewhere between about 0.19 and 1.51 cm."
        ),
        "criteria": [
            {"key": "a1", "points": 1, "text": "Correctly calculates the interval with correct formula and arithmetic.", "evidence": "Shows 0.85 +/- 2.120(0.31) = (0.193, 1.507)."},
            {"key": "b1", "points": 1, "text": "Correctly interprets the interval in context, referencing the true slope.", "evidence": "States 95% confidence the interval captures the true slope (increase in plant height per additional day of sunlight), not a claim about individual plants or the sample slope alone."},
        ],
    },
    {
        "content_key": "APSTATS-FRQ-038",
        "unit": "Unit 9",
        "difficulty": "Hard",
        "subtopics": ["conditions for regression inference"],
        "stem": (
            "Before running inference on the slope of a regression line, a "
            "student must check several conditions (sometimes remembered as "
            "'LINER': Linear, Independent, Normal residuals, Equal variance, "
            "Random sample).\n\n"
            "**A.** Describe what graphical evidence would help verify the "
            "'Linear' and 'Equal variance' conditions, and what pattern in that "
            "graphical evidence would indicate each condition is violated.\n\n"
            "**B.** Describe what graphical evidence would help verify the "
            "'Normal residuals' condition, and what pattern would indicate that "
            "condition is violated."
        ),
        "canonical_answer": (
            "A residual plot (residuals vs. x, or vs. predicted values) helps "
            "check both Linear and Equal variance. Linearity is violated if the "
            "residual plot shows a curved/systematic pattern rather than random "
            "scatter around zero. Equal variance (constant spread) is violated "
            "if the residual plot shows a fan/funnel shape -- residuals "
            "spreading wider or narrower as x (or predicted value) increases. A "
            "normal probability plot (or histogram/dotplot) of the residuals "
            "helps check the Normal residuals condition; it's violated if the "
            "normal probability plot shows a clear curved departure from a "
            "straight line (or if a histogram of residuals is strongly skewed "
            "or has outliers)."
        ),
        "criteria": [
            {"key": "a1", "points": 1, "text": "Identifies the residual plot as the tool for checking Linear and Equal variance.", "evidence": "Names residual plot (residuals vs x or predicted values) for both conditions."},
            {"key": "a2", "points": 1, "text": "Correctly describes the violation pattern for Linear (curved pattern) and Equal variance (fan/funnel shape) separately.", "evidence": "Must distinguish the two patterns -- curvature indicates nonlinearity, a fan/funnel shape indicates unequal variance."},
            {"key": "b1", "points": 1, "text": "Identifies a normal probability plot (or equivalent, e.g. histogram) of residuals as the tool for checking Normal residuals.", "evidence": "Names an appropriate graphical tool for assessing normality of residuals."},
            {"key": "b2", "points": 1, "text": "Correctly describes the violation pattern for Normal residuals.", "evidence": "States a curved departure from a straight line on a normal probability plot (or a skewed/outlier-containing histogram) indicates non-normal residuals."},
        ],
    },
    {
        "content_key": "APSTATS-FRQ-039",
        "unit": "Unit 6",
        "difficulty": "Medium",
        "subtopics": ["power of a test"],
        "stem": (
            "A researcher is designing a hypothesis test to detect whether a new "
            "teaching method improves test scores. She is concerned about the "
            "power of her test.\n\n"
            "**A.** Explain what the power of a test means in this context.\n\n"
            "**B.** Describe two specific changes the researcher could make to "
            "her study design that would increase the power of the test, and "
            "explain why each change increases power."
        ),
        "canonical_answer": (
            "Power is the probability that the test correctly detects a true "
            "effect -- here, the probability of correctly concluding the "
            "teaching method improves scores when it truly does. Two ways to "
            "increase power: (1) Increase the sample size -- a larger sample "
            "reduces the standard error of the sampling distribution, making it "
            "easier to distinguish a true effect from sampling variability. "
            "(2) Increase the significance level (alpha) -- e.g., from 0.05 to "
            "0.10 -- which makes it easier to reject H0, increasing power but "
            "also increasing the Type I error rate as a tradeoff. (Other valid "
            "answers: reduce variability in the response variable through "
            "better measurement/design, or use a one-sided instead of two-sided "
            "test if directionally justified, each with correct reasoning.)"
        ),
        "criteria": [
            {"key": "a1", "points": 1, "text": "Correctly defines power in context.", "evidence": "States power is the probability of correctly detecting/concluding a true effect (correctly rejecting H0 when the alternative is true), specific to the teaching-method scenario."},
            {"key": "b1", "points": 1, "text": "Describes a valid method to increase power (e.g., increase sample size).", "evidence": "Any statistically valid method (larger n, larger alpha, less variability, one-sided test where justified) with correct reasoning."},
            {"key": "b2", "points": 1, "text": "Describes a second valid, distinct method to increase power, with correct reasoning.", "evidence": "Must be a genuinely different mechanism from the first, each with its own correct explanation of why it increases power."},
        ],
    },
    {
        "content_key": "APSTATS-FRQ-040",
        "unit": "Unit 2",
        "difficulty": "Easy",
        "subtopics": ["coefficient of determination", "r-squared"],
        "stem": (
            "A regression analysis relating hours of sleep to reaction time "
            "produces r^2 = 0.64.\n\n"
            "**A.** Interpret r^2 in context.\n\n"
            "**B.** A classmate says, 'r^2 = 0.64 means the correlation is "
            "0.64.' Explain what is wrong with this statement and state the "
            "correct value(s) of r consistent with this r^2."
        ),
        "canonical_answer": (
            "About 64% of the variability in reaction time is explained by the "
            "linear relationship with hours of sleep (using the least-squares "
            "regression line). The classmate's statement confuses r^2 with r: "
            "r is the square root of r^2, not r^2 itself. Since r^2 = 0.64, "
            "r = +/-sqrt(0.64) = +/-0.8 -- so r is either 0.8 (if the "
            "association is positive) or -0.8 (if negative); the sign of r "
            "cannot be determined from r^2 alone, but should typically match "
            "the sign of the slope."
        ),
        "criteria": [
            {"key": "a1", "points": 1, "text": "Correctly interprets r^2 as percent of variability in the response variable explained by the linear model.", "evidence": "Must reference variability in reaction time (response variable) explained by the regression on sleep, not describe it as 'strength of correlation' directly."},
            {"key": "b1", "points": 1, "text": "Explains the classmate's error (confusing r with r^2).", "evidence": "States r is the square root of r^2, not the same value."},
            {"key": "b2", "points": 1, "text": "Correctly states r = +/-0.8 and notes the sign is ambiguous from r^2 alone.", "evidence": "Shows sqrt(0.64) = 0.8 and explains r could be +0.8 or -0.8 depending on the direction of the association (matching the slope's sign)."},
        ],
    },
]
