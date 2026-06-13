const verbFamilies = [
  {
    base: "jaana",
    tamil: "போவது",
    english: "to go",
    forms: [
      ["jaa rahi hoon", "நான் போய்க் கொண்டிருக்கிறேன்", "I am going"],
      ["gayi", "அவள்/நான் போனேன்", "she/I went"],
      ["jaana hai", "போக வேண்டும்", "have to go"],
      ["jaaungi", "நான் போவேன்", "I will go"]
    ]
  },
  {
    base: "aana",
    tamil: "வருவது",
    english: "to come",
    forms: [
      ["aa rahi hoon", "நான் வந்துகொண்டிருக்கிறேன்", "I am coming"],
      ["aayi", "அவள்/நான் வந்தேன்", "she/I came"],
      ["aana hai", "வர வேண்டும்", "have to come"],
      ["aayega", "அவன்/அது வரும்", "he/it will come"]
    ]
  },
  {
    base: "karna",
    tamil: "செய்வது",
    english: "to do",
    forms: [
      ["kar rahi hoon", "நான் செய்கிறேன்", "I am doing"],
      ["kiya", "செய்தான்/செய்தது", "did"],
      ["karna hai", "செய்ய வேண்டும்", "have to do"],
      ["karega", "அவன் செய்வான்", "he will do"]
    ]
  },
  {
    base: "khaana",
    tamil: "சாப்பிடுவது",
    english: "to eat",
    forms: [
      ["kha rahi hoon", "நான் சாப்பிடுகிறேன்", "I am eating"],
      ["khaaya", "சாப்பிட்டான்/சாப்பிட்டது", "ate"],
      ["khaayi", "அவள்/நான் சாப்பிட்டேன்", "she/I ate"],
      ["khaana hai", "சாப்பிட வேண்டும்", "have to eat"]
    ]
  },
  {
    base: "peena",
    tamil: "குடிப்பது",
    english: "to drink",
    forms: [
      ["pee rahi hoon", "நான் குடிக்கிறேன்", "I am drinking"],
      ["piya", "குடித்தான்/குடித்தது", "drank"],
      ["peena hai", "குடிக்க வேண்டும்", "have to drink"],
      ["piyega", "அவன் குடிப்பான்", "he will drink"]
    ]
  },
  {
    base: "bolna",
    tamil: "சொல்வது",
    english: "to say/speak",
    forms: [
      ["bol rahi hoon", "நான் பேசுகிறேன்", "I am speaking"],
      ["bola", "சொன்னான்", "said"],
      ["bolna hai", "சொல்ல வேண்டும்", "have to say"],
      ["bolega", "அவன் சொல்வான்", "he will say"]
    ]
  },
  {
    base: "dekhna",
    tamil: "பார்ப்பது",
    english: "to see/watch",
    forms: [
      ["dekh rahi hoon", "நான் பார்த்துக் கொண்டிருக்கிறேன்", "I am watching"],
      ["dekha", "பார்த்தான்/பார்த்தது", "saw"],
      ["dekhna hai", "பார்க்க வேண்டும்", "have to watch"],
      ["dekhega", "அவன் பார்ப்பான்", "he will watch"]
    ]
  },
  {
    base: "lena",
    tamil: "எடுப்பது",
    english: "to take",
    forms: [
      ["le rahi hoon", "நான் எடுத்துக்கொள்கிறேன்", "I am taking"],
      ["liya", "எடுத்தான்/எடுத்தது", "took"],
      ["lena hai", "எடுக்க வேண்டும்", "have to take"],
      ["lega", "அவன் எடுப்பான்", "he will take"]
    ]
  },
  {
    base: "dena",
    tamil: "கொடுப்பது",
    english: "to give",
    forms: [
      ["de rahi hoon", "நான் கொடுக்கிறேன்", "I am giving"],
      ["diya", "கொடுத்தான்/கொடுத்தது", "gave"],
      ["dena hai", "கொடுக்க வேண்டும்", "have to give"],
      ["dega", "அவன் கொடுப்பான்", "he will give"]
    ]
  },
  {
    base: "hona",
    tamil: "இருப்பது / ஆகுவது",
    english: "to be/happen",
    forms: [
      ["ho raha hai", "நடந்து கொண்டிருக்கிறது", "it is happening"],
      ["hua", "நடந்தது", "happened"],
      ["hona hai", "நடக்க வேண்டும்", "has to happen"],
      ["hoga", "நடக்கும் / இருக்கும்", "will happen / will be"]
    ]
  }
];

