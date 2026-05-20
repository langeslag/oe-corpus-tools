# This script extracts headword, POS, frequency, and attested spellings
# from the Dictionary of Old English A--H CD-ROM (if HTML at ./doe/).
# Copyright Paul Langeslag 2026
# TODO: readd epigraphy, which is filtered out by re.search
# TODO: consider cutting fragmentary readings
import json,re,argparse
from pathlib import Path
from bs4 import BeautifulSoup

argparser = argparse.ArgumentParser()
# This flag is for internal use only; it assumes you have access to a headword list
# formatted as a dictionary whose keys are imported if this option is used; this
# requires for each item value to be a tuple whose third value matches 'entry' below.
argparser.add_argument('--id', action='store_true')
args = argparser.parse_args()
if args.id == True:
    use_lemma_id = True
    print("Loading DOE headword data...")
    # Set path to headword list here if available:
    doe_headwords_json = 'doeheadwords.json'
    with open(doe_headwords_json) as json_data:
        doe_headwords = json.load(json_data)
else:
    use_lemma_id = False

html_folder = Path.cwd() / 'doe'
target_folder = Path.cwd() / 'attsp'
target_folder.mkdir(exist_ok=True)

# Substrings to be elided wherever they occur:
cuts = [
        '(the hypothesized infinitive headword is very uncertain, and the recorded hamacgað has been taken as a form of otherwise unrecorded *gemagian)',
        'There are occurrences of forms of anbidian with on- for an- : ',
        'glosses expectant in PsGlE 68.7, presumably for onbidaþ (see onbīdan, and cf. PsGlL 68.7 onbidað), but perhaps for onbidiaþ (cf. PsGlI anbidiaþ, PsGlGHK anbidiað, PsGlD anbidigað, PsGlF andbidiað).',
        '(the Tironian note, here represented by &, may possibly be taken as on-, thus giving a headword *onbīcnian',
        '(acc.sg.; ? or gen.pl.: cf. Heliand 438, 2017 for the gen.pl. phrase frio sconiosta)',
        '(or take as mutated comparatives of gnēaþ / gnēad, Bede MS B)',
        '(HomU 5.5, xiii; here the only attestation of a possibly strong form)',
        'for hohful with second element evidently associated with fullfremed, BenRGl)',
        '? Partial reading in gloss:',
        '(or perh. take as an instance of a wk. 1 vb. *blendan ‘to mix’)',
        '(gen.pl., HomM 15 [Wanley transcr.])',
        '(PsCaK, xii; ÆGram MS W, xiii);',
        'Spellings in -ng',
        'Forms originally proper to the dative are used for the general object case in some texts of s. xii and later',
        'Formed on pres.part.:',
        'Formed on stem:',
        'Reduced forms:',
        'In late North. texts:',
        '(with u [?] over wynn, acc.sg.)',
        '? With compar. first element:',
        'take as pret.subj.sg. of st. 7 vb. geblandan or as an instance of pret.indic.sg. of a wk. 1 vb. *geblendan',
        'take as pret.pl. of st. 7 vb. geblandan or as an instance of the pret.pl. of a wk. 1 vb. *geblendan',
        '(-leaf erased, ÆGl MS F)',
        '(for hand swa, BenR)',
        '(the MS character ⁊).',
        '(wynn, for the Tironian note, GenA 1120).',
        '(? for awille; or perh. for awillendlice or awillice; or if ā- is for ān-, perh. take as a form of ānwillendlīce [q.v.] or ānwillīce [q.v.])',
        ' (with first a and i added afterwards, ? for ageanhwirfte; or perh. ageanhwirfe, ageanhwirfenysse)',
        '(? p altered from c by later hand, AldV 1)',
        'Or perhaps take as forms of otherwise unattested efenheortnes',
        'The form may alternatively be taken as two words with helle as gen.sg. of hell',
        'hiwlæs with a second læs written immediately below the first',
        'Forms of the interrogative particle with -e',
        'these forms may represent scribal compromise between gnēað and gnȳðe',
        'These instances may alternatively be taken as forms of hēan adj',
        'With - es as a generalized adverbial marker',
        'these forms may alternatively be read as merographs of forms of hēahnes',
        'form may have arisen by confusion of the dat.inf. to gehealdenne = custodiendus with an adj. like deriendlic',
        '(BDSN MSS Hk, Kl2, Me, V, Z, xii-xv);',
        'I. Active forms and past part',
        'II. Passive forms excluding the past part',
        'adjectival inflectional endings are added to gen.sg.',
        'and dat.pl. forms. Genitives formed in this way generally decline as possessive adjectives',
        'and case. The motivation behind doubly inflected dative pl. forms is unclear',
        'with line-break in MS between her and heard',
        'agreeing with the modified noun in number',
        'A. Forms derived from the Germanic pres.pass. inflection',
        'used as both pres. and pret. pass.',
        'c(w)uc- forms belonging to the general adj. declension:',
        'these forms could also be taken as abbreviations for hlīsbǣre',
        'and hlīsig',
        'adjectival inflectional endings are added to gen.sg.',
        'and dat.pl. forms. Genitives formed in this way generally decline as possessive adjectives',
        'agreeing with the modified noun in number',
        'and case. The motivation behind doubly inflected dative pl. forms is unclear',
        'but these may have been invented in order to disambiguate dat.pl. heom from the identically spelled m./n.dat.sg. form. The attested forms are as follows',
        'Gen.pl. with m./n.dat.sg. or dat.pl. inflection',
        'For forms of the f.nom.sg. 3rd pers. pronoun beginning in sc',
        'perhaps written through confusion with forms of',
        'The hyrig- spellings may be formed from the root of the verb hȳrigan',
        'or may represent corrupt forms of hȳringmann2',
        'Gen.pl. with m./n.dat.sg. or dat.pl. inflection',
        'se gifra helle',
        'ðam deopan helle',
        'has been read as',
        'with brem repeated by dittography, Lch II)',
        'with traces of cm written above the line',
        'Uninfl. North. glosses of familias',
        'Gen.pl. with m./n.dat.sg. or dat.pl. inflection',
        'these forms have alternatively been taken as n.',
        'Dat.pl. with dat.pl. inflection',
        'inflected:',
        'all copies of HomS 11',
        '(Ch IWm [Douglas 7])',
        'Abbrev. form in a gloss',
        'Abbrev. forms in glosses: ',
        'Forms without mark of abbrev.:',
        'Also in an inscription now lost:',
        'Anom. forms',
        'Compromise spelling:',
        'Contracted forms:',
        'acc.sg./dat.sg.',
        'acc./gen.sg.',
        'Anom. form in a gloss',
        'Corrupt form in a gloss: ',
        'Corrupt forms in late MS',
        'In North. glosses',
        'Unambig. f. wk.',
        'As alternative gloss for fyðerfōte',
        'With st. inflections',
        'Northumbrian paradigm',
        'Forms without final n',
        'Unambiguous wk. 2 forms',
        'as if f., cl. 2 or n. noun * gydde ?',
        'as if f.',
        '(for grimman mannes, Bede MS B)',
        'Endingless in acc.sg.',
        'Spellings in eg- are mainly North',
        'Spellings in oe- are North',
        'Spellings in æu- are from ChronE additions',
        'Spellings in oef- are from Li',
        'Spellings in efeg- are from CP MS Camb.Trin. R.5.22',
        'Spellings with initial h are from CP MS CUL Ii.ii.4',
        'Forms in oe- are from DurRit',
        'Forms with -n- are Northumbrian',
        'note that endingless forms are also common',
        'Some spellings in gearn- may alternatively represent forms of earnung with initial g',
        'The manuscript is damaged and difficult to read',
        'The attestations are ambiguous and may be interpreted as forms of the adjective',
        'excluding all forms found also with other dialect groupings',
        'but the last letter is doubtful',
        'Spellings with -z- are found in MSS of s. x med. and later',
        'bedupe. Forms with -pt-',
        'pð could also be taken s.v. bedyppan',
        'in a number of citations confusion is attested in the variants',
        'Some forms in gearn- / georn- may alternatively be taken as forms of earnian with initial g',
        'Form in geard- may alternatively be taken as eard- with initial g',
        'Gen.pl. flana and dat.pl. flanum have been treated s.v. flān',
        'and treated as OE copied by foreign scribes',
        'For unambiguously weak forms',
        'occas. in s.xii MSS',
        'see cwene',
        'see scǣ',
        'With metathesis',
        'metathesis',
        'perh.',
        'scratched',
        'composition',
        'With unmetathesized suffix',
        'With inflected first element',
        'With merging of æl',
        'followed by first minim of u',
        '-ei- spellings are Northumbrian',
        'confessor may be either OE or Lat',
        'Forms with medial n predominate in Ælfric',
        'Spellings in eæll- are mainly in PsGlE',
        'Spellings in eærm(- are from PsCaE',
        'Spellings in æl-',
        'the combining form of eall',
        'for other gr- spellings',
        'With ǣ-',
        'Ch IIHen [PRO1912 3], xiv)',
        'Book of Kings',
        'cf. gringwræce s.v. cringan',
        '(f.nom./acc.pl.)',
        '(f./n.nom.sg., n.acc.sg.),'
        '&AElig;CHom I MS B, xii2',
        'Wk. forms with loss of inflectional -n',
        'Uninflected forms in glosses:',
        '(st.m./n.gen.sg., Abbo, PsGlG; ? st.m.acc.sg., Abbo).',
        ', st.f.dat.sg., AldV 13.1).',
        ', st.f.dat.sg., AldV 1, AldV 13.1),',
        '(wk.m.dat.sg., LambHom [Morris 10], xiii);',
        'xiv-xv',
        'cryptogram',
        'enclitic',
        'nom./',
        'unaccented',
        'mid mycele ferde',
        'altered',
        'wk.gen.pl.',
        'm.instr.sg.',
        'm./n.instr.sg.',
        '-i-/-ig-',
        'nom.sg.',
        'acc.sg. - ',
        'acc.sg.',
        'gen.sg. - ',
        'gen.sg. ',
        'dat.sg. - ',
        'dat.sg.',
        'tmesis',
        'both acc.pl.',
        'all 2nd pl.',
        'nom./acc.sg.',
        'nom./acc.pl.',
        'both acc.pl.',
        'acc./dat.',
        'pres.subj.',
        'pret.pl.',
        'pret.indic.sg.',
        'pret.subj.sg.',
        'Pres.ind.pl.',
        'Pres.ind.sg.',
        'Pres.subj.pl.',
        'Pres.subj.sg.',
        'Pret.ind.pl.',
        'Pret.ind.sg.',
        'Pret.subj.pl.',
        'Pret.subj.sg.',
        'nom.pl.',
        'acc.pl.',
        'gen.pl.',
        'dat.pl.',
        'pret.sg.',
        'prefix',
        'A.xiv',
        'Pres.part.',
        'pret.ind.',
        'pres.',
        'umlaut',
        'M. wk. with t',
        'gender',
        ' for h ',
        'With contr.',
        'Forms with -dd-',
        'Forms in LdGl',
        'Forms in -nd-',
        'Fragm. forms',
        'CollGl 38.6 are preserved in continental MSS',
        'f./n./',
        'Redupl. pret.',
        'ðone onsione',
        'hæ nū',
        'initial',
        'nom./acc./gen./',
        'ðis hælo',
        'expanded as ',
        'm. more common',
        'ambig.',
        'added',
        'Indecl. forms:',
        'shortened',
        'M. cl. 3 (pl.)',
        'Wk. m ',
        'Wk. 1',
        'St. pl.',
        'In sg.',
        'with -m',
        'cl. 3',
        'cl. 4',
        '2nd sg',
        'm./f.',
        'gen.sg./',
        'wk.',
        'st.',
        'cf.',
        'PPs [prose]',
        'M. or N.',
        'inflections',
        'm./f./n.',
        'm./n.dat.sg.',
        'in pl.',
        'n. more common',
        'belonging',
        'xii/xiii',
        'xii-xiii',
        'xiii',
        'xii',
        'xiv',
        's.xvi',
        'adj.',
        'transcr.',
        'part.',
        'declined',
        'spellings',
        'associated',
        'vowel',
        'imp.sg.',
        'nom.',
        'acc.',
        'gen.',
        'dat.',
        'inst.',
        'The form',
        ',',
        ':',
        ';',
        '·',
        '=',
        '|',
        '(',
        ')',
        '[',
        ']',
        '*',
        '‘',
        '’',
#        '/',
        '\\'
]

