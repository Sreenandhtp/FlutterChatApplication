import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? _user;

  User? get user {
    return _user;
  }

  AuthService() {
    _firebaseAuth.authStateChanges().listen(authStateChanges);
  }

  Future<bool> login(String email, String password) async {
    try {
      final UserCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (UserCredential.user != null) {
        _user = UserCredential.user;
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> signUp(String email, String password) async {
    try {
      final Credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (Credential.user != null) {
        _user = Credential.user;
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> logout() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  void authStateChanges(User? user) {
    if (user != null) {
      _user = user;
    } else {
      _user = null;
    }
  }
}
