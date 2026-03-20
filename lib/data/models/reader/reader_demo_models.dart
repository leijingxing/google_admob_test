/// 本地阅读器作品模型。
class ReaderWork {
  const ReaderWork({
    required this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.tagline,
    required this.summary,
    required this.accentColor,
    required this.preferComic,
    required this.chapters,
    this.tags = const <String>[],
  });

  final String id;
  final String title;
  final String author;
  final String genre;
  final String tagline;
  final String summary;
  final int accentColor;
  final bool preferComic;
  final List<String> tags;
  final List<ReaderChapter> chapters;
}

/// 阅读章节模型。
class ReaderChapter {
  const ReaderChapter({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.comicPanels,
    required this.novelParagraphs,
    required this.bonusParagraph,
  });

  final String id;
  final String title;
  final String subtitle;
  final List<ComicPanel> comicPanels;
  final List<String> novelParagraphs;
  final String bonusParagraph;
}

/// 漫画分镜模型。
class ComicPanel {
  const ComicPanel({
    required this.title,
    required this.caption,
    required this.dialogue,
    required this.height,
    required this.tintColor,
  });

  final String title;
  final String caption;
  final String dialogue;
  final double height;
  final int tintColor;
}
