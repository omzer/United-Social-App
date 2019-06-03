import 'package:flutter/material.dart';
import 'package:social/backend/my_db.dart';
import 'package:social/custom_widgets/my_custom_textfeild.dart';
import 'package:social/custom_widgets/my_dialogs.dart';
import 'package:social/custom_widgets/my_text.dart';
import 'package:file_picker/file_picker.dart';

class NewPostPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NewPostPageStf();
  }
}

class NewPostPageStf extends StatefulWidget {
  @override
  _NewPostPageStateStf createState() => _NewPostPageStateStf();
}

class _NewPostPageStateStf extends State<NewPostPageStf> {
  String _content, _location, _price, _tag;
  List<Widget> _tagsChips = [];
  List<String> _tagsText = [];
  List<String> _photos = [];
  String _uploadingStatus = '0 photos added';

//  photos??

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: PageView(
        children: <Widget>[
          _buildContent(),
          _buildImages(),
          _buildTags(),
          _buildLocation(),
          _buildPrice(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return _buildCardList(
      Column(
        children: <Widget>[
          MyText(
            content: 'Post Content',
            size: 18,
          ),
          SizedBox(height: 16),
          Image.asset('lib/assets/imgs/content.png'),
          SizedBox(height: 8),
          SizedBox(height: 16),
          TextField(
            controller: TextEditingController(text: _content),
            onChanged: (input) => _content = input,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Write your post content here',
            ),
          ),
          SizedBox(height: 32),
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

  Widget _buildImages() {
    return _buildCardList(
      Column(
        children: <Widget>[
          MyText(
            content: 'Select Photo/s (optional)',
            size: 18,
          ),
          SizedBox(height: 16),
          Image.asset('lib/assets/imgs/add_photo.png'),
          SizedBox(height: 8),
          MyText(content: _uploadingStatus),
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
          SizedBox(height: 120),
          Image.asset('lib/assets/imgs/horizantal_scroll.png'),
          SizedBox(height: 8),
          MyText(
            content: 'Scroll right or left',
            size: 18,
          )
        ],
      ),
    );
  }

  Widget _buildTags() {
    return _buildCardList(
      Column(
        children: <Widget>[
          MyText(
            content: 'Add Tags (one at least)',
            size: 18,
          ),
          SizedBox(height: 16),
          Image.asset('lib/assets/imgs/hashtag.png'),
          SizedBox(height: 8),
          MyTextFeild(
            label: 'Write tag',
            icon: Icon(Icons.playlist_add),
            onChange: (input) => _tag = input,
            controller: TextEditingController(text: _tag),
          ),
          SizedBox(height: 8),
          MaterialButton(
            child: MyText(
              content: 'Add tag',
              size: 18,
              color: Colors.white,
            ),
            onPressed: () {
              if (_tag == null || _tag.length < 2) {
                MyDialogs.showCustomDialog(
                    context, 'Invalid Tag', 'Write a valid tag please');
                FocusScope.of(context).requestFocus(new FocusNode());
                return;
              }

              setState(() {
                _tagsText.add(_tag);
                _tagsChips.add(
                  Chip(
                    avatar: Icon(
                      Icons.done_all,
                      color: Colors.green,
                    ),
                    elevation: 4,
                    label: MyText(content: '#$_tag'),
                  ),
                );
                _tagsChips.add(SizedBox(width: 10));

                _tag = '';
                FocusScope.of(context).requestFocus(new FocusNode());
              });
            },
            minWidth: double.infinity,
            color: Colors.blue,
            height: 50,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: _tagsChips),
          ),
          SizedBox(height: 60),
          Image.asset('lib/assets/imgs/horizantal_scroll.png'),
          SizedBox(height: 8),
          MyText(
            content: 'Scroll right or left',
            size: 18,
          )
        ],
      ),
    );
  }

  Widget _buildLocation() {
    return _buildCardList(
      Column(
        children: <Widget>[
          MyText(
            content: 'Add location',
            size: 18,
          ),
          SizedBox(height: 16),
          Image.asset('lib/assets/imgs/map.png'),
          SizedBox(height: 8),
          MyTextFeild(
            label: 'Write the location',
            icon: Icon(Icons.map),
            onChange: (input) => _location = input,
            controller: TextEditingController(text: _location),
          ),
          SizedBox(height: 120),
          Image.asset('lib/assets/imgs/horizantal_scroll.png'),
          SizedBox(height: 8),
          MyText(
            content: 'Scroll right or left',
            size: 18,
          )
        ],
      ),
    );
  }

  Widget _buildPrice() {
    return _buildCardList(
      Column(
        children: <Widget>[
          MyText(
            content: 'How much you will pay',
            size: 18,
          ),
          SizedBox(height: 16),
          Image.asset('lib/assets/imgs/money_hand.png'),
          SizedBox(height: 8),
          MyTextFeild(
            onChange: (input) => _price = input,
            controller: TextEditingController(text: _price),
            keyType: TextInputType.number,
            label: 'Write the price',
            icon: Icon(Icons.monetization_on),
          ),
          SizedBox(height: 120),
          Image.asset('lib/assets/imgs/tap.png'),
          SizedBox(height: 8),
          MyText(
            content: 'Click the ✔ one the top right',
            size: 18,
          )
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

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('New post'),
      centerTitle: true,
      actions: <Widget>[
        IconButton(icon: Icon(Icons.done), onPressed: _submitInfo)
      ],
    );
  }

  void _addImage() async {
    String path = await FilePicker.getFilePath(type: FileType.IMAGE);
    if (path == null) return;
    setState(() {
      _uploadingStatus = 'Uploading.... please wait';
    });
    String url = await MyDB.uploadImage(path);
    setState(() {
      _photos.add(url);
      _uploadingStatus = '${_photos.length} photos added';
    });
  }

  void _submitInfo() {
    if (_content == null || _content.length < 5) {
      MyDialogs.showCustomDialog(context, 'Invalid content',
          'Please write your post content correctly!');
      return;
    }
    if (_tagsText.length == 0) {
      MyDialogs.showCustomDialog(
          context, 'Don\'t be mean 🙄', 'Add at least one tag');
      return;
    }
    if (_location == null || _location.length < 3) {
      MyDialogs.showCustomDialog(context, 'Invalid location 🗺',
          'Please write the location where you need the post to appear!');
      return;
    }
    if (_uploadingStatus[0] == 'U') {
      MyDialogs.showCustomDialog(
        context,
        'Still uploading',
        'Wait until your photos done uploading!',
      );
      return;
    }
    if (_price == null) {
      setState(() {
        _price = '0';
      });
    }
    int price = 0;
    try {
      price = int.parse(_price);
    } catch (error) {
      MyDialogs.showCustomDialog(context, 'Wrong price',
          'Please right valid price (should be integer)');
      return;
    }
    MyDB.newPost(context, _content, _photos, _tagsText, _location, price);
  }
}
