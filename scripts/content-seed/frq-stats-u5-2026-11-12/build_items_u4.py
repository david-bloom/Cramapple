#!/usr/bin/env python3
"""Unit 4 (Inference for Quantitative Data: Means) FRQs from rubric_patterns.json, same method as build_items.py.
Unit 4 is the STAND-IN for the nonexistent Unit 6 (David, 2026-11-12). Seed and variant = one template function, two cfgs.
Writes authored/seeds_u4.json, authored/variants_u4.json, pattern_use_u4.json."""
import json, math, os
from build_items import crit, assemble, SK, HERE, num  # noqa: F401

HELP4 = '''import math
from mpmath import betainc, findroot
def tcdf(t, df):
    x = df / (df + t * t)
    p = 0.5 * betainc(df / 2.0, 0.5, 0, x, regularized=True)
    return float(1 - p if t > 0 else p)
def tinv(p, df):
    return float(findroot(lambda t: tcdf(t, df) - p, 2.0))
def ncdf(z):
    return 0.5 * (1 + math.erf(z / math.sqrt(2)))
def zstar(p):
    return float(findroot(lambda z: ncdf(z) - p, 1.5))
def welch(s1, n1, s2, n2):
    a = s1 * s1 / n1; b = s2 * s2 / n2
    return math.sqrt(a + b), (a + b) ** 2 / (a * a / (n1 - 1) + b * b / (n2 - 1))
'''
exec(HELP4, globals())
M = '−'


def sg(v, d):
    s = f'{v:.{d}f}'
    return s.replace('-', M)


def pfmt(p):
    return f'{p:.4f}'


# ------------------------------------------------------------------ 4.1
def t41(c):
    mu, sg_, n, n2, cut = c['mu'], c['sigma'], c['n'], c['n2'], c['cut']
    sd = sg_ / math.sqrt(n); z = (cut - mu) / sd; sd2 = sg_ / math.sqrt(n2)
    p = ncdf(z) if c['dir'] == 'less' else 1 - ncdf(z)
    ev = f"the probability that the mean of a random sample of {n} {c['noun']} is {c['dir']} than {cut} {c['units']}"
    parts = [
        (f"Find the mean and the standard deviation of the sampling distribution of the sample mean x̄ for random samples of {n} {c['noun']}.",
         [('MEAN_XBAR', dict(mu=mu, units=c['units'], n=n, noun=c['noun'])),
          ('SD_XBAR', dict(sigma=sg_, n=n, sd=f'{sd:.3g}', units=c['units'], sd_variants=[f'{sd:.2f}', f'{sd:g}']))]),
        ("Is the sampling distribution of x̄ approximately normal? Justify your answer by checking the conditions.",
         [('XBAR_SHAPE', dict(stat_name='x̄', why=c['why'], why_short=c['why_short']))]),
        (f"Find the probability that the mean of a random sample of {n} {c['noun']} is {c['dir']} than {cut} {c['units']}.",
         [('XBAR_PROB', dict(event_text=ev, cut=cut, mu=mu, sd=f'{sd:.3g}', z=sg(z, 2), prob=f'{p:.4f}', prob_variants=[f'{p:.3f}', f'{100*p:.1f}%']))]),
        (f"Suppose the sample size is {n2} instead of {n}. How does the standard deviation of x̄ change? Give its new value.",
         [('SD_CHANGE', dict(n2=n2, sd2=f'{sd2:.3g}', sd=f'{sd:.3g}', units=c['units']))]),
    ]
    model = (f"(a) The mean of the sampling distribution of x̄ is μ = {mu} {c['units']}. The standard deviation is σ/√n = {sg_}/√{n} = {sd:.3g} {c['units']}.\n\n"
             f"(b) Yes. The sampling distribution of x̄ is approximately normal because {c['why']}.\n\n"
             f"(c) z = ({cut} − {mu})/{sd:.3g} = {sg(z, 2)}, so the probability that x̄ is {c['dir']} than {cut} {c['units']} is about {p:.4f}.\n\n"
             f"(d) With n = {n2}, the standard deviation of x̄ is {sg_}/√{n2} = {sd2:.3g} {c['units']}, smaller than {sd:.3g} {c['units']}, because σ/√n decreases as n increases.")
    ver = HELP4 + f'''mu, sigma, n, n2, cut = {mu}, {sg_}, {n}, {n2}, {cut}
sd = sigma / math.sqrt(n)
assert abs(sd - {sd:.6f}) < 1e-5
z = (cut - mu) / sd
assert abs(z - {z:.6f}) < 1e-5 and round(z, 2) == {round(z, 2)}
p = {'ncdf(z)' if c['dir'] == 'less' else '1 - ncdf(z)'}
assert round(p, 4) == {round(p, 4)}
assert abs(sigma / math.sqrt(n2) - {sd2:.6f}) < 1e-5
print("ALL_CHECKS_PASSED")
'''
    return assemble(c['title'], 'permitted', c['stim'], parts, model, ver)


S41 = dict(title='Sampling Distribution of Mean Battery Life', mu=12.4, sigma=1.8, n=36, n2=144, cut=12.0, dir='less', noun='batteries', units='hours',
           stim="A laptop manufacturer states that the battery life of its laptops has a mean of 12.4 hours and a standard deviation of 1.8 hours. The distribution of battery life is right-skewed. The company's inspectors will test a random sample of laptops chosen from the thousands produced this month.",
           why="the sample is random and much smaller than 10% of all laptops, so the values are independent, and the sample size n = 36 is at least 30, so the central limit theorem applies even though the population is skewed",
           why_short='random sample, independence, and n of at least 30 (central limit theorem)')
S41['noun'] = 'laptops'
V41 = dict(title='Sampling Distribution of Mean Bag Weight', mu=1000, sigma=24, n=16, n2=64, cut=1005, dir='greater', noun='bags', units='grams',
           stim="A packaging line fills bags of rice. The weight of a bag is normally distributed with a mean of 1000 grams and a standard deviation of 24 grams. A quality inspector will weigh a random sample of bags taken from the thousands filled today.",
           why="the sample is random and much smaller than 10% of all bags, so the values are independent, and the population of bag weights is normally distributed, so x̄ is normal for any sample size",
           why_short='random sample, independence, and a normal population')


