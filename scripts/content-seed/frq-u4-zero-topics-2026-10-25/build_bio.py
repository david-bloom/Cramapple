import json
def C(text, evidence, fix, v=None):
    return {"text": text, "evidence": evidence, "fix": fix, "accepted_variants": v or []}
def P(prompt, *crit):
    return {"prompt": prompt, "criteria": list(crit)}
items = []

# ---------------- AP Biology 4.2 (A) ---------------- (round 2: replaced; round 1 voted 6 of 6 for 4.3)
items.append({"subject_key": "ap_biology", "topic_code": "4.2", "item": {
 "title": "Amplification in a Hormone Signal Transduction Pathway",
 "calculator": "not_applicable",
 "stimulus": """Epinephrine is a hormone released into the blood during stress. It binds to a G protein-coupled receptor (GPCR) in the plasma membrane of liver cells. The activated receptor activates a G protein, and the G protein activates the enzyme adenylyl cyclase. Adenylyl cyclase converts ATP to the second messenger cAMP. cAMP activates protein kinase A, a protein kinase that phosphorylates and activates the next enzyme in the pathway. A series of such steps ends with the activation of glycogen phosphorylase, an enzyme that breaks down glycogen to release glucose.

For each step, the table gives the approximate number of activated molecules produced per single activated receptor.

Step | Activated molecules per activated receptor
1. Receptor | 1
2. G protein | 100
3. Adenylyl cyclase | 100
4. cAMP | 10,000
5. Protein kinase A | 10,000
6. Glycogen phosphorylase | 1,000,000""",
 "parts": [
  P("Identify the second messenger in this pathway, and explain how the signal can be passed into the cell even though epinephrine itself does not enter the cell.",
    C("Identifies cAMP as the second messenger in the pathway.",
      "Response names cAMP (cyclic AMP) as the second messenger.",
      "Find the small molecule that adenylyl cyclase produces from ATP; that molecule relays the signal and is the second messenger.", ["cyclic AMP"]),
    C("Explains that epinephrine binds the receptor at the cell surface, and the receptor passes the signal inside by activating a G protein and an enzyme that produces the second messenger, which relays the signal to other components in the cell.",
      "Response states that binding at the surface receptor starts a chain of activations inside the cell, ending with a second messenger that relays the signal, so the hormone does not need to enter.",
      "Trace the start of the pathway: ligand binds the surface receptor, the receptor activates inside components, and the second messenger relays the signal.")),
  P("Use the table to state how many molecules of glycogen phosphorylase are activated per activated receptor, and explain how a series of steps like these can produce such a large response from a single hormone-binding event.",
    C("States that about 1,000,000 molecules of glycogen phosphorylase are activated per activated receptor.",
      "Response reads the value 1,000,000 from the last row of the table.",
      "Read the value for the final step directly from the table and state it with what it counts.", ["1 million", "10^6"]),
    C("Explains that each activated enzyme can activate many molecules of the next component, so the number of activated molecules increases at successive steps and the signal is amplified.",
      "Response states that each step activates multiple molecules of the next step, so the response is much larger than the original signal.",
      "Explain amplification by counting: one activated molecule at a step activates many molecules at the next step.")),
  P("Protein kinase A adds phosphate groups to its target proteins. Describe the effect of phosphorylation on a target protein.",
    C("Describes that phosphorylation changes the shape of the target protein, which changes its activity (for example, activating an enzyme).",
      "Response states that adding a phosphate group changes the target protein's shape or activity.",
      "Say what phosphorylation does to the target: it changes the protein's shape, and that change switches its activity on or off.", ["changes conformation"]))],
 "model_answer": """(a) The second messenger is cAMP. Epinephrine binds the GPCR at the cell surface and does not enter the cell. The activated receptor activates a G protein, which activates adenylyl cyclase inside the cell. Adenylyl cyclase makes cAMP, and this second messenger relays the signal to protein kinase A and the other components of the pathway.

(b) About 1,000,000 molecules of glycogen phosphorylase are activated per activated receptor. The signal is amplified because each activated component can activate many molecules of the next component. One activated receptor activates about 100 G proteins, and later steps multiply the number of activated molecules again, so one hormone-binding event leads to a very large response.

(c) Phosphorylation changes the shape of the target protein, which changes its activity, for example by switching an enzyme on.""",
 "verification_python": """steps = [1, 100, 100, 10000, 10000, 1000000]
assert steps[-1] == 1000000 and steps[0] == 1
assert steps == sorted(steps)
assert steps[-1] // steps[0] == 10**6
print('ALL_CHECKS_PASSED')
"""}})

