"""Offline tests. All provider transport is mocked; no authorization or paid call is made."""
import concurrent.futures,copy,json,pathlib,tempfile,unittest
from unittest.mock import patch
import budget,gateway,gates

def reserve_in_process(args):
    path,i=args
    try:
        budget.Meter(path).reserve('openai/gpt-6-sol',8000,f'process{i}')
        return True
    except budget.BudgetError:return False

class GuardTests(unittest.TestCase):
    def setUp(self):
        self.tmp=tempfile.TemporaryDirectory();self.path=pathlib.Path(self.tmp.name)
        self.meter=budget.Meter(self.path/'meter.sqlite3')
    def tearDown(self):self.tmp.cleanup()
    def test_authorization_missing_and_incomplete(self):
        with self.assertRaises(budget.BudgetError):budget.authorization(self.path/'none')
        p=self.path/'auth.json';p.write_text('{}')
        with self.assertRaises(budget.BudgetError):budget.authorization(p)
    def test_gateway_stops_without_authorization_before_key_or_transport(self):
        with patch.object(gateway,'authorization',side_effect=budget.BudgetError('No approval')),patch.object(gateway,'_key') as key,patch.object(gateway.urllib.request,'urlopen') as http:
            with self.assertRaises(budget.BudgetError):gateway.chat_json('openai/gpt-6-sol','','',self.path,'test')
            key.assert_not_called();http.assert_not_called()
    def test_reservation_uses_full_context_and_highest_tier(self):
        self.assertEqual(budget.worst_case('openai/gpt-6-sol',8000),4_320_000)
        self.assertEqual(budget.worst_case('anthropic/claude-haiku-5.5',8000),520_000)
        with self.assertRaises(budget.BudgetError):budget.worst_case('other/model',8000)
        with self.assertRaises(budget.BudgetError):budget.worst_case('openai/gpt-6-sol',16001)
    def test_concurrent_workers_never_exceed_cap(self):
        def reserve(i):
            try:return self.meter.reserve('openai/gpt-6-sol',8000,str(i))
            except budget.BudgetError:return None
        with concurrent.futures.ThreadPoolExecutor(max_workers=24) as ex:ids=list(ex.map(reserve,range(100)))
        self.assertEqual(len([x for x in ids if x]),13)
        self.assertLessEqual(self.meter.summary()['committed_or_reserved_usd'],60)
        # A new process/instance sees the same durable reservations.
        with self.assertRaises(budget.BudgetError):budget.Meter(self.path/'meter.sqlite3').reserve('openai/gpt-6-sol',8000,'restart')
    def test_settlement_releases_only_bounded_usage(self):
        r=self.meter.reserve('openai/gpt-6-sol',8000,'ok')
        self.meter.settle(r,{'prompt_tokens':1000,'completion_tokens':1000,'completion_tokens_details':{'reasoning_tokens':900}},8000)
        self.assertAlmostEqual(self.meter.summary()['committed_or_reserved_usd'],.012)
    def test_separate_processes_share_the_same_cap(self):
        with concurrent.futures.ProcessPoolExecutor(max_workers=4) as ex:
            admitted=list(ex.map(reserve_in_process,[(str(self.path/'meter.sqlite3'),i) for i in range(40)]))
        self.assertEqual(sum(admitted),13)
        self.assertLessEqual(self.meter.summary()['committed_or_reserved_usd'],60)
    def test_unknown_usage_retains_full_reservation(self):
        r=self.meter.reserve('openai/gpt-6-sol',8000,'unknown')
        with self.assertRaises(budget.BudgetError):self.meter.settle(r,{},8000)
        self.assertEqual(self.meter.summary()['committed_or_reserved_usd'],4.32)
    def test_retry_keeps_timeout_reservation_and_charges_success(self):
        response={'choices':[{'message':{'content':'{"ok":true}'}}],'usage':{'prompt_tokens':1000,'completion_tokens':1000}}
        class Response:
            def __enter__(self):return self
            def __exit__(self,*a):pass
            def read(self):return json.dumps(response).encode()
        with patch.object(gateway,'_authorize_and_verify'),patch.object(gateway,'_key',return_value='test-no-key'),patch.object(gateway,'Meter',return_value=self.meter),patch.object(gateway.time,'sleep'),patch.object(gateway.urllib.request,'urlopen',side_effect=[TimeoutError('ambiguous'),Response()]) as http:
            p,_=gateway.chat_json('openai/gpt-6-sol','test','test',self.path,'retry',max_tokens=8000,retries=3)
            self.assertTrue(p['ok']);self.assertEqual(http.call_count,2)
        self.assertAlmostEqual(self.meter.summary()['committed_or_reserved_usd'],4.332)
    def test_all_failed_retries_are_reserved(self):
        with patch.object(gateway,'_authorize_and_verify'),patch.object(gateway,'_key',return_value='test-no-key'),patch.object(gateway,'Meter',return_value=self.meter),patch.object(gateway.time,'sleep'),patch.object(gateway.urllib.request,'urlopen',side_effect=TimeoutError('ambiguous')):
            with self.assertRaises(RuntimeError):gateway.chat_json('openai/gpt-6-sol','','',self.path,'retry',max_tokens=8000,retries=3)
        self.assertAlmostEqual(self.meter.summary()['committed_or_reserved_usd'],12.96)
    def test_roster_price_increase_refused(self):
        rows=[{'id':m,'context_window':c,'pricing':{'input':str(i/1_000_000),'output':str(o/1_000_000)}} for m,(c,i,o,_) in budget.PRICES.items()]
        budget.verify_roster({'data':rows})
        rows[0]['pricing']['input']='99'
        with self.assertRaises(budget.BudgetError):budget.verify_roster({'data':rows})
    def examples(self):
        checks=['google/gemini-3.5-flash','openai/gpt-6-sol'];veto='anthropic/claude-haiku-5.5'
        controls=[{'candidate_id':str(i),'control':True,'control_target':'entry','hooks':[]} for i in range(6)]
        def verdict(c):return {'candidate_id':c['candidate_id'],'accepted':False,'checkers':{m:{'accept':False,'samples':[{'entry':{'accept':False}}]} for m in checks},'veto':None,'hooks_accepted':{}}
        return controls,[verdict(c) for c in controls],checks,veto
    def test_control_gate_requires_complete_verdicts_and_all_rejections(self):
        c,r,ch,v=self.examples();self.assertTrue(gates.validate([],c,r,ch,v))
        with self.assertRaises(ValueError):gates.validate([],c,r[:-1],ch,v)
        bad=copy.deepcopy(r);bad[0]['accepted']=True
        with self.assertRaises(ValueError):gates.validate([],c,bad,ch,v)
    def test_hook_control_cannot_pass_by_rejecting_correct_entry(self):
        c,r,ch,v=self.examples();c[0]['control_target']='hook';c[0]['hooks']=[{'hook_text':'bad'}];r[0]['hooks_accepted']={'bad':False}
        with self.assertRaises(ValueError):gates.validate([],c,r,ch,v)
        for m in ch:r[0]['checkers'][m]['accept']=True
        r[0]['veto']={'accept':True,'samples':[{}]};r[0]['accepted']=True
        self.assertTrue(gates.validate([],c,r,ch,v))
    def test_gate_receipt_pins_input_and_verdict_hashes(self):
        c,r,ch,v=self.examples();paths=[]
        for name,data in [('candidates',[]),('controls',c),('verdicts',r)]:
            p=self.path/(name+'.json');p.write_text(json.dumps(data));paths.append(p)
        gate=self.path/'gate.json';gates.write_receipt(gate,*paths,ch,v);gates.verify_receipt(gate)
        paths[0].write_text('[{}]')
        with self.assertRaises(ValueError):gates.verify_receipt(gate)

if __name__=='__main__':unittest.main(verbosity=2)
