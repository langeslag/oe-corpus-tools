# This script will replace attsp.sh
# but is as yet under development.
# Copyright Paul Langeslag 2026
import json,re
from pathlib import Path
from bs4 import BeautifulSoup

html_folder = Path.cwd() / 'doe'
target_folder = Path.cwd() / 'attsp'
target_folder.mkdir(exist_ok=True)

cuts = [
        'Gen.pl. with m./n.dat.sg. or dat.pl. inflection',
        'Dat.pl. with dat.pl. inflection',
        'Att. sp.: ',
        'Compar.: ',
        'Late: ',
        'Rarely',
        'Abbrev. forms in glosses: ',
        'Corrupt form in a gloss: ',
        'Strong Adjective:',
        'Weak Adjective',
        'Northumbrian paradigm',
        'Forms without final n',
        'Unambiguous wk. 2 forms',
        'Endingless in acc.sg.',
        'Spellings in eg- are mainly North',
        'The manuscript is damaged and difficult to read',
        'excluding all forms found also with other dialect groupings',
        'but the last letter is doubtful',
        'Spellings with -z- are found in MSS of s. x med. and later',
        'bedupe. Forms with -pt-',
        'pð could also be taken s.v. bedyppan',
        'in a number of citations confusion is attested in the variants',
        'Some forms in gearn- / georn- may alternatively be taken as forms of earnian with initial g',
        'For unambiguously weak forms',
        'occas. in s.xii MSS',
        'see cwene',
        'With metathesis',
        '-ei- spellings are Northumbrian',
        'confessor may be either OE or Lat',
        'Forms with medial n predominate in Ælfric',
        'Spellings in eæll- are mainly in PsGlE',
        'Spellings in æl-',
        'the combining form of eall',
        'for other gr- spellings',
        'With ǣ-',
        'cf. gringwræce s.v. cringan',
        'Masculine',
        'Neuter',
        'Feminine',
        'wk.gen.pl.',
        'nom.sg.',
        'acc.sg. - ',
        'gen.sg. - ',
        'gen.sg. ',
        'dat.sg. - ',
        'dat.sg. ',
        'nom./acc.sg.',
        'nom./acc.pl.',
        'both acc.pl.',
        'acc.pl.',
        'gen.pl.',
        'dat.pl.',
        'M. wk. with t',
        'gender',
        'With contr.',
        'Forms with -dd-',
        'With -swæc',
        'With -spæc',
        'Redupl. pret.',
        'ðone onsione',
        'expanded as ',
        'm. more common',
        'IE bheu-',
        'IE wes-',
        'IE es-',
        'PGerm. ar-',
        'M. cl. 3 (pl.)',
        'Wk. m ',
        'Wk. 1',
        'St. pl.',
        'In sg.',
        'cl. 4',
        'wk.',
        'Wk.',
        'M. or N.',
        'M.',
        'N.',
        'F.',
        ',',
        ':',
        ';',
        '='
]

