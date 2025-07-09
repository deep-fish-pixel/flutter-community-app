import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gardener/pages/information/video_image/components/video/tiktok/style/style.dart';
import 'package:gardener/routes/generate_route.dart';

const double scrollSpeed = 300;

enum TikTokPagePositon {
  left,
  right,
  middle,
}

class TikTokScaffoldController extends ValueNotifier<TikTokPagePositon> {
  TikTokScaffoldController([
    TikTokPagePositon value = TikTokPagePositon.middle,
  ]) : super(value);

  Future? animateToPage(TikTokPagePositon pagePositon) {
    return _onAnimateToPage?.call(pagePositon);
  }

  Future? animateToLeft() {
    return _onAnimateToPage?.call(TikTokPagePositon.left);
  }

  Future? animateToRight() {
    return _onAnimateToPage?.call(TikTokPagePositon.right);
  }

  Future? animateToMiddle() {
    return _onAnimateToPage?.call(TikTokPagePositon.middle);
  }

  Future Function(TikTokPagePositon pagePositon)? _onAnimateToPage;
}

class TikTokScaffold extends StatefulWidget {
  final TikTokScaffoldController? controller;

  /// 首页的顶部
  final Widget? header;

  /// 右滑页面
  final Widget? rightPage;

  /// 视频序号
  final int currentIndex;

  final bool hasBottomPadding;
  final bool? enableGesture;
  final bool onlyMain;

  final Widget? page;

  final Function()? onPullDownRefresh;

  const TikTokScaffold({
    Key? key,
    this.header,
    this.rightPage,
    this.hasBottomPadding: false,
    this.page,
    this.currentIndex: 0,
    this.enableGesture,
    this.onlyMain = false,
    this.onPullDownRefresh,
    this.controller,
  }) : super(key: key);

  @override
  _TikTokScaffoldState createState() => _TikTokScaffoldState();
}

