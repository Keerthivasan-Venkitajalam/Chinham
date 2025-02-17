import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:frontend/user_info.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'camera_screen.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccount createState() => _CreateAccount();
}

class _CreateAccount extends State<CreateAccount> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController confirm = TextEditingController();
  bool _passwordVisibleFirst = false;
  bool _passwordVisibleConfirm = false;

  @override
  void initState() {
    super.initState();
    _passwordVisibleFirst = false;
    _passwordVisibleConfirm = false;
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfo>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Create Account"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title("What is your email?"),
              emailField(),
              const SizedBox(height: 20),
              title("Create a password"),
              passwordFieldFirst(),
              const SizedBox(height: 5),
              passwordHint(),
              const SizedBox(height: 20),
              title("Confirm password"),
              passwordFieldConfirm(),
              const SizedBox(height: 5),
              passwordHint(),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    backgroundColor: const Color(0xff108A7E),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      createAccount(email.text, pass.text, userInfo);
                    }
                  },
                  child: const Text(
                    "Create Account",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ],
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
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget passwordHint() {
    return const Text(
      "Use at least 8 characters",
      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
    );
  }

  Widget emailField() {
    return TextFormField(
      controller: email,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: "Email",
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

  Widget passwordFieldFirst() {
    return TextFormField(
      obscureText: !_passwordVisibleFirst,
      controller: pass,
      decoration: InputDecoration(
        labelText: "Password",
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            _passwordVisibleFirst ? Icons.visibility : Icons.visibility_off,
            color: const Color(0xff108A7E),
          ),
          onPressed: () {
            setState(() {
              _passwordVisibleFirst = !_passwordVisibleFirst;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password';
        } else if (value.length < 8) {
          return 'Password must be at least 8 characters';
        }
        return null;
      },
    );
  }

  Widget passwordFieldConfirm() {
    return TextFormField(
      obscureText: !_passwordVisibleConfirm,
      controller: confirm,
      decoration: InputDecoration(
        labelText: "Confirm Password",
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            _passwordVisibleConfirm ? Icons.visibility : Icons.visibility_off,
            color: const Color(0xff108A7E),
          ),
          onPressed: () {
            setState(() {
              _passwordVisibleConfirm = !_passwordVisibleConfirm;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        } else if (value.length < 8) {
          return 'Password must be at least 8 characters';
        } else if (value != pass.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  Future<void> createAccount(String emailText, String passwordText, UserInfo userInfo) async {
    var url = Uri.parse('https://signify-10529.uc.r.appspot.com/register');

    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'email': emailText, 'password': passwordText}),
      );

      var responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 && responseBody['id'] != null) {
        userInfo.setUserId(responseBody['id']);

        // Navigate to CameraScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CameraScreen()),
        );
      } else {
        showErrorDialog("Email already exists or registration failed.");
      }
    } catch (e) {
      showErrorDialog("An error occurred. Please try again.");
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            message,
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
