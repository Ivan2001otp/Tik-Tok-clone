import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:tik_tok_clone/model/user.dart' as model;
import 'package:tik_tok_clone/util/constants.dart';
import 'package:tik_tok_clone/views/screens/auth/login_screen.dart';
import 'package:tik_tok_clone/views/screens/home_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find<AuthController>();
  late Rx<File?> _pickedImage;
  late Rx<User?> _user;

  File? get ProfilePhoto => _pickedImage.value;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => HomeScreen());
    }
  }

  void pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      Get.snackbar("Profile Picture", "Updated successfully!");
      _pickedImage = Rx<File?>(File(pickedImage!.path));
      return;
    }

    Get.snackbar("Error", "Something went wrong while uploading image!");
  }

  //upload to storeage
  Future<String> _uploadToStorage(File image) async {
    // Reference ref = await firebaseStorage
    //     .ref()
    //     .child("profilePics")
    //     .child(firebaseAuth.currentUser!.uid);
    Reference ref_ = await FirebaseStorage.instanceFor(
      app: firebaseStorage.app,
      bucket: firebaseStorage.bucket,
    ).ref().child("profile_pic").child(firebaseAuth.currentUser!.uid);

    await ref_.putFile(image);

    String downloadUrl = await ref_.getDownloadURL();
    return downloadUrl;
  }

  //register user
  void registerUser(
      String userName, String email, String password, File? image) async {
    try {
      if (userName.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        UserCredential userCredential =
            await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String downloadUrl = await _uploadToStorage(image);
        model.User user = model.User(
          name: userName,
          email: email,
          uid: userCredential.user!.uid,
          profilePhoto: downloadUrl,
          password: password,
        );

        await fireStore
            .collection("users")
            .doc(userCredential.user!.uid)
            .set(user.toJson());

        Get.snackbar("Account Created", "SUCCESS !");
      } else {
        Get.snackbar('Error creating Account', "Please enter all the fields.");
      }
    } catch (e) {
      Get.snackbar('Error creating Account', e.toString());
    }
  }

  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        print("Logged in sucess");

        Get.snackbar("Success", "Logged in successfully !");
      } else {
        Get.snackbar("Error creating Account!", "Error Login!");
      }
    } catch (e) {
      Get.snackbar(
        "Error creating Account!",
        e.toString(),
      );
    }
  }
}
