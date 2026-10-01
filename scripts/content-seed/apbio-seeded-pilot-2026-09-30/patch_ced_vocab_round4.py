# Round 4 (2026-10-01): Product Owner policy = items stay within CED vocabulary (no stem-supplied beyond-CED mechanisms).
# Replaces 6 variants (018-v1, 018-v2, 021-v1, 022-v1, 023-v1, 023-v2) with CED-vocabulary versions and edits choice B of 008-v1.
# Letters come from a per-key RNG (key + "-r4"); 008-v1 keeps its letters. Other variants are untouched. build_variants*.py are NOT re-run.
import json, random, os
D = os.path.dirname(__file__); L = "ABCD"
TARGET = {"apbio-mcq-sv-018-v1":"A","apbio-mcq-sv-018-v2":"B","apbio-mcq-sv-021-v1":"C","apbio-mcq-sv-022-v1":"B","apbio-mcq-sv-023-v1":"A","apbio-mcq-sv-023-v2":"C"}
R = []  # (key, seed, unit, topic, change, stim, q, correct, distractors)
def r(*a): R.append(a)
r("apbio-mcq-sv-018-v1","APBIO-MCQ-018",2,"2.5","LDL receptor -> transferrin receptor in developing red blood cells; clathrin, endosome and acidity removed (not in the CED); endocytosis described generically (2.5.B.1)",
 "Developing red blood cells take in iron by endocytosis. Iron-bound transferrin, a protein in the blood, binds to transferrin receptors, which are proteins in the plasma membrane. The membrane then folds inward and engulfs the bound transferrin in a vesicle that carries the iron into the cell. A rare inherited mutation prevents transferrin receptors from reaching the plasma membrane of developing red blood cells.",
 "Which prediction about individuals with this mutation is best supported by the described process?",
 ("Iron-bound transferrin will stay in the blood at high levels, because the cells have no receptors to bind it and take it in.",
  "Correct. In the process described, uptake starts when transferrin binds a receptor in the plasma membrane. Without receptors at the surface, the cells cannot take in the transferrin, so it stays in the blood."),
 [("Iron-bound transferrin will cross the phospholipid bilayer by simple diffusion instead, because the receptors are not needed for uptake.",
   "Incorrect. Transferrin is a large protein, and the hydrophobic interior of the bilayer blocks large and polar substances. In the process described, uptake depends on the receptor and endocytosis."),
  ("The plasma membrane will stop folding inward in these cells, so no other substance can be taken in by endocytosis.",
   "Incorrect. The mutation removes only the transferrin receptor from the surface. The cells can still carry out endocytosis for substances whose receptors are present."),
  ("The cells will have more iron available inside, because the iron stays outside the cells, where it can diffuse freely into the cytoplasm.",
   "Incorrect. Iron bound to transferrin does not diffuse freely across the hydrophobic interior of the membrane. Without the receptor, the iron is not taken into the cells.")])
r("apbio-mcq-sv-018-v2","APBIO-MCQ-018",2,"2.5","LDL receptor loss -> receptor present but unable to start endocytosis; endosome, lysosome, recycling and cholesterol feedback removed (not in the CED)",
 "Liver cells remove LDL particles, which carry cholesterol, from the blood by endocytosis. LDL binds to receptor proteins in the plasma membrane, and the binding makes the membrane fold inward and engulf the LDL in a vesicle. A mutant form of the receptor reaches the plasma membrane and binds LDL as well as the normal receptor does, but it cannot make the membrane fold inward.",
 "Which prediction about liver cells that have only the mutant receptor is best supported by the described process?",
 ("LDL will bind to the surface of the cells but will not be taken in, so the level of LDL in the blood will stay high.",
  "Correct. The mutant receptor binds LDL, but uptake needs the membrane to fold inward around it. Without that step, the LDL is not engulfed and is not removed from the blood."),
 [("LDL will cross the phospholipid bilayer directly once it is bound to the receptor, so the level of LDL in the blood will fall.",
   "Incorrect. LDL particles are too large to cross the hydrophobic interior of the bilayer. Without endocytosis, bound LDL is not carried into the cell."),
  ("Fewer receptors will reach the plasma membrane, so the cells will bind less LDL than normal.",
   "Incorrect. The stimulus states that the mutant receptor reaches the plasma membrane and binds LDL as well as the normal receptor does."),
  ("The cells will take in LDL normally, because binding to the receptor is the only step in uptake that needs a receptor protein.",
   "Incorrect. In the process described, binding makes the membrane fold inward and engulf the LDL. The mutant receptor cannot do this, so uptake does not occur normally.")])
