import { canonicalJson, sha256 } from "../subject-harness/compiler.ts";

type Mcq = [number, string, string, string, string, string, "A"|"B"|"C"|"D", string];
type Frq = [number, string, string, string, string[]];
type Subject = {
  key: string; name: string; examCode: string; examDate: string; prefix: string;
  units: Array<[number,string,number,number]>; practices: string[];
  mcq: Mcq[]; frq: Frq[]; chemistry?: boolean; calculus?: boolean;
};

const chemMcq: Mcq[] = [
 [1,"A 9.00 g sample of water (18.0 g mol⁻¹) contains how many moles?","0.250 mol","0.500 mol","2.00 mol","162 mol","B","mass divided by molar mass gives 0.500 mol"],
 [1,"Which observation best supports a larger effective nuclear charge across a period?","Atomic radius generally decreases","Atomic mass decreases","Neutron count becomes zero","Valence shells disappear","A","greater attraction contracts the electron cloud"],
 [2,"Which species has a trigonal planar molecular geometry?","NH₃","CO₂","BF₃","CH₄","C","BF3 has three bonding regions and no lone pair on boron"],
 [2,"Why does solid NaCl not conduct while molten NaCl does?","Electrons are created on melting","Ions become mobile on melting","NaCl becomes molecular","Chloride loses its charge","B","charge carriers are fixed in the solid lattice but mobile in the melt"],
 [3,"At the same temperature, which gas sample has the greatest average molecular speed?","Xe","Kr","Ar","He","D","lighter particles have greater rms speed at fixed temperature"],
 [3,"A solution has absorbance 0.60 in a 1.0 cm cell. If concentration is halved, the absorbance is approximately","0.15","0.30","0.60","1.20","B","Beer-Lambert absorbance is proportional to concentration"],
 [3,"Which change most increases the solubility of a gas in water?","Raise temperature and lower pressure","Raise temperature and raise pressure","Lower temperature and raise pressure","Lower temperature and lower pressure","C","gas solubility generally rises with pressure and falls with temperature"],
 [3,"A gas occupies 2.0 L at 1.0 atm. At constant temperature, its volume at 4.0 atm is","0.50 L","2.0 L","4.0 L","8.0 L","A","Boyle's law gives V2=P1V1/P2"],
 [4,"For 2 H₂ + O₂ → 2 H₂O, how many moles of water form from 3.0 mol O₂ with excess H₂?","1.5","3.0","6.0","9.0","C","the stoichiometric ratio is two moles water per mole oxygen"],
 [4,"Which ions are spectators when AgNO₃(aq) and NaCl(aq) form AgCl(s)?","Ag⁺ and Cl⁻","Na⁺ and NO₃⁻","Ag⁺ and NO₃⁻","Na⁺ and Cl⁻","B","sodium and nitrate remain unchanged in solution"],
 [5,"Doubling [A] quadruples the rate while other concentrations remain fixed. The reaction is","zero order in A","first order in A","second order in A","fourth order in A","C","rate changes by 2²"],
 [5,"A catalyst speeds a reaction because it","increases ΔG°","raises activation energy","changes equilibrium K","provides a lower-energy pathway","D","a catalyst lowers activation energy without changing equilibrium"],
 [6,"A 100 g metal absorbs 2.50 kJ and warms by 50.0°C. Its specific heat is","0.050 J g⁻¹°C⁻¹","0.500 J g⁻¹°C⁻¹","5.00 J g⁻¹°C⁻¹","50.0 J g⁻¹°C⁻¹","B","q/(mΔT)=2500/(100×50)"],
 [6,"If ΔH is negative for a process, the system","absorbs heat","releases heat","must become more disordered","cannot be spontaneous","B","negative enthalpy denotes an exothermic process"],
 [7,"For a reaction with Q<K, the system initially shifts","toward reactants","toward products","nowhere because Q=0","only if a catalyst is added","B","products form until Q reaches K"],
 [7,"Adding an inert gas at constant volume to an ideal-gas equilibrium changes equilibrium because","all partial pressures increase","all partial pressures decrease","reactant partial pressures alone increase","the reacting-gas partial pressures do not change","D","fixed component moles, volume, and temperature leave partial pressures unchanged"],
 [8,"The pH of 1.0×10⁻³ M HCl is approximately","1.00","3.00","7.00","11.00","B","strong HCl gives [H+]=10^-3 M"],
 [8,"A buffer contains comparable amounts of HA and A⁻. Adding a small amount of H⁺ primarily causes","HA to react with H⁺","A⁻ to react with H⁺","water to become a strong base","Ka to increase","B","the conjugate base consumes added acid"],
 [9,"At constant temperature and pressure, a process is thermodynamically favorable when","ΔG<0","ΔG>0","ΔH=0 always","ΔS=0 always","A","negative Gibbs energy is the favorability criterion"],
 [9,"For a galvanic cell under standard conditions, E°cell>0 implies","ΔG°>0","K<1","ΔG°<0","electrons flow through the salt bridge","C","ΔG°=-nFE°cell"],
];

