import 'package:flutter/material.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // setState(() {
    //fijkplayer
    // controller = VideoPlayerController.networkUrl(Uri.parse(
    // 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'));

    // });

    // controller.initialize();
    // controller.play();
    // controller.setVolume(0.5);
    // controller.setLooping(true);

    fijkPlayer.setDataSource(
       'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4');
    fijkPlayer.setLoop(0);
    fijkPlayer.setVolume(0.5);
    fijkPlayer.start();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    fijkPlayer.dispose();
    // controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.sizeOf(context).height / 1.5,
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
                    onPressed: () {},
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
