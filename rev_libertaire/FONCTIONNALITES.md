# 📋 Documentation des Fonctionnalités

## 🌐 WebView

### Description
Affiche le site web complet de Révolution Libertaire dans une WebView native Android.

### Implémentation
- Package : `webview_flutter`
- JavaScript activé pour une navigation complète
- Gestion automatique des cookies et sessions

### Fichiers concernés
- `lib/screens/home_screen.dart`

## 🎨 Splash Screen

### Description
Écran de démarrage animé affiché pendant 3 secondes au lancement de l'application.

### Caractéristiques
- Animation de fondu (fade-in)
- Logo et titre de l'application
- Fond rouge foncé révolutionnaire
- Transition automatique vers l'écran principal

### Fichiers concernés
- `lib/screens/splash_screen.dart`

## 🧭 Navigation

### Boutons disponibles

1. **Retour** (←)
   - Revient à la page précédente dans l'historique
   - Désactivé si aucune page précédente

2. **Avancer** (→)
   - Avance à la page suivante dans l'historique
   - Désactivé si aucune page suivante

3. **Recharger** (⟳)
   - Recharge la page actuelle
   - Vérifie également la connexion Internet

4. **Accueil** (🏠)
   - Retourne à la page d'accueil du site

### Fichiers concernés
- `lib/screens/home_screen.dart` (barre de navigation inférieure)

## ⭐ Favoris

### Description
Système complet de gestion des favoris avec stockage local persistant.

### Fonctionnalités

1. **Ajouter un favori**
   - Bouton cœur dans la barre d'application
   - Sauvegarde l'URL et le titre de la page
   - Horodatage de l'ajout

2. **Supprimer un favori**
   - Depuis la liste des favoris
   - Confirmation visuelle par SnackBar

3. **Liste des favoris**
   - Affichage de tous les favoris sauvegardés
   - Clic pour ouvrir dans une WebView
   - Bouton de suppression pour chaque favori

### Stockage
- Package : `shared_preferences`
- Format : JSON
- Persistant entre les sessions

### Fichiers concernés
- `lib/models/favorite.dart` - Modèle de données
- `lib/services/favorites_service.dart` - Logique métier
- `lib/screens/favorites_screen.dart` - Interface utilisateur

## 🌍 Traduction Automatique

### Description
Traduction du site web dans différentes langues via Google Translate.
L'API LibreTranslate de l'Union Libertaire Anarchiste est intégrée dans le code pour de futures traductions de texte.

### Langues supportées
- Français (fr)
- English (en)
- Español (es)
- Deutsch (de)
- Italiano (it)
- Português (pt)

### Fonctionnement
1. Clic sur le bouton traduction (🌐)
2. Sélection de la langue dans le menu
3. Utilisation de Google Translate pour traduire la page web complète
4. Option "Version originale" pour revenir au site non traduit

### Services utilisés
- **Google Translate** : Pour la traduction de pages web complètes (seule solution simple disponible)
- **LibreTranslate (ULA)** : API de traduction de texte hébergée par l'Union Libertaire Anarchiste (intégrée dans le code pour usage futur)

### Note technique
LibreTranslate est une API de traduction de **texte**, pas de pages web. Pour traduire une page web complète avec LibreTranslate, il faudrait :
1. Télécharger le HTML de la page
2. Extraire tout le texte
3. Traduire chaque élément via l'API LibreTranslate
4. Réinjecter le texte traduit dans le HTML
5. Afficher le résultat

Cette approche nécessiterait un backend personnalisé. Pour l'instant, Google Translate reste la solution la plus simple pour traduire des pages web complètes.

### Fichiers concernés
- `lib/services/translation_service.dart`
- `lib/screens/home_screen.dart` (menu de traduction)

## ⚠️ Gestion des Erreurs

### Détection hors ligne

**Fonctionnalité**
- Détection automatique de la connexion Internet
- Package : `connectivity_plus`

**Affichage**
- Overlay noir avec icône WiFi barrée
- Message "Hors ligne"
- Vérification à chaque rechargement

### Erreurs de chargement

**Types d'erreurs gérées**
- Page introuvable (404)
- Erreur serveur (500)
- Timeout de connexion
- Erreur SSL/TLS

**Affichage**
- Boîte de dialogue avec titre et description
- Bouton OK pour fermer

### Fichiers concernés
- `lib/screens/home_screen.dart`

## 🎨 Thème et Interface

### Couleurs

**Couleur principale**
- Rouge foncé : `#8B0000`
- Symbolise l'engagement révolutionnaire

**Éléments colorés**
- Barre d'application (AppBar)
- Boutons d'action flottants
- Indicateurs de chargement
- Icônes actives

### Design

**Principes**
- Interface simple et épurée
- Navigation intuitive
- Feedback visuel immédiat
- Accessibilité optimale

### Fichiers concernés
- `lib/main.dart` (configuration du thème)
- Tous les écrans utilisent le thème global

## 📱 Permissions Android

### Permissions requises

1. **INTERNET**
   - Nécessaire pour charger le site web
   - Accès aux services de traduction

2. **ACCESS_NETWORK_STATE**
   - Détection de la connexion Internet
   - Gestion du mode hors ligne

### Configuration
- Fichier : `android/app/src/main/AndroidManifest.xml`

## 🔧 Architecture du Code

### Structure MVC simplifiée

**Models** (`lib/models/`)
- Définition des structures de données
- Sérialisation/désérialisation JSON

**Services** (`lib/services/`)
- Logique métier
- Interaction avec le stockage local
- Services externes (traduction)

**Screens** (`lib/screens/`)
- Interface utilisateur
- Gestion des états
- Navigation

### Bonnes pratiques

1. **Code commenté**
   - Commentaires en français
   - Documentation des fonctions
   - Explications des choix techniques

2. **Gestion des états**
   - StatefulWidget pour les écrans dynamiques
   - setState() pour les mises à jour UI

3. **Async/Await**
   - Opérations asynchrones propres
   - Gestion des erreurs avec try/catch

4. **Séparation des responsabilités**
   - Chaque classe a un rôle unique
   - Services réutilisables

## 🚀 Performance

### Optimisations

1. **WebView**
   - JavaScript activé uniquement si nécessaire
   - Cache activé par défaut

2. **Favoris**
   - Chargement asynchrone
   - Mise en cache en mémoire

3. **Images**
   - Compression recommandée pour le logo
   - Format PNG ou WebP

### Taille de l'application

**APK estimé**
- Universal : ~20-25 MB
- Split per ABI : ~15-18 MB chacun

## 📊 Tests Recommandés

### Tests fonctionnels

- [ ] Navigation entre les pages
- [ ] Ajout/suppression de favoris
- [ ] Traduction dans différentes langues
- [ ] Comportement hors ligne
- [ ] Rotation de l'écran
- [ ] Boutons retour/avancer
- [ ] Rechargement de page

### Tests de compatibilité

- [ ] Android 5.0+ (API 21+)
- [ ] Différentes tailles d'écran
- [ ] Tablettes
- [ ] Mode sombre (si activé sur l'appareil)

### Tests de performance

- [ ] Temps de chargement initial
- [ ] Fluidité de la navigation
- [ ] Consommation mémoire
- [ ] Consommation batterie

---

**Application développée avec ❤️ pour la cause libertaire**
