import 'package:flutter/material.dart';
import 'package:social/MyClasses/static_content.dart';
import 'package:social/backend/my_db.dart';
import 'package:social/custom_widgets/my_custom_post.dart';
import 'package:social/custom_widgets/my_custom_textfeild.dart';
import 'package:social/custom_widgets/my_dialogs.dart';
import 'package:social/custom_widgets/my_text.dart';
import 'package:social/pages/view_image.dart';
import 'package:social/pages/view_profile.dart';

class ViewDetailedPost extends StatelessWidget {
  final MyPostCard post;
  String _comment;
  BuildContext _context;

  ViewDetailedPost({
    this.post,
  });

//   todo if uid == current user id then hide 'send message'
  ListView pst;
  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: MyDB.getCommentsFromPost(post.postId),
          builder: (context, commentsSnap) {
            if (pst != null) return pst;
            if (commentsSnap.connectionState == ConnectionState.waiting) {
              return LinearProgressIndicator();
            }
            return FutureBuilder(
              future: MyDB.getTagsFromPost(post.postId),
              builder: (context, tagsSnap) {
                if (tagsSnap.connectionState == ConnectionState.waiting) {
                  return LinearProgressIndicator();
                }
                List<Widget> list = [];
                list.add(_buildUserImage());
                list.add(SizedBox(height: 8));
                list.add(_buildName());
                list.add(SizedBox(height: 8));
                list.add(_buildPrice());
                list.add(SizedBox(height: 4));
                list.add(_buildLocation());
                list.add(SizedBox(height: 4));
                list.add(_buildDate());
                list.add(SizedBox(height: 8));
                list.add(_buildPhotos());
                list.add(SizedBox(height: 8));
                list.add(_buildContent());

                list.add(Divider(color: Colors.blueGrey, height: 16));

                List<String> tags = [];
                tagsSnap.data.documents.forEach((doc) {
                  tags.add(doc['content']);
                });

                list.add(_buildTags(tags));
                list.add(Divider(color: Colors.blueGrey, height: 16));

                commentsSnap.data.documents.forEach((doc) {
                  Widget currentComment = FutureBuilder(
                    future: MyDB.getUserInfoById(doc['authoruid']),
                    builder: (context, singleCommentSnap) {
                      if (singleCommentSnap.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return _buildSingleComment(
                          doc['content'], singleCommentSnap.data['photoURL']);
                    },
                  );
                  list.add(currentComment);
                });
                list.add(SizedBox(height: 8));
                list.add(_buildAddComment());
                list.add(SizedBox(height: 4));
                if (post.uid != StaticContent.currentUser.uid) {
                  list.add(MaterialButton(
                    color: Colors.green,
                    onPressed: _sendMessage,
                    child: MyText(
                      content: 'Send Message',
                      color: Colors.white,
                    ),
                  ));
                }

                return pst = ListView(children: list);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildUserImage() {
    return Center(
      child: InkWell(
        onTap: _goToUserProfile,
        child: Hero(
          tag: post.postId,
          child: CircleAvatar(
            backgroundImage: NetworkImage(post.image),
            radius: 60,
          ),
        ),
      ),
    );
  }

  Widget _buildName() {
    return InkWell(
      onTap: _goToUserProfile,
      child: MyText(
        content: post.name,
        align: TextAlign.center,
        size: 32,
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: .5,
      title: Text('Post by ${post.name}'),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.pan_tool),
          onPressed: _closeSession,
          tooltip: 'End post',
        )
      ],
    );
  }

  void _closeSession() async {
    await MyDialogs.showReviewDialog(
      _context,
      post.code,
      post.uid,
      post.postId,
    );
  }

  void _sendMessage() {}

  Widget _buildPrice() {
    return MyText(
      content: '${post.price}\$',
      color: Colors.green,
      size: 22,
      isBold: true,
      align: TextAlign.center,
    );
  }

  Widget _buildLocation() {
    return MyText(
      content: post.location,
      color: Colors.blueAccent,
      size: 18,
      align: TextAlign.center,
    );
  }

  Widget _buildDate() {
    return MyText(
      content: post.date,
      color: Colors.grey,
      size: 18,
    );
  }

  Widget _buildContent() {
    return MyText(
      content: post.content,
      color: Colors.black,
      size: 18,
    );
  }

  Widget _buildTags(List<String> tags) {
    List<Widget> allTags = [];
    tags.forEach((tag) {
      allTags.add(Chip(
        label: MyText(content: '#$tag\t', color: Colors.blue),
        avatar: Icon(
          Icons.done_all,
          color: Colors.green,
        ),
      ));
      allTags.add(SizedBox(width: 10));
    });

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: allTags),
    );
  }

  Widget _buildSingleComment(String commentContent, String imageURL) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Chip(
        elevation: 2,
        label: MyText(content: commentContent, color: Colors.blueGrey),
        avatar: CircleAvatar(backgroundImage: NetworkImage(imageURL)),
      ),
    );
  }

  Widget _buildAddComment() {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      title: MyTextFeild(
        label: 'Add new comment',
        onChange: (String input) => _comment = input,
      ),
      actions: <Widget>[
        FlatButton(
          child: Icon(Icons.send),
          onPressed: _sendComment,
        ),
      ],
    );
  }

  Widget _buildPhotos() {
    List<Widget> imgs = [];

    post.photos.forEach((photo) {
      imgs.add(
        InkWell(
          onTap: () => StaticContent.push(_context, ViewImage(image: photo)),
          child: Hero(
            tag: photo,
            child: FadeInImage.assetNetwork(
              image: photo,
              placeholder: 'lib/assets/imgs/loading.gif',
              width: 200,
              height: 160,
            ),
          ),
        ),
      );
      imgs.add(SizedBox(width: 20));
    });

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: imgs,
      ),
    );
  }

  void _sendComment() {
    MyDB.addComment(_context, post.postId, _comment, post);
  }

  void _goToUserProfile() {
    StaticContent.push(
        _context,
        UserProfile(
          uid: post.uid,
        ));
  }
}
