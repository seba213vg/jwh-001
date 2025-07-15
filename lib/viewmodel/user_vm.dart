import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwh_01/model/user_model.dart';
import 'package:jwh_01/repository/auth_repo.dart';
import 'package:jwh_01/repository/user_repo.dart';
import 'package:jwh_01/viewmodel/sign_up_vm.dart';

class UserViewModel extends AsyncNotifier<UserModel> {
  late UserRepository userRepo;
  late final AuthRepository _authRepo;

  @override
  FutureOr<UserModel> build() async {
    userRepo = ref.read(userRepoProvider);
    _authRepo = ref.read(authRepoProvider);

    if (_authRepo.isLoggedIn) {
      final userId = _authRepo.user!.uid;
      final profile = await userRepo.findProfile(userId);
      if (profile != null) {
        return UserModel.fromJson(profile);
      }
    }
    return UserModel.empty();
  }

  Future<void> CreateUser(UserCredential credential) async {
    state = AsyncValue.loading();
    final AdditionalUserInfo = ref.read(SignupInfo);
    final user = UserModel(
      name: credential.user!.displayName ?? AdditionalUserInfo['name']!,
      uid: credential.user!.uid,
      email: credential.user!.email ?? "anon@anon.co",
      bio: 'undefined',
      link: 'undefined',
      photoUrl: 'undefined',
      volume: 1.0,
      textsize: 1.0,
      notification: true,
    );

    await userRepo.createUser(user);
    state = AsyncValue.data(user);
  }

  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    //state = AsyncValue.loading();
    final userId = _authRepo.user!.uid;
    await userRepo.updateUser(userId, data);
    final updatedUser = await userRepo.findProfile(userId);
    if (updatedUser != null) {
      state = AsyncValue.data(UserModel.fromJson(updatedUser));
    } else {
      state = AsyncValue.error(
        'Failed to update user profile',
        StackTrace.current,
      );
    }
  }
}

final UserVmProvider = AsyncNotifierProvider<UserViewModel, UserModel>(
  () => UserViewModel(),
);
