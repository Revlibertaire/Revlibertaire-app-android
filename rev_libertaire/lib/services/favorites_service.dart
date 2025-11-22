import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/favorite.dart';

/// Service de gestion des favoris avec stockage local
class FavoritesService {
  static const String _favoritesKey = 'favorites';

  /// Récupère tous les favoris
  Future<List<Favorite>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getString(_favoritesKey);
    
    if (favoritesJson == null) {
      return [];
    }

    final List<dynamic> decoded = jsonDecode(favoritesJson);
    return decoded.map((json) => Favorite.fromJson(json)).toList();
  }

  /// Ajoute un favori
  Future<void> addFavorite(String url, String title) async {
    final favorites = await getFavorites();
    
    // Vérifie si le favori existe déjà
    if (favorites.any((f) => f.url == url)) {
      return;
    }

    favorites.add(Favorite(
      url: url,
      title: title,
      addedAt: DateTime.now(),
    ));

    await _saveFavorites(favorites);
  }

  /// Supprime un favori
  Future<void> removeFavorite(String url) async {
    final favorites = await getFavorites();
    favorites.removeWhere((f) => f.url == url);
    await _saveFavorites(favorites);
  }

  /// Vérifie si une URL est dans les favoris
  Future<bool> isFavorite(String url) async {
    final favorites = await getFavorites();
    return favorites.any((f) => f.url == url);
  }

  /// Sauvegarde les favoris
  Future<void> _saveFavorites(List<Favorite> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = jsonEncode(
      favorites.map((f) => f.toJson()).toList(),
    );
    await prefs.setString(_favoritesKey, favoritesJson);
  }
}
