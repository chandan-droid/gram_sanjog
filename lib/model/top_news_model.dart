import 'news_model.dart';

class TopNewsItem {
  final String newsId;
  final String title;
  final String imageUrl;

TopNewsItem({
  required this. newsId,
  required this.title,
  required this.imageUrl,
});

factory TopNewsItem.fromNews(News news) {
  return TopNewsItem(
    newsId: news.newsId,
    title: news.title,
    imageUrl: news.imageUrls.isNotEmpty ? news.imageUrls.first : '',
  );
}

}