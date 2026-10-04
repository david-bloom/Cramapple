import json,hashlib
meta="""001|0adbe5c1-17c3-45bb-ac3d-7b4131f3028d|40d8dda2-58c4-4c30-a2af-6f48693fc0da|validated|8
002|7c44284d-0f37-4471-adb3-458dd476c446|79fb2d5e-03de-4ae9-8f37-ccb344a96e08|validated|8
003|c6e5d3e9-98ef-4704-b202-3279ec9428df|310c3aab-790a-43c6-a2d8-75a617d6f2d5|held|
005|ac3d12a7-5519-4f46-983b-b128da218dd8|f776acc1-c315-4d81-84d0-053e20ada34e|validated|9
006|c979ee83-79d9-402a-ba93-70588b5f836c|b27d1b43-4dd0-49bd-a0d8-8a4768cfdef0|validated|9
007|0e3b84c1-0c3a-4dfc-ba02-678c45f2d5f0|683d2a99-cc8b-455a-8c57-6a0414f3341c|validated|10
008|8a9d4d4b-5590-4077-8cd4-18d7ed4b8d5b|d08e0b09-0ff5-4195-9516-c99e5ba9c0fd|validated|10
009|47dafcfd-9894-463a-8f7e-54ad04ef28f4|c2521186-1279-4703-9b51-6a583a3fd95f|validated|10
016|c29fe0eb-d5c7-4908-937b-a857d2bd3106|a27c0b98-41a7-45a4-906c-785a810d239f|held|
019|438860ca-3825-4838-868c-ad8b28ed812a|f89306e6-08bc-4e0a-a074-7128d3f356e2|held|
021|f5d6353a-ae8d-4845-aa46-433759089cc1|323e62f1-a874-4a4b-8ac5-0a961436e554|validated|8
022|f2dbbf4e-201f-4172-964d-2c2c37c35a1b|fd38da62-4043-41ce-9a6a-3587b37d3f47|validated|8
023|50200712-b656-4ba6-8ec8-535d14b4aeea|e0817ceb-7257-4284-8976-72615341b827|validated|8
024|d6d46cfb-5dfa-43dd-a1a8-4e97e95ec17b|12c4d0cc-aaa6-48be-a9e4-3e619b10804a|validated|8
025|1612b41d-7a18-4557-be51-bcb7abe846df|edc2da0d-97ad-464f-85be-cc218b51a578|validated|8
026|f23e1a19-be59-4505-baf0-f53c5ef7dd32|9973664a-5a58-4def-9e92-05517ac0af8f|validated|9
027|672b2774-ee5d-4683-9117-fecd7f72e15f|e430dc7b-f183-4750-81b1-f76017511120|validated|9
028|b6cfbb53-60bf-4d55-9565-54929b1feb8f|41f074ee-841c-47fc-a263-a8ccc023aa2b|validated|9
029|288ef89a-f424-45a3-844f-6730640f7c4e|b4febe3d-44f9-4a5c-96e4-02c8075526e0|validated|10
030|51569438-5f3c-4718-b450-a925338c54ca|2c73534a-508b-4c62-b215-af4faa83467f|validated|10
np1-001|b274bffc-a2cd-40e7-b8fa-117f0a406de0|1d1dda5d-5f15-42fa-a61d-e1f26cccbf6f|validated|8
np1-002|ea5b2011-36f4-4b57-8703-8030868c4e65|33cd1b57-477a-4ed5-988f-c6b4101c14f9|validated|8
np1-003|2e447d18-3dd7-4c78-9c94-c8d1f6e8175a|bf72f8ae-d7ba-4fa1-9396-e1d2516172fa|validated|9
np1-004|bcc12efb-7c37-4625-945d-9452d42d6d4d|d9aa6cdf-6e08-4c3b-a8d7-76094bc2f2fa|validated|9
np1-005|426b4c29-ca49-4090-9b43-0345e8c308ed|eb1f57bc-e5e9-4916-b7b0-65273df863cd|held|
np1-006|3a83f707-c52f-4301-bbce-4bf041548138|b8f1500b-8378-4e9f-9eef-bd5228e719cb|validated|8
np1-009|21800abf-c627-4f74-b05d-bce7c8f28f88|ae39bac6-a30c-43bb-b774-b97712687b21|validated|10
np1-010|3d7aefd8-9099-4b09-abbc-dff9cb74e1c1|6d3b2e63-94b2-4e3f-8e3e-4b26f36a9574|validated|8"""
from content28 import C
M={}
for l in meta.split('\n'):
    n,i,v,s,u=l.split('|'); M['apphycem-mcq-'+n]=dict(key='apphycem-mcq-'+n,item_id=i,version_id=v,label_status=s,max_required_unit=int(u) if u else None)
