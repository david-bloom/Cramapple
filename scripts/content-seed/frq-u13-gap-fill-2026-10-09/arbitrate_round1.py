#!/usr/bin/env python3
"""Claude's arbitration, round 1 (Product Owner direction 2026-10-10): correct flagged items, record each change,
and return them to pending_checks so every gate runs again on the corrected draft."""
import json, os, datetime, copy
HERE = os.path.dirname(os.path.abspath(__file__)); NOW = datetime.datetime.utcnow().isoformat() + 'Z'
def load(sid): return json.load(open(os.path.join(HERE, 'slots', sid + '.json')))
def save(sid, s, note, topic_ruling=None):
    s.setdefault('arbitration', {}).setdefault('log', []).append({'at': NOW, 'round': 1, 'note': note})
    if topic_ruling: s['arbitration']['topic_ruling'] = topic_ruling
    s.setdefault('history_flagged', []).extend(s['candidates']); s['candidates'] = []; s['status'] = 'pending_checks'
    json.dump(s, open(os.path.join(HERE, 'slots', sid + '.json'), 'w'), indent=1, ensure_ascii=False); print('arbitrated', sid)
def crit(it, p, c): return it['parts'][p]['criteria'][c]

# ---- topic rulings from the CED text (checkers still run) ----
for sid, unit_req, why in [
  ('ap_biology__2.5__1', [2], 'CED 2.5.A.1-3 (passive vs active by concentration gradient) and 2.5.B (endocytosis/exocytosis) are exactly what the item tests; 2.8 is membrane proteins, ATP and the Na+/K+ pump, none of which appear. Vote misled by "energy-blocking chemical".'),
  ('ap_physics_2__11.2__1', [11], 'Item tests only closed, open and short circuits and multiple loops through one element (CED 11.2.A.1-3); no series/parallel or equivalent resistance (11.5). Vote tied 3-3.'),
  ('ap_calculus_ab__1.1__1', [1], 'Ruling approved by the Product Owner for AB 1.1: average rates over shrinking intervals on both sides, the zero-length interval (CHA-1.A.2) and interpretation only; no limit notation, no derivative. 1.1 and 2.1 overlap by design in the CED.'),
  ('ap_calculus_bc__1.1__1', [1], 'Same 1.1 ruling as AB 1.1 (identical CED text for BC).')]:
    s = load(sid); save(sid, s, 'Topic ruling by CED text: ' + why, {'topic': s['slot']['topic_code'], 'required_units': unit_req, 'basis': 'ced_text_tiebreak', 'reason': why})

# ---- Biology 3.1 ----
s = load('ap_biology__3.1__1'); it = s['given']['item']
it['stimulus'] = it['stimulus'].replace('Researchers measured the initial rate of product formation in four tubes kept at the same temperature and pH.',
  'Researchers measured the initial rate of product formation in four tubes kept at the same temperature and pH. Every tube starts with the same concentration of substrate, and every tube that contains enzyme has the same enzyme concentration.')
crit(it, 2, 0)['fix'] = 'Compare the charges of active site and substrate; like charges repel, which reduces binding and enzyme–substrate complex formation.'
save('ap_biology__3.1__1', s, 'Added equal substrate and enzyme concentrations to the setup (well_posed); c1 fix says like charges reduce, not prevent, complex formation (accurate).')

# ---- Calculus BC 1.15 ----
s = load('ap_calculus_bc__1.15__1'); it = s['given']['item']; c = crit(it, 1, 0)
c['text'] = 'Shows valid work for x → −∞ that accounts for x being negative.'
c['evidence'] = 'Any valid argument earns the point: dividing by x with √(x²) = |x| = −x, a dominant-term argument (√(16x² + 9) behaves like −4x while 2x + 5 behaves like 2x), or showing f(x)² → 4 with f(x) < 0 for large negative x.'
save('ap_calculus_bc__1.15__1', s, 'b1 now accepts any valid argument that handles the sign for negative x (rubric_points).')

# ---- Chemistry 1.3 ----
s = load('ap_chemistry__1.3__1'); it = s['given']['item']; c = crit(it, 2, 0)
c['evidence'] = 'Response shows that sample 2 has the same composition as sample 1, either by calculating a matching composition value (percent S, mass ratio or atom ratio) or by showing that both elemental masses scale by the same factor, and states that one compound always has the same mass ratio of its elements.'
c['fix'] = 'Show the composition matches, by a matching value or by both masses scaling by one factor, then cite the law.'
it['parts'][3]['prompt'] = it['parts'][3]['prompt'].rstrip('.') + '. Show the work that leads to your answer.'
save('ap_chemistry__1.3__1', s, 'c1 accepts proportional-scaling evidence; part (d) now asks for the work its criterion scores (rubric_points).')

