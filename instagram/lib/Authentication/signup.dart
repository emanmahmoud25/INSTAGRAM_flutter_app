import 'dart:typed_data';

import 'package:flutter/Material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/Authentication/login.dart';
import 'package:instagram/Constants/Colors.dart';
import 'package:instagram/Constants/image_picker.dart';
import 'package:instagram/Constants/images_assets.dart';
import 'package:instagram/resources/Auth_Method.dart';

import '../Responsive/mobile screen_layout.dart';
import '../Responsive/responsive_layout.dart';
import '../Responsive/web_screen_layout.dart';
import '../Widgets/text_form_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void SelectImage() async {
    Uint8List im = await PickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void SignUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().SignUpUsers(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        bio: _bioController.text,
        file: _image!);
    setState(() {
      _isLoading = false;
    });
    if (res != 'Success') {
      ShowSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout(),
              )));
    }
  }

  Widget build(BuildContext context) {
    void navigateToLogin() {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const Login(),
      ));
    }

    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          // Flexible(
          //   child: Container(),
          //   flex: 2,
          // ),
          SvgPicture.asset(
            AppImageAsset.logo,
            color: primaryColor,
            height: 64,
          ),
          const SizedBox(height: 50),
          Stack(
            children: [
              _image != null
                  ? CircleAvatar(
                      radius: 64,
                      backgroundImage: MemoryImage(_image!),
                    )
                  : const CircleAvatar(
                      radius: 64,
                      backgroundImage: AssetImage(
                        AppImageAsset.signup,
                      )),
              Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                      onPressed: SelectImage, icon: Icon(Icons.add_a_photo)))
            ],
          ),
          const SizedBox(
            // height: 24,
            height: 10,
          ),
          TextEditingForm(
            hinttext: "Enter Your Username",
            textEditingController: _usernameController,
            textInputType: TextInputType.text,
          ),
          const SizedBox(
            // height: 24,
            height: 10,
          ),
          TextEditingForm(
            hinttext: "Enter Your Email",
            textEditingController: _emailController,
            textInputType: TextInputType.emailAddress,
          ),
          const SizedBox(
            // height: 24,
            height: 10,
          ),
          TextEditingForm(
            hinttext: "Enter Your Password",
            textEditingController: _passwordController,
            ispass: true,
            textInputType: TextInputType.text,
          ),
          const SizedBox(
            // height: 24,
            height: 10,
          ),
          TextEditingForm(
            hinttext: "Enter Your bio",
            textEditingController: _bioController,
            textInputType: TextInputType.text,
          ),
          const SizedBox(
            // height: 24,
            height: 10,
          ),
          InkWell(
            onTap: SignUpUser,
            child: Container(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    )
                  : const Text("Sign Up"),
              width: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: const ShapeDecoration(
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4))),
              ),
              // color: Colors.blue,
            ),
          ),
          // SizedBox(
          //   height: 12,
          // ),
          // Flexible(
          //   child: Container(),
          //   flex: 2,
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                // padding: EdgeInsets.symmetric(vertical: 8),
                child: Text("Don't have an account?"),
              ),
              GestureDetector(
                // to make it clickable
                onTap: navigateToLogin,
                child: Container(
                  // padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    "login",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          )
        ]),
      )),
    );
  }
}
