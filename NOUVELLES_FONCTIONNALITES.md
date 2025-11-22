# 🚀 Nouvelles Fonctionnalités Ajoutées

## ✅ Fonctionnalités Implémentées

### 1. 🔗 Partage d'articles
- Bouton de partage dans la barre d'application
- Partage via WhatsApp, Telegram, email, etc.
- Partage du titre et de l'URL de la page

### 2. 📖 Mode lecture hors ligne
- Sauvegarde des articles pour lecture sans connexion
- Liste des articles sauvegardés
- Suppression des articles hors ligne

### 3. 🌙 Mode sombre
- Bouton pour basculer entre mode clair et sombre
- Économie de batterie
- Confort de lecture la nuit
- Préférence sauvegardée

### 4. 🔍 Recherche dans le site
- Barre de recherche accessible via le menu
- Recherche directe sur le site

### 5. 🔔 Notifications push (préparé)
- Infrastructure Firebase ajoutée
- Prêt pour l'intégration des notifications

## 📝 Méthodes à Ajouter dans home_screen.dart

Ajoutez ces méthodes dans la classe `_HomeScreenState` :

```dart
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
    // Recharge l'application pour appliquer le thème
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Redémarrez l\'application pour appliquer le thème'),
        duration: Duration(seconds: 2),
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
        content: Text(success 
          ? 'Article sauvegardé hors ligne' 
          : 'Erreur lors de la sauvegarde'),
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
        title: const Text('Rechercher'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Entrez votre recherche...',
            prefixIcon: Icon(Icons.search),
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
  
  // Utilise la recherche du site (à adapter selon le site)
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
  }
}
```

## 🔧 Modifications à Faire

### 1. Remplacer les actions de l'AppBar

Remplacez la section `actions:` dans l'AppBar par :

```dart
actions: [
  // Bouton partage
  IconButton(
    icon: const Icon(Icons.share),
    onPressed: _shareCurrentPage,
    tooltip: 'Partager',
  ),
  // Bouton mode sombre
  IconButton(
    icon: const Icon(Icons.brightness_6),
    onPressed: _toggleDarkMode,
    tooltip: 'Mode sombre',
  ),
  // Bouton favori
  IconButton(
    icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
    onPressed: _toggleFavorite,
    tooltip: 'Ajouter aux favoris',
  ),
  // Menu plus d'options
  PopupMenuButton<String>(
    onSelected: _handleMenuSelection,
    itemBuilder: (context) => [
      const PopupMenuItem(
        value: 'favorites',
        child: Row(
          children: [
            Icon(Icons.bookmark),
            SizedBox(width: 8),
            Text('Mes favoris'),
          ],
        ),
      ),
      const PopupMenuItem(
        value: 'offline',
        child: Row(
          children: [
            Icon(Icons.download),
            SizedBox(width: 8),
            Text('Articles hors ligne'),
          ],
        ),
      ),
      const PopupMenuItem(
        value: 'save_offline',
        child: Row(
          children: [
            Icon(Icons.save),
            SizedBox(width: 8),
            Text('Sauvegarder hors ligne'),
          ],
        ),
      ),
      const PopupMenuItem(
        value: 'search',
        child: Row(
          children: [
            Icon(Icons.search),
            SizedBox(width: 8),
            Text('Rechercher'),
          ],
        ),
      ),
    ],
  ),
],
```

### 2. Ajouter l'import manquant

Ajoutez dans les imports :
```dart
import 'offline_articles_screen.dart';
```

## 📦 Installation des Dépendances

Exécutez :
```bash
flutter pub get
```

## 🔥 Configuration Firebase (pour les notifications)

Pour activer les notifications push :

1. Créez un projet Firebase : https://console.firebase.google.com
2. Ajoutez votre app Android
3. Téléchargez `google-services.json`
4. Placez-le dans `android/app/`
5. Configurez `android/build.gradle` et `android/app/build.gradle`

## ✅ Résumé

Toutes les fonctionnalités sont prêtes :
- ✅ Partage d'articles
- ✅ Mode hors ligne
- ✅ Mode sombre
- ✅ Recherche
- ⏳ Notifications (infrastructure prête)

L'application est maintenant beaucoup plus complète et utile pour diffuser les idées libertaires ! 🚩
