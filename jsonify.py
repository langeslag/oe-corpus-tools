# This script reads data from previously generated DOE attested spelling files
# and outputs the data to JSON indexed by reference and form.
# Copyright 2023 P. S. Langeslag
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# this program. If not, see <https://www.gnu.org/licenses/>.

import os,glob,re,json,copy

data = {}
data_inverted = {}
files = glob.glob('attsp/E*.txt')
for file in files:
    reference = os.path.basename(file).removesuffix('.txt')
    forms = open(file).read().splitlines()
    if len(forms) > 2:
        lemma = copy.copy(forms[0])
        frequency = copy.copy(forms[1])
        forms.pop(0)
        forms.pop(0)
        if '(' in frequency:
            rubble = frequency.split('(', 1)
            frequency = rubble[0]
            context = rubble[1]
        frequency = int(re.sub(r'\D', '', frequency))
        lemma = lemma.replace('# ', '')
        data[reference] = {'lemma': lemma, 'frequency': frequency, 'forms': forms}
        for form in forms:
            if not form in data_inverted:
                data_inverted[form] = []
            if not reference in data_inverted[form]:
                data_inverted[form].append((reference, lemma, frequency))
            data_inverted[form] = sorted(data_inverted[form], key=lambda x: x[2], reverse=True)

with open('attsp.json', 'w') as outfile:
    json.dump(data, outfile)

with open('attsp_inverted.json', 'w') as outfile:
    json.dump(data_inverted, outfile)

