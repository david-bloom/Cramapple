# CED-text rulings by Claude (owner-approved 2026-11-13), all subjects except AB. key -> (topic, reason[, required_units_override]).
R = {
 'apcalcbc-frq-017': ('1.13', 'find k so f is continuous (removing the discontinuity) is the lead ask; parts also use the derivative definition (Unit 2) and IVT', [1, 2]),
 'apprecalc-frq-002': ('2.10', 'validated cell 2.10 stays; serving label only'),
 'apprecalc-frq-020': ('2.6', 'fitting a two-term exponential model and comparing its prediction with the pattern is competing-model validation'),
 'apprecalc-frq-np2-007': ('2.13', 'two of three parts are logarithm/exponential equation work (2.12 rewrite, 2.13 solve); part (c) trig equation adds Unit 3', [2, 3]),
 'apprecalc-frq-u12-002': ('2.12', 'validated cell 2.12 stays; serving label only'), 'apprecalc-frq-u12-014': ('2.12', 'validated cell 2.12 stays; parts-included revote 5 of 6 on 2.12'),
 'apprecalc-frq-u12-016': ('2.2', 'validated cell 2.2 stays; parts-included revote 4 of 6'),
 'apchem-mcq-042': ('4.9', 'oxidizing agent and oxidation-state change in a redox reaction; 5 of 5 votes (owner approved release of the hold)'),
 'apchem-sfrq-023': ('4.9', 'redox half-reactions and oxidizing agent; 5 of 5 votes (owner approved release of the hold)'),
 'apphy1-frq-012': ('4.4', 'perfectly inelastic collision and why kinetic energy is not conserved; 4 of 6 votes'),
 'apphy1-frq-019': ('1.4', 'validated cell; 5 of 5 votes (hold released)'), 'apphy1-frq-026': ('3.4', 'validated cell; 5 of 5 votes (hold released)'),
 'apphy1-frq-np1-010': ('3.5', 'validated cell; 5 of 5 votes (hold released)'), 'apphy1-mcq-045': ('5.6', 'rotational form of Newton second law; 5 of 5 votes (hold released)'),
 'apphy2-frq-003': ('11.8', 'validated cell; 6 of 6 votes (hold released)'), 'apphy2-frq-008': ('9.4', 'validated cell; 5 of 5 votes (hold released)'), 'apphy2-frq-035': ('11.8', 'validated cell; 5 of 5 votes, also parts-included revote (hold released)'),
 'apphycem-frq-021': ('9.2', 'validated cell; 5 of 5 votes (hold released)'),
 'apphycem-mcq-037': ('12.1', 'CED fact pack: topic 12.1 includes the closed-loop Gauss law for magnetism integral'),
 'apphycm-frq-044': ('3.4', 'energy conservation for a spring-mass maximum speed needs Unit 3 only; keeps the recorded unit (7.4 would move it to Unit 7)'),
}
SKIP = {'apprecalc-frq-np2-010': 'three unrelated parts (Unit 1 polynomial zeros, Unit 3 sum identity, Unit 1 rational inequality); no single topic; left unlabeled'}
def stats(k):
    if k.startswith('apstat-compare_stats-0900'): return ('1.7', 'asks for a difference of two computed summary statistics (mean/median/IQR); CED 1.7; replaces the authored 1.9 tag (same unit)')
    if k.startswith('apstat-u1-11-2a-sampling-'): return ('1.12', 'stem describes a voluntary-response or convenience plan: bias in sampling is 1.12; replaces the authored 1.11 tag (same unit)')
    if k.startswith('apstat-u1-6-4a-distribution-'): return ('1.6', 'describing a distribution from a five-number summary (shape, center, spread, outliers) is 1.6; matches the authored cell')
    if k == 'APSTATS-MCQ-097': return ('1.13', 'validated cell 1.13 stays; the item also needs the Unit 4 difference-of-means inference', [1, 4])
    return None
