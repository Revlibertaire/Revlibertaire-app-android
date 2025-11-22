<div align="center">

# 🚩🏴 REVLIBERTAIRE

<img src="logo.png" alt="Revlibertaire Logo" width="180" style="border-radius: 20px; box-shadow: 0 4px 8px rgba(0,0,0,0.2);"/>

### Application Mobile Android • Revlibertaire

[![Platform](https://img.shields.io/badge/Platform-Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)](https://www.android.com/)
[![Flutter](https://img.shields.io/badge/Flutter-3.35.1-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.9.0-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-red?style=for-the-badge)](LICENSE)
[![Status](https://img.shields.io/badge/Status-Production_Ready-success?style=for-the-badge)](https://github.com)

**Application mobile pour diffuser les idées libertaires et anarchistes**

[📱 Installation](#-installation) • [✨ Fonctionnalités](#-fonctionnalités) • [📖 Documentation](#-documentation) • [🔔 Notifications](#-notifications-push) • [🤝 Contribuer](#-contribution)

</div>

---

## 🎯 À Propos

**Revlibertaire** est l'application mobile officielle du site [revlibertaire.unionlibertaireanarchiste.org](https://revlibertaire.unionlibertaireanarchiste.org). Elle permet de consulter les articles, actualités et analyses du forum Revlibertaire directement depuis votre smartphone Android.

> 🚩 **Rouge** pour la révolution sociale  
> 🏴 **Noir** pour l'anarchisme

---

## ✨ Fonctionnalités

<table>
<tr>
<td width="50%" valign="top">

### 🎯 Fonctionnalités Principales

- 🌐 **WebView Optimisé**  
  Affichage fluide du site complet

- 🎨 **Splash Screen Stylé**  
  Dégradé diagonal rouge/noir CNT-AIT

- 🧭 **Navigation Intuitive**  
  Retour, avancer, recharger, accueil

- ❤️ **Système de Favoris**  
  Sauvegarde locale de vos articles préférés

- ⚠️ **Gestion Intelligente**  
  Détection hors ligne et messages d'erreur

</td>
<td width="50%" valign="top">

### 🚀 Fonctionnalités Avancées

- 🔗 **Partage Social**  
  WhatsApp, Telegram, email, etc.

- 📖 **Mode Hors Ligne**  
  Lecture sans connexion Internet

- 🌙 **Mode Sombre**  
  Économie de batterie et confort

- 🔍 **Recherche Intégrée**  
  Trouvez rapidement vos articles

- 🔔 **Notifications Push**  
  Alertes pour nouveaux contenus

</td>
</tr>
</table>

---

## 📱 Installation

### Prérequis

- Flutter SDK 3.0+
- Android Studio ou VS Code
- Appareil Android ou émulateur

> ⚠️ **Note** : Cette application est développée **uniquement pour Android**

### Installation Rapide

```bash
# 1. Cloner le projet
git clone https://github.com/votre-repo/revlibertaire.git
cd revlibertaire

# 2. Installer les dépendances
flutter pub get

# 3. Lancer l'application
flutter run
```

### Compilation APK

```bash
# APK de production
flutter build apk --release

# APK optimisés par architecture (recommandé)
flutter build apk --split-per-abi
```

📦 **APK généré dans** : `build/app/outputs/flutter-apk/app-release.apk`

---

## 📖 Documentation

| Document | Description |
|----------|-------------|
| 📘 [DEMARRAGE_RAPIDE.md](DEMARRAGE_RAPIDE.md) | Installation en 3 étapes |
| 📗 [GUIDE_COMPILATION.md](GUIDE_COMPILATION.md) | Compilation détaillée |
| 📙 [CONFIGURATION_FIREBASE.md](CONFIGURATION_FIREBASE.md) | Configuration notifications |
| 📕 [NOTIFICATIONS_CONFIGUREES.md](NOTIFICATIONS_CONFIGUREES.md) | Guide notifications |
| 📔 [NOUVELLES_FONCTIONNALITES.md](NOUVELLES_FONCTIONNALITES.md) | Guide des features |
| 📓 [RESUME_FINAL.md](RESUME_FINAL.md) | Vue d'ensemble complète |

---

## 🎨 Captures d'Écran

<div align="center">

| Splash Screen | Page d'Accueil | Menu |
|:-------------:|:--------------:|:----:|
| 🎨 Dégradé CNT-AIT | 🌐 WebView | ⋮ Options |

</div>

---

## 🔔 Notifications Push

Les notifications sont configurées avec **Firebase Cloud Messaging**.

### Topics Disponibles

- 📰 `nouveaux_articles` - Nouveaux articles publiés
- 📅 `evenements` - Événements militants

### Configuration

Consultez [CONFIGURATION_FIREBASE.md](CONFIGURATION_FIREBASE.md) pour activer les notifications.

---

## 🛠️ Technologies

<div align="center">

| Technologie | Version | Usage |
|-------------|---------|-------|
| ![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white) | 3.35.1 | Framework |
| ![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white) | 3.9.0 | Langage |
| ![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=flat&logo=firebase&logoColor=black) | Latest | Notifications |
| ![Android](https://img.shields.io/badge/Android-3DDC84?style=flat&logo=android&logoColor=white) | 5.0+ | Plateforme |

</div>

### Dépendances Principales

```yaml
webview_flutter: ^4.4.2      # Affichage web
shared_preferences: ^2.2.2   # Stockage local
connectivity_plus: ^5.0.2    # Détection connexion
share_plus: ^7.2.1           # Partage
path_provider: ^2.1.1        # Fichiers
firebase_messaging: ^14.7.9  # Notifications
```

---

## 📊 Statistiques

<div align="center">

| 📝 Lignes de Code | 📁 Fichiers | 📚 Documentation | ⚡ Fonctionnalités | ✅ Tests |
|:-----------------:|:-----------:|:----------------:|:-----------------:|:--------:|
| ~1400 | 18 | 15+ fichiers | 10 complètes | 0 erreurs |

</div>

---

## 🎯 Utilisation

### Partager un Article

1. Naviguez vers un article
2. Cliquez sur **🔗 Partager**
3. Choisissez votre application

### Mode Hors Ligne

1. Ouvrez un article
2. Menu **⋮** → "Sauvegarder hors ligne"
3. Consultez via Menu → "Articles hors ligne"

### Rechercher

1. Menu **⋮** → "Rechercher"
2. Entrez votre recherche
3. Validez

### Mode Sombre

1. Menu **⋮** → "Mode sombre"
2. Redémarrez l'application

---

## 🤝 Contribution

Contributions bienvenues ! Pour contribuer :

1. 🍴 **Fork** le projet
2. 🌿 **Créez** une branche (`git checkout -b feature/amelioration`)
3. 💾 **Commit** vos changements (`git commit -m 'Ajout fonctionnalité'`)
4. 📤 **Push** vers la branche (`git push origin feature/amelioration`)
5. 🔀 **Ouvrez** une Pull Request

---

## 📄 Licence

Ce projet est sous licence **MIT** - voir le fichier [LICENSE](LICENSE) pour plus de détails.

### Principes du Logiciel Libre

- ✅ Liberté d'utiliser
- ✅ Liberté d'étudier
- ✅ Liberté de redistribuer
- ✅ Liberté d'améliorer

---

## 🌟 Remerciements

- **Forum Revlibertaire** pour le contenu
- **Communauté Flutter** pour le framework
- **Tous les contributeurs** pour leur soutien

---

<div align="center">

## ✊ Solidarité et Liberté Numérique ! 🚩🏴

*Développé avec passion pour la cause libertaire*

**Version 1.0.0** • **Production Ready** ✅

---

[![Made with Flutter](https://img.shields.io/badge/Made%20with-Flutter-blue?style=for-the-badge&logo=flutter)](https://flutter.dev/)
[![Made with Love](https://img.shields.io/badge/Made%20with-❤️-red?style=for-the-badge)](https://github.com)
[![Anarchism](https://img.shields.io/badge/Anarchism-🏴-black?style=for-the-badge)](https://github.com)

**[Forum Revlibertaire](https://revlibertaire.unionlibertaireanarchiste.org)** • **[Union Libertaire Anarchiste](https://unionlibertaireanarchiste.org)**

</div>