# ---------------- AP Biology 4.2 (B) ----------------
items.append({"subject_key": "ap_biology", "topic_code": "4.2", "item": {
 "title": "Surface and Intracellular Receptors for Two Signals",
 "calculator": "not_applicable",
 "stimulus": """Cells in a tissue culture respond to two signaling molecules by turning on a set of genes. Signal X is a small, nonpolar molecule. Signal Y is a large, polar molecule. Researchers added each signal to the medium outside the cells and measured gene activation in relative units.

In two treatments, the researchers first added a blocker. The blocker binds to proteins on the outer surface of the plasma membrane, so that no ligand can bind to them. The blocker cannot enter the cell.

Treatment | Gene activation (relative units)
1. No signal | 1
2. Signal X added outside the cells | 85
3. Signal Y added outside the cells | 90
4. Blocker, then signal X added outside the cells | 83
5. Blocker, then signal Y added outside the cells | 2""",
 "parts": [
  P("Identify which signal binds to a receptor on the cell surface, and use the data to support your answer.",
    C("Identifies signal Y as the signal that binds a receptor on the cell surface.",
      "Response names signal Y (not signal X) as the signal whose receptor is on the cell surface.",
      "Decide which signal's response depends on a blocker that works only outside the cell; that signal's receptor is on the surface."),
    C("Supports the answer with the blocker data: the response to signal Y fell from 90 to 2 when the blocker, which acts only outside the cell, was present.",
      "Response cites the loss of the response to signal Y (about 90 to about 2) when the blocker was present. A comparison with signal X may be included but is not required.",
      "Cite the values for signal Y with and without the blocker; a large drop shows its receptor is reachable by the outside-only blocker.")),
  P("Explain, using the structure of the plasma membrane, why signal X can reach its receptor but signal Y needs a receptor on the cell surface.",
    C("Explains that signal X is small and nonpolar, so it can pass through the hydrophobic interior of the phospholipid bilayer and bind a receptor inside the cell.",
      "Response links X being nonpolar to crossing the hydrophobic core of the membrane to reach an intracellular receptor.",
      "Tie polarity to the bilayer: small nonpolar molecules cross the hydrophobic core, so they can bind receptors inside the cell."),
    C("Explains that signal Y is large and polar, so it cannot cross the phospholipid bilayer and must bind a surface receptor, which then relays the signal into the cell.",
      "Response states that Y cannot cross the membrane because it is large or polar, so it acts through a receptor in the plasma membrane.",
      "State why Y cannot cross: large polar molecules are blocked by the hydrophobic core, so they need a membrane receptor to relay the message.")),
  P("Explain why the receptor for signal Y does not respond to signal X.",
    C("Explains that the receptor's ligand-binding domain has a specific shape that fits signal Y but not signal X, so X cannot bind and activate it.",
      "Response states that the receptor's binding site is specific, with a shape that matches only its own ligand.",
      "Name the receptor feature involved: the ligand-binding domain has a specific shape that matches only its own ligand.", ["binding site is specific to its ligand"]))],
 "model_answer": """(a) Signal Y binds a receptor on the cell surface. When the blocker, which acts only on proteins on the outer surface, was present, the response to signal Y dropped from 90 to 2, but the response to signal X stayed about the same (85 with no blocker, 83 with the blocker).

(b) Signal X is small and nonpolar, so it can pass through the hydrophobic interior of the phospholipid bilayer and bind a receptor inside the cell. Signal Y is large and polar, so it cannot cross the bilayer. It must bind a receptor in the plasma membrane, and that receptor relays the signal into the cell.

(c) A receptor's ligand-binding domain has a specific shape that fits its own ligand. The receptor for signal Y has a binding site that matches signal Y but not signal X, so X cannot bind to it or activate it.""",
 "verification_python": """# Biology reading check for the table values used in the rubric
y_no, y_block = 90, 2
x_no, x_block = 85, 83
assert y_no - y_block == 88
assert abs(x_no - x_block) <= 2
assert y_block < 5 and x_block > 80
print('ALL_CHECKS_PASSED')
"""}})

