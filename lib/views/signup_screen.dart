import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cottonist/controller/signup_controller.dart';
import 'package:cottonist/views/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final signupController = Get.put(SignupController());

  TextEditingController orgNameController = TextEditingController();
  TextEditingController orgAddController = TextEditingController();
  TextEditingController dirNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  String selectedRole = 'Director';
  List<String> roles = ["Director"];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F3E8),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
                "Create Account",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: screenHeight * 0.03),

              // Sign-Up Form Container
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Sign Up",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    _buildTextField("Organization Name", orgNameController,
                        Icons.business, false),
                    _buildTextField("Organization Address", orgAddController,
                        Icons.location_on, false),
                    _buildTextField("Director Name", dirNameController,
                        Icons.person, false),
                    _buildTextField(
                        "Mobile Number", mobileController, Icons.phone, false,
                        keyboardType: TextInputType.phone),
                    _buildTextField(
                        "Email", emailController, Icons.email, false,
                        keyboardType: TextInputType.emailAddress),
                    _buildTextField("Username", userNameController,
                        Icons.account_circle, false),
                    _buildTextField(
                        "Password", passwordController, Icons.lock, true),
                    _buildTextField("Confirm Password", confirmPassController,
                        Icons.lock, true),

                    // Role Dropdown
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: (10 / 800) * screenHeight,
                      ),
                      child: DropdownButtonFormField<String>(
                        value: selectedRole,
                        decoration: InputDecoration(
                          labelText: "Select Role",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          prefixIcon: Icon(Icons.people),
                        ),
                        items: roles.map((String role) {
                          return DropdownMenuItem<String>(
                            value: role,
                            child: Text(role),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedRole = value!;
                          });
                        },
                      ),
                    ),

                    // Logo Upload
                    Row(
                      children: [
                        Obx(
                          () => signupController.selectedImage.value == null
                              ? const Text("No logo selected")
                              : const Text("logo is selected"),
                        ),
                        Spacer(),
                        ElevatedButton.icon(
                          onPressed: () {
                            signupController.pickLogo();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          icon: Icon(
                            Icons.upload,
                            color: Colors.white,
                          ),
                          label: Text(
                            "Upload Logo",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      child: Obx(
                        () => signupController.isLoading.value
                            ? const SizedBox(
                                height: 30,
                                width: 30,
                                child: Center(
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2.5)),
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  if (!_formKey.currentState!.validate())
                                    return;
                                  signupController.signUp(
                                      orgNameController.text,
                                      orgAddController.text,
                                      dirNameController.text,
                                      mobileController.text,
                                      emailController.text,
                                      userNameController.text,
                                      passwordController.text,
                                      selectedRole,
                                      signupController.selectedImage.value!);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: const Text("Create Account",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                              ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              const Text("Already have an account?"),
              TextButton(
                onPressed: () {
                  Get.to(() => LoginScreen());
                },
                child: const Text(
                  "Login",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      IconData icon, bool isPassword,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return "$label is required";
          if (label == "Email" &&
              !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value))
            return "Enter a valid email";
          if (label == "Mobile Number" &&
              !RegExp(r'^[0-9]{10}$').hasMatch(value))
            return "Enter a valid mobile number";
          if (label == "Password" && value.length < 6)
            return "Password must be at least 6 characters";
          if (label == "Confirm Password" && value != passwordController.text)
            return "Passwords do not match";
          return null;
        },
      ),
    );
  }
}
