import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tik_tok_clone/model/comment.dart';
import 'package:tik_tok_clone/util/constants.dart';

class CommentController extends GetxController {
  final Rx<List<Comment>> _comments = Rx<List<Comment>>([]);

  List<Comment> get comments => _comments.value;

  String _postId = "";

  updatePostId(String id) {
    _postId = id;
    getComment();
  }

  likeComment(String id) async {
    var uid = authController.user.uid;
    DocumentSnapshot doc = await fireStore
        .collection('videos')
        .doc(_postId)
        .collection("comments")
        .doc(id)
        .get();


      if((doc.data()! as dynamic)['likes'].contains(uid)){
        await fireStore
        .collection('videos')
        .doc(_postId)
        .collection('comments')
        .doc(id)
        .update({
          'likes':FieldValue.arrayRemove([uid]),
        });
      }else{
        await fireStore
        .collection('videos')
        .doc(_postId)
        .collection('comments')
        .doc(id)
        .update({
          'likes':FieldValue.arrayUnion([uid]),
        });
      }

  }

  getComment() async {
    _comments.bindStream(
      fireStore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .snapshots()
          .map((QuerySnapshot query) {
        List<Comment> returnValue = [];

        for (var element in query.docs) {
          returnValue.add(Comment.fromSnap(element));
        }
        return returnValue;
      }),
    );
  }

  postComment(String commentText) async {
    try {
      if (commentText.isNotEmpty) {
        DocumentSnapshot userDoc = await fireStore
            .collection("users")
            .doc(authController.user.uid)
            .get();

        var allDocs = await fireStore
            .collection("videos")
            .doc(_postId)
            .collection("comments")
            .get();
        int len = allDocs.docs.length;

        Comment comment = Comment(
          username: (userDoc.data()! as dynamic)['name'],
          comment: commentText.trim(),
          datePublished: DateTime.now(),
          likes: [],
          profilePhoto: (userDoc.data()! as dynamic)['profilePhoto'],
          uid: authController.user.uid,
          id: 'Comment $len',
        );

        await fireStore
            .collection('videos')
            .doc(_postId)
            .collection('comments')
            .doc('Comment $len')
            .set(comment.toJson());

        //commennt count
        DocumentSnapshot doc =
            await fireStore.collection('videos').doc(_postId).get();

        await fireStore.collection('videos').doc(_postId).update({
          "commentCount": (doc.data()! as dynamic)['commentCount'] + 1,
        });
      }
    } catch (e) {
      Get.snackbar("Error while Commenting", e.toString());
    }
  }
}
