#!/usr/bin/env python3
"""Instantiate AP Statistics Unit 5 FRQs from rubric_patterns.json.

One template function per topic; a seed and its variant are the SAME function called with two different `cfg`
dicts, so the rubric shape (ordered pattern ids, part count, point count) is identical and the variant differs only in
context, data and numbers. Writes authored/seeds.json, authored/variants.json and pattern_use.json (sidecar).
All numbers shown in text are computed here from the data; each item also carries a verification_python that
recomputes them independently inside the item (checked by validate.mjs).
"""
import json, math, os, sys
HERE = os.path.dirname(os.path.abspath(__file__))
LIB = json.load(open(os.path.join(HERE, 'rubric_patterns.json')))['patterns']
SK = 'ap_statistics'


def reg(x, y):
    n = len(x); mx = sum(x) / n; my = sum(y) / n
    sxx = sum((a - mx) ** 2 for a in x); syy = sum((b - my) ** 2 for b in y)
    sxy = sum((a - mx) * (b - my) for a, b in zip(x, y)); b = sxy / sxx
    return b, my - b * mx, sxy / math.sqrt(sxx * syy), mx, my


HELP = '''import math
def reg(x, y):
    n = len(x); mx = sum(x) / n; my = sum(y) / n
    sxx = sum((a - mx) ** 2 for a in x); syy = sum((b - my) ** 2 for b in y)
    sxy = sum((a - mx) * (b - my) for a, b in zip(x, y)); b = sxy / sxx
    return b, my - b * mx, sxy / math.sqrt(sxx * syy), mx, my
'''


def crit(pid, **f):
    p = LIB[pid]
    out = {k: p[k].format(**f) for k in ('text', 'evidence', 'fix')}
    av = p['accepted_variants']
    av = f[av.strip('{}')] if isinstance(av, str) else list(av)
    out['accepted_variants'] = list(dict.fromkeys(av))
    return out, {'pattern': pid, 'fills': {k: v for k, v in f.items() if not k.endswith('_variants')}}


def assemble(title, calc, stim, parts, model, verify):
    plist, use = [], []
    for prompt, cs in parts:
        row = [crit(pid, **f) for pid, f in cs]
        plist.append({'prompt': prompt, 'criteria': [r[0] for r in row]})
        use.append([r[1] for r in row])
    return {'title': title, 'calculator': calc, 'stimulus': stim, 'parts': plist, 'model_answer': model,
            'verification_python': verify}, use


def table(hx, hy, xs, ys):
    return f'{hx} | {hy}\n' + '\n'.join(f'{a} | {b}' for a, b in zip(xs, ys))


def num(v, d=1):
    return f'{v:.{d}f}'.replace('-', '−')


