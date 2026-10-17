import { execFileSync } from 'node:child_process';
import { createHash } from 'node:crypto';
import { mkdirSync, writeFileSync } from 'node:fs';
const ref = 'pcntajvbdfqhbeewmdry';
let keys;
try { keys = JSON.parse(execFileSync('supabase', ['projects','api-keys','--project-ref',ref,'-o','json'], {encoding:'utf8',stdio:['ignore','pipe','pipe']})); }
catch { throw new Error('Could not obtain existing project access through Supabase CLI; no credentials printed.'); }
const key = keys.find(k => k.name === 'service_role')?.api_key;
if (!key) throw new Error('Existing service credential unavailable.');
const base = `https://${ref}.supabase.co`;
const headers = {apikey:key,Authorization:`Bearer ${key}`,'Content-Type':'application/json'};
const targets = [
  {key:'apcalcbc-mcq-ab-060',path:'questions/apcalcab-mcq-060/v2/9c8307b50c0c5c345f016df04cb96f8cca7bf5f88ebcf3645700f53c567e4669.png',expected:'9c8307b50c0c5c345f016df04cb96f8cca7bf5f88ebcf3645700f53c567e4669'},
  {key:'APBIO-FRQ-S-003',path:'Biology/FRQ/APBIO-FRQ-S-003.png'},
];
const out = new URL('./storage-evidence/',import.meta.url); mkdirSync(out,{recursive:true});
const evidence=[];
for (const t of targets) {
  const signed = await fetch(`${base}/storage/v1/object/sign/content-assets/${t.path}`,{method:'POST',headers,body:JSON.stringify({expiresIn:900})});
  if (!signed.ok) { evidence.push({...t,sign_status:signed.status});continue; }
  const b=await signed.json();
  const download = await fetch(`${base}/storage/v1${b.signedURL}`);
  const bytes=Buffer.from(await download.arrayBuffer());
  const sha256=createHash('sha256').update(bytes).digest('hex');
  if (t.expected && t.expected!==sha256) throw new Error(`Checksum mismatch for ${t.key}`);
  if(download.ok) writeFileSync(new URL(`${t.key}.png`,out),bytes);
  const pub=await fetch(`${base}/storage/v1/object/public/content-assets/${t.path}`);
  evidence.push({content_key:t.key,path:t.path,download_status:download.status,bytes:bytes.length,sha256,expected_checksum_matches:t.expected?sha256===t.expected:null,unsigned_status:pub.status});
}
const result={checked_at:new Date().toISOString(),project_ref:ref,evidence,credentials_saved:false,signed_urls_saved:false,scope:'Storage operator check only; not student authorization or browser delivery'};
writeFileSync(new URL('verification.json',out),JSON.stringify(result,null,2)+'\n');
console.log(JSON.stringify(result));