const vocabulary = [
  ["jaana", "verb", "போவது", "to go", "jana, jaana, gya, gaya, gayi, jaa"],
  ["aana", "verb", "வருவது", "to come", "ana, aaya, aayi, aa"],
  ["karna", "verb", "செய்வது", "to do", "krna, kar, kiya, karna"],
  ["khaana", "verb", "சாப்பிடுவது", "to eat / food", "khana, kha, khaya, khayi"],
  ["peena", "verb", "குடிப்பது", "to drink", "pina, pee, piya"],
  ["bolna", "verb", "சொல்வது / பேசுவது", "to say / speak", "bol, bola, boli"],
  ["dekhna", "verb", "பார்ப்பது", "to see / watch", "dekh, dekha, dekhi"],
  ["lena", "verb", "எடுப்பது", "to take", "le, liya, li"],
  ["dena", "verb", "கொடுப்பது", "to give", "de, diya, di"],
  ["hona", "verb", "இருப்பது / நடப்பது", "to be / happen", "hai, ho, hua, hoga"],
  ["chahiye", "verb", "வேண்டும்", "want / need", "chaiye, chahie"],
  ["rakhna", "verb", "வைப்பது", "to keep / put", "rakh, rakha"],
  ["milna", "verb", "சந்திப்பது / கிடைப்பது", "to meet / get", "mil, mila"],
  ["samajhna", "verb", "புரிந்துகொள்வது", "to understand", "samajh, samja"],
  ["pata hona", "verb", "தெரிந்திருப்பது", "to know", "pata, malum"],
  ["sochna", "verb", "நினைப்பது", "to think", "soch, socha"],
  ["sunna", "verb", "கேட்பது", "to hear / listen", "sun, suna"],
  ["poochna", "verb", "கேட்பது", "to ask", "puchna, pooch, pucha"],
  ["likhna", "verb", "எழுதுவது", "to write", "likh, likha"],
  ["padhna", "verb", "படிப்பது", "to read / study", "padh, padha"],
  ["sona", "verb", "தூங்குவது", "to sleep", "so, soya"],
  ["uthna", "verb", "எழுவது", "to get up", "uth, utha"],
  ["baithna", "verb", "உட்காருவது", "to sit", "baith, baitha"],
  ["chalna", "verb", "நடப்பது / இயங்குவது", "to walk / work", "chal, chala"],
  ["rukna", "verb", "நிற்பது", "to stop / wait", "ruk, ruka"],
  ["laana", "verb", "கொண்டு வருவது", "to bring", "lana, la, laya"],
  ["bhejna", "verb", "அனுப்புவது", "to send", "bhej, bheja"],
  ["banana", "verb", "செய்வது / தயாரிப்பது", "to make", "bana, banaya"],
  ["lagna", "verb", "தோன்றுவது / ஆகுவது", "to feel / seem / take time", "lag, laga"],
  ["pasand hona", "verb", "பிடித்திருப்பது", "to like", "pasand, like"],
  ["kaam", "noun", "வேலை", "work", "kam"],
  ["ghar", "noun", "வீடு", "home / house", "gar"],
  ["office", "noun", "ஆபீஸ்", "office", "ofis"],
  ["paani", "noun", "தண்ணீர்", "water", "pani"],
  ["chai", "noun", "சாய் / டீ", "tea", "chaai"],
  ["coffee", "noun", "காபி", "coffee", "kofi"],
  ["doodh", "noun", "பால்", "milk", "dudh"],
  ["roti", "noun", "ரொட்டி", "roti / bread", "rooti"],
  ["rice", "noun", "சாதம்", "rice", "chawal, chawal"],
  ["sabzi", "noun", "காய்கறி உணவு", "vegetable dish", "sabji"],
  ["dal", "noun", "பருப்பு", "lentils", "daal"],
  ["namak", "noun", "உப்பு", "salt", "salt"],
  ["cheeni", "noun", "சர்க்கரை", "sugar", "chini"],
  ["phone", "noun", "போன்", "phone", "mobile"],
  ["message", "noun", "மெசேஜ்", "message", "msg"],
  ["call", "noun", "கால்", "call", "kaal"],
  ["photo", "noun", "போட்டோ", "photo", "pic"],
  ["video", "noun", "வீடியோ", "video", "vidiyo"],
  ["movie", "noun", "படம்", "movie", "film"],
  ["song", "noun", "பாட்டு", "song", "gaana"],
  ["gaadi", "noun", "வண்டி / கார்", "vehicle / car", "gadi"],
  ["auto", "noun", "ஆட்டோ", "auto rickshaw", "rickshaw"],
  ["train", "noun", "ரயில்", "train", "rail"],
  ["flight", "noun", "விமானம்", "flight", "plane"],
  ["ticket", "noun", "டிக்கெட்", "ticket", "tiket"],
  ["paise", "noun", "பணம்", "money", "paisa, money"],
  ["time", "noun", "நேரம்", "time", "samay, waqt"],
  ["aaj", "time", "இன்று", "today", "aj"],
  ["kal", "time", "நேற்று / நாளை", "yesterday / tomorrow", "kal"],
  ["abhi", "time", "இப்போது", "now", "abi"],
  ["baad mein", "time", "பிறகு", "later", "badme, baadme"],
  ["pehle", "time", "முன்பு / முதலில்", "before / first", "pehle"],
  ["subah", "time", "காலை", "morning", "morning"],
  ["shaam", "time", "மாலை", "evening", "sham"],
  ["raat", "time", "இரவு", "night", "rat"],
  ["din", "time", "நாள் / பகல்", "day", "day"],
  ["minute", "time", "நிமிடம்", "minute", "min"],
  ["gharwaale", "noun", "வீட்டார்", "family people", "family, gharwale"],
  ["mummy", "noun", "அம்மா", "mother", "mom, maa"],
  ["papa", "noun", "அப்பா", "father", "dad"],
  ["dost", "noun", "நண்பர்", "friend", "friend"],
  ["ladka", "noun", "பையன்", "boy", "boy"],
  ["ladki", "noun", "பெண்", "girl", "girl"],
  ["log", "noun", "மக்கள்", "people", "people"],
  ["aadmi", "noun", "ஆண் / மனிதன்", "man / person", "admi"],
  ["aurat", "noun", "பெண்", "woman", "woman"],
  ["baccha", "noun", "குழந்தை", "child", "bacha"],
  ["naam", "noun", "பெயர்", "name", "nam"],
  ["jagah", "noun", "இடம்", "place", "jaga"],
  ["room", "noun", "அறை", "room", "kamra"],
  ["bathroom", "noun", "குளியலறை", "bathroom", "toilet"],
  ["kitchen", "noun", "சமையலறை", "kitchen", "rasoi"],
  ["school", "noun", "ஸ்கூல்", "school", "skool"],
  ["college", "noun", "கல்லூரி", "college", "kalej"],
  ["market", "noun", "மார்க்கெட்", "market", "bazaar, bajar"],
  ["shop", "noun", "கடை", "shop", "dukaan, dukan"],
  ["hospital", "noun", "மருத்துவமனை", "hospital", "aspatal"],
  ["doctor", "noun", "டாக்டர்", "doctor", "daktar"],
  ["medicine", "noun", "மருந்து", "medicine", "dawai, davai"],
  ["head", "noun", "தலை", "head", "sir"],
  ["pet", "noun", "வயிறு", "stomach", "stomach"],
  ["haath", "noun", "கை", "hand", "hath"],
  ["pair", "noun", "கால்", "leg / foot", "per"],
  ["dil", "noun", "இதயம் / மனம்", "heart", "heart"],
  ["problem", "noun", "பிரச்சனை", "problem", "issue"],
  ["help", "noun", "உதவி", "help", "madad"],
  ["baat", "noun", "விஷயம் / பேச்சு", "matter / talk", "bat"],
  ["sawaal", "noun", "கேள்வி", "question", "sawal"],
  ["jawab", "noun", "பதில்", "answer", "javab"],
  ["idea", "noun", "யோசனை", "idea", "soch"],
  ["mood", "noun", "மூடு / மனநிலை", "mood", "man"],
  ["accha", "descriptor", "நல்லது", "good", "acha"],
  ["bura", "descriptor", "கெட்டது", "bad", "bad"],
  ["theek", "descriptor", "சரி", "okay / fine", "thik, tik"],
  ["jaldi", "descriptor", "சீக்கிரம்", "quickly / early", "fast"],
  ["slow", "descriptor", "மெதுவாக", "slow", "dheere"],
  ["zyada", "descriptor", "அதிகம்", "more / too much", "jyada"],
  ["kam", "descriptor", "குறைவு", "less", "less"],
  ["naya", "descriptor", "புதியது", "new", "new"],
  ["purana", "descriptor", "பழையது", "old", "old"],
  ["garam", "descriptor", "சூடு", "hot", "hot"],
  ["thanda", "descriptor", "குளிர்", "cold", "cold"],
  ["main", "pronoun", "நான்", "I", "mein, mai"],
  ["tum", "pronoun", "நீ / நீங்கள்", "you", "tu, aap"],
  ["woh", "pronoun", "அவன் / அவள் / அது", "he / she / that", "vo, wo"],
  ["hum", "pronoun", "நாம் / நாங்கள்", "we", "ham"],
  ["yeh", "pronoun", "இது", "this", "ye"],
  ["kya", "question", "என்ன", "what", "kia"],
  ["kyun", "question", "ஏன்", "why", "kyu"],
  ["kaise", "question", "எப்படி", "how", "kese"],
  ["kab", "question", "எப்போது", "when", "when"],
  ["kahan", "question", "எங்கே", "where", "kaha"],
  ["kitna", "question", "எவ்வளவு", "how much", "kitne"],
  ["nahi", "context", "இல்லை", "no / not", "nahin, nai"],
  ["haan", "context", "ஆம்", "yes", "ha, haan"],
  ["bas", "context", "போதும் / வெறும்", "enough / just", "bus"],
  ["phir", "context", "பிறகு / அப்புறம்", "then / again", "fir"],
  ["lekin", "context", "ஆனால்", "but", "but"],
  ["aur", "context", "மேலும் / மற்றும்", "and / more", "or"],
  ["agar", "context", "என்றால்", "if", "if"],
  ["shayad", "context", "ஏதோ / ஒருவேளை", "maybe", "maybe"]
].map(([term, type, tamil, english, aliases]) => ({
  term,
  type,
  tamil,
  english,
  aliases: aliases.split(",").map((alias) => alias.trim()).filter(Boolean)
}));

