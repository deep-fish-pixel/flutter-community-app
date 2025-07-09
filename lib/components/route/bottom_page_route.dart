import 'package:flutter/cupertino.dart';

class BottomPageRoute extends PageRouteBuilder {
  final Widget currentPage;
  final Widget newPage;

  BottomPageRoute(this.currentPage, this.newPage)
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    currentPage,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        Stack(
          children: <Widget>[
            Positioned(
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0),
                  end: const Offset(0, -1),
                ).animate(animation),
                child: currentPage,
              ),
            ),
            Positioned(
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: const Offset(0, 0),
                ).animate(animation),
                child: newPage,
              ),
            ),
          ],
        ),
  );
}