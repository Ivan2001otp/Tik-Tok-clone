import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tik_tok_clone/controllers/search_controller.dart' as Search;
import 'package:tik_tok_clone/model/user.dart';
import 'package:tik_tok_clone/views/screens/profile_screen.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});
  Search.SearchController _searchController =
      Get.put(Search.SearchController());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(95, 72, 71, 71),
          title: TextFormField(
            decoration: InputDecoration(
              icon: Icon(
                Icons.search,
                size: 24,
                color: Colors.white,
              ),
              filled: false,
              focusColor: Colors.white,
              hintText: 'Search for Users...',
              hintStyle: TextStyle(
                fontSize: 16,
                color: Colors.blueGrey,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onFieldSubmitted: (value) => _searchController.searchUser(value),
          ),
        ),
        body: _searchController.searchUsers.isEmpty
            ? const Center(
                child: Text(
                  'Search for users',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: _searchController.searchUsers.length,
                itemBuilder: (context, index) {
                  User searchedUser = _searchController.searchUsers[index];

                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              ProfileScreen(uid: searchedUser.uid),
                        ),
                      );
                    },
                    child: ListTile(
                      contentPadding: EdgeInsets.only(top: 6, left: 10),
                      minVerticalPadding: 4,
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundImage:
                            NetworkImage(searchedUser.profilePhoto),
                      ),
                      title: Text(
                        searchedUser.name,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }),
      );
    });
  }
}