const commonNounTerms = [
  "kaam",
  "ghar",
  "office",
  "paani",
  "chai",
  "coffee",
  "doodh",
  "roti",
  "rice",
  "sabzi",
  "dal",
  "namak",
  "cheeni",
  "phone",
  "message",
  "call",
  "photo",
  "video",
  "movie",
  "song",
  "gaadi",
  "auto",
  "train",
  "flight",
  "ticket",
  "paise",
  "time",
  "mummy",
  "papa",
  "dost",
  "baat",
  "sawaal",
  "jawab"
];

const commonNouns = commonNounTerms
  .map((term) => vocabulary.find((entry) => entry.term === term))
  .filter(Boolean);

const recognizedHindiTerms = {
  "\u0915\u094d\u092f\u093e": "kya",
  "\u0915\u092f\u093e": "kya",
  "\u0915\u0939": "bol",
  "\u0915\u0939\u093e": "bola",
  "\u0915\u0939\u0940": "boli",
  "\u092c\u094b\u0932": "bol",
  "\u092c\u094b\u0932\u093e": "bola",
  "\u0930\u0939\u0940": "rahi",
  "\u0930\u0939\u093e": "raha",
  "\u0939\u094b": "ho",
  "\u0939\u0942\u0901": "hoon",
  "\u0939\u0942\u0902": "hoon",
  "\u0939\u0948": "hai",
  "\u092e\u0948\u0902": "main",
  "\u092e\u0947": "main",
  "\u0924\u0941\u092e": "tum",
  "\u0924\u0941\u092e\u0928\u0947": "tumne",
  "\u0935\u0939": "woh",
  "\u0918\u0930": "ghar",
  "\u0911\u092b\u093f\u0938": "office",
  "\u092a\u093e\u0928\u0940": "paani",
  "\u0916\u093e\u0928\u093e": "khaana",
  "\u0916\u093e\u092f\u093e": "khaaya",
  "\u0917\u092f\u093e": "gaya",
  "\u0917\u092f\u0940": "gayi",
  "\u0906\u0928\u093e": "aana",
  "\u0906": "aa",
  "\u091c\u093e\u0928\u093e": "jaana",
  "\u091c\u093e": "jaa",
  "\u0915\u0930": "kar",
  "\u0915\u093f\u092f\u093e": "kiya",
  "\u0926\u0947\u0916": "dekh",
  "\u0932\u0947": "le",
  "\u0926\u0947": "de"
};

const phraseMatches = [
  {
    tokens: ["kya", "bol"],
    term: "bolna",
    tamil: "நீ என்ன சொல்கிறாய்?",
    english: "What are you saying?",
    note: "kya + kah/bol + rahi/raha points to saying/speaking."
  },
  {
    tokens: ["kya", "kar"],
    term: "karna",
    tamil: "நீ என்ன செய்கிறாய்?",
    english: "What are you doing?",
    note: "kya + kar points to doing."
  },
  {
    tokens: ["paani", "chahiye"],
    term: "paani",
    tamil: "தண்ணீர் வேண்டும்",
    english: "Need water",
    note: "paani is the noun anchor; chahiye means need/want."
  },
  {
    tokens: ["ghar", "gaya"],
    term: "jaana",
    tamil: "வீட்டுக்கு போனான்",
    english: "Went home",
    note: "gaya/gayi are past forms from jaana."
  }
];

const helperTermMeanings = {
  raha: ["present/ongoing marker", "நடந்து கொண்டிருக்கும் குறி"],
  rahi: ["present/ongoing marker", "நடந்து கொண்டிருக்கும் குறி"],
  ho: ["you are / auxiliary", "நீ இருக்கிறாய் / துணைச்சொல்"],
  hoon: ["I am / auxiliary", "நான் இருக்கிறேன் / துணைச்சொல்"],
  hai: ["is / auxiliary", "இருக்கிறது / துணைச்சொல்"],
  aa: ["come stem", "வரு என்ற வேர்"],
  jaa: ["go stem", "போ என்ற வேர்"]
};

