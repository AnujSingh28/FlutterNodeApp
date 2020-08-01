import 'package:flutter/material.dart';
import 'package:sih2020/NetworkHandler.dart';
import 'package:sih2020/components/rounded_button.dart';
import 'package:sih2020/components/round_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sih2020/screens/login_screen.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static String screenID = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool vis = true;
  final _globalkey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String errorText;
  bool validate = false;
  bool circular = false;
  checkUser() async {
    if (_usernameController.text.length == 0) {
      setState(() {
        circular = false;
        validate = false;
        errorText = "Username can't be empty";
      });
    } else {
      var response = await networkHandler
          .get("/user/checkusername/${_usernameController.text}");
      if (response["Status"]) {
        setState(() {
          validate = false;
          errorText = "Username already taken";
        });
      } else {
        setState(() {
          validate = true;
        });
      }
    }
  }

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
                              errorText: validate ? null : errorText,
                              hintText: "Your Username",
                              hintStyle: TextStyle(color: Colors.grey)),
                          style: TextStyle(),
                          textAlign: TextAlign.start,
                          onChanged: (String value) {},
                        ),
                        TextFormField(
                          controller: _emailController,
                          validator: (value) {
                            if (value.isEmpty) return "Email can't be empty";
                            if (!value.contains("@")) return "Email is invalid";
                            return null;
                          },
                          cursorColor: Colors.green,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              hintText: "Your Email",
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
                          validator: (value) {
                            if (value.isEmpty) return "Password can't be empty";
                            return null;
                          },
                          cursorColor: Colors.green,
                          obscureText: vis,
                          decoration: InputDecoration(
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
                          height: 8.0,
                        ),
                        SizedBox(
                          height: 35.0,
                        ),
                        circular
                            ? CircularProgressIndicator()
                            : RoundedButton(
                                text: 'Register',
                                onPressed: () async {
                                  setState(() {
                                    circular = true;
                                  });
                                  await checkUser();
                                  if (_globalkey.currentState.validate() &&
                                      validate) {
                                    Map<String, String> data = {
                                      "username": _usernameController.text,
                                      "password": _passwordController.text,
                                      "email": _emailController.text
                                    };
                                    await networkHandler.post(
                                        "/user/register", data);
                                    setState(() {
                                      circular = false;
                                    });
                                    Navigator.pushNamed(
                                        context, LoginScreen.screenID);
                                  } else {
                                    setState(() {
                                      circular = false;
                                    });
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
                          "Already have an account? ",
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
                                  context, LoginScreen.screenID);
                            },
                            child: Text(
                              'Log in',
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