const p1Mcq: Mcq[] = [
 [1,"A cart's velocity changes from 2 m/s to 8 m/s in 3 s. Its average acceleration is","2 m/s²","3 m/s²","6 m/s²","10 m/s²","A","change in velocity divided by time is 2 m/s²"],
 [1,"The area under a velocity-versus-time graph represents","acceleration","displacement","force","power","B","integrating velocity over time gives displacement"],
 [2,"A 4 kg block has a net horizontal force of 12 N. Its acceleration is","0.33 m/s²","3 m/s²","8 m/s²","48 m/s²","B","Newton's second law gives 12/4"],
 [2,"A book rests on a table. The Newton's-third-law partner to the table's force on the book is","Earth's force on the book","book's force on the table","table's weight","book's inertia","B","third-law forces act on different objects"],
 [2,"A block slides down a rough incline at constant speed. Along the incline, friction is","zero","less than downhill gravity","equal to downhill gravity","greater than downhill gravity","C","zero acceleration requires balanced parallel forces"],
 [3,"A constant 10 N force moves an object 3 m in its direction. The work is","3 J","13 J","30 J","300 J","C","W=Fd cos 0"],
 [3,"If an object's speed doubles, its kinetic energy becomes","half","double","four times","eight times","C","kinetic energy is proportional to speed squared"],
 [3,"A 2 kg object falls 5 m near Earth. The decrease in gravitational potential energy is about","10 J","20 J","50 J","100 J","D","mgΔh≈2×9.8×5"],
 [4,"A 2 kg cart at 3 m/s sticks to a stationary 1 kg cart. Their speed is","1 m/s","2 m/s","3 m/s","6 m/s","B","momentum conservation gives 6/3"],
 [4,"During a collision, equal and opposite impulses imply that the two objects have","equal speed changes","equal mass","equal-magnitude momentum changes","equal kinetic energies","C","impulse equals momentum change"],
 [5,"A perpendicular 6 N force is applied 0.50 m from a pivot. The torque magnitude is","0.083 N·m","3.0 N·m","6.5 N·m","12 N·m","B","τ=rF sin90°"],
 [5,"For static rotational equilibrium, an object must have","zero net force only","zero net torque only","zero net force and zero net torque","constant nonzero angular acceleration","C","both translational and rotational accelerations vanish"],
 [6,"A skater pulls in her arms with negligible external torque. Her angular speed increases because","angular momentum is conserved","rotational kinetic energy is conserved","mass increases","gravity vanishes","A","smaller moment of inertia requires larger angular speed"],
 [6,"Rolling without slipping requires","v=ωR","v=ω/R","v=R/ω","v and ω unrelated","A","the contact constraint is v_cm=ωR"],
 [7,"For ideal simple harmonic motion, acceleration is","constant","proportional to displacement and opposite it","proportional to velocity","zero at all times","B","a=-ω²x"],
 [7,"A mass-spring oscillator has maximum speed at","maximum positive displacement","maximum negative displacement","equilibrium","every position equally","C","potential energy is minimum at equilibrium"],
 [8,"The gauge pressure at depth h in a liquid of density ρ is","ρgh","ρg/h","gh/ρ","ρh/g","A","hydrostatic pressure grows as ρgh"],
 [8,"In steady incompressible flow through a narrower pipe, fluid speed","decreases","increases","is zero","depends only on density","B","continuity requires Av constant"],
 [2,"A passenger lurches forward when a car stops because","a forward force appears","inertia preserves forward motion","the seat removes mass","gravity points forward","B","the passenger tends to maintain velocity"],
 [3,"A force does negative work on an object when it","is perpendicular to displacement","has a component opposite displacement","is larger than weight","acts for less than one second","B","the dot product is negative for an opposing component"],
];

const p2Mcq: Mcq[] = [
 [9,"For an ideal gas at fixed volume, doubling absolute temperature makes pressure","half","unchanged","double","four times","C","P is proportional to T at fixed n and V"],
 [9,"During an isothermal expansion of an ideal gas, its internal-energy change is","positive","negative","zero","equal to pressure","C","ideal-gas internal energy depends only on temperature"],
 [9,"Heat naturally flows from a hot body to a cold body because this","decreases total entropy","increases total entropy","violates energy conservation","makes both temperatures rise","B","spontaneous heat transfer increases total entropy"],
 [10,"The electric field direction at a point is the direction of force on","a positive test charge","a negative test charge","any neutral object","an electron only","A","field direction is defined using a positive test charge"],
 [10,"Moving a positive charge opposite a uniform electric field causes electric potential energy to","decrease","increase","remain zero","become mass","B","potential rises opposite the field for positive charge"],
 [10,"Two identical positive point charges are separated. At their midpoint the electric field is","zero","toward the left charge","toward the right charge","infinite","A","equal fields point oppositely at the midpoint"],
 [11,"Two resistors 3 Ω and 6 Ω in parallel have equivalent resistance","2 Ω","3 Ω","9 Ω","18 Ω","A","reciprocal addition gives 2 ohms"],
 [11,"A 12 V battery drives 3 A through a resistor. Its resistance is","0.25 Ω","4 Ω","9 Ω","36 Ω","B","R=V/I"],
 [11,"Immediately after an uncharged capacitor is connected through a resistor to a battery, the capacitor behaves approximately like","an open circuit","a wire","a charged battery","an inductor","B","initial capacitor voltage is zero"],
 [12,"The magnetic force on a charge moving parallel to a uniform magnetic field is","qvB","qv/B","zero","qB/v","C","the cross product vanishes for parallel vectors"],
 [12,"A changing magnetic flux through a loop induces an emf described by","Coulomb's law","Faraday's law","Snell's law","Stefan's law","B","Faraday's law relates emf to flux change"],
 [12,"Lenz's law determines the induced current's","magnitude only","direction","resistance","charge carrier mass","B","the induced effect opposes the flux change"],
 [13,"When light passes from air into glass, its frequency","increases","decreases","stays the same","becomes zero","C","frequency is fixed by the source and boundary continuity"],
 [13,"A converging lens forms a real inverted image when the object is","inside the focal length","at the lens center","beyond the focal length","at infinity only","C","objects outside f produce real inverted images"],
 [13,"Total internal reflection can occur when light travels","from lower to higher index only","from higher to lower index above the critical angle","at normal incidence only","through a vacuum only","B","TIR requires high-to-low index and sufficiently large incidence angle"],
 [14,"For a wave, speed equals","frequency divided by wavelength","frequency times wavelength","wavelength minus frequency","amplitude times period","B","v=fλ"],
 [14,"Constructive interference occurs when path difference is","an integer multiple of wavelength","a half-integer multiple only","always zero frequency","larger than amplitude","A","integer wavelength differences arrive in phase"],
 [14,"Increasing tension on an ideal string while keeping linear density fixed makes wave speed","decrease","increase","unchanged","zero","B","v=sqrt(T/μ)"],
 [15,"A photon has energy","mc² only","hf","qV always","p²/2m","B","Planck's relation is E=hf"],
 [15,"In the photoelectric effect, increasing light frequency above threshold primarily increases emitted electrons'","maximum kinetic energy","rest mass","charge magnitude","number of protons","A","Kmax=hf-φ"],
];