const prompts = [
  {
    id: "office-jaana",
    type: "Meaning from audio",
    phrase: "kal office jaana hai",
    question: "What is the rough meaning?",
    options: [
      ["Have to go to office tomorrow", "நாளை ஆபீஸ்க்கு போக வேண்டும்"],
      ["Went home yesterday", "நேற்று வீட்டுக்கு போனேன்"],
      ["Want to eat now", "இப்போது சாப்பிட வேண்டும்"]
    ],
    correct: 0,
    tamil: "நாளை ஆபீஸ்க்கு போக வேண்டும்",
    english: "Have to go to office tomorrow",
    verb: "jaana",
    tense: "need/intent",
    noun: "office"
  },
  {
    id: "khana-khaaya",
    type: "Meaning from audio",
    phrase: "maine khaana khaaya",
    question: "What happened?",
    options: [
      ["I ate food", "நான் சாப்பாடு சாப்பிட்டேன்"],
      ["I am going home", "நான் வீட்டுக்கு போகிறேன்"],
      ["He will drink water", "அவன் தண்ணீர் குடிப்பான்"]
    ],
    correct: 0,
    tamil: "நான் சாப்பாடு சாப்பிட்டேன்",
    english: "I ate food",
    verb: "khaana",
    tense: "past",
    noun: "khaana"
  },
  {
    id: "ghar-gaya",
    type: "Tense/context",
    phrase: "woh ghar gaya",
    question: "Is this past, now, or future?",
    options: [
      ["Past: he went home", "கடந்த காலம்: அவன் வீட்டுக்கு போனான்"],
      ["Now: he is going home", "இப்போது: அவன் வீட்டுக்கு போகிறான்"],
      ["Future: he will go home", "எதிர்காலம்: அவன் போவான்"]
    ],
    correct: 0,
    tamil: "அவன் வீட்டுக்கு போனான்",
    english: "He went home",
    verb: "jaana",
    tense: "past",
    noun: "ghar"
  },
  {
    id: "paani-chahiye",
    type: "Hinglish context",
    phrase: "mujhe paani chahiye",
    question: "What does the speaker want?",
    options: [
      ["Water", "தண்ணீர்"],
      ["Food", "சாப்பாடு"],
      ["Office", "ஆபீஸ்"]
    ],
    correct: 0,
    tamil: "எனக்கு தண்ணீர் வேண்டும்",
    english: "I want water",
    verb: "hona",
    tense: "want/need",
    noun: "paani"
  },
  {
    id: "kya-bola",
    type: "Verb recognition",
    phrase: "tumne kya bola",
    question: "Which base verb did you hear?",
    options: [
      ["bolna: to say/speak", "சொல்வது / பேசுவது"],
      ["peena: to drink", "குடிப்பது"],
      ["lena: to take", "எடுப்பது"]
    ],
    correct: 0,
    tamil: "நீ என்ன சொன்னாய்?",
    english: "What did you say?",
    verb: "bolna",
    tense: "past",
    noun: "kya"
  },
  {
    id: "kha-rahi",
    type: "Tense/context",
    phrase: "main kha rahi hoon",
    question: "What is happening?",
    options: [
      ["I am eating", "நான் சாப்பிடுகிறேன்"],
      ["I ate", "நான் சாப்பிட்டேன்"],
      ["I will eat", "நான் சாப்பிடுவேன்"]
    ],
    correct: 0,
    tamil: "நான் சாப்பிடுகிறேன்",
    english: "I am eating",
    verb: "khaana",
    tense: "present",
    noun: "main"
  },
  {
    id: "movie-dekhna",
    type: "Hinglish context",
    phrase: "aaj movie dekhna hai",
    question: "What is the plan?",
    options: [
      ["Watch a movie today", "இன்று படம் பார்க்க வேண்டும்"],
      ["Eat food tomorrow", "நாளை சாப்பிட வேண்டும்"],
      ["Give money now", "இப்போது பணம் கொடுக்க வேண்டும்"]
    ],
    correct: 0,
    tamil: "இன்று படம் பார்க்க வேண்டும்",
    english: "Have to watch a movie today",
    verb: "dekhna",
    tense: "need/intent",
    noun: "movie"
  },
  {
    id: "kaam-karna",
    type: "Meaning from audio",
    phrase: "mujhe kaam karna hai",
    question: "What is the rough meaning?",
    options: [
      ["I have to work", "எனக்கு வேலை செய்ய வேண்டும்"],
      ["I took water", "நான் தண்ணீர் எடுத்தேன்"],
      ["She came home", "அவள் வீட்டுக்கு வந்தாள்"]
    ],
    correct: 0,
    tamil: "எனக்கு வேலை செய்ய வேண்டும்",
    english: "I have to work",
    verb: "karna",
    tense: "need/intent",
    noun: "kaam"
  },
  {
    id: "chai-peena",
    type: "Verb recognition",
    phrase: "chai peena hai",
    question: "Which action is the anchor?",
    options: [
      ["peena: drink", "குடிப்பது"],
      ["dena: give", "கொடுப்பது"],
      ["aana: come", "வருவது"]
    ],
    correct: 0,
    tamil: "சாய் குடிக்க வேண்டும்",
    english: "Have to drink tea",
    verb: "peena",
    tense: "need/intent",
    noun: "chai"
  },
  {
    id: "phone-liya",
    type: "Meaning from audio",
    phrase: "maine phone liya",
    question: "What happened?",
    options: [
      ["I took the phone", "நான் போன் எடுத்தேன்"],
      ["I gave food", "நான் சாப்பாடு கொடுத்தேன்"],
      ["He is speaking", "அவன் பேசுகிறான்"]
    ],
    correct: 0,
    tamil: "நான் போன் எடுத்தேன்",
    english: "I took the phone",
    verb: "lena",
    tense: "past",
    noun: "phone"
  },
  {
    id: "message-dena",
    type: "Hinglish context",
    phrase: "usko message dena hai",
    question: "What needs to be done?",
    options: [
      ["Give/send him a message", "அவனுக்கு மெசேஜ் கொடுக்க வேண்டும்"],
      ["Take his phone", "அவனுடைய போன் எடுக்க வேண்டும்"],
      ["Watch a movie", "படம் பார்க்க வேண்டும்"]
    ],
    correct: 0,
    tamil: "அவனுக்கு மெசேஜ் கொடுக்க வேண்டும்",
    english: "Have to give/send him a message",
    verb: "dena",
    tense: "need/intent",
    noun: "message"
  },
  {
    id: "kya-hua",
    type: "Meaning from audio",
    phrase: "kya hua",
    question: "What is being asked?",
    options: [
      ["What happened?", "என்ன நடந்தது?"],
      ["What did you eat?", "நீ என்ன சாப்பிட்டாய்?"],
      ["Where are you going?", "நீ எங்கே போகிறாய்?"]
    ],
    correct: 0,
    tamil: "என்ன நடந்தது?",
    english: "What happened?",
    verb: "hona",
    tense: "past",
    noun: "kya"
  },
  {
    id: "kal-aayega",
    type: "Tense/context",
    phrase: "woh kal aayega",
    question: "Is this past, now, or future?",
    options: [
      ["Future: he will come tomorrow", "எதிர்காலம்: அவன் நாளை வருவான்"],
      ["Past: he came yesterday", "கடந்த காலம்: அவன் நேற்று வந்தான்"],
      ["Now: he is eating", "இப்போது: அவன் சாப்பிடுகிறான்"]
    ],
    correct: 0,
    tamil: "அவன் நாளை வருவான்",
    english: "He will come tomorrow",
    verb: "aana",
    tense: "future",
    noun: "kal"
  },
  {
    id: "maine-kiya",
    type: "Verb recognition",
    phrase: "maine already kiya",
    question: "Which base verb does kiya belong to?",
    options: [
      ["karna: to do", "செய்வது"],
      ["jaana: to go", "போவது"],
      ["dekhna: to watch", "பார்ப்பது"]
    ],
    correct: 0,
    tamil: "நான் ஏற்கனவே செய்தேன்",
    english: "I already did it",
    verb: "karna",
    tense: "past",
    noun: "already"
  },
  {
    id: "ghar-aa-rahi",
    type: "Meaning from audio",
    phrase: "main ghar aa rahi hoon",
    question: "What is happening?",
    options: [
      ["I am coming home", "நான் வீட்டுக்கு வந்துகொண்டிருக்கிறேன்"],
      ["I went to office", "நான் ஆபீஸ்க்கு போனேன்"],
      ["I want water", "எனக்கு தண்ணீர் வேண்டும்"]
    ],
    correct: 0,
    tamil: "நான் வீட்டுக்கு வந்துகொண்டிருக்கிறேன்",
    english: "I am coming home",
    verb: "aana",
    tense: "present",
    noun: "ghar"
  },
  {
    id: "tum-dekhoge",
    type: "Tense/context",
    phrase: "tum baad mein dekhoge",
    question: "What time clue is this?",
    options: [
      ["Future: you will see later", "எதிர்காலம்: நீ பிறகு பார்ப்பாய்"],
      ["Past: you saw it", "கடந்த காலம்: நீ பார்த்தாய்"],
      ["Need: you have to drink", "தேவை: நீ குடிக்க வேண்டும்"]
    ],
    correct: 0,
    tamil: "நீ பிறகு பார்ப்பாய்",
    english: "You will see later",
    verb: "dekhna",
    tense: "future",
    noun: "baad mein"
  }
];

