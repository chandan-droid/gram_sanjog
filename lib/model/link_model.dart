class LinkModel {
  final String title;
  final String url;

  LinkModel({required this.title, required this.url});

  factory LinkModel.fromMap(Map<String, dynamic> data) {
    return LinkModel(
      title: data['title'] ?? '',
      url: data['url'] ?? '',
    );
  }
}
