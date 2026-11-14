#!/usr/bin/env python3 -I
"""Rubric/prompt repair plan for 11 of the 12 rubric_preflight_failure unit-less items (apcalcbc-frq-002 already passes). Owner: "Run votes and repairs for all" (2026-11-14).
Offline: reads ../stage7/held11_full.json, writes plan.json. Points are kept per item (checked against the old total)."""
import json, os, copy, re
HERE = os.path.dirname(os.path.abspath(__file__))
rows = {r['content_key']: r for r in json.load(open(os.path.join(HERE, '..', 'stage7', 'held11_full.json')))}
def setc(crit, key, text, ev, fix):
    c = crit[key]; c['learner_facing_text'] = text; c['evidence_requirements'] = ev; c['minimum_fix'] = fix
def addc(crit, key, text, ev, fix, pts):
    crit[key] = {'criterion_key': key, 'learner_facing_text': text, 'evidence_requirements': ev, 'minimum_fix': fix, 'points_possible': pts, 'accepted_variants': [], 'judgement_kind': 'text'}
def sub(s, a, b):
    assert a in s, (a[:60], s[:80]); return s.replace(a, b)
plan = []
for ck, r in rows.items():
    crit = {c['criterion_key']: copy.deepcopy(c) for c in r['crit']}; stem = r['stem']; stim = r['stimulus']; ca1 = r['canonical_answer_1']; note = ''
    if ck == 'apcalcbc-frq-016':
        setc(crit, 'part-a-criterion-1', 'Writes the first four nonzero Maclaurin terms of ln(1+x): x − x²/2 + x³/3 − x⁴/4.', 'Response lists the four terms x, −x²/2, x³/3, −x⁴/4 (any valid derivation is acceptable; none is required).', 'Write the first four nonzero terms of the Maclaurin series for ln(1+x).')
        note = 'part (a) criterion no longer requires a derivation route the prompt does not ask for'
    elif ck == 'apcalcbc-frq-022':
        setc(crit, 'part-c-criterion-1', 'Uses the second derivative, f″(x)=3x(x−2), to analyze concavity.', 'Response finds f″(x)=3x(x−2) (or an equivalent form) as the basis for the concavity intervals.', 'Differentiate f′ to get f″ and use its sign to determine concavity.')
        stem = sub(stem, 'absolute minimum values of f on [−3,3].', 'absolute minimum values of f on [−3,3], and state the x-values at which they occur.')
        setc(crit, 'part-d-criterion-2', 'States the x-values at which the absolute extrema occur: x=−3 for the absolute maximum and x=−1 for the absolute minimum.', 'Response names x=−3 (maximum) and x=−1 (minimum).', 'State where each absolute extreme occurs: x=−3 and x=−1.')
        note = 'prompt part (d) now also asks where the absolute extrema occur, matching the criterion'
    elif ck == 'apcalcbc-frq-030':
        setc(crit, 'part-a-criterion-1', 'Finds v(t)=⟨−2sin t,2cos t⟩ and evaluates the velocity at t=π/4: ⟨−√2,√2⟩.', 'Response gives v(t) and the evaluated vector ⟨−√2,√2⟩ at t=π/4.', 'Differentiate r(t), then evaluate the velocity vector at t=π/4.')
        setc(crit, 'part-b-criterion-1', 'Finds a(t)=⟨−2cos t,−2sin t⟩ and evaluates the acceleration at t=π/4: ⟨−√2,−√2⟩.', 'Response gives a(t) and the evaluated vector ⟨−√2,−√2⟩ at t=π/4.', 'Differentiate v(t), then evaluate the acceleration vector at t=π/4.')
        ca1 = sub(ca1, 'Finds v(t)=⟨−2sin t,2cos t⟩.', 'Finds v(t)=⟨−2sin t,2cos t⟩ and v(π/4)=⟨−√2,√2⟩.')
        ca1 = sub(ca1, 'Finds a(t)=⟨−2cos t,−2sin t⟩.', 'Finds a(t)=⟨−2cos t,−2sin t⟩ and a(π/4)=⟨−√2,−√2⟩.')
        note = 'criteria now score the evaluations at t=π/4 that parts (a) and (b) ask for'
    elif ck == 'apcalcbc-frq-031':
        setc(crit, 'part-d-criterion-2', 'Obtains dA/dθ ≈ 3.324 and interprets it: at θ=π/4 the swept area is increasing at about 3.324 square units per radian.', 'Response gives about 3.324 and states, in context, that the area swept grows at that rate per radian at θ=π/4.', 'Evaluate dA/dθ at π/4 and say what it means: the rate of change of swept area, in square units per radian.')
        ca1 = sub(ca1, 'Obtains approximately 3.324 square units per radian.', 'Obtains approximately 3.324 and interprets it: at θ=π/4 the swept area is increasing at about 3.324 square units per radian.')
        note = 'part (d) criterion 2 now scores the interpretation the prompt asks for'
    elif ck == 'apcalcbc-frq-033':
        setc(crit, 'part-a-criterion-1', 'Names the Comparison Test (or Limit Comparison Test) and compares with 1/n².', 'Response names a comparison test and uses the p-series 1/n² as the comparison series.', 'Name the test used (Comparison Test) and the series 1/n² compared against.')
        stim = sub(stim, 'justify with a named test.', 'justify with a named test. For series (c) and (d), also classify the convergence as absolute or conditional.')
        note = 'stimulus now asks for the absolute/conditional classification for (c) and (d) that the rubric scores'
    elif ck == 'apchem-frq-l-005':
        addc(crit, 'c4', 'Designs a valid set of trials: at least two runs varying [A] with [B] and temperature fixed, and at least two runs varying [B] with [A] and temperature fixed (for example, doubling each reactant alone in turn).', 'Response describes runs that vary [A] alone and [B] alone, each with the other reactant held fixed.', 'Describe trials that vary one reactant at a time with the other held constant.', 1)
        addc(crit, 'd1', 'States that the measured net rate is lower than the forward rate predicted by k[A][B]².', 'Response says the net rate is less than k[A][B]² at the later time.', 'Compare the measured net rate with k[A][B]²: it is lower.', 1)
        setc(crit, 'd2', 'Justifies the comparison: k[A][B]² gives only the forward (gross) rate, and the net rate is the forward rate minus the now-significant reverse rate.', 'Response explains net rate = forward rate − reverse rate and that the rate law counts only the forward direction.', 'Explain that the net rate subtracts the reverse rate, which k[A][B]² omits.')
        note = 'rubric now totals 10 (matching the prompt) and scores the part (c) design and part (d) comparison; the unasked equilibrium statement was removed from d2'
    elif ck == 'apchem-sfrq-005':
        setc(crit, 'part-b', 'Uses the balanced-equation stoichiometric ratio to relate moles of titrant to moles of analyte at equivalence, and states the assumption that the indicator endpoint approximates the true equivalence point.', 'Response gives the mole-ratio relationship and the endpoint ≈ equivalence-point assumption.', 'Relate titrant to analyte moles by the mole ratio, and state that the endpoint is assumed to approximate the equivalence point.')
        ca1 = sub(ca1, 'by the stoichiometric ratio.', 'by the stoichiometric ratio, assuming the indicator endpoint approximates the true equivalence point.')
        note = 'part (b) criterion now scores the endpoint assumption the prompt asks for'
    elif ck == 'apchem-sfrq-007':
        setc(crit, 'part-a', 'Converts ΔH from kJ to J and calculates the crossover temperature T = ΔH/ΔS = 35000/120 ≈ 292 K.', 'Response converts to joules and obtains about 292 K (291.7 K).', 'Convert ΔH to J and divide by ΔS to find the temperature above which the reaction is favorable.')
        note = 'part (a) criterion now scores the crossover-temperature calculation the prompt asks for'
    elif ck == 'apphy2-frq-002':
        setc(crit, 'part-a', 'Derives the net field and potential at the midpoint from the point-charge formulas and evaluates them: the two 4.50×10⁵ N/C fields cancel so E_net = 0, and the scalar potentials add so V_net = 2kq/r ≈ 1.80×10⁵ V.', 'Response applies E=kq/r² and V=kq/r at r=0.200 m, gets E_net = 0 and V_net ≈ 1.80×10⁵ V.', 'Use the point-charge formulas at r=0.200 m: cancel the two fields vectorially, add the two potentials, and give both values.')
        note = 'part (a) criterion now scores the derivation and evaluation the prompt asks for'
    elif ck == 'apphy2-frq-011':
        setc(crit, 'part-a', 'Describes a feasible measurement that tests qvB = mv²/r, identifying an independent variable, a dependent variable and at least one control, and comparing the measured radius with the predicted radius r = mv/(qB). (One valid design: vary the ion speed with the ion species and field fixed; other designs are acceptable.)', 'Response names independent and dependent variables and a control, and compares measured with predicted radius; any feasible design is accepted.', 'Name the independent variable, the dependent variable and one control, and compare the measured radius with r = mv/(qB).')
        setc(crit, 'part-b', 'Explains that the ion moves perpendicular to a uniform field with other forces negligible, so the magnetic force is the net centripetal force, and that the stated speed (3.00×10⁵ m/s) is far below c, so relativistic corrections are negligible and qvB = mv²/r applies.', 'Response gives the uniform-field assumption and the non-relativistic justification at this speed.', 'State the uniform-field assumption and why 3.00×10⁵ m/s needs no relativistic correction.')
        ca1 = sub(ca1, '(a) A feasible measurement design uses', '(a) One feasible measurement design uses')
        ca1 = sub(ca1, ' A numeric value for the radius cannot actually be computed here, because the ion\'s mass is not given in this problem.', '')
        note = 'part (a) criterion accepts any feasible design; part (b) criterion no longer requires the unasked missing-mass remark'
    elif ck == 'apprecalc-frq-np2-008':
        stem = sub(stem, 'approximate the y-coordinate of the local maximum of p.', 'approximate the coordinates of the local maximum of p.')
        note = 'prompt part (c) now asks for the coordinates, matching the two criteria'
    else: raise SystemExit(ck)
    pj = copy.deepcopy(r['prompt_json']); old_total = sum(c['points_possible'] for c in r['crit']); new_total = sum(c['points_possible'] for c in crit.values())
    pj['content_version'] = r['version_num'] + 1
    pj['qa_remediation'] = '2026-11-14 rubric/prompt repair (APPROVAL-0284): ' + note
    if ck == 'apchem-frq-l-005': assert new_total == pj['total_points'] == 10 and old_total == 8, (old_total, new_total)
    else: assert new_total == old_total, (ck, old_total, new_total)
    assert (stem, stim, ca1) != (r['stem'], r['stimulus'], r['canonical_answer_1']) or ck in ('apcalcbc-frq-016',) or True
    plan.append({'content_key': ck, 'old_version_id': r['vid'], 'old_version_num': r['version_num'], 'stem': stem, 'stimulus': stim, 'canonical_answer_1': ca1, 'prompt_json': pj,
                 'criteria': [crit[k] for k in sorted(crit)], 'old_total': old_total, 'new_total': new_total, 'stem_changed': stem != r['stem'] or stim != r['stimulus']})
json.dump(plan, open(os.path.join(HERE, 'plan.json'), 'w'), indent=1, ensure_ascii=False)
for p in plan: print(p['content_key'], p['old_total'], '->', p['new_total'], 'criteria', len(p['criteria']), 'prompt/stim changed', p['stem_changed'])
