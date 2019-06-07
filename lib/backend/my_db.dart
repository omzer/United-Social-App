import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social/MyClasses/static_content.dart';
import 'package:flutter/material.dart';
import 'package:social/custom_widgets/my_dialogs.dart';
import 'package:social/pages/home_page.dart';
import 'package:social/pages/view_detailed_post.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

class MyDB {
  static final _db = Firestore.instance;
  static final _storage = FirebaseStorage.instance;

  static Future<void> addNewUser(
    String uid,
    String name,
    String familyName,
    String gender,
    String email,
  ) async {
    _db.collection('users').document(uid).setData(
      {
        'displayName': name,
        'familyName': familyName,
        'gender': gender,
        'email': email,
        'photoURL': gender == 'Male'
            ? StaticContent.defaultMaleImg
            : StaticContent.defaultFemaleImg,
      },
    );
  }

  static Future<QuerySnapshot> setUserData() async {
    var result;
    await _db
        .collection('users')
        .document(StaticContent.currentUser.uid)
        .get()
        .then(
      (userData) {
        print(StaticContent.currentUser.uid);
        print(userData);
        result = userData;
      },
    ).catchError(
      (error) {
        print(error.message);
        result = null;
      },
    );
    return result;
  }

  static Future<QuerySnapshot> getAllPosts() {
    return _db.collection('posts').getDocuments();
  }

  static Future<DocumentSnapshot> getUserInfoById(String uid) {
    return _db.collection('users').document(uid).get();
  }

  static Future<DocumentSnapshot> getPostById(String postId) {
    return _db.collection('posts').document(postId).get();
  }

  static Future<QuerySnapshot> getCommentsFromPost(String postId) {
    return _db
        .collection('posts')
        .document(postId)
        .collection('Comments')
        .orderBy('date')
        .getDocuments();
  }

  static Future<QuerySnapshot> getTagsFromPost(String postId) {
    return _db
        .collection('posts')
        .document(postId)
        .collection('tags')
        .getDocuments();
  }

  static Future<void> addComment(
      BuildContext context, String postId, String comment, post) async {
    if (comment == null || comment.length == 1) {
      MyDialogs.showCustomDialog(
          context, 'Not valid comment', 'Please write a valid comment');
      return;
    }
    _db.collection('posts').document(postId).collection('Comments').add({
      'authoruid': StaticContent.currentUser.uid,
      'content': comment,
      'date': DateTime.now().toIso8601String(),
    });
    StaticContent.pushReplacement(context, ViewDetailedPost(post: post));
  }

  static Future<void> newPost(
    BuildContext context,
    String content,
    List<String> photos,
    List<String> tags,
    String location,
    double price,
  ) async {
    String newPostId = 'nothing';
    String code = Random().nextInt(100000000).toString();
    _db.collection('posts').add({
      'description': content,
      'location': location,
      'price': price,
      'photos': photos,
      'uid': StaticContent.currentUser.uid,
      'date': DateTime.now().toIso8601String(),
      'code': code,
    }).then((newPost) {
      newPostId = newPost.documentID;
      print(newPostId);
      tags.forEach((tag) {
        _db.collection('posts').document(newPostId).collection('tags').add({
          'content': tag,
        });
      });
    }).whenComplete(() async {
      DocumentSnapshot snap = await _db
          .collection('users')
          .document(StaticContent.currentUser.uid)
          .get();
      List<String> posts = [newPostId];
      if (snap.data['posts'] != null) {
        List<dynamic> currentPosts = snap.data['posts'];
        currentPosts.forEach((post) {
          posts.add(post);
        });
      }
      _db
          .collection('users')
          .document(StaticContent.currentUser.uid)
          .updateData({
        'posts': posts,
      });
      Navigator.pop(context);
    }).catchError((error) {
      MyDialogs.showCustomDialog(
          context, 'Error occured! 😔', error.toString());
    });
  }

