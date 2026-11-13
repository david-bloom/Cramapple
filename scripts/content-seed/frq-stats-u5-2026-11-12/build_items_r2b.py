#!/usr/bin/env python3
"""r2 second variants (David via the parent session, 2026-11-12): a SECOND variant for each re-authored r2 seed.
Same template functions and rubric structure as the r2 seed and its first variant; only context, data and numbers differ.
Difficulty target for the batch: Medium (no checker rates Easy); every harder demand (trap in the context, failed condition,
critique, multi-step) is kept from the parent. Writes r2/authored/variants_b.json and r2/pattern_use_b.json."""
import json, os
from build_items_r2 import *  # noqa: F401,F403
from build_items_r2 import TOPICS, R2, SK, t51, t53, t54, t55, t43, t44, t45, t46, t47, t49, reg

# ---- 5.1: arch, water and growth
_xw = list(range(1, 13)); _yw = [int(round(70 - 1.2 * (x - 6) ** 2)) for x in _xw]
_hi = [y for x, y in zip(_xw, _yw) if x >= 10]; _mid = [y for x, y in zip(_xw, _yw) if 3 <= x <= 8]
V51b = dict(title='Weekly Water and Seedling Growth: Describing a Curved Association', kind='arch', xs=[float(x) for x in _xw], f=lambda x: 70 - 1.2 * (x - 6) ** 2, ys=_yw, pk=5, f_src='70 - 1.2 * (x - 6) ** 2',
            hx='Water (liters per week)', hy='Growth (mm)', x_name='weekly water amount', y_name='seedling growth', x_units='liters', turn='6',
            d1='positive', d2='negative', form='non-linear (a curve that rises and then falls)', form_short='rising then falling',
            stim="A gardener gave 12 groups of seedlings different weekly amounts of water, in liters, and recorded the mean growth of each group after a month, in millimeters.",
            claim='Claim 1 (gardener): seedlings given more water always grow more.', claim2='Claim 2 (neighbor): every group given 10 or more liters grew less than every group given 3 to 8 liters.',
            claim_text=f"Concludes Claim 1 is not supported: growth rises up to 6 liters ({_yw[5]} mm) but falls for larger amounts, for example {_yw[11]} mm at 12 liters.",
            claim_evidence=f"Response says Claim 1 is not supported and cites values from the table, such as {_yw[5]} mm at 6 liters versus {_yw[11]} mm at 12 liters.",
            claim_assert="assert ys[11] < ys[5] and xs[11] > xs[5]\nassert max(y for x, y in zip(xs, ys) if x >= 10) < min(y for x, y in zip(xs, ys) if 3 <= x <= 8)",
            claim2_text=f"Concludes Claim 2 is supported: the highest growth among groups given 10 or more liters is {max(_hi)} mm, which is below the lowest growth ({min(_mid)} mm) among groups given 3 to 8 liters.",
            claim2_evidence=f"Response says Claim 2 is supported and shows every growth at 10 or more liters ({', '.join(str(v) for v in _hi)}) is below every growth from 3 to 8 liters ({min(_mid)} or higher), for example by comparing {max(_hi)} with {min(_mid)}.")
assert max(_hi) < min(_mid)

# ---- 5.3: e-bike prices from two points
V53b = dict(title='Limits of an Electric Bike Price Model', ages=[1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5], a=1850, b=-210, x_far=10, xs3=[0.5, 5, 8], kinds=['extrapolation', 'interpolation', 'extrapolation'], pts=[(2, 1430), (4, 1010)],
            ph=['6 months', '5 years', '8 years'], dp=0, eq_text='ŷ = 1850 − 210x', eq_plain='1850 − 210x', x_name='age', y_name='resale price', x_units='years', y_units='dollars', case='an electric bike that is', case_pl='electric bikes', seller='shop owner',
            stim="A shop owner recorded the age, in years, of each of {n} electric bikes of the same model and its resale price. The ages were: {ages}. The least-squares regression line, found using technology, has the form ŷ = a + bx, where x is the age in years and ŷ is the predicted resale price in dollars.",
            order_text='', reason_text='')

# ---- 5.4: arch (tree age and fruit yield)
V54b = dict(title='Residual Pattern for a Tree Age and Fruit Yield Model', xs=[1, 2, 3, 4, 5, 6, 7], ys=[11, 17, 24, 26, 25, 23, 12], xa=1, xb=4,
            signs=['negative', 'negative', 'positive', 'positive', 'positive', 'positive', 'negative'], case_word='age group', x_unit='years', shape_word='negative, positive, negative (arch-shaped)',
            pattern_text='arch-shaped pattern of the residuals', hx='Tree age (years)', hy='Yield (kg)', y_name='fruit yield', y_units='kg',
            stim="An orchard manager recorded the mean fruit yield of trees in seven age groups. The least-squares regression line, found using technology, is {eq}, where x is the age of the trees in years and ŷ is the predicted yield in kilograms. The data are shown below.")

