-- MCQ remediation batch, 2026-08-11.
--
-- Context: docs/Q&A/REVIEWER_QA_SWEEP_2026_08_11.md, owner-directed "Run the 16 item
-- remediation" + "Assess APBIO-MCQ-094 to determine if it can be remediated or should
-- be retired." Covers the 9 AP Biology + 3 AP Physics MCQs from the 08-10/08-11 sweeps'
-- published-but-modification_reserved list, plus APBIO-MCQ-094 (disapproved, never
-- published -- assessed here and repaired, not retired; see per-item note below).
--
-- Every fix is independently re-derived per protocol §9.2 (docs/research/
-- CONTENT_AUTHORING_AND_QA_PROTOCOL.md), not a literal transcription of the reviewer's
-- note -- several fixes go beyond or narrow what the note said, with reasoning inline.
-- Insertion discipline follows §9.4: new content_item_versions row per item, never an
-- in-place edit; owner_remediation_approval assignment+decision; publish only after
-- structural QA gates pass.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-mcq-batch-repair-20260811'));

create temporary table repair_targets (
  content_key text primary key,
  find_status text not null
) on commit drop;

insert into repair_targets values
('APBIO-MCQ-025','published'),
('APBIO-MCQ-030','published'),
('APBIO-MCQ-033','published'),
('APBIO-MCQ-046','published'),
('APBIO-MCQ-063','published'),
('APBIO-MCQ-067','published'),
('APBIO-MCQ-069','published'),
('APBIO-MCQ-074','published'),
('APBIO-MCQ-079','published'),
('apphy2-mcq-003','published'),
('apphy2-mcq-006','published'),
('apphycm-mcq-012','published'),
('APBIO-MCQ-094','assigned');

create temporary table repaired (
  content_key text primary key,
  old_version_id uuid not null,
  new_version_id uuid not null
) on commit drop;

do $$
declare
  t record;
  v_item app.content_items%rowtype;
  v_old app.content_item_versions%rowtype;
  v_new uuid;
begin
  for t in select * from repair_targets order by content_key loop
    select * into strict v_item
    from app.content_items
    where content_key=t.content_key and item_type='mcq'
    for update;

    select * into strict v_old
    from app.content_item_versions
    where content_item_id=v_item.id and status=t.find_status
    order by version_num desc
    limit 1
    for update;

    v_new := gen_random_uuid();

    update app.content_review_assignments
    set status='skipped'
    where content_item_version_id=v_old.id
      and assignment_purpose='subject_review'
      and status in ('pending','in_progress');

    update app.content_item_versions
    set status='retired', updated_at=now()
    where id=v_old.id;

    update app.content_items
    set status='draft', updated_at=now()
    where id=v_item.id;

    insert into app.content_item_versions (
      id,content_item_id,version_num,stem,stimulus,prompt_json,
      explanation,help_text,content_hash,status,created_by,
      canonical_answer_1,canonical_answer_2,review_status,
      rubric_type,evaluator_strategy,stimulus_image_path
    ) values (
      v_new,v_item.id,v_old.version_num+1,v_old.stem,v_old.stimulus,
      coalesce(v_old.prompt_json,'{}'::jsonb) || jsonb_build_object(
        'content_version',v_old.version_num+1,
        'qa_remediation','2026-08-11 MCQ batch repair (docs/Q&A/REVIEWER_QA_SWEEP_2026_08_11.md)',
        'qa_source_version_id',v_old.id
      ),
      v_old.explanation,v_old.help_text,v_old.content_hash,
      'draft','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
      v_old.canonical_answer_1,v_old.canonical_answer_2,null,
      v_old.rubric_type,v_old.evaluator_strategy,v_old.stimulus_image_path
    );

    insert into app.mcq_choices (
      content_item_version_id,choice_key,choice_text,is_correct,rationale
    )
    select v_new,choice_key,choice_text,is_correct,rationale
    from app.mcq_choices
    where content_item_version_id=v_old.id;

    insert into repaired values (t.content_key,v_old.id,v_new);
  end loop;
end $$;

-- ---------------------------------------------------------------------------
-- Per-item repairs.
-- ---------------------------------------------------------------------------

