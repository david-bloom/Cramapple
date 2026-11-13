import importlib.util, json, os, glob, uuid
HERE=os.path.dirname(os.path.abspath(__file__)); R=os.path.join(HERE,'..')
spec=importlib.util.spec_from_file_location('pmb',os.path.join(R,'..','publish_mcq_batch.py')); pmb=importlib.util.module_from_spec(spec); spec.loader.exec_module(pmb)
REF=pmb.ENVS['prod']; U=str(uuid.uuid4())
epv={}
for f in glob.glob(os.path.join(R,'raw','ap_*.json')):
    for r in json.load(open(f)): epv[r['content_key']]=r['epv']
allowed={r['exam_pack_version_id']:max(r['allowed_unit_numbers']) for r in pmb.query(REF,'select exam_pack_version_id::text, allowed_unit_numbers from app.home_release_manifest')}
cases=[('apphy1-mcq-022','mcq',['2.6','6.6']),('apphycm-frq-003','frq',['3.4','7.2']),('apcalcbc-frq-u13-014','frq',['2.3','5.1']),('apchem-frq-l-017','frq',['4.6','8.5']),('apprecalc-frq-np2-010','frq',['1.11','1.5']),('APSTAT-MOD4-H001-INV','frq',['1.13','4.10']),('APSTAT-MOD5-H001-INV','frq',['5.2','1.13'])]
for k,ty,tops in cases:
    e=epv[k]
    for t in tops:
        got={}; off=0
        for _ in range(40):
            page=pmb.query(REF,f"select content_key, topic_match from public.select_student_practice_items('{e}'::uuid, {allowed[e]}, '{U}'::uuid, null, '{ty}', '{t}', 51, {off})")
            for p in page: got[p['content_key']]=p['topic_match']
            off+=51
            if len(page)<51 or k in got: break
        print(k,'allowed max unit',allowed[e],'topic',t,'->', 'RETURNED topic_match=%s'%got[k] if k in got else 'not returned')
