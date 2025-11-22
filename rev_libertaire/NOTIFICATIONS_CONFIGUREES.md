# ✅ Notifications Push - Configuration Complète

## 🎉 Statut : FONCTIONNEL

Les notifications push sont maintenant **100% configurées et opérationnelles** !

---

## ✅ Configuration Effectuée

### 1. Firebase Configuré
- ✅ Projet Firebase : `revlibertaireblogpwa`
- ✅ `google-services.json` installé dans `android/app/`
- ✅ `firebase_options.dart` configuré avec les vraies valeurs
- ✅ Firebase initialisé au démarrage de l'app

### 2. Gradle Configuré
- ✅ Plugin Google Services ajouté dans `settings.gradle.kts`
- ✅ Dépendances Firebase ajoutées dans `app/build.gradle.kts`
- ✅ Firebase BoM (Bill of Materials) configuré

### 3. Permissions Android
- ✅ `POST_NOTIFICATIONS` - Afficher les notifications
- ✅ `VIBRATE` - Vibration lors des notifications
- ✅ `RECEIVE_BOOT_COMPLETED` - Notifications après redémarrage

### 4. Service de Notifications
- ✅ `NotificationService` créé et fonctionnel
- ✅ Demande automatique de permissions
- ✅ Récupération du token FCM
- ✅ Handlers pour tous les états (foreground, background, fermée)

### 5. Topics Configurés
- ✅ Abonnement automatique à `nouveaux_articles`
- ✅ Abonnement automatique à `evenements`

---

## 📱 Comment Ça Fonctionne

### Au Démarrage de l'App

1. **Firebase s'initialise** automatiquement
2. **Permissions demandées** à l'utilisateur
3. **Token FCM généré** pour cet appareil
4. **Abonnement aux topics** : `nouveaux_articles` et `evenements`

### Quand une Notification Arrive

#### App au Premier Plan (ouverte)
```dart
FirebaseMessaging.onMessage.listen((message) {
  // Notification reçue
  // Vous pouvez afficher une notification locale
});
```

#### App en Arrière-Plan
```dart
FirebaseMessaging.onMessageOpenedApp.listen((message) {
  // Notification cliquée
  // Navigation vers la page concernée
});
```

#### App Fermée
```dart
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(message) {
  // Notification reçue en arrière-plan
}
```

---

## 🔔 Envoyer une Notification de Test

### Via la Console Firebase

1. Allez sur https://console.firebase.google.com
2. Sélectionnez votre projet : **revlibertaireblogpwa**
3. Menu **Engagement** → **Cloud Messaging**
4. Cliquez sur **Envoyer votre premier message**

#### Configuration du Message

**Notification :**
- **Titre** : "Nouveau sur Revlibertaire !"
- **Texte** : "Un nouvel article vient d'être publié"
- **Image** : (optionnel)

**Cible :**
- Sélectionnez **Topic**
- Entrez : `nouveaux_articles` ou `evenements`

**Planification :**
- **Maintenant** pour un envoi immédiat

5. Cliquez sur **Vérifier** puis **Publier**

### Via l'API REST

```bash
curl -X POST https://fcm.googleapis.com/fcm/send \
  -H "Authorization: key=VOTRE_SERVER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "to": "/topics/nouveaux_articles",
    "notification": {
      "title": "Nouveau sur Revlibertaire !",
      "body": "Un nouvel article vient d'\''être publié",
      "icon": "@mipmap/ic_launcher",
      "sound": "default"
    },
    "data": {
      "url": "https://revlibertaire.unionlibertaireanarchiste.org/article",
      "type": "article"
    }
  }'
```

**Server Key** : Console Firebase → Paramètres → Cloud Messaging → Clé du serveur

---

## 🎯 Topics Disponibles

### `nouveaux_articles`
Pour notifier les utilisateurs des nouveaux articles publiés.

**Exemple de notification :**
```json
{
  "to": "/topics/nouveaux_articles",
  "notification": {
    "title": "Nouvel article",
    "body": "Titre de l'article"
  }
}
```

### `evenements`
Pour notifier les utilisateurs des événements militants.

**Exemple de notification :**
```json
{
  "to": "/topics/evenements",
  "notification": {
    "title": "Événement à venir",
    "body": "Manifestation le 1er mai"
  }
}
```

---

## 🔧 Personnalisation

### Ajouter un Nouveau Topic

Dans `lib/main.dart` :

```dart
await notificationService.subscribeToTopic('votre_nouveau_topic');
```