-- APBIO-MCQ-025: shorten the correct-answer chain; delete the off-CED ENaC/aldosterone
-- reference from D's rationale (per Adil Abbasi, 08-09). The full reframe-around-Unit-2
-- suggestion in the note is optional/aspirational, not the required minimum fix, and is
-- not applied here.
update app.mcq_choices m
set choice_text='ADH → AQP2 inserts into the apical membrane → increased water permeability of the collecting duct → water moves osmotically from the tubule into the hyperosmotic kidney medulla → urine becomes concentrated → body water is conserved',
    rationale='The kidney medulla is hyperosmotic relative to tubular urine. AQP2 insertion into the apical membrane lets water move down its osmotic gradient from the tubule into the medulla and ultimately into blood. Without AQP2 insertion, water stays in the tubule and is excreted as dilute urine, as seen in the mutant mice.'
from repaired r where r.content_key='APBIO-MCQ-025' and m.content_item_version_id=r.new_version_id and m.choice_key='A';
update app.mcq_choices m
set rationale='AQP2 is a water channel; it does not block sodium channels. Na⁺ transport in the collecting duct is a separate regulatory pathway not tested by this item.'
from repaired r where r.content_key='APBIO-MCQ-025' and m.content_item_version_id=r.new_version_id and m.choice_key='D';

-- APBIO-MCQ-030: A and D are non-functional distractors (per Adil Abbasi, 08-09).
-- Independently re-derived replacements: A now targets the same efficiency axis as the
-- original (energy cost), reframed around necrosis instead of a nonsensical ATP-donation
-- claim. D now targets the Bax/Bak evidence directly, testing whether students correctly
-- read the knockout result (Bax/Bak are intrinsic-pathway genes; their loss blocks
-- apoptosis, showing the intrinsic pathway is required -- not that the extrinsic pathway
-- alone is sufficient, which is the reverse of what the knockout shows).
update app.mcq_choices m
set choice_text='Necrosis would clear the interdigital cells more efficiently than apoptosis because it does not require ATP-dependent caspase activation',
    rationale='Necrosis may avoid the energy cost of caspase activation, but efficiency is not why apoptosis is required here: necrosis triggers inflammation that would damage the neighboring digit tissue, which is the actual reason the controlled, non-inflammatory apoptotic pathway is needed for precise sculpting.'
from repaired r where r.content_key='APBIO-MCQ-030' and m.content_item_version_id=r.new_version_id and m.choice_key='A';
update app.mcq_choices m
set choice_text='The Bax/Bak knockout result shows that the extrinsic (death-receptor) pathway alone is sufficient to trigger interdigital apoptosis, since Bax and Bak are intrinsic-pathway genes',
    rationale='This reverses the knockout result. Bax and Bak are intrinsic-pathway genes; losing them blocks apoptosis and causes webbing, showing the intrinsic pathway is required for interdigital clearance -- not that the extrinsic pathway alone is sufficient without it.'
from repaired r where r.content_key='APBIO-MCQ-030' and m.content_item_version_id=r.new_version_id and m.choice_key='D';

-- APBIO-MCQ-033: reduce named-molecule density in the stimulus (PLC and PIP2
-- genericized; IP3/DAG/PKC retained as load-bearing to the item's own logic and cannot
-- be removed without gutting the question). D replaced with the reviewer's suggested
-- plausible error. B shortened to state the conclusion without restating the full
-- mechanism a second time (per Adil Abbasi, 08-09).
update app.content_item_versions civ
set stimulus='Activation of a cell-surface receptor triggers cleavage of a plasma-membrane phospholipid into two second messengers: IP₃ and DAG. IP₃ diffuses to the ER membrane and opens ligand-gated Ca²⁺ channels, releasing stored Ca²⁺ into the cytoplasm. DAG remains anchored in the plasma membrane. Protein kinase C (PKC) is activated by the simultaneous presence of both DAG at the membrane and elevated cytoplasmic Ca²⁺. When both co-activators are present, PKC activity is maximal; DAG or Ca²⁺ alone provides only weak partial activation.'
from repaired r where r.content_key='APBIO-MCQ-033' and civ.id=r.new_version_id;
update app.mcq_choices m
set choice_text='PKC activity is substantially reduced, though not eliminated, because losing IP₃-receptor-gated Ca²⁺ release removes one of PKC''s two required co-activators, while DAG generation is unaffected',
    rationale='Blocking the IP₃ receptor removes Ca²⁺ as a co-activator but does not affect DAG generation or membrane localization. Per the stimulus, DAG alone provides only weak partial activation, so PKC activity drops substantially without reaching zero.'
