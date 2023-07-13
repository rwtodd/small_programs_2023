# data about bible books

# Here are the expanded names for the various bible versions I'm working on...
module BibleVersions

  Expanded_Names = {
    NIV: 'New International Verison',
    NRSV: 'New Revised Standard Version',
    KJV: 'King James Version',
    KJVAK: 'King James Version with Apokryphen',
    ASV: 'American Standard Version',
    TYNDALE: 'Willaim Tyndale Bible',
    WYCLIFFE: 'John Wycliffe Bible',
    KJ2000: 'King James 2000',
    KJVCNT: 'King James Clarified NT',
    LXXE: 'Brenton\'s English Septuagent',
    ALXX: 'The Analytic Setpuagent',
    LXX: 'Septuagenta LXX',
    TISCHENDORF: 'Tischendorf Greek NT',
    WCL: 'Westminster Leningrad Codex',
    CLVUL: 'Clementine Vulgate',
    RSV: 'Revised Standard Version',
    BOM: 'Book of Mormon',
    NVLA: 'Nova Vulgata',
    OSHMHB: 'Open Scriptures Morphological Hebrew Bible',
    DOUR: 'Douay Rheims Bible',
    MAPM: 'Miqra Al Pi Ha-Meshorah',
    VULGATE: 'Biblia Sacra Vulgata',
    CPDV: 'Catholic Public Domain Version',
    TR: 'Textus Receptus',
    WHNU: 'Westcott and Hort with NA27 UBS4 Variants',
    VOICE: 'Voice Bible',
    MSG: 'Message Bible',
    CEV: 'Contemporary English Version',
    ESV: 'English Standard Version',
    NLT: 'New Living Translation',
    NKJV: 'New King James Version',
    NASB: 'New American Standard Bible',
    NAB: 'New American Bible',
    NETx: 'New English Translation'
  }

  Zefania_Books = {
   'Genesis': { 
     id: 1, 
     short: 'GEN',
     long: 'Genesis',
     testament: 'Old'
   },
   'Exodus': { 
     id: 2, 
     short: 'EXO',
     long: 'Exodus',
     testament: 'Old'
   },
   'Leviticus': { 
     id: 3, 
     short: 'LEV',
     long: 'Leviticus',
     testament: 'Old'
   },
   'Numbers': { 
     id: 4, 
     short: 'NUM',
     long: 'Numbers',
     testament: 'Old'
   },
   'Deuteronomy': { 
     id: 5, 
     short: 'DEU',
     long: 'Deuteronomy',
     testament: 'Old'
   },
   'Joshua': { 
     id: 6, 
     short: 'JOS',
     long: 'Joshua',
     testament: 'Old'
   },
   'Judges': { 
     id: 7, 
     short: 'JDG',
     long: 'Judges',
     testament: 'Old'
   },
   'Ruth': { 
     id: 8, 
     short: 'RUT',
     long: 'Ruth',
     testament: 'Old'
   },
   '1 Samuel': { 
     id: 9, 
     short: '1SA',
     long: '1 Samuel',
     testament: 'Old'
   },
   '2 Samuel': { 
     id: 10, 
     short: '2SA',
     long: '2 Samuel',
     testament: 'Old'
   },
   '1 Kings': { 
     id: 11, 
     short: '1KI',
     long: '1 Kings',
     testament: 'Old'
   },
   '2 Kings': { 
     id: 12, 
     short: '2KI',
     long: '2 Kings',
     testament: 'Old'
   },
   '1 Chronicles': { 
     id: 13, 
     short: '1CH',
     long: '1 Chronicles',
     testament: 'Old'
   },
   '2 Chronicles': { 
     id: 14, 
     short: '2CH',
     long: '2 Chronicles',
     testament: 'Old'
   },
   'Ezra': { 
     id: 15, 
     short: 'EZR',
     long: 'Ezra',
     testament: 'Old'
   },
   'Nehemiah': { 
     id: 16, 
     short: 'NEH',
     long: 'Nehemiah',
     testament: 'Old'
   },
   'Esther': { 
     id: 17, 
     short: 'EST',
     long: 'Esther',
     testament: 'Old'
   },
   'Job': { 
     id: 18, 
     short: 'JOB',
     long: 'Job',
     testament: 'Old'
   },
   'Psalms': { 
     id: 19, 
     short: 'PSA',
     long: 'Psalms',
     testament: 'Old'
   },
   'Proverbs': { 
     id: 20, 
     short: 'PRO',
     long: 'Proverbs',
     testament: 'Old'
   },
   'Ecclesiastes': { 
     id: 21, 
     short: 'ECC',
     long: 'Ecclesiastes',
     testament: 'Old'
   },
   'Song of Solomon': { 
     id: 22, 
     short: 'SNG',
     long: 'Song of Solomon',
     testament: 'Old'
   },
   'Isaiah': { 
     id: 23, 
     short: 'ISA',
     long: 'Isaiah',
     testament: 'Old'
   },
   'Jeremiah': { 
     id: 24, 
     short: 'JER',
     long: 'Jeremiah',
     testament: 'Old'
   },
   'Lamentations': { 
     id: 25, 
     short: 'LAM',
     long: 'Lamentations',
     testament: 'Old'
   },
   'Ezekiel': { 
     id: 26, 
     short: 'EZK',
     long: 'Ezekiel',
     testament: 'Old'
   },
   'Daniel': { 
     id: 27, 
     short: 'DAN',
     long: 'Daniel',
     testament: 'Old'
   },
   'Hosea': { 
     id: 28, 
     short: 'HOS',
     long: 'Hosea',
     testament: 'Old'
   },
   'Joel': { 
     id: 29, 
     short: 'JOL',
     long: 'Joel',
     testament: 'Old'
   },
   'Amos': { 
     id: 30, 
     short: 'AMO',
     long: 'Amos',
     testament: 'Old'
   },
   'Obadiah': { 
     id: 31, 
     short: 'OBA',
     long: 'Obadiah',
     testament: 'Old'
   },
   'Jonah': { 
     id: 32, 
     short: 'JON',
     long: 'Jonah',
     testament: 'Old'
   },
   'Micah': { 
     id: 33, 
     short: 'MIC',
     long: 'Micah',
     testament: 'Old'
   },
   'Nahum': { 
     id: 34, 
     short: 'NAM',
     long: 'Nahum',
     testament: 'Old'
   },
   'Habakkuk': { 
     id: 35, 
     short: 'HAB',
     long: 'Habakkuk',
     testament: 'Old'
   },
   'Zephaniah': { 
     id: 36, 
     short: 'ZEP',
     long: 'Zephaniah',
     testament: 'Old'
   },
   'Haggai': { 
     id: 37, 
     short: 'HAG',
     long: 'Haggai',
     testament: 'Old'
   },
   'Zechariah': { 
     id: 38, 
     short: 'ZEC',
     long: 'Zechariah',
     testament: 'Old'
   },
   'Malachi': { 
     id: 39, 
     short: 'MAL',
     long: 'Malachi',
     testament: 'Old'
   },
   'Tobit': { 
     id: 69, 
     short: 'TOB',
     long: 'Tobit',
     testament: 'Apocrypha'
   },
   'Judith': { 
     id: 67, 
     short: 'JDT',
     long: 'Judith',
     testament: 'Apocrypha'
   },
   'Additions to Esther': { 
     id: 75, 
     short: 'ADE',
     long: 'Additions to Esther',
     testament: 'Apocrypha'
   },
   'Wisdom': { 
     id: 68, 
     short: 'WIS',
     long: 'Wisdom',
     testament: 'Apocrypha'
   },
   'Sirach': { 
     id: 70, 
     short: 'SIR',
     long: 'Sirach',
     testament: 'Apocrypha'
   },
   'Baruch': { 
     id: 71, 
     short: 'BAR',
     long: 'Baruch',
     testament: 'Apocrypha'
   },
   'Additions to Daniel': { 
     id: 74, 
     short: 'ADD',
     long: 'Additions to Daniel',
     testament: 'Apocrypha'
   },
   'Susanna': { 
     id: 87,                # NOTE! duplicate of 'Bel and the Dragon' below...
     short: 'SUS',
     long: 'Susanna',
     testament: 'Apocrypha'
   },
   'Bel and the Dragon': { 
     id: 87,                # NOTE! duplicate of 'susanna' above....
     short: 'BEL',
     long: 'Bel and the Dragon',
     testament: 'Apocrypha'
   },
   '1 Maccabees': { 
     id: 72, 
     short: '1MA',
     long: '1 Maccabees',
     testament: 'Apocrypha'
   },
   '2 Maccabees': { 
     id: 73, 
     short: '2MA',
     long: '2 Maccabees',
     testament: 'Apocrypha'
   },
   '1 Esdras': { 
     id: 80, 
     short: '1ES',
     long: '1 Esdras',
     testament: 'Apocrypha'
   },
   'Manassse': { 
     id: 76, 
     short: 'MAN',
     long: 'Manassse',
     testament: 'Apocrypha'
   },
   '2 Esdras': { 
     id: 81, 
     short: '2ES',
     long: '2 Esdras',
     testament: 'Apocrypha'
   },
   'Letter of Jeremiah': {
     id: 79, 
     short: 'LJE',
     long: 'Letter of Jeremiah',
     testament: 'Apocrypha'
   },
   'Psalms of Solomon': {
     id: 83, 
     short: 'PSS',
     long: 'Psalms of Solomon',
     testament: 'Apocrypha'  # possibly should be "Rahlfs' LXX"
   },
   'Matthew': { 
     id: 40, 
     short: 'MAT',
     long: 'Matthew',
     testament: 'New'
   },
   'Mark': { 
     id: 41, 
     short: 'MRK',
     long: 'Mark',
     testament: 'New'
   },
   'Luke': { 
     id: 42, 
     short: 'LUK',
     long: 'Luke',
     testament: 'New'
   },
   'John': { 
     id: 43, 
     short: 'JHN',
     long: 'John',
     testament: 'New'
   },
   'Acts': { 
     id: 44, 
     short: 'ACT',
     long: 'Acts',
     testament: 'New'
   },
   'Romans': { 
     id: 45, 
     short: 'ROM',
     long: 'Romans',
     testament: 'New'
   },
   '1 Corinthians': { 
     id: 46, 
     short: '1CO',
     long: '1 Corinthians',
     testament: 'New'
   },
   '2 Corinthians': { 
     id: 47, 
     short: '2CO',
     long: '2 Corinthians',
     testament: 'New'
   },
   'Galatians': { 
     id: 48, 
     short: 'GAL',
     long: 'Galatians',
     testament: 'New'
   },
   'Ephesians': { 
     id: 49, 
     short: 'EPH',
     long: 'Ephesians',
     testament: 'New'
   },
   'Philippians': { 
     id: 50, 
     short: 'PHP',
     long: 'Philippians',
     testament: 'New'
   },
   'Colossians': { 
     id: 51, 
     short: 'COL',
     long: 'Colossians',
     testament: 'New'
   },
   '1 Thessalonians': { 
     id: 52, 
     short: '1TH',
     long: '1 Thessalonians',
     testament: 'New'
   },
   '2 Thessalonians': { 
     id: 53, 
     short: '2TH',
     long: '2 Thessalonians',
     testament: 'New'
   },
   '1 Timothy': { 
     id: 54, 
     short: '1TI',
     long: '1 Timothy',
     testament: 'New'
   },
   '2 Timothy': { 
     id: 55, 
     short: '2TI',
     long: '2 Timothy',
     testament: 'New'
   },
   'Titus': { 
     id: 56, 
     short: 'TIT',
     long: 'Titus',
     testament: 'New'
   },
   'Philemon': { 
     id: 57, 
     short: 'PHM',
     long: 'Philemon',
     testament: 'New'
   },
   'Hebrews': { 
     id: 58, 
     short: 'HEB',
     long: 'Hebrews',
     testament: 'New'
   },
   'James': { 
     id: 59, 
     short: 'JAS',
     long: 'James',
     testament: 'New'
   },
   '1 Peter': { 
     id: 60, 
     short: '1PE',
     long: '1 Peter',
     testament: 'New'
   },
   '2 Peter': { 
     id: 61, 
     short: '2PE',
     long: '2 Peter',
     testament: 'New'
   },
   '1 John': { 
     id: 62, 
     short: '1JN',
     long: '1 John',
     testament: 'New'
   },
   '2 John': { 
     id: 63, 
     short: '2JN',
     long: '2 John',
     testament: 'New'
   },
   '3 John': { 
     id: 64, 
     short: '3JN',
     long: '3 John',
     testament: 'New'
   },
   'Jude': { 
     id: 65, 
     short: 'JUD',
     long: 'Jude',
     testament: 'New'
   },
   'Revelation': {
     id: 66,
     short: 'REV',
     long: 'Revelation',
     testament: 'New'
   }
  }

  # Douay-Rheims Bible
  DR_Bible = [
   { 
     id: 1, 
     short: 'GEN',
     long: 'Genesis',
     testament: 'Old',
     chapters: 50
   },
   { 
     id: 2, 
     short: 'EXO',
     long: 'Exodus',
     testament: 'Old',
     chapters: 40
   },
   { 
     id: 3, 
     short: 'LEV',
     long: 'Leviticus',
     testament: 'Old',
     chapters: 27
   },
   { 
     id: 4, 
     short: 'NUM',
     long: 'Numbers',
     testament: 'Old',
     chapters: 36
   },
   { 
     id: 5, 
     short: 'DEU',
     long: 'Deuteronomy',
     testament: 'Old',
     chapters: 34
   },
   { 
     id: 6, 
     short: 'JOS',
     long: 'Joshua',
     testament: 'Old',
     chapters: 24
   },
   { 
     id: 7, 
     short: 'JDG',
     long: 'Judges',
     testament: 'Old',
     chapters: 21
   },
   { 
     id: 8, 
     short: 'RUT',
     long: 'Ruth',
     testament: 'Old',
     chapters: 4
   },
   { 
     id: 9, 
     short: '1SA',
     long: '1 Samuel',
     drtitle: '1 Kings',
     testament: 'Old',
     chapters: 31
   },
   { 
     id: 10, 
     short: '2SA',
     long: '2 Samuel',
     drtitle: '2 Kings',
     testament: 'Old',
     chapters: 24
   },
   { 
     id: 11, 
     short: '1KI',
     long: '1 Kings',
     drtitle: '3 Kings',
     testament: 'Old',
     chapters: 22
   },
   { 
     id: 12, 
     short: '2KI',
     long: '2 Kings',
     drtitle: '4 Kings',
     testament: 'Old',
     chapters: 25
   },
   { 
     id: 13, 
     short: '1CH',
     long: '1 Chronicles',
     drtitle: '1 Paralipomenon',
     testament: 'Old',
     chapters: 29
   },
   { 
     id: 14, 
     short: '2CH',
     long: '2 Chronicles',
     drtitle: '2 Paralipomenon',
     testament: 'Old',
     chapters: 36
   },
   { 
     id: 15, 
     short: 'EZR',
     long: 'Ezra',
     drtitle: '1 Esdras',
     testament: 'Old',
     chapters: 10
   },
   { 
     id: 16, 
     short: 'NEH',
     long: 'Nehemiah',
     drtitle: '2 Esdras',
     testament: 'Old',
     chapters: 13
   },
   { 
     id: 17, 
     short: 'TOB',
     long: 'Tobit',
     drtitle: 'Tobias',
     testament: 'Apocrypha',
     chapters: 14
   },
   { 
     id: 18, 
     short: 'JDT',
     long: 'Judith',
     testament: 'Apocrypha',
     chapters: 16
   },
   { 
     id: 19, 
     short: 'EST',
     long: 'Esther',
     testament: 'Old',
     chapters: 16
   },
   { 
     id: 20, 
     short: 'JOB',
     long: 'Job',
     testament: 'Old',
     chapters: 42
   },
   { 
     id: 21, 
     short: 'PSA',
     long: 'Psalms',
     testament: 'Old',
     chapters: 150
   },
   { 
     id: 22, 
     short: 'PRO',
     long: 'Proverbs',
     testament: 'Old',
     chapters: 31
   },
   { 
     id: 23, 
     short: 'ECC',
     long: 'Ecclesiastes',
     testament: 'Old',
     chapters: 12
   },
   { 
     id: 24, 
     short: 'SNG',
     long: 'Song of Solomon',
     drtitle: 'Canticle of Canticles',
     testament: 'Old',
     chapters: 8
   },
   { 
     id: 25, 
     short: 'WIS',
     long: 'Wisdom',
     testament: 'Apocrypha',
     chapters: 19
   },
   { 
     id: 26, 
     short: 'SIR',
     long: 'Sirach',
     drtitle: 'Ecclesiasticus',
     testament: 'Apocrypha',
     chapters: 51
   },
   { 
     id: 27, 
     short: 'ISA',
     long: 'Isaiah',
     drtitle: 'Isaias',
     testament: 'Old',
     chapters: 66
   },
   { 
     id: 28, 
     short: 'JER',
     long: 'Jeremiah',
     drtitle: 'Jeremias',
     testament: 'Old',
     chapters: 52
   },
   { 
     id: 29, 
     short: 'LAM',
     long: 'Lamentations',
     testament: 'Old',
     chapters: 5
   },
   { 
     id: 30, 
     short: 'BAR',
     long: 'Baruch',
     testament: 'Apocrypha',
     chapters: 6
   },
   { 
     id: 31, 
     short: 'EZK',
     long: 'Ezekiel',
     drtitle: 'Ezechiel',
     testament: 'Old',
     chapters: 48
   },
   { 
     id: 32, 
     short: 'DAN',
     long: 'Daniel',
     testament: 'Old',
     chapters: 14
   },
   { 
     id: 33, 
     short: 'HOS',
     long: 'Hosea',
     drtitle: 'Osee',
     testament: 'Old',
     chapters: 14
   },
   { 
     id: 34, 
     short: 'JOL',
     long: 'Joel',
     testament: 'Old',
     chapters: 3
   },
   { 
     id: 35, 
     short: 'AMO',
     long: 'Amos',
     testament: 'Old',
     chapters: 9
   },
   { 
     id: 36, 
     short: 'OBA',
     long: 'Obadiah',
     drtitle: 'Abdias',
     testament: 'Old',
     chapters: 1
   },
   { 
     id: 37, 
     short: 'JON',
     long: 'Jonah',
     drtitle: 'Jonas',
     testament: 'Old',
     chapters: 4
   },
   { 
     id: 38, 
     short: 'MIC',
     long: 'Micah',
     drtitle: 'Micheas',
     testament: 'Old',
     chapters: 0
   },
   { 
     id: 39, 
     short: 'NAM',
     long: 'Nahum',
     testament: 'Old',
     chapters: 3
   },
   { 
     id: 40, 
     short: 'HAB',
     long: 'Habakkuk',
     drtitle: 'Habacuc',
     testament: 'Old',
     chapters: 3
   },
   { 
     id: 41, 
     short: 'ZEP',
     long: 'Zephaniah',
     drtitle: 'Sophonias',
     testament: 'Old',
     chapters: 3
   },
   { 
     id: 42, 
     short: 'HAG',
     long: 'Haggai',
     drtitle: 'Aggeus',
     testament: 'Old',
     chapters: 2
   },
   { 
     id: 43, 
     short: 'ZEC',
     long: 'Zechariah',
     drtitle: 'Zacharias',
     testament: 'Old',
     chapters: 14
   },
   { 
     id: 44, 
     short: 'MAL',
     long: 'Malachi',
     drtitle: 'Malachias',
     testament: 'Old',
     chapters: 4
   },
   { 
     id: 45, 
     short: '1MA',
     long: '1 Maccabees',
     drtitle: '1 Machabees',
     testament: 'Apocrypha',
     chapters: 16
   },
   { 
     id: 46, 
     short: '2MA',
     long: '2 Maccabees',
     drtitle: '2 Machabees',
     testament: 'Apocrypha',
     chapters: 15
   },
   { 
     id: 47, 
     short: 'MAT',
     long: 'Matthew',
     testament: 'New',
     chapters: 28
   },
   { 
     id: 48, 
     short: 'MRK',
     long: 'Mark',
     testament: 'New',
     chapters: 16
   },
   { 
     id: 49, 
     short: 'LUK',
     long: 'Luke',
     testament: 'New',
     chapters: 24
   },
   { 
     id: 50, 
     short: 'JHN',
     long: 'John',
     testament: 'New',
     chapters: 21
   },
   { 
     id: 51, 
     short: 'ACT',
     long: 'Acts',
     testament: 'New',
     chapters: 28
   },
   { 
     id: 52, 
     short: 'ROM',
     long: 'Romans',
     testament: 'New',
     chapters: 16
   },
   { 
     id: 53, 
     short: '1CO',
     long: '1 Corinthians',
     testament: 'New',
     chapters: 16
   },
   { 
     id: 54, 
     short: '2CO',
     long: '2 Corinthians',
     testament: 'New',
     chapters: 13
   },
   { 
     id: 55, 
     short: 'GAL',
     long: 'Galatians',
     testament: 'New',
     chapters: 6
   },
   { 
     id: 56, 
     short: 'EPH',
     long: 'Ephesians',
     testament: 'New',
     chapters: 6
   },
   { 
     id: 57, 
     short: 'PHP',
     long: 'Philippians',
     testament: 'New',
     chapters: 4
   },
   { 
     id: 58, 
     short: 'COL',
     long: 'Colossians',
     testament: 'New',
     chapters: 4
   },
   { 
     id: 59, 
     short: '1TH',
     long: '1 Thessalonians',
     testament: 'New',
     chapters: 5
   },
   { 
     id: 60, 
     short: '2TH',
     long: '2 Thessalonians',
     testament: 'New',
     chapters: 3
   },
   { 
     id: 61, 
     short: '1TI',
     long: '1 Timothy',
     testament: 'New',
     chapters: 6
   },
   { 
     id: 62, 
     short: '2TI',
     long: '2 Timothy',
     testament: 'New',
     chapters: 4
   },
   { 
     id: 63, 
     short: 'TIT',
     long: 'Titus',
     testament: 'New',
     chapters: 3
   },
   { 
     id: 64, 
     short: 'PHM',
     long: 'Philemon',
     testament: 'New',
     chapters: 1
   },
   { 
     id: 65, 
     short: 'HEB',
     long: 'Hebrews',
     testament: 'New',
     chapters: 13
   },
   { 
     id: 66, 
     short: 'JAS',
     long: 'James',
     testament: 'New',
     chapters: 5
   },
   { 
     id: 67, 
     short: '1PE',
     long: '1 Peter',
     testament: 'New',
     chapters: 5
   },
   { 
     id: 68, 
     short: '2PE',
     long: '2 Peter',
     testament: 'New',
     chapters: 3
   },
   { 
     id: 69, 
     short: '1JN',
     long: '1 John',
     testament: 'New',
     chapters: 5
   },
   { 
     id: 70, 
     short: '2JN',
     long: '2 John',
     testament: 'New',
     chapters: 1
   },
   { 
     id: 71, 
     short: '3JN',
     long: '3 John',
     testament: 'New',
     chapters: 1
   },
   { 
     id: 72, 
     short: 'JUD',
     long: 'Jude',
     testament: 'New',
     chapters: 1
   },
   {
     id: 73,
     short: 'REV',
     long: 'Revelation',
     drtitle: 'Apocalypse',
     testament: 'New',
     chapters: 22
   }
  ]
end 

# vim: sw=2 expandtab