const remediationByVerb = {
  jaana: {
    id: "remedial-jaana",
    type: "Simpler follow-up",
    phrase: "jaana hai",
    question: "Which base verb is this?",
    options: [["jaana: to go", "போவது"], ["khaana: to eat", "சாப்பிடுவது"], ["bolna: to say", "சொல்வது"]],
    correct: 0,
    tamil: "போக வேண்டும்",
    english: "Have to go",
    verb: "jaana",
    tense: "need/intent",
    noun: "jaana"
  },
  khaana: {
    id: "remedial-khaana",
    type: "Simpler follow-up",
    phrase: "khaana hai",
    question: "Which action is this?",
    options: [["eat", "சாப்பிடுவது"], ["go", "போவது"], ["give", "கொடுப்பது"]],
    correct: 0,
    tamil: "சாப்பிட வேண்டும்",
    english: "Have to eat",
    verb: "khaana",
    tense: "need/intent",
    noun: "khaana"
  },
  karna: {
    id: "remedial-karna",
    type: "Simpler follow-up",
    phrase: "karna hai",
    question: "Which action is this?",
    options: [["do", "செய்வது"], ["come", "வருவது"], ["drink", "குடிப்பது"]],
    correct: 0,
    tamil: "செய்ய வேண்டும்",
    english: "Have to do",
    verb: "karna",
    tense: "need/intent",
    noun: "karna"
  },
  bolna: {
    id: "remedial-bolna",
    type: "Simpler follow-up",
    phrase: "bolna hai",
    question: "Which action is this?",
    options: [["say/speak", "சொல்வது / பேசுவது"], ["watch", "பார்ப்பது"], ["take", "எடுப்பது"]],
    correct: 0,
    tamil: "சொல்ல வேண்டும்",
    english: "Have to say",
    verb: "bolna",
    tense: "need/intent",
    noun: "bolna"
  }
};

const defaultProgress = {
  attempts: 0,
  correct: 0,
  phraseCorrect: {},
  verbs: {},
  nouns: {},
  tenses: {},
  sessionsCompleted: 0
};

const state = {
  index: 0,
  sessionPrompts: [...prompts],
  answered: false,
  sessionAttempts: 0,
  sessionCorrect: 0,
  currentAudio: null,
  deferredInstallPrompt: null,
  progress: loadProgress()
};

const els = {
  tabs: document.querySelectorAll(".tab"),
  views: document.querySelectorAll(".view"),
  sessionCount: document.querySelector("#sessionCount"),
  sessionSkill: document.querySelector("#sessionSkill"),
  sessionBar: document.querySelector("#sessionBar"),
  playButton: document.querySelector("#playButton"),
  audioState: document.querySelector("#audioState"),
  quizQuestion: document.querySelector("#quizQuestion"),
  options: document.querySelector("#options"),
  revealCard: document.querySelector("#revealCard"),
  resultLine: document.querySelector("#resultLine"),
  heardPhrase: document.querySelector("#heardPhrase"),
  tamilMeaning: document.querySelector("#tamilMeaning"),
  englishMeaning: document.querySelector("#englishMeaning"),
  verbFamily: document.querySelector("#verbFamily"),
  tensePattern: document.querySelector("#tensePattern"),
  nextButton: document.querySelector("#nextButton"),
  verbList: document.querySelector("#verbList"),
  nounList: document.querySelector("#nounList"),
  benchmarkScore: document.querySelector("#benchmarkScore"),
  attemptCount: document.querySelector("#attemptCount"),
  learnedCount: document.querySelector("#learnedCount"),
  sessionAccuracy: document.querySelector("#sessionAccuracy"),
  wordBankCount: document.querySelector("#wordBankCount"),
  verbProgress: document.querySelector("#verbProgress"),
  nounProgress: document.querySelector("#nounProgress"),
  tenseProgress: document.querySelector("#tenseProgress"),
  dayPlan: document.querySelector("#dayPlan"),
  wordSearch: document.querySelector("#wordSearch"),
  searchSummary: document.querySelector("#searchSummary"),
  searchResults: document.querySelector("#searchResults"),
  recordButton: document.querySelector("#recordButton"),
  recordState: document.querySelector("#recordState"),
  transcriptCard: document.querySelector("#transcriptCard"),
  recognizedText: document.querySelector("#recognizedText"),
  wordTranslation: document.querySelector("#wordTranslation"),
  resetButton: document.querySelector("#resetButton"),
  installButton: document.querySelector("#installButton")
};

init();

function init() {
  renderPrompt();
  renderVerbFamilies();
  renderCommonNouns();
  renderProgress();
  bindEvents();
  registerServiceWorker();
}

