import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwh_01/repository/auth_repo.dart';
import 'package:jwh_01/repository/bookmark_repo.dart';

class BookmarkViewModel extends Notifier<void> {
  late AuthRepository _authRepo;
  late BookmarkRepository _bookmarkRepo;

  @override
  void build() {
    _bookmarkRepo = ref.read(bookmarkRepoProvider);
    _authRepo = ref.read(authRepoProvider);
  }

  Future<String> addBookmark(Map<String, dynamic> wordData) async {
    try {
      if (_authRepo.isLoggedIn) {
        final userId = _authRepo.user!.uid;
        await _bookmarkRepo.addBookmark(wordData, userId);
        return "북마크 추가 성공";
      } else {
        return "로그인이 필요해요";
      }
    } catch (e) {
      return "에러: ${e.toString()}";
    }
  }

  Future<String> removeBookmark(String docId) async {
    try {
      if (_authRepo.isLoggedIn) {
        final userId = _authRepo.user!.uid;
        await _bookmarkRepo.removeBookmark(userId, docId);
        return "북마크 삭제 성공";
      } else {
        return "로그인이 필요해요";
      }
    } catch (e) {
      return "에러: ${e.toString()}";
    }
  }
}

final bookmarkVmProvider = NotifierProvider<BookmarkViewModel, void>(
  () => BookmarkViewModel(),
);
