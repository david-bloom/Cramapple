export const lessons = {
 calc:{
 title:"Water in a tank",topic:"Calculus · Average rate of change",
 question:"The volume of water in a tank is V(t) = t² + 4t liters, where t is measured in minutes. What is the average rate of change of the volume from t = 1 to t = 5 minutes?",
 choices:["40 liters/min","10 liters/min","14 liters/min","45 liters/min"],correct:1,
 highlights:["average rate of change","t = 1 to t = 5 minutes"],
 facts:[
 {id:"calc-rate",title:"Average rate of change",text:"Average rate = change in output divided by change in input: [V(b) − V(a)] / (b − a). This is the secant slope through the endpoints, not the derivative at one endpoint."},
 {id:"calc-values",title:"The endpoint values",text:"V(1) = 1² + 4×1 = 5 L. V(5) = 5² + 4×5 = 45 L. Volume change: 45 − 5 = 40 L. Elapsed time: 5 − 1 = 4 minutes. Average rate: 40 / 4 = 10 L/min."},
 {id:"calc-recall",title:"Recall aid",text:"Change in water over change in time. End minus start on top and bottom. This is a demo-authored explanation, not a claim that this phrase is in the published hook bank."}
 ],solution:"(45 − 5) / (5 − 1) = 40 / 4 = 10 liters per minute.",
 focuses:["What does average rate mean?","How do I calculate V(5)?","Why divide by time?","Help me remember the formula"]
 },
 chem:{
 title:"How concentrated is it?",topic:"Chemistry · Molarity",
 question:"A solution contains 0.30 mol of NaCl in a total solution volume of 150 mL. What is the molarity of the solution?",
 choices:["0.0020 M","2.0 M","0.50 M","45 M"],correct:1,
 highlights:["0.30 mol of NaCl","total solution volume of 150 mL","molarity"],
 facts:[
 {id:"chem-molarity",title:"Molarity",text:"M = moles of solute / liters of solution. M means mol/L. Use the total solution volume, not just the added solvent."},
 {id:"chem-units",title:"Convert the volume",text:"1,000 mL = 1 L. 150 mL / 1,000 = 0.150 L. 0.30 mol / 0.150 L = 2.0 mol/L = 2.0 M. Dividing 0.30 by 150 gives 0.0020 mol/mL, a different unit from M."},
 {id:"chem-recall",title:"Recall aid",text:"Moles per liter: per means divide. Moles on top, liters below. Divide mL by 1,000 to get L. This phrase is demo-authored, not a claim that it is a published hook."}
 ],solution:"150 mL = 0.150 L. M = 0.30 mol / 0.150 L = 2.0 M.",
 focuses:["What is molarity?","Why convert to liters?","How does the formula work?","Help me remember the formula"]
 }
} as const;
export type Subject=keyof typeof lessons;
