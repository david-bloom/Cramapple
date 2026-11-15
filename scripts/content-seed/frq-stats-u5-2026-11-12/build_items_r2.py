#!/usr/bin/env python3
"""Round 2 (r2): replace the ten seeds the checkers rated Easy in round 1, and their variants, with items that meet the
difficulty target (Medium or better at AP-exam level; no checker may rate an item Easy).
Easy in r1 (both checkers): 5.1, 5.3, 5.4, 5.5, 4.3, 4.4, 4.5, 4.6, 4.7, 4.9. Same method as r1: one template function per topic,
seed and variant = two cfgs, identical ordered pattern ids. Writes r2/authored/seeds.json, variants.json, r2/pattern_use.json."""
import json, math, os
from build_items import crit, assemble, reg, SK, HERE, num, table, HELP as HELP1  # noqa: F401
from build_items_u4 import HELP4, tcdf, tinv, ncdf, welch, sg, pfmt, decide, M  # noqa: F401

R2 = os.path.join(HERE, 'r2')
GR = 'x̄'


# ------------------------------------------------------------------ 5.1 (non-linear association, strength and a claim)
def t51(c):
    xs, ys, pk = c['xs'], c['ys'], c['pk']
    f = c['f']; assert max(abs(y - f(x)) for x, y in zip(xs, ys)) <= 0.51
    if c['kind'] == 'arch':
        assert all(ys[i] <= ys[i + 1] for i in range(pk)) and all(ys[i] >= ys[i + 1] for i in range(pk, len(ys) - 1))
    else:
        assert all(ys[i] >= ys[i + 1] for i in range(pk)) and all(ys[i] <= ys[i + 1] for i in range(pk, len(ys) - 1))
    stim = c['stim'] + '\n\n' + table(c['hx'], c['hy'], xs, ys)
    parts = [
        (f"Describe the association between {c['x_name']} and {c['y_name']} that a scatterplot of these data would show. Address form, direction and strength, in context.",
         [('SCATTER_FORM', dict(form_phrase=c['form'])),
          ('SCATTER_DIR_MIXED', dict(x_name=c['x_name'], y_name=c['y_name'], turn=c['turn'], first_dir=c['d1'], second_dir=c['d2'], x_units=c['x_units'])),
          ('SCATTER_STRENGTH', dict(strength='strong', strength_reason='all of the points lie close to one smooth curve'))]),
        (f"A classmate says, \"The association is weak, because the points do not stay close to a straight line.\" Is the classmate correct? Explain.",
         [('ERR_STRENGTH_LINE', dict(student_claim='the claim that the association is weak because the points do not stay close to a straight line'))]),
        (f"{c['claim']} {c['claim2']} For each claim, state whether the data table supports it, and justify your answer using values from the table.",
         [('SCATTER_CLAIM', dict(claim_text=c['claim_text'], claim_evidence=c['claim_evidence'])),
          ('SCATTER_CLAIM', dict(claim_text=c['claim2_text'], claim_evidence=c['claim2_evidence']))]),
    ]
    model = (f"(a) Form: the association is non-linear; the points follow a curve ({c['form_short']}). Direction: it changes; the association is {c['d1']} for {c['x_name']} below about {c['turn']} {c['x_units']} and {c['d2']} for larger values. "
             f"Strength: strong, because the points follow a single curved pattern closely.\n\n"
             f"(b) No. Strength describes how closely the points follow the general pattern, which can be curved. These points follow a curve closely, so the association is strong even though it is not close to a straight line.\n\n"
             f"(c) Claim 1: {c['claim_text']} Claim 2: {c['claim2_text']}")
    ver = HELP4 + f'''xs = {xs}
ys = {ys}
pk = {pk}
f = lambda x: {c['f_src']}
assert max(abs(y - f(x)) for x, y in zip(xs, ys)) <= 0.51
assert all(ys[i] {'<=' if c['kind'] == 'arch' else '>='} ys[i + 1] for i in range(pk))
assert all(ys[i] {'>=' if c['kind'] == 'arch' else '<='} ys[i + 1] for i in range(pk, len(ys) - 1))
{c['claim_assert']}
print("ALL_CHECKS_PASSED")
'''
    return assemble(c['title'], 'not_applicable', stim, parts, model, ver)


_xa = [0.5 + 0.5 * i for i in range(12)]
S51 = dict(title='Study Time and Test Score: Describing a Curved Association', kind='arch', xs=_xa, f=lambda x: 85 - 3.2 * (x - 3.5) ** 2,
           ys=[int(round(85 - 3.2 * (x - 3.5) ** 2)) for x in _xa], pk=6, f_src='85 - 3.2 * (x - 3.5) ** 2',
           hx='Study time (hours per day)', hy='Test score (points)', x_name='daily study time', y_name='test score', x_units='hours', turn='3.5',
           d1='positive', d2='negative', form='non-linear (a curve that rises and then falls)', form_short='rising then falling',
           stim="A teacher recorded the daily study time, in hours, and the score on a unit test, in points, for each of 12 students.",
                      claim_text="Concludes the claim is not supported: scores rise up to 3.5 hours of study (85 points) but fall for longer study times, for example 65 points at 6 hours.",
           claim_evidence="Response says the claim is not supported and cites values from the table, such as 85 points at 3.5 hours versus 65 points at 6 hours.",
           claim_assert="assert ys[11] < ys[6] and xs[11] > xs[6]\nassert max(y for x, y in zip(xs, ys) if x >= 5) < min(y for x, y in zip(xs, ys) if 2.5 <= x <= 4.5)",
           claim='Claim 1 (principal): students who study more hours per day always score higher.', claim2='Claim 2 (parent): every student who studies 5 hours or more scored lower than every student who studies from 2.5 to 4.5 hours.',
           claim2_text="Concludes Claim 2 is supported: the highest score among students who studied 5 hours or more is 78 points, which is below the lowest score (82 points) among students who studied 2.5 to 4.5 hours.",
           claim2_evidence="Response says Claim 2 is supported and shows every score at 5 hours or more (78, 72, 65) is below every score from 2.5 to 4.5 hours (82 or higher), for example by comparing the highest of the first group (78) with the lowest of the second (82).")
_xb = [30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140]
V51 = dict(title='Driving Speed and Fuel Use: Describing a Curved Association', kind='u', xs=_xb, f=lambda x: 5.8 + 0.0026 * (x - 75) ** 2,
           ys=[round(5.8 + 0.0026 * (x - 75) ** 2, 1) for x in _xb], pk=4, f_src='5.8 + 0.0026 * (x - 75) ** 2',
           hx='Speed (km per hour)', hy='Fuel use (liters per 100 km)', x_name='driving speed', y_name='fuel use', x_units='km per hour', turn='75',
           d1='negative', d2='positive', form='non-linear (a curve that falls and then rises)', form_short='falling then rising',
           stim="An engineer drove the same car at 12 steady speeds, in kilometers per hour, and recorded the fuel use, in liters per 100 kilometers, at each speed.",
                      claim_text="Concludes the claim is not supported: fuel use falls as speed increases up to about 70 to 80 km per hour (11.1 liters at 30 km per hour versus 5.9 liters at 70 km per hour) before it rises.",
           claim_evidence="Response says the claim is not supported and cites values from the table, such as 11.1 liters per 100 km at 30 km per hour versus 5.9 at 70 km per hour.",
           claim_assert="assert ys[0] > ys[4] and xs[0] < xs[4]\nassert min(y for x, y in zip(xs, ys) if x > 100) > max(y for x, y in zip(xs, ys) if 50 <= x <= 80)",
           claim='Claim 1 (driver): driving faster always increases fuel use per 100 km.', claim2='Claim 2 (engineer): every speed above 100 km per hour uses more fuel per 100 km than every speed from 50 to 80 km per hour.',
           claim2_text="Concludes Claim 2 is supported: the lowest fuel use above 100 km per hour is 9.0 liters per 100 km, which is above the highest fuel use (7.4 liters) from 50 to 80 km per hour.",
           claim2_evidence="Response says Claim 2 is supported and shows every fuel use above 100 km per hour (9.0 to 16.8) is above every fuel use from 50 to 80 km per hour (7.4 or lower), for example by comparing the lowest of the first group (9.0) with the highest of the second (7.4).")