r("apbio-mcq-sv-021-v1","APBIO-MCQ-021",2,"2.1","deleted signal peptide -> ribosomes unable to attach to the rough ER; signal peptide, SRP and co-translational targeting removed (not in the CED); route through the endomembrane system is stated in the stem",
 "Pancreatic cells secrete the digestive enzyme amylase. Normally, amylase is made by ribosomes attached to the rough ER, and it then passes through the Golgi complex and transport vesicles before it is secreted from the cell. A researcher treats the cells with a drug that stops ribosomes from attaching to the rough ER. The ribosomes remain in the cytoplasm.",
 "Which outcome for amylase in the treated cells is most likely?",
 ("Amylase is still made, but in the cytoplasm rather than at the rough ER, so it does not enter the endomembrane system and little is secreted.",
  "Correct. Ribosomes in the cytoplasm can still make a protein from mRNA, but the protein is not made at the rough ER, so it does not pass through the Golgi complex and vesicles to be secreted."),
 [("Amylase is no longer made at all, because only ribosomes attached to the rough ER can carry out protein synthesis.",
   "Incorrect. Ribosomes in the cytoplasm also synthesize proteins from mRNA, so the enzyme can still be made. It just is not made at the rough ER."),
  ("Amylase is made on the smooth ER instead and is secreted normally, because the smooth ER also takes part in making proteins.",
   "Incorrect. The smooth ER is involved in detoxification and lipid synthesis. Ribosomes, not the smooth ER, make proteins."),
  ("Amylase moves directly from the cytoplasm into the Golgi complex, where it is modified and then secreted as usual.",
   "Incorrect. In the route described, the protein reaches the Golgi complex after it is made at the rough ER. A protein made in the cytoplasm does not skip that step.")])
r("apbio-mcq-sv-022-v1","APBIO-MCQ-022",2,"2.10","mitochondria -> chloroplasts; 70S/80S, antibiotic and binary fission removed (not in the CED); evidence limited to double membrane, circular DNA, ribosomes and independent reproduction",
 "Evidence supporting the endosymbiotic origin of chloroplasts includes: (1) chloroplasts have a double membrane, with an inner membrane like the plasma membrane of a cyanobacterium and an outer membrane like the host cell's endomembrane; (2) chloroplasts contain their own circular DNA; (3) chloroplasts contain ribosomes made of rRNA and protein, like those of prokaryotes; (4) chloroplasts reproduce independently of the cell cycle of the host.",
 "Which single piece of evidence most specifically supports the claim that a host cell engulfed a cyanobacterium, rather than only showing that chloroplasts have a prokaryote-like ancestry?",
 ("The double membrane, with an inner layer like a cyanobacterial membrane and an outer layer like host endomembrane, matches engulfment by a host vesicle.",
  "Correct. Evidence (1) describes the physical result of engulfment: the inner membrane belongs to the engulfed cell and the outer membrane comes from the host vesicle. The other pieces show prokaryote-like ancestry but not how the cell came to be inside the host."),
 [("Having its own circular DNA shows that chloroplasts are still able to survive on their own outside the plant cell.",
   "Incorrect. Circular DNA shows a link to prokaryotes, but it does not show that chloroplasts can survive on their own, and it does not show how they came to be inside the host."),
  ("Having ribosomes made of rRNA and protein shows that each chloroplast is still a free-living cyanobacterium inside the cell.",
   "Incorrect. Ribosomes are found in all forms of life and reflect common ancestry. They do not show how the organelle came to be inside the cell or that it is still free-living."),
  ("Reproducing independently of the host's cell cycle shows that the chloroplast was surrounded by a host membrane during engulfment.",
   "Incorrect. Independent reproduction shows a similarity to prokaryotes, but it says nothing about a host membrane surrounding the cell. The double membrane is the evidence that does.")])
r("apbio-mcq-sv-023-v1","APBIO-MCQ-023",2,"2.3","fractionation by detergent, salt and biotin -> arrangement of hydrophobic and hydrophilic regions of an embedded membrane protein (CED 2.3.A.2); integral/peripheral, detergent and protease assays removed (not in the CED)",
 "Protein X is embedded in the plasma membrane of an intestinal cell and extends across it. A segment in the middle of Protein X is made of amino acids with nonpolar (hydrophobic) R groups. The segments at each end of Protein X are made of amino acids with polar (hydrophilic) R groups.",
 "Which arrangement of Protein X in the membrane is most likely?",
 ("The nonpolar middle segment lies in the hydrophobic interior of the bilayer, and the polar end segments are exposed to the water on each side of the membrane.",
  "Correct. Nonpolar R groups are stable among the hydrophobic tails of the phospholipids, and polar R groups are stable in the watery environments inside and outside the cell."),
 [("The nonpolar middle segment is exposed to the watery environment outside the cell, and the polar end segments lie in the hydrophobic interior of the bilayer.",
   "Incorrect. This reverses the arrangement. Nonpolar groups avoid water, and polar groups are not stable among the hydrophobic tails."),
  ("Protein X floats free in the cytoplasm and is not associated with the membrane at all, because it has polar segments at its ends.",
   "Incorrect. The stimulus states that Protein X is embedded in the membrane, and its nonpolar middle segment is what allows it to sit in the hydrophobic interior."),
  ("All of Protein X lies in the hydrophobic interior of the bilayer, including the polar end segments, because the protein is embedded in the membrane.",
   "Incorrect. Polar end segments are not stable among the hydrophobic tails. They are exposed to the watery environment on each side of the membrane.")])
