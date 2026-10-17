/** Deterministic SVG source + 2x PNGs for reviewer inspection, never a live load. */
import {createRequire} from 'node:module';
import {readFile,writeFile,mkdir} from 'node:fs/promises';
import {createHash} from 'node:crypto';
import {resolve} from 'node:path';
const require=createRequire(process.argv[2]?resolve(process.argv[2],'package.json'):import.meta.url),sharp=require('sharp');
const base=new URL('./',import.meta.url),spec=JSON.parse(await readFile(new URL('specs.json',base)));
const esc=s=>String(s).replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&apos;'}[c]));
const hash=b=>createHash('sha256').update(b).digest('hex');
const W=340,H=330,LEFT=65,RIGHT=312,TOP=42,BOTTOM=220,FONT=26;
await mkdir(new URL('assets/',base),{recursive:true});
const text=(x,y,s,extra='')=>`<text x="${x}" y="${y}" ${extra}>${esc(s)}</text>`;
const num=n=>Number(n.toFixed(6));
function panel(item,choice,offset=0){
 const n=item.bins.length,step=(RIGHT-LEFT)/n,max=item.y_axis_max;
 let out=`<g transform="translate(0 ${offset})" font-family="Arial, sans-serif" font-size="${FONT}" fill="#151515">`;
 out+=text(12,28,choice.key,'font-weight="700" data-meaningful="choice-label"');
 for(let count=0;count<=max;count+=2){
  const y=num(BOTTOM-count/max*(BOTTOM-TOP));
  out+=`<path d="M${LEFT} ${y}H${RIGHT}" fill="none" stroke="#ddd" stroke-width="1"/>`;
  out+=text(LEFT-8,y+8,count,'font-size="24" text-anchor="end" data-role="tick"');
 }
 for(let i=0;i<n;i++){
  const height=choice.counts[i]/max*(BOTTOM-TOP);
  out+=`<rect data-role="histogram-bar" data-bin="${i}" data-count="${choice.counts[i]}" x="${num(LEFT+i*step)}" y="${num(BOTTOM-height)}" width="${num(step)}" height="${num(height)}" fill="#b5b5b5" stroke="#151515" stroke-width="1.2"/>`;
 }
 out+=`<path d="M${LEFT} ${TOP}V${BOTTOM}H${RIGHT}" stroke="#151515" fill="none" stroke-width="1.4"/>`;
 const edges=item.bins.map(b=>b.left_edge).concat(item.bins.at(-1).right_edge_exclusive);
 for(let i=0;i<edges.length;i++){
  const x=num(LEFT+i*step);
  out+=`<path d="M${x} ${BOTTOM}v5" stroke="#151515"/>`;
  out+=text(0,0,edges[i],`font-size="${n>=10?20:24}" transform="translate(${x-7} ${BOTTOM+14}) rotate(90)" text-anchor="start" data-role="tick"`);
 }
 out+=text(0,0,'Count',`transform="translate(25 142) rotate(-90)" text-anchor="middle" data-meaningful="y-axis"`);
 const variable={'quiz scores':'Quiz score','one-way commute times':'Commute time','battery life':'Battery life','online order totals':'Order total','seedling heights':'Seedling height'}[item.variable];
 out+=text((LEFT+RIGHT)/2,314,`${variable} (${item.unit})`,'text-anchor="middle" data-meaningful="x-axis"');
 return out+'</g>';
}
const wrap=(body,height,title,description)=>`<svg xmlns="http://www.w3.org/2000/svg" width="340" height="${height}" viewBox="0 0 340 ${height}" role="img" aria-labelledby="title desc"><title id="title">${esc(title)}</title><desc id="desc">${esc(description)}</desc><rect width="340" height="${height}" fill="white"/>${body}</svg>\n`;
const manifest={status:'Local review artifacts; no upload or publication',rasterizer_versions:sharp.versions,renderer_sha256:hash(await readFile(new URL('render.mjs',base))),specs_sha256:hash(await readFile(new URL('specs.json',base))),width:W,panel_height:H,meaningful_font_user_units:FONT,minimum_planned_css_width:230,minimum_planned_label_css_px:FONT*230/W,items:[]};
async function asset(name,svg,height,alt,longDescription){
 const svgBytes=Buffer.from(svg),png=await sharp(svgBytes,{density:144}).png({compressionLevel:9,adaptiveFiltering:false}).toBuffer();
 const svgPath=`assets/${name}.svg`,pngPath=`assets/${name}.png`;
 await writeFile(new URL(svgPath,base),svgBytes);await writeFile(new URL(pngPath,base),png);
 const meta=await sharp(png).metadata();
 if(meta.width!==680||meta.height!==height*2)throw Error(`Unexpected raster dimensions for ${name}`);
 return {svg:svgPath,png:pngPath,svg_sha256:hash(svgBytes),png_sha256:hash(png),png_width:meta.width,png_height:meta.height,mime:'image/png',bytes:png.length,alt_text:alt,long_description:longDescription};
}
for(const item of spec.items){
 const suffix=item.content_key.split('-').at(-1),record={content_key:item.content_key,source_version:item.source_content_item_version_id,source_digest:item.source_audit_content_digest,choices:[]};
 for(const c of item.choices){
  const svg=wrap(panel(item,c),H,`Choice ${c.key}`,c.long_description);
  record.choices.push({key:c.key,...await asset(`${suffix}-${c.key}`,svg,H,c.alt_text,c.long_description)});
 }
 const height=H*4,svg=wrap(item.choices.map((c,i)=>panel(item,c,i*H)).join(''),height,'Histogram choices A through D',item.sheet_long_description);
 record.all_choices_sheet=await asset(`${suffix}-all-choices`,svg,height,item.sheet_alt_text,item.sheet_long_description);
 manifest.items.push(record);
}
await writeFile(new URL('manifest.json',base),JSON.stringify(manifest,null,2)+'\n');
const cards=spec.items.map((item,index)=>{
 const rec=manifest.items[index];
 return `<section id="q${index}" class="question"><h2>${esc(item.content_key)}</h2><p class="stem">${esc(item.stem)}</p><div class="choices">${rec.choices.map(c=>`<figure><img src="${c.svg}" alt="${esc(c.alt_text)}" width="340" height="330" loading="lazy"/><figcaption>Choice ${c.key}</figcaption></figure>`).join('')}</div><details><summary>Reviewer key and revision details</summary><p>Derived answer: <strong>${esc(item.derived_answer_key)}</strong>. Historical stored key must be compared before release.</p>${item.choices.map(c=>`<p><strong>${c.key} · ${esc(c.change)}</strong> — ${esc(c.rationale)}</p>`).join('')}<p>Full A–D sheet: <a href="${rec.all_choices_sheet.png}">PNG</a> · <a href="${rec.all_choices_sheet.svg}">SVG</a></p></details></section>`;
}).join('\n');
const html=`<!doctype html><html lang="en"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Statistics graphical choices — 20-item repair review</title><style>*{box-sizing:border-box}body{margin:0;color:#202020;background:#f4f3f0;font:18px/1.5 Arial,sans-serif}header,main{max-width:900px;margin:auto;padding:24px}h1{font-size:28px}h2{font-size:20px;overflow-wrap:anywhere}.question{background:white;padding:24px;margin-bottom:24px;border:1px solid #ccc}.choices{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:20px}figure{margin:0;border:1px solid #ddd;padding:8px}img{display:block;width:100%;max-width:340px;height:auto;margin:auto}figcaption{font-weight:bold;text-align:center}details{margin-top:24px;border-top:1px solid #ddd;padding-top:16px}summary{cursor:pointer}nav{display:flex;flex-wrap:wrap;gap:8px}a{color:#9c2c00}nav a{padding:5px 10px;background:white;border:1px solid #bbb}body.phone main,body.phone header{max-width:320px;padding:16px}body.phone .question{padding:12px}body.phone .choices{grid-template-columns:1fr;gap:16px}body.phone figure{padding:8px}button{font:inherit;padding:8px 12px;background:white;border:1px solid #555;cursor:pointer}@media(max-width:580px){header,main{padding:16px}.question{padding:12px}.choices{grid-template-columns:1fr;gap:16px}figure{padding:8px}}</style><body><header><h1>Statistics graphical choices</h1><p>20 existing questions · local repair draft · no live changes</p><p>All four choices use identical axes and styling. Reviewer answers stay collapsed. Raw observations, stems and the two historical histogram choices are preserved.</p><button id="phone" type="button">Toggle 320px review pane</button><nav aria-label="Questions">${spec.items.map((it,i)=>`<a href="#q${i}">${it.content_key.split('-').at(-1)}</a>`).join('')}</nav></header><main>${cards}</main><script>document.getElementById('phone').onclick=()=>document.body.classList.toggle('phone');</script></body></html>`;
await writeFile(new URL('preview.html',base),html+'\n');
console.log(JSON.stringify({questions:manifest.items.length,choice_images:manifest.items.length*4,all_choice_sheets:manifest.items.length,svg_and_png_files:manifest.items.length*10,min_planned_label_css_px:manifest.minimum_planned_label_css_px}));
