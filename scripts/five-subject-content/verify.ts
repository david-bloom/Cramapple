import { compilePlan, canonicalJson, sha256 } from "../subject-harness/compiler.ts";

const subjects=["ap-chemistry","ap-physics-1","ap-physics-2","ap-physics-c-mechanics","ap-physics-c-em"];
const registry=JSON.parse(await Deno.readTextFile("schemas/subject-onboarding/platform-capabilities.v1.json"));
const allKeys=new Set<string>();
const result:any[]=[];

for(const subjectKey of subjects){
 const subject=JSON.parse(await Deno.readTextFile(`content/subject-packages/${subjectKey}.subject-package.json`));
 const dir=`content/item-packages/${subjectKey}`;
 const files=[];
 for await(const entry of Deno.readDir(dir)) if(entry.isFile&&entry.name.endsWith(".json")) files.push(entry.name);
 files.sort();
 const items=await Promise.all(files.map(async name=>JSON.parse(await Deno.readTextFile(`${dir}/${name}`))));
 const mcq=items.filter(i=>i.item_type==="mcq"); const frq=items.filter(i=>i.item_type==="frq");
 if(mcq.length!==20||frq.length!==16) throw new Error(`${subjectKey}: expected 20 MCQ and 16 FRQ`);
 for(const item of items){
  if(allKeys.has(item.content_key)) throw new Error(`duplicate content_key ${item.content_key}`); allKeys.add(item.content_key);
  const copy=structuredClone(item); delete copy.provenance.content_sha256;
  const actual=await sha256(canonicalJson(copy));
  if(actual!==item.provenance.content_sha256) throw new Error(`${item.content_key}: hash mismatch`);
 }
 const unitKeys=new Set(subject.taxonomy.nodes.filter((n:any)=>n.node_type==="unit").map((n:any)=>n.node_key));
 const covered=new Set(items.flatMap((i:any)=>i.taxonomy_refs.map((r:any)=>r.node_key)).filter((k:string)=>unitKeys.has(k)));
 if(covered.size!==unitKeys.size) throw new Error(`${subjectKey}: unit coverage ${covered.size}/${unitKeys.size}`);
 const difficulty=Object.fromEntries(["Easy","Medium","Hard","Very Hard"].map(d=>[d,items.filter(i=>i.difficulty===d).length]));
 if(Math.max(...Object.values(difficulty) as number[])>Math.floor(items.length*.4)) throw new Error(`${subjectKey}: difficulty concentration`);
 const plan=await compilePlan(subject,items,registry);
 result.push({subject:subjectKey,mcq:mcq.length,frq:frq.length,units:covered.size,difficulty,plan_sha256:plan.plan_sha256,advisories:plan.advisories});
}
console.log(JSON.stringify({valid:true,total_content_keys:allKeys.size,subjects:result},null,2));
