import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tik_tok_clone/controllers/auth_controller.dart';
import 'package:tik_tok_clone/views/screens/add_video_screen.dart';
import 'package:tik_tok_clone/views/screens/search_screen.dart';
import 'package:tik_tok_clone/views/screens/video_screen.dart';

const backgroundColor = Color.fromARGB(223, 14, 13, 13);
const buttonColor = Color.fromARGB(219, 255, 255, 255);
const borderColor = Colors.grey;

var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var fireStore = FirebaseFirestore.instance;

var authController = AuthController.instance;

List pages = [
  // Text("home screen"),
  VideoScreen(),
 SearchScreen(),
  AddVideoScreen(),
  Text("message screen"),
  Text("profile screen"),
];
