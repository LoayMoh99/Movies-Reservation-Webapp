import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:movies_webapp/routing/route_names.dart';
import 'package:movies_webapp/views/auth_views/forget_pass.dart';
import 'package:movies_webapp/views/auth_views/login.dart';
import 'package:movies_webapp/views/auth_views/register.dart';
import 'package:movies_webapp/views/headers/about.dart';
import 'package:movies_webapp/views/home/home_view.dart';
import 'package:movies_webapp/widgets/shade_loading.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomeRoute:
      return _getPageRoute(HomeView(), settings);
    case LoadingRoute:
      return _getPageRoute(ShadeLoading(), settings);
    case ForgetRoute:
      return _getPageRoute(ForgetView(), settings);
    case LoginRoute:
      return _getPageRoute(LoginView(), settings);
    case RegisterRoute:
      return _getPageRoute(RegisterView(), settings);
    case AboutRoute:
      return _getPageRoute(AboutView(), settings);
    default:
      return _getPageRoute(HomeView(), settings);
  }
}

PageRoute _getPageRoute(Widget child, RouteSettings settings) {
  return _FadeRoute(child: child, routeName: settings.name!);
}

class _FadeRoute extends PageRouteBuilder {
  final Widget? child;
  final String? routeName;
  _FadeRoute({this.child, this.routeName})
      : super(
          settings: RouteSettings(name: routeName),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              child!,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
