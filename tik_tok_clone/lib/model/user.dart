import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String name;
  String profilePhoto;
  String email;
  String uid;
  String password;

  User({
    required this.name,
    required this.profilePhoto,
    required this.email,
    required this.uid,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "profilePhoto": profilePhoto,
        "email": email,
        "uid": uid,
        "password":password,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      name: snap['name'],
      profilePhoto: snap['profilePhoto'],
      email: snap['email'],
      uid: snap['uid'],
      password: snap['password'],
    );
  }
}
