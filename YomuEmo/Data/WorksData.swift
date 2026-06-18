import Foundation

enum WorksData {
    static let all: [Work] = [
        Work(
            id: "ningen-shikkaku",
            title: "人間失格",
            authorId: "dazai",
            authorName: "太宰治",
            tags: [.自己嫌悪, .孤独, .生きづらさ],
            readTime: "8分",
            isPremium: false,
            coverEmoji: "🎭",
            description: "「恥の多い生涯を送って来ました」──人間のフリをし続けた男の告白。",
            afterword: Work.Afterword(
                theme: "人間として生きることへの根源的な違和感",
                point: "「自分は人間としての資格がない」と思ったことがある人なら、この感覚がわかるはず",
                modern: "SNS時代の「本当の自分」問題。オンラインで演じる自分とリアルの自分のギャップに悩む感覚と同じ。"
            ),
            segments: [
                TextSegment(
                    originalText: "恥の多い生涯を送って来ました。",
                    easyText: "めちゃくちゃ恥ずかしいことだらけの人生でした。",
                    emoText: "ずっと、恥ずかしくて、\n情けなくて、\n消えたかった人生だった。",
                    vibesSummary: "開幕からいきなり自己否定MAX",
                    emotionScores: [.自己嫌悪: 90, .孤独: 60],
                    glossaryEntries: [
                        GlossaryEntry(word: "生涯", reading: "しょうがい", meaning: "人の一生", vibes: "生まれてから死ぬまでの全部")
                    ]
                ),
                TextSegment(
                    originalText: "自分には、人間の生活というものが、見当がつかないのです。",
                    easyText: "自分には、「ふつうの生活」ってやつが、まったくわからないんです。",
                    emoText: "みんなが当たり前にやってる「ふつう」が、\n自分にはどうしてもわからない。",
                    vibesSummary: "人間やり方マニュアルください状態",
                    emotionScores: [.自己嫌悪: 80, .不安: 70, .孤独: 85],
                    glossaryEntries: [
                        GlossaryEntry(word: "見当がつかない", reading: "けんとうがつかない", meaning: "まったくわからない", vibes: "ガチで何もわからん")
                    ]
                ),
                TextSegment(
                    originalText: "自分の幸福の観念と、世のすべての人たちの幸福の観念とが、まるで食いちがっているような気がして、",
                    easyText: "自分が「幸せ」だと思うことと、みんなが「幸せ」だと思うことが、全然ちがう気がして、",
                    emoText: "みんなの「幸せ」と自分の「幸せ」が\n全然違う場所にあって、\nどうしても交わらない。",
                    vibesSummary: "みんなと同じ「幸せ」が感じられない孤立感",
                    emotionScores: [.孤独: 90, .自己嫌悪: 70, .不安: 60],
                    glossaryEntries: [
                        GlossaryEntry(word: "観念", reading: "かんねん", meaning: "考え方・とらえ方", vibes: "「幸せ」の定義が周りと違いすぎる"),
                        GlossaryEntry(word: "食いちがう", reading: "くいちがう", meaning: "かみ合わない・ずれる", vibes: "パズルのピースが全然ハマらない感じ")
                    ]
                ),
                TextSegment(
                    originalText: "自分はその不安のために夜々、転輾し、呻吟し、発狂しかけた事さえあります。",
                    easyText: "その不安のせいで毎晩、寝返りをうちまくって、うめいて、おかしくなりそうになったことすらあります。",
                    emoText: "毎晩毎晩、\n頭の中がぐるぐるして、\n壊れそうになった。",
                    vibesSummary: "夜中に布団の中で頭がぐるぐるするやつ",
                    emotionScores: [.不安: 95, .自己嫌悪: 80, .孤独: 70],
                    glossaryEntries: [
                        GlossaryEntry(word: "転輾", reading: "てんてん", meaning: "眠れずに何度も寝返りをうつこと", vibes: "深夜3時にスマホ見ながら寝返りしまくるあの感じ"),
                        GlossaryEntry(word: "呻吟", reading: "しんぎん", meaning: "苦しくてうめくこと", vibes: "メンタルがしんどすぎて声が出るやつ")
                    ]
                ),
                TextSegment(
                    originalText: "自分は隣人と、ほとんど会話が出来ません。何を、どう言いいいのか、わからないのです。",
                    easyText: "自分は周りの人と、ほとんど話せません。何を、どう話せばいいのか、わからないんです。",
                    emoText: "人と話すとき、\n何を言えばいいかわからなくて、\nいつも言葉が出てこない。",
                    vibesSummary: "コミュ障の元祖みたいな告白",
                    emotionScores: [.孤独: 95, .不安: 80, .自己嫌悪: 75],
                    pollIndex: 0
                ),
                TextSegment(
                    originalText: "そこで考え出したのは、道化でした。",
                    easyText: "そこで思いついたのは、ピエロを演じることでした。",
                    emoText: "だから、\nおどけて笑って、\nピエロになることにした。",
                    vibesSummary: "「おもしろキャラ」で武装するという生存戦略",
                    emotionScores: [.孤独: 80, .自己嫌悪: 85],
                    glossaryEntries: [
                        GlossaryEntry(word: "道化", reading: "どうけ", meaning: "おどけた役、ピエロ", vibes: "クラスのお笑い担当を無理してやってる状態")
                    ]
                ),
                TextSegment(
                    originalText: "それは、自分の、人間に対する最後の求愛でした。",
                    easyText: "それは、自分なりの「お願いだから嫌いにならないで」という、最後のアピールでした。",
                    emoText: "ふざけてるように見えて、\n本当は、嫌われたくなくて、\n必死だった。",
                    vibesSummary: "ふざけてるように見えて、本当は必死に愛されたかった",
                    emotionScores: [.承認欲求: 95, .孤独: 90, .自己嫌悪: 70],
                    glossaryEntries: [
                        GlossaryEntry(word: "求愛", reading: "きゅうあい", meaning: "愛を求めること", vibes: "「お願いだから嫌いにならないで」っていう心の叫び")
                    ]
                ),
                TextSegment(
                    originalText: "自分は、人間を極度に恐れていながら、それでいて、人間を、どうしても思い切れなかったらしいのです。",
                    easyText: "自分は、人がめちゃくちゃ怖いのに、それでも人のことを諦められなかったみたいなんです。",
                    emoText: "人が怖い。\nでも、人がいないと\n生きていけない。\nこの矛盾が、ずっと苦しい。",
                    vibesSummary: "人が怖いのに人がいないと生きられない矛盾",
                    emotionScores: [.孤独: 95, .承認欲求: 90, .不安: 85]
                ),
                TextSegment(
                    originalText: "ただ、一さいは過ぎて行きます。",
                    easyText: "ただ、全部は過ぎていきます。",
                    emoText: "結局、\nぜんぶ、\n過ぎていく。",
                    vibesSummary: "すべてを受け入れた、静かな諦め",
                    emotionScores: [.諦念: 95, .孤独: 60]
                ),
            ],
            polls: [
                Poll(
                    question: "葉蔵に共感する？",
                    options: [
                        PollOption(text: "とても共感する", percentage: 52),
                        PollOption(text: "少し共感する", percentage: 30),
                        PollOption(text: "あまり共感しない", percentage: 12),
                        PollOption(text: "共感しない", percentage: 6),
                    ]
                ),
            ]
        ),

        Work(
            id: "rashomon",
            title: "羅生門",
            authorId: "akutagawa",
            authorName: "芥川龍之介",
            tags: [.不安, .罪悪感, .生きづらさ],
            readTime: "6分",
            isPremium: false,
            coverEmoji: "🚪",
            description: "善悪の境界線が溶ける、極限状態の人間ドラマ。",
            afterword: Work.Afterword(
                theme: "生きるためなら悪も許されるのか？",
                point: "追い詰められた時、自分ならどうする？という問い",
                modern: "就活や生活苦で「もう何でもいいから」となる感覚。ルールを破る自分を正当化する心理。"
            ),
            segments: [
                TextSegment(
                    originalText: "ある日の暮方の事である。一人の下人が、羅生門の下で雨やみを待っていた。",
                    easyText: "ある日の夕方のこと。一人のクビになった男が、羅生門の下で雨が止むのを待っていた。",
                    emoText: "夕暮れ。\n仕事を失った男が、\n雨宿りしながら、\nこれからどうするか考えていた。",
                    vibesSummary: "職を失った男が、雨宿りしながら人生を考えてる",
                    emotionScores: [.不安: 70, .孤独: 60],
                    glossaryEntries: [
                        GlossaryEntry(word: "下人", reading: "げにん", meaning: "身分の低い使用人", vibes: "今でいうと派遣切りにあった人"),
                        GlossaryEntry(word: "羅生門", reading: "らしょうもん", meaning: "京都にあった巨大な門", vibes: "荒れ果てた廃墟みたいな場所")
                    ]
                ),
                TextSegment(
                    originalText: "広い門の下には、この男のほかに誰もいない。",
                    easyText: "広い門の下には、この男以外、誰もいない。",
                    emoText: "誰もいない。\nこの広い場所に、\n自分だけ。",
                    vibesSummary: "完全に孤立してる感",
                    emotionScores: [.孤独: 80, .不安: 50]
                ),
                TextSegment(
                    originalText: "下人は、大きなくさめをして、それから、大儀そうに立上がった。",
                    easyText: "男は大きなくしゃみをして、それから、めんどくさそうに立ち上がった。",
                    emoText: "くしゃみひとつ。\n重い体を起こす。\nすべてがだるい。",
                    vibesSummary: "だるい。人生だるい。",
                    emotionScores: [.諦念: 60, .不安: 40],
                    glossaryEntries: [
                        GlossaryEntry(word: "くさめ", reading: "くさめ", meaning: "くしゃみ", vibes: "くしゃみのこと。古語。"),
                        GlossaryEntry(word: "大儀そうに", reading: "たいぎそうに", meaning: "面倒くさそうに", vibes: "「あー、だりぃ」って感じ")
                    ]
                ),
                TextSegment(
                    originalText: "この男には、明日の暮しさえどうなるかわからない。何のあてもない。",
                    easyText: "この男には、明日どうやって生きるかすらわからない。なんの当てもない。",
                    emoText: "明日が見えない。\n何ひとつ、\nあてがない。",
                    vibesSummary: "将来の見通しゼロ。ガチの詰み。",
                    emotionScores: [.不安: 90, .絶望: 70, .孤独: 60]
                ),
                TextSegment(
                    originalText: "盗人になるよりほかに仕方がない。——と云う事を、彼は何度も繰返した。",
                    easyText: "泥棒になるしかない。——ということを、彼は何度も繰り返していた。",
                    emoText: "もう、盗むしかない。\nそう自分に言い聞かせて、\nでも、まだ動けない。",
                    vibesSummary: "犯罪に手を染めるしかないところまで追い詰められてる",
                    emotionScores: [.罪悪感: 60, .不安: 85, .生きづらさ: 80],
                    glossaryEntries: [
                        GlossaryEntry(word: "盗人", reading: "ぬすびと", meaning: "泥棒", vibes: "犯罪者になるしかないと自分に言い聞かせてる")
                    ],
                    pollIndex: 0
                ),
                TextSegment(
                    originalText: "しかし、その「すれば」を、いくら繰返しても、結局「すれば」は、いつまでたっても、「すれば」であった。",
                    easyText: "でも、「やるしかない」と何度言い聞かせても、結局「やるしかない」のまま、ずっと動けなかった。",
                    emoText: "「やるしかない」って、\n何回言っても、\n結局やれないまま。",
                    vibesSummary: "やるしかないって言いつつ、一歩が踏み出せない",
                    emotionScores: [.不安: 80, .罪悪感: 70]
                ),
                TextSegment(
                    originalText: "下人の悪を憎む心は、老婆の床に挿した松の木片のように、勢いよく燃え上がり出していた。",
                    easyText: "男の「悪いことは許さない」って気持ちが、松明みたいに勢いよく燃え始めていた。",
                    emoText: "許せない、という感情が\n一気に燃え上がる。\n正義が暴走する。",
                    vibesSummary: "正義感に火がついた瞬間",
                    emotionScores: [.怒り: 85, .希望: 30]
                ),
                TextSegment(
                    originalText: "「では、己が引剥をしようと恨むまいな。己もそうしなければ、饑死をする体なのだ。」",
                    easyText: "「じゃあ、俺がお前の服を奪っても恨むなよ。俺だってそうしないと、餓死するんだから。」",
                    emoText: "お前がやるなら、\n俺もやっていいだろ。\n生きるためなら、仕方ない。",
                    vibesSummary: "「お前がやるなら俺もやっていいよな」という論理の転換",
                    emotionScores: [.罪悪感: 40, .怒り: 60, .生きづらさ: 90],
                    glossaryEntries: [
                        GlossaryEntry(word: "引剥", reading: "ひはぎ", meaning: "他人の着物をはぎ取る強盗", vibes: "服を奪い取る追い剥ぎのこと"),
                        GlossaryEntry(word: "饑死", reading: "うえじに", meaning: "飢え死に", vibes: "マジで餓死するレベルの貧困")
                    ]
                ),
                TextSegment(
                    originalText: "下人は、既に、雨を冒して、京都の町へ強盗を働きに急いでいた。下人の行方は、誰も知らない。",
                    easyText: "男はもう、雨の中を走って、京都の街へ強盗をしに向かっていた。男がその後どうなったかは、誰も知らない。",
                    emoText: "男は走り出した。\n雨の中へ。\nその先に何があるか、\n誰も知らない。",
                    vibesSummary: "善悪の境界線を超えた男の、行き先不明なラスト",
                    emotionScores: [.絶望: 70, .罪悪感: 50, .不安: 60]
                ),
            ],
            polls: [
                Poll(
                    question: "追い詰められたら、下人と同じことをする？",
                    options: [
                        PollOption(text: "するかもしれない", percentage: 45),
                        PollOption(text: "したくないけどわからない", percentage: 33),
                        PollOption(text: "絶対しない", percentage: 15),
                        PollOption(text: "考えたくない", percentage: 7),
                    ]
                ),
            ]
        ),

        Work(
            id: "hashire-melos",
            title: "走れメロス",
            authorId: "dazai",
            authorName: "太宰治",
            tags: [.希望, .青春, .怒り],
            readTime: "7分",
            isPremium: false,
            coverEmoji: "🏃",
            description: "信じること・信じられることの重さを描く、全力疾走の友情物語。",
            afterword: Work.Afterword(
                theme: "人を信じることの美しさと苦しさ",
                point: "約束を守るために走り続ける姿が、意外と今のメンタルに刺さる",
                modern: "「既読スルーされると不安になる」時代に、信頼って何？を考えさせる。"
            ),
            segments: [
                TextSegment(
                    originalText: "メロスは激怒した。必ず、かの邪智暴虐の王を除かなければならぬと決意した。",
                    easyText: "メロスはブチギレた。あのずる賢くて暴力的な王を絶対に倒すと決めた。",
                    emoText: "ブチギレた。\nこんな理不尽、\n絶対に許さない。",
                    vibesSummary: "開幕ブチギレ。正義感の塊。",
                    emotionScores: [.怒り: 95, .希望: 40],
                    glossaryEntries: [
                        GlossaryEntry(word: "邪智暴虐", reading: "じゃちぼうぎゃく", meaning: "ずる賢くて暴力的", vibes: "パワハラ上司の究極形態")
                    ]
                ),
                TextSegment(
                    originalText: "メロスには政治がわからぬ。メロスは、村の牧人である。笛を吹き、羊と遊んで暮して来た。",
                    easyText: "メロスは政治なんてわからない。メロスはただの羊飼い。笛を吹いて、羊と遊んで暮らしてきた。",
                    emoText: "難しいことはわからない。\nただの田舎の羊飼い。\nでも、理不尽はわかる。",
                    vibesSummary: "政治わからんけど、理不尽は許さないマン",
                    emotionScores: [.青春: 70, .希望: 50],
                    glossaryEntries: [
                        GlossaryEntry(word: "牧人", reading: "ぼくじん", meaning: "羊飼い", vibes: "のんびり田舎で暮らしてたピュアな青年")
                    ]
                ),
                TextSegment(
                    originalText: "「人の心を疑うのは、最も恥ずべき悪徳だ。」",
                    easyText: "「人を信じないのは、一番ダサいことだ。」",
                    emoText: "人を疑うくらいなら、\n騙されたほうがマシ。",
                    vibesSummary: "信じることを諦めない、まっすぐすぎる信念",
                    emotionScores: [.希望: 90, .青春: 80]
                ),
                TextSegment(
                    originalText: "メロスは、友に誓った。三日のうちに、必ず帰る。",
                    easyText: "メロスは、友に誓った。3日以内に、絶対に戻る。",
                    emoText: "約束した。\n命をかけて、\n絶対に戻る。",
                    vibesSummary: "命をかけた約束。友情が重すぎる。",
                    emotionScores: [.希望: 80, .不安: 50],
                    pollIndex: 0
                ),
                TextSegment(
                    originalText: "走れ！メロス。もっと速く、もっと速く。遅れてはならぬ。",
                    easyText: "走れ！メロス。もっと速く、もっと速く。間に合わないとダメだ。",
                    emoText: "走れ。\nもっと速く。\n間に合わなかったら、\n全部終わる。",
                    vibesSummary: "全力疾走。限界超えてる。",
                    emotionScores: [.希望: 70, .不安: 80, .青春: 90]
                ),
                TextSegment(
                    originalText: "私は、信頼に報いなければならぬ。いまはただその一事だ。走れ！メロス。",
                    easyText: "俺は、信頼に応えなきゃいけない。今はそれだけだ。走れ！メロス。",
                    emoText: "信じてくれた人がいる。\nそれだけで、\nまだ走れる。",
                    vibesSummary: "約束を守るためだけに走る。シンプルだけど最強。",
                    emotionScores: [.希望: 95, .青春: 85]
                ),
                TextSegment(
                    originalText: "メロスは走った。メロスは友を救うために走った。",
                    easyText: "メロスは走った。友を助けるために、ただ走った。",
                    emoText: "理屈じゃない。\n友のために、\nただ走った。",
                    vibesSummary: "理屈じゃない、全身全霊の友情",
                    emotionScores: [.希望: 90, .青春: 95]
                ),
            ],
            polls: [
                Poll(
                    question: "友のために命をかけられる？",
                    options: [
                        PollOption(text: "かけられると思う", percentage: 28),
                        PollOption(text: "わからない", percentage: 42),
                        PollOption(text: "正直むずかしい", percentage: 22),
                        PollOption(text: "かけられない", percentage: 8),
                    ]
                ),
            ]
        ),

        Work(
            id: "kumo-no-ito",
            title: "蜘蛛の糸",
            authorId: "akutagawa",
            authorName: "芥川龍之介",
            tags: [.罪悪感, .希望, .絶望],
            readTime: "4分",
            isPremium: true,
            coverEmoji: "🕸️",
            description: "地獄からの一本の蜘蛛の糸。チャンスを掴めるか、自分勝手に落ちるか。",
            afterword: Work.Afterword(
                theme: "エゴイズムと救済の矛盾",
                point: "自分だけ助かりたいと思った瞬間に、救いの糸が切れる",
                modern: "「自分だけ得したい」が当たり前の競争社会で、利他の心はどこまで持てるか。"
            ),
            segments: [
                TextSegment(
                    originalText: "ある日の事でございます。御釈迦様は極楽の蓮池のふちを、独りでぶらぶら御歩きになっていらっしゃいました。",
                    easyText: "ある日のこと。お釈迦様が、極楽の蓮の池のそばを、一人でのんびり散歩していました。",
                    emoText: "ある日、\nお釈迦様が\n極楽の蓮の池のほとりを\nゆっくり歩いていた。",
                    vibesSummary: "お釈迦様の散歩シーン。穏やかスタート。",
                    emotionScores: [.希望: 50],
                    glossaryEntries: [
                        GlossaryEntry(word: "御釈迦様", reading: "おしゃかさま", meaning: "仏教の開祖ブッダ", vibes: "仏教界のトップ。最強の慈悲の持ち主。")
                    ]
                ),
                TextSegment(
                    originalText: "ふと御釈迦様は、蓮池の水の中を御覧になりました。この蓮池の下は、丁度地獄の底に当たって居ります。",
                    easyText: "ふとお釈迦様が、蓮池の水の中を覗いてみました。この蓮池の真下は、ちょうど地獄の底につながっています。",
                    emoText: "ふと、\n池を覗いたら、\nその下は──地獄だった。",
                    vibesSummary: "極楽から地獄を覗くという衝撃の構図",
                    emotionScores: [.不安: 40, .希望: 30]
                ),
                TextSegment(
                    originalText: "その地獄の底に、犍陀多という男が、ほかの罪人と一しょに蠢いている姿が、御眼に止まりました。",
                    easyText: "その地獄の底に、カンダタという男が、ほかの罪人たちとうごめいているのが、目に止まりました。",
                    emoText: "地獄の底で、\nひとりの男が\nもがいていた。",
                    vibesSummary: "地獄でもがいてる元犯罪者にフォーカス",
                    emotionScores: [.絶望: 70, .罪悪感: 60],
                    glossaryEntries: [
                        GlossaryEntry(word: "犍陀多", reading: "カンダタ", meaning: "この物語の主人公。大泥棒。", vibes: "地獄に落ちた悪人だけど、一回だけ蜘蛛を助けたことがある"),
                        GlossaryEntry(word: "蠢いている", reading: "うごめいている", meaning: "虫のようにうごめくこと", vibes: "地獄でゾワゾワ這いずり回ってる")
                    ]
                ),
                TextSegment(
                    originalText: "「これは己のものだ。己のものだ。下りろ。下りろ。」と喚きました。",
                    easyText: "「これは俺のだ。俺のだ。降りろ。降りろ！」と叫びました。",
                    emoText: "「俺のだ！」\n「降りろ！」\nエゴが爆発した。",
                    vibesSummary: "「俺だけ助かりたい」エゴ全開の瞬間",
                    emotionScores: [.罪悪感: 30, .怒り: 70, .自己嫌悪: 50],
                    glossaryEntries: [
                        GlossaryEntry(word: "喚く", reading: "わめく", meaning: "大声で叫ぶ", vibes: "パニックで叫びまくってる")
                    ],
                    pollIndex: 0
                ),
                TextSegment(
                    originalText: "すると、その途端でございます。蜘蛛の糸が、犍陀多のぶら下がっている所から、ぷつりと音を立てて断れました。",
                    easyText: "すると、その瞬間。蜘蛛の糸が、カンダタがぶら下がっているところから、プツッと切れました。",
                    emoText: "その瞬間、\n糸が切れた。\n救いが消えた。",
                    vibesSummary: "エゴの瞬間に救いが消える。因果応報。",
                    emotionScores: [.絶望: 95, .罪悪感: 80]
                ),
                TextSegment(
                    originalText: "後にはただ極楽の蜘蛛の糸が、きらきらと細く光りながら、月も星もない空の中途に、短く垂れているばかりでございます。",
                    easyText: "あとにはただ、極楽の蜘蛛の糸が、キラキラと細く光りながら、月も星もない真っ暗な空に、短く垂れているだけでした。",
                    emoText: "あとには、\nキラキラ光る糸だけが\n暗い空に垂れていた。\n美しくて、残酷。",
                    vibesSummary: "静かに糸だけが残る。美しくて残酷なラスト。",
                    emotionScores: [.絶望: 80, .孤独: 70]
                ),
            ],
            polls: [
                Poll(
                    question: "カンダタの気持ち、わかる？",
                    options: [
                        PollOption(text: "正直わかる", percentage: 38),
                        PollOption(text: "少しわかる", percentage: 35),
                        PollOption(text: "わかりたくない", percentage: 18),
                        PollOption(text: "わからない", percentage: 9),
                    ]
                ),
            ]
        ),

        Work(
            id: "kokoro",
            title: "こころ",
            authorId: "natsume",
            authorName: "夏目漱石",
            tags: [.孤独, .罪悪感, .生きづらさ],
            readTime: "10分",
            isPremium: true,
            coverEmoji: "💔",
            description: "信頼と裏切り、罪悪感と孤独。明治の知識人が抱えた「こころ」の闇。",
            afterword: Work.Afterword(
                theme: "人を信じることと、裏切ってしまうことの苦しみ",
                point: "秘密を抱え続けることの重さ。誰にも言えない罪悪感。",
                modern: "SNSでは見せない裏の自分。「本当のことを言えない」関係性の脆さ。"
            ),
            segments: [
                TextSegment(
                    originalText: "私はその人を常に先生と呼んでいた。だからここでもただ先生と書くだけで本名は打ち明けない。",
                    easyText: "私はその人をいつも「先生」と呼んでいた。だからここでも「先生」とだけ書いて、本名は伏せておく。",
                    emoText: "あの人のことを、\nずっと「先生」と呼んでいた。\n本当の名前は、まだ言えない。",
                    vibesSummary: "謎の人物「先生」。名前を隠すところからもう重い。",
                    emotionScores: [.孤独: 50, .不安: 30]
                ),
                TextSegment(
                    originalText: "これは私だけの秘密です。私はこの秘密を持って、やがてこの世から消えてしまう積りです。",
                    easyText: "これは自分だけの秘密です。この秘密を抱えたまま、いずれこの世からいなくなるつもりです。",
                    emoText: "この秘密は、\n誰にも言えない。\nこのまま抱えて、\n消えるつもりだ。",
                    vibesSummary: "墓場まで持っていく系の秘密",
                    emotionScores: [.罪悪感: 90, .孤独: 85, .絶望: 60],
                    pollIndex: 0
                ),
                TextSegment(
                    originalText: "人間はね、自分が困らない程度内で、なるべく人に親切がして見たいものだ。",
                    easyText: "人間ってね、自分が困らない範囲で、できるだけ人にやさしくしたいと思うもんなんだよ。",
                    emoText: "やさしさには限界がある。\n自分が壊れない程度の、\nやさしさしかあげられない。",
                    vibesSummary: "やさしさには限界があるという現実",
                    emotionScores: [.孤独: 60, .諦念: 70]
                ),
                TextSegment(
                    originalText: "精神的に向上心のないものは馬鹿だ。",
                    easyText: "成長しようとしない人間はバカだ。",
                    emoText: "成長を止めた瞬間、\n人は終わる。\nそう言い聞かせている。",
                    vibesSummary: "現状維持で満足するなという圧",
                    emotionScores: [.怒り: 50, .希望: 40]
                ),
                TextSegment(
                    originalText: "恋は罪悪ですよ。——そうして神聖なものですよ。",
                    easyText: "恋は罪ですよ。——そして、聖なるものですよ。",
                    emoText: "恋は罪で、\n同時に、聖なるもの。\nこの矛盾が恋の正体。",
                    vibesSummary: "恋は罪で、同時に聖なるもの。矛盾だけど真実。",
                    emotionScores: [.恋愛: 80, .罪悪感: 70]
                ),
                TextSegment(
                    originalText: "もう取り返しがつかないという黒い光が、私の未来を貫いて、一瞬間に私の前に横たわる全生涯を物凄く照らしました。",
                    easyText: "もう取り返しがつかないっていう、黒い光が、自分の未来を貫いて、一瞬で人生全部が絶望的に見えました。",
                    emoText: "取り返しがつかない。\nその事実が、\n一瞬で人生全部を\n暗く塗りつぶした。",
                    vibesSummary: "人生が終わったと悟る瞬間の絶望",
                    emotionScores: [.絶望: 95, .罪悪感: 90, .孤独: 80],
                    glossaryEntries: [
                        GlossaryEntry(word: "一瞬間", reading: "いっしゅんかん", meaning: "ほんの一瞬", vibes: "全部が壊れるのは一瞬で十分")
                    ]
                ),
            ],
            polls: [
                Poll(
                    question: "誰にも言えない秘密、ある？",
                    options: [
                        PollOption(text: "ある", percentage: 58),
                        PollOption(text: "少しある", percentage: 27),
                        PollOption(text: "ない", percentage: 10),
                        PollOption(text: "答えたくない", percentage: 5),
                    ]
                ),
            ]
        ),

        Work(
            id: "gingatetsudo",
            title: "銀河鉄道の夜",
            authorId: "miyazawa",
            authorName: "宮沢賢治",
            tags: [.孤独, .希望, .青春],
            readTime: "9分",
            isPremium: true,
            coverEmoji: "🌠",
            description: "孤独な少年が銀河を旅する、美しくて切ないファンタジー。",
            afterword: Work.Afterword(
                theme: "本当の幸せとは何か",
                point: "大切な人がいなくなっても、その記憶は銀河のように輝き続ける",
                modern: "推しのロスや友人との別れを経験した人に刺さる。「いなくなっても、その存在は消えない」。"
            ),
            segments: [
                TextSegment(
                    originalText: "「ではみなさんは、そういうふうに川だと云われたり、乳の流れたあとだと云われたりしていたこのぼんやりと白いものがほんとうは何かご承知ですか。」",
                    easyText: "「じゃあみなさん、『川だ』とか『ミルクがこぼれた跡だ』とか言われてきた、あのぼんやり白いもの、本当は何か知ってますか？」",
                    emoText: "夜空のあの白いもの、\nみんな知ったかぶりしてるけど、\n本当は何なのか知ってる？",
                    vibesSummary: "天の川って何？から始まる宇宙の授業",
                    emotionScores: [.希望: 40, .青春: 50],
                    glossaryEntries: [
                        GlossaryEntry(word: "乳の流れたあと", reading: "ちちのながれたあと", meaning: "天の川の別名（ミルキーウェイの語源）", vibes: "天の川＝ミルクがこぼれた跡、っていう昔の言い方")
                    ]
                ),
                TextSegment(
                    originalText: "カムパネルラが手をあげました。それから四五人手をあげました。ジョバンニも手をあげようとして、急いでそのままやめました。",
                    easyText: "カムパネルラが手を挙げた。それから4〜5人が手を挙げた。ジョバンニも手を挙げようとして、すぐにやめた。",
                    emoText: "手を挙げたかった。\nでも、挙げられなかった。\n教室で、自分だけ透明になる感覚。",
                    vibesSummary: "手を挙げられない。自信がない。教室での孤独。",
                    emotionScores: [.孤独: 80, .不安: 60, .青春: 40]
                ),
                TextSegment(
                    originalText: "ジョバンニは、もう何も云えずに、そのまま泣き出してしまいました。",
                    easyText: "ジョバンニは、もう何も言えなくて、そのまま泣き出してしまった。",
                    emoText: "言葉にならない。\nただ、涙だけが\n溢れた。",
                    vibesSummary: "言葉にできない悲しみが溢れた瞬間",
                    emotionScores: [.孤独: 90, .絶望: 50]
                ),
                TextSegment(
                    originalText: "「カムパネルラ、また僕たち二人きりになったねえ。」",
                    easyText: "「カムパネルラ、また僕たち二人きりだね。」",
                    emoText: "また二人きりだ。\nこの瞬間が、いちばん安心する。",
                    vibesSummary: "親友と二人だけの銀河の旅。尊い。",
                    emotionScores: [.希望: 70, .青春: 85, .孤独: 30],
                    pollIndex: 0
                ),
                TextSegment(
                    originalText: "「カムパネルラ、僕たちどこまでもどこまでも一緒に行こう。」",
                    easyText: "「カムパネルラ、僕たちずっとずっと一緒にいよう。」",
                    emoText: "ずっと一緒にいたい。\nどこまでも、\nいつまでも。",
                    vibesSummary: "永遠に一緒にいたい、という切なる願い",
                    emotionScores: [.希望: 80, .青春: 90, .孤独: 40]
                ),
                TextSegment(
                    originalText: "ジョバンニはカムパネルラがどこかへ行ってしまったのではないかと思いました。",
                    easyText: "ジョバンニは、カムパネルラがどこかへ行ってしまったんじゃないかと思った。",
                    emoText: "いなくなった？\nさっきまで隣にいたのに。\n胸が、ぎゅっとなる。",
                    vibesSummary: "大切な人がいなくなる予感。胸が痛い。",
                    emotionScores: [.孤独: 95, .絶望: 70, .不安: 80]
                ),
                TextSegment(
                    originalText: "「ほんとうのさいわいは一体何だろう。」",
                    easyText: "「本当の幸せって、いったい何なんだろう。」",
                    emoText: "本当の幸せって、\nなんだろう。\nまだ、答えは出ない。",
                    vibesSummary: "この物語の核心。答えは出ない。でも問い続ける。",
                    emotionScores: [.希望: 60, .孤独: 50, .青春: 40]
                ),
            ],
            polls: [
                Poll(
                    question: "大切な人がいなくなった経験、ある？",
                    options: [
                        PollOption(text: "ある、今も思い出す", percentage: 45),
                        PollOption(text: "ある、でも乗り越えた", percentage: 30),
                        PollOption(text: "まだない", percentage: 18),
                        PollOption(text: "考えたくない", percentage: 7),
                    ]
                ),
            ]
        ),
    ]

    static func find(by id: String) -> Work? {
        all.first { $0.id == id }
    }

    static func works(for authorId: String) -> [Work] {
        all.filter { $0.authorId == authorId }
    }

    static func works(withTag tag: EmotionTag) -> [Work] {
        all.filter { $0.tags.contains(tag) }
    }
}
