import json
def C(text, evidence, fix, v=None):
    return {"text": text, "evidence": evidence, "fix": fix, "accepted_variants": v or []}
def P(prompt, *crit):
    return {"prompt": prompt, "criteria": list(crit)}
items = []

# ---------------- AP Biology 4.2 (A) ---------------- (round 6: replaced; the cascade versions voted 6 of 6 for 4.3 five times)
items.append({"subject_key": "ap_biology", "topic_code": "4.2", "item": {
 "title": "Ligand Recognition by Receptors in Three Cell Types",
 "calculator": "not_applicable",
 "stimulus": """A researcher studies three cell types and three signaling molecules (ligands), P, Q and R. Ligands P and R are different peptides (small proteins). Ligand Q is a small nonpolar molecule. The researcher prepared extracts containing the receptor proteins from each cell type and measured how much of each ligand bound to the receptor proteins (relative units; 100 is the maximum binding). Readings of 5 or below are background and mean that the ligand did not bind.

Cell type | Ligand P | Ligand Q | Ligand R
Muscle cell | 92 | 0 | 3
Liver cell | 4 | 0 | 88
Skin cell | 2 | 85 | 1""",
 "parts": [
  P("Identify which ligand each cell type is able to recognize, and state what the data show about the receptors of the three cell types.",
    C("Identifies the ligand recognized by each cell type: muscle cells recognize P, liver cells recognize R, and skin cells recognize Q.",
      "Response pairs each cell type with the one ligand that shows high binding (muscle with P, liver with R, skin with Q).",
      "For each row, find the one ligand with high binding and pair it with that cell type."),
    C("States that the three cell types have different receptors, and that each receptor binds only one of the ligands.",
      "Response states that the receptors differ between cell types and that each receptor is specific to one ligand.",
      "Compare rows: if each cell type binds a different ligand and almost no others, the receptors are different and specific.")),
  P("Explain, in terms of receptor structure, why the receptor proteins from liver cells bind ligand R but not ligand P, even though both ligands are peptides.",
    C("Explains that the receptor's ligand-binding domain has a specific shape that matches ligand R but not ligand P, so P cannot bind.",
      "Response states that the ligand-binding domain recognizes a specific ligand through its shape or structure, which fits R and does not fit P.",
      "Name the receptor feature involved: the ligand-binding domain has a specific shape that fits only its own ligand.", ["binding site is specific to its ligand"])),
  P("A fourth cell type has no receptor for ligand P. Predict whether this cell type will respond to ligand P, and justify your prediction.",
    C("Predicts that the cell type will not respond to ligand P, because without a receptor that recognizes P, the signal cannot be received and the signaling does not start.",
      "Response predicts no response and states that recognition of the ligand by a receptor protein is required to begin signaling.",
      "Link response to reception: a signal can start a response only if a receptor in the target cell recognizes the ligand."))],
 "model_answer": """(a) Muscle cells recognize ligand P (92), liver cells recognize ligand R (88), and skin cells recognize ligand Q (85); each cell type shows almost no binding to the other two ligands. The three cell types therefore have different receptors, and each receptor is specific to only one of the ligands.

(b) The ligand-binding domain of a receptor has a specific shape. The liver-cell receptor has a binding domain whose shape fits ligand R, so R binds (88). Ligand P is also a peptide but has a different structure that does not fit this domain, so P does not bind (4).

(c) The cell type will not respond to ligand P. Signaling begins when a receptor protein in the target cell recognizes the ligand. Without a receptor for P, the cell cannot receive the signal, so no signal transduction occurs.""",
 "verification_python": """table = {'muscle': (92, 0, 3), 'liver': (4, 0, 88), 'skin': (2, 85, 1)}
best = {k: max(range(3), key=lambda i: v[i]) for k, v in table.items()}
assert best == {'muscle': 0, 'liver': 2, 'skin': 1}
for k, v in table.items():
    assert sorted(v)[-1] >= 85 and sorted(v)[-2] <= 4
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