# ------------------------------------------------------------------ 5.1
def t51(c):
    xs, ys, ui = c['xs'], c['ys'], c['ui']
    b, a, r, mx, my = reg(xs, ys)
    res = [y - (a + b * x) for x, y in zip(xs, ys)]
    others = sorted(abs(e) for i, e in enumerate(res) if i != ui)
    assert abs(res[ui]) >= 2.5 * others[-1], (res[ui], others[-1])
    assert abs(r) >= 0.85
    meet = [(x, y) for x, y in zip(xs, ys) if x >= c['thr']]
    assert all(c['cmp'](y) for _, y in meet)
    stim = c['stim'] + '\n\n' + table(c['hx'], c['hy'], xs, ys)
    nm = len(meet)
    parts = [
        (f"If {c['purpose']}, which variable is the explanatory variable and which is the response variable? State which axis each variable is placed on in a scatterplot.",
         [('EXPL_RESP', dict(x_name=c['x_name'], y_name=c['y_name']))]),
        (f"Describe the association between {c['x_name']} and {c['y_name']} that a scatterplot of these data would show. Address form, direction, strength and any unusual feature, in context.",
         [('SCATTER_FORM', dict(form_phrase='linear (the points follow a roughly straight-line pattern)')),
          ('SCATTER_DIR', dict(direction=c['dir'], x_name=c['x_name'], y_name=c['y_name'], trend_phrase=c['trend'])),
          ('SCATTER_STRENGTH', dict(strength='strong', strength_reason='all points other than one lie close to a single straight-line pattern')),
          ('SCATTER_UNUSUAL', dict(
              unusual_text=f"Identifies the point with {xs[ui]} {c['x_units']} of {c['x_short']} and {ys[ui]} {c['y_units']} of {c['y_short']} as an unusual feature: it does not fit the general pattern because {c['unusual_why']}.",
              unusual_evidence=f"Response singles out the observation ({xs[ui]}, {ys[ui]}) as not fitting the general pattern and says how it differs from the other points."))]),
        (f"{c['claim']} Does the data table support this claim? Justify your answer using the values in the table.",
         [('SCATTER_CLAIM', dict(
             claim_text=f"Concludes the claim is supported, because all {nm} {c['units_noun']} with {c['thr']} {c['x_units']} or more of {c['x_short']} ({', '.join(str(y) for _, y in meet)} {c['y_units']}) {c['cmp_text']}.",
             claim_evidence=f"Response says the claim is supported and cites the {nm} {c['units_noun']} with {c['x_short']} of {c['thr']} {c['x_units']} or more, all of whom {c['cmp_text']}."))]),
    ]
    model = (f"(a) The explanatory variable is {c['x_name']}, placed on the x-axis, because it is the variable used to predict the other. The response variable is {c['y_name']}, placed on the y-axis.\n\n"
             f"(b) Form: the association is linear, because the points follow a roughly straight-line pattern. Direction: it is {c['dir']}; as {c['x_name']} increases, {c['y_name']} tends to {c['trend']}. "
             f"Strength: the association is strong, because all points other than one lie close to a single straight-line pattern. Unusual feature: the point ({xs[ui]}, {ys[ui]}), {xs[ui]} {c['x_units']} of {c['x_short']} and {ys[ui]} {c['y_units']} of {c['y_short']}, does not fit the general pattern because {c['unusual_why']}.\n\n"
             f"(c) Yes, the data support the claim. All {nm} {c['units_noun']} with {c['thr']} {c['x_units']} or more of {c['x_short']} have {c['y_short']} of {', '.join(str(y) for _, y in meet)} {c['y_units']}, and each {c['cmp_sg']}.")
    ver = HELP + f'''xs = {xs}
ys = {ys}
ui = {ui}
b, a, r, mx, my = reg(xs, ys)
assert {'r < -0.85' if c['dir'] == 'negative' else 'r > 0.85'}
assert (b < 0) == {c['dir'] == 'negative'}
res = [y - (a + b * x) for x, y in zip(xs, ys)]
others = sorted(abs(e) for i, e in enumerate(res) if i != ui)
assert abs(res[ui]) >= 2.5 * others[-1]
assert max(range(len(res)), key=lambda i: abs(res[i])) == ui
meet = [y for x, y in zip(xs, ys) if x >= {c['thr']}]
assert len(meet) == {nm}
assert all({c['vcmp']} for y in meet)
assert meet == {[y for _, y in meet]}
print("ALL_CHECKS_PASSED")
'''
    return assemble(c['title'], 'not_applicable', stim, parts, model, ver)


S51 = dict(
    title='Daily Screen Time and Nightly Sleep for Twelve Students',
    stim="A school counselor wants to know whether daily screen time is related to sleep. For each of 12 randomly chosen students, the counselor recorded the typical daily screen time in minutes and the typical nightly sleep in hours.",
    hx='Screen time (minutes per day)', hy='Sleep (hours per night)',
    xs=[30, 40, 55, 60, 75, 85, 95, 110, 120, 130, 140, 150], ys=[9.0, 8.8, 8.6, 7.7, 8.3, 8.1, 7.9, 7.7, 7.5, 7.4, 7.2, 7.0], ui=3,
    purpose='the counselor wants to use daily screen time to predict nightly sleep', x_name='daily screen time', y_name='nightly sleep',
    x_short='screen time', y_short='sleep', x_units='minutes', y_units='hours', dir='negative', trend='decrease',
    unusual_why='this student sleeps noticeably less than other students with similar screen time',
    claim='The counselor claims that students who spend 120 minutes or more on screens each day sleep fewer than 8 hours per night.',
    thr=120, cmp=lambda y: y < 8, vcmp='y < 8', cmp_text='sleep fewer than 8 hours', cmp_sg='sleeps fewer than 8 hours', units_noun='students')
