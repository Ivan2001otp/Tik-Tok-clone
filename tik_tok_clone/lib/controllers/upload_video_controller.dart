import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tik_tok_clone/model/video.dart';
import 'package:tik_tok_clone/util/constants.dart';
import 'package:video_compress/video_compress.dart' as VD;

class UploadVideoController extends GetxController {
  Future<File> _compressVideo(String videoPath) async {
    if (VD.VideoCompress.isCompressing) {
      await VD.VideoCompress.cancelCompression();
      await VD.VideoCompress.deleteAllCache();
    }
    final compressedVideo = await VD.VideoCompress.compressVideo(
      videoPath,
    );

    return compressedVideo!.file!;
  }

  _uploadVideoToStorage(String videoId, String videoPath) async {
    Reference ref = firebaseStorage.ref().child("videos").child(videoId);

    // File compressedVideo = await _compressVideo(videoPath);
    File uploadedVideoFile = File(videoPath);
    UploadTask uploadTask = ref.putFile(uploadedVideoFile);
    TaskSnapshot snap = await uploadTask;

    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  _getThumbnail(String videoPath) async {
    final thumbNail = await VD.VideoCompress.getFileThumbnail(videoPath);
    return thumbNail;
  }

  Future<String> _uploadImageToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child("thumbnails").child(id);
    UploadTask uploadTask = ref.putFile(
      await _getThumbnail(videoPath),
    );
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  //upload video
  uploadVideo(String songName, String caption, String videoPath) async {
    try {
      String uid = firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await fireStore.collection("users").doc(uid).get();
      var allDocs = await fireStore.collection("videos").get();
      int len = allDocs.docs.length;
      String videoUrl = await _uploadVideoToStorage("Video $len", videoPath);
      // String thumbnailUrl =
          // await _uploadImageToStorage("Video $len", videoPath); //thumbnail

      Video video = Video(
        username: (userDoc.data()! as Map<String, dynamic>)['name'],
        uid: uid,
        id: "Video $len",
        likes: [],
        commentCount: 0,
        shareCount: 0,
        songName: songName,
        caption: caption,
        videoUrl: videoUrl,
        profilePhoto: (userDoc.data()! as Map<String, dynamic>)['profilePhoto'],
        thumbNail: '',
      );

      await fireStore.collection("videos").doc("Video $len").set(
            video.toJson(),
          );

      Get.back();
    } catch (e) {
      debugPrint("Error while uploading video $e");
      Get.snackbar("Error Uploading Video", e.toString());
    }
  }
}
