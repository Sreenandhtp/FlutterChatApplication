import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mychatapp/pages/loginpage.dart';
import 'package:mychatapp/pages/splash_screen.dart';
import 'package:mychatapp/utils.dart';

void main() async {
  await setUp();
  runApp(const MyApp());
}

Future<void> setUp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpFirebase();
  await registerServices();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          textTheme: GoogleFonts.montserratTextTheme()),
      home:  SplashScreen(),
      // routes: {
      //   "loginPage": (context) {
      //     return const LoginPage();
      //   },
      //   "registerPage": (context) {
      //     return const RegisterPage();
      //   }
      // },
      debugShowCheckedModeBanner: false,
    );
  }
}