# Replacement rules:
regex = [
        (r'(heahlice) readings in Godric MSS GHIKL could alternatively be read as forms of the adj. hālig q.v.', r'\1'),
        (r'(halali) readings in Godric MSS GHIKL could alternatively be read as forms of the adj. hālig q.v.', r'\1'),
        (r'In late OE some forms of onbīdan with prefix.*$', ''),
        (r'^Anom\. form: ᚹ.*$', ''),
        (r'firgingatā \(\? -ā for -ena, \? -ā for -am\), ', 'firgingatā firgingatena firgingatam'),
        (r'(afursed)\. -eo- spellings occur in Psalters FGK', r'\1'),
        (r'awifte \(with w for p\)', 'awifte apifte'),
        (r' \(both for dat\.sg\. (ametenum)\)', r'\1'),
        (r'hweoga \(with g for þ.*\)', 'hweoga hweoþa'),
        (r'confusion with ǣghwæðer.*$', ''),
        (r'(heg) or an unusual spelling of ēac', r'\1'),
        (r'ða (bydel)', r'\1'),
        (r'brim faro. ðæs', 'brimfaro'),
        (r'(bradeleaces). Final e in composition is unique to this compound of brad', r'\1'),
        (r'bituinf letnise', 'bituinfletnise'),
        (r'the word has been read as (betothecd)', r'\1'),
        (r'brondas ðencan', ''),
        (r'\(cipher for ([^,]*), [^)]*\)', r'\1'),
        (r'(geembehte) ðu', r'\1'),
        (r'(ƀ(scop)?) ChronF\)', r'\1'),
        (r'((ge)?anlich?ie) we', r'\1'),
        (r'(nage) we', r'\1'),
        (r'(agefe) ue', r'\1'),
        (r'ðone (eage)', r'\1'),
        (r'ᚪ ᛚ ᛗ ᛖ ᛇ ᛏ ᛏ ᛁ ᚷ', 'ᚪᛚᛗᛖᛇᛏᛏᛁᚷ'),
        (r'·(ᛖ) ·(ᚹ) ·(ᚢ)·', r'\1\2\3'),
        (r'(ᚷᚫᚱᚩᚻᛁ) = (GÆROHI)', r'\1 gærohi'),
        (r'menn cyni', 'menncyni'),
        (r'(aldor) \.\.\. (sacerdæs)', r'\1\2'),
        (r'(aldor) \.\.\. (sacerda)', r'\1\2'),
        (r'(efne) \.\.\.(acunn)', r'\1\2 \2'),
        (r'(alduras) (sacerdas)', r'\1\2'),
        (r'(dagae) note that endingless forms are also common', r'\1'),
        (r'gedæled edlice', 'gedælededlice'),
        (r'mid cwealmlicre (flihte)', r'\1'),
        (r'se (ansine)', r'\1'),
        (r'Standard Paradigm (deoflu)', r'\1'),
        (r'Jun. Transcr. 71 (ægewriteras)', r'\1'),
        (r'presumably\ for\ (onbidað)', r'\1'),
        (r'but\ perhaps\ for\ (onbidiað)', r'\1'),
        (r'(egewritteras) and scepttenras have been suggested as possible readings', r'\1'),
        (r'(onbidedon).\ The\ form\ (onbiduð)\ glosses\ expectant\ in\ PsGlE\ 68\.7', r'\1 \2'),
        (r'm.pl. (deoflas) in Aldred', r'\1'),
        (r'(afyrsað). -eo- spellings occur in Psalters FGK', r'\1'),
        (r'(ædeawado). Past tense forms perhaps show influence of wk. 2 on wk. 1', r'\1'),
        (r'The spelling ǣrendwreca is etymological.*explanation, narrative’', ''),
        (r'a (æsnungdrenceas)', r'\1'),
        (r'wesan (draegtre)', r'\1'),
        (r'mid ðysse (hrægle)', r'\1'),
        (r'(eardungstowe) ðinum', r'\1'),
        (r'(earlippricco) \.\.\.\ ðio', r'\1'),
        (r'ða (earelipprica)', r'\1'),
        (r'(earliprica) ðæt', r'\1'),
        (r'\(for ([^,]*), [^)]*\)', r'\1'),
        (r'\(prob\. for ([^,]*), [^)]*\)', r'\1'),
        (r'\(\?? ?miswritten for ([^,]*), [^)]*\)', r'\1'),
        (r'\(\?? ?in error for ([^,]*), [^)]*\)', r'\1'),
        (r'\(= ([^,]*) for ([^,]*), [^)]*\)', r'\1 \2'),
        (r'\([^)]{0,20}\? for ([^,]*), [^)]*\)', r'\1'),
        (r' \([A-ZÆÞÐĘa-zæþðęāǣēīōūȳĀǢĒĪŌŪȲ0-9., ]+\)', ''),
        (r'b[ei]o ge', ''),
        (r'(derb) s', r'\1'),
        (r'Abbrev\. form\.(xv)\.(an)', r'\1\2'),
        (r'Abbrev\. forms\.(v)\.(tiene)', r'\1\2'),
        (r'Corrupt forms of (nraef)', r'\1'),
        (r'nænne (færeld)', r'\1'),
        (r'ælcne (færeld)', r'\1'),
        (r'y\.tiene \|*\.xv\.na', 'ytiene xvna'),
        (r'(forspebienne) for (forswebienne)', r'\1 \2'),
        (r'North\. (geheras)', r'\1'),
        (r'ða (heane)', r'\1'),
        (r'ðæt (færelt)', r'\1'),
        (r'ðet (foster)', r'\1'),
        (r'te (hernise)', r'\1'),
        (r'ðæt mycele (gylp)', r'\1'),
        (r'ðæt (geagl)', r'\1'),
        (r'(godene) or (godere)', r'\1 \2'),
        (r'se (fyrstmearce)', r'\1'),
        (r'se (druncnesse)', r'\1'),
        (r'(in) (sið) (gryre)', r'\1\2\3'),
        (r'mid mycclum (fyrde)', r'\1'),
        (r'ðio (earliprece) ðone', r'\1'),
        (r'(fore) (fengnisse)', r'\1\2'),
        (r'(græi) (an)', r'\1\2'),
        (r'(forcyððed) \(MSol', r'\1'),
        (r'(forbinde) ge', r'\1'),
        (r'(folce) (getrume)', r'\1\2'),
        (r'(huru) (fæðmum)', r'\1\2'),
        (r'(imbrae) (rae)', r'\1\2'),
        (r'(hea) (an)', r'\1\2'),
        (r'(earlipprica) \.\.\. ðio', r'\1'),
        (r'ðone (ęarliprica)', r'\1'),
        (r'(eolhxsecg) Hickes transcr\. (eolhx) (secc)', r'\1 \2\3'),
        (r'(galpania) ⁊ anan', r'\1'),
        (r'\.\.\. (gefleanne)', r'\1'),
        (r'(efne) \.\.\.(gesette)', r'\1\2'),
        (r'(efne) \.\.\.(geworhte)', r'\1\2'),
        (r'(eft) \.\.\.(\w+)', r'\1\2 \2'),
        (r'(fe) \.\.\.(cuoeð)', r'\1\2'),
        (r'(frendles) \.\.\. (ne)', r'\1 \1\2'),
        (r'(for[ðþ]) \.\.\.(\w+)', r'\1\2'),
        (r'(for) \.\.\.(\w+)', r'\1\2'),
        (r'f\.(hracan)', r'\1'),
        (r'(ge) \.\.\.(\w+)', r'\1\2'),
        (r'(fore) \.\.\.(\w+)', r'\1\2'),
        (r'(fram) \.\.\.(\w+)', r'\1\2'),
        (r'(from) \.\.\.(\w+)', r'\1\2'),
        (r'(fyrn) \.\.\.(\w+)', r'\1\2'),
        (r'(fe) \.\.\.(\w+)', r'\1\2'),
        (r'(heh) \.\.\.(\w+)', r'\1\2'),
        (r'(huelc) \.\.\. (iueres)', r'\1\2'),
        (r'(eft) (to) (\w*nne)', r'\3 \1\2'),
        (r'(yrðe) yrðe', r'\1'),
        (r'(geafæn) \.\.\.(læce)', r'\1\2'),
        (r'(behydda) \.\.\. (dedre)', r'\1\2'),
        (r'(cul) (bod) (gehnades) with\ ł\ cum\ bel\ written\ above\ cul\ bod\ in\ a\ later\ hand', r'\1\2\3'),
        (r'fr (fræge)', r'\1'),
        (r'PsGl[A-N]+', ''),
        (r'se (burhwaru)', r'\1'),
        (r'(forgife) ge', r'\1'),
        (r'(freo) (don)', r'\1\2'),
        (r'se (fyrd)', r'\1'),
        (r'(forweorpe) i', r'\1'),
        (r'te (fullfremmanne)', r'\1'),
        (r'(faere) ue', r'\1'),
        (r'ðæt\ \.\.\.\ feord', ''),
        (r'ðæt (ferd)', r'\1'),
        (r'w (feounge)', r'\1'),
        (r'(foresce) (g)', r'/\1\2'),
        (r'te (habbe)', r'\1'),
        (r'(forewit) (tiendlicer)', r'\1\2'),
        (r'(hen) se', r'\1'),
        (r'þet (foster)', r'\1'),
        (r'(an) (twig)', r'\1\2')
]

