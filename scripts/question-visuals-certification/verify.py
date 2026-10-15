import collections,hashlib,json,unittest
import render as B
S=json.loads((B.HERE/'specs.json').read_text())['visuals']
class Repairs(unittest.TestCase):
 def test_graph_exact_source(self):
  a,b=S[0]['segments']
  for x in [-2,0,2,3]:self.assertAlmostEqual(B.R.value(a,x),x+1)
  for x in [3,4,5,6]:self.assertAlmostEqual(B.R.value(b,x),-(x-3)**2+4)
  self.assertEqual(S[0]['points'],[{'x':3,'y':4,'included':False},{'x':3,'y':6,'included':True}])
 def test_ions_exact_source_equal_scale(self):
  self.assertEqual(collections.Counter(S[1]['panels'][0]['ions']),{'Na⁺':6,'Cl⁻':6})
  self.assertEqual(collections.Counter(S[1]['panels'][1]['ions']),{'Ca²⁺':4,'Cl⁻':8})
  fig=B.ions(S[1]);fig.canvas.draw()
  a,b=[a.get_window_extent().size.tolist() for a in fig.axes]
  for x,y in zip(a,b):self.assertAlmostEqual(x,y,places=9)
  self.assertEqual([sum(isinstance(p,B.R.Circle) for p in a.patches) for a in fig.axes],[12,12]);B.R.plt.close(fig)
 def test_labels_inside_canvas_and_do_not_overlap(self):
  for s in S:
   fig=B.figure(s);fig.canvas.draw();renderer=fig.canvas.get_renderer();prior=[]
   for t in fig.findobj(B.R.matplotlib.text.Text):
    if not (t.get_gid() or '').startswith('meaningful-'):continue
    box=t.get_window_extent(renderer)
    self.assertTrue(0<=box.x0<box.x1<=fig.bbox.width and 0<=box.y0<box.y1<=fig.bbox.height,t.get_gid())
    self.assertFalse(any(box.overlaps(b) for b in prior),t.get_gid());prior.append(box)
   B.R.plt.close(fig)
 def test_artifacts_and_repeatability(self):
  before=(B.HERE/'manifest.json').read_bytes();B.build();self.assertEqual(before,(B.HERE/'manifest.json').read_bytes())
  for v in json.loads(before)['visuals']:
   l=v['layouts']['compact'];self.assertGreaterEqual(l['min_meaningful_glyph_css_px'],16)
   for ext in ['png','svg']:self.assertEqual(hashlib.sha256((B.HERE/l[ext]).read_bytes()).hexdigest(),l['sha256'][ext])
if __name__=='__main__':unittest.main(verbosity=2)