from repaired r where r.content_key='APBIO-MCQ-033' and m.content_item_version_id=r.new_version_id and m.choice_key='B';
update app.mcq_choices m
set choice_text='PKC activity is unchanged because Ca²⁺ enters from outside the cell instead',
    rationale='The stimulus describes cytoplasmic Ca²⁺ elevation as coming specifically from IP₃-receptor-gated ER release; blocking that receptor removes the described source. Nothing in the stimulus establishes an alternative plasma-membrane Ca²⁺-entry pathway in this system, so this choice introduces a claim the stimulus does not support.'
from repaired r where r.content_key='APBIO-MCQ-033' and m.content_item_version_id=r.new_version_id and m.choice_key='D';

-- APBIO-MCQ-046: replace the outlandish B distractor, shorten A to match the other
-- choices' length, and soften the stimulus's near-giveaway phrasing (per Adil Abbasi,
-- 08-09).
update app.content_item_versions civ
set stimulus='Thyroid hormone (T3) homeostasis depends on a negative feedback loop: low T3 → hypothalamus releases TRH → pituitary releases TSH → thyroid gland produces T3 → elevated T3 feeds back to suppress both TRH and TSH release. A patient is found to have a TSH-secreting pituitary adenoma (benign tumor) that secretes TSH autonomously. The patient''s serum T3 is 4× the normal upper limit.'
from repaired r where r.content_key='APBIO-MCQ-046' and civ.id=r.new_version_id;
update app.mcq_choices m
set choice_text='The pituitary adenoma secretes TSH independently of T3 feedback, so continuous TSH stimulation keeps driving the thyroid to overproduce T3 despite already-elevated levels',
    rationale='In normal physiology, elevated T3 suppresses TSH release, closing the feedback loop. The adenoma bypasses this by producing TSH regardless of T3 concentration, so the thyroid keeps receiving stimulatory signals and maintains excess T3 production -- a feedback loop disrupted by autonomous hormone secretion.'
from repaired r where r.content_key='APBIO-MCQ-046' and m.content_item_version_id=r.new_version_id and m.choice_key='A';
update app.mcq_choices m
set choice_text='The thyroid has become less sensitive to TSH, so more TSH is required to maintain a normal T3 level',
    rationale='Reduced thyroid sensitivity to TSH is a real endocrine mechanism, but it would explain elevated TSH driving T3 back to normal -- not a tumor that secretes TSH autonomously and drives T3 to 4x the normal upper limit. It does not fit this stimulus''s specific finding.'
from repaired r where r.content_key='APBIO-MCQ-046' and m.content_item_version_id=r.new_version_id and m.choice_key='B';

-- APBIO-MCQ-063: streamline choice B's text and rationale to the concepts the CED
-- actually requires (cap protects from degradation, enables export, is required for
-- translation), removing named factors (CBC, eIF4E, 43S pre-initiation complex) that
-- exceed AP Biology's scope. C's rationale loses the CBC acronym for the same reason
-- (per Sarah Sohail, 08-10).
update app.mcq_choices m
set choice_text='The 5'' cap protects the mRNA from degradation, is required for export from the nucleus, and is recognized by the translation machinery that assembles ribosomes on the mRNA; without a cap, the transcript is rapidly degraded and cannot be translated',
    rationale='The 5'' cap serves several essential functions: it protects the mRNA''s 5'' end from degradation, it is recognized by proteins that carry the mRNA out of the nucleus, and it is recognized by initiation factors that recruit the ribosome to begin translation. Blocking capping disrupts mRNA stability, localization, and translation initiation together.'
from repaired r where r.content_key='APBIO-MCQ-063' and m.content_item_version_id=r.new_version_id and m.choice_key='B';
update app.mcq_choices m
set rationale='The cap does influence splicing of the first intron through interactions between cap-binding proteins and the spliceosome, but this is not the primary consequence of blocking capping. The dominant effects are mRNA degradation and failure of translation initiation, both more directly and universally disruptive than incomplete splicing of one intron.'
from repaired r where r.content_key='APBIO-MCQ-063' and m.content_item_version_id=r.new_version_id and m.choice_key='C';

