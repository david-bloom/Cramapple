// Operator-only immutable Storage; no credentials or signed URLs are saved.
import {execFileSync} from 'node:child_process';
import {readFile,writeFile} from 'node:fs/promises';
import {createHash} from 'node:crypto';
const here=new URL('./',import.meta.url),plan=JSON.parse(await readFile(new URL('release-plan.json',here))),mode=process.argv[2]??'verify',ref='pcntajvbdfqhbeewmdry',base=`https://${ref}.supabase.co`;
if(!['upload','verify'].includes(mode)||plan.length!==23)throw Error('Scope/mode guard');
let keys;try{keys=JSON.parse(execFileSync('supabase',['projects','api-keys','--project-ref',ref,'-o','json'],{encoding:'utf8',stdio:['ignore','pipe','pipe']}));}catch{throw Error('Existing CLI access unavailable; no credentials printed');}
const key=keys.find(k=>k.name==='service_role')?.api_key;if(!key)throw Error('No existing service credential');
const headers={apikey:key,Authorization:`Bearer ${key}`,'Content-Type':'application/json'},hash=b=>createHash('sha256').update(b).digest('hex'),results=[];
for(const t of plan){
 if(!t.storage_path.startsWith('questions/')||!t.storage_path.endsWith(t.sha256+'.png'))throw Error('Immutable path guard');
 if(mode==='upload'){
  const png=await readFile(new URL(t.png,here));if(hash(png)!==t.sha256||png.length!==t.bytes)throw Error('Asset checksum drift');
  const res=await fetch(`${base}/storage/v1/object/content-assets/${t.storage_path}`,{method:'POST',headers:{...headers,'Content-Type':'image/png','x-upsert':'false','cache-control':'31536000'},body:png});
  if(!res.ok)throw Error(`Immutable upload ${t.content_key}: HTTP ${res.status}`);
  results.push({content_key:t.content_key,path:t.storage_path,sha256:t.sha256,bytes:t.bytes,overwritten:false});
 }else{
  const sign=await fetch(`${base}/storage/v1/object/sign/content-assets/${t.storage_path}`,{method:'POST',headers,body:JSON.stringify({expiresIn:900})});if(!sign.ok)throw Error(`Sign HTTP ${sign.status}`);
  const signed=await sign.json(),res=await fetch(`${base}/storage/v1${signed.signedURL}`);if(!res.ok)throw Error(`GET HTTP ${res.status}`);
  const png=Buffer.from(await res.arrayBuffer());if(hash(png)!==t.sha256)throw Error('Live SHA drift');
  const pub=await fetch(`${base}/storage/v1/object/public/content-assets/${t.storage_path}`);if(pub.ok)throw Error('Private object unexpectedly public');
  results.push({content_key:t.content_key,path:t.storage_path,sha256:hash(png),bytes:png.length,width:png.readUInt32BE(16),height:png.readUInt32BE(20),signed_get:res.status,public_get:pub.status,ttl:900});
 }
 await writeFile(new URL(`storage-${mode}-receipt.json`,here),JSON.stringify({checked_at:new Date().toISOString(),project_ref:ref,mode,results,credentials_saved:false,signed_urls_saved:false},null,2)+'\n');
}
console.log(JSON.stringify({mode,objects:results.length,checks_passed:true}));
