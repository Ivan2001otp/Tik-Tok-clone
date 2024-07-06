import 'package:flutter/material.dart';
import 'package:tik_tok_clone/util/constants.dart';
import 'package:tik_tok_clone/views/widgets/text_input_field.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Tik Tok',
            style: TextStyle(
              fontSize: 35,
              color: buttonColor,
              fontWeight: FontWeight.w900,
            ),
          ),
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                    'https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png'),
                backgroundColor: Colors.white,
              ),
              Positioned(
                left: 50,
                bottom: -12,
                child: IconButton(
                  onPressed: () {
                    debugPrint("Clicked on photo");
                    authController.pickImage();
                  },
                  icon: Icon(
                    Icons.add_circle_rounded,
                    color: Colors.blue,
                    size: 25,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: TextInputField(
              controller: _userNameController,
              labelText: 'User Name',
              isObscure: false,
              icon: Icons.person_2_outlined,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: TextInputField(
              controller: _emailController,
              labelText: 'Email',
              isObscure: false,
              icon: Icons.email,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: TextInputField(
              controller: _passwordController,
              labelText: 'Password',
              isObscure: true,
              icon: Icons.password,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            width: MediaQuery.of(context).size.width - 40,
            height: 50,
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            child: InkWell(
              onTap: () {
                debugPrint("sign up clicked");

                authController.registerUser(
                  _userNameController.text,
                  _emailController.text,
                  _passwordController.text,
                  authController.ProfilePhoto,
                );
              },
              child: Center(
                child: Text(
                  "SIGN UP",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an acccount?  ',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                ' Login',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: buttonColor,
                ),
              )
            ],
          )
        ],
      ),
    ));
  }
}
