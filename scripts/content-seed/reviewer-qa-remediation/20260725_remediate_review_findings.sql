-- Remediate content defects found while assessing four reviewers.
-- Production project: pcntajvbdfqhbeewmdry
-- Idempotency: each replacement is identified by content_key + md5(stem).
-- Prior versions and submitted decisions are preserved.

begin;

select pg_advisory_xact_lock(hashtext('cramapple-reviewer-qa-remediation-20260725'));

create temporary table qa_specs (
  content_key text primary key,
  stem text not null,
  stimulus text,
  canonical_answer_1 text,
  prompt_patch jsonb not null default '{}'::jsonb,
  reviewer_id uuid not null,
  choices jsonb,
  criteria jsonb
) on commit drop;

insert into qa_specs
  (content_key, stem, stimulus, canonical_answer_1, prompt_patch, reviewer_id, criteria)
values
(
  'apcalcab-frq-005',
  $stem$Part A: Find dy/dx in terms of x and y.

Part B: Find the slope at (2,2).

Part C: Write an equation for the normal line at (2,2).$stem$,
  $stimulus$Points (x,y) lie on x²+xy+2y²=16 near the point (2,2).$stimulus$,
  $answer$dy/dx=−(2x+y)/(x+4y). At (2,2), the tangent slope is −3/5. A normal line is y−2=(5/3)(x−2).$answer$,
  '{"content_version":2,"qa_remediation":"2026-07-25 reviewer assessment"}'::jsonb,
  'ed6ce8d3-5c57-49c9-8574-7d70b46cba36',
  '[
    {"criterion_key":"part-a-criterion-1","learner_facing_text":"Find dy/dx by implicit differentiation.","points_possible":1,"evidence_requirements":"dy/dx=−(2x+y)/(x+4y).","minimum_fix":"Differentiate every term implicitly and solve for dy/dx.","accepted_variants":["Any algebraically equivalent expression."]},
    {"criterion_key":"part-b-criterion-1","learner_facing_text":"Evaluate the tangent slope at (2,2).","points_possible":1,"evidence_requirements":"Substitution gives −3/5.","minimum_fix":"Substitute x=2 and y=2 into the derivative.","accepted_variants":["-0.6"]},
    {"criterion_key":"part-c-criterion-1","learner_facing_text":"Write the normal line at (2,2).","points_possible":1,"evidence_requirements":"Uses normal slope 5/3 and passes through (2,2).","minimum_fix":"Take the negative reciprocal of the tangent slope and use point-slope form.","accepted_variants":["Any algebraically equivalent equation."]}
  ]'::jsonb
),
(
  'apcalcab-frq-014',
  $stem$Part A: Use Euler's method with step size 0.5 to approximate y(1).

Part B: Solve the differential equation exactly for the particular solution.

Part C: Compare the Euler approximation with the exact value y(1) and state whether the approximation is an overestimate or an underestimate.$stem$,
  $stimulus$The differential equation is dy/dx=x(y−1), with y(0)=2.$stimulus$,
  $answer$Euler's method gives y(0.5)=2 and y(1)=2.25. Separation gives ln(y−1)=x²/2+C, so y=1+e^(x²/2). Thus y(1)=1+e^(1/2)≈2.6487, and 2.25 is an underestimate.$answer$,
  '{"content_version":2,"qa_remediation":"2026-07-25 reviewer assessment","difficulty":"Hard"}'::jsonb,
  'ed6ce8d3-5c57-49c9-8574-7d70b46cba36',
  '[
    {"criterion_key":"part-a-criterion-1","learner_facing_text":"Apply two Euler steps of size 0.5.","points_possible":1,"evidence_requirements":"y(0.5)=2 and y(1)=2.25.","minimum_fix":"Use y_next=y_current+0.5 f(x_current,y_current) twice.","accepted_variants":[]},
    {"criterion_key":"part-b-criterion-1","learner_facing_text":"Solve the separable differential equation.","points_possible":1,"evidence_requirements":"ln(y−1)=x²/2+C and y=1+e^(x²/2).","minimum_fix":"Separate dy/(y−1)=x dx, integrate, and apply y(0)=2.","accepted_variants":["Equivalent exact forms."]},
    {"criterion_key":"part-c-criterion-1","learner_facing_text":"Compare the numerical and exact values.","points_possible":1,"evidence_requirements":"Exact y(1)=1+sqrt(e)≈2.6487; Euler value 2.25 is an underestimate.","minimum_fix":"Evaluate the particular solution at x=1 and compare.","accepted_variants":[]}
  ]'::jsonb
),
(
  'apphycem-frq-014',
  $stem$Answer all parts of the following question.

(a) Derive Eₓ(x) and determine the ratio of the new field to the original field at the same fixed position x when the decay length is changed from L to 2L. State the condition under which the field increases rather than decreases.

(b) Identify the governing relationship between electric field and potential and explain why only the x derivative is needed.$stem$,
  $stimulus$On the x-axis the electric potential is V(x)=V₀e^(−x/L) for x≥0.$stimulus$,
  $answer$Eₓ=(V₀/L)e^(−x/L). After L→2L, E'ₓ=(V₀/2L)e^(−x/2L), so E'ₓ/Eₓ=(1/2)e^(x/2L). The field increases when x>2L ln 2, equals the original value at x=2L ln 2, and decreases for smaller x. Since V depends only on x, Eₓ=−dV/dx.$answer$,
  '{"content_version":2,"qa_remediation":"2026-07-25 reviewer assessment"}'::jsonb,
  'cee0cee4-fc59-4084-9a83-b24ccca940b9',
  '[
    {"criterion_key":"part-a","learner_facing_text":"Derive both fields and compare them at fixed x.","points_possible":1,"evidence_requirements":"E=(V0/L)e^(−x/L), E''=(V0/2L)e^(−x/2L), ratio=(1/2)e^(x/2L), with increase for x>2L ln 2.","minimum_fix":"Differentiate both potentials and form their ratio at the same x.","accepted_variants":["Equivalent algebraic comparisons."]},
    {"criterion_key":"part-b","learner_facing_text":"Relate the field to the potential.","points_possible":1,"evidence_requirements":"E=−grad V and one-dimensional dependence gives E_x=−dV/dx.","minimum_fix":"State the negative spatial derivative relationship and the one-dimensional assumption.","accepted_variants":[]}
  ]'::jsonb
),
(
  'apphy1-frq-013',
  $stem$Answer all parts of the following question.

(a) Calculate the cable tension for the original beam. Then predict and calculate the cable tension when the beam's weight is doubled while its dimensions and the cable geometry remain unchanged.

(b) Explain, using torque equilibrium about the hinge, why the cable tension is directly proportional to the beam's weight in this setup.$stem$,
  $stimulus$A uniform 2.00 m beam weighing 100 N is hinged at one end and held horizontal by a vertical cable attached at the other end.$stimulus$,
  $answer$Torque balance about the hinge gives TL=W(L/2), so T=W/2. Initially T=50.0 N. If the weight doubles to 200 N, the tension doubles to 100 N.$answer$,
  '{"content_version":2,"qa_remediation":"2026-07-25 reviewer assessment"}'::jsonb,
  'cee0cee4-fc59-4084-9a83-b24ccca940b9',
  '[
    {"criterion_key":"part-a","learner_facing_text":"Calculate the original and doubled-weight tensions.","points_possible":1,"evidence_requirements":"Original T=50.0 N and doubled-weight T=100 N.","minimum_fix":"Use TL=W(L/2) for each weight.","accepted_variants":[]},
    {"criterion_key":"part-b","learner_facing_text":"Use rotational equilibrium to justify the proportionality.","points_possible":1,"evidence_requirements":"The cable acts at L, the uniform beam weight at L/2, and L cancels to give T=W/2.","minimum_fix":"Write the two torques about the hinge and set their sum to zero.","accepted_variants":[]}
  ]'::jsonb
),
(
  'apphy1-frq-025',
  $stem$Answer all parts of the following question.

(a) Represent force versus position and determine the work done from x=0 to x=6.0 m.

(b) Determine the cart's speed at x=6.0 m.

(c) The measured travel time is 2.63 s. Determine the average power delivered and explain why the final instantaneous power is different.$stem$,
  $stimulus$A 2.0 kg cart starts from rest on a horizontal frictionless track. The applied force increases uniformly from 2.0 N at x=0 to 14 N at x=6.0 m.$stimulus$,
  $answer$The force-position graph is a line from (0,2.0 N) to (6.0 m,14 N). Its area is W=((2.0+14)/2)(6.0)=48 J. Work-energy gives v=sqrt(48)=6.93 m/s. Average power is 48/2.63=18.3 W; final instantaneous power is Fv=(14)(6.93)=97.0 W.$answer$,
  '{"content_version":2,"qa_remediation":"2026-07-25 reviewer assessment"}'::jsonb,
  'cee0cee4-fc59-4084-9a83-b24ccca940b9',
  '[
    {"criterion_key":"a-graph","learner_facing_text":"Represent the applied force as a function of position.","points_possible":1,"evidence_requirements":"Straight line from (0,2.0 N) to (6.0 m,14 N), with labeled axes.","minimum_fix":"Plot the two endpoints and connect them linearly.","accepted_variants":[]},
    {"criterion_key":"a-work","learner_facing_text":"Calculate the work from the area under the force-position graph.","points_possible":1,"evidence_requirements":"W=((2.0+14)/2)(6.0)=48 J.","minimum_fix":"Use the trapezoid area under the graph.","accepted_variants":[]},
    {"criterion_key":"b-energy","learner_facing_text":"Apply the work-energy theorem.","points_possible":1,"evidence_requirements":"48 J=(1/2)(2.0 kg)v².","minimum_fix":"Set net work equal to the change in kinetic energy.","accepted_variants":[]},
    {"criterion_key":"b-speed","learner_facing_text":"Calculate the final speed.","points_possible":1,"evidence_requirements":"v=sqrt(48)=6.93 m/s.","minimum_fix":"Solve the work-energy equation for v.","accepted_variants":["6.9 m/s"]},
    {"criterion_key":"c-average","learner_facing_text":"Calculate average power.","points_possible":1,"evidence_requirements":"P_avg=48 J/2.63 s=18.3 W.","minimum_fix":"Divide total work by elapsed time.","accepted_variants":["18 W"]},
    {"criterion_key":"c-instant","learner_facing_text":"Calculate and interpret final instantaneous power.","points_possible":1,"evidence_requirements":"P_final=Fv=(14 N)(6.93 m/s)=97.0 W and differs because force and speed vary during the trip.","minimum_fix":"Use the final force and speed in P=Fv and contrast endpoint with time average.","accepted_variants":["97 W"]}
  ]'::jsonb
),
(
  'apphy2-frq-006',
  $stem$Answer all parts of the following question.

(a) Determine whether the interference at the detector is constructive or destructive, and justify the result quantitatively.

(b) Explain how the destructive-interference condition, path difference=(m+1/2)λ, follows from the waves arriving out of phase, and explain why coherence is required for a stable pattern.$stem$,
  $stimulus$Two coherent sources emit in phase with wavelength 0.500 m. The path difference from the sources to a detector is 1.25 m.$stimulus$,
  $answer$The path difference is 1.25/0.500=2.5 wavelengths. Because the sources emit in phase, the half-integer path difference makes the waves arrive π radians out of phase, producing destructive interference. Coherence keeps their phase difference constant in time.$answer$,
  '{"content_version":2,"qa_remediation":"2026-07-25 reviewer assessment"}'::jsonb,
  'cee0cee4-fc59-4084-9a83-b24ccca940b9',
  '[
    {"criterion_key":"part-a","learner_facing_text":"Classify the interference and justify it quantitatively.","points_possible":1,"evidence_requirements":"Path difference=2.5 lambda and in-phase emission therefore yields destructive interference.","minimum_fix":"Divide the path difference by the wavelength and use the stated initial phase.","accepted_variants":[]},
    {"criterion_key":"part-b","learner_facing_text":"Explain the phase condition and coherence requirement.","points_possible":1,"evidence_requirements":"A half-integer wavelength adds an odd-pi phase difference; coherence keeps the relative phase fixed.","minimum_fix":"Connect path difference to phase difference and define the role of coherence.","accepted_variants":[]}
  ]'::jsonb
),
(
  'apchem-frq-l-002',
  $stem$Answer all parts of the following question.

(a) Assign the formal charges in each proposed Lewis structure and explain why the two structures are equivalent resonance contributors.

(b) Predict the molecular geometry about the central oxygen atom and the average O−O bond order.

(c) Describe an experimental measurement that could test the bonding prediction and state the expected result.

(d) Explain why drawing one contributor with one single bond and one double bond does not imply that an ozone molecule contains one permanently shorter O−O bond.$stem$,
  $stimulus$Ozone, O₃, can be represented by two Lewis structures. Structure I is O=O−O, with the double bond to the left terminal oxygen. Structure II is O−O=O, with the double bond to the right terminal oxygen. In each structure, the singly bonded terminal oxygen has a −1 formal charge and the central oxygen has a +1 formal charge.$stimulus$,
  $answer$The contributors have the same formal-charge pattern and differ only in which terminal oxygen has the double bond, so they are equivalent. The central oxygen has three electron domains and one lone pair, giving bent molecular geometry. Resonance delocalization makes the two O−O bonds equivalent with average bond order 1.5. A bond-length measurement should find two equal lengths intermediate between typical single and double O−O bonds.$answer$,
  '{"content_version":2,"qa_remediation":"2026-07-25 reviewer assessment","total_points":4}'::jsonb,
  '806b0a0e-8431-4aa5-ad71-b803a1792145',
  '[
    {"criterion_key":"part-a","learner_facing_text":"Assign formal charges and identify equivalent resonance contributors.","points_possible":1,"evidence_requirements":"Central O is +1, singly bonded terminal O is −1, double-bonded terminal O is 0; swapping terminal positions gives an equivalent contributor.","minimum_fix":"Use formal charge=valence−nonbonding−bond order and compare the two structures.","accepted_variants":[]},
    {"criterion_key":"part-b","learner_facing_text":"Predict geometry and average bond order.","points_possible":1,"evidence_requirements":"Bent geometry and average O−O bond order 1.5.","minimum_fix":"Count electron domains and average the equivalent single/double bonding descriptions.","accepted_variants":[]},
    {"criterion_key":"part-c","learner_facing_text":"Propose a measurement of O−O bonding.","points_possible":1,"evidence_requirements":"Measure both O−O bond lengths; expect equal lengths intermediate between typical single and double bonds.","minimum_fix":"Identify bond length as the measured variable and state the resonance prediction.","accepted_variants":["Diffraction or spectroscopy with an equivalent bond-length conclusion."]},
    {"criterion_key":"part-d","learner_facing_text":"Explain delocalization in the resonance hybrid.","points_possible":1,"evidence_requirements":"The contributors are bookkeeping representations; pi electron density is delocalized, so neither bond is permanently localized as single or double.","minimum_fix":"Distinguish resonance contributors from rapidly switching or localized physical structures.","accepted_variants":[]}
  ]'::jsonb
),
(
  'apchem-frq-l-005',
  $stem$Answer all parts of the following question.

(a) Determine the rate law from the initial-rate relationships and state the overall reaction order.

(b) Explain how independently varying [A] and [B] establishes the order with respect to each reactant.

(c) Design a set of initial-rate trials that would test both exponents in the proposed rate law. Identify the measured variable and the controlled variables.

(d) At a later time, products have accumulated and the reverse reaction is significant. Compare the measured net forward progress with the forward-reaction rate predicted by k[A][B]² and justify the comparison.$stem$,
  $stimulus$For a reaction involving reactants A and B, initial-rate data show that the rate doubles when [A] is doubled while [B] is held constant. The rate quadruples when [B] is doubled while [A] is held constant.$stimulus$,
  $answer$The rate law is rate=k[A][B]² and the reaction is third order overall. Establish the exponents by changing one reactant concentration at a time while holding the other and temperature constant. A valid test includes at least one pair varying A at fixed B and another pair varying B at fixed A while measuring initial product-formation rate. Later, the reverse rate subtracts from the forward rate, so net forward progress is lower than k[A][B]².$answer$,
  '{"content_version":2,"qa_remediation":"2026-07-25 reviewer assessment","total_points":4}'::jsonb,
  '806b0a0e-8431-4aa5-ad71-b803a1792145',
  '[
    {"criterion_key":"part-a","learner_facing_text":"Determine the rate law and overall order.","points_possible":1,"evidence_requirements":"rate=k[A][B]^2 and overall order 3.","minimum_fix":"Translate the doubling and quadrupling observations into exponents.","accepted_variants":[]},
    {"criterion_key":"part-b","learner_facing_text":"Explain the method of initial rates.","points_possible":1,"evidence_requirements":"Compare trials that vary one reactant while holding the other and temperature constant.","minimum_fix":"Explain why one-variable-at-a-time comparisons isolate each exponent.","accepted_variants":[]},
    {"criterion_key":"part-c","learner_facing_text":"Design trials that test both exponents.","points_possible":1,"evidence_requirements":"Includes a pair varying A at fixed B and a pair varying B at fixed A; measures initial rate and controls temperature and other conditions.","minimum_fix":"Test each reactant separately while measuring initial product formation or reactant disappearance.","accepted_variants":[]},
    {"criterion_key":"part-d","learner_facing_text":"Compare net and forward rates when the reverse reaction matters.","points_possible":1,"evidence_requirements":"Net forward progress is lower because rate_net=rate_forward−rate_reverse.","minimum_fix":"Distinguish the forward rate law from the measured net rate near equilibrium.","accepted_variants":[]}
  ]'::jsonb
);

