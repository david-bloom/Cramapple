# Builds variants_023_items.json (2 variants of APBIO-MCQ-023, written AFTER the choice A rationale repair, APPROVAL-0067).
# Separate from build_variants.py so the 14 already-checked variants are never touched. Letters are drawn from a per-key seeded RNG.
# DO NOT RE-RUN once the file has been checked or loaded anywhere (use --force only before any check).
import json, random, sys, os
OUT = os.path.join(os.path.dirname(__file__), "variants_023_items.json")
if os.path.exists(OUT) and "--force" not in sys.argv:
    sys.exit("variants_023_items.json exists; refusing to rebuild.")
L = "ABCD"
V = [
("apbio-mcq-sv-023-v1","APBIO-MCQ-023",2,"2.3","detergent/high-salt/biotin in red blood cells -> carbonate wash/detergent/trypsin in intestinal cells; the answer is now a membrane-embedded protein with an extracellular region",
 "Researchers study a membrane protein from intestinal epithelial cells using three treatments. (1) Sodium carbonate at pH 11 strips off proteins that are attached to the membrane surface by non-covalent interactions, without dissolving the bilayer. (2) The detergent Triton X-100 dissolves the bilayer and releases proteins that are embedded in it into detergent micelles. (3) Trypsin, a protease too large to cross the plasma membrane, is added to intact cells and cleaves only protein regions exposed on the outer surface. Protein X stays in the membrane fraction after the carbonate wash, is released into micelles by Triton X-100, and is cleaved into a smaller fragment when trypsin is added to intact cells.",
 "Which characterization of Protein X is best supported by all three results?",
 ("A membrane-embedded protein with at least one region exposed on the extracellular surface",
  "Correct. Staying in the membrane after the carbonate wash and being released only by detergent show that Protein X is embedded in the bilayer, and cleavage by trypsin on intact cells shows that part of it is exposed on the outer surface."),
 [("A peripheral protein attached to the cytoplasmic face of the membrane by ionic interactions",
   "Incorrect. A peripheral protein would have been stripped off by the carbonate wash, and trypsin added to intact cells cannot reach the cytoplasmic face, so it would not have cleaved Protein X."),
  ("A peripheral protein attached to the extracellular surface of the membrane by ionic interactions",
   "Incorrect. A protein held to the surface by non-covalent interactions would have been removed by the carbonate wash, but Protein X stayed in the membrane fraction."),
  ("A soluble protein in the cytoplasm that is not associated with the membrane at all",
   "Incorrect. A soluble cytoplasmic protein would not remain in the membrane fraction, and trypsin cannot cross the plasma membrane to cleave a protein inside intact cells.")]),
("apbio-mcq-sv-023-v2","APBIO-MCQ-023",2,"2.3","peripheral protein on the cytoplasmic face again but shown by a different pair of results (salt release; protease works only on broken cells), in liver cells",
 "Researchers study a protein from the plasma membrane of liver cells. (1) A high-salt wash releases proteins that are held to the membrane surface by ionic interactions, without dissolving the bilayer. (2) Trypsin, a protease too large to cross the plasma membrane, is added to intact cells. (3) The same enzyme is added to cells whose membranes have been broken open so that both faces are exposed. Protein Y is released by the high-salt wash. Trypsin does not cleave Protein Y in intact cells, but it does cleave Protein Y in the broken-open cells.",
 "Which characterization of Protein Y is best supported by the results?",
 ("A peripheral protein attached to the cytoplasmic face of the plasma membrane",
  "Correct. Release by the high-salt wash shows that Protein Y is a peripheral protein held by ionic interactions, and cleavage only when both faces are exposed shows that it sits on the cytoplasmic face, out of reach of trypsin in intact cells."),
 [("A peripheral protein attached to the extracellular surface of the plasma membrane",
   "Incorrect. A protein on the outer surface would have been cleaved by trypsin in intact cells, but Protein Y was cleaved only after the membranes were broken open."),
  ("A membrane-spanning protein with a large region exposed on the extracellular side",
   "Incorrect. A spanning protein is not released by a salt wash alone, and an exposed extracellular region would have been cleaved by trypsin in intact cells."),
  ("A protein buried entirely within the lipid bilayer, with no region exposed on either face",
   "Incorrect. A protein buried in the bilayer would not be released by a salt wash, which does not dissolve the bilayer, and trypsin would not reach it in either condition.")]),
]
items, manifest = [], []
for key, seed, unit, topic, change, stim, q, corr, dis in V:
    rng = random.Random(key)
    opts = [(corr[0], corr[1], True)] + [(t, r, False) for t, r in dis]
    rng.shuffle(opts)
    keyed = next(L[i] for i, o in enumerate(opts) if o[2])
    items.append(dict(key=key, kind="mcq", unit=unit, topic=topic, seed=seed, stem=f"Stimulus: {stim}\n\nQuestion: {q}",
        choices=[dict(label=L[i], text=o[0]) for i, o in enumerate(opts)], keyed_label=keyed, rationales={L[i]: o[1] for i, o in enumerate(opts)}))
    manifest.append(dict(key=key, seed=seed, unit=unit, topic=topic, keyed_label=keyed, change=change))
json.dump(items, open(OUT, "w"), indent=1, ensure_ascii=False)
json.dump(manifest, open(OUT.replace("items", "manifest"), "w"), indent=1, ensure_ascii=False)
print(len(items), "variants; keyed letters:", [m["keyed_label"] for m in manifest])
