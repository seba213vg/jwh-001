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

class UserScreen extends ConsumerStatefulWidget {
  const UserScreen({super.key});

  @override
  ConsumerState<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends ConsumerState<UserScreen> {
  bool _isVolumeSliding = false;
  bool _isTextsizeSliding = false;
  double _volume = 1.0;
  double _textsize = 1.0;
  String url = 'https://omiz124.blogspot.com/p/c-sdk.html';

  void _profileInfo() {
    Navigator.of(context).push(createSlideRoute(const ProfileInfo()));
  }

  void _deleteUserAccount() {
    Navigator.of(context).push(createSlideRoute(const DeleteUserAccount()));
  }

  Future<void> _launchURL() async {
    final uri = Uri.parse(url);

    if (!await launchUrl(uri)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('링크를 열 수 없습니다'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(SignUpVmProvider, (previous, next) {
      if (next.status == AuthStatus.idle) {
        context.go('/SignUpScreen');
      }
    });
    final user = ref.watch(UserVmProvider).value;
    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final uid = user.uid;
    return StreamBuilder<DocumentSnapshot>(
      stream:
          FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // 2. 🟢 에러 확인
        if (snapshot.hasError) {
          // 에러 발생 시 로그아웃 처리 및 메시지 반환
          ref.read(SignUpVmProvider.notifier).whenDeleteUserAccount();
          // snapshot.error는 Null일 수 있으므로 안전하게 처리
          return Text('데이터 로드 오류가 발생했습니다. 다시 로그인 해주세요: ${snapshot.error}');
        }

        // 3. 🚨 문서 존재 여부 확인 (탈퇴된 계정 처리)
        // 이 시점에서 snapshot.data는 반드시 null이 아니며, DocumentSnapshot 타입이 보장됨.
        if (!snapshot.data!.exists) {
          // 회원 탈퇴 등으로 문서가 삭제되었을 때
          ref.read(SignUpVmProvider.notifier).whenDeleteUserAccount();
          return const Text('사용자 정보가 없습니다. 다시 로그인 해주세요.');
        }
        var data = snapshot.data!.data() as Map<String, dynamic>;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final rawVolume = data['volume'];
          final newVolume =
              (rawVolume is int)
                  ? rawVolume.toDouble()
                  : (rawVolume is double)
                  ? rawVolume
                  : 1.0;
          if (!_isVolumeSliding && _volume != newVolume) {
            setState(() {
              _volume = newVolume;
            });
          }

          final rawSize = data['textsize'];
          final newSize =
              (rawSize is int)
                  ? rawSize.toDouble()
                  : (rawSize is double)
                  ? rawSize
                  : 1.0;
          if (!_isTextsizeSliding && _textsize != newSize) {
            setState(() {
              _textsize = newSize;
            });
          }
        });
        // return
        // ref
        //     .watch(UserVmProvider)
        //     .when(
        //       error: (error, stackTrace) => Text("something went wrong $error"),
        //       loading: () => Center(child: CircularProgressIndicator()),
        //       data: (data) {
        return Scaffold(
          appBar: AppBar(title: Text("프로피-루")),
          body: Column(
            children: [
              GestureDetector(
                onTap: _profileInfo,
                child: ListTile(
                  title: Text("사용자 정보", style: TextStyle(fontSize: 18.sp)),
                ),
                /*Container(
                  padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
                  height: 15.h,
                  width: 90.w,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 2.w),
                      CircleAvatar(
                        radius: 4.h,
                        foregroundImage:
                            data['photoUrl'] != 'undefined'
                                ? NetworkImage(data['photoUrl'])
                                : null,
                        backgroundColor:
                            Theme.of(context).colorScheme.secondaryContainer,
                        child: Text('-', style: TextStyle(fontSize: 30.sp)),
                      ),
                      
                      SizedBox(width: 6.w),
                      Text(
                        data['name'],
                        style: TextStyle(
                          fontSize: 23.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 36.w),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.chevronRight,
                            size: 18.sp,
                            color: Theme.of(context).colorScheme.primaryFixed,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),*/
              ),

              ListTile(
                title: Text("알림받기", style: TextStyle(fontSize: 18.sp)),
                trailing: CupertinoSwitch(
                  value: ref.watch(UserVmProvider).value!.notification,
                  onChanged: (value) {
                    ref.read(UserVmProvider.notifier).updateUserProfile({
                      "notification": value,
                    });
                  },
                ),
              ),

              ListTile(
                title: Text("볼륨조절", style: TextStyle(fontSize: 18.sp)),
                subtitle: Slider(
                  value: _volume,
                  min: 0.0,
                  max: 1.0,
                  divisions: 100,
                  onChangeStart: (_) {
                    _isVolumeSliding = true;
                  },
                  onChanged: (value) {
                    setState(() {
                      _volume = value;
                    });
                  },
                  onChangeEnd: (value) async {
                    _isVolumeSliding = false;
                    await ref.read(UserVmProvider.notifier).updateUserProfile({
                      'volume': value,
                    });
                  },
                ),
              ),

              ListTile(
                title: Text("글자크기 조절", style: TextStyle(fontSize: 18.sp)),
                subtitle: Slider(
                  value: _textsize,
                  min: 1.0,
                  max: 2.0,
                  divisions: 100,
                  onChangeStart: (_) {
                    _isTextsizeSliding = true;
                  },
                  onChanged: (value) {
                    setState(() {
                      _textsize = value;
                    });
                  },
                  onChangeEnd: (value) async {
                    _isTextsizeSliding = false;
                    await ref.read(UserVmProvider.notifier).updateUserProfile({
                      'textsize': value,
                    });
                  },
                ),
              ),

              ListTile(
                onTap: _launchURL,
                title: Text("개인정보보호방침", style: TextStyle(fontSize: 18.sp)),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(createSlideRoute(LicensePage()));
                },
                title: Text("오픈소스 라이선스", style: TextStyle(fontSize: 18.sp)),
              ),
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
                        title: Text("로그아웃 하시곘습니까?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              "아니요",
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: Theme.of(context).colorScheme.secondary,
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
                                color: Theme.of(context).colorScheme.secondary,
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
                        title: Text("회원탈퇴 하시곘습니까?"),
                        content: const Text('탈퇴하시면 계정 내에 모든 정보가 삭제됩니다.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              "아니요",
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _deleteUserAccount();
                            },
                            child: Text(
                              "네",
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: Theme.of(context).colorScheme.secondary,
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
        );
      },
    );
  }
}
