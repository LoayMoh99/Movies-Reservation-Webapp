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

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  late bool isLoading;
  late bool isVisible;

  @override
  void initState() {
    super.initState();
    isVisible = false;
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    emailController.text = "loay@test.com";
    passwordController.text = "12345678";
    AuthenticationProvider provider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    //: make the UI more Web/Mobile compatible i.e. check the size of the screen
    double customWidth = size.width > 600 ? 600 : size.width;
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
                    backgroundColor: Theme.of(context).primaryColor,
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
                        child: Column(
                          children: <Widget>[
                            // Center(
                            //   child: Text(
                            //     'Movies Reservations Webapp',
                            //     style: TextStyle(
                            //       color: Theme.of(context).primaryColor,
                            //       fontSize: 46,
                            //       fontWeight: FontWeight.bold,
                            //       letterSpacing: 1.5,
                            //     ),
                            //   ),
                            // ),
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
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              hintText: 'Email',
                              obscureText: false,
                              prefixIconData: Icons.person,
                              autoFocus: false,
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            TextFieldWidget(
                              controller: passwordController,
                              hintText: 'Password',
                              prefixIconData: Icons.lock,
                              obscureText: isVisible ? false : true,
                              suffixOnTap: () {
                                setState(() {
                                  isVisible = !isVisible;
                                });
                              },
                              autoFocus: false,
                              suffixIconData: isVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () {
                                locator<NavigationService>()
                                    .navigateTo(ForgetRoute);
                              }, //go to forgetpassword page
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Forget Password?',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            CustomRoundButton(
                              size: size,
                              text: 'Login',
                              onPress: () async {
                                //TODO: add validations:
                                //add form and form key here
                                //add a validator function for each textfield widget
                                setState(() {
                                  isLoading = true;
                                });
                                bool loggedIn = await provider.logIn(
                                    context,
                                    emailController.text,
                                    passwordController.text);
                                if (loggedIn) {
                                  locator<NavigationService>()
                                      .navigateTo(HomeRoute);
                                }
                                setState(() {
                                  isLoading = false;
                                });
                              }, //logIn
                            ),
                            SizedBox(
                              height: size.height * 0.025,
                            ),
                            GestureDetector(
                              onTap: () async {
                                // just used here to register a user for first time
                                // bool isRegistered =
                                //     await FireBaseServices().register(
                                //         "ManagerTest",
                                //         "Manager",
                                //         "Movies",
                                //         //emailController.text.trim(),
                                //         "manager@test.com",
                                //         passwordController.text,
                                //         "manager",
                                //         context);
                                //
                                FocusScope.of(context).unfocus();
                                emailController.clear();
                                passwordController.clear();
                                //if (isRegistered) {
                                locator<NavigationService>()
                                    .navigateTo(RegisterRoute);
                                //}
                              }, //go to register view page
                              child: Text(
                                'Register',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                              ),
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
                ],
              ),
      ),
    );
  }
}
