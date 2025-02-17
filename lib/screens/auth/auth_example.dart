import 'package:flutter/material.dart';
import 'package:ribra_tech_auth_template/ribra_tech_auth_template.dart';



class AuthExample extends StatefulWidget {
  const AuthExample({super.key});

  @override
  State<AuthExample> createState() => _AuthExampleState();
}

class _AuthExampleState extends State<AuthExample> {
  final auth = RibraTechAuth();
  bool isLogin = true;
  bool isLoading = false;

  Future<void> handleLogin(String email, String password) async {
    if (isLoading) return; // Prevent multiple taps

    setState(() => isLoading = true);
    try {
      await auth.signInWithEmail(
        email: email,
        password: password,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Giriş başarılı!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> handleRegister(String email, String password, String name) async {
    if (isLoading) return;

    setState(() => isLoading = true);
    try {
      await auth.signUpWithEmail(
        email: email,
        password: password,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kayıt başarılı!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void toggleAuthMode() {
    setState(() => isLogin = !isLogin);
  }

  @override
  Widget build(BuildContext context) {
    return isLogin
        ? LoginScreen(
            onLogin: handleLogin,
            onRegister: toggleAuthMode,
            logo: Image.asset('assets/logo.png', errorBuilder: (context, error, stackTrace) => const SizedBox()),
            backgroundColor: Colors.white,
            customizations: {
              'buttonColor': Colors.blue,
              'textColor': Colors.black,
            },
          )
        : RegisterScreen(
            onRegister: handleRegister,
            onLogin: toggleAuthMode,
            logo: Image.asset('assets/logo.png', errorBuilder: (context, error, stackTrace) => const SizedBox()),
            backgroundColor: Colors.white,
            customizations: {
              'buttonColor': Colors.blue,
              'textColor': Colors.black,
            },
          );
  }
}