import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth;

  AuthRepository({FirebaseAuth? firebaseAuth})
      : _auth = firebaseAuth ?? FirebaseAuth.instance;

  Future<UserModel> login(String email, String password) async {
    try {
      print("📡 Trying login with: $email");

      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;

      print("✅ Firebase Login Success:");
      print("UID: ${user?.uid}");
      print("Email: ${user?.email}");
      print("Email Verified: ${user?.emailVerified}");
      print("Token: ${await user?.getIdToken()}");

      if (user == null) {
        throw Exception('Login failed. User is null.');
      }

      return UserModel(email: user.email ?? email);

    } on FirebaseAuthException catch (e) {
      print("❌ FirebaseAuthException: ${e.code} - ${e.message}");

      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found for that email.';
          break;
        case 'wrong-password':
          message = 'Wrong password provided.';
          break;
        case 'invalid-email':
          message = 'Email address is not valid.';
          break;
        case 'user-disabled':
          message = 'This account has been disabled.';
          break;
        default:
          message = 'Login failed: ${e.message ?? e.code}';
      }
      throw Exception(message);

    } catch (e) {
      print("❌ Other Login Error: $e");
      throw Exception('Login failed: $e');
    }
  }
}