V51 = dict(
    title='Weekly Practice Time and Typing Speed for Twelve Students',
    stim="A keyboarding teacher wants to know whether practice time is related to typing speed. For each of 12 randomly chosen students, the teacher recorded the weekly practice time in hours and the typing speed on a timed test in words per minute.",
    hx='Practice time (hours per week)', hy='Typing speed (words per minute)',
    xs=[2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 14], ys=[38, 43, 46, 52, 55, 45, 63, 68, 72, 76, 80, 88], ui=5,
    purpose='the teacher wants to use weekly practice time to predict typing speed', x_name='weekly practice time', y_name='typing speed',
    x_short='practice', y_short='typing speed', x_units='hours', y_units='words per minute', dir='positive', trend='increase',
    unusual_why='this student types much more slowly than other students with similar practice time',
    claim='The teacher claims that students who practice 10 hours or more per week type at least 70 words per minute.',
    thr=10, cmp=lambda y: y >= 70, vcmp='y >= 70', cmp_text='type at least 70 words per minute', cmp_sg='types at least 70 words per minute', units_noun='students')


# ------------------------------------------------------------------ 5.2
def t52(c):
    r = c['r']; sgn = 'negative' if r < 0 else 'positive'; pole = '-1' if r < 0 else '1'
    rt = num(r, 2)
    # unit-free demo data for the verification script
    xs, ys = c['demo_x'], c['demo_y']
    stim = c['stim']
    parts = [
        (f"Interpret the value of r in context.",
         [('R_DIR', dict(r_value=rt, direction=sgn, x_name=c['x_name'], y_name=c['y_name'], trend_phrase=c['trend'])),
          ('R_STRENGTH', dict(r_value=rt, strength_word='strong', near_pole=pole, x_name=c['x_name'], y_name=c['y_name']))]),
        (f"{c['mgr']} says, \"Because r = {rt}, a linear model is definitely appropriate for predicting {c['y_name']} from {c['x_name']}.\" Explain why this reasoning is incomplete and what should be done before deciding that a linear model is appropriate.",
         [('R_NOT_GUARANTEE', dict(r_value=rt)), ('R_CHECK_RESIDUAL_PLOT', dict())]),
        (f"{c['mgr']} also concludes that {c['cause_claim']}. Is this conclusion justified by the correlation? Explain.",
         [('NO_CAUSATION', dict(cause_claim=c['cause_claim']))]),
        (f"The analysts will also measure {c['x_name']} in different units, {c['unit_change']}. What value of r will they find for the new measurements? Explain.",
         [('R_UNIT_FREE', dict(r_value=rt, unit_change=c['unit_change_short']))]),
    ]
    model = (f"(a) The correlation r = {rt} is {sgn}, so as {c['x_name']} increases, {c['y_name']} tends to {c['trend']}. Because r is close to {pole}, the linear association between {c['x_name']} and {c['y_name']} is strong.\n\n"
             f"(b) A value of r close to -1 or 1 does not necessarily mean a linear model is appropriate. The data could follow a curved pattern even when r is large. The analysts should look at a residual plot (or a scatterplot) and check for curvature or another pattern before deciding.\n\n"
             f"(c) No. Correlation does not imply causation. The strong association does not show that {c['cause_claim']}; other variables could account for the pattern.\n\n"
             f"(d) The new r will still be {rt}. The correlation coefficient is unit-free, so changing the units of measurement ({c['unit_change_short']}) does not change r.")
    ver = HELP + f'''r = {r}
assert -1 <= r <= 1 and abs(r) > 0.8
assert (r < 0) == {r < 0}
xs = {xs}
ys = {ys}
r1 = reg(xs, ys)[2]
r2 = reg([{c['unit_factor']} * x for x in xs], ys)[2]
assert abs(r1 - r2) < 1e-12
print("ALL_CHECKS_PASSED")
'''
    return assemble(c['title'], 'not_applicable', stim, parts, model, ver)


