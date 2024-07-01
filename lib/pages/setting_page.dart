import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mychatapp/models/user_profile.dart';
import 'package:mychatapp/services/auth_service.dart';
import 'loginpage.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingState();
}

class _SettingState extends State<Settings> {
  final GetIt _getIt = GetIt.instance;

  late AuthService _authService;

  UserProfile? loggedUser;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    loggedUser = UserProfile(
        uid: _authService.user!.uid,
        name: _authService.user!.displayName,
        pfpURL: _authService.user!.photoURL);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            profilePhoto(),
            logOutBotton(),
          ],
        ),
      ),
    );
  }

  Widget profilePhoto() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: CircleAvatar(
            radius: MediaQuery.of(context).size.width * 0.11,
            // backgroundImage: NetworkImage(_authService.user!.photoURL!),
          ),
        ),
        // Text(loggedUser!.uid!)
      ],
    );
  }

  

  Widget logOutBotton() {
    return GestureDetector(
      onTap: () async {
        bool result = await _authService.logout();
        if (result) {
          DelightToastBar(
            autoDismiss: true,
            position: DelightSnackbarPosition.top,
            builder: (context) {
              return const ToastCard(
                leading: Icon(Icons.check),
                title: Text(
                  "Successfuly logged out!....",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
              );
            },
          ).show(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ));
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.08,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("LogOut"),
            Icon(
              Icons.logout,
              color: Colors.red,
            )
          ],
        ),
      ),
    );
  }
}
