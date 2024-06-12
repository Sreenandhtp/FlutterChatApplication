import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mychatapp/const.dart';
import 'package:mychatapp/pages/bottom_navigator.dart';
import 'package:mychatapp/pages/registerpage.dart';
import 'package:mychatapp/services/auth_service.dart';
import '../widgets/custometextfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GetIt _getIt = GetIt.instance;

  final GlobalKey<FormState> _loginFormKey = GlobalKey();

  late AuthService _authService;

  String? email, password;
  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
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
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [_headerText(), _loginField(), _loginPageNavigator()],
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
            "Welcome Back....",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          Text(
            "Sign in to get started",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _loginField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Form(
        key: _loginFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomeTextField(
                onsave: (value) {
                  setState(() {
                    email = value;
                  });
                },
                validationRegExp: EMAIL_VALIDATION_REGEX,
                height: MediaQuery.sizeOf(context).height * 0.1,
                fieldIcon: Icons.mail_outline_rounded,
                labeltext: "Email"),
            const SizedBox(
              height: 10,
            ),
            CustomeTextField(
                onsave: (value) {
                  setState(() {
                    password = value;
                  });
                },
                obsecureText: true,
                validationRegExp: PASSWORD_VALIDATION_REGEX,
                height: MediaQuery.sizeOf(context).height * 0.1,
                fieldIcon: Icons.lock_outline,
                labeltext: "Password"),
            const SizedBox(
              height: 10,
            ),
            _loginButton(),
          ],
        ),
      ),
    );
  }

  Widget _loginButton() {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromARGB(255, 16, 44, 225),
      ),
      // height: MediaQuery.sizeOf(context).height / 15,
      child: MaterialButton(
        onPressed: () async {
          if (_loginFormKey.currentState?.validate() ?? false) {
            _loginFormKey.currentState?.save();
            bool result = await _authService.login(email!, password!);
            print(result);
            if (result) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BottomNavigator(),
                  ));
            } else {
              DelightToastBar(
                autoDismiss: true,
                position: DelightSnackbarPosition.top,
                builder: (context) {
                  return const ToastCard(
                    leading: Icon(Icons.error),
                    title: Text(
                      "Failed to login, Please try again..",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                  );
                },
              ).show(context);
            }
          }
        },
        child: const Text(
          "Log In",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _loginPageNavigator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "You don't have any account?",
          style: TextStyle(color: Colors.black),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegisterPage(),
                ));
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 5, 86, 185)),
          ),
        )
      ],
    );
  }
}