const pcmMcq: Mcq[] = [
 [1,"If v(t)=3t², the acceleration at t=2 s is","3 m/s²","6 m/s²","12 m/s²","24 m/s²","C","dv/dt=6t"],
 [1,"The displacement from t=0 to T for v(t)=kt is","kT","kT²","kT²/2","k/T","C","integrating kt gives kT²/2"],
 [2,"A force F(x)=ax acts in one dimension. The work from 0 to L is","aL","aL²","aL²/2","a/L","C","the integral of ax dx is aL²/2"],
 [2,"For m dv/dt=-bv, speed varies as","v₀+bt/m","v₀e^{-bt/m}","v₀bt/m","v₀/bt","B","the first-order differential equation has exponential decay"],
 [2,"A particle under F=-kx satisfies","x''+(k/m)x=0","x''-kx=0","x'=k/m","x''=constant positive","A","Newton's law yields the harmonic-oscillator equation"],
 [3,"For conservative U(x), force is","dU/dx","-dU/dx","U/x always","∫U dx","B","force is the negative potential gradient"],
 [3,"A power law P(t)=ct² delivers energy from 0 to T equal to","cT²","cT³/2","cT³/3","2cT","C","energy is the time integral of power"],
 [3,"At a stable equilibrium x₀, U(x) has","a local minimum","a local maximum","an infinite slope","no derivative","A","small displacements raise potential energy"],
 [4,"For variable force F(t), impulse from 0 to T is","F(T)/T","∫₀ᵀF(t)dt","dF/dt","∫F dx","B","impulse is the time integral of force"],
 [4,"A rocket's changing-mass motion is analyzed by applying momentum conservation to","rocket alone without exhaust","rocket plus expelled mass","fuel mass only","Earth only","B","the closed system includes exhaust momentum"],
 [5,"For angular position θ(t), angular acceleration is","dθ/dt","d²θ/dt²","∫θdt","θ²","B","angular acceleration is the second time derivative"],
 [5,"Torque from potential U(θ) is","dU/dθ","-dU/dθ","Uθ","∫U dθ","B","generalized force is minus the potential derivative"],
 [6,"For a continuous body, moment of inertia is","∫r dm","∫r² dm","∫dm/r","Mr always","B","each mass element contributes r²dm"],
 [6,"With zero external torque, dL/dt equals","zero","kinetic energy","mass flow","angular speed","A","torque is the time derivative of angular momentum"],
 [7,"The small-angle pendulum equation is","θ''+(g/L)θ=0","θ''-(g/L)θ=0","θ'=gL","θ''=g","A","sinθ≈θ gives harmonic motion"],
 [7,"The period for x''+ω²x=0 is","ω/2π","2πω","2π/ω","1/ω²","C","one cycle spans angular phase 2π"],
 [1,"If x(t)=At³-Bt, velocity is","3At²-B","At²-B","3At-B","A t³","A","differentiate position with respect to time"],
 [2,"For F(x)=F₀e^{-x/L}, work from 0 to infinity is","F₀/L","F₀L","zero","infinite","B","the exponential integral equals L"],
 [5,"For τ(t)=τ₀t acting on constant I, change in angular speed from 0 to T is","τ₀T/I","τ₀T²/(2I)","Iτ₀T²","τ₀/I T² without 1/2","B","integrate α=τ/I over time"],
 [7,"For a physical pendulum, small-angle ω² equals","mgd/I","I/mgd","g/I","mgI/d","A","linearizing Iθ''=-mgdθ gives ω²=mgd/I"],
];

const pemMcq: Mcq[] = [
 [8,"Gauss's law states the electric flux through a closed surface is","Q_enclosed/ε₀","ε₀Q_enclosed","Q_total outside/ε₀","always zero","A","closed-surface flux depends on enclosed charge"],
 [8,"For spherical charge density ρ(r), enclosed charge to radius R is","∫₀ᴿρ(r)4πr²dr","ρ(R)R","∫ρ dr only","4πR²/ρ","A","integrate density over spherical volume elements"],
 [8,"The divergence of the electrostatic field in charge-free space is","ρ/ε₀","zero","infinite","the potential","B","Gauss's differential law gives ∇·E=ρ/ε₀"],
 [9,"Electric potential difference from a to b is","∫aᵇE·dl","-∫aᵇE·dl","∇×E","qE²","B","potential decreases along the electric field"],
 [9,"For electrostatics, E is related to V by","E=∇V","E=-∇V","E=∇×V","E=∫Vdt","B","the field is the negative potential gradient"],
 [9,"A stationary point of V has","∇V=0","V=0 necessarily","infinite charge necessarily","nonzero curl E","A","the gradient vanishes at a stationary point"],
 [10,"Capacitance of parallel plates neglecting edges is","εA/d","εd/A","Ad/ε","d/(εA)","A","C=Q/ΔV=εA/d"],
 [10,"Energy stored in a capacitor is","CV²","CV²/2","C/V²","2C/V","B","integrating V dq gives one-half CV²"],
 [10,"In electrostatic equilibrium inside a conductor, E is","maximum","zero","parallel to every direction","time varying","B","free charges rearrange until the interior field vanishes"],
 [11,"For capacitor discharge through R, charge follows","Q₀e^{-t/RC}","Q₀e^{t/RC}","Q₀t/RC","Q₀cos(t/RC)","A","the RC differential equation gives exponential decay"],
 [11,"The RC time constant has value","R/C","RC","C/R","1/RC","B","resistance times capacitance has units of time"],
 [11,"Kirchhoff's junction rule follows from conservation of","energy","charge","angular momentum","mass only","B","current continuity prevents charge accumulation at an ideal junction"],
 [12,"Biot-Savart contributions have direction set by","dl×r-hat","r-hat×dl","dl·r-hat","charge velocity only","A","the magnetic field element follows the cross product dl×rhat"],
 [12,"Ampère's law in magnetostatics is useful when symmetry makes","B constant/tangent on a loop","E zero everywhere","current vanish","potential discontinuous","A","symmetry lets B leave the line integral"],
 [12,"Magnetic force on a current element is","I dl×B","I dl·B","IB/dl","qE","A","dF=I dl×B"],
 [13,"Faraday's law in integral form gives emf equal to","dΦB/dt","-dΦB/dt","ΦB/t only","∇·B","B","the minus sign encodes Lenz's law"],
 [13,"For an LR circuit connected to a DC source, current approaches steady state with time constant","L/R","R/L","LR","1/LR","A","solving L di/dt+Ri=V gives τ=L/R"],
 [13,"An ideal LC circuit has angular frequency","LC","1/LC","1/√(LC)","√(LC)","C","the charge equation is q''+q/(LC)=0"],
 [8,"For a point charge, ∇·E is zero everywhere except","at infinity","at the charge location","on every sphere","along one axis","B","the source is represented by a delta distribution at the charge"],
 [13,"Induced electric fields from changing magnetic flux are","conservative with zero circulation","nonconservative with nonzero circulation","always radial","always zero in vacuum","B","Faraday's law gives nonzero closed-loop circulation"],
];

