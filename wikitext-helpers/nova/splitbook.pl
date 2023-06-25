#!/usr/bin/env perl

use v5.36;
use builtin qw(trim);
no warnings 'experimental::builtin';
use File::Basename;

use constant OUTDIR => 'out';
use constant ABBREV => 'NVLA';
use constant CONTENTS => 'Nova Vulgata (NVLA)';

sub contents_link($says="Contents") { sprintf("[[%s|%s]]", CONTENTS, $says) }

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
     nav => [ 'Epistula III Ioannis', 'Apocalypsis Ioannis' ],
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

use constant SRCDIR => './www.vatican.va/archive/bible/nova_vulgata/documents/';

my %filenames = (
'nova-vulgata_vt_genesis_lt.txt'                       => 'Liber Genesis',
'nova-vulgata_vt_exodus_lt.txt'                        => 'Liber Exodus',
'nova-vulgata_vt_leviticus_lt.txt'                     => 'Liber Leviticus',
'nova-vulgata_vt_numeri_lt.txt'                        => 'Liber Numeri',
'nova-vulgata_vt_deuteronomii_lt.txt'                  => 'Liber Deuteronomii',
'nova-vulgata_vt_iosue_lt.txt'                         => 'Liber Iosue',
'nova-vulgata_vt_iudicum_lt.txt'                       => 'Liber Iudicum',
'nova-vulgata_vt_ruth_lt.txt'                          => 'Liber Ruth',
'nova-vulgata_vt_i-samuelis_lt.txt'                    => 'Liber I Samuelis',
'nova-vulgata_vt_ii-samuelis_lt.txt'                   => 'Liber II Samuelis',
'nova-vulgata_vt_i-regum_lt.txt'                       => 'Liber I Regum',
'nova-vulgata_vt_ii-regum_lt.txt'                      => 'Liber II Regum',
'nova-vulgata_vt_i-paralipomenon_lt.txt'               => 'Liber I Paralipomenon',
'nova-vulgata_vt_ii-paralipomenon_lt.txt'              => 'Liber II Paralipomenon',
'nova-vulgata_vt_esdrae_lt.txt'                        => 'Liber Esdrae',
'nova-vulgata_vt_nehemiae_lt.txt'                      => 'Liber Nehemiae',
'nova-vulgata_vt_thobis_lt.txt'                        => 'Liber Thobis',
'nova-vulgata_vt_iudith_lt.txt'                        => 'Liber Iudith',
'nova-vulgata_vt_esther_lt.txt'                        => 'Liber Esther',
'nova-vulgata_vt_iob_lt.txt'                           => 'Liber Iob',
'nova-vulgata_vt_psalmorum_lt.txt'                     => 'Liber Psalmorum' ,
'nova-vulgata_vt_proverbiorum_lt.txt'                  => 'Liber Proverbiorum',
'nova-vulgata_vt_ecclesiastes_lt.txt'                  => 'Liber Ecclesiastes',
'nova-vulgata_vt_canticum-canticorum_lt.txt'           => 'Canticum Canticorum',
'nova-vulgata_vt_sapientiae_lt.txt'                    => 'Liber Sapientiae',
'nova-vulgata_vt_ecclesiasticus_lt.txt'                => 'Liber Ecclesiasticus',
'nova-vulgata_vt_isaiae_lt.txt'                        => 'Liber Isaiae',
'nova-vulgata_vt_ieremiae_lt.txt'                      => 'Liber Ieremiae',
'nova-vulgata_vt_lamentationes_lt.txt'                 => 'Lamentationes',
'nova-vulgata_vt_baruch_lt.txt'                        => 'Liber Baruch',
'nova-vulgata_vt_ezechielis_lt.txt'                    => 'Prophetia Ezechielis',
'nova-vulgata_vt_danielis_lt.txt'                      => 'Prophetia Danielis',
'nova-vulgata_vt_osee_lt.txt'                          => 'Prophetia Osee',
'nova-vulgata_vt_ioel_lt.txt'                          => 'Prophetia Ioel',
'nova-vulgata_vt_amos_lt.txt'                          => 'Prophetia Amos',
'nova-vulgata_vt_abdiae_lt.txt'                        => 'Prophetia Abdiae',
'nova-vulgata_vt_ionae_lt.txt'                         => 'Prophetia Ionae',
'nova-vulgata_vt_michaeae_lt.txt'                      => 'Prophetia Michaeae',
'nova-vulgata_vt_nahum_lt.txt'                         => 'Prophetia Nahum',
'nova-vulgata_vt_habacuc_lt.txt'                       => 'Prophetia Habacuc',
'nova-vulgata_vt_sophoniae_lt.txt'                     => 'Prophetia Sophoniae',
'nova-vulgata_vt_aggaei_lt.txt'                        => 'Prophetia Aggaei',
'nova-vulgata_vt_zachariae_lt.txt'                     => 'Prophetia Zachariae',
'nova-vulgata_vt_malachiae_lt.txt'                     => 'Prophetia Malachiae',
'nova-vulgata_vt_i-maccabaeorum_lt.txt'                => 'Liber I Maccabaeorum',
'nova-vulgata_vt_ii-maccabaeorum_lt.txt'               => 'Liber II Maccabaeorum',
'nova-vulgata_nt_evang-matthaeum_lt.txt'               => 'Evangelium secundum Matthaeum',
'nova-vulgata_nt_evang-marcum_lt.txt'                  => 'Evangelium secundum Marcum',
'nova-vulgata_nt_evang-lucam_lt.txt'                   => 'Evangelium secundum Lucam',
'nova-vulgata_nt_evang-ioannem_lt.txt'                 => 'Evangelium secundum Ioannem',
'nova-vulgata_nt_actus-apostolorum_lt.txt'             => 'Actus Apostolorum',
'nova-vulgata_nt_epist-romanos_lt.txt'                 => 'Epistula ad Romanos',
'nova-vulgata_nt_epist-i-corinthios_lt.txt'            => 'Epistula I ad Corinthios',
'nova-vulgata_nt_epist-ii-corinthios_lt.txt'           => 'Epistula II ad Corinthios',
'nova-vulgata_nt_epist-galatas_lt.txt'                 => 'Epistula ad Galatas',
'nova-vulgata_nt_epist-ephesios_lt.txt'                => 'Epistula ad Ephesios',
'nova-vulgata_nt_epist-philippenses_lt.txt'            => 'Epistula ad Philippenses',
'nova-vulgata_nt_epist-colossenses_lt.txt'             => 'Epistula ad Colossenses',
'nova-vulgata_nt_epist-i-thessalonicenses_lt.txt'      => 'Epistula I ad Thessalonicenses',
'nova-vulgata_nt_epist-ii-thessalonicenses_lt.txt'     => 'Epistula II ad Thessalonicenses',
'nova-vulgata_nt_epist-i-timotheum_lt.txt'             => 'Epistula I ad Timotheum',
'nova-vulgata_nt_epist-ii-timotheum_lt.txt'            => 'Epistula II ad Timotheum',
'nova-vulgata_nt_epist-titum_lt.txt'                   => 'Epistula ad Titum',
'nova-vulgata_nt_epist-philemonem_lt.txt'              => 'Epistulam ad Philemonem',
'nova-vulgata_nt_epist-hebraeos_lt.txt'                => 'Epistula ad Hebraeos',
'nova-vulgata_nt_epist-iacobi_lt.txt'                  => 'Epistula Iacobi',
'nova-vulgata_nt_epist-i-petri_lt.txt'                 => 'Epistula I Petri',
'nova-vulgata_nt_epist-ii-petri_lt.txt'                => 'Epistula II Petri',
'nova-vulgata_nt_epist-i-ioannis_lt.txt'               => 'Epistula I Ioannis',
'nova-vulgata_nt_epist-ii-ioannis_lt.txt'              => 'Epistula II Ioannis',
'nova-vulgata_nt_epist-iii-ioannis_lt.txt'             => 'Epistula III Ioannis',
'nova-vulgata_nt_epist-iudae_lt.txt'                   => 'Epistula Iudae',
'nova-vulgata_nt_apocalypsis-ioannis_lt.txt'           => 'Apocalypsis Ioannis'
);

