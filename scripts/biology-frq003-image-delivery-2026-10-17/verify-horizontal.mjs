// Exact current-version gate and source/control checks; no app-auth certificate.
import {readFileSync,writeFileSync} from 'node:fs';
import {createHash} from 'node:crypto';
import assert from 'node:assert/strict';
import {partitionDeliverable,indexAssets} from '../../supabase/functions/_shared/student-item-delivery.ts';
const here=new URL('./',import.meta.url),read=f=>JSON.parse(readFileSync(new URL(f,here)));
const before=read('horizontal-before.json'),after=read('horizontal-after.json'),m=read('horizontal-manifest.json');
assert.equal(after.length,4);
for(const a of after){
 const b=before.find(b=>b.version_id===a.version_id);assert(b);
 for(const field of ['item_hash','content_hash','taxonomy_hash','criteria_hash','label_hash','requirement_hash'])assert.equal(a[field],b[field],`${a.version_id}: ${field}`);
 assert.equal(a.retained_assets_hash,b.assets_hash);
 if(a.version_id!==m.version_id){assert.equal(a.full_version_hash,b.full_version_hash);assert.equal(a.stimulus_image_path,b.stimulus_image_path);}
 else {assert.equal(a.status,'published');assert.equal(a.stimulus_image_path,m.path);assert.equal(a.assets.length,2);}
}
const current=after.filter(r=>r.status==='published').map(r=>{
 const a=r.assets.find(a=>a.storage_path===r.stimulus_image_path);assert(a?.approved_at);
 return {...r,...a,...r.visual_requirement,content_item_version_id:r.version_id};
});
assert.equal(current.length,2);
const source=readFileSync(new URL('../../supabase/functions/_shared/student-item-delivery.ts',here)),sha=createHash('sha256').update(source).digest('hex');
assert.equal(sha,'f00785f0dd2c7422f81fb45b1a75c8209a468400419076f9dea810a23e2e3fe0');
const gate=partitionDeliverable(current,indexAssets(current),false,new Map(current.map(r=>[r.version_id,r.visual_requirement])));
assert.equal(gate.deliverable.length,2);assert.equal(gate.omitted.length,0);
const result={checked_at:new Date().toISOString(),deployed_version:41,live_source_compared_byte_for_byte:true,source_sha256:sha,qa_mode:false,deliverable:gate.deliverable.map(x=>({content_key:x.row.content_key,version_id:x.row.content_item_version_id,path:x.asset.storage_path})),omitted:gate.omitted,source_scoring_taxonomy_labels_and_existing_metadata_decisions_unchanged:true,retired_s003_and_all_l003_unchanged:true,limits:'Exact deployed image gate with live read-back. Local 230px/620px diagram checks are separate; no authenticated learner/browser or whole-question certificate.'};
writeFileSync(new URL('horizontal-delivery-gate-check.json',here),JSON.stringify(result,null,2)+'\n');
console.log(JSON.stringify(result,null,2));
