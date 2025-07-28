#!/bin/bash
#
# This script mines Dictionary of Old English HTML files for headword,
# frequency, and attested spelling information.
# Tested on the A--H CD-ROM release. Copyright 2020 P. S. Langeslag.
# 
# This is the original, primitive version of the script; if there's a demand
# I may or may not do up a more sophisticated and platform-independent Python
# script.
# 
# TODO: sanity checks; if doe/ not found don't do anything and complain, etc.
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

echo "Data mining underway, this will take time..."

# Expects HTML source files to be located in doe/; outputs as attsp/E*.txt.

mkdir -p attsp

# Reduce entries to just headword, occ., and att. sp. lines, in that order:

for i in doe/E*.html; do 
	bare=${i#doe/}
	grep "doe-hd\|^<span class=\"doe-oesp" $i > "attsp/${bare%.html}.txt"
	grep "doe-occ" $i >> "attsp/${bare%.html}.txt"
	grep "doe-attsp" $i >> "attsp/${bare%.html}.txt"
done

# Remove HTML formatting:

cd attsp
sed -i 's/<[^>]\+>//g' E*.txt

# Comment out headword and occurrences:

sed -i '/^$/d' E*.txt
sed -i '1,2s/^/#\ /' E*.txt

# Substitute unicode glyphs for entity codes:

sed -i 's/&eth;/ð/g' E*.txt
sed -i 's/&thorn;/ð/g' E*.txt
sed -i 's/&ETH;/Ð/g' E*.txt
sed -i 's/&THORN;/Þ/g' E*.txt
sed -i 's/&aelig;/æ/g' E*.txt
sed -i 's/&AElig;/Æ/g' E*.txt
sed -i 's/&otilde;/õ/g' E*.txt
sed -i 's/&middot;/·/g' E*.txt
sed -i 's/&amp;/\&/g' E*.txt
sed -i 's/&#257;/ā/g' E*.txt
sed -i 's/&#273;/đ/g' E*.txt
sed -i 's/&#275;/ē/g' E*.txt
sed -i 's/&#281;/ę/g' E*.txt
sed -i 's/&#295;/ħ/g' E*.txt
sed -i 's/&#299;/ī/g' E*.txt
sed -i 's/&#322;/ł/g' E*.txt
sed -i 's/&#333;/ō/g' E*.txt
sed -i 's/&#339;/œ/g' E*.txt
sed -i 's/&#363;/ū/g' E*.txt
sed -i 's/&#384;/ƀ/g' E*.txt
sed -i 's/&#447;/ƿ/g' E*.txt
sed -i 's/&#483;/ǣ/g' E*.txt
sed -i 's/&#541;/ȝ/g' E*.txt
sed -i 's/&#563;/ȳ/g' E*.txt
sed -i 's/&#5792;/ᚠ/g' E*.txt
sed -i 's/&#5794;/ᚢ/g' E*.txt
sed -i 's/&#5798;/ᚦ/g' E*.txt
sed -i 's/&#5801;/ᚩ/g' E*.txt
sed -i 's/&#5802;/ᚪ/g' E*.txt
sed -i 's/&#5803;/ᚫ/g' E*.txt
sed -i 's/&#5809;/ᚱ/g' E*.txt
sed -i 's/&#5811;/ᚳ/g' E*.txt
sed -i 's/&#5815;/ᚷ/g' E*.txt
sed -i 's/&#5817;/ᚹ/g' E*.txt
sed -i 's/&#5819;/ᚻ/g' E*.txt
sed -i 's/&#5822;/ᚾ/g' E*.txt
sed -i 's/&#5825;/ᛁ/g' E*.txt
sed -i 's/&#5831;/ᛇ/g' E*.txt
sed -i 's/&#5832;/ᛈ/g' E*.txt
sed -i 's/&#5835;/ᛋ/g' E*.txt
sed -i 's/&#5839;/ᛏ/g' E*.txt
sed -i 's/&#5842;/ᛒ/g' E*.txt
sed -i 's/&#58429;//g' E*.txt
sed -i 's/&#5846;/ᛖ/g' E*.txt
sed -i 's/&#5847;/ᛗ/g' E*.txt
sed -i 's/&#5850;/ᛚ/g' E*.txt
sed -i 's/&#5854;/ᛞ/g' E*.txt
sed -i 's/&#5855;/ᛟ/g' E*.txt
sed -i 's/&#5856;/ᛠ/g' E*.txt
sed -i 's/&#5859;/ᛣ/g' E*.txt
sed -i 's/&#5877;/ᛵ/g' E*.txt
sed -i 's/&#5878;/ᛶ/g' E*.txt
sed -i 's/&#5880;/ᛸ/g' E*.txt
sed -i 's/&#5881;/᛹/g' E*.txt
sed -i 's/&#61769;//g' E*.txt
sed -i 's/&#61809;//g' E*.txt
sed -i 's/&#61813;//g' E*.txt
sed -i 's/&#61815;//g' E*.txt
sed -i 's/&#61817;//g' E*.txt
sed -i 's/&#61819;//g' E*.txt
sed -i 's/&#61821;//g' E*.txt
sed -i 's/&#62209;//g' E*.txt
sed -i 's/&#62211;//g' E*.txt
sed -i 's/&#62213;//g' E*.txt
sed -i 's/&#62215;//g' E*.txt
sed -i 's/&#62217;//g' E*.txt
sed -i 's/&#62223;//g' E*.txt
sed -i 's/&#62225;//g' E*.txt
sed -i 's/&#62227;//g' E*.txt
sed -i 's/&#62229;//g' E*.txt
sed -i 's/&#62233;//g' E*.txt
sed -i 's/&#62235;//g' E*.txt
sed -i 's/&#62237;//g' E*.txt
sed -i 's/&#62239;//g' E*.txt
sed -i 's/&#62241;//g' E*.txt
sed -i 's/&#62367;//g' E*.txt
sed -i 's/&#62371;//g' E*.txt
sed -i 's/&#62381;//g' E*.txt
sed -i 's/&#62383;//g' E*.txt
sed -i 's/&#62394;//g' E*.txt
sed -i 's/&#62397;//g' E*.txt
sed -i 's/&#7713;/ḡ/g' E*.txt
sed -i 's/&#7865;/ẹ/g' E*.txt
sed -i 's/&#8266;/⁊/g' E*.txt
sed -i 's/&#946;/β/g' E*.txt
sed -i 's/&lt;//g' E*.txt
sed -i 's/&gt;//g' E*.txt

# Put each attested form on its own line, and address a slew of individual exceptions:

sed -i '/In\ late\ OE\ some\ forms\ of\ onbīdan\ with\ prefix\ an-\ (for\ on-)\ may\ have\ merged\ with\ some\ forms\ of\ anbidian;\ the\ following\ forms\ are\ treated\ s\.v\.\ onbīdan:\ anbidan,\ anbidæn\ ||\ anbide\ ||\ anbide&eth;\ ||\ anbida&thorn;\ (pl\.)\ ||\ anbidende\.<\/div>/d' E*.txt
sed -i '3,$s/\ |||\ /\n/g' E*.txt
sed -i '3,$s/\ ||\ /\n/g' E*.txt
sed -i '3,$s/\ |\ /\n/g' E*.txt
sed -i '/^Anom\.\ form:\ ᚹ\ (wynn,\ for\ the\ Tironian\ note,\ GenA\ 1120)$/d' E*.txt
sed -i '3,$s/firgingatā\ (\?\ -ā\ for\ -ena,\ \?\ -ā\ for\ -am),\ /firgingatā\nfirgingatena\nfirgingatam\n/g' E*.txt
sed -i '3,$s/awifte\ (with\ w\ for\ p)/awifte\napifte/g' E*.txt
sed -i '3,$s/\ (both\ for\ dat\.sg\.\ ametenum)/\nametenum/g' E*.txt
sed -i '3,$s/hweoga\ (with\ g\ for\ ð.*)\./hweoga\nhweðga/g' E*.txt
sed -i '3,$s/By\ confusion\ with\ ǣghwæðer\ (cf\.\ ǣghwider\ for\ similar\ confusion):\ //g' E*.txt
sed -i '3,$s/Perh\.\ by\ confusion\ with\ ǣghwæðer\ (cf\.\ ǣghwǣr\ for\ similar\ confusion):\ //g' E*.txt
sed -i '3,$s/\ (cipher\ for\ \([^,]*\),\ [^)]*)\ /\n\1\n/g' E*.txt
sed -i '3,$s/\ (for\ \([^,]*\),\ [^)]*)\ /\n\1\n/g' E*.txt
sed -i '3,$s/\ (prob\.\ for\ \([^,]*\),\ [^)]*)\ /\n\1\n/g' E*.txt
sed -i '3,$s/\ (miswritten\ for\ \([^,]*\),\ [^)]*)\ /\n\1\n/g' E*.txt
sed -i '3,$s/\ (\?\ miswritten\ for\ \([^,]*\),\ [^)]*)\ /\n\1\n/g' E*.txt
sed -i '3,$s/\ (in\ error\ for\ \([^,]*\),\ [^)]*)\ /\n\1\n/g' E*.txt
sed -i '3,$s/\ (\?\ in\ error\ for\ \([^,]*\),\ [^)]*)\ /\n\1\n/g' E*.txt
sed -i '3,$s/\ (=\ \([^,]*\),\ for\ \([^,]*\),\ [^)]*)\ /\n\1\n\2\n/g' E*.txt
sed -i '3,$s/\ ([^)]\{0,20\}\?\ for\ \([^,]*\),\ [^)]*)\ /\n\1\n/g' E*.txt
sed -i '3,$s/\ ([^)]*)//g' E*.txt
sed -i '3,$s/([^)]*)/\n/g' E*.txt
sed -i '3,$s/;\ /\n/g' E*.txt
sed -i '3,$s/^$\n//g' E*.txt
sed -i '3,$s/^\.$\n//g' E*.txt
sed -i '3,$s/\.\s*$//g' E*.txt
sed -i '3,$s/^\.//g' E*.txt
sed -i '3,$s/^\s*//g' E*.txt
sed -i '3,$s/\n^$//g' E*.txt
sed -i '3,$s/\[//g' E*.txt
sed -i '3,$s/\]//g' E*.txt
sed -i '3,$s/\x27//g' E*.txt
sed -i '3,$s/^[^:]*:\ //g' E*.txt
sed -i '3,$s/^[^:]*:\ //g' E*.txt
sed -i '3,$s/^[^:]*:\ //g' E*.txt
sed -i '3,$s/^Strong\ Adjective:$//g' E*.txt
sed -i '3,$s/^Masculine:$//g' E*.txt
sed -i '3,$s/^Late\ *$//g' E*.txt
sed -i '3,$s/^[^:]*:\ //g' E*.txt
sed -i '3,$s/^[^:]*:\ //g' E*.txt
sed -i '3,$s/:*//g' E*.txt
sed -i '/^$/d' E*.txt
sed -i '3,$s/\?\ //g' E*.txt
sed -i '/^Neuter$/d' E*.txt
sed -i '/^Feminine$/d' E*.txt
sed -i '/^Masculine$/d' E*.txt
sed -i '/^Gen\.pl\.$/d' E*.txt
sed -i '/^Rarely$/d' E*.txt
sed -i '/^adjectival inflectional endings are added to gen.sg.$/d' E*.txt
sed -i '/^gen.pl.$/d' E*.txt
sed -i '/^and dat.pl. forms. Genitives formed in this way generally decline as possessive adjectives$/d' E*.txt
sed -i '/^agreeing with the modified noun in number$/d' E*.txt
sed -i '/^gender$/d' E*.txt
sed -i '/^and case. The motivation behind doubly inflected dative pl. forms is unclear$/d' E*.txt
sed -i '/^but these may have been invented in order to disambiguate dat.pl. heom from the identically spelled m.\/n.dat.sg. form. The attested forms are as follows$/d' E*.txt
sed -i '/^Weak\ Adjective$/d' E*.txt
sed -i '/^Gen.pl. with m.\/n.dat.sg. or dat.pl. inflection$/d' E*.txt
sed -i '/^Dat.pl. with dat.pl. inflection$/d' E*.txt
sed -i '/^For forms of the f.nom.sg. 3rd pers. pronoun beginning in sc$/d' E*.txt
sed -i '/^see scǣ$/d' E*.txt
sed -i '/^beo\ ge$/d' E*.txt
sed -i '/^bio\ ge$/d' E*.txt
sed -i '/^wære\ wit$/d' E*.txt
sed -i '/^Northumbrian paradigm$/d' E*.txt
sed -i '/^excluding all forms found also with other dialect groupings$/d' E*.txt
sed -i 's/\ $//' E*.txt
sed -i 's/^to\ //' E*.txt
sed -i '/^N\.$/d' E*.txt
sed -i '/an\ twig/d' E*.txt
sed -i '3,$s/nage\ we/nage/' E*.txt
sed -i '3,$s/afyrsað.\ -eo-\ spellings\ occur\ in\ Psalters\ FGK/afyrsað/' E*.txt
sed -i '3,$s/Wk.\ ahrerede/ahrerede/' E*.txt
sed -i '/brondas\ ðencan/d' E*.txt
sed -i '/Forms\ without\ final\ n/d' E*.txt
sed -i '/Att.\ sp./d' E*.txt
sed -i '/anlicie\ we/d' E*.txt
sed -i '/anlichie\ we/d' E*.txt
sed -i '/ðone\ onsione/d' E*.txt
sed -i '3,$s/se\ ansine/ansine/' E*.txt
sed -i '/Unambiguous\ wk.\ 2\ forms/d' E*.txt
sed -i '/Att.\ sp./d' E*.txt
sed -i '/Abbrev.\ forms\ in\ glosses/d' E*.txt
sed -i '/With\ ǣ-/d' E*.txt
sed -i '3,$s/geembehte\ ðu/geembehte/' E*.txt
sed -i '3,$s/geanlicie\ we/geanlicie/' E*.txt
sed -i '/With\ gen.sg.\ in\ -s/d' E*.txt
sed -i '3,$s/ædeawado.\ Past\ tense\ forms\ perhaps\ show\ influence\ of\ wk.\ 2\ on\ wk.\ 1/ædeawado/' E*.txt
sed -i '/Sg.\ or\ pl/d' E*.txt
sed -i '/Endingless\ in\ acc.sg./d' E*.txt
sed -i '/Spellings\ in\ eg-\ are\ mainly\ North/d' E*.txt
sed -i '/The\ spelling\ ǣrendwreca\ is\ etymological.\ The\ form\ ǣrendraca\ appears\ to\ have\ developed\ by\ popular\ association\ with\ racu\ &lsquo;explanation/d' E*.txt
sed -i '/M.\ or\ N./d' E*.txt
sed -i '/The\ manuscript\ is\ damaged\ and\ difficult\ to\ read/d' E*.txt
sed -i '3,$s/Jun.\ Transcr.\ 71\ ægewriteras/ægewriteras/' E*.txt
sed -i '3,$s/egewritteras\ and\ scepttenras\ have\ been\ suggested\ as\ possible\ readings/egewritteras/' E*.txt
sed -i '/IE\ bheu-/d' E*.txt
sed -i '/beo\ ge/d' E*.txt
sed -i '/bio\ ge/d' E*.txt
sed -i '/IE\ wes-/d' E*.txt
sed -i '/IE\ es-/d' E*.txt
sed -i '/PGerm.\ ar-/d' E*.txt
sed -i '/Northumbrian\ paradigm/d' E*.txt
sed -i '/excluding\ all\ forms\ found\ also\ with\ other\ dialect\ groupings/d' E*.txt
sed -i '/the\ word\ has\ been\ read\ as\ betothecd/d' E*.txt
sed -i '/but\ the\ last\ letter\ is\ doubtful/d' E*.txt
sed -i '3,$s/ƀscop\ ChronF)/ƀscop/' E*.txt
sed -i '3,$s/ƀ\ ChronF)/ƀ/' E*.txt
sed -i '/Spellings\ with\ -z-\ are\ found\ in\ MSS\ of\ s.\ x\ med.\ and\ later/d' E*.txt
sed -i '/Wk.\ m/d' E*.txt
sed -i '3,$s/boncade\ borcade/boncade\nborcade/' E*.txt
sed -i '/St.\ pl./d' E*.txt
sed -i '/bedupe.\ Forms\ with\ -pt-/d' E*.txt
sed -i '/-pð\ could\ also\ be\ taken\ s.v.\ bedyppan/d' E*.txt
sed -i '/in\ a\ number\ of\ citations\ confusion\ is\ attested\ in\ the\ variants/d' E*.txt
sed -i '/With\ contr./d' E*.txt
sed -i '/Forms\ with\ -dd-/d' E*.txt
sed -i '3,$s/be\ \.\.\.\ tweonum/betweonum\ntweonum/' E*.txt
sed -i '/With\ -swæc/d' E*.txt
sed -i '/With\ -spæc/d' E*.txt
sed -i '/Redupl.\ pret./d' E*.txt
sed -i '/Wk.\ 1/d' E*.txt
sed -i '3,$s/becbures\ or\ betbures/becbures\nbetbures/' E*.txt
sed -i '/se\ burhwaru/d' E*.txt
sed -i '/M.\ cl.\ 3/d' E*.txt
sed -i '/nom.sg.\ -\ bissextus/d' E*.txt
sed -i '3,$s/acc.sg.\ -\ bissextum/bissextum/' E*.txt
sed -i '/gen.sg.\ -\ bissextus/d' E*.txt
sed -i '3,$s/dat.sg.\ -\ bissexto/bissexto/' E*.txt
sed -i '/M.\ wk.\ with\ t/d' E*.txt
sed -i '/ða\ bydel/d' E*.txt
sed -i '/Forms\ with\ -dd-/d' E*.txt
sed -i '3,$s/bradeleaces.\ Final\ e\ in\ composition\ is\ unique\ to\ this\ compound\ of\ brad/bradeleaces/' E*.txt
sed -i '3,$s/bituinf\ letnise/bituinfletnise/' E*.txt
sed -i '/nom.\/acc.sg.\ broðor/d' E*.txt
sed -i '/gen.sg.\ broðor/d' E*.txt
sed -i '3,$s/dat.sg.\ breðer/breðer/' E*.txt
sed -i '/nom.\/acc.pl.\ broðor/d' E*.txt
sed -i '/gen.pl.\ broðra/d' E*.txt
sed -i '/dat.pl.\ broðrum/d' E*.txt
sed -i '3,$s/brim\ faro.\ ðæs/brimfaro/' E*.txt
sed -i '/cl.\ 4/d' E*.txt
sed -i '/For\ unambiguously\ weak\ forms/d' E*.txt
sed -i '/see\ cwene/d' E*.txt
sed -i '/With\ metathesis/d' E*.txt
sed -i '/-ei-\ spellings\ are\ Northumbrian/d' E*.txt
sed -i '3,$s/a\ æsnungdrenceas/æsnungdrenceas/' E*.txt
sed -i '/confessor\ may\ be\ either\ OE\ or\ Lat/d' E*.txt
sed -i '/Forms\ with\ medial\ n\ predominate\ in\ Ælfric/d' E*.txt
sed -i '/for\ other\ gr-\ spellings/d' E*.txt
sed -i '/cf.\ gringwræce\ s.v.\ cringan/d' E*.txt
sed -i '3,$s/expanded\ as\ christenman/christenman/' E*.txt
sed -i '3,$s/menn\ cyni/menncyni/' E*.txt
sed -i '3,$s/dagae\ note\ that\ endingless\ forms\ are\ also\ common/dagae/' E*.txt
sed -i '3,$s/gedæled\ edlice/gedælededlice/' E*.txt
sed -i '3,$s/dug\ ../dug/' E*.txt
sed -i '/occas.\ in\ s.xii\ MSS/d' E*.txt
sed -i '3,$s/Standard\ Paradigm\ deoflu/deoflu/' E*.txt
sed -i '/In\ sg./d' E*.txt
sed -i '/m.\ more\ common/d' E*.txt
sed -i '/m.pl.\ deoflas\ in\ Aldred/d' E*.txt
sed -i '3,$s/ᛞᛖᚱᛖᚦ\ =\ dereð/ᛞᛖᚱᛖᚦ\ndereð/' E*.txt
sed -i '3,$s/nom.sg.\ diaconus/diaconus/' E*.txt
sed -i '3,$s/acc\.pl\.\ diaconos/diaconos/' E*.txt
sed -i '3,$s/wesan\ draegtre/draegtre/' E*.txt
sed -i '3,$s/drencan\ both\ acc.pl./drencan/' E*.txt
sed -i '3,$s/derb\ s/derb/' E*.txt
sed -i '3,$s/se\ druncnesse/druncnesse/' E*.txt
sed -i '/Some\ forms\ in\ gearn-\ \/\ georn-\ may\ alternatively\ be\ taken\ as\ forms\ of\ earnian\ with\ initial\ g/d' E*.txt
sed -i '/efenheortnes/d' E*.txt
sed -i '3,$s/ðone\ eage/eage/' E*.txt
sed -i '/aldor\ \.\.\.\ sacerdæs/d' E*.txt
sed -i '/aldor\ \.\.\.\ sacerda/d' E*.txt
sed -i '3,$s/alduras\ sacerdas/aldurassacerdas/' E*.txt
sed -i '/Spellings\ in\ eæll-\ are\ mainly\ in\ PsGlE/d' E*.txt
sed -i '3,$s/ᚪ\ ᛚ\ ᛗ\ ᛖ\ ᛇ\ ᛏ\ ᛏ\ ᛁ\ ᚷ/ᚪᛚᛗᛖᛇᛏᛏᛁᚷ/' E*.txt
sed -i '/Spellings\ in\ æl-/d' E*.txt
sed -i '/the\ combining\ form\ of\ eall/d' E*.txt
sed -i '3,$s/efne\ \.\.\.acunn/efneacunn\nacunn/' E*.txt
sed -i '3,$s/me\ are/are/' E*.txt
sed -i '/Spellings\ in\ eærd-\ are\ from\ PsGlE/d' E*.txt
sed -i '3,$s/efne\ \.\.\.gesette/efnegesette\ngesette/' E*.txt
sed -i '3,$s/ðio\ earliprece\ ðone/earliprece/' E*.txt
sed -i '3,$s/earlipprica\ \.\.\.\ ðio/earlipprica/' E*.txt
sed -i '3,$s/ðone\ ęarliprica/ęarliprica/' E*.txt
sed -i '/Spellings\ in\ eærm(-\ are\ from\ PsCaE/d' E*.txt
sed -i '3,$s/efne\ \.\.\.geworhta/efnegeworhta/' E*.txt
sed -i '/With\ inflected\ first\ element/d' E*.txt
sed -i '3,$s/eft\ \.\.\.acennedo/eftacennedo\nacennedo/' E*.txt
sed -i '3,$s/eft\ \.\.\.brenga/eftbrenga\nbrenga/' E*.txt
sed -i '3,$s/eft\ \.\.\.afylled/eftafylled\nafylled/' E*.txt
sed -i '3,$s/eft\ \.\.\.afylledo/eftafylledo\nafylledo/' E*.txt
sed -i '3,$s/eft\ \.\.\.afirred/eftafirred\nafirred/' E*.txt
sed -i '3,$s/eft\ \.\.\.arisa/eftarisa\narisa/' E*.txt
sed -i '3,$s/eft\ \.\.\.awoende/eftawoende\nawoende/' E*.txt
sed -i '3,$s/eft\ \.\.\.ædeawde/eftædeawde\nædeawde/' E*.txt
sed -i '3,$s/eft\ \.\.\.beheald/eftbeheald\nbeheald/' E*.txt
sed -i '3,$s/eft\ \.\.\.besii/eftbesii\nbesii/' E*.txt
sed -i '3,$s/eft\ \.\.\.bisii/eftbisii\nbisii/' E*.txt
sed -i '3,$s/eft\ \.\.\.boetanne/eftboetanne\nboetanne/' E*.txt
sed -i '3,$s/eft\ \.\.\.giboeted/eftgiboeted\ngiboeted/' E*.txt
sed -i '3,$s/eft\ \.\.\.gebeotes/eftgebeotes\ngebeotes/' E*.txt
sed -i '3,$s/eft\ \.\.\.giblaue/eftgiblaue\ngiblaue/' E*.txt
sed -i '/The\ attestations\ are\ ambiguous\ and\ may\ be\ interpreted\ as\ forms\ of\ the\ adjective/d' E*.txt
sed -i '3,$s/eft\ \.\.\.cerro/eftcerro\ncerro/' E*.txt
sed -i '3,$s/eft\ \.\.\.cerde/eftcerde\ncerde/' E*.txt
sed -i '3,$s/eft\ \.\.\.lifde/eftlifde\nlifde/' E*.txt
sed -i '3,$s/eft\ \.\.\.gilixia/eftgilixia\ngilixia/' E*.txt
sed -i '3,$s/eft\ \.\.\.gimyndga/eftgimyndga\ngimyndga/' E*.txt
sed -i '3,$s/eft\ \.\.\.niuaia/eftniuaia\nniuaia/' E*.txt
sed -i '3,$s/eft\ \.\.\.onfoenne/eftonfoenne\nonfoenne/' E*.txt
sed -i '3,$s/eft\ \.\.\.onlece/eftonlece\nonlece/' E*.txt
sed -i '3,$s/eft\ \.\.\.gihriordad/eftgihriordad\ngihriordad/' E*.txt
sed -i '3,$s/eft\ \.\.\.sægdon/eftsægdon\nsægdon/' E*.txt
sed -i '3,$s/eft\ \.\.\.sald/eftsald\nsald/' E*.txt
sed -i '3,$s/eft\ \.\.\.sende/eftsende\nsende/' E*.txt
sed -i '3,$s/eft\ \.\.\.gesea/eftgesea\ngesea/' E*.txt
sed -i '3,$s/eft\ \.\.\.gesetes/eftgesetes\ngesetes/' E*.txt
sed -i '3,$s/eft\ \.\.\.toslitas/efttoslitas\ntoslitas/' E*.txt
sed -i '3,$s/eft\ \.\.\.ðences/eftðences\nðences/' E*.txt
sed -i '3,$s/eft\ \.\.\.geðencas/eftgeðencas\ngeðencas/' E*.txt
sed -i '/Spellings\ in\ oe-\ are\ North/d' E*.txt
sed -i '3,$s/eft\ \.\.\.wendas/eftwendas\nwendas/' E*.txt
sed -i '3,$s/eft\ \.\.\.gewoendas/eftgewoendas\ngewoendas/' E*.txt
sed -i '3,$s/eft\ \.\.\.wæltes/eftwæltes\nwæltes/' E*.txt
sed -i '/Spellings\ in\ æu-\ are\ from\ ChronE\ additions/d' E*.txt
sed -i '/Spellings\ in\ oef-\ are\ from\ Li/d' E*.txt
sed -i '/Spellings\ in\ efeg-\ are\ from\ CP\ MS\ Camb.Trin.\ R.5.22/d' E*.txt
sed -i '/Spellings\ with\ initial\ h\ are\ from\ CP\ MS\ CUL\ Ii.ii.4/d' E*.txt
sed -i '3,$s/eft\ \.\.\.alesenis/eftalesenis\nalesenis/' E*.txt
sed -i '/With\ merging\ of\ æl/d' E*.txt
sed -i '3,$s/oelebearuu\ ||/oelebearuu/' E*.txt
sed -i '/Forms\ in\ LdGl/d' E*.txt
sed -i '/CollGl\ 32.3/d' E*.txt
sed -i '/CollGl\ 38.6\ are\ preserved\ in\ continental\ MSS/d' E*.txt
sed -i '/and\ treated\ as\ OE\ copied\ by\ foreign\ scribes/d' E*.txt
sed -i '3,$s/eolhxsecg\ Hickes\ transcr\.\ eolhx\ secc/eolhxsecg\neolhxsecc/' E*.txt
sed -i 's/firygingattam.*/firygingattam/' E*.txt
sed -i 's/^forfære.*/forfære/' E*.txt
sed -i '3,$s/·ᛖ\ ·ᚹ\ ·ᚢ·/ᛖᚹᚢ/' E*.txt
sed -i '3,$s/erscgrafan\ ersegrafan/erscgrafan\nersegrafan/' E*.txt
sed -i '/Forms\ in\ oe-\ are\ from\ DurRit/d' E*.txt
sed -i '/Forms\ in\ oe-\ are\ from\ DurRit/d' E*.txt
sed -i '/Some\ spellings\ in\ gearn-\ may\ alternatively\ represent\ forms\ of\ earnung\ with\ initial\ g/d' E*.txt
sed -i '/geafæn\ \.\.\.læce/d' E*.txt
sed -i '/Forms\ with\ -n-\ are\ Northumbrian/d' E*.txt
sed -i '/Fragm.\ forms/d' E*.txt
sed -i '/M.\ or\ N./d' E*.txt
sed -i '3,$s/nænne\ færeld/færeld/' E*.txt
sed -i '3,$s/ðæt\ færelt/færelt/' E*.txt
sed -i '/Forms\ in\ -nd-/d' E*.txt
sed -i '/Forms\ in\ -nd-/d' E*.txt
sed -i '3,$s/Abbrev.\ form.xv.an/.xv.an/' E*.txt
sed -i '3,$s/Abbrev.\ forms.v.tiene/.v.tiene/' E*.txt
sed -i '/In\ North.\ glosses/d' E*.txt
sed -i '/As\ alternative\ gloss\ for\ fyðerfōte/d' E*.txt
sed -i '3,$s/ᚠᚩᛚᚳ\ =\ folc/ᚠᚩᛚᚳ\nfolc/' E*.txt
sed -i '3,$s/w\ feounge/feounge/' E*.txt
sed -i '/With\ unmetathesized\ suffix/d' E*.txt
sed -i '/Corrupt\ forms\ of\ nraef/d' E*.txt
sed -i '/Gen.pl.\ flana\ and\ dat.pl.\ flanum\ have\ been\ treated\ s.v.\ flān/d' E*.txt
sed -i '3,$s/fore\ fengnisse/forefengnisse/' E*.txt
sed -i '3,$s/forcyððed\ (MSol/forcyððed/' E*.txt
sed -i '3,$s/forbinde\ ge/forbinde/' E*.txt
sed -i '3,$s/folce\ getrume/folcegetrume/' E*.txt
sed -i '3,$s/forð\ \.\.\.ateo/forðateo\nateo/' E*.txt
sed -i '3,$s/forðteoð||\ forðteo/forðteoð\nforðteo/' E*.txt
sed -i '3,$s/forð\ \.\.\.bringe/forðbringe\nbringe/' E*.txt
sed -i '3,$s/huru\ fæðmum/hurufæðmum/' E*.txt
sed -i '3,$s/fleah|\ flęh/fleah\nflęh/' E*.txt
sed -i '3,$s/from\ \.\.\.sunduria/fromsunduria\nsunduria/' E*.txt
sed -i '3,$s/fr\ fræge/fræge/' E*.txt
sed -i '3,$s/fyrn\ \.\.\.gewritu/fyrngewritu\ngewritu/' E*.txt
sed -i '3,$s/mid\ cwealmlicre\ flihte/flihte/' E*.txt
sed -i '3,$s/geflea\ ||/geflea/' E*.txt
sed -i '3,$s/forglendrede\ (pret.sg./forglendrede/' E*.txt
sed -i '/HomU\ 32\ MS\ B/d' E*.txt
sed -i '/^f\ ð$/d' E*.txt
sed -i '3,$s/fore\ \.\.\.\ saga/foresaga\nsaga/' E*.txt
sed -i '3,$s/foresce\ g/foresceg/' E*.txt
sed -i '/Form\ in\ geard-\ may\ alternatively\ be\ taken\ as\ eard-\ with\ initial\ g/d' E*.txt
sed -i '3,$s/fore\ \.\.\.cweðo/forecweðo\ncweðo/' E*.txt
sed -i '3,$s/fore\ \.\.\.gongende/foregongende\ngongende/' E*.txt
sed -i '/With\ st.\ inflections/d' E*.txt
sed -i '3,$s/fore\ \.\.\.gesette/foregesette\ngesette/' E*.txt
sed -i '3,$s/fore\ \.\.\.tal/foretal\ntal/' E*.txt
sed -i '3,$s/forewit\ tiendlicer/forewittiendlicer/' E*.txt
sed -i '3,$s/fe\ \.\.\.\ getachte/fegetachte\ngetachte/' E*.txt
sed -i '3,$s/for\ \.\.\.gemeleasað/forgemeleasað\ngemeleasað/' E*.txt
sed -i '3,$s/forhycggan\ forhycganne/forhycggan\nforhycganne/' E*.txt
sed -i '3,$s/forhicgende\ ||/forhicggende/' E*.txt
sed -i '3,$s/galpania\ ⁊\ anan/galpania/' E*.txt
sed -i '3,$s/forgife\ ge/forgife/' E*.txt
sed -i '/followed\ by\ first\ minim\ of\ u/d' E*.txt
sed -i '3,$s/ðet\ foster/foster/' E*.txt
sed -i '3,$s/se\ fyrstmearce/fyrstmearce/' E*.txt
sed -i '3,$s/gefaran\ gefaren/gefaran\ngefaren/' E*.txt
sed -i '3,$s/freo\ don/freodon/' E*.txt
sed -i '/se\ fyrd/d' E*.txt
sed -i '3,$s/ðæt\ ferd/ferd/' E*.txt
sed -i '3,$s/mid\ mycclum\ fyrde/fyrde/' E*.txt
sed -i '/Abbrev.\ form\ in\ a\ gloss/d' E*.txt
sed -i '3,$s/geonglic\ geonlic/geonglic\ngeonlic/' E*.txt
sed -i '/Anom.\ forms/d' E*.txt
sed -i '3,$s/ðæt\ mycele\ gylp/gylp/' E*.txt
sed -i '3,$s/gydde\ as\ if\ f./gydde/' E*.txt
sed -i '/cl.\ 2or\ n.\ noun\ \ gydde\ ?/d' E*.txt
sed -i '3,$s/godene\ or\ godere/godene\ngodere/' E*.txt
sed -i '/Anom.\ forms/d' E*.txt
sed -i '/Unambig.\ f.\ wk./d' E*.txt
sed -i '3,$s/ðæt\ geagl/geagl/' E*.txt
sed -i '3,$s/in\ sið\ gryre/insiðgryre/' E*.txt
sed -i '/these\ forms\ have\ alternatively\ been\ taken\ as\ n./d' E*.txt
sed -i '3,$s/græi\ an/græian/' E*.txt
sed -i '/these\ forms\ may\ represent\ scribal\ compromise\ between\ gnēað\ and\ gnȳðe/d' E*.txt
sed -i 's/onfruma.*/onfruma/' E*.txt
sed -i '/^nom\.pl\.$/d' E*.txt
sed -i '/^Ru1$/d' E*.txt
sed -i '/noun\.\{1,2\}gydde/d' E*.txt
sed -i 's/heahfore\ .*$/heahfore/' E*.txt
sed -i '/^Bede$/d' E*.txt
sed -i 's/^haliryft\ .*/haliryft/' E*.txt
sed -i '/these\ forms\ may\ alternatively\ be\ read\ as\ merographs\ of\ forms\ of\ hēahnes/d' E*.txt
sed -i '/form\ may\ have\ arisen\ by\ confusion\ of\ the\ dat.inf.\ to\ gehealdenne\ =\ custodiendus\ with\ an\ adj.\ like\ deriendlic/d' E*.txt
sed -i '3,$s/hea\ an/heaan/' E*.txt
sed -i '3,$s/hen\ se/hen/' E*.txt
sed -i '3,$s/heh\ \.\.\.sacerd/hehsacerd\nsacerd/' E*.txt
sed -i '3,$s/heh\ \.\.\.sacerdas/hehsacerdas\nsacerdas/' E*.txt
sed -i '3,$s/heh\ \.\.\.sac/hehsac\nsac/' E*.txt
sed -i '3,$s/imbrae\ rae/imbraerae/' E*.txt
sed -i '/Anom.\ forms/d' E*.txt
sed -i '/perhaps\ written\ through\ confusion\ with\ forms\ of/d' E*.txt
sed -i '/Uninfl.\ North.\ glosses\ of\ familias/d' E*.txt
sed -i '/hæ\ nū/d' E*.txt
sed -i '/M.\ or\ N./d' E*.txt
sed -i '/ðis\ hælo/d' E*.txt
sed -i '/cl.\ 3/d' E*.txt
sed -i '/2nd\ sg/d' E*.txt
sed -i 's/hundæ\ .*$/hundæ/' E*.txt
sed -i '/^xii$/d' E*.txt
sed -i '/^M\.$/d' E*.txt
sed -i '/^IE\ bheu-$/d' E*.txt
sed -i '/^IE\ wes-$/d' E*.txt
sed -i '/^IE\ es-$/d' E*.txt
sed -i '/^PGerm\. ar-$/d' E*.txt
sed -i '/^s-$/d' E*.txt
sed -i '/^bhu-$/d' E*.txt
sed -i '/^wēs-$/d' E*.txt
sed -i '/^-$/d' E*.txt
sed -i '/^with\ -m$/d' E*.txt
sed -i '/with\ traces\ of\ cm\ written\ above\ the\ line/d' E*.txt
sed -i '3,$s/North.\ geheras/geheras/' E*.txt
sed -i 's/baldsamum\ .*$/baldsamum/' E*.txt
sed -i '3,$s/St.\ hyrwendlic/hyrwendlic/' E*.txt
sed -i '3,$s/te\ hernise/hernise/' E*.txt
sed -i 's/heræð\ heræð/heræð/' E*.txt
sed -i '/The\ hyrig-\ spellings\ may\ be\ formed\ from\ the\ root\ of\ the\ verb\ hȳrigan/d' E*.txt
sed -i '/or\ may\ represent\ corrupt\ forms\ of\ hȳringmann2/d' E*.txt
sed -i '/se\ gifra\ helle/d' E*.txt
sed -i '/ðam\ deopan\ helle/d' E*.txt
sed -i '/Anom.\ form\ in\ a\ gloss/d' E*.txt
sed -i '/heahlice\ readings\ in\ Godric\ MSS\ GHIKL\ could\ alternatively\ be\ read\ as\ forms\ of\ the\ adj.\ hālig\ q.v./d' E*.txt
sed -i '/I.\ Active\ forms\ and\ past\ part/d' E*.txt
sed -i '/II.\ Passive\ forms\ excluding\ the\ past\ part/d' E*.txt
sed -i '/A.\ Forms\ derived\ from\ the\ Germanic\ pres.pass.\ inflection/d' E*.txt
sed -i '/used\ as\ both\ pres.\ and\ pret.\ pass./d' E*.txt
sed -i '/these\ forms\ could\ also\ be\ taken\ as\ abbreviations\ for\ hlīsbǣre/d' E*.txt
sed -i '/and\ hlīsig/d' E*.txt
sed -i '/adjectival\ inflectional\ endings\ are\ added\ to\ gen.sg./d' E*.txt
sed -i '/and\ dat.pl.\ forms.\ Genitives\ formed\ in\ this\ way\ generally\ decline\ as\ possessive\ adjectives/d' E*.txt
sed -i '/agreeing\ with\ the\ modified\ noun\ in\ number/d' E*.txt
sed -i '/and\ case.\ The\ motivation\ behind\ doubly\ inflected\ dative\ pl.\ forms\ is\ unclear/d' E*.txt
sed -i '/but\ these\ may\ have\ been\ invented\ in\ order\ to\ disambiguate\ dat.pl.\ heom\ from\ the\ identically\ spelled\ m.\/n.dat.sg.\ form.\ The\ attested\ forms\ are\ as\ follows/d' E*.txt
sed -i '/Gen.pl.\ with\ m.\/n.dat.sg.\ or\ dat.pl.\ inflection/d' E*.txt
sed -i '/For\ forms\ of\ the\ f.nom.sg.\ 3rd\ pers.\ pronoun\ beginning\ in\ sc/d' E*.txt
sed -i '/see\ scǣ/d' E*.txt
sed -i '/Forms\ originally\ proper\ to\ the\ dative\ are\ used\ for\ the\ general\ object\ case\ in\ some\ texts\ of\ s.\ xii\ and\ later/d' E*.txt
sed -i '/hiwlæs\ with\ a\ second\ læs\ written\ immediately\ below\ the\ first/d' E*.txt
sed -i '/Forms\ of\ the\ interrogative\ particle\ with\ -e/d' E*.txt
sed -i '3,$s/mid\ ðysse\ hrægle/hrægle/' E*.txt
sed -i '/The\ form\ may\ alternatively\ be\ taken\ as\ two\ words\ with\ helle\ as\ gen.sg.\ of\ hell/d' E*.txt
sed -i '3,$s/ða\ heane/heane/' E*.txt
sed -i '/These\ instances\ may\ alternatively\ be\ taken\ as\ forms\ of\ hēan\ adj/d' E*.txt
sed -i '3,$s/Wk.\ heorre/heorre/' E*.txt
sed -i '/With\ -\ es\ as\ a\ generalized\ adverbial\ marker/d' E*.txt
sed -i '3,$s/healfbrocenra\ (Bede\ MSS\ BCaO/healfbrocenra/' E*.txt
sed -i '/Anom.\ forms/d' E*.txt
sed -i '3,$s/hyrsumien|\ hyrsumien/hyrsumien/' E*.txt
sed -i '/Corrupt\ forms\ in\ late\ MS/d' E*.txt
sed -i '3,$s/ᚷᚫᚱᚩᚻᛁ\ =\ GÆROHI/ᚷᚫᚱᚩᚻᛁ\ngærohi/' E*.txt
sed -i 's/onbidedon.\ The\ form\ onbiduð\ glosses\ expectant\ in\ PsGlE\ 68\.7/onbiduð/' E*.txt
sed -i 's/presumably\ for\ onbidað/onbidað/' E*.txt
sed -i 's/but\ perhaps\ for\ onbidiað/onbidiað/' E*.txt
sed -i 's/agefe\ ue/agefe/' E*.txt
sed -i 's/afursed\.\ -eo-\ spellings\ occur\ in\ Psalters\ FGK/afursed/' E*.txt
sed -i 's/arehton\ arehtun/arehton\narehtun/' E*.txt
sed -i 's/awurpon\ auurpon/awurpon\nauurpon/' E*.txt
sed -i 's/ilke||\ elchene/ilke\nelchene/' E*.txt
sed -i 's/uuæs|\ uues/uuæs\nuues/' E*.txt
sed -i 's/besenked\.\ bisenced/besenked\nbisenced/' E*.txt
sed -i 's/behydda\ \.\.\.\ dedre/behyddadedre/' E*.txt
sed -i 's/ge\ \.\.\.berende/berende\ngeberende/' E*.txt
sed -i 's/ge\ \.\.\.bidas/bidas\ngebidas/' E*.txt
sed -i 's/byrigele\ byrielse/byrigele\nbyrielse/' E*.txt
sed -i 's/cul\ bod\ gehnades\ with\ ł\ cum\ bel\ written\ above\ cul\ bod\ in\ a\ later\ hand/culbodgehnades/' E*.txt
sed -i 's/deie\ note\ that\ endingless\ forms\ are\ also\ common/deie/' E*.txt
sed -i 's/ᛞᛖᛖᚱᛖᚦ\ =\ deereð/ᛞᛖᛖᚱᛖᚦ\ndeereð/' E*.txt
sed -i 's/gedihligan\ all\ copies\ of\ HomS\ 11/gedihligan/' E*.txt
sed -i 's/dræncen\ both\ acc\.pl\./dræncan/' E*.txt
sed -i 's/duolages\ all\ 2nd\ pl\./duolages/' E*.txt
sed -i 's/enden\ endun/enden\nendun/' E*.txt
sed -i '/Or\ perhaps\ take\ as\ forms\ of\ otherwise\ unattested\ efenheortnes/d' E*.txt
sed -i 's/eardungstowe\ ðinum/eardungstowe/' E*.txt
sed -i 's/earlippricco\ \.\.\.\ ðio/earlippricco/' E*.txt
sed -i 's/ða\ earelipprica/earelipprica/' E*.txt
sed -i 's/earliprica\ ðæt/earliprica/' E*.txt
sed -i 's/eft\ \.\.\.aras/eftaras\naras/' E*.txt
sed -i 's/eft\ \.\.\.awoended/eftawoended\nawoended/' E*.txt
sed -i 's/eft\ \.\.\.awoendo/eftawoendo\nawoendo/' E*.txt
sed -i 's/eft\ to\ cerranne/eftcerranne\neft\ to\ cerranne\ncerranne/' E*.txt
sed -i 's/eft\ \.\.\.cerre/eftcerre\ncerre/' E*.txt
sed -i 's/eft\ \.\.\.cerdon/eftcerdon\ncerdon/' E*.txt
sed -i '/eft\ \.\.\.to\ cerranne/d' E*.txt
sed -i 's/eft\ \.\.\.cerrde/eftcerrde\ncerrde/' E*.txt
sed -i 's/eft\ \.\.\.cerrende/eftcerrende\ncerrende/' E*.txt
sed -i 's/eft\ \.\.\.cerende/eftcerende\ncerende/' E*.txt
sed -i 's/eft\ \.\.\.cerde/eftcerde\ncerde/' E*.txt
sed -i 's/eft\ \.\.\.onfoanne/eftonfoanne\nonfoanne/' E*.txt
sed -i 's/eft\ to\ sellanne/eft\ to\ sellanne\nsellanne/' E*.txt
sed -i 's/eft\ to\ seallane/eft\ to\ seallane\nseallane/' E*.txt
sed -i 's/eft\ \.\.\.gesald/eftgesald\ngesald/' E*.txt
sed -i 's/eft\ \.\.\.wende/eftwende\nwende/' E*.txt
sed -i 's/olebearua\ ||/olebearua/' E*.txt
sed -i 's/yrðe\ yrðe/yrðe/' E*.txt
sed -i '/ælcne\ færeld/d' E*.txt
sed -i 's/y\.tiene\ ||\.xv\.na/y.tiene\n.xv.na/' E*.txt
sed -i 's/feox||\ feaxes/feox\nfeaxes/' E*.txt
sed -i 's/forspebienne\ for\ forswebienne/forspebienne\nforswebienne/' E*.txt
sed -i 's/fram\ \.\.\.awend/framawend\nawend/' E*.txt
sed -i 's/ðone\ flege/flege/' E*.txt
sed -i 's/\.\.\.\ gefleanne/gefleanne/' E*.txt
sed -i 's/gifleane\ ||/gifleane/' E*.txt
sed -i 's/filigeað|\ felgiað/filigeað\nfelgiað/' E*.txt
sed -i 's/fe\ \.\.\.cuoeð/fecuoeð\ncuoeð/' E*.txt
sed -i 's/fe\ \.\.\.cueð/fecueð\ncueð/' E*.txt
sed -i 's/\ forhycganne/forhycganne/' E*.txt
sed -i 's/frendles\ \.\.\.\ ne/frendlesne\nfrendles/' E*.txt
sed -i 's/fulweres\ Mart\ 5)/fulweres/' E*.txt
sed -i 's/forgefeð\.\ forgyfað/forgefeð\nforgyfað/' E*.txt
sed -i 's/forweorpe\ i/forweorpe/' E*.txt
sed -i 's/te\ fullfremmanne/fullfremmanne/' E*.txt
sed -i 's/\ fyrstmearca/fyrstmearca/' E*.txt
sed -i 's/faere\ ue/faere/' E*.txt
sed -i 's/friðe\ frumðe/friðe\nfrumðe/' E*.txt
sed -i '/ðæt\ \.\.\.\ feord/d' E*.txt
sed -i '/mid\ mycele\ ferde/d' E*.txt
sed -i 's/gidda\ as\ if\ f\./gidda/' E*.txt
sed -i '/cl\.\ 2or\ n\.\ noun\ \ gydde\ ?/d' E*.txt
sed -i '/Lch\ I\ MS\ O/d' E*.txt
sed -i 's/heardhortnesse\ heardhirtnysse/heardhortnesse\nheardhirtnysse/' E*.txt
sed -i 's/herieð\ ÆCHom\ I\ MS\ G/herieð/' E*.txt
sed -i 's/huelc\ \.\.\.\ iueres/huelciueres/' E*.txt
sed -i '/halali\ readings\ in\ Godric\ MSS\ GHIKL\ could\ alternatively\ be\ read\ as\ forms\ of\ the\ adj\.\ hālig\ q\.v\./d' E*.txt
sed -i 's/hafæst|\ hæfest/hafæst\nhæfest/' E*.txt
sed -i 's/te\ habbe/habbe/' E*.txt
sed -i 's/heg\ or\ an\ unusual\ spelling\ of\ ēac/heg/' E*.txt
sed -i 's/hwettan\ hwetten/hwettan\nhwetten/' E*.txt
sed -i 's/cierliscan\ cyrliscan/cierliscan\ncyrliscan/' E*.txt
sed -i '/^in\ pl\.$/d' E*.txt
sed -i '/^n\.\ more\ common$/d' E*.txt
sed -i ':a;N;$!ba;s/#\n/#/g' E*.txt
sed -E -i '3,$s/,\ /\n/g' E*.txt
sed -E -i '3,$s/,//g' E*.txt
sed -E -i '3,$s/\*//g' E*.txt
sed -E -i '3,$s/^to\ //' E*.txt
sed -E -i '3,$s/\ ge$//' E*.txt
sed -E -i '3,$s/\ we$//' E*.txt
sed -E -i '3,$s/\ tu$//' E*.txt
sed -E -i '3,$s/\ þu$//' E*.txt
sed -E -i '3,$s/\ ðu$//' E*.txt
sed -E -i '3,$s/\ eow$//' E*.txt
sed -i 's/|//g' E*.txt
sed -i '/^$/d' E*.txt

# Sort, and remove duplicate word forms:

mkdir -p unique
for i in E*.txt; do 
	(head -n 2 $i && tail -n +3 $i | sort -u) > unique/$i
done
mv unique/E*.txt .
rm -rf unique
cd ..
