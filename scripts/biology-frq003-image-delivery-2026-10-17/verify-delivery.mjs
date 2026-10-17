// Reproduce the recorded v41 gate and source invariance check; no network/writes
// outside this local evidence directory. Not a live student authorization test.
import {readFileSync,writeFileSync} from 'node:fs';
import {createHash} from 'node:crypto';
import assert from 'node:assert/strict';
import {partitionDeliverable,indexAssets} from '../../supabase/functions/_shared/student-item-delivery.ts';
const here=new URL('./',import.meta.url),read=f=>JSON.parse(readFileSync(new URL(f,here)));
const rows=read('after.json'),before=read('before.json');
const code=readFileSync(new URL('../../supabase/functions/_shared/student-item-delivery.ts',here));
const sourceSha=createHash('sha256').update(code).digest('hex');
assert.equal(sourceSha,'f00785f0dd2c7422f81fb45b1a75c8209a468400419076f9dea810a23e2e3fe0');
const gate=partitionDeliverable(rows,indexAssets(rows),false,new Map(rows.map(r=>[r.content_item_version_id,{content_item_version_id:r.content_item_version_id,image_needed:r.image_needed,image_approval:r.image_approval}])));
assert.equal(gate.deliverable.length,2);assert.equal(gate.omitted.length,0);
for(const r of rows){
 const b=before.find(b=>b.version_id===r.content_item_version_id);
 for(const field of ['content_hash','criteria_hash','taxonomy_hash','label_hash'])assert.equal(r[field],b[field]);
 assert(r.alt_text&&r.long_description&&r.approved_at);
}
const result={checked_at:new Date().toISOString(),project_ref:'pcntajvbdfqhbeewmdry',deployed_version:41,deployed_source_matches_tested_source:true,source_sha256:sourceSha,qa_mode:false,deliverable:gate.deliverable.map(x=>({content_key:x.row.content_key,version_id:x.row.content_item_version_id,path:x.asset.storage_path,approved:true})),omitted:gate.omitted,source_scoring_taxonomy_labels_match_before:true,limits:'Recorded exact deployed gate with live metadata read-back; not an ordinary-student entitlement or full app/browser certificate.'};
writeFileSync(new URL('delivery-gate-check.json',here),JSON.stringify(result,null,2)+'\n');
console.log(JSON.stringify(result,null,2));