# ------------------------------------------------------------------ 5.3 (impossible prediction; boundary classification)
def where_kind(x, lo, hi):
    if x < lo: return 'below', 'extrapolation'
    if x > hi: return 'beyond', 'extrapolation'
    if x == hi: return 'within (at the upper end of)', 'interpolation'
    if x == lo: return 'within (at the lower end of)', 'interpolation'
    return 'within', 'interpolation'


def t53(c):
    ages, a, b = c['ages'], c['a'], c['b']; lo, hi = min(ages), max(ages); xf = c['x_far']; dp = c['dp']
    yf = a + b * xf; assert yf < 0
    yt = sg(yf, dp)
    cls = []
    for x in c['xs3']:
        w, k = where_kind(x, lo, hi)
        cls.append(('EXTRAP_CLASS', dict(x0=x, kind=k, where=w, x_name=c['x_name'], lo=lo, hi=hi, x_units=c['x_units'])))
    assert [k['kind'] for _, k in cls] == c['kinds']
    stim = c['stim'].format(ages=', '.join(str(x) for x in ages), n=len(ages))
    (xp1, yp1), (xp2, yp2) = c['pts']; assert abs((yp2 - yp1) / (xp2 - xp1) - b) < 1e-9 and abs(yp1 - b * xp1 - a) < 1e-9
    parts = [
        (f"The regression line passes through the points ({xp1}, {yp1}) and ({xp2}, {yp2}). Find the equation of the regression line.",
         [('EQ_FROM_POINTS', dict(p1=f'({xp1}, {yp1})', p2=f'({xp2}, {yp2})', b_text=sg(b, dp if dp else 0) if False else (f'{b:g}'.replace('-', M)), a_text=f'{a:g}', eq_text=c['eq_text']))]),
        (f"Use the model to predict the {c['y_name']} of {c['case']} {xf} {c['x_units']} old. Is the predicted value reasonable? Explain, and say what this shows about using the model at this age.",
         [('PREDICT', dict(eq_text=c['eq_text'], x0=xf, yhat_text=yt, y_units=c['y_units'], yhat_variants=[yt])),
          ('IMPLAUSIBLE', dict(x0=xf, yhat_text=yt, y_name=c['y_name'], y_units=c['y_units'], lo=lo, hi=hi, x_units=c['x_units']))]),
        (f"The {c['seller']} also wants to use the model for {c['case_pl']} that are {c['ph'][0]}, {c['ph'][1]} and {c['ph'][2]} old. For each age, state whether using the model is interpolation or extrapolation, and explain.", cls),
    ]
    ex = '; '.join(f"{x} {c['x_units']} is {where_kind(x, lo, hi)[0]} the interval of ages used to fit the line ({lo} to {hi} {c['x_units']}), so it is {where_kind(x, lo, hi)[1]}" for x in c['xs3'])
    model = (f"(a) slope = ({yp2} − {yp1})/({xp2} − {xp1}) = {b:g}; intercept = {yp1} − ({b:g})({xp1}) = {a:g}; so {c['eq_text']}.\n\n"
             f"(b) ŷ = {c['eq_plain']} with x = {xf} gives ŷ = {yt} {c['y_units']}. A negative {c['y_name']} is impossible. The ages in the data run from {lo} to {hi} {c['x_units']}, so {xf} {c['x_units']} is far beyond them, and the linear model should not be used that far outside the data.\n\n"
             f"(c) {ex}.")
    ver = f'''ages = {ages}
a, b = {a}, {b}
lo, hi = min(ages), max(ages)
assert (lo, hi) == ({lo}, {hi})
yf = a + b * {xf}
assert abs(yf - {round(yf, dp)}) < 1e-9 and yf < 0
def kind(x):
    return 'interpolation' if lo <= x <= hi else 'extrapolation'
assert [kind(x) for x in {c['xs3']}] == {c['kinds']}
dist = [max(lo - x, x - hi, 0) for x in {c['xs3']}]
assert dist[1] == 0 and 0 < dist[0] < dist[2]
(p1x, p1y), (p2x, p2y) = {c['pts']}
assert abs((p2y - p1y) / (p2x - p1x) - b) < 1e-9 and abs(p1y - b * p1x - a) < 1e-9
print("ALL_CHECKS_PASSED")
'''
    return assemble(c['title'], 'permitted', stim, parts, model, ver)


S53 = dict(title='Limits of a Used-Car Price Model', ages=[2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 7, 7, 7, 8, 8, 9, 9], a=27.4, b=-1.9, x_far=16, xs3=[1.5, 9, 12],
           kinds=['extrapolation', 'interpolation', 'extrapolation'], pts=[(4, 19.8), (8, 12.2)], ph=['18 months', '9 years', '12 years'], order_text='9, then 1.5, then 12 years', reason_text='9 years is interpolation, while 1.5 years is extrapolation only 0.5 years below the youngest car (2 years) and 12 years is extrapolation 3 years beyond the oldest car (9 years), and predictions get less reliable the further the x-value is beyond the data', x_ref=6, dp=1, eq_text='ŷ = 27.4 − 1.9x', eq_plain='27.4 − 1.9x',
           x_name='age', y_name='asking price', x_units='years', y_units='thousand dollars', case='a car that is', case_pl='cars', seller='dealer',
           stim="A used-car dealer recorded the age, in years, of each of {n} cars of the same model and its asking price. The ages were: {ages}. The least-squares regression line, found using technology, has the form ŷ = a + bx, where x is the age in years and ŷ is the predicted asking price in thousands of dollars.")
V53 = dict(title='Limits of a Laptop Resale Model', ages=[1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4], a=640, b=-85, x_far=8, xs3=[0.5, 4, 6],
           kinds=['extrapolation', 'interpolation', 'extrapolation'], pts=[(1, 555), (3, 385)], ph=['6 months', '4 years', '6 years'], order_text='4, then 0.5, then 6 years', reason_text='4 years is interpolation, while 0.5 years is extrapolation only 0.5 years below the youngest laptop (1 year) and 6 years is extrapolation 2 years beyond the oldest laptop (4 years), and predictions get less reliable the further the x-value is beyond the data', x_ref=3, dp=0, eq_text='ŷ = 640 − 85x', eq_plain='640 − 85x',
           x_name='age', y_name='resale value', x_units='years', y_units='dollars', case='a laptop that is', case_pl='laptops', seller='reseller',
           stim="An electronics reseller recorded the age, in years, of each of {n} laptops of the same model and its resale value. The ages were: {ages}. The least-squares regression line, found using technology, has the form ŷ = a + bx, where x is the age in years and ŷ is the predicted resale value in dollars.")