# Sequences to be replaced by a space wherever thy occur:
spaces = [
        ' ||| ',
        ' || ',
        ' | ',
        ', '
        '; ',
        ' or '
]

# Forms that should not be accepted as spellings:
disallow_forms = [
        'assim',
        'erased',
        'past',
        'charter',
        'viii',
        'xi',
        'mix',
        'out',
        'document',
        'preceding',
        'reading',
        'with',
        'scribe',
        'emended',
        'form',
        'forms',
        'medial',
        'corrupt',
        'context',
        'to',
        'xv',
        'transcript',
        'take',
        'the',
        'instance',
        'glosses',
        'inflection',
        'metathesis',
        'sense',
        'we',
        'late',
        'glossing',
        'gloss',
        'by',
        'n',
        'd',
        'y'
]

# Forms that are admissible only for the listed headwords:
exceptions = {
        'a': ['ān', 'ā-gēn, ā-gēan', 'a noun', 'ā adv.', 'a prep.', 'ac', 'antefn', 'ǣ', 'ēa noun', 'hwā, hwæt'],
        'are': ['ān', 'ār1, āre', 'ār2', 'ārian', 'ǣr adv., prep. and conj.', 'ǣrra, ǣrest', 'ēar2'],
        'as': ['eall-swā'],
        'æ': ['*arce-pallium, *arcebisceop-pallium', 'ā adv.', 'æ', 'ǣ', 'æt prep. and adv.', 'æt prep. and adv.', 'ēa noun', 'eall adj.', 'etan'],
        'b': ['b', 'bisceop'],
        'c': ['cennan', 'crist', 'c'],
        'C': ['confessor', 'c'],
        'd': ['dryhten', 'd', 'hold noun1'],
        'e': ['e', 'ēa noun', 'hell, helle'],
        'E': ['e'],
        'f': ['f', 'fæst', 'for', 'for-tyhtend, for-tyhtiend'],
        'F': ['f'],
        'for': ['fēower', 'fōr1', 'forma, fyrmest adj.', 'fōr2, foor', 'forð', 'feorr adv.', 'for', 'for-gnagan', 'for-inlīce', 'faran'],
        'from': ['fram adj.', 'fram prep. and adv.'],
        'g': ['ge·croged', 'g', 'ge·croged', 'god', 'gōd adj.', 'gān', 'gēar', 'glæd adj.', 'ge conj.'],
        'G': ['g'],
        'ge': ['ǣ', 'ge, gei', 'gē pron.', 'ge conj.', 'gēa', 'ge·hwilcnes'],
        'h': ['h', 'hāl', 'hǣlend', 'hrōf', 'hēr', 'hū', 'hē, hēo, hit', 'hwā, hwæt', 'holt', 'healf noun'],
        'H': ['h'],
        'i': ['i'],
        'I': ['i'],
        'ix': ['ex1'],
        'in': ['in prep. and adv.', 'in adv., inn', 'inn noun'],
        'k': ['cyning, cyng'],
        'o': ['ā adv.', 'hōh'],
        'of': ['hof', 'of prep.', 'of adv.'],
        'r': ['hēr', 'ge·hȳran1'],
        't': ['hwīt adj.'],
        'ðone': ['þonne adv.', 'þonne conj.', 'þon', 'sē, þæt, sēo'], # wait for final form of that last one
        'ðu': ['þu', 'þū', 'þā adv.', 'þā conj.'], # wait for final form of headword ID 28439
        'u': ['fers, uers'],
        'we': ['we', 'wē']
}

