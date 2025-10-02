import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwh_01/repository/add_word_repo.dart';
import 'package:jwh_01/repository/auth_repo.dart';
import 'package:jwh_01/repository/bookmark_repo.dart';

class WordAddVm extends AsyncNotifier<void> {
  late AuthRepository _authRepo;

  late AddWordRepository _addWordRepo;

  @override
  FutureOr<void> build() async {
    _addWordRepo = ref.read(addWordRepoProvider);
    _authRepo = ref.read(authRepoProvider);
    return;
  }

  Future<String> addWord() async {
    final wordData = ref.read(addedWord);
    try {
      if (_authRepo.isLoggedIn) {
        final userId = _authRepo.user!.uid;
        await _addWordRepo.addWord(wordData, userId);
        return "단어 추가 성공";
      } else {
        return "로그인이 필요해요";
      }
    } catch (e) {
      return "에러: ${e.toString()}";
    }
  }
}

final addedWord = StateProvider<Map<String, String>>(
  (ref) => {
    'title': '',
    'mean': '',
    'description1': '',
    'description2': '',
    'exam1': '',
    'exam2': '',
    'exam3': '',
    'exam4': '',
    'url1': '',
    'url2': '',
  },
);

final wordAddVmProvider = AsyncNotifierProvider<WordAddVm, void>(() {
  return WordAddVm();
});
