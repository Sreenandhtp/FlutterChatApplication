import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mychatapp/pages/splash_screen.dart';
import 'package:mychatapp/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  await setUp();
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

Future<void> setUp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpFirebase();
  await registerServices();
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const MyApp({super.key, this.savedThemeMode});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: GoogleFonts.montserratTextTheme(),
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.blueAccent,
        
      ),
      dark: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: GoogleFonts.montserratTextTheme(),
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blueAccent,
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        theme: theme,
        darkTheme: darkTheme,
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
    // return MaterialApp(
    //   theme: ThemeData(
    //       colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    //       useMaterial3: true,
    //       textTheme: GoogleFonts.montserratTextTheme()),
    //   home: const SplashScreen(),
    //   // routes: {
    //   //   "loginPage": (context) {
    //   //     return const LoginPage();
    //   //   },
    //   //   "registerPage": (context) {
    //   //     return const RegisterPage();
    //   //   }
    //   // },
    //   debugShowCheckedModeBanner: false,
    // );
  }
}
