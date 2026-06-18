export type EmotionTag =
  | "孤独"
  | "不安"
  | "嫉妬"
  | "希望"
  | "怒り"
  | "恋愛"
  | "罪悪感"
  | "生きづらさ"
  | "青春"
  | "絶望"
  | "自己嫌悪"
  | "承認欲求"
  | "郷愁"
  | "諦念";

export interface GlossaryEntry {
  word: string;
  reading: string;
  meaning: string;
  vibes: string;
}

export interface TextSegment {
  text: string;
  vibes: string;
  emotions: Partial<Record<EmotionTag, number>>;
  glossary?: GlossaryEntry[];
}

export interface Author {
  id: string;
  name: string;
  bio: string;
  tags: EmotionTag[];
  works: string[];
  born: string;
  died: string;
  icon: string;
}

export interface Work {
  id: string;
  title: string;
  authorId: string;
  authorName: string;
  tags: EmotionTag[];
  readTime: string;
  premium: boolean;
  coverEmoji: string;
  description: string;
  afterword: {
    theme: string;
    point: string;
    modern: string;
  };
  segments: TextSegment[];
}

export const authors: Author[] = [
  {
    id: "dazai",
    name: "太宰治",
    bio: "人間やるの疲れがちな文豪。自分が嫌いなのに誰かに愛されたい矛盾を抱えて生きた人。",
    tags: ["自己嫌悪", "承認欲求", "孤独"],
    works: ["ningen-shikkaku", "hashire-melos"],
    born: "1909",
    died: "1948",
    icon: "🖋️",
  },
  {
    id: "akutagawa",
    name: "芥川龍之介",
    bio: "知性で武装した繊細すぎるメンタルの持ち主。短編の天才だけど、生きるのは下手だった。",
    tags: ["不安", "嫉妬", "絶望"],
    works: ["rashomon", "kumo-no-ito"],
    born: "1892",
    died: "1927",
    icon: "📚",
  },
  {
    id: "natsume",
    name: "夏目漱石",
    bio: "明治のインテリ代表。人付き合い苦手なのに人間観察は超一流。猫視点で社会を斬る。",
    tags: ["孤独", "郷愁", "諦念"],
    works: ["kokoro"],
    born: "1867",
    died: "1916",
    icon: "🐱",
  },
  {
    id: "miyazawa",
    name: "宮沢賢治",
    bio: "生前はほぼ無名。自然と宇宙とやさしさを描いた孤独な理想主義者。",
    tags: ["希望", "孤独", "青春"],
    works: ["gingatetsudo"],
    born: "1896",
    died: "1933",
    icon: "🌌",
  },
];

