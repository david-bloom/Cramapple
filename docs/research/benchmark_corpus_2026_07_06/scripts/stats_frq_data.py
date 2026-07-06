# AI-provisional (Claude-authored) Statistics FRQ corpus data.
# NOT Learning-Quality-approved. See label_status in generator output.

STATS_FRQ_ITEMS = [
    {
        "id": "statistics_frq_01",
        "title": "Conditional Relative Frequencies and a Claim of Independence",
        "unit": "Unit 1 - Exploring One-Variable Data / Categorical Data",
        "difficulty": "Medium",
        "content_type": "interpretation",
        "stem": (
            "A survey of 400 students classified them by grade level (Freshman/Senior) and "
            "whether they participate in an after-school club (Yes/No).\n\n"
            "| | Club: Yes | Club: No | Total |\n"
            "| --- | --- | --- | --- |\n"
            "| Freshman | 60 | 140 | 200 |\n"
            "| Senior | 100 | 100 | 200 |\n"
            "| Total | 160 | 240 | 400 |\n\n"
            "**A.** Calculate the conditional relative frequency of club participation given "
            "Freshman status, and the conditional relative frequency of club participation "
            "given Senior status. Show your work.\n\n"
            "**B.** Based on these conditional relative frequencies, explain whether grade level "
            "and club participation appear to be associated (not independent) in this sample, "
            "and justify your answer using the values from part A."
        ),
        "criteria": [
            {"id": "C1", "text": "Calculates P(Club Yes | Freshman) = 60/200 = 0.30 (30%).", "notes": "Must divide by the row total (200), not the grand total (400)."},
            {"id": "C2", "text": "Calculates P(Club Yes | Senior) = 100/200 = 0.50 (50%).", "notes": "Must divide by the row total (200), not the grand total."},
            {"id": "C3", "text": "States that grade level and club participation appear to be associated (not independent) in this sample.", "notes": "Must conclude association, not independence, given the differing conditional frequencies."},
            {"id": "C4", "text": "Justifies the association claim by explicitly comparing the two conditional relative frequencies from A (30% vs. 50%) and noting that if the variables were independent, these conditional frequencies would be approximately equal.", "notes": "Must reference the specific numeric comparison, not just assert 'the numbers are different.'"},
        ],
        "responses": [
            {
                "id": "R1",
                "text": (
                    "(A) P(Club Yes | Freshman) = 60/200 = 0.30. P(Club Yes | Senior) = 100/200 = 0.50.\n\n"
                    "(B) Grade level and club participation appear to be associated in this sample. If the two "
                    "variables were independent, the conditional relative frequency of club participation should "
                    "be roughly the same for Freshmen and Seniors. Instead, only 30% of Freshmen participate "
                    "compared to 50% of Seniors, a substantial difference, which suggests club participation "
                    "depends on grade level rather than being independent of it."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit response with correct conditional frequencies computed off the correct row totals and a comparison-based justification referencing the independence definition.",
                "boundary_tags": [],
            },
            {
                "id": "R2",
                "text": (
                    "(A) P(Club Yes | Freshman) = 60/400 = 0.15. P(Club Yes | Senior) = 100/400 = 0.25.\n\n"
                    "(B) They are independent because both grades have some students in the club."
                ),
                "labels": {"C1": "not_earned", "C2": "not_earned", "C3": "not_earned", "C4": "not_earned"},
                "reviewer_note": "Divides by the grand total (400) instead of the row total (200) for both conditional frequencies, which is the classic conditional-relative-frequency error. The independence conclusion in (B) is also wrong (the correct conditional frequencies of 30% vs 50% show association) and the justification ('both grades have some students') doesn't address conditional frequencies at all. Flags: arithmetic method error (wrong denominator), unsupported conclusion.",
                "boundary_tags": ["arithmetic_method_error", "unsupported_inference"],
            },
            {
                "id": "R3",
                "text": (
                    "(A) P(Club Yes | Freshman) = 60/200 = 0.30. P(Club Yes | Senior) = 100/200 = 0.50.\n\n"
                    "(B) They appear to be associated since the percentages are different."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "not_earned"},
                "reviewer_note": "Correct calculations and correct conclusion, but the justification never states the actual values being compared (30% vs. 50%) or connects the comparison to the definition of independence -- 'the percentages are different' is a vague restatement rather than the specific numeric justification the criterion requires. Flags: over-credit risk, vague generality.",
                "boundary_tags": ["over_credit_risk", "vague_generality"],
            },
            {
                "id": "R4",
                "text": (
                    "(A) Freshman: 60 out of 200 Freshmen are in the club, so 60/200 = 0.30. Senior: 100 out of "
                    "200 Seniors are in the club, so 100/200 = 0.50.\n\n"
                    "(B) Since 30% of Freshmen and 50% of Seniors participate in the club, and these conditional "
                    "percentages would be roughly equal if grade level and club participation were independent, "
                    "the large gap between 30% and 50% indicates that the two variables are associated, not "
                    "independent, in this sample."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Second full-credit response with slightly more detailed work shown; useful for confirming grader consistency.",
                "boundary_tags": [],
            },
            {
                "id": "R5",
                "text": (
                    "(A) P(Club Yes | Freshman) = 60/200 = 0.30. P(Freshman | Club Yes) = 60/160 = 0.375.\n\n"
                    "(B) Since these two conditional probabilities are different (0.30 vs. 0.375), grade level "
                    "and club participation are associated."
                ),
                "labels": {"C1": "earned", "C2": "not_earned", "C3": "earned", "C4": "not_earned"},
                "reviewer_note": "C1 is correct, but the second calculation answers a different conditional probability than asked (P(Freshman | Club) instead of P(Club | Senior)), so C2 is not earned. The conclusion in B happens to be correct, but the justification compares two conditional probabilities that are not the correct comparison pair for testing independence between grade level and club participation (comparing P(Club|Freshman) to P(Club|Senior) is the correct test, not comparing P(Club|Freshman) to P(Freshman|Club)). Flags: wrong conditional computed, unsupported reasoning despite correct final conclusion.",
                "boundary_tags": ["wrong_conditional_computed", "correct_conclusion_wrong_reasoning"],
            },
        ],
    },
    {
        "id": "statistics_frq_02",
        "title": "Interpreting Slope and a Residual Plot in a Regression Model",
        "unit": "Unit 2 - Exploring Two-Variable Data",
        "difficulty": "Medium",
        "content_type": "modeling",
        "stem": (
            "A least-squares regression line is fit to predict a car's fuel economy (miles per "
            "gallon, mpg) from its weight (in thousands of pounds): "
            "`predicted mpg = 42.1 - 5.3(weight)`. The residual plot for this model shows a clear "
            "curved (U-shaped) pattern.\n\n"
            "**A.** Interpret the slope of this regression line in context.\n\n"
            "**B.** Explain what the residual plot's curved pattern indicates about the "
            "appropriateness of this linear model, and describe what a researcher should conclude "
            "as a result."
        ),
        "criteria": [
            {"id": "C1", "text": "Interprets the slope in context: for each additional 1,000 pounds of weight, predicted fuel economy decreases by about 5.3 mpg.", "notes": "Must include direction (decrease), magnitude (5.3), units (mpg per 1,000 lbs), and 'predicted'/'on average' language."},
            {"id": "C2", "text": "Does not misinterpret the intercept as a meaningful prediction outside the data's scope, and correctly restricts the slope interpretation to association/prediction rather than causation.", "notes": "This criterion checks for absence of a causal claim ('weight causes lower mpg') or an unsupported extrapolation claim, not a separate calculation."},
            {"id": "C3", "text": "Explains that a curved residual pattern indicates the relationship between weight and mpg is not actually linear, so a linear model is not appropriate for these data.", "notes": "Must connect the curved pattern specifically to linearity, not to some other assumption (e.g., outliers, equal variance) unless linearity is also mentioned."},
            {"id": "C4", "text": "Concludes that the researcher should not use this linear model for prediction (or should consider a different, non-linear model / transformation) because the residual pattern shows the linear model systematically over- or under-predicts at different weight values.", "notes": "Must state a concrete consequence (don't use this model / consider transforming or fitting a different model), not just 'the model has a problem.'"},
        ],
        "responses": [
            {
                "id": "R1",
                "text": (
                    "(A) For each additional 1,000 pounds a car weighs, the model predicts fuel economy "
                    "decreases by about 5.3 mpg, on average.\n\n"
                    "(B) The curved pattern in the residual plot shows that the relationship between weight and "
                    "mpg is not actually linear -- if it were, the residuals would scatter randomly around zero "
                    "with no pattern. Because the linear model systematically over-predicts in some weight ranges "
                    "and under-predicts in others, the researcher should conclude that this linear model is not "
                    "appropriate for these data and should consider a different model, such as a curved "
                    "(nonlinear) fit or a transformation of the variables, rather than using this line for "
                    "prediction."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit response. Slope interpretation includes direction, magnitude, units, and 'predicted/on average' language; residual explanation correctly ties the curve to linearity and gives a concrete next step.",
                "boundary_tags": [],
            },
            {
                "id": "R2",
                "text": (
                    "(A) Weight causes mpg to go down by 5.3 for every unit of weight.\n\n"
                    "(B) The residual plot being curved just means there were a few outlier cars; the linear "
                    "model is still fine to use for prediction."
                ),
                "labels": {"C1": "not_earned", "C2": "not_earned", "C3": "not_earned", "C4": "not_earned"},
                "reviewer_note": "Uses causal language ('weight causes') rather than association/prediction language, and drops the units (per 1,000 lbs) and 'predicted/on average' qualifier from the slope. Then misattributes the curved pattern to outliers rather than nonlinearity, and incorrectly concludes the model is still fine to use. Flags: causal language misuse, misdiagnosed residual pattern, unsupported conclusion.",
                "boundary_tags": ["causal_language_misuse", "unsupported_inference"],
            },
            {
                "id": "R3",
                "text": (
                    "(A) The slope means mpg decreases by 5.3 as weight increases.\n\n"
                    "(B) The curved residual pattern means the linear model isn't appropriate. The researcher "
                    "should try a different model."
                ),
                "labels": {"C1": "not_earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "The slope interpretation is missing the unit of weight (per 1,000 lbs) and the 'predicted/on average' qualifier -- as written it reads as a deterministic per-unit-of-weight statement rather than a per-1,000-lb, on-average prediction, so C1 is not earned even though direction and magnitude are present. Parts about linearity and next steps are both correct, if brief. Flags: over-credit risk if grader treats direction+magnitude alone as sufficient for C1.",
                "boundary_tags": ["over_credit_risk", "units_omitted"],
            },
            {
                "id": "R4",
                "text": (
                    "(A) On average, for every 1,000-pound increase in a car's weight, its predicted fuel "
                    "economy decreases by about 5.3 mpg.\n\n"
                    "(B) A curved pattern in a residual plot means the association between weight and mpg isn't "
                    "linear, so a straight-line model doesn't capture the true relationship well. As a result, "
                    "the researcher shouldn't rely on this linear equation to predict mpg and should instead "
                    "look for a model that better fits the curved pattern, such as fitting a quadratic model or "
                    "transforming one of the variables."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Second full-credit response with slightly different phrasing; confirms grader tolerance for 'straight-line model' as equivalent to 'linear model.'",
                "boundary_tags": [],
            },
            {
                "id": "R5",
                "text": (
                    "(A) For every 1,000 lbs of extra weight, predicted mpg drops by 5.3, on average.\n\n"
                    "(B) The curved residuals mean the model has some error in it, but since R-squared is "
                    "probably still high, the linear model can still be trusted for prediction."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "not_earned", "C4": "not_earned"},
                "reviewer_note": "Slope interpretation is fully correct. But part B never actually says the relationship is nonlinear -- 'has some error in it' is vague -- and then invents an unsupported claim about R-squared being high (no R-squared value was given, and a high R-squared doesn't excuse a clear curved residual pattern anyway). Flags: unsupported inference, vague generality, misconception that R-squared alone validates linearity.",
                "boundary_tags": ["unsupported_inference", "vague_generality", "r_squared_misconception"],
            },
        ],
    },
    {
        "id": "statistics_frq_03",
        "title": "Confidence Interval for Mean Battery Life",
        "unit": "Unit 6 - Inference for Categorical/Quantitative Data (One Sample Means)",
        "difficulty": "Medium",
        "content_type": "inference",
        "stem": (
            "A quality-control engineer takes a random sample of 36 batteries from a large "
            "production run and records their lifetimes. The sample mean is 14.2 hours with a "
            "sample standard deviation of 1.8 hours. Assume the sampling distribution of the "
            "sample mean is approximately normal.\n\n"
            "**A.** Construct a 95% confidence interval for the true mean battery lifetime, "
            "showing the formula, critical value, and calculation.\n\n"
            "**B.** Interpret this confidence interval in context, and state one condition that "
            "should be checked before this interval is considered valid."
        ),
        "criteria": [
            {"id": "C1", "text": "Uses the correct formula (sample mean +/- t* x (s / sqrt(n)), or z* if specified) with correct values substituted: 14.2 +/- t*(1.8/sqrt(36)).", "notes": "Accept t* from a t-distribution with df=35 (approximately 2.03) or a reasonable z* approximation if the response states that choice; the key requirement is correct structure and correct substitution of given values."},
            {"id": "C2", "text": "Computes a numerically correct interval (approximately 13.59 to 14.81 hours, depending on which critical value is used).", "notes": "Accept a small range of correct numeric answers depending on t* vs z* choice, as long as the arithmetic from the response's own formula is internally consistent."},
            {"id": "C3", "text": "Interprets the interval in context: states that we are 95% confident that the true mean lifetime of all batteries in this production run is captured by the calculated interval.", "notes": "Must reference the population parameter (true mean lifetime) and 'confident the interval captures it,' not a claim about individual batteries or about repeated sample means."},
            {"id": "C4", "text": "States a condition that should be checked (random sample, independence/10% condition given a large production run, or approximate normality of the sampling distribution/population) relevant to this scenario.", "notes": "Any one correctly stated and relevant condition is sufficient."},
        ],
        "responses": [
            {
                "id": "R1",
                "text": (
                    "(A) Using x-bar +/- t* (s / sqrt(n)) with x-bar = 14.2, s = 1.8, n = 36, and t* = 2.03 "
                    "(df = 35, 95% confidence): 14.2 +/- 2.03(1.8/sqrt(36)) = 14.2 +/- 2.03(0.30) = "
                    "14.2 +/- 0.609, giving an interval of about (13.59, 14.81) hours.\n\n"
                    "(B) We are 95% confident that the interval (13.59, 14.81) hours captures the true mean "
                    "lifetime of all batteries in this production run. One condition to check is that the sample "
                    "of 36 batteries was randomly selected from the production run (and, since the run is large, "
                    "that 36 is less than 10% of the total batteries produced, satisfying independence)."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit response with correct formula, correct t* and arithmetic, a properly worded confidence-interval interpretation about the true mean, and a relevant condition (random sample / 10% condition).",
                "boundary_tags": [],
            },
            {
                "id": "R2",
                "text": (
                    "(A) 14.2 +/- 1.8/sqrt(36) = 14.2 +/- 0.3, so (13.9, 14.5).\n\n"
                    "(B) We are 95% sure that 95% of all batteries last between 13.9 and 14.5 hours."
                ),
                "labels": {"C1": "not_earned", "C2": "not_earned", "C3": "not_earned", "C4": "not_earned"},
                "reviewer_note": "Omits the critical value entirely (uses just the standard error, not t* times the standard error), so the interval is far too narrow for a 95% confidence level. The interpretation in (B) also commits the classic misinterpretation of a confidence interval as describing where 95% of individual values fall, rather than a statement of confidence about the population mean. No condition is mentioned. Flags: missing critical value, classic CI misinterpretation, condition omitted.",
                "boundary_tags": ["missing_critical_value", "classic_ci_misinterpretation", "condition_omitted"],
            },
            {
                "id": "R3",
                "text": (
                    "(A) 14.2 +/- 2.03(1.8/sqrt(36)) = 14.2 +/- 0.609, so (13.59, 14.81).\n\n"
                    "(B) We are 95% confident the true mean battery life is in this interval."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "not_earned"},
                "reviewer_note": "Formula, substitution, and arithmetic are all correct, and the interpretation correctly references the true mean. However, the response never states any condition that should be checked before trusting the interval (random sample, independence, or normality), which part B explicitly asked for. Flags: incomplete response -- condition omitted despite otherwise full credit on A and the interpretation.",
                "boundary_tags": ["condition_omitted"],
            },
            {
                "id": "R4",
                "text": (
                    "(A) x-bar +/- t*(s/sqrt(n)): 14.2 +/- 2.03(1.8/sqrt(36)) = 14.2 +/- 0.609 = (13.591, 14.809).\n\n"
                    "(B) We can be 95% confident that the interval (13.591, 14.809) hours captures the true mean "
                    "lifetime of batteries from this production run. Before trusting this interval, we should "
                    "check that the sampling distribution of the sample mean is approximately normal, which is "
                    "reasonable to assume here given the problem states it directly, or otherwise would require "
                    "either a large enough sample size or an approximately normal population distribution."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Second full-credit response with more detail on the normality condition specifically.",
                "boundary_tags": [],
            },
            {
                "id": "R5",
                "text": (
                    "(A) 14.2 +/- 2.03(1.8/6) = 14.2 +/- 0.609, so (13.591, 14.809).\n\n"
                    "(B) We are 95% confident the interval captures the average lifetime of these 36 sample "
                    "batteries. We should check that the sample size is large."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "not_earned", "C4": "earned"},
                "reviewer_note": "Calculation is correct (sqrt(36)=6 correctly simplified). However, the interpretation in (B) refers to 'the average lifetime of these 36 sample batteries' rather than the true population mean of all batteries in the production run -- this is a common misinterpretation confusing the sample statistic with the population parameter the interval is meant to estimate. The condition stated ('sample size is large') is vague but plausibly acceptable as a stand-in for a normality/CLT condition. Flags: sample-vs-population confusion in interpretation.",
                "boundary_tags": ["sample_vs_population_confusion"],
            },
        ],
    },
    {
        "id": "statistics_frq_04",
        "title": "One-Sample z-Test for a Claimed Defect Rate",
        "unit": "Unit 6 - Inference for Categorical Data (One Sample Proportions)",
        "difficulty": "Medium",
        "content_type": "inference",
        "stem": (
            "A factory claims that no more than 4% of its products are defective. A quality "
            "inspector takes a random sample of 250 products and finds 16 defective, "
            "a sample proportion of 0.064. The inspector wants to test whether the true defect "
            "rate is actually greater than 4%.\n\n"
            "**A.** State the null and alternative hypotheses in terms of the true population "
            "proportion of defective products, and verify that the conditions for this "
            "significance test are met.\n\n"
            "**B.** Given that this test produces a p-value of 0.006, state a conclusion in "
            "context at the alpha = 0.05 significance level."
        ),
        "criteria": [
            {"id": "C1", "text": "States H0: p = 0.04 and Ha: p > 0.04, where p is the true proportion of defective products, using a one-sided (greater than) alternative.", "notes": "Must define p in context and use a one-sided alternative matching 'greater than 4%.'"},
            {"id": "C2", "text": "Verifies conditions: random sample (stated in the problem), and large counts using the null proportion (n*p0 = 250*0.04 = 10 and n*(1-p0) = 250*0.96 = 240, both >= 10), plus independence/10% condition (250 products is less than 10% of all products from a large factory run).", "notes": "Must use the null value p0=0.04 for the large-counts check, not the sample proportion 0.064 -- this is the key boundary-sensitive point."},
            {"id": "C3", "text": "States that because the p-value (0.006) is less than alpha (0.05), the result is statistically significant.", "notes": "Must explicitly compare p-value to alpha."},
            {"id": "C4", "text": "Concludes in context that there is convincing evidence that the true proportion of defective products is greater than 4% (rejecting the factory's claim).", "notes": "Must state the conclusion in context (about the defect rate), not just 'reject the null hypothesis' with no context."},
        ],
        "responses": [
            {
                "id": "R1",
                "text": (
                    "(A) H0: p = 0.04, Ha: p > 0.04, where p is the true proportion of defective products from "
                    "this factory. Conditions: the sample was randomly selected (stated). Using the null "
                    "proportion, n*p0 = 250(0.04) = 10 and n*(1-p0) = 250(0.96) = 240, both at least 10, so the "
                    "large counts condition is met. Also, 250 products is almost certainly less than 10% of all "
                    "products the factory produces, so independence is reasonable.\n\n"
                    "(B) Since the p-value (0.006) is less than alpha (0.05), the result is statistically "
                    "significant. There is convincing evidence that the true proportion of defective products "
                    "from this factory is greater than 4%, so we reject the factory's claim."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit response. Hypotheses correctly defined in context, large-counts condition correctly checked using the null proportion (not the sample proportion), and a properly contextualized conclusion.",
                "boundary_tags": [],
            },
            {
                "id": "R2",
                "text": (
                    "(A) H0: p = 0.064, Ha: p != 0.04. Conditions: n*p-hat = 250(0.064) = 16 and "
                    "n(1-p-hat) = 234, both >= 10, so conditions are met.\n\n"
                    "(B) The p-value is small, so we reject H0 and conclude the defect rate is different from "
                    "4%."
                ),
                "labels": {"C1": "not_earned", "C2": "not_earned", "C3": "earned", "C4": "not_earned"},
                "reviewer_note": "H0 uses the sample proportion (0.064) instead of the claimed value (0.04), and the alternative is two-sided when the scenario specifically asks about greater than 4%. The large-counts check then also uses the sample proportion p-hat instead of the null proportion p0 -- this is the classic boundary error the item is designed to catch. The conclusion vaguely says 'different from 4%' rather than the specific 'greater than' direction and context. Flags: null hypothesis value error, wrong-proportion-used-in-conditions error, direction lost in conclusion.",
                "boundary_tags": ["null_value_error", "wrong_proportion_used_in_conditions", "direction_lost_in_conclusion"],
            },
            {
                "id": "R3",
                "text": (
                    "(A) H0: p = 0.04, Ha: p > 0.04. Conditions are met since the sample was random and large "
                    "enough.\n\n"
                    "(B) Since 0.006 < 0.05, we reject H0. There is convincing evidence the defect rate is "
                    "greater than 4%."
                ),
                "labels": {"C1": "earned", "C2": "not_earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Hypotheses and conclusion are both correct and well-contextualized. However, the condition check in (A) is only asserted ('random and large enough') without showing the actual np0 and n(1-p0) calculations, so the large-counts verification the criterion requires is not demonstrated. Flags: over-credit risk if grader accepts an asserted-but-unshown condition check.",
                "boundary_tags": ["over_credit_risk", "condition_asserted_not_shown"],
            },
            {
                "id": "R4",
                "text": (
                    "(A) H0: p = 0.04 (true proportion of defective products equals 4%), Ha: p > 0.04 (true "
                    "proportion is greater than 4%). Random: stated in the problem. Large counts: "
                    "n*p0 = 250(0.04) = 10 >= 10 and n*(1-p0) = 250(0.96) = 240 >= 10, so this condition is met. "
                    "Independence: 250 sampled products is reasonably less than 10% of the factory's total "
                    "output.\n\n"
                    "(B) Because the p-value of 0.006 is less than alpha = 0.05, we have convincing evidence "
                    "that the true proportion of defective products exceeds 4%, contradicting the factory's claim."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Second full-credit response with more explicit condition labeling; useful for confirming grader consistency across differently-formatted but equally complete answers.",
                "boundary_tags": [],
            },
            {
                "id": "R5",
                "text": (
                    "(A) H0: p = 0.04, Ha: p > 0.04. Conditions: np0 = 10 and n(1-p0) = 240, both >= 10, "
                    "so we can use a normal approximation.\n\n"
                    "(B) Since the p-value is less than 0.05, the sample proportion of 0.064 is statistically "
                    "significantly different from 0.04, so the factory's claim is false."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "not_earned"},
                "reviewer_note": "Hypotheses and condition check are both fully correct. But the conclusion states the factory's claim is simply 'false' rather than stating there is convincing evidence the true defect rate is greater than 4% -- inference conclusions should be framed as evidence for/against a claim about the parameter, not a flat true/false verdict, and it drops the 'greater than' directional framing established in the hypotheses. Flags: overstated certainty, directional framing lost in conclusion.",
                "boundary_tags": ["overstated_certainty", "direction_lost_in_conclusion"],
            },
        ],
    },
    {
        "id": "statistics_frq_05",
        "title": "Independence vs. Mutually Exclusive Events in a Dice/Card Scenario",
        "unit": "Unit 4 - Probability, Random Variables, and Probability Distributions",
        "difficulty": "Medium",
        "content_type": "reasoning",
        "stem": (
            "Let event A be 'drawing a King' from a standard 52-card deck, and event B be "
            "'drawing a Heart.' A student claims: 'Since a King of Hearts exists, A and B cannot "
            "be independent, because independent events must be mutually exclusive.'\n\n"
            "**A.** Explain what it means for two events to be independent, and what it means "
            "for two events to be mutually exclusive, and state whether these are the same "
            "concept.\n\n"
            "**B.** Determine whether events A and B are independent by comparing P(A), P(B), "
            "and P(A and B), and explain what this shows about the student's claim."
        ),
        "criteria": [
            {"id": "C1", "text": "Correctly defines independence: two events are independent if the occurrence of one does not change the probability of the other (P(A|B) = P(A), equivalently P(A and B) = P(A) x P(B)).", "notes": "Must reference the conditional-probability-unchanged idea or the multiplication rule, not just 'they don't affect each other' with no further detail."},
            {"id": "C2", "text": "Correctly defines mutually exclusive: two events are mutually exclusive if they cannot both occur at the same time (P(A and B) = 0), and states that independence and mutual exclusivity are different concepts (in fact, two mutually exclusive events with nonzero probability are never independent).", "notes": "Must explicitly state these are different concepts, not treat them as synonyms."},
            {"id": "C3", "text": "Correctly computes P(A) = 4/52, P(B) = 13/52, and P(A and B) = 1/52 (the King of Hearts), and checks P(A) x P(B) = (4/52)(13/52) = 52/2704 = 1/52, which equals P(A and B).", "notes": "Numeric values must be correct and the comparison must be shown, not just asserted."},
            {"id": "C4", "text": "Concludes that since P(A and B) = P(A) x P(B), events A and B are in fact independent, which directly contradicts the student's claim -- the existence of the King of Hearts (a nonzero intersection) is exactly why they are not mutually exclusive, but that has no bearing on whether they are independent.", "notes": "Must explicitly connect the numeric check to refuting the student's claim, not just state 'they are independent' without addressing the claim."},
        ],
        "responses": [
            {
                "id": "R1",
                "text": (
                    "(A) Two events are independent if knowing one occurred does not change the probability of "
                    "the other -- that is, P(A|B) = P(A), which is equivalent to P(A and B) = P(A) x P(B). Two "
                    "events are mutually exclusive if they cannot both happen at the same time, meaning "
                    "P(A and B) = 0. These are different concepts: mutually exclusive events with nonzero "
                    "individual probabilities are actually never independent, and independent events are usually "
                    "not mutually exclusive (since both can occur together with the expected joint probability).\n\n"
                    "(B) P(A) = 4/52 (Kings), P(B) = 13/52 (Hearts), and P(A and B) = 1/52 (the King of Hearts). "
                    "Checking P(A) x P(B) = (4/52)(13/52) = 1/52, which equals P(A and B). Since this equality "
                    "holds, A and B are independent. This directly contradicts the student's claim: the King of "
                    "Hearts existing is exactly why A and B are not mutually exclusive, but that has nothing to "
                    "do with independence -- in fact these two events are independent."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit response with correct definitions distinguishing the two concepts, correct probability calculations, and a direct refutation of the student's claim using the numeric result.",
                "boundary_tags": [],
            },
            {
                "id": "R2",
                "text": (
                    "(A) Independent and mutually exclusive mean the same thing -- both describe events that "
                    "don't overlap.\n\n"
                    "(B) Since a King of Hearts exists, A and B overlap, so they are not independent. The "
                    "student is correct."
                ),
                "labels": {"C1": "not_earned", "C2": "not_earned", "C3": "not_earned", "C4": "not_earned"},
                "reviewer_note": "Repeats exactly the misconception the item is designed to test -- claims independence and mutual exclusivity are the same concept, and endorses the student's incorrect claim without ever computing P(A), P(B), or P(A and B) to check. Flags: core misconception endorsed, no calculation shown, unsupported conclusion.",
                "boundary_tags": ["independence_mutual_exclusivity_conflation", "unsupported_inference"],
            },
            {
                "id": "R3",
                "text": (
                    "(A) Independent means one event doesn't affect the other's probability. Mutually "
                    "exclusive means they can't both happen. These are different things.\n\n"
                    "(B) P(A) x P(B) = 1/52, which is the same as P(A and B) = 1/52, so they are independent. "
                    "The student is wrong."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "not_earned"},
                "reviewer_note": "Definitions and calculation are correct, and the final claim ('the student is wrong') is the right conclusion, but the response never explains *why* the student is wrong -- it doesn't connect the King-of-Hearts intersection to mutual exclusivity being false while independence still holds, which is the actual point of confusion being tested. Flags: over-credit risk, conclusion stated without connecting reasoning back to the specific claim.",
                "boundary_tags": ["over_credit_risk", "justification_restates_prompt"],
            },
            {
                "id": "R4",
                "text": (
                    "(A) Two events are independent when the outcome of one has no effect on the probability "
                    "of the other occurring. Two events are mutually exclusive when they cannot occur together. "
                    "These are not the same idea -- mutually exclusive events (with nonzero probability) are "
                    "always dependent, since knowing one happened makes the other impossible.\n\n"
                    "(B) P(A) = 4/52, P(B) = 13/52, P(A and B) = 1/52. Since P(A) x P(B) = (4/52)(13/52) = "
                    "1/52 = P(A and B), the events are independent. The student's claim is incorrect: the King of "
                    "Hearts shows that A and B are not mutually exclusive, but mutual exclusivity has no bearing "
                    "on independence, and the calculation shows these particular events actually are independent."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Second full-credit response with an additional correct detail (mutually exclusive nonzero-probability events are always dependent); useful for confirming the grader accepts this extra correct elaboration without penalizing length.",
                "boundary_tags": [],
            },
            {
                "id": "R5",
                "text": (
                    "(A) Independent means the events are unrelated. Mutually exclusive means they overlap. "
                    "They're different.\n\n"
                    "(B) P(A and B) = 1/52, and P(A) times P(B) also equals 1/52, so they're independent, "
                    "meaning the student is wrong."
                ),
                "labels": {"C1": "not_earned", "C2": "not_earned", "C3": "earned", "C4": "not_earned"},
                "reviewer_note": "The calculation in (B) is correct and the final verdict happens to be right, but both definitions in (A) are stated backwards or vaguely: 'independent means unrelated' is too vague to demonstrate the conditional-probability concept, and 'mutually exclusive means they overlap' is the opposite of the correct definition (mutually exclusive events do NOT overlap). Because the definitions are wrong, the reasoning connecting the calculation to refuting the claim is not actually sound even though the numeric check and final verdict are correct. Flags: definition reversal error, correct answer via unsound reasoning.",
                "boundary_tags": ["definition_reversal_error", "correct_conclusion_wrong_reasoning"],
            },
        ],
    },
    {
        "id": "statistics_frq_06",
        "title": "Effect of Sample Size on the Standard Error of the Sample Mean",
        "unit": "Unit 5 - Sampling Distributions",
        "difficulty": "Medium",
        "content_type": "modeling",
        "stem": (
            "A population of adult resting heart rates has mean 72 beats per minute and standard "
            "deviation 9 beats per minute. Researchers plan to take a random sample and compute "
            "the sample mean heart rate.\n\n"
            "**A.** Describe the shape, center, and spread of the sampling distribution of the "
            "sample mean if a sample size of n = 9 is used, versus a sample size of n = 100. "
            "Assume the population distribution is approximately normal.\n\n"
            "**B.** Explain why increasing the sample size from 9 to 100 changes the spread of "
            "the sampling distribution but does not change its center, and explain the practical "
            "consequence for how precisely the sample mean estimates the population mean."
        ),
        "criteria": [
            {"id": "C1", "text": "States that both sampling distributions are approximately normal in shape (since the population is approximately normal, the sampling distribution of the sample mean is normal for any sample size), and both are centered at the population mean, 72 bpm.", "notes": "Must state shape (normal) and center (72) for both sample sizes."},
            {"id": "C2", "text": "Correctly calculates the standard error for each sample size: for n=9, SE = 9/sqrt(9) = 3 bpm; for n=100, SE = 9/sqrt(100) = 0.9 bpm, and states that the n=100 sampling distribution has a smaller spread (less variability) than the n=9 sampling distribution.", "notes": "Both SE values must be numerically correct and compared."},
            {"id": "C3", "text": "Explains that the center of the sampling distribution (population mean) does not depend on sample size -- the sample mean is an unbiased estimator of the population mean regardless of n -- while the spread (standard error) decreases as sample size increases because dividing by a larger sqrt(n) reduces variability among sample means.", "notes": "Must explain both halves: why center is unaffected and why spread decreases, tied to the standard error formula."},
            {"id": "C4", "text": "Explains the practical consequence: with the larger sample size (n=100), the sample mean is likely to be closer to the true population mean (less variable from sample to sample), making it a more precise estimator, whereas with n=9 individual sample means could vary more widely from the true population mean.", "notes": "Must state precision/estimation-quality consequence, not just repeat the standard error values."},
        ],
        "responses": [
            {
                "id": "R1",
                "text": (
                    "(A) For n=9, the sampling distribution of the sample mean is approximately normal, "
                    "centered at 72 bpm, with standard error 9/sqrt(9) = 3 bpm. For n=100, the sampling "
                    "distribution is also approximately normal, still centered at 72 bpm, but with a much "
                    "smaller standard error of 9/sqrt(100) = 0.9 bpm.\n\n"
                    "(B) The center of the sampling distribution doesn't change with sample size because the "
                    "sample mean is an unbiased estimator of the population mean no matter how large the "
                    "sample is -- on average, sample means from either sample size center on 72. The spread "
                    "decreases as sample size increases because the standard error formula divides the "
                    "population standard deviation by sqrt(n); a larger n produces a larger denominator and "
                    "therefore a smaller standard error. Practically, this means that with n=100, sample means "
                    "will tend to be much closer to the true population mean of 72 bpm from sample to sample, "
                    "making it a more precise estimate than with the smaller sample of n=9, where sample means "
                    "could vary more widely around 72."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit response with correct shape/center/spread for both sample sizes, a correct explanation tied to the standard error formula, and a clear precision consequence.",
                "boundary_tags": [],
            },
            {
                "id": "R2",
                "text": (
                    "(A) For n=9, the distribution is skewed with mean around 72 and spread of 9. For n=100, "
                    "the distribution becomes normal with a mean higher than 72 and a spread of 9 also.\n\n"
                    "(B) Bigger samples make the distribution more normal and shift the mean closer to the true "
                    "average, but the spread stays the same because the population standard deviation doesn't "
                    "change."
                ),
                "labels": {"C1": "not_earned", "C2": "not_earned", "C3": "not_earned", "C4": "not_earned"},
                "reviewer_note": "Incorrectly claims the n=9 sampling distribution is skewed (it should be approximately normal since the population itself is approximately normal) and that the mean shifts with n=100 (the center never changes -- it stays at the population mean regardless of n). Also uses the population standard deviation (9) as the standard error for both sample sizes instead of dividing by sqrt(n), and claims spread doesn't change, which is the opposite of the correct relationship. Flags: shape misconception, center-shifts-with-n misconception, standard-error-formula omitted entirely.",
                "boundary_tags": ["shape_misconception", "center_shifts_with_n_misconception", "standard_error_formula_omitted"],
            },
            {
                "id": "R3",
                "text": (
                    "(A) Both are approximately normal, centered at 72. For n=9, spread is 3; for n=100, "
                    "spread is 0.9.\n\n"
                    "(B) The center stays the same, but spread decreases with a bigger sample. This means the "
                    "estimate is better with more data."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "not_earned", "C4": "earned"},
                "reviewer_note": "Shape/center/spread values in (A) are all correct, and the practical-precision consequence in (B) is stated (though briefly). However, (B) never explains *why* the center is unaffected (unbiasedness) or *why* the spread decreases (the sqrt(n) relationship in the standard error formula) -- it just restates that these things happen without the underlying mechanism the criterion asks for. Flags: over-credit risk, mechanism omitted despite correct numeric values.",
                "boundary_tags": ["over_credit_risk", "mechanism_omitted"],
            },
            {
                "id": "R4",
                "text": (
                    "(A) For n=9, the sampling distribution is approximately normal with mean 72 bpm and "
                    "standard error 9/sqrt(9) = 3 bpm. For n=100, it is also approximately normal with mean "
                    "72 bpm and standard error 9/sqrt(100) = 0.9 bpm -- much less spread out.\n\n"
                    "(B) The center is unaffected by sample size because the sample mean is unbiased regardless "
                    "of n; averaging more or fewer values doesn't systematically push the average away from 72. "
                    "The spread shrinks as n grows because the standard error formula (population SD divided by "
                    "the square root of n) has n in the denominator under a square root, so a bigger sample makes "
                    "the denominator bigger and the standard error smaller. Practically, this means sample means "
                    "computed from n=100 will cluster much more tightly around 72 than sample means computed "
                    "from n=9, so the n=100 sample mean is a more precise, reliable estimate of the true "
                    "population mean."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Second full-credit response with more explicit mechanism detail; useful for confirming grader consistency on the mechanism-explanation requirement in C3.",
                "boundary_tags": [],
            },
            {
                "id": "R5",
                "text": (
                    "(A) Both distributions are approximately normal and centered at 72 bpm. Standard errors "
                    "are 3 and 0.9 respectively.\n\n"
                    "(B) The spread decreases with sample size because you're including more people, which "
                    "makes outliers matter less and less. The mean stays the same because averages don't really "
                    "change with sample size."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "not_earned", "C4": "not_earned"},
                "reviewer_note": "Shape/center/spread numbers are all correct. But the explanation in (B) never invokes the standard-error formula (SD/sqrt(n)) -- 'outliers matter less' is an informal and incomplete mechanism, and 'averages don't really change with sample size' asserts the conclusion without explaining unbiasedness. Also never states the practical precision consequence for estimating the population mean. Flags: mechanism incomplete/informal, practical consequence omitted.",
                "boundary_tags": ["mechanism_omitted", "vague_generality"],
            },
        ],
    },
    {
        "id": "statistics_frq_07",
        "title": "Comparing Two Distributions of Commute Times from Summary Statistics",
        "unit": "Unit 1 - Exploring One-Variable Data",
        "difficulty": "Medium",
        "content_type": "interpretation",
        "stem": (
            "Two groups of employees report their one-way commute times in minutes. "
            "Group A: mean = 28, median = 24, standard deviation = 9, IQR = 8. "
            "Group B: mean = 30, median = 30, standard deviation = 6, IQR = 9.\n\n"
            "**A.** Using the relationship between the mean and median for each group, describe "
            "the likely shape of each group's distribution.\n\n"
            "**B.** Compare the two groups' commute times in terms of center and spread, and "
            "state which summary statistics (mean/median, standard deviation/IQR) are more "
            "appropriate to report for each group, with justification."
        ),
        "criteria": [
            {"id": "C1", "text": "States that Group A's distribution is likely right-skewed, because the mean (28) is noticeably greater than the median (24), which typically happens when a few high commute-time values pull the mean up.", "notes": "Must reference the mean-greater-than-median pattern specifically for Group A."},
            {"id": "C2", "text": "States that Group B's distribution is likely roughly symmetric, because the mean (30) and median (30) are equal (or nearly equal).", "notes": "Must reference the mean-approximately-equal-to-median pattern specifically for Group B."},
            {"id": "C3", "text": "Compares center and spread appropriately: e.g., using medians, Group B (30) has a somewhat longer typical commute than Group A (24); using IQR, Group B (9) has slightly more spread in the middle 50% than Group A (8).", "notes": "Must use the median/IQR (not mean/SD) as the primary center/spread comparison for Group A, since it is skewed; comparing using Group B's mean/median (which are close) is acceptable for Group B."},
            {"id": "C4", "text": "Justifies that median and IQR are the more appropriate summary statistics for Group A because it is skewed (median/IQR are resistant to the skew and to potential outliers pulling the mean and standard deviation), while mean and standard deviation are reasonably appropriate for Group B since it is roughly symmetric.", "notes": "Must connect the skew/symmetry conclusions from A to the choice of appropriate statistics -- this is the key reasoning link the item tests."},
        ],
        "responses": [
            {
                "id": "R1",
                "text": (
                    "(A) Group A is likely right-skewed, since its mean (28) is noticeably higher than its "
                    "median (24) -- this pattern typically occurs when a few unusually long commute times pull "
                    "the mean upward relative to the median. Group B is likely roughly symmetric, since its mean "
                    "(30) and median (30) are equal.\n\n"
                    "(B) Comparing centers using medians (since Group A is skewed): Group B's typical commute "
                    "(median 30) is somewhat longer than Group A's (median 24). Comparing spread using IQR: "
                    "Group B (IQR 9) has slightly more spread in the middle 50% of its data than Group A (IQR 8). "
                    "Median and IQR are the more appropriate statistics to report for Group A, because its "
                    "distribution is skewed and these measures are resistant to the skew and to any outliers "
                    "that may be pulling its mean and standard deviation. For Group B, since its distribution is "
                    "roughly symmetric, mean and standard deviation are also reasonably appropriate to report."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit response with correct skew/symmetry conclusions, an appropriate median/IQR-based comparison for the skewed group, and correct justification connecting shape to statistic choice.",
                "boundary_tags": [],
            },
            {
                "id": "R2",
                "text": (
                    "(A) Group A is left-skewed because the mean is less than the median. Group B is "
                    "right-skewed because the mean and median are different.\n\n"
                    "(B) Group A has a longer commute on average (mean 28 vs 30... wait, Group B's mean is "
                    "higher, so Group B is longer). We should use the mean and standard deviation for both "
                    "groups since those are the standard statistics."
                ),
                "labels": {"C1": "not_earned", "C2": "not_earned", "C3": "not_earned", "C4": "not_earned"},
                "reviewer_note": "Gets the skew direction backwards for Group A (mean 28 > median 24 means right-skewed, not left-skewed, and the response also has the mean/median comparison backwards) and incorrectly calls Group B skewed despite mean=median=30 indicating symmetry. The comparison in (B) is confused and self-contradictory, and the recommendation to use mean/SD 'for both groups since those are standard' ignores the skew in Group A entirely, which is exactly the case where mean/SD are not resistant and median/IQR are preferred. Flags: skew direction reversed, symmetry misclassified, recommendation ignores skew.",
                "boundary_tags": ["skew_direction_reversed", "recommendation_ignores_skew"],
            },
            {
                "id": "R3",
                "text": (
                    "(A) Group A is right-skewed since mean > median. Group B is symmetric since mean = "
                    "median.\n\n"
                    "(B) Group B has a longer commute and about the same spread. Median and IQR should be used "
                    "for Group A since it's skewed."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "not_earned", "C4": "earned"},
                "reviewer_note": "Skew/symmetry conclusions and the statistic-choice justification are both correct. However, the center/spread comparison in (B) is vague and slightly inaccurate -- 'about the same spread' glosses over the actual IQR values (8 vs 9) rather than stating and comparing them, and doesn't specify which center measure (median) is being used for the comparison. Flags: over-credit risk, comparison lacks the actual numeric values needed to demonstrate the correct approach.",
                "boundary_tags": ["over_credit_risk", "vague_generality"],
            },
            {
                "id": "R4",
                "text": (
                    "(A) Since Group A's mean (28) is greater than its median (24), Group A's distribution is "
                    "likely right-skewed. Since Group B's mean (30) equals its median (30), Group B's "
                    "distribution is likely roughly symmetric.\n\n"
                    "(B) Using medians, Group B's typical commute (30 minutes) is longer than Group A's "
                    "(24 minutes). Using IQR, Group B's middle 50% (IQR = 9) is slightly more spread out than "
                    "Group A's (IQR = 8). Because Group A is skewed, median and IQR are more appropriate for it, "
                    "since they resist being pulled by the skew or outliers the way mean and standard deviation "
                    "would be; for Group B, since it's roughly symmetric, mean and standard deviation are "
                    "equally appropriate."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Second full-credit response, near-equivalent to R1 with slightly different ordering; confirms grader consistency.",
                "boundary_tags": [],
            },
            {
                "id": "R5",
                "text": (
                    "(A) Group A is right-skewed (mean > median). Group B is symmetric (mean = median).\n\n"
                    "(B) Group B has a longer typical commute (mean 30 vs mean 28) and less spread (SD 6 vs "
                    "SD 9). We should use mean and standard deviation for both groups because that's what most "
                    "statistics classes use by default."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "not_earned", "C4": "not_earned"},
                "reviewer_note": "Skew/symmetry conclusions in (A) are correct. But (B) uses mean and standard deviation to compare Group A even after correctly identifying it as skewed in (A) -- comparing means/SD for a skewed distribution is exactly the inappropriate choice the item is testing for, and the justification given ('what most classes use by default') is not a statistical reason and directly contradicts the skew finding from part A. Flags: recommendation ignores skew, unsupported justification.",
                "boundary_tags": ["recommendation_ignores_skew", "unsupported_inference"],
            },
        ],
    },
    {
        "id": "statistics_frq_08",
        "title": "Two-Sample t-Test for Difference in Mean Plant Growth",
        "unit": "Unit 6 - Inference for Categorical/Quantitative Data (Two Samples)",
        "difficulty": "Hard",
        "content_type": "inference",
        "stem": (
            "A researcher randomly assigns 40 seedlings to two groups of 20: one group receives "
            "a new fertilizer, and the other receives standard fertilizer. After 6 weeks, the new "
            "fertilizer group has a mean height of 34.2 cm (s = 5.1 cm) and the standard "
            "fertilizer group has a mean height of 30.8 cm (s = 4.6 cm). The researcher wants to "
            "test whether the new fertilizer produces greater mean growth.\n\n"
            "**A.** State appropriate hypotheses for a two-sample t-test in this context, and "
            "identify the design feature that supports treating this as a valid experiment for "
            "making a cause-and-effect conclusion.\n\n"
            "**B.** The resulting p-value is 0.031. State a conclusion at alpha = 0.05, "
            "explicitly addressing whether a cause-and-effect conclusion is justified."
        ),
        "criteria": [
            {"id": "C1", "text": "States H0: mu_new - mu_standard = 0 (or mu_new = mu_standard) and Ha: mu_new - mu_standard > 0 (or mu_new > mu_standard), where mu refers to true mean seedling height for each fertilizer group.", "notes": "Must define parameters in context and use a one-sided alternative matching 'greater mean growth.'"},
            {"id": "C2", "text": "Identifies random assignment of seedlings to treatment groups as the design feature supporting a cause-and-effect conclusion.", "notes": "Must specifically name random assignment (not random sampling, which supports generalizability, not causation)."},
            {"id": "C3", "text": "States that because the p-value (0.031) is less than alpha (0.05), the result is statistically significant, so there is convincing evidence that the true mean height for the new-fertilizer population is greater than for the standard-fertilizer population.", "notes": "Must state the conclusion in context with correct direction."},
            {"id": "C4", "text": "States that because this was a randomized experiment (not an observational study), a cause-and-effect conclusion is justified: the new fertilizer causes greater mean seedling growth, assuming other conditions for inference are met.", "notes": "Must explicitly connect random assignment to the causal claim being justified, not just restate 'it's significant.'"},
        ],
        "responses": [
            {
                "id": "R1",
                "text": (
                    "(A) H0: mu_new - mu_standard = 0; Ha: mu_new - mu_standard > 0, where mu_new and "
                    "mu_standard are the true mean heights of seedlings under each fertilizer treatment. "
                    "Random assignment of seedlings to the two fertilizer groups is the design feature that "
                    "supports a cause-and-effect conclusion, since it balances out other lurking variables "
                    "between the groups.\n\n"
                    "(B) Because the p-value (0.031) is less than alpha (0.05), the result is statistically "
                    "significant: there is convincing evidence that the true mean height of seedlings given the "
                    "new fertilizer is greater than that of seedlings given the standard fertilizer. Because "
                    "seedlings were randomly assigned to treatment groups (a randomized experiment), this "
                    "significant difference can be attributed to the fertilizer itself, so a cause-and-effect "
                    "conclusion is justified: the new fertilizer causes greater mean growth."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit response with correctly defined hypotheses and parameters, correctly identified design feature (random assignment, not random sampling), a properly directional and contextualized conclusion, and an explicit causal claim tied to the experimental design.",
                "boundary_tags": [],
            },
            {
                "id": "R2",
                "text": (
                    "(A) H0: x-bar1 = x-bar2, Ha: x-bar1 != x-bar2. The design feature is that the seedlings "
                    "were randomly sampled from all seedlings, which supports a cause-and-effect conclusion.\n\n"
                    "(B) Since p < 0.05, the fertilizers are different, and since the sample was random, we can "
                    "say the fertilizer caused the difference."
                ),
                "labels": {"C1": "not_earned", "C2": "not_earned", "C3": "not_earned", "C4": "not_earned"},
                "reviewer_note": "Hypotheses are written in terms of sample statistics (x-bar) rather than population parameters (mu), and use a two-sided alternative rather than the one-sided 'greater growth' direction specified. The design feature identified is random *sampling*, which supports generalizability to a population, not random *assignment*, which is what actually supports causal claims -- this is the key concept confusion the item targets. The conclusion is vague ('the fertilizers are different') rather than directional and in context. Flags: parameter notation error, direction lost, random-sampling/random-assignment conflation.",
                "boundary_tags": ["random_sampling_random_assignment_conflation", "parameter_notation_error", "direction_lost_in_conclusion"],
            },
            {
                "id": "R3",
                "text": (
                    "(A) H0: mu_new = mu_standard, Ha: mu_new > mu_standard. Random assignment supports a "
                    "cause-and-effect conclusion.\n\n"
                    "(B) Since p = 0.031 < 0.05, we reject H0. The new fertilizer works better."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "not_earned", "C4": "not_earned"},
                "reviewer_note": "Hypotheses and design-feature identification are both correct. But the conclusion in (B) is under-specified: 'the new fertilizer works better' doesn't reference the population parameters (true mean heights) or state the result is in terms of convincing evidence, and the response never explicitly revisits the cause-and-effect question that part B specifically asks the response to address, even though C2 correctly named random assignment in part A. Flags: over-credit risk, conclusion lacks parameter context, causal claim not explicitly revisited in B as asked.",
                "boundary_tags": ["over_credit_risk", "causal_claim_not_revisited"],
            },
            {
                "id": "R4",
                "text": (
                    "(A) H0: mu_new - mu_standard = 0, Ha: mu_new - mu_standard > 0, where mu_new and "
                    "mu_standard represent the true mean seedling heights under the new and standard "
                    "fertilizers. Since seedlings were randomly assigned to the two treatment groups (rather "
                    "than the groups being pre-existing or self-selected), this random assignment supports "
                    "making a cause-and-effect conclusion.\n\n"
                    "(B) Because p = 0.031 < alpha = 0.05, there is convincing evidence that the true mean "
                    "height of seedlings receiving the new fertilizer is greater than that of seedlings "
                    "receiving the standard fertilizer. Because this was a randomized experiment, we can "
                    "conclude that the new fertilizer causes this increase in mean growth, assuming the other "
                    "conditions for inference (random assignment, independence, and approximate normality of the "
                    "sampling distribution) are satisfied."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Second full-credit response with more explicit qualification about the other inference conditions; useful for confirming the grader doesn't require exactly R1's phrasing.",
                "boundary_tags": [],
            },
            {
                "id": "R5",
                "text": (
                    "(A) H0: mu_new = mu_standard, Ha: mu_new > mu_standard. Random assignment is the design "
                    "feature that supports cause and effect.\n\n"
                    "(B) The p-value is significant, so the new fertilizer definitely causes better growth in "
                    "all seedlings everywhere, not just this sample."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "not_earned"},
                "reviewer_note": "Hypotheses, design feature, and significance conclusion are all correct up through stating convincing evidence exists. But the causal claim in (B) overreaches by extending the conclusion to 'all seedlings everywhere,' which is a generalizability claim -- generalizing beyond the sampled population requires random *sampling*, which was not established here (only random assignment was), so this overstates what the experiment supports. Flags: overstated generalizability, random-assignment/random-sampling scope confusion.",
                "boundary_tags": ["overstated_generalizability", "random_sampling_random_assignment_conflation"],
            },
        ],
    },
    {
        "id": "statistics_frq_09",
        "title": "Confounding Variable in an Observational Study of Screen Time and Sleep",
        "unit": "Unit 3 - Collecting Data",
        "difficulty": "Medium",
        "content_type": "reasoning",
        "stem": (
            "An observational study finds that teenagers who report more daily screen time also "
            "report fewer hours of sleep per night. A news article concludes: 'Screen time causes "
            "reduced sleep in teenagers.' A student points out that teenagers with more "
            "after-school jobs and extracurricular commitments tend to have both more screen time "
            "(used for quick breaks between activities) and less sleep (due to a busier schedule "
            "overall).\n\n"
            "**A.** Explain why this is an observational study rather than an experiment, and "
            "explain why that distinction matters for the news article's causal claim.\n\n"
            "**B.** Explain how 'busyness from jobs and extracurriculars' could be a confounding "
            "variable in this study, and explain what the researcher would need to do to "
            "establish a cause-and-effect relationship instead."
        ),
        "criteria": [
            {"id": "C1", "text": "Explains that this is an observational study because the researcher measured screen time and sleep as they naturally occurred, without randomly assigning teenagers to different screen-time levels.", "notes": "Must reference the lack of random assignment/treatment imposition, not just 'they just observed data.'"},
            {"id": "C2", "text": "Explains that this distinction matters because observational studies can only establish association/correlation, not causation, since other variables may differ systematically between groups (unlike a randomized experiment, which balances lurking variables).", "notes": "Must connect observational design to the causation-vs-association limitation directly."},
            {"id": "C3", "text": "Explains that busyness is a confounding variable because it is associated with both the explanatory variable (screen time) and the response variable (sleep), and its effect on sleep cannot be separated from the effect of screen time on sleep using this data.", "notes": "Must state both associations (with screen time AND with sleep) and the inability to separate their effects, not just 'it's related to both.'"},
            {"id": "C4", "text": "States that to establish a cause-and-effect relationship, the researcher would need to conduct a randomized experiment, randomly assigning teenagers to different screen-time conditions (levels), which would balance out busyness and other lurking variables between groups on average.", "notes": "Must specifically name random assignment to treatment groups as the fix, not just 'do more research' or 'control for busyness statistically' without mentioning randomization."},
        ],
        "responses": [
            {
                "id": "R1",
                "text": (
                    "(A) This is an observational study because the researcher simply measured teenagers' "
                    "existing screen time and sleep habits without randomly assigning any teenager to a "
                    "particular screen-time level -- the teenagers' screen time was already whatever it was. "
                    "This distinction matters because observational studies can only show that two variables "
                    "are associated; they cannot establish that one causes the other, since without random "
                    "assignment, other variables might differ systematically between high- and low-screen-time "
                    "teenagers and could be responsible for the sleep difference instead.\n\n"
                    "(B) Busyness from jobs and extracurriculars could be a confounding variable because it is "
                    "associated with both variables in the study: busier teenagers may use screens more for "
                    "quick breaks (associated with screen time) and also sleep less overall due to a packed "
                    "schedule (associated with sleep). Because busyness affects both variables, it's impossible "
                    "to tell from this data whether screen time itself is reducing sleep, or whether busyness is "
                    "driving both the screen time and the reduced sleep independently. To establish causation, "
                    "the researcher would need to conduct a randomized experiment, randomly assigning teenagers "
                    "to different fixed screen-time conditions; random assignment would tend to balance busyness "
                    "and other lurking variables evenly across the groups, isolating the effect of screen time "
                    "itself on sleep."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit response with correct observational/experimental distinction, correct causation-limitation reasoning, correct confounding-variable explanation naming both associations, and the correct experimental fix (random assignment).",
                "boundary_tags": [],
            },
            {
                "id": "R2",
                "text": (
                    "(A) This is an experiment because the researcher collected real data from real "
                    "teenagers. This matters because real data is more trustworthy than made-up data.\n\n"
                    "(B) Busyness isn't really a confounding variable -- it's just another thing that happens "
                    "to be true about busy teenagers. The researcher doesn't need to do anything differently; "
                    "the original conclusion about screen time causing less sleep is fine."
                ),
                "labels": {"C1": "not_earned", "C2": "not_earned", "C3": "not_earned", "C4": "not_earned"},
                "reviewer_note": "Misidentifies the study as an experiment (using 'real data from real teenagers' as the criterion, which is not what distinguishes observational studies from experiments -- the presence or absence of random assignment is), and the reasoning about trustworthiness is unrelated to the causation-vs-association distinction. Then denies that busyness is a confounding variable at all and endorses the original causal claim without any correction. Flags: observational/experiment misclassification, confounding variable concept rejected, unsupported endorsement of causal claim.",
                "boundary_tags": ["study_design_misclassification", "confounding_variable_concept_rejected"],
            },
            {
                "id": "R3",
                "text": (
                    "(A) It's observational because no one was randomly assigned to a screen-time group. This "
                    "means we can't say screen time causes less sleep.\n\n"
                    "(B) Busyness is a confounding variable because it's related to both things. To fix this, "
                    "researchers should run an experiment."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "not_earned", "C4": "not_earned"},
                "reviewer_note": "Parts (A) are both correctly reasoned. But (B) never explains *how* busyness is related to both variables (the specific mechanisms -- quick breaks and a packed schedule) or explains *why* that shared relationship prevents separating the effects, and 'run an experiment' doesn't specify random assignment as the actual mechanism that would fix the confounding. Flags: over-credit risk, confounding mechanism underexplained, fix underspecified (missing 'random assignment' specifically).",
                "boundary_tags": ["over_credit_risk", "mechanism_omitted", "fix_underspecified"],
            },
            {
                "id": "R4",
                "text": (
                    "(A) This is an observational study, not an experiment, because the researcher recorded "
                    "teenagers' screen time and sleep as they naturally occurred rather than randomly assigning "
                    "teenagers to specific screen-time levels. This matters because, without random assignment, "
                    "other differences between high- and low-screen-time teenagers (besides screen time itself) "
                    "could be responsible for the sleep difference, so only association -- not causation -- can "
                    "be concluded.\n\n"
                    "(B) Busyness could be a confounding variable because busier teenagers may both use screens "
                    "more (for short breaks between commitments) and sleep less (due to less free time overall), "
                    "meaning busyness is linked to both the explanatory and response variables. This makes it "
                    "impossible to separate whether screen time itself, or busyness, is actually responsible for "
                    "the reduced sleep. To establish causation, the researcher would need to run a randomized "
                    "experiment that randomly assigns teenagers to different screen-time levels, which would "
                    "tend to distribute busy and non-busy teenagers evenly across groups and remove busyness as "
                    "an alternative explanation."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Second full-credit response, closely paraphrasing R1 with equivalent completeness; confirms grader consistency.",
                "boundary_tags": [],
            },
            {
                "id": "R5",
                "text": (
                    "(A) It's observational since nothing was randomly assigned. This matters because "
                    "observational studies are less accurate than experiments.\n\n"
                    "(B) Busyness could explain both the screen time and the lack of sleep, so it's a "
                    "confounding variable. The researcher should control for busyness by only studying "
                    "teenagers who report the same busyness level, without needing to randomly assign anything."
                ),
                "labels": {"C1": "earned", "C2": "not_earned", "C3": "earned", "C4": "not_earned"},
                "reviewer_note": "C1 and the confounding-variable explanation in (B) are correct. But (A)'s reasoning for why the distinction matters ('observational studies are less accurate') mischaracterizes the actual issue -- it's not about accuracy/precision, it's about the inability to establish causation without random assignment. Additionally, (B)'s proposed fix (restricting the sample to a single busyness level) is a form of statistical control, not random assignment, and while a legitimate design idea in principle, it does not match the criterion's required fix (a randomized experiment) and the response even explicitly rejects needing randomization. Flags: causation-limitation reasoning replaced by vague accuracy claim, fix does not use required randomization mechanism.",
                "boundary_tags": ["vague_generality", "fix_does_not_match_required_mechanism"],
            },
        ],
    },
    {
        "id": "statistics_frq_10",
        "title": "Chi-Square Goodness-of-Fit Test for a Claimed Uniform Distribution",
        "unit": "Unit 8 - Inference for Categorical Data (Chi-Square Tests)",
        "difficulty": "Hard",
        "content_type": "inference",
        "stem": (
            "A game designer claims that a spinner lands on each of its 4 equally-sized colored "
            "regions (Red, Blue, Green, Yellow) with equal probability. A tester spins it 200 "
            "times and records: Red 62, Blue 58, Green 41, Yellow 39.\n\n"
            "**A.** State the null and alternative hypotheses for a chi-square goodness-of-fit "
            "test, and calculate the expected count for each color under the null hypothesis.\n\n"
            "**B.** The resulting chi-square test statistic is 8.68 with 3 degrees of freedom, "
            "giving a p-value of approximately 0.034. State a conclusion in context at "
            "alpha = 0.05."
        ),
        "criteria": [
            {"id": "C1", "text": "States H0: the spinner lands on each of the 4 colors with equal probability (p_Red = p_Blue = p_Green = p_Yellow = 0.25), and Ha: the spinner does not land on all 4 colors with equal probability (at least one proportion differs from 0.25).", "notes": "Must state both hypotheses in context, not just symbolically."},
            {"id": "C2", "text": "Calculates the expected count for each color as 200 x 0.25 = 50 for all four colors.", "notes": "All four expected counts must be stated as 50, not computed from the observed counts."},
            {"id": "C3", "text": "States that degrees of freedom = number of categories - 1 = 4 - 1 = 3, consistent with the given chi-square statistic, and correctly compares the p-value (0.034) to alpha (0.05) to determine statistical significance.", "notes": "Must explicitly compare p-value to alpha, not just restate the p-value."},
            {"id": "C4", "text": "Concludes in context that because the p-value (0.034) is less than alpha (0.05), there is convincing evidence that the spinner does not land on all 4 colors with equal probability, contradicting the designer's claim.", "notes": "Must state the conclusion in context (about the spinner's colors), not just 'reject H0.'"},
        ],
        "responses": [
            {
                "id": "R1",
                "text": (
                    "(A) H0: the spinner lands on Red, Blue, Green, and Yellow each with probability 0.25. "
                    "Ha: the spinner does not land on all four colors with equal probability. Expected count "
                    "for each color = 200 x 0.25 = 50.\n\n"
                    "(B) Degrees of freedom = 4 - 1 = 3, matching the given chi-square statistic. Since the "
                    "p-value (0.034) is less than alpha (0.05), the result is statistically significant. There "
                    "is convincing evidence that the spinner does not land on all four colors with equal "
                    "probability, contradicting the designer's claim of a uniform distribution."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit response with correctly stated hypotheses in context, correct expected counts, correct degrees of freedom check, and a properly contextualized conclusion.",
                "boundary_tags": [],
            },
            {
                "id": "R2",
                "text": (
                    "(A) H0: the observed counts equal the expected counts. Ha: they don't. Expected counts: "
                    "Red 62, Blue 58, Green 41, Yellow 39 (same as observed, since that's what we saw happen).\n\n"
                    "(B) Since the p-value is small, we reject H0 and conclude the spinner is unfair, meaning "
                    "it will never land on all colors equally again."
                ),
                "labels": {"C1": "not_earned", "C2": "not_earned", "C3": "not_earned", "C4": "not_earned"},
                "reviewer_note": "Hypotheses are stated in circular, non-substantive terms ('observed equals expected') rather than referencing the actual claimed proportions (0.25 each). Expected counts are incorrectly set equal to the observed counts -- expected counts under H0 must be calculated from the claimed/null proportions (200 x 0.25 = 50 each), not copied from what was actually observed, which would make a chi-square test meaningless. The conclusion also overreaches with an absolute, deterministic claim ('will never land on all colors equally again') rather than a probabilistic evidence-based conclusion. Flags: expected counts computed from observed data (invalidates the test), overstated/deterministic conclusion.",
                "boundary_tags": ["expected_counts_computed_from_observed_data", "overstated_certainty"],
            },
            {
                "id": "R3",
                "text": (
                    "(A) H0: p = 0.25 for each color. Ha: not all p = 0.25. Expected count = 50 for each "
                    "color.\n\n"
                    "(B) Since 0.034 < 0.05, we reject H0. The spinner is not fair."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "not_earned", "C4": "earned"},
                "reviewer_note": "Hypotheses and expected counts are both correct, and the final conclusion correctly reflects the evidence found. However, the response never mentions or verifies degrees of freedom (df = 4 - 1 = 3) as part of the significance check, which the criterion specifically requires alongside the p-value/alpha comparison. Flags: over-credit risk if grader treats the p-value comparison alone as sufficient without the df check.",
                "boundary_tags": ["over_credit_risk", "df_check_omitted"],
            },
            {
                "id": "R4",
                "text": (
                    "(A) H0: the spinner lands on each of the 4 colors with equal probability "
                    "(p_Red = p_Blue = p_Green = p_Yellow = 0.25). Ha: at least one color's true probability "
                    "differs from 0.25. Expected count for each color: 200 x 0.25 = 50.\n\n"
                    "(B) With 4 categories, degrees of freedom = 4 - 1 = 3, matching the given statistic. "
                    "Because the p-value (0.034) is less than alpha = 0.05, there is convincing evidence that "
                    "the spinner does not land on all four colors with equal probability, so the designer's "
                    "claim of a uniform distribution across the four regions is not supported by these data."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Second full-credit response with equivalent completeness to R1; confirms grader consistency.",
                "boundary_tags": [],
            },
            {
                "id": "R5",
                "text": (
                    "(A) H0: all colors are equally likely, Ha: not all equally likely. Expected count for "
                    "each: 50.\n\n"
                    "(B) Since 0.034 < 0.05, we have convincing evidence that the spinner isn't landing on "
                    "each color 25% of the time, exactly as the designer intended, so the spinner is broken and "
                    "needs to be physically rebuilt."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "not_earned", "C4": "earned"},
                "reviewer_note": "Hypotheses and expected counts are correct, and the core statistical conclusion (evidence against the uniform-probability claim) is correctly reached, so C4 is earned. But like R3, degrees of freedom are never checked, and the response also adds an unsupported real-world claim ('the spinner is broken and needs to be physically rebuilt') that goes beyond what the statistical test itself can establish -- the test shows the observed proportions are unlikely under H0, not a specific physical cause. Flags: df check omitted, unsupported inference beyond the scope of the test.",
                "boundary_tags": ["df_check_omitted", "unsupported_inference"],
            },
        ],
    },
]