# ------------------------------------------------------------------ 4.2
def t42(c):
    n, xb, s, conf = c['n'], c['xbar'], c['s'], c['conf']
    df = n - 1; ts = round(tinv(1 - (1 - conf) / 2, df), 3)
    se = s / math.sqrt(n); me = ts * se; lo, hi = xb - me, xb + me
    pc = int(round(conf * 100)); zs = f'{zstar(1 - (1 - conf) / 2):.2f}'
    parts = [
        (f"Show that the conditions for the appropriate procedure for estimating the {c['pop_mean']} are met.",
         [('COND_RANDOM', dict(rand_text=c['rand'])), ('COND_TEN', dict(ten_text=c['ten'])), ('COND_NORMAL', dict(norm_text=c['norm']))]),
        (f"The t critical value for {pc}% confidence with {df} degrees of freedom is t* = {ts}. Calculate the standard error and the interval.",
         [('CI_SE', dict(se_formula='s/√n = ' + f'{s}/√{n}', se=f'{se:.3f}'.rstrip('0').rstrip('.') if False else f'{se:.2f}', units=c['units'])),
          ('CI_INTERVAL', dict(formula=f'{xb} ± {ts}({se:.2f})', lo=f'{lo:.2f}', hi=f'{hi:.2f}', units=c['units'], tstar=ts,
                               interval_variants=[f'({lo:.2f}, {hi:.2f})', f'({lo:.1f}, {hi:.1f})']))]),
        (f"For {pc}% confidence, the critical value from the standard normal distribution is z* = {zs}, which is smaller than t* = {ts}. Explain why t* is larger.",
         [('T_STAR', dict(ts=ts, zs=zs, df=df, conf=pc))]),
    ]
    model = (f"(a) The procedure is a one-sample t-interval for a population mean. Randomization: {c['rand']}. 10% condition: {c['ten']}. Sample-data condition: {c['norm']}.\n\n"
             f"(b) SE = s/√n = {s}/√{n} = {se:.2f} {c['units']}. The interval is {xb} ± {ts}({se:.2f}) = {lo:.2f} to {hi:.2f} {c['units']}.\n\n"
             f"(c) The t-distribution has heavier tails than the normal distribution because s is used to estimate σ (here with {df} degrees of freedom), so t* = {ts} is larger than z* = {zs}.")
    ver = HELP4 + f'''n, xbar, s, conf = {n}, {xb}, {s}, {conf}
ts = tinv(1 - (1 - conf) / 2, n - 1)
assert abs(ts - {ts}) < 0.0006
assert round(zstar(1 - (1 - conf) / 2), 2) == {zs} and {ts} > {zs}
se = s / math.sqrt(n)
assert round(se, 2) == {round(se, 2)}
lo = xbar - {ts} * se; hi = xbar + {ts} * se
assert round(lo, 2) == {round(lo, 2)} and round(hi, 2) == {round(hi, 2)}
print("ALL_CHECKS_PASSED")
'''
    return assemble(c['title'], 'permitted', c['stim'], parts, model, ver)


S42 = dict(title='Estimating Mean Online Checkout Time', n=25, xbar=48.2, s=9.5, conf=0.95, units='seconds', pop_mean='mean checkout time',
           param_phrase='true mean checkout time for all online checkouts completed this month at this store',
           stim="An online store wants to estimate the mean time customers take to complete checkout. From the thousands of checkouts completed this month, an analyst selects a random sample of 25 checkouts. The sample mean is 48.2 seconds and the sample standard deviation is 9.5 seconds. A dotplot of the sample shows no strong skewness and no outliers.",
           rand='the checkouts were randomly selected', ten='25 checkouts are less than 10% of the thousands completed this month',
           norm='n = 25 is less than 30, but the dotplot of the sample shows no strong skewness and no outliers')
V42 = dict(title='Estimating Mean Fill Volume of Soda Cans', n=16, xbar=354.1, s=2.6, conf=0.95, units='milliliters', pop_mean='mean fill volume',
           param_phrase='true mean fill volume of all cans filled in this shift on this production line',
           stim="A beverage company wants to estimate the mean fill volume of cans from one production line. From the thousands of cans filled in one shift, an inspector selects a random sample of 16 cans. The sample mean is 354.1 milliliters and the sample standard deviation is 2.6 milliliters. A dotplot of the sample shows no strong skewness and no outliers.",
           rand='the cans were randomly selected', ten='16 cans are less than 10% of the thousands filled in the shift',
           norm='n = 16 is less than 30, but the dotplot of the sample shows no strong skewness and no outliers')


