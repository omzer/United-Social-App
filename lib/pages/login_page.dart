import 'package:flutter/material.dart';
import 'package:social/backend/firebase_auth.dart';
import 'package:social/custom_widgets/my_custom_textfeild.dart';
import 'package:social/custom_widgets/my_dialogs.dart';
import 'package:social/pages/signup_page.dart';

import 'home_page.dart';

String _email, _password;
BuildContext _context;

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _context = context;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Center(child: _buildSignInCard()),
    );
  }
}

Widget _buildAppBar() {
  return AppBar(
    automaticallyImplyLeading: false,
    centerTitle: true,
    elevation: .5,
    title: Text('Sign in'),
  );
}

Widget _buildSignInCard() {
  return SizedBox(
    width: double.infinity,
    height: 400,
    child: Card(
      elevation: 5,
      margin: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Card items:
              MyTextFeild(
                label: 'Email',
                onChange: (input) => _email = input,
              ),
              SizedBox(height: 32.0),
              MyTextFeild(
                label: 'Password',
                onChange: (input) => _password = input,
                isPassword: true,
              ),
              SizedBox(height: 8.0),
              MaterialButton(
                onPressed: _forgetPasswordClicked,
                child: Text('Forget pasword?'),
                padding: EdgeInsets.all(0.0),
              ),
              MaterialButton(
                onPressed: _signInClicked,
                child: Text('Sign in'),
                color: Colors.lightBlue,
                minWidth: double.infinity,
                height: 50.0,
                textColor: Colors.white,
              ),
              SizedBox(height: 16.0),
              MaterialButton(
                onPressed: _signUpClicked,
                child: Text('Sign up'),
                color: Colors.lightBlue,
                height: 50.0,
                minWidth: double.infinity,
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

void _forgetPasswordClicked() {
  if (_email == null) {
    MyDialogs.showCustomDialog(
        _context, 'Email can\'t be empty!', 'Please write your email address');
    return;
  }
  MyAuth.forgetPassword(_context, _email);
}

void _signInClicked() {
  if (_email == null || _password == null) {
    MyDialogs.showCustomDialog(_context, 'Email or Password is empty',
        'You can\'t login with empty credantials!!');
    return;
  }
  MyAuth.signIn(_context, _email, _password);
}

void _signUpClicked() {
  Navigator.pushReplacement(
    _context,
    MaterialPageRoute(builder: (BuildContext context) => SignupPage()),
  );
}
