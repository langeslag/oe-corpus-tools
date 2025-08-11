# This script extracts NER spellings from ECHOE.
# It expects ECHOE at echoe/.
# TODO: descend into <w> and nuke all spacing there.

import re,glob,json
from lxml import etree

equivalents = {
        'ſ' : 's',
        '' : 's',
        'ẏ' : 'y',
        'ƿ' : 'w',
        'ꝛ' : 'r'
        }

def multipleReplace(text, wordDict):
    for key in wordDict:
        text = text.replace(key, wordDict[key])
    return text

parser = etree.XMLParser(remove_blank_text=False,resolve_entities=False)

forms = []

# For present purposes I just want the personal names, e.g. iohannes:
#categories = ['{http://www.tei-c.org/ns/1.0}persName', '{http://www.tei-c.org/ns/1.0}name', '{http://www.tei-c.org/ns/1.0}placeName']
categories = ['{http://www.tei-c.org/ns/1.0}persName']

for file in sorted(glob.glob('echoe/xml/[0-9]*.xml')):
    tree = etree.parse(file, parser=parser)
    root = tree.getroot()
    text = root.find('.//{http://www.tei-c.org/ns/1.0}text')
    version = root.find('.//{http://www.tei-c.org/ns/1.0}idno').text
    for category in categories:
        for element in text.iter(category):
            if element.find('.//{http://www.tei-c.org/ns/1.0}abbr') is not None:
                abbr = element.find('.//{http://www.tei-c.org/ns/1.0}abbr')
                abbr.getparent().remove(abbr)
            if element.find('.//{http://www.tei-c.org/ns/1.0}am') is not None:
                abbr = element.find('.//{http://www.tei-c.org/ns/1.0}am')
                abbr.getparent().remove(abbr)
            if element.find('.//{http://www.tei-c.org/ns/1.0}lb') is not None:
                lb = element.find('.//{http://www.tei-c.org/ns/1.0}lb')
                lb.getparent().remove(lb)
            if element.find('.//{http://www.tei-c.org/ns/1.0}corr') is not None:
                corr = element.find('.//{http://www.tei-c.org/ns/1.0}corr')
                corr.getparent().remove(corr)
            if element.find('.//{http://www.tei-c.org/ns/1.0}del') is not None:
                deletion = element.find('.//{http://www.tei-c.org/ns/1.0}del')
                deletion.getparent().remove(deletion)
            if element.find('.//{http://www.tei-c.org/ns/1.0}orig') is not None:
                orig = element.find('.//{http://www.tei-c.org/ns/1.0}orig')
                orig.getparent().remove(orig)
            name = multipleReplace(etree.tostring(element, method='text', encoding='unicode').lower().lstrip().rstrip(), equivalents).replace('\n', '').replace('  ', ' ').replace('  ', ' ').replace('  ', ' ').replace('  ', ' ').replace('  ', ' ').replace('  ', ' ')
            print(name)
            forms.append(name)

forms = list(set(forms))

with open('echoe_ner.json', 'w', encoding='utf-8') as outfile:
    json.dump(forms, outfile, ensure_ascii=False, indent=4)
