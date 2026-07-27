You are generating realistic STUDENT answers for an AP-exam grading-engine test. These are real exam-style FRQ (free-response) questions from AP Biology and AP Statistics. For each question below, write **5 candidate answers** a real student might submit under real exam time pressure.

**Process — do these in order, don't skip the order:**
1. First, just write 5 answers that naturally vary in quality — some strong, some weak, some in between — the way a real classroom's worth of student submissions would vary. Don't decide "I'm now writing a tier-2 answer" before you write it; write naturally varied answers first.
2. After all 5 are written, go back and honestly self-assess each one's actual correctness/completeness on a `quality_tier` scale from 1 (very weak / largely wrong but a genuine good-faith attempt) to 5 (strong / mostly correct). This label should reflect what you actually wrote, not a target you wrote toward.
3. Exactly one of the 5 answers per question must end up at `quality_tier: 5`. If your natural first pass doesn't produce one, revise only the minimum needed to get one clean tier-5 answer — don't relabel a mediocre answer as a 5.

Note: this `quality_tier` is your own independent judgment — you have not been given the official rubric or answer key, so treat it as a rough self-assessment, not a certified score.

**Realism constraints (read carefully — this is the main failure mode to avoid):**
AI-generated "student" answers are almost always too complete, too polished, and too long compared to what a real student produces under timed exam conditions — even when explicitly asked to write a "weak" answer. Do not correct for this. Real students:
- Run out of time and leave sub-parts unanswered, especially on long multi-part FRQs — a tier-1 or tier-2 answer legitimately may skip a whole Part C or D, not attempt a rushed version of it.
- Write in fragmented, note-like phrasing rather than full polished paragraphs, with occasional imprecise or slightly wrong terminology even in strong answers.
- Rarely produce answers longer than what's actually achievable in the time given (see per-question time budgets below) — do not pad length "to be thorough."

Per-question time budget and target length (use this to calibrate how much a student could realistically produce):
- **Q1, Q2, Q5 (AP Bio long FRQ, 4 sub-parts each):** ~22-25 minutes total. A tier-5 answer is realistically 250-400 words across all 4 parts combined, in note-like exam prose — not an exhaustive essay. Tier 1-2 answers are often 60-150 words and may skip one or more sub-parts entirely.
- **Q3, Q4, Q6 (AP Stats short FRQ):** ~2-3 minutes each. A tier-5 answer is 1-4 sentences. Weak answers are often a single confused sentence or a guess with shaky reasoning.

Other constraints:
- Write in first-person, natural student voice — informal phrasing, varying sentence structure, occasional real-student imprecision.
- Address the sub-parts in order the way a student would in an exam booklet — don't restate the sub-part letter labels.
- Do not reference "rubric," "grading," "points," "quality tier," or any meta-commentary about the exam or this exercise inside the answer text itself — only in the `quality_tier` field. The answer text should read exactly like something a student actually wrote on an exam.
- You have NOT been given and should NOT try to guess or reconstruct any official answer key — answer each question from your own subject knowledge, the way a student studying for this exam would.

Output strict JSON only, no markdown fencing, no commentary, in exactly this shape:

```json
{
  "answers": [
    {
      "content_key": "<exact content_key from the question below>",
      "item_type": "frq",
      "responses": [
        {
          "quality_tier": 1-5,
          "text": "<student's answer text>"
        }
      ]
    }
  ]
}
```

Each `answers[]` entry must contain exactly 5 objects in `responses`, one of which has `quality_tier: 5`.

---

## Question 1 (FRQ) — content_key: APBIO-FRQ-L-015

**Stem:**
Answer all parts of the following question.

Part A: Trace the carbon atoms from one molecule of glucose (C₆H₁₂O₆) through glycolysis, pyruvate oxidation, and the Krebs cycle. Account for all six carbon atoms by identifying the carbon-containing molecules produced and the steps at which CO₂ is released.

