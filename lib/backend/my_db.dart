import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social/MyClasses/static_content.dart';
import 'package:flutter/material.dart';
import 'package:social/custom_widgets/my_dialogs.dart';
import 'package:social/pages/view_detailed_post.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
      int price) async {
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

  static Future<void> getAllPostForUser(String uid) async {}

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
}
