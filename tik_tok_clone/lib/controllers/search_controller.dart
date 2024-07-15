import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tik_tok_clone/model/user.dart';
import 'package:tik_tok_clone/util/constants.dart';

class SearchController extends GetxController {
  final Rx<List<User>> _searchedUsers = Rx<List<User>>([]);

  List<User> get searchUsers => _searchedUsers.value;

  searchUser(String typedUser) async {
    _searchedUsers.bindStream(
      fireStore
          .collection('users')
          .where('name', isGreaterThanOrEqualTo: typedUser)
          .snapshots()
          .map((QuerySnapshot query) {
        List<User> returnValue = [];
        for (var element in query.docs) {
          returnValue.add(User.fromSnap(element));
        }
        return returnValue;
      }),
    );
  }
}
