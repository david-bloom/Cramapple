#!/usr/bin/env python3 -I
"""Repair plan for the two items left unlabeled in APPROVAL-0281. Owner: "Repair both and label them" (2026-11-14). Offline: reads held_full.json, writes plan.json.
 apcalcab-frq-035: Euler's method (CED 7.5, BC-only) removed from an AB item; replaced by AB-scope concavity (second derivative) and tangent-line comparison. 9 points kept.
 apchem-sfrq-035: parts (b),(c) no longer compute a new pH after adding acid to a buffer (CED 8.9 exclusion); they ask for new amounts, the new ratio and the direction of change. 4 points kept."""
import json, os, copy
HERE = os.path.dirname(os.path.abspath(__file__))
rows = {r['content_key']: r for r in json.load(open(os.path.join(HERE, 'held_full.json')))}
def setc(crit, key, text, ev, fix):
    c = crit[key]; c['learner_facing_text'] = text; c['evidence_requirements'] = ev; c['minimum_fix'] = fix
plan = []
for ck, r in rows.items():
    crit = {c['criterion_key']: copy.deepcopy(c) for c in r['crit']}
    stem = r['stem']; ca1 = r['canonical_answer_1']
    if ck == 'apcalcab-frq-035':
        stem = stem.replace("(b) Use Euler's method with step size 0.5 to estimate y(1).", "(b) Find d²y/dx² in terms of x and y, and use it to determine whether the solution curve is concave up or concave down at x=0.")
        stem = stem.replace("(d) Find y(1) exactly and compare it with the Euler estimate.", "(d) Find y(1) exactly. Then use the tangent line from part (a) to approximate y(1), and state whether this approximation is an underestimate or an overestimate of y(1).")
        assert "Euler" not in stem and "d²y/dx²" in stem and "overestimate" in stem
        setc(crit, 'part-b-criterion-1', 'Differentiates dy/dx=2x/(1+y) with respect to x to get d²y/dx² = 2/(1+y) − 4x²/(1+y)³ (any equivalent form, including one that still contains dy/dx, such as [2(1+y) − 2x·dy/dx]/(1+y)²).',
             'Response shows a correct second derivative, using the quotient rule with the chain rule on y.', 'Differentiate 2x/(1+y) with the quotient rule, treating y as a function of x, and give d²y/dx².')
        setc(crit, 'part-b-criterion-2', 'Evaluates d²y/dx² at (0,1) to get 1, which is positive, and concludes the solution curve is concave up at x=0.',
             'Response substitutes x=0, y=1 into its second derivative and states concave up because the value is positive.', 'Evaluate d²y/dx² at (0,1) and state that a positive value means concave up.')
        setc(crit, 'part-d-criterion-2', 'Uses the tangent line y=1 from part (a) to get the approximation 1 at x=1, and concludes it is an underestimate because 1 < √6−1 ≈ 1.449 (consistent with the curve being concave up near x=0).',
             'Response gives the tangent-line value 1 at x=1, compares it with y(1)=√6−1≈1.449, and says underestimate.', 'Evaluate the tangent line at x=1, compare it with the exact y(1), and say underestimate.')
        ca1 = ca1.replace('Finds y(0.5)=1 and then uses slope 0.5 at (0.5,1). | Obtains y(1)≈1.25.', 'Finds d²y/dx² = 2/(1+y) − 4x²/(1+y)³. | At (0,1), d²y/dx² = 1 > 0, so the curve is concave up at x=0.')
        ca1 = ca1.replace('Notes √6−1≈1.449 exceeds 1.25.', 'The tangent line y=1 gives 1 at x=1, an underestimate since 1 < √6−1 ≈ 1.449.')
        assert 'Euler' not in ca1 and '1.25' not in ca1 and 'concave up' in ca1 and 'underestimate' in ca1, ca1
        note = "prompt parts (b) and (d) rewritten: Euler's method (CED 7.5, BC-only) removed from an AB item; replaced by concavity from the second derivative and a tangent-line comparison"
    elif ck == 'apchem-sfrq-035':
        stem = stem.replace('(b) Calculate the new pH of Buffer A after the HCl is added.', '(b) Without calculating a new pH, determine the amounts of CH3COOH and CH3COO- in Buffer A after the HCl is added, and use the new CH3COO-/CH3COOH ratio to predict whether the pH rises or falls.')
        stem = stem.replace('(c) Calculate the new pH of Buffer B after the HCl is added.', '(c) Do the same for Buffer B: determine the new amounts of CH3COOH and CH3COO-, and use the new ratio to predict whether the pH rises or falls.')
        stem = stem.replace('(d) Based on your results,', '(d) Based on your results in parts (b) and (c),')
        assert 'Calculate the new pH' not in stem and '(b) Without' in stem and '(c) Do the same' in stem and 'parts (b) and (c)' in stem
        setc(crit, 'part-b', "Correctly updates Buffer A's amounts (0.090 mol CH3COO- and 0.11 mol CH3COOH), finds the CH3COO-/CH3COOH ratio falls from 1.0 to about 0.82, and predicts the pH falls.",
             'Response gives 0.090 mol CH3COO- and 0.11 mol CH3COOH, a ratio of about 0.82, and says the pH decreases; no pH value is required.', 'Subtract 0.010 mol from CH3COO- and add it to CH3COOH, find the new ratio, and say the pH falls.')
        setc(crit, 'part-c', "Correctly updates Buffer B's amounts (0.99 mol CH3COO- and 1.01 mol CH3COOH), finds the ratio falls only from 1.0 to about 0.98, and predicts the pH falls only very slightly.",
             'Response gives 0.99 mol CH3COO- and 1.01 mol CH3COOH, a ratio of about 0.98, and says the pH decreases very slightly; no pH value is required.', 'Subtract 0.010 mol from CH3COO- and add it to CH3COOH, find the new ratio, and say the pH falls only very slightly.')
        setc(crit, 'part-d', 'Correctly identifies Buffer B as having the greater buffer capacity, explaining that because it holds much larger amounts of CH3COO- (which reacts with the added H+) and of CH3COOH (which reacts with any added base), the same 0.010 mol addition changes the CH3COO-/CH3COOH ratio, and therefore the pH, much less than it does in the more dilute Buffer A.',
             'Response identifies Buffer B and links the larger reserve of conjugate base (which reacts with the added H+) and conjugate acid to a smaller ratio change (about 0.98 versus 0.82) and so a smaller pH change.', 'Name Buffer B and explain that its larger reserve of CH3COO-, which reacts with the added H+, changes the ratio, and so the pH, less.')
        ca1 = ca1.replace('New pH = 4.74 + log(0.09/0.11) approximately 4.74 - 0.09 approximately 4.65', 'The CH3COO-/CH3COOH ratio falls from 1.00 to 0.09/0.11, about 0.82, so the pH falls (by a noticeable amount).')
        ca1 = ca1.replace('New pH = 4.74 + log(0.99/1.01) approximately 4.74 - 0.01 approximately 4.73', 'The ratio falls only from 1.00 to 0.99/1.01, about 0.98, so the pH falls only very slightly.')
        ca1 = ca1.replace('(deltapH approximately 0.01 for B versus approximately 0.09 for A)', '(ratio about 0.98 for B versus about 0.82 for A)')
        assert 'approximately 4.65' not in ca1 and 'approximately 4.73' not in ca1 and 'deltapH' not in ca1 and 'about 0.82' in ca1, ca1
        note = 'prompt parts (b) and (c) rewritten as qualitative reasoning from the new amounts and ratio, because CED 8.9 excludes computing the change in pH on adding an acid or base to a buffer'
    pj = copy.deepcopy(r['prompt_json']); old_total = sum(c['points_possible'] for c in r['crit'])
    pj['content_version'] = r['version_num'] + 1
    pj['qa_remediation'] = '2026-11-14 content repair (APPROVAL-0282): ' + note
    new_total = sum(c['points_possible'] for c in crit.values()); assert new_total == old_total == pj['total_points'], (ck, old_total, new_total)
    assert stem != r['stem'] and ca1 != r['canonical_answer_1']
    plan.append({'content_key': ck, 'old_version_id': r['vid'], 'old_version_num': r['version_num'], 'stem': stem, 'stimulus': r['stimulus'], 'canonical_answer_1': ca1, 'prompt_json': pj,
                 'criteria': [crit[k] for k in sorted(crit)], 'old_total': old_total, 'new_total': new_total, 'stem_changed': True})
json.dump(plan, open(os.path.join(HERE, 'plan.json'), 'w'), indent=1, ensure_ascii=False)
for p in plan: print(p['content_key'], p['old_total'], '->', p['new_total'], 'criteria', len(p['criteria'])); print(p['stem']); print()