my @toc_order = (
  'Liber Genesis',
  'Liber Exodus',
  'Liber Leviticus',
  'Liber Numeri',
  'Liber Deuteronomii',
  'Liber Iosue',
  'Liber Iudicum',
  'Liber Ruth',
  'Liber I Samuelis',
  'Liber II Samuelis',
  'Liber I Regum',
  'Liber II Regum',
  'Liber I Paralipomenon',
  'Liber II Paralipomenon',
  'Liber Esdrae',
  'Liber Nehemiae',
  'Liber Thobis',
  'Liber Iudith',
  'Liber Esther',
  'Liber Iob',
  'Liber Psalmorum' ,
  'Liber Proverbiorum',
  'Liber Ecclesiastes',
  'Canticum Canticorum',
  'Liber Sapientiae',
  'Liber Ecclesiasticus',
  'Liber Isaiae',
  'Liber Ieremiae',
  'Lamentationes',
  'Liber Baruch',
  'Prophetia Ezechielis',
  'Prophetia Danielis',
  'Prophetia Osee',
  'Prophetia Ioel',
  'Prophetia Amos',
  'Prophetia Abdiae',
  'Prophetia Ionae',
  'Prophetia Michaeae',
  'Prophetia Nahum',
  'Prophetia Habacuc',
  'Prophetia Sophoniae',
  'Prophetia Aggaei',
  'Prophetia Zachariae',
  'Prophetia Malachiae',
  'Liber I Maccabaeorum',
  'Liber II Maccabaeorum',
  'Evangelium secundum Matthaeum',
  'Evangelium secundum Marcum',
  'Evangelium secundum Lucam',
  'Evangelium secundum Ioannem',
  'Actus Apostolorum',
  'Epistula ad Romanos',
  'Epistula I ad Corinthios',
  'Epistula II ad Corinthios',
  'Epistula ad Galatas',
  'Epistula ad Ephesios',
  'Epistula ad Philippenses',
  'Epistula ad Colossenses',
  'Epistula I ad Thessalonicenses',
  'Epistula II ad Thessalonicenses',
  'Epistula I ad Timotheum',
  'Epistula II ad Timotheum',
  'Epistula ad Titum',
  'Epistulam ad Philemonem',
  'Epistula ad Hebraeos',
  'Epistula Iacobi',
  'Epistula I Petri',
  'Epistula II Petri',
  'Epistula I Ioannis',
  'Epistula II Ioannis',
  'Epistula III Ioannis',
  'Epistula Iudae',
  'Apocalypsis Ioannis'
);

