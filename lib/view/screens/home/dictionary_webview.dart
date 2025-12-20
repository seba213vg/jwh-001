import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DictionaryWebview extends StatefulWidget {
  const DictionaryWebview({super.key});

  @override
  State<DictionaryWebview> createState() => _DictionaryWebviewState();
}

class _DictionaryWebviewState extends State<DictionaryWebview> {
  WebViewController? controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _startLoadingAfterAnimation();
    _initializeWebView();
  }

  Future<void> _startLoadingAfterAnimation() async {
    // 🚀 애니메이션 지속 시간만큼 기다립니다.
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> _initializeWebView() async {
    await _requestAllPermissions();

    controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (String url) {
                setState(() {
                  isLoading = true;
                });
              },
              onPageFinished: (String url) {
                setState(() {
                  isLoading = false;
                });
                _setupWebViewPermissions();
              },
              // URL 네비게이션 요청 처리
              onNavigationRequest: (NavigationRequest request) {
                final url = request.url;

                // intent:// 스킴 차단
                if (url.startsWith('intent://')) {
                  print('Blocked intent URL: $url');
                  // 음성 인식 버튼 클릭을 JavaScript로 처리
                  _handleVoiceIntent();
                  return NavigationDecision.prevent;
                }

                // 다른 커스텀 스킴들도 차단
                if (url.startsWith('market://') ||
                    url.startsWith('play://') ||
                    url.startsWith('app://')) {
                  print('Blocked custom scheme URL: $url');
                  return NavigationDecision.prevent;
                }

                return NavigationDecision.navigate;
              },
              // onPermissionRequest 제거 - 더 이상 지원되지 않음
            ),
          )
          ..enableZoom(true)
          ..setUserAgent(
            'Mozilla/5.0 (Linux; Android 10; SM-G973F) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36',
          )
          ..loadRequest(_buildDictionaryUrl());
  }

  // 개선된 권한 요청
  Future<void> _requestAllPermissions() async {
    try {
      // 먼저 현재 권한 상태 확인
      final microphoneStatus = await Permission.microphone.status;
      final speechStatus = await Permission.speech.status;

      print('현재 마이크 권한 상태: $microphoneStatus');
      print('현재 음성 인식 권한 상태: $speechStatus');

      // 권한이 부여되지 않은 경우에만 요청
      if (microphoneStatus != PermissionStatus.granted) {
        final newMicStatus = await Permission.microphone.request();
        print('마이크 권한 요청 결과: $newMicStatus');

        if (newMicStatus.isPermanentlyDenied) {
          _showPermissionDialog('마이크', () async {
            await openAppSettings();
          });
          return;
        }
      }

      if (speechStatus != PermissionStatus.granted) {
        final newSpeechStatus = await Permission.speech.request();
        print('음성 인식 권한 요청 결과: $newSpeechStatus');

        if (newSpeechStatus.isPermanentlyDenied) {
          _showPermissionDialog('음성 인식', () async {
            await openAppSettings();
          });
          return;
        }
      }

      // 모든 권한이 부여된 경우
      final finalMicStatus = await Permission.microphone.status;
      final finalSpeechStatus = await Permission.speech.status;

      if (finalMicStatus.isGranted && finalSpeechStatus.isGranted) {
        print('모든 권한이 부여되었습니다.');
        if (mounted) {
          Fluttertoast.showToast(
            msg: "마이크 권한이 허용되었습니다",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      }
    } catch (e) {
      print('권한 요청 오류: $e');
    }
  }

  // 권한 설명 다이얼로그
  void _showPermissionDialog(String permissionName, VoidCallback onPressed) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('$permissionName 권한 필요'),
            content: Text('음성 번역 기능을 사용하려면 $permissionName 권한이 필요합니다.'),
            actions: [
              TextButton(
                child: Text('취소'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              ElevatedButton(
                child: Text('설정'),
                onPressed: () {
                  Navigator.of(context).pop();
                  onPressed();
                },
              ),
            ],
          );
        },
      );
    }
  }

  // WebView 권한 설정 - 누락된 메서드
  Future<void> _setupWebViewPermissions() async {
    await controller?.runJavaScript('''
      // 1. intent:// URL 차단
      const originalOpen = window.open;
      window.open = function(url, name, specs) {
        if (url && url.startsWith('intent://')) {
          console.log('Blocked intent URL:', url);
          return null;
        }
        return originalOpen.call(this, url, name, specs);
      };
      
      // 2. 링크 클릭 차단
      document.addEventListener('click', function(event) {
        const target = event.target.closest('a');
        if (target && target.href && target.href.startsWith('intent://')) {
          event.preventDefault();
          event.stopPropagation();
          console.log('Blocked intent link click');
          return false;
        }
      });
      
      // 3. 권한 API 오버라이드
      navigator.permissions = navigator.permissions || {};
      navigator.permissions.query = function(descriptor) {
        console.log('Permission query for:', descriptor.name);
        return Promise.resolve({
          state: 'granted',
          onchange: null
        });
      };
      
      // 4. getUserMedia 성공하도록 설정
      if (navigator.mediaDevices) {
        const originalGetUserMedia = navigator.mediaDevices.getUserMedia;
        navigator.mediaDevices.getUserMedia = function(constraints) {
          console.log('getUserMedia called with:', constraints);
          return originalGetUserMedia.call(this, constraints)
            .catch(error => {
              console.log('getUserMedia error:', error);
              return Promise.resolve({});
            });
        };
      }
      
      // 5. 권한 다이얼로그 자동 허용
      const autoClickPermissionButtons = function() {
        const buttons = document.querySelectorAll('button, [role="button"], input[type="button"]');
        buttons.forEach(function(btn) {
          const text = (btn.textContent || btn.innerText || btn.value || '').toLowerCase();
          if (text.includes('allow') || text.includes('허용') || text.includes('확인') || text.includes('yes')) {
            console.log('Auto-clicking permission button:', text);
            btn.click();
          }
        });
      };
      
      // DOM 변화 감지
      const observer = new MutationObserver(function(mutations) {
        mutations.forEach(function(mutation) {
          if (mutation.addedNodes.length > 0) {
            setTimeout(autoClickPermissionButtons, 500);
          }
        });
      });
      
      observer.observe(document.body, {
        childList: true,
        subtree: true
      });
      
      // 페이지 로드 후 권한 버튼 자동 클릭
      setTimeout(autoClickPermissionButtons, 1000);
      setTimeout(autoClickPermissionButtons, 3000);
    ''');
  }

  // intent:// URL이 발생했을 때 음성 인식 처리 - 누락된 메서드
  Future<void> _handleVoiceIntent() async {
    print('Voice intent detected, enabling microphone...');

    await controller?.runJavaScript('''
      console.log('Handling voice intent...');
      
      // 음성 인식 강제 활성화
      if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
        navigator.mediaDevices.getUserMedia({audio: true})
          .then(function(stream) {
            console.log('Microphone access granted');
            // 스트림 처리
          })
          .catch(function(error) {
            console.log('Microphone access denied:', error);
          });
      }
      
      // 파파고 음성 버튼 다시 활성화 시도
      setTimeout(function() {
        const voiceButtons = document.querySelectorAll('[data-testid*="voice"], [aria-label*="음성"], .voice-button, button[title*="음성"]');
        voiceButtons.forEach(function(btn) {
          console.log('Found voice button, clicking...');
          btn.click();
        });
      }, 1000);
    ''');
  }

  Uri _buildDictionaryUrl() {
    const baseUrl = 'https://papago.naver.com/?sk=ko&tk=ja&hn=0';
    return Uri.parse(baseUrl);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.translate),
              SizedBox(width: 8),
              Text('파파고 번역기'),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () => controller?.reload(),
            ),
            IconButton(
              icon: Icon(Icons.mic),
              onPressed: _requestAllPermissions,
            ),
          ],
        ),
        body: Stack(
          children: [
            if (controller != null) WebViewWidget(controller: controller!),
            if (isLoading)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 2.h),
                    Text('번역기를 불러오는 중...', style: TextStyle(fontSize: 16.sp)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
