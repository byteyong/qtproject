import 'package:flutter/material.dart';
import '../main.dart';
import 'login_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoggedIn = false; // 로그인 상태 관리 (추후 SharedPreferences 등으로 확장 가능)

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      return LoginScreen(
        onLoginSuccess: () {
          setState(() => _isLoggedIn = true);
        },
      );
    }

    return MainShell(
      onLogout: () {
        setState(() => _isLoggedIn = false);
      },
    );
  }
}