# ------------------------------------------------------------------ 4.3 / 4.8 (claim from an interval)
def t43(c):
    # matched-pairs interval for a mean difference; interval comes from technology (rounded to 2 decimals)
    n, d, s, conf = c['n'], c['dbar'], c['sd'], c['conf']
    ts = round(tinv(1 - (1 - conf) / 2, n - 1), 3); se = s / math.sqrt(n); me = ts * se
    lo, hi = round(d - me, 2), round(d + me, 2); pc = int(round(conf * 100)); v = c['claim_val']
    assert lo > 0 and hi < v
    stim = c['stim'].format(lo=f'{lo:.2f}', hi=f'{hi:.2f}', pc=pc)
    parts = [
        ("Interpret the interval in context.",
         [('CI_INTERPRET', dict(conf=pc, lo=f'{lo:.2f}', hi=f'{hi:.2f}', units=c['units'], param_phrase=c['param_phrase']))]),
        (f"{c['who']} claims that {c['zero_claim']}, that is, that μ_d = 0. Does the interval provide convincing evidence against this claim? Explain.",
         [('CI_CLAIM', dict(value='0', in_out='not in', lo=f'{lo:.2f}', hi=f'{hi:.2f}', claim_concl=f"0 is not a plausible value of the population mean difference, so the interval provides convincing evidence that the mean difference is not 0 ({c['zero_concl']})"))]),
        (f"{c['who']} also claims that {c['big_claim']}, that is, that μ_d is at least {v} {c['units']}. Does the interval support this claim? Explain.",
         [('CI_CLAIM', dict(value=v, in_out='above', lo=f'{lo:.2f}', hi=f'{hi:.2f}', claim_concl=f"{v} is not a plausible value of μ_d and every plausible value is below it, so the interval does not support the claim"))]),
        (f"Without recalculating, how would a {c['conf2']}% interval from the same data compare in width with this {pc}% interval? Explain.",
         [('CI_WIDTH', dict(conf2=c['conf2']))]),
    ]
    model = (f"(a) We are {pc}% confident that the interval from {lo:.2f} to {hi:.2f} {c['units']} captures the {c['param_phrase']}.\n\n"
             f"(b) Yes. Because 0 is not in the interval ({lo:.2f}, {hi:.2f}), it is not a plausible value of μ_d, so the interval provides convincing evidence that the mean difference is not 0 ({c['zero_concl']}).\n\n"
             f"(c) No. {v} is above the interval ({lo:.2f}, {hi:.2f}), so it is not a plausible value of μ_d and every plausible value is below it; the interval does not support the claim.\n\n"
             f"(d) A {c['conf2']}% interval would be wider, because a higher confidence level uses a larger critical value t*, which increases the margin of error.")
    ver = HELP4 + f'''n, d, s, conf = {n}, {d}, {s}, {conf}
ts = tinv(1 - (1 - conf) / 2, n - 1)
se = s / math.sqrt(n)
lo, hi = d - ts * se, d + ts * se
assert round(lo, 2) == {lo} and round(hi, 2) == {hi}
assert lo > 0 and hi < {v}
assert tinv(1 - (1 - {c['conf2'] / 100}) / 2, n - 1) > ts
print("ALL_CHECKS_PASSED")
'''
    return assemble(c['title'], 'permitted', stim, parts, model, ver)


S43 = dict(title='Claims About a Mean Improvement in 5K Times', n=20, dbar=1.35, sd=2.10, conf=0.95, units='minutes', conf2=99, claim_val=2.5, who='The coach',
           param_phrase='true mean improvement (before minus after) in 5K time for all runners like these after the 6-week program',
           zero_claim='the program does not change mean 5K time', zero_concl='the program is associated with a change in mean 5K time',
           big_claim='the program improves mean 5K time by at least 2.5 minutes',
           stim="A coach recorded the 5K running times of 20 randomly selected runners before and after a 6-week training program. For each runner, the difference (before minus after) in minutes was calculated; positive differences mean the runner got faster. The differences have no strong skewness and no outliers. Using technology, the coach found a {pc}% confidence interval for the population mean difference μ_d of ({lo}, {hi}) minutes.")
V43 = dict(title='Claims About a Mean Blood Pressure Drop', n=24, dbar=6.8, sd=9.6, conf=0.95, units='mmHg', conf2=99, claim_val=12, who='The pharmacist',
           param_phrase='true mean drop (before minus after) in systolic blood pressure for all patients like these after the new medication',
           zero_claim='the medication does not change mean systolic blood pressure', zero_concl='the medication is associated with a change in mean systolic blood pressure',
           big_claim='the medication lowers mean systolic blood pressure by at least 12 mmHg',
           stim="A pharmacist recorded the systolic blood pressure of 24 randomly selected patients before and after four weeks on a new medication. For each patient, the difference (before minus after) in mmHg was calculated; positive differences mean blood pressure dropped. The differences have no strong skewness and no outliers. Using technology, the pharmacist found a {pc}% confidence interval for the population mean difference μ_d of ({lo}, {hi}) mmHg.")


# ------------------------------------------------------------------ 4.4 / 4.9 (set up a test)
def t44(c):
    n, xb, s = c['n'], c['xbar'], c['s']
    parts = [
        (f"Define the parameter of interest and state the null and alternative hypotheses for the test.",
         [('PARAM_DEFINE', dict(param_sym='μ', param_phrase=c['param_phrase'])),
          ('HYPOTHESES', dict(h0=f"μ = {c['mu0']}", ha=f"μ {c['ha_sym']} {c['mu0']}"))]),
        ("Identify the appropriate procedure and show that its conditions are met.",
         [('PROC_ID', dict(proc='a one-sample t-test for a population mean', why_proc='')),
          ('COND_RANDOM', dict(rand_text=c['rand'])), ('COND_TEN', dict(ten_text=c['ten'])), ('COND_NORMAL', dict(norm_text=c['norm']))]),
    ]
    model = (f"(a) μ is the {c['param_phrase']}. H₀: μ = {c['mu0']} versus Hₐ: μ {c['ha_sym']} {c['mu0']}.\n\n"
             f"(b) The procedure is a one-sample t-test for a population mean, Randomization: {c['rand']}. 10% condition: {c['ten']}. Sample-data condition: {c['norm']}.")
    ver = f'''mu0, n = {c['mu0']}, {n}
assert n {'>= 30' if c['n'] >= 30 else '< 30'}
assert {c['xbar']} {'<' if c['ha_sym'] == '<' else '>'} mu0
print("ALL_CHECKS_PASSED")
'''
    return assemble(c['title'], 'not_applicable', c['stim'], parts, model, ver)


S44 = dict(title='Setting Up a Test of a Claimed Mean Bulb Life', mu0=1200, ha_sym='<', n=40, xbar=1168, s=96,
           param_phrase="true mean lifetime, in hours, of all of this company's light bulbs sold in stores nationwide",
           stim="A company claims that its light bulbs last a mean of 1200 hours. A consumer group suspects the true mean lifetime is less than 1200 hours. The group buys a random sample of 40 bulbs from the thousands in stores nationwide and tests each one. The sample mean lifetime is 1168 hours and the sample standard deviation is 96 hours.",
           rand='the 40 bulbs were randomly selected', ten='40 bulbs are less than 10% of all of this company\'s bulbs in stores',
           norm='n = 40 is at least 30, so the sampling distribution of the sample mean is approximately normal')
V44 = dict(title='Setting Up a Test of a Claimed Mean Clinic Wait', mu0=20, ha_sym='>', n=18, xbar=23.1, s=5.8,
           param_phrase='true mean waiting time, in minutes, of all patients seen at this clinic this month',
           stim="A clinic posts a sign saying that patients wait a mean of 20 minutes to see a provider. A patient advocate suspects the true mean wait is more than 20 minutes. The advocate takes a random sample of 18 patients from the hundreds seen this month and records each wait. The sample mean is 23.1 minutes and the sample standard deviation is 5.8 minutes. A dotplot of the sample shows no strong skewness and no outliers.",
           rand='the 18 patients were randomly selected', ten='18 patients are less than 10% of the hundreds seen this month',
           norm='n = 18 is less than 30, but the dotplot of the sample shows no strong skewness and no outliers')


