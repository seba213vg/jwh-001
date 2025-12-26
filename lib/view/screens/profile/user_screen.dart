import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:jwh_01/common/route_helper.dart';
import 'package:jwh_01/model/auth_model.dart';
import 'package:jwh_01/view/screens/profile/deleteUserAccount.dart';
import 'package:jwh_01/view/screens/profile/profile_info.dart';
import 'package:jwh_01/viewmodel/sign_up_vm.dart';
import 'package:jwh_01/viewmodel/user_vm.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class UserScreen extends ConsumerWidget {
  UserScreen({super.key});

  String url = 'https://omiz124.blogspot.com/p/c-sdk.html';

  void _profileInfo(BuildContext context) {
    Navigator.of(context).push(createSlideRoute(const ProfileInfo()));
  }

  void _deleteUserAccount(BuildContext context) {
    Navigator.of(context).push(createSlideRoute(const DeleteUserAccount()));
  }

  Future<void> _launchURL() async {
    final uri = Uri.parse(url);

    if (!await launchUrl(uri)) {
      // URL 오류 처리 필요시 context 전달받아 처리
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(SignUpVmProvider, (previous, next) {
      if (next.status == AuthStatus.idle) {
        context.go('/LogInScreen');
      }
    });

    final userAsync = ref.watch(UserVmProvider);

    return userAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) {
        // 에러 발생 시 로그아웃 처리
        ref.read(SignUpVmProvider.notifier).whenDeleteUserAccount();
        return Center(child: Text('데이터 로드 오류: $error'));
      },
      data: (user) {
        if (user.uid.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          appBar: AppBar(title: const Text("프로피-루")),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _profileInfo(context),
                  child: Text("사용자 정보", style: TextStyle(fontSize: 18.sp)),
                ),
                SizedBox(height: 2.h),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("알림받기", style: TextStyle(fontSize: 18.sp)),
                        CupertinoSwitch(
                          value: user.notification,
                          onChanged: (value) {
                            ref.read(UserVmProvider.notifier).updateUserProfile(
                              {"notification": value},
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("글자크기", style: TextStyle(fontSize: 18.sp)),
                        SizedBox(width: 3.w),
                        SegmentedButton<textsize>(
                          segments: <ButtonSegment<textsize>>[
                            ButtonSegment(
                              value: textsize.small,
                              label: Text(
                                '작게',
                                style: TextStyle(fontSize: 16.sp),
                              ),
                              icon: const Icon(
                                Icons.text_fields_sharp,
                                size: 12,
                              ),
                            ),
                            ButtonSegment(
                              value: textsize.medium,
                              label: Text(
                                '보통',
                                style: TextStyle(fontSize: 16.sp),
                              ),
                              icon: const Icon(
                                Icons.text_fields_sharp,
                                size: 16,
                              ),
                            ),
                            ButtonSegment(
                              value: textsize.large,
                              label: Text(
                                '크게',
                                style: TextStyle(fontSize: 16.sp),
                              ),
                              icon: const Icon(
                                Icons.text_fields_sharp,
                                size: 20,
                              ),
                            ),
                          ],
                          selected: <textsize>{_getTextsizeEnum(user.textsize)},
                          onSelectionChanged: (Set<textsize> newSelection) {
                            final newTextsize = _getTextsizeValue(
                              newSelection.first,
                            );
                            ref.read(UserVmProvider.notifier).updateUserProfile(
                              {'textsize': newTextsize},
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "단어카드의 글자 크기를 조절합니다",
                      style: TextStyle(fontSize: 18 * user.textsize),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                GestureDetector(
                  onTap: _launchURL,
                  child: Text("개인정보보호방침", style: TextStyle(fontSize: 18.sp)),
                ),
                SizedBox(height: 2.h),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(createSlideRoute(LicensePage()));
                  },
                  child: Text("오픈소스 라이선스", style: TextStyle(fontSize: 18.sp)),
                ),
                SizedBox(height: 2.h),
                ListTile(
                  title: Text(
                    "로그아웃",
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("로그아웃 하시곘습니까?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                "아니요",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed:
                                  () =>
                                      ref
                                          .read(SignUpVmProvider.notifier)
                                          .logOut(),
                              child: Text(
                                "네",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    "회원탈퇴",
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("회원탈퇴 하시곘습니까?"),
                          content: const Text('탈퇴하시면 계정 내에 모든 정보가 삭제됩니다.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                "아니요",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                _deleteUserAccount(context);
                              },
                              child: Text(
                                "네",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  textsize _getTextsizeEnum(double value) {
    if (value < 1.15) return textsize.small;
    if (value < 1.45) return textsize.medium;
    return textsize.large;
  }

  double _getTextsizeValue(textsize size) {
    switch (size) {
      case textsize.small:
        return 1.0;
      case textsize.medium:
        return 1.3;
      case textsize.large:
        return 1.6;
    }
  }
}

enum textsize { small, medium, large }
