import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:social/MyClasses/static_content.dart';
import 'package:social/backend/my_db.dart';
import 'package:social/custom_widgets/my_text.dart';
import 'package:social/pages/view_image.dart';

class MessagePage extends StatelessWidget {
  final String uid;
  MessagePage({this.uid});

  @override
  Widget build(BuildContext context) {
    return MessagePagestf(uid: uid);
  }
}

class MessagePagestf extends StatefulWidget {
  final String uid;
  MessagePagestf({this.uid});
  static String myImg = StaticContent.defaultFemaleImg;
  static String userImg = StaticContent.defaultMaleImg;

  @override
  _MessagePageStatestf createState() => _MessagePageStatestf();
}

class _MessagePageStatestf extends State<MessagePagestf> {
  BuildContext context;

  String _message;
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text('Messages'),
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
              top: 0, left: 8, right: 8, bottom: 75, child: _buildFuture()),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomBar(),
          )
        ],
      ),
    );
  }

  Widget memo;
  Widget _buildFuture() {
    return memo != null
        ? memo
        : memo = FutureBuilder(
            future: MyDB.listenToRoom(widget.uid),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snap.hasError) {
                return Center(child: Text('error occured!'));
              }
              return _buildStream(snap.data);
            },
          );
  }

  Widget _buildStream(Stream s) {
    return StreamBuilder(
      stream: s,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Center(child: Text('loading messages....'));
        }
        List<Widget> widgets = [];

        snap.data.documents.forEach((message) {
          String from = message['senderId'];
          String imageUrl = message['imageUrl'];
          String content = message['message'] ?? 'img';
          int messageType = message['message_type'];

          Widget chip;
          bool mine = from == StaticContent.currentUser.uid;
          if (messageType == 1)
            chip = _buildMessageChip(content, mine);
          else
            chip = _buildImage(imageUrl, mine);
          widgets.add(chip);
        });

        Future.delayed(Duration(milliseconds: 500)).then((_) {
          setState(() {
            scrollController.animateTo(
              scrollController.offset + 50,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          });
        });

        return SingleChildScrollView(
          controller: scrollController,
          child: Column(children: widgets),
        );
      },
    );
  }

  Widget _buildImage(String imgURL, bool mine) {
    return Align(
      alignment:
          mine ? AlignmentDirectional.topEnd : AlignmentDirectional.topStart,
      child: InkWell(
        onTap: () => StaticContent.push(context, ViewImage(image: imgURL)),
        child: Container(
          height: 200,
          width: 200,
          child: Hero(
            tag: imgURL,
            child: FadeInImage.assetNetwork(
              image: imgURL,
              placeholder: 'lib/assets/imgs/loading.gif',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageChip(String message, bool mine) {
    return Align(
      alignment:
          mine ? AlignmentDirectional.topEnd : AlignmentDirectional.topStart,
      child: Chip(
        backgroundColor: mine ? Colors.blue : Colors.green,
        label: MyText(
          content: message,
          color: Colors.white,
        ),
        avatar: CircleAvatar(
          radius: 15,
          backgroundImage: NetworkImage(
            mine ? MessagePagestf.myImg : MessagePagestf.userImg,
          ),
        ),
      ),
    );
  }

  Future<String> _addImage() async {
    String path = await FilePicker.getFilePath(type: FileType.IMAGE);
    if (path == null) return null;
    return await MyDB.uploadImage(path);
  }

  Widget _buildBottomBar() {
    return SafeArea(
      child: Container(
        color: Colors.blue,
        width: MediaQuery.of(context).size.width,
        height: 70,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            child: TextField(
              controller: TextEditingController(text: _message),
              onChanged: (_) => _message = _,
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'Your Message',
                labelStyle: TextStyle(color: Colors.black),
                prefixIcon: Icon(
                  Icons.comment,
                  color: Colors.black,
                ),
                suffixIcon: SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.send,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          if (_message == null || _message.length == 0) return;
                          MyDB.sendTextMessage(widget.uid, _message);
                          setState(() {
                            _message = '';
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.image,
                          color: Colors.blue,
                        ),
                        onPressed: () async {
                          String imgURL = await _addImage();
                          if (imgURL == null) return;
                          MyDB.sendImageMessage(widget.uid, imgURL);
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
