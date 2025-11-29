import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwh_01/repository/user_repo.dart';

class NotificationsProvider extends AsyncNotifier {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final UserRepository _userRepo = UserRepository();

  @override
  FutureOr build() async {
    final token = await _messaging.getToken();
    if (token == null) return;
    await _userRepo.updateToken(token);
    _messaging.onTokenRefresh.listen((newToken) async {
      await _userRepo.updateToken(newToken);
    });
  }
}

final notificationsProvider = AsyncNotifierProvider(
  () => NotificationsProvider(),
);
