import 'package:cottonist/controller/addGrader_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddGrader extends StatefulWidget {
  const AddGrader({super.key});
  @override
  AddGraderState createState() => AddGraderState();
}

class AddGraderState extends State<AddGrader> {
  final _formKey = GlobalKey<FormState>();
  final signupController = Get.put(AddgraderController());

  TextEditingController orgNameController = TextEditingController();
  TextEditingController orgAddController = TextEditingController();
  TextEditingController graderNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  String selectedRole = 'grader'; // Default role
  List<String> role = ["grader"];

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
              Center(
                child: Text(
                  "Grader Form",
                  style: GoogleFonts.aboreto(
                      fontWeight: FontWeight.w700, fontSize: 23),
                ),
              ),

              SizedBox(height: screenHeight * 0.03),
              // Sign-Up Form Container
              Container(
                width: screenWidth * 0.85,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
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
                    Text("Add Grader",
                        style: GoogleFonts.raleway(
                            fontWeight: FontWeight.w700, fontSize: 18)),
                    const SizedBox(height: 15),
                    _buildTextField("Organization Name", orgNameController,
                        Icons.business, false),
                    _buildTextField("Organization Address", orgAddController,
                        Icons.location_on, false),
                    _buildTextField("Grader Name", graderNameController,
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
                          prefixIcon: const Icon(Icons.people),
                        ),
                        items: role.map((String role) {
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
                        const Spacer(),
                        ElevatedButton.icon(
                          onPressed: () {
                            signupController.pickLogo();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF65B845)),
                          icon: const Icon(
                            Icons.upload,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Upload Logo",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
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
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }
                                  signupController.signUp(
                                      orgNameController.text,
                                      orgAddController.text,
                                      graderNameController.text,
                                      mobileController.text,
                                      emailController.text,
                                      userNameController.text,
                                      passwordController.text,
                                      selectedRole,
                                      signupController.selectedImage.value!);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF65B845),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: Text("Add Grader",
                                    style: GoogleFonts.lato(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: 16)),
                              ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.03),
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