regex = [
        (r'In late OE some forms of onbīdan with prefix.*$', ''),
        (r'^Anom\. form: ᚹ.*$', ''),
        (r'firgingatā \(\? -ā for -ena, \? -ā for -am\), ', 'firgingatā firgingatena firgingatam'),
        (r'awifte \(with w for p\)', 'awifte apifte'),
        (r' \(both for dat\.sg\. ametenum\)', 'ametenum'),
        (r'hweoga \(with g for þ.*\)', 'hweoga hweoþa'),
        (r'confusion with ǣghwæðer.*$', ''),
        (r'adjectival inflectional endings are added to gen.sg.', ''),
        (r'and dat.pl. forms. Genitives formed in this way generally decline as possessive adjectives', ''),
        (r'and case. The motivation behind doubly inflected dative pl. forms is unclear', ''),
        (r'but these may have been invented in order to disambiguate dat.pl. heom', ''),
        (r'agreeing with the modified noun in number', ''),
        (r'see scǣ', ''),
        (r'ða (bydel)', r'\1'),
        (r'brim faro. ðæs', 'brimfaro'),
        (r'(bradeleaces). Final e in composition is unique to this compound of brad', r'\1'),
        (r'bituinf letnise', 'bituinfletnise'),
        (r'the word has been read as (betothecd)', r'\1'),
        (r'brondas ðencan', ''),
        (r'For forms of the f.nom.sg. 3rd pers. pronoun beginning in sc$', ''),
        (r'\(cipher for ([^,]*), [^)]*\)', r'\1'),
        (r'(geembehte) ðu', r'\1'),
        (r'(ƀ(scop)?) ChronF\)', r'\1'),
        (r'((ge)?anlich?ie) we', r'\1'),
        (r'(nage) we', r'\1'),
        (r'ðone (eage)', r'\1'),
        (r'ᚪ ᛚ ᛗ ᛖ ᛇ ᛏ ᛏ ᛁ ᚷ', 'ᚪᛚᛗᛖᛇᛏᛏᛁᚷ'),
        (r'menn cyni', 'menncyni'),
        (r'(aldor) \.\.\. (sacerdæs)', r'\1\2'),
        (r'(aldor) \.\.\. (sacerda)', r'\1\2'),
        (r'(efne) \.\.\.(acunn)', r'\1\2 \2'),
        (r'(alduras) (sacerdas)', r'\1\2'),
        (r'(dagae) note that endingless forms are also common', r'\1'),
        (r'gedæled edlice', 'gedælededlice'),
        (r'se (ansine)', r'\1'),
        (r'Standard Paradigm (deoflu)', r'\1'),
        (r'Jun. Transcr. 71 (ægewriteras)', r'\1'),
        (r'(egewritteras) and scepttenras have been suggested as possible readings', r'\1'),
        (r'm.pl. (deoflas) in Aldred', r'\1'),
        (r'(afyrsað). -eo- spellings occur in Psalters FGK', r'\1'),
        (r'(ædeawado). Past tense forms perhaps show influence of wk. 2 on wk. 1', r'\1'),
        (r'The spelling ǣrendwreca is etymological.*explanation, narrative’', ''),
        (r'a (æsnungdrenceas)', r'\1'),
        (r'wesan (draegtre)', r'\1'),
        (r'\(for ([^,]*), [^)]*\)', r'\1'),
        (r'\(prob\. for ([^,]*), [^)]*\)', r'\1'),
        (r'\(\?? ?miswritten for ([^,]*), [^)]*\)', r'\1'),
        (r'\(\?? ?in error for ([^,]*), [^)]*\)', r'\1'),
        (r'\(= ([^,]*) for ([^,]*), [^)]*\)', r'\1 \2'),
        (r'\([^)]{0,20}\? for ([^,]*), [^)]*\)', r'\1'),
        (r' \([A-ZÆÞÐa-zæþðāǣēīōūȳĀǢĒĪŌŪȲ0-9., ]+\)', ''),
        (r'b[ei]o ge', ''),
        (r'(derb) s', r'\1'),
        (r'se (druncnesse)', r'\1'),
        (r'se (burhwaru)', r'\1')

]

spaces = [
        ' ||| ',
        ' || ',
        ' | ',
        ', '
        '; ',
        ' or '
]

entries = dict()
for entry in html_folder.glob('*.html'):
    ref = entry.name[:-5]
    print(ref)
    with open(entry) as html_file:
        soup = BeautifulSoup(html_file, 'html.parser')

    lemma_node = soup.find('div', class_=['doe-hd', 'doe-sub', 'doe-affix'])
    lemma = lemma_node.get_text().strip('\n')
    pos_node = soup.find('div', class_=['doe-pos'])
    if pos_node is None:
        pos = ''
    else:
        pos = pos_node.get_text()
    occ_node = soup.find('div', class_=['doe-occ'])
    if occ_node is None:
        occ = ''
    else:
        occ = occ_node.get_text()
    spelling_strings = [i.get_text().rstrip('.') for i in soup.select('div[class^="doe-attsp"]')]
    spellings = []
    for line in spelling_strings:
        for pattern in spaces:
            line = line.replace(pattern, ' ')
        for pattern,replacement in regex:
            line = re.sub(pattern, replacement, line)
        for pattern in cuts:
            line = line.replace(pattern, '')
        spellings.extend(line.split())

    entry_dict = {
            'lemma': lemma,
            'pos': pos,
            'freq': occ,
            'attsp': spellings
            }
    entries[ref] = entry_dict

with open('attsp.json', 'w', encoding='utf-8') as output:
    json.dump(entries, output, ensure_ascii=False, indent=4)
