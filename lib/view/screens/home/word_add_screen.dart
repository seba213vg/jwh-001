import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwh_01/common/my_button.dart';
import 'package:jwh_01/viewmodel/word_add_vm.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class WordAddScreen extends ConsumerStatefulWidget {
  const WordAddScreen({super.key});

  @override
  ConsumerState<WordAddScreen> createState() => _WordAddScreenState();
}

class _WordAddScreenState extends ConsumerState<WordAddScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, String> _formData = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _addWord() async {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        ref.read(addedWord.notifier).state = {
          'title': _formData['title']!,
          'mean': _formData['mean']!,
          'description1': _formData['description1'] ?? '',
          'description2': _formData['description2'] ?? '',
          'exam1': _formData['exam1'] ?? '',
          'exam2': _formData['exam2'] ?? '',
          'exam3': _formData['exam3'] ?? '',
          'exam4': _formData['exam4'] ?? '',
        };

        final result = await ref.read(wordAddVmProvider.notifier).addWord();

        Fluttertoast.showToast(
          msg: result,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(title: Text('탄고 츠이카')),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 1.h),

                Row(
                  children: [
                    Text(
                      "단어추가하기",
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 1.h),
                Text(
                  "추가한 단어는 단어탭에서 확인할 수 있어요",
                  style: TextStyle(fontSize: 17.sp, color: Colors.grey[400]),
                ),
                SizedBox(height: 1.h),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 2.h,
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          style: TextStyle(fontSize: 18.sp),
                          decoration: InputDecoration(
                            labelText: "단어",
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return '단어를 입력해주세요';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _formData['title'] = value ?? '';
                          },
                        ),
                        SizedBox(height: 3.h),
                        TextFormField(
                          style: TextStyle(fontSize: 18.sp),
                          decoration: InputDecoration(
                            labelText: "뜻",
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return '뜻을 입력해주세요';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _formData['mean'] = value?.trim() ?? '';
                          },
                        ),
                        SizedBox(height: 3.h),
                        TextFormField(
                          style: TextStyle(fontSize: 18.sp),
                          decoration: InputDecoration(
                            labelText: "추가설명1",
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onSaved: (value) {
                            _formData['description1'] = value?.trim() ?? '';
                          },
                        ),
                        SizedBox(height: 3.h),
                        TextFormField(
                          style: TextStyle(fontSize: 18.sp),
                          decoration: InputDecoration(
                            labelText: "추가설명2",
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onSaved: (value) {
                            _formData['description2'] = value?.trim() ?? '';
                          },
                        ),
                        SizedBox(height: 3.h),
                        TextFormField(
                          style: TextStyle(fontSize: 18.sp),
                          decoration: InputDecoration(
                            labelText: "예문1",
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onSaved: (value) {
                            _formData['exam1'] = value?.trim() ?? '';
                          },
                        ),
                        SizedBox(height: 3.h),
                        TextFormField(
                          style: TextStyle(fontSize: 18.sp),
                          decoration: InputDecoration(
                            labelText: "예문1 뜻",
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onSaved: (value) {
                            _formData['exam2'] = value?.trim() ?? '';
                          },
                        ),
                        SizedBox(height: 3.h),
                        TextFormField(
                          style: TextStyle(fontSize: 18.sp),
                          decoration: InputDecoration(
                            labelText: "예문2",
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onSaved: (value) {
                            _formData['exam3'] = value?.trim() ?? '';
                          },
                        ),
                        SizedBox(height: 3.h),
                        TextFormField(
                          style: TextStyle(fontSize: 18.sp),
                          decoration: InputDecoration(
                            labelText: "예문2 뜻",
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onSaved: (value) {
                            _formData['exam4'] = value?.trim() ?? '';
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 2.h),
                GestureDetector(
                  onTap: () {
                    _addWord();
                  },
                  child: Align(
                    alignment: Alignment(0, 0),
                    child: MyButton(text: "추가하기", isEnabled: true),
                  ),
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
