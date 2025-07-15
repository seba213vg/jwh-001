import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      ScaffoldMessenger.of(
        ref.context,
      ).showSnackBar(SnackBar(content: Text('비밀번호 재설정 이메일이 전송되었습니다.')));
    } else {
      ScaffoldMessenger.of(
        ref.context,
      ).showSnackBar(SnackBar(content: Text('이메일을 입력해주세요.')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authstate = ref.watch(SignUpVmProvider);
    return GestureDetector(
      onTap: () => Focus.of(context).unfocus(),
      child: Scaffold(
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
                      SizedBox(height: 5.h),

                      Row(
                        children: [
                          Text(
                            "비밀번호 재설정",
                            style: TextStyle(
                              fontSize: 26.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 4.h),
                      TextField(
                        controller: emailController,
                        style: TextStyle(fontSize: 20.sp),
                        decoration: InputDecoration(
                          labelText: "이메일",
                          labelStyle: TextStyle(fontSize: 20.sp),
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
                        child: MyButton(text: "이메일보내기", isEnabled: true),
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
