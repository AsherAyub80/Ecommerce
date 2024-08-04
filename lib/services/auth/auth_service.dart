import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Instance of FirebaseAuth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Get current user
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  // Sign in with email and password
  Future<UserCredential> signInWithEmailPassword(
      String email, String password) async {
    try {
      // Attempt to sign in user
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Handle specific FirebaseAuthException
      throw Exception(e.message);
    } catch (e) {
      // Handle other errors
      throw Exception('Failed to sign in: $e');
    }
  }

  // Sign up with email and password
  Future<UserCredential> signUpWithEmailPassword(
      String email, String password) async {
    try {
      // Attempt to sign up user
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Handle specific FirebaseAuthException
      throw Exception(e.message);
    } catch (e) {
      // Handle other errors
      throw Exception('Failed to sign up: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }
}