S52 = dict(
    title='Interpreting a Correlation Between Temperature and Bike Rentals',
    stim="A bike-share company recorded, for each of 60 randomly selected days, the daily high temperature in degrees Fahrenheit and the number of bikes rented that day. Technology reports a correlation coefficient of r = 0.91 for these data.",
    r=0.91, x_name='daily high temperature', y_name='number of bikes rented', trend='increase', mgr='A manager',
    cause_claim='warmer temperatures cause more bikes to be rented', unit_change='in degrees Celsius instead of degrees Fahrenheit',
    unit_change_short='measuring temperature in degrees Celsius instead of degrees Fahrenheit', unit_factor='5/9',
    demo_x=[40, 52, 61, 70, 78, 85, 91], demo_y=[210, 305, 330, 420, 515, 560, 640])
V52 = dict(
    title='Interpreting a Correlation Between Vehicle Weight and Fuel Economy',
    stim="An automotive magazine recorded, for each of 45 randomly selected new car models, the vehicle weight in pounds and the fuel economy in miles per gallon. Technology reports a correlation coefficient of r = −0.88 for these data.",
    r=-0.88, x_name='vehicle weight', y_name='fuel economy', trend='decrease', mgr='An editor',
    cause_claim='heavier vehicles cause lower fuel economy', unit_change='in kilograms instead of pounds',
    unit_change_short='measuring weight in kilograms instead of pounds', unit_factor='0.4536',
    demo_x=[2400, 2700, 3000, 3300, 3700, 4100, 4600], demo_y=[39, 36, 34, 30, 27, 24, 21])


# ------------------------------------------------------------------ 5.3
def t53(c):
    a, b, lo, hi, xn, xf = c['a'], c['b'], c['lo'], c['hi'], c['x_near'], c['x_far']
    yn, yf = a + b * xn, a + b * xf
    assert lo <= xn <= hi and xf > hi
    eq = c['eq_text']; dp = c['dp']

    def fmt(v): return f'{v:.{dp}f}'
    def var(v, extra): return [fmt(v), str(round(v, dp)).rstrip('0').rstrip('.') if dp else fmt(v)] + extra
    stim = c['stim']
    parts = [
        (f"Use the model to predict the {c['y_name']} of {c['case_a']} {xn} {c['x_units']} old. Is this prediction an interpolation or an extrapolation? Explain.",
         [('PREDICT', dict(eq_text=eq, x0=xn, yhat_text=fmt(yn), y_units=c['y_units'], yhat_variants=var(yn, c['extra_n']))),
          ('EXTRAP_CLASS', dict(x0=xn, kind='interpolation', where='within', x_name=c['x_name'], lo=lo, hi=hi, x_units=c['x_units']))]),
        (f"Use the model to predict the {c['y_name']} of {c['case_a']} {xf} {c['x_units']} old. Is this prediction an interpolation or an extrapolation? Explain.",
         [('PREDICT', dict(eq_text=eq, x0=xf, yhat_text=fmt(yf), y_units=c['y_units'], yhat_variants=var(yf, c['extra_f']))),
          ('EXTRAP_CLASS', dict(x0=xf, kind='extrapolation', where='beyond', x_name=c['x_name'], lo=lo, hi=hi, x_units=c['x_units'])) ]),
        (f"Which of your two predictions is more reliable? Explain.",
         [('RELIABILITY', dict(x_near=xn, x_far=xf, x_units=c['x_units'], x_name=c['x_name']))]),
    ]
    model = (f"(a) ŷ = {c['eq_plain']} with x = {xn} gives ŷ = {fmt(yn)} {c['y_units']}. This is interpolation, because {xn} {c['x_units']} is within the interval of {c['x_name']} values, {lo} to {hi} {c['x_units']}, used to fit the line.\n\n"
             f"(b) With x = {xf}, ŷ = {fmt(yf)} {c['y_units']}. This is extrapolation, because {xf} {c['x_units']} is beyond the interval of {c['x_name']} values, {lo} to {hi} {c['x_units']}, used to fit the line.\n\n"
             f"(c) The prediction at {xn} {c['x_units']} is more reliable. The prediction at {xf} {c['x_units']} is extrapolation, and predictions become less reliable the further {c['x_name']} is beyond the data.")
    ver = f'''a = {a}
b = {b}
lo, hi = {lo}, {hi}
xn, xf = {xn}, {xf}
yn = a + b * xn
yf = a + b * xf
assert abs(yn - {round(yn, dp)}) < 1e-9
assert abs(yf - {round(yf, dp)}) < 1e-9
assert lo <= xn <= hi
assert xf > hi
print("ALL_CHECKS_PASSED")
'''
    return assemble(c['title'], 'permitted', stim, parts, model, ver)


