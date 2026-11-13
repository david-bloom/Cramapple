"""Rubric-side edits for the rubric-held FRQs (prompt text is NOT changed). Each op:
  set  : rewrite fields of an existing criterion (text / evidence / fix), points unchanged
  add  : new 1-point criterion appended to a part (part total +1)
  del  : remove a criterion (part total -1)
Every edit ties scoring to an operation the prompt actually asks, per the preflight finding.
"""
def S(key, text=None, ev=None, fix=None): return ('set', key, text, ev, fix)
def A(key, text, ev, fix): return ('add', key, text, ev, fix)
def D(key): return ('del', key)

EDITS = {
 # ---- Type A: criterion scored an unasked operation
 'apcalcab-frq-u13-006': [
   S('part-b-criterion-01', 'Identifies the forward difference quotient (T(2)-T(0))/(2-0) as the appropriate choice at t=0.',
     'Response selects the forward difference over [0,2] as the quotient to use.',
     'State that the forward difference quotient over [0,2] is the one to use at t=0.'),
   S('part-b-criterion-03', 'Explains the choice using the data: t=0 is the left endpoint of the table, so no value at t<0 exists and [0,2] is the nearest available interval.',
     'Response notes there is no data for t<0, so a central or backward difference cannot be formed, and the nearest interval is [0,2].',
     'Give the reason for the choice from the table: t=0 is the first entry, so only a forward difference is available.'),
   ],
 'apcalcab-frq-u13-017': [D('part-a-criterion-03')],
 'apcalcbc-frq-u13-010': [D('part-a-criterion-04')],
 'apcalcbc-frq-u13-018': [
   S('part-a-criterion-01', None,
     'Response states the domain restriction -1<=x<=1 because arccos(x^2) requires x^2<=1.',
     'State the restriction on x that keeps x^2 within the domain of arccos, -1<=x<=1.')],
 'apphy1-frq-035': [D('part-a-criterion-07')],
 'apphy1-frq-052': [D('b-limit')],
 'apphycm-frq-036': [
   S('part-c-criterion-03', 'Marks initial values and asymptotes on the axes: v(0)=0 and v approaching v_T; a(0)=g and a approaching 0.',
     'Response labels the starting value and the asymptote on each graph (v: 0 and v_T; a: g and 0).',
     'Label v(0)=0, the asymptote v_T, a(0)=g and the asymptote a=0 on the graphs.')],
 'apprecalc-frq-027': [
   S('part-a-criterion-2', 'States the midline d=7.', 'Response gives d=7 as the midline.', 'State the midline, d=7.'),
   S('part-c-criterion-1', 'States that the depth is decreasing on 0<t<3.', 'Response says d is decreasing on 0<t<3.', 'State that d is decreasing on 0<t<3.'),
   S('part-c-criterion-2', 'States that the rate of change of the depth is decreasing on 0<t<3 (d is concave down).', 'Response says the rate of change of d is decreasing on 0<t<3.', 'State that the rate of change of d is decreasing on 0<t<3.')],
 'apprecalc-frq-029': [
   S('part-a-criterion-2', 'States the midline L=12.', 'Response gives L=12 as the midline.', 'State the midline, L=12.'),
   S('part-c-criterion-1', 'States that daylight is increasing on 3<t<6.', 'Response says L is increasing on 3<t<6.', 'State that L is increasing on 3<t<6.'),
   S('part-c-criterion-2', 'States that the rate of change of daylight is decreasing on 3<t<6 (L is concave down).', 'Response says the rate of change of L is decreasing on 3<t<6.', 'State that the rate of change of L is decreasing on 3<t<6.')],
 'apprecalc-frq-031': [
   S('part-a-criterion-2', 'States the midline x=0.', 'Response gives x=0 as the midline.', 'State the midline, x=0.'),
   S('part-c-criterion-1', 'States that the coordinate is decreasing on 1/2<t<5/4.', 'Response says x is decreasing on 1/2<t<5/4.', 'State that x is decreasing on 1/2<t<5/4.'),
   S('part-c-criterion-2', 'States that the rate of change of the coordinate is decreasing on 1/2<t<5/4 (x is concave down).', 'Response says the rate of change of x is decreasing on 1/2<t<5/4.', 'State that the rate of change of x is decreasing on 1/2<t<5/4.')],
 'apprecalc-frq-u12-004': [
   S('part-c-criterion-01', 'States a reasonable domain for x, such as 0 <= x <= 18.2 (or 0 <= x < 18.2), narrower than the stated 0 <= x <= 20.',
     'Response gives a domain whose upper bound is the break-even value x of about 18.2 (equivalent forms accepted) and whose lower bound is 0.',
     'State a domain for x such as 0 <= x <= 18.2.'),
   S('part-c-criterion-02', 'Explains the real-world restrictions: the price increase cannot be negative, and beyond x of about 18.2 the weekly profit is negative, so the model is not meaningful there.',
     'Response gives both restrictions: x>=0 (a price increase) and profit not positive past about 18.2.',
     'Explain why x cannot be negative and why x beyond about 18.2 is not reasonable (negative profit).')],
 # ---- Type B: the prompt asked something no criterion scored
 'apphy1-frq-054': [A('a-components', 'Determines the components v0x = 25.0 cos 40.0 deg (about 19.2 m/s) and v0y = 25.0 sin 40.0 deg (about 16.1 m/s).',
     'Response states both initial-velocity components with values near 19.2 m/s and 16.1 m/s.', 'Compute v0x = v0 cos(theta) and v0y = v0 sin(theta) for 25.0 m/s at 40.0 deg.')],
 'apphy2-frq-028': [A('a-labels', 'Labels the principal axis, mirror, F, C, object and image on the diagram, and shows arrow directions on the rays and the object and image arrows.',
     'Response labels all six features and puts arrowheads on the two rays and on the object and image arrows.', 'Label the axis, mirror, F, C, object and image, and add arrow directions to the rays and the object and image.')],
 'apphycem-frq-np1-002': [A('part-b-criterion-03', 'Justifies, using spherical symmetry, that the field is radial and has constant magnitude on the Gaussian sphere of radius r.',
     'Response argues that by spherical symmetry E points along the radius and cannot depend on direction, so its magnitude is the same everywhere on the sphere.',
     'Use spherical symmetry to explain why E is radial and constant in magnitude on the Gaussian surface.')],
 'apphycem-frq-np1-003': [A('part-b-criterion-03', 'Justifies that x = R/sqrt(2) gives a maximum: dE/dx changes from positive to negative there, or E(0)=0, E approaches 0 as x approaches infinity, and this is the only critical point.',
     'Response gives the sign change of dE/dx about x = R/sqrt(2), or the endpoint-behavior argument.',
     'Show dE/dx > 0 below and < 0 above x = R/sqrt(2), or use E(0)=0 and E to 0 at large x.')],
 'apphycem-frq-np1-010': [
   A('part-c-criterion-03', 'States where the energy goes when the dielectric moves in freely: the lost field energy becomes kinetic energy of the dielectric (later dissipated as heat or sound if it oscillates and settles).',
     'Response identifies kinetic energy of the dielectric (and eventual dissipation) as the destination of the decrease in stored energy.',
     'State that the decrease in stored energy appears as kinetic energy of the dielectric.'),
   A('part-c-criterion-04', 'Describes slow insertion: the field still does positive work on the dielectric, while the external agent does negative work holding it back, so the net work is about zero and the agent absorbs the energy the field gives up.',
     'Response contrasts the field (positive work) with the agent (negative work) for quasi-static insertion.',
     'State that for slow insertion the field does positive work and the external agent does negative work of equal size.')],
}
