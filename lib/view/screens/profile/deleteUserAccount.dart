import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jwh_01/common/my_button.dart';
import 'package:jwh_01/route.dart';
import 'package:jwh_01/viewmodel/user_vm.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DeleteUserAccount extends ConsumerStatefulWidget {
  const DeleteUserAccount({super.key});

  @override
  ConsumerState<DeleteUserAccount> createState() => _DeleteUserAccountState();
}

class _DeleteUserAccountState extends ConsumerState<DeleteUserAccount> {
  late TextEditingController passwordController;
  bool _isObscure = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    passwordController = TextEditingController();
  }

  void _changeObsure() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  Future<void> reauthenticationAndDeleteUser(String password) async {
    if (password.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      final result = await ref
          .read(UserVmProvider.notifier)
          .deleteUserAccount(password);
      if (result && mounted) {
        final router = ref.read(myRouterProvider);
        router.go('/SignUpScreen');
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      Fluttertoast.showToast(
        msg: "비밀번호를 입력해주세요.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: const Text('회원탈퇴'),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 2.h),
                      Text(
                        "회원탈퇴를 위해서 비밀번호를 입력해주세요.",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 4.h),
                      TextField(
                        controller: passwordController,
                        style: TextStyle(fontSize: 18.sp),
                        obscureText: _isObscure, // ✅ 비밀번호 숨김
                        decoration: InputDecoration(
                          labelText: "비밀번호",
                          labelStyle: TextStyle(fontSize: 18.sp),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon:
                                _isObscure
                                    ? FaIcon(FontAwesomeIcons.eye)
                                    : FaIcon(FontAwesomeIcons.eyeSlash),
                            onPressed: _changeObsure,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      GestureDetector(
                        onTap:
                            () => reauthenticationAndDeleteUser(
                              passwordController.text,
                            ),
                        child: Center(
                          child: MyButton(text: "탈퇴하기", isEnabled: true),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_isLoading)
            // ③ 로딩 배경 (사용자의 다른 조작 방지)
            const Opacity(
              opacity: 0.5, // 배경을 반투명하게 만듦
              // ModalBarrier가 dismissible: false 이므로, 이 위에 탭 이벤트가 발생해도
              // ModalBarrier가 이벤트를 막고, GestureDetector의 onTap이 실행됩니다.
              child: ModalBarrier(dismissible: false, color: Colors.black),
            ),
          if (_isLoading)
            // ④ 로딩 인디케이터
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
