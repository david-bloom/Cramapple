import json
# taxonomy.json per pack (from app.taxonomy_topics, Production, 2026-10-04)
def mk(units,T,first):
    return dict(units=[dict(n=u,title=t) for u,t in units],topics=[dict(code=f"{u}.{i+1}",title=t,unit=u) for u,l in T.items() for i,t in enumerate(l)],skills=[])
em=mk([(8,"Electric Charges, Fields, and Gauss's Law"),(9,"Electric Potential"),(10,"Conductors and Capacitors")],{
8:["Electric Charge and Electric Force","Conservation of Electric Charge and the Process of Charging","Electric Fields","Electric Fields of Charge Distributions","Electric Flux","Gauss's Law"],
9:["Electric Potential Energy","Electric Potential","Conservation of Electric Energy"],
10:["Electrostatics with Conductors","Redistribution of Charge between Conductors","Capacitors","Dielectrics"]},0)
cm=mk([(1,"Kinematics"),(2,"Force and Translational Dynamics"),(3,"Work, Energy, and Power")],{
1:["Scalars and Vectors","Displacement, Velocity, and Acceleration","Representing Motion","Reference Frames and Relative Motion","Motion in Two or Three Dimensions"],
2:["Systems and Center of Mass","Forces and Free-Body Diagrams","Newton's Third Law","Newton's First Law","Newton's Second Law","Gravitational Force","Kinetic and Static Friction","Spring Forces","Resistive Forces","Circular Motion"],
3:["Translational Kinetic Energy","Work","Potential Energy","Conservation of Energy","Power"]},0)
p2=mk([(9,"Thermodynamics"),(10,"Electric Force, Field, and Potential"),(11,"Electric Circuits")],{
9:["Kinetic Theory of Temperature and Pressure","The Ideal Gas Law","Thermal Energy Transfer and Equilibrium","The First Law of Thermodynamics","Specific Heat and Thermal Conductivity","Entropy and the Second Law of Thermodynamics"],
10:["Electric Charge and Electric Force","Conservation of Electric Charge and the Process of Charging","Electric Fields","Electric Potential Energy","Electric Potential","Capacitors","Conservation of Electric Energy"],
11:["Electric Current","Simple Circuits","Resistance, Resistivity, and Ohm's Law","Electric Power","Compound Direct Current (DC) Circuits","Kirchhoff's Loop Rule","Kirchhoff's Junction Rule","Resistor-Capacitor (RC) Circuits"]},0)
for n,t in (('em',em),('cm',cm),('p2',p2)): json.dump(t,open(f'taxonomy_{n}.json','w'),indent=1,ensure_ascii=False)
