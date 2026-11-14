-- Structured explainer pieces (recommendation #3), batch 2026-11-13. Guarded on each row still holding the text it was built on.
begin;
update app.topic_explainers set
  core_idea = $q$- DNA and RNA are nucleic acids with nucleotide sequences.
- Both have sugar-phosphate backbones.
- Both follow base-pairing rules.$q$,
  what_students_need_to_understand = $q$Structure explains information storage, copying, transcription, and translation.$q$,
  how_this_becomes_points = $q$You earn points by connecting base sequence, complementarity, directionality, and DNA/RNA differences to biological function.$q$,
  point_attaining_answer = $q$1. Use structure-function language: base order stores information and base pairing enables accurate copying or expression.
2. Then make the scoring connection explicit: You earn points by connecting base sequence, complementarity, directionality, and DNA/RNA differences to biological function.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 6-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=6 and topic_code='6.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='948c5a2505aee7952e55157821ee0df3';
update app.topic_explainers set
  core_idea = $q$- DNA replication copies genetic information.
- It uses complementary base pairing.
- It uses enzyme-coordinated strand synthesis.$q$,
  what_students_need_to_understand = $q$It supports inheritance, cell division, mutation reasoning, and biotechnology.$q$,
  how_this_becomes_points = $q$You earn points by explaining template strands, complementary nucleotides, directionality, and enzyme roles in accurate copying.$q$,
  point_attaining_answer = $q$1. Describe how each original strand guides a new complementary strand.
2. Then make the scoring connection explicit: You earn points by explaining template strands, complementary nucleotides, directionality, and enzyme roles in accurate copying.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 6-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=6 and topic_code='6.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='20eec1c887b01cf719047a0aa4eaee20';
update app.topic_explainers set
  core_idea = $q$- Transcription produces RNA from a DNA template.
- RNA processing modifies eukaryotic transcripts before translation.$q$,
  what_students_need_to_understand = $q$This topic connects genetic information to gene expression and regulation.$q$,
  how_this_becomes_points = $q$You earn points by distinguishing template DNA, mRNA product, RNA polymerase, and processing steps such as splicing when relevant.$q$,
  point_attaining_answer = $q$1. Track information flow from DNA template to RNA sequence, then mention processing if the organism or prompt requires it.
2. Then make the scoring connection explicit: You earn points by distinguishing template DNA, mRNA product, RNA polymerase, and processing steps such as splicing when relevant.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 6-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=6 and topic_code='6.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='25e32746b3a46e88a2f4d319f0cd506c';
update app.topic_explainers set
  core_idea = $q$- Translation builds polypeptides.
- It uses ribosomes, mRNA codons, tRNA anticodons, and amino acids.$q$,
  what_students_need_to_understand = $q$It completes the flow from genetic information to protein structure and function.$q$,
  how_this_becomes_points = $q$You earn points by connecting codon sequence to amino acid sequence and explaining the roles of ribosome and tRNA.$q$,
  point_attaining_answer = $q$1. Read mRNA codons in order and connect each codon to an amino acid carried by tRNA.
2. Then make the scoring connection explicit: You earn points by connecting codon sequence to amino acid sequence and explaining the roles of ribosome and tRNA.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 6-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=6 and topic_code='6.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='b4933b947e188f986c39823a20599a91';
update app.topic_explainers set
  core_idea = $q$Cells regulate gene expression by controlling when and how much gene product is made.$q$,
  what_students_need_to_understand = $q$Regulation explains specialization, response to environment, development, and efficient resource use.$q$,
  how_this_becomes_points = $q$You earn points by identifying the control point and explaining how it changes mRNA or protein production.$q$,
  point_attaining_answer = $q$1. State whether regulation affects transcription, RNA processing, translation, or protein activity, then explain the output change.
2. Then make the scoring connection explicit: You earn points by identifying the control point and explaining how it changes mRNA or protein production.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 6-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=6 and topic_code='6.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='28558fab80509f4a1a29d16aa3828d18';
update app.topic_explainers set
  core_idea = $q$- Different cell types can contain the same genome.
- They can express different genes.$q$,
  what_students_need_to_understand = $q$This topic connects regulation to development and explains how specialized cells perform different functions.$q$,
  how_this_becomes_points = $q$You earn points by explaining that selective gene expression produces different proteins and therefore different cell functions.$q$,
  point_attaining_answer = $q$1. Connect gene expression pattern -> protein set -> specialized cell function.
2. Then make the scoring connection explicit: You earn points by explaining that selective gene expression produces different proteins and therefore different cell functions.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 6-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=6 and topic_code='6.6' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='ac5b35b1b528f790e8381e920b7970bd';
update app.topic_explainers set
  core_idea = $q$- Mutations are changes in genetic information.
- They can alter RNA, protein sequence, protein function, or phenotype.$q$,
  what_students_need_to_understand = $q$They connect molecular biology to inheritance, disease, variation, and evolution.$q$,
  how_this_becomes_points = $q$You earn points by tracing the effect of a mutation from DNA change to codon, amino acid, protein structure, and phenotype when appropriate.$q$,
  point_attaining_answer = $q$1. Follow the chain: DNA mutation -> RNA/codon change -> amino acid or regulation change -> functional effect.
2. Then make the scoring connection explicit: You earn points by tracing the effect of a mutation from DNA change to codon, amino acid, protein structure, and phenotype when appropriate.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 6-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=6 and topic_code='6.7' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='3c3a0eb5a1bd7339cc2381dda4d7fbd8';
update app.topic_explainers set
  core_idea = $q$Biotechnology uses molecular tools to analyze, modify, or compare DNA and gene expression.$q$,
  what_students_need_to_understand = $q$It often appears in experimental and data questions about genes, inheritance, and evidence.$q$,
  how_this_becomes_points = $q$You earn points by explaining what the tool measures or changes and how the result supports a biological claim.$q$,
  point_attaining_answer = $q$1. Identify the method's input, output, and interpretation before answering the claim.
2. Then make the scoring connection explicit: You earn points by explaining what the tool measures or changes and how the result supports a biological claim.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 6-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=6 and topic_code='6.8' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='1eeeaffb2ae6122884e090f820c366f7';
update app.topic_explainers set
  core_idea = $q$- Natural selection occurs when heritable variation affects survival or reproduction.
- It acts in a particular environment.$q$,
  what_students_need_to_understand = $q$This is the core mechanism linking variation to evolutionary change.$q$,
  how_this_becomes_points = $q$You earn points by connecting variation, heritability, differential fitness, and allele frequency change.$q$,
  point_attaining_answer = $q$1. Use the chain: variation exists -> some variants improve fitness -> those alleles become more common.
2. Then make the scoring connection explicit: You earn points by connecting variation, heritability, differential fitness, and allele frequency change.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 6-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=7 and topic_code='7.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='7f96ed2f66232c0d70561972bd209939';
update app.topic_explainers set
  core_idea = $q$Natural selection changes population traits over generations because individuals with certain heritable traits leave more offspring.$q$,
  what_students_need_to_understand = $q$- It is one of the most important AP Biology reasoning patterns.
- It appears across data, experimental, and explanation tasks.$q$,
  how_this_becomes_points = $q$You earn points by explaining selection pressure, fitness differences, inheritance, and population-level change over time.$q$,
  point_attaining_answer = $q$1. Describe what is selected, why it affects reproductive success, and how the population changes.
2. Then make the scoring connection explicit: You earn points by explaining selection pressure, fitness differences, inheritance, and population-level change over time.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 6-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=7 and topic_code='7.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='29ceab5805aed56e7203681ef80ecfd4';
update app.topic_explainers set
  core_idea = $q$Artificial selection occurs when humans choose which traits are favored for breeding.$q$,
  what_students_need_to_understand = $q$- It provides a clear comparison case for natural selection.
- It helps explain rapid trait shifts.$q$,
  how_this_becomes_points = $q$You earn points by identifying the human-selected trait and explaining how breeding changes trait or allele frequencies over generations.$q$,
  point_attaining_answer = $q$1. Name the selected trait, who selects it, and how reproduction changes the population.
2. Then make the scoring connection explicit: You earn points by identifying the human-selected trait and explaining how breeding changes trait or allele frequencies over generations.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 6-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=7 and topic_code='7.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='369aa1fe817eb119330f7f4e25c2da60';
update app.topic_explainers set
  core_idea = $q$Population genetics studies allele frequencies and how evolutionary forces change genetic composition.$q$,
  what_students_need_to_understand = $q$It gives students a quantitative way to reason about evolution rather than only describing traits.$q$,
  how_this_becomes_points = $q$You earn points by calculating or interpreting allele and genotype frequencies and linking changes to evolutionary mechanisms.$q$,
  point_attaining_answer = $q$1. Define the population and allele frequencies before deciding whether they changed.
2. Then make the scoring connection explicit: You earn points by calculating or interpreting allele and genotype frequencies and linking changes to evolutionary mechanisms.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 6-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=7 and topic_code='7.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='1debb94e6f916ddf2f96e62a3321aafd';
update app.topic_explainers set
  core_idea = $q$- Hardy-Weinberg equilibrium is a null model for genotype frequencies.
- It applies when specific evolutionary conditions are met.$q$,
  what_students_need_to_understand = $q$It is a high-yield quantitative topic for detecting whether evolution is occurring in a population.$q$,
  how_this_becomes_points = $q$You earn points by using p + q = 1 and p^2 + 2pq + q^2 = 1 and interpreting departures from expected frequencies.$q$,
  point_attaining_answer = $q$1. Identify p and q carefully, calculate genotype frequencies, then compare observed and expected values.
2. Then make the scoring connection explicit: You earn points by using p + q = 1 and p^2 + 2pq + q^2 = 1 and interpreting departures from expected frequencies.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 6-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=7 and topic_code='7.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='f071716c19ed850128e4ead4d729fa3e';
update app.topic_explainers set
  core_idea = $q$Evidence for evolution includes fossils, molecular similarities, anatomical structures, biogeography, and observed population change.$q$,
  what_students_need_to_understand = $q$AP questions reward using evidence to support a claim about relatedness or change over time.$q$,
  how_this_becomes_points = $q$You earn points by naming specific evidence and explaining how it supports common ancestry or evolutionary change.$q$,
  point_attaining_answer = $q$1. Use claim-evidence-reasoning: state the evolutionary claim, cite the evidence, then explain the connection.
2. Then make the scoring connection explicit: You earn points by naming specific evidence and explaining how it supports common ancestry or evolutionary change.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 6-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=7 and topic_code='7.6' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='82d1e2ea84a0a22da110c6228b1b2ea6';
update app.topic_explainers set
  core_idea = $q$- Common ancestry means groups share an ancestral lineage.
- It is often inferred from molecular or structural similarities.$q$,
  what_students_need_to_understand = $q$It connects evolution to phylogeny, comparative biology, and DNA evidence.$q$,
  how_this_becomes_points = $q$You earn points by using similarities and differences to infer relative relatedness or shared ancestry.$q$,
  point_attaining_answer = $q$1. Compare the evidence and state which organisms share a more recent common ancestor and why.
2. Then make the scoring connection explicit: You earn points by using similarities and differences to infer relative relatedness or shared ancestry.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 6-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=7 and topic_code='7.7' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='5c5f25fe63c40d1aecccfbc3ae965a09';
update app.topic_explainers set
  core_idea = $q$Evolution continues when allele frequencies keep changing under mutation, selection, drift, or gene flow.$q$,
  what_students_need_to_understand = $q$This topic helps students explain modern examples such as resistance, emerging traits, and changing environments.$q$,
  how_this_becomes_points = $q$You earn points by identifying the evolutionary force and explaining how it changes allele frequencies over generations.$q$,
  point_attaining_answer = $q$1. Name the force causing change and connect it to allele-frequency shifts, not individual need.
2. Then make the scoring connection explicit: You earn points by identifying the evolutionary force and explaining how it changes allele frequencies over generations.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 6-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=7 and topic_code='7.8' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='8c9040de87af7069445d8395697ea213';
update app.topic_explainers set
  core_idea = $q$Phylogenies represent hypotheses about evolutionary relationships among groups.$q$,
  what_students_need_to_understand = $q$They are common data displays for interpreting relatedness, ancestry, and trait evolution.$q$,
  how_this_becomes_points = $q$- You earn points by reading nodes as common ancestors.
- Use branching patterns, not tip order, to infer relationships.$q$,
  point_attaining_answer = $q$1. Find the most recent common ancestor on the tree before comparing relatedness.
2. Then make the scoring connection explicit: You earn points by reading nodes as common ancestors and using branching patterns, not tip order, to infer relationships.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 6-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=7 and topic_code='7.9' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='971de110c963f38355d9a5314a095554';
update app.topic_explainers set
  core_idea = $q$Speciation occurs when populations become reproductively isolated and diverge into separate species.$q$,
  what_students_need_to_understand = $q$It connects evolutionary mechanisms to biodiversity and lineage branching.$q$,
  how_this_becomes_points = $q$You earn points by explaining the isolating barrier, reduced gene flow, divergence, and reproductive isolation.$q$,
  point_attaining_answer = $q$1. State what separates the populations and how separation leads to accumulated differences.
2. Then make the scoring connection explicit: You earn points by explaining the isolating barrier, reduced gene flow, divergence, and reproductive isolation.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 6-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=7 and topic_code='7.10' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='0c03fc6eb8ab66d7e424ea8b1253d519';
update app.topic_explainers set
  core_idea = $q$Variation in populations comes from mutation, recombination, and other sources of genetic difference.$q$,
  what_students_need_to_understand = $q$Natural selection can only act on existing heritable variation, so this topic supports nearly every evolution explanation.$q$,
  how_this_becomes_points = $q$You earn points by identifying the source of variation and explaining how it creates differences selection or drift can act on.$q$,
  point_attaining_answer = $q$1. Connect the variation source to heritable differences among individuals.
2. Then make the scoring connection explicit: You earn points by identifying the source of variation and explaining how it creates differences selection or drift can act on.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 6-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=7 and topic_code='7.11' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='3bbdd141738ea3065d4b2d933661acbc';
update app.topic_explainers set
  core_idea = $q$Origins-of-life questions address hypotheses about early conditions and the emergence of biological molecules and cells.$q$,
  what_students_need_to_understand = $q$- This is lower frequency.
- It helps students distinguish evidence-supported hypotheses from unsupported claims.$q$,
  how_this_becomes_points = $q$You earn points by connecting early Earth conditions, chemical building blocks, and evidence to a plausible step in life's origin.$q$,
  point_attaining_answer = $q$1. State the hypothesis and the evidence or condition that supports it.
2. Then make the scoring connection explicit: You earn points by connecting early Earth conditions, chemical building blocks, and evidence to a plausible step in life's origin.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 6-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=7 and topic_code='7.12' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='2898c0dabf74ca9ef531278d684883e8';
update app.topic_explainers set
  core_idea = $q$Organisms respond to environmental stimuli through behavioral, physiological, or developmental changes.$q$,
  what_students_need_to_understand = $q$This topic connects ecology to regulation, communication, and fitness.$q$,
  how_this_becomes_points = $q$You earn points by linking a stimulus to a response and explaining how the response affects survival, reproduction, or homeostasis.$q$,
  point_attaining_answer = $q$1. Identify stimulus, response, and biological advantage in the same answer.
2. Then make the scoring connection explicit: You earn points by linking a stimulus to a response and explaining how the response affects survival, reproduction, or homeostasis.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 6-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=8 and topic_code='8.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='fef6e2d8f8c5362ea1c8d7321cd6b5d4';
update app.topic_explainers set
  core_idea = $q$- Energy flows through ecosystems from producers to consumers.
- Energy is lost as heat at each transfer.$q$,
  what_students_need_to_understand = $q$It is a major ecology concept that supports food webs, trophic pyramids, and productivity reasoning.$q$,
  how_this_becomes_points = $q$You earn points by tracing energy movement and explaining why available energy decreases at higher trophic levels.$q$,
  point_attaining_answer = $q$1. Follow energy from source to trophic level and account for loss at each transfer.
2. Then make the scoring connection explicit: You earn points by tracing energy movement and explaining why available energy decreases at higher trophic levels.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 6-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=8 and topic_code='8.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='98a73e688089c0c71909d785346e06fa';
update app.topic_explainers set
  core_idea = $q$Population ecology studies population size, growth, carrying capacity, and factors that affect population change.$q$,
  what_students_need_to_understand = $q$It provides graph and model contexts for interpreting ecological data.$q$,
  how_this_becomes_points = $q$You earn points by connecting birth, death, immigration, emigration, resources, and carrying capacity to population trends.$q$,
  point_attaining_answer = $q$1. Read the graph or model first, then identify which factor changes population size.
2. Then make the scoring connection explicit: You earn points by connecting birth, death, immigration, emigration, resources, and carrying capacity to population trends.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 6-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=8 and topic_code='8.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='cefe5153b27952e9de839b72643ce3cc';
update app.topic_explainers set
  core_idea = $q$Population density affects competition, disease spread, predation, and resource availability.$q$,
  what_students_need_to_understand = $q$This topic helps students distinguish density-dependent effects from density-independent events.$q$,
  how_this_becomes_points = $q$You earn points by explaining how the effect changes as population density changes and what that does to growth or survival.$q$,
  point_attaining_answer = $q$1. Ask whether the factor becomes stronger when the population is more crowded.
2. Then make the scoring connection explicit: You earn points by explaining how the effect changes as population density changes and what that does to growth or survival.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 6-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=8 and topic_code='8.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='b50a6e4f7c1a1822ccf5c638847f5ccb';
update app.topic_explainers set
  core_idea = $q$Community ecology studies interactions among species, including competition, predation, mutualism, parasitism, and succession.$q$,
  what_students_need_to_understand = $q$It connects species interactions to population outcomes and ecosystem structure.$q$,
  how_this_becomes_points = $q$You earn points by identifying the interaction type and explaining the effect on each species or on community composition.$q$,
  point_attaining_answer = $q$1. Name the interaction and state the effect on each participant using evidence from the prompt.
2. Then make the scoring connection explicit: You earn points by identifying the interaction type and explaining the effect on each species or on community composition.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 6-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=8 and topic_code='8.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='f0bb4c74dda62679f391140a2074312a';
update app.topic_explainers set
  core_idea = $q$Biodiversity includes genetic, species, and ecosystem diversity.$q$,
  what_students_need_to_understand = $q$It supports ecosystem resilience, adaptation potential, and conservation reasoning.$q$,
  how_this_becomes_points = $q$You earn points by connecting the type of biodiversity to stability, resilience, or response to environmental change.$q$,
  point_attaining_answer = $q$1. Specify genetic, species, or ecosystem diversity, then explain the consequence of more or less diversity.
2. Then make the scoring connection explicit: You earn points by connecting the type of biodiversity to stability, resilience, or response to environmental change.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 6-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=8 and topic_code='8.6' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='57c763b929a3852d96cfa10734500653';
update app.topic_explainers set
  core_idea = $q$Disruptions such as habitat change, invasive species, climate shifts, and pollution can alter ecosystem structure and function.$q$,
  what_students_need_to_understand = $q$AP ecology questions often ask students to predict effects and justify them from food webs, population data, or biodiversity patterns.$q$,
  how_this_becomes_points = $q$You earn points by tracing the disruption through direct and indirect effects on populations, interactions, and ecosystem processes.$q$,
  point_attaining_answer = $q$1. Identify the first affected component, then follow consequences through the system using evidence.
2. Then make the scoring connection explicit: You earn points by tracing the disruption through direct and indirect effects on populations, interactions, and ecosystem processes.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Biology units 6-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_biology' and unit_number=8 and topic_code='8.7' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='c0b543006da9c6174e7e01fa63792f4f';
do $$ begin if (select count(*) from app.topic_explainers where subject_key='ap_biology' and topic_code in ('6.1','6.2','6.3','6.4','6.5','6.6','6.7','6.8','7.1','7.2','7.3','7.4','7.5','7.6','7.7','7.8','7.9','7.10','7.11','7.12','8.1','8.2','8.3','8.4','8.5','8.6','8.7') and source_note like '%Structured 2026-11-13 (recommendation #3%')<>27 then raise exception 'expected 27 rows updated'; end if; end $$;
commit;
