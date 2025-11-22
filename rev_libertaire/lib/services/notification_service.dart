import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Service de gestion des notifications push
class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Initialise Firebase et les notifications
  Future<void> initialize() async {
    try {
      // Demande la permission pour les notifications
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        if (kDebugMode) {
          print('✅ Notifications autorisées');
        }

        // Récupère le token FCM
        String? token = await _messaging.getToken();
        if (kDebugMode) {
          print('📱 Token FCM: $token');
        }

        // Configure les handlers de notifications
        _setupNotificationHandlers();
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur initialisation notifications: $e');
      }
    }
  }

  /// Configure les handlers pour les différents états de notification
  void _setupNotificationHandlers() {
    // Notification reçue quand l'app est au premier plan
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('📬 Notification reçue (foreground): ${message.notification?.title}');
      }
      // Vous pouvez afficher une notification locale ici
    });

    // Notification cliquée quand l'app est en arrière-plan
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('🔔 Notification cliquée (background): ${message.notification?.title}');
      }
      // Navigation vers l'article ou la page concernée
    });

    // Notification reçue quand l'app est fermée
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  /// S'abonne à un topic pour recevoir des notifications
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      if (kDebugMode) {
        print('✅ Abonné au topic: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur abonnement topic: $e');
      }
    }
  }

  /// Se désabonne d'un topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      if (kDebugMode) {
        print('✅ Désabonné du topic: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur désabonnement topic: $e');
      }
    }
  }

  /// Récupère le token FCM
  Future<String?> getToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur récupération token: $e');
      }
      return null;
    }
  }
}

/// Handler pour les notifications en arrière-plan
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    print('📬 Notification en arrière-plan: ${message.notification?.title}');
  }
}
