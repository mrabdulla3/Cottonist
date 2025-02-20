import 'package:cottonist/credentials/auth_preference.dart';
import 'package:cottonist/views/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cottonist/controller/login_controller.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

final loginController = Get.put(LoginController());

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Form key to manage validation
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  
  
  void validateAndLogin() {
    if (_formKey.currentState!.validate()) {
      loginController.login(usernameController.text, passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F3E8),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.1),

            // Logo
            Center(
              child: Image.asset(
                'assets/images/logo.png',
                height: screenHeight * 0.15,
                width: screenWidth * 0.3,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            const Text(
              "Welcome Back!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: screenHeight * 0.03),

            Container(
              width: screenWidth * 0.85,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Form(
                key: _formKey, // Assigning the form key
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Login Account",
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),

                    // Username Field
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person_2_outlined),
                        labelText: "Username",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Username is required!";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),

                    // Password Field
                    Obx(() => TextFormField(
                          controller: passwordController,
                          obscureText: loginController.isPasswordHidden.value,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock_outline),
                            labelText: "Password",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            suffixIcon: IconButton(
                              onPressed: () {
                                loginController.isPasswordHidden.value =
                                    !loginController.isPasswordHidden.value;
                              },
                              icon: Icon(
                                loginController.isPasswordHidden.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Password is required!";
                            }
                            if (value.length < 6) {
                              return "Password must be at least 6 characters!";
                            }
                            return null;
                          },
                        )),
                    SizedBox(height: 10),

                    // Forgot Password
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: const Text("Forgot Password?",
                                style: TextStyle(color: Colors.blue)),
                          ),
                        ],
                      ),
                    ),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      child: Obx(
                        () => loginController.isLoading.value
                            ? const SizedBox(
                                height: 30,
                                width: 30,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                  ),
                                ),
                              )
                            : ElevatedButton(
                                onPressed: validateAndLogin, // Call validation method
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF65B845),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: const Text("Login Account",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                              ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            const Text("Don't Have an Account?"),
            TextButton(
              onPressed: () {
                Get.offAll(() => SignUpScreen());
              },
              child: const Text(
                "Create Account",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