-- APBIO-MCQ-067: option B's rationale is rewritten to state only what each individual
-- experiment directly supports -- removing the inference that experiment 2 alone shows
-- "sufficient to confer liver-specific expression" (specificity requires experiment 3
-- too) and replacing the absolute "present in liver but not muscle" claim with what
-- experiment 4 actually shows (supplying the factors is sufficient to rescue activity),
-- per Sarah Sohail, 08-10.
update app.mcq_choices m
set choice_text='The enhancer is necessary for Gene X transcription in liver cells, drives strong expression when linked to a reporter gene in liver cells, and requires liver-specific transcription factors -- supplying those factors to muscle cells restores the enhancer''s activity there',
    rationale='Each experiment supports a distinct, narrower conclusion: (1) deletion in liver cells drops expression to near zero -- the enhancer is necessary; (2) the enhancer drives strong reporter expression in liver cells -- it is transcriptionally active there; (3) the same construct is inactive in muscle cells -- its activity is cell-type-restricted; (4) adding liver-specific transcription factors to muscle cells restores activity -- the enhancer''s activity depends on those factors, and supplying them is sufficient to rescue it in a cell type where it was otherwise silent.'
from repaired r where r.content_key='APBIO-MCQ-067' and m.content_item_version_id=r.new_version_id and m.choice_key='B';

-- APBIO-MCQ-069: rewrite B to state the conceptual conclusion without the explicit
-- 2x3x2=12 multiplication (the stimulus's given group sizes still let a student derive
-- the number if they choose to), and strengthen C/D per the reviewer's own suggested
-- text (per Adil Abbasi, 08-09). The stimulus's three-group exon diagram remains
-- unadded -- no image-generation capability in this remediation pass; flagged as an
-- open follow-up, not silently dropped.
update app.mcq_choices m
set choice_text='Selecting one exon independently from each of the three alternative-exon groups creates many different possible exon combinations, so a single gene can encode multiple distinct protein isoforms',
    rationale='Because one exon is chosen independently from each of the three groups, many different exon combinations are possible from a single gene, each yielding a distinct mRNA and potentially a distinct protein. This is why the proteome can exceed the genome''s gene count.'
from repaired r where r.content_key='APBIO-MCQ-069' and m.content_item_version_id=r.new_version_id and m.choice_key='B';
update app.mcq_choices m
set choice_text='Each of the 12 possible isoforms requires its own separate promoter and its own copy of the gene',
    rationale='Alternative splicing produces multiple mRNAs from one pre-mRNA transcribed from a single promoter and a single gene copy. No duplication of promoters or gene copies is needed -- this confuses splicing-based diversity with gene duplication.'
from repaired r where r.content_key='APBIO-MCQ-069' and m.content_item_version_id=r.new_version_id and m.choice_key='C';
update app.mcq_choices m
set choice_text='The 12 isoforms differ only in which 5'' cap structure they carry, not in their amino acid sequence',
    rationale='Different exon combinations change the mRNA''s coding sequence, which changes the resulting protein''s amino acid sequence. The 5'' cap structure is chemically identical across all of a cell''s mRNAs regardless of which exons were included -- this gets the mechanism backwards.'
from repaired r where r.content_key='APBIO-MCQ-069' and m.content_item_version_id=r.new_version_id and m.choice_key='D';

-- APBIO-MCQ-074: remove the giveaway clause from the stimulus, rewrite C and D per the
-- reviewer's own suggested text (per Adil Abbasi, 08-09). The larger "raise the demand"
-- rebuild (target sequence + point-mutation prediction) is a new-authoring-scale change,
-- not applied here -- flagged as an open follow-up.
update app.content_item_versions civ
set stimulus='CRISPR-Cas9 uses a Cas9 protein that cuts DNA at a location specified by an attached guide RNA.'
from repaired r where r.content_key='APBIO-MCQ-074' and civ.id=r.new_version_id;
update app.mcq_choices m
set choice_text='Cas9 recognizes the guide RNA''s PAM sequence rather than the DNA''s',
    rationale='The PAM (protospacer adjacent motif) is a short sequence on the target DNA itself, immediately adjacent to the cut site, that Cas9 recognizes directly -- not a sequence carried by the guide RNA. This reverses which molecule the PAM belongs to.'
from repaired r where r.content_key='APBIO-MCQ-074' and m.content_item_version_id=r.new_version_id and m.choice_key='C';
update app.mcq_choices m
set choice_text='Changing the guide RNA changes which strand Cas9 cuts, not which gene',
    rationale='The guide RNA''s sequence determines which genomic location Cas9 targets through RNA-DNA base pairing, not which strand is cut. Changing the guide RNA redirects Cas9 to a different DNA sequence altogether, not merely to the opposite strand of the same site.'
