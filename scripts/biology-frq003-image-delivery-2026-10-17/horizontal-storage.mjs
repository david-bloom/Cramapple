// Exact-scope operator Storage checks. Credentials and signed URLs stay in memory.
import {execFileSync} from 'node:child_process';
import {createHash} from 'node:crypto';
import {readFile,writeFile,mkdir} from 'node:fs/promises';
const ref='pcntajvbdfqhbeewmdry',base=`https://${ref}.supabase.co`;
const here=new URL('./',import.meta.url),mode=process.argv[2]??'verify';
if(!['upload','verify'].includes(mode))throw Error('Unknown mode');
let keys;
try{keys=JSON.parse(execFileSync('supabase',['projects','api-keys','--project-ref',ref,'-o','json'],{encoding:'utf8',stdio:['ignore','pipe','pipe']}));}
catch{throw Error('Existing CLI project access unavailable; credentials were not printed.');}
const key=keys.find(k=>k.name==='service_role')?.api_key;
if(!key)throw Error('Existing service credential unavailable.');
const headers={apikey:key,Authorization:`Bearer ${key}`,'Content-Type':'application/json'};
const originals=[
 {content_key:'APBIO-FRQ-S-003',path:'Biology/FRQ/APBIO-FRQ-S-003.png',sha256:'a04a4f2604635854a864f98a2d919f360e218d79da3b2f5724ad1f384d1abe8a'},
 {content_key:'APBIO-FRQ-L-003',path:'Biology/FRQ/APBIO-FRQ-L-003.png',sha256:'6cf98d6964144ae0946c729176917120efe1a0925454eb443ff5b88a02f8553c'}
];
const hash=b=>createHash('sha256').update(b).digest('hex');
if(mode==='upload'){
 const manifest=JSON.parse(await readFile(new URL('horizontal-manifest.json',here)));
 const png=await readFile(new URL(manifest.file,here));
 if(hash(png)!==manifest.sha256||!manifest.path.startsWith('questions/apbio-frq-s-003/v3/'))throw Error('Build/path guard failed');
 const result=await fetch(`${base}/storage/v1/object/content-assets/${manifest.path}`,{method:'POST',headers:{...headers,'Content-Type':'image/png','x-upsert':'false','cache-control':'31536000'},body:png});
 if(!result.ok)throw Error(`Immutable upload failed: HTTP ${result.status}`);
 const receipt={uploaded:true,checked_at:new Date().toISOString(),path:manifest.path,sha256:manifest.sha256,bytes:png.length,overwritten:false}; await writeFile(new URL('horizontal-upload-receipt.json',here),JSON.stringify(receipt,null,2)+'\n'); console.log(JSON.stringify(receipt));
}else{
 const targets=[
  {...originals[1]},
  {content_key:'APBIO-FRQ-S-003',...JSON.parse(await readFile(new URL('horizontal-manifest.json',here)))}
 ];
 const results=[];
 for(const t of targets){
  const sign=await fetch(`${base}/storage/v1/object/sign/content-assets/${t.path}`,{method:'POST',headers,body:JSON.stringify({expiresIn:900})});
  if(!sign.ok)throw Error(`Sign failed for ${t.content_key}: HTTP ${sign.status}`);
  const body=await sign.json();
  const response=await fetch(`${base}/storage/v1${body.signedURL}`);
  if(!response.ok)throw Error(`Download failed: HTTP ${response.status}`);
  const png=Buffer.from(await response.arrayBuffer());
  if(hash(png)!==t.sha256)throw Error('Exact-object checksum mismatch');
  const pub=await fetch(`${base}/storage/v1/object/public/content-assets/${t.path}`);
  if(pub.ok)throw Error('Private object unexpectedly public');
  results.push({content_key:t.content_key,path:t.path,sha256:hash(png),bytes:png.length,width:png.readUInt32BE(16),height:png.readUInt32BE(20),signed_download_status:response.status,unsigned_status:pub.status,ttl_seconds:900});
 }
 const result={checked_at:new Date().toISOString(),project_ref:ref,mode,results,credentials_saved:false,signed_urls_saved:false,scope:'Operator download/signing check; not ordinary-student authorization or app rendering'};
 await writeFile(new URL('horizontal-live-storage-check.json',here),JSON.stringify(result,null,2)+'\n');
 console.log(JSON.stringify(result,null,2));
}