Part B: For one molecule of glucose completely oxidized through aerobic respiration, account for the electron carriers produced. List the number of NADH and FADH₂ produced at each stage (glycolysis, pyruvate oxidation, Krebs cycle) and explain where each electron carrier is used in the electron transport chain.

Part C: The theoretical maximum ATP yield from one glucose molecule is often stated as ~30-32 ATP. Explain why the actual ATP yield is lower than the theoretical maximum, describing at least THREE specific reasons for this discrepancy.

Part D: A cell is shifted from aerobic to anaerobic conditions. Using the data in Table 1, which shows glucose consumption rates, explain the Pasteur effect (why glucose consumption increases dramatically under anaerobic conditions). Your answer should connect glycolytic regulation, the role of NAD⁺ availability, and ATP production efficiency.

**Stimulus (Table 1 and reference data provided to the student):**
Table 1: Glucose consumption in yeast cells
Condition     | Glucose consumed (mmol/hr/g cells)
Aerobic       |        0.5
Anaerobic     |        4.2

ATP yield summary (theoretical):
Glycolysis: 2 ATP (substrate-level), 2 NADH (cytoplasmic)
Pyruvate oxidation: 0 ATP, 2 NADH (mitochondrial)
Krebs cycle (×2 turns): 2 ATP (GTP), 6 NADH, 2 FADH₂

Electron carrier ATP equivalents (approximate):
Mitochondrial NADH: ~2.5 ATP each
Cytoplasmic NADH: ~1.5 ATP each (malate-aspartate shuttle) or ~1.0 (glycerol-3-phosphate shuttle)
FADH₂: ~1.5 ATP each

---

## Question 2 (FRQ) — content_key: APBIO-FRQ-L-028

**Stem:**
Answer all parts of the following question.

Part A: Mount St. Helens erupted in 1980, destroying 600 km² of forest and depositing meters of volcanic ash and rock. Ecologists have monitored species recovery in this area since 1980. Classify the ecological succession occurring at Mount St. Helens as primary or secondary and justify your classification. Describe the facilitation model of succession and apply it to the Mount St. Helens recovery by naming a specific type of early colonist (pioneer species) and explaining how it modifies the environment to make it suitable for later species. Describe how species diversity (as measured by the Shannon diversity index or species richness) would change over succession time from year 0 to year 50 at Mount St. Helens and explain the mechanism.

Part B: The intermediate disturbance hypothesis (IDH) predicts that species diversity is highest at intermediate levels of disturbance frequency and intensity. Explain why diversity is lower in undisturbed communities and what process dominates in the absence of disturbance. Explain why diversity is also lower in highly disturbed communities and what types of species persist. Explain why intermediate disturbance maximizes diversity using the concept of competitive exclusion in your answer. Predict how the IDH applies to coral reefs, where wave disturbance creates patches of open substrate.

Part C: Keystone species have a disproportionately large effect on community structure relative to their abundance. Robert Paine's classic experiment with sea stars (Pisaster ochraceus) in Pacific tidepools demonstrated this. Explain what happened to species diversity when Paine removed Pisaster from the tidal zone. Define keystone species and explain the trophic cascade mechanism by which losing a keystone predator causes loss of biodiversity. Give ONE example of a keystone species in a terrestrial ecosystem (not Pisaster) and explain its role.

Part D: Invasive species are a leading cause of native species extinction. The invasive zebra mussel (Dreissena polymorpha) was introduced into the Great Lakes in 1988 via ballast water. Describe THREE ecological impacts of zebra mussels on the Great Lakes ecosystem. Explain why invasive species often succeed so dramatically in their introduced environment. Propose ONE ecologically sound management strategy for zebra mussels and explain its mechanism.

**Stimulus (figure description, Table 1, and reference data provided to the student):**
Figure 1 description: aerial/ground photos of Mount St. Helens blast zone showing bare volcanic ash/pyroclastic deposits in 1980 versus scattered lupine patches and early conifer seedlings by the mid-1990s and denser vegetation cover by 2000s.