# ------------------------------------------------------------------ 5.4 (all residuals, sign pattern, curvature)
def t54(c):
    xs, ys = c['xs'], c['ys']; b, a, r, _, _ = reg(xs, ys); a2, b2 = round(a, 2), round(b, 2)
    res = [y - (a2 + b2 * x) for x, y in zip(xs, ys)]
    assert min(abs(e) for e in res) >= 1.5, res
    sg_ = ['positive' if e > 0 else 'negative' for e in res]
    xa, xb = c['xa'], c['xb']; ia, ib = xs.index(xa), xs.index(xb)
    seq = ', '.join(sg_)
    assert sg_ == c['signs'], sg_
    eq = f"ŷ = {a2} {'+' if b2 > 0 else M} {abs(b2)}x"
    stim = c['stim'].format(eq=eq) + '\n\n' + table(c['hx'], c['hy'], xs, ys)

    def rc(i):
        yh = a2 + b2 * xs[i]; e = ys[i] - yh
        return ('RESID_CALC', dict(y_obs=ys[i], yhat_text=f'{yh:.2f}', resid_text=sg(e, 2), y_units=c['y_units'], resid_variants=[sg(e, 2), sg(e, 1)]))
    ea = res[ia]; sgn = sg_[ia]; verb = 'underpredicts' if ea > 0 else 'overpredicts'; ab = 'above' if ea > 0 else 'below'
    parts = [
        (f"Calculate the residuals for the observations at x = {xa} and x = {xb}.", [rc(ia), rc(ib)]),
        (f"Interpret the residual at x = {xa} in context.",
         [('RESID_SIGN_CTX', dict(sign_word=sgn, model_verb=verb, y_name=c['y_name'], case_phrase=f"{c['case_word']} with x = {xa} {c['x_unit']}", above_below=ab)),
          ('RESID_MAGNITUDE', dict(case_phrase=f"{c['case_word']} with x = {xa} {c['x_unit']}", y_name=c['y_name'], abs_resid=f'{abs(ea):.2f}', y_units=c['y_units'], above_below=ab))]),
        (f"Determine the sign of the residual for each of the seven observations. Describe the pattern in the signs as x increases, and state what it suggests about the linear model.",
         [('RESID_SEQ', dict(seq_text=seq, shape_word=c['shape_word'])),
          ('RESID_PLOT_CURVE', dict(pattern_text=c['pattern_text']))]),
    ]
    yha, yhb = a2 + b2 * xa, a2 + b2 * xb
    model = (f"(a) At x = {xa}: ŷ = {a2} {'+' if b2 > 0 else M} {abs(b2)}({xa}) = {yha:.2f}, so the residual is {ys[ia]} − {yha:.2f} = {sg(res[ia], 2)} {c['y_units']}. "
             f"At x = {xb}: ŷ = {yhb:.2f}, so the residual is {ys[ib]} − {yhb:.2f} = {sg(res[ib], 2)} {c['y_units']}.\n\n"
             f"(b) The residual at x = {xa} is {sgn}, so the model {verb} the {c['y_name']} there: the observed value is {ab} the predicted value, by about {abs(ea):.2f} {c['y_units']}.\n\n"
             f"(c) In order of x the residuals are {seq}. This is a systematic {c['shape_word']} pattern, not random scatter. It means the residual plot would show curvature, which suggests the linear model is not the most appropriate model for the data.")
    ver = HELP1 + f'''xs = {xs}
ys = {ys}
b, a, r, mx, my = reg(xs, ys)
a2, b2 = round(a, 2), round(b, 2)
assert (a2, b2) == ({a2}, {b2})
res = [y - (a2 + b2 * x) for x, y in zip(xs, ys)]
assert min(abs(e) for e in res) >= 1.5
signs = ['positive' if e > 0 else 'negative' for e in res]
assert signs == {sg_}
ia, ib = xs.index({xa}), xs.index({xb})
assert round(res[ia], 2) == {round(res[ia], 2)} and round(res[ib], 2) == {round(res[ib], 2)}
print("ALL_CHECKS_PASSED")
'''
    return assemble(c['title'], 'permitted', stim, parts, model, ver)


S54 = dict(title='Residual Pattern for a Supplement Dose and Plant Growth Model', xs=[1, 2, 3, 4, 5, 6, 7], ys=[14, 20, 27, 30, 32, 30, 19], xa=1, xb=4,
           signs=['negative', 'negative', 'positive', 'positive', 'positive', 'positive', 'negative'], case_word='group', x_unit='mg', shape_word='negative, positive, negative (arch-shaped)',
           pattern_text='arch-shaped pattern of the residuals', hx='Dose (mg)', hy='Growth (mm)', y_name='plant growth', y_units='mm',
           stim="A botanist grew seven groups of seedlings with different daily doses of a supplement and measured the mean growth of each group. The least-squares regression line, found using technology, is {eq}, where x is the dose in milligrams and ŷ is the predicted growth in millimeters. The data are shown below.")
V54 = dict(title='Residual Pattern for a Temperature and Energy Use Model', xs=[20, 30, 40, 50, 60, 70, 80], ys=[30, 24, 16, 12, 11, 14, 24], xa=20, xb=50,
           signs=None, case_word='temperature group', x_unit='°F', shape_word='positive, negative, positive (U-shaped)', pattern_text='U-shaped pattern of the residuals', hx='Mean monthly temperature (°F)',
           hy='Energy use (hundreds of kWh)', y_name='energy use', y_units='hundreds of kWh',
           stim="A utility recorded the mean monthly temperature and the mean household energy use for seven temperature groups. The least-squares regression line, found using technology, is {eq}, where x is the mean monthly temperature in degrees Fahrenheit and ŷ is the predicted energy use in hundreds of kilowatt-hours. The data are shown below.")


# ------------------------------------------------------------------ 5.5 (critique of r-squared; solve for the mean of x)
def t55(c):
    a, b, lo, hi, xb, yb, r2 = c['a'], c['b'], c['lo'], c['hi'], c['xbar'], c['ybar'], c['r2']
    assert abs(a + b * xb - yb) < 1e-9 and a > 0
    xs_ = (yb - a) / b; assert abs(xs_ - xb) < 1e-9
    inc = 'increases' if b > 0 else 'decreases'; pct = round(r2 * 100); at = num(a, 1)
    bt = ('+ ' if b > 0 else '− ') + f'{abs(b):.1f}'
    stim = c['stim']
    parts = [
        ("Interpret the slope of the regression line in context.",
         [('SLOPE_INTERP', dict(x_unit_one=c['x_one'], y_name=c['y_name'], inc_dec=inc, b_abs=f'{abs(b):.1f}', y_units=c['y_units'], x_name=c['x_name']))]),
        ("State what the y-intercept represents, and explain whether it can be given a reasonable interpretation in this context.",
         [('INTERCEPT_DEF', dict(a_text=at, y_name=c['y_name'], x_name=c['x_name'], y_units=c['y_units'])),
          ('INTERCEPT_WHY', dict(x_name=c['x_name'], lo=lo, hi=hi, x_units=c['x_units']))]),
        (f"A student writes, \"Since r² = {r2:.2f}, {c['student']}.\" Is the student's interpretation correct? Explain what r² does not measure, then give a correct interpretation of r² in context.",
         [('R2_ERR', dict(student_claim=f"the student's interpretation that {c['student']}")),
          ('R2_INTERP', dict(r2_text=f'{r2:.2f}', pct=pct, y_name=c['y_name'], x_name=c['x_name']))]),
        (f"The mean {c['y_name']} for the {c['n']} {c['unit_noun']} was {yb:.1f} {c['y_units']}. Use the regression line to find the mean {c['x_name']} for these {c['unit_noun']}.",
         [('SOLVE_XBAR', dict(ybar_text=f'{yb:.1f}', a_text=at, b_text=bt, xbar=f'{xb:g}', x_units=c['x_units'], x_name=c['x_name']))]),
    ]
    model = (f"(a) For each one-{c['x_one']} increase in {c['x_name']}, the predicted {c['y_name']} {inc} by about {abs(b):.1f} {c['y_units']}.\n\n"
             f"(b) The y-intercept, {at}, is the predicted {c['y_name']} when {c['x_name']} is 0. It should not be interpreted, because {c['x_name']} = 0 is outside the interval of values used to fit the line ({lo} to {hi} {c['x_units']}); this would be extrapolation.\n\n"
             f"(c) The student is incorrect. r² does not measure the percent of points on the line or the percent of correct predictions. About {pct}% of the variation in {c['y_name']} is explained by the linear relationship with {c['x_name']}.\n\n"
             f"(d) The line passes through (x̅, ȳ), so {yb:.1f} = {at} {bt}x̅. Solving, x̅ = {xb:g} {c['x_units']}.")
    ver = f'''a, b = {a}, {b}
lo, hi = {lo}, {hi}
ybar, r2 = {yb}, {r2}
xbar = (ybar - a) / b
assert abs(xbar - {xb}) < 1e-9
assert round(r2 * 100) == {pct} and not (lo <= 0 <= hi) and a > 0
assert round(abs(b), 1) == {abs(b):.1f}
print("ALL_CHECKS_PASSED")
'''
    return assemble(c['title'], 'permitted', stim, parts, model, ver)


