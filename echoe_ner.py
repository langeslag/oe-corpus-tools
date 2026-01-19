# This script extracts NER spellings from ECHOE.
# It expects ECHOE at echoe/.
# TODO: abbr/am not always nuked, spaces unduly removed

import re,glob,json
from lxml import etree

equivalents = {
        'ſ' : 's',
        '' : 's',
        'ẏ' : 'y',
        'ƿ' : 'w',
        'ꝛ' : 'r',
        ' ': '',
        '\n': ''
        }

def multipleReplace(text, wordDict):
    for key in wordDict:
        text = text.replace(key, wordDict[key])
    return text

parser = etree.XMLParser(remove_blank_text=True,resolve_entities=True)

forms = []

# For present purposes I just want the personal names, e.g. iohannes:
#categories = ['{http://www.tei-c.org/ns/1.0}persName', '{http://www.tei-c.org/ns/1.0}name', '{http://www.tei-c.org/ns/1.0}placeName']
categories = ['{http://www.tei-c.org/ns/1.0}persName']

for file in sorted(glob.glob('echoe/xml/[0-9]*.xml')):
    tree = etree.parse(file, parser=parser)
    root = tree.getroot()
    text = root.find('.//{http://www.tei-c.org/ns/1.0}text')
    version = root.find('.//{http://www.tei-c.org/ns/1.0}idno').text
    delenda = ['am', 'abbr', 'lb', 'corr', 'del', 'orig']
    for category in categories:
        for element in text.iter(category):
            for i in delenda:
                query = './/{http://www.tei-c.org/ns/1.0}' + i
            if element.find(query) is not None:
                loc = element.find(query)
                loc.getparent().remove(loc)
            name = multipleReplace(etree.tostring(element, method='text', encoding='unicode').lower().lstrip().rstrip(), equivalents)
            print(name)
            forms.append(name)

forms = list(set(forms))

with open('echoe_ner.json', 'w', encoding='utf-8') as outfile:
    json.dump(forms, outfile, ensure_ascii=False, indent=4)