# ------------------------------------------------------------------ 4.5 / 4.10 (carry out a test)
def decide(p, alpha):
    return ('less than', 'reject') if p < alpha else ('greater than', 'fail to reject')


def t45(c):
    n, d, s, alpha = c['n'], c['dbar'], c['sd'], c['alpha']
    se = s / math.sqrt(n); t = d / se; df = n - 1
    tail = 1 - tcdf(abs(t), df); p = tail if c['alt'] == 'one' else 2 * tail
    cmp_, dec = decide(p, alpha); ps = pfmt(p); ts = sg(t, 2)
    concl = c['reject_concl'] if dec == 'reject' else c['fail_concl']
    short = 'convincing evidence for Hₐ' if dec == 'reject' else 'not convincing evidence for Hₐ'
    stim = c['stim'].format(p=ps)
    parts = [
        ("Calculate the test statistic.",
         [('TEST_STAT', dict(t_formula=f"t = d̄/(s_d/√n) = {sg(d, 2) if d < 0 else d}/({s}/√{n})", t_text=ts, t_variants=[ts, f'{t:.3f}'.replace('-', M)]))]),
        ("Interpret the p-value in context.",
         [('P_INTERPRET', dict(p=ps, null_context=c['null_ctx'], extreme_text=c['extreme']))]),
        (f"Use the p-value and the significance level α = {alpha} to state a conclusion about the claim, in context.",
         [('P_DECISION', dict(p=ps, alpha=alpha, cmp=cmp_, decision=dec)), ('CONCLUDE', dict(concl_text=concl, concl_short=short))]),
    ]
    model = (f"(a) t = d̄/(s_d/√n) = {sg(d, 2) if d < 0 else d}/({s}/√{n}) = {ts}, with df = {df}.\n\n"
             f"(b) Assuming {c['null_ctx']}, the probability of getting {c['extreme']} is about {ps}.\n\n"
             f"(c) The p-value {ps} is {cmp_} α = {alpha}, so we {dec} H₀. {concl[0].upper() + concl[1:]}.")
    ver = HELP4 + f'''n, d, s, alpha = {n}, {d}, {s}, {alpha}
t = d / (s / math.sqrt(n))
assert round(t, 2) == {round(t, 2)}
tail = 1 - tcdf(abs(t), n - 1)
p = {'tail' if c['alt'] == 'one' else '2 * tail'}
assert round(p, 4) == {round(p, 4)}
assert (p < alpha) == {p < alpha}
print("ALL_CHECKS_PASSED")
'''
    return assemble(c['title'], 'permitted', stim, parts, model, ver)


S45 = dict(title='Test of Mean Score Gain After Mnemonic Training', n=15, dbar=3.4, sd=4.6, alpha=0.05, alt='one', units='points', extreme='a sample mean difference of 3.4 points or greater (equivalently, a test statistic of about 2.86 or greater)',
           null_ctx='the mean score gain for all students after mnemonic training is 0', alt_dir='(a mean gain greater than 0)',
           reject_concl='there is convincing evidence that the mean score gain after mnemonic training is greater than 0 points for all students like these',
           fail_concl='there is not convincing evidence that the mean score gain after mnemonic training is greater than 0 points for all students like these',
           stim="A teacher randomly selected 15 students from a large school and gave each a vocabulary quiz before and after a mnemonic training session. For each student, the difference (after minus before) in quiz score was calculated. The sample of differences has mean 3.4 points and standard deviation 4.6 points, with no strong skewness and no outliers. The teacher tests H₀: μ_d = 0 versus Hₐ: μ_d > 0 at significance level α = 0.05, where μ_d is the population mean difference (after minus before). Technology gives a p-value of {p}.")
V45 = dict(title='Test of Mean Commute Difference Between Two Routes', n=12, dbar=-2.9, sd=5.1, alpha=0.05, alt='two', units='minutes', extreme='a sample mean difference at least 2.9 minutes away from 0 in either direction (equivalently, a test statistic at least about 1.97 away from 0)',
           null_ctx='the mean commute-time difference (route A minus route B) for all drivers is 0', alt_dir='in either direction (a mean difference different from 0)',
           reject_concl='there is convincing evidence that the mean commute-time difference (route A minus route B) is not 0 minutes for all drivers like these',
           fail_concl='there is not convincing evidence that the mean commute-time difference (route A minus route B) is not 0 minutes for all drivers like these',
           stim="A commuter randomly selected 12 drivers from a large company, and each drove both route A and route B in a random order. For each driver, the difference (route A time minus route B time) in minutes was calculated. The sample of differences has mean −2.9 minutes and standard deviation 5.1 minutes, with no strong skewness and no outliers. The commuter tests H₀: μ_d = 0 versus Hₐ: μ_d ≠ 0 at significance level α = 0.05, where μ_d is the population mean difference (route A minus route B). Technology gives a p-value of {p}.")