insert into qa_specs
  (content_key, stem, stimulus, canonical_answer_1, prompt_patch, reviewer_id, choices)
values
(
  'apphycem-mcq-003',
  $stem$The divergence of the electrostatic field in a charge-free region is$stem$,
  null,
  'B',
  '{"content_version":2,"qa_remediation":"2026-07-25 reviewer assessment"}'::jsonb,
  'cee0cee4-fc59-4084-9a83-b24ccca940b9',
  '[
    {"choice_key":"A","choice_text":"a nonzero constant set by surrounding charges","is_correct":false,"rationale":"External charges can create a nonzero field in the region, but in a charge-free region Gauss''s law in differential form requires the local divergence to be zero."},
    {"choice_key":"B","choice_text":"zero","is_correct":true,"rationale":"Gauss''s law gives divergence E=rho/epsilon_0, and the local charge density rho is zero in the specified region."},
    {"choice_key":"C","choice_text":"infinite","is_correct":false,"rationale":"A charge-free region excludes the singular local charge density that could produce a divergent source term."},
    {"choice_key":"D","choice_text":"equal to the electric potential","is_correct":false,"rationale":"Potential is a scalar; divergence of the vector field is related to local charge density, not to the potential itself."}
  ]'::jsonb
),
(
  'apphy2-mcq-011',
  $stem$A 50-turn coil experiences a magnetic flux per turn that decreases uniformly from 0.80 Wb to 0.20 Wb in 0.10 s. What is the magnitude of the average induced emf?

A. 6 V
B. 30 V
C. 300 V
D. 400 V$stem$,
  null,
  'C',
  '{"content_version":2,"qa_remediation":"2026-07-25 reviewer assessment","difficulty":"Medium"}'::jsonb,
  'cee0cee4-fc59-4084-9a83-b24ccca940b9',
  '[
    {"choice_key":"A","choice_text":"6 V","is_correct":false,"rationale":"This uses change in flux divided by time but omits the 50 turns."},
    {"choice_key":"B","choice_text":"30 V","is_correct":false,"rationale":"This multiplies the flux change by the number of turns but omits division by the 0.10 s interval."},
    {"choice_key":"C","choice_text":"300 V","is_correct":true,"rationale":"Faraday''s law gives magnitude N|Delta Phi|/Delta t=50(0.60)/0.10=300 V."},
    {"choice_key":"D","choice_text":"400 V","is_correct":false,"rationale":"This incorrectly uses the initial flux 0.80 Wb rather than the flux change 0.60 Wb."}
  ]'::jsonb
),
(
  'apphy2-mcq-016',
  $stem$A periodic wave has frequency 5.0 Hz and wavelength 0.60 m. What is its speed?

A. 0.12 m/s
B. 3.0 m/s
C. 5.6 m/s
D. 8.3 m/s$stem$,
  null,
  'B',
  '{"content_version":2,"qa_remediation":"2026-07-25 reviewer assessment","difficulty":"Medium"}'::jsonb,
  'cee0cee4-fc59-4084-9a83-b24ccca940b9',
  '[
    {"choice_key":"A","choice_text":"0.12 m/s","is_correct":false,"rationale":"This divides wavelength by frequency instead of multiplying."},
    {"choice_key":"B","choice_text":"3.0 m/s","is_correct":true,"rationale":"The wave speed is v=f lambda=(5.0)(0.60)=3.0 m/s."},
    {"choice_key":"C","choice_text":"5.6 m/s","is_correct":false,"rationale":"This adds the numerical values of frequency and wavelength, which have different units."},
    {"choice_key":"D","choice_text":"8.3 m/s","is_correct":false,"rationale":"This computes frequency divided by wavelength rather than frequency times wavelength."}
  ]'::jsonb
),
(
  'apphy2-mcq-018',
  $stem$The tension in an ideal string is increased by a factor of 4 while its linear density remains fixed. By what factor does the wave speed change?

A. It becomes one-fourth as large.
B. It becomes one-half as large.
C. It becomes twice as large.
D. It becomes four times as large.$stem$,
  null,
  'C',
  '{"content_version":2,"qa_remediation":"2026-07-25 reviewer assessment","difficulty":"Medium"}'::jsonb,
  'cee0cee4-fc59-4084-9a83-b24ccca940b9',
  '[
    {"choice_key":"A","choice_text":"It becomes one-fourth as large.","is_correct":false,"rationale":"This treats speed as inversely proportional to tension rather than proportional to its square root."},
    {"choice_key":"B","choice_text":"It becomes one-half as large.","is_correct":false,"rationale":"This applies a square root but reverses the direction of the dependence."},
    {"choice_key":"C","choice_text":"It becomes twice as large.","is_correct":true,"rationale":"Since v=sqrt(T/mu), multiplying T by 4 multiplies v by sqrt(4)=2."},
    {"choice_key":"D","choice_text":"It becomes four times as large.","is_correct":false,"rationale":"This assumes direct proportionality between wave speed and tension and omits the square root."}
  ]'::jsonb
),
(
  'APBIO-MCQ-007',
  $stem$Which property of water explains the large energy transfer associated with evaporation, and which property explains why liquid water beads and rolls along hydrophobic troughs rather than spreading flat?$stem$,
  $stimulus$Namib Desert beetles collect water by tilting toward coastal fog at dawn. Droplets condense on hydrophilic bumps on their back surfaces and roll toward their mouths along hydrophobic troughs. Researchers noted that beetles must collect water before peak daytime heat causes significant evaporative loss from their body surface. A separate study found that transferring the same mass of water from liquid to vapor requires substantially more energy than melting the same mass of ice.$stimulus$,
  'D',
  '{"content_version":2,"qa_remediation":"2026-07-25 reviewer assessment"}'::jsonb,
  '83098fb9-b408-47ad-a9ee-fcf231efade0',
  '[
    {"choice_key":"A","choice_text":"High specific heat explains both phenomena: it slows temperature change and causes water to resist spreading on surfaces.","is_correct":false,"rationale":"Specific heat concerns temperature change within a phase and does not cause beading on a hydrophobic surface."},
    {"choice_key":"B","choice_text":"Adhesion explains both: water clings to hydrophilic bumps and rolls along hydrophobic troughs because it adheres strongly to both surfaces.","is_correct":false,"rationale":"Adhesion helps condensation on hydrophilic bumps, but weak adhesion to hydrophobic material does not explain the water-to-water attraction that maintains beads."},
    {"choice_key":"C","choice_text":"Polarity alone explains both: polar water requires no energy to vaporize and is repelled by every nonpolar surface.","is_correct":false,"rationale":"Vaporization requires substantial energy, and hydrophobic interactions are not a simple electrostatic repulsion of water molecules."},
    {"choice_key":"D","choice_text":"High heat of vaporization means each gram that evaporates absorbs substantial energy; cohesion keeps water molecules attracted to one another so they bead on hydrophobic surfaces.","is_correct":true,"rationale":"Hydrogen bonding produces a high heat of vaporization and strong cohesion. Cohesion exceeds adhesion to a hydrophobic surface, maintaining droplets that can roll."}
  ]'::jsonb
),
(
  'APBIO-MCQ-009',
  $stem$Which evaluation of the student's prediction is best supported by the data?$stem$,
  $stimulus$A researcher measures carbonic anhydrase activity at several pH values.

pH | Activity (units/min)
6.0 | 15
6.5 | 35
7.0 | 72
7.4 | 100
7.8 | 74
8.0 | 40
8.5 | 12

Carbonic anhydrase catalyzes the reversible hydration of CO₂. The researcher adds the enzyme to a sealed solution with low buffer capacity, initially at pH 7.4, and excess dissolved CO₂. Over 60 minutes, the measured pH falls to 6.5 and enzyme activity falls from 100 to 35 units/min. A student predicts that the reaction will slow as the product-associated pH change moves the enzyme away from its optimum.$stimulus$,
  'A',
  '{"content_version":2,"qa_remediation":"2026-07-25 reviewer assessment"}'::jsonb,
  '83098fb9-b408-47ad-a9ee-fcf231efade0',
  '[
    {"choice_key":"A","choice_text":"The prediction is supported because the observed pH decline moves the solution away from the enzyme''s pH optimum and is accompanied by lower activity.","is_correct":true,"rationale":"The independent pH-activity data show an optimum near 7.4, and the time-course directly links a fall to pH 6.5 with activity falling to 35 units/min. The enzyme speeds equilibration but does not change the equilibrium position."},
    {"choice_key":"B","choice_text":"The prediction is unsupported because the enzyme has equal activity at every tested pH.","is_correct":false,"rationale":"Activity varies strongly with pH and is highest at pH 7.4."},
    {"choice_key":"C","choice_text":"The prediction is unsupported because an enzyme can never be affected by the chemical environment created during a reaction.","is_correct":false,"rationale":"Enzyme conformation and catalytic activity can change when the reaction environment, including pH, changes."},
    {"choice_key":"D","choice_text":"The prediction is supported only if the product binds competitively to the enzyme''s active site.","is_correct":false,"rationale":"The observations support a pH-mediated change and do not require competitive inhibition."}
  ]'::jsonb
),
(
  'apchem-mcq-016',
  $stem$Adding an inert gas at constant volume and constant temperature does not change an ideal-gas equilibrium because

A. all partial pressures increase
B. all partial pressures decrease
C. reactant partial pressures alone increase
D. the reacting-gas partial pressures do not change$stem$,
  null,
  'D',
  '{"content_version":2,"qa_remediation":"2026-07-25 reviewer assessment"}'::jsonb,
  '806b0a0e-8431-4aa5-ad71-b803a1792145',
  '[
    {"choice_key":"A","choice_text":"all partial pressures increase","is_correct":false,"rationale":"Total pressure increases, but each reacting species keeps the same moles, volume, and temperature, so its partial pressure is unchanged."},
    {"choice_key":"B","choice_text":"all partial pressures decrease","is_correct":false,"rationale":"At constant volume there is no dilution of the reacting gases; each species'' partial pressure remains nRT/V."},
    {"choice_key":"C","choice_text":"reactant partial pressures alone increase","is_correct":false,"rationale":"An inert gas does not selectively alter reactant amounts or partial pressures."},
    {"choice_key":"D","choice_text":"the reacting-gas partial pressures do not change","is_correct":true,"rationale":"For each reacting gas, n, T, and V are unchanged, so its partial pressure and the reaction quotient remain unchanged."}
  ]'::jsonb
);

