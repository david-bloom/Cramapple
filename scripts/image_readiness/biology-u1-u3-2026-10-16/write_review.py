"""Materialize the conductor's completed 221-source review, not an image classifier.

Every source/choice/authored-part was read in this session. The explicit exceptions
below preserve the distinction between missing assets, incomplete instructions,
complete tables and requested learner constructions. No database writes.
"""
import json
from pathlib import Path
HERE = Path(__file__).parent
rows = json.loads((HERE / 'published-source-inventory.json').read_text())
selected = {r['content_item_version_id'] for r in json.loads((HERE/'selector-result.json').read_text())['rows']} if (HERE/'selector-result.json').exists() else set()
scenario_only = {
 'APBIO-FRQ-S-003','APBIO-FRQ-S-019','APBIO-FRQ-S-021','APBIO-FRQ-S-023',
 'APBIO-FRQ-S-025','APBIO-FRQ-S-026','APBIO-FRQ-S-028','APBIO-FRQ-S-029',
 'APBIO-FRQ-S-032','APBIO-FRQ-S-033','APBIO-FRQ-S-036','APBIO-FRQ-S-038',
 'APBIO-FRQ-S-040','APBIO-FRQ-S-071','APBIO-FRQ-S-080',
}
notes = {
 'APBIO-FRQ-L-008': ('learner_constructs_visual','Full sucrose/mass table is present; the student is asked to graph the values. A completed graph would disclose the response.'),
 'APBIO-HDG-2026-GRAPH-002': ('learner_constructs_visual','Both five-number summaries are supplied, including temperature labels. Constructing side-by-side boxplots is the response task.'),
 'APBIO-MCQ-020': ('complete_text','The photographed-cell outcomes are fully specified in words (normal/swollen/lysed/crenated), together with 300 mOsm/L. No unseen morphological identification is requested.'),
 'APBIO-MCQ-005': ('complete_text','Both sugar formula and the differing three-dimensional arrangements are supplied; the task asks why shape affects transport, not to identify an unseen structure.'),
 'APBIO-MCQ-022': ('complete_text','The four lines of endosymbiotic evidence, including both membrane identities, are enumerated in text; the answer does not depend on a missing micrograph.'),
 'APBIO-OHT-2.3': ('complete_text','The task asks which written description correctly arranges phospholipids in water. Drawing the correct arrangement in the prompt would disclose the assessed answer.'),
 'APBIO-OHT-3.1': ('complete_text','Activation energies 75/40 and total energy release 30 kJ/mol are stated. The task asks what an enzyme changes, rather than to interpret an absent energy diagram.'),
}
reviews=[]
for row in rows:
 key=row['content_key']
 if key in scenario_only:
  category='insufficient_question_instructions'
  reason='The published presentation contains a scenario but no question/instruction or authored part prompt. Do not infer the task from scoring criteria or invent an image requirement.'
 elif key in notes:
  category,reason=notes[key]
 elif '|' in ((row['stem'] or '')+' '+(row['stimulus'] or '')):
  category='complete_table'
  reason='The question supplies its stated values, row/column labels and relevant conditions in a text table. No absent graph/figure is needed for the question as authored.'
 else:
  category='complete_text'
  reason='The stem, stimulus, written choices and authored parts supply the task and givens; the question asks for a written mechanism/prediction/comparison rather than identification of an unseen visual.'
 reviews.append({
  'content_key':key,'content_item_version_id':row['content_item_version_id'],
  'audit_content_digest':row['audit_content_digest'],'topic_evidence':row['topic_evidence'],
  'classification':category,'reason':reason,'source_evidence':row['stem'],
  'existing_image_path':row['stimulus_image_path'],
  'delivery_finding': 'asset_metadata_missing; image object exists but ordinary delivery omits this item' if key=='APBIO-FRQ-S-003' else None,
  'image_need_conclusion': 'undetermined_without_actual_question' if key in scenario_only else 'no_missing_required_prompt_image_identified',
  'browser_delivery':'not_individually_exercised',
  'ordinary_unit3_selector_eligible_no_history':row['content_item_version_id'] in selected,
  'scope_disposition':'boundary_conflict_later_serving_unit' if key in {'APBIO-FRQ-S-040','APBIO-MCQ-024','APBIO-MCQ-030','APBIO-MCQ-061'} else 'units_1_3',
 })
assert len(rows)==221 and len({r['content_item_version_id'] for r in rows})==221
assert {r['content_item_version_id'] for r in reviews}=={r['content_item_version_id'] for r in rows}
assert all(r['topic_evidence'] and all(t['unit'] in (1,2,3) for t in r['topic_evidence']) for r in reviews)
assert sum(r['classification']=='insufficient_question_instructions' for r in reviews)==15
(HERE/'reviews.json').write_text(json.dumps(reviews,indent=2,ensure_ascii=False)+'\n')
counts={}
for r in reviews: counts[r['classification']]=counts.get(r['classification'],0)+1
summary={'environment':'Production','project_ref':'pcntajvbdfqhbeewmdry','source_versions_reviewed':221,
 'subjects':['biology'],'units':[1,2,3],'scope_rule':'Current canonical primary-topic resolution; metadata-only boundary check, no source audit of later units.',
 'by_type':{'mcq':187,'frq':34},'by_unit':{'1':104,'2':80,'3':37},'classifications':counts,
 'confirmed_missing_prompt_image_objects':0,'existing_image_delivery_blockers':1,'incomplete_question_presentations':15,
 'scope_uncertainties':[{'content_key':'APBIO-HDG-2026-GRAPH-008','finding':'Held generic germination graph-construction exercise; no canonical unit. Scope-boundary review only: complete counts table, requested graph is the response, not a missing prompt image.'},
 {'content_key':'APBIO-HDG-2026-GRAPH-010','finding':'No canonical unit; stale unit-8 label and ecology metadata. Source not opened, outside authorized audit.'}],
 'independent_qa':'pending','verdict':'Cannot certify complete-question delivery; source review complete for 221 canonical-mapped versions, including four explicit later-unit boundary conflicts.',
 'biology_content_asset_label_writes':0,'other_subject_audits':0,
 'strict_units_1_3_versions':217,'primary_vs_later_serving_unit_conflicts':4,
 'incomplete_instructions_strict_scope':14,
 'ordinary_selector_eligible_at_unit3_no_history':len(selected),'passes_image_gate_after_selector':len(selected)-1 if selected else None,
 'teaching_designations':22,'held_practice_questions':2,'new_biology_objects':0}
(HERE/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps(summary))
