"""Record a batch AFTER the conductor reads its complete presentation.

This script reconciles identities and materializes supplied judgments. It does
not classify unseen questions or substitute lexical hits for semantic review.
"""
import argparse,json
from pathlib import Path
p=argparse.ArgumentParser();p.add_argument('start',type=int);p.add_argument('end',type=int);p.add_argument('--category',default='complete_text_formula_or_table');p.add_argument('--reason',default='The complete numerical/formula/text givens and task are present in the authored question; no absent input graphic is needed for the task as stated.');p.add_argument('--exceptions',default='{}');a=p.parse_args()
root=Path(__file__).parent; inv=json.loads((root/'published-source-inventory.json').read_text()); out=root/'reviews.json'
reviews={r['content_item_version_id']:r for r in json.loads(out.read_text())} if out.exists() else {}
exceptions=json.loads(a.exceptions)
assert 0<=a.start<a.end<=len(inv)
for i in range(a.start,a.end):
 r=inv[i]; e=exceptions.get(str(i),{}); key=r['content_item_version_id']
 reviews[key]={'index':i,'subject_key':r['subject_key'],'content_key':r['content_key'],'content_item_version_id':key,'audit_content_digest':r['audit_content_digest'],
 'classification':e.get('classification',a.category),'reason':e.get('reason',a.reason),'source_evidence':r['stem'],'topic_evidence':r['topic_evidence'],
 'existing_image_path':r['stimulus_image_path'],'source_review':'conductor_complete_presentation','browser_delivery':'not_individually_exercised'}
assert all(r['content_item_version_id'] in {x['content_item_version_id'] for x in inv} for r in reviews.values())
out.write_text(json.dumps(sorted(reviews.values(),key=lambda r:r['index']),indent=2,ensure_ascii=False)+'\n')
progress={'total_inventory':len(inv),'reviewed':len(reviews),'unreviewed_indices':[i for i,r in enumerate(inv) if r['content_item_version_id'] not in reviews],
 'classification_counts':{c:sum(r['classification']==c for r in reviews.values()) for c in sorted({r['classification'] for r in reviews.values()})}}
(root/'progress.json').write_text(json.dumps(progress,indent=2)+'\n')
print(json.dumps({k:v for k,v in progress.items() if k!='unreviewed_indices'}))
