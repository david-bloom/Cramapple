"""TASK-0065 Biology checker pilot: 5 clean teaching items + 4 deliberately broken controls.

Writes items.json (what the checkers see; no control metadata) and controls.json
(the expected defect per control, kept separate so no checker is told what to find).
Author: Claude (Anthropic) -- so Anthropic models never act as checkers.
"""
import copy, json

def mcq(key, topic, unit, stem, choices, keyed, rationales, earned, lost):
    return {"key": key, "kind": "mcq", "subject": "AP Biology", "unit": unit, "topic_code": topic,
            "stem": stem, "choices": [{"label": l, "text": t} for l, t in zip("ABCD", choices)],
            "keyed_label": keyed, "rationales": dict(zip("ABCD", rationales)),
            "earned": earned, "lost": lost}

clean = [
  mcq("t65-bio-1.1", "1.1", 1,
      "Water has a much higher specific heat than most other molecules of similar size. Which explanation best accounts for this property?",
      ["Much of the heat added to water is used to break hydrogen bonds between water molecules before the molecules can move faster.",
       "The covalent bonds inside each water molecule must break before the temperature of the water can rise.",
       "Water evaporates easily, and evaporation carries heat away before the water can warm up.",
       "Liquid water is dense, so heat is trapped between tightly packed molecules."],
      "A",
      ["Raising the temperature means making molecules move faster. In water, much of the absorbed energy first goes into breaking hydrogen bonds between molecules, so more heat is needed for each degree of change. Tracing the property back to polarity and hydrogen bonding is what earns the point.",
       "Tempts because 'breaking bonds absorbs energy' sounds right, but heating water does not break the covalent O-H bonds inside each molecule. Fix: when an answer says bonds break, check whether they are bonds within a molecule or between molecules.",
       "Tempts because evaporative cooling is a real water property that also depends on hydrogen bonds, but it describes heat leaving as water evaporates, not how much heat it takes to raise the temperature of the water. Fix: keep specific heat (temperature change) separate from evaporative cooling (heat carried off by evaporation).",
       "Tempts because density is another well-known property of water, but density does not explain how much heat water absorbs per degree. Fix: explain the property the question names, using hydrogen bonds between molecules."],
      ["Trace the property back to water's polarity.", "Name hydrogen bonds between molecules as the cause.", "Match each property to its own mechanism."],
      ["Blaming covalent bonds inside the molecule.", "Explaining one water property with another.", "Citing a property with no molecular cause."]),
  mcq("t65-bio-2.5", "2.5", 2,
      "An uncharged substance X is at 5 mM outside a cell and 20 mM inside it. Over the next hour, the concentration of X inside the cell rises to 30 mM while the concentration outside stays at 5 mM. Which conclusion is best supported by these data?",
      ["X entered by passive transport, because it moved into the cell.",
       "X entered by active transport, because it moved from lower to higher concentration.",
       "X entered by passive transport, because the membrane is selectively permeable to X.",
       "No conclusion is possible without knowing whether a membrane protein carried X."],
      "B",
      ["Tempts because X did end up inside the cell, but the direction of entry does not decide the mechanism; what matters is that X moved toward the side where it was already more concentrated. Fix: compare the concentrations on each side before naming passive or active.",
       "X moved from 5 mM outside to an even higher concentration inside, which is against its concentration gradient. Passive transport only produces net movement from higher to lower concentration, so movement from lower to higher requires energy and is active transport. Reading the gradient direction first is what earns the point.",
       "Tempts because selective permeability is a real feature of membranes, but it explains which substances can cross, not how a substance can build up against its gradient. Fix: ask whether the movement is down or against the gradient.",
       "Tempts students who think a protein is what makes transport active, but proteins take part in both passive and active transport, and the gradient data already settle the question. Fix: decide passive or active from the gradient, not from whether a protein is involved."],
      ["Compare the concentrations on each side first.", "Call net movement toward higher concentration active.", "Link active transport to an energy requirement."],
      ["Deciding the mechanism from the protein alone.", "Reading the direction of entry as the gradient.", "Treating selective permeability as a transport mechanism."]),
  mcq("t65-bio-3.1", "3.1", 3,
      "An enzyme speeds up the conversion of its substrate to product. Which statement correctly describes how the enzyme increases the reaction rate?",
      ["It supplies the energy needed for the reaction to occur.",
       "It raises the temperature of the solution so that molecules collide more often.",
       "It binds any molecule of similar size, so it can speed up many different reactions.",
       "It binds the substrate in an active site with a complementary shape, which lowers the activation energy."],
      "D",
      ["Tempts because a reaction 'needs energy to get started', but an enzyme does not add energy; it lowers the energy barrier that must be crossed. Fix: say 'lowers activation energy', never 'provides energy'.",
       "Tempts because heat does speed up reactions, but an enzyme works at the cell's temperature and does not heat its surroundings. Fix: credit the enzyme with lowering activation energy, not with adding heat.",
       "Tempts because binding the substrate is part of the right answer, but enzymes are specific: the active site fits a particular substrate by shape and chemistry, not by size alone. Fix: tie specificity to the shape of the active site.",
       "An enzyme speeds a reaction by lowering its activation energy, and it does this by binding a specific substrate in an active site whose shape fits that substrate. Linking active-site shape to lower activation energy is what earns the point."],
      ["Tie the active site's shape to its substrate.", "Say the enzyme lowers activation energy.", "Connect lower activation energy to a faster rate."],
      ["Saying the enzyme adds energy.", "Crediting the enzyme with heating the reaction.", "Ignoring substrate specificity."]),
  mcq("t65-bio-5.3", "5.3", 5,
      "In pea plants, the allele for purple flowers (P) is dominant to the allele for white flowers (p). A plant heterozygous for flower color is crossed with a white-flowered plant. What fraction of the offspring is expected to have white flowers?",
      ["1/4", "1/2", "3/4", "0"],
      "B",
      ["Tempts because 1/4 is the familiar fraction for a recessive phenotype, but it comes from crossing two heterozygotes (Pp x Pp). Fix: write both parents' genotypes before reaching for a remembered ratio.",
       "The heterozygous parent (Pp) makes P and p gametes in equal numbers, and the white parent (pp) makes only p gametes. The offspring are 1/2 Pp (purple) and 1/2 pp (white). Writing both parental genotypes before the cross is what earns the point.",
       "Tempts because 3/4 is the classic dominant fraction from Pp x Pp, but this cross is with a white parent, and the question asks about white offspring. Fix: set up the cross in the question, not the one you remember.",
       "Tempts if you assume the dominant allele always shows up in the offspring, but the heterozygous parent passes p to half its offspring. Fix: track each parent's gametes separately."],
      ["Assign each parent's genotype first.", "List the gametes each parent can make.", "Read the ratio from the completed cross."],
      ["Using the Pp x Pp ratio for a different cross.", "Assuming every offspring shows the dominant trait.", "Skipping the gametes each parent makes."]),
  mcq("t65-bio-7.5", "7.5", 7,
      "In a population in Hardy-Weinberg equilibrium for a gene with two alleles, 16% of individuals show the recessive phenotype. What is the expected frequency of heterozygous individuals?",
      ["0.24", "0.15", "0.84", "0.48"],
      "D",
      ["Tempts because pq = (0.6)(0.4) = 0.24 uses the right allele frequencies, but it leaves out the 2: a heterozygote can receive the dominant allele from either parent. Fix: the heterozygote frequency is 2pq.",
       "Tempts students who take the square root of 0.84, the frequency of the dominant phenotype, and treat it as p. That gives p of about 0.92, q of about 0.08 and 2pq of about 0.15. Fix: take the square root only of the recessive phenotype frequency, which is q squared.",
       "Tempts because 0.84 = 1 - 0.16 counts everyone without the recessive phenotype, but that group includes homozygous dominant individuals as well as heterozygotes. Fix: split the dominant phenotype into p squared and 2pq.",
       "The recessive phenotype frequency is q squared = 0.16, so q = 0.4 and p = 1 - 0.4 = 0.6. Heterozygotes are 2pq = 2(0.6)(0.4) = 0.48. Taking the square root of the recessive frequency, not the dominant one, is what earns the point."],
      ["Start from q squared for the recessive phenotype.", "Find p from p + q = 1.", "Compute 2pq for the heterozygotes."],
      ["Taking the square root of the wrong frequency.", "Forgetting the 2 in 2pq.", "Treating the dominant phenotype as all heterozygotes."]),
]
by = {i["key"]: i for i in clean}
# Second patch (round 3): 2.5's stem now says X is uncharged, so no electrochemical gradient can
# drive it (DeepSeek, round 2 C2). Beyond the one-patch-loop policy: 2.5 is NOT publish-eligible
# from this pilot even if it passes; it is rerun only to test the CED-text topic probe.
SECOND_PATCH = {"t65-bio-2.5"}
controls, expected = [], {}