# ---- Chemistry 1.4 ----
s = load('ap_chemistry__1.4__1'); it = s['given']['item']; c = crit(it, 3, 0)
c['evidence'] = 'Response reports 5.40 Ca atoms per Si atom with a correct supporting calculation by any valid route (for example finding the SiO₂ mass by subtraction and converting both elements to moles, or a single combined expression), or a ratio consistent with the student’s earlier answers.'
it['parts'][3]['prompt'] = it['parts'][3]['prompt'].rstrip('.') + '. Show the work that leads to your answer.'
save('ap_chemistry__1.4__1', s, 'd1 accepts any correct supported calculation of the atom ratio (rubric_points).')

# ---- Chemistry 1.5 ----
s = load('ap_chemistry__1.5__1'); it = s['given']['item']; c = crit(it, 3, 0)
c['text'] = 'Explains with Coulomb’s law that 2p electrons are attracted more strongly to the nucleus than 3p electrons, because they are closer to it on average or experience less shielding (greater effective nuclear charge), so they need more energy to remove.'
c['evidence'] = 'Response links a stronger Coulombic attraction for 2p electrons to either their smaller average distance from the nucleus (shell 2 versus shell 3) or less shielding by inner electrons, and concludes that more energy is needed to remove them.'
c['fix'] = 'Compare the two electrons’ distance from the nucleus or their shielding, then use Coulomb’s law to compare the attractions.'
save('ap_chemistry__1.5__1', s, 'd1 accepts a distance argument or a shielding/effective-nuclear-charge argument (rubric_points).')

# ---- Chemistry 3.12 ----
s = load('ap_chemistry__3.12__1'); it = s['given']['item']
def rep(x): return x.replace('7.830 × 10⁻¹⁹', '7.829 × 10⁻¹⁹').replace('4.558 × 10⁻¹⁹', '4.557 × 10⁻¹⁹')
it['stimulus'] = rep(it['stimulus']); it['model_answer'] = rep(it['model_answer'])
for p in it['parts']:
    p['prompt'] = rep(p['prompt'])
    for c in p['criteria']:
        for k in ('text', 'evidence', 'fix'): c[k] = rep(c[k])
        c['accepted_variants'] = [rep(v) for v in c['accepted_variants']]
c = crit(it, 0, 0)
c['evidence'] = 'Response uses c = λν with consistent units (for example converting 253.7 nm to 2.537 × 10⁻⁷ m, or using c = 2.998 × 10¹⁷ nm/s) and reports 1.182 × 10¹⁵ s⁻¹.'
c['fix'] = 'Use ν = c/λ with the wavelength and the speed of light in matching length units.'
crit(it, 1, 0)['evidence'] = crit(it, 1, 0)['evidence'].replace('7.829 × 10⁻¹⁹ J per photon; a last-digit difference caused by using a rounded frequency is acceptable.', '7.829 × 10⁻¹⁹ J per photon; 7.832 × 10⁻¹⁹ J from using the rounded frequency in (a) is also acceptable.')
vp = it['verification_python']
vp = vp.replace('7.830e-19', '7.829e-19').replace('7.830E-19', '7.829e-19').replace('4.558e-19', '4.557e-19')
it['verification_python'] = vp
save('ap_chemistry__3.12__1', s, 'Corrected rounding: 7.829 × 10⁻¹⁹ J (not 7.830) and 4.557 × 10⁻¹⁹ J (not 4.558); a1 accepts any consistent-unit method; b1 states the rounded-frequency value 7.832 × 10⁻¹⁹ J explicitly (accurate, rubric_points).')

# ---- Chemistry 3.5 ----
s = load('ap_chemistry__3.5__1'); it = s['given']['item']
crit(it, 0, 0)['fix'] = 'Compare the two Kelvin temperatures, then state that equal temperatures mean equal average kinetic energies.'
it['parts'][2]['prompt'] = it['parts'][2]['prompt'].rstrip('?') + '? Justify your answer.'
save('ap_chemistry__3.5__1', s, 'a1 fix is now a concrete action; part (c) asks for the justification its criterion scores (rubric_evidence, rubric_points).')

# ---- Chemistry 3.8 ----
s = load('ap_chemistry__3.8__1'); it = s['given']['item']
it['parts'][2]['prompt'] = it['parts'][2]['prompt'].rstrip('.') + '. Explain each orientation in terms of the attraction between charges.'
save('ap_chemistry__3.8__1', s, 'Part (c) now asks for the explanation its criteria score (rubric_points).')

