import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../services/favorites_service.dart';
import '../models/favorite.dart';

/// Écran affichant la liste des favoris
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesService _favoritesService = FavoritesService();
  List<Favorite> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  /// Charge la liste des favoris
  Future<void> _loadFavorites() async {
    setState(() => _isLoading = true);
    final favorites = await _favoritesService.getFavorites();
    setState(() {
      _favorites = favorites;
      _isLoading = false;
    });
  }

  /// Supprime un favori
  Future<void> _removeFavorite(String url) async {
    await _favoritesService.removeFavorite(url);
    await _loadFavorites();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Favori supprimé'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  /// Ouvre un favori dans une WebView
  void _openFavorite(String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _FavoriteWebViewScreen(url: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Favoris'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF8B0000),
              ),
            )
          : _favorites.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bookmark_border,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Aucun favori',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Ajoutez des pages à vos favoris\npour les retrouver ici',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _favorites.length,
                  itemBuilder: (context, index) {
                    final favorite = _favorites[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFF8B0000),
                          child: Icon(Icons.bookmark, color: Colors.white),
                        ),
                        title: Text(
                          favorite.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          favorite.url,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeFavorite(favorite.url),
                        ),
                        onTap: () => _openFavorite(favorite.url),
                      ),
                    );
                  },
                ),
    );
  }
}

/// Écran WebView pour afficher un favori
class _FavoriteWebViewScreen extends StatefulWidget {
  final String url;

  const _FavoriteWebViewScreen({required this.url});

  @override
  State<_FavoriteWebViewScreen> createState() => _FavoriteWebViewScreenState();
}

class _FavoriteWebViewScreenState extends State<_FavoriteWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favori'),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF8B0000),
              ),
            ),
        ],
      ),
    );
  }
}
