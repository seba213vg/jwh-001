import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:jwh_01/common/my_button.dart';
import 'package:jwh_01/model/auth_model.dart';
import 'package:jwh_01/viewmodel/sign_up_vm.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:text_field_validator/text_field_validator.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  bool _isObscure = true;
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final String _password = '';

  @override
  void initState() {
    super.initState();
  }

  void _onTabLogIn() {
    context.push('/LogInScreen');
  }

  void _onConfirmTap() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        ref
            .read(SignupInfo.notifier)
            .update(
              (state) => {
                ...state,
                'email': _formData['email']!,
                'password': _formData['password']!,
                'name': _formData['name']!,
              },
            );
        print(ref.read(SignupInfo));
        ref.read(SignUpVmProvider.notifier).signUp();
      }
    }
  }

  void _changeObsure() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authstate = ref.watch(SignUpVmProvider);

    ref.listen(SignUpVmProvider, (previous, next) {
      if (next.status == AuthStatus.success) {
        context.go('/home');
      }

      if (next.status == AuthStatus.error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error!)));
      }
    });
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          Text(
                            "회원가입하기",
                            style: TextStyle(
                              fontSize: 26.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 4.h),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              style: TextStyle(fontSize: 20.sp),
                              decoration: InputDecoration(
                                labelText: "이름",
                                border: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              validator: (value) {
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              onSaved: (newValue) {
                                _formData["name"] = newValue!;
                              },
                            ),

                            SizedBox(height: 5.h),
                            TextFormField(
                              style: TextStyle(fontSize: 20.sp),
                              decoration: InputDecoration(
                                labelText: "이메일",
                                border: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              validator: (value) {
                                return TextFieldValidator.emailValidator(
                                  email: value,
                                  invalidEmailErrorMessage: "잘못된 이메일이에요",
                                );
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              onSaved: (newValue) {
                                _formData["email"] = newValue!;
                              },
                            ),
                            SizedBox(height: 5.h),
                            TextFormField(
                              controller: passwordController,
                              style: TextStyle(fontSize: 20.sp),
                              obscureText: _isObscure,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                labelText: "비밀번호",
                                border: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: _changeObsure,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child:
                                            _isObscure
                                                ? FaIcon(FontAwesomeIcons.eye)
                                                : FaIcon(
                                                  FontAwesomeIcons.eyeSlash,
                                                ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              validator: (value) {
                                return TextFieldValidator.passWordValidator(
                                  password: value,
                                  lowercaseErrorMessage:
                                      "대문자와 소문자를 모두 포함하는 비밀번호를 설정해주세요",
                                  numberErrorMessage: "숫자를 포함하는 비밀번호를 설정해주세요",
                                  uppercaseErrorMessage:
                                      "대문자와 소문자를 모두 포함하는 비밀번호를 설정해주세요",
                                  invalidPasswordErrorMessage: "잘못된 비밀번호예요",
                                  minPasswordLengthErrorMessage:
                                      "8글자 이상 비밀번호를 설정해주세요",
                                  specialCharactersRequired: false,
                                );
                              },
                              onSaved: (newValue) {
                                _formData["password"] = newValue!;
                              },
                            ),
                            SizedBox(height: 5.h),
                            TextFormField(
                              controller: confirmPasswordController,
                              style: TextStyle(fontSize: 20.sp),
                              obscureText: _isObscure,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                labelText: "비밀번호확인",
                                border: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: _changeObsure,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child:
                                            _isObscure
                                                ? FaIcon(FontAwesomeIcons.eye)
                                                : FaIcon(
                                                  FontAwesomeIcons.eyeSlash,
                                                ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '비밀번호 확인을 입력하세요';
                                }
                                if (value != passwordController.text) {
                                  return '비밀번호가 일치하지 않습니다';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 5.h),
                      GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          _onConfirmTap();
                        },
                        child: Align(
                          alignment: Alignment(0, 0),
                          child: MyButton(text: "회원가입", isEnabled: true),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: _onTabLogIn,
                            child: Text(
                              "로그인하기",
                              style: TextStyle(
                                fontSize: 19.sp,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (authstate.status == AuthStatus.loading)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.4),
                        child: Center(child: CircularProgressIndicator()),
                      ),
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
