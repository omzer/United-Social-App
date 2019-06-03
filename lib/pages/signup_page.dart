import 'package:flutter/material.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:social/backend/firebase_auth.dart';
import 'package:social/custom_widgets/my_custom_textfeild.dart';
import 'package:social/custom_widgets/my_dialogs.dart';
import 'package:social/custom_widgets/my_text.dart';

class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MySignUp();
  }
}

class MySignUp extends StatefulWidget {
  @override
  _MySignUpState createState() => _MySignUpState();
}

class _MySignUpState extends State<MySignUp> {
  String _gender = 'Choose your gender',
      _name,
      _familyName,
      _email,
      _password1,
      _password2;
  final _controller = PageController(initialPage: 0);
  GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.blue,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text('Sign up'),
      elevation: .5,
    );
  }

  Widget _buildBottomBar() {
    return FancyBottomNavigation(
      key: _key,
      circleColor: Colors.amber,
      tabs: [
        TabData(iconData: Icons.supervised_user_circle, title: "Gender"),
        TabData(iconData: Icons.contacts, title: "Name"),
        TabData(iconData: Icons.alternate_email, title: "Info"),
        TabData(iconData: Icons.done_all, title: "Finish")
      ],
      onTabChangedListener: (position) {
        setState(
          () {
            _controller.animateToPage(
              position,
              duration: Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          },
        );
      },
    );
  }

  Widget _buildBody() {
    return PageView(
      controller: _controller,
      onPageChanged: (int position) {
        setState(() {
          FancyBottomNavigationState fs = _key.currentState;
          fs.setPage(position);
        });
      },
      children: <Widget>[
        _buildGenderPage(),
        _buildNamePage(),
        _buildInfoPage(),
        _buildFinishPage(),
      ],
    );
  }

  Widget _buildGenderPage() {
    return _buildCardList(
      Column(
        children: <Widget>[
          MyText(
            content: _gender,
            size: 28.0,
            isBold: true,
          ),
          SizedBox(height: 16.0),
          InkWell(
            onTap: () {
              setState(() {
                _gender = 'Male';
              });
            },
            child: SizedBox(
              child: Image.asset('lib/assets/imgs/boy.png'),
              height: 150,
              width: 150,
            ),
          ),
          SizedBox(height: 8.0),
          Divider(),
          SizedBox(height: 8.0),
          InkWell(
            onTap: () {
              setState(() {
                _gender = 'Fmale';
              });
            },
            child: SizedBox(
              child: Image.asset('lib/assets/imgs/girl.png'),
              height: 150,
              width: 150,
            ),
          ),
          SizedBox(height: 16.0),
          MyText(
            content: 'Swipe to continue ->',
            size: 16.0,
          ),
        ],
      ),
    );
  }

  Widget _buildNamePage() {
    return _buildCardList(Column(
      children: <Widget>[
        MyText(
          content: 'Lets know you better',
          size: 28,
          isBold: true,
        ),
        SizedBox(height: 64.0),
        MyTextFeild(
          onChange: (String input) => _name = input,
          label: 'Your name',
          icon: Icon(Icons.contact_mail),
          controller: TextEditingController(text: _name),
        ),
        SizedBox(height: 32.0),
        MyTextFeild(
          onChange: (String input) => _familyName = input,
          label: 'Your family name',
          icon: Icon(Icons.group),
          controller: TextEditingController(text: _familyName),
        ),
        SizedBox(height: 64.0),
        MyText(
          content: 'Swipe to continue ->',
          size: 16.0,
        ),
      ],
    ));
  }

  Widget _buildInfoPage() {
    return _buildCardList(
      Column(
        children: <Widget>[
          MyText(
            content: 'Last thing we need',
            size: 28,
            isBold: true,
          ),
          SizedBox(height: 32.0),
          MyTextFeild(
            onChange: (String input) => _email = input,
            label: 'Your email',
            icon: Icon(Icons.email),
            controller: TextEditingController(text: _email),
          ),
          SizedBox(height: 32.0),
          MyTextFeild(
            onChange: (String input) => _password1 = input,
            label: 'Your password',
            icon: Icon(Icons.lock),
            isPassword: true,
            controller: TextEditingController(text: _password1),
          ),
          SizedBox(height: 32.0),
          MyTextFeild(
            onChange: (String input) => _password2 = input,
            label: 'Repeat your password',
            icon: Icon(Icons.lock_outline),
            isPassword: true,
            controller: TextEditingController(text: _password2),
          ),
          SizedBox(height: 64.0),
          MyText(
            content: 'Swipe to continue ->',
            size: 16.0,
          ),
        ],
      ),
    );
  }

  Widget _buildFinishPage() {
    return _buildCardList(
      Column(
        children: <Widget>[
          MyText(
            content: 'Your all set!',
            size: 32.0,
          ),
          SizedBox(height: 64.0),
          MyText(
            content:
                'Click "Go" and we will check your info and create your account',
            size: 18.0,
          ),
          SizedBox(height: 128.0),
          MaterialButton(
            onPressed: _start,
            minWidth: double.infinity,
            height: 80,
            color: Colors.blue,
            child: MyText(
              content: 'Go!',
              size: 32.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardList(Column col) {
    return SizedBox(
      width: double.infinity,
      height: 300,
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: col,
          ),
        ),
      ),
    );
  }

  void _start() {
    if (!_validate()) {
      return;
    }
    // succeed
    MyAuth.signUp(context, _email, _password1, _gender, _name, _familyName);
  }

  bool _validate() {
    // Empty fields
    if (_name == null ||
        _familyName == null ||
        _email == null ||
        _password1 == null ||
        _password2 == null) {
      MyDialogs.showCustomDialog(
          context, 'Empty Fileds', 'Don\'t leave empty fields!');
      return false;
    }
    if (_gender.length > 5) {
      MyDialogs.showCustomDialog(
          context, 'Gender not chosen', 'Please choose gender to proceed');
      return false;
    }
    if (_email.length < 5) {
      MyDialogs.showCustomDialog(
          context, 'Incorrect email', 'Please add valid email');
      return false;
    }
    if (_password1.length < 6) {
      MyDialogs.showCustomDialog(
          context, 'Invalid password', 'Password must be 6 digits at least');
      return false;
    }
    if (_password1 != _password2) {
      _password1 = _password2 = '';
      MyDialogs.showCustomDialog(
          context, 'Password not match', 'Your passwords must match');
      return false;
    }
    return true;
  }
}