def extract():
    entries = dict()
    inverted = dict()
    for entry in html_folder.glob('*.html'):
        ref = entry.name[:-5]
        print(ref)
        if use_lemma_id == True:
            lemma_id = next((k for k,v in doe_headwords.items() if v[2] == ref), None)
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
        spellings = sorted(list(set(spellings)))
        purged_spellings = sorted(list(set([form for form in spellings 
                            if form not in disallow_forms 
                            and not (form in exceptions and not lemma in exceptions[form])
                            and re.search("^[a-zþæðęłœøƀāēīōūȳ\u16A0-\u16FF]+$", form)
                            ])))
    
        entry_dict = {}
        if use_lemma_id:
            entry_dict['id'] = lemma_id
        entry_dict['lemma'] = lemma
        entry_dict['pos'] = pos
        entry_dict['freq'] = occ
        entry_dict['attsp'] = purged_spellings
        entries[ref] = entry_dict
        for spelling in purged_spellings:
            if not spelling in inverted:
                inverted[spelling] = []
            if not ref in inverted[spelling]:
                inverted[spelling].append((ref, lemma, pos, occ))
            inverted[spelling] = sorted(inverted[spelling], key=lambda x: x[3], reverse=True)
    inverted = dict(sorted(inverted.items()))
    entries = dict(sorted(entries.items()))
    
    with open('attsp.json', 'w', encoding='utf-8') as output:
        json.dump(entries, output, ensure_ascii=False, indent=4)
    
    with open('attsp_inverted.json', 'w') as outfile:
        json.dump(inverted, outfile)
    
    for k,v in entries.items():
        filename = k + '.txt'
        outfile = Path.cwd() / 'attsp' / filename
        if outfile.is_file():
            outfile.unlink()
        with open(outfile, 'w') as f:
            f.write('# ' + v['lemma'] + '\n')
            f.write('# ' + v['pos'] + '\n')
            f.write('# ' + v['freq'])
            for i in v['attsp']:
                f.write(f'\n{i}')

if __name__ == '__main__':
    extract()