class _TikTokScaffoldState extends State<TikTokScaffold>
    with TickerProviderStateMixin {
  AnimationController? animationControllerX;
  AnimationController? animationControllerY;
  late Animation<double> animationX;
  late Animation<double> animationY;
  TikTokPagePositon page = TikTokPagePositon.middle;
  double offsetX = 0.0;
  double offsetY = 0.0;
  // int currentIndex = 0;
  double inMiddle = 0;
  double dragX = 0;

  @override
  void initState() {
    widget.controller!._onAnimateToPage = animateToPage;
    super.initState();
  }

  Future animateToPage(p) async {
    switch (p) {
      case TikTokPagePositon.left:
        await animateTo(screenWidth);
        page = TikTokPagePositon.left;
        break;
      case TikTokPagePositon.middle:
        await animateTo();
        page = TikTokPagePositon.middle;
        break;
      case TikTokPagePositon.right:
        await animateTo(-screenWidth);
        page = TikTokPagePositon.right;
        break;
    }
    widget.controller!.value = p;
  }

  double screenWidth = 100;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    AnimationController? controller = RouteUtil.swipeablePageRoute?.controller;
    List<Widget> pages = widget.onlyMain ? [_MiddlePage(
      absorbing: absorbing,
      onTopDrag: () {
        // absorbing = true;
        setState(() {});
      },
      offsetX: offsetX,
      offsetY: offsetY,
      header: widget.header,
      isStack: !widget.hasBottomPadding,
      page: widget.page,
    ),] : [
      _MiddlePage(
        absorbing: absorbing,
        onTopDrag: () {
          // absorbing = true;
          setState(() {});
        },
        offsetX: offsetX,
        offsetY: offsetY,
        header: widget.header,
        isStack: !widget.hasBottomPadding,
        page: widget.page,
      ),
      _RightPageTransform(
        offsetX: offsetX,
        offsetY: offsetY,
        content: widget.rightPage,
      ),
    ];
    // 先定义正常结构
    Widget body = Stack(
      fit: StackFit.passthrough,
      children: pages,
    );
    // 增加手势控制
    body = GestureDetector(
      onVerticalDragUpdate: calculateOffsetY,
      onVerticalDragEnd: (_) async {
        if (!widget.enableGesture!) return;
        absorbing = false;
        if (offsetY != 0) {
          await animateToTop();
          widget.onPullDownRefresh?.call();
          setState(() {});
        }
      },
      // 水平方向滑动开始
      onHorizontalDragStart: (details) {
        if (!widget.enableGesture!) return;
        dragX = 0;
        animationControllerX?.stop();
        animationControllerY?.stop();
      },
      onHorizontalDragUpdate: (details) {
        if (!widget.enableGesture!) return;
        if (page == TikTokPagePositon.middle) {
          dragX -= details.delta.dx;
          if (dragX > 0) {
            if (!widget.onlyMain) {
              return onHorizontalDragUpdate(
                details,
                screenWidth,
              );
            }

          } else {
            controller?.value -= details.delta.dx / screenWidth;
            return;
          }
        }

        print('onHorizontalDragUpdate=====' + (controller?.value ?? 0).toString() + ' ' + details.delta.dx.toString() + ' ' + (screenWidth).toString() + ' ' + details.primaryDelta.toString());
        if (!widget.onlyMain) {
          return onHorizontalDragUpdate(
            details,
            screenWidth,
          );
        }
      },
      onHorizontalDragEnd: (details) {
        if (!widget.enableGesture!) return;
        if (page == TikTokPagePositon.middle) {
          if (dragX > 0) {
            if (!widget.onlyMain) {
              onHorizontalDragEnd(
                details,
                screenWidth,
              );
            }
          } else {
            onHorizontalDragEnd(
              details,
              screenWidth,
            );
            dragEnd(details.velocity.pixelsPerSecond.dx);
            return;
          }
        }
        if (!widget.onlyMain) {
          onHorizontalDragEnd(
            details,
            screenWidth,
          );
        }
      },
      child: body,
    );
    body = Scaffold(
      body: body,
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
    );
    return body;
  }


  void dragEnd(double velocity) {
    // Fling in the appropriate direction.
    // AnimationController.fling is guaranteed to
    // take at least one frame.
    //
    // This curve has been determined through rigorously eyeballing native iOS
    // animations.
    const double _kMinFlingVelocity = 1; // Screen widths per second.

    const int _kMaxDroppedSwipePageForwardAnimationTime = 800; // Milliseconds.

    const int _kMaxPageBackAnimationTime = 300; // Milliseconds.

    const Curve animationCurve = Curves.fastLinearToSlowEaseIn;
    final bool animateForward;

    // If the user releases the page before mid screen with sufficient velocity,
    // or after mid screen, we should animate the page out. Otherwise, the page
    // should be animated back in.
    AnimationController? controller = RouteUtil.swipeablePageRoute?.controller;
    double controllerValue = RouteUtil.swipeablePageRoute?.controller?.value ?? 0;

    if (velocity.abs() >= _kMinFlingVelocity) {
      animateForward = velocity <= 0;
    } else {

      animateForward = controllerValue > 0.5;
    }

    if (animateForward) {
      // The closer the panel is to dismissing, the shorter the animation is.
      // We want to cap the animation time, but we want to use a linear curve
      // to determine it.
      final droppedPageForwardAnimationTime = min(
        lerpDouble(
          _kMaxDroppedSwipePageForwardAnimationTime,
          0,
          controllerValue,
        )!.floor(),
        _kMaxPageBackAnimationTime,
      );
      controller?.animateTo(
        1,
        duration: Duration(milliseconds: droppedPageForwardAnimationTime),
        curve: animationCurve,
      );
    } else {
      // This route is destined to pop at this point. Reuse navigator's pop.
      RouteUtil.swipeablePageRoute?.navigator?.pop();

      // The popping may have finished inline if already at the target
      // destination.

      final droppedPageBackAnimationTime = lerpDouble(
        0,
        _kMaxDroppedSwipePageForwardAnimationTime,
        controllerValue,
      )!.floor();

      if (controller?.isAnimating == true) {
        // Otherwise, use a custom popping animation duration and curve.
        controller?.animateBack(
          0,
          duration: Duration(milliseconds: droppedPageBackAnimationTime),
          curve: animationCurve,
        );
      }
      /*Future.delayed(Duration(milliseconds: droppedPageBackAnimationTime)).then((e) {
        RouteUtil.swipeablePageRoute?.navigator?.pop();
      });*/
    }

    if (controller?.isAnimating == true) {
      // Keep the userGestureInProgress in true state so we don't change the
      // curve of the page transition mid-flight since CupertinoPageTransition
      // depends on userGestureInProgress.
      late AnimationStatusListener animationStatusCallback;
      animationStatusCallback = (status) {
        // RouteUtil.swipeablePageRoute?.navigator?.didStopUserGesture();
        controller?.removeStatusListener(animationStatusCallback);
      };
      controller?.addStatusListener(animationStatusCallback);
    } else {
      // RouteUtil.swipeablePageRoute?.navigator?.didStopUserGesture();
    }
  }
  /*double _convertToLogical(double value) {
    switch (context.directionality) {
      case TextDirection.rtl:
        return -value;
      case TextDirection.ltr:
        return value;
    }
  }*/

  // 水平方向滑动中
  void onHorizontalDragUpdate(details, screenWidth) {
    if (!widget.enableGesture!) return;
    print('${offsetX} ${details.delta.dx}');
    // 控制 offsetX 的值在 -screenWidth 到 screenWidth 之间
    if (offsetX > 0) {
      setState(() {
        offsetX = 0;
      });
    } else if (offsetX + details.delta.dx <= -screenWidth) {
      setState(() {
        offsetX = -screenWidth;
      });
    } else {
      setState(() {
        offsetX += details.delta.dx;
      });
    }
  }

  // 水平方向滑动结束
  onHorizontalDragEnd(details, screenWidth) {
    if (!widget.enableGesture!) return;
    print('velocity:${details.velocity}');
    var vOffset = details.velocity.pixelsPerSecond.dx;

    // 速度很快时
    if (vOffset > scrollSpeed && inMiddle == 0) {
      // 去右边页面
      // return animateToPage(TikTokPagePositon.left);
    } else if (vOffset < -scrollSpeed && inMiddle == 0) {
      // 去左边页面
      return animateToPage(TikTokPagePositon.right);
    } else if (inMiddle > 0 && vOffset < -scrollSpeed) {
      return animateToPage(TikTokPagePositon.middle);
    } else if (inMiddle < 0 && vOffset > scrollSpeed) {
      return animateToPage(TikTokPagePositon.middle);
    }
    // 当滑动停止的时候 根据 offsetX 的偏移量进行动画
    if (offsetX.abs() < screenWidth * 0.5) {
      // 中间页面
      return animateToPage(TikTokPagePositon.middle);
    } else if (offsetX > 0) {
      // 去左边页面
      // return animateToPage(TikTokPagePositon.left);
    } else {
      // 去右边页面
      return animateToPage(TikTokPagePositon.right);
    }
  }

  /// 滑动到顶部
  ///
  /// [offsetY] to 0.0
  Future animateToTop() {
    animationControllerY = AnimationController(
        duration: Duration(milliseconds: offsetY.abs() * 1000 ~/ 60),
        vsync: this);
    final curve = CurvedAnimation(
        parent: animationControllerY!, curve: Curves.easeOutCubic);
    animationY = Tween(begin: offsetY, end: 0.0).animate(curve)
      ..addListener(() {
        setState(() {
          offsetY = animationY.value;
        });
      });
    return animationControllerY!.forward();
  }

  CurvedAnimation curvedAnimation() {
    animationControllerX = AnimationController(
        duration: Duration(milliseconds: max(offsetX.abs(), 60) * 1000 ~/ 500),
        vsync: this);
    return CurvedAnimation(
        parent: animationControllerX!, curve: Curves.easeOutCubic);
  }

  Future animateTo([double end = 0.0]) {
    final curve = curvedAnimation();
    animationX = Tween(begin: offsetX, end: end).animate(curve)
      ..addListener(() {
        setState(() {
          offsetX = animationX.value;
        });
      });
    inMiddle = end;
    return animationControllerX!.animateTo(1);
  }

  bool absorbing = false;
  double endOffset = 0.0;

  /// 计算[offsetY]
  ///
  /// 手指上滑,[absorbing]为false，不阻止事件，事件交给底层PageView处理
  /// 处于第一页且是下拉，则拦截滑动���件
  void calculateOffsetY(DragUpdateDetails details) {
    if (!widget.enableGesture!) return;
    if (inMiddle != 0) {
      setState(() => absorbing = false);
      return;
    }
    final tempY = offsetY + details.delta.dy / 2;
    if (widget.currentIndex == 0) {
      // absorbing = true; // TODO:暂时屏蔽了下拉刷新
      if (tempY > 0) {
        if (tempY < 40) {
          offsetY = tempY;
        } else if (offsetY != 40) {
          offsetY = 40;
          // vibrate();
        }
      } else {
        absorbing = false;
      }
      setState(() {});
    } else {
      absorbing = false;
      offsetY = 0;
      setState(() {});
    }
    print(absorbing.toString());
  }

  @override
  void dispose() {
    animationControllerX?.dispose();
    animationControllerY?.dispose();
    super.dispose();
  }
}

