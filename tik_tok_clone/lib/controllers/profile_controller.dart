import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tik_tok_clone/util/constants.dart';

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get user => _user.value;

  Rx<String> _uid = "".obs;
    List<String> thumbnails = [];


  updateUserId(String userId) {
    _uid.value = userId;
    getUserData();
  }

  getUserData() async {
    var uploadedVideos = await fireStore
        .collection('videos')
        .where('uid', isEqualTo: _uid.value)
        .get();

    for (int i = 0; i < uploadedVideos.docs.length; i++) {
      thumbnails.add((uploadedVideos.docs[i].data() as dynamic)['videoUrl']);
    }

    DocumentSnapshot doc =
        await fireStore.collection('users').doc(_uid.value).get();
    final userData = doc.data()! as dynamic;

    String name = userData['name'];
    String profilePhoto = userData['profilePhoto'];
    int likes = 0, followers = 0, following = 0;
    bool isFollowing = false;

    for (var item in uploadedVideos.docs) {
      likes += (item.data()['likes'] as List).length;
    }

    var followerDoc = await fireStore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .get();

    var followingDoc = await fireStore
        .collection('users')
        .doc(_uid.value)
        .collection('following')
        .get();

    followers = followerDoc.docs.length;
    following = followingDoc.docs.length;

    fireStore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .doc(authController.user.uid)
        .get()
        .then((value) {
      if (value.exists) {
        isFollowing = true;
      } else {
        isFollowing = false;
      }
    });

    _user.value = {
      'followers': followers.toString(),
      'following': following.toString(),
      'isFollowing': isFollowing,
      'likes': likes.toString(),
      'profilePhoto': profilePhoto,
      'name': name,
      'thumbnails': thumbnails,
    };
    update();
  }

  followUser() async {
    var doc = await fireStore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .doc(authController.user.uid)
        .get();

    if (!doc.exists) {
      await fireStore
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .doc(authController.user.uid)
          .set({});
      await fireStore
          .collection('users')
          .doc(authController.user.uid)
          .collection('following')
          .doc(_uid.value)
          .set({});

      _user.value.update(
        'followers',
        (value) => (int.parse(value) + 1).toString(),
      );
    } else {
      await fireStore
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .doc(authController.user.uid)
          .delete();
      await fireStore
          .collection('users')
          .doc(authController.user.uid)
          .collection('following')
          .doc(_uid.value)
          .delete();

      _user.value.update(
        'followers',
        (value) => (int.parse(value) - 1).toString(),
      );
    }
    _user.value.update('isFollowing', (value) => !value);
    update();
  }
}
