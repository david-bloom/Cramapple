import sys
n=sys.argv[1]; s=open(f'u{n}.txt').read()
exec(open(f'rep{n}.py').read())
for a,b in R:
    assert s.count(a)==1,(a,s.count(a)); s=s.replace(a,b)
open(f'u{n}.txt','w').write(s)
