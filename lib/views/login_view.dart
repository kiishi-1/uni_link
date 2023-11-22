import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_link/resources/auth_methods.dart';
import 'package:uni_link/resources/navigation_service.dart';
import 'package:uni_link/router/routing_constants.dart';
// import 'package:instagram_clone/responsive/mobile_screen_Layout.dart';
// import 'package:instagram_clone/responsive/responsive_layout_screen.dart';
// import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:uni_link/utils/colors.dart';
import 'package:uni_link/utils/global_variables.dart';
import 'package:uni_link/views/sign_up_view.dart';
import 'package:uni_link/widgets/text_field_input.dart';
import 'package:uni_link/widgets/uni_link_flush_bar.dart';

import 'home.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);

    if (res == "Login Successful") {
      NavigationService.instance.navigateToReplace(
        NavigatorRoutes.home,
      );
      UniLinkFlushBar.showSuccess(
        // context: NavigationService.instance.navigatorKey.currentContext!,
        message: res,
        title: "Success",
      );
      setState(() {
        _isLoading = false;
      });
    } else {
      UniLinkFlushBar.showFailure(
        // context: NavigationService.instance.navigatorKey.currentContext!,
        message: res,
        title: "Login Error",
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  void navigateToSignup() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SignupView()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: MediaQuery.of(context).size.width > webScreenSize
            ? EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 32)
            : const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: ListView(
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 120,
            ),
            //svg image
            // SvgPicture.asset(
            //   "assets/ic_instagram.svg",
            //   color: primaryColor,
            //   height: 64,
            // ),
            Text(
              "UniLink",
              style: GoogleFonts.notoSansMeroitic(
                color: primaryColor,
                // fontSize: 70,
                fontSize: 55,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 45,
            ),
            //text field input for email
            TextFieldInput(
                textEditingController: _emailController,
                hintText: "Enter your Email",
                textInputType: TextInputType.emailAddress),
            const SizedBox(
              height: 24,
            ),
            //text field input for password
            TextFieldInput(
              textEditingController: _passwordController,
              hintText: "Enter your password",
              textInputType: TextInputType.text,
              isPass: true,
            ),
            const SizedBox(
              height: 24,
            ),
            //login button
            InkWell(
              onTap: loginUser,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                width: double.infinity,
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                  color: secondColor,
                ),
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFEAEAEB),
                        ),
                      )
                    : const Text("Log in"),
              ),
            ),
            const SizedBox(
              height: 12,
            ),

            //transitioning to sign up
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text("Don't have an account? "),
                ),
                GestureDetector(
                  onTap: () {
                    NavigationService.instance.navigateToReplace(
                      NavigatorRoutes.signup,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      "Sign up",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
