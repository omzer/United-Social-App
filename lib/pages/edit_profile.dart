import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:social/backend/my_db.dart';
import 'package:social/custom_widgets/my_dialogs.dart';
import 'package:social/custom_widgets/my_text.dart';

class EditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EditPageStf();
  }
}

class EditPageStf extends StatefulWidget {
  @override
  _EditPageStfState createState() => _EditPageStfState();
}

class _EditPageStfState extends State<EditPageStf> {
  String _name,
      _familyName,
      _age,
      _city,
      _photoURL,
      _bio,
      _uploadingComment = 'Choose photo';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: FutureBuilder(
        future: MyDB.getUserInfoToUpdate(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          dynamic data = snap.data;

          _name = data['name'];
          _familyName = data['family'];
          _age = data['age'].toString();
          _city = data['city'];
          if (_photoURL == null) _photoURL = data['photo'];
          _bio = data['bio'];

          return PageView(
            children: <Widget>[
              _buildImage(),
              _buildName(),
              _buildAge(),
              _buildBiography(),
              _buildCity(),
            ],
          );
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('Update Profile'),
      centerTitle: true,
      actions: <Widget>[
        IconButton(icon: Icon(Icons.done), onPressed: _submitInfo)
      ],
    );
  }

  Widget _buildName() {
    return _buildCardList(
      Column(
        children: <Widget>[
          MyText(
            content: 'Name & Family name',
            size: 18,
            isBold: true,
          ),
          SizedBox(height: 16),
          Image.asset('lib/assets/imgs/name.png'),
          SizedBox(height: 8),
          TextField(
            controller: TextEditingController(text: _name),
            onChanged: (input) => _name = input,
            decoration: InputDecoration(
              labelText: 'Name',
              prefixIcon: Icon(
                Icons.person,
                color: Colors.blue,
              ),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: TextEditingController(text: _familyName),
            onChanged: (input) => _familyName = input,
            decoration: InputDecoration(
              labelText: 'Family name',
              prefixIcon: Icon(
                Icons.group,
                color: Colors.blue,
              ),
            ),
          ),
          SizedBox(height: 22),
          Image.asset('lib/assets/imgs/horizantal_scroll.png'),
          SizedBox(height: 8),
          MyText(
            content: 'Scroll to the right to continue',
            size: 18,
          )
        ],
      ),
    );
  }

  Widget _buildAge() {
    return _buildCardList(
      Column(
        children: <Widget>[
          MyText(
            content: 'Age',
            size: 18,
            isBold: true,
          ),
          SizedBox(height: 16),
          Image.asset('lib/assets/imgs/cake.png'),
          SizedBox(height: 8),
          TextField(
            controller: TextEditingController(text: _age),
            onChanged: (input) => _age = input,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Age',
              prefixIcon: Icon(
                Icons.mood,
                color: Colors.blue,
              ),
            ),
          ),
          SizedBox(height: 64),
          Image.asset('lib/assets/imgs/horizantal_scroll.png'),
          SizedBox(height: 8),
          MyText(
            content: 'Scroll to the right or left',
            size: 18,
          )
        ],
      ),
    );
  }

  Widget _buildBiography() {
    return _buildCardList(
      Column(
        children: <Widget>[
          MyText(
            content: 'Bio - Tell us about you!',
            size: 18,
            isBold: true,
          ),
          SizedBox(height: 16),
          Image.asset('lib/assets/imgs/notepad.png'),
          SizedBox(height: 8),
          TextField(
            controller: TextEditingController(text: _bio),
            onChanged: (input) => _bio = input,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Bio',
              prefixIcon: Icon(
                Icons.speaker_notes,
                color: Colors.blue,
              ),
            ),
          ),
          SizedBox(height: 64),
          Image.asset('lib/assets/imgs/horizantal_scroll.png'),
          SizedBox(height: 8),
          MyText(
            content: 'Scroll to the right or left',
            size: 18,
          )
        ],
      ),
    );
  }

  Widget _buildCity() {
    return _buildCardList(
      Column(
        children: <Widget>[
          MyText(
            content: 'City - Where are you from?',
            size: 18,
            isBold: true,
          ),
          SizedBox(height: 16),
          Image.asset('lib/assets/imgs/city.png'),
          SizedBox(height: 8),
          TextField(
            controller: TextEditingController(text: _city),
            onChanged: (input) => _city = input,
            decoration: InputDecoration(
              labelText: 'City',
              prefixIcon: Icon(
                Icons.location_city,
                color: Colors.blue,
              ),
            ),
          ),
          SizedBox(height: 64),
          Image.asset('lib/assets/imgs/horizantal_scroll.png'),
          SizedBox(height: 8),
          MyText(
            content: 'Scroll to the right or left',
            size: 18,
          )
        ],
      ),
    );
  }

  Widget _buildImage() {
    return _buildCardList(
      Column(
        children: <Widget>[
          MyText(
            content: 'Personal Photo',
            size: 18,
            isBold: true,
          ),
          SizedBox(height: 16),
          FadeInImage.assetNetwork(
            width: 180,
            height: 180,
            image: _photoURL,
            placeholder: 'lib/assets/imgs/loading.gif',
          ),
          SizedBox(height: 8),
          MyText(
            content: _uploadingComment,
            size: 18,
          ),
          SizedBox(height: 8),
          MaterialButton(
            child: MyText(
              content: 'Pick a photo',
              size: 22,
              color: Colors.white,
            ),
            onPressed: _addImage,
            minWidth: double.infinity,
            color: Colors.blue,
            height: 60,
          ),
          SizedBox(height: 80),
          Image.asset('lib/assets/imgs/horizantal_scroll.png'),
          SizedBox(height: 8),
          MyText(
            content: 'Scroll to the right to continue',
            size: 18,
          )
        ],
      ),
    );
  }

  void _addImage() async {
    String path = await FilePicker.getFilePath(type: FileType.IMAGE);
    if (path == null) return;
    setState(() {
      _uploadingComment = 'Photo uplading...';
    });
    String url = await MyDB.uploadImage(path);
    setState(() {
      _uploadingComment = 'Done!';
    });
    setState(() {
      print(url);
      _photoURL = url;
    });
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

  void _submitInfo() {
    if (_name.length < 2 || _familyName.length < 2) {
      MyDialogs.showCustomDialog(
        context,
        'Incorrect Names',
        'Please write correct name and family name',
      );
      return;
    }
    MyDB.updateUserInfo(
      context,
      _name,
      _familyName,
      double.parse(_age),
      _bio,
      _city,
      _photoURL,
    );
  }
}
