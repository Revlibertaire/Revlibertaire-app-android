# 🔥 Configuration Firebase pour les Notifications Push

## 📋 Étapes de Configuration

### 1. Créer un Projet Firebase

1. Allez sur https://console.firebase.google.com
2. Cliquez sur "Ajouter un projet"
3. Nom du projet : `revlibertaire` (ou autre)
4. Désactivez Google Analytics (optionnel)
5. Cliquez sur "Créer le projet"

### 2. Ajouter l'Application Android

1. Dans la console Firebase, cliquez sur l'icône Android
2. **Nom du package Android** : `org.revlibertaire.rev_libertaire`
   - Trouvez-le dans `android/app/build.gradle` → `applicationId`
3. **Surnom de l'app** : Revlibertaire
4. Cliquez sur "Enregistrer l'application"

### 3. Télécharger google-services.json

1. Téléchargez le fichier `google-services.json`
2. Placez-le dans : `android/app/google-services.json`

### 4. Configurer les Fichiers Android

#### A. `android/build.gradle`

Ajoutez dans `dependencies` (section `buildscript`) :

```gradle
buildscript {
    dependencies {
        // ... autres dépendances
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

#### B. `android/app/build.gradle`

Ajoutez à la fin du fichier :

```gradle
apply plugin: 'com.google.gms.google-services'
```

### 5. Mettre à Jour firebase_options.dart

Remplacez les valeurs dans `lib/firebase_options.dart` :

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'VOTRE_API_KEY',              // De google-services.json
  appId: 'VOTRE_APP_ID',                // De google-services.json
  messagingSenderId: 'VOTRE_SENDER_ID', // De google-services.json
  projectId: 'VOTRE_PROJECT_ID',        // De google-services.json
  storageBucket: 'VOTRE_STORAGE_BUCKET',// De google-services.json
);
```

**Où trouver ces valeurs ?**

Ouvrez `google-services.json` et cherchez :
- `api_key` → `current_key`
- `mobilesdk_app_id`
- `project_number` (c'est le messagingSenderId)
- `project_id`
- `storage_bucket`

### 6. Ajouter les Permissions Android

Dans `android/app/src/main/AndroidManifest.xml`, ajoutez :

```xml
<!-- Permissions pour les notifications -->
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
```

### 7. Tester les Notifications

#### A. Compiler l'application

```bash
flutter clean
flutter pub get
flutter build apk --release
```

#### B. Installer sur un appareil réel

```bash
flutter install
```

#### C. Envoyer une notification de test

1. Dans la console Firebase, allez dans **Cloud Messaging**
2. Cliquez sur "Envoyer votre premier message"
3. **Titre** : "Test Revlibertaire"
4. **Texte** : "Notification de test"
5. Cliquez sur "Suivant"
6. **Cible** : Sélectionnez votre app
7. Cliquez sur "Suivant" puis "Vérifier" et "Publier"

## 📱 Utilisation des Topics

L'application s'abonne automatiquement à 2 topics :

1. **`nouveaux_articles`** - Pour les nouveaux articles
2. **`evenements`** - Pour les événements militants

### Envoyer une Notification à un Topic

Dans la console Firebase :
1. Cloud Messaging → Nouveau message
2. Remplissez le titre et le texte
3. Dans "Cible", sélectionnez "Topic"
4. Entrez : `nouveaux_articles` ou `evenements`
5. Envoyez !

## 🔧 Configuration Avancée

### Personnaliser les Topics

Dans `lib/main.dart`, modifiez :

```dart
await notificationService.subscribeToTopic('votre_topic');
```

### Gérer les Clics sur Notifications

Dans `lib/services/notification_service.dart`, modifiez :

```dart
FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  // Navigation personnalisée
  String? articleUrl = message.data['url'];
  if (articleUrl != null) {
    // Ouvrir l'article
  }
});
```

## 🚀 Backend pour Envoyer des Notifications

### Option 1 : Console Firebase (Manuel)

Utilisez la console Firebase pour envoyer manuellement.

### Option 2 : API REST (Automatique)

Créez un script backend pour envoyer automatiquement :

```bash
curl -X POST https://fcm.googleapis.com/fcm/send \
  -H "Authorization: key=VOTRE_SERVER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "to": "/topics/nouveaux_articles",
    "notification": {
      "title": "Nouvel article",
      "body": "Un nouvel article est disponible !",
      "click_action": "FLUTTER_NOTIFICATION_CLICK"
    },
    "data": {
      "url": "https://revlibertaire.unionlibertaireanarchiste.org/article"
    }
  }'
```

**Server Key** : Console Firebase → Paramètres du projet → Cloud Messaging → Clé du serveur

### Option 3 : WordPress Plugin

Si le site utilise WordPress, installez un plugin comme :
- **OneSignal**
- **Firebase Push Notifications**

## ⚠️ Mode Sans Firebase

Si vous ne voulez pas configurer Firebase maintenant :

1. Commentez l'initialisation dans `lib/main.dart` :

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Commentez tout le bloc Firebase
  /*
  try {
    await Firebase.initializeApp(...);
    ...
  } catch (e) {
    ...
  }
  */
  
  runApp(const RevLibertaireApp());
}
```

2. L'application fonctionnera sans notifications

## ✅ Vérification

Pour vérifier que tout fonctionne :

1. Lancez l'app : `flutter run`
2. Regardez les logs :
   - ✅ "Notifications autorisées"
   - 📱 "Token FCM: ..."
   - ✅ "Abonné au topic: nouveaux_articles"

3. Envoyez une notification de test depuis Firebase

## 🆘 Problèmes Courants

### "google-services.json not found"

→ Vérifiez que le fichier est dans `android/app/`

### "Default FirebaseApp is not initialized"

→ Vérifiez que `Firebase.initializeApp()` est appelé dans `main()`

### Notifications ne s'affichent pas

→ Vérifiez les permissions dans AndroidManifest.xml
→ Testez sur un appareil réel (pas l'émulateur)

## 📚 Ressources

- Documentation Firebase : https://firebase.google.com/docs/cloud-messaging
- FlutterFire : https://firebase.flutter.dev

---

**🚩 Notifications configurées pour la révolution numérique ! ✊**
