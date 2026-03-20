import '../models/reader/reader_demo_models.dart';

/// 本地阅读器示例数据仓库。
class ReaderDemoRepository {
  const ReaderDemoRepository();

  List<ReaderWork> getWorks() {
    return const [
      ReaderWork(
        id: 'mist-port',
        title: '雾港回声',
        author: '林见深',
        genre: '赛博悬疑',
        tagline: '凌晨四点的港口，会把秘密冲上岸。',
        summary: '以漫画分镜和小说双形态交错展开的港口悬疑故事，适合演示图文混排和章节切换。',
        accentColor: 0xFF214E80,
        preferComic: true,
        tags: ['漫画主叙事', '夜色港口', '悬疑追踪'],
        chapters: [
          ReaderChapter(
            id: 'mist-port-1',
            title: '第 01 话',
            subtitle: '凌晨的第七码头',
            bonusParagraph: '番外里，旧货摊老板承认自己见过那个红伞女孩。她没有买任何东西，只是把一枚发热的铜币压在木桌上，说“今天会有一艘不该靠岸的船”。',
            comicPanels: [
              ComicPanel(
                title: '浓雾压城',
                caption: '海风把旧集装箱上的编号吹得吱呀作响。',
                dialogue: '“如果你今天还要查那艘船，最好在天亮前离开。”',
                height: 220,
                tintColor: 0xFF19334F,
              ),
              ComicPanel(
                title: '冷色霓虹',
                caption: '蓝紫霓虹在潮湿地面拉出扭曲倒影。',
                dialogue: '“这不是普通走私案，监控里的那个人没有影子。”',
                height: 260,
                tintColor: 0xFF385C8A,
              ),
              ComicPanel(
                title: '货舱开启',
                caption: '编号 7 的货舱门缝里传出老式留声机的声音。',
                dialogue: '“别开门，里面装着的不是货。”',
                height: 240,
                tintColor: 0xFF6D85A8,
              ),
            ],
            novelParagraphs: [
              '凌晨四点十三分，海面像一块没有温度的钢板。许昼踩过被雨水浸透的木栈桥，听见远处集装箱的金属回响像低声耳语，一阵一阵，从雾里传过来。',
              '雾港的夜里很少有人说真话。巡逻艇没有亮灯，码头工头也提前收了队，只有第七码头的红色警示灯还在一下一下地闪，像在为一场不该开始的故事打板。',
              '许昼停在货舱前，伸手碰了碰门把，冰冷得像刚从海底捞起的铁器。门后的音乐突然清晰起来，是一段过时的华尔兹，拍子准得近乎诡异。',
            ],
          ),
          ReaderChapter(
            id: 'mist-port-2',
            title: '第 02 话',
            subtitle: '船票背面的火焰',
            bonusParagraph: '那张被火焰烧掉半边的船票，背面其实写着另一个坐标。许昼后来才明白，那不是目的地，而是“回来的入口”。',
            comicPanels: [
              ComicPanel(
                title: '破旧船票',
                caption: '纸边烧焦，却残留一缕温度。',
                dialogue: '“船票只写了出发时间，没有目的地。”',
                height: 210,
                tintColor: 0xFF5F4429,
              ),
              ComicPanel(
                title: '站台长椅',
                caption: '无人候船厅里，广播在重复播放不存在的班次。',
                dialogue: '“下一班船，开往没有地图的地方。”',
                height: 250,
                tintColor: 0xFF7F5C3C,
              ),
              ComicPanel(
                title: '火焰图案',
                caption: '火焰像一只睁开的眼睛，映在许昼的指尖。',
                dialogue: '“有人想让你看到这张船票。”',
                height: 235,
                tintColor: 0xFFBF7B42,
              ),
            ],
            novelParagraphs: [
              '票根背面的火焰纹样并非装饰，而像一枚缓慢呼吸的印记。许昼把它举到头顶的灯下，纸纤维间浮出一串本来不存在的数字。',
              '广播声忽然卡顿了一秒，像有人用手指掐住了时间。空荡的候船厅里，座椅一排排延伸出去，仿佛一节被切开的车厢，每一把椅子上都坐着沉默的影子。',
              '他终于读出那串数字，那不是航次编号，而是一段坐标。有人在邀请他上船，或者说，邀请他回去。问题是，他从未到过那里。',
            ],
          ),
        ],
      ),
      ReaderWork(
        id: 'star-hotel',
        title: '星轨旅店',
        author: '闻雪',
        genre: '都市奇旅',
        tagline: '每个失眠的人，都在午夜十一楼拥有一张房卡。',
        summary: '更偏小说阅读体验，适合演示长段文本、章节续读和番外解锁激励广告。',
        accentColor: 0xFF6A3FCB,
        preferComic: false,
        tags: ['小说主叙事', '城市奇遇', '治愈'],
        chapters: [
          ReaderChapter(
            id: 'star-hotel-1',
            title: '第 01 章',
            subtitle: '十一楼没有尽头',
            bonusParagraph: '番外里，前台小姐递给陆灯一杯热可可，说十一楼其实只有在“还想回头”的人眼里才会无限延伸。',
            comicPanels: [
              ComicPanel(
                title: '旅店门牌',
                caption: '金色门牌在夜雨里泛着微光。',
                dialogue: '“欢迎回来，尽管您是第一次入住。”',
                height: 220,
                tintColor: 0xFF4B2F8F,
              ),
              ComicPanel(
                title: '长廊尽头',
                caption: '长廊铺着厚厚地毯，脚步声被全部吞没。',
                dialogue: '“十一楼没有尽头，但每一扇门后都有人在等你。”',
                height: 250,
                tintColor: 0xFF8F6ADE,
              ),
            ],
            novelParagraphs: [
              '陆灯第一次推开星轨旅店的旋转门时，外面正下着一场细密的夜雨。玻璃门把世界切成两半，一半是被出租车尾灯染红的街道，一半是温暖得像梦境的大厅。',
              '前台小姐抬头看见她，像是已经等了很久。没有登记，没有问询，只是把一张写着“1107”的房卡轻轻推到桌边，微笑着说，欢迎回来。',
              '电梯在十一楼停下时并没有发出提示音。门打开后，是一条看不到尽头的长廊，墙上的铜灯柔和得像从旧电影里剪下来的月光。',
            ],
          ),
          ReaderChapter(
            id: 'star-hotel-2',
            title: '第 02 章',
            subtitle: '会发光的留言簿',
            bonusParagraph: '番外里，留言簿最后一页其实是空白的，只有在房客真正决定离开时，纸面上才会浮出那一句“谢谢你来过”。',
            comicPanels: [
              ComicPanel(
                title: '旧式柜台',
                caption: '柜台上的铜铃没有人碰，却自己轻轻响了一下。',
                dialogue: '“今夜入住的人，都有一句想写却没写出的告别。”',
                height: 220,
                tintColor: 0xFFC6873A,
              ),
              ComicPanel(
                title: '留言簿发光',
                caption: '纸页在指尖翻动，像微小的星轨。',
                dialogue: '“你写下的不是文字，是你还没放下的那部分心。”',
                height: 240,
                tintColor: 0xFFE1B866,
              ),
            ],
            novelParagraphs: [
              '十一楼的尽头有一间总亮着暖光的阅览室。房门虚掩着，里面没有人，只有一张长桌和一本厚得离谱的留言簿，纸页边缘发着很淡的光。',
              '陆灯翻开第一页，看见不同年份、不同笔迹写下的句子。有人写“我终于不再等他回头”，有人写“原来离开不是背叛，只是继续生活”。',
              '她迟迟没有落笔。那些字句像被风吹动的水面，轻轻晃进她眼里。某一瞬间她意识到，这本留言簿并不收集文字，它记录的是人决定往前走时那一下轻微却真实的心跳。',
            ],
          ),
        ],
      ),
      ReaderWork(
        id: 'paper-bird',
        title: '纸鸟事务所',
        author: '沈砚',
        genre: '轻奇幻',
        tagline: '委托人的烦恼，会先长出羽毛。',
        summary: '偏轻快风格的本地作品，用来补足第三种封面和书架展示效果。',
        accentColor: 0xFF1D7A66,
        preferComic: true,
        tags: ['都市轻奇幻', '事务所', '群像'],
        chapters: [
          ReaderChapter(
            id: 'paper-bird-1',
            title: '第 01 话',
            subtitle: '会说话的纸鹤',
            bonusParagraph: '番外里，那只纸鹤其实早就知道答案，它只是想等委托人先学会好好开口。',
            comicPanels: [
              ComicPanel(
                title: '纸鹤起飞',
                caption: '委托单还没盖章，折角处已经拍了拍翅膀。',
                dialogue: '“请问，这份烦恼是加急件吗？”',
                height: 230,
                tintColor: 0xFF1A6A58,
              ),
              ComicPanel(
                title: '事务所书墙',
                caption: '高高的书墙后面，藏着一条会转弯的风。',
                dialogue: '“在这里，心事会先变成一只鸟。”',
                height: 250,
                tintColor: 0xFF49A48F,
              ),
            ],
            novelParagraphs: [
              '纸鸟事务所开在老城区的二楼，楼梯窄得一次只能容下一个人上行。门口没有招牌，只有一只小小的纸鹤吊在窗边，风一吹就点头像在回应每个路人的犹豫。',
              '第一次来的人总会怀疑这里到底做不做正经生意。直到他们把烦恼写进委托单，看着那张纸自己折起翅膀，摇摇晃晃地飞向屋里最亮的那盏灯。',
            ],
          ),
        ],
      ),
    ];
  }
}
