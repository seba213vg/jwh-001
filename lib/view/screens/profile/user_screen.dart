import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:jwh_01/model/auth_model.dart';
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
  String url =
      'https://doc-hosting.flycricket.io/hangeulro-baeuneun-ilboneo-omijeugudasai-privacy-policy/5bac7b1b-530f-4e8f-ad64-884f90d165ce/privacy';

  void _profileInfo() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => ProfileInfo()));
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
        if (!snapshot.hasData) return CircularProgressIndicator();
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
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => LicensePage()));
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
            ],
          ),
        );
      },
    );
  }
}
