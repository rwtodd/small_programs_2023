use v5.36;
use constant ABBREV => 'NVLA';
use constant CONTENTS => 'contents';

my %book_byname = (
   'Liber Genesis' => { 
     nav => [ CONTENTS, 'Liber Exodus' ],
     chapters => 50,
     latin => 'Liber Genesis' ,
     id => 1, 
     short => 'GEN',
     long => 'Genesis',
     testament => 'Old'
   },
   'Liber Exodus' => { 
     nav => [ 'Liber Genesis', 'Liber Leviticus'],
     chapters => 40,
     latin => 'Liber Exodus' ,
     id => 2, 
     short => 'EXO',
     long => 'Exodus',
     testament => 'Old'
   },
   'Liber Leviticus' => { 
     nav => [ 'Liber Exodus', 'Liber Numeri'],
     chapters => 27,
     latin => 'Liber Leviticus' ,
     id => 3, 
     short => 'LEV',
     long => 'Leviticus',
     testament => 'Old'
   },
   'Liber Numeri' => { 
     nav => [ 'Liber Leviticus', 'Liber Deuteronomii'],
     chapters => 36,
     latin => 'Liber Numeri' ,
     id => 4, 
     short => 'NUM',
     long => 'Numbers',
     testament => 'Old'
   },
   'Liber Deuteronomii' => { 
     nav => [ 'Liber Numeri', 'Liber Iosue'],
     chapters => 34,
     latin => 'Liber Deuteronomii' ,
     id => 5, 
     short => 'DEU',
     long => 'Deuteronomy',
     testament => 'Old'
   },
   'Liber Iosue' => { 
     nav => [ 'Liber Deuteronomii', 'Liber Iudicum'],
     chapters => 24,
     latin => 'Liber Iosue' ,
     id => 6, 
     short => 'JOS',
     long => 'Joshua',
     testament => 'Old'
   },
   'Liber Iudicum' => { 
     nav => [ 'Liber Iosue', 'Liber Ruth'],
     chapters => 21,
     latin => 'Liber Iudicum' ,
     id => 7, 
     short => 'JDG',
     long => 'Judges',
     testament => 'Old'
   },
   'Liber Ruth' => { 
     nav => [ 'Liber Iudicum', 'Liber I Samuelis'],
     chapters => 4,
     latin => 'Liber Ruth' ,
     id => 8, 
     short => 'RUT',
     long => 'Ruth',
     testament => 'Old'
   },
   'Liber I Samuelis' => { 
     nav => [ 'Liber Ruth', 'Liber II Samuelis'],
     chapters => 31,
     latin => 'Liber I Samuelis' ,
     id => 9, 
     short => '1SA',
     long => '1 Samuel',
     testament => 'Old'
   },
   'Liber II Samuelis' => { 
     nav => [ 'Liber I Samuelis', 'Liber I Regum'],
     chapters => 24,
     latin => 'Liber II Samuelis' ,
     id => 10, 
     short => '2SA',
     long => '2 Samuel',
     testament => 'Old'
   },
   'Liber I Regum' => { 
     nav => [ 'Liber II Samuelis', 'Liber II Regum'],
     chapters => 22,
     latin => 'Liber I Regum' ,
     id => 11, 
     short => '1KI',
     long => '1 Kings',
     testament => 'Old'
   },
   'Liber II Regum' => { 
     nav => [ 'Liber I Regum', 'Liber I Paralipomenon'],
     chapters => 25,
     latin => 'Liber II Regum' ,
     id => 12, 
     short => '2KI',
     long => '2 Kings',
     testament => 'Old'
   },
   'Liber I Paralipomenon' => { 
     nav => [ 'Liber II Regum', 'Liber II Paralipomenon'],
     chapters => 29,
     latin => 'Liber I Paralipomenon' ,
     id => 13, 
     short => '1CH',
     long => '1 Chronicles',
     testament => 'Old'
   },
   'Liber II Paralipomenon' => { 
     nav => [ 'Liber I Paralipomenon', 'Liber Esdrae'],
     chapters => 36,
     latin => 'Liber II Paralipomenon' ,
     id => 14, 
     short => '2CH',
     long => '2 Chronicles',
     testament => 'Old'
   },
   'Liber Esdrae' => { 
     nav => [ 'Liber II Paralipomenon', 'Liber Nehemiae'],
     chapters => 10,
     latin => 'Liber Esdrae' ,
     id => 15, 
     short => 'EZR',
     long => 'Ezra',
     testament => 'Old'
   },
   'Liber Nehemiae' => { 
     nav => [ 'Liber Esdrae', 'Liber Thobis'],
     chapters => 13,
     latin => 'Liber Nehemiae' ,
     id => 16, 
     short => 'NEH',
     long => 'Nehemiah',
     testament => 'Old'
   },
   'Liber Thobis' => { 
     nav => [ 'Liber Nehemiae', 'Liber Iudith'],
     chapters => 14,
     latin => 'Liber Thobis' ,
     id => 69, 
     short => 'TOB',
     long => 'Tobit',
     testament => 'Apocrypha'
   },
   'Liber Iudith' => { 
     nav => [ 'Liber Thobis', 'Liber Esther'],
     chapters => 16,
     latin => 'Liber Iudith' ,
     id => 67, 
     short => 'JDT',
     long => 'Judith',
     testament => 'Apocrypha'
   },
   'Liber Esther' => { 
     nav => [ 'Liber Iudith', 'Liber Iob'],
     chapters => 10,
     latin => 'Liber Esther' ,
     id => 17, 
     short => 'EST',
     long => 'Esther',
     testament => 'Old'
   },
   'Liber Iob' => { 
     nav => [ 'Liber Esther', 'Liber Psalmorum' ],
     chapters => 42,
     latin => 'Liber Iob' ,
     id => 18, 
     short => 'JOB',
     long => 'Job',
     testament => 'Old'
   },
   'Liber Psalmorum'  => { 
     nav => [ 'Liber Iob', 'Liber Proverbiorum'],
     chapters => 150,  # named PSALMUS-space-NUMBER
     latin => 'Liber Psalmorum',
     id => 19, 
     short => 'PSA',
     long => 'Psalms',
     testament => 'Old'
   },
   'Liber Proverbiorum' => { 
     nav => [ 'Liber Psalmorum' , 'Liber Ecclesiastes'],
     chapters => 31,
     latin => 'Liber Proverbiorum' ,
     id => 20, 
     short => 'PRO',
     long => 'Proverbs',
     testament => 'Old'
   },
   'Liber Ecclesiastes' => { 
     nav => [ 'Liber Proverbiorum', 'Canticum Canticorum'],
     chapters => 12,
     latin => 'Liber Ecclesiastes' ,
     id => 21, 
     short => 'ECC',
     long => 'Ecclesiastes',
     testament => 'Old'
   },
   'Canticum Canticorum' => { 
     nav => [ 'Liber Ecclesiastes', 'Liber Sapientiae'],
     chapters => 8,
     latin => 'Canticum Canticorum' ,
     id => 22, 
     short => 'SNG',
     long => 'Song of Solomon',
     testament => 'Old'
   },
   'Liber Sapientiae' => { 
     nav => [ 'Canticum Canticorum', 'Liber Ecclesiasticus'],
     chapters => 19,
     latin => 'Liber Sapientiae' ,
     id => 68, 
     short => 'WIS',
     long => 'Wisdom',
     testament => 'Apocrypha'
   },
   'Liber Ecclesiasticus' => { 
     nav => [ 'Liber Sapientiae', 'Liber Isaiae'],
     chapters => 51,
     latin => 'Liber Ecclesiasticus',
     id => 70, 
     short => 'SIR',
     long => 'Sirach',
     testament => 'Apocrypha'
   },
   'Liber Isaiae' => { 
     nav => [ 'Liber Ecclesiasticus', 'Liber Ieremiae'],
     chapters => 66,
     latin => 'Liber Isaiae' ,
     id => 23, 
     short => 'ISA',
     long => 'Isaiah',
     testament => 'Old'
   },
   'Liber Ieremiae' => { 
     nav => [ 'Liber Isaiae', 'Lamentationes'],
     chapters => 52,
     latin => 'Liber Ieremiae' ,
     id => 24, 
     short => 'JER',
     long => 'Jeremiah',
     testament => 'Old'
   },
   'Lamentationes' => { 
     nav => [ 'Liber Ieremiae', 'Liber Baruch'],
     chapters => 5,
     latin => 'Lamentationes' ,
     id => 25, 
     short => 'LAM',
     long => 'Lamentations',
     testament => 'Old'
   },
   'Liber Baruch' => { 
     nav => [ 'Lamentationes', 'Prophetia Ezechielis'],
     chapters => 6,
     latin => 'Liber Baruch' ,
     id => 71, 
     short => 'BAR',
     long => 'Baruch',
     testament => 'Apocrypha'
   },
   'Prophetia Ezechielis' => { 
     nav => [ 'Liber Baruch', 'Prophetia Danielis'],
     chapters => 48,
     latin => 'Prophetia Ezechielis' ,
     id => 26, 
     short => 'EZK',
     long => 'Ezekiel',
     testament => 'Old'
   },
   'Prophetia Danielis' => { 
     nav => [ 'Prophetia Ezechielis', 'Prophetia Osee'],
     chapters => 14,
     latin => 'Prophetia Danielis' ,
     id => 27, 
     short => 'DAN',
     long => 'Daniel',
     testament => 'Old'
   },
   'Prophetia Osee' => { 
     nav => [ 'Prophetia Danielis', 'Prophetia Ioel'],
     chapters => 14,
     latin => 'Prophetia Osee' ,
     id => 28, 
     short => 'HOS',
     long => 'Hosea',
     testament => 'Old'
   },
   'Prophetia Ioel' => { 
     nav => [ 'Prophetia Osee', 'Prophetia Amos'],
     chapters => 4,
     latin => 'Prophetia Ioel' ,
     id => 29, 
     short => 'JOL',
     long => 'Joel',
     testament => 'Old'
   },
   'Prophetia Amos' => { 
     nav => [ 'Prophetia Ioel', 'Prophetia Abdiae'],
     chapters => 9,
     latin => 'Prophetia Amos' ,
     id => 30, 
     short => 'AMO',
     long => 'Amos',
     testament => 'Old'
   },
   'Prophetia Abdiae' => { 
     nav => [ 'Prophetia Amos', 'Prophetia Ionae'],
     chapters => 1,
     latin => 'Prophetia Abdiae' ,
     id => 31, 
     short => 'OBA',
     long => 'Obadiah',
     testament => 'Old'
   },
   'Prophetia Ionae' => { 
     nav => [ 'Prophetia Abdiae', 'Prophetia Michaeae'],
     chapters => 4,
     latin => 'Prophetia Ionae' ,
     id => 32, 
     short => 'JON',
     long => 'Jonah',
     testament => 'Old'
   },
   'Prophetia Michaeae' => { 
     nav => [ 'Prophetia Ionae', 'Prophetia Nahum'],
     chapters => 7,
     latin => 'Prophetia Michaeae' ,
     id => 33, 
     short => 'MIC',
     long => 'Micah',
     testament => 'Old'
   },
   'Prophetia Nahum' => { 
     nav => [ 'Prophetia Michaeae', 'Prophetia Habacuc'],
     chapters => 3,
     latin => 'Prophetia Nahum' ,
     id => 34, 
     short => 'NAM',
     long => 'Nahum',
     testament => 'Old'
   },
   'Prophetia Habacuc' => { 
     nav => [ 'Prophetia Nahum', 'Prophetia Sophoniae'],
     chapters => 3,
     latin => 'Prophetia Habacuc' ,
     id => 35, 
     short => 'HAB',
     long => 'Habakkuk',
     testament => 'Old'
   },
   'Prophetia Sophoniae' => { 
     nav => [ 'Prophetia Habacuc', 'Prophetia Aggaei'],
     chapters => 3,
     latin => 'Prophetia Sophoniae' ,
     id => 36, 
     short => 'ZEP',
     long => 'Zephaniah',
     testament => 'Old'
   },
   'Prophetia Aggaei' => { 
     nav => [ 'Prophetia Sophoniae', 'Prophetia Zachariae'],
     chapters => 2,
     latin => 'Prophetia Aggaei' ,
     id => 37, 
     short => 'HAG',
     long => 'Haggai',
     testament => 'Old'
   },
   'Prophetia Zachariae' => { 
     nav => [ 'Prophetia Aggaei', 'Prophetia Malachiae'],
     chapters => 14,
     latin => 'Prophetia Zachariae' ,
     id => 38, 
     short => 'ZEC',
     long => 'Zechariah',
     testament => 'Old'
   },
   'Prophetia Malachiae' => { 
     nav => [ 'Prophetia Zachariae', 'Liber I Maccabaeorum'],
     chapters => 3,
     latin => 'Prophetia Malachiae' ,
     id => 39, 
     short => 'MAL',
     long => 'Malachi',
     testament => 'Old'
   },
   'Liber I Maccabaeorum' => { 
     nav => [ 'Prophetia Malachiae', 'Liber II Maccabaeorum'],
     chapters => 16,
     latin => 'Liber I Maccabaeorum' ,
     id => 72, 
     short => '1MA',
     long => '1 Maccabees',
     testament => 'Apocrypha'
   },
   'Liber II Maccabaeorum' => { 
     nav => [ 'Liber I Maccabaeorum', 'Evangelium secundum Matthaeum'],
     chapters => 15,
     latin => 'Liber II Maccabaeorum' ,
     id => 73, 
     short => '2MA',
     long => '2 Maccabees',
     testament => 'Apocrypha'
   },
   'Evangelium secundum Matthaeum' => { 
     nav => [ 'Liber II Maccabaeorum', 'Evangelium secundum Marcum'],
     chapters => 28,
     latin => 'Evangelium secundum Matthaeum' ,
     id => 40, 
     short => 'MAT',
     long => 'Matthew',
     testament => 'New'
   },
   'Evangelium secundum Marcum' => { 
     nav => [ 'Evangelium secundum Matthaeum', 'Evangelium secundum Lucam'],
     chapters => 16,
     latin => 'Evangelium secundum Marcum' ,
     id => 41, 
     short => 'MRK',
     long => 'Mark',
     testament => 'New'
   },
   'Evangelium secundum Lucam' => { 
     nav => [ 'Evangelium secundum Marcum', 'Evangelium secundum Ioannem'],
     chapters => 24,
     latin => 'Evangelium secundum Lucam' ,
     id => 42, 
     short => 'LUK',
     long => 'Luke',
     testament => 'New'
   },
   'Evangelium secundum Ioannem' => { 
     nav => [ 'Evangelium secundum Lucam', 'Actus Apostolorum'],
     chapters => 21,
     latin => 'Evangelium secundum Ioannem' ,
     id => 43, 
     short => 'JHN',
     long => 'John',
     testament => 'New'
   },
   'Actus Apostolorum' => { 
     nav => [ 'Evangelium secundum Ioannem', 'Epistula ad Romanos'],
     chapters => 28,
     latin => 'Actus Apostolorum' ,
     id => 44, 
     short => 'ACT',
     long => 'Acts',
     testament => 'New'
   },
   'Epistula ad Romanos' => { 
     nav => [ 'Actus Apostolorum', 'Epistula I ad Corinthios'],
     chapters => 16,
     latin => 'Epistula ad Romanos' ,
     id => 45, 
     short => 'ROM',
     long => 'Romans',
     testament => 'New'
   },
   'Epistula I ad Corinthios' => { 
     nav => [ 'Epistula ad Romanos', 'Epistula II ad Corinthios'],
     chapters => 16,
     latin => 'Epistula I ad Corinthios' ,
     id => 46, 
     short => '1CO',
     long => '1 Corinthians',
     testament => 'New'
   },
   'Epistula II ad Corinthios' => { 
     nav => [ 'Epistula I ad Corinthios', 'Epistula ad Galatas'],
     chapters => 13,
     latin => 'Epistula II ad Corinthios' ,
     id => 47, 
     short => '2CO',
     long => '2 Corinthians',
     testament => 'New'
   },
   'Epistula ad Galatas' => { 
     nav => [ 'Epistula II ad Corinthios', 'Epistula ad Ephesios'],
     chapters => 6,
     latin => 'Epistula ad Galatas' ,
     id => 48, 
     short => 'GAL',
     long => 'Galatians',
     testament => 'New'
   },
   'Epistula ad Ephesios' => { 
     nav => [ 'Epistula ad Galatas', 'Epistula ad Philippenses'],
     chapters => 6,
     latin => 'Epistula ad Ephesios' ,
     id => 49, 
     short => 'EPH',
     long => 'Ephesians',
     testament => 'New'
   },
   'Epistula ad Philippenses' => { 
     nav => [ 'Epistula ad Ephesios', 'Epistula ad Colossenses'],
     chapters => 4,
     latin => 'Epistula ad Philippenses' ,
     id => 50, 
     short => 'PHP',
     long => 'Philippians',
     testament => 'New'
   },
   'Epistula ad Colossenses' => { 
     nav => [ 'Epistula ad Philippenses', 'Epistula I ad Thessalonicenses'],
     chapters => 4,
     latin => 'Epistula ad Colossenses' ,
     id => 51, 
     short => 'COL',
     long => 'Colossians',
     testament => 'New'
   },
   'Epistula I ad Thessalonicenses' => { 
     nav => [ 'Epistula ad Colossenses', 'Epistula II ad Thessalonicenses'],
     chapters => 5,
     latin => 'Epistula I ad Thessalonicenses' ,
     id => 52, 
     short => '1TH',
     long => '1 Thessalonians',
     testament => 'New'
   },
   'Epistula II ad Thessalonicenses' => { 
     nav => [ 'Epistula I ad Thessalonicenses', 'Epistula I ad Timotheum'],
     chapters => 3,
     latin => 'Epistula II ad Thessalonicenses' ,
     id => 53, 
     short => '2TH',
     long => '2 Thessalonians',
     testament => 'New'
   },
   'Epistula I ad Timotheum' => { 
     nav => [ 'Epistula II ad Thessalonicenses', 'Epistula II ad Timotheum'],
     chapters => 6,
     latin => 'Epistula I ad Timotheum' ,
     id => 54, 
     short => '1TI',
     long => '1 Timothy',
     testament => 'New'
   },
   'Epistula II ad Timotheum' => { 
     nav => [ 'Epistula I ad Timotheum', 'Epistula ad Titum'],
     chapters => 4,
     latin => 'Epistula II ad Timotheum' ,
     id => 55, 
     short => '2TI',
     long => '2 Timothy',
     testament => 'New'
   },
   'Epistula ad Titum' => { 
     nav => [ 'Epistula II ad Timotheum', 'Epistulam ad Philemonem'],
     chapters => 3,
     latin => 'Epistula ad Titum' ,
     id => 56, 
     short => 'TIT',
     long => 'Titus',
     testament => 'New'
   },
   'Epistulam ad Philemonem' => { 
     nav => [ 'Epistula ad Titum', 'Epistula ad Hebraeos'],
     chapters => 1,
     latin => 'Epistulam ad Philemonem' ,
     id => 57, 
     short => 'PHM',
     long => 'Philemon',
     testament => 'New'
   },
   'Epistula ad Hebraeos' => { 
     nav => [ 'Epistulam ad Philemonem', 'Epistula Iacobi'],
     chapters => 13,
     latin => 'Epistula ad Hebraeos' ,
     id => 58, 
     short => 'HEB',
     long => 'Hebrews',
     testament => 'New'
   },
   'Epistula Iacobi' => { 
     nav => [ 'Epistula ad Hebraeos', 'Epistula I Petri'],
     chapters => 5,
     latin => 'Epistula Iacobi' ,
     id => 59, 
     short => 'JAS',
     long => 'James',
     testament => 'New'
   },
   'Epistula I Petri' => { 
     nav => [ 'Epistula Iacobi', 'Epistula II Petri'],
     chapters => 5,
     latin => 'Epistula I Petri' ,
     id => 60, 
     short => '1PE',
     long => '1 Peter',
     testament => 'New'
   },
   'Epistula II Petri' => { 
     nav => [ 'Epistula I Petri', 'Epistula I Ioannis'],
     chapters => 3,
     latin => 'Epistula II Petri' ,
     id => 61, 
     short => '2PE',
     long => '2 Peter',
     testament => 'New'
   },
   'Epistula I Ioannis' => { 
     nav => [ 'Epistula II Petri', 'Epistula II Ioannis'],
     chapters => 5,
     latin => 'Epistula I Ioannis' ,
     id => 62, 
     short => '1JN',
     long => '1 John',
     testament => 'New'
   },
   'Epistula II Ioannis' => { 
     nav => [ 'Epistula I Ioannis', 'Epistula III Ioannis'],
     chapters => 1,
     latin => 'Epistula II Ioannis' ,
     id => 63, 
     short => '2JN',
     long => '2 John',
     testament => 'New'
   },
   'Epistula III Ioannis' => { 
     nav => [ 'Epistula II Ioannis', 'Epistula Iudae'],
     chapters => 1,
     latin => 'Epistula III Ioannis' ,
     id => 64, 
     short => '3JN',
     long => '3 John',
     testament => 'New'
   },
   'Epistula Iudae' => { 
     nav => [ 'Epistula III Ioannis', 'Apocalypsis Ioannis'],
     chapters => 1,
     latin => 'Epistula Iudae' ,
     id => 65, 
     short => 'JUD',
     long => 'Jude',
     testament => 'New'
   },
   'Apocalypsis Ioannis' => {
     nav => [ 'Epistula Iudae', CONTENTS ],
     chapters => 22,
     latin => 'Apocalypsis Ioannis' ,
     id => 66,
     short => 'REV',
     long => 'Revelation',
     testament => 'New'
   }
);