# X1: C3 control -- same enzyme item, but distractor rationales give no reason they tempt and a
# generic fix, and the keyed rationale never says why it earns the point. Evades the lint (each has
# a 'Fix:' and is >= 25 chars) so only the named-trap audit can catch it.
x = copy.deepcopy(by["t65-bio-3.1"]); x["key"] = "t65-bio-x1"
x["rationales"] = {
  "A": "This is incorrect because enzymes do not supply energy. Fix: review enzyme function.",
  "B": "This is incorrect because enzymes do not change temperature. Fix: review enzyme function.",
  "C": "This is incorrect because enzymes are specific. Fix: review enzyme specificity.",
  "D": "Choice D is the correct statement about how enzymes work."}
controls.append(x); expected[x["key"]] = "C3 named-trap: no why-it-tempts, generic fixes, keyed rationale not explained"

# X2: C6 control -- Mendelian item with habit lines that are facts, not habits, and off the topic's brief.
x = copy.deepcopy(by["t65-bio-5.3"]); x["key"] = "t65-bio-x2"
x["earned"] = ["Purple is dominant to white in pea plants.", "Mendel studied pea plants.", "A Punnett square for one gene has four boxes."]
x["lost"] = ["Enzymes can denature at high temperature.", "Some traits are controlled by many genes.", "White flowers are a recessive trait."]
controls.append(x); expected[x["key"]] = "C6 habits: facts not habits, unrelated to the 5.3 point brief"

