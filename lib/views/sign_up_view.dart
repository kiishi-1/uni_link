import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uni_link/resources/auth_methods.dart';
import 'package:uni_link/resources/navigation_service.dart';
import 'package:uni_link/router/routing_constants.dart';
import 'package:uni_link/utils/colors.dart';
import 'package:uni_link/utils/utils.dart';
import 'package:uni_link/views/home.dart';
import 'package:uni_link/views/login_view.dart';
import 'package:uni_link/widgets/text_field_input.dart';
import 'package:uni_link/widgets/uni_link_flush_bar.dart';

class SignupView extends StatefulWidget {
  const SignupView({Key? key}) : super(key: key);

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  //AuthMethods _authMethods = AuthMethods();
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage(ImageSource source) async {
    Uint8List? im = await pickImage(source);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    FocusScope.of(context).unfocus();
    if (_image == null) {
      UniLinkFlushBar.showFailure(
        message: "Input data in required field",
        title: "Notice",
      );
    } else {
      setState(() {
        _isLoading = true;
      });
      String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: _image!,
      );

      if (res != "Registration Successful") {
        UniLinkFlushBar.showFailure(
          // context: NavigationService.instance.navigatorKey.currentContext!,
          message: res,
          title: "Registration Error",
        );
        setState(() {
          _isLoading = false;
        });
      } else {
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
      }
    }
  }

  void navigateToLogin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginView()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),

            Text(
              "UniLink",
              style: GoogleFonts.notoSansMeroitic(
                color: primaryColor,
                fontSize: 55,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 45,
            ),
            //circular widget to accept and show our selected file
            Center(
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : const CircleAvatar(
                          radius: 75,
                          backgroundImage: NetworkImage(
                            "https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg",
                          ),
                        ),
                  Positioned(
                    bottom: -10,
                    left: 90,
                    child: IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            clipBehavior: Clip.hardEdge,
                            // constraints: BoxConstraints(
                            //   //minHeight: (MediaQuery.sizeOf(context).height * 2) / 3,
                            // ),
                            //showDragHandle: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(17),
                                topRight: Radius.circular(17),
                              ),
                            ),
                            builder: (context) => Container(
                                  color: mobileBackgroundColor,
                                  padding: const EdgeInsets.all(10),
                                  height: 120,
                                  width: double.infinity,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          selectImage(ImageSource.camera);
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(
                                          Icons.camera_alt,
                                          color: secondColor,
                                          size: 35,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          selectImage(ImageSource.gallery);
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(
                                          Icons.image,
                                          color: secondColor,
                                          size: 35,
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                      },
                      icon: const Icon(
                        Icons.add_a_photo,
                        color: secondColor,
                        size: 25,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            //text field input for username
            TextFieldInput(
                textEditingController: _usernameController,
                hintText: "Enter your username",
                textInputType: TextInputType.text),
            const SizedBox(
              height: 24,
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
            //text field input for bio
            TextFieldInput(
                textEditingController: _bioController,
                hintText: "Enter your bio",
                textInputType: TextInputType.text),
            const SizedBox(
              height: 24,
            ),
            //login button
            InkWell(
              onTap: signUpUser,
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
                    : const Text("sign up"),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            const SizedBox(
              height: 20,
            ),
            //transitioning to sign up
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text("have an account already?  "),
                ),
                GestureDetector(
                  onTap: () {
                    NavigationService.instance.navigateToReplace(
                      NavigatorRoutes.login,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      "Log in",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 45,
            ),
          ],
        ),
      )),
    );
  }
}
