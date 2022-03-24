import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mdpflutterproject/Services/email.dart';
import 'package:splashscreen/splashscreen.dart';

import 'Screens/signUpPage.dart';
import 'Screens/myNotes.dart';
import 'Widgets/button.dart';
import 'Widgets/textBox.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Start(),
      theme: ThemeData.light(),
    );
  }
}

class Start extends StatelessWidget { //start is the first loading page
  const Start({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      backgroundColor: Color.fromARGB(255, 131, 129, 129),
      seconds: 5,
      navigateAfterSeconds: HomeScreen(),
      title: Text("My Notes",
          style: GoogleFonts.oswald(
            fontSize: 40,
            color: Color.fromARGB(255, 255, 166, 0),
          )),
      image: Image.asset(
        'images/splash.png',
      ),
      photoSize: 100,
      loaderColor: Color.fromARGB(255, 238, 166, 0),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FocusNode myfocus = FocusNode();
  final AuthenticationServices _auth = AuthenticationServices();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  "My Notes",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.oswald(fontSize: 70, color: Color.fromARGB(255, 255, 166, 0)),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Center(
                child: Image(
                  image: AssetImage(
                    'images/login.png',
                  ),
                  height: size.height * 0.3,
                  width: size.width * 0.7,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: EntryField(
                      textEditingController: _emailController,
                      label: "Email Address",
                      hide: false,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: EntryField(
                      textEditingController: _passwordController,
                      label: "Password",
                      hide: true,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RoundedButton(
                      text: "Log In",
                      onPressed: () async {
                        dynamic result = await _auth.loginUser(
                            _emailController.text, _passwordController.text);
                        if (result == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Login Unsucessful!")));
                        } else {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => Todo(
                                        uid: _auth.getUid(),
                                        auth: _auth.user(),
                                      )));
                        }
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Divider(
                  thickness: 2,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: GoogleFonts.oswald(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return Email();
                      }));
                    },
                    child: Text(
                      "Sign Up",
                      style: GoogleFonts.oswald(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 255, 166, 0)),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
