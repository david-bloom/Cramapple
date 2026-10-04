import json,hashlib
meta="""001|49216c78-1683-42f6-80b6-b5c99d628ecd|db2e6c78-ef6f-46a1-a4fb-1dbbb906f2e6|validated|1
002|9a2e21c9-ceff-441a-a2f1-7f17603eab13|7cfdacff-5cb8-417c-9e45-0cd579e98c76|validated|1
003|2125d5ea-c76d-41ca-8838-22572a9920b3|afa57d5f-9865-4994-abe8-5417da1b27db|validated|3
006|b9f5988a-a8c6-4324-90a0-99cc6ab57bca|1bf78f57-14be-4400-8f4a-ef79e6f7b01d|validated|3
007|085b45f0-2248-48fd-9104-4038ec9bb2b7|ae4db131-c654-4d7a-a9c7-7b54e994341c|validated|3
008|0603f412-3808-4082-af54-b19aa2ea4643|856ead17-947c-4e0f-9592-a2da10b0ade6|validated|3
012|6e169389-a30a-4cd4-92f4-d947387103be|6deeda4a-51fc-4932-a515-dc302ff2e27a|held|
017|a781979a-51b9-4b6a-9679-ad06183c657c|69deeb0b-611a-45fd-8e64-defec3e092f4|validated|1
018|67f8e9d0-4063-43c2-9607-4b1a9bed54ac|9604811c-40a7-46b2-9340-80f09c38e5d0|validated|3
019|67f466af-2862-459b-af0a-727efef8ca6a|b7f33d69-7a41-42ba-9455-eb46472604f3|held|
020|678c4049-218c-42b7-8b14-3ca850779da0|f415f38a-4f86-4254-92a2-51b3687c44d5|held|
021|34d30618-f4d3-486a-bd92-caf104f5d2cd|2b6e1aa8-7f08-43b1-b7f0-fffa0bbe380d|validated|1
022|132b19a5-db85-4e31-a6dd-07851bea0607|b7950289-62d4-4275-9b06-bcf1e5523221|validated|1
023|80434433-3897-4798-9181-7139b229d2ad|18ada83c-3177-4506-b8b6-1200358df615|held|
024|3b320224-1d60-4607-b022-10d9826f7be3|54867242-0e93-4bf4-81d1-a54d044bc394|validated|3
025|7f23d57d-6a62-4045-a414-5be3bba42198|c6bc1dcb-e4be-4a4a-bdcf-cf908d8aff43|validated|2
026|58c63e7c-a817-4be5-9bfb-12abbacfd94f|20aa73d9-a25a-4836-a602-ba540df33334|validated|2
027|e6811540-a8d9-42cb-a2a2-e198fdae058c|a9e501c1-c9e1-4237-b40f-07cee0b30fb3|validated|3
028|dc15de4e-04ba-4564-b953-b8953cc11c5b|6876d1f1-f40b-4415-beb3-bae7898459ff|validated|3
029|71e98913-c701-404f-88ca-718d8fcfc9f8|4276e4d3-afac-4f10-8232-1c1c05f563f8|validated|3
030|ce618e84-b717-41aa-9fbc-ab4eac297ecc|dc3bec4a-550a-47d9-85f3-7eedc09c996f|validated|3
031|401c3359-45d8-487e-b3ff-6d70200ecce8|53067725-5cab-4423-b089-fa4992dba508|held|
034|9bc8d593-3dfd-4bef-adac-3c22c208c531|ba6e8551-c83d-4c81-8844-09674b2f42cc|held|
040|8b32d1e8-cc78-47e3-bea9-c6d90286c2d9|a6ce6f27-2a89-4fdb-bd4f-e462b7c09f73|held|"""
M={}
for l in meta.split('\n'):
    n,i,v,s,u=l.split('|'); M['apphycm-mcq-'+n]=dict(key='apphycm-mcq-'+n,item_id=i,version_id=v,label_status=s,max_required_unit=int(u) if u else None)
json.dump(M,open('meta_all.json','w'),indent=1)
md5=hashlib.md5('\n'.join(sorted(m['version_id'] for m in M.values())).encode()).hexdigest()
print(len(M),md5); assert md5=='1f4a121f2e2640320baaf4389c7bcd27'  # DB: md5(string_agg(version_id order by id::text, E'\n'))
from content24 import C
units=[(1,"Kinematics"),(2,"Force and Translational Dynamics"),(3,"Work, Energy, and Power"),(4,"Linear Momentum"),(5,"Torque and Rotational Dynamics"),(6,"Energy and Momentum of Rotating Systems"),(7,"Oscillations")]
T={1:["Scalars and Vectors","Displacement, Velocity, and Acceleration","Representing Motion","Reference Frames and Relative Motion","Motion in Two or Three Dimensions"],
2:["Systems and Center of Mass","Forces and Free-Body Diagrams","Newton's Third Law","Newton's First Law","Newton's Second Law","Gravitational Force","Kinetic and Static Friction","Spring Forces","Resistive Forces","Circular Motion"],
3:["Translational Kinetic Energy","Work","Potential Energy","Conservation of Energy","Power"],
4:["Linear Momentum","Change in Momentum and Impulse","Conservation of Linear Momentum","Elastic and Inelastic Collisions"],
5:["Rotational Kinematics","Connecting Linear and Rotational Motion","Torque","Rotational Inertia","Rotational Equilibrium and Newton's First Law in Rotational Form","Newton's Second Law in Rotational Form"],
6:["Rotational Kinetic Energy","Torque and Work","Angular Momentum and Angular Impulse","Conservation of Angular Momentum","Rolling","Motion of Orbiting Satellites"],
7:["Defining Simple Harmonic Motion (SHM)","Frequency and Period of SHM","Representing and Analyzing SHM","Energy of Simple Harmonic Oscillators","Simple and Physical Pendulums"]}
topics=[dict(code=f"{u}.{i+1}",title=t,unit=u) for u in T for i,t in enumerate(T[u])]
json.dump(dict(units=[dict(n=u,title=t) for u,t in units],topics=topics,skills=[]),open('taxonomy.json','w'),indent=1,ensure_ascii=False)
seeds=[];packets=[];mathitems=[]
for k,(stem,ch) in C.items():
    m=M[k]; kl=[c[0] for c in ch if c[2]][0]
    seeds.append(dict(m,stem=stem,choices=[dict(choice_key=a,choice_text=b,is_correct=bool(c),rationale=d) for a,b,c,d in ch],keyed_label=kl))
    body=stem+"\n\nChoices:\n"+"\n".join(f"{a}. {b}" for a,b,_,_ in ch)
    packets.append(dict(content_key=k,item_type='mcq',body=body))
    mathitems.append(dict(key=k,kind='mcq',stem=stem,choices=[dict(label=a,text=b) for a,b,_,_ in ch],keyed_label=kl,rationales={a:d for a,_,_,d in ch}))
json.dump(dict(published_mcq_count=24,version_id_md5=md5,all=list(M.values()),candidate_seeds=seeds),open('seeds_all.json','w'),indent=1,ensure_ascii=False)
json.dump(packets,open('packets_mcq.json','w'),indent=1,ensure_ascii=False)
json.dump(mathitems,open('seeds_math_items.json','w'),indent=1,ensure_ascii=False)
print(len(seeds))
