import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwh_01/viewmodel/user_vm.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfileInfo extends ConsumerWidget {
  const ProfileInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(UserVmProvider)
        .when(
          error: (error, stackTrace) => Text("something went wrong $error"),
          loading: () => Center(child: CircularProgressIndicator()),
          data: (data) {
            return SafeArea(
              child: Scaffold(
                body: Column(
                  children: [
                    SizedBox(height: 2.h),
                    /*
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                      width: double.infinity,
                      height: 23.h,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 2.h),
                          CircleAvatar(
                            radius: 4.h,
                            foregroundImage:
                                data.photoUrl != 'undefined'
                                    ? NetworkImage(data.photoUrl)
                                    : null,
                            backgroundColor:
                                Theme.of(
                                  context,
                                ).colorScheme.secondaryContainer,
                            child: Text("-", style: TextStyle(fontSize: 30.sp)),
                          ),
                          SizedBox(height: 3.h),
                          FilledButton(
                            onPressed: () {
                              // 버튼 클릭 시 동작
                            },
                            child: Text('프로필 사진 수정'),
                          ),

                          SizedBox(height: 1.h),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                    */
                    ListTile(
                      title: Text(
                        "이름 : ${data.name}",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),

                    ListTile(
                      title: Text(
                        "메일주소 : ${data.email}",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
  }
}
