import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social/MyClasses/static_content.dart';
import 'package:social/backend/my_db.dart';
import 'package:social/pages/message_page.dart';

class MessagesList extends StatefulWidget {
  @override
  _MessagesListState createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: MyDB.listenToMessages(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        QuerySnapshot chats = snap.data;
        List<Widget> widgets = [SizedBox(height: 8)];

        chats.documents.forEach((chat) {
          widgets.add(_buildFutreMessageTile(chat['uid']));
          widgets.add(SizedBox(height: 8));
        });
        return ListView(children: widgets);
      },
    );
  }

  Widget _buildFutreMessageTile(String uid) {
    return FutureBuilder(
      future: MyDB.getNameAndImg(uid),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return LinearProgressIndicator();
        }
        return _buildMessageTile(snap.data['name'], snap.data['img'], uid);
      },
    );
  }

  Widget _buildMessageTile(String name, String img, String uid) {
    return Material(
      elevation: 6,
      child: InkWell(
        onTap: () => StaticContent.push(context, MessagePage(uid: uid)),
        child: ListTile(
          title: Text(name),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(img),
            radius: 20,
          ),
        ),
      ),
    );
  }
}
