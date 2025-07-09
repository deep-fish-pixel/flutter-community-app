import 'package:flutter/cupertino.dart';

/// @Author wywinstonwy
/// @Date 2022/1/13 8:32 上午
/// @Description:

class NoAniamteRoute extends PageRoute {
  NoAniamteRoute( {
    this.barrierColor,
    this.barrierLabel,
    required this.builder,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.opaque = true,
    this.barrierDismissible = false,

    this.maintainState = true, required RouteSettings settings,
  });

  final WidgetBuilder builder;

  @override
  final Duration transitionDuration;

  @override
  final bool opaque;

  @override
  final bool barrierDismissible;

  @override
  final Color ? barrierColor;

  @override
  final String ? barrierLabel;

  @override
  final bool maintainState;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) => builder(context);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    //当前路由被激活，是打开新路由
    return FadeTransition(
      opacity: animation,
      child: builder(context),
    );
  }
}