S55 = dict(title='Interpreting and Critiquing a Regression Line for Hot Chocolate Sales', a=312.4, b=-3.8, lo=30, hi=70, xbar=50, ybar=122.4, r2=0.81, x_one='degree Fahrenheit',
           x_name='noon temperature', y_name='number of cups sold', x_units='degrees Fahrenheit', y_units='cups', n=40, unit_noun='days',
           student='81% of the days fall exactly on the regression line',
           stim="A café owner recorded the outdoor temperature at noon and the number of cups of hot chocolate sold that day for 40 days when the noon temperature was between 30°F and 70°F. Technology gives the least-squares regression line ŷ = 312.4 − 3.8x, where x is the noon temperature in degrees Fahrenheit and ŷ is the predicted number of cups sold, and gives r² = 0.81.")
V55 = dict(title='Interpreting and Critiquing a Regression Line for Ice Cream Sales', a=24.5, b=2.1, lo=62, hi=96, xbar=80, ybar=192.5, r2=0.76, x_one='degree Fahrenheit',
           x_name='afternoon temperature', y_name='number of cones sold', x_units='degrees Fahrenheit', y_units='cones', n=36, unit_noun='days',
           student='the regression line predicts the number of cones sold correctly on 76% of the days',
           stim="A shop owner recorded the afternoon temperature and the number of ice cream cones sold that day for 36 days when the afternoon temperature was between 62°F and 96°F. Technology gives the least-squares regression line ŷ = 24.5 + 2.1x, where x is the afternoon temperature in degrees Fahrenheit and ŷ is the predicted number of cones sold, and gives r² = 0.76.")


# ------------------------------------------------------------------ 4.3 (confidence level, individuals, sample size, claims)
def t43(c):
    n, d, s, conf = c['n'], c['dbar'], c['sd'], c['conf']; pc = int(round(conf * 100))
    ts = round(tinv(1 - (1 - conf) / 2, n - 1), 3); me = ts * s / math.sqrt(n); lo, hi = round(d - me, 2), round(d + me, 2); v = c['claim_val']
    assert lo > 0 and hi < v
    n2 = c['n_new']; ts2 = round(tinv(1 - (1 - conf) / 2, n2 - 1), 3); me2 = ts2 * s / math.sqrt(n2); ratio = me2 / me
    assert 0.45 < ratio < 0.5
    stim = c['stim'].format(lo=f'{lo:.2f}', hi=f'{hi:.2f}', pc=pc)
    parts = [
        ("Interpret the interval in context, and interpret the confidence level.",
         [('CI_INTERPRET', dict(conf=pc, lo=f'{lo:.2f}', hi=f'{hi:.2f}', units=c['units'], param_phrase=c['param_phrase'])), ('CI_LEVEL', dict(conf=pc))]),
        (f"{c['who']} makes two claims. Claim 1: {c['zero_claim']}. Claim 2: {c['big_claim']}. For each claim, state whether the interval supports it, and explain.",
         [('CI_CLAIM', dict(value='0', in_out='not in', lo=f'{lo:.2f}', hi=f'{hi:.2f}', claim_concl=f"0 is not a plausible value of the population mean difference, so the interval provides convincing evidence against Claim 1 ({c['zero_concl']})")),
          ('CI_CLAIM', dict(value=v, in_out='above', lo=f'{lo:.2f}', hi=f'{hi:.2f}', claim_concl=f"{v} is not a plausible value and every plausible value is below it, so the interval does not support Claim 2"))]),
        (f"{c['who']} also says, \"{c['indiv']}\" Is this a correct use of the interval? Explain.",
         [('CI_NOT_INDIV', dict(student_claim=c['indiv_short'], param_phrase='population mean difference'))]),
        (f"Suppose {c['who_lower']} had used a random sample of {n2} {c['unit_noun']} instead of {n}, and the sample mean difference and standard deviation were the same. How would the width of the {pc}% interval change? Give an approximate value for the new margin of error.",
         [('CI_SAMPLE_SIZE', dict(n_old=n, n_new=n2, ratio_text='half', me_text=f'{me2:.2f}', units=c['units']))]),
    ]
    model = (f"(a) We are {pc}% confident that the interval from {lo:.2f} to {hi:.2f} {c['units']} captures the {c['param_phrase']}. The confidence level means that if many random samples of the same size were taken, about {pc}% of the intervals they produce would capture the true mean difference.\n\n"
             f"(b) Claim 1: 0 is not in the interval ({lo:.2f}, {hi:.2f}), so it is not a plausible value of μ_d, and the interval provides convincing evidence against Claim 1 ({c['zero_concl']}). Claim 2: {v} is above the interval, so it is not a plausible value and every plausible value is below it; the interval does not support Claim 2.\n\n"
             f"(c) No. The interval estimates the population mean difference, not the range of individual values, so it does not describe where {pc}% of individuals fall.\n\n"
             f"(d) The interval would be narrower. The standard error s/√n would be about half as large because √{n2} is about twice √{n}, so the margin of error would be about half of {me:.2f}, roughly {me2:.2f} {c['units']}.")
    ver = HELP4 + f'''n, d, s, conf, n2 = {n}, {d}, {s}, {conf}, {n2}
ts = round(tinv(1 - (1 - conf) / 2, n - 1), 3)
me = ts * s / math.sqrt(n)
assert round(d - me, 2) == {lo} and round(d + me, 2) == {hi}
assert {lo} > 0 and {hi} < {v}
me2 = round(tinv(1 - (1 - conf) / 2, n2 - 1), 3) * s / math.sqrt(n2)
assert round(me2, 2) == {round(me2, 2)}
assert 0.45 < me2 / me < 0.5
print("ALL_CHECKS_PASSED")
'''
    return assemble(c['title'], 'permitted', stim, parts, model, ver)


S43 = dict(title='Claims and Misreadings of a Matched-Pairs Interval for 5K Times', n=20, dbar=1.35, sd=2.10, conf=0.95, units='minutes', n_new=80, claim_val=2.5, who='The coach', who_lower='the coach',
           unit_noun='runners', param_phrase='true mean improvement (before minus after) in 5K time for all runners like these after the 6-week program',
           zero_claim='the program does not change mean 5K time (μ_d = 0)', zero_concl='the program is associated with a change in mean 5K time',
           big_claim='the program improves mean 5K time by at least 2.5 minutes (μ_d ≥ 2.5)',
           indiv='95% of runners improved by between 0.37 and 2.33 minutes.', indiv_short="the coach's statement that 95% of runners improved by between 0.37 and 2.33 minutes",
           stim="A coach recorded the 5K running times of 20 randomly selected runners before and after a 6-week training program. For each runner, the difference (before minus after) in minutes was calculated; positive differences mean the runner got faster. The differences have no strong skewness and no outliers. Using technology, the coach found a {pc}% confidence interval for the population mean difference μ_d of ({lo}, {hi}) minutes.")
