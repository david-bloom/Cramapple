"""S4 divergence check against the source, run WITHOUT storing the source in the repo.
Usage: python3 divergence_check.py <path-to-source-text-outside-repo>
Prints only numbers per item: word Jaccard vs each source question (max), shared non-trivial numbers,
shared chemical formulas, shared 4-word phrases count. Writes divergence_report.json (numbers only)."""
import json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
src_text = open(sys.argv[1]).read()
blocks = [b for b in re.split(r'^### ', src_text, flags=re.M) if b.strip()]

def norm(t):
    t = t.translate(str.maketrans('₀₁₂₃₄₅₆₇₈₉⁻⁺', '0123456789-+'))
    return t.lower()

def words(t): return set(re.findall(r'[a-z0-9.]+', norm(t)))
def nums(t): return {n for n in re.findall(r'\d+\.\d+|\d{2,}', norm(t)) if n not in {'100', '10', '23', '22.4'}}
def formulas(t): return set(re.findall(r'\b(?:[A-Z][a-z]?\d*(?:\([A-Za-z0-9]+\)\d*)?){2,}\b', t.translate(str.maketrans('₀₁₂₃₄₅₆₇₈₉', '0123456789'))))
def grams(t, n=4):
    w = re.findall(r'[a-z]+', norm(t)); return {' '.join(w[i:i + n]) for i in range(len(w) - n + 1)}

items = json.load(open(sys.argv[2] if len(sys.argv) > 2 else os.path.join(HERE, 'items_assembled.json')))
rows = []
for it in items:
    t = it['stem'] + ' ' + ' '.join(c['text'] for c in it['choices']) + ' ' + ' '.join(it['rationales'].values())
    w = words(t)
    j = max(len(w & words(b)) / len(w | words(b)) for b in blocks)
    rows.append({'key': it['key'],
                 'max_jaccard_vs_source': round(j, 3),
                 'shared_numbers': len(nums(t) & nums(src_text)),
                 'shared_formulas': len(formulas(t) & formulas(src_text)),
                 'shared_4grams': len(grams(t) & grams(src_text))})
json.dump(rows, open(os.path.join(HERE, 'divergence_report.json'), 'w'), indent=1)
for r in rows: print(r)
