import 'package:flutter/material.dart';
import 'package:frontend/theme_model.dart';
import 'package:frontend/user_info.dart';
import 'package:provider/provider.dart';
import 'package:frontend/history.dart';
import 'custom_theme.dart';
import 'login_page.dart';

class MySettingsPage extends StatefulWidget {
  const MySettingsPage({Key? key}) : super(key: key);

  @override
  _MySettingsPageState createState() => _MySettingsPageState();
}

class _MySettingsPageState extends State<MySettingsPage> {
  // Method to show Font Size Pop-Up dialog
  void _showFontSizePopUp(ThemeNotifier themeNotifier) async {
    final selectedFontSize = await showDialog<double>(
      context: context,
      builder: (context) => FontSizePopUp(
        initialFontSize: themeNotifier.getFontSize(),
        themeNotifier: themeNotifier,
      ),
    );

    if (selectedFontSize != null) {
      themeNotifier.setFontSize(selectedFontSize);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final userInfo = Provider.of<UserInfo>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // History button
            TextButton.icon(
              icon: const Icon(
                Icons.access_time,
                size: 24.0,
              ),
              label: const Text(
                "History",
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              style: TextButton.styleFrom(
                  padding: const EdgeInsets.only(left: 15),
                  alignment: Alignment.centerLeft),
              onPressed: () {
                if (userInfo.getUserId.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HistoryPage()),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
                        content: Text(
                          'Login to view history page',
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        ),
                      );
                    },
                  );
                }
              },
            ),
            // Dark/Light theme button
            TextButton.icon(
              icon: const Icon(
                Icons.mode_night_outlined,
                size: 24.0,
              ),
              label: const Text(
                "Dark/Light Mode",
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              style: TextButton.styleFrom(
                  padding: const EdgeInsets.only(left: 15),
                  alignment: Alignment.centerLeft),
              onPressed: () {
                themeNotifier.changeThemeMode();
              },
            ),
            // Theme Color button
            TextButton.icon(
              icon: const Icon(
                Icons.border_color_outlined,
                size: 24.0,
              ),
              label: const Text(
                "Theme Color",
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              style: TextButton.styleFrom(
                  padding: const EdgeInsets.only(left: 15),
                  alignment: Alignment.centerLeft),
              onPressed: () {
                _chooseThemeColor(themeNotifier);
              },
            ),
            // Text size button
            TextButton.icon(
              icon: const Icon(
                Icons.format_size_sharp,
                size: 24.0,
              ),
              label: const Text(
                "Text Size",
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              style: TextButton.styleFrom(
                  padding: const EdgeInsets.only(left: 15),
                  alignment: Alignment.centerLeft),
              onPressed: () {
                _showFontSizePopUp(themeNotifier);
              },
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
              indent: 15,
              endIndent: 15,
            ),
            _loginLogout(userInfo)
          ],
        ),
      ),
    );
  }

  // Pop-up window for color theme selection
  void _chooseThemeColor(ThemeNotifier themeNotifier) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Choose Theme Color"),
          content: Container(
            width: 50,
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              mainAxisSpacing: 30,
              padding: const EdgeInsets.only(top: 20),
              children: [
                _colorCircle(themeNotifier, Colors.pink, 'pink'),
                _colorCircle(themeNotifier, defaultColor, 'default'),
                _colorCircle(themeNotifier, Colors.orange, 'orange'),
                _colorCircle(themeNotifier, Colors.brown, 'brown'),
                _colorCircle(themeNotifier, Colors.lightBlue, 'lightBlue'),
                _colorCircle(themeNotifier, Colors.purple, 'purple'),
              ],
            ),
          ),
        );
      },
    );
  }

  // Color circle button
Widget _colorCircle(
    ThemeNotifier themeNotifier, MaterialColor color, String colorString) {
  return ElevatedButton(
    onPressed: () {
      themeNotifier.setThemeColor(color, colorString);
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: color,  // Corrected property name
      shape: const CircleBorder(),
    ),
    child: null,
  );
}


  // Display login or logout button based on user status
  Widget _loginLogout(UserInfo userInfo) {
    IconData icon1 = userInfo.getUserId.isEmpty ? Icons.login : Icons.logout;
    String label1 = userInfo.getUserId.isEmpty ? "Login" : "Log out";

    return TextButton.icon(
      icon: Icon(
        icon1,
        size: 24.0,
      ),
      label: Text(
        label1,
        style: TextStyle(fontWeight: FontWeight.w900),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.only(left: 15),
        alignment: Alignment.centerLeft,
      ),
      onPressed: () {
        if (userInfo.getUserId.isNotEmpty) {
          userInfo.setUserId('');
        }
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      },
    );
  }
}

class FontSizePopUp extends StatefulWidget {
  final double initialFontSize;
  final ThemeNotifier themeNotifier;

  const FontSizePopUp({Key? key, required this.initialFontSize, required this.themeNotifier}) : super(key: key);

  @override
  _FontSizePopUpState createState() => _FontSizePopUpState();
}

class _FontSizePopUpState extends State<FontSizePopUp> {
  double _fontSize = 0;

  @override
  void initState() {
    super.initState();
    _fontSize = widget.initialFontSize;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Font Size'),
      insetPadding: const EdgeInsets.symmetric(vertical: 280, horizontal: 50),
      content: Column(
        children: <Widget>[
          Slider(
            value: _fontSize,
            max: 30,
            min: 10,
            divisions: 20,
            label: _fontSize.round().toString(),
            onChanged: (double value) {
              setState(() {
                _fontSize = value;
                widget.themeNotifier.setFontSize(_fontSize);
              });
            },
          ),
          Text(
            "SIGNify",
            style: TextStyle(fontSize: _fontSize),
          )
        ],
      ),
    );
  }
}
