import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:who_gets_this/screens/forgot_password.dart';

import '../constant.dart';
import '../core/store.dart';
import './signup_screen.dart';
import '../widgets/taost.dart';
import '../widgets/logo_design.dart';
import '../core/authentication.dart';

class LogInScreen extends StatefulWidget {
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formKey = GlobalKey<FormState>();
  MyStore store = VxState.store;

  String _email;
  String _password;

  void _save() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {
        Authentication.loginUserFromFirebase(
            context: context, email: _email.trim(), password: _password.trim());
      } catch (error) {
        const errorMessage = 'Internet connection too slow';
        toast(errorMessage, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: mq.height,
          ),
          child: Stack(
            children: [
              buildBackContainer(context, mq),
              buildInputContainer(mq),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBackContainer(BuildContext context, Size mq) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: mq.height * 0.5,
          decoration: boxDecoration(),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: mq.height * 0.05,
                ),
                LogoDesign(),
                SizedBox(
                  height: mq.height * 0.05,
                ),
                const Text(
                  'Login',
                  style: TextStyle(
                      color: Colors.white, fontSize: 36, fontFamily: 'Raleway'),
                ),
              ],
            ),
          ),
        ),
        Spacer(),
        VxBuilder(
          builder: (_, __, ___) {
            return store.isLoading == false
                ? buildLogInButton(mq)
                : SpinKitHourGlass(
                    color: kPrimaryColor,
                  );
          },
          mutations: {ToggleLoading},
        ),
        buildDontHaveAccount(context),
        SizedBox(
          height: mq.height * 0.015,
        ),
      ],
    );
  }

  Widget buildInputContainer(Size mq) {
    return Positioned(
      left: mq.width * 0.055,
      right: mq.width * 0.055,
      top: mq.height * 0.36,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 1,
        child: Container(
          width: mq.width * 0.8,
          padding: EdgeInsets.only(
              left: mq.width * 0.05,
              right: mq.width * 0.05,
              top: mq.height * 0.04,
              bottom: mq.height * 0.01),
          decoration: BoxDecoration(
            color: kSecondaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                buildEmailField(),
                SizedBox(height: mq.height * 0.02),
                buildPasswordField(),
                buildForgotPassword(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEmailField() {
    return Container(
      color: Colors.white,
      child: TextFormField(
        cursorColor: kPrimaryColor,
        style: textStyle(),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Email',
          hintStyle: hintStyle(),
          border: border(),
          focusedBorder: focusedBorder(),
        ),
        // ignore: missing_return
        validator: (_value) {
          if (_value.isEmpty) {
            return kEmailNullError;
          }
          bool emailValid = emailValidatorRegExp.hasMatch(_value);
          if (!emailValid) {
            return kInvalidEmailError;
          }
        },
        onSaved: (_value) {
          _email = _value;
        },
      ),
    );
  }

  Widget buildPasswordField() {
    return Container(
      color: Colors.white,
      child: TextFormField(
        cursorColor: kPrimaryColor,
        style: textStyle(),
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Password',
          hintStyle: hintStyle(),
          border: border(),
          focusedBorder: focusedBorder(),
        ),
        // ignore: missing_return
        validator: (_value) {
          if (_value.isEmpty) {
            return kPassNullError;
          }
        },
        onSaved: (_value) {
          _password = _value;
        },
      ),
    );
  }

  Widget buildLogInButton(Size mq) {
    return GestureDetector(
      onTap: _save,
      child: Container(
        height: mq.height * 0.065,
        width: mq.width * 0.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [kButtonColor.withOpacity(0.8), kButtonColor],
          ),
        ),
        child: Center(
          child: const Text(
            'LOGIN',
            style: TextStyle(
                fontSize: 16,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget buildDontHaveAccount(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Don\'t have an account?',
          style: TextStyle(fontSize: 15, fontFamily: 'Raleway'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              CupertinoPageRoute(
                builder: (ctx) => SignUpScreen(),
              ),
            );
          },
          child: const Text(
            'Signup',
            style: TextStyle(color: kPrimaryColor, fontFamily: 'Raleway'),
          ),
        ),
      ],
    );
  }

  Widget buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (ctx) => ForgotPasswordScreen(),
            ),
          );
        },
        child: Text(
          'Forgot Password?',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
