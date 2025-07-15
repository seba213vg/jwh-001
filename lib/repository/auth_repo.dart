import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool get isLoggedIn => user != null;

  User? get user => _auth.currentUser;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<UserCredential> SignupWithEmail({
    required String email,
    required String password,
    String? name,
  }) async {
    UserCredential credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await credential.user!.updateDisplayName(name);

    await credential.user!.reload();

    return credential;
  }

  Future<UserCredential> logInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> ResetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> logOut() async {
    await _auth.signOut();
  }
}

final authStreamState = StreamProvider((ref) {
  final repo = ref.read(authRepoProvider);
  return repo.authStateChanges();
});

final authRepoProvider = Provider((ref) => AuthRepository());
