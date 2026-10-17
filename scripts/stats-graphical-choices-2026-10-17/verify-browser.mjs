/** Verify local draft layout in Chromium. This never visits a live student app. */
import {createRequire} from 'node:module';
import {readFile,writeFile,mkdir} from 'node:fs/promises';
import {resolve} from 'node:path';
const require=createRequire(process.argv[2]?resolve(process.argv[2],'package.json'):import.meta.url);
const {chromium}=require('playwright');
const base=new URL('./',import.meta.url),manifest=JSON.parse(await readFile(new URL('manifest.json',base)));
const browser=await chromium.launch({headless:true});
const page=await browser.newPage({viewport:{width:1280,height:900}});
const errors=[],layout={};
try{
 await page.setContent('<body style="margin:0"></body>');
 let svgCount=0,texts=0,minLabel=Infinity;
 for(const item of manifest.items){
  for(const asset of [...item.choices,item.all_choices_sheet]){
   const svg=await readFile(new URL(asset.svg,base),'utf8');
   const measured=await page.evaluate(svg=>{
    document.body.innerHTML=svg;
    const root=document.querySelector('svg');root.style.width='230px';root.style.height='auto';
    const bounds=root.getBoundingClientRect();
    const nodes=[...root.querySelectorAll('text')].map(el=>{
     const r=el.getBoundingClientRect();
     return {text:el.textContent,left:r.left-bounds.left,right:r.right-bounds.left,
             top:r.top-bounds.top,bottom:r.bottom-bounds.top,
             meaningful:el.hasAttribute('data-meaningful'),
             cssFont:parseFloat(getComputedStyle(el).fontSize)*bounds.width/root.viewBox.baseVal.width};
    });
    const clipped=nodes.filter(r=>r.left < -0.5||r.right>bounds.width+0.5||r.top < -0.5||r.bottom>bounds.height+0.5);
    const overlaps=[];
    for(let i=0;i<nodes.length;i++)for(let j=i+1;j<nodes.length;j++){
     const a=nodes[i],b=nodes[j];
     if(Math.min(a.right,b.right)-Math.max(a.left,b.left)>0.5&&Math.min(a.bottom,b.bottom)-Math.max(a.top,b.top)>0.5)overlaps.push([a.text,b.text]);
    }
    return {clipped,overlaps,texts:nodes.length,minLabel:Math.min(...nodes.filter(n=>n.meaningful).map(n=>n.cssFont))};
   },svg);
   svgCount++;texts+=measured.texts;minLabel=Math.min(minLabel,measured.minLabel);
   if(measured.clipped.length||measured.overlaps.length)errors.push({file:asset.svg,...measured});
  }
 }
 if(errors.length)throw Error(JSON.stringify({layout_errors:errors.slice(0,8),total:errors.length}));
 await mkdir(new URL('review-evidence/',base),{recursive:true});
 for(const width of [1280,320]){
  await page.setViewportSize({width,height:900});
  await page.goto(new URL('preview.html',base).href);
  // Scroll every image into view so lazy loads are verified, not merely counted.
  for(const img of await page.locator('img').all()){
   await img.scrollIntoViewIfNeeded();
   await img.evaluate(async image=>{await image.decode()});
  }
  const checks=await page.evaluate(()=>({
   viewport:window.innerWidth,document:document.documentElement.scrollWidth,
   images:[...document.images].map(i=>({decoded:i.complete&&i.naturalWidth>0,width:i.getBoundingClientRect().width,alt:!!i.alt})),
   answerDetailsClosed:[...document.querySelectorAll('details')].every(d=>!d.open),
  }));
  if(checks.document>checks.viewport||checks.images.length!==80||checks.images.some(i=>!i.decoded||!i.alt)||!checks.answerDetailsClosed)throw Error(JSON.stringify({width,...checks}));
  layout[width]={viewport_css_px:checks.viewport,document_css_px:checks.document,decoded_images:checks.images.length,
                 minimum_image_css_width:Math.min(...checks.images.map(i=>i.width)),
                 minimum_meaningful_label_css_px:Math.min(...checks.images.map(i=>26*i.width/340)),
                 answers_collapsed:true};
  if(layout[width].minimum_meaningful_label_css_px<16)throw Error('Labels too small');
  await page.locator('#q8').scrollIntoViewIfNeeded();
  await page.locator('#q8').screenshot({path:new URL(`review-evidence/105008-${width}.png`,base).pathname});
 }
 const result={status:'PASS',svg_documents_measured:svgCount,text_elements_measured:texts,
               clipping_or_text_overlap:0,minimum_label_at_230_css_width:minLabel,preview_layouts:layout,
               limitation:'Local reviewer preview only; no authenticated student app, publication or entitlement check.'};
 await writeFile(new URL('browser-verification.json',base),JSON.stringify(result,null,2)+'\n');
 console.log(JSON.stringify(result,null,2));
}finally{await browser.close()}
