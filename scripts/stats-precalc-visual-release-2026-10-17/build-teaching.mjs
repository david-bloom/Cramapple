import {createRequire} from 'node:module';
import {readFile,writeFile} from 'node:fs/promises';
import {createHash} from 'node:crypto';
const sharp=createRequire('/Users/davidbloom/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/package.json')('sharp');
const here=new URL('./',import.meta.url),hash=b=>createHash('sha256').update(b).digest('hex');
const txt=(x,y,s,extra='')=>`<text x="${x}" y="${y}" ${extra}>${s}</text>`;
const center=(x,y,s)=>txt(x,y,s,'text-anchor="middle"');
const wrap=(h,b,d)=>`<svg xmlns="http://www.w3.org/2000/svg" width="340" height="${h}" viewBox="0 0 340 ${h}" role="img"><title>${d}</title><rect width="340" height="${h}" fill="white"/><g font-family="Arial,sans-serif" font-size="26" fill="#151515">${b}</g></svg>\n`;
const assets=[];
async function save(key,h,b,alt,long){const svg=wrap(h,b,alt),png=await sharp(Buffer.from(svg),{density:144}).png({compressionLevel:9,adaptiveFiltering:false}).toBuffer();const file=key.toLowerCase().replaceAll('.','-');await writeFile(new URL(file+'.svg',here),svg);await writeFile(new URL(file+'.png',here),png);assets.push({content_key:key,svg:file+'.svg',png:file+'.png',width:680,height:h*2,bytes:png.length,sha256:hash(png),svg_sha256:hash(svg),storage_path:`questions/${key.toLowerCase()}/v1/${hash(png)}.png`,alt_text:alt,long_description:long,minimum_label_css_px_at_230:26*230/340});}
let b='';const X=x=>60+x*34,Y=y=>300-y*30;
for(let x=0;x<=7;x++){b+=`<path d="M${X(x)} 60V300" stroke="#ddd"/>`+center(X(x),327,x);}
for(let y=0;y<=8;y+=2){b+=`<path d="M60 ${Y(y)}H298" stroke="#ddd"/>`+txt(48,Y(y)+8,y,'text-anchor="end"');}
b+='<path d="M60 45V300H311" fill="none" stroke="#151515" stroke-width="2"/>'+txt(306,354,'x')+txt(16,30,'f(x)');
b+=`<polyline points="${[[0,1],[2,7],[5,1],[7,3]].map(([x,y])=>[X(x),Y(y)].join(',')).join(' ')}" fill="none" stroke="#151515" stroke-width="3"/>`;
for(const [x,y] of [[0,1],[2,7],[5,1],[7,3]])b+=`<circle cx="${X(x)}" cy="${Y(y)}" r="4" fill="#151515"/>`;
await save('apprecalc-oht-1.3',370,b,'Piecewise-linear graph of f on labeled x and f(x) axes.','Straight segments connect the points (0,1), (2,7), (5,1) and (7,3), in that order. The x axis runs from 0 to 7; the vertical axis is labeled f(x).');
b='';
for(const [offset,title,max,value,unit] of [[0,'Freshmen: n = 200',200,60,'Count'],[300,'Seniors: n = 50',100,40,'Percent']]){
 b+=center(190,offset+31,title);
 for(let tick=0;tick<=max;tick+=max/4){let y=offset+235-tick/max*165;b+=`<path d="M85 ${y}H305" stroke="#ddd"/>`+txt(77,y+7,tick,'text-anchor="end" font-size="22"');}
 b+=`<path d="M85 ${offset+65}V${offset+235}H305" fill="none" stroke="#151515" stroke-width="2"/>`;
 let barh=value/max*165;b+=`<rect x="165" y="${offset+235-barh}" width="65" height="${barh}" fill="#b5b5b5" stroke="#151515"/>`+center(197.5,offset+225-barh,value)+center(197.5,offset+269,'Pop')+txt(0,0,unit,`transform="translate(26 ${offset+155}) rotate(-90)" text-anchor="middle"`);
}
b+=center(170,625,'Pop category only');
await save('APSTATS-OHT-1.4',640,b,'Two Pop-only bar panels: freshman counts and senior percentages.','Freshmen panel: n=200, vertical axis Count from 0 to 200, Pop bar height 60. Seniors panel: n=50, vertical axis Percent from 0 to 100, Pop bar height 40. Only the Pop category is displayed; other genres are unspecified.');
b=center(182,32,'Meeting preference');
for(let tick=0;tick<=100;tick+=25){const y=260-tick*1.8;b+=`<path d="M80 ${y}H310" stroke="#ddd"/>`+txt(73,y+7,tick,'text-anchor="end" font-size="22"');}
b+='<path d="M80 75V260H310" fill="none" stroke="#151515" stroke-width="2"/>'+txt(0,0,'Percent','transform="translate(23 175) rotate(-90)" text-anchor="middle"');
for(const [x,label,pct] of [[105,'Chess',40],[235,'Art',75]]){const cut=260-pct*1.8;b+=`<rect x="${x}" y="80" width="60" height="180" fill="#eee" stroke="#151515"/><rect x="${x}" y="${cut}" width="60" height="${pct*1.8}" fill="#777" stroke="#151515"/>`+center(x+30,cut+Math.max(30,pct*.9)+8,pct+'%')+center(x+30,80+(100-pct)*.9+8,(100-pct)+'%')+center(x+30,295,label);}
b+='<rect x="70" y="325" width="26" height="26" fill="#777" stroke="#151515"/>'+txt(110,348,'Online')+'<rect x="70" y="370" width="26" height="26" fill="#eee" stroke="#151515"/>'+txt(110,393,'Not online');
await save('APSTATS-OHT-2.1',420,b,'Equal-total segmented percentage bars for Chess and Art meeting preference.','Both bars total 100 percent of their own club. Chess: online 40 percent, not online 60 percent. Art: online 75 percent, not online 25 percent. Dark segments denote online; light segments denote not online. No membership counts are specified.');
await writeFile(new URL('teaching-assets.json',here),JSON.stringify({renderer_sha256:hash(await readFile(new URL('build-teaching.mjs',here))),assets},null,2)+'\n');console.log(JSON.stringify(assets.map(a=>({key:a.content_key,sha:a.sha256,size:[a.width,a.height]}))));