# ---------------- AP Biology 4.6 (A) ----------------
items.append({"subject_key": "ap_biology", "topic_code": "4.6", "item": {
 "title": "Cyclin-CDK Activity and a Drug That Stops Cells Before Mitosis",
 "calculator": "not_applicable",
 "stimulus": """Cyclins are proteins whose concentration changes during the cell cycle. A cyclin binds to a cyclin-dependent kinase (CDK), and a CDK is active only when it is bound to a cyclin. Researchers followed a synchronized culture of dividing cells through one cell cycle and measured the concentration of the cyclin that regulates entry into mitosis and the activity of its partner CDK. Mitosis ended near hour 11.

Time (hours) | Cyclin concentration (relative units) | CDK activity (relative units)
0 | 5 | 4
3 | 20 | 18
6 | 55 | 52
9 | 90 | 88
12 | 8 | 6

The researchers then treated a second culture with a drug that blocks the active cyclin-CDK complex needed to enter mitosis. After 24 hours they measured the DNA content of each cell. A G1 cell has the 2C amount of DNA, and a cell that has finished DNA replication has 4C. They also counted cells with visible condensed chromosomes (cells in mitosis).

Group | % of cells in G1 (2C DNA) | % of cells in S phase (between 2C and 4C) | % of cells with 4C DNA (G2 or mitosis) | % of all cells in mitosis
Control culture | 48 | 22 | 30 | 4
Drug-treated culture | 8 | 12 | 80 | 0.4""",
 "parts": [
  P("Describe the relationship between cyclin concentration and CDK activity in the first table, and explain the relationship.",
    C("Describes that CDK activity rises and falls together with the cyclin concentration (both are highest at 9 hours and low at 0 and 12 hours).",
      "Response states that CDK activity follows the cyclin concentration over time.",
      "Compare the two columns over time: when one rises or falls, state whether the other changes in the same direction."),
    C("Explains that CDK is active only when it is bound to cyclin, so CDK activity depends on the cyclin concentration.",
      "Response states that cyclin binding is required to activate the CDK.",
      "Use the information given about the proteins: a CDK needs a bound cyclin to be active, so its activity tracks cyclin level.")),
  P("Based on the second table, identify the stage of the cell cycle at which most drug-treated cells are stopped, support your answer with values from the table, and explain what this shows about the role of the cyclin-CDK complex that the drug blocks.",
    C("Identifies G2 (after DNA replication and before mitosis) as the stage where most treated cells are stopped, supported by 80% of cells having 4C DNA while only 0.4% are in mitosis.",
      "Response names G2 (or the point just before mitosis) and cites the large share of 4C cells and the very small share of cells in mitosis.",
      "Combine two clues: cells with 4C DNA have replicated their DNA, and few cells in mitosis means they stopped before mitosis."),
    C("Explains that the active cyclin-CDK complex is needed for cells to pass the checkpoint into mitosis, so blocking it keeps cells from progressing out of G2.",
      "Response states that the cyclin-CDK complex is required for cells to move from G2 into mitosis.",
      "Connect the drug to the stop: if blocking the complex halts the cycle, then the active complex is required to move forward.")),
  P("Cells with damaged DNA normally pause at an internal checkpoint. Explain how this pause benefits the organism.",
    C("Explains that the pause gives the cell time to repair the damaged DNA, or keeps a cell with damaged DNA from dividing, so damaged DNA is not passed to daughter cells.",
      "Response states that the checkpoint holds the cycle so repair can occur, or that it stops damaged cells from dividing, preventing passage of damaged DNA.",
      "State what the pause achieves: damaged DNA is repaired, or the damaged cell does not divide, so daughter cells do not inherit it."))],
 "model_answer": """(a) CDK activity rises and falls together with cyclin concentration: both are highest at 9 hours (90 and 88) and low at 0 and 12 hours. This is because a CDK is active only when it is bound to a cyclin, so the amount of active CDK depends on the amount of cyclin.

(b) Most drug-treated cells are stopped in G2. In the treated culture 80% of cells have 4C DNA, which means they have replicated their DNA, but only 0.4% are in mitosis (4% in the control). The active cyclin-CDK complex that the drug blocks is therefore needed for cells to pass the checkpoint from G2 into mitosis. Without it, cells cannot progress.

(c) When DNA is damaged, the checkpoint pauses the cycle. This gives the cell time to repair the DNA before it divides, so damaged DNA is not copied and passed to the daughter cells.""",
 "verification_python": """# Biology reading check for the table values used in the rubric
cyc = [5, 20, 55, 90, 8]
cdk = [4, 18, 52, 88, 6]
assert cyc.index(max(cyc)) == cdk.index(max(cdk)) == 3
treated = (8, 12, 80, 0.4)
control = (48, 22, 30, 4)
assert sum(treated[:3]) == 100 and sum(control[:3]) == 100
assert treated[2] == 80 and treated[3] < control[3]
print('ALL_CHECKS_PASSED')
"""}})

