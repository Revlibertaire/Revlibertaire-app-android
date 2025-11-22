import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart';

/// Service de traduction utilisant LibreTranslate de l'Union Libertaire Anarchiste
/// 
/// LibreTranslate est une alternative libre et open-source à Google Translate
/// hébergée par l'Union Libertaire Anarchiste
class TranslationService {
  static const String _libreTranslateUrl = 'https://libretranslate.unionlibertaireanarchiste.org';
  
  /// Traduit un texte via l'API LibreTranslate de l'ULA
  /// 
  /// [text] : Le texte à traduire
  /// [targetLanguage] : Code de la langue cible (ex: 'en', 'es', 'de')
  /// [sourceLanguage] : Code de la langue source (par défaut 'auto' pour détection automatique)
  /// 
  /// Retourne le texte traduit ou le texte original en cas d'erreur
  Future<String> translateText(
    String text,
    String targetLanguage, {
    String sourceLanguage = 'auto',
  }) async {
    if (text.trim().isEmpty) return text;
    
    try {
      final response = await http.post(
        Uri.parse('$_libreTranslateUrl/translate'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'q': text,
          'source': sourceLanguage,
          'target': targetLanguage,
          'format': 'text',
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['translatedText'] ?? text;
      } else {
        return text;
      }
    } catch (e) {
      return text;
    }
  }

  /// Traduit une page HTML complète via LibreTranslate
  /// 
  /// Télécharge la page, extrait le texte, le traduit via LibreTranslate,
  /// et retourne le HTML traduit sous forme de data URL
  Future<String> translateHtmlPage(String url, String targetLanguage) async {
    try {
      // 1. Télécharge la page HTML
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      
      if (response.statusCode != 200) {
        return url; // Retourne l'URL originale en cas d'erreur
      }

      // 2. Parse le HTML
      final document = html_parser.parse(response.body);
      
      // 3. Traduit les éléments textuels
      await _translateElement(document.body, targetLanguage);
      
      // 4. Retourne le HTML traduit comme data URL
      final translatedHtml = document.outerHtml;
      final encodedHtml = Uri.encodeComponent(translatedHtml);
      
      return 'data:text/html;charset=utf-8,$encodedHtml';
    } catch (e) {
      // En cas d'erreur, retourne l'URL originale
      return url;
    }
  }

  /// Traduit récursivement les éléments d'un nœud HTML
  Future<void> _translateElement(Element? element, String targetLanguage) async {
    if (element == null) return;

    // Traduit le texte direct de l'élément (pas les enfants)
    for (var node in element.nodes) {
      if (node.nodeType == Node.TEXT_NODE) {
        final text = node.text?.trim() ?? '';
        if (text.isNotEmpty && text.length > 2) {
          final translated = await translateText(text, targetLanguage);
          node.text = translated;
        }
      }
    }

    // Traduit les attributs alt et title
    if (element.attributes.containsKey('alt')) {
      final alt = element.attributes['alt'] ?? '';
      if (alt.isNotEmpty) {
        element.attributes['alt'] = await translateText(alt, targetLanguage);
      }
    }
    
    if (element.attributes.containsKey('title')) {
      final title = element.attributes['title'] ?? '';
      if (title.isNotEmpty) {
        element.attributes['title'] = await translateText(title, targetLanguage);
      }
    }

    // Traduit récursivement les enfants
    for (var child in element.children) {
      await _translateElement(child, targetLanguage);
    }
  }

  /// Génère une URL pour afficher la page traduite
  /// 
  /// Utilise LibreTranslate de l'ULA pour traduire la page complète
  String getTranslatedUrl(String originalUrl, String targetLanguage) {
    // Cette méthode retourne l'URL originale
    // La traduction sera faite dans home_screen.dart avec translateHtmlPage()
    return originalUrl;
  }
  
  /// URL de l'instance LibreTranslate de l'Union Libertaire Anarchiste
  static String get libreTranslateUrl => _libreTranslateUrl;
  
  /// Vérifie si LibreTranslate est accessible
  Future<bool> checkAvailability() async {
    try {
      final response = await http.get(
        Uri.parse('$_libreTranslateUrl/languages'),
      ).timeout(const Duration(seconds: 5));
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
  
  /// Récupère la liste des langues supportées par LibreTranslate
  Future<List<Map<String, String>>> getSupportedLanguages() async {
    try {
      final response = await http.get(
        Uri.parse('$_libreTranslateUrl/languages'),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final List<dynamic> languages = jsonDecode(response.body);
        return languages.map((lang) => {
          'code': lang['code'].toString(),
          'name': lang['name'].toString(),
        }).toList();
      }
    } catch (e) {
      // Erreur récupération langues
    }
    
    // Langues par défaut
    return [
      {'code': 'fr', 'name': 'Français'},
      {'code': 'en', 'name': 'English'},
      {'code': 'es', 'name': 'Español'},
      {'code': 'de', 'name': 'Deutsch'},
      {'code': 'it', 'name': 'Italiano'},
      {'code': 'pt', 'name': 'Português'},
    ];
  }
  
  /// Liste des langues supportées (statique)
  static const Map<String, String> supportedLanguages = {
    'fr': 'Français',
    'en': 'English',
    'es': 'Español',
    'de': 'Deutsch',
    'it': 'Italiano',
    'pt': 'Português',
  };
}