function bindEvents() {
  els.tabs.forEach((tab) => {
    tab.addEventListener("click", () => showView(tab.dataset.view));
  });

  els.playButton.addEventListener("click", () => playPromptAudio(currentPrompt()));
  document.addEventListener("click", handleAudioButtonClick);
  els.nextButton.addEventListener("click", nextPrompt);
  els.resetButton.addEventListener("click", resetProgress);
  els.wordSearch.addEventListener("input", () => renderSearch(els.wordSearch.value));
  els.recordButton.addEventListener("click", recordSpeech);

  window.addEventListener("beforeinstallprompt", (event) => {
    event.preventDefault();
    state.deferredInstallPrompt = event;
    els.installButton.hidden = false;
  });

  els.installButton.addEventListener("click", async () => {
    if (!state.deferredInstallPrompt) return;
    state.deferredInstallPrompt.prompt();
    await state.deferredInstallPrompt.userChoice;
    state.deferredInstallPrompt = null;
    els.installButton.hidden = true;
  });
}

function showView(viewId) {
  els.views.forEach((view) => view.classList.toggle("active", view.id === viewId));
  els.tabs.forEach((tab) => tab.classList.toggle("active", tab.dataset.view === viewId));
  if (viewId === "progressView") renderProgress();
  if (viewId === "searchView") renderSearch(els.wordSearch.value);
}

function currentPrompt() {
  return state.sessionPrompts[state.index];
}

function renderPrompt() {
  const prompt = currentPrompt();
  state.answered = false;
  els.revealCard.hidden = true;
  els.sessionCount.textContent = `Prompt ${state.index + 1} of ${state.sessionPrompts.length}`;
  els.sessionSkill.textContent = prompt.type;
  els.sessionBar.style.width = `${(state.index / state.sessionPrompts.length) * 100}%`;
  els.quizQuestion.textContent = prompt.question;
  els.audioState.textContent = "Tap play, then answer from what you hear.";
  els.options.innerHTML = "";

  prompt.options.forEach((option, optionIndex) => {
    const button = document.createElement("button");
    button.className = "option";
    button.type = "button";
    button.innerHTML = `${escapeHtml(option[0])}<small>${escapeHtml(option[1])}</small>`;
    button.addEventListener("click", () => answerPrompt(optionIndex));
    els.options.append(button);
  });
}

function answerPrompt(optionIndex) {
  if (state.answered) return;
  const prompt = currentPrompt();
  const isCorrect = optionIndex === prompt.correct;
  state.answered = true;
  state.sessionAttempts += 1;
  state.progress.attempts += 1;

  if (isCorrect) {
    state.sessionCorrect += 1;
    state.progress.correct += 1;
    incrementMap(state.progress.phraseCorrect, prompt.id);
    incrementMap(state.progress.verbs, prompt.verb);
    incrementMap(state.progress.nouns, prompt.noun);
    incrementMap(state.progress.tenses, prompt.tense);
  } else {
    const followUp = remediationByVerb[prompt.verb];
    if (followUp && !state.sessionPrompts.some((item) => item.id === followUp.id)) {
      state.sessionPrompts.splice(state.index + 1, 0, followUp);
    }
  }

  saveProgress();
  renderAnswerState(optionIndex, isCorrect);
  renderProgress();
}

function renderAnswerState(optionIndex, isCorrect) {
  const prompt = currentPrompt();
  [...els.options.children].forEach((button, index) => {
    button.disabled = true;
    if (index === prompt.correct) button.classList.add("correct");
    if (index === optionIndex && !isCorrect) button.classList.add("wrong");
  });

  els.resultLine.textContent = isCorrect ? "Recognized" : "Review this pattern";
  els.resultLine.className = `result-line ${isCorrect ? "right" : "wrong"}`;
  els.heardPhrase.textContent = prompt.phrase;
  els.tamilMeaning.textContent = prompt.tamil;
  els.englishMeaning.textContent = prompt.english;
  els.verbFamily.textContent = `${prompt.verb} family`;
  els.tensePattern.textContent = prompt.tense;
  els.revealCard.hidden = false;
}

function nextPrompt() {
  if (state.index < state.sessionPrompts.length - 1) {
    state.index += 1;
    renderPrompt();
    return;
  }

  state.progress.sessionsCompleted += 1;
  saveProgress();
  els.sessionBar.style.width = "100%";
  els.quizQuestion.textContent = "Session complete";
  els.audioState.textContent = "Come back later for another short listening pass.";
  els.options.innerHTML = "";
  els.revealCard.hidden = true;
  renderProgress();
}

function handleAudioButtonClick(event) {
  const button = event.target.closest("[data-audio-id]");
  if (!button) return;

  playReferenceAudio(button);
}

function playReferenceAudio(button) {
  button.disabled = true;
  button.classList.add("is-playing");
  playAudioClip(button.dataset.audioId, {
    onEnd: () => {
      button.disabled = false;
      button.classList.remove("is-playing");
    },
    onError: () => {
      button.disabled = false;
      button.classList.remove("is-playing");
    },
    onBlocked: () => {
      button.disabled = false;
      button.classList.remove("is-playing");
    }
  });
}

function playPromptAudio(prompt) {
  els.playButton.disabled = true;
  els.audioState.textContent = "Loading natural Hindi audio...";
  playAudioClip(prompt.id, {
    onPlaying: () => {
      els.audioState.textContent = "Listening...";
    },
    onEnd: () => {
      els.playButton.disabled = false;
      els.audioState.textContent = "Now answer from memory.";
    },
    onError: () => {
      els.playButton.disabled = false;
      els.audioState.textContent = "Hindi audio is unavailable. Refresh once or check the hosted build.";
    },
    onBlocked: () => {
      els.playButton.disabled = false;
      els.audioState.textContent = "Audio playback was blocked. Tap Play again.";
    },
    onStarted: () => {
      els.audioState.textContent = "Playing natural Hindi audio...";
    }
  });
}

function playAudioClip(audioId, handlers = {}) {
  window.speechSynthesis?.cancel();
  state.currentAudio?.pause();
  const audioSrc = window.promptAudioData?.[audioId] || `audio/${audioId}.mp3`;
  const audio = new Audio(audioSrc);
  state.currentAudio = audio;

  audio.onplaying = () => {
    handlers.onPlaying?.();
  };

  audio.onended = () => {
    handlers.onEnd?.();
  };

  audio.onerror = () => {
    handlers.onError?.();
  };

  audio
    .play()
    .then(() => {
      handlers.onStarted?.();
    })
    .catch(() => {
      handlers.onBlocked?.();
    });
}

