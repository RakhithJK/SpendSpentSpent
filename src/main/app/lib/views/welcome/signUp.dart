import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/models/appColors.dart';
import 'package:spend_spent_spent/models/user.dart';
import 'package:spend_spent_spent/utils/colorUtils.dart';
import 'package:spend_spent_spent/utils/stringUtils.dart';
import 'package:spend_spent_spent/views/login.dart';

class SignUp extends StatefulWidget {
  Function onBack;
  String server;
  Key key;

  SignUp({required this.onBack, required this.server, required this.key});

  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  TextEditingController usernameController = TextEditingController(),
      passwordController = TextEditingController(),
      repeatPasswordController = TextEditingController(),
      firstNameController = TextEditingController(),
      lastNameController = TextEditingController();
  String error = '';

  Future<void> signup(BuildContext context) async {
    setState(() {
      error = '';
    });

    User user =
        User(email: usernameController.text.trim(), firstName: firstNameController.text.trim(), lastName: lastNameController.text.trim(), password: passwordController.text.trim(), isAdmin: false);

    if (user.email.length == 0 || user.password?.length == 0 || user.firstName.length == 0 || user.lastName.length == 0) {
      setState(() {
        error = 'Please fill all the fields';
      });

      return;
    }

    if (!isValidEmail(user.email)) {
      setState(() {
        error = 'Please input a valid email';
      });
      return;
    }

    if (user.password != repeatPasswordController.text) {
      setState(() {
        error = 'Passwords don\'t match';
      });
      return;
    }

    try {
      bool result = await service.signUp(widget.server, user);
    } catch (e) {
      setState(() {
        error = e.toString();
      });
      return;
    }

    await Fluttertoast.showToast(
        msg: "Sign up successful, you can now log in",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);

    widget.onBack();
  }

  @override
  Widget build(BuildContext context) {
    AppColors colors = get(context);
    return Padding(
      padding: const EdgeInsets.all(70.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Container(alignment: Alignment.centerLeft, child: Text('Email', style: TextStyle(color: colors.textOnMain))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PlatformTextField(
              controller: usernameController,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              material: (_, __) => MaterialTextFieldData(decoration: getFieldDecoration("Email", "user@example.org", colors)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Container(alignment: Alignment.centerLeft, child: Text('Password', style: TextStyle(color: colors.textOnMain))),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: PlatformTextField(
                controller: passwordController,
                obscureText: true,
                material: (_, __) => MaterialTextFieldData(decoration: getFieldDecoration("Password", "", colors)),
              )),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Container(alignment: Alignment.centerLeft, child: Text('Repeat Password', style: TextStyle(color: colors.textOnMain))),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: PlatformTextField(
                controller: repeatPasswordController,
                obscureText: true,
                material: (_, __) => MaterialTextFieldData(decoration: getFieldDecoration("Password", "", colors)),
              )),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Container(alignment: Alignment.centerLeft, child: Text('First name', style: TextStyle(color: colors.textOnMain))),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: PlatformTextField(
                controller: firstNameController,
                keyboardType: TextInputType.name,
                autocorrect: false,
                material: (_, __) => MaterialTextFieldData(decoration: getFieldDecoration("First name", "John", colors)),
              )),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Container(alignment: Alignment.centerLeft, child: Text('Last name', style: TextStyle(color: colors.textOnMain))),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: PlatformTextField(
                controller: lastNameController,
                keyboardType: TextInputType.name,
                autocorrect: false,
                material: (_, __) => MaterialTextFieldData(decoration: getFieldDecoration("Last name", "Doe", colors)),
              )),
          Visibility(
            visible: error.length > 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  decoration: BoxDecoration(borderRadius: defaultBorder, color: Colors.red.shade400),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(error),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: PlatformElevatedButton(color: colors.mainDark, onPressed: () => signup(context), child: Text('Sign up')),
                ),
              ],
            ),
          ),
          TextButton(
              onPressed: () => widget.onBack(),
              child: Text(
                'Back',
                style: TextStyle(color: colors.text),
              ))
        ],
      ),
    );
  }
}