say <<'HEADER';
== Contents ==
* [[Constitutio Apostolica (NVLA)|Constitutio Apostolica]]
* [[Praefatio ad Lectorem (NVLA)|Praefatio ad Lectorem]]
* [[Praenotanda (NVLA)|Praenotanda]]

=== Old Testament ===
HEADER

my $cur = $book_byname{'Liber Genesis'};

while($cur) {
  print "\n=== New Testament ===" if $cur->{short} eq 'MAT';
  print "\n; $$cur{latin}";
  print "\n: $$cur{long} ($$cur{short})";
  for my $count (1..$$cur{chapters}) {
    print(($count-1) % 10 == 0 ? "\n: " : " &bull; ");
    print("[[$$cur{long} $count (NVLA)|$count]]");
  }
} continue {
  $cur = $book_byname{$cur->{nav}->[1]};
}

say <<'FOOTER';

=== Appendex ===
* [[Decretum de Canonicis Scripturis (NVLA)|Decretum de Canonicis Scripturis]]
* [[Decretum de editione et usu Sacrorum Librorum (NVLA)|Decretum de editione et usu Sacrorum Librorum]]
* [[Praefatio ad Lectorem (trium editionum Clementinarum) (NVLA)|Praefatio ad Lectorem (trium editionum Clementinarum)]]

[[Category:Bibles]]
FOOTER
# vim: sw=2 expandtab