# ------------------------------------------------------------------ 4.6
def t46(c):
    m1, s1, n1, m2, s2, n2, cut = c['m1'], c['s1'], c['n1'], c['m2'], c['s2'], c['n2'], c['cut']
    md = m1 - m2; sd = math.sqrt(s1 ** 2 / n1 + s2 ** 2 / n2); z = (cut - md) / sd
    p = ncdf(z) if c['dir'] == 'less' else 1 - ncdf(z)
    ev = f"the probability that x̄₁ − x̄₂ is {c['dir']} than {cut} {c['units']}"
    parts = [
        ("Find the mean of the sampling distribution of x̄₁ − x̄₂, the difference between the two sample means.",
         [('DIFF_MEAN', dict(md=md, units=c['units']))]),
        ("Find the standard deviation of the sampling distribution of x̄₁ − x̄₂.",
         [('DIFF_SD', dict(s1=s1, n1=n1, s2=s2, n2=n2, sdd=f'{sd:.3f}', units=c['units'], sdd_variants=[f'{sd:.2f}']))]),
        ("Is the sampling distribution of x̄₁ − x̄₂ approximately normal? Justify your answer.",
         [('XBAR_SHAPE', dict(stat_name='x̄₁ − x̄₂', why=c['why'], why_short=c['why_short']))]),
        (c.get('q') or f"Find the probability that the sample mean from {c['g1']} exceeds the sample mean from {c['g2']} by {'more' if c['dir'] == 'greater' else 'less'} than {cut} {c['units']}.",
         [('XBAR_PROB', dict(event_text=ev, cut=cut, mu=md, sd=f'{sd:.3f}', z=sg(z, 2), prob=f'{p:.4f}', prob_variants=[f'{p:.3f}', f'{100*p:.1f}%']))]),
    ]
    model = (f"(a) The mean is μ₁ − μ₂ = {m1} − {m2} = {md} {c['units']}.\n\n"
             f"(b) √({s1}²/{n1} + {s2}²/{n2}) = {sd:.3f} {c['units']}.\n\n"
             f"(c) Yes. The sampling distribution of x̄₁ − x̄₂ is approximately normal because {c['why']}.\n\n"
             f"(d) z = ({cut} − {md})/{sd:.3f} = {sg(z, 2)}, so the probability that x̄₁ − x̄₂ is {c['dir']} than {cut} {c['units']} is about {p:.4f}.")
    ver = HELP4 + f'''m1, s1, n1, m2, s2, n2, cut = {m1}, {s1}, {n1}, {m2}, {s2}, {n2}, {cut}
md = m1 - m2
sd = math.sqrt(s1 ** 2 / n1 + s2 ** 2 / n2)
assert md == {md} and round(sd, 3) == {round(sd, 3)}
z = (cut - md) / sd
assert round(z, 2) == {round(z, 2)}
p = {'ncdf(z)' if c['dir'] == 'less' else '1 - ncdf(z)'}
assert round(p, 4) == {round(p, 4)}
print("ALL_CHECKS_PASSED")
'''
    return assemble(c['title'], 'permitted', c['stim'], parts, model, ver)


S46 = dict(title='Sampling Distribution of a Difference in Mean Commute Times', m1=34, s1=8, n1=40, m2=30, s2=6, n2=45, cut=6, dir='greater', units='minutes',
           g1='City A', g2='City B',
           stim="Commute times (in minutes) in City A have a mean of 34 and a standard deviation of 8. Commute times in City B have a mean of 30 and a standard deviation of 6. A researcher takes independent random samples of 40 commuters from City A and 45 commuters from City B, each far smaller than 10% of the commuters in its city. Let x̄₁ be the mean for City A and x̄₂ the mean for City B.",
           why='both samples are random and independent, and both sample sizes (40 and 45) are at least 30',
           why_short='independent random samples and both sample sizes at least 30')
V46 = dict(title='Sampling Distribution of a Difference in Mean Delivery Times', q='Find the probability that the difference x̄₁ − x̄₂ is less than 2 minutes.', m1=52, s1=10, n1=50, m2=47, s2=7, n2=60, cut=2, dir='less', units='minutes',
           g1='Store 1', g2='Store 2',
           stim="Delivery times (in minutes) for Store 1 have a mean of 52 and a standard deviation of 10. Delivery times for Store 2 have a mean of 47 and a standard deviation of 7. An analyst takes independent random samples of 50 deliveries from Store 1 and 60 deliveries from Store 2, each far smaller than 10% of that store's deliveries. Let x̄₁ be the mean for Store 1 and x̄₂ the mean for Store 2.",
           why='both samples are random and independent, and both sample sizes (50 and 60) are at least 30',
           why_short='independent random samples and both sample sizes at least 30')
S46['g1'] = 'City A'; V46['g1'] = 'Store 1'


# ------------------------------------------------------------------ 4.7 / 4.8 helpers for two means
def two(c):
    n1, m1, s1, n2, m2, s2 = c['n1'], c['m1'], c['s1'], c['n2'], c['m2'], c['s2']
    se, df = welch(s1, n1, s2, n2); df1 = round(df, 1); conf = c['conf']
    ts = round(tinv(1 - (1 - conf) / 2, df1), 3); d = m1 - m2; me = ts * se
    return dict(se=se, df=df1, ts=ts, d=d, lo=d - me, hi=d + me, pc=int(round(conf * 100)))


def t47(c):
    r = two(c); n1, m1, s1, n2, m2, s2 = c['n1'], c['m1'], c['s1'], c['n2'], c['m2'], c['s2']
    se, ts, d, lo, hi, pc, df = r['se'], r['ts'], r['d'], r['lo'], r['hi'], r['pc'], r['df']
    stim = c['stim']
    parts = [
        (f"Show that the conditions for the appropriate procedure for estimating the difference in mean {c['resp']} are met.",
         [('COND_RANDOM', dict(rand_text=c['rand'])), ('COND_TEN', dict(ten_text=c['ten'])), ('COND_NORMAL', dict(norm_text=c['norm']))]),
        (f"Technology gives {pc}% confidence with approximately {df} degrees of freedom, so t* = {ts}. Calculate the standard error and the interval for μ₁ − μ₂.",
         [('CI_SE', dict(se_formula=f'√(s₁²/n₁ + s₂²/n₂) = √({s1}²/{n1} + {s2}²/{n2})', se=f'{se:.3f}', units=c['units'])),
          ('CI_INTERVAL', dict(formula=f'({m1} − {m2}) ± {ts}({se:.3f})', lo=sg(lo, 2), hi=sg(hi, 2), units=c['units'], tstar=ts,
                               interval_variants=[f'({sg(lo, 2)}, {sg(hi, 2)})', f'({sg(lo, 1)}, {sg(hi, 1)})']))]),
        ("State the point estimate for μ₁ − μ₂.",
         [('POINT_EST', dict(m1=m1, m2=m2, d=sg(d, 1), units=c['units']))]),
    ]
    model = (f"(a) The procedure is a two-sample t-interval for a difference in population means. Randomization: {c['rand']}. 10% condition: {c['ten']}. Sample-data condition: {c['norm']}.\n\n"
             f"(b) SE = √({s1}²/{n1} + {s2}²/{n2}) = {se:.3f} {c['units']}. The interval is ({m1} − {m2}) ± {ts}({se:.3f}) = {sg(lo, 2)} to {sg(hi, 2)} {c['units']}.\n\n"
             f"(c) The point estimate is x̄₁ − x̄₂ = {m1} − {m2} = {sg(d, 1)} {c['units']}.")
    ver = HELP4 + f'''n1, m1, s1, n2, m2, s2, conf = {n1}, {m1}, {s1}, {n2}, {m2}, {s2}, {c['conf']}
se, df = welch(s1, n1, s2, n2)
assert round(df, 1) == {df}
ts = tinv(1 - (1 - conf) / 2, {df})
assert abs(ts - {ts}) < 0.0006
assert round(se, 3) == {round(se, 3)}
lo = (m1 - m2) - {ts} * se; hi = (m1 - m2) + {ts} * se
assert round(lo, 2) == {round(lo, 2)} and round(hi, 2) == {round(hi, 2)}
print("ALL_CHECKS_PASSED")
'''
    return assemble(c['title'], 'permitted', stim, parts, model, ver)