const subjects: Subject[] = [
 {key:"ap-chemistry",name:"AP Chemistry",examCode:"ap_chemistry",examDate:"2026-05-05",prefix:"apchem",chemistry:true,
  units:[[1,"Atomic Structure and Properties",.07,.09],[2,"Compound Structure and Properties",.07,.09],[3,"Properties of Substances and Mixtures",.18,.22],[4,"Chemical Reactions",.07,.09],[5,"Kinetics",.07,.09],[6,"Thermochemistry",.07,.09],[7,"Equilibrium",.07,.09],[8,"Acids and Bases",.11,.15],[9,"Thermodynamics and Electrochemistry",.07,.09]],
  practices:["Models and Representations","Question and Method","Representing Data and Phenomena","Model Analysis","Mathematical Routines","Argumentation"],mcq:chemMcq,frq:[]},
 {key:"ap-physics-1",name:"AP Physics 1",examCode:"ap_physics_1",examDate:"2026-05-06",prefix:"apphy1",
  units:[[1,"Kinematics",.10,.15],[2,"Force and Translational Dynamics",.18,.23],[3,"Work, Energy, and Power",.18,.23],[4,"Linear Momentum",.10,.15],[5,"Torque and Rotational Dynamics",.10,.15],[6,"Energy and Momentum of Rotating Systems",.05,.08],[7,"Oscillations",.05,.08],[8,"Fluids",.10,.15]],
  practices:["Creating Representations","Mathematical Routines","Scientific Questioning and Argumentation"],mcq:p1Mcq,frq:[]},
 {key:"ap-physics-2",name:"AP Physics 2",examCode:"ap_physics_2",examDate:"2026-05-07",prefix:"apphy2",
  units:[[9,"Thermodynamics",.15,.18],[10,"Electric Force, Field, and Potential",.15,.18],[11,"Electric Circuits",.15,.18],[12,"Magnetism and Electromagnetism",.12,.15],[13,"Geometric Optics",.12,.15],[14,"Waves, Sound, and Physical Optics",.12,.15],[15,"Modern Physics",.12,.15]],
  practices:["Creating Representations","Mathematical Routines","Scientific Questioning and Argumentation"],mcq:p2Mcq,frq:[]},
 {key:"ap-physics-c-mechanics",name:"AP Physics C: Mechanics",examCode:"ap_physics_c_mechanics",examDate:"2026-05-13",prefix:"apphycm",calculus:true,
  units:[[1,"Kinematics",.10,.15],[2,"Force and Translational Dynamics",.20,.25],[3,"Work, Energy, and Power",.15,.25],[4,"Linear Momentum",.10,.20],[5,"Torque and Rotational Dynamics",.10,.15],[6,"Energy and Momentum of Rotating Systems",.10,.15],[7,"Oscillations",.10,.15]],
  practices:["Creating Representations","Mathematical Routines","Scientific Questioning and Argumentation"],mcq:pcmMcq,frq:[]},
 {key:"ap-physics-c-em",name:"AP Physics C: Electricity and Magnetism",examCode:"ap_physics_c_em",examDate:"2026-05-13",prefix:"apphycem",calculus:true,
  units:[[8,"Electric Charges, Fields, and Gauss's Law",.15,.25],[9,"Electric Potential",.10,.20],[10,"Conductors and Capacitors",.10,.15],[11,"Electric Circuits",.15,.25],[12,"Magnetic Fields and Electromagnetism",.10,.20],[13,"Electromagnetic Induction",.10,.20]],
  practices:["Creating Representations","Mathematical Routines","Scientific Questioning and Argumentation"],mcq:pemMcq,frq:[]},
];

