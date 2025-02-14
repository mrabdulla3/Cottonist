import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController orgAddController = TextEditingController();
  TextEditingController dirNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  bool isLoading = false;

  Future<void> signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      String url = 'https://www.shreshtacotton.com/api/register/';
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Something went wrong. Please try again.")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

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
                  'assets/logo.png', // Your logo here
                  height: screenHeight * 0.15,
                  width: screenWidth * 0.3,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Title
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

                    _buildTextField("Organization Name", nameController,
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

                    SizedBox(height: 10),

                    // Sign-Up Button
                    SizedBox(
                      width: double.infinity,
                      child: isLoading
                          ? const SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                              ),
                            )
                          : ElevatedButton(
                              onPressed: signUp,
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
                    SizedBox(height: 10),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              // Already have an account?
              const Text("Already have an account?"),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
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
          if (value == null || value.isEmpty) {
            return "$label is required";
          }
          if (label == "Email" &&
              !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return "Enter a valid email";
          }
          if (label == "Mobile Number" &&
              !RegExp(r'^[0-9]{10}$').hasMatch(value)) {
            return "Enter a valid mobile number";
          }
          if (label == "Password" && value.length < 6) {
            return "Password must be at least 6 characters";
          }
          if (label == "Confirm Password" && value != passwordController.text) {
            return "Passwords do not match";
          }
          return null;
        },
      ),
    );
  }
}
