# AI-provisional (Claude-authored) Biology FRQ corpus data.
# NOT Learning-Quality-approved. See label_status in generator output.

BIO_FRQ_ITEMS = [
    {
        "id": "biology_frq_01",
        "title": "Uncoupling the Proton Gradient in Oxidative Phosphorylation",
        "unit": "Unit 3 - Cellular Energetics",
        "difficulty": "Hard",
        "content_type": "mechanism-heavy",
        "stem": (
            "A researcher adds a chemical uncoupler to isolated mitochondria. The uncoupler "
            "makes the inner mitochondrial membrane freely permeable to protons, so protons can "
            "cross back into the matrix without passing through ATP synthase. Electron transport "
            "chain activity and oxygen consumption both increase after the uncoupler is added.\n\n"
            "**A.** Describe how the electron transport chain normally establishes a proton "
            "gradient across the inner mitochondrial membrane, and explain how that gradient "
            "normally drives ATP synthesis.\n\n"
            "**B.** Predict the effect of the uncoupler on the amount of ATP produced per oxygen "
            "molecule consumed, and justify your prediction using the proton gradient."
        ),
        "criteria": [
            {"id": "C1", "text": "Describes that electron transport chain complexes pump protons from the matrix into the intermembrane space, creating a proton (electrochemical) gradient.", "notes": "Must place proton movement matrix -> intermembrane space, not the reverse."},
            {"id": "C2", "text": "Explains that protons normally flow back into the matrix through ATP synthase, and this flow drives the phosphorylation of ADP to ATP (chemiosmosis).", "notes": "Accept 'chemiosmosis' by name or by mechanism description."},
            {"id": "C3", "text": "Predicts that ATP produced per oxygen consumed will decrease despite increased electron transport chain activity and oxygen consumption.", "notes": "Response must reconcile increased O2 use with decreased ATP yield, not just state one or the other."},
            {"id": "C4", "text": "Justifies the prediction by explaining that protons leak back through the membrane itself instead of through ATP synthase, dissipating the gradient as heat and uncoupling electron transport from ATP synthesis.", "notes": "Restating 'the uncoupler uncouples them' without the leak/heat mechanism should not earn full credit."},
        ],
        "responses": [
            {
                "id": "R1",
                "text": (
                    "(A) As electrons move through the electron transport chain complexes, energy released "
                    "is used to actively pump protons from the matrix into the intermembrane space, building "
                    "up a proton gradient. Protons flow back down this gradient through ATP synthase, and "
                    "that flow provides the energy ATP synthase uses to phosphorylate ADP into ATP.\n\n"
                    "(B) Prediction: ATP produced per oxygen consumed will decrease. Justification: Because the "
                    "membrane is now permeable to protons, protons can leak back into the matrix directly through "
                    "the membrane instead of through ATP synthase. The gradient is dissipated as heat rather than "
                    "captured by ATP synthase, so electron transport and oxygen consumption keep occurring (and even "
                    "speed up as the cell tries to restore the gradient) while much less of that energy is converted to ATP."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit response. Correctly places proton pumping direction, chemiosmotic ATP synthesis, and the leak/heat mechanism explaining decreased ATP yield despite increased O2 consumption.",
                "boundary_tags": [],
            },
            {
                "id": "R2",
                "text": (
                    "(A) The electron transport chain pumps protons from the intermembrane space into the matrix, "
                    "and this movement powers ATP synthase to make ATP.\n\n"
                    "(B) Prediction: ATP production will increase. Justification: Since the uncoupler lets protons "
                    "move more freely, ATP synthase can work faster and make more ATP per oxygen used."
                ),
                "labels": {"C1": "not_earned", "C2": "not_earned", "C3": "not_earned", "C4": "not_earned"},
                "reviewer_note": "Reverses the direction of proton pumping in (A), which breaks the chemiosmosis explanation in C2 as well. (B) gets both the direction of the ATP effect and the mechanism wrong -- treats the uncoupler as helping ATP synthase rather than bypassing it. Flags: invented mechanism, direction-reversal error.",
                "boundary_tags": ["invented_biology", "direction_reversal_error"],
            },
            {
                "id": "R3",
                "text": (
                    "(A) Electron transport chain complexes pump protons into the intermembrane space, building a "
                    "gradient. Protons flow back through ATP synthase to make ATP.\n\n"
                    "(B) Prediction: ATP per oxygen consumed will decrease. Justification: The uncoupler messes up "
                    "the normal process so the cell can't make as much ATP anymore."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "not_earned"},
                "reviewer_note": "Part A is fully correct and the direction of the prediction is right, but the justification never explains *how* the uncoupler lowers ATP yield -- no mention of proton leak, bypassing ATP synthase, or heat dissipation. Restates the outcome rather than the mechanism. Flags: over-credit risk if graded on prediction direction alone.",
                "boundary_tags": ["over_credit_risk", "justification_restates_prompt"],
            },
            {
                "id": "R4",
                "text": (
                    "(A) The electron transport chain pumps protons from the matrix into the intermembrane space, "
                    "creating a gradient that drives ATP synthase to produce ATP from ADP.\n\n"
                    "(B) Prediction: ATP produced per oxygen consumed will decrease. Justification: The uncoupler "
                    "makes the membrane permeable to protons, so protons leak back into the matrix through the "
                    "membrane itself, not through ATP synthase. This wastes the gradient as heat instead of ATP, "
                    "even though the electron transport chain runs faster to try to keep up."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Second full-credit response with slightly different phrasing, useful as a paraphrase-robustness check against R1 -- the grader should not require R1's exact wording ('as heat') to award C4.",
                "boundary_tags": [],
            },
            {
                "id": "R5",
                "text": (
                    "(A) Protons are pumped into the intermembrane space by the electron transport chain, creating "
                    "a gradient that powers ATP synthase.\n\n"
                    "(B) Prediction: ATP production per oxygen will stay the same, because the electron transport "
                    "chain is still running and oxygen is still being consumed at the end of the chain, so ATP "
                    "synthase should still work normally."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "not_earned", "C4": "not_earned"},
                "reviewer_note": "Part A is correct, but the prediction ignores that the gradient itself is dissipated by the leak -- treats 'chain is running' as sufficient for normal ATP output, missing the core uncoupling concept. Flags: under-credit risk if grader mistakes 'chain still running' language for partial C4 credit -- it should not receive any C4 credit.",
                "boundary_tags": ["misconception_chain_activity_equals_atp_yield"],
            },
            {
                "id": "R6",
                "text": (
                    "(A) Electron transport chain complexes use energy from electrons to move protons across the "
                    "membrane, and this makes ATP somehow through ATP synthase.\n\n"
                    "(B) Prediction: ATP will decrease per oxygen consumed. Justification: protons stop moving "
                    "through the membrane entirely once the uncoupler is added, so ATP synthase has nothing to use."
                ),
                "labels": {"C1": "unable_to_determine", "C2": "not_earned", "C3": "earned", "C4": "not_earned"},
                "reviewer_note": "Direction of proton pumping in (A) is vague ('across the membrane' without specifying matrix-to-intermembrane direction) -- reviewer should confirm whether vague directionality still earns C1; flagged as unable_to_determine pending a rubric-drift decision rather than scored outright. (B) prediction direction is right but justification invents the wrong mechanism (protons stopping entirely, rather than leaking through the membrane instead of ATP synthase). Flags: rubric ambiguity on C1 vague-direction wording, invented mechanism on C4.",
                "boundary_tags": ["rubric_ambiguity", "invented_biology"],
            },
        ],
    },
    {
        "id": "biology_frq_02",
        "title": "A CDK Inhibitor and the G1/S Checkpoint",
        "unit": "Unit 4 - Cell Communication and Cell Cycle",
        "difficulty": "Medium",
        "content_type": "mechanism-heavy",
        "stem": (
            "A drug inhibits cyclin-dependent kinase (CDK) activity in cultured human cells. "
            "Treated cells accumulate in the G1 phase of the cell cycle and do not progress "
            "to S phase, even though nutrients and growth signals are present.\n\n"
            "**A.** Describe how cyclin-CDK complexes normally regulate passage through the "
            "G1 checkpoint.\n\n"
            "**B.** Explain why inhibiting CDK activity causes cells to arrest in G1 rather "
            "than progressing to S phase."
        ),
        "criteria": [
            {"id": "C1", "text": "Describes that cyclin binds CDK to form an active cyclin-CDK complex.", "notes": "Accept 'cyclin activates CDK' as equivalent."},
            {"id": "C2", "text": "Explains that the active cyclin-CDK complex phosphorylates target proteins (e.g., Rb) needed to pass the G1 checkpoint.", "notes": "Naming Rb specifically is not required; 'phosphorylates checkpoint target proteins' is sufficient."},
            {"id": "C3", "text": "Explains that phosphorylation of these targets normally releases transcription factors (e.g., E2F) that allow expression of S-phase genes / entry into S phase.", "notes": "Accept general 'triggers genes needed for DNA replication/S phase' language."},
            {"id": "C4", "text": "Connects CDK inhibition to arrest by explaining that without CDK activity, target proteins remain unphosphorylated, checkpoint proteins keep blocking the pathway, and the cell cannot pass into S phase regardless of external growth signals.", "notes": "Must explicitly link the missing phosphorylation step to the arrest, not just restate 'CDK is blocked so the cycle stops.'"},
        ],
        "responses": [
            {
                "id": "R1",
                "text": (
                    "(A) Cyclin proteins bind to and activate CDK, forming a cyclin-CDK complex. This active complex "
                    "phosphorylates checkpoint target proteins such as Rb, which releases transcription factors like "
                    "E2F that turn on genes needed for DNA replication, allowing the cell to pass the G1 checkpoint "
                    "into S phase.\n\n"
                    "(B) Without CDK activity, the cyclin-CDK complex cannot form an active kinase, so Rb (or "
                    "equivalent checkpoint proteins) is never phosphorylated. Unphosphorylated Rb continues to hold "
                    "E2F inactive, so S-phase genes are never turned on. The cell therefore arrests in G1 even with "
                    "growth signals present, because the checkpoint block was never removed."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit response with the complete cyclin-CDK-Rb-E2F chain and an explicit link between missing phosphorylation and continued arrest.",
                "boundary_tags": [],
            },
            {
                "id": "R2",
                "text": (
                    "(A) CDK makes cyclin, and together they check if the cell is big enough to divide.\n\n"
                    "(B) The drug stops CDK from making cyclin, so the cell doesn't know it's ready and stays in G1."
                ),
                "labels": {"C1": "not_earned", "C2": "not_earned", "C3": "not_earned", "C4": "not_earned"},
                "reviewer_note": "Reverses the cyclin-CDK relationship (CDK does not make cyclin) and never describes phosphorylation of any checkpoint target. 'Checks if the cell is big enough' is a vague restatement of 'checkpoint' rather than a mechanism. Flags: invented biology, mechanism omitted entirely.",
                "boundary_tags": ["invented_biology", "mechanism_omitted"],
            },
            {
                "id": "R3",
                "text": (
                    "(A) Cyclin binds CDK to activate it. The active complex phosphorylates target proteins that "
                    "let the cell move into S phase.\n\n"
                    "(B) Without CDK, the checkpoint stays closed and the cell can't move to S phase."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "not_earned", "C4": "not_earned"},
                "reviewer_note": "C1 and C2 are earned in general terms, but (A) never names or describes what the phosphorylation releases (E2F / S-phase gene expression), so C3 is not earned. (B) restates 'checkpoint stays closed' without tying it back to the missing phosphorylation step from (A), so C4 is not earned either. Flags: over-credit risk if grader assumes C3 is implied by C2.",
                "boundary_tags": ["over_credit_risk", "justification_restates_prompt"],
            },
            {
                "id": "R4",
                "text": (
                    "(A) Cyclin-CDK complexes phosphorylate Rb, which releases E2F to turn on genes needed for "
                    "S phase.\n\n"
                    "(B) Since the drug inhibits CDK, cyclin can't bind to it anymore, so no complex ever forms and "
                    "the checkpoint can't be passed."
                ),
                "labels": {"C1": "not_earned", "C2": "earned", "C3": "earned", "C4": "not_earned"},
                "reviewer_note": "Part A skips describing complex formation itself (jumps straight to phosphorylation), so C1 is not clearly earned, though C2/C3 are described well. Part B invents an incorrect mechanism -- CDK inhibitors typically block kinase activity, not cyclin binding -- so the arrest explanation is built on an unsupported claim. Flags: invented biology in the inhibition mechanism, C1 boundary case (implied but not stated).",
                "boundary_tags": ["invented_biology", "rubric_ambiguity"],
            },
            {
                "id": "R5",
                "text": (
                    "(A) Cyclin binds CDK, forming an active complex that phosphorylates checkpoint proteins so "
                    "the cell can enter S phase.\n\n"
                    "(B) The cell arrests in G1 because CDK is inhibited, so the checkpoint doesn't pass."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "not_earned", "C4": "not_earned"},
                "reviewer_note": "Same shape as R3 -- correct on complex formation and phosphorylation in general, but part A never states what phosphorylation releases (E2F/S-phase genes), and part B just restates the observation in the prompt ('CDK is inhibited so the checkpoint doesn't pass') without tracing the missing-phosphorylation link. Useful paired example with R3 for calibrating the C3/C4 boundary.",
                "boundary_tags": ["under_credit_risk_if_merged_with_R3", "justification_restates_prompt"],
            },
            {
                "id": "R6",
                "text": (
                    "(A) Active cyclin-CDK phosphorylates Rb, releasing E2F, which activates transcription of genes "
                    "required for DNA replication and S-phase entry.\n\n"
                    "(B) If CDK is inhibited, Rb is never phosphorylated, so it continues binding and inactivating "
                    "E2F. Without free E2F, S-phase genes are never transcribed, so the cell cannot leave G1 even "
                    "though external growth signals are present."
                ),
                "labels": {"C1": "unable_to_determine", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "B, C, D of the chain are fully and precisely described. However, (A) never explicitly states that cyclin *binds* CDK to activate it -- it starts from 'active cyclin-CDK' as a given. Reviewer should decide whether starting from the already-formed complex still earns C1, or whether binding must be stated explicitly; flagged unable_to_determine pending that call rather than assumed earned.",
                "boundary_tags": ["rubric_ambiguity"],
            },
        ],
    },
    {
        "id": "biology_frq_03",
        "title": "Competitive vs. Noncompetitive Inhibition from Kinetics Data",
        "unit": "Unit 3 - Cellular Energetics (Enzymes)",
        "difficulty": "Medium",
        "content_type": "concept-heavy",
        "stem": (
            "An enzyme's reaction rate is measured across a range of substrate concentrations "
            "under three conditions: no inhibitor, Inhibitor X, and Inhibitor Y. Adding Inhibitor "
            "X raises the substrate concentration needed to reach half of Vmax but does not change "
            "Vmax itself. Adding Inhibitor Y lowers Vmax but does not change the substrate "
            "concentration needed to reach half of the (now lower) Vmax.\n\n"
            "**A.** Identify which inhibitor (X or Y) is a competitive inhibitor and which is a "
            "noncompetitive inhibitor, and justify each identification using the data described.\n\n"
            "**B.** Explain why increasing substrate concentration can overcome the effect of a "
            "competitive inhibitor but cannot overcome the effect of a noncompetitive inhibitor."
        ),
        "criteria": [
            {"id": "C1", "text": "Identifies Inhibitor X as competitive.", "notes": "Must be paired with correct data-based justification in C2 to earn full identification credit conceptually, but ID and justification are labeled separately."},
            {"id": "C2", "text": "Justifies X as competitive using the data: unchanged Vmax with increased apparent Km (more substrate needed to reach half-Vmax) indicates competition at the active site.", "notes": "Response should reference the Vmax-unchanged / Km-increased pattern, not just assert 'it competes.'"},
            {"id": "C3", "text": "Identifies Inhibitor Y as noncompetitive and justifies using the data: Vmax decreases while the substrate level needed to reach half of the new Vmax is unchanged, indicating the inhibitor acts at a site other than the active site.", "notes": "Both ID and data justification bundled in this criterion for Y."},
            {"id": "C4", "text": "Explains that excess substrate can out-compete a competitive inhibitor for the active site (restoring Vmax), but a noncompetitive inhibitor binds elsewhere and reduces functional enzyme regardless of substrate concentration, so adding substrate cannot restore Vmax.", "notes": "Must address both halves (why competitive is overcome, why noncompetitive is not) for full credit."},
        ],
        "responses": [
            {
                "id": "R1",
                "text": (
                    "(A) Inhibitor X is competitive: Vmax stays the same but more substrate is needed to reach half "
                    "of Vmax, which means the inhibitor is competing with substrate for the active site rather than "
                    "permanently blocking the enzyme. Inhibitor Y is noncompetitive: Vmax decreases, but the "
                    "substrate level needed to reach half of that new (lower) Vmax is unchanged, which fits an "
                    "inhibitor binding somewhere other than the active site and taking some enzyme out of action "
                    "regardless of substrate levels.\n\n"
                    "(B) Adding more substrate increases the chance that substrate molecules occupy the active "
                    "site instead of the competitive inhibitor, so at high enough substrate concentration the "
                    "enzyme can still reach its normal Vmax. A noncompetitive inhibitor binds at a different site "
                    "(often changing enzyme shape), so it doesn't matter how much substrate is present -- the "
                    "affected enzyme molecules stay non-functional, permanently lowering Vmax."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit response with data-grounded justification for both inhibitors and a complete explanation of why excess substrate rescues one but not the other.",
                "boundary_tags": [],
            },
            {
                "id": "R2",
                "text": (
                    "(A) Inhibitor X is noncompetitive and Inhibitor Y is competitive, because X changes the shape "
                    "of the enzyme and Y blocks the active site.\n\n"
                    "(B) More substrate can push past a competitive inhibitor because there's more of it, but "
                    "noncompetitive inhibitors are stronger so substrate can't overcome them."
                ),
                "labels": {"C1": "not_earned", "C2": "not_earned", "C3": "not_earned", "C4": "not_earned"},
                "reviewer_note": "Swaps the identities of X and Y relative to the data (X is actually competitive based on unchanged Vmax/raised apparent Km). Justification in (A) asserts mechanism without citing the data at all, and (B) explains the difference via inhibitor 'strength' rather than binding site/site competition, which is not a supported mechanism. Flags: identity swap, invented mechanism, data not used.",
                "boundary_tags": ["invented_biology", "data_not_cited"],
            },
            {
                "id": "R3",
                "text": (
                    "(A) Inhibitor X is competitive because Vmax is unchanged. Inhibitor Y is noncompetitive "
                    "because Vmax decreases.\n\n"
                    "(B) Substrate can overcome a competitive inhibitor by outcompeting it, but it can't overcome "
                    "a noncompetitive inhibitor."
                ),
                "labels": {"C1": "earned", "C2": "not_earned", "C3": "not_earned", "C4": "not_earned"},
                "reviewer_note": "Correct identifications, but neither justification cites the full data pattern required (X: increased apparent Km specifically; Y: unchanged half-Vmax substrate level specifically) -- both are one-clause restatements of the ID. Part B restates the conclusion of C4 without any mechanism (no active-site competition, no alternate binding site). Flags: over-credit risk if grader accepts bare Vmax mention as sufficient data justification.",
                "boundary_tags": ["over_credit_risk", "justification_restates_prompt"],
            },
            {
                "id": "R4",
                "text": (
                    "(A) X is competitive -- more substrate is needed to reach half-Vmax while Vmax itself doesn't "
                    "change, which fits competition for the active site. Y is noncompetitive -- Vmax drops, showing "
                    "some enzyme is taken out of action no matter how much substrate is present, and since the "
                    "half-Vmax substrate level relative to the new Vmax doesn't shift, the inhibitor isn't competing "
                    "at the active site.\n\n"
                    "(B) Because X only slows the enzyme down by competing for the same site substrate uses, "
                    "flooding the reaction with substrate molecules gives substrate the numeric advantage and lets "
                    "the enzyme reach full speed again. Y's damage doesn't depend on the active site being "
                    "occupied, so no amount of substrate changes how much active enzyme exists."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Second full-credit response with different phrasing, useful for calibrating paraphrase tolerance on the Vmax/apparent-Km justification language.",
                "boundary_tags": [],
            },
            {
                "id": "R5",
                "text": (
                    "(A) Inhibitor X is competitive because it directly competes with the substrate; Inhibitor Y is "
                    "noncompetitive because it does not compete with the substrate.\n\n"
                    "(B) A competitive inhibitor can be overcome with more substrate because there's a competition, "
                    "and whoever has more numbers wins the active site. A noncompetitive inhibitor doesn't compete "
                    "for the active site so more substrate doesn't help."
                ),
                "labels": {"C1": "earned", "C2": "not_earned", "C3": "not_earned", "C4": "earned"},
                "reviewer_note": "Correctly identifies X and part B's mechanism explanation is acceptable, but neither identification is justified using the actual Vmax/half-Vmax data from the prompt -- both restate the definition of 'competitive'/'noncompetitive' circularly ('competitive because it competes'). Flags: circular justification, data not cited; illustrates that C4 can be earned independent of C2/C3 when the general mechanism is right but the data-tie is missing.",
                "boundary_tags": ["data_not_cited", "rubric_ambiguity"],
            },
        ],
    },
    {
        "id": "biology_frq_04",
        "title": "Tonicity Shift in a Plant Cell Vacuole",
        "unit": "Unit 2 - Cell Structure and Function",
        "difficulty": "Medium",
        "content_type": "concept-heavy",
        "stem": (
            "A turgid plant cell with a large central vacuole is placed in a hypertonic solution "
            "of sucrose. After 30 minutes, the cell is observed to be plasmolyzed.\n\n"
            "**A.** Describe the direction of net water movement across the plasma membrane "
            "during this 30-minute period, and explain why water moves in that direction.\n\n"
            "**B.** Predict what would happen to the same plasmolyzed cell if it were then moved "
            "into distilled water, and justify your prediction."
        ),
        "criteria": [
            {"id": "C1", "text": "Describes net water movement as out of the cell (cytoplasm/vacuole into the surrounding solution).", "notes": "Direction must be explicit, not just 'water moves.'"},
            {"id": "C2", "text": "Explains the direction using water potential/solute concentration: the hypertonic solution has a lower water potential (higher solute concentration) than the cell interior, so water moves down its water potential gradient out of the cell.", "notes": "Accept either water-potential language or solute-concentration/osmosis language, but the explanation must reference the gradient, not just define plasmolysis."},
            {"id": "C3", "text": "Predicts that the cell will regain turgor / water will move back into the cell (deplasmolysis) when placed in distilled water.", "notes": "Must state the direction reverses, not just 'the cell will be affected.'"},
            {"id": "C4", "text": "Justifies the prediction by explaining that distilled water has a higher water potential (essentially no solutes) than the cell interior, so water now moves down its gradient into the cell, re-inflating the vacuole and pushing the membrane back against the cell wall.", "notes": "Should mention the cell wall limiting expansion / turgor pressure being restored, not unlimited swelling."},
        ],
        "responses": [
            {
                "id": "R1",
                "text": (
                    "(A) Water moves out of the cell during the 30 minutes. Because the surrounding sucrose "
                    "solution is hypertonic, it has a higher solute concentration and therefore a lower water "
                    "potential than the cell's interior. Water moves down its water potential gradient, from "
                    "the higher-water-potential cell interior to the lower-water-potential external solution, "
                    "causing the cell to lose water and the membrane to pull away from the wall (plasmolysis).\n\n"
                    "(B) Prediction: The cell will regain turgor pressure as water moves back in (deplasmolysis). "
                    "Justification: Distilled water has almost no solutes, so it has a much higher water potential "
                    "than the cell interior, which still has a relatively high solute concentration after losing "
                    "water. Water now flows down its gradient into the cell, re-inflating the central vacuole "
                    "until the cell membrane presses against the cell wall again, restoring turgor pressure."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit response with correct direction, water-potential-based mechanism in both parts, and correct mention of the cell wall limiting re-expansion.",
                "boundary_tags": [],
            },
            {
                "id": "R2",
                "text": (
                    "(A) Water moves into the cell because the cell has more solutes than the sucrose solution, "
                    "so water tries to balance it out.\n\n"
                    "(B) The cell will burst because distilled water has no solutes and will keep flowing in "
                    "until the cell membrane pops."
                ),
                "labels": {"C1": "not_earned", "C2": "not_earned", "C3": "not_earned", "C4": "not_earned"},
                "reviewer_note": "Reverses the direction of water movement in (A) relative to the given hypertonic condition (should be out, not in), which is inconsistent with the stated observation that the cell plasmolyzed. (B) ignores the cell wall entirely and predicts bursting, which does not occur in walled plant cells at normal turgor. Flags: direction-reversal error, invented outcome (animal-cell lysis logic applied to a plant cell).",
                "boundary_tags": ["invented_biology", "direction_reversal_error"],
            },
            {
                "id": "R3",
                "text": (
                    "(A) Water moves out of the cell, causing plasmolysis, because the solution outside is "
                    "hypertonic.\n\n"
                    "(B) Prediction: the cell will regain turgor pressure. Justification: distilled water will "
                    "move into the cell."
                ),
                "labels": {"C1": "earned", "C2": "not_earned", "C3": "earned", "C4": "not_earned"},
                "reviewer_note": "Both parts get the direction right but never explain the water-potential/solute-gradient mechanism behind either movement -- (A) just restates 'hypertonic' as the cause without saying why that produces outward water movement, and (B) states the conclusion of C4 as its own justification. Flags: over-credit risk if graded on direction alone; useful boundary case distinguishing 'correct direction' (C1/C3) from 'correct mechanism' (C2/C4).",
                "boundary_tags": ["over_credit_risk", "justification_restates_prompt"],
            },
            {
                "id": "R4",
                "text": (
                    "(A) Net water movement is out of the cell. The hypertonic sucrose solution has less water "
                    "and more solute than the cell's cytoplasm, so water diffuses from where it's more "
                    "concentrated (inside the cell) to where it's less concentrated (outside), which is osmosis "
                    "down the water concentration gradient.\n\n"
                    "(B) Prediction: the cell will deplasmolyze and regain turgor. Justification: distilled water "
                    "is almost pure water, so it has a much higher concentration of water molecules than the "
                    "cell's interior, and water diffuses back into the cell until the vacuole pushes the membrane "
                    "against the cell wall again."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit response phrased entirely in terms of relative water concentration/osmosis rather than water-potential terminology -- confirms both phrasings should be accepted for C2/C4 as the rubric notes allow.",
                "boundary_tags": [],
            },
            {
                "id": "R5",
                "text": (
                    "(A) Water leaves the cell because the outside solution is hypertonic and has a lower water "
                    "potential, so water moves out down its gradient.\n\n"
                    "(B) Prediction: the cell will keep losing water and shrink further, because the sucrose "
                    "residue left on the cell surface will keep drawing water out even in distilled water."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "not_earned", "C4": "not_earned"},
                "reviewer_note": "Part A is fully correct. Part B invents a 'sucrose residue on the cell surface' mechanism that isn't supported -- once the cell is moved into distilled water, the external solute concentration is what determines water potential outside the cell, not a residue. Predicts the wrong direction of change as a result. Flags: invented biology, unsupported inference.",
                "boundary_tags": ["invented_biology", "unsupported_inference"],
            },
        ],
    },
    {
        "id": "biology_frq_05",
        "title": "Lac Operon Response to Lactose and Glucose Availability",
        "unit": "Unit 6 - Gene Expression and Regulation",
        "difficulty": "Hard",
        "content_type": "boundary-sensitive",
        "stem": (
            "*E. coli* cells are grown in a medium containing both glucose and lactose. Researchers "
            "then transfer the cells to a medium containing lactose but no glucose.\n\n"
            "**A.** Describe the state of the lac operon (transcribed at low, moderate, or high "
            "level) while both glucose and lactose are present, and explain the role of the lac "
            "repressor and CAP/cAMP in producing that state.\n\n"
            "**B.** Explain how removing glucose (while lactose remains present) changes lac "
            "operon transcription, referencing both the repressor and CAP/cAMP."
        ),
        "criteria": [
            {"id": "C1", "text": "States that with both glucose and lactose present, the lac operon is transcribed at a low level (not fully off, not fully high).", "notes": "Full 'off' or full 'high' without qualification should not earn this criterion."},
            {"id": "C2", "text": "Explains that lactose (via allolactose) binds and inactivates the lac repressor, removing repression of the operon, while low cAMP (because glucose is present) means CAP is not bound/active at the promoter, so RNA polymerase binding is not strongly enhanced.", "notes": "Both halves (repressor inactivated by lactose AND CAP not active due to glucose) are needed for full credit."},
            {"id": "C3", "text": "Explains that removing glucose raises cAMP levels, allowing CAP-cAMP to bind the promoter region and enhance RNA polymerase binding/transcription.", "notes": "Must connect glucose removal to rising cAMP to CAP activation, not just assert 'transcription goes up.'"},
            {"id": "C4", "text": "Concludes that with lactose present and glucose absent, the operon is transcribed at a high level, because the repressor remains inactivated by lactose and CAP-cAMP is now active, both promoting transcription.", "notes": "Requires the combined effect of both regulatory elements pointing the same direction (high transcription), not just one."},
        ],
        "responses": [
            {
                "id": "R1",
                "text": (
                    "(A) With both glucose and lactose present, the lac operon is transcribed at a low level. "
                    "Lactose is converted to allolactose, which binds the lac repressor and inactivates it, so the "
                    "repressor is not blocking transcription. However, glucose being present keeps cAMP levels low, "
                    "so CAP is not bound to the promoter and cannot enhance RNA polymerase binding, keeping "
                    "transcription at a baseline low level rather than a high level.\n\n"
                    "(B) Removing glucose causes cAMP levels to rise. Rising cAMP binds CAP, and the CAP-cAMP "
                    "complex binds the promoter region, increasing RNA polymerase binding and boosting "
                    "transcription. Since lactose is still present, the repressor remains inactivated. With both "
                    "the repressor inactive and CAP-cAMP now active, the lac operon is transcribed at a high level."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit response correctly distinguishing the low-transcription (both sugars present) state from the high-transcription (lactose only) state, with both repressor and CAP/cAMP mechanisms explained in each part.",
                "boundary_tags": [],
            },
            {
                "id": "R2",
                "text": (
                    "(A) The lac operon is completely off when both sugars are present, because the cell prefers "
                    "glucose and shuts down the lactose genes entirely.\n\n"
                    "(B) When glucose is removed, the operon turns on because now the cell needs to use lactose "
                    "for energy."
                ),
                "labels": {"C1": "not_earned", "C2": "not_earned", "C3": "not_earned", "C4": "not_earned"},
                "reviewer_note": "Claims the operon is 'completely off' with both sugars present, but lactose is still present and inactivates the repressor, so transcription is low, not zero. Neither part mentions the repressor or CAP/cAMP mechanism at all -- 'the cell prefers glucose' and 'the cell needs energy' are teleological restatements, not mechanisms. Flags: invented biology (operon fully off), mechanism omitted.",
                "boundary_tags": ["invented_biology", "mechanism_omitted"],
            },
            {
                "id": "R3",
                "text": (
                    "(A) The operon is transcribed at a low level because lactose inactivates the repressor but "
                    "glucose being present means CAP isn't very active.\n\n"
                    "(B) Removing glucose lets CAP become active, which increases transcription."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "not_earned"},
                "reviewer_note": "Parts A and the first half of B correctly cover the repressor and CAP mechanisms, but part B never states the resulting transcription *level* (high) or reconnects it to the repressor still being inactivated by lactose -- it only says transcription 'increases' without characterizing the resulting state relative to (A)'s baseline. Flags: over-credit risk if grader treats 'increases' as equivalent to the specific high-level conclusion required by C4.",
                "boundary_tags": ["over_credit_risk", "rubric_ambiguity"],
            },
            {
                "id": "R4",
                "text": (
                    "(A) Lac operon transcription is low with both sugars present: lactose/allolactose inactivates "
                    "the repressor, removing that block, but low cAMP while glucose is present means CAP-cAMP "
                    "isn't bound at the promoter, so RNA polymerase binding isn't strongly enhanced.\n\n"
                    "(B) Without glucose, cAMP rises and binds CAP, and CAP-cAMP binds the promoter to boost "
                    "RNA polymerase activity. Because lactose is still present, the repressor stays off the "
                    "operator. With the repressor inactive and CAP-cAMP now enhancing transcription, the operon "
                    "reaches a high level of transcription."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Second full-credit response with equivalent phrasing to R1, useful for confirming grader consistency across near-duplicate high-quality answers.",
                "boundary_tags": [],
            },
            {
                "id": "R5",
                "text": (
                    "(A) The operon is at a moderate level because both sugars are present and they balance "
                    "each other out.\n\n"
                    "(B) When glucose disappears, cAMP goes up and CAP binds the promoter, so transcription "
                    "increases to a high level, and lactose is still around so the repressor also stays inactive."
                ),
                "labels": {"C1": "not_earned", "C2": "not_earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Part A's 'balance each other out' framing does not correctly characterize the low-transcription state or explain either the repressor or CAP mechanism -- it is a vague restatement rather than a mechanism, so C1/C2 are not earned. Part B, however, independently and correctly explains both the CAP/cAMP rise and the repressor remaining inactive, earning C3/C4 despite the weak first half. Illustrates that criteria for (A) and (B) should be scored independently rather than assuming a weak (A) implies a weak (B).",
                "boundary_tags": ["rubric_ambiguity", "vague_generality"],
            },
        ],
    },
    {
        "id": "biology_frq_06",
        "title": "A Primase-Deficient Mutant and Lagging Strand Synthesis",
        "unit": "Unit 6 - DNA Replication",
        "difficulty": "Hard",
        "content_type": "mechanism-heavy",
        "stem": (
            "A bacterial mutant produces a nonfunctional primase enzyme but has normal helicase, "
            "DNA polymerase, and ligase activity. Researchers examine DNA replication in this "
            "mutant.\n\n"
            "**A.** Describe the normal roles of helicase and primase at a replication fork, and "
            "explain why DNA polymerase requires the product that primase makes.\n\n"
            "**B.** Predict the effect of nonfunctional primase on leading strand synthesis and on "
            "lagging strand synthesis, and justify each prediction."
        ),
        "criteria": [
            {"id": "C1", "text": "Describes helicase unwinding the double helix at the replication fork, and primase synthesizing short RNA primers that provide a free 3' end.", "notes": "Both enzymes must be described, not just one."},
            {"id": "C2", "text": "Explains that DNA polymerase can only add nucleotides to an existing 3' end and cannot initiate a new strand on its own, so it requires the RNA primer as a starting point.", "notes": "Must state the 3'-OH extension requirement, not just 'DNA polymerase needs primase to work.'"},
            {"id": "C3", "text": "Predicts that both leading and lagging strand synthesis will fail to initiate (no new DNA strand is made on either strand) because both require an RNA primer to begin, even though leading strand normally needs only one primer and lagging strand needs many.", "notes": "A response that says only lagging strand is affected should not earn this criterion -- leading strand also needs one initial primer."},
            {"id": "C4", "text": "Justifies that although the lagging strand normally requires repeated primase activity for each Okazaki fragment (making it more heavily dependent on primase), the leading strand also needs at least one primer to begin synthesis in the first place, so eliminating primase blocks initiation of DNA replication on both strands.", "notes": "Response should explicitly compare the two strands' primer dependence rather than treating only lagging strand as affected."},
        ],
        "responses": [
            {
                "id": "R1",
                "text": (
                    "(A) Helicase unwinds the double helix at the replication fork, separating the two strands "
                    "and creating two single-stranded templates. Primase then synthesizes a short RNA primer on "
                    "each template, providing a free 3'-OH end. DNA polymerase can only add new nucleotides onto "
                    "an existing 3' end -- it cannot start a new strand from scratch -- so it requires the primer "
                    "primase provides before it can begin extending DNA.\n\n"
                    "(B) Prediction: Neither leading strand nor lagging strand synthesis will initiate. "
                    "Justification: the leading strand needs one initial RNA primer to start continuous synthesis, "
                    "and the lagging strand needs a new primer for every Okazaki fragment. Without functional "
                    "primase, no primers are made on either strand, so DNA polymerase has no 3' end to extend on "
                    "either strand, and replication cannot begin at all."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit response. Correctly generalizes primer dependence to both strands rather than assuming only the lagging strand is affected.",
                "boundary_tags": [],
            },
            {
                "id": "R2",
                "text": (
                    "(A) Helicase makes RNA primers and primase unwinds the DNA.\n\n"
                    "(B) Prediction: only the lagging strand will be affected, because it's the one made in "
                    "pieces. Justification: the leading strand is made continuously so it doesn't need primase."
                ),
                "labels": {"C1": "not_earned", "C2": "not_earned", "C3": "not_earned", "C4": "not_earned"},
                "reviewer_note": "Swaps the roles of helicase and primase entirely in (A). (B) contains the classic misconception that continuous (leading-strand) synthesis means no primer is ever needed -- in fact the leading strand still needs one initial primer to begin. Flags: role-swap error, common misconception (continuous synthesis needs no primer at all).",
                "boundary_tags": ["invented_biology", "common_misconception_continuous_strand_no_primer"],
            },
            {
                "id": "R3",
                "text": (
                    "(A) Helicase unwinds the DNA at the fork. Primase makes RNA primers so DNA polymerase has "
                    "somewhere to start.\n\n"
                    "(B) Prediction: both strands will fail to replicate, because DNA polymerase needs a primer "
                    "on both strands."
                ),
                "labels": {"C1": "earned", "C2": "not_earned", "C3": "earned", "C4": "not_earned"},
                "reviewer_note": "Part A correctly describes both enzymes' roles but never explains *why* DNA polymerase needs a free 3' end to extend (just says 'somewhere to start'), so C2 is not fully earned. Part B reaches the correct prediction but the justification is a one-clause restatement without comparing the strands' differing primer dependence (single primer vs. repeated primers). Flags: over-credit risk if grader accepts 'needs a primer' alone as the mechanism.",
                "boundary_tags": ["over_credit_risk", "justification_restates_prompt"],
            },
            {
                "id": "R4",
                "text": (
                    "(A) Helicase separates the two DNA strands at the replication fork by breaking hydrogen "
                    "bonds between bases. Primase synthesizes short RNA primers complementary to the template, "
                    "giving a 3'-OH group. DNA polymerase can only extend an existing strand by adding nucleotides "
                    "to a free 3' end; it cannot join two free nucleotides together to start a strand, so it "
                    "depends on primase's RNA primer as the starting point.\n\n"
                    "(B) Prediction: leading strand synthesis will fail to start and lagging strand synthesis "
                    "will also fail to start. Justification: the leading strand still requires one primer at the "
                    "origin before continuous synthesis can proceed, and the lagging strand requires a new primer "
                    "at the start of every Okazaki fragment; without any primase activity, DNA polymerase has no "
                    "3' end on either template, so no new DNA is synthesized on either strand."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Second full-credit response with more detailed 3'-OH/hydrogen-bond phrasing; useful for confirming the grader doesn't require exact wording to award C1/C2.",
                "boundary_tags": [],
            },
            {
                "id": "R5",
                "text": (
                    "(A) Helicase unwinds DNA and primase lays down RNA primers so polymerase has a place to "
                    "attach.\n\n"
                    "(B) Prediction: the lagging strand will fail completely, but the leading strand will still "
                    "replicate normally since it doesn't need repeated primers the way the lagging strand does."
                ),
                "labels": {"C1": "earned", "C2": "not_earned", "C3": "not_earned", "C4": "not_earned"},
                "reviewer_note": "Part A is acceptable at a general level but again doesn't explain the 3'-OH extension requirement. Part B makes the same continuous-synthesis misconception as R2 in a subtler form -- correctly notes the lagging strand needs *repeated* primers but wrongly concludes the leading strand needs none at all, missing that it still needs one initial primer. Flags: under-credit risk if grader only checks 'lagging strand affected' without checking that leading strand is also predicted to fail.",
                "boundary_tags": ["common_misconception_continuous_strand_no_primer", "under_credit_risk"],
            },
        ],
    },
    {
        "id": "biology_frq_07",
        "title": "Hardy-Weinberg Allele Frequencies After a Non-Random Mating Shift",
        "unit": "Unit 7 - Natural Selection (Population Genetics)",
        "difficulty": "Medium",
        "content_type": "concept-heavy",
        "stem": (
            "In a population of 500 beetles, 320 are homozygous dominant (`GG`, green), 160 are "
            "heterozygous (`Gg`, green), and 20 are homozygous recessive (`gg`, brown) for a "
            "single-locus coat color gene.\n\n"
            "**A.** Calculate the allele frequencies of `G` and `g` in this population, showing "
            "your work.\n\n"
            "**B.** The population is later found to be mating non-randomly: green beetles "
            "strongly prefer to mate with other green beetles. Explain whether this population "
            "is in Hardy-Weinberg equilibrium, and predict how the genotype frequencies (not "
            "allele frequencies) will change over subsequent generations as a result."
        ),
        "criteria": [
            {"id": "C1", "text": "Correctly calculates allele frequencies: p(G) = (2*320 + 160) / 1000 = 0.8, q(g) = (2*20 + 160) / 1000 = 0.2, showing the work (counting alleles, not individuals).", "notes": "Accept equivalent correct arithmetic paths (e.g., computing genotype frequencies first then p = freq(GG) + 1/2 freq(Gg))."},
            {"id": "C2", "text": "States that the population is not in Hardy-Weinberg equilibrium because non-random mating (assortative mating) violates one of the required Hardy-Weinberg assumptions.", "notes": "Must name non-random/assortative mating specifically as the violated assumption, not just 'conditions aren't met.'"},
            {"id": "C3", "text": "Predicts that homozygote genotype frequencies (GG and gg) will increase over subsequent generations while heterozygote (Gg) frequency will decrease.", "notes": "Must specify the direction for both homozygotes and heterozygotes."},
            {"id": "C4", "text": "Explains that assortative mating increases the frequency of matings between similar genotypes, which increases homozygosity in offspring, while allele frequencies themselves (p and q) remain unchanged because no alleles are being gained, lost, or selected against -- only genotypes are being redistributed.", "notes": "Must explicitly note that allele frequencies stay the same even though genotype frequencies shift -- this is the key boundary-sensitive point."},
        ],
        "responses": [
            {
                "id": "R1",
                "text": (
                    "(A) Total alleles = 1000. Count of G alleles = (320 x 2) + (160 x 1) = 640 + 160 = 800, so "
                    "p(G) = 800/1000 = 0.8. Count of g alleles = (20 x 2) + (160 x 1) = 40 + 160 = 200, so "
                    "q(g) = 200/1000 = 0.2.\n\n"
                    "(B) This population is not in Hardy-Weinberg equilibrium because assortative (non-random) "
                    "mating violates the random-mating assumption. Over subsequent generations, the frequency of "
                    "homozygotes (both GG and gg) will increase and the frequency of heterozygotes (Gg) will "
                    "decrease, because green beetles preferentially producing offspring with other green beetles "
                    "increases the chance of pairing similar alleles together. However, the allele frequencies "
                    "themselves (p = 0.8, q = 0.2) will not change, because no alleles are being added, removed, "
                    "or selected against -- assortative mating only redistributes which genotypes those alleles "
                    "end up in, not how many of each allele exist."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit response with correct arithmetic shown, correctly named violated assumption, correct genotype-frequency direction, and the key boundary point that allele frequencies stay constant under assortative mating.",
                "boundary_tags": [],
            },
            {
                "id": "R2",
                "text": (
                    "(A) p = 320/500 = 0.64, q = 20/500 = 0.04.\n\n"
                    "(B) The population is in Hardy-Weinberg equilibrium because the total number of beetles "
                    "isn't changing. Genotype frequencies will stay the same."
                ),
                "labels": {"C1": "not_earned", "C2": "not_earned", "C3": "not_earned", "C4": "not_earned"},
                "reviewer_note": "Calculates allele frequency using individual counts divided by total individuals rather than counting alleles (a common error -- should count each homozygote as 2 alleles and heterozygote as 1 of each), producing incorrect values that don't even sum to 1. Part B incorrectly claims equilibrium holds and that genotype frequencies won't shift, missing the assortative-mating violation entirely. Flags: arithmetic method error, missed assumption violation.",
                "boundary_tags": ["arithmetic_method_error", "invented_biology"],
            },
            {
                "id": "R3",
                "text": (
                    "(A) p(G) = 0.8, q(g) = 0.2 (counting alleles: 800 G alleles and 200 g alleles out of 1000 "
                    "total).\n\n"
                    "(B) This is not Hardy-Weinberg equilibrium because mating isn't random. Homozygotes will "
                    "become more common and heterozygotes less common over time."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "not_earned"},
                "reviewer_note": "Correct calculation, correct equilibrium violation, and correct genotype-frequency direction, but never addresses whether allele frequencies themselves change -- the key boundary distinction the question is testing (genotype frequencies shift, allele frequencies don't). Flags: over-credit risk if graders assume C3 implies C4; this is exactly the kind of response the boundary tag exists to catch.",
                "boundary_tags": ["over_credit_risk", "rubric_boundary_allele_vs_genotype_frequency"],
            },
            {
                "id": "R4",
                "text": (
                    "(A) p(G) = 0.8 and q(g) = 0.2, calculated by counting alleles across all 500 individuals "
                    "(1000 total alleles).\n\n"
                    "(B) Since green beetles prefer green mates, this violates the random mating assumption of "
                    "Hardy-Weinberg, so the population is not in equilibrium. Homozygote frequencies will rise "
                    "and heterozygote frequency will fall over generations as similar genotypes increasingly pair "
                    "up, but the allele frequencies p and q will stay at 0.8 and 0.2 respectively since assortative "
                    "mating only changes which genotype combinations occur, not the total number of each allele "
                    "in the gene pool."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Second full-credit response with the allele-vs-genotype distinction stated explicitly and tied back to the numeric p/q values from (A).",
                "boundary_tags": [],
            },
            {
                "id": "R5",
                "text": (
                    "(A) p(G) = 0.8, q(g) = 0.2.\n\n"
                    "(B) Not in equilibrium, since mating is non-random. Over time, allele frequencies will "
                    "shift so that G becomes even more common, since green beetles are mating together and "
                    "passing on more G alleles, eventually approaching fixation."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "not_earned", "C4": "not_earned"},
                "reviewer_note": "Correct calculation and correctly identifies the violated assumption, but invents an allele-frequency-shift outcome that assortative mating does not cause on its own (that would require selection, drift, or differential reproduction, not just non-random pairing) -- also never addresses genotype frequencies as asked. Flags: invented biology, conflates assortative mating with selection.",
                "boundary_tags": ["invented_biology", "conflates_assortative_mating_with_selection"],
            },
        ],
    },
    {
        "id": "biology_frq_08",
        "title": "Blocking a Downstream Kinase in a GPCR Signaling Cascade",
        "unit": "Unit 4 - Cell Communication and Cell Cycle",
        "difficulty": "Hard",
        "content_type": "boundary-sensitive",
        "stem": (
            "A hormone binds a G-protein-coupled receptor (GPCR) on the surface of a target cell, "
            "triggering a signal transduction cascade that activates protein kinase A (PKA), which "
            "phosphorylates a transcription factor needed to turn on a target gene. A researcher "
            "adds a drug that specifically blocks PKA's kinase activity, without affecting the "
            "GPCR, G-protein, or second messenger production.\n\n"
            "**A.** Describe how binding of the hormone to the GPCR ultimately leads to activation "
            "of PKA, including the role of the G-protein and second messenger.\n\n"
            "**B.** Predict the effect of the PKA-blocking drug on target gene transcription in the "
            "presence of hormone, and explain why steps upstream of PKA still occur normally."
        ),
        "criteria": [
            {"id": "C1", "text": "Describes that hormone binding causes a conformational change in the GPCR, which activates an associated G-protein (e.g., exchanging GDP for GTP).", "notes": "Accept general G-protein activation language without requiring GDP/GTP detail by name, but conformational change + G-protein activation must both appear."},
            {"id": "C2", "text": "Explains that the activated G-protein activates an enzyme (e.g., adenylyl cyclase) that produces a second messenger (e.g., cAMP).", "notes": "Naming cAMP/adenylyl cyclase specifically is preferred but general 'second messenger produced' language is acceptable if the enzyme-activation step is present."},
            {"id": "C3", "text": "Explains that the second messenger activates PKA, and predicts that target gene transcription will not occur (or will be blocked) because the drug prevents PKA from phosphorylating the transcription factor.", "notes": "Must state transcription is blocked specifically due to the phosphorylation step failing, not just 'signaling stops.'"},
            {"id": "C4", "text": "Explains that the upstream steps (GPCR activation, G-protein activation, second messenger production) do not require PKA activity to occur, so they still happen normally -- the block is specific to the one downstream step where PKA acts on the transcription factor.", "notes": "This tests whether the response understands the drug acts at one specific point in the cascade rather than shutting down the whole pathway."},
        ],
        "responses": [
            {
                "id": "R1",
                "text": (
                    "(A) Hormone binding causes a conformational change in the GPCR, which activates an "
                    "associated G-protein by causing it to exchange GDP for GTP. The activated G-protein then "
                    "activates an enzyme such as adenylyl cyclase, which converts ATP into the second messenger "
                    "cAMP. Rising cAMP levels bind to and activate PKA.\n\n"
                    "(B) Prediction: target gene transcription will not occur, because although PKA is activated "
                    "by cAMP, the drug blocks its kinase activity, so it cannot phosphorylate the transcription "
                    "factor needed to turn on the gene. The steps upstream of PKA -- GPCR activation, G-protein "
                    "activation, and cAMP production -- still occur normally because none of those steps require "
                    "PKA's kinase activity; the drug only interferes with the one specific step where PKA acts on "
                    "its target, not the earlier parts of the cascade."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit response tracing the entire cascade correctly and explicitly explaining why the block is localized to one step rather than the whole pathway.",
                "boundary_tags": [],
            },
            {
                "id": "R2",
                "text": (
                    "(A) The hormone enters the cell and directly turns on PKA.\n\n"
                    "(B) Since PKA is blocked, none of the signaling happens at all -- the GPCR, G-protein, and "
                    "second messenger steps also stop because the whole pathway shuts down."
                ),
                "labels": {"C1": "not_earned", "C2": "not_earned", "C3": "earned", "C4": "not_earned"},
                "reviewer_note": "Part A skips the entire GPCR/G-protein/second-messenger cascade and incorrectly has the hormone entering the cell (GPCR ligands for this type of receptor act at the surface). Part B correctly predicts transcription is blocked, but incorrectly claims the entire upstream pathway also stops -- this is the key misconception the item is designed to catch (treating a downstream block as if it shuts down the whole cascade). Flags: invented biology (hormone entering cell), mechanism omitted, downstream-block-treated-as-whole-pathway-block misconception.",
                "boundary_tags": ["invented_biology", "downstream_block_treated_as_whole_pathway_block"],
            },
            {
                "id": "R3",
                "text": (
                    "(A) The GPCR activates a G-protein, which leads to production of a second messenger that "
                    "activates PKA.\n\n"
                    "(B) Target gene transcription won't happen because PKA can't do its job. Everything before "
                    "that step still happens normally."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit at a more general level of detail than R1 -- doesn't name GTP exchange, adenylyl cyclase, or cAMP specifically, but the rubric notes allow general language for C1/C2, and C3/C4 are both clearly and correctly stated. Useful for calibrating how much specificity is actually required versus preferred.",
                "boundary_tags": [],
            },
            {
                "id": "R4",
                "text": (
                    "(A) Hormone binding activates the GPCR, which activates a G-protein, which produces a "
                    "second messenger that activates PKA.\n\n"
                    "(B) Since PKA can't phosphorylate the transcription factor, transcription is blocked. The "
                    "second messenger also stops being made once PKA is blocked, since PKA blocking disrupts "
                    "the whole cascade upstream of it too."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "not_earned"},
                "reviewer_note": "Parts A and the first sentence of B are correct, but the response then incorrectly claims second-messenger production stops because of the PKA block -- inventing feedback that reverses causality (a downstream block does not stop an upstream step). Flags: invented biology, downstream-to-upstream causality reversal; a subtler version of R2's whole-pathway misconception limited to just one upstream step instead of all of them.",
                "boundary_tags": ["invented_biology", "downstream_block_treated_as_whole_pathway_block"],
            },
            {
                "id": "R5",
                "text": (
                    "(A) The hormone binds the GPCR, activating a G-protein that triggers second messenger "
                    "production, which activates PKA to phosphorylate transcription factors.\n\n"
                    "(B) Transcription will decrease somewhat because signaling is disrupted, but some "
                    "transcription may still occur through backup pathways."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "not_earned", "C4": "unable_to_determine"},
                "reviewer_note": "Part A is fully correct. Part B hedges into an unsupported 'backup pathways' claim not established by the prompt, and never clearly states that transcription is blocked because the phosphorylation step specifically fails -- 'decrease somewhat' is vaguer than the rubric's required 'blocked' conclusion. Because the response never actually addresses the upstream-steps-still-occur point directly, C4 is flagged unable_to_determine rather than scored as earned or not; reviewer should decide whether the silence on upstream steps defaults to not_earned. Flags: unsupported inference, vague generality.",
                "boundary_tags": ["unsupported_inference", "vague_generality", "rubric_ambiguity"],
            },
        ],
    },
    {
        "id": "biology_frq_09",
        "title": "RuBisCO Carbon Fixation Under Falling CO2 Concentration",
        "unit": "Unit 3 - Cellular Energetics (Calvin Cycle)",
        "difficulty": "Medium",
        "content_type": "concept-heavy",
        "stem": (
            "A plant is moved from a chamber with normal atmospheric CO2 concentration into a "
            "sealed chamber where CO2 concentration is allowed to gradually fall as photosynthesis "
            "proceeds, while light intensity and temperature are held constant and unlimited ATP "
            "and NADPH from the light reactions remain available.\n\n"
            "**A.** Describe the role of RuBisCO and CO2 in the first step of the Calvin cycle "
            "(carbon fixation).\n\n"
            "**B.** Predict the effect of falling CO2 concentration on the rate of carbon fixation, "
            "and justify your prediction in terms of RuBisCO's substrate."
        ),
        "criteria": [
            {"id": "C1", "text": "Describes that RuBisCO catalyzes the attachment (fixation) of CO2 to RuBP (ribulose bisphosphate), producing two molecules of 3-PGA (a 3-carbon compound).", "notes": "Naming RuBP and 3-PGA specifically is preferred; general 'CO2 attaches to a 5-carbon molecule to form a 3-carbon product' is acceptable."},
            {"id": "C2", "text": "Identifies CO2 as the substrate whose availability directly limits the rate of the RuBisCO-catalyzed reaction when CO2 is scarce.", "notes": "Must specifically identify CO2 (not light, water, or temperature) as the limiting substrate for this step."},
            {"id": "C3", "text": "Predicts that the rate of carbon fixation will decrease as CO2 concentration falls.", "notes": "Direction must be explicit and tied to the falling-CO2 scenario, not a generic 'photosynthesis slows' statement."},
            {"id": "C4", "text": "Justifies the prediction by explaining that with ATP and NADPH held constant/unlimited, CO2 becomes the limiting reagent/substrate for RuBisCO, so as its concentration falls, RuBisCO has less substrate to bind and the reaction rate (and thus carbon fixation rate) slows even though light-reaction products are still abundant.", "notes": "Must explicitly rule out ATP/NADPH as the limiting factor in this scenario, connecting back to the prompt's statement that they remain available."},
        ],
        "responses": [
            {
                "id": "R1",
                "text": (
                    "(A) RuBisCO catalyzes the attachment of a CO2 molecule to RuBP, a 5-carbon molecule, forming "
                    "an unstable 6-carbon intermediate that immediately splits into two molecules of the 3-carbon "
                    "compound 3-PGA. This is the carbon-fixation step of the Calvin cycle.\n\n"
                    "(B) Prediction: the rate of carbon fixation will decrease as CO2 concentration falls. "
                    "Justification: because ATP and NADPH remain unlimited in this scenario, they are not the "
                    "limiting factor here -- CO2 itself is RuBisCO's substrate for this reaction, so as CO2 "
                    "becomes scarce, RuBisCO has fewer CO2 molecules available to bind to RuBP, directly slowing "
                    "the rate at which 3-PGA (and therefore the rest of the Calvin cycle) is produced."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit response with correct mechanism, correct identification of CO2 as the limiting substrate, and explicit ruling-out of ATP/NADPH limitation as given in the prompt.",
                "boundary_tags": [],
            },
            {
                "id": "R2",
                "text": (
                    "(A) RuBisCO uses ATP to attach CO2 to a 3-carbon molecule, making RuBP.\n\n"
                    "(B) Prediction: carbon fixation rate stays the same, because the light reactions are still "
                    "providing plenty of ATP and NADPH, and those are what the Calvin cycle really depends on."
                ),
                "labels": {"C1": "not_earned", "C2": "not_earned", "C3": "not_earned", "C4": "not_earned"},
                "reviewer_note": "Reverses the carbon-fixation reaction (RuBP is the starting substrate that CO2 attaches to, not the product) and incorrectly claims ATP is used directly in the fixation step itself. Then predicts no change and justifies it purely via ATP/NADPH availability, ignoring that CO2 -- not ATP/NADPH -- is the substrate that has actually become scarce. Flags: invented biology (reaction reversed), missed limiting-reagent identification.",
                "boundary_tags": ["invented_biology", "missed_limiting_reagent"],
            },
            {
                "id": "R3",
                "text": (
                    "(A) RuBisCO fixes CO2 onto RuBP, producing 3-PGA.\n\n"
                    "(B) Prediction: carbon fixation will decrease because there's less CO2. Justification: "
                    "CO2 is needed for the Calvin cycle."
                ),
                "labels": {"C1": "earned", "C2": "not_earned", "C3": "earned", "C4": "not_earned"},
                "reviewer_note": "Part A is correct and concise. Prediction direction is correct, but the justification never explains RuBisCO's substrate role specifically or rules out ATP/NADPH as a possible limiting factor -- 'CO2 is needed for the Calvin cycle' is a restatement of the premise, not an explanation of why scarcity of that specific substrate slows the RuBisCO reaction. Flags: over-credit risk, justification restates prompt.",
                "boundary_tags": ["over_credit_risk", "justification_restates_prompt"],
            },
            {
                "id": "R4",
                "text": (
                    "(A) In the first step of the Calvin cycle, RuBisCO catalyzes fixation of CO2 onto the "
                    "5-carbon RuBP, producing two 3-carbon 3-PGA molecules.\n\n"
                    "(B) Prediction: carbon fixation rate will fall as CO2 falls. Justification: since ATP and "
                    "NADPH supply is unlimited in this scenario, they cannot be the bottleneck; instead, CO2, "
                    "which is RuBisCO's substrate in this reaction, becomes scarce, so RuBisCO has fewer "
                    "molecules to bind per unit time, directly reducing the rate 3-PGA is produced."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Second full-credit response, near-paraphrase of R1; useful as a duplicate-quality check that the grader scores both identically.",
                "boundary_tags": [],
            },
            {
                "id": "R5",
                "text": (
                    "(A) RuBisCO combines carbon dioxide with a starting molecule to make a product used later "
                    "in the cycle.\n\n"
                    "(B) Prediction: carbon fixation rate will increase, because when CO2 gets low the plant "
                    "will open its stomata wider to bring in more CO2, balancing things out."
                ),
                "labels": {"C1": "unable_to_determine", "C2": "not_earned", "C3": "not_earned", "C4": "not_earned"},
                "reviewer_note": "Part A is vague enough ('a starting molecule,' 'a product used later') that it does not clearly demonstrate knowledge of RuBP/3-PGA identity or the 5-carbon-to-3-carbon transition -- flagged unable_to_determine rather than assumed earned, pending a rubric-drift decision on how much specificity 'first step' language requires. Part B invents an unsupported stomatal-response mechanism not established by the sealed-chamber scenario and predicts the wrong direction outright. Flags: invented biology, unsupported inference, rubric ambiguity on vague description credit.",
                "boundary_tags": ["invented_biology", "unsupported_inference", "rubric_ambiguity"],
            },
        ],
    },
    {
        "id": "biology_frq_10",
        "title": "Prezygotic vs. Postzygotic Reproductive Isolation in Two Cricket Populations",
        "unit": "Unit 8 - Ecology / Evolution (Speciation)",
        "difficulty": "Medium",
        "content_type": "boundary-sensitive",
        "stem": (
            "Two populations of crickets, once part of a single species, have been geographically "
            "separated for many generations. Population A now produces a mating call at a "
            "different pitch than Population B, and A and B rarely attempt to mate with each "
            "other. In laboratory crosses where mating is forced to occur, most resulting hybrid "
            "offspring are produced, but these hybrids are sterile as adults.\n\n"
            "**A.** Identify the reproductive barrier responsible for A and B rarely mating in the "
            "wild, and explain whether it is classified as prezygotic or postzygotic.\n\n"
            "**B.** Identify the reproductive barrier responsible for hybrid sterility, explain "
            "whether it is classified as prezygotic or postzygotic, and explain why both barriers "
            "being present would make these populations more likely to be classified as separate "
            "species."
        ),
        "criteria": [
            {"id": "C1", "text": "Identifies the mating-call/pitch difference as a behavioral isolation barrier and correctly classifies it as prezygotic (it prevents mating/fertilization from occurring at all).", "notes": "Must use 'prezygotic' correctly -- occurs before a zygote can form."},
            {"id": "C2", "text": "Justifies the prezygotic classification by explaining that behavioral isolation prevents mating attempts/fertilization in the first place, before any zygote is formed.", "notes": "Should not simply assert 'prezygotic' without the before-fertilization reasoning."},
            {"id": "C3", "text": "Identifies hybrid sterility as a postzygotic barrier and correctly classifies it as postzygotic (a zygote/hybrid offspring does form, but it cannot itself reproduce).", "notes": "Must use 'postzygotic' correctly -- occurs after a zygote/hybrid has already formed."},
            {"id": "C4", "text": "Explains that the presence of both a prezygotic barrier (limiting gene flow before mating) and a postzygotic barrier (limiting gene flow through infertile hybrids, even on the rare occasions mating does occur) means gene flow between the populations is restricted at multiple points, supporting classification as separate species under the biological species concept.", "notes": "Must connect both barriers to restricted gene flow and tie that to the species-concept reasoning, not just restate that both barriers exist."},
        ],
        "responses": [
            {
                "id": "R1",
                "text": (
                    "(A) The barrier is behavioral isolation -- the mating call pitch difference means members "
                    "of A and B do not recognize each other as potential mates. This is a prezygotic barrier "
                    "because it prevents mating (and therefore fertilization/zygote formation) from occurring at "
                    "all between the two populations.\n\n"
                    "(B) The barrier responsible for hybrid sterility is a postzygotic barrier, since a hybrid "
                    "zygote does form and develop into an offspring, but that offspring is unable to reproduce. "
                    "Having both barriers present means gene flow is restricted at two separate points: the "
                    "behavioral barrier prevents most matings from happening in the first place, and even on the "
                    "rare occasions when mating does occur, the postzygotic sterility barrier prevents any genes "
                    "from passing to a further generation. Because gene flow between the populations is blocked "
                    "both before and after mating, the populations are reproductively isolated overall, supporting "
                    "their classification as separate species."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Full-credit response with correct barrier identification and classification for both parts, and a complete explanation connecting both barriers to restricted gene flow and species classification.",
                "boundary_tags": [],
            },
            {
                "id": "R2",
                "text": (
                    "(A) The barrier is hybrid sterility, and it's postzygotic because it happens before "
                    "mating.\n\n"
                    "(B) The barrier is behavioral isolation, which is prezygotic because it happens after "
                    "fertilization. Both barriers being present means the populations are the same species "
                    "since they can still produce some offspring."
                ),
                "labels": {"C1": "not_earned", "C2": "not_earned", "C3": "not_earned", "C4": "not_earned"},
                "reviewer_note": "Swaps which barrier answers which part of the question (behavioral isolation explains the mating-avoidance in the wild, not hybrid sterility; hybrid sterility explains the offspring being infertile, not the mating avoidance). Also inverts the definitions of prezygotic/postzygotic in both directions. The conclusion in (B) is the opposite of the expected reasoning -- some offspring being produced does not override reproductive isolation caused by their sterility. Flags: barrier/part mismatch, prezygotic/postzygotic definitions reversed, invented biology in conclusion.",
                "boundary_tags": ["invented_biology", "definition_reversal_error"],
            },
            {
                "id": "R3",
                "text": (
                    "(A) Behavioral isolation, prezygotic.\n\n"
                    "(B) Hybrid sterility, postzygotic. Both barriers together make it more likely they're "
                    "separate species."
                ),
                "labels": {"C1": "earned", "C2": "not_earned", "C3": "earned", "C4": "not_earned"},
                "reviewer_note": "Correct identifications and classifications for both barriers, but neither is justified (no explanation of why the call difference is prezygotic or why sterility is postzygotic), and the species-classification conclusion in (B) is asserted without explaining the gene-flow-restriction reasoning connecting the two barriers. Flags: over-credit risk if grader scores bare correct labels as sufficient -- illustrates the ID-vs-justification split this rubric is built to catch.",
                "boundary_tags": ["over_credit_risk", "justification_restates_prompt"],
            },
            {
                "id": "R4",
                "text": (
                    "(A) The mating call difference causes behavioral isolation, a prezygotic barrier, because "
                    "it stops fertilization from happening in the first place -- the crickets never mate, so no "
                    "zygote ever forms.\n\n"
                    "(B) Hybrid sterility is a postzygotic barrier, because a zygote does form and develop into "
                    "a living hybrid, but that hybrid cannot pass on its genes since it's sterile. Since gene flow "
                    "is blocked both before fertilization (behavioral isolation) and after a hybrid forms (sterility), "
                    "the two populations are effectively unable to exchange genes at all, which supports treating "
                    "them as separate species under the biological species concept."
                ),
                "labels": {"C1": "earned", "C2": "earned", "C3": "earned", "C4": "earned"},
                "reviewer_note": "Second full-credit response, slightly more detailed than R1 on the gene-flow reasoning; useful for confirming grader consistency.",
                "boundary_tags": [],
            },
            {
                "id": "R5",
                "text": (
                    "(A) Behavioral isolation is the barrier. It's postzygotic because the crickets are already "
                    "separate species by the time they'd try to mate.\n\n"
                    "(B) Hybrid sterility is postzygotic, since the offspring can't reproduce. Since both are "
                    "postzygotic, gene flow is blocked after zygotes form, so they're separate species."
                ),
                "labels": {"C1": "not_earned", "C2": "not_earned", "C3": "earned", "C4": "not_earned"},
                "reviewer_note": "Correctly identifies behavioral isolation as the barrier in (A) but misclassifies it as postzygotic with circular reasoning ('already separate species' assumes the conclusion the question is trying to establish). (B)'s barrier ID and classification are correct, but the response then incorrectly claims *both* barriers are postzygotic, missing that behavioral isolation is prezygotic -- this understates how gene flow is restricted at two different points rather than one. Flags: definition/classification error, circular reasoning, invented biology in the final synthesis.",
                "boundary_tags": ["definition_reversal_error", "invented_biology"],
            },
        ],
    },
]
