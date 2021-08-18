import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationHelper {
  final FirebaseAuth _firebaseAuth;

  AuthenticationHelper(this._firebaseAuth);

  // 2
  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();


  // 3
  Future<String> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch(e) {
      return e.message;
    }
  }

  // 4
  Future<String> signUp({String email, String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch(e) {
      return e.message;
    }
  }

  // 5
  Future<String> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return "Signed out";
    } on FirebaseAuthException catch(e) {
      return e.message;
    }
  }

// 6
  User getUser() {
    try {
      return _firebaseAuth.currentUser;
    } on FirebaseAuthException {
      return null;
    }
  }
}