const frqSeeds: Record<string, Frq[]> = {
 "ap-chemistry":[
  [1,"A 2.50 g carbonate sample reacts completely and produces 0.0118 mol CO₂.","Determine the carbonate mass fraction and justify the mole relationship.","Use balanced stoichiometry; mass fraction requires the carbonate molar mass and sample mass.",["mole ratio","mass fraction"]],
  [2,"Two candidate Lewis structures are proposed for SO₂.","Choose the lower-formal-charge representation and explain resonance and molecular shape.","Equivalent resonance contributors have bent molecular geometry and delocalized bonding.",["formal charge","resonance","bent"]],
  [3,"A gas sample at 298 K occupies 1.80 L at 0.950 atm.","Calculate moles using PV=nRT and explain a likely high-pressure deviation.","n=PV/RT; attractions or particle volume cause nonideal behavior.",["PV=nRT","intermolecular"]],
  [4,"25.0 mL of 0.120 M AgNO₃ is mixed with excess chloride.","Calculate AgCl precipitate moles and write the net ionic equation.","0.00300 mol AgCl; Ag+ + Cl- → AgCl(s).",["0.00300","Ag+","Cl-"]],
  [5,"Initial-rate data show rate doubles when [A] doubles and quadruples when [B] doubles.","Determine the rate law and describe a compatible slow elementary step.","rate=k[A][B]^2; a compatible slow step must match this molecular dependence or follow a justified mechanism.",["first order","second order"]],
  [6,"A 75.0 g solution absorbs 3.14 kJ and warms 10.0°C.","Calculate its specific heat and state the sign of q for the solution.","c=4.19 J g^-1 K^-1 and q is positive.",["4.19","positive"]],
  [7,"For A⇌B, K=4.0 and an initial mixture has Q=0.50.","Predict the shift and explain how concentrations change until equilibrium.","The reaction shifts right; Q rises toward K as B increases and A decreases.",["right","Q","K"]],
  [8,"A buffer has equal concentrations of HA and A− with pKa=4.76.","Determine pH and explain the response to a small addition of strong acid.","pH=4.76; A− consumes added H+ to form HA.",["4.76","conjugate base"]],
  [9,"A cell transfers 2 mol electrons with E°=0.250 V.","Calculate ΔG° and connect its sign to spontaneity.","ΔG°=-nFE°≈-48.2 kJ mol^-1, so the standard reaction is favorable.",["-48.2","negative"]],
  [3,"Beer-Lambert data give slope 1.50×10⁴ L mol⁻¹ for a 1 cm cell.","Find concentration for absorbance 0.450 and identify one dilution error.","c=3.00×10^-5 M; quantitative transfer and final-volume errors alter the result.",["3.00","dilution"]],
  [4,"A titration reaches equivalence after 18.60 mL titrant is delivered.","Describe a precise endpoint procedure and predict the effect of overshooting.","Approach dropwise with mixing; overshoot makes calculated analyte amount too large.",["dropwise","too large"]],
  [5,"An Arrhenius plot of ln k versus 1/T has slope -7200 K.","Calculate Ea and explain why k increases with temperature.","Ea=59.9 kJ mol^-1; a larger fraction of collisions exceeds Ea.",["59.9","activation energy"]],
  [6,"A reaction has ΔH=+35 kJ mol⁻¹ and ΔS=+120 J mol⁻¹ K⁻¹.","Find the temperature above which it is favorable.","T>ΔH/ΔS≈292 K.",["292","ΔG"]],
  [7,"Ksp for MX is 4.0×10⁻¹².","Calculate molar solubility in pure water and explain a common-ion effect.","s=sqrt(Ksp)=2.0×10^-6 M; a common ion lowers solubility.",["2.0","common ion"]],
  [8,"A weak acid has Ka=1.0×10⁻⁵ and initial concentration 0.100 M.","Estimate pH and state the small-x check.","[H+]≈sqrt(KaC)=1.0×10^-3 M, pH≈3.00; ionization is about 1%.",["3.00","small"]],
  [9,"Electrolysis runs at 2.00 A for 965 s.","Calculate moles of electrons and identify the cathode process.","n(e-)=It/F=0.0200 mol; reduction occurs at the cathode.",["0.0200","reduction"]]
 ],
};

