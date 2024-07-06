import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class ConfirmScreen extends StatefulWidget {
  final File videoFile;

  final String videoPath;
  ConfirmScreen({super.key, required this.videoFile, required this.videoPath});

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
    );
  }
}
