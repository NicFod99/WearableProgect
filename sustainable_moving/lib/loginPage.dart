import 'package:flutter/material.dart';
import 'package:sustainable_moving/home.dart';
import 'package:sustainable_moving/homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const routename = 'loginPage';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _wrongCredentials = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        titleSpacing: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Username',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              obscureText: true,
              controller: _passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Password',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _login();
              },
              child: const Text('Login'),
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
    );
  }

  void _login() {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    if (username == 'a' && password == 'a') {
      // Navigate to the homepage if credentials are correct
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ChoosePage()));
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
} //HomePage//HomePage



