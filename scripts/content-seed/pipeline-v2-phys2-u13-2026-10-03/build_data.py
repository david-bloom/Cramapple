import json,hashlib
meta="""001|994e2cfa-2d5a-4e82-8933-3463a59c1bf7|da82cdbc-afc0-4e9c-85b1-a6c10b5eb761|held|
002|72bf6cc1-53d7-45ec-bddf-2229f0d55b13|79a6b93d-55d9-4ae0-b884-4dd334e8dfac|validated|9
003|de575f7c-5aeb-4268-8b2e-cdd37c0f3596|70984727-0772-45e4-a04a-8ee28c582513|validated|9
004|7e016f9a-a5bd-4721-95ab-b433eec050a4|0e153951-2152-4c66-9e46-947b7c72a92a|validated|10
005|f89b3306-f71c-47fa-be5b-e5c1bd028d3a|58f46bfd-3a78-43b4-a6fe-30f506e84c75|validated|10
006|6e7c80ae-eab3-4f51-aab7-d25d77f4d2e8|a437632c-4747-43f4-bc98-86f4bd5f490e|validated|10
007|705667c4-c2ee-4abd-9efc-1d2981452798|3f988f70-a49e-4a96-a66a-2cd9e9afedd5|validated|11
008|da6a4a08-e8ed-4f40-9687-7115b883ae49|ff54dff1-7b63-4f09-864e-88125f0638da|validated|11
009|3e40c1c8-7971-431e-8a26-067e96281ff7|b8dd7e16-c158-4213-8642-0fa0b878af86|validated|11
010|65a74e55-1f56-4d8f-8443-fbf504027015|80ab716d-cb3c-4226-a9c2-627e21309f9e|validated|12
012|f65ed739-b183-488f-b787-3cde35d5a564|f8952991-b8db-4914-89a9-0a537f6ec5ae|validated|12
013|af9559fe-b7ea-4140-a870-0371f675bb15|6d4fc26b-a60d-4fc0-83e5-9f272a68994c|validated|14
014|3434fe02-560c-40a1-a93a-7fd0ada453ab|d1204237-373b-4ad7-a36c-803c6656cfd9|validated|13
015|8209410c-4fa0-4932-8d34-c5b23cbc7e9b|d049cddb-a291-4bd2-afa1-2bd25588d376|validated|13
016|716fafdd-ba1f-4c69-93ab-5a6d98be0e09|9d1fee80-d912-43d6-8746-f2795f09787b|validated|14
017|c0d999a1-9393-4f03-ab6f-359b13c63671|0975e43b-f228-403c-8b10-3bb449942a51|validated|14
019|52eb871e-13e8-4e28-9578-0f5c7eea1825|21247dc8-cf80-4098-b5bc-a84792d7ca10|held|
020|295f27ef-806c-404b-827d-fda2cc0eb474|eeae7b54-8e4a-4a14-bb34-d2c46a628fc0|validated|15
021|c4ac07e7-d1fb-47ab-9509-4311f00e2965|798ef9d6-60f6-44b1-91d4-586756066360|validated|9
022|cabc07e1-be3d-4936-a768-640c12067b61|d8be3521-4876-4b15-97ae-16aced23753a|validated|9
023|23474684-1d5f-40ae-b28a-28331540f2d7|c4991223-bfc1-4484-985f-1a9916cb4513|validated|9
024|771d98b7-e06a-470e-966b-5b1920d6eea4|aef222f0-de71-41ad-8e4a-67aff59afe92|validated|10
025|152502ad-6fe0-43dc-b264-c1ce61186fcb|8b4127b8-7472-456c-bb72-df136bbd5896|validated|10
026|3574bc1f-4a7e-4a75-89ef-0558567a3db0|7531ab19-6d04-4235-8f80-e9468fa5f048|validated|10
027|c8030902-7020-47b5-8b74-a78213f0c84d|2661f0f4-ab40-4e36-8069-f3c67a278cbb|validated|11
028|84e3b17a-210d-44b7-90ba-f4b4703f479d|478b5762-d4b2-4c77-b73c-34cfe38ca585|validated|11
029|3181ec59-9dc2-46ae-a35d-2a0c394f1869|0714f061-39d4-477c-937d-5d544bd089db|validated|11
030|84d26421-3b56-4b66-81ef-37c8255ee022|6bdafdc6-94e1-4d2b-a304-cd2487a7af30|validated|11
031|658a2709-788e-43a8-a60a-4ce5ce1a1d37|904498ef-0e49-49f1-99d5-98c5c53deb7b|validated|12
032|e29f8faa-83a8-44d5-bcef-bac6e4c28c8b|9add92ae-19a8-4b53-aaeb-24362f0f4842|validated|12
033|56dd5547-d962-43f5-a606-5bf24816e0d7|5664df1f-203d-47f1-a544-227bbf2bfeb6|validated|12
034|f263529b-09d8-4280-9138-81480725f788|1124f048-e37b-4337-9cb6-b3305820973b|validated|13
035|ac61964d-0b59-456f-9f40-cb6cb870b1da|baebe382-6429-4f75-a28f-e0e40e964daa|validated|13
036|e3181a08-cfd4-45af-bfba-9e9e4f9db615|1ff33c89-a38e-43f1-b83d-88261d6ba0ac|validated|13
037|7e735839-c531-4c43-be6f-3e5a07868695|f9bd3c8d-0ee2-4783-902f-e721a867b065|validated|14
038|2825ba0a-2344-4b39-820a-afc7ab218164|81d4eb9c-d8b7-4df1-a229-8abd0aab3af3|validated|14
039|a1da27c2-6af7-49b4-bd89-e297a171e8ba|d7a58c0f-488b-4eae-946a-2bb6223f4e20|validated|14
040|b79ad532-0f8f-4e24-b8c2-a8f53ff08878|c0cf1fa7-2e01-4dca-85e2-6e1dad5bb9b4|validated|15
041|2970f68c-0ef6-4195-be44-63127fb43212|88061f49-923f-46f4-830c-ad9ef63db3d8|validated|15
042|e60d9d30-6ffe-4caf-ac00-0c6748c20a0c|425aa4fb-4a89-4c9a-965f-024d59f67674|validated|15"""
M={}
for l in meta.split('\n'):
    n,i,v,s,u=l.split('|'); M['apphy2-mcq-'+n]=dict(key='apphy2-mcq-'+n,item_id=i,version_id=v,label_status=s,max_required_unit=int(u) if u else None)