Table 1: Species richness at Mount St. Helens blast zone over time (illustrative)
Years since eruption | Approx. species richness (vascular plants, per plot)
   0 (1980)           |          0-1
   5                   |          3-5
  15                   |         10-15
  30                   |         20-25
  50                   |         25-30 (plateauing)

Trophic cascade / keystone reference data:
Pisaster removal experiment (Paine, Makah Bay tidepools):
- Control plots (Pisaster present): ~15 species coexisting (algae, barnacles, mussels, chitons, limpets)
- Pisaster-removal plots: community collapsed to ~1-3 species within a year, dominated by Mytilus californianus (mussel)

Zebra mussel background:
- Native range: Caspian Sea/Black Sea region (Eastern Europe)
- Introduced to Great Lakes via ballast water discharge, 1988
- Filter rate: a single zebra mussel filters ~1 liter of water per day; dense colonies can filter an entire lake volume multiple times per season
- Population density: can exceed 100,000 individuals per square meter on hard substrate

---

## Question 3 (FRQ) — content_key: STATS-MOD1-E005

**Stem:** Identify whether each scenario involves a parameter or a statistic: (a) average salary of all employees at a company, (b) average salary from a sample of 100 employees.

**Stimulus:** (none)

---

## Question 4 (FRQ) — content_key: APSTAT-MOD3-E005

**Stem:** Two variables are said to have a strong correlation. Does this mean one causes the other?

**Stimulus:** (none)

---

## Question 5 (FRQ) — content_key: APBIO-FRQ-L-021

**Stem:**
Answer all parts of the following question.

Part A: Eukaryotic gene expression requires the coordinated action of transcription factors, RNA polymerase II, and chromatin remodeling. Describe the sequence of events that leads to the assembly of the pre-initiation complex (PIC) at a eukaryotic promoter and name TWO general transcription factors and their roles. Explain how an enhancer element located 10,000 base pairs upstream of a gene can stimulate transcription at the gene's promoter, including the role of activator proteins and Mediator.

Part B: Chromatin structure regulates access to DNA. Using Figure 1 (which shows the same gene in euchromatin vs. heterochromatin states): Describe the structural difference between euchromatin and heterochromatin at the level of histone modification. Explain how histone acetyltransferases (HATs) and histone deacetylases (HDACs) have opposite effects on transcription, including the mechanism by which acetylation opens chromatin. A researcher adds trichostatin A (an HDAC inhibitor) to cells. Predict and explain the effect on global gene expression.

Part C: Experiment: The researcher fuses the DNA-binding domain of a transcription factor to different activation domains and measures target gene expression. Results are shown in Table 1. What does the DNA-binding domain alone demonstrate about gene activation? What do the activation domain results reveal about how transcription is activated? The researcher finds that activation domain 3 interacts physically with the Mediator complex. Explain how this interaction could lead to increased transcription.

Part D: Explain how the following two mechanisms contribute to cell-type-specific gene expression in a multicellular organism that has one genome but hundreds of distinct cell types: Combinatorial control by transcription factors and epigenetic inheritance of chromatin states.

**Stimulus (Figure 1 description and Table 1 provided to the student):**
Figure 1 (described):
• Euchromatin: beads-on-a-string appearance; histones visible as individual nucleosomes; 30nm fiber partially unfolded; gene accessible to RNA polymerase → gene ON
• Heterochromatin: highly compact; 300nm fiber; DNA wound tightly; gene inaccessible → gene OFF

Table 1: Transcription factor domain fusion experiment
Construct                    | Target gene expression (relative units)
DBD alone                    |         1 (baseline)
DBD + Activation Domain 1    |        45
DBD + Activation Domain 2    |        12
DBD + Activation Domain 3    |        87
DBD + AD1 + AD3              |       203

Note: DBD = DNA-binding domain; all constructs bind the same promoter sequence.

---

## Question 6 (FRQ) — content_key: APSTAT-MOD4-M003

**Stem:** Explain the difference between a census and a sample survey. When would you use each?

**Stimulus:** (none)

---

Produce the JSON now for all 6 questions.