S53 = dict(
    title='Predicting Used-Car Prices From Age',
    stim="A used-car dealer fit a least-squares regression line to the asking prices of 20 cars of the same model. The cars were between 2 and 9 years old. The regression equation, found using technology, is ŷ = 27.4 − 1.9x, where x is the age of the car in years and ŷ is the predicted asking price in thousands of dollars.",
    a=27.4, b=-1.9, lo=2, hi=9, x_near=6, x_far=13, eq_text='ŷ = 27.4 − 1.9x', eq_plain='27.4 − 1.9x', dp=1,
    x_name='age', y_name='asking price', x_units='years', y_units='thousand dollars', case_a='a car that is', extra_n=['$16,000'], extra_f=['$2,700'])
V53 = dict(
    title='Predicting Laptop Resale Value From Age',
    stim="An electronics reseller fit a least-squares regression line to the resale values of 15 laptops of the same model. The laptops were between 1 and 4 years old. The regression equation, found using technology, is ŷ = 640 − 85x, where x is the age of the laptop in years and ŷ is the predicted resale value in dollars.",
    a=640, b=-85, lo=1, hi=4, x_near=3, x_far=7, eq_text='ŷ = 640 − 85x', eq_plain='640 − 85x', dp=0,
    x_name='age', y_name='resale value', x_units='years', y_units='dollars', case_a='a laptop that is', extra_n=['$385'], extra_f=['$45'])


# ------------------------------------------------------------------ 5.4
def t54(c):
    a, b, x0, y0 = c['a'], c['b'], c['x0'], c['y0']
    yh = a + b * x0; e = y0 - yh
    assert abs(e) > 1
    sgn = 'positive' if e > 0 else 'negative'; verb = 'underpredicts' if e > 0 else 'overpredicts'; ab = 'above' if e > 0 else 'below'
    yht, et = f'{yh:.1f}', num(e, 1)
    stim = c['stim']
    parts = [
        (f"For the {c['case']} {c['x_phrase']}, the observed {c['y_name']} was {y0} {c['y_units']}. Calculate the residual for this {c['unit_noun']}.",
         [('PREDICT', dict(eq_text=c['eq_text'], x0=x0, yhat_text=yht, y_units=c['y_units'], yhat_variants=[yht])),
          ('RESID_CALC', dict(y_obs=y0, yhat_text=yht, resid_text=et, y_units=c['y_units'], resid_variants=[et, f'{e:.1f}']))]),
        ("Interpret the residual you calculated in context.",
         [('RESID_SIGN', dict(sign_word=sgn, model_verb=verb, above_below=ab)),
          ('RESID_MAGNITUDE', dict(case_phrase=f"the {c['case']} {c['x_phrase']}", y_name=c['y_name'], abs_resid=f'{abs(e):.1f}', y_units=c['y_units'], above_below=ab))]),
        (f"A residual plot of the residuals against the predicted {c['y_name']} for the linear model shows {c['pattern_desc']}. What does this pattern suggest about the linear model, and what would an appropriate residual plot look like?",
         [('RESID_PLOT_CURVE', dict(pattern_text=c['pattern_text'])), ('RESID_PLOT_RANDOM', dict())]),
    ]
    model = (f"(a) ŷ = {c['eq_plain']} with x = {x0} gives ŷ = {yht} {c['y_units']}. The residual is observed minus predicted: {y0} − {yht} = {et} {c['y_units']}.\n\n"
             f"(b) The residual is {sgn}, so the model {verb} the {c['y_name']} for this {c['unit_noun']}: the observed value is {ab} the predicted value. For the {c['case']} {c['x_phrase']}, the observed {c['y_name']} is about {abs(e):.1f} {c['y_units']} {ab} the predicted value.\n\n"
             f"(c) The {c['pattern_text']} is curvature, which suggests the linear model is not the most appropriate model for the data. If the linear model were appropriate, the residual plot would show apparent randomness, with no pattern.")
    ver = f'''a = {a}
b = {b}
x0, y0 = {x0}, {y0}
yh = a + b * x0
assert abs(yh - {round(yh, 1)}) < 1e-9
e = y0 - yh
assert abs(e - {round(e, 1)}) < 1e-9
assert (e > 0) == {e > 0}
print("ALL_CHECKS_PASSED")
'''
    return assemble(c['title'], 'permitted', stim, parts, model, ver)


