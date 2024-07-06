import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tik_tok_clone/util/constants.dart';
import 'package:tik_tok_clone/views/screens/confirm_screen.dart';

class AddVideoScreen extends StatelessWidget {
  const AddVideoScreen({super.key});

  pickVideo(ImageSource src, BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: src);

    if (video != null) {
      //confirma page
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => ConfirmScreen(),
      //   ),
      // );
    }
  }

  showOptionsDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          SimpleDialogOption(
            onPressed: () {
              pickVideo(ImageSource.gallery, context);
            },
            child: Row(
              children: [
                Icon(Icons.image),
                Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Text(
                    "Gallery",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              pickVideo(ImageSource.camera, context);
            },
            child: Row(
              children: [
                Icon(Icons.camera_alt_outlined),
                Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Text(
                    "Camera",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Row(
              children: [
                Icon(Icons.cancel),
                Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Text(
                    "Cancel",
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: () {
            showOptionsDialog(context);
          },
          child: Container(
            width: 190,
            height: 50,
            decoration: BoxDecoration(
                color: buttonColor, borderRadius: BorderRadius.circular(12)),
            child: Center(
              child: Text(
                'Add Video',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
