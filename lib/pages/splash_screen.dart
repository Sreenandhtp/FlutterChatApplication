import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mychatapp/pages/homepage.dart';
import 'package:mychatapp/pages/loginpage.dart';
import 'package:mychatapp/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
 const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GetIt _getIt = GetIt.instance;

  late AuthService _authService;

  // bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    checkUserLogged();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/chat_logo.jpg",
              height: 200,
              width: 200,
            ),
            const CircularProgressIndicator(
              color: Colors.black87,
            )
          ],
        ),
      ),
    );
  }

  Future<void> checkUserLogged() async {
    await Future.delayed(const Duration(seconds: 5));
    print(_authService.user);
    if (_authService.user != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Homepage(),
          ));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ));
    }
  }
}
