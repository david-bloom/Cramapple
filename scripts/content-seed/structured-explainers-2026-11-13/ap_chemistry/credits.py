import sys,json,urllib.request
sys.path.insert(0,'.')
import tools
r=urllib.request.Request("https://ai-gateway.vercel.sh/v1/credits",headers={"Authorization":"Bearer "+tools.gateway_key()})
print(json.load(urllib.request.urlopen(r)))
