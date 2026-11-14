import subprocess,sys
T='/Users/davidbloom/Documents/Cramapple.nosync/scripts/content-seed/structured-explainers-rest-2026-11-13/tools.py'
subprocess.run(['python3','-u',T,'check','fetch_ab.json','proposed_ab_skipped.json','check_out_ab_struct','openai/gpt-6.1-sol','moonshotai/kimi-k3.1-pro'],stdout=open('qlog_ab_struct.txt','w'),stderr=subprocess.STDOUT)
