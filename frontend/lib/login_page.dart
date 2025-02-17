import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'camera_screen.dart';
import 'user_info.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfo>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Log In"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                title("Email"),
                emailField(email),
                const SizedBox(height: 20),
                title("Password"),
                passwordField(password),
                const SizedBox(height: 40),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff108A7E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          login(email.text, password.text, userInfo);
                        }
                      },
                      child: const Text(
                        "LOG IN",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
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

  Widget title(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(
        text,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget emailField(TextEditingController email) {
    return TextFormField(
      controller: email,
      decoration: const InputDecoration(
        labelText: "Enter your email",
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter an email';
        } else if (!EmailValidator.validate(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  Widget passwordField(TextEditingController password) {
    return TextFormField(
      obscureText: true,
      controller: password,
      decoration: const InputDecoration(
        labelText: "Enter your password",
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password';
        }
        return null;
      },
    );
  }

  Future<void> login(String emailText, String passwordText, UserInfo userInfo) async {
    var url = Uri.parse('https://signify-10529.uc.r.appspot.com/login');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'email': emailText, 'password': passwordText}),
    );

    if (response.statusCode == 200) {
      String userId = jsonDecode(response.body)['id'];

      if (userId.isNotEmpty) {
        userInfo.setUserId(userId);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CameraScreen()),
        );
      } else {
        showErrorDialog("Incorrect password");
      }
    } else {
      showErrorDialog("Login failed. Please try again.");
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            message,
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
        );
      },
    );
  }
}