S47 = dict(title='Estimating a Difference in Mean Exam Scores Between Two Schools', n1=32, m1=78.4, s1=11.2, n2=35, m2=72.1, s2=9.8, conf=0.95, units='points', resp='exam score',
           param_phrase='true difference (School 1 minus School 2) in mean exam score for all students at the two schools',
           stim="A district compares a common end-of-year exam at two schools. Independent random samples were taken: 32 students from School 1 (mean 78.4, standard deviation 11.2) and 35 students from School 2 (mean 72.1, standard deviation 9.8). Each sample is less than 10% of its school's students.",
           rand='the students were selected by independent random samples from the two schools', ten='each sample is less than 10% of the students at its school',
           norm='both sample sizes (32 and 35) are at least 30')
V47 = dict(title='Estimating a Difference in Mean Seedling Heights for Two Greenhouses', n1=18, m1=14.6, s1=3.1, n2=22, m2=12.9, s2=2.8, conf=0.95, units='centimeters', resp='seedling height',
           param_phrase='true difference (Greenhouse A minus Greenhouse B) in mean seedling height for all seedlings in the two greenhouses',
           stim="A botanist compares two large greenhouses. Independent random samples of seedlings were measured: 18 seedlings from Greenhouse A (mean height 14.6 cm, standard deviation 3.1 cm) and 22 seedlings from Greenhouse B (mean height 12.9 cm, standard deviation 2.8 cm). Each greenhouse holds thousands of seedlings. Dotplots of both samples show no strong skewness and no outliers.",
           rand='the seedlings were selected by independent random samples from the two greenhouses', ten='each sample is less than 10% of the seedlings in its greenhouse',
           norm='both sample sizes are less than 30, but the dotplots of both samples show no strong skewness and no outliers')


def t48(c):
    r = two(c); lo, hi, pc, d = round(r['lo'], 2), round(r['hi'], 2), r['pc'], r['d']; v = c['claim_val']
    assert lo > 0 and hi < v
    stim = c['stim'].format(lo=f'{lo:.2f}', hi=f'{hi:.2f}', pc=pc)
    parts = [
        ("Interpret the interval in context.",
         [('CI_INTERPRET', dict(conf=pc, lo=f'{lo:.2f}', hi=f'{hi:.2f}', units=c['units'], param_phrase=c['param_phrase']))]),
        (f"{c['who']} claims that {c['zero_claim']}, that is, that μ₁ − μ₂ = 0. Does the interval provide convincing evidence against this claim? Explain.",
         [('CI_CLAIM', dict(value='0', in_out='not in', lo=f'{lo:.2f}', hi=f'{hi:.2f}', claim_concl=f"0 is not a plausible value of the difference in population means, so the interval provides convincing evidence that the means differ ({c['zero_concl']})"))]),
        (f"{c['who']} also claims that {c['big_claim']}, that is, that μ₁ − μ₂ is at least {v} {c['units']}. Does the interval support this claim? Explain.",
         [('CI_CLAIM', dict(value=v, in_out='above', lo=f'{lo:.2f}', hi=f'{hi:.2f}', claim_concl=f"{v} is not a plausible value of μ₁ − μ₂ and every plausible value is below it, so the interval does not support the claim"))]),
        (f"Without recalculating, how would a {c['conf2']}% interval from the same data compare in width with this {pc}% interval? Explain.",
         [('CI_WIDTH', dict(conf2=c['conf2']))]),
    ]
    model = (f"(a) We are {pc}% confident that the interval from {lo:.2f} to {hi:.2f} {c['units']} captures the {c['param_phrase']}.\n\n"
             f"(b) Yes. Because 0 is not in the interval ({lo:.2f}, {hi:.2f}), it is not a plausible value of μ₁ − μ₂, so the interval provides convincing evidence that the means differ ({c['zero_concl']}).\n\n"
             f"(c) No. {v} is above the interval ({lo:.2f}, {hi:.2f}), so it is not a plausible value and every plausible value is below it; the interval does not support the claim.\n\n"
             f"(d) A {c['conf2']}% interval would be wider, because a higher confidence level uses a larger critical value t*, which increases the margin of error.")
    n1, m1, s1, n2, m2, s2 = c['n1'], c['m1'], c['s1'], c['n2'], c['m2'], c['s2']
    ver = HELP4 + f'''n1, m1, s1, n2, m2, s2, conf = {n1}, {m1}, {s1}, {n2}, {m2}, {s2}, {c['conf']}
se, df = welch(s1, n1, s2, n2)
ts = tinv(1 - (1 - conf) / 2, round(df, 1))
lo = (m1 - m2) - ts * se; hi = (m1 - m2) + ts * se
assert round(lo, 2) == {lo} and round(hi, 2) == {hi}
assert lo > 0 and hi < {v}
assert tinv(1 - (1 - {c['conf2'] / 100}) / 2, round(df, 1)) > ts
print("ALL_CHECKS_PASSED")
'''
    return assemble(c['title'], 'permitted', stim, parts, model, ver)