# ---- 5.5: fuel economy
V55b = dict(title='Interpreting and Critiquing a Regression Line for Fuel Economy', a=52.4, b=-0.8, lo=22, hi=42, xbar=30, ybar=28.4, r2=0.88, x_one='hundred pounds',
            x_name='vehicle weight', y_name='fuel economy', x_units='hundreds of pounds', y_units='miles per gallon', n=45, unit_noun='vehicle models',
            student='the regression line predicts the fuel economy exactly for 88% of the vehicle models',
            stim="A magazine recorded the weight and the highway fuel economy of 45 vehicle models whose weights were between 2200 and 4200 pounds. Technology gives the least-squares regression line ŷ = 52.4 − 0.8x, where x is the vehicle weight in hundreds of pounds and ŷ is the predicted fuel economy in miles per gallon, and gives r² = 0.88.")

# ---- 4.3: weight loss
V43b = dict(title='Claims and Misreadings of a Matched-Pairs Interval for Weight Loss', n=18, dbar=3.1, sd=3.8, conf=0.95, units='kg', n_new=72, claim_val=6, who='The dietitian', who_lower='the dietitian',
            unit_noun='participants', param_phrase='true mean weight loss (before minus after) for all adults like these after the 8-week diet',
            zero_claim='the diet does not change mean weight (μ_d = 0)', zero_concl='the diet is associated with a change in mean weight',
            big_claim='the diet lowers mean weight by at least 6 kg (μ_d ≥ 6)',
            indiv='95% of participants lost between 1.21 and 4.99 kg.', indiv_short="the dietitian's statement that 95% of participants lost between 1.21 and 4.99 kg",
            stim="A dietitian recorded the weights of 18 randomly selected adults before and after an 8-week diet. For each adult, the difference (before minus after) in kilograms was calculated; positive differences mean the adult lost weight. The differences have no strong skewness and no outliers. Using technology, the dietitian found a {pc}% confidence interval for the population mean difference μ_d of ({lo}, {hi}) kg.")

# ---- 4.4: matched pairs, condition fails, reversed sign
V44b = dict(title='Is a Matched-Pairs t-Test Appropriate? Headphones and Focus Scores', sym='μ_d', h0='μ_d = 0', ha='μ_d < 0',
            param_phrase='μ_d is the true mean difference (focus score without headphones minus focus score with headphones), in points, for all students at this college',
            proc='a one-sample t-test for a population mean difference (matched pairs), applied to the 14 differences',
            rand='the 14 students were randomly selected', ten='14 students are less than 10% of the students at the college',
            norm='the sample of differences has n = 14, which is less than 30, and its dotplot is strongly skewed with one outlier, so the sample-data condition is not met and the t-test is not appropriate',
            n_small=14, big=False, met=False,
            q_err='A classmate proposes a two-sample t-test that compares the mean focus score with headphones and the mean focus score without headphones for these students. Is that appropriate? Explain.',
            proposed="the classmate's two-sample t-test", why_not='each student provided both scores, so the two sets of scores are not independent samples; the analysis should use the 14 differences (a matched-pairs, one-sample procedure)',
            stim="A counselor suspects that noise-cancelling headphones improve students' focus scores. She randomly selected 14 students from a large college. Each student took a focus test once with headphones and once without, in a random order, and the counselor recorded each student's difference (score without headphones minus score with headphones) in points. The sample of 14 differences has mean −6.4 points and standard deviation 9.8 points. A dotplot of the 14 differences is strongly skewed with one outlier.")

# ---- 4.5: errors with an ergonomic keyboard, alpha 0.05 and 0.01
V45b = dict(title='Test of Mean Typing-Error Change: Conclusions and Misconceptions', n=18, dbar=-2.6, sd=4.4, alpha=0.05, alpha2=0.01, alt='one', units='errors',
            extreme='a sample mean difference of −2.6 errors or lower (equivalently, a test statistic of about −2.51 or lower)',
            null_ctx='the mean difference in typing errors (after minus before) for all typists is 0',
            student="Since the p-value is less than 0.05, the keyboard reduces errors by a large amount.", student_short="the student's statement that the small p-value shows the keyboard reduces errors by a large amount",
            correction='a small p-value means convincing evidence that the mean difference is less than 0; it does not measure how large the difference is, which is estimated by the sample mean difference of −2.6 errors',
            reject_concl='there is convincing evidence that the mean difference in typing errors (after minus before) is less than 0 for all typists like these',
            fail_concl='there is not convincing evidence that the mean difference in typing errors (after minus before) is less than 0 for all typists like these',
            stim="A trainer randomly selected 18 typists from a large company and counted each typist's errors on a standard text before and after switching to an ergonomic keyboard. For each typist, the difference (after minus before) in errors was calculated. The sample of differences has mean −2.6 errors and standard deviation 4.4 errors, with no strong skewness and no outliers. The trainer tests H₀: μ_d = 0 versus Hₐ: μ_d < 0, where μ_d is the population mean difference (after minus before). Technology gives a p-value of {p}.")

