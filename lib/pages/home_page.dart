import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:flutter/material.dart';
import 'package:social/MyClasses/static_content.dart';
import 'package:social/backend/firebase_auth.dart';
import 'package:social/backend/my_db.dart';
import 'package:social/custom_widgets/my_custom_post.dart';
import 'package:social/custom_widgets/my_dialogs.dart';
import 'package:social/custom_widgets/my_expandable_info.dart';
import 'package:social/custom_widgets/my_expandable_post.dart';
import 'package:social/custom_widgets/my_expandable_reviews.dart';
import 'package:social/custom_widgets/my_messages_list.dart';
import 'package:social/custom_widgets/my_text.dart';
import 'package:social/custom_widgets/user_profile_stack.dart';
import 'package:social/pages/search_page.dart';
import 'package:social/pages/view_detailed_post.dart';
import 'edit_profile.dart';
import 'new_post_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final fabsIcons = [
    Icon(Icons.add),
    Icon(Icons.edit),
    Icon(Icons.add_comment),
  ];

  final fabsColors = [
    Colors.blue,
    Colors.orangeAccent,
    Colors.green,
  ];

  final fabsTooltip = [
    'Create new post',
    'Edit profile',
    'Send new message',
  ];

  int _currentPage = 0;
  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: 3);
    _tabController.addListener(
      () {
        setState(() {
          _currentPage = _tabController.index;
        });
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: _currentPage,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          tooltip: fabsTooltip[_currentPage],
          onPressed: () {
            switch (_currentPage) {
              case 0:
                _newPost();
                break;
              case 1:
                _editProfile();
                break;
              case 2:
                _sendNewMessage();
                break;
            }
          },
          child: fabsIcons[_currentPage],
          backgroundColor: fabsColors[_currentPage],
        ),
        appBar: _buildAppBar(),
        body: _buildTabBarView(),
        backgroundColor: Colors.white,
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      title: FlatButton.icon(
        icon: Hero(
          tag: 'search',
          child: Icon(
            Icons.search,
            color: Colors.white,
          ),
        ),
        label: MyText(
          content: 'look up for a hero!',
          color: Colors.white,
        ),
        onPressed: _search,
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () async {
            bool wantToExit = await MyDialogs.showYesNoDialog(
              context,
              'Sure?',
              'Are you sure you want to sign out?',
            );
            if (wantToExit) {
              MyAuth.signOut(context);
            }
          },
        ),
      ],
      bottom: TabBar(
        controller: _tabController,
        onTap: (int position) {
          setState(() {
            _currentPage = position;
          });
        },
        tabs: <Widget>[
          Tab(icon: Icon(Icons.home), text: 'Home'),
          Tab(icon: Icon(Icons.account_circle), text: 'Profile'),
          Tab(icon: Icon(Icons.message), text: 'Messages'),
        ],
      ),
    );
  }

  TabBarView _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildHomeTab(),
        _buildProfileTab(),
        _buildMessagesTab(),
      ],
    );
  }

  List<Widget> posts;

  Widget _buildHomeTab() {
    if (posts != null) {
      return _buildPullToScrol(ListView(children: posts));
    }
    posts = [];
    return FutureBuilder(
      future: MyDB.getAllPosts(),
      builder: (context, snaps) {
        if (snaps.connectionState == ConnectionState.waiting) {
          return Center(child: LinearProgressIndicator());
        }
        snaps.data.documents.forEach((currentPost) {
          String uid = currentPost['uid'];
          String location = currentPost['location'];
          String date = currentPost['date'];
          String code = currentPost['code'];
          double price = currentPost['price'];
          String content = currentPost['description'];
          String postId = currentPost.documentID;
          List<dynamic> photos = currentPost['photos'];

          MyPostCard post;
          post = MyPostCard(
            uid: uid,
            code: code,
            location: location,
            date: date,
            price: price,
            content: content,
            postId: postId,
            photos: photos,
            onCardClicked: () => _postClicked(post),
          );
          posts.add(post);
        });
        return _buildPullToScrol(ListView(children: posts));
      },
    );
  }

  Widget _buildPullToScrol(ListView list) {
    return LiquidPullToRefresh(
      showChildOpacityTransition: false,
      child: list,
      onRefresh: () async {
        await Future.delayed(Duration(milliseconds: 1500));
        setState(() {
          posts = null;
        });
      },
    );
  }

  List<Widget> profileWidgets = [];
  Widget _buildProfileTab() {
    if (profileWidgets.isEmpty) {
      // Personal info section
      profileWidgets.add(ExpandablePersonalInfo(
          uid: StaticContent.currentUser.uid, context: context));
      profileWidgets.add(Divider(color: Colors.black));
      // Reviews section
      profileWidgets.add(MyExpandableReviews(
          uid: StaticContent.currentUser.uid, context: context));
      profileWidgets.add(Divider(color: Colors.black));
      // Posts section
      profileWidgets.add(ExpandablePosts(
          uid: StaticContent.currentUser.uid, context: context));
      // Profile img and name (first element in the page)
      profileWidgets.insert(
        0,
        ProfileCard(uid: StaticContent.currentUser.uid, context: context),
      );
    }
    return LiquidPullToRefresh(
      showChildOpacityTransition: false,
      child: ListView(children: profileWidgets),
      onRefresh: () async {
        await Future.delayed(Duration(milliseconds: 1500));
        setState(() {
          profileWidgets = [];
        });
      },
    );
  }

  Widget _buildMessagesTab() {
    return MessagesList();
  }

//  Methods!

  void _postClicked(MyPostCard post) {
    StaticContent.push(context, ViewDetailedPost(post: post));
  }

  void _search() => StaticContent.push(context, SearchPageStatless());

  void _newPost() => StaticContent.push(context, NewPostPage());

  void _editProfile() => StaticContent.push(context, EditPage());

  void _sendNewMessage() => StaticContent.push(context, SearchPageStatless());
}
