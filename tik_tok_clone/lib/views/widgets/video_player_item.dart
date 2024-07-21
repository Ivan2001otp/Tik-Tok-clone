import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerItem({required this.videoUrl, super.key});

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  // late VideoPlayerController videoPlayerController;

  late FijkPlayer fijkPlayer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fijkPlayer = FijkPlayer();
    fijkPlayer.setDataSource(
      widget.videoUrl,
      showCover: true,
      autoPlay: true,
    );
    fijkPlayer.setVolume(0.5);
    fijkPlayer.setLoop(0);
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    fijkPlayer.pause();

    super.deactivate();
    // videoPlayerController.pause();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // videoPlayerController.dispose();
    fijkPlayer.release();
    fijkPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        color: Colors.black,
        // gradient: LinearGradient(colors: colors)
      ),
      child: FijkView(
        player: fijkPlayer,
        color: Colors.black54,
        fit: FijkFit.contain,
      ),
    );
  }
}