# ---- 4.6: bus lines
V46b = dict(title='Direction, Probability and Sample Size for a Difference in Mean Bus Waits', m1=18, s1=5, n1=36, m2=15, s2=4, n2=42, dir='less', units='minutes', target=0.45, pop_word='bus line', role='planner',
            event="the mean wait of the Line 1 sample is less than the mean wait of the Line 2 sample", q_prob="Find the probability that the sample mean wait for Line 1 is less than the sample mean wait for Line 2.",
            stim="Waiting times (in minutes) at Line 1 stops have a mean of 18 and a standard deviation of 5. Waiting times at Line 2 stops have a mean of 15 and a standard deviation of 4. A planner takes independent random samples of 36 waits from Line 1 and 42 waits from Line 2, each far smaller than 10% of that line's waits. Let x̄₁ be the mean for Line 1 and x̄₂ the mean for Line 2.",
            why='both samples are random and independent, and both sample sizes (36 and 42) are at least 30', why_short='independent random samples and both sample sizes at least 30')

# ---- 4.7: phone batteries, t table
V47b = dict(title='Interval for a Difference in Mean Battery Life Using a t Table', n1=26, m1=14.2, s1=2.1, n2=21, m2=12.8, s2=2.4, conf=0.95, units='hours', resp='battery life',
            tab_intro='A t table gives these critical values:',
            stim="A reviewer compares two phone brands. Independent random samples of phones were tested: 26 phones of Brand X (mean battery life 14.2 hours, standard deviation 2.1 hours) and 21 phones of Brand Y (mean 12.8 hours, standard deviation 2.4 hours). Each brand has sold thousands of the model. Dotplots of both samples show no strong skewness and no outliers.",
            rand='the phones were selected by independent random samples from the two brands', ten='each sample is less than 10% of the thousands of phones sold by its brand',
            norm='both sample sizes are less than 30, but the dotplots of both samples show no strong skewness and no outliers')

# ---- 4.9: couriers, not-equal alternative, condition fails
V49b = dict(title='Is a Two-Sample t-Test Appropriate? Delivery Times for Two Couriers', g1='first courier', g2='second courier', ha_sym='≠', n1=34, n2=12, m1=41.6, m2=44.9, both_big=False,
            param_phrase='μ₁ is the true mean delivery time, in minutes, of all deliveries by the first courier, and μ₂ is the true mean delivery time of all deliveries by the second courier',
            rand='the deliveries were selected by independent random samples from the two couriers\' deliveries', ten='each sample is less than 10% of the thousands of deliveries by its courier',
            norm='one sample (n = 12) is less than 30, so both samples must show no strong skewness or outliers, but the second courier\'s sample is skewed with one outlier, so the sample-data condition is not met and the two-sample t-test is not appropriate',
            stim="A dispatcher wants to know whether two couriers have different mean delivery times. Each courier has made thousands of deliveries. The dispatcher independently and randomly selected 34 deliveries by the first courier (sample mean 41.6 minutes) and 12 deliveries by the second courier (sample mean 44.9 minutes). A dotplot of the 34 first-courier times has no strong skewness and no outliers. A dotplot of the 12 second-courier times is skewed right with one outlier.")

B = {'5.1': V51b, '5.3': V53b, '5.4': V54b, '5.5': V55b, '4.3': V43b, '4.4': V44b, '4.5': V45b, '4.6': V46b, '4.7': V47b, '4.9': V49b}
if __name__ == '__main__':
    seed_use = json.load(open(os.path.join(R2, 'pattern_use.json')))
    out, use = [], {}
    for code, fn, s, v in TOPICS:
        item, u = fn(B[code])
        assert [[p['pattern'] for p in part] for part in u] == [[p['pattern'] for p in part] for part in seed_use[f'{SK}__{code}__seed']], code
        out.append({'subject_key': SK, 'topic_code': code, 'item': item})
        use[f'{SK}__{code}__seed'] = seed_use[f'{SK}__{code}__seed']; use[f'{SK}__{code}__variant'] = u
    json.dump(out, open(os.path.join(R2, 'authored', 'variants_b.json'), 'w'), indent=1, ensure_ascii=False)
    json.dump(use, open(os.path.join(R2, 'pattern_use_b.json'), 'w'), indent=1, ensure_ascii=False)
    print(len(out), 'second variants built; pattern order equals the seed for every topic')
