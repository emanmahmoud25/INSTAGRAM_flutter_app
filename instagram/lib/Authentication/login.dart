import 'package:flutter/Material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram/Authentication/signup.dart';
import 'package:instagram/Constants/Colors.dart';
import 'package:instagram/Constants/Global_Variables.dart';
import 'package:instagram/Constants/image_picker.dart';
import 'package:instagram/Constants/images_assets.dart';
import 'package:instagram/resources/Auth_Method.dart';

import '../Responsive/mobile screen_layout.dart';
import '../Responsive/responsive_layout.dart';
import '../Responsive/web_screen_layout.dart';
import '../Widgets/text_form_field.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUsers() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);
    if (res == "success") {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout(),
              )));
      // Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else {
      ShowSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  Widget build(BuildContext context) {
    void navigateToSignUp() {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const SignUp(),
      ));
    }

    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: MediaQuery.of(context).size.width > WebScreenSize
            ? EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 3)
            : EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Flexible(
            child: Container(),
            flex: 2,
          ),
          SvgPicture.asset(
            AppImageAsset.logo,
            color: primaryColor,
            height: 64,
          ),
          const SizedBox(height: 64),
          TextEditingForm(
            hinttext: "Enter Your Email",
            textEditingController: _emailController,
            textInputType: TextInputType.emailAddress,
          ),
          const SizedBox(
            height: 24,
          ),
          TextEditingForm(
            hinttext: "Enter Your Password",
            textEditingController: _passwordController,
            ispass: true,
            textInputType: TextInputType.text,
          ),
          const SizedBox(
            height: 24,
          ),
          InkWell(
            onTap: loginUsers,
            child: Container(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: primaryColor,
                    ))
                  : const Text("Login"),
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
          const SizedBox(
            height: 12,
          ),
          Flexible(
            child: Container(),
            flex: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text("Don't have an account?"),
              ),
              GestureDetector(
                // to make it clickable
                onTap: navigateToSignUp,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: const Text(
                    "Sign up",
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
