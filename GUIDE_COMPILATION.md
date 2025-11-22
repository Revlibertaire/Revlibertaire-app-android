# 📱 Guide de Compilation - Révolution Libertaire

## Étapes de compilation pour Android

### 1. Vérifier l'installation Flutter

```bash
flutter doctor
```

Assurez-vous que tout est vert, notamment :
- Flutter SDK
- Android toolchain
- Android Studio ou VS Code

### 2. Installer les dépendances

```bash
cd rev_libertaire
flutter pub get
```

### 3. Tester sur émulateur ou appareil

Connectez un appareil Android ou lancez un émulateur, puis :

```bash
flutter run
```

### 4. Compiler l'APK de production

#### APK universel (fonctionne sur tous les appareils)

```bash
flutter build apk --release
```

L'APK sera dans : `build/app/outputs/flutter-apk/app-release.apk`

#### APK optimisés par architecture (recommandé, taille réduite)

```bash
flutter build apk --split-per-abi
```

Génère 3 APK dans `build/app/outputs/flutter-apk/` :
- `app-armeabi-v7a-release.apk` (anciens appareils 32-bit)
- `app-arm64-v8a-release.apk` (appareils récents 64-bit)
- `app-x86_64-release.apk` (émulateurs)

### 5. Compiler un App Bundle (pour Google Play Store)

```bash
flutter build appbundle --release
```

Le fichier `.aab` sera dans : `build/app/outputs/bundle/release/app-release.aab`

## 🔑 Signature de l'application (pour publication)

### Créer une clé de signature

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

### Configurer la signature

1. Créez le fichier `android/key.properties` :

```properties
storePassword=VOTRE_MOT_DE_PASSE
keyPassword=VOTRE_MOT_DE_PASSE
keyAlias=upload
storeFile=/chemin/vers/upload-keystore.jks
```

2. Modifiez `android/app/build.gradle` :

Ajoutez avant `android {` :

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}
```

Dans `android { ... }`, ajoutez :

```gradle
signingConfigs {
    release {
        keyAlias keystoreProperties['keyAlias']
        keyPassword keystoreProperties['keyPassword']
        storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
        storePassword keystoreProperties['storePassword']
    }
}
buildTypes {
    release {
        signingConfig signingConfigs.release
    }
}
```

## 🎨 Personnaliser l'icône

1. Placez votre logo dans `assets/logo.png` (512x512 px)

2. Configurez dans `pubspec.yaml` :

```yaml
flutter_launcher_icons:
  android: true
  image_path: "assets/logo.png"
  adaptive_icon_background: "#8B0000"
  adaptive_icon_foreground: "assets/logo.png"
```

3. Générez les icônes :

```bash
flutter pub run flutter_launcher_icons
```

## 🚀 Installation sur appareil

### Via câble USB

```bash
flutter install
```

### Via fichier APK

1. Transférez l'APK sur votre téléphone
2. Activez "Sources inconnues" dans les paramètres
3. Ouvrez l'APK et installez

## 🐛 Résolution de problèmes

### Erreur "SDK not found"

```bash
flutter config --android-sdk /chemin/vers/android/sdk
```

### Erreur de licence Android

```bash
flutter doctor --android-licenses
```

### Nettoyer le projet

```bash
flutter clean
flutter pub get
```

## 📊 Optimisations

### Réduire la taille de l'APK

```bash
flutter build apk --release --shrink --split-per-abi
```

### Analyser la taille

```bash
flutter build apk --analyze-size
```

## ✅ Checklist avant publication

- [ ] Tester sur plusieurs appareils Android
- [ ] Vérifier toutes les fonctionnalités (WebView, favoris, traduction)
- [ ] Tester hors ligne
- [ ] Vérifier les permissions dans AndroidManifest.xml
- [ ] Changer l'icône de l'application
- [ ] Mettre à jour le numéro de version dans pubspec.yaml
- [ ] Signer l'application
- [ ] Tester l'APK final

## 📝 Versions

Modifiez dans `pubspec.yaml` :

```yaml
version: 1.0.0+1
```

Format : `MAJOR.MINOR.PATCH+BUILD_NUMBER`

---

**Bon courage pour la révolution numérique ! ✊**
