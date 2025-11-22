/// Modèle représentant un favori
class Favorite {
  final String url;
  final String title;
  final DateTime addedAt;

  Favorite({
    required this.url,
    required this.title,
    required this.addedAt,
  });

  /// Convertit un favori en Map pour le stockage
  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'title': title,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  /// Crée un favori depuis un Map
  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      url: json['url'] as String,
      title: json['title'] as String,
      addedAt: DateTime.parse(json['addedAt'] as String),
    );
  }
}
