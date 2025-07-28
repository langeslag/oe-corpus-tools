# This script identifies Old English tokens in -es in ECHOE, and if they
# are not names or known parts of speech other than common noun, it prints
# them with a token window for manual sorting.

import os,glob,json

with open('../../ner_forms.json') as ner_file:
    ner = json.load(ner_file)

with open('../../ycoe_pos_simplified.json') as pos_file:
    pos = json.load(pos_file)

# I'm treating "dæges" and "nihtes" as adverbials whose genitive origin no longer matters.
# I'm keeping forms of "halig" because they're usually with reference to a saint.
ignore = [
        'þærrihtes',
        'þærihtes',
        'celnes',
        'sices',
        'guardones',
        'selfwilles',
        'dryges',
        'dæges',
        'dæiges',
        'dages',
        'nihtes',
        'willes',
        'unwilles',
        'rihtwysnes',
        'efnes',
        'wænsumnes',
        'hreownes',
        'modines'
        ]

data = dict()

for infile in glob.glob('../../echoe-plaintext/309*txt'):
    version = os.path.basename(infile).replace('.txt', '')
    print(version)
    matches = []
    lines = open(infile).readlines()
    for line in lines:
        if line == '':
            continue
        else:
            line_tokens = line.split()
            for idx,token in enumerate(line_tokens):
                if token[-2:] == 'es':
                    if token not in ner and token not in ignore:
                        if (token in pos and pos[token] == 'N') or token not in pos:
                            window = ''
                            for context in (4, 3, 2, 1):
                                if idx < context:
                                    continue
                                else:
                                    window = window + line_tokens[idx-context] + ' '
                            window = window + token.upper() + ' '
                            for context in range(4):
                                if len(line_tokens) - idx - 2 < context:
                                    continue
                                else:
                                    window = window + line_tokens[idx+context+1] + ' '

                            print(window)
                            matches.append(window)
                            data[version] = window
