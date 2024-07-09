import 'package:flutter/material.dart';
import 'package:pretty_animated_buttons/configs/pkg_colors.dart';
import 'package:sustainable_moving/Screens/navBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

/* Login page, si passa con ID: "a", PASS: "a" per semplicità, i controller sono
 * messi nel dispose come suggerito per liberare memoria. 
 *
 * TODO: Fare in modo che non richiede ogni volta il login, ma lo salvi in 
 * shared preference, sicchè lo bypassi 
 * TESTARE SE VA*/

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
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

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
                    SizedBox(height: 60),
                    Positioned(
                      top: 0.0, // Adjust position as needed
                      left: 0,
                      right: 0,
                      child: Transform.scale(
                        scale: 1.8, // Adjust the scale factor as needed
                        child: Image.asset(
                          'assets/LogoClean.png',
                          width: 200, // Adjust size as needed
                        ),
                      ),
                    ),
                    SizedBox(height: 60),
                    TextField(
                      controller: _usernameController,
                      cursorColor: Colors.black,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors
                                  .black, // Colore del bordo quando selezionato
                            ),
                          ),
                          labelText: 'Username',
                          labelStyle: TextStyle(color: Colors.black),
                          hintText: 'Enter username',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors
                                  .black, // Colore del bordo quando abilitato e non selezionato
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          )),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      obscureText: true,
                      controller: _passwordController,
                      cursorColor: Colors.black,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors
                                .black, // Colore del bordo quando selezionato
                          ),
                        ),
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.black),
                        hintText: 'Enter password',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors
                                .black, // Colore del bordo quando abilitato e non selezionato
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextButton.icon(
                      onPressed: () {
                        _login();
                      },
                      icon: const Icon(Icons.login, color: Colors.white),
                      label: const Text('Login',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w400)),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color.fromARGB(255, 9, 166, 14),
                      ),
                    ),
                    if (_wrongCredentials)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Wrong credentials',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    SizedBox(height: 105),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    if (username == 'a' && password == 'a') {
      // Save login status
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

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

  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // Navigate to the homepage if already logged in
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => NavBar()));
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
