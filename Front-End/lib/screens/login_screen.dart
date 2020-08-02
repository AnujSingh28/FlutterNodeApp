import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../components/rounded_button.dart';
import '../components/round_icon.dart';
import './registration_screen.dart';
import './vehicle_list_screen.dart';
import '../NetworkHandler.dart';

class LoginScreen extends StatefulWidget {
  static String screenID = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool vis = true;
  final _globalkey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String errorText;
  bool validate = false;
  bool circular = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: _globalkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Hero(
                    tag: 'appLogo',
                    child: Icon(
                      Icons.local_gas_station,
                      size: 100.0,
                      color: Colors.blue.shade200,
                    ),
                  ),
                  Text(
                    'Fuelio',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 48.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        TextFormField(
                          controller: _usernameController,
                          cursorColor: Colors.green,
                          decoration: InputDecoration(
                              errorText: validate ? "Incorrect Username" : null,
                              hintText: "Your Username",
                              hintStyle: TextStyle(color: Colors.grey)),
                          style: TextStyle(),
                          textAlign: TextAlign.start,
                          onChanged: (String value) {},
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          cursorColor: Colors.green,
                          obscureText: vis,
                          decoration: InputDecoration(
                              errorText: validate ? "Incorrect Password" : null,
                              suffixIcon: IconButton(
                                  icon: Icon(vis
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      vis = !vis;
                                    });
                                  }),
                              hintText: "Your Password",
                              hintStyle: TextStyle(color: Colors.grey)),
                          style: TextStyle(),
                          textAlign: TextAlign.start,
                          onChanged: (String value) {},
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        InkWell(
                          onTap: () {
                            print('hello');
                          },
                          child: Text(
                            "Forgot Password?",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: Colors.grey,
//                        decoration: TextDecoration.underline
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 35.0,
                        ),
                        circular
                            ? CircularProgressIndicator()
                            : RoundedButton(
                                text: 'Log In',
                                onPressed: () async {
                                  setState(() {
                                    circular = true;
                                  });
                                  Map<String, String> data = {
                                    "username": _usernameController.text,
                                    "password": _passwordController.text,
                                  };
                                  var response = await networkHandler.post(
                                      "/user/login", data);
                                  if (response.statusCode == 200 ||
                                      response.statusCode == 201) {
                                    Map<String, dynamic> output =
                                        json.decode(response.body);
                                    print(output["token"]);
                                    setState(() {
                                      validate = true;
                                      circular = false;
                                    });
                                    Navigator.pushNamed(
                                        context, VehicleListScreen.screenID);
                                  } else {
                                    String output = json.decode(response.body);
                                    print(output);
                                    validate = false;
                                    //errorText = output;
                                    circular = false;
                                  }
                                },
                                color: Colors.blueAccent,
                                textColor: Colors.white,
                              ),
                        Text(
                          "or",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
//                        decoration: TextDecoration.underline
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            RoundIcon(
                              icon: FontAwesomeIcons.facebookF,
                              onPressed: () {},
                            ),
                            RoundIcon(
                              icon: FontAwesomeIcons.googlePlusG,
                              onPressed: () {},
                            ),
                            RoundIcon(
                              icon: FontAwesomeIcons.twitter,
                              onPressed: () {},
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(
                                  context, RegistrationScreen.screenID);
                            },
                            child: Text(
                              'Register',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
