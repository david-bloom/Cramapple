#!/usr/bin/env python3 -I
"""Rubric (and, for apchem-frq-l-026 only, prompt) repair plan for the 4 rubric_preflight_failure items. Owner: "Yes, all four" (2026-11-13). Offline: reads rubric_held_full.json, writes plan.json."""
import json, os, copy, re
HERE = os.path.dirname(os.path.abspath(__file__))
rows = {r['content_key']: r for r in json.load(open(os.path.join(HERE, 'rubric_held_full.json')))}
def setc(crit, key, text=None, ev=None, fix=None, pts=None):
    c = crit[key]
    if text is not None: c['learner_facing_text'] = text
    if ev is not None: c['evidence_requirements'] = ev
    if fix is not None: c['minimum_fix'] = fix
    if pts is not None: c['points_possible'] = pts
def addc(crit, key, text, ev, fix, pts):
    crit[key] = {'criterion_key': key, 'learner_facing_text': text, 'evidence_requirements': ev, 'minimum_fix': fix, 'points_possible': pts, 'accepted_variants': [], 'judgement_kind': 'text'}
plan = []
for ck, r in rows.items():
    crit = {c['criterion_key']: copy.deepcopy(c) for c in r['crit']}
    stem = r['stem']; ca1 = r['canonical_answer_1']; expl = r['explanation']
    if ck == 'apcalcab-frq-017':
        setc(crit, 'part-c-criterion-4', 'Concludes that the amount of water is greatest at t≈4.443 minutes, supported by the comparison of candidate times (also stating the maximum amount, about 107.953 liters, is acceptable but not required).',
             'Response names t≈4.443 minutes as the time of greatest amount, linked to the comparison of the interior candidate with t=0 and t=6.', 'State the conclusion the question asks for: the amount of water is greatest at t≈4.443 minutes.')
        ca1 = ca1.replace('Concludes the maximum amount is approximately 107.953 liters at t≈4.443.', 'Concludes the amount of water is greatest at t≈4.443 minutes (maximum about 107.953 liters).')
    elif ck == 'apcalcab-frq-036':
        setc(crit, 'part-c-criterion-1', 'Sets up a correct integral for the volume about the y-axis: washers in y, π∫₀⁴[(√y)²−(y/2)²]dy, or cylindrical shells, 2π∫₀²x(2x−x²)dx.',
             'Response gives a correct integral for the y-axis revolution, either washers in y (outer radius √y, inner radius y/2, limits 0 to 4) or shells (radius x, height 2x−x², limits 0 to 2).',
             'Set up the y-axis volume as washers in y, π∫₀⁴[(√y)²−(y/2)²]dy, or as shells, 2π∫₀²x(2x−x²)dx.')
        ca1 = ca1.replace('Uses cylindrical shells 2π∫₀²x(2x−x²)dx.', 'Uses washers in y, π∫₀⁴[(√y)²−(y/2)²]dy, or cylindrical shells 2π∫₀²x(2x−x²)dx.')
    elif ck == 'apchem-frq-l-023':
        setc(crit, 'a3', 'Substitutes the equilibrium concentrations into the expression and evaluates Kc = (0.800)²/[(0.200)²(0.100)] = 160.', 'Response shows the three concentrations substituted into the expression and obtains Kc = 160 (units not required).',
             'Substitute [SO3] = 0.800 M, [SO2] = 0.200 M and [O2] = 0.100 M into the expression and evaluate Kc = 160.', 2)
        setc(crit, 'a4', 'Interprets Kc = 160 as a product-favored equilibrium, and separately uses this mixture\'s concentrations to show it holds far more SO3 than SO2 or O2, without claiming that Kc alone fixes the composition of every mixture.',
             'Response states that Kc much greater than 1 means product-favored, and cites this mixture\'s actual concentrations (0.800 M SO3 versus 0.200 M SO2 and 0.100 M O2); does not claim every mixture with this Kc is mostly product.',
             'Say product-favored from Kc = 160, then support the conclusion about this particular mixture from the stated concentrations.', 2)
        setc(crit, 'a5', 'Predicts that adding O2 shifts the equilibrium toward products (to the right), explained with Le Chatelier\'s principle or with Q < K after the addition, without recalculating Kc.',
             'Response gives the direction (toward SO3) and a Le Chatelier or Q-versus-K reason.', 'State the shift direction (toward products) and give the Le Chatelier or Q < K reason.', 2)
        addc(crit, 'a6', 'States that Kc does not change after the concentration disturbance at constant temperature.', 'Response says Kc is unchanged because temperature is constant.', 'State that Kc is unchanged at constant temperature.', 1)
    elif ck == 'apchem-frq-l-026':
        stem = stem.replace('(d) Calculate the new pH of the solution after the HCl is added.',
            '(d) Without calculating a new pH, use the amounts of NH3 and NH4+ before and after the HCl is added to predict whether the pH changes noticeably from the value in part (b). Justify your prediction.')
        stem = stem.replace('(f) Instead of HCl, suppose 0.020 mol of NaOH(aq) is added to the original 1.00 L buffer. Calculate the new pH.',
            '(f) Instead of HCl, suppose 0.020 mol of NaOH(aq) is added to the original 1.00 L buffer. Identify which buffer component reacts, state the new amounts of NH3 and NH4+, and predict the direction and approximate size of the pH change.')
        assert stem != r['stem'] and '(d) Without' in stem and '(f) Instead' in stem and 'Calculate the new pH' not in stem
        setc(crit, 'a1', 'Correctly calculates Ka(NH4+) = Kw/Kb ≈ 5.6 × 10^-10.', 'Response divides Kw by Kb to obtain Ka ≈ 5.6 × 10^-10.', 'Calculate Ka(NH4+) = Kw/Kb = (1.0 × 10^-14)/(1.8 × 10^-5).')
        setc(crit, 'b1', 'Applies the Henderson-Hasselbalch equation, pH = pKa + log([base]/[acid]), with pKa = -log Ka ≈ 9.25 and [NH3] as the base and [NH4+] as the acid.',
             'Response converts Ka to pKa ≈ 9.25 and applies pH = pKa + log([NH3]/[NH4+]) with NH3 as the base.', 'Convert Ka to pKa and apply the Henderson-Hasselbalch equation with NH3 as the base and NH4+ as the acid.')
        setc(crit, 'd1', 'Correctly updates moles after the HCl: NH3 decreases from 0.30 to 0.28 mol and NH4+ increases from 0.25 to 0.27 mol.', 'Response gives 0.28 mol NH3 and 0.27 mol NH4+.', 'Subtract 0.020 mol from NH3 and add 0.020 mol to NH4+.')
        setc(crit, 'd2', 'Predicts that the pH decreases only slightly (stays close to the part (b) value) because the NH3 to NH4+ ratio changes only from about 1.2 to about 1.04.',
             'Response concludes the pH changes little and falls slightly, tied to the small change in the NH3/NH4+ ratio.', 'State that the pH falls only slightly because the NH3/NH4+ ratio changes little.')
        setc(crit, 'f1', 'Correctly updates the amounts after the NaOH (NH4+ = 0.23 mol, NH3 = 0.32 mol), identifies NH4+ as the component that reacts, and predicts that the pH rises slightly because the NH3/NH4+ ratio increases from about 1.2 to about 1.39.',
             'Response gives 0.23 mol NH4+ and 0.32 mol NH3, names NH4+ as the reacting component, and states the pH rises slightly.', 'Subtract 0.020 mol from NH4+, add 0.020 mol to NH3, and say the pH rises slightly.')
        setc(crit, 'c1', 'Writes the net ionic equation NH3 + H+ -> NH4+ (or NH3 + H3O+ -> NH4+ + H2O).', 'Credits either the H+ or the H3O+ form of the net ionic equation.', 'Write the net ionic equation for NH3 reacting with H+ (or H3O+).')
        setc(crit, 'c2', 'Explains specifically that the conjugate base, NH3, consumes the added H+ by reacting with it directly to form NH4+, rather than describing the buffer only as resisting pH change without naming the reacting species.', 'Response names NH3 as the species that reacts with the added H+ and NH4+ as what it becomes.', 'Name NH3 as the reacting species and NH4+ as the product, instead of only saying the buffer resists change.')
        ca1 = re.sub(r'\(d\) After adding.*?(?=\n\(e\))', '(d) After adding 0.020 mol HCl: mol NH3 decreases from 0.30 to 0.28 mol; mol NH4+ increases from 0.25 to 0.27 mol. The NH3/NH4+ ratio changes only from 1.2 to about 1.04, so the pH decreases only slightly from 9.33.', ca1, flags=re.S)
        ca1 = re.sub(r'\(f\) .*?(?=\n\(g\))', '(f) NH4+ reacts with the added OH-: NH4+ = 0.25 - 0.02 = 0.23 mol, NH3 = 0.30 + 0.02 = 0.32 mol. The ratio rises from 1.2 to about 1.39, so the pH rises slightly from 9.33.', ca1, flags=re.S)
        assert '(d) After adding 0.020 mol HCl: mol NH3' in ca1 and '9.39' not in ca1, ca1
    else: raise SystemExit(ck)
    pj = copy.deepcopy(r['prompt_json']); old_total = sum(c['points_possible'] for c in r['crit'])
    pj['content_version'] = r['version_num'] + 1
    pj['qa_remediation'] = '2026-11-13 rubric preflight repair (APPROVAL-0277)' + ('; prompt parts (d) and (f) rewritten as qualitative reasoning because the CED excludes computing pH change on adding acid or base to a buffer' if ck == 'apchem-frq-l-026' else ': criteria aligned to the operations the prompt asks')
    new_total = sum(c['points_possible'] for c in crit.values()); assert new_total == old_total == r['prompt_json'].get('total_points', old_total) or ck.startswith('apchem'), (ck, old_total, new_total)
    assert new_total == old_total, ck
    plan.append({'content_key': ck, 'old_version_id': r['vid'], 'old_version_num': r['version_num'], 'stem': stem, 'stimulus': r['stimulus'], 'canonical_answer_1': ca1, 'prompt_json': pj,
                 'criteria': [crit[k] for k in sorted(crit)], 'old_total': old_total, 'new_total': new_total, 'stem_changed': stem != r['stem']})
json.dump(plan, open(os.path.join(HERE, 'plan.json'), 'w'), indent=1, ensure_ascii=False)
for p in plan: print(p['content_key'], p['old_total'], '->', p['new_total'], 'stem_changed', p['stem_changed'], 'criteria', len(p['criteria']))