S48 = dict(title='Claims About a Difference in Mean Reading Fluency', n1=40, m1=61.2, s1=10.4, n2=38, m2=56.0, s2=9.1, conf=0.95, units='words per minute', conf2=99, claim_val=10, who='The program director',
           param_phrase='true difference (program group minus comparison group) in mean reading fluency for all students like these',
           zero_claim='the program does not change mean reading fluency', zero_concl='the program is associated with a difference in mean reading fluency',
           big_claim='the program raises mean reading fluency by at least 10 words per minute',
           stim="A school district randomly assigned 40 students to a reading-fluency program and 38 students to a comparison group, and measured each student's reading fluency in words per minute at the end of the term. Program group: mean 61.2, standard deviation 10.4. Comparison group: mean 56.0, standard deviation 9.1. Using technology, an analyst found a {pc}% confidence interval for μ₁ − μ₂, the difference (program minus comparison) in population means, of ({lo}, {hi}) words per minute.")
V48 = dict(title='Claims About a Difference in Mean Daily Steps', n1=42, m1=9.1, s1=4.2, n2=45, m2=5.9, s2=3.6, conf=0.95, units='thousand steps', conf2=99, claim_val=6, who='The wellness manager',
           param_phrase='true difference (participant minus non-participant) in mean daily steps, in thousands, for all employees like these',
           zero_claim='participants and non-participants have the same mean daily steps', zero_concl='participants and non-participants differ in mean daily steps',
           big_claim='participants average at least 6 thousand more steps per day',
           stim="A company randomly selected 42 employees who joined a wellness program and 45 who did not, and recorded each employee's mean daily steps, in thousands. Participants: mean 9.1, standard deviation 4.2. Non-participants: mean 5.9, standard deviation 3.6. Using technology, an analyst found a {pc}% confidence interval for μ₁ − μ₂, the difference (participant minus non-participant) in population means, of ({lo}, {hi}) thousand steps.")


# ------------------------------------------------------------------ 4.9
def t49(c):
    parts = [
        (f"Define the parameters of interest and state the null and alternative hypotheses for the test.",
         [('PARAM_DEFINE', dict(param_sym='μ₁ and μ₂', param_phrase=c['param_phrase'])),
          ('HYPOTHESES', dict(h0='μ₁ − μ₂ = 0', ha=f"μ₁ − μ₂ {c['ha_sym']} 0"))]),
        ("Identify the appropriate procedure and show that its conditions are met.",
         [('PROC_ID', dict(proc='a two-sample t-test for a difference in population means', why_proc='')),
          ('COND_RANDOM', dict(rand_text=c['rand'])), ('COND_TEN', dict(ten_text=c['ten'])), ('COND_NORMAL', dict(norm_text=c['norm']))]),
    ]
    model = (f"(a) {c['param_phrase'][0].upper() + c['param_phrase'][1:]}. H₀: μ₁ − μ₂ = 0 versus Hₐ: μ₁ − μ₂ {c['ha_sym']} 0.\n\n"
             f"(b) The procedure is a two-sample t-test for a difference in population means, Randomization: {c['rand']}. 10% condition: {c['ten']}. Sample-data condition: {c['norm']}.")
    ver = f'''n1, n2, m1, m2 = {c['n1']}, {c['n2']}, {c['m1']}, {c['m2']}
assert {'min(n1, n2) >= 30' if min(c['n1'], c['n2']) >= 30 else 'max(n1, n2) < 30'}
assert m1 {'>' if c['ha_sym'] == '>' else '<'} m2
print("ALL_CHECKS_PASSED")
'''
    return assemble(c['title'], 'not_applicable', c['stim'], parts, model, ver)


S49 = dict(title='Setting Up a Test for Two Fertilizers', ha_sym='>', n1=36, m1=48.6, s1=6.4, n2=40, m2=45.9, s2=7.1,
           param_phrase='μ₁ is the true mean yield, in bushels per acre, of all fields in the region that use the new fertilizer, and μ₂ is the true mean yield of all fields in the region that use the standard fertilizer',
           stim="A farm cooperative believes a new fertilizer gives a greater mean corn yield than the standard fertilizer. Thousands of fields in the region use each fertilizer. The cooperative independently and randomly selected 36 fields that use the new fertilizer (sample mean 48.6 bushels per acre, standard deviation 6.4) and 40 fields that use the standard fertilizer (sample mean 45.9, standard deviation 7.1).",
           rand='the fields were selected by independent random samples from the two groups of fields', ten='each sample is less than 10% of the thousands of fields that use its fertilizer',
           norm='both sample sizes (36 and 40) are at least 30')
V49 = dict(title='Setting Up a Test for Two Study Methods', ha_sym='>', n1=14, m1=84.3, s1=6.2, n2=16, m2=79.8, s2=7.0,
           param_phrase='μ₁ is the true mean exam score, in points, of all students at the school who study with flashcards, and μ₂ is the true mean exam score of all students at the school who study by rereading notes',
           stim="A teacher believes that students who study with flashcards earn a greater mean exam score than students who study by rereading notes. At a school of 400 students, 200 study with flashcards and 200 study by rereading. A counselor independently and randomly selected 14 of the students who study with flashcards (sample mean 84.3 points, standard deviation 6.2) and 16 of the students who study by rereading (sample mean 79.8 points, standard deviation 7.0). Dotplots of both samples show no strong skewness and no outliers.",
           rand='the students were selected by independent random samples from the two groups of students', ten='each sample is less than 10% of its group of 200 students (14 and 16 are each under 20)',
           norm='both sample sizes are less than 30, but the dotplots of both samples show no strong skewness and no outliers')


