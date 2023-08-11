import 'package:flutter_library_managent/features/auth/presentation/providers/state/auth_notifier.dart';
import 'package:flutter_library_managent/features/auth/presentation/screen/sign_in_screen.dart';
import 'package:flutter_library_managent/features/auth/presentation/widget/animatiom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/model/user_model.dart';

class SignUp extends ConsumerStatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  ConsumerState<SignUp> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String? username;
  String? email;
  String? password;
  String? confirmPassword;

  // make handle register method fro user model and AuthStateNotifier
  void handleRegister(
      BuildContext context, AuthStateNotifier authnotifier) async {
    final result = await authnotifier.register(
      UserModel(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
      ),
    );

    result.fold(
      (exception) {
        // Handle login failure
        print('Login failed: ${exception.error}');
        Navigator.pushNamed(context, "/register");
      },
      (isLoggedIn) {
        // Handle login success
        Navigator.pushNamed(context, "/login");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;

    var authregisterprovider = ref.watch(authStateNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          color: Color.fromARGB(255, 0, 0, 0),
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
                context); // Navigate back when the back button is pressed
          },
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          height: 900,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                Container(
                  height: 200,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Image.asset(
                    'assets/images/guitar.jpg', // Replace with your guitar banner image path
                    height: double.infinity, // Set height to fill the container
                    width: double.infinity, // Set width to fill the container
                    fit: BoxFit
                        .cover, // Make the image cover the entire container without stretching
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        AnimationWidget(
                          axis: Axis.vertical,
                          curve: Curves.easeOutExpo,
                          offset: 100.0,
                          duration: const Duration(milliseconds: 1000),
                          child: SizedBox(
                            width: double.infinity,
                            child: Column(
                              children: [
                                const SizedBox(height: 10.0),
                                TextFormField(
                                  key: const ValueKey('txtName'),
                                  controller: nameController,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your name';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      username = value;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "Enter Name",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                TextFormField(
                                  key: const ValueKey('txtEmail'),
                                  controller: emailController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: (value) {
                                    setState(() {
                                      email = value;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "Email Address",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                TextFormField(
                                  key: const ValueKey('txtPassword'),
                                  controller: passwordController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    if (value.length < 8) {
                                      return 'Password must be at least 8 characters';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  obscureText: true,
                                  onChanged: (value) {
                                    setState(() {
                                      password = value;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "Password",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                TextFormField(
                                  key: const ValueKey('txtConfirmPassword'),
                                  controller: confirmPasswordController,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your confirm password';
                                    }
                                    if (value.length < 8) {
                                      return 'Password must be at least 8 characters';
                                    }
                                    if (value != password) {
                                      return 'Password not match';
                                    }
                                    return null;
                                  },
                                  obscureText: true,
                                  onChanged: (value) {
                                    setState(() {
                                      confirmPassword = value;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "Confirm Password",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 40.0),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Color.fromARGB(255, 223, 44, 12),
                                    minimumSize:
                                        const Size.fromHeight(50), // NEW
                                  ),
                                  key: const ValueKey('btnRegister'),
                                  onPressed: () {
                                    handleRegister(
                                        context, authregisterprovider);
                                  },
                                  child: const Text("Create Account"),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget orSignIn(String image, int duration) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return AnimationWidget(
      axis: Axis.vertical,
      curve: Curves.easeOutExpo,
      offset: 100.0,
      duration: Duration(milliseconds: duration),
      child: Container(
        height: myHeight * 0.08,
        width: myWidth * 0.16,
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(5.0)),
        child: Center(
          child: Image.asset(image, height: 30.0),
        ),
      ),
    );
  }
}