function renderVerbFamilies() {
  els.verbList.innerHTML = "";
  verbFamilies.forEach((verb) => {
    const card = document.createElement("article");
    card.className = "verb-card";
    card.innerHTML = `
      <div class="verb-head">
        <div>
          <div class="word-with-audio">
            <button class="audio-chip" type="button" data-audio-id="word-${escapeHtml(verb.base)}" aria-label="Play ${escapeHtml(verb.base)}">▶</button>
            <div class="verb-title">${escapeHtml(verb.base)}</div>
          </div>
          <div class="meaning-labels">
            <span>Tamil meaning: ${escapeHtml(verb.tamil)}</span>
            <span>English: ${escapeHtml(verb.english)}</span>
          </div>
        </div>
        <span class="chip">${Math.min(state.progress.verbs[verb.base] || 0, 3)}/3</span>
      </div>
      <div class="form-list">
        ${verb.forms
          .map(
            ([form, tamil, english], index) => `
              <div class="form-row">
                <div class="word-with-audio">
                  <button class="audio-chip small" type="button" data-audio-id="form-${escapeHtml(verb.base)}-${index}" aria-label="Play ${escapeHtml(form)}">▶</button>
                  <strong>${escapeHtml(form)}</strong>
                </div>
                <span>Tamil meaning: ${escapeHtml(tamil)}<br>English: ${escapeHtml(english)}</span>
              </div>
            `
          )
          .join("")}
      </div>
    `;
    els.verbList.append(card);
  });
}

function renderCommonNouns() {
  if (!els.nounList) return;
  els.nounList.innerHTML = "";
  commonNouns.forEach((entry) => {
    const card = document.createElement("article");
    card.className = "word-card noun-card";
    card.innerHTML = `
      <div class="word-head">
        <div>
          <div class="word-with-audio">
            <button class="audio-chip" type="button" data-audio-id="word-${escapeHtml(entry.term)}" aria-label="Play ${escapeHtml(entry.term)}">▶</button>
            <div class="word-term">${escapeHtml(entry.term)}</div>
          </div>
          <div class="meaning-labels">
            <span>Tamil meaning: ${escapeHtml(entry.tamil)}</span>
            <span>English: ${escapeHtml(entry.english)}</span>
          </div>
        </div>
        <span class="chip word-type">${escapeHtml(entry.type)}</span>
      </div>
      <div class="alias-line">Heard like: ${escapeHtml([entry.term, ...entry.aliases].slice(0, 6).join(", "))}</div>
    `;
    els.nounList.append(card);
  });
}

function renderProgress() {
  const benchmark = state.progress.attempts ? Math.round((state.progress.correct / state.progress.attempts) * 100) : 0;
  const learned = Object.values(state.progress.phraseCorrect).filter((count) => count >= 3).length;
  const sessionAccuracy = state.sessionAttempts ? Math.round((state.sessionCorrect / state.sessionAttempts) * 100) : 0;

  els.wordBankCount.textContent = vocabulary.length;
  els.benchmarkScore.textContent = `${benchmark}%`;
  els.attemptCount.textContent = state.progress.attempts;
  els.learnedCount.textContent = learned;
  els.sessionAccuracy.textContent = `${sessionAccuracy}%`;
  renderMeterList(els.verbProgress, verbFamilies.map((verb) => verb.base), state.progress.verbs);
  renderMeterList(els.nounProgress, ["ghar", "office", "khaana", "paani", "movie", "kaam", "phone", "message"], state.progress.nouns);
  renderMeterList(els.tenseProgress, ["past", "present", "future", "need/intent", "want/need"], state.progress.tenses);
  renderDayPlan();
  renderVerbFamilies();
  renderCommonNouns();
}

function renderSearch(rawQuery = "") {
  const query = rawQuery.trim();
  const phraseMatch = query ? matchRecognizedPhrase(normalizeRecognizedPhrase(query).split(/\s+/)) : null;
  const searchQuery = phraseMatch?.term || query;
  const results = searchQuery ? searchVocabulary(searchQuery, 10) : vocabulary.slice(0, 10).map((entry) => ({ entry, score: 0, matched: entry.term }));
  els.searchSummary.textContent = query
    ? `${results.length} likely match${results.length === 1 ? "" : "es"} for "${query}"${phraseMatch ? `, interpreted as ${phraseMatch.term}` : ""}.`
    : `Search ${vocabulary.length} base words, or start with these common anchors.`;
  els.searchResults.innerHTML = "";

  results.forEach(({ entry, matched, score }) => {
    const card = document.createElement("article");
    card.className = "word-card";
    card.innerHTML = `
      <div class="word-head">
        <div>
          <div class="word-term">${escapeHtml(entry.term)}</div>
          <div class="verb-meaning">${escapeHtml(entry.english)}</div>
        </div>
        <span class="chip word-type">${escapeHtml(entry.type)}</span>
      </div>
      <div class="word-meaning">
        <div><span>Tamil</span><p>${escapeHtml(entry.tamil)}</p></div>
        <div><span>English</span><p>${escapeHtml(entry.english)}</p></div>
      </div>
      <div class="alias-line">Heard like: ${escapeHtml([entry.term, ...entry.aliases].slice(0, 6).join(", "))}${query ? ` · match: ${escapeHtml(matched)} · score ${score}` : ""}</div>
    `;
    els.searchResults.append(card);
  });
}

function recordSpeech() {
  const Recognition = window.SpeechRecognition || window.webkitSpeechRecognition;
  if (!Recognition) {
    els.recordState.textContent = "Speech recognition is not available in this browser. Try Chrome or Safari, or type the heard word above.";
    return;
  }

  const recognition = new Recognition();
  recognition.lang = "hi-IN";
  recognition.interimResults = false;
  recognition.maxAlternatives = 3;
  els.recordButton.disabled = true;
  els.recordButton.textContent = "Listening...";
  els.recordState.textContent = "Speak or replay the Hindi/Hinglish phrase now.";

  recognition.onresult = (event) => {
    const transcript = event.results[0][0].transcript;
    renderTranscript(transcript);
    els.wordSearch.value = firstSearchableRecognizedToken(transcript) || transcript;
    renderSearch(els.wordSearch.value);
  };

  recognition.onerror = () => {
    els.recordState.textContent = "Could not recognize that audio. Try a shorter phrase or type the closest sound.";
  };

  recognition.onend = () => {
    els.recordButton.disabled = false;
    els.recordButton.textContent = "Record speech";
  };

  recognition.start();
}

function renderTranscript(transcript) {
  const words = transcript.split(/\s+/).map((word) => word.trim()).filter(Boolean);
  const normalizedTokens = words.map((word) => normalizeRecognizedWord(word));
  const phraseMatch = matchRecognizedPhrase(normalizedTokens);
  els.transcriptCard.hidden = false;
  els.recognizedText.textContent = transcript;
  els.recordState.textContent = phraseMatch
    ? "Matched the phrase gist first, then the individual anchor words."
    : "Matched each recognized word against the crash-course word bank.";
  els.wordTranslation.innerHTML = "";

  if (phraseMatch) {
    const phraseRow = document.createElement("div");
    phraseRow.className = "translation-row phrase-row";
    phraseRow.innerHTML = `
      <strong>Phrase gist</strong>
      <span>${escapeHtml(phraseMatch.term)}: ${escapeHtml(phraseMatch.tamil)} · ${escapeHtml(phraseMatch.english)}<br>${escapeHtml(phraseMatch.note)}</span>
    `;
    els.wordTranslation.append(phraseRow);
  }

  words.forEach((word) => {
    const normalizedWord = normalizeRecognizedWord(word);
    const helperMeaning = helperTermMeanings[normalizedWord];
    const match = helperMeaning ? null : searchVocabulary(normalizedWord, 1)[0];
    const row = document.createElement("div");
    row.className = "translation-row";
    if (helperMeaning) {
      row.innerHTML = `<strong>${escapeHtml(word)}</strong><span>${escapeHtml(normalizedWord)}: ${escapeHtml(helperMeaning[1])} · ${escapeHtml(helperMeaning[0])}</span>`;
    } else {
      row.innerHTML = match
        ? `<strong>${escapeHtml(word)}</strong><span>${escapeHtml(match.entry.term)}: ${escapeHtml(match.entry.tamil)} · ${escapeHtml(match.entry.english)}</span>`
        : `<strong>${escapeHtml(word)}</strong><span>No close match yet</span>`;
    }
    els.wordTranslation.append(row);
  });
}

function searchVocabulary(query, limit) {
  const normalizedQuery = normalizeSound(normalizeRecognizedPhrase(query));
  return vocabulary
    .map((entry) => {
      const candidates = [entry.term, entry.english, ...entry.aliases];
      const scored = candidates.map((candidate) => {
        const normalizedCandidate = normalizeSound(candidate);
        let score = editDistance(normalizedQuery, normalizedCandidate);
        if (normalizedCandidate.includes(normalizedQuery)) score -= 2;
        if (normalizedQuery.includes(normalizedCandidate)) score -= 1;
        return { candidate, score };
      });
      scored.sort((a, b) => a.score - b.score);
      return { entry, matched: scored[0].candidate, score: scored[0].score };
    })
    .filter((result) => result.score <= Math.max(3, Math.ceil(normalizedQuery.length * 0.45)))
    .sort((a, b) => a.score - b.score || a.entry.term.localeCompare(b.entry.term))
    .slice(0, limit);
}

function firstSearchableRecognizedToken(value) {
  const tokens = String(value)
    .split(/\s+/)
    .map((word) => normalizeRecognizedWord(word));
  return matchRecognizedPhrase(tokens)?.term || tokens.find((word) => word && !helperTermMeanings[word]);
}

function normalizeRecognizedPhrase(value) {
  return String(value)
    .split(/\s+/)
    .map((word) => normalizeRecognizedWord(word))
    .join(" ");
}

function normalizeRecognizedWord(value) {
  const word = String(value).trim().replace(/[?!\u0964,.;:]/g, "");
  return recognizedHindiTerms[word] || word;
}

function matchRecognizedPhrase(tokens) {
  const normalizedTokens = tokens.map((token) => normalizeSound(token));
  return phraseMatches.find((match) =>
    match.tokens.every((required) => normalizedTokens.some((token) => token.includes(normalizeSound(required))))
  );
}

function normalizeSound(value) {
  return String(value)
    .toLowerCase()
    .replaceAll(/[^a-z0-9]+/g, "")
    .replaceAll("aa", "a")
    .replaceAll("ee", "i")
    .replaceAll("oo", "u")
    .replaceAll("ph", "f")
    .replaceAll("bh", "b")
    .replaceAll("dh", "d")
    .replaceAll("th", "t")
    .replaceAll("sh", "s")
    .replaceAll("ch", "c")
    .replaceAll("w", "v")
    .replaceAll("z", "j");
}

function editDistance(a, b) {
  const rows = Array.from({ length: a.length + 1 }, (_, row) => [row]);
  for (let column = 1; column <= b.length; column += 1) rows[0][column] = column;

  for (let row = 1; row <= a.length; row += 1) {
    for (let column = 1; column <= b.length; column += 1) {
      const cost = a[row - 1] === b[column - 1] ? 0 : 1;
      rows[row][column] = Math.min(
        rows[row - 1][column] + 1,
        rows[row][column - 1] + 1,
        rows[row - 1][column - 1] + cost
      );
    }
  }

  return rows[a.length][b.length];
}

function renderDayPlan() {
  const wordsPerDay = Math.ceil(vocabulary.length / 14);
  els.dayPlan.innerHTML = "";
  for (let day = 0; day < 14; day += 1) {
    const words = vocabulary.slice(day * wordsPerDay, (day + 1) * wordsPerDay).map((entry) => entry.term);
    const row = document.createElement("div");
    row.className = "form-row";
    row.innerHTML = `
      <strong>Day ${day + 1}</strong>
      <span>${escapeHtml(words.join(", "))}</span>
    `;
    els.dayPlan.append(row);
  }
}

function renderMeterList(container, labels, values) {
  container.innerHTML = "";
  labels.forEach((label) => {
    const count = values[label] || 0;
    const percent = Math.min(count / 3, 1) * 100;
    const row = document.createElement("div");
    row.className = "meter-row";
    row.innerHTML = `
      <span>${escapeHtml(label)}</span>
      <div class="meter" aria-hidden="true"><div style="width:${percent}%"></div></div>
      <span>${Math.min(count, 3)}/3</span>
    `;
    container.append(row);
  });
}

function loadProgress() {
  try {
    return { ...defaultProgress, ...JSON.parse(localStorage.getItem("hindi-listening-progress")) };
  } catch {
    return cloneDefaultProgress();
  }
}

function saveProgress() {
  localStorage.setItem("hindi-listening-progress", JSON.stringify(state.progress));
}

function resetProgress() {
  state.progress = cloneDefaultProgress();
  state.sessionAttempts = 0;
  state.sessionCorrect = 0;
  saveProgress();
  renderProgress();
}

function incrementMap(map, key) {
  map[key] = (map[key] || 0) + 1;
}

function cloneDefaultProgress() {
  return {
    attempts: 0,
    correct: 0,
    phraseCorrect: {},
    verbs: {},
    nouns: {},
    tenses: {},
    sessionsCompleted: 0
  };
}

function escapeHtml(value) {
  return String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
}

function registerServiceWorker() {
  if ("serviceWorker" in navigator) {
    navigator.serviceWorker.register("service-worker.js");
  }
}