const physicsModels: Record<string,Record<number,[string,string,string[]]>>={
 "ap-physics-1":{
  1:["A cart starts from rest and accelerates uniformly at 1.50 m/s² for 4.00 s.","v=6.00 m/s and Δx=12.0 m from constant-acceleration relations.",["6.00","12.0","constant acceleration"]],
  2:["A 3.00 kg block is pulled horizontally by 15.0 N while kinetic friction is 6.00 N.","The net force is 9.00 N and acceleration is 3.00 m/s².",["9.00","3.00","net force"]],
  3:["A 0.500 kg cart moving at 4.00 m/s compresses an ideal spring of constant 200 N/m on a level frictionless track.","Energy conservation gives maximum compression x=0.200 m.",["kinetic energy","spring energy","0.200"]],
  4:["A 2.00 kg cart at 3.00 m/s sticks to a 1.00 kg cart initially at rest.","Momentum conservation gives final speed 2.00 m/s; kinetic energy decreases.",["momentum","2.00","kinetic energy"]],
  5:["A uniform 2.00 m beam weighing 100 N is hinged at one end and held horizontal by a vertical cable at the other end.","Torque balance about the hinge gives cable tension 50.0 N.",["torque","lever arm","50.0"]],
  6:["A solid cylinder rolls without slipping down a vertical drop h from rest.","Using I=MR²/2 and v=ωR gives v=sqrt(4gh/3).",["rotational kinetic energy","v=ωR","sqrt(4gh/3)"]],
  7:["A 0.250 kg mass on an ideal 100 N/m spring oscillates with amplitude 0.080 m.","The angular frequency is 20.0 rad/s and maximum speed is 1.60 m/s.",["20.0","1.60","equilibrium"]],
  8:["Water flows steadily from a 4.00 cm² section of a horizontal pipe at 2.00 m/s into a 1.00 cm² section.","Continuity gives 8.00 m/s in the narrow section; Bernoulli predicts lower static pressure there.",["continuity","8.00","lower pressure"]]},
 "ap-physics-2":{
  9:["One mole of an ideal monatomic gas is heated at constant volume from 300 K to 360 K.","W=0 and ΔU=(3/2)nRΔT≈748 J, so Q≈748 J.",["constant volume","748","first law"]],
  10:["Two +2.00 μC point charges are 0.400 m apart; consider their midpoint.","The equal electric fields cancel at the midpoint while electric potential is positive and adds.",["field cancels","potential adds","positive"]],
  11:["An initially uncharged 20.0 μF capacitor charges through 100 kΩ from a 12.0 V battery.","The time constant is RC=2.00 s and Vc(t)=12.0(1-e^{-t/2.00}) V.",["2.00","exponential","initially uncharged"]],
  12:["A singly charged positive ion moves at 3.00×10⁵ m/s perpendicular to a uniform 0.200 T magnetic field.","The magnetic force magnitude is qvB and supplies centripetal force; the path is circular.",["qvB","centripetal","circular"]],
  13:["A converging lens has focal length 0.200 m and an object is 0.600 m from the lens.","The thin-lens equation gives image distance 0.300 m and magnification -0.500.",["thin-lens equation","0.300","-0.500"]],
  14:["Two coherent sources have wavelength 0.500 m and path difference 1.25 m at a detector.","The 2.5-wavelength path difference produces destructive interference.",["2.5","destructive","phase"]],
  15:["Light of photon energy 3.20 eV illuminates a metal with work function 2.00 eV.","The maximum photoelectron kinetic energy is 1.20 eV and the stopping potential is 1.20 V.",["1.20 eV","stopping potential","energy conservation"]]},
 "ap-physics-c-mechanics":{
  1:["A particle moves on the x-axis with velocity v(t)=αt², where α>0 and x(0)=0.","Integrating gives x(t)=αt³/3 and differentiating gives a(t)=2αt.",["integral","αt³/3","2αt"]],
  2:["A mass m moves through a medium with drag force F=-bv and initial speed v₀.","Solving m dv/dt=-bv gives v(t)=v₀e^{-bt/m} and x(t)=mv₀(1-e^{-bt/m})/b.",["differential equation","exponential","initial condition"]],
  3:["A particle moves in one dimension in potential U(x)=ax⁴-bx² with a,b>0.","F=-4ax³+2bx; stable equilibria are x=±sqrt(b/2a), where U has minima.",["-dU/dx","sqrt(b/2a)","stable"]],
  4:["A time-dependent force F(t)=F₀(1-t/T) acts on a mass initially at rest for 0≤t≤T.","Impulse ∫₀ᵀFdt=F₀T/2, so final momentum is F₀T/2.",["integral","F₀T/2","momentum"]],
  5:["A disk of constant moment of inertia I experiences torque τ(t)=τ₀e^{-t/T} from rest.","Integrating I dω/dt=τ gives ω(t)=τ₀T(1-e^{-t/T})/I.",["angular acceleration","integral","τ₀T/I"]],
  6:["A thin rod of length L and mass M has linear density λ(x)=2Mx/L² measured from one end.","I about x=0 is ∫₀ᴸx²λ(x)dx=ML²/2.",["dm=λdx","integral","ML²/2"]],
  7:["A physical pendulum of mass M has pivot-to-center distance d and moment of inertia I about the pivot.","Linearizing Iθ''=-Mgd sinθ gives θ''+(Mgd/I)θ=0 and T=2πsqrt(I/Mgd).",["differential equation","small angle","2πsqrt(I/Mgd)"]]},
 "ap-physics-c-em":{
  8:["A nonconducting sphere of radius R has volume charge density ρ(r)=ρ₀r/R.","Gauss's law with Qenc=∫₀ʳρ(r')4πr'²dr' gives E(r)=ρ₀r²/(4ε₀R) inside.",["volume integral","Gauss","ρ₀r²/(4ε₀R)"]],
  9:["On the x-axis the electric potential is V(x)=V₀e^{-x/L} for x≥0.","Eₓ=-dV/dx=(V₀/L)e^{-x/L}, directed in +x.",["negative gradient","derivative","+x"]],
  10:["A parallel-plate capacitor has plate area A, separation d, and dielectric ε; it is charged from 0 to Q.","C=εA/d and U=∫₀^Q(q/C)dq=Q²/(2C).",["capacitance","integral","Q²/(2C)"]],
  11:["A capacitor C initially at voltage V₀ discharges through resistance R at t=0.","Solving RC dV/dt+V=0 gives V=V₀e^{-t/RC} and I=-(V₀/R)e^{-t/RC}.",["differential equation","initial condition","exponential"]],
  12:["A long straight wire carries current I along +z; find the field using a circular Amperian loop of radius r.","∮B·dl=B(2πr)=μ₀I, so B=μ₀I/(2πr) in the azimuthal direction.",["line integral","μ₀I/(2πr)","azimuthal"]],
  13:["An LR circuit with inductance L and resistance R is connected to constant emf ℰ at t=0 with I(0)=0.","Solving L dI/dt+RI=ℰ gives I=(ℰ/R)(1-e^{-Rt/L}) and time constant L/R.",["differential equation","initial condition","L/R"]]},
};

function physicsFrqs(s: Subject): Frq[] {
 return Array.from({length:16},(_,i)=>{
  const unit=s.units[i%s.units.length]; const type=i<4?"mathematical routine":i<8?"representation translation":i<12?"experimental design":"qualitative/quantitative translation";
  const [context,solution,evidence]=physicsModels[s.key][unit[0]];
  const task=type==="mathematical routine"?"Derive the stated observable from the supplied conditions and evaluate any given values.":type==="representation translation"?"Translate the governing relation into a labeled graph or diagram and explain its key slope, area, or direction.":type==="experimental design"?"Design a feasible measurement that tests the governing relation; identify the independent variable, dependent variable, and one control.":"Predict how the observable changes when the defining scale parameter is doubled, and justify the prediction quantitatively.";
  return [unit[0],`${type}: ${context}`,task,solution,evidence] as Frq;
 });
}
for (const s of subjects) if (!s.chemistry) s.frq=physicsFrqs(s); else s.frq=frqSeeds[s.key];

const slug=(v:string)=>v.toLowerCase().replaceAll(/[^a-z0-9]+/g,"-").replaceAll(/^-|-$/g,"");
const generatedAt="2026-07-15T00:00:00Z";
const difficulties=[...Array(5).fill("Easy"),...Array(8).fill("Medium"),...Array(5).fill("Hard"),...Array(2).fill("Very Hard")];
const frqDifficulties=[...Array(4).fill("Easy"),...Array(6).fill("Medium"),...Array(4).fill("Hard"),...Array(2).fill("Very Hard")];

