import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Service de gestion du mode hors ligne
class OfflineService {
  static const String _offlineArticlesKey = 'offline_articles';

  /// Sauvegarde un article pour lecture hors ligne
  Future<bool> saveArticleOffline(String url, String title) async {
    try {
      // Télécharge le contenu de la page
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      
      if (response.statusCode != 200) return false;

      // Extrait uniquement le contenu de l'article (pas le header/footer)
      String cleanContent = _extractArticleContent(response.body);

      // Sauvegarde le contenu dans un fichier
      final directory = await getApplicationDocumentsDirectory();
      final fileName = _sanitizeFileName(url);
      final file = File('${directory.path}/offline_$fileName.html');
      await file.writeAsString(cleanContent);

      // Sauvegarde les métadonnées
      final prefs = await SharedPreferences.getInstance();
      final articles = await getOfflineArticles();
      
      articles.add({
        'url': url,
        'title': title,
        'fileName': fileName,
        'savedAt': DateTime.now().toIso8601String(),
      });

      await prefs.setString(_offlineArticlesKey, jsonEncode(articles));
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Extrait uniquement le contenu de l'article
  String _extractArticleContent(String html) {
    // Cherche le contenu principal de l'article
    // Essaie différents sélecteurs communs pour WordPress
    final patterns = [
      RegExp(r'<article[^>]*>(.*?)</article>', dotAll: true),
      RegExp(r'<div[^>]*class="[^"]*entry-content[^"]*"[^>]*>(.*?)</div>', dotAll: true),
      RegExp(r'<div[^>]*class="[^"]*post-content[^"]*"[^>]*>(.*?)</div>', dotAll: true),
      RegExp(r'<main[^>]*>(.*?)</main>', dotAll: true),
    ];

    for (var pattern in patterns) {
      final match = pattern.firstMatch(html);
      if (match != null && match.group(1) != null) {
        return match.group(1)!;
      }
    }

    // Si aucun pattern ne correspond, retourne le HTML complet
    // (mieux que rien)
    return html;
  }

  /// Récupère la liste des articles hors ligne
  Future<List<Map<String, dynamic>>> getOfflineArticles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final articlesJson = prefs.getString(_offlineArticlesKey);
      
      if (articlesJson == null) return [];

      final List<dynamic> decoded = jsonDecode(articlesJson);
      return decoded.map((item) => Map<String, dynamic>.from(item)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Supprime un article hors ligne
  Future<bool> deleteOfflineArticle(String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/offline_$fileName.html');
      
      if (await file.exists()) {
        await file.delete();
      }

      // Met à jour les métadonnées
      final prefs = await SharedPreferences.getInstance();
      final articles = await getOfflineArticles();
      articles.removeWhere((article) => article['fileName'] == fileName);
      await prefs.setString(_offlineArticlesKey, jsonEncode(articles));

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Récupère le contenu d'un article hors ligne
  Future<String?> getOfflineArticleContent(String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/offline_$fileName.html');
      
      if (await file.exists()) {
        return await file.readAsString();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Vérifie si un article est sauvegardé hors ligne
  Future<bool> isArticleSaved(String url) async {
    final articles = await getOfflineArticles();
    return articles.any((article) => article['url'] == url);
  }

  /// Nettoie le nom de fichier
  String _sanitizeFileName(String url) {
    return url
        .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')
        .substring(0, url.length > 50 ? 50 : url.length);
  }
}