assert set(M)==set(C)
print(len(M), hashlib.md5('\n'.join(sorted(m['version_id'] for m in M.values())).encode()).hexdigest())
json.dump(M,open('meta_all.json','w'),indent=1)
tax=[(8,"Electric Charges, Fields, and Gauss's Law","8.1","Electric Charge and Electric Force"),(8,"","8.2","Conservation of Electric Charge and the Process of Charging"),(8,"","8.3","Electric Fields"),(8,"","8.4","Electric Fields of Charge Distributions"),(8,"","8.5","Electric Flux"),(8,"","8.6","Gauss's Law"),
(9,"Electric Potential","9.1","Electric Potential Energy"),(9,"","9.2","Electric Potential"),(9,"","9.3","Conservation of Electric Energy"),
(10,"Conductors and Capacitors","10.1","Electrostatics with Conductors"),(10,"","10.2","Redistribution of Charge between Conductors"),(10,"","10.3","Capacitors"),(10,"","10.4","Dielectrics"),
(11,"Electric Circuits","11.1","Electric Current"),(11,"","11.2","Simple Circuits"),(11,"","11.3","Resistance, Resistivity, and Ohm's Law"),(11,"","11.4","Electric Power"),(11,"","11.5","Compound Direct Current Circuits"),(11,"","11.6","Kirchhoff's Loop Rule"),(11,"","11.7","Kirchhoff's Junction Rule"),(11,"","11.8","Resistor Capacitor (RC) Circuits"),
(12,"Magnetic Fields and Electromagnetism","12.1","Magnetic Fields"),(12,"","12.2","Magnetism and Moving Charges"),(12,"","12.3","Magnetic Fields of Current-Carrying Wires and the Biot-Savart Law"),(12,"","12.4","Ampère's Law"),
(13,"Electromagnetic Induction","13.1","Magnetic Flux"),(13,"","13.2","Electromagnetic Induction"),(13,"","13.3","Induced Currents and Magnetic Forces"),(13,"","13.4","Inductance"),(13,"","13.5","Circuits with Resistors and Inductors (LR Circuits)"),(13,"","13.6","Circuits with Capacitors and Inductors (LC Circuits)")]
units=sorted({(u,t) for u,t,_,_ in tax if t})
json.dump(dict(units=[dict(n=u,title=t) for u,t in units],topics=[dict(code=c,title=t,unit=u) for u,_,c,t in tax],skills=[]),open('taxonomy.json','w'),indent=1,ensure_ascii=False)
seeds=[];packets=[];mathitems=[]
for k,(stem,ch) in C.items():
    m=M[k]; kl=[c[0] for c in ch if c[2]][0]
    seeds.append(dict(m,stem=stem,choices=[dict(choice_key=a,choice_text=b,is_correct=bool(c),rationale=d) for a,b,c,d in ch],keyed_label=kl))
    packets.append(dict(content_key=k,item_type='mcq',body=stem+"\n\nChoices:\n"+"\n".join(f"{a}. {b}" for a,b,_,_ in ch)))
    mathitems.append(dict(key=k,kind='mcq',stem=stem,choices=[dict(label=a,text=b) for a,b,_,_ in ch],keyed_label=kl,rationales={a:d for a,_,_,d in ch}))
json.dump(dict(all=list(M.values()),candidate_seeds=seeds),open('seeds_all.json','w'),indent=1,ensure_ascii=False)
json.dump(packets,open('packets_mcq.json','w'),indent=1,ensure_ascii=False)
json.dump(packets,open('packets_probe.json','w'),indent=1,ensure_ascii=False)
json.dump(mathitems,open('seeds_math_items.json','w'),indent=1,ensure_ascii=False)
