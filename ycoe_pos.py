# This script extracts POS frequency counts from all terms in YCOE,
# but renames some of the labels in accordance with ParCorOEv3. It
# outputs both a frequency-ranked JSON and a simplified JSON giving
# only the most frequent label.
# Copyright (C) 2025 Paul Langeslag

import json,re
from nltk.corpus.reader.ycoe import YCOECorpusReader
root = '/home/paul/ebooks/Corpora/ycoe/'
ycoe = YCOECorpusReader(root)

def normalize(w):
    substitutions = {'+a': 'æ', '+t': 'þ', '+d': 'ð', '+A': 'Æ', '+T': 'Þ', '+D': 'Ð', '&': 'and', '$': ''}
    for k, v in substitutions.items():
        w = w.replace(k, v).lower()
    return w

def relabel(pos):
    substitutions = {
            '^NR$': 'PROPN',    # proper noun
            '^CONJ$': 'CCONJ',  # coordinating conjunction
            '^PRO\$*$': 'PRON', # personal pronoun; possessive
            '^Q.*$': 'DET',     # quantifier
            '^D$': 'DET',       # determiner
            '^ADJ.$': 'ADJ',    # adjective
            '^ADV.$': 'ADV',    # adverb
            '^NEG$': 'PART',    # (negating) particle
            '^FP$': 'ADV',      # focus particle (āna, huru, furþon)
            '^RP+VB.*$': 'VERB', # adverbial particle enclitic plus verb
            '^BE.*$': 'BE',     # be; keeping that because it is significant
            '^BAG$': 'BE',      # be; keeping that because it is significant
            '^HV.*$': 'VERB',   # habban; not in Nerthus
            '^HAG$': 'VERB',    # habban; not in Nerthus
            '^AX.*$': 'AUX',    # auxiliary
            '^MD.*$': 'MOD',    # modal
            '^VB.*$': 'VERB',   # verb
            '^FW$': 'X',        # foreign word
            '^WPRO$': 'PRON',   # wh-pronoun
            '^WADJ$': 'ADJ',    # wh-adjective
            '^WADV$': 'ADV',    # wh-adverb
            '^WQ$': 'ADV'       # "WHETHER", simplifying here; Nerthus yields ADV:4, SCONJ:2, CCONJ:1
                                # Keeping YCOE's C=complementizer because it doesn't match a Nerthus category cleanly
                                # Keeping YCOE's P=preposition/subordinating conj because it doesn't match a Nerthus category cleanly

}
    for k, v in substitutions.items():
        pos = re.sub(k, v, pos)
    return pos

data = dict()

for token in ycoe.tagged_words():
    if token[0] not in '.:;,!?':
        norm = normalize(token[0])
        if token[1] is None:
            continue
        pos = token[1].split('^')[0]
        if norm in data:
            if pos in data[norm]:
                data[norm][pos] += 1
            else:
                data[norm][pos] = 1
        else:
            data[norm] = dict()
            data[norm][pos] = 1

for k,v in data.items():
    data[k] = dict(sorted(data[k].items(), key=lambda item: item[1], reverse=True))

with open('ycoe_pos.json', 'w', encoding='utf-8') as outfile:
    json.dump(data, outfile, ensure_ascii=False, indent=4)

simplified = dict()
for k,v in data.items():
    if len(data[k]) == 1:
        simplified[k] = list(data[k])[0]
    else:
        if list(data[k].values())[0] / list(data[k].values())[1] > 5:
            simplified[k] = list(data[k])[0]
        else:
            simplified[k] = list(data[k])[0] + '^' + list(data[k])[1]

with open('ycoe_pos_simplified.json', 'w', encoding='utf-8') as outfile:
    json.dump(simplified, outfile, ensure_ascii=False, indent=4)

print("OK done.")