from repaired r where r.content_key='APBIO-MCQ-074' and m.content_item_version_id=r.new_version_id and m.choice_key='D';

-- APBIO-MCQ-079: option B's rationale is trimmed to remove the sympatric-speciation
-- extrapolation the stimulus provides no basis for (per Sarah Sohail, 08-10).
update app.mcq_choices m
set rationale='Disruptive (diversifying) selection acts when both phenotypic extremes have higher fitness than the intermediate. Here: small beaks fit small seeds; large beaks fit large seeds; intermediate beaks are poor at both, giving them the lowest fitness. Differential survival and reproduction favors both extremes, generating and maintaining the observed bimodal distribution over time.'
from repaired r where r.content_key='APBIO-MCQ-079' and m.content_item_version_id=r.new_version_id and m.choice_key='B';

-- apphy2-mcq-003: repair the sentence-fragment stem and swap D for a real second-law
-- distractor (per Ahmed Ali, 08-11). Reflected in the mcq_choices row and the rendered
-- stem answer list both.
update app.content_item_versions civ
set stem='Which of the following best explains why energy is spontaneously transferred from a hot object to a cold object?

A. decreases total entropy
B. increases total entropy
C. violates energy conservation
D. decreases the entropy of the cold object'
from repaired r where r.content_key='apphy2-mcq-003' and civ.id=r.new_version_id;
update app.mcq_choices m
set choice_text='decreases the entropy of the cold object',
    rationale='Reverses the actual effect: heat flowing into the cold object increases its entropy (ΔS = Q/T_cold > 0), and this increase is what dominates the total-entropy change, not a decrease.'
from repaired r where r.content_key='apphy2-mcq-003' and m.content_item_version_id=r.new_version_id and m.choice_key='D';

-- apphy2-mcq-006: expand option A's rationale to state equal magnitude and opposite
-- direction explicitly, not just "cancel" (per Chisom Anuba, 08-10).
update app.mcq_choices m
set rationale='The two charges are equal in magnitude and equidistant from the midpoint, so the electric field each produces there has equal magnitude. Because both charges are positive, each field points away from its own charge, meaning the two fields point in opposite directions at the midpoint. Equal-magnitude, opposite-direction vectors sum to zero, giving a net field of zero.'
from repaired r where r.content_key='apphy2-mcq-006' and m.content_item_version_id=r.new_version_id and m.choice_key='A';

-- apphycm-mcq-012: replace the dimensionally-implausible C/D distractors with the
-- reviewer's suggested pair, and add the scope-limiting clause to the stem (per Ahmed
-- Ali, 08-11).
update app.content_item_versions civ
set stem='Torque from potential energy U(θ), for a system whose potential energy depends only on the angle θ, is

A. dU/dθ
B. -dU/dθ
C. -U/θ
D. +d²U/dθ²'
from repaired r where r.content_key='apphycm-mcq-012' and civ.id=r.new_version_id;
update app.mcq_choices m
set choice_text='-U/θ',
    rationale='Incorrect. Treats torque as the total potential energy divided by the angle (a ratio), rather than as the instantaneous rate of change of potential energy with angle (a derivative).'
from repaired r where r.content_key='apphycm-mcq-012' and m.content_item_version_id=r.new_version_id and m.choice_key='C';
update app.mcq_choices m
set choice_text='+d²U/dθ²',
    rationale='Incorrect. This is the second derivative of U with respect to θ (related to the curvature/stiffness of the potential, as appears in small-angle oscillation problems), not the first derivative that defines torque.'
from repaired r where r.content_key='apphycm-mcq-012' and m.content_item_version_id=r.new_version_id and m.choice_key='D';