V43 = dict(title='Claims and Misreadings of a Matched-Pairs Interval for Blood Pressure', n=24, dbar=6.8, sd=9.6, conf=0.95, units='mmHg', n_new=96, claim_val=12, who='The pharmacist', who_lower='the pharmacist',
           unit_noun='patients', param_phrase='true mean drop (before minus after) in systolic blood pressure for all patients like these after the new medication',
           zero_claim='the medication does not change mean systolic blood pressure (μ_d = 0)', zero_concl='the medication is associated with a change in mean systolic blood pressure',
           big_claim='the medication lowers mean systolic blood pressure by at least 12 mmHg (μ_d ≥ 12)',
           indiv='95% of patients had a drop of between 2.75 and 10.85 mmHg.', indiv_short="the pharmacist's statement that 95% of patients had a drop of between 2.75 and 10.85 mmHg",
           stim="A pharmacist recorded the systolic blood pressure of 24 randomly selected patients before and after four weeks on a new medication. For each patient, the difference (before minus after) in mmHg was calculated; positive differences mean blood pressure dropped. The differences have no strong skewness and no outliers. Using technology, the pharmacist found a {pc}% confidence interval for the population mean difference μ_d of ({lo}, {hi}) mmHg.")


# ------------------------------------------------------------------ 4.4 / 4.9 (set up a test; decide whether the sample-data condition is met)
def t44(c):
    parts = [
        ("Define the parameter of interest and state the null and alternative hypotheses for the test.",
         [('PARAM_DEFINE', dict(param_sym=c['sym'], param_phrase=c['param_phrase'])), ('HYPOTHESES', dict(h0=c['h0'], ha=c['ha']))]),
        ("For the appropriate procedure, decide whether its conditions are met. Justify each decision.",
         [('COND_RANDOM', dict(rand_text=c['rand'])), ('COND_TEN', dict(ten_text=c['ten'])), ('COND_NORMAL', dict(norm_text=c['norm']))]),
        (c['q_err'], [('PROC_ERR', dict(proposed=c['proposed'], why_not=c['why_not']))]),
    ]
    model = (f"(a) {c['param_phrase'][0].upper() + c['param_phrase'][1:]}. H₀: {c['h0']} versus Hₐ: {c['ha']}.\n\n"
             f"(b) The procedure is {c['proc']}. Randomization: {c['rand']}. 10% condition: {c['ten']}. Sample-data condition: {c['norm']}.\n\n"
             f"(c) No. {c['why_not'][0].upper() + c['why_not'][1:]}.")
    ver = f'''n_small = {c['n_small']}
met = {c['met']}
assert (n_small >= 30) == {c['big']}
print("ALL_CHECKS_PASSED")
'''
    return assemble(c['title'], 'not_applicable', c['stim'], parts, model, ver)


S44 = dict(title='Is a Matched-Pairs t-Test Appropriate? Background Music and Puzzle Time', sym='μ_d', h0='μ_d = 0', ha='μ_d < 0',
           param_phrase='μ_d is the true mean difference (time without music minus time with music), in seconds, for all students at this school',
           proc='a one-sample t-test for a population mean difference (matched pairs), applied to the 15 differences',
           rand='the 15 students were randomly selected',
           ten='15 students are less than 10% of the students at the school',
           norm='the sample of differences has n = 15, which is less than 30, and its dotplot is strongly right-skewed with one outlier, so the sample-data condition is not met and the t-test is not appropriate',
           n_small=15, big=False, met=False,
           q_err='A classmate proposes a two-sample t-test that compares the mean time with music and the mean time without music for these students. Is that appropriate? Explain.',
           proposed="the classmate's two-sample t-test", why_not='each student provided both times, so the two sets of times are not independent samples; the analysis should use the 15 differences (a matched-pairs, one-sample procedure)',
           stim="A teacher suspects that background music slows students down on a puzzle task. She randomly selected 15 students from a large school. Each student completed a puzzle once with music and once without music, in a random order, and the teacher recorded each student's difference (time without music minus time with music) in seconds. The sample of 15 differences has mean −9.3 seconds and standard deviation 12.1 seconds. A dotplot of the 15 differences is strongly right-skewed with one outlier.")
V44 = dict(title='Is a Matched-Pairs t-Test Appropriate? Sleep Aid and Time to Fall Asleep', sym='μ_d', h0='μ_d = 0', ha='μ_d > 0',
           param_phrase='μ_d is the true mean difference (time to fall asleep without the sleep aid minus time with it), in minutes, for all adults in this city',
           proc='a one-sample t-test for a population mean difference (matched pairs), applied to the 12 differences',
           rand='the 12 adults were randomly selected',
           ten='12 adults are less than 10% of the adults in the city',
           norm='the sample of differences has n = 12, which is less than 30, and its dotplot is strongly left-skewed with one outlier, so the sample-data condition is not met and the t-test is not appropriate',
           n_small=12, big=False, met=False,
           q_err='A classmate proposes a two-sample t-test that compares the mean time to fall asleep with the aid and the mean time without it for these adults. Is that appropriate? Explain.',
           proposed="the classmate's two-sample t-test", why_not='each adult provided both times, so the two sets of times are not independent samples; the analysis should use the 12 differences (a matched-pairs, one-sample procedure)',
           stim="A sleep researcher suspects that a sleep aid reduces the time it takes adults to fall asleep. She randomly selected 12 adults from a large city. Each adult used the sleep aid on one night and no aid on another night, in a random order, and the researcher recorded each adult's difference (time to fall asleep without the aid minus time with it) in minutes. The sample of 12 differences has mean 4.8 minutes and standard deviation 9.6 minutes. A dotplot of the 12 differences is strongly left-skewed with one outlier.")


OP = {'<': '<', '>': '>', '≠': '!='}


def t49(c):
    parts = [
        (f"Let μ₁ be the mean for the {c['g1']} and μ₂ the mean for the {c['g2']}. Define the parameters of interest and state the null and alternative hypotheses for the test.",
         [('PARAM_DEFINE', dict(param_sym='μ₁ and μ₂', param_phrase=c['param_phrase'])), ('HYPOTHESES', dict(h0='μ₁ − μ₂ = 0', ha=f"μ₁ − μ₂ {c['ha_sym']} 0"))]),
        ("Identify the appropriate procedure, and decide whether its conditions are met. Justify each decision.",
         [('PROC_ID', dict(proc='a two-sample t-test for a difference in population means', why_proc='')), ('COND_RANDOM', dict(rand_text=c['rand'])), ('COND_TEN', dict(ten_text=c['ten'])), ('COND_NORMAL', dict(norm_text=c['norm']))]),
    ]
    model = (f"(a) {c['param_phrase'][0].upper() + c['param_phrase'][1:]}. H₀: μ₁ − μ₂ = 0 versus Hₐ: μ₁ − μ₂ {c['ha_sym']} 0.\n\n"
             f"(b) The procedure is a two-sample t-test for a difference in population means. Randomization: {c['rand']}. 10% condition: {c['ten']}. Sample-data condition: {c['norm']}.")
    ver = f'''n1, n2 = {c['n1']}, {c['n2']}
both_big = min(n1, n2) >= 30
assert both_big == {c['both_big']}
assert {c['m1']} {OP[c['ha_sym']]} {c['m2']}
print("ALL_CHECKS_PASSED")
'''
    return assemble(c['title'], 'not_applicable', c['stim'], parts, model, ver)


