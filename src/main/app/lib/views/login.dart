import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:spend_spent_spent/globals.dart' as globals;
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/icons.dart';

class Login extends StatefulWidget {
  Function onLoginSuccess;

  Login({required this.onLoginSuccess});

  @override
  _LoginState createState() => _LoginState();
}

InputDecoration getFieldDecoration(String label, String hint) {
  return InputDecoration(
      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: Colors.white);
}

class _LoginState extends State<Login> {
  final urlController = TextEditingController(text: "https://sss.ftpix.com");
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String error = '';

  Future<void> logIn() async {
    try {
      await globals.service.setUrl(urlController.text);
      var loggedIn = await globals.service.login(usernameController.text, passwordController.text);
      setState(() {
        error = '';
      });
      if (loggedIn) {
        FBroadcast.instance().broadcast(globals.BROADCAST_LOGGED_IN);
        print(loggedIn);
        widget.onLoginSuccess();
      }
    } catch (e) {
      setState(() {
        error = e.toString().replaceFirst("Exception: ", '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    MediaQueryData mq = MediaQuery.of(context);
    bool tablet = isTablet(mq);

    double width = mq.size.width;
    double height = mq.size.height;

    if (tablet) {
      width = 500;
      height = 600;
    }

    return Column(
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: AnimatedContainer(
              width: width,
              height: height,
              duration: panelTransition,
              curve: Curves.easeInOutQuart,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3), //color of shadow
                      spreadRadius: 2, //spread radius
                      blurRadius: 3, // blur radius
                      offset: Offset(0, 2), // changes position of shadow
                      //first paramerter of offset is left-right
                      //second parameter is top to down
                    ),
                    //you can set more BoxShadow() here
                  ],
                  gradient: LinearGradient(colors: [Colors.blueAccent, Colors.blue], stops: [0, 0.5], begin: Alignment.bottomCenter, end: Alignment.topRight),
                  borderRadius: BorderRadius.circular(tablet ? 20 : 0)),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(bottom: bottom),
                  child: Container(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: globals.defaultBorder,
                            ),
                            child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Padding(padding: const EdgeInsets.all(8.0), child: getIcon('groceries_bag', size: 200, color: Colors.white)),
                                    Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: PlatformTextField(
                                          showCursor: true,
                                          material: (_, __) => MaterialTextFieldData(decoration: getFieldDecoration('Server Url', 'https://sss.ftpix.com')),
                                          controller: urlController,
                                          autocorrect: false,
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: PlatformTextField(
                                        controller: usernameController,
                                        autocorrect: false,
                                        material: (_, __) => MaterialTextFieldData(decoration: getFieldDecoration("Email", "user@example.org")),
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: PlatformTextField(
                                          controller: passwordController,
                                          obscureText: true,
                                          material: (_, __) => MaterialTextFieldData(decoration: getFieldDecoration("Password", "")),
                                        )),
                                    Visibility(
                                      visible: error.length > 0,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(error),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextButton(style: globals.flatButtonStyle, onPressed: logIn, child: Text('Log in')),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ))),
                      )
                    ],
                  )),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