r("apbio-mcq-sv-023-v2","APBIO-MCQ-023",2,"2.3","fractionation by high-salt wash and protease -> R-group pattern of a channel protein (CED 2.3.A.2, 2.6.A.1); peripheral protein, salt wash and trypsin assay removed (not in the CED)",
 "A channel protein in the plasma membrane allows sodium ions to cross the membrane. The protein is embedded in the membrane and forms a pore through it. Researchers compare the R groups of the amino acids that line the pore with the R groups on the outer surface of the protein, where it touches the phospholipid tails.",
 "Which pattern of R groups is most likely?",
 ("The amino acids that line the pore have polar or charged R groups, and the amino acids on the outer surface have nonpolar R groups.",
  "Correct. Polar and charged R groups line the pore, where they interact with the sodium ions in water. Nonpolar R groups on the outer surface are stable beside the hydrophobic tails of the phospholipids."),
 [("The amino acids that line the pore have nonpolar R groups, and the amino acids on the outer surface have polar or charged R groups.",
   "Incorrect. This reverses the pattern. Sodium ions are charged and would not pass through a nonpolar pore, and polar groups on the outer surface would not be stable beside the hydrophobic tails."),
  ("All of the amino acids have nonpolar R groups, because the protein is embedded in the hydrophobic interior of the membrane.",
   "Incorrect. A pore lined with nonpolar groups would block charged ions. The pore needs polar or charged R groups for sodium ions to cross."),
  ("All of the amino acids have polar or charged R groups, because the channel must let ions cross the membrane.",
   "Incorrect. Polar groups on the outer surface would not be stable beside the hydrophobic tails of the phospholipids, so the protein could not sit in the membrane.")])
items, man = {}, {}
for key, seed, unit, topic, change, stim, q, corr, dis in R:
    want = TARGET[key]
    for n in range(500):  # per-key seeded search so the keyed letters are mixed across the six items
        rng = random.Random(f"{key}-r4-{n}")
        opts = [(corr[0], corr[1], True)] + [(t, r_, False) for t, r_ in dis]; rng.shuffle(opts)
        if L[[o[2] for o in opts].index(True)] == want: break
    keyed = next(L[i] for i, o in enumerate(opts) if o[2])
    items[key] = dict(key=key, kind="mcq", unit=unit, topic=topic, seed=seed, stem=f"Stimulus: {stim}\n\nQuestion: {q}",
        choices=[dict(label=L[i], text=o[0]) for i, o in enumerate(opts)], keyed_label=keyed, rationales={L[i]: o[1] for i, o in enumerate(opts)})
    man[key] = (keyed, change)
# 008-v1: replace choice B (disulfide, needs cysteine/sulfur detail) with an R-group/ionic version; letters unchanged
B8 = ("Isoleucine forms ionic bonds between separate enzyme molecules, linking them together in a way that threonine cannot.",
      "Incorrect. Isoleucine's R group is nonpolar, not charged, so it cannot form ionic interactions between enzyme molecules.")
def patch(fn):
    p = os.path.join(D, fn)
    if not os.path.exists(p): return
    data = json.load(open(p)); n = 0
    for i, x in enumerate(data):
        k = x["key"]
        if k in items:
            n += 1
            data[i] = items[k] if "choices" in x else {**x, "keyed_label": man[k][0], "change": man[k][1]}
        elif k == "apbio-mcq-sv-008-v1" and "choices" in x:
            n += 1
            for c in x["choices"]:
                if c["label"] == "B": c["text"] = B8[0]; x["rationales"]["B"] = B8[1]
    json.dump(data, open(p, "w"), indent=1, ensure_ascii=False); print(fn, "patched", n)
for fn in ("variants_all_items.json", "variants_items.json", "variants_023_items.json", "variants_manifest.json", "variants_023_manifest.json"): patch(fn)
json.dump(list(items.values()) + [x for x in json.load(open(os.path.join(D, "variants_all_items.json"))) if x["key"] == "apbio-mcq-sv-008-v1"],
          open(os.path.join(D, "variants_round4_items.json"), "w"), indent=1, ensure_ascii=False)
print({k: v[0] for k, v in man.items()})
