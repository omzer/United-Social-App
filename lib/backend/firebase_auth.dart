import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social/MyClasses/my_user.dart';
import 'package:social/MyClasses/static_content.dart';
import 'package:social/backend/my_db.dart';
import 'package:social/custom_widgets/my_dialogs.dart';
import 'package:social/pages/home_page.dart';
import 'package:social/pages/login_page.dart';

class MyAuth {
  static final _myAuth = FirebaseAuth.instance;
  static FirebaseUser _user = null;

  static signIn(BuildContext context, String email, String password) {
    _myAuth.signInWithEmailAndPassword(email: email, password: password).then(
      (FirebaseUser user) {
        _user = user;
        StaticContent.pushReplacement(context, HomePage());
      },
    ).catchError(
      (error) {
        MyDialogs.showCustomDialog(context, 'Error occured', error.message);
      },
    );
  }

  static signUp(
    BuildContext context,
    String email,
    String password,
    String gender,
    String name,
    String familyName,
  ) {
    _myAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then(
      (FirebaseUser user) {
        _user = user;
        MyDB.addNewUser(user.uid, name, familyName, gender, email);
        StaticContent.pushReplacement(context, HomePage());
      },
    ).catchError(
      (error) {
        MyDialogs.showCustomDialog(context, 'Error occured', error.message);
      },
    );
  }

  static forgetPassword(BuildContext context, String email) {
    _myAuth.sendPasswordResetEmail(email: email).then(
      (result) {
        MyDialogs.showCustomDialog(
          context,
          'Reset Password',
          'Password reset request sent, please check your email',
        );
      },
    ).catchError(
      (error) {
        MyDialogs.showCustomDialog(context, 'Error occured', error.message);
      },
    );
  }

  static bool isSigned() {
    return _user != null;
  }

  static void initUser() {
    _myAuth.onAuthStateChanged.listen(
      (FirebaseUser user) {
        _user = user;
        if (user != null) {
          StaticContent.currentUser = User(user.uid);
        }
      },
    );
  }

  static Future<void> signOut(BuildContext context) async {
    await _myAuth.signOut().then((obj) {
      StaticContent.pushReplacement(context, LoginPage());
    }).catchError((error) {
      MyDialogs.showCustomDialog(
        context,
        'Error loggin out',
        error.message,
      );
    });
  }

  static FirebaseUser getUser() {
    return _user;
  }
}