S54 = dict(
    title='Residuals for a Model Predicting Weekly Sales From Advertising',
    stim="A retailer fit a least-squares regression line to data from 24 weeks. The regression equation, found using technology, is ŷ = 38.4 + 7.2x, where x is the number of radio advertisements aired during the week and ŷ is the predicted weekly sales in thousands of dollars.",
    a=38.4, b=7.2, x0=5, y0=80.5, case='week', x_phrase='with 5 advertisements', y_name='weekly sales', y_units='thousand dollars', unit_noun='week',
    eq_text='ŷ = 38.4 + 7.2x', eq_plain='38.4 + 7.2x', pattern_desc='a U-shaped pattern: negative residuals for the smallest and largest predicted values and positive residuals for the middle values reversed, that is, positive at both ends and negative in the middle',
    pattern_text='U-shaped pattern')
S54['pattern_desc'] = 'a U-shaped pattern, with positive residuals at both ends and negative residuals in the middle'
V54 = dict(
    title='Residuals for a Model Predicting Exam Scores From Study Time',
    stim="A teacher fit a least-squares regression line to data from 30 students. The regression equation, found using technology, is ŷ = 48.6 + 4.1x, where x is the number of hours a student studied for the exam and ŷ is the predicted exam score in points.",
    a=48.6, b=4.1, x0=8, y0=71.0, case='student', x_phrase='who studied 8 hours', y_name='exam score', y_units='points', unit_noun='student',
    eq_text='ŷ = 48.6 + 4.1x', eq_plain='48.6 + 4.1x', pattern_desc='an arch-shaped pattern, with negative residuals at both ends and positive residuals in the middle',
    pattern_text='arch-shaped pattern')


# ------------------------------------------------------------------ 5.5
def t55(c):
    a, b, lo, hi, xb, yb, r2 = c['a'], c['b'], c['lo'], c['hi'], c['xbar'], c['ybar'], c['r2']
    assert abs(a + b * xb - yb) < 1e-9 and a > 0
    inc = 'increases' if b > 0 else 'decreases'
    pct = round(r2 * 100)
    at, ybt = num(a, 1), f'{yb:.1f}'
    sg = '+' if b > 0 else '\u2212'
    stim = c['stim']
    parts = [
        (f"Interpret the slope of the regression line in context.",
         [('SLOPE_INTERP', dict(x_unit_one=c['x_one'], y_name=c['y_name'], inc_dec=inc, b_abs=f'{abs(b):.1f}', y_units=c['y_units'], x_name=c['x_name']))]),
        ("Can the y-intercept of the regression line be given a reasonable interpretation in this context? Explain.",
         [('INTERCEPT_DEF', dict(a_text=at, y_name=c['y_name'], x_name=c['x_name'], y_units=c['y_units'])),
          ('INTERCEPT_WHY', dict(x_name=c['x_name'], lo=lo, hi=hi, x_units=c['x_units']))]),
        (f"Interpret the value of r² in context.",
         [('R2_INTERP', dict(r2_text=f'{r2:.2f}', pct=pct, y_name=c['y_name'], x_name=c['x_name']))]),
        (f"For these data the mean {c['x_name']} is x̅ = {xb:g} {c['x_units']} and the mean {c['y_name']} is ȳ = {ybt} {c['y_units']}. Show that the regression line passes through the point (x̅, ȳ).",
         [('LSRL_THROUGH_MEANS', dict(eq_text=c['eq_text'], xbar=f'{xb:g}', ybar_text=ybt, x_units=c['x_units']))]),
    ]
    model = (f"(a) For each one-{c['x_one']} increase in {c['x_name']}, the predicted {c['y_name']} {inc} by about {abs(b):.1f} {c['y_units']}.\n\n"
             f"(b) The y-intercept, {at}, is the predicted {c['y_name']} when {c['x_name']} is 0. It should not be interpreted, because {c['x_name']} = 0 is outside the interval of values used to fit the line ({lo} to {hi} {c['x_units']}); this would be extrapolation.\n\n"
             f"(c) About {pct}% of the variation in {c['y_name']} is explained by the linear relationship with {c['x_name']}.\n\n"
             f"(d) Substituting x = {xb:g} into {c['eq_text']} gives ŷ = {at} {'+' if b > 0 else '−'} {abs(b):.1f}({xb:g}) = {ybt}, which equals ȳ. So the least-squares line passes through (x̅, ȳ).")
    ver = f'''a = {a}
b = {b}
lo, hi = {lo}, {hi}
xbar, ybar = {xb}, {yb}
r2 = {r2}
assert abs(a + b * xbar - ybar) < 1e-9
assert round(r2 * 100) == {pct}
assert not (lo <= 0 <= hi)
assert round(abs(b), 1) == {abs(b):.1f}
print("ALL_CHECKS_PASSED")
'''
    return assemble(c['title'], 'permitted', stim, parts, model, ver)


S55 = dict(
    title='Interpreting a Regression Line for Hot Chocolate Sales',
    stim="A café owner recorded the outdoor temperature at noon and the number of cups of hot chocolate sold that day for 40 days when the noon temperature was between 30°F and 70°F. Technology gives the least-squares regression line ŷ = 312.4 − 3.8x, where x is the noon temperature in degrees Fahrenheit and ŷ is the predicted number of cups sold, and gives r² = 0.81.",
    a=312.4, b=-3.8, lo=30, hi=70, xbar=50, ybar=122.4, r2=0.81, x_one='degree Fahrenheit', x_name='noon temperature', y_name='number of cups sold',
    x_units='degrees Fahrenheit', y_units='cups', eq_text='ŷ = 312.4 − 3.8x')
V55 = dict(
    title='Interpreting a Regression Line for Ice Cream Sales',
    stim="A shop owner recorded the afternoon temperature and the number of ice cream cones sold that day for 36 days when the afternoon temperature was between 62°F and 96°F. Technology gives the least-squares regression line ŷ = 24.5 + 2.1x, where x is the afternoon temperature in degrees Fahrenheit and ŷ is the predicted number of cones sold, and gives r² = 0.76.",
    a=24.5, b=2.1, lo=62, hi=96, xbar=80, ybar=192.5, r2=0.76, x_one='degree Fahrenheit', x_name='afternoon temperature', y_name='number of cones sold',
    x_units='degrees Fahrenheit', y_units='cones', eq_text='ŷ = 24.5 + 2.1x')

TOPICS = [('5.1', t51, S51, V51), ('5.2', t52, S52, V52), ('5.3', t53, S53, V53), ('5.4', t54, S54, V54), ('5.5', t55, S55, V55)]
if __name__ == '__main__':
    seeds, variants, use = [], [], {}
    for code, fn, s, v in TOPICS:
        for kind, cfg, out in (('seed', s, seeds), ('variant', v, variants)):
            item, u = fn(cfg)
            out.append({'subject_key': SK, 'topic_code': code, 'item': item})
            use[f'{SK}__{code}__{kind}'] = u
        assert [[p['pattern'] for p in part] for part in use[f'{SK}__{code}__seed']] == [[p['pattern'] for p in part] for part in use[f'{SK}__{code}__variant']], code
    os.makedirs(os.path.join(HERE, 'authored'), exist_ok=True)
    json.dump(seeds, open(os.path.join(HERE, 'authored', 'seeds.json'), 'w'), indent=1, ensure_ascii=False)
    json.dump(variants, open(os.path.join(HERE, 'authored', 'variants.json'), 'w'), indent=1, ensure_ascii=False)
    json.dump(use, open(os.path.join(HERE, 'pattern_use.json'), 'w'), indent=1, ensure_ascii=False)
    print(len(seeds), 'seeds,', len(variants), 'variants; same pattern order per topic: OK')