# ---- Physics 1 1.1 ----
s = load('ap_physics_1__1.1__1'); it = s['given']['item']; c = crit(it, 1, 0)
c['text'] = 'Explains that displacement depends only on the net change in position, so both robots have −3 m (3 m west), while distance counts every meter traveled.'
c['evidence'] = 'Response states both displacements are −3 m (3 m west) and explains why, either by signed trips canceling in the vector sum (−20 m against +17 m) or by both robots starting and ending at the same positions, and contrasts this with distance.'
c['fix'] = 'Compare only start and end positions for displacement; distance adds every trip regardless of direction.'
save('ap_physics_1__1.1__1', s, 'b1 accepts endpoint-based reasoning as well as signed-sum reasoning (rubric_points).')

# ---- Physics 1 2.1 ----
s = load('ap_physics_1__2.1__1'); it = s['given']['item']
for j, axis in [(0, 'x'), (1, 'y')]:
    c = crit(it, 1, j)
    c['evidence'] = c['evidence'].replace(f'Response uses {axis}_cm = Σm·{axis}/Σm with total mass 8.0 kg and obtains', f'Response obtains') .rstrip('.') + f' by any valid method, for example the weighted average Σm·{axis}/Σm over all 8.0 kg, or combining the original 4.0 kg center of mass with the added 4.0 kg mass.'
save('ap_physics_1__2.1__1', s, 'b1 and b2 accept any valid center-of-mass method, including combining subsystems (rubric_points).')

# ---- Calculus AB 2.1 (Product Owner item): unbundle points within the 8-point limit ----
s = load('ap_calculus_ab__2.1__1'); it = s['given']['item']
it['parts'][1] = {'prompt': 'Find the average rate of change of H(t) over [8, 12]. Over which interval, [2, 8] or [8, 12], was the rod heating faster on average? Justify your answer.',
  'criteria': [
    {'text': 'Gives the average rate 15/4 = 3.75 °C per hour on [8, 12].', 'evidence': 'Response computes (100 − 85)/(12 − 8) = 15/4 = 3.75, with units of degrees Celsius per hour.', 'fix': 'Divide the change in temperature by the change in time for that interval only.', 'accepted_variants': ['15/4', '3.75']},
    {'text': 'Concludes the rod heated faster on average over [2, 8], because 25/3 ≈ 8.333 > 3.75.', 'evidence': 'Response names [2, 8] as the faster interval and justifies it by comparing the two average rates.', 'fix': 'Compare the two average rates directly and name the interval with the larger one.', 'accepted_variants': []}]}
it['parts'][3] = {'prompt': 'A second rod’s temperature is G(t) = 15t + 20 °C. Use the limit of a difference quotient to find the instantaneous rate of change of G at t = 5. Show the algebra that leads to your answer.',
  'criteria': [
    {'text': 'Sets up a limit of a difference quotient for G at t = 5 with the function values substituted.', 'evidence': 'Response writes lim h→0 [15(5 + h) + 20 − 95]/h, or lim t→5 [(15t + 20) − 95]/(t − 5), using G(5) = 95.', 'fix': 'Write the difference quotient at t = 5 inside the limit, then substitute G’s formula and G(5) = 95.', 'accepted_variants': []},
    {'text': 'Simplifies the difference quotient and evaluates the limit to obtain 15 °C per hour.', 'evidence': 'Response simplifies to 15h/h (or 15(t − 5)/(t − 5)), cancels, and gives the limit 15 with units of degrees Celsius per hour.', 'fix': 'Simplify the numerator and cancel the common factor before letting h approach 0.', 'accepted_variants': ['15']}]}
it['model_answer'] = it['model_answer'].split('\n\n(b)')[0] + '\n\n(b) Over [8, 12]: (100 − 85)/(12 − 8) = 15/4 = 3.75 °C per hour. The rod heated faster on average over [2, 8], because 25/3 ≈ 8.333 °C per hour is greater than 3.75 °C per hour.\n\n(c)' + it['model_answer'].split('\n\n(c)')[1].split('\n\n(d)')[0] + '\n\n(d) G(5) = 15(5) + 20 = 95. lim h→0 [G(5 + h) − G(5)]/h = lim h→0 [15(5 + h) + 20 − 95]/h = lim h→0 15h/h = 15. The instantaneous rate of change of G at t = 5 is 15 °C per hour.'
it['verification_python'] = it['verification_python'].replace("assert r(0, 2) == F(15, 2) and r(8, 12) == F(15, 4) and r(0, 2) > r(8, 12)", "assert r(8, 12) == F(15, 4) and r(2, 8) > r(8, 12)")
save('ap_calculus_ab__2.1__1', s, 'Unbundled points within the 8-point limit: (b) now one rate ([8, 12]) plus a comparison with (a); (d) separate setup and evaluation points, accepting the h-form or the t→5 form; dropped the interpretation sentence to stay at 8 points (rubric_points). Product Owner item; corrected under the arbitration direction.')
