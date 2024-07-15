import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        ),
      ),
    );
  }
}