-- APBIO-MCQ-094: assessed and REPAIRED, not retired. Grep-verified against
-- docs/product/AP_BIOLOGY_CED_FACT_PACK.md Unit 8 (lines 902-1008): "succession",
-- "climax", and "pioneer species" have zero hits anywhere in the fact pack -- Adil
-- Abbasi's 08-09 disapproval ("succession is not CED content") is confirmed correct, not
-- just a reviewer opinion. Retargeted per Adil's own suggested fix: keep the volcanic-
-- island stimulus, but reframe the tested content onto LO 8.6.A (diversity/resilience:
-- "less diverse ecosystems are less resilient to change") and LO 8.5.B (community
-- structure changing over time), both real CED content, instead of succession stages.
-- Stimulus rewritten to drop succession-specific vocabulary ("pioneer species") and
-- frame the narrative around changing species richness. Also fixes the flagged
-- 100-vs-25-word length-cue defect: rewritten choices are ~40-58 words each.
update app.content_item_versions civ
set stem='Based on the pattern of colonization described, which best explains why increasing species richness on the island over time is expected to make the resulting community more resilient to future disturbance?',
    stimulus='A volcanic eruption creates a new island of bare basalt with no soil. Over the following centuries, ecologists document how the community of organisms on the island changes. The first organisms to colonize the bare rock are cyanobacteria and lichens. As organic matter and soil accumulate, additional species -- mosses, ferns, small shrubs, and eventually a diverse mix of forest species -- establish themselves, and overall species richness on the island increases. The time scale spans decades to centuries.',
    canonical_answer_1='A',
    prompt_json=coalesce(prompt_json,'{}'::jsonb) || jsonb_build_object('subtopics',jsonb_build_array('8.5 Community Ecology','8.6 Biodiversity'))
from repaired r where r.content_key='APBIO-MCQ-094' and civ.id=r.new_version_id;

delete from app.mcq_choices m using repaired r where r.content_key='APBIO-MCQ-094' and m.content_item_version_id=r.new_version_id;
insert into app.mcq_choices (content_item_version_id,choice_key,choice_text,is_correct,rationale)
select r.new_version_id, v.choice_key, v.choice_text, v.is_correct, v.rationale
from repaired r
join (values
 ('A','As more species establish on the island, the community gains a wider range of ecological roles and more overlap in those roles between species, so the loss of any single species is less likely to collapse the whole community, matching the principle that less diverse ecosystems are less resilient to disturbance',true,
  'Correct. Greater species richness typically means more functional redundancy -- multiple species can fill similar ecological roles -- so losing any one species is less likely to eliminate a function from the community. This directly matches the CED principle that less diverse ecosystems are less resilient to change.'),
 ('B','Species richness has no effect on how the island community responds to future disturbance, since resilience depends only on the physical stability of the volcanic rock itself, not on which organisms are present',false,
  'Incorrect. Ecosystem resilience is a property of the living community''s structure, not just the substrate''s physical stability; species richness is a recognized driver of ecosystem resilience.'),
 ('C','Because each new species that arrives directly increases the total biomass of producers on the island, the ecosystem becomes more resilient simply by having more total organic matter available, regardless of how many species are present',false,
  'Incorrect. Resilience is not simply a function of total biomass -- a community with high biomass concentrated in very few species is more vulnerable to collapse if that species is lost, since redundancy across species, not just biomass, is what buffers against disturbance.'),
 ('D','The island becomes more resilient because later-arriving species outcompete and eliminate all earlier colonizers, leaving a single, well-adapted species that can withstand any future disturbance alone',false,
  'Incorrect. A single-species community has essentially no functional redundancy and would be highly vulnerable to any disturbance that specifically affects that one species -- the opposite of what makes a community resilient.')
) as v(choice_key,choice_text,is_correct,rationale) on true
where r.content_key='APBIO-MCQ-094';

-- ---------------------------------------------------------------------------
-- Recompute content_hash for every repaired version.
-- ---------------------------------------------------------------------------
update app.content_item_versions civ
set content_hash=md5(coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||
  coalesce((select string_agg(m.choice_key||':'||m.choice_text||':'||m.is_correct::text||':'||coalesce(m.rationale,''), E'\n' order by m.choice_key)
            from app.mcq_choices m where m.content_item_version_id=civ.id),''))
from repaired r where civ.id=r.new_version_id;

-- ---------------------------------------------------------------------------
-- Owner remediation approval + publish, gated on structural QA.
-- ---------------------------------------------------------------------------
insert into app.content_review_assignments (
  content_review_assignment_id, content_item_version_id, reviewer_id,
  review_stage, review_kind, status, assignment_purpose, created_by
)
select gen_random_uuid(),new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
       'tutor_question','mcq','pending','owner_remediation_approval','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from repaired;

