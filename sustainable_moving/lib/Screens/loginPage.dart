import 'package:flutter/material.dart';
import 'package:pretty_animated_buttons/configs/pkg_colors.dart';
import 'package:sustainable_moving/Screens/navBar.dart';
import 'package:pretty_animated_buttons/pretty_animated_buttons.dart';

/* Login page, si passa con ID: "a", PASS: "a" per semplicità, i controller sono
 * messi nel dispose come suggerito per liberare memoria. 
 *
 * TODO: Fare in modo che non richiede ogni volta il login, ma lo salvi in 
 * shared preference, sicchè lo bypassi */

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const routename = 'loginPage';

  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _wrongCredentials = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28.0,
          ),
        ),
        centerTitle: true,
        titleSpacing: 0,
      ),
      body: DefaultTabController(
        length: 6,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Username',
                        hintText: 'Enter username',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      obscureText: true,
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        hintText: 'Enter password',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    PrettyCapsuleButton(
                      label: 'Login'.toUpperCase(),
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                      bgColor: Colors.blue,
                      onPressed: () {
                        _login();
                      },
                    ),
                    if (_wrongCredentials)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Wrong credentials',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _login() {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    if (username == 'a' && password == 'a') {
      // Navigate to the homepage if credentials are correct
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => NavBar()));
    } else {
      // Show message for wrong credentials
      setState(() {
        _wrongCredentials = true;
      });
      // Hide message after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _wrongCredentials = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
