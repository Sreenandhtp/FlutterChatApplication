import 'dart:io';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:mychatapp/const.dart';
import 'package:mychatapp/models/user_profile.dart';
import 'package:mychatapp/pages/homepage.dart';
import 'package:mychatapp/services/auth_service.dart';
import 'package:mychatapp/services/database_service.dart';
import 'package:mychatapp/services/media_service.dart';
import 'package:mychatapp/services/storege_service.dart';
import 'package:mychatapp/widgets/custometextfield.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<RegisterPage> {
  File? selectedImage;
  final GetIt _getIt = GetIt.instance;
  String? email, password, name;
  final GlobalKey<FormState> _RegisterFormKey = GlobalKey();

  late AuthService _authService;
  late MediaService _mediaService;
  late StorageService _storageService;
  late DatabaseService _databaseService;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _authService = _getIt.get<AuthService>();
    _mediaService = _getIt.get<MediaService>();
    _storageService = _getIt.get<StorageService>();
    _databaseService = _getIt.get<DatabaseService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _headerText(),
            if (!isLoading) _pfpSelectionField(),
            if (!isLoading) _registerField(),
            if (!isLoading) _otherRegisterButton(),
            if (!isLoading) _loginPageNavigator(),
            if (isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _pfpSelectionField() {
    return GestureDetector(
      onTap: () async {
        File? file = await _mediaService.getImageFromGallery();
        if (file != null) {
          setState(() {
            selectedImage = file;
          });
        }
      },
      child: CircleAvatar(
        radius: MediaQuery.of(context).size.width * 0.15,
        backgroundImage: selectedImage != null
            ? FileImage(selectedImage!)
            : NetworkImage(PLACEHOLDER_PFP) as ImageProvider,
      ),
    );
  }

  Widget _headerText() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: const Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Create Account....",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          Text(
            "Sign Up to get started",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _registerField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Form(
        key: _RegisterFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomeTextField(
              validationRegExp: NAME_VALIDATION_REGEX,
              height: MediaQuery.sizeOf(context).height * 0.1,
              fieldIcon: Icons.person,
              labeltext: "Name",
              onsave: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            CustomeTextField(
              validationRegExp: EMAIL_VALIDATION_REGEX,
              height: MediaQuery.sizeOf(context).height * 0.1,
              fieldIcon: Icons.mail_outline_rounded,
              labeltext: "Email",
              onsave: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            CustomeTextField(
              obsecureText: true,
              validationRegExp: PASSWORD_VALIDATION_REGEX,
              height: MediaQuery.sizeOf(context).height * 0.1,
              fieldIcon: Icons.lock_outline,
              labeltext: "Password",
              onsave: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            _registerButton(),
            const Text(
              "OR",
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            const Text("Sign Up with"),
          ],
        ),
      ),
    );
  }

  Widget _registerButton() {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromARGB(255, 16, 44, 225),
      ),
      child: MaterialButton(
        onPressed: () async {
          setState(() {
            isLoading = true;
          });

          try {
            if ((_RegisterFormKey.currentState?.validate() ?? false) &&
                selectedImage != null) {}
            _RegisterFormKey.currentState?.save();
            final result = await _authService.signUp(email!, password!);
            if (result) {
              String? pfpURL = await _storageService.upLoadUserPfp(
                  file: selectedImage!, uid: _authService.user!.uid);
              if (pfpURL != null) {
                await _databaseService.createUserProfile(
                    userProfile: UserProfile(
                        uid: _authService.user!.uid,
                        name: name,
                        pfpURL: pfpURL));
              } else {
                throw Exception("Unable to upload user profile picture  ");
              }

              DelightToastBar(
                autoDismiss: true,
                position: DelightSnackbarPosition.top,
                builder: (context) {
                  return const ToastCard(
                    leading: Icon(Icons.check),
                    title: Text(
                      "Successfuly registered..",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                  );
                },
              ).show(context);
              // Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Homepage(),
                  ));
            } else {
              throw Exception("Unable to register user");
            }
            print(result);
          } catch (e) {
            DelightToastBar(
              autoDismiss: true,
              position: DelightSnackbarPosition.top,
              builder: (context) {
                return const ToastCard(
                  leading: Icon(Icons.error),
                  title: Text(
                    "Failed to register,Please try again!..",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                );
              },
            ).show(context);
          }
          setState(() {
            isLoading = false;
          });
        },
        child: const Text(
          "Create Account",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _otherRegisterButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
            height: MediaQuery.sizeOf(context).height * 0.06,
            width: MediaQuery.sizeOf(context).width / 2.4,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: const Color.fromARGB(255, 238, 237, 237)),
            child: ElevatedButton.icon(
                onPressed: () {},
                icon: const FaIcon(FontAwesomeIcons.google),
                label: const Text(
                  "Google",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ))),
        Container(
            height: MediaQuery.sizeOf(context).height * 0.06,
            width: MediaQuery.sizeOf(context).width / 2.4,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: const Color.fromARGB(255, 238, 237, 237)),
            child: ElevatedButton.icon(
                onPressed: () {},
                icon: const FaIcon(FontAwesomeIcons.facebook),
                label: const Text(
                  "Facebook",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ))),
      ],
    );
  }

  Widget _loginPageNavigator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Already have an account?",
          style: TextStyle(color: Colors.black),
        ),
        GestureDetector(
          onTap: () {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => const LoginPage(),
            //     ));
            Navigator.pop(context);
          },
          child: const Text(
            "Login",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 5, 86, 185)),
          ),
        )
      ],
    );
  }
}
