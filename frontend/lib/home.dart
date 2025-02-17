import 'package:flutter/material.dart';
import 'package:frontend/create_account.dart';
import 'package:frontend/login_page.dart';
import 'package:frontend/camera_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Color(0xffADD7D3), Colors.white],
          ),
        ),
        child: Container(
          margin: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 10,
            top: MediaQuery.of(context).size.height * 0.25,
          ),
          child: Column(
            children: [
              Container(
                height: 250,
                width: 250,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage("assets/images/logo.png"),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
              ),
              Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: 350,
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          backgroundColor: const Color(0xff108A7E),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CreateAccount(),
                            ),
                          );
                        },
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: 350,
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "LOG IN",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CameraScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Continue As Guest',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationThickness: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
