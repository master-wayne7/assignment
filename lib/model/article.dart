class Article {
  final String title;
  final String description;
  final String imageUrl;
  final String sourceName;
  final String publishedAt;
  final String url;
  bool isFavorite;

  Article({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.publishedAt,
    required this.sourceName,
    required this.url,
    this.isFavorite = false,
  });
}