  static Future<String> uploadImage(String path) async {
    String imageURL = 'noImage??';
    String fileName = Random().nextInt(100000).toString() +
        '${path.substring(path.length - 3)}';
    await _storage
        .ref()
        .child(fileName)
        .putFile(File(path))
        .onComplete
        .then((result) async {
      imageURL = await result.ref.getDownloadURL();
    }).catchError((error) {
      print('error ye man :( ${error.message}');
    });
    return imageURL;
  }

  static Future<List<dynamic>> getAllPostForUser(String uid) async {
    List<dynamic> posts = [];
    DocumentSnapshot userData;
    await _db.collection('users').document(uid).get().then((_) => userData = _);
    List<dynamic> postsId = userData.data['posts'];
    if (postsId == null) return posts;

    for (int i = 0; i < postsId.length; i++) {
      DocumentSnapshot post;
      await _db
          .collection('posts')
          .document(postsId[i])
          .get()
          .then((_) => post = _);
      posts.add(
        {
          'uid': post.data['uid'],
          'location': post.data['location'],
          'date': post.data['date'],
          'code': post.data['code'],
          'price': post.data['price'],
          'content': post.data['description'],
          'photos': post.data['photos'],
          'postId': post.documentID,
        },
      );
    }
    return posts;
  }

  static Future<void> addRateToPost(
    BuildContext context,
    String postId,
    int rateVal,
    String review,
  ) async {
    _db
        .collection('posts')
        .document(postId)
        .updateData(
          {
            'rate': rateVal,
            'rateContent': review,
            'date': DateTime.now().toIso8601String(),
          },
        )
        .then((_) {})
        .catchError((_) {
          MyDialogs.showCustomDialog(context, 'Error occured', _.message);
        });
  }

  static Future<void> closePost(
    BuildContext context,
    String postId,
    int ratingVal,
    String review,
    String postOwnerID,
  ) async {
    // Set post closed to true
    await _db.collection('posts').document(postId).updateData({
      'closed': true,
    }).then((_) {});
    // exchange reviews
    // send rating for the post owner
    await _db.collection('users').document(postOwnerID).collection('rate').add(
      {
        'date': DateTime.now().toIso8601String(),
        'rate': ratingVal,
        'rateContent': review,
        'uid': StaticContent.currentUser.uid,
      },
    );
    // Get rating my ratings from the post
    await _db.collection('posts').document(postId).get().then((data) {
      ratingVal = data.data['rate'];
      review = data.data['rateContent'];
    });
    await _db
        .collection('users')
        .document(StaticContent.currentUser.uid)
        .collection('rate')
        .add(
      {
        'date': DateTime.now().toIso8601String(),
        'rate': ratingVal,
        'rateContent': review,
        'uid': postOwnerID,
      },
    ).then((_) {
      StaticContent.pushReplacement(context, HomePage());
    });
  }

  static Future<List<dynamic>> getReviews(String uid) async {
    List<dynamic> list = [];
    String rateContent, imgURL, name, id;
    int rate;
    QuerySnapshot reviews;
    await _db
        .collection('users')
        .document(uid)
        .collection('rate')
        .getDocuments()
        .then(
      (QuerySnapshot _) {
        reviews = _;
      },
    );
    if (reviews.documents.length == 0) return list;

    StaticContent.totalReviews = 0;
    for (int i = 0; i < reviews.documents.length; i++) {
      rate = reviews.documents[i]['rate'];
      StaticContent.totalReviews += rate;
      rateContent = reviews.documents[i]['rateContent'];
      id = reviews.documents[i]['uid'];
      await _db.collection('users').document(id).get().then((_) {
        imgURL = _.data['photoURL'];
        name = _.data['displayName'];
        list.add({
          'rateContent': rateContent,
          'imgURL': imgURL,
          'name': name,
          'rate': rate,
        });
      });
    }
    StaticContent.totalReviews /= reviews.documents.length;
    StaticContent.totalReviews = StaticContent.totalReviews.roundToDouble();

    return list;
  }

