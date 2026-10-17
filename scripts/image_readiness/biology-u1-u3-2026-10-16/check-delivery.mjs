import { readFileSync, writeFileSync } from 'node:fs';
import { createHash } from 'node:crypto';
import { partitionDeliverable, indexAssets } from './live-delivery-v41.ts';
const rows=JSON.parse(readFileSync(new URL('./published-source-inventory.json',import.meta.url)));
const selected=rows.map(r=>({...r}));
const assets=rows.flatMap(r=>r.assets.map(a=>({content_item_version_id:r.content_item_version_id,storage_bucket:a.bucket,storage_path:a.path,alt_text:a.alt,long_description:a.long_description,approved_at:a.approved?'present':null})));
const requirements=rows.filter(r=>r.image_needed).map(r=>({content_item_version_id:r.content_item_version_id,image_needed:r.image_needed,image_approval:r.image_approval}));
const gate=partitionDeliverable(selected,indexAssets(assets),false,new Map(requirements.map(r=>[r.content_item_version_id,r])));
if(gate.omitted.length!==1||gate.omitted[0].content_key!=='APBIO-FRQ-S-003'||gate.omitted[0].reason!=='asset_metadata_missing') throw new Error('Unexpected image gate result');
const output={checked_at:new Date().toISOString(),deployed_function_version:41,
 shared_source_sha256:createHash('sha256').update(readFileSync(new URL('./live-delivery-v41.ts',import.meta.url))).digest('hex'),
 input_versions:rows.length,passes_visual_metadata_gate:gate.deliverable.length,omitted:gate.omitted,
 scope:'Execute the exact deployed pure image gate against frozen live records; this is not a selector, endpoint, browser or student-authorization certification.'};
writeFileSync(new URL('./delivery-gate-result.json',import.meta.url),JSON.stringify(output,null,2)+'\n');
console.log(JSON.stringify(output));