# X3: C5 control -- designated 7.5 (Hardy-Weinberg) but the question is natural selection (7.2).
x = mcq("t65-bio-x3", "7.5", 7,
  "A population of beetles lives on tree bark that darkened over several decades. Birds find light-colored beetles more easily than dark-colored ones on the dark bark, and beetle color is heritable. Which outcome is most likely over many generations?",
  ["Individual light beetles darken their color to avoid being eaten.",
   "The frequency of alleles for dark color increases in the population.",
   "The population stays the same because color does not affect reproduction.",
   "Birds evolve to see dark beetles more easily within one generation."],
  "B",
  ["Tempts because it describes an adaptation, but individuals do not change their inherited traits in response to need; populations change across generations. Fix: describe change in allele frequencies in the population, not in one individual.",
   "Dark beetles survive and reproduce more on dark bark, and color is heritable, so alleles for dark color are passed on more often and rise in frequency. Linking differential survival of a heritable trait to allele frequency change is what earns the point.",
   "Tempts if you overlook the link between survival and reproduction, but beetles that are eaten leave fewer offspring. Fix: connect survival to reproductive success.",
   "Tempts because predators can evolve too, but evolution happens across generations, not within one. Fix: keep the timescale to many generations."],
  ["Name the heritable variation first.", "Link survival to reproductive success.", "Describe change as allele frequency in the population."],
  ["Saying individuals change their genes.", "Ignoring heritability.", "Compressing evolution into one generation."])
controls.append(x); expected[x["key"]] = "C5 topic drift: designated 7.5, content is 7.2 natural selection"

# X4: C2 control -- water item with one factual error planted in a distractor rationale.
x = copy.deepcopy(by["t65-bio-1.1"]); x["key"] = "t65-bio-x4"
x["rationales"]["D"] = ("Tempts because density is another well-known property of water, but water is densest as a solid, "
  "which is why ice sinks to the bottom of lakes in winter. Fix: explain the property the question names, using hydrogen bonds between molecules.")
controls.append(x); expected[x["key"]] = "C2 rationale accuracy: false claim that ice is denser and sinks"

json.dump(clean + controls, open("items.json", "w"), indent=1, ensure_ascii=False)
json.dump(expected, open("controls.json", "w"), indent=1)
print(len(clean), "clean +", len(controls), "controls; keys", [i["keyed_label"] for i in clean])
