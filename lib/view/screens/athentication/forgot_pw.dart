import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Toast 패키지 추가
import 'package:jwh_01/common/my_button.dart';
import 'package:jwh_01/model/auth_model.dart';
import 'package:jwh_01/viewmodel/sign_up_vm.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ForgotPassword extends ConsumerWidget {
  ForgotPassword({super.key});
  final TextEditingController emailController = TextEditingController();
  final String _email = '';

  void _sendPasswordResetEmail(String email, WidgetRef ref) {
    print(email);
    if (email.isNotEmpty) {
      ref.read(SignUpVmProvider.notifier).sendPasswordResetEmail(email);

      Fluttertoast.showToast(
        msg: "비밀번호 재설정 이메일이 전송되었습니다.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      Fluttertoast.showToast(
        msg: "이메일을 입력해주세요.",
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
  Widget build(BuildContext context, WidgetRef ref) {
    final authstate = ref.watch(SignUpVmProvider);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('비밀번호 재설정'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Stack(
                children: [
                  if (authstate.status == AuthStatus.loading)
                    Center(child: CircularProgressIndicator()),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 2.h),

                      Text(
                        "이메일 주소를 입력하면 비밀번호 재설정 링크를 보내드립니다.",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey[600],
                        ),
                      ),

                      SizedBox(height: 4.h),
                      TextField(
                        controller: emailController,
                        style: TextStyle(fontSize: 18.sp),
                        decoration: InputDecoration(
                          labelText: "이메일",
                          labelStyle: TextStyle(fontSize: 18.sp),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      GestureDetector(
                        onTap:
                            () => _sendPasswordResetEmail(
                              emailController.text.trim(),
                              ref,
                            ),
                        child: Center(
                          child: MyButton(text: "이메일보내기", isEnabled: true),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
