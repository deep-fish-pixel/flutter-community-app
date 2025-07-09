import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

import '/pages/not_found_page.dart';
import 'no_aniamte_route.dart';
import 'index.dart';

// 路由动画类型
enum RouteAnimate{
  none,
  cupertino,
  material,
  modal,
  swipe,
}

class RouteUtil {
  static push(BuildContext context, String path, {
    params = const {},
    RouteAnimate animate = RouteAnimate.cupertino,
    bool swipeEdge = false,
  }) async {
    var result = await Navigator.pushNamed(
      context,
      path,
      arguments: {
        'params': params,
        'animate': animate,
        'swipeEdge': swipeEdge,
      }
    );
    return result;
  }

  static replace(BuildContext context, String path, {
    Map<String, dynamic> params = const {},
  }) async {
    var result = await Navigator.pushReplacementNamed(context, path , arguments: {
      'params': params,
      'animate': RouteAnimate.none
    });
    return result;
  }

  static pop(BuildContext context, [Object? param]) {
    if (param == null) {
      Navigator.pop(context);
    } else {
      Navigator.pop(context, param);
    }
  }

  static getParams(context){
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;
    print('getParams======');
    print(arguments);
    if (arguments == null) {
      return {};
    }
    return arguments['params'];
  }

  static CupertinoPageRoute? swipeablePageRoute;
}



generateRoute(context){
  var routes = getRoutes(context);

  return (RouteSettings settings) {
    print('generateRoute->routeName: $settings.name');
    dynamic arguments = settings.arguments ?? {};

    Widget builder(BuildContext context) {
      final name = settings.name;
      var builder = routes[name];
      // 如果路由表中未定义，跳转到未定义路由页面
      builder ??= (context) => NotFoundPage();
      // 用户权限认证的逻辑处理
      // 构建动态的route
      print('generateRoute->pageRoute->routeName: $name');

      /*return CupertinoPageRoute(
        builder: (context)=>builder(context),
      ).buildContent(context);*/
      return builder(context);
    }

    var animate = arguments['animate'];

    switch(animate) {
      case RouteAnimate.none: {
        return NoAniamteRoute(
            builder: builder,
            settings: RouteSettings(
              arguments: arguments,
            )
        );
      }
      case RouteAnimate.cupertino: {
        RouteUtil.swipeablePageRoute = CupertinoPageRoute(
            builder: builder,
            settings: RouteSettings(
              arguments: arguments,
            )
        );
        return RouteUtil.swipeablePageRoute;
      }
      case RouteAnimate.swipe: {
        RouteUtil.swipeablePageRoute = SwipeablePageRoute(
            canOnlySwipeFromEdge: arguments['swipeEdge'] ?? false,
            builder: builder,
            settings: RouteSettings(
              arguments: arguments,
            )
        );
        return RouteUtil.swipeablePageRoute;
      }
      case RouteAnimate.material: {
        return MaterialPageRoute(
            builder: builder,
            settings: RouteSettings(
              arguments: arguments,
            )
        );
      }
      case RouteAnimate.modal: {
        return MaterialWithModalsPageRoute(
            builder: builder,
            settings: RouteSettings(
              arguments: arguments,
            )
        );
      }
      default:
        return MaterialWithModalsPageRoute(
          builder: builder,
          settings: RouteSettings(
            arguments: arguments,
          )
        );
    }
  };
}

