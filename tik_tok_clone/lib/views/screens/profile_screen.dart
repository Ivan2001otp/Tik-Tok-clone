import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tik_tok_clone/controllers/profile_controller.dart';
import 'package:tik_tok_clone/util/constants.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileController.updateUserId(widget.uid);
  }

  Future<Uint8List?> _thumbnailImageRetriever(String path) async {
    return await VideoThumbnail.thumbnailData(
      video: path,
      imageFormat: ImageFormat.JPEG,
      quality: 25,
      maxWidth: 128,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (controller) {
      if (controller.user.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      debugPrint('${controller.user.entries}');
      Map<String, dynamic> response = controller.user;

      return SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.center,
              child: ClipOval(
                clipBehavior: Clip.hardEdge,
                child: CachedNetworkImage(
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  fit: BoxFit.fill,
                  height: 120,
                  width: 120,
                  imageUrl: response['profilePhoto'],
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                response['name'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      response['followers'].toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 30,
                      ),
                    ),
                    Text(
                      'Followers',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      response['likes'].toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 30,
                      ),
                    ),
                    Text(
                      'Likes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      response['following'].toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 30,
                      ),
                    ),
                    Text(
                      'Following',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: 140,
              height: 47,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey,
                  width: 3,
                ),
              ),
              child: Center(
                child: InkWell(
                  onTap: () {
                    if (widget.uid == authController.user.uid) {
                      authController.signOut();
                    } else {
                      controller.followUser();
                    }
                  },
                  child: Text(
                    widget.uid == authController.user.uid
                        ? 'Sign Out'
                        : controller.user['isFollowing']
                            ? 'Unfollow'
                            : 'Follow',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 50 / 100,
              child: FutureBuilder<Uint8List?>(
                  future: _thumbnailImageRetriever(
                    response['profilePhoto'],
                  ),
                  builder: (_, AsyncSnapshot<Uint8List?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.yellow,
                        ),
                      );
                    } else if (snapshot.hasData) {
                      return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                            crossAxisSpacing: 5,
                          ),
                          itemCount: controller.thumbnails.length,
                          itemBuilder: (context, index) {
                            String thumbnail = controller.thumbnails[index];

                            if (snapshot.data == null) {
                              return SizedBox();
                            }

                            //Need to revisit and fix the thumbnail problem.
                            // return Image.memory(
                            //   snapshot.data!,
                            //   fit: BoxFit.cover,
                            // );
                            return Container(
                              color: Colors.red,
                            );
                          });
                    }

                    return const Center(
                      child: Text(
                        'Something went wrong',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  }),

              /*
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1,
                        crossAxisSpacing: 5,
                      ),
                      itemCount: controller.thumbnails.length,
                      itemBuilder: (context, index) {
                        String thumbnail = controller.thumbnails[index];
          
                        return CachedNetworkImage(
                          imageUrl: thumbnail,
                          fit: BoxFit.cover,
                        );
                      }),
                */
            ),
          ],
        ),
      )
          /*body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: 'efa', //controller.user['profilePhoto'],
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '0', //controller.user['following'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        const Text(
                          'Following',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                    Container(
                      color: Colors.black54,
                      width: 1,
                      height: 15,
                      margin: EdgeInsets.symmetric(horizontal: 15),
                    ),
                    Column(
                      children: [
                        Text(
                          controller.user['followers'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          'Followers',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      color: Colors.black54,
                      width: 1,
                      height: 15,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          controller.user['likes'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Likes',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: 140,
                  height: 47,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black12,
                    ),
                  ),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        if (widget.uid == authController.user.uid) {
                          authController.signOut();
                        } else {
                          controller.followUser();
                        }
                      },
                      child: Text(
                        widget.uid == authController.user.uid
                            ? 'Sign Out'
                            : controller.user['isFollowing']
                                ? 'Unfollow'
                                : 'Follow',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      crossAxisSpacing: 5,
                    ),
                    itemCount: controller.thumbnails.length,
                    itemBuilder: (context, index) {
                      String thumbnail = controller.thumbnails[index];

                      return CachedNetworkImage(
                        imageUrl: thumbnail,
                        fit: BoxFit.cover,
                      );
                    })
             
              ],
            ),
          ),
        ),*/
          );
    });
  }
}
