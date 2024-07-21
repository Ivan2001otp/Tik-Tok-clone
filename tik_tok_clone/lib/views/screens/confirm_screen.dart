import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:tik_tok_clone/controllers/upload_video_controller.dart';
import 'package:tik_tok_clone/util/constants.dart';
import 'package:tik_tok_clone/views/widgets/text_input_field.dart';
import 'package:video_player/video_player.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'dart:io';

class ConfirmScreen extends StatefulWidget {
  final File videoFile;
  final String videoPath;

  ConfirmScreen({super.key, required this.videoFile, required this.videoPath});

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  late VideoPlayerController controller;
  FijkPlayer fijkPlayer = FijkPlayer();

  TextEditingController _songController = TextEditingController();
  TextEditingController _captionController = TextEditingController();
  UploadVideoController uploadVideoController =
      Get.put(UploadVideoController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    debugPrint("The url is ${widget.videoPath}");
    fijkPlayer.setDataSource(
      widget.videoPath,
      autoPlay: true,
      showCover: true,
    );
    fijkPlayer.setLoop(0);
    fijkPlayer.setVolume(0.5);
    fijkPlayer.stop();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    fijkPlayer.pause();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    fijkPlayer.release();
    fijkPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // const SizedBox(
            //   height: 10,
            // ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.sizeOf(context).height / 1.4,
              child: FijkView(
                color: backgroundColor,
                fit: FijkFit.fill,
                player: fijkPlayer,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    width: MediaQuery.sizeOf(context).width - 20,
                    child: TextInputField(
                      controller: _songController,
                      labelText: 'Song Name',
                      isObscure: false,
                      icon: Icons.music_note_rounded,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width - 20,
                    child: TextInputField(
                      controller: _captionController,
                      labelText: "Caption",
                      isObscure: false,
                      icon: Icons.closed_caption,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_songController.text.isNotEmpty &&
                          _captionController.text.isNotEmpty) {
                        EasyLoading.show(status: "Uploading..");

                        await uploadVideoController.uploadVideo(
                          _songController.text,
                          _captionController.text,
                          widget.videoPath,
                        );

                        EasyLoading.showSuccess(
                          "Success",
                        );
                        EasyLoading.dismiss();

                        Navigator.of(context).pop();
                      } else {
                        Get.snackbar(
                            "Hey Listen!", "Kindly add song name and caption!");
                      }
                    },
                    child: Text(
                      "Share !",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
