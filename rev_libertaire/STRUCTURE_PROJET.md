# 📁 Structure du Projet

## Arborescence complète

```
rev_libertaire/
├── android/                          # Configuration Android
│   ├── app/
│   │   └── src/main/
│   │       └── AndroidManifest.xml   # Permissions et configuration
│   └── build.gradle                  # Configuration Gradle
│
├── assets/                           # Ressources (images, logos)
│   └── .gitkeep                      # Placeholder pour le logo
│
├── lib/                              # Code source Dart
│   ├── main.dart                     # Point d'entrée de l'application
│   │
│   ├── models/                       # Modèles de données
│   │   └── favorite.dart             # Modèle Favori (URL, titre, date)
│   │
│   ├── screens/                      # Écrans de l'application
│   │   ├── splash_screen.dart        # Écran de démarrage animé
│   │   ├── home_screen.dart          # Écran principal avec WebView
│   │   └── favorites_screen.dart     # Liste et gestion des favoris
│   │
│   └── services/                     # Services et logique métier
│       ├── favorites_service.dart    # Gestion du stockage des favoris
│       └── translation_service.dart  # Service de traduction
│
├── pubspec.yaml                      # Dépendances et configuration
├── flutter_launcher_icons.yaml      # Configuration des icônes
│
└── Documentation/
    ├── README.md                     # Vue d'ensemble
    ├── DEMARRAGE_RAPIDE.md          # Guide de démarrage
    ├── GUIDE_COMPILATION.md         # Guide de compilation détaillé
    ├── FONCTIONNALITES.md           # Documentation technique
    └── STRUCTURE_PROJET.md          # Ce fichier
```

## 📄 Description des fichiers principaux

### `lib/main.dart`

**Rôle :** Point d'entrée de l'application

**Contenu :**
- Configuration du thème (couleurs rouge foncé)
- Initialisation de MaterialApp
- Navigation vers le SplashScreen

**Lignes clés :**
```dart
primaryColor: const Color(0xFF8B0000)  // Thème révolutionnaire
home: const SplashScreen()              // Premier écran
```

---

### `lib/screens/splash_screen.dart`

**Rôle :** Écran de démarrage avec animation

**Fonctionnalités :**
- Animation de fondu (2 secondes)
- Affichage du logo et titre
- Navigation automatique après 3 secondes

**Widgets utilisés :**
- `AnimationController` : Contrôle l'animation
- `FadeTransition` : Effet de fondu
- `Timer` : Délai avant navigation

---

### `lib/screens/home_screen.dart`

**Rôle :** Écran principal avec WebView et toutes les fonctionnalités

**Fonctionnalités :**
- WebView pour afficher le site
- Navigation (retour, avancer, recharger, accueil)
- Gestion des favoris
- Menu de traduction
- Détection hors ligne
- Gestion des erreurs

**Composants :**
- `WebViewController` : Contrôle du WebView
- `NavigationDelegate` : Gestion des événements de navigation
- `Connectivity` : Détection de la connexion
- `BottomAppBar` : Barre de navigation

**Variables d'état :**
```dart
bool _isLoading      // Indicateur de chargement
bool _isOffline      // État de connexion
bool _isFavorite     // Page en favori ou non
String _currentUrl   // URL actuelle
```

---

### `lib/screens/favorites_screen.dart`

**Rôle :** Affichage et gestion de la liste des favoris

**Fonctionnalités :**
- Liste de tous les favoris
- Suppression de favoris
- Ouverture dans une WebView dédiée

**Composants :**
- `ListView.builder` : Liste dynamique
- `Card` : Carte pour chaque favori
- `_FavoriteWebViewScreen` : WebView pour ouvrir un favori

---

### `lib/models/favorite.dart`

**Rôle :** Modèle de données pour un favori

**Propriétés :**
```dart
String url          // URL de la page
String title        // Titre de la page
DateTime addedAt    // Date d'ajout
```

**Méthodes :**
- `toJson()` : Convertit en Map pour stockage
- `fromJson()` : Crée un Favori depuis un Map

---

### `lib/services/favorites_service.dart`

**Rôle :** Gestion du stockage local des favoris

**Méthodes principales :**

```dart
Future<List<Favorite>> getFavorites()           // Récupère tous les favoris
Future<void> addFavorite(url, title)            // Ajoute un favori
Future<void> removeFavorite(url)                // Supprime un favori
Future<bool> isFavorite(url)                    // Vérifie si en favori
```

**Stockage :**
- Utilise `SharedPreferences`
- Format JSON
- Clé : `'favorites'`

---

### `lib/services/translation_service.dart`

**Rôle :** Service de traduction via Google Translate

**Méthode principale :**

```dart
String getTranslatedUrl(originalUrl, targetLanguage)
```

