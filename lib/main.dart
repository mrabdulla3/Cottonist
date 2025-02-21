import 'package:cottonist/credentials/auth_preference.dart';
import 'package:cottonist/views/dashboards/director_dashboard.dart';
import 'package:cottonist/views/dashboards/grader_dashboard.dart';
import 'package:cottonist/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  try {
    await dotenv.load(fileName: ".env"); // Load environment variables
  } catch (e) {
    throw Exception('Error loading .env file: $e'); // Print error if any
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final authPreferences = Get.put(AuthPreferences());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Cottonist',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: authPreferences.isLogged(), // Check login status
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator()); // Show loading indicator
          } else if (snapshot.hasData && snapshot.data == true) {
            if (authPreferences.userrole == "grader") {
              return const GraderDashboard();
            } else if (authPreferences.userrole == "Director") {
              return const DirectorDashboard();
            } else {
              return LoginScreen();
            }
          } else {
            return LoginScreen(); // Redirect to Login if not logged in
          }
        },
      ),
    );
  }
}
