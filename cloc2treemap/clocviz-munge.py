#!/usr/bin/env python2

import json
import sys
import os
import os.path

j = json.loads(sys.stdin.read())

langs = {'_':0}
dirs = {}
entries = [ ['Path', 'Parent', 'Lines of Code', 'Lang Num'] ]

for filepath in j:
    if filepath in ['header', 'SUM']:
        continue
    e = j[filepath]

    lang = e['language']
    if not lang in langs:
        langs[lang] = len(langs)

    d = os.path.dirname(filepath)
    if not d in dirs:
        dirs[d] = True

    parent = d
    entries.append( [filepath, parent, e['code'], langs[lang]] )



# copy dirs so we have separate structures to iterate & mutate
#alldirs = {x:dirs[x] for x in dirs}
alldirs = {}

for d in dirs:
    #print '               ', d
    #alldirs[d] = True
    #entries.append( [d, p, 0, 0] )

    while len(d) > 1:
        p = os.path.dirname(d)
        if (d,p) in alldirs:
            #print (d,p)
            d = ''
            continue # outer, i.e. break inner
        alldirs[(d,p)] = True
        #print d, ' => ', p
        entries.append( [d, p, 0, 0] )
        d = p

print json.dumps([langs, entries])

