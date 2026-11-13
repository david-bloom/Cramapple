import json,sys
u=int(sys.argv[1])
for r in json.load(open('current.json')):
    if r['unit_number']==u:
        print('=====',r['topic_code'])
        for f in ['core_idea','what_students_need_to_understand','how_this_becomes_points','point_attaining_answer','mini_example_question']:
            print(f[:6].upper(),':',r[f])
