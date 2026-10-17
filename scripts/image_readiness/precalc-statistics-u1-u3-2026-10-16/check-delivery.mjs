import {readFileSync,writeFileSync} from 'node:fs';
import {createHash} from 'node:crypto';
import assert from 'node:assert/strict';
import {partitionDeliverable,indexAssets} from './live-delivery-v41.ts';
const read=f=>JSON.parse(readFileSync(new URL(f,import.meta.url)));
const rows=read('published-source-inventory.json'),reviews=read('reviews.json');
const selectors=read('selector-result.json').pages,teaching=read('teaching-selection.json').results;
assert.equal(rows.length,801);assert.equal(reviews.length,801);
assert.equal(new Set(reviews.map(r=>r.content_item_version_id)).size,801);
for(const r of reviews) assert(rows.some(x=>x.content_item_version_id===r.content_item_version_id&&x.audit_content_digest===r.audit_content_digest));
const assets=rows.flatMap(r=>r.assets.map(a=>({content_item_version_id:r.content_item_version_id,storage_bucket:a.bucket,storage_path:a.path,alt_text:a.alt,long_description:a.long_description,approved_at:a.approved?'present':null})));
const requirements=rows.filter(r=>r.image_needed).map(r=>({content_item_version_id:r.content_item_version_id,image_needed:r.image_needed,image_approval:r.image_approval}));
const gate=partitionDeliverable(rows,indexAssets(assets),false,new Map(requirements.map(r=>[r.content_item_version_id,r])));
assert.equal(gate.deliverable.length,801);assert.equal(gate.omitted.length,0);
const strict=reviews.filter(r=>!r.classification.startsWith('scope_boundary'));
const required=reviews.filter(r=>r.classification==='required_visual_construct_fidelity');
const result={checked_at:new Date().toISOString(),deployed_function_version:41,shared_source_sha256:createHash('sha256').update(readFileSync(new URL('./live-delivery-v41.ts',import.meta.url))).digest('hex'),all_versions:801,strict_units_1_3:strict.length,boundary_only:801-strict.length,attached_paths:rows.filter(r=>r.stimulus_image_path).length,asset_metadata:assets.length,question_figure_uses:rows.reduce((n,r)=>n+r.question_figures.length,0),existing_gate:{passes:gate.deliverable.length,omitted:gate.omitted},subjects:{}};
for(const subject of ['ap-precalculus','ap-statistics']){
 const corpus=rows.filter(r=>r.subject_key===subject),rev=reviews.filter(r=>r.subject_key===subject);
 const selected=selectors.flatMap(p=>p.items).filter(s=>corpus.some(r=>r.content_item_version_id===s.content_item_version_id));
 assert.equal(new Set(selected.map(r=>r.content_item_version_id)).size,selected.length);
 const taught=teaching.filter(t=>t.subject_key===subject);
 assert(taught.every(t=>corpus.some(r=>r.content_item_version_id===t.selected_version)));
 result.subjects[subject]={reviewed:corpus.length,strict:rev.filter(r=>!r.classification.startsWith('scope_boundary')).length,mcq:corpus.filter(r=>r.item_type==='mcq').length,frq:corpus.filter(r=>r.item_type==='frq').length,counts:Object.fromEntries([...new Set(rev.map(r=>r.classification))].sort().map(c=>[c,rev.filter(r=>r.classification===c).length])),ordinary_selector_candidates:selected.length,ordinary_candidates_after_visual_gate:selected.length,teaching_topics:taught.length,teaching_distinct_versions:new Set(taught.map(t=>t.selected_version)).size};
}
result.required_visual_findings=required.map(r=>({content_key:r.content_key,content_item_version_id:r.content_item_version_id,existing_requirement:rows.find(x=>x.content_item_version_id===r.content_item_version_id).image_needed,selected_teaching_topics:teaching.filter(t=>t.selected_version===r.content_item_version_id).map(t=>t.topic),image_path:null,teaching_image_branch_result_by_source:'no_image'}));
result.limit='Pure deployed visual-gate execution, paged SQL selector and owner/admin teaching RPC checks. No authenticated HTTP or browser student rendering proof; no ordinary-student entitlement proof. Unknown visual decisions are permissive. All findings remain conductor judgments pending independent review.';
writeFileSync(new URL('./summary.json',import.meta.url),JSON.stringify(result,null,2)+'\n');
console.log(JSON.stringify(result,null,2));