class _MiddlePage extends StatelessWidget {
  final bool? absorbing;
  final bool isStack;
  final Widget? page;

  final double? offsetX;
  final double? offsetY;
  final Function? onTopDrag;

  final Widget? header;

  const _MiddlePage({
    Key? key,
    this.absorbing,
    this.onTopDrag,
    this.offsetX,
    this.offsetY,
    this.isStack: false,
    required this.header,
    this.page,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Widget mainVideoList = Container(
      color: ColorPlate.back1,
      padding: EdgeInsets.only(
        bottom: isStack ? 0 : 44 + MediaQuery.of(context).padding.bottom,
      ),
      child: page,
    );
    // 刷新标志
    Widget _headerContain;
    if (offsetY! >= 20) {
      _headerContain = Opacity(
        opacity: (offsetY! - 20) / 20,
        child: Transform.translate(
          offset: Offset(0, offsetY!),
          child: Container(
            height: 44,
            child: Center(
              child: const Text(
                "下拉刷新内容",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: SysSize.normal,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      _headerContain = Opacity(
        opacity: max(0, 1 - offsetY! / 20),
        child: Transform.translate(
          offset: Offset(0, offsetY!),
          child: SafeArea(
            child: Container(
              height: 44,
              child: header ?? Placeholder(color: Colors.green),
            ),
          ),
        ),
      );
    }

    Widget middle = Transform.translate(
      offset: Offset(offsetX! > 0 ? offsetX! : offsetX! / 5, 0),
      child: Stack(
        children: <Widget>[
          Container(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                mainVideoList,
              ],
            ),
          ),
          _headerContain,
        ],
      ),
    );
    if (page is! PageView) {
      return middle;
    }
    return AbsorbPointer(
      absorbing: absorbing!,
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowGlow();
          return;
        } as bool Function(OverscrollIndicatorNotification)?,
        child: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            // 当手指离开时，并且处于顶部则拦截PageView的滑动事件 TODO: 没有触发下拉刷新
            if (notification.direction == ScrollDirection.idle &&
                notification.metrics.pixels == 0.0) {
              onTopDrag?.call();
              return false;
            }
            return true;
          },
          child: middle,
        ),
      ),
    );
  }
}

/// 左侧Widget
///
/// 通过 [Transform.scale] 进行根据 [offsetX] 缩放
/// 最小 0.88 最大为 1
class _LeftPageTransform extends StatelessWidget {
  final double? offsetX;
  final Widget? content;

  const _LeftPageTransform({Key? key, this.offsetX, this.content})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Transform.scale(
      scale: 0.88 + 0.12 * offsetX! / screenWidth < 0.88
          ? 0.88
          : 0.88 + 0.12 * offsetX! / screenWidth,
      child: content ?? Placeholder(color: Colors.pink),
    );
  }
}

class _RightPageTransform extends StatelessWidget {
  final double? offsetX;
  final double? offsetY;

  final Widget? content;

  const _RightPageTransform({
    Key? key,
    this.offsetX,
    this.offsetY,
    this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Transform.translate(
        offset: Offset(max(0, offsetX! + screenWidth), 0),
        child: Container(
          width: screenWidth,
          height: screenHeight,
          color: Colors.transparent,
          child: content ?? Placeholder(fallbackWidth: screenWidth),
        ));
  }
}
