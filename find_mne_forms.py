# This script identifies tokens in the Dictionary of Old English A--H
# attested spelling fields that are Present-Day English and adds them
# to a list of forms to exclude from a list of Old English forms, but
# if they are also found in OE form lists previously based on the same
# resource it adds the respective headwords to the output JSON.
# Requires aspell and its dependencies, and its English dictionaries;
# see the rather poor documentation on GNU aspell.
import re,json
from pathlib import Path
from bs4 import BeautifulSoup
import enchant

b = enchant.Broker()
b.set_ordering('en_CA', 'aspell,myspell')
b.request_dict('en_CA')

html_folder = Path.cwd() / 'doe'

# Sequences to be replaced by a space wherever thy occur:
spaces = [
        ' ||| ',
        ' || ',
        ' | ',
        ', '
        '; ',
        ' or '
]

# We'll add in a few forms manually that are either missed by aspell
# or are not Modern English but require a list of exceptions:
additions = {
        "above": [],
        "ge": ['ǣ', 'ge, gei', 'gē pron.', 'ge conj.', 'gēa', 'ge·hwilcnes'],
        "gender": [],
        "prose": [],
        "scribe": [],
        "wynn": [],
        "ᚹ": [],
        "xiv": []
        }

with open('attsp_inverted_old.json') as json_data:
    attsp_inverted = json.load(json_data)

def extract():
    all_spellings = []
    for entry in html_folder.glob('*.html'):
        ref = entry.name[:-5]
        print(ref)
        with open(entry) as html_file:
            soup = BeautifulSoup(html_file, 'html.parser')
    
        lemma_node = soup.find('div', class_=['doe-hd', 'doe-sub', 'doe-affix'])
        lemma = lemma_node.get_text().strip('\n')
        pos_node = soup.find('div', class_=['doe-pos'])
        spelling_strings = [i.get_text().rstrip('.') for i in soup.select('div[class^="doe-attsp"]')]
        spellings = []
        for line in spelling_strings:
            for pattern in spaces:
                line = line.replace(pattern, ' ')
            spellings.extend(line.split())
        spellings = list(set(spellings))
        purged_spellings = list(set([form for form in spellings 
                            if re.search("^[a-zþæðęłœøƀāēīōūȳ\u16A0-\u16FF]+$", form)
                            ]))
        all_spellings.extend(purged_spellings)
    all_spellings = sorted(list(set(all_spellings)))
    english_forms = dict()
    d = enchant.Dict("en_CA")
    for spelling in all_spellings:
        # If form is valid Canadian English, add it to the list for exclusion in attsp.py:
        if d.check(spelling) and re.search("^[a-z]+$", spelling):
            english_forms[spelling] = []
            # But if it is additionally a known OE form, add the matching headwords:
            if spelling in attsp_inverted:
                english_forms[spelling] = [i[1] for i in attsp_inverted[spelling]]
    for k,v in additions.items():
        english_forms[k] = v

    with open('pde.json', 'w', encoding='utf-8') as output:
        json.dump(english_forms, output, ensure_ascii=False, indent=4)
    
if __name__ == '__main__':
    extract()