insert into app.content_review_decisions (
  content_review_assignment_id,content_item_version_id,reviewer_id,
  review_stage,tutor_score,difficulty_label,diagnostic_flag,
  concern_codes,note,tutor_decision,decision_payload,
  decision_hash,created_by
)
select cra.content_review_assignment_id,r.new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
       'tutor_question',1,'Medium',false,array[]::text[],
       case r.content_key
         when 'APBIO-MCQ-094' then 'Owner-directed retire-or-repair assessment, 2026-08-11: succession/climax content confirmed absent from AP_BIOLOGY_CED_FACT_PACK.md Unit 8 by direct grep (no hits for succession/climax/pioneer species); repaired by retargeting to LO 8.6.A/8.5.B (biodiversity/resilience, community change over time) on the same volcanic-island stimulus, per protocol §9.2 independent re-derivation, not retired.'
         else 'Owner-directed MCQ batch repair, 2026-08-11 (docs/Q&A/REVIEWER_QA_SWEEP_2026_08_11.md follow-up). Fix independently re-derived per protocol §9.2, not a literal transcription of the flagging reviewer''s note -- ' || r.content_key
       end,
       'approve',
       jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','mcq_batch_repair_20260811','content_key',r.content_key,'qa_date','2026-08-11'),
       encode(extensions.digest(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','mcq_batch_repair_20260811','content_key',r.content_key,'qa_date','2026-08-11')::text,'sha256'),'hex'),
       'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from repaired r
join app.content_review_assignments cra on cra.content_item_version_id=r.new_version_id and cra.assignment_purpose='owner_remediation_approval' and cra.status='pending';

create temporary table qa_blocked as
select r.content_key,
  case
    when nullif(trim(civ.stem),'') is null then 'blank stem'
    when (select count(*) from app.mcq_choices m where m.content_item_version_id=civ.id)<>4 then 'choice count'
    when (select count(distinct lower(trim(m.choice_text))) from app.mcq_choices m where m.content_item_version_id=civ.id)<>4 then 'duplicate choice text'
    when (select count(*) from app.mcq_choices m where m.content_item_version_id=civ.id and m.is_correct)<>1 then 'correct key count'
    when exists (select 1 from app.mcq_choices m where m.content_item_version_id=civ.id and nullif(trim(coalesce(m.rationale,'')),'') is null) then 'blank rationale'
    when exists (select 1 from app.content_item_versions other where other.content_item_id=civ.content_item_id and other.id<>civ.id and other.status='published') then 'competing published version'
  end reason
from repaired r
join app.content_item_versions civ on civ.id=r.new_version_id;
delete from qa_blocked where reason is null;

create temporary table approve_set on commit drop as
select r.content_key, r.new_version_id
from repaired r
where not exists (select 1 from qa_blocked b where b.content_key=r.content_key);

update app.content_item_versions civ
set status='reviewed_approved',
    review_status='question_review_approved',
    approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
    approved_at=coalesce(civ.approved_at,now()),
    updated_at=now()
from approve_set p
where civ.id=p.new_version_id;

update app.content_items ci
set status='reviewed_approved', updated_at=now()
from approve_set p
join app.content_item_versions civ on civ.id=p.new_version_id
where ci.id=civ.content_item_id;

update app.content_item_versions civ
set status='published',
    published_at=coalesce(civ.published_at,now()),
    updated_at=now()
from approve_set p
where civ.id=p.new_version_id;

update app.content_items ci
set status='published', updated_at=now()
from approve_set p
join app.content_item_versions civ on civ.id=p.new_version_id
where ci.id=civ.content_item_id;

do $$
declare n integer;
begin
  select count(*) into n from repaired;
  if n<>13 then raise exception 'expected 13 repaired MCQs, got %', n; end if;

  select count(*) into n from qa_blocked;
  if n<>0 then raise exception 'MCQ repair blocked by structural QA gate: %',
    (select string_agg(content_key||':'||reason, ', ' order by content_key) from qa_blocked);
  end if;

  select count(*) into n from (
    select content_item_id from app.content_item_versions where status='published'
    group by content_item_id having count(*)>1
  ) d;
  if n<>0 then raise exception 'duplicate published versions after MCQ repair: %', n; end if;
end $$;

select 'repaired_mcq' metric, count(*)::text value from repaired
union all select 'published_mcq', count(*)::text from approve_set
union all select 'qa_blocked', count(*)::text from qa_blocked
union all select 'published_keys', string_agg(content_key, ', ' order by content_key) from approve_set;

commit;
