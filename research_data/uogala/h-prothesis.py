# This script serves to help readers of my article "The Case Against English
# Elements in _Hebban olla uogala_" reproduce my findings. It expects a JSON
# index of attested spellings in the grantparent directory named `attsp.json`,
# generated with `attsp.sh` on the basis of the DOE A--H CD-ROM, and it
# requires a plaintext corpus in the directory `../../doec-plaintext/`. It
# outputs a list of DOE headwords beginning with "a" that are attested with
# initial "h", as well as all matches of those forms in the corpus.
# (C) P. S. Langeslag 2025.

import json,re,subprocess,os

with open('../../attsp.json') as f:
    data = json.load(f)

matches = dict()
counter = 0
for k,v in data.items():
    if v['lemma'][0] == 'a' or v['lemma'][0] == 'ā':
        counter += 1
        lemma = v['lemma']
        h_forms = list()
        for form in v['forms']:
            if form[0] == 'h':
                h_forms.append(form)
        if len(h_forms) > 0:
            matches[lemma] = h_forms

with open('h-prothesis.txt', 'w') as f:
    for k,v in matches.items():
        forms = ','.join(v)
        f.write(k + ': ' + forms + '\n')

print("The total number of lexemes starting with <a> or <ā> is " + str(counter) + ".")

search_path = '../../doec-plaintext/'
with open('h-prothesis-doec.txt', 'w') as f:
    os.chdir(search_path)
    for k,v in matches.items():
        f.write('##############################################################################\n')
        f.write(k + ': reported prothetic forms yield the following hits in DOEC:\n')
        f.write('------------------------------------------------------------------------------\n')
        for form in v:
            regex = r'"\(\W\|^\)' + form + r'\(\W\|$\)"'
            try:
                p = subprocess.check_output('grep -i ' + regex + ' ' + '*txt', shell=True, stderr=subprocess.STDOUT)
            except subprocess.CalledProcessError as e:
                p = None
                output = str(e.output)
            if p is not None:
                f.write(p.decode())
