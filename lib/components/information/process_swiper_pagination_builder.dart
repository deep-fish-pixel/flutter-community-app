import 'dart:developer';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gardener/pages/information/video_image/components/video/tiktok/views/animation_controllers.dart';
import 'package:gardener/util/win_media.dart';

class ProcessSwiperPagination extends StatefulWidget {
  ///color when current index,if set null , will be Theme.of(context).primaryColor
  final Color? activeColor;

  ///,if set null , will be Theme.of(context).scaffoldBackgroundColor
  final Color? color;

  ///Size of the dot when activate
  final double activeSize;

  ///Size of the dot
  final double size;

  /// Space between dots
  final double space;

  final Key? key;

  final AnimationControllers animationControllers;
  final SwiperPluginConfig config;

  const ProcessSwiperPagination({
    this.activeColor,
    this.color,
    this.key,
    this.size = 10.0,
    this.activeSize = 10.0,
    this.space = 3.0,
    required this.animationControllers,
    required this.config
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProcessSwiperPaginationState();
  }

}

class _ProcessSwiperPaginationState extends State<ProcessSwiperPagination> {
  @override
  void initState() {
    super.initState();
    widget.animationControllers.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.config.itemCount > 20) {
      log(
        'The itemCount is too big, we suggest use FractionPaginationBuilder '
            'instead of DotSwiperPaginationBuilder in this situation',
      );
    }
    var activeColor = widget.activeColor;
    var color = widget.color;

    if (activeColor == null || color == null) {
      final themeData = Theme.of(context);
      activeColor = widget.activeColor ?? themeData.primaryColor;
      color = widget.color ?? themeData.scaffoldBackgroundColor;
    }

    if (widget.config.indicatorLayout != PageIndicatorLayout.NONE &&
        widget.config.layout == SwiperLayout.DEFAULT) {
      return PageIndicator(
        count: widget.config.itemCount,
        controller: widget.config.pageController!,
        layout: widget.config.indicatorLayout,
        size: widget.size,
        activeColor: activeColor,
        color: color,
      );
    }

    final list = <Widget>[];

    final itemCount = widget.config.itemCount;
    var width = (winWidth(context) - 20) / ( itemCount < 1 ? 1 : itemCount);

    for (var i = 0; i < itemCount; ++i) {
      list.add(Container(
        key: Key('pagination_$i'),
        child: Container(
          width: width - widget.space,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: color,
                ),
              ),
              Container(
                width: widget.animationControllers.getItemValue(i),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: activeColor,
                ),
              ),
            ],
          ),
        ),
      ));
    }

    if (widget.config.scrollDirection == Axis.vertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: list,
      );
    } else {
      return Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        height: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: list,
        ),
      );
    }
  }
}