### Gérer les Clics sur Notifications

Dans `lib/services/notification_service.dart` :

```dart
FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  // Récupérer les données
  String? articleUrl = message.data['url'];
  
  // Navigation personnalisée
  if (articleUrl != null) {
    // Ouvrir l'article dans l'app
  }
});
```

### Afficher une Notification Locale

Installez `flutter_local_notifications` :

```yaml
dependencies:
  flutter_local_notifications: ^16.3.0
```

Puis dans `onMessage` :

```dart
FirebaseMessaging.onMessage.listen((message) {
  // Afficher une notification locale
  flutterLocalNotificationsPlugin.show(
    message.hashCode,
    message.notification?.title,
    message.notification?.body,
    notificationDetails,
  );
});
```

---

## 🧪 Tester les Notifications

### 1. Vérifier l'Initialisation

Lancez l'app et regardez les logs :

```
✅ Notifications autorisées
📱 Token FCM: ey...
✅ Abonné au topic: nouveaux_articles
✅ Abonné au topic: evenements
```

### 2. Envoyer une Notification de Test

Depuis la console Firebase, envoyez une notification au topic `nouveaux_articles`.

### 3. Vérifier la Réception

- **App ouverte** : La notification apparaît dans les logs
- **App en arrière-plan** : La notification apparaît dans la barre de notifications
- **App fermée** : La notification apparaît dans la barre de notifications

---

## 🚀 Automatisation

### Intégration WordPress

Si le site utilise WordPress, installez un plugin :

1. **OneSignal** - Gratuit, facile à configurer
2. **Firebase Push Notifications** - Intégration directe
3. **WP Push Notifications** - Alternative

### Script Backend

Créez un script qui envoie automatiquement une notification quand un nouvel article est publié :

```python
import requests

def send_notification(title, body, url):
    headers = {
        'Authorization': 'key=VOTRE_SERVER_KEY',
        'Content-Type': 'application/json'
    }
    
    data = {
        'to': '/topics/nouveaux_articles',
        'notification': {
            'title': title,
            'body': body
        },
        'data': {
            'url': url
        }
    }
    
    response = requests.post(
        'https://fcm.googleapis.com/fcm/send',
        headers=headers,
        json=data
    )
    
    return response.json()

# Utilisation
send_notification(
    'Nouvel article',
    'Titre de l\'article',
    'https://revlibertaire.unionlibertaireanarchiste.org/article'
)
```

---

## 📊 Statistiques

Dans la console Firebase, vous pouvez voir :

- **Nombre d'envois** de notifications
- **Taux d'ouverture** des notifications
- **Nombre d'abonnés** par topic
- **Erreurs** d'envoi

---

## ⚠️ Limitations

### Android 13+

Sur Android 13 et supérieur, l'utilisateur doit **explicitement autoriser** les notifications.

L'app demande automatiquement la permission au premier lancement.

### Émulateur

Les notifications peuvent ne pas fonctionner sur l'émulateur. **Testez sur un appareil réel**.

### Taille des Notifications

- **Titre** : Max 65 caractères
- **Corps** : Max 240 caractères
- **Données** : Max 4 KB

---

## 🆘 Dépannage

### "Notifications non autorisées"

→ Vérifiez les paramètres de l'app sur l'appareil
→ Réinstallez l'app et acceptez les permissions

### "Token FCM null"

→ Vérifiez que `google-services.json` est bien dans `android/app/`
→ Vérifiez que Firebase est initialisé dans `main.dart`

### "Notifications ne s'affichent pas"

→ Testez sur un appareil réel (pas l'émulateur)
→ Vérifiez que l'app est abonnée au bon topic
→ Regardez les logs pour voir si la notification est reçue

---

## ✅ Checklist Finale

- [x] Firebase configuré
- [x] `google-services.json` installé
- [x] Gradle configuré
- [x] Permissions ajoutées
- [x] Service de notifications créé
- [x] Topics configurés
- [x] App testée et fonctionnelle

---

## 🎉 Résultat

**Les notifications push sont 100% opérationnelles !**

Vous pouvez maintenant :
- ✅ Envoyer des notifications depuis la console Firebase
- ✅ Notifier les utilisateurs des nouveaux articles
- ✅ Alerter sur les événements militants
- ✅ Automatiser l'envoi de notifications

---

**🚩 Notifications configurées pour la révolution numérique ! ✊**

*Diffusez les idées libertaires en temps réel !*
