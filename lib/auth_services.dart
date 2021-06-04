import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  static FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<void> signOut() async {
    _auth.signOut();
  }

  static Future<User> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      User firebaseUser = result.user;
      return firebaseUser;
    } catch (e) {
      return e;
    }
  }

  static Future<User> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User firebaseUser = result.user;

      return firebaseUser;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<User> getCredential(String email, String password) async {
    User user = await FirebaseAuth.instance.currentUser;
    UserCredential authResult = await user.reauthenticateWithCredential(
      EmailAuthProvider.credential(
        email: user.email,
        password: password,
      ),
    );
    User firebaseUser = authResult.user;
    return firebaseUser;
  }

  static Future<void> updateEmail(
      String email, String password, User firebaseUser) async {
    User user = firebaseUser;

    user.updateEmail(email).then((_) {
      print("Succesfull changed email");
    }).catchError((error) {
      print("email can't be changed" + error.toString());
    });
  }

  static Future<void> updatePassword(String password, User firebaseUser) async {
    User user = firebaseUser;

    user.updatePassword(password).then((_) {
      print("Succesfull changed password");
    }).catchError((error) {
      print("password can't be changed" + error.toString());
    });
  }

  static Stream<User> get firebaseUserStream => _auth.authStateChanges();
  
}

class UserServices {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static saveUser(User user, firstName, lastName, email, password, role) async {
    Map<String, dynamic> userData = {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'role': role,
    };

    final userRef = firestore.collection('users').doc(user.uid);
    if ((await userRef.get()).exists) {
      await userRef.update({
        'first_name': firstName,
        'last_name': lastName,
      });
    } else {
      await firestore.collection('users').doc(user.uid).set(userData);
    }
  }
}