export const works: Work[] = [
  {
    id: "ningen-shikkaku",
    title: "人間失格",
    authorId: "dazai",
    authorName: "太宰治",
    tags: ["自己嫌悪", "孤独", "生きづらさ"],
    readTime: "8分",
    premium: false,
    coverEmoji: "🎭",
    description:
      "「恥の多い生涯を送って来ました」──人間のフリをし続けた男の告白。",
    afterword: {
      theme: "人間として生きることへの根源的な違和感",
      point: "「自分は人間としての資格がない」と思ったことがある人なら、この感覚がわかるはず",
      modern:
        "SNS時代の「本当の自分」問題。オンラインで演じる自分とリアルの自分のギャップに悩む感覚と同じ。",
    },
    segments: [
      {
        text: "恥の多い生涯を送って来ました。",
        vibes: "開幕からいきなり自己否定MAX",
        emotions: { 自己嫌悪: 90, 孤独: 60 },
        glossary: [
          {
            word: "生涯",
            reading: "しょうがい",
            meaning: "人の一生",
            vibes: "生まれてから死ぬまでの全部",
          },
        ],
      },
      {
        text: "自分には、人間の生活というものが、見当がつかないのです。",
        vibes: "人間やり方マニュアルください状態",
        emotions: { 自己嫌悪: 80, 不安: 70, 孤独: 85 },
        glossary: [
          {
            word: "見当がつかない",
            reading: "けんとうがつかない",
            meaning: "まったくわからない",
            vibes: "ガチで何もわからん",
          },
        ],
      },
      {
        text: "自分の幸福の観念と、世のすべての人たちの幸福の観念とが、まるで食いちがっているような気がして、",
        vibes: "みんなと同じ「幸せ」が感じられない孤立感",
        emotions: { 孤独: 90, 自己嫌悪: 70, 不安: 60 },
        glossary: [
          {
            word: "観念",
            reading: "かんねん",
            meaning: "考え方・とらえ方",
            vibes: "「幸せ」の定義が周りと違いすぎる",
          },
          {
            word: "食いちがう",
            reading: "くいちがう",
            meaning: "かみ合わない・ずれる",
            vibes: "パズルのピースが全然ハマらない感じ",
          },
        ],
      },
      {
        text: "自分はその不安のために夜々、転輾し、呻吟し、発狂しかけた事さえあります。",
        vibes: "夜中に布団の中で頭がぐるぐるするやつ",
        emotions: { 不安: 95, 自己嫌悪: 80, 孤独: 70 },
        glossary: [
          {
            word: "転輾",
            reading: "てんてん",
            meaning: "眠れずに何度も寝返りをうつこと",
            vibes: "深夜3時にスマホ見ながら寝返りしまくるあの感じ",
          },
          {
            word: "呻吟",
            reading: "しんぎん",
            meaning: "苦しくてうめくこと",
            vibes: "メンタルがしんどすぎて声が出るやつ",
          },
        ],
      },
      {
        text: "自分は隣人と、ほとんど会話が出来ません。何を、どう言いいいのか、わからないのです。",
        vibes: "コミュ障の元祖みたいな告白",
        emotions: { 孤独: 95, 不安: 80, 自己嫌悪: 75 },
      },
      {
        text: "そこで考え出したのは、道化でした。",
        vibes: "「おもしろキャラ」で武装するという生存戦略",
        emotions: { 孤独: 80, 自己嫌悪: 85 },
        glossary: [
          {
            word: "道化",
            reading: "どうけ",
            meaning: "おどけた役、ピエロ",
            vibes: "クラスのお笑い担当を無理してやってる状態",
          },
        ],
      },
      {
        text: "それは、自分の、人間に対する最後の求愛でした。",
        vibes: "ふざけてるように見えて、本当は必死に愛されたかった",
        emotions: { 承認欲求: 95, 孤独: 90, 自己嫌悪: 70 },
        glossary: [
          {
            word: "求愛",
            reading: "きゅうあい",
            meaning: "愛を求めること",
            vibes: "「お願いだから嫌いにならないで」っていう心の叫び",
          },
        ],
      },
      {
        text: "自分は、人間を極度に恐れていながら、それでいて、人間を、どうしても思い切れなかったらしいのです。",
        vibes: "人が怖いのに人がいないと生きられない矛盾",
        emotions: { 孤独: 95, 承認欲求: 90, 不安: 85 },
      },
      {
        text: "ただ、一さいは過ぎて行きます。",
        vibes: "すべてを受け入れた、静かな諦め",
        emotions: { 諦念: 95, 孤独: 60 },
      },
    ],
  },
  {
    id: "rashomon",
    title: "羅生門",
    authorId: "akutagawa",
    authorName: "芥川龍之介",
    tags: ["不安", "罪悪感", "生きづらさ"],
    readTime: "6分",
    premium: false,
    coverEmoji: "🚪",
    description: "善悪の境界線が溶ける、極限状態の人間ドラマ。",
    afterword: {
      theme: "生きるためなら悪も許されるのか？",
      point: "追い詰められた時、自分ならどうする？という問い",
      modern:
        "就活や生活苦で「もう何でもいいから」となる感覚。ルールを破る自分を正当化する心理。",
    },
    segments: [
      {
        text: "ある日の暮方の事である。一人の下人が、羅生門の下で雨やみを待っていた。",
        vibes: "職を失った男が、雨宿りしながら人生を考えてる",
        emotions: { 不安: 70, 孤独: 60 },
        glossary: [
          {
            word: "下人",
            reading: "げにん",
            meaning: "身分の低い使用人",
            vibes: "今でいうと派遣切りにあった人",
          },
          {
            word: "羅生門",
            reading: "らしょうもん",
            meaning: "京都にあった巨大な門",
            vibes: "荒れ果てた廃墟みたいな場所",
          },
        ],
      },
      {
        text: "広い門の下には、この男のほかに誰もいない。",
        vibes: "完全に孤立してる感",
        emotions: { 孤独: 80, 不安: 50 },
      },
      {
        text: "下人は、大きなくさめをして、それから、大儀そうに立上がった。",
        vibes: "だるい。人生だるい。",
        emotions: { 諦念: 60, 不安: 40 },
        glossary: [
          {
            word: "くさめ",
            reading: "くさめ",
            meaning: "くしゃみ",
            vibes: "くしゃみのこと。古語。",
          },
          {
            word: "大儀そうに",
            reading: "たいぎそうに",
            meaning: "面倒くさそうに",
            vibes: "「あー、だりぃ」って感じ",
          },
        ],
      },
      {
        text: "この男には、明日の暮しさえどうなるかわからない。何のあてもない。",
        vibes: "将来の見通しゼロ。ガチの詰み。",
        emotions: { 不安: 90, 絶望: 70, 孤独: 60 },
      },
      {
        text: "盗人になるよりほかに仕方がない。——と云う事を、彼は何度も繰返した。",
        vibes: "犯罪に手を染めるしかないところまで追い詰められてる",
        emotions: { 罪悪感: 60, 不安: 85, 生きづらさ: 80 },
        glossary: [
          {
            word: "盗人",
            reading: "ぬすびと",
            meaning: "泥棒",
            vibes: "犯罪者になるしかないと自分に言い聞かせてる",
          },
        ],
      },
      {
        text: "しかし、その「すれば」を、いくら繰返しても、結局「すれば」は、いつまでたっても、「すれば」であった。",
        vibes: "やるしかないって言いつつ、一歩が踏み出せない",
        emotions: { 不安: 80, 罪悪感: 70 },
      },
      {
        text: "下人の悪を憎む心は、老婆の床に挿した松の木片のように、勢いよく燃え上がり出していた。",
        vibes: "正義感に火がついた瞬間",
        emotions: { 怒り: 85, 希望: 30 },
      },
      {
        text: "「では、己が引剥をしようと恨むまいな。己もそうしなければ、饑死をする体なのだ。」",
        vibes: "「お前がやるなら俺もやっていいよな」という論理の転換",
        emotions: { 罪悪感: 40, 怒り: 60, 生きづらさ: 90 },
        glossary: [
          {
            word: "引剥",
            reading: "ひはぎ",
            meaning: "他人の着物をはぎ取る強盗",
            vibes: "服を奪い取る追い剥ぎのこと",
          },
          {
            word: "饑死",
            reading: "うえじに",
            meaning: "飢え死に",
            vibes: "マジで餓死するレベルの貧困",
          },
        ],
      },
      {
        text: "下人は、既に、雨を冒して、京都の町へ強盗を働きに急いでいた。下人の行方は、誰も知らない。",
        vibes: "善悪の境界線を超えた男の、行き先不明なラスト",
        emotions: { 絶望: 70, 罪悪感: 50, 不安: 60 },
      },
    ],
  },
  {
    id: "hashire-melos",
    title: "走れメロス",
    authorId: "dazai",
    authorName: "太宰治",
    tags: ["希望", "青春", "怒り"],
    readTime: "7分",
    premium: false,
    coverEmoji: "🏃",
    description: "信じること・信じられることの重さを描く、全力疾走の友情物語。",
    afterword: {
      theme: "人を信じることの美しさと苦しさ",
      point: "約束を守るために走り続ける姿が、意外と今のメンタルに刺さる",
      modern:
        "「既読スルーされると不安になる」時代に、信頼って何？を考えさせる。",
    },
    segments: [
      {
        text: "メロスは激怒した。必ず、かの邪智暴虐の王を除かなければならぬと決意した。",
        vibes: "開幕ブチギレ。正義感の塊。",
        emotions: { 怒り: 95, 希望: 40 },
        glossary: [
          {
            word: "邪智暴虐",
            reading: "じゃちぼうぎゃく",
            meaning: "ずる賢くて暴力的",
            vibes: "パワハラ上司の究極形態",
          },
        ],
      },
      {
        text: "メロスには政治がわからぬ。メロスは、村の牧人である。笛を吹き、羊と遊んで暮して来た。",
        vibes: "政治わからんけど、理不尽は許さないマン",
        emotions: { 青春: 70, 希望: 50 },
        glossary: [
          {
            word: "牧人",
            reading: "ぼくじん",
            meaning: "羊飼い",
            vibes: "のんびり田舎で暮らしてたピュアな青年",
          },
        ],
      },
      {
        text: "「人の心を疑うのは、最も恥ずべき悪徳だ。」",
        vibes: "信じることを諦めない、まっすぐすぎる信念",
        emotions: { 希望: 90, 青春: 80 },
      },
      {
        text: "メロスは、友に誓った。三日のうちに、必ず帰る。",
        vibes: "命をかけた約束。友情が重すぎる。",
        emotions: { 希望: 80, 不安: 50 },
      },
      {
        text: "走れ！メロス。もっと速く、もっと速く。遅れてはならぬ。",
        vibes: "全力疾走。限界超えてる。",
        emotions: { 希望: 70, 不安: 80, 青春: 90 },
      },
      {
        text: "私は、信頼に報いなければならぬ。いまはただその一事だ。走れ！メロス。",
        vibes: "約束を守るためだけに走る。シンプルだけど最強。",
        emotions: { 希望: 95, 青春: 85 },
      },
      {
        text: "メロスは走った。メロスは友を救うために走った。",
        vibes: "理屈じゃない、全身全霊の友情",
        emotions: { 希望: 90, 青春: 95 },
      },
    ],
  },
  {
    id: "kumo-no-ito",
    title: "蜘蛛の糸",
    authorId: "akutagawa",
    authorName: "芥川龍之介",
    tags: ["罪悪感", "希望", "絶望"],
    readTime: "4分",
    premium: true,
    coverEmoji: "🕸️",
    description:
      "地獄からの一本の蜘蛛の糸。チャンスを掴めるか、自分勝手に落ちるか。",
    afterword: {
      theme: "エゴイズムと救済の矛盾",
      point: "自分だけ助かりたいと思った瞬間に、救いの糸が切れる",
      modern:
        "「自分だけ得したい」が当たり前の競争社会で、利他の心はどこまで持てるか。",
    },
    segments: [
      {
        text: "ある日の事でございます。御釈迦様は極楽の蓮池のふちを、独りでぶらぶら御歩きになっていらっしゃいました。",
        vibes: "お釈迦様の散歩シーン。穏やかスタート。",
        emotions: { 希望: 50 },
        glossary: [
          {
            word: "御釈迦様",
            reading: "おしゃかさま",
            meaning: "仏教の開祖ブッダ",
            vibes: "仏教界のトップ。最強の慈悲の持ち主。",
          },
        ],
      },
      {
        text: "ふと御釈迦様は、蓮池の水の中を御覧になりました。この蓮池の下は、丁度地獄の底に当たって居ります。",
        vibes: "極楽から地獄を覗くという衝撃の構図",
        emotions: { 不安: 40, 希望: 30 },
      },
      {
        text: "その地獄の底に、犍陀多という男が、ほかの罪人と一しょに蠢いている姿が、御眼に止まりました。",
        vibes: "地獄でもがいてる元犯罪者にフォーカス",
        emotions: { 絶望: 70, 罪悪感: 60 },
        glossary: [
          {
            word: "犍陀多",
            reading: "カンダタ",
            meaning: "この物語の主人公。大泥棒。",
            vibes: "地獄に落ちた悪人だけど、一回だけ蜘蛛を助けたことがある",
          },
          {
            word: "蠢いている",
            reading: "うごめいている",
            meaning: "虫のようにうごめくこと",
            vibes: "地獄でゾワゾワ這いずり回ってる",
          },
        ],
      },
      {
        text: "「これは己のものだ。己のものだ。下りろ。下りろ。」と喚きました。",
        vibes: "「俺だけ助かりたい」エゴ全開の瞬間",
        emotions: { 罪悪感: 30, 怒り: 70, 自己嫌悪: 50 },
        glossary: [
          {
            word: "喚く",
            reading: "わめく",
            meaning: "大声で叫ぶ",
            vibes: "パニックで叫びまくってる",
          },
        ],
      },
      {
        text: "すると、その途端でございます。蜘蛛の糸が、犍陀多のぶら下がっている所から、ぷつりと音を立てて断れました。",
        vibes: "エゴの瞬間に救いが消える。因果応報。",
        emotions: { 絶望: 95, 罪悪感: 80 },
      },
      {
        text: "後にはただ極楽の蜘蛛の糸が、きらきらと細く光りながら、月も星もない空の中途に、短く垂れているばかりでございます。",
        vibes: "静かに糸だけが残る。美しくて残酷なラスト。",
        emotions: { 絶望: 80, 孤独: 70 },
      },
    ],
  },
  {
    id: "kokoro",
    title: "こころ",
    authorId: "natsume",
    authorName: "夏目漱石",
    tags: ["孤独", "罪悪感", "生きづらさ"],
    readTime: "10分",
    premium: true,
    coverEmoji: "💔",
    description:
      "信頼と裏切り、罪悪感と孤独。明治の知識人が抱えた「こころ」の闇。",
    afterword: {
      theme: "人を信じることと、裏切ってしまうことの苦しみ",
      point: "秘密を抱え続けることの重さ。誰にも言えない罪悪感。",
      modern:
        "SNSでは見せない裏の自分。「本当のことを言えない」関係性の脆さ。",
    },
    segments: [
      {
        text: "私はその人を常に先生と呼んでいた。だからここでもただ先生と書くだけで本名は打ち明けない。",
        vibes: "謎の人物「先生」。名前を隠すところからもう重い。",
        emotions: { 孤独: 50, 不安: 30 },
      },
      {
        text: "これは私だけの秘密です。私はこの秘密を持って、やがてこの世から消えてしまう積りです。",
        vibes: "墓場まで持っていく系の秘密",
        emotions: { 罪悪感: 90, 孤独: 85, 絶望: 60 },
      },
      {
        text: "人間はね、自分が困らない程度内で、なるべく人に親切がして見たいものだ。",
        vibes: "やさしさには限界があるという現実",
        emotions: { 孤独: 60, 諦念: 70 },
      },
      {
        text: "精神的に向上心のないものは馬鹿だ。",
        vibes: "現状維持で満足するなという圧",
        emotions: { 怒り: 50, 希望: 40 },
      },
      {
        text: "恋は罪悪ですよ。——そうして神聖なものですよ。",
        vibes: "恋は罪で、同時に聖なるもの。矛盾だけど真実。",
        emotions: { 恋愛: 80, 罪悪感: 70 },
      },
      {
        text: "もう取り返しがつかないという黒い光が、私の未来を貫いて、一瞬間に私の前に横たわる全生涯を物凄く照らしました。",
        vibes: "人生が終わったと悟る瞬間の絶望",
        emotions: { 絶望: 95, 罪悪感: 90, 孤独: 80 },
        glossary: [
          {
            word: "一瞬間",
            reading: "いっしゅんかん",
            meaning: "ほんの一瞬",
            vibes: "全部が壊れるのは一瞬で十分",
          },
        ],
      },
    ],
  },
  {
    id: "gingatetsudo",
    title: "銀河鉄道の夜",
    authorId: "miyazawa",
    authorName: "宮沢賢治",
    tags: ["孤独", "希望", "青春"],
    readTime: "9分",
    premium: true,
    coverEmoji: "🌠",
    description:
      "孤独な少年が銀河を旅する、美しくて切ないファンタジー。",
    afterword: {
      theme: "本当の幸せとは何か",
      point: "大切な人がいなくなっても、その記憶は銀河のように輝き続ける",
      modern:
        "推しのロスや友人との別れを経験した人に刺さる。「いなくなっても、その存在は消えない」。",
    },
    segments: [
      {
        text: "「ではみなさんは、そういうふうに川だと云われたり、乳の流れたあとだと云われたりしていたこのぼんやりと白いものがほんとうは何かご承知ですか。」",
        vibes: "天の川って何？から始まる宇宙の授業",
        emotions: { 希望: 40, 青春: 50 },
        glossary: [
          {
            word: "乳の流れたあと",
            reading: "ちちのながれたあと",
            meaning: "天の川の別名（ミルキーウェイの語源）",
            vibes: "天の川＝ミルクがこぼれた跡、っていう昔の言い方",
          },
        ],
      },
      {
        text: "カムパネルラが手をあげました。それから四五人手をあげました。ジョバンニも手をあげようとして、急いでそのままやめました。",
        vibes: "手を挙げられない。自信がない。教室での孤独。",
        emotions: { 孤独: 80, 不安: 60, 青春: 40 },
      },
      {
        text: "ジョバンニは、もう何も云えずに、そのまま泣き出してしまいました。",
        vibes: "言葉にできない悲しみが溢れた瞬間",
        emotions: { 孤独: 90, 絶望: 50 },
      },
      {
        text: "「カムパネルラ、また僕たち二人きりになったねえ。」",
        vibes: "親友と二人だけの銀河の旅。尊い。",
        emotions: { 希望: 70, 青春: 85, 孤独: 30 },
      },
      {
        text: "「カムパネルラ、僕たちどこまでもどこまでも一緒に行こう。」",
        vibes: "永遠に一緒にいたい、という切なる願い",
        emotions: { 希望: 80, 青春: 90, 孤独: 40 },
      },
      {
        text: "ジョバンニはカムパネルラがどこかへ行ってしまったのではないかと思いました。",
        vibes: "大切な人がいなくなる予感。胸が痛い。",
        emotions: { 孤独: 95, 絶望: 70, 不安: 80 },
      },
      {
        text: "「ほんとうのさいわいは一体何だろう。」",
        vibes: "この物語の核心。答えは出ない。でも問い続ける。",
        emotions: { 希望: 60, 孤独: 50, 青春: 40 },
      },
    ],
  },
];

export const emotionColors: Record<EmotionTag, string> = {
  孤独: "#6366f1",
  不安: "#8b5cf6",
  嫉妬: "#10b981",
  希望: "#f59e0b",
  怒り: "#ef4444",
  恋愛: "#ec4899",
  罪悪感: "#6b7280",
  生きづらさ: "#78716c",
  青春: "#06b6d4",
  絶望: "#1e1b4b",
  自己嫌悪: "#7c3aed",
  承認欲求: "#f97316",
  郷愁: "#a78bfa",
  諦念: "#94a3b8",
};

export const emotionEmojis: Record<EmotionTag, string> = {
  孤独: "🌙",
  不安: "🌊",
  嫉妬: "🐍",
  希望: "🌅",
  怒り: "🔥",
  恋愛: "💕",
  罪悪感: "⛓️",
  生きづらさ: "🫠",
  青春: "🌸",
  絶望: "🕳️",
  自己嫌悪: "🪞",
  承認欲求: "📱",
  郷愁: "🏚️",
  諦念: "🍃",
};
