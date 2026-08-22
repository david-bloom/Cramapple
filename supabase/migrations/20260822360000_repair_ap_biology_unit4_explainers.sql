begin;

-- Repair AP Biology Unit 4 (Cell Communication and Cell Cycle) Learn More
-- explainers -- all 6 were template-generated debt (core_idea verbatim-
-- matching their brief's what_it_is, and mini_example_question / weak_answer
-- sharing boilerplate duplicated across ~150 other rows corpus-wide, per the
-- 2026-08-21 bulk audit; the exact weak_answer "I would name the biology term
-- and give a general statement." and the exact title-interpolation
-- mini_example_question template appear on many other AP Biology rows).
-- Confirmed via SQL before authoring: all 6 rows carried source_note
-- 'generated-from-brief:legacy; grandfathered-2026-08-21' with no "repaired"
-- marker, and a direct read of the current rows showed core_idea
-- byte-identical to the paired brief's what_it_is on every row, plus the
-- exact boilerplate weak_answer and mini_example_question template on every
-- row -- so all 6 are genuine debt; none were an outlier that already had
-- hand-authored content. Briefs for this unit are genuinely hand-authored
-- and correct; NOT touched here.
--
-- Grounded in docs/product/AP_BIOLOGY_CED_FACT_PACK.md Unit 4 section
-- (starting line 581): 4.1's three modes of cell communication (direct
-- contact; short-distance local/paracrine signaling to nearby cells; and
-- long-distance signaling, e.g. hormones traveling through the bloodstream)
-- applied to an endocrine-hormone-vs-local-regulator worked example; 4.2's
-- receptor-location and ligand-binding facts (ligand-binding domain
-- specificity; surface/cytoplasm/nuclear receptor types, illustrated by
-- GPCRs; cascades relaying/amplifying the signal via second messengers such
-- as cAMP) applied to a steroid-hormone-vs-peptide-hormone worked example
-- contrasting intracellular and surface receptor binding; 4.3's pathway-
-- disruption facts (signal transduction can change gene expression, alter
-- phenotype, or trigger apoptosis; changes to any pathway component or
-- interacting chemical can activate or inhibit downstream transduction)
-- applied to a constitutively-active-kinase mutation worked example; 4.4's
-- feedback-direction facts (negative feedback reduces the stimulus toward a
-- set point; positive feedback amplifies it until system change occurs)
-- applied to a blood-glucose-vs-labor-contraction contrast; 4.5's interphase
-- sub-phase facts (G1 organelle/cytosolic growth; S-phase DNA replication
-- into sister chromatids; G2 protein synthesis, ATP production, and
-- centrosome replication; checkpoints can hold the cycle; G0 as a
-- non-dividing state) applied to a DNA-content/centrosome/spindle worked
-- example distinguishing G2 from mitosis; and 4.6's checkpoint/regulation
-- facts (internal checkpoints regulate progression; cyclin-CDK interactions
-- control the cycle, without naming specific cyclin-CDK pairs per the
-- documented exclusion; disruptions can cause cancer or apoptosis) applied
-- to a checkpoint-failure worked example connecting unrepaired DNA damage to
-- cancer. All facts (the three signaling modes, receptor-location logic,
-- pathway-disruption consequences, feedback-direction logic, interphase
-- sub-phase ordering, and cyclin-CDK checkpoint regulation) were
-- independently verified during authoring against the fact pack; no biology
-- facts required correction.
--
-- Before-state not separately captured for this batch (no prior before-state
-- export file exists for AP Biology Unit 4); the pre-repair content is fully
-- recoverable from git history for this table's rows if a rollback is ever
-- needed.
--
-- Every new explainer is genuinely topic-specific: core_idea differs from
-- what_it_is on every row (expands it with a new grounded fact from the fact
-- pack rather than restating it). answer_move and common_point_loss are
-- preserved verbatim from the paired brief per protocol section 4 ("the same
-- topic-specific answer_move" / "the same or refined common_point_loss") --
-- the Unit 4 briefs already carry specific, correct, non-templated
-- point-earning language, so no refinement was needed. mini_example_question
-- / weak_answer / point_attaining_answer / practice_bridge are original
-- per-row text that was checked corpus-wide before this migration was
-- written and repeats nowhere else in the published corpus (zero collisions
-- found on any of the four fields against the full published corpus).

with explainer_updates (
  topic_code, core_idea, what_students_need_to_understand,
  how_this_becomes_points, answer_move, mini_example_question, weak_answer,
  point_attaining_answer, common_point_loss, practice_bridge
) as (
  values
  ('4.1',
   'Cell communication uses signals, receptors, and responses to coordinate activity across cells, and it happens through three main modes: direct contact between adjacent cells, short-distance local (paracrine) signaling to nearby cells, and long-distance signaling where a signal travels through the body to reach a distant target cell.',
   'It supports explanations of development, immune responses, homeostasis, and environmental response. Local regulators act on nearby cells over a short distance, while long-distance signals such as hormones can travel through the bloodstream to reach specific target cells elsewhere in the body.',
   'You earn points by connecting signal reception to a cellular response and explaining how specificity is achieved, and by correctly classifying a described signaling event as direct contact, short-distance/local, or long-distance based on how far the signal travels and how it reaches its target.',
   'Identify the signal, receptor, target cell, and response in order.',
   'A hormone secreted by an endocrine gland travels through the bloodstream to bind receptors on a distant target cell, while an injured cell releases a local regulator that only affects immediately neighboring cells. Explain the difference between these two signaling processes and why each covers the distance it does.',
   'Both are just cells sending signals to each other.',
   'The endocrine gland''s hormone is released into the bloodstream and travels throughout the body, so it can only affect cells that carry a matching receptor, no matter how far away they are -- this is long-distance signaling. The injured cell''s local regulator diffuses through the extracellular fluid but is broken down or diluted before it travels far, so it only reaches and affects cells in its immediate vicinity -- this is short-distance/local (paracrine) signaling. Both rely on receptor specificity to determine which cells respond, but the distance covered depends on how the signal is delivered.',
   'Saying a signal causes a response without explaining receptor specificity.',
   'Return to practice and, on every cell-communication item, name whether the signal is direct-contact, local/paracrine, or long-distance/endocrine and connect that to receptor specificity.'),
  ('4.2',
   'Signal transduction converts an external or internal signal into intracellular molecular changes through three stages -- reception, transduction, and response -- and it begins when a ligand binds a receptor with a highly specific binding domain, such as a G-protein-coupled receptor (GPCR) on the cell surface.',
   'It is the mechanism that turns communication into altered cell behavior. Receptors can sit on the cell surface, in the cytoplasm, or in the nucleus depending on whether the ligand can cross the plasma membrane, and many pathways relay the signal through a phosphorylation cascade or second messengers like cAMP.',
   'You earn points by explaining the sequence reception -> transduction -> response, and by correctly matching a ligand''s chemical properties to its receptor''s location -- hydrophobic ligands crossing the membrane to intracellular or nuclear receptors, hydrophilic ligands binding surface receptors like GPCRs.',
   'Use the three-stage chain and place each molecule or event in the correct stage.',
   'A steroid hormone diffuses through the plasma membrane and binds a receptor inside the cytoplasm, while a peptide hormone binds a G-protein-coupled receptor (GPCR) on the cell surface. Explain why these two signals require different receptor locations.',
   'The hormone activates a receptor that starts a response.',
   'The steroid hormone is lipid-soluble, so it diffuses directly across the phospholipid bilayer and binds a receptor inside the cytoplasm or nucleus, directly affecting gene expression. The peptide hormone is hydrophilic and cannot cross the membrane, so it instead binds a G-protein-coupled receptor on the cell surface; this binding triggers an intracellular cascade, often involving a second messenger like cAMP, that relays the signal into the cell without the hormone itself ever entering.',
   'Skipping from signal to response without describing intracellular transduction.',
   'Head back to practice and, on every signal-transduction item, state whether the ligand is hydrophobic (crosses the membrane) or hydrophilic (binds a surface receptor) before describing the cascade.'),
  ('4.3',
   'Signal transduction pathways often use cascades, phosphorylation, second messengers, and amplification, and changing any single component -- through mutation or a chemical that activates or inhibits it -- can alter every downstream step, ultimately changing gene expression, cell phenotype, or even triggering apoptosis.',
   'AP questions reward mechanistic explanations of how a small signal produces a larger or specific response. A pathway''s downstream response can include turning genes on or off, changing the cell''s phenotype, or initiating programmed cell death (apoptosis) depending on which genes or proteins the cascade ultimately affects.',
   'You earn points by tracing pathway order and explaining how changes to one component affect downstream response, including predicting what happens when a mutation locks a pathway component permanently on or off regardless of the original signal.',
   'Follow the pathway arrow by arrow and state whether each step activates, inhibits, or amplifies the next.',
   'A cell-signaling pathway normally activates a transcription factor that turns on genes for cell growth. A mutation locks one kinase in the pathway in its active form regardless of whether the initial signal is present. Predict and explain the effect on the cell''s downstream response.',
   'The mutation breaks the pathway so it doesn''t work anymore.',
   'Because the kinase is locked in its active form, it keeps phosphorylating and activating the next component in the cascade continuously, regardless of whether the original ligand has bound its receptor. This means the transcription factor at the end of the pathway is activated even without the normal upstream signal, so the growth genes are switched on constitutively -- the cell receives an uncontrolled ''grow'' signal independent of outside conditions, which can drive unregulated proliferation.',
   'Describing every component as simply on or off without linking upstream changes to downstream effects.',
   'Return to practice and, on every pathway-mutation item, trace the change through each downstream step instead of stopping at ''the pathway breaks.'''),
  ('4.4',
   'Feedback loops regulate biological systems by using outputs to influence earlier steps, and the direction of that influence defines the loop: negative feedback reduces a stimulus back toward a set point to maintain homeostasis, while positive feedback amplifies the original stimulus until a decisive endpoint, such as childbirth or blood clotting, is reached.',
   'Negative feedback supports homeostasis, while positive feedback amplifies a process toward an endpoint. Most regulatory systems in the body -- like temperature and blood glucose control -- rely on negative feedback, while positive feedback is reserved for processes that need to reach a specific conclusion quickly, like labor contractions or clot formation.',
   'You earn points by identifying the variable, stimulus, response, and whether the loop reduces or amplifies the original change, and by justifying that classification with the specific effect the response has on the original stimulus rather than just naming a loop type.',
   'Ask whether the response reverses the change or strengthens it, then name negative or positive feedback.',
   'Blood glucose rises after a meal, triggering insulin release that lowers glucose back toward baseline. Separately, during childbirth, uterine contractions stretch the cervix, triggering oxytocin release that increases contraction strength until birth occurs. Identify which is negative and which is positive feedback and justify each answer using the response''s effect on the original stimulus.',
   'Insulin is negative feedback and oxytocin is positive feedback.',
   'Rising blood glucose is the stimulus that triggers insulin release; insulin lowers blood glucose, which reduces the very stimulus that caused its release, driving the system back toward its set point -- this is negative feedback. Cervical stretching during labor is the stimulus that triggers oxytocin release; oxytocin increases contraction strength, which increases cervical stretching even further rather than reducing it, amplifying the process until birth occurs -- this is positive feedback because the response strengthens, not reverses, the original stimulus.',
   'Calling every control system negative feedback without explaining the direction of the response.',
   'Go back to practice and, on every feedback item, check whether the response reduces or amplifies the original stimulus before naming negative or positive feedback.'),
  ('4.5',
   'The cell cycle coordinates growth, DNA replication, and division through ordered phases, and interphase itself has three distinct sub-phases -- G1 (organelle and cytosolic growth), S (DNA replicates into sister chromatids), and G2 (further protein synthesis, ATP production, and centrosome replication) -- before the cell enters mitosis.',
   'It connects cellular reproduction to inheritance, development, and regulation. Cells that stop dividing can exit the cycle into a non-dividing G0 state, and checkpoints throughout the cycle can hold a cell in place until conditions are appropriate to proceed.',
   'You earn points by placing events in the correct phase and explaining why ordering matters for accurate division, including using specific evidence -- such as DNA content or centrosome/spindle status -- to justify which exact phase a cell is in rather than a broad label like ''interphase.''',
   'Name the phase and the key event: growth, DNA replication, chromosome separation, or cytokinesis.',
   'A cell is found to have doubled its centrosomes and DNA content, but the nuclear envelope is still intact and no spindle fibers have formed. Identify which cell cycle phase this cell is in and explain what evidence supports that identification.',
   'The cell is in mitosis because it''s getting ready to divide.',
   'The doubled DNA content shows that S phase has already completed, ruling out G1. The doubled centrosomes are consistent with G2, when centrosome replication occurs alongside additional protein synthesis and ATP production to prepare for division. Because the nuclear envelope is still intact and no spindle fibers have formed, the cell has not yet entered prophase of mitosis (where the envelope breaks down and the spindle assembles) -- so this cell is in G2 of interphase, not mitosis.',
   'Mixing up DNA replication with chromosome separation.',
   'Head to practice and, on every cell-cycle item, use DNA content and centrosome/spindle status together to pin down the exact phase, not just ''interphase'' or ''mitosis.'''),
  ('4.6',
   'Cell cycle checkpoints and regulatory proteins help prevent division when DNA or cell conditions are not ready, and this control relies on cyclin and cyclin-dependent kinase (CDK) interactions; when these checkpoints fail, a cell can keep dividing with damaged DNA, which can lead to cancer or, if the damage is severe enough, trigger apoptosis instead.',
   'This topic links signaling, mutation, cancer, and inheritance of cellular errors. Internal checkpoints monitor conditions like DNA integrity before allowing the cycle to proceed, and cyclin-CDK activity is the regulatory mechanism that enforces those checkpoints, without needing to name specific cyclin-CDK pairs.',
   'You earn points by explaining how checkpoint failure or regulatory disruption changes cell division outcomes, including describing the normal cyclin-CDK-based checkpoint function before explaining what happens when that control is bypassed.',
   'Identify the checkpoint or regulator, then state what error it normally prevents.',
   'A cell''s DNA is damaged during S phase, but a mutation prevents the checkpoint from halting the cycle, and the cell continues dividing with the damaged DNA. Explain the normal role of the checkpoint and the consequence of its failure in this cell.',
   'The checkpoint usually stops the cell cycle, but it''s broken so the cell divides too fast.',
   'Normally, a checkpoint uses cyclin-CDK activity to detect DNA damage during S phase and halt the cycle, giving the cell time to repair the damage or, if the damage is too severe, triggering apoptosis so the damaged DNA is never passed on. With the checkpoint mutation, this cyclin-CDK-based control is bypassed, so the cell replicates and divides despite the DNA damage, passing the mutations to daughter cells -- this kind of checkpoint failure, allowing continued division of cells with accumulating damage, is a key mechanism underlying cancer.',
   'Saying cells divide too fast without explaining the failed control mechanism.',
   'Return to practice and, on every checkpoint item, name the specific control (cyclin-CDK activity) and its normal outcome (repair, arrest, or apoptosis) before explaining what failure produces.')
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
  source_note = 'cramapple-authored; repaired 2026-08-22 replacing a template-generated explainer (previously generated-from-brief, grandfathered per the 2026-08-21 bulk audit) with topic-specific content grounded in AP_BIOLOGY_CED_FACT_PACK.md Unit 4 section (line 581): the three modes of cell communication (direct contact, short-distance local/paracrine, long-distance/endocrine) for 4.1, applied to an endocrine-hormone-vs-local-regulator worked example; the receptor-location and ligand-binding facts (surface/cytoplasm/nuclear receptors, GPCRs, second messengers such as cAMP) for 4.2, applied to a steroid-hormone-vs-peptide-hormone worked example; the pathway-disruption facts (gene expression change, phenotype alteration, apoptosis; any component change can alter downstream transduction) for 4.3, applied to a constitutively-active-kinase mutation worked example; the feedback-direction facts (negative feedback reduces the stimulus toward a set point, positive feedback amplifies it until system change occurs) for 4.4, applied to a blood-glucose-vs-labor-contraction contrast; the interphase sub-phase facts (G1/S/G2 events, checkpoints, G0) for 4.5, applied to a DNA-content/centrosome/spindle worked example distinguishing G2 from mitosis; and the checkpoint/cyclin-CDK regulation facts (disruptions can cause cancer or apoptosis) for 4.6, applied to a checkpoint-failure worked example connecting unrepaired DNA damage to cancer. All facts were independently verified against the fact pack during authoring; no biology facts required correction. Briefs for this unit are genuinely hand-authored and were NOT touched. batch 2026-08-22-ap-biology-unit4-explainer-repair; author=reviewer same session, no independent human review yet'
from explainer_updates u
where e.subject_key = 'ap_biology'
  and e.unit_number = 4
  and e.topic_code = u.topic_code;

do $$
declare
  v_repaired integer;
  v_core_matches integer;
begin
  select count(*) into v_repaired from app.topic_explainers
    where subject_key='ap_biology' and unit_number=4 and status='published'
      and source_note like '%unit4-explainer-repair%';
  if v_repaired <> 6 then
    raise exception 'expected 6 repaired AP Biology Unit 4 explainers, got %', v_repaired;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code
  where b.subject_key='ap_biology' and b.unit_number=4 and b.status='published'
    and e.status='published' and e.core_idea = b.what_it_is;
  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Biology Unit 4 explainers matching their brief verbatim, got %', v_core_matches;
  end if;
end $$;

commit;
