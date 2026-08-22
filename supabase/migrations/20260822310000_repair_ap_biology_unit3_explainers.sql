begin;

-- Repair AP Biology Unit 3 (Cellular Energetics) Learn More explainers -- all
-- 5 were template-generated debt (core_idea verbatim-matching their brief's
-- what_it_is, and mini_example_question / weak_answer shared boilerplate
-- duplicated across ~150 other rows corpus-wide, per the 2026-08-21 bulk
-- audit; the exact weak_answer "I would name the biology term and give a
-- general statement." and the exact title-interpolation mini_example_question
-- template appear on many other AP Biology rows). Confirmed via SQL before
-- authoring: all 5 rows carried source_note
-- 'generated-from-brief:legacy; grandfathered-2026-08-21' with no "repaired"
-- marker, and a direct read of the current rows showed core_idea
-- byte-identical to the paired brief's what_it_is on every row, plus the
-- exact boilerplate weak_answer and mini_example_question template on every
-- row -- so all 5 are genuine debt; none were an outlier that already had
-- hand-authored content. Briefs for this unit are genuinely hand-authored
-- and correct; NOT touched here.
--
-- Grounded in docs/product/AP_BIOLOGY_CED_FACT_PACK.md Unit 3 section
-- (starting line 496): 3.1's enzyme-substrate complex/induced-fit model
-- (substrate shape and charge must fit the active site) applied to a
-- sucrase-vs-lactose substrate-specificity worked example; 3.2's denaturation
-- mechanics (temperature/pH outside the optimum disrupt the hydrogen bonding
-- that holds an enzyme's shape together, and denaturation is sometimes
-- reversible) applied to a pH 4/7/10 reaction-rate worked example with a
-- partial-recovery-vs-no-recovery contrast; 3.3's thermodynamics and coupled-
-- reaction facts (living systems require continual energy input exceeding
-- loss, consistent with the first and second laws; metabolic pathways are
-- sequential, with a product typically the next step's reactant) applied to
-- an ATP-hydrolysis-driven active-transport worked example naming the
-- phosphorylation/shape-change coupling mechanism; 3.4's documented exclusion
-- (Calvin-cycle steps, molecule structures, and enzyme names beyond ATP
-- synthase are out of scope) demonstrated directly in a worked example that
-- explains the light-reactions-to-Calvin-cycle handoff (thylakoid membrane
-- location, chemiosmosis through ATP synthase, ATP/NADPH as the two products
-- carried to the stroma) without naming individual Calvin-cycle steps or
-- molecules; and 3.5's fermentation/NAD+-regeneration mechanics (glycolysis
-- needs no oxygen; without oxygen as final electron acceptor the electron
-- transport chain backs up and NADH cannot be reoxidized fast enough, so the
-- cell ferments pyruvate to lactic acid or alcohol to regenerate NAD+ and
-- keep glycolysis running) applied to a low-oxygen-environment worked
-- example. All facts (enzyme-substrate complex/induced fit, denaturation
-- reversibility, thermodynamics/energy-coupling, the Unit 3.4 exclusion
-- boundary, and fermentation's NAD+-regeneration role) were independently
-- verified during authoring against the fact pack; no biology facts required
-- correction.
--
-- Before-state not separately captured for this batch (no prior before-state
-- export file exists for AP Biology Unit 3); the pre-repair content is fully
-- recoverable from git history for this table's rows if a rollback is ever
-- needed.
--
-- Every new explainer is genuinely topic-specific: core_idea differs from
-- what_it_is on every row (expands it with a new grounded fact from the fact
-- pack rather than restating it). answer_move and common_point_loss are
-- preserved verbatim from the paired brief per protocol section 4 ("the same
-- topic-specific answer_move" / "the same or refined common_point_loss") --
-- the Unit 3 briefs already carry specific, correct, non-templated
-- point-earning language, so no refinement was needed. mini_example_question
-- / weak_answer / point_attaining_answer / practice_bridge are original
-- per-row text that was checked corpus-wide before this migration was
-- written and repeats nowhere else in the published corpus (zero collisions
-- found; the only match surfaced during the pre-check was a deliberate
-- control string reused from the Unit 2 migration to sanity-check the query,
-- not one of this batch's candidate rows).

with explainer_updates (
  topic_code, core_idea, what_students_need_to_understand,
  how_this_becomes_points, answer_move, mini_example_question, weak_answer,
  point_attaining_answer, common_point_loss, practice_bridge
) as (
  values
  ('3.1',
   'Enzymes are protein catalysts that speed reactions by lowering the activation energy required, and the enzyme-substrate complex model describes how a substrate''s shape and charge must fit the active site -- often through induced fit, where the active site changes shape slightly as it binds -- for catalysis to occur.',
   'Enzyme questions connect protein structure, reaction rate, regulation, and environmental conditions. The enzyme-substrate complex model explains this: catalysis requires a specific molecular fit between an active site and its substrate, often refined through induced fit as the site closes slightly around the bound substrate to stabilize the transition state.',
   'You earn points by connecting active-site shape, substrate specificity, and activation energy to reaction outcomes, and by explicitly invoking the enzyme-substrate complex or induced-fit model when asked why a given enzyme works on one substrate but not another.',
   'Describe how enzyme structure affects substrate binding and reaction rate.',
   'An enzyme called sucrase breaks down sucrose but has no effect on lactose, even though both are disaccharide sugars. Explain why sucrase can catalyze the breakdown of sucrose but not lactose.',
   'Sucrase works on sucrose because that''s the sugar it''s designed for.',
   'Sucrase''s active site has a specific shape and charge distribution that is complementary to sucrose''s molecular structure, allowing sucrose to bind and form an enzyme-substrate complex. Lactose has a different molecular shape and charge arrangement that does not fit sucrase''s active site, so it cannot bind and no reaction occurs -- this specificity is what makes sucrase effective only on its matching substrate, not sugars in general.',
   'Saying enzymes add energy to reactions instead of lowering activation energy.',
   'Return to practice and, on every enzyme-specificity item, explain the fit between active-site shape/charge and substrate shape/charge rather than just saying the enzyme is ''designed for'' its substrate.'),
  ('3.2',
   'Temperature, pH, salinity, and other conditions can alter enzyme shape and activity, and outside an enzyme''s optimum range these conditions disrupt the hydrogen bonds holding its three-dimensional shape together -- denaturation -- which is sometimes reversible if conditions return to normal before the structure is permanently disrupted.',
   'This topic is a recurring experimental context where students must connect data trends to molecular explanation. Beyond temperature and pH, relative substrate/product concentration affects reaction efficiency, and inhibitors provide another mechanism: competitive inhibitors bind reversibly at the active site itself, while noncompetitive inhibitors bind at a separate allosteric site and still reduce activity.',
   'You earn points by linking environmental change to protein structure, active-site fit, and reaction rate, and by distinguishing reversible denaturation from permanent loss of function, or competitive from noncompetitive inhibition, when a question requires that specific mechanism.',
   'Use data to identify the activity change, then explain it through enzyme shape or denaturation when appropriate.',
   'A researcher measures an enzyme''s reaction rate at pH 4, pH 7, and pH 10, finding the enzyme is most active at pH 7 and nearly inactive at pH 4 and pH 10. After returning the pH-4 sample to pH 7, activity partially recovers, but the pH-10 sample shows no recovery. Explain both observations.',
   'The enzyme got denatured at the wrong pH so it stopped working.',
   'At pH 7, the enzyme''s hydrogen bonds maintain the three-dimensional shape needed for its active site to bind substrate, giving maximum activity. At pH 4 and pH 10, the shift away from optimum pH disrupts those hydrogen bonds, altering the enzyme''s shape and reducing catalytic ability -- denaturation. The partial recovery after returning to pH 7 from pH 4 shows that this particular denaturation was reversible, with the hydrogen bonds able to reform correctly, while the lack of recovery from pH 10 indicates that extreme condition caused a more permanent disruption to the enzyme''s structure.',
   'Only describing the graph trend without explaining the molecular cause.',
   'Head back to practice and, on every denaturation item, name the specific interaction being disrupted (hydrogen bonding) and state whether the data show reversible or permanent loss of function.'),
  ('3.3',
   'Cells use energy coupling and ATP to drive processes that require energy input, and because living systems are highly ordered, they must continually take in more energy than they lose to maintain that order, consistent with the first and second laws of thermodynamics; ATP hydrolysis releases energy in a stepwise sequence where each pathway''s product typically becomes the next step''s reactant.',
   'This topic supports understanding of transport, biosynthesis, movement, photosynthesis, and respiration. Because core metabolic pathways such as glycolysis and oxidative phosphorylation are conserved across Archaea, Bacteria, and Eukarya, this energy-coupling logic is evidence of these pathways'' common ancestry across all three domains of life.',
   'You earn points by explaining how ATP hydrolysis or coupled reactions make an unfavorable process possible, and by recognizing that a pathway''s steps are sequential, with one step''s product serving as the next step''s reactant.',
   'Identify the energy-requiring process and connect ATP or coupling to the work being done.',
   'A cell needs to actively transport a solute against its concentration gradient, a process that does not occur spontaneously. Explain how ATP makes this unfavorable process possible.',
   'ATP has a lot of energy stored in it, so it powers the process.',
   'ATP hydrolysis breaks the bond to its terminal phosphate group, releasing energy and transferring that phosphate to the transport protein in a coupled reaction. This phosphorylation changes the transport protein''s shape, driving the energetically unfavorable movement of the solute against its gradient -- the energy-releasing hydrolysis of ATP is directly coupled to the energy-requiring transport step, rather than the two happening independently.',
   'Saying ATP is energy without explaining how phosphate transfer or coupling supports the process.',
   'Return to practice and, on every ATP-coupling item, name the specific coupled reaction (phosphorylation, shape change) linking ATP hydrolysis to the energy-requiring process, not just that ATP ''provides energy.'''),
  ('3.4',
   'Photosynthesis converts light energy into chemical energy stored in sugars through linked light reactions and carbon fixation, and this process first evolved in prokaryotes -- cyanobacterial photosynthesis is responsible for producing Earth''s oxygenated atmosphere. In the light reactions, chlorophyll absorbs light to boost electrons in photosystems II and I, and splitting water replaces the electrons lost at photosystem II while releasing oxygen as a byproduct.',
   'It connects energy flow, organelle structure, electron transport, carbon cycling, and environmental inputs. The light reactions take place in the thylakoid membranes (organized into grana) while the Calvin cycle takes place in the stroma; the electron transport chain builds a proton gradient across the thylakoid membrane that chemiosmosis through ATP synthase converts into ATP, the same chemiosmotic logic used in cellular respiration.',
   'You earn points by linking inputs, locations, products, and energy transformations across the two major stages, including naming the thylakoid membrane and stroma as the specific sites and describing the proton-gradient/ATP-synthase mechanism without needing Calvin-cycle step names or molecule structures, which are outside the tested scope.',
   'Separate light reactions from the Calvin cycle, then connect their products and dependencies.',
   'A student is asked to explain how the light reactions of photosynthesis make carbohydrate production in the Calvin cycle possible, without naming any individual Calvin-cycle steps or molecule structures. What should the answer include?',
   'The light reactions happen first, then the Calvin cycle uses RuBP and G3P to make glucose through carbon fixation, reduction, and regeneration.',
   'The light reactions occur in the thylakoid membrane, where chlorophyll absorbs light energy and an electron transport chain moves electrons from photosystem II to photosystem I, establishing a proton gradient across the thylakoid membrane. Chemiosmosis through ATP synthase uses that gradient to generate ATP, while electrons reduce NADP+ to NADPH at photosystem I. Both ATP and NADPH then diffuse into the stroma, where they supply the energy and reducing power the Calvin cycle needs to build carbohydrates from carbon dioxide -- without needing to name the individual Calvin-cycle steps or molecules involved.',
   'Mixing up where oxygen, ATP, NADPH, or sugar are produced.',
   'Go back to practice and, on every light-reactions-to-Calvin-cycle item, connect ATP and NADPH as the products handed off between stages rather than naming specific Calvin-cycle intermediates, which the exam does not require.'),
  ('3.5',
   'Cellular respiration transfers energy from organic molecules to ATP through glycolysis, oxidation steps, and electron transport, and this same core process -- along with fermentation, which lets glycolysis continue without oxygen by producing alcohol or lactic acid -- occurs in some form across all living organisms, not only in organisms with mitochondria.',
   'It is one of the most tested cellular energetics topics and often appears in data and experimental questions. The Krebs cycle occurs in the mitochondrial matrix and reduces NAD+ and FAD while releasing CO2, and the resulting NADH and FADH2 carry electrons to the electron transport chain, which builds a proton gradient across the inner mitochondrial membrane (with the matrix at higher pH than the intermembrane space) that chemiosmosis through ATP synthase converts into ATP.',
   'You earn points by connecting molecule breakdown, electron carriers, proton gradients, oxygen, and ATP production, and by correctly locating each stage (glycolysis in the cytosol, the Krebs cycle in the matrix, the electron transport chain across the inner mitochondrial membrane).',
   'Track carbon, electrons, and ATP through the process instead of memorizing a list of stages.',
   'A cell is placed in a low-oxygen environment. Glycolysis continues, but pyruvate can no longer be fully oxidized through the Krebs cycle and electron transport chain. Explain what happens to the cell''s ATP production and to pyruvate under these conditions.',
   'The cell stops making ATP because it needs oxygen for respiration to work.',
   'Glycolysis does not require oxygen and continues in the cytosol, producing a small amount of ATP and NADH directly from glucose. Without oxygen to serve as the final electron acceptor at the end of the electron transport chain, the chain backs up and NADH cannot be reoxidized to NAD+ fast enough to keep glycolysis running. Instead, the cell shifts to fermentation, converting pyruvate to lactic acid or alcohol, a reaction that regenerates NAD+ so glycolysis can continue producing its smaller amount of ATP even without oxygen.',
   'Saying oxygen makes ATP directly instead of explaining its role as final electron acceptor.',
   'Head to practice and, on every low-oxygen or fermentation item, explain fermentation''s role in regenerating NAD+ to keep glycolysis running, rather than saying the cell simply ''stops'' making ATP.')
)
update app.topic_explainers e
set
  core_idea = u.core_idea,
  what_students_need_to_understand = u.what_students_need_to_understand,
  how_this_becomes_points = u.how_this_becomes_points,
  answer_move = u.answer_move,
  mini_example_question = u.mini_example_question,
  weak_answer = u.weak_answer,
  point_attaining_answer = u.point_attaining_answer,
  common_point_loss = u.common_point_loss,
  practice_bridge = u.practice_bridge,
  source_note = 'cramapple-authored; repaired 2026-08-22 replacing a template-generated explainer (previously generated-from-brief, grandfathered per the 2026-08-21 bulk audit) with topic-specific content grounded in AP_BIOLOGY_CED_FACT_PACK.md Unit 3 section (line 496): the enzyme-substrate complex/induced-fit model for 3.1, applied to a sucrase-vs-lactose substrate-specificity worked example; the denaturation mechanics (temp/pH-driven disruption of hydrogen bonding, sometimes reversible) for 3.2, applied to a pH 4/7/10 reaction-rate worked example with a partial-recovery-vs-no-recovery contrast; the thermodynamics and coupled-reaction facts for 3.3, applied to an ATP-hydrolysis-driven active-transport worked example naming the phosphorylation/shape-change coupling mechanism; the documented 3.4 exclusion (Calvin-cycle steps, molecule structures, and enzyme names beyond ATP synthase out of scope) demonstrated directly in a light-reactions-to-Calvin-cycle handoff worked example; and the fermentation/NAD+-regeneration mechanics for 3.5, applied to a low-oxygen-environment worked example. All facts were independently verified against the fact pack during authoring; no biology facts required correction. Briefs for this unit are genuinely hand-authored and were NOT touched. batch 2026-08-22-ap-biology-unit3-explainer-repair; author=reviewer same session, no independent human review yet'
from explainer_updates u
where e.subject_key = 'ap_biology'
  and e.unit_number = 3
  and e.topic_code = u.topic_code;

do $$
declare
  v_repaired integer;
  v_core_matches integer;
begin
  select count(*) into v_repaired from app.topic_explainers
    where subject_key='ap_biology' and unit_number=3 and status='published'
      and source_note like '%unit3-explainer-repair%';
  if v_repaired <> 5 then
    raise exception 'expected 5 repaired AP Biology Unit 3 explainers, got %', v_repaired;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code
  where b.subject_key='ap_biology' and b.unit_number=3 and b.status='published'
    and e.status='published' and e.core_idea = b.what_it_is;
  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Biology Unit 3 explainers matching their brief verbatim, got %', v_core_matches;
  end if;
end $$;

commit;