# ---------------- AP Biology 4.6 (B) ----------------
items.append({"subject_key": "ap_biology", "topic_code": "4.6", "item": {
 "title": "A Checkpoint Mutation and the Response to DNA Damage",
 "calculator": "not_applicable",
 "stimulus": """Cell line N is a normal line of skin cells. Cell line M has a mutation in a gene for a protein that normally detects DNA damage and stops the cell cycle before DNA replication (before S phase). Researchers exposed samples of each cell line to ultraviolet (UV) light, which damages DNA, and compared them with unexposed samples. Over the next 24 hours they measured the percentage of cells that entered S phase and the percentage of cells that underwent apoptosis (programmed cell death).

Cell line | UV exposure | % of cells entering S phase | % of cells undergoing apoptosis
N | none | 30 | 2
N | UV | 4 | 35
M | none | 31 | 2
M | UV | 29 | 3""",
 "parts": [
  P("Describe how the normal cells (cell line N) responded to UV exposure, using the data to support each response you describe.",
    C("Describes that UV exposure caused cells to stop entering S phase (30% without UV, 4% with UV), consistent with a checkpoint halting the cycle.",
      "Response states that the percentage of cells entering S phase fell sharply after UV exposure, and gives the values.",
      "Compare UV with no UV for the column that shows cell cycle progress, and give both values."),
    C("Describes that UV exposure caused many more cells to undergo apoptosis (2% without UV, 35% with UV).",
      "Response states that apoptosis increased after UV exposure, and gives the values.",
      "Compare the apoptosis column for UV and no UV, and state the increase using both values.")),
  P("Explain how the mutation in cell line M changes the way those cells respond to UV exposure.",
    C("Explains that the mutated protein does not detect DNA damage or stop the cycle, so the checkpoint fails and cells with damaged DNA keep entering S phase (29%) and rarely undergo apoptosis (3%).",
      "Response states that the checkpoint fails in cell line M, so cells continue through the cycle with damaged DNA and apoptosis does not rise.",
      "State what the lost protein did in cell line N, then show that the data from M have lost that response.")),
  P("Predict one long-term consequence for a person whose skin cells carry this mutation and are exposed to UV light repeatedly. Justify your prediction.",
    C("Predicts that damaged cells keep dividing, mutations accumulate, and uncontrolled cell division can lead to a tumor or cancer.",
      "Response predicts cancer or tumor formation and links it to cells dividing with damaged DNA that is not repaired or removed by apoptosis.",
      "Connect failed checkpoints to cancer: cells divide with damaged DNA, mutations accumulate, and division can become uncontrolled."))],
 "model_answer": """(a) Normal cells stopped progressing through the cell cycle after UV exposure: the percentage entering S phase fell from 30% to 4%, which fits a checkpoint halting the cycle in response to DNA damage. Normal cells also underwent apoptosis much more often after UV exposure: from 2% to 35%.

(b) Cell line M has a mutation in the protein that detects DNA damage and stops the cycle, so its checkpoint does not work. After UV exposure, 29% of the M cells still entered S phase, nearly the same as without UV (31%), and only 3% underwent apoptosis. The damaged cells are neither held at the checkpoint nor removed.

(c) Cells with damaged DNA would keep dividing, so mutations would build up in the daughter cells. Because the cell cycle is no longer controlled by the checkpoint, cells could divide in an uncontrolled way and form a tumor, so the person would have a higher risk of skin cancer.""",
 "verification_python": """# Biology reading check for the table values used in the rubric
n_none, n_uv = (30, 2), (4, 35)
m_none, m_uv = (31, 2), (29, 3)
assert n_none[0] - n_uv[0] == 26
assert n_uv[1] - n_none[1] == 33
assert abs(m_uv[0] - m_none[0]) <= 2 and m_uv[1] <= 3
print('ALL_CHECKS_PASSED')
"""}})

json.dump(items, open('authored_bio.json', 'w'), ensure_ascii=False, indent=1)
print(len(items), 'bio items written')