S49 = dict(title='Is a Two-Sample t-Test Appropriate? Onboarding Setup Times', g1='new onboarding process', g2='standard process', ha_sym='<', n1=36, n2=14, m1=21.4, m2=26.8, both_big=False,
           param_phrase='μ₁ is the true mean setup time, in minutes, of all customers who use the new onboarding process, and μ₂ is the true mean setup time of all customers who use the standard process',
           rand='the customers were selected by independent random samples from the two groups of customers',
           ten='each sample is less than 10% of the thousands of customers in its group',
           norm='one sample (n = 14) is less than 30, so both samples must show no strong skewness or outliers, but the standard-process sample has an outlier and is skewed, so the sample-data condition is not met and the two-sample t-test is not appropriate',
           stim="A software company believes its new onboarding process reduces the mean time customers need to finish setup. Thousands of customers use each process. The company independently and randomly selected 36 customers who used the new process (sample mean 21.4 minutes) and 14 customers who used the standard process (sample mean 26.8 minutes). A dotplot of the 36 new-process times has no strong skewness and no outliers. A dotplot of the 14 standard-process times is skewed right with one outlier.")
V49 = dict(title='Is a Two-Sample t-Test Appropriate? Quiz Scores for Two Study Formats', g1='practice-test format', g2='rereading format', ha_sym='>', n1=32, n2=15, m1=78.5, m2=74.1, both_big=False,
           param_phrase='μ₁ is the true mean quiz score, in points, of all students at the university who study with practice tests, and μ₂ is the true mean quiz score of all students at the university who study by rereading',
           rand='the students were selected by independent random samples from the two groups of students',
           ten='each sample is less than 10% of the thousands of students in its group',
           norm='one sample (n = 15) is less than 30, so both samples must show no strong skewness or outliers, but the rereading sample has an outlier, so the sample-data condition is not met and the two-sample t-test is not appropriate',
           stim="An instructor believes that students who study with practice tests earn a greater mean quiz score than students who study by rereading. Thousands of students at the university use each format. The instructor independently and randomly selected 32 students who use practice tests (sample mean 78.5 points) and 15 students who reread (sample mean 74.1 points). A dotplot of the 32 practice-test scores shows no strong skewness and no outliers. A dotplot of the 15 rereading scores is skewed right with one outlier.")


# ------------------------------------------------------------------ 4.5 (carry out a test; critique a conclusion; change alpha)
def t45(c):
    n, d, s, a1, a2 = c['n'], c['dbar'], c['sd'], c['alpha'], c['alpha2']
    se = s / math.sqrt(n); t = d / se; df = n - 1
    tail = 1 - tcdf(abs(t), df); p = tail if c['alt'] == 'one' else 2 * tail
    c1, d1 = decide(p, a1); c2, d2 = decide(p, a2); ps = pfmt(p); ts = sg(t, 2)
    assert d1 != d2
    concl = c['reject_concl'] if d1 == 'reject' else c['fail_concl']
    short = 'convincing evidence for Hₐ' if d1 == 'reject' else 'not convincing evidence for Hₐ'
    dtxt = sg(d, 2) if d < 0 else d
    stim = c['stim'].format(p=ps)
    parts = [
        ("Calculate the test statistic.",
         [('TEST_STAT', dict(t_formula=f"t = d̄/(s_d/√n) = {dtxt}/({s}/√{n})", t_text=ts, t_variants=[ts, f'{t:.3f}'.replace('-', M)]))]),
        ("Interpret the p-value in context.", [('P_INTERPRET', dict(p=ps, null_context=c['null_ctx'], extreme_text=c['extreme']))]),
        (f"A student writes, \"{c['student']}\" Is the student correct? Explain.",
         [('P_ERR', dict(student_claim=c['student_short'], correction=c['correction']))]),
        (f"Use the p-value to state a conclusion about the claim at significance level α = {a1}, in context. Then say whether your decision about H₀ would change at α = {a2}.",
         [('P_DECISION', dict(p=ps, alpha=a1, cmp=c1, decision=d1)), ('CONCLUDE', dict(concl_text=concl, concl_short=short)),
          ('P_DECISION', dict(p=ps, alpha=a2, cmp=c2, decision=d2))]),
    ]
    model = (f"(a) t = d̄/(s_d/√n) = {dtxt}/({s}/√{n}) = {ts}.\n\n"
             f"(b) Assuming {c['null_ctx']}, the probability of getting {c['extreme']} is about {ps}.\n\n"
             f"(c) The student is incorrect, because {c['correction']}.\n\n"
             f"(d) At α = {a1}: the p-value {ps} is {c1} α, so we {d1} H₀. {concl[0].upper() + concl[1:]}. At α = {a2}: the p-value {ps} is {c2} α, so we {d2} H₀; the decision would change.")
    ver = HELP4 + f'''n, d, s, a1, a2 = {n}, {d}, {s}, {a1}, {a2}
t = d / (s / math.sqrt(n))
assert round(t, 2) == {round(t, 2)}
tail = 1 - tcdf(abs(t), n - 1)
p = {'tail' if c['alt'] == 'one' else '2 * tail'}
assert round(p, 4) == {round(p, 4)}
assert (p < a1) == {p < a1} and (p < a2) == {p < a2} and ((p < a1) != (p < a2))
print("ALL_CHECKS_PASSED")
'''
    return assemble(c['title'], 'permitted', stim, parts, model, ver)


S45 = dict(title='Test of Mean Score Gain: Conclusions and Misconceptions', n=15, dbar=3.4, sd=4.6, alpha=0.05, alpha2=0.001, alt='one', units='points',
           extreme='a sample mean difference of 3.4 points or greater (equivalently, a test statistic of about 2.86 or greater)',
           null_ctx='the mean score gain for all students after mnemonic training is 0',
           student="There is a 0.63% chance that the null hypothesis is true.", student_short="the student's statement that there is a 0.63% chance that the null hypothesis is true",
           correction='the p-value is computed assuming the null hypothesis is true; it is the probability of a result this extreme, not the probability that the null hypothesis is true',
           reject_concl='there is convincing evidence that the mean score gain after mnemonic training is greater than 0 points for all students like these',
           fail_concl='there is not convincing evidence that the mean score gain after mnemonic training is greater than 0 points for all students like these',
           stim="A teacher randomly selected 15 students from a large school and gave each a vocabulary quiz before and after a mnemonic training session. For each student, the difference (after minus before) in quiz score was calculated. The sample of differences has mean 3.4 points and standard deviation 4.6 points, with no strong skewness and no outliers. The teacher tests H₀: μ_d = 0 versus Hₐ: μ_d > 0, where μ_d is the population mean difference (after minus before). Technology gives a p-value of {p}.")
