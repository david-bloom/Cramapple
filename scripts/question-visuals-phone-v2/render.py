"""Compact v2: same source data, larger labels for 320px question panes."""
import hashlib,importlib.util,json
from pathlib import Path
HERE=Path(__file__).resolve().parent
def load(name,path):
 spec=importlib.util.spec_from_file_location(name,path);module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module);return module
R=load('pilot_v2_engine',HERE.parent/'question-visuals-pilot'/'render.py')
LAYOUT={'width':340,'height':350,'min_width':230,'font':26}
def ions(spec):
 w,h=340,850
 fig=R.plt.figure(figsize=(w/100,h/100),dpi=100,facecolor='white')
 def label(x,y,text,gid):
  t=fig.text(x,y,text,ha='center',va='center',fontsize=R.font(26));t.set_gid('meaningful-'+gid)
 label(.5,.965,spec['title'],'title')
 for n,p in enumerate(spec['panels']):
  bottom=.56 if n==0 else .17
  label(.5,bottom+.30,p['label'],f'panel-{n}')
  ax=fig.add_axes([.06,bottom,.88,.25]);ax.set(xlim=(0,4),ylim=(0,3));ax.axis('off')
  ax.add_patch(R.Rectangle((0,0),4,3,facecolor='#faf8fc',edgecolor=R.AXIS,linewidth=1.5))
  for j,ion in enumerate(p['ions']):
   x=.5+j%4;y=2.5-j//4
   patch=R.Circle((x,y),radius=.43,facecolor='#e8e1f2' if ion!='Cl⁻' else 'white',edgecolor=R.INK,linewidth=1.1)
   patch.set_gid(f'ion-{n}-{j}-{ion}');ax.add_patch(patch)
   t=ax.text(x,y,ion,ha='center',va='center',fontsize=R.font(26),color=R.INK);t.set_gid(f'meaningful-ion-{n}-{j}')
 label(.5,.12,'Same volume\nin each box.','equal-volume')
 label(.5,.04,'Water molecules\nnot shown.','water-omitted')
 return fig
def figure(s):
 if s['kind']=='ions':return ions(s)
 if s['kind']=='particles':
  fig=R.particles(s,LAYOUT)
  next(t for t in fig.texts if t.get_gid()=='meaningful-key').set_position((.5,.015))
  return fig
 return R.graph(s,LAYOUT)
def build():
 out=HERE/'assets';out.mkdir(exist_ok=True)
 m={'schema_version':2,'status':'built_not_published','renderer_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),'graph_engine_sha256':hashlib.sha256((HERE.parent/'question-visuals-pilot'/'render.py').read_bytes()).hexdigest(),'specs_sha256':hashlib.sha256((HERE/'specs.json').read_bytes()).hexdigest(),'matplotlib_version':R.matplotlib.__version__,'visuals':[]}
 for s in json.loads((HERE/'specs.json').read_text())['visuals']:
  fig=figure(s);base=out/(s['visual_id']+'-compact-v2')
  fig.savefig(base.with_suffix('.svg'),metadata={'Date':None,'Creator':'Cramapple deterministic question renderer compact v2'})
  fig.savefig(base.with_suffix('.png'),dpi=200,metadata={'Software':'Cramapple deterministic question renderer compact v2'})
  floor=R.svg_metadata(base.with_suffix('.svg'),s,LAYOUT);R.plt.close(fig)
  hashes={ext:hashlib.sha256(base.with_suffix('.'+ext).read_bytes()).hexdigest() for ext in ['png','svg']}
  v={k:s[k] for k in ['visual_id','content_key','question_version_id','audit_content_digest','source_stem_md5','source_stimulus_md5','source_image_path','alt','long_description','lane']}
  v['layouts']={'compact':{'png':str(base.with_suffix('.png').relative_to(HERE)),'svg':str(base.with_suffix('.svg').relative_to(HERE)),'sha256':hashes,'min_display_width_css_px':230,'min_meaningful_glyph_css_px':floor,'proposed_private_object_path':f'questions/{s["content_key"]}/v2/{hashes["png"]}.png'}};m['visuals'].append(v)
 (HERE/'manifest.json').write_text(json.dumps(m,ensure_ascii=False,indent=2)+'\n')
 print('Built six v2 compact SVG/PNG pairs; floor 17.59px at 230px image width.')
if __name__=='__main__':build()