json.dump(M,open('meta_all.json','w'),indent=1)
print(len(M), hashlib.md5('\n'.join(sorted(m['version_id'] for m in M.values())).encode()).hexdigest())

from content20 import C
tax=[
(9,"Thermodynamics","9.1","Kinetic Theory of Temperature and Pressure"),(9,"","9.2","The Ideal Gas Law"),(9,"","9.3","Thermal Energy Transfer and Equilibrium"),(9,"","9.4","The First Law of Thermodynamics"),(9,"","9.5","Specific Heat and Thermal Conductivity"),(9,"","9.6","Entropy and the Second Law of Thermodynamics"),
(10,"Electric Force, Field, and Potential","10.1","Electric Charge and Electric Force"),(10,"","10.2","Conservation of Electric Charge and the Process of Charging"),(10,"","10.3","Electric Fields"),(10,"","10.4","Electric Potential Energy"),(10,"","10.5","Electric Potential"),(10,"","10.6","Capacitors"),(10,"","10.7","Conservation of Electric Energy"),
(11,"Electric Circuits","11.1","Electric Current"),(11,"","11.2","Simple Circuits"),(11,"","11.3","Resistance, Resistivity, and Ohm's Law"),(11,"","11.4","Electric Power"),(11,"","11.5","Compound Direct Current (DC) Circuits"),(11,"","11.6","Kirchhoff's Loop Rule"),(11,"","11.7","Kirchhoff's Junction Rule"),(11,"","11.8","Resistor-Capacitor (RC) Circuits"),
(12,"Magnetism and Electromagnetism","12.1","Magnetic Fields"),(12,"","12.2","Magnetism and Moving Charges"),(12,"","12.3","Magnetism and Current-Carrying Wires"),(12,"","12.4","Electromagnetic Induction and Faraday's Law"),
(13,"Geometric Optics","13.1","Reflection"),(13,"","13.2","Images Formed by Mirrors"),(13,"","13.3","Refraction"),(13,"","13.4","Images Formed by Lenses"),
(14,"Waves, Sound, and Physical Optics","14.1","Properties of Wave Pulses and Waves"),(14,"","14.2","Periodic Waves"),(14,"","14.3","Boundary Behavior of Waves and Polarization"),(14,"","14.4","Electromagnetic Waves"),(14,"","14.5","The Doppler Effect"),(14,"","14.6","Wave Interference and Standing Waves"),(14,"","14.7","Diffraction"),(14,"","14.8","Double-Slit Interference and Diffraction Gratings"),(14,"","14.9","Thin-Film Interference"),
(15,"Modern Physics","15.1","Quantum Theory and Wave-Particle Duality"),(15,"","15.2","The Bohr Model of Atomic Structure"),(15,"","15.3","Emission and Absorption Spectra"),(15,"","15.4","Blackbody Radiation"),(15,"","15.5","The Photoelectric Effect"),(15,"","15.6","Compton Scattering"),(15,"","15.7","Fission, Fusion, and Nuclear Decay"),(15,"","15.8","Types of Radioactive Decay")]
units=sorted({(u,t) for u,t,_,_ in tax if t})
json.dump(dict(units=[dict(n=u,title=t) for u,t in units],topics=[dict(code=c,title=t,unit=u) for u,_,c,t in tax]),open('taxonomy.json','w'),indent=1,ensure_ascii=False)
seeds=[];packets=[];mathitems=[];probe=[]
for k,(stem,ch) in C.items():
    m=M[k]; kl=[c[0] for c in ch if c[2]][0]
    seeds.append(dict(m,stem=stem,choices=[dict(choice_key=a,choice_text=b,is_correct=bool(c),rationale=d) for a,b,c,d in ch],keyed_label=kl))
    body=stem+"\n\nChoices:\n"+"\n".join(f"{a}. {b}" for a,b,_,_ in ch)
    packets.append(dict(content_key=k,item_type='mcq',body=body))
    mathitems.append(dict(key=k,kind='mcq',stem=stem,choices=[dict(label=a,text=b) for a,b,_,_ in ch],keyed_label=kl,rationales={a:d for a,_,_,d in ch}))
json.dump(dict(published_mcq_count=40,version_id_md5='47862ef21754dad62efdf528f8797ad7',all=list(M.values()),candidate_seeds=seeds),open('seeds_all.json','w'),indent=1,ensure_ascii=False)
json.dump(packets,open('packets_mcq.json','w'),indent=1,ensure_ascii=False)
json.dump(packets,open('packets_probe.json','w'),indent=1,ensure_ascii=False)
json.dump(mathitems,open('seeds_math_items.json','w'),indent=1,ensure_ascii=False)
print(len(seeds))