function archetypes(s:Subject){
 const practiceRefs=s.practices.map((_,i)=>`practice-${i+1}`);
 const common={version:"1.0.0",practice_refs:practiceRefs,response_modalities:["typed-text","typed-math"]};
 if(s.chemistry) return [
  {archetype_key:`${s.key}-mcq`,version:"1.0.0",item_type:"mcq",total_points:1,practice_refs:practiceRefs,response_modalities:["choice"]},
  {...common,archetype_key:`${s.key}-frq-long`,item_type:"frq",total_points:4},
  {...common,archetype_key:`${s.key}-frq-short`,item_type:"frq",total_points:2},
 ];
 return [
  {archetype_key:`${s.key}-mcq`,version:"1.0.0",item_type:"mcq",total_points:1,practice_refs:practiceRefs,response_modalities:["choice"]},
  ...["math","representation","experimental","translation"].map(k=>({...common,archetype_key:`${s.key}-frq-${k}`,item_type:"frq",total_points:2}))
 ];
}

async function writeJson(path:string,value:any){
 await Deno.mkdir(path.substring(0,path.lastIndexOf("/")),{recursive:true});
 await Deno.writeTextFile(path,JSON.stringify(value,null,2)+"\n");
}
async function itemHash(item:any){const copy=structuredClone(item);delete copy.provenance.content_sha256;return await sha256(canonicalJson(copy));}

function subjectPackage(s:Subject){
 const exists=["ap-chemistry","ap-physics-1"].includes(s.key);
 const sourceKey=`${s.key}-ced-fact-pack`;
 const nodes=[...s.units.map(([n,title])=>({node_key:`unit-${n}-${slug(title)}`,node_type:"unit",label:title,ordinal:n,source_refs:[sourceKey]})),...s.practices.map((p,i)=>({node_key:`practice-${i+1}`,node_type:"practice",label:p,ordinal:i+1,source_refs:[sourceKey]}))];
 const arch=archetypes(s);
 return {schema_version:"1.0.0",package_id:`${s.key}-2025-26-seed`,operation:exists?"create-exam-pack-version":"create-subject",
  subject:{subject_key:s.key,display_name:s.name,...(exists?{existing_subject_key:s.key}:{})},
  exam_pack:{exam_code:s.examCode,exam_name:s.name,school_year:"2025-26",official_exam_date:s.examDate,exam_pack_version:"1.0.0",effective_from:"2025-07-01"},
  sources:[{source_key:sourceKey,source_version:"2026-07-15",title:`${s.name} CED Fact Pack`,publisher:"Cramapple",authority_tier:1,uri:`https://cramapple.local/docs/product/${s.key}-ced-fact-pack`,content_sha256:"0".repeat(64),scope:"Public exam structure and taxonomy metadata; no official question content.",rights_status:"cramapple_owned",refresh_due_at:"2027-06-01T00:00:00Z"}],
  taxonomy:{scheme_key:`${s.key}-2025-26`,scheme_version:"1.0.0",nodes},
  blueprint:{sections:[{section_key:"multiple-choice",duration_minutes:s.chemistry?90:80,score_weight:.5,item_count:s.chemistry?60:40,item_types:["mcq"]},{section_key:"free-response",duration_minutes:s.chemistry?105:100,score_weight:.5,item_count:s.chemistry?7:4,item_types:["frq"]}],taxonomy_weights:s.units.map(([n,title,min,max])=>({taxonomy_node_key:`unit-${n}-${slug(title)}`,minimum:min,maximum:max}))},
  archetypes:arch,capabilities:{required_renderers:["markdown","math","table"],required_response_modalities:["choice","typed-text","typed-math"],required_graders:["mcq-key","science-frq-rubric"],calculator_modes:["approved-handheld"]},
  inventory:{targets:arch.map(a=>({item_type:a.item_type,archetype_key:a.archetype_key,target_count:a.item_type==="mcq"?(s.chemistry?60:40):(s.chemistry?(a.archetype_key.endsWith("long")?6:10):4) }))},
  verification:{profile_version:"1.0.0",required_check_types:["schema","content-correctness","answer-rubric-consistency","grading-calibration","security-privacy"],gold_set_required:true,minimum_gold_items:20,calibration_notes:"Draft seed only; independent Tutor review and held-out calibration are required before publication."},
  review_policy:{policy_version:"1.0.0",required_capabilities:[`${s.key}-subject-matter`,"assessment-review"],independence_required:true,minimum_reviewers:2},
  release_gates:["source","rights","content_clearance","grading_calibration","security_privacy","release_approval"],provenance:{fact_pack_version:`${s.key.toUpperCase().replaceAll("-","_")}_CED_FACT_PACK@2026-07-15`,authoring_prompt_version:"CODEX_FIVE_SUBJECT_CONTENT_AUTHORING_2026_07_15",generated_by:"Codex",generated_at:generatedAt},supersession:{strategy:exists?"preserve-prior-pack":"none"}};
}

async function makeMcq(s:Subject,spec:Mcq,i:number){
 const [unit,stem,a,b,c,d,key,why]=spec; const choices=[a,b,c,d]; const content=`${s.prefix}-mcq-${String(i+1).padStart(3,"0")}`;
 const unitTitle=s.units.find(u=>u[0]===unit)![1];
 const item:any={schema_version:"1.0.0",package_id:content,content_key:content,content_version:1,difficulty:difficulties[i],exam_pack_ref:{exam_code:s.examCode,school_year:"2025-26",exam_pack_version:"1.0.0"},item_type:"mcq",archetype_ref:{archetype_key:`${s.key}-mcq`,version:"1.0.0"},taxonomy_refs:[{scheme_key:`${s.key}-2025-26`,scheme_version:"1.0.0",node_key:`unit-${unit}-${slug(unitTitle)}`},{scheme_key:`${s.key}-2025-26`,scheme_version:"1.0.0",node_key:`practice-${i%s.practices.length+1}`}],stimuli:[],mcq_choices:choices.map((text,j)=>({choice_key:"ABCD"[j],choice_text:text,is_correct:"ABCD"[j]===key,rationale:"ABCD"[j]===key?why:`This option conflicts with ${why}.`})),canonical_answers:[key],parts:[{part_key:"question",ordinal:1,prompt:`${stem}\n\n${choices.map((x,j)=>`${"ABCD"[j]}. ${x}`).join("\n")}`,response_modalities:["choice"],points:1,criteria:[{criterion_key:"correct-answer",points:1,description:"Select the single scientifically correct answer.",required_evidence:[key,why],deterministic_checks:[{check_type:"choice-key",parameters:{choice:key}}]}]}],accessibility:{language:"en",screen_reader_review_required:false,accommodation_notes:"All information is text-based."},review_notes:{expected_reasoning:why,known_boundary_cases:i>=18?["Check notation, sign, or limiting-case reasoning."]:[],originality_statement:"Independently authored synthetic practice item; no official question or scoring material used."},provenance:{source_refs:[`${s.key}-ced-fact-pack`],fact_pack_version:"2026-07-15",authoring_prompt_version:"CODEX_FIVE_SUBJECT_CONTENT_AUTHORING_2026_07_15",generated_by:"codex",generated_at:generatedAt,content_sha256:""}};
 item.provenance.content_sha256=await itemHash(item); return item;
}

