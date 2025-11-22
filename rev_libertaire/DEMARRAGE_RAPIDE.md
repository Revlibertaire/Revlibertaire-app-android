# 🚀 Démarrage Rapide

## Installation en 3 étapes

### 1️⃣ Installer les dépendances

```bash
cd rev_libertaire
flutter pub get
```

### 2️⃣ Lancer l'application

**Sur émulateur ou appareil connecté :**

```bash
flutter run
```

**L'application va :**
- Afficher un splash screen pendant 3 secondes
- Charger le site Révolution Libertaire
- Être prête à l'utilisation !

### 3️⃣ Compiler l'APK

**Pour tester :**

```bash
flutter build apk --release
```

**L'APK sera dans :** `build/app/outputs/flutter-apk/app-release.apk`

## 📱 Utilisation de l'application

### Navigation
- **Barre du bas** : Retour, Avancer, Recharger, Accueil
- **Barre du haut** : Favoris, Traduction, Liste des favoris

### Ajouter un favori
1. Naviguez vers une page
2. Cliquez sur le cœur ❤️ en haut
3. La page est sauvegardée !

### Traduire une page
1. Cliquez sur l'icône 🌐
2. Choisissez une langue
3. La page est traduite via Google Translate

### Voir vos favoris
1. Cliquez sur l'icône 📑 en haut
2. Liste de tous vos favoris
3. Cliquez pour ouvrir, ou supprimez avec la corbeille

## 🎨 Personnalisation

### Changer le logo

1. Créez ou trouvez un logo (512x512 px recommandé)
2. Placez-le dans `assets/logo.png`
3. Décommentez dans `pubspec.yaml` :

```yaml
assets:
  - assets/logo.png
```

4. Générez les icônes :

```bash
flutter pub run flutter_launcher_icons
```

### Changer les couleurs

Éditez `lib/main.dart`, ligne ~15 :

```dart
primaryColor: const Color(0xFF8B0000), // Changez cette couleur
```

Codes couleur :
- Rouge foncé : `0xFF8B0000` (actuel)
- Noir : `0xFF000000`
- Rouge vif : `0xFFFF0000`
- Bordeaux : `0xFF800020`

## 🔧 Commandes utiles

### Vérifier l'installation Flutter

```bash
flutter doctor
```

### Nettoyer le projet

```bash
flutter clean
flutter pub get
```

### Voir les appareils connectés

```bash
flutter devices
```

### Analyser le code

```bash
flutter analyze
```

### Compiler pour différentes architectures

```bash
flutter build apk --split-per-abi
```

## ❓ Problèmes courants

### "No devices found"

**Solution :**
- Connectez un appareil Android via USB
- Ou lancez un émulateur depuis Android Studio
- Activez le débogage USB sur votre téléphone

### "SDK not found"

**Solution :**

```bash
flutter config --android-sdk /chemin/vers/android/sdk
```

### L'application ne se connecte pas

**Solution :**
- Vérifiez votre connexion Internet
- Vérifiez que les permissions sont dans `AndroidManifest.xml`
- Rechargez la page avec le bouton ⟳

### Erreur de compilation

**Solution :**

```bash
flutter clean
flutter pub get
flutter build apk --release
```

## 📚 Documentation complète

- **README.md** : Vue d'ensemble du projet
- **GUIDE_COMPILATION.md** : Guide détaillé de compilation
- **FONCTIONNALITES.md** : Documentation technique complète

## 🆘 Support

Pour toute question ou problème :
1. Consultez la documentation Flutter : https://docs.flutter.dev
2. Vérifiez les issues GitHub du projet
3. Contactez la communauté libertaire

---

**Solidarité numérique ! ✊🚩**