# ------------------------------------------------------------------ 4.10
def t410(c):
    n1, m1, s1, n2, m2, s2, alpha = c['n1'], c['m1'], c['s1'], c['n2'], c['m2'], c['s2'], c['alpha']
    se, df = welch(s1, n1, s2, n2); df = round(df, 1); t = (m1 - m2) / se
    tail = 1 - tcdf(abs(t), df); p = tail if c['alt'] == 'one' else 2 * tail
    cmp_, dec = decide(p, alpha); ps = pfmt(p); ts = sg(t, 2)
    concl = c['reject_concl'] if dec == 'reject' else c['fail_concl']
    short = 'convincing evidence for Hₐ' if dec == 'reject' else 'not convincing evidence for Hₐ'
    stim = c['stim'].format(p=ps, df=df)
    parts = [
        ("Calculate the test statistic.",
         [('TEST_STAT', dict(t_formula=f"t = (x̄₁ − x̄₂)/√(s₁²/n₁ + s₂²/n₂) = ({m1} − {m2})/√({s1}²/{n1} + {s2}²/{n2})", t_text=ts, t_variants=[ts, f'{t:.3f}'.replace('-', M)]))]),
        ("Interpret the p-value in context.",
         [('P_INTERPRET', dict(p=ps, null_context=c['null_ctx'], extreme_text=c['extreme']))]),
        (f"Use the p-value and the significance level α = {alpha} to state a conclusion about the claim, in context.",
         [('P_DECISION', dict(p=ps, alpha=alpha, cmp=cmp_, decision=dec)), ('CONCLUDE', dict(concl_text=concl, concl_short=short))]),
    ]
    model = (f"(a) t = ({m1} − {m2})/√({s1}²/{n1} + {s2}²/{n2}) = {ts}.\n\n"
             f"(b) Assuming {c['null_ctx']}, the probability of getting {c['extreme']} is about {ps}.\n\n"
             f"(c) The p-value {ps} is {cmp_} α = {alpha}, so we {dec} H₀. {concl[0].upper() + concl[1:]}.")
    ver = HELP4 + f'''n1, m1, s1, n2, m2, s2, alpha = {n1}, {m1}, {s1}, {n2}, {m2}, {s2}, {alpha}
se, df = welch(s1, n1, s2, n2)
assert round(df, 1) == {df}
t = (m1 - m2) / se
assert round(t, 2) == {round(t, 2)}
tail = 1 - tcdf(abs(t), {df})
p = {'tail' if c['alt'] == 'one' else '2 * tail'}
assert round(p, 4) == {round(p, 4)}
assert (p < alpha) == {p < alpha}
print("ALL_CHECKS_PASSED")
'''
    return assemble(c['title'], 'permitted', stim, parts, model, ver)


S410 = dict(title='Test of a Difference in Mean Delivery Times for Two Couriers', n1=30, m1=82.5, s1=12.1, n2=34, m2=76.8, s2=10.7, alpha=0.05, alt='one', units='points', extreme='a difference in sample means of 5.7 points or greater (equivalently, a test statistic of about 1.98 or greater)',
            null_ctx='tutoring has no effect on the mean exam score (μ₁ − μ₂ = 0)', alt_dir='in the direction of Hₐ (a difference greater than 0)',
            reject_concl='there is convincing evidence that the mean exam score with tutoring is greater than the mean exam score without tutoring for the students in this study',
            fail_concl='there is not convincing evidence that the mean exam score with tutoring is greater than the mean exam score without tutoring for the students in this study',
            stim="A tutoring center randomly assigned students to a tutored group (30 students, mean score 82.5, standard deviation 12.1) or a comparison group (34 students, mean score 76.8, standard deviation 10.7) on a final exam. Both samples have no strong skewness and no outliers. The center tests H₀: μ₁ − μ₂ = 0 versus Hₐ: μ₁ − μ₂ > 0 at significance level α = 0.05, where group 1 is tutored and group 2 is comparison. Technology gives df ≈ {df} and a p-value of {p}.")
S410['title'] = 'Test of a Difference in Mean Exam Scores for Tutored Students'
V410 = dict(title='Test of a Difference in Mean Recovery Times for Two Treatments', n1=26, m1=71.4, s1=9.8, n2=28, m2=68.9, s2=11.3, alpha=0.05, alt='two', units='minutes', extreme='a difference in sample means at least 2.5 minutes away from 0 in either direction (equivalently, a test statistic at least about 0.87 away from 0)',
            null_ctx='the two treatments have the same mean recovery time (μ₁ − μ₂ = 0)', alt_dir='in either direction (a difference different from 0)',
            reject_concl='there is convincing evidence that the mean recovery time with treatment 1 differs from the mean recovery time with treatment 2 for the patients in this study',
            fail_concl='there is not convincing evidence that the mean recovery time with treatment 1 differs from the mean recovery time with treatment 2 for the patients in this study',
            stim="A physiotherapy clinic randomly assigned patients to treatment 1 (26 patients, mean recovery time 71.4 minutes, standard deviation 9.8) or treatment 2 (28 patients, mean recovery time 68.9 minutes, standard deviation 11.3). Both samples have no strong skewness and no outliers. The clinic tests H₀: μ₁ − μ₂ = 0 versus Hₐ: μ₁ − μ₂ ≠ 0 at significance level α = 0.05. Technology gives df ≈ {df} and a p-value of {p}.")
S410['units'] = 'points'

TOPICS = [('4.1', t41, S41, V41), ('4.2', t42, S42, V42), ('4.3', t43, S43, V43), ('4.4', t44, S44, V44), ('4.5', t45, S45, V45),
          ('4.6', t46, S46, V46), ('4.7', t47, S47, V47), ('4.8', t48, S48, V48), ('4.9', t49, S49, V49), ('4.10', t410, S410, V410)]
if __name__ == '__main__':
    seeds, variants, use = [], [], {}
    for code, fn, s, v in TOPICS:
        for kind, cfg, out in (('seed', s, seeds), ('variant', v, variants)):
            item, u = fn(cfg)
            out.append({'subject_key': SK, 'topic_code': code, 'item': item})
            use[f'{SK}__{code}__{kind}'] = u
        assert [[p['pattern'] for p in part] for part in use[f'{SK}__{code}__seed']] == [[p['pattern'] for p in part] for part in use[f'{SK}__{code}__variant']], code
    json.dump(seeds, open(os.path.join(HERE, 'authored', 'seeds_u4.json'), 'w'), indent=1, ensure_ascii=False)
    json.dump(variants, open(os.path.join(HERE, 'authored', 'variants_u4.json'), 'w'), indent=1, ensure_ascii=False)
    json.dump(use, open(os.path.join(HERE, 'pattern_use_u4.json'), 'w'), indent=1, ensure_ascii=False)
    print(len(seeds), 'Unit 4 seeds,', len(variants), 'variants; same pattern order per topic: OK')