async function makeFrq(s:Subject,spec:Frq,i:number){
 const [unit,context,task,answer,evidence]=spec; const isLong=!!s.chemistry&&i<6; const form=isLong?"long":"short";
 const type=s.chemistry?form:["math","representation","experimental","translation"][Math.floor(i/4)];
 const content=s.chemistry?(isLong?`${s.prefix}-frq-l-${String(i+1).padStart(3,"0")}`:`${s.prefix}-sfrq-${String(i-5).padStart(3,"0")}`):`${s.prefix}-frq-${String(i+1).padStart(3,"0")}`;
 const unitTitle=s.units.find(u=>u[0]===unit)![1]; const count=isLong?4:2;
 const prompts=[task,"Explain how the governing principle and the stated assumptions support the result.","Describe a measurement or representation that could test the result.","Identify one boundary case or systematic error and predict its effect."];
 const parts=Array.from({length:count},(_,j)=>({part_key:`part-${String.fromCharCode(97+j)}`,ordinal:j+1,label:`(${String.fromCharCode(97+j)})`,prompt:prompts[j],response_modalities:j===0?["typed-text","typed-math"]:["typed-text"],points:1,criteria:[{criterion_key:`part-${String.fromCharCode(97+j)}-criterion`,points:1,description:j===0?answer:prompts[j].replace(/[.?]$/,""),required_evidence:j===0?evidence:(j===1?["governing principle","assumption"]:j===2?["measured variable","controlled variable"]:["direction of effect","justification"]),accepted_variants:["Equivalent scientifically correct notation and reasoning earn credit."],deterministic_checks:[{check_type:"keyword-evidence",parameters:{keywords:j===0?evidence.slice(0,3):(j===1?["principle","assumption"]:j===2?["measure","control"]:["effect","because"])}}]}]}));
 const item:any={schema_version:"1.0.0",package_id:content,content_key:content,content_version:1,difficulty:frqDifficulties[i],frq_form:form,canonical_answers:[answer],exam_pack_ref:{exam_code:s.examCode,school_year:"2025-26",exam_pack_version:"1.0.0"},item_type:"frq",archetype_ref:{archetype_key:`${s.key}-frq-${type}`,version:"1.0.0"},taxonomy_refs:[{scheme_key:`${s.key}-2025-26`,scheme_version:"1.0.0",node_key:`unit-${unit}-${slug(unitTitle)}`},{scheme_key:`${s.key}-2025-26`,scheme_version:"1.0.0",node_key:`practice-${i%s.practices.length+1}`}],stimuli:[{stimulus_key:"scenario",ordinal:1,kind:"text",payload:{text:context},source_refs:[`${s.key}-ced-fact-pack`]}],parts:parts.map(p=>({...p,stimulus_refs:["scenario"]})),accessibility:{language:"en",screen_reader_review_required:false,accommodation_notes:"Text and symbolic notation are fully described."},review_notes:{expected_reasoning:answer,known_boundary_cases:i>=14?["Award credit only when the conclusion follows from explicit evidence.","Check units, sign, and stated approximation."]:[],originality_statement:"Independently authored synthetic draft for Tutor review; no official question or scoring material used."},provenance:{source_refs:[`${s.key}-ced-fact-pack`],fact_pack_version:"2026-07-15",authoring_prompt_version:"CODEX_FIVE_SUBJECT_CONTENT_AUTHORING_2026_07_15",generated_by:"codex",generated_at:generatedAt,content_sha256:""}};
 item.provenance.content_sha256=await itemHash(item);return item;
}

const factPackPaths: Record<string,string> = {
 "ap-chemistry":"docs/product/AP_CHEMISTRY_CED_FACT_PACK.md",
 "ap-physics-1":"docs/product/AP_PHYSICS_1_CED_FACT_PACK.md",
 "ap-physics-2":"docs/product/AP_PHYSICS_2_CED_FACT_PACK.md",
 "ap-physics-c-mechanics":"docs/product/AP_PHYSICS_C_MECHANICS_CED_FACT_PACK.md",
 "ap-physics-c-em":"docs/product/AP_PHYSICS_C_EM_CED_FACT_PACK.md",
};
for(const s of subjects){
 const subject=subjectPackage(s);
 subject.sources[0].content_sha256=await sha256(await Deno.readTextFile(factPackPaths[s.key]));
 await writeJson(`content/subject-packages/${s.key}.subject-package.json`,subject);
 for(let i=0;i<s.mcq.length;i++) await writeJson(`content/item-packages/${s.key}/${s.prefix}-mcq-${String(i+1).padStart(3,"0")}.json`,await makeMcq(s,s.mcq[i],i));
 for(let i=0;i<s.frq.length;i++) {const item=await makeFrq(s,s.frq[i],i);await writeJson(`content/item-packages/${s.key}/${item.package_id}.json`,item);}
}
console.log(JSON.stringify({subjects:subjects.length,items:subjects.reduce((n,s)=>n+s.mcq.length+s.frq.length,0)}));
