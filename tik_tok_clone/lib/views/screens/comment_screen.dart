import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tik_tok_clone/controllers/comment_controller.dart';
import 'package:tik_tok_clone/util/constants.dart';
import 'package:timeago/timeago.dart' as tago;

class CommentScreen extends StatelessWidget {
  final String id;
  CommentScreen({
    required this.id,
    Key? key,
  }) : super(key: key);

  final TextEditingController _commentEditingController =
      TextEditingController();
  CommentController _commentController = Get.put(CommentController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _commentController.updatePostId(id);

    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: Column(
              children: [
                Expanded(
                  child: Obx(() {
                    return ListView.builder(
                        itemCount: _commentController.comments.length,
                        itemBuilder: (context, index) {
                          final comment = _commentController.comments[index];

                          return Column(
                            children: [
                              
                              ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                leading: CircleAvatar(
                                  radius: 24,
                                  backgroundColor: Colors.black54,
                                  backgroundImage: NetworkImage(
                                    comment.profilePhoto,
                                  ),
                                ),
                                title: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      comment.username,
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      comment.comment,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                                subtitle: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          tago.format(
                                              comment.datePublished.toDate()),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          '${comment.likes.length} likes',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: InkWell(
                                  onTap: () {
                                    _commentController.likeComment(comment.id);
                                  },
                                  child: comment.likes
                                          .contains(authController.user.uid)
                                      ? Icon(
                                          Icons.favorite,
                                          size: 25,
                                          color: Colors.red,
                                        )
                                      : Icon(
                                          Icons.favorite_outline,
                                          size: 25,
                                          color: Colors.white,
                                        ),
                                ),
                              ),
                              const Divider(
                                endIndent: 10,
                                indent: 10,
                                thickness: 4.0,
                              ),
                            ],
                          );
                        });
                  }),
                ),
                ListTile(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.white,
                      style: BorderStyle.solid,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  title: TextField(
                    controller: _commentEditingController,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Comment',
                      labelStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w700,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  trailing: TextButton(
                    onPressed: () {
                      if (_commentEditingController.text.isNotEmpty) {
                        _commentController
                            .postComment(_commentEditingController.text.trim());

                        _commentEditingController.clear();
                      }
                    },
                    child: Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