V45 = dict(title='Test of Mean Commute Difference: Conclusions and Misconceptions', n=12, dbar=-2.9, sd=5.1, alpha=0.05, alpha2=0.10, alt='two', units='minutes',
           extreme='a sample mean difference at least 2.9 minutes away from 0 in either direction (equivalently, a test statistic at least about 1.97 away from 0)',
           null_ctx='the mean commute-time difference (route A minus route B) for all drivers is 0',
           student="Since the p-value is greater than 0.05, we have proven that the two routes have the same mean commute time.", student_short="the student's statement that the p-value proves the two routes have the same mean commute time",
           correction='failing to reject the null hypothesis means the data do not provide convincing evidence of a difference; it does not prove that the null hypothesis is true',
           reject_concl='there is convincing evidence that the mean commute-time difference (route A minus route B) is not 0 minutes for all drivers like these',
           fail_concl='there is not convincing evidence that the mean commute-time difference (route A minus route B) is not 0 minutes for all drivers like these',
           stim="A commuter randomly selected 12 drivers from a large company, and each drove both route A and route B in a random order. For each driver, the difference (route A time minus route B time) in minutes was calculated. The sample of differences has mean −2.9 minutes and standard deviation 5.1 minutes, with no strong skewness and no outliers. The commuter tests H₀: μ_d = 0 versus Hₐ: μ_d ≠ 0, where μ_d is the population mean difference (route A minus route B). Technology gives a p-value of {p}.")


# ------------------------------------------------------------------ 4.6 (direction of the difference; sample size needed)
def t46(c):
    m1, s1, n1, m2, s2, n2 = c['m1'], c['s1'], c['n1'], c['m2'], c['s2'], c['n2']
    md = m1 - m2; sd = math.sqrt(s1 ** 2 / n1 + s2 ** 2 / n2); cut = 0; z = (cut - md) / sd
    p = ncdf(z) if c['dir'] == 'less' else 1 - ncdf(z)
    tg = c['target']; n_exact = (s1 ** 2 + s2 ** 2) / tg ** 2; n_ans = math.ceil(n_exact - 1e-9)
    ne = f'{n_exact:g}' if abs(n_exact - round(n_exact)) < 1e-9 else f'{n_exact:.2f}'
    ev = f"the probability that {c['event']}"
    parts = [
        ("Find the mean and the standard deviation of the sampling distribution of x̄₁ − x̄₂, the difference between the two sample means.",
         [('DIFF_MEAN', dict(md=md, units=c['units'])), ('DIFF_SD', dict(s1=s1, n1=n1, s2=s2, n2=n2, sdd=f'{sd:.3f}', units=c['units'], sdd_variants=[f'{sd:.2f}']))]),
        ("Is the sampling distribution of x̄₁ − x̄₂ approximately normal? Justify your answer.",
         [('XBAR_SHAPE', dict(stat_name='x̄₁ − x̄₂', why=c['why'], why_short=c['why_short']))]),
        (c['q_prob'], [('XBAR_PROB', dict(event_text=ev, cut=cut, mu=md, sd=f'{sd:.3f}', z=sg(z, 2), prob=f'{p:.4f}', prob_variants=[f'{p:.3f}', f'{100*p:.2f}%']))]),
        (f"Suppose the {c['role']} instead takes independent random samples of the same size n from each {c['pop_word']}. What is the smallest n for which the standard deviation of x̄₁ − x̄₂ is at most {tg} {c['units']}?",
         [('SD_SOLVE_N', dict(target=tg, n_exact=ne, n_ans=n_ans, s1=s1, s2=s2, units=c['units']))]),
    ]
    model = (f"(a) The mean is μ₁ − μ₂ = {m1} − {m2} = {md} {c['units']}. The standard deviation is √({s1}²/{n1} + {s2}²/{n2}) = {sd:.3f} {c['units']}.\n\n"
             f"(b) Yes. The sampling distribution of x̄₁ − x̄₂ is approximately normal because {c['why']}.\n\n"
             f"(c) {c['event'][0].upper() + c['event'][1:]} means x̄₁ − x̄₂ is {c['dir']} than 0. z = (0 − {md})/{sd:.3f} = {sg(z, 2)}, so the probability is about {p:.4f}.\n\n"
             f"(d) √({s1}²/n + {s2}²/n) ≤ {tg} gives ({s1 ** 2} + {s2 ** 2})/n ≤ {tg ** 2:g}, so n ≥ {ne}. The smallest n is {n_ans}.")
    ver = HELP4 + f'''m1, s1, n1, m2, s2, n2 = {m1}, {s1}, {n1}, {m2}, {s2}, {n2}
md = m1 - m2
sd = math.sqrt(s1 ** 2 / n1 + s2 ** 2 / n2)
assert md == {md} and round(sd, 3) == {round(sd, 3)}
z = (0 - md) / sd
assert round(z, 2) == {round(z, 2)}
p = {'ncdf(z)' if c['dir'] == 'less' else '1 - ncdf(z)'}
assert round(p, 4) == {round(p, 4)}
tg = {tg}
n_ans = math.ceil((s1 ** 2 + s2 ** 2) / tg ** 2 - 1e-9)
assert n_ans == {n_ans}
assert math.sqrt((s1 ** 2 + s2 ** 2) / n_ans) <= tg < math.sqrt((s1 ** 2 + s2 ** 2) / (n_ans - 1))
print("ALL_CHECKS_PASSED")
'''
    return assemble(c['title'], 'permitted', c['stim'], parts, model, ver)


S46 = dict(title='Direction, Probability and Sample Size for a Difference in Mean Commute Times', m1=34, s1=8, n1=40, m2=30, s2=6, n2=45, dir='less', units='minutes', target=0.8, pop_word='city', role='researcher',
           event="the mean commute time of the City B sample exceeds the mean commute time of the City A sample", q_prob="Find the probability that the sample mean commute time for City B exceeds the sample mean commute time for City A.",
           stim="Commute times (in minutes) in City A have a mean of 34 and a standard deviation of 8. Commute times in City B have a mean of 30 and a standard deviation of 6. A researcher takes independent random samples of 40 commuters from City A and 45 commuters from City B, each far smaller than 10% of the commuters in its city. Let x̄₁ be the mean for City A and x̄₂ the mean for City B.",
           why='both samples are random and independent, and both sample sizes (40 and 45) are at least 30', why_short='independent random samples and both sample sizes at least 30')
V46 = dict(title='Direction, Probability and Sample Size for a Difference in Mean Delivery Times', m1=52, s1=10, n1=50, m2=47, s2=7, n2=60, dir='less', units='minutes', target=1.2, pop_word='store', role='analyst',
           event="the mean delivery time of the Store 1 sample is less than the mean delivery time of the Store 2 sample", q_prob="Find the probability that the sample mean delivery time for Store 1 is less than the sample mean delivery time for Store 2.",
           stim="Delivery times (in minutes) for Store 1 have a mean of 52 and a standard deviation of 10. Delivery times for Store 2 have a mean of 47 and a standard deviation of 7. An analyst takes independent random samples of 50 deliveries from Store 1 and 60 deliveries from Store 2, each far smaller than 10% of that store's deliveries. Let x̄₁ be the mean for Store 1 and x̄₂ the mean for Store 2.",
           why='both samples are random and independent, and both sample sizes (50 and 60) are at least 30', why_short='independent random samples and both sample sizes at least 30')
S46['dir'] = 'less'
V46['dir'] = 'less'


