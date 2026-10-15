"""Fail-closed, process-safe accounting for this batch's explicitly approved provider spend.

Reserve a full context window at the highest listed token tier before EVERY HTTP attempt.
Only a complete trustworthy usage response releases the unused reservation. Timeouts, HTTP
errors, missing usage and interrupted workers retain their entire reservation indefinitely.
This bounds spend subject to the provider honoring published rates and output token limits.
No paid request is authorized by importing or testing this module.
"""
import json, pathlib, sqlite3, uuid
from decimal import Decimal, ROUND_CEILING

HERE = pathlib.Path(__file__).resolve().parent
CAP = 60_000_000  # microdollars; immutable batch maximum
PRICES = {
    "anthropic/claude-sonnet-5.5": (1_000_000, Decimal('2'), Decimal('10'), None),
    "google/gemini-3.5-flash": (1_000_000, Decimal('1.5'), Decimal('9'), None),
    "openai/gpt-6-sol": (1_050_000, Decimal('4'), Decimal('15'), 272001),
    "anthropic/claude-haiku-5.5": (1_000_000, Decimal('0.5'), Decimal('2.5'), 100001),
}

class BudgetError(RuntimeError): pass

def authorization(path=None):
    path = pathlib.Path(path or HERE / 'budget_authorization.json')
    if not path.exists(): raise BudgetError('No owner authorization file: provider calls prohibited')
    a = json.loads(path.read_text())
    if (a.get('provider_calls_authorized') is not True or a.get('cap_usd') != 60
            or not a.get('approval_reference') or set(a.get('models', [])) != set(PRICES)):
        raise BudgetError('Authorization must name approval, all four models and exactly the $60 cap')
    return a

def _micro(n): return int(n.to_integral_value(rounding=ROUND_CEILING))

def worst_case(model, max_tokens):
    if model not in PRICES or not isinstance(max_tokens, int) or not 0 < max_tokens <= 16000:
        raise BudgetError('Unapproved model or output-token limit')
    context, ip, op, _ = PRICES[model]
    return _micro(Decimal(context) * ip + Decimal(max_tokens) * op)

class Meter:
    def __init__(self, path=None):
        self.path = pathlib.Path(path or HERE / 'out' / 'spend.sqlite3')
        self.path.parent.mkdir(parents=True, exist_ok=True)
        with self._db() as db:
            db.execute('create table if not exists settings (id integer primary key, cap integer not null, frozen integer not null default 0)')
            db.execute('insert or ignore into settings(id,cap) values(1,?)', (CAP,))
            db.execute('create table if not exists calls (id text primary key, model text not null, tag text not null, reserved integer not null, charged integer, state text not null)')
            if db.execute('select cap from settings where id=1').fetchone()[0] != CAP:
                raise BudgetError('Existing meter has different budget cap')
    def _db(self):
        db=sqlite3.connect(self.path, timeout=30, isolation_level=None)
        db.execute('pragma synchronous=FULL')
        return db
    def reserve(self, model, max_tokens, tag):
        amount=worst_case(model,max_tokens); rid=str(uuid.uuid4())
        with self._db() as db:
            db.execute('begin immediate')
            used=db.execute('select coalesce(sum(coalesce(charged,reserved)),0) from calls').fetchone()[0]
            frozen=db.execute('select frozen from settings where id=1').fetchone()[0]
            if frozen or used+amount>CAP:
                db.execute('rollback')
                raise BudgetError(f'Budget stopped before request: committed/reserved ${used/1e6:.4f}, next bound ${amount/1e6:.4f}, cap $60')
            db.execute('insert into calls values(?,?,?,?,null,?)',(rid,model,tag,amount,'reserved'))
            db.execute('commit')
        return rid
    def uncertain(self, rid):
        with self._db() as db: db.execute("update calls set state='uncertain' where id=? and charged is null",(rid,))
    def settle(self,rid,usage,max_tokens):
        with self._db() as db:
            db.execute('begin immediate')
            model,reserved,state=db.execute('select model,reserved,state from calls where id=?',(rid,)).fetchone()
            p=usage.get('prompt_tokens'); c=usage.get('completion_tokens')
            context,ip,op,threshold=PRICES[model]
            valid=(type(p) is int and type(c) is int and 0<=p<=context and 0<=c<=max_tokens)
            reasoning=(usage.get('completion_tokens_details') or {}).get('reasoning_tokens',0)
            valid=valid and type(reasoning) is int and 0<=reasoning<=c if valid else False
            if not valid:
                db.execute("update calls set state='uncertain' where id=?",(rid,)); db.execute('commit')
                raise BudgetError('Missing/unbounded usage: full reservation retained; no retry')
            if threshold and p<threshold:
                ip,op=(Decimal('2'),Decimal('10')) if model.startswith('openai/') else (Decimal('0.1'),Decimal('0.5'))
            charged=_micro(Decimal(p)*ip+Decimal(c)*op)
            if charged>reserved or state=='settled':
                db.execute('update settings set frozen=1 where id=1'); db.execute('commit')
                raise BudgetError('Provider bound violation or duplicate settlement: meter frozen')
            db.execute("update calls set charged=?,state='settled' where id=?",(charged,rid)); db.execute('commit')
    def summary(self):
        with self._db() as db:
            rows=db.execute('select state,count(*),sum(coalesce(charged,reserved)) from calls group by state').fetchall()
        return {'cap_usd':60,'states':[{'state':s,'calls':n,'usd':v/1e6} for s,n,v in rows], 'committed_or_reserved_usd':sum(r[2] for r in rows)/1e6}

def verify_roster(data):
    """Free public roster read must happen before the first paid attempt in each process."""
    rows={r['id']:r for r in data.get('data',[])}
    for model,(context,ip,op,_) in PRICES.items():
        if model not in rows: raise BudgetError(f'Model missing from roster: {model}')
        r=rows[model]; prices=r.get('pricing',{})
        inputs=[Decimal(prices.get('input','Infinity'))]+[Decimal(x['cost']) for x in prices.get('input_tiers',[])]
        outputs=[Decimal(prices.get('output','Infinity'))]+[Decimal(x['cost']) for x in prices.get('output_tiers',[])]
        if max(inputs)*1_000_000>ip or max(outputs)*1_000_000>op or r.get('context_window',context)>context:
            raise BudgetError(f'Roster exceeds reserved pricing/context bound: {model}')
