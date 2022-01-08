import 'package:flutter/material.dart';
import 'package:movies_webapp/providers/authentication.dart';
import 'package:movies_webapp/routing/route_names.dart';
import 'package:movies_webapp/services/firebase_services.dart';
import 'package:movies_webapp/services/navigation_service.dart';
import 'package:movies_webapp/widgets/custom_round_button.dart';
import 'package:movies_webapp/widgets/guest_dialog.dart';
import 'package:movies_webapp/widgets/logo_widget.dart';
import 'package:movies_webapp/widgets/textfield_widget.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';

import '../../dependencyInjection.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final userNameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String role = "customer";
  bool wannaBeManager = false;
  final _formKey = GlobalKey<FormState>();
  late bool isLoading;
  late bool isVisible1;
  late bool isVisible2;

  @override
  void initState() {
    super.initState();
    isVisible1 = false;
    isVisible2 = false;
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    AuthenticationProvider provider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    //: make the UI more Web/Mobile compatible i.e. check the size of the screen
    double customWidth = size.width > 700 ? 700 : size.width;
    //double customWidth = size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: SafeArea(
        child: isLoading
            ? Container(
                width: size.width,
                height: size.height,
                child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).accentColor,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              )
            : Stack(
                children: <Widget>[
                  Center(
                    child: SingleChildScrollView(
                      child: Container(
                        width: customWidth,
                        margin: EdgeInsets.all(customWidth * 0.075),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: customWidth * 0.075,
                          horizontal: customWidth * 0.06,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.03,
                                ),
                                child: Column(
                                  children: <Widget>[
                                    LogoWidget(),
                                  ],
                                ),
                              ),
                              TextFieldWidget(
                                keyboardType: TextInputType.text,
                                controller: userNameController,
                                hintText: 'User Name',
                                obscureText: false,
                                prefixIconData: Icons.person,
                                autoFocus: false,
                                validator: (value) {
                                  RegExp allEnglish =
                                      RegExp(r'^[A-Za-z][!-z]*$');
                                  if (value.isEmpty ||
                                      !allEnglish.hasMatch(value)) {
                                    return "Empty or Wrong User Name format!!";
                                  }
                                },
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              TextFieldWidget(
                                keyboardType: TextInputType.text,
                                controller: firstNameController,
                                hintText: 'First Name',
                                obscureText: false,
                                prefixIconData: Icons.person,
                                autoFocus: false,
                                validator: (value) {
                                  RegExp allEnglish =
                                      RegExp(r'^[A-Za-z][!-z]*$');
                                  if (value.isEmpty ||
                                      !allEnglish.hasMatch(value)) {
                                    return "Empty or Wrong First Name format!!";
                                  }
                                },
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              TextFieldWidget(
                                keyboardType: TextInputType.text,
                                controller: lastNameController,
                                hintText: 'Last Name',
                                obscureText: false,
                                prefixIconData: Icons.person,
                                autoFocus: false,
                                validator: (value) {
                                  RegExp allEnglish =
                                      RegExp(r'^[A-Za-z][!-z]*$');
                                  if (value.isEmpty ||
                                      !allEnglish.hasMatch(value)) {
                                    return "Empty or Wrong Last Name format!!";
                                  }
                                },
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              TextFieldWidget(
                                keyboardType: TextInputType.emailAddress,
                                controller: emailController,
                                hintText: 'Email',
                                obscureText: false,
                                prefixIconData: Icons.email,
                                autoFocus: false,
                                validator: (value) {
                                  RegExp allEnglish =
                                      RegExp(r'^[A-Za-z][!-z]*$');
                                  if (!value.contains("@") ||
                                      value.isEmpty ||
                                      !allEnglish.hasMatch(value)) {
                                    return "Wrong email format!!";
                                  }
                                },
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              TextFieldWidget(
                                controller: passwordController,
                                hintText: 'Password',
                                prefixIconData: Icons.lock,
                                obscureText: isVisible1 ? false : true,
                                suffixOnTap: () {
                                  setState(() {
                                    isVisible1 = !isVisible1;
                                  });
                                },
                                validator: (value) {
                                  RegExp passowrd = RegExp(
                                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
                                  if (value.length < 8) {
                                    return "Password must be at least 8 characters";
                                  } else if (!passowrd.hasMatch(value)) {
                                    return "Should contain at least 1 digit and 1 letter";
                                  }
                                },
                                autoFocus: false,
                                suffixIconData: isVisible1
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              TextFieldWidget(
                                controller: confirmPasswordController,
                                hintText: 'Confirm Password',
                                prefixIconData: Icons.lock,
                                obscureText: isVisible2 ? false : true,
                                suffixOnTap: () {
                                  setState(() {
                                    isVisible2 = !isVisible2;
                                  });
                                },
                                validator: (value) {
                                  RegExp passowrd = RegExp(
                                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
                                  if (value.length < 8) {
                                    return "Password must be at least 8 characters!";
                                  } else if (!passowrd.hasMatch(value)) {
                                    return "Should contain at least 1 digit and 1 lower letter and 1 upper letter!";
                                  } else if (value != passwordController.text) {
                                    return "Password and Confirm Password should be same!";
                                  }
                                },
                                autoFocus: false,
                                suffixIconData: isVisible2
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                width: size.width * 0.8,
                                color: Colors.white70,
                                child: Wrap(
                                  direction: Axis.horizontal,
                                  children: [
                                    ListTile(
                                      title: Text("Customer"),
                                      leading: Radio(
                                        hoverColor: !wannaBeManager
                                            ? Colors.white
                                            : Theme.of(context).accentColor,
                                        value: false,
                                        groupValue: wannaBeManager,
                                        onChanged: (_) {
                                          setState(() {
                                            wannaBeManager = false;
                                          });
                                        },
                                        fillColor: MaterialStateProperty.all(
                                          Theme.of(context).primaryColor,
                                        ),
                                        activeColor:
                                            Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    ListTile(
                                      title: Text("Manager"),
                                      leading: Radio(
                                        hoverColor: wannaBeManager
                                            ? Colors.white
                                            : Theme.of(context).accentColor,
                                        value: true,
                                        groupValue: wannaBeManager,
                                        onChanged: (_) {
                                          setState(() {
                                            wannaBeManager = true;
                                          });
                                        },
                                        fillColor: MaterialStateProperty.all(
                                          Theme.of(context).primaryColor,
                                        ),
                                        activeColor:
                                            Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              CustomRoundButton(
                                size: size,
                                text: 'Register',
                                onPress: () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    bool isRegistered = await provider.register(
                                        context,
                                        userNameController.text,
                                        firstNameController.text,
                                        lastNameController.text,
                                        emailController.text,
                                        passwordController.text,
                                        role,
                                        wannaBeManager);
                                    setState(() {
                                      isLoading = false;
                                    });
                                    if (isRegistered) {
                                      // ignore: deprecated_member_use
                                      Scaffold.of(context).showSnackBar(SnackBar(
                                          content: Text(
                                              'Register is successfully!')));
                                      setGlobalEmailAndPassword(
                                          emailController.text.trim(),
                                          passwordController.text);
                                      locator<NavigationService>()
                                          .navigateTo(LoginRoute);
                                    } else {
                                      // ignore: deprecated_member_use
                                      Scaffold.of(context).showSnackBar(SnackBar(
                                          content: Text(
                                              'Register failed please try again!')));
                                    }
                                  }
                                },
                              ),
                              SizedBox(
                                height: size.height * 0.025,
                              ),
                              GestureDetector(
                                onTap: () {
                                  dialogGuest(context);
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 4),
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'Login as Guest',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