# ------------------------------------------------------------------ 4.7 (conservative df and a t table)
def t47(c):
    n1, m1, s1, n2, m2, s2, conf = c['n1'], c['m1'], c['s1'], c['n2'], c['m2'], c['s2'], c['conf']
    pc = int(round(conf * 100)); df = min(n1 - 1, n2 - 1); ts = round(tinv(1 - (1 - conf) / 2, df), 3)
    se = math.sqrt(s1 ** 2 / n1 + s2 ** 2 / n2); d = m1 - m2; me = ts * se; lo, hi = d - me, d + me
    _, dfw = welch(s1, n1, s2, n2); dft = round(dfw, 1); tst = round(tinv(1 - (1 - conf) / 2, dft), 3); tlo, thi = d - tst * se, d + tst * se
    assert tst < ts and tlo > lo and thi < hi
    rows = [(k, round(tinv(1 - (1 - conf) / 2, k), 3)) for k in range(df - 2, df + 3)]
    assert dict(rows)[df] == ts
    tab = f'Degrees of freedom | t* for {pc}% confidence\n' + '\n'.join(f'{k} | {v:.3f}' for k, v in rows)
    stim = c['stim'] + '\n\n' + c['tab_intro'] + '\n' + tab
    parts = [
        (f"Show that the conditions for the appropriate procedure for estimating the difference in mean {c['resp']} are met.",
         [('COND_RANDOM', dict(rand_text=c['rand'])), ('COND_TEN', dict(ten_text=c['ten'])), ('COND_NORMAL', dict(norm_text=c['norm']))]),
        (f"Use the smaller of n₁ − 1 and n₂ − 1 as the degrees of freedom and the table to find t*. Then calculate the standard error and the {pc}% confidence interval for μ₁ − μ₂.",
         [('T_CONSERVATIVE', dict(n1=n1, n2=n2, df=df, ts=f'{ts:.3f}', conf=pc)),
          ('CI_INTERVAL', dict(formula=f'({m1} − {m2}) ± {ts:.3f}√({s1}²/{n1} + {s2}²/{n2}) = {d:.1f} ± {ts:.3f}({se:.3f})', lo=sg(lo, 2), hi=sg(hi, 2), units=c['units'], tstar=f'{ts:.3f}',
                               interval_variants=[f'({sg(lo, 2)}, {sg(hi, 2)})', f'({sg(lo, 1)}, {sg(hi, 1)})']))]),
        (f"Technology gives df ≈ {dft} and t* = {tst:.3f} for {pc}% confidence, and the interval ({sg(tlo, 2)}, {sg(thi, 2)}) {c['units']}. Why is your interval from the table wider?",
         [('DF_WHY', dict(df=df, df_tech=dft, ts=f'{ts:.3f}', ts_tech=f'{tst:.3f}'))]),
    ]
    model = (f"(a) The procedure is a two-sample t-interval for a difference in population means. Randomization: {c['rand']}. 10% condition: {c['ten']}. Sample-data condition: {c['norm']}.\n\n"
             f"(b) df = smaller of ({n1} − 1, {n2} − 1) = {df}, so t* = {ts:.3f}. SE = √({s1}²/{n1} + {s2}²/{n2}) = {se:.3f} {c['units']}. The interval is ({m1} − {m2}) ± {ts:.3f}({se:.3f}) = {sg(lo, 2)} to {sg(hi, 2)} {c['units']}.\n\n"
             f"(c) The smaller df ({df}) gives a larger t* ({ts:.3f} versus {tst:.3f}) than technology's df of about {dft}, so the table interval is wider; the table method is conservative.")
    ver = HELP4 + f'''n1, m1, s1, n2, m2, s2, conf = {n1}, {m1}, {s1}, {n2}, {m2}, {s2}, {conf}
df = min(n1 - 1, n2 - 1)
assert df == {df}
ts = tinv(1 - (1 - conf) / 2, df)
assert abs(ts - {ts}) < 0.0006
for k, v in {rows}:
    assert abs(tinv(1 - (1 - conf) / 2, k) - v) < 0.0006
se = math.sqrt(s1 ** 2 / n1 + s2 ** 2 / n2)
assert round(se, 3) == {round(se, 3)}
lo = (m1 - m2) - {ts} * se; hi = (m1 - m2) + {ts} * se
assert round(lo, 2) == {round(lo, 2)} and round(hi, 2) == {round(hi, 2)}
se2, df2 = welch(s1, n1, s2, n2)
assert round(df2, 1) == {dft}
t2 = tinv(1 - (1 - conf) / 2, {dft})
assert abs(t2 - {tst}) < 0.0006 and t2 < {ts}
assert round((m1 - m2) - {tst} * se, 2) == {round(tlo, 2)} and round((m1 - m2) + {tst} * se, 2) == {round(thi, 2)}
print("ALL_CHECKS_PASSED")
'''
    return assemble(c['title'], 'permitted', stim, parts, model, ver)


S47 = dict(title='Interval for a Difference in Mean Exam Scores Using a t Table', n1=32, m1=78.4, s1=11.2, n2=35, m2=72.1, s2=9.8, conf=0.95, units='points', resp='exam score',
           tab_intro='A t table gives these critical values:',
           stim="A district compares a common end-of-year exam at two schools. Independent random samples were taken: 32 students from School 1 (mean 78.4, standard deviation 11.2) and 35 students from School 2 (mean 72.1, standard deviation 9.8). Each sample is less than 10% of its school's students.",
           rand='the students were selected by independent random samples from the two schools', ten='each sample is less than 10% of the students at its school', norm='both sample sizes (32 and 35) are at least 30')
V47 = dict(title='Interval for a Difference in Mean Seedling Heights Using a t Table', n1=18, m1=14.6, s1=3.1, n2=22, m2=12.9, s2=2.8, conf=0.95, units='centimeters', resp='seedling height',
           tab_intro='A t table gives these critical values:',
           stim="A botanist compares two large greenhouses. Independent random samples of seedlings were measured: 18 seedlings from Greenhouse A (mean height 14.6 cm, standard deviation 3.1 cm) and 22 seedlings from Greenhouse B (mean height 12.9 cm, standard deviation 2.8 cm). Each greenhouse holds thousands of seedlings. Dotplots of both samples show no strong skewness and no outliers.",
           rand='the seedlings were selected by independent random samples from the two greenhouses', ten='each sample is less than 10% of the seedlings in its greenhouse',
           norm='both sample sizes are less than 30, but the dotplots of both samples show no strong skewness and no outliers')

TOPICS = [('5.1', t51, S51, V51), ('5.3', t53, S53, V53), ('5.4', t54, S54, V54), ('5.5', t55, S55, V55),
          ('4.3', t43, S43, V43), ('4.4', t44, S44, V44), ('4.5', t45, S45, V45), ('4.6', t46, S46, V46), ('4.7', t47, S47, V47), ('4.9', t49, S49, V49)]
if __name__ == '__main__':
    # derive the 5.4 U-shaped variant's expected sign pattern from its own data
    b_, a_, *_ = reg(V54['xs'], V54['ys']); a2_, b2_ = round(a_, 2), round(b_, 2)
    V54['signs'] = ['positive' if y - (a2_ + b2_ * x) > 0 else 'negative' for x, y in zip(V54['xs'], V54['ys'])]
    seeds, variants, use = [], [], {}
    for code, fn, s, v in TOPICS:
        for kind, cfg, out in (('seed', s, seeds), ('variant', v, variants)):
            item, u = fn(cfg)
            out.append({'subject_key': SK, 'topic_code': code, 'item': item})
            use[f'{SK}__{code}__{kind}'] = u
        assert [[p['pattern'] for p in part] for part in use[f'{SK}__{code}__seed']] == [[p['pattern'] for p in part] for part in use[f'{SK}__{code}__variant']], code
    os.makedirs(os.path.join(R2, 'authored'), exist_ok=True)
    json.dump(seeds, open(os.path.join(R2, 'authored', 'seeds.json'), 'w'), indent=1, ensure_ascii=False)
    json.dump(variants, open(os.path.join(R2, 'authored', 'variants.json'), 'w'), indent=1, ensure_ascii=False)
    json.dump(use, open(os.path.join(R2, 'pattern_use.json'), 'w'), indent=1, ensure_ascii=False)
    print(len(seeds), 'r2 seeds,', len(variants), 'variants; same pattern order per topic: OK')