sub prev_chapter_link($book, $chap_num) {
  $chap_num--;
  if($chap_num <= 0) {
    $book = $book_byname{$book->{nav}->[0]};
    return contents_link() if(! defined $book);
    $chap_num = $$book{chapters};
  }
  return sprintf('[[%s %d (%s)|%s %d]]', $$book{long}, $chap_num, ABBREV, $$book{short}, $chap_num);
}
sub next_chapter_link($book, $chap_num) {
  $chap_num++;
  if($chap_num > $$book{chapters}) {
    $book = $book_byname{$book->{nav}->[1]};
    return contents_link() if(! defined $book);
    $chap_num =  1;
  }
  return sprintf('[[%s %d (%s)|%s %d]]', $$book{long}, $chap_num, ABBREV, $$book{short}, $chap_num);
}

sub chapter_page_name($book, $chap_num) {
  sprintf("%s %d (%s)", $$book{long}, $chap_num, ABBREV);
}

sub chapter_file_name($page_name) { ($page_name =~ tr/ /_/r) . ".wikitext" }

sub write_chapter($fh, $book, $chap_num) {
  my $book_name = $$book{latin};
  my $filename = sprintf('%s/%s %d (%s).wikitext', OUTDIR, $$book{long}, $chap_num, ABBREV);
  $filename =~ tr/ /_/;
  open my $chap_file, '>:utf8', $filename or die "Can't open out file!";

  my $nxtlink = next_chapter_link($book, $chap_num);
  { # write the navigatoin header
    my $prvlink = prev_chapter_link($book, $chap_num);
    $chap_file->print(<<~"NAV");
    {{Bible $$book{testament} Nav
    |1=Nova Vulgata (NVLA)
    |2=$$book{long} $chap_num
    |3=$prvlink
    |4=$nxtlink}}
    NAV
  }
  my $next_chap;
  my $verse = 0;
  if($book_name eq 'Liber Psalmorum') {
    # deal with the PSALMUS line
    my $pline = <$fh>;
    chomp($pline);
    die "Bad psalm <$chap_num>!" unless $pline =~ m/^PSALMUS/;
    $chap_file->say("'''$pline'''");
  }
  $chap_file->say("<ol>");
  while(<$fh>) {
    $_ = trim($_);            # get rid of stray whitespace
    s/--/&mdash;/g;           # convert 'manual' mdashes..
    s/\x{201c} */\x{201c}/g;  # there's a lot of weird space around the smart quotes, for wome reason...
    s/ *\x{201d}/\x{201d}/g;

    my @skipped = ();
    while(s/^\((\d+)\) *//) {
       push @skipped, $1;
    }
    if(s/^(\d+) *//) {
      if(!length) {
        $next_chap = $1 + 0;
        last;
      }
      $chap_file->say("</p></li>") if($verse);
      if($1 == 1 + $verse) {
        $chap_file->print("<li>");
      } else {
        warn "<$book_name $chap_num>: Skipping verse to $1!"
          unless $verse + @skipped + 1 == $1;
        $chap_file->print("<li value=\"$1\">");
      }
      $verse = $1;
      $chap_file->print("<p id=\"V$verse\">");
    } else {
      warn "$book_name $chap_num verse (marked) as skipped but not a verse! <@skipped>"
        if(scalar @skipped);
      $chap_file->say("<br/>") if($verse);
    }
    $chap_file->print("<span id=\"$_\"></span>") for @skipped;
    $chap_file->print($_);
  }
  $chap_file->say("</p></li></ol>");
  $chap_file->say("\n&rarr; $nxtlink &rarr;\n[[Category:Bible Texts (NVLA)]]");
  close $chap_file;

  if(defined $next_chap && $chap_num + 1 != $next_chap) {
    warn "chapter went from <$chap_num> to <$next_chap>??"
  }
  return $next_chap;
}

sub process_infile($fname) {
  my $book_name = $filenames{basename($fname)};
  die "Book <$fname> not found in my list!" unless (defined $book_name);
  say STDERR "nvim $fname  # $book_name ===============================";

  open my $fh, '<:utf8', $fname or die "Couldn't open input file!";

  my $book = $book_byname{$book_name} or die "unknown book <$book_name>!";

  # find the first chapter...
  my $chap_num = 0;
  while(<$fh>) {
    $_ = trim($_);
    if(m/^\d+$/) {
      $chap_num = $_ + 0;
      last;
    }
  }

  warn "bad starting chapter? <$chap_num>" unless $chap_num == 1;

  # ok, now write a file per book...
  while($chap_num = write_chapter($fh, $book, $chap_num)) {
     die "off the rails!" if($chap_num > 150);
  }; 
  close $fh; 
}

mkdir OUTDIR unless -d OUTDIR;
# act on all the files...
while(my $infile = shift @ARGV) {
  process_infile($infile);
}

__END__

=head1 splitnova.pl

Split the Nova Vulgate text from the vatican website into wikitext chapters.

# vim: sw=2 expandtab