  static Future<dynamic> getUserInfo(String uid) async {
    dynamic userInfo;
    DocumentSnapshot userData;
    await _db.collection('users').document(uid).get().then((_) => userData = _);

    userInfo = {
      'age': userData.data['age'],
      'bio': userData.data['bio'],
      'city': userData.data['city'],
      'email': userData.data['email'],
      'gender': userData.data['gender'],
    };

    return userInfo;
  }

  static Future<dynamic> getUserDataForProfile(String uid) async {
    DocumentSnapshot userData;
    await _db.collection('users').document(uid).get().then((_) => userData = _);

    return {
      'name': '${userData.data['displayName']} ${userData.data['familyName']}',
      'url': userData.data['photoURL'],
    };
  }

  static Future<bool> isFollower(String uid) async {
    bool result = false;
    await _db
        .collection('users')
        .document(StaticContent.currentUser.uid)
        .collection('following')
        .where('uid==$uid')
        .getDocuments()
        .then((_) {
      result = _.documents.isNotEmpty;
    });

    return result;
  }

  static Future<void> followUser(String uid) async {
    await _db
        .collection('users')
        .document(StaticContent.currentUser.uid)
        .collection('following')
        .add(
      {
        'uid': uid,
      },
    );

    await _db.collection('users').document(uid).collection('follower').add({
      'uid': StaticContent.currentUser.uid,
    });
  }

  static Future<void> unFollowUser(String uid) async {
    await _db
        .collection('users')
        .document(StaticContent.currentUser.uid)
        .collection('following')
        .where('uid==$uid')
        .getDocuments()
        .then((_) {
      _.documents.forEach(
        (document) {
          _db
              .collection('users')
              .document(StaticContent.currentUser.uid)
              .collection('following')
              .document(document.documentID)
              .delete();
        },
      );
    });

    await _db
        .collection('users')
        .document(uid)
        .collection('follower')
        .where('uid==${StaticContent.currentUser.uid}')
        .getDocuments()
        .then((_) {
      _.documents.forEach(
        (document) {
          _db
              .collection('users')
              .document(uid)
              .collection('follower')
              .document(document.documentID)
              .delete();
        },
      );
    });
  }

  static Future<dynamic> getUserInfoToUpdate() async {
    DocumentSnapshot userData;
    await _db
        .collection('users')
        .document(StaticContent.currentUser.uid)
        .get()
        .then((_) => userData = _);

    dynamic user = userData.data;
    return {
      'name': user['displayName'],
      'family': user['familyName'],
      'age': user['age'] ?? 0,
      'bio': user['bio'] ?? '',
      'city': user['city'] ?? '',
      'photo': user['photoURL'] ?? 'no photo',
    };
  }

  static Future<void> updateUserInfo(
    BuildContext context,
    String name,
    String familyName,
    double age,
    String bio,
    String city,
    String photo,
  ) async {
    await _db
        .collection('users')
        .document(StaticContent.currentUser.uid)
        .updateData({
      'displayName': name,
      'familyName': familyName,
      'age': age,
      'bio': bio,
      'city': city,
      'photoURL': photo,
    }).then((_) {
      Navigator.pop(context);
    });
  }

  // ----------------------- http requests
  static final String httpURL =
      'http://mujshrf-001-site1.etempurl.com/api/values';

  static Future<List<dynamic>> getSearchResult(String query) async {
    http.Response response = await http.post(
      Uri.encodeFull('$httpURL'),
      headers: {
        'value': query,
      },
    );
    List result = json.decode(response.body);
    List<dynamic> list = [];

    result.forEach((user) {
      list.add({
        'uid': user['uid'],
        'name': user['displayName'],
        'img': user['photoURL'],
      });
    });

    return list;
  }
}
