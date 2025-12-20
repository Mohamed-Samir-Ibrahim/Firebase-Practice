import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/model/user_model.dart';
import 'package:firebase_practice/service/database_service.dart';
import 'package:firebase_practice/service/encryption_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? userFromFirebase(User? user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  Stream<UserModel> get user =>
      _auth.authStateChanges().map((user) => userFromFirebase(user)!);

  Future<User?>? signInAnonymous() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      print('Result: ${user?.uid}');
      return user;
    } catch (e) {
      print('Error: ${e.toString()}');
      return null;
    }
  }

  Future<UserModel?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final hashedPassword = EncryptionService.hashPassword(password);
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      User? user = result.user;
      final storedHashedPassword = EncryptionService.hashPassword(password);
      return userFromFirebase(user);
    } catch (e) {
      print('Error: ${e.toString()}');
      return null;
    }
  }

  Future<UserModel?> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final hashedPassword = EncryptionService.hashPassword(password);
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      User? user = result.user;
      await DatabaseService(
        uid: user?.uid,
      ).updateUserData('0', 'New Crew User', 100);
      return userFromFirebase(user);
    } catch (e) {
      print('Error: ${e.toString()}');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print('Error: ${e.toString()}');
      return;
    }
  }
}