do $$
declare
  s qa_specs%rowtype;
  v_item app.content_items%rowtype;
  v_old app.content_item_versions%rowtype;
  v_new_id uuid;
  v_next integer;
  v_choice jsonb;
  v_criterion jsonb;
begin
  for s in select * from qa_specs order by content_key loop
    select * into strict v_item
    from app.content_items
    where lower(content_key)=lower(s.content_key);

    select * into strict v_old
    from app.content_item_versions
    where content_item_id=v_item.id
    order by version_num desc
    limit 1
    for update;

    if v_old.content_hash = md5(s.stem)
       and v_old.stem = s.stem
       and exists (
         select 1 from app.content_review_assignments
         where content_item_version_id=v_old.id
       ) then
      continue;
    end if;

    v_next := v_old.version_num + 1;

    update app.content_item_versions
    set status='retired'
    where id=v_old.id
      and status <> 'retired';

    update app.content_items
    set status='draft'
    where id=v_item.id;

    insert into app.content_item_versions (
      content_item_id, version_num, stem, stimulus, prompt_json,
      explanation, help_text, content_hash, status, created_by,
      canonical_answer_1, canonical_answer_2, review_status,
      rubric_type, evaluator_strategy, stimulus_image_path
    ) values (
      v_item.id, v_next, s.stem, s.stimulus,
      coalesce(v_old.prompt_json,'{}'::jsonb) || s.prompt_patch,
      v_old.explanation, v_old.help_text, md5(s.stem), 'draft',
      'f5a26c6b-3566-4d58-9e97-979fbb947564',
      s.canonical_answer_1, v_old.canonical_answer_2, null,
      case when v_item.item_type='mcq' then 'mcq' else v_old.rubric_type end,
      case when v_item.item_type='mcq' then 'rule_based_mcq' else v_old.evaluator_strategy end,
      v_old.stimulus_image_path
    ) returning id into v_new_id;

    if v_item.item_type='mcq' then
      if jsonb_array_length(s.choices) <> 4 then
        raise exception 'MCQ % does not contain four choices', s.content_key;
      end if;
      for v_choice in select value from jsonb_array_elements(s.choices) loop
        insert into app.mcq_choices (
          content_item_version_id, choice_key, choice_text, is_correct, rationale
        ) values (
          v_new_id,
          v_choice->>'choice_key',
          v_choice->>'choice_text',
          (v_choice->>'is_correct')::boolean,
          v_choice->>'rationale'
        );
      end loop;
      if (select count(*) from app.mcq_choices where content_item_version_id=v_new_id and is_correct) <> 1 then
        raise exception 'MCQ % does not contain exactly one correct choice', s.content_key;
      end if;
    else
      if s.criteria is null or jsonb_array_length(s.criteria)=0 then
        raise exception 'FRQ % has no criteria', s.content_key;
      end if;
      for v_criterion in select value from jsonb_array_elements(s.criteria) loop
        insert into app.frq_criteria (
          content_item_version_id, criterion_key, learner_facing_text,
          points_possible, evidence_requirements, minimum_fix, accepted_variants
        ) values (
          v_new_id,
          v_criterion->>'criterion_key',
          v_criterion->>'learner_facing_text',
          (v_criterion->>'points_possible')::integer,
          v_criterion->>'evidence_requirements',
          v_criterion->>'minimum_fix',
          coalesce(v_criterion->'accepted_variants','[]'::jsonb)
        );
      end loop;
    end if;

    insert into app.content_review_assignments (
      content_item_version_id, reviewer_id, review_stage, review_kind,
      status, created_by
    ) values (
      v_new_id, s.reviewer_id, 'tutor_question', v_item.item_type,
      'pending', 'f5a26c6b-3566-4d58-9e97-979fbb947564'
    );
  end loop;
end
$$;

-- Repair the seven Biology long-FRQ forks that were correctly restructured
-- but accidentally lost fields while being copied. No decisions exist on the
-- forked versions, so this does not invalidate review evidence.
with forked as (
  select ci.id item_id, ci.content_key,
         (array_agg(civ.id) filter (where civ.version_num=1))[1] v1_id,
         (array_agg(civ.id) filter (where civ.version_num=2))[1] v2_id
  from app.content_items ci
  join app.content_item_versions civ on civ.content_item_id=ci.id
  where ci.content_key in (
    'APBIO-FRQ-L-001','APBIO-FRQ-L-005','APBIO-FRQ-L-009',
    'APBIO-FRQ-L-031','APBIO-FRQ-L-034','APBIO-FRQ-L-038','APBIO-FRQ-L-041'
  )
  group by ci.id,ci.content_key
), source_rows as (
  select f.*, v1.stimulus, v1.prompt_json, v1.explanation, v1.help_text,
         v1.canonical_answer_1, v1.canonical_answer_2, v1.stimulus_image_path
  from forked f
  join app.content_item_versions v1 on v1.id=f.v1_id
)
update app.content_item_versions v2
set stimulus=s.stimulus,
    prompt_json=coalesce(s.prompt_json,'{}'::jsonb) ||
      jsonb_build_object('total_points',9,'qa_remediation','2026-07-25 restored fork fields'),
    explanation=s.explanation,
    help_text=s.help_text,
    canonical_answer_1=s.canonical_answer_1,
    canonical_answer_2=s.canonical_answer_2,
    stimulus_image_path=s.stimulus_image_path,
    content_hash=md5(v2.stem)
