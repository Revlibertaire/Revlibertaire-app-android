import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:share_plus/share_plus.dart';
import '../services/favorites_service.dart';
import '../services/offline_service.dart';
import '../services/theme_service.dart';
import 'favorites_screen.dart';
import 'offline_articles_screen.dart';

/// Écran principal avec WebView et navigation
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final WebViewController _controller;
  final String _baseUrl = 'https://revlibertaire.unionlibertaireanarchiste.org';
  final FavoritesService _favoritesService = FavoritesService();
  final OfflineService _offlineService = OfflineService();
  final ThemeService _themeService = ThemeService();

  
  bool _isLoading = true;
  bool _isOffline = false;
  bool _isFavorite = false;
  String _currentUrl = '';


  @override
  void initState() {
    super.initState();
    _initWebView();
    _checkConnectivity();
    _loadFavoriteStatus();
  }

  /// Initialise le WebView
  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              _isLoading = true;
              _currentUrl = url;
            });
            _loadFavoriteStatus();
          },
          onPageFinished: (url) {
            setState(() => _isLoading = false);
          },
          onWebResourceError: (error) {
            _showErrorDialog('Erreur de chargement', error.description);
          },
        ),
      )
      ..loadRequest(Uri.parse(_baseUrl));
  }

  /// Vérifie la connectivité réseau
  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isOffline = connectivityResult == ConnectivityResult.none;
    });
    
    if (_isOffline) {
      _showErrorDialog('Hors ligne', 'Vous êtes actuellement hors ligne. Veuillez vérifier votre connexion Internet.');
    }
  }

  /// Charge le statut favori de l'URL actuelle
  Future<void> _loadFavoriteStatus() async {
    final isFav = await _favoritesService.isFavorite(_currentUrl);
    setState(() => _isFavorite = isFav);
  }

  /// Affiche une boîte de dialogue d'erreur
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Bascule le statut favori
  Future<void> _toggleFavorite() async {
    if (_currentUrl.isEmpty) return;
    
    if (_isFavorite) {
      await _favoritesService.removeFavorite(_currentUrl);
    } else {
      // Récupère le titre de la page
      final title = await _controller.getTitle() ?? 'Sans titre';
      await _favoritesService.addFavorite(_currentUrl, title);
    }
    
    await _loadFavoriteStatus();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isFavorite ? 'Ajouté aux favoris' : 'Retiré des favoris'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('REVLIBERTAIRE'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFF0000), Colors.black], // Rouge sang vif
              stops: [0.5, 0.5],
            ),
          ),
        ),
        actions: [
          // Bouton partage
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareCurrentPage,
            tooltip: 'Partager',
          ),
          // Bouton favori
          IconButton(
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: _toggleFavorite,
            tooltip: 'Favoris',
          ),
          // Menu plus d'options
          PopupMenuButton<String>(
            onSelected: _handleMenuSelection,
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'favorites',
                child: Row(
                  children: [
                    Icon(Icons.bookmark),
                    SizedBox(width: 12),
                    Text('Mes favoris'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'save_offline',
                child: Row(
                  children: [
                    Icon(Icons.download),
                    SizedBox(width: 12),
                    Text('Sauvegarder hors ligne'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'offline',
                child: Row(
                  children: [
                    Icon(Icons.article),
                    SizedBox(width: 12),
                    Text('Articles hors ligne'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'search',
                child: Row(
                  children: [
                    Icon(Icons.search),
                    SizedBox(width: 12),
                    Text('Rechercher'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'dark_mode',
                child: Row(
                  children: [
                    Icon(Icons.brightness_6),
                    SizedBox(width: 12),
                    Text('Mode sombre'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          // WebView
          WebViewWidget(controller: _controller),
          
          // Indicateur de chargement
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF8B0000),
              ),
            ),
          
          // Message hors ligne
          if (_isOffline)
            Container(
              color: Colors.black87,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wifi_off, size: 64, color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Hors ligne',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      
      // Barre de navigation compacte avec dégradé CNT-AIT
      bottomNavigationBar: Container(
        height: 50,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFF0000), Colors.black], // Rouge sang vif
            stops: [0.5, 0.5],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Bouton retour
            IconButton(
              icon: const Icon(Icons.arrow_back, size: 20),
              color: Colors.white,
              onPressed: () async {
                if (await _controller.canGoBack()) {
                  _controller.goBack();
                }
              },
              tooltip: 'Retour',
            ),
            // Bouton avancer
            IconButton(
              icon: const Icon(Icons.arrow_forward, size: 20),
              color: Colors.white,
              onPressed: () async {
                if (await _controller.canGoForward()) {
                  _controller.goForward();
                }
              },
              tooltip: 'Avancer',
            ),
            // Bouton recharger
            IconButton(
              icon: const Icon(Icons.refresh, size: 20),
              color: Colors.white,
              onPressed: () {
                _controller.reload();
                _checkConnectivity();
              },
              tooltip: 'Recharger',
            ),
            // Bouton accueil
            IconButton(
              icon: const Icon(Icons.home, size: 20),
              color: Colors.white,
              onPressed: () {
                _controller.loadRequest(Uri.parse(_baseUrl));
              },
              tooltip: 'Accueil',
            ),
          ],
        ),
      ),
    );
  }

  /// Partage la page actuelle
  Future<void> _shareCurrentPage() async {
    final title = await _controller.getTitle() ?? 'Revlibertaire';
    await Share.share(
      '$title\n$_currentUrl',
      subject: title,
    );
  }

  /// Bascule le mode sombre
  Future<void> _toggleDarkMode() async {
    await _themeService.toggleDarkMode();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Redémarrez l\'application pour appliquer le thème'),
          duration: Duration(seconds: 3),
          backgroundColor: Color(0xFF8B0000),
        ),
      );
    }
  }

  /// Sauvegarde la page actuelle hors ligne
  Future<void> _savePageOffline() async {
    if (_currentUrl.isEmpty) return;
    
    setState(() => _isLoading = true);
    
    final title = await _controller.getTitle() ?? 'Sans titre';
    final success = await _offlineService.saveArticleOffline(_currentUrl, title);
    
    setState(() => _isLoading = false);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                success ? Icons.check_circle : Icons.error,
                color: Colors.white,
              ),
              const SizedBox(width: 12),
              Text(success 
                ? 'Article sauvegardé hors ligne' 
                : 'Erreur lors de la sauvegarde'),
            ],
          ),
          backgroundColor: success ? const Color(0xFF2E7D32) : Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  /// Affiche la barre de recherche
  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String searchQuery = '';
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.search, color: Color(0xFF8B0000)),
              SizedBox(width: 8),
              Text('Rechercher'),
            ],
          ),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Entrez votre recherche...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => searchQuery = value,
            onSubmitted: (value) {
              Navigator.pop(context);
              _performSearch(value);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B0000),
              ),
              onPressed: () {
                Navigator.pop(context);
                _performSearch(searchQuery);
              },
              child: const Text('Rechercher'),
            ),
          ],
        );
      },
    );
  }

  /// Effectue une recherche sur le site
  void _performSearch(String query) {
    if (query.isEmpty) return;
    
    // Utilise la recherche du site WordPress
    final searchUrl = '$_baseUrl/?s=${Uri.encodeComponent(query)}';
    _controller.loadRequest(Uri.parse(searchUrl));
  }

  /// Gère la sélection du menu
  void _handleMenuSelection(String value) {
    switch (value) {
      case 'favorites':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FavoritesScreen()),
        );
        break;
      case 'offline':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const OfflineArticlesScreen()),
        );
        break;
      case 'save_offline':
        _savePageOffline();
        break;
      case 'search':
        _showSearchDialog();
        break;
      case 'dark_mode':
        _toggleDarkMode();
        break;
    }
  }
}