**Fonctionnement :**
- Génère une URL Google Translate
- Format : `https://translate.google.com/translate?sl=auto&tl=LANG&u=URL`
- Langues supportées : fr, en, es, de, it, pt, etc.

---

### `android/app/src/main/AndroidManifest.xml`

**Rôle :** Configuration Android et permissions

**Permissions ajoutées :**
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
```

**Configuration :**
- Nom de l'application : "Révolution Libertaire"
- Icône : `@mipmap/ic_launcher`

---

### `pubspec.yaml`

**Rôle :** Configuration du projet et dépendances

**Dépendances principales :**

```yaml
webview_flutter: ^4.4.2              # WebView
shared_preferences: ^2.2.2           # Stockage local
connectivity_plus: ^5.0.2            # Détection connexion
translator: ^1.0.0                   # Traduction
flutter_launcher_icons: ^0.13.1      # Génération d'icônes
```

**Configuration :**
- Version : 1.0.0+1
- SDK Dart : ^3.9.0

---

## 🔄 Flux de données

### Ajout d'un favori

```
1. Utilisateur clique sur ❤️
   ↓
2. home_screen.dart → _toggleFavorite()
   ↓
3. Récupère le titre via WebViewController
   ↓
4. favorites_service.dart → addFavorite()
   ↓
5. Crée un objet Favorite
   ↓
6. Sérialise en JSON
   ↓
7. Sauvegarde dans SharedPreferences
   ↓
8. Affiche SnackBar de confirmation
```

### Traduction d'une page

```
1. Utilisateur clique sur 🌐
   ↓
2. home_screen.dart → _showTranslationMenu()
   ↓
3. Affiche BottomSheet avec langues
   ↓
4. Utilisateur sélectionne une langue
   ↓
5. translation_service.dart → getTranslatedUrl()
   ↓
6. Génère URL de traduction (Google Translate)
   Note: LibreTranslate de l'ULA est disponible pour traductions API
   ↓
7. WebViewController charge la nouvelle URL
   ↓
8. Page traduite affichée
```

### Chargement de la liste des favoris

```
1. Utilisateur ouvre favorites_screen.dart
   ↓
2. initState() → _loadFavorites()
   ↓
3. favorites_service.dart → getFavorites()
   ↓
4. Lit depuis SharedPreferences
   ↓
5. Désérialise le JSON
   ↓
6. Crée une List<Favorite>
   ↓
7. setState() met à jour l'UI
   ↓
8. ListView.builder affiche les favoris
```

---

## 🎨 Architecture

### Pattern utilisé : MVC simplifié

**Models** (`lib/models/`)
- Structures de données pures
- Sérialisation/désérialisation
- Pas de logique métier

**Services** (`lib/services/`)
- Logique métier
- Interaction avec le stockage
- Services externes (traduction)

**Screens** (`lib/screens/`)
- Interface utilisateur (Views)
- Gestion des états locaux
- Contrôleurs (Controllers)

### Avantages de cette architecture

✅ **Séparation des responsabilités**
- Chaque fichier a un rôle clair
- Facile à maintenir et tester

✅ **Réutilisabilité**
- Services utilisables partout
- Modèles indépendants

✅ **Évolutivité**
- Facile d'ajouter de nouvelles fonctionnalités
- Structure claire pour les nouveaux développeurs

---

## 🔧 Points d'extension

### Ajouter une nouvelle langue

**Fichier :** `lib/services/translation_service.dart`

```dart
static const Map<String, String> supportedLanguages = {
  'fr': 'Français',
  'en': 'English',
  'ru': 'Русский',  // ← Ajouter ici
};
```

### Ajouter un nouveau service

1. Créer `lib/services/mon_service.dart`
2. Implémenter la logique
3. Importer dans les screens nécessaires

### Ajouter un nouvel écran

1. Créer `lib/screens/mon_ecran.dart`
2. Créer un StatefulWidget
3. Ajouter la navigation depuis un autre écran

---

## 📊 Taille des fichiers (approximatif)

```
main.dart                    ~40 lignes
splash_screen.dart           ~80 lignes
home_screen.dart            ~280 lignes (le plus gros)
favorites_screen.dart       ~180 lignes
favorite.dart                ~30 lignes
favorites_service.dart       ~70 lignes
translation_service.dart     ~30 lignes
```

**Total :** ~710 lignes de code Dart

---

## 🚀 Prochaines améliorations possibles

1. **Mode hors ligne**
   - Cache des pages visitées
   - Lecture hors ligne des favoris

2. **Partage**
   - Partager une page via d'autres apps
   - Partager un favori

3. **Recherche**
   - Recherche dans les favoris
   - Recherche dans le site

4. **Notifications**
   - Nouveaux articles
   - Mises à jour du site

5. **Thèmes**
   - Mode sombre
   - Personnalisation des couleurs

6. **Historique**
   - Historique de navigation
   - Effacer l'historique

---

**Code propre, révolution numérique ! ✊**