from source_rows s
where v2.id=s.v2_id
  and not exists (
    select 1 from app.content_review_decisions d
    where d.content_item_version_id=v2.id
  );

-- Quarantine all structurally invalid two-part Biology short FRQs. Preserve
-- submitted decisions, but remove pending work from reviewer queues.
update app.content_review_assignments a
set status='skipped'
from app.content_item_versions civ
join app.content_items ci on ci.id=civ.content_item_id
where a.content_item_version_id=civ.id
  and ci.content_key ~ '^APBIO-FRQ-S-[0-9]{3}$'
  and a.status in ('pending','in_progress');

update app.content_item_versions civ
set status='retired'
from app.content_items ci
where ci.id=civ.content_item_id
  and ci.content_key ~ '^APBIO-FRQ-S-[0-9]{3}$'
  and civ.status <> 'retired';

update app.content_items
set status='retired'
where content_key ~ '^APBIO-FRQ-S-[0-9]{3}$'
  and status <> 'retired';

-- Enforce the product owner's decision to stop assigning calculus work to
-- Ferdous while preserving all profile, assignment, and decision history.
update app.validator_qualifications
set status='suspended',
    suspension_reason='Reviewer QA 2026-07-25: critical correctness and current-CED scope misses; product owner ended engagement.'
where reviewer_id='f643c601-87fd-43c5-b83f-d4b7a544322f'
  and status='active';

commit;
