import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/animation.dart';

typedef IndexedBuilder<T> = T Function(int index);


class AnimationControllers {
  List<AnimationController> list = [];
  late final int length;
  late final IndexedBuilder<AnimationController> itemBuilder;
  late final SwiperController swiperController;
  int currentIndex = -1;
  bool _disposed = false;
  bool _paused = false;

  DateTime date = DateTime.now();

  AnimationControllers({
    required IndexedBuilder<AnimationController> itemBuilder,
    required int length,
    required SwiperController swiperController,
    required currentIndex
  }) {
    this.itemBuilder = itemBuilder;
    this.currentIndex = currentIndex;
    this.length = length;
    this.swiperController = swiperController;
    this.swiperController.addListener(() {
      // print('_swiperController==========');
      if (_disposed) {
        return;
      }
      var event = this.swiperController.event;
      if (event is AutoPlaySwiperControllerEvent && event.animation) {
        if(event.autoplay){
          forward();
          print('_swiperController=============' + this.swiperController.event.hashCode.toString());
        } else {
          pause();
        }
      } else if (event is NextIndexControllerEvent && event.animation) {
        forward();
        print('_swiperController=============' + this.swiperController.event.hashCode.toString());
      }
      // forward();
    });
    build();
  }

  build() {
    for (int index = 0; index < length; index++) {
      list.add(itemBuilder(index));
    }
    if (list.length > 0) {
      // 最后一个完成时重置
      list[list.length - 1].addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // reset();
        }
      });
    }
  }

  void forward() {
    // 停止状态下重启
    if (_paused) {
      return proceed();
    }
    if (currentIndex == length || currentIndex < 0) {
      currentIndex = 0;
      reset();
    }
    date = DateTime.now();
    list[currentIndex % length].forward();
    currentIndex++;
    date = DateTime.now();
    print('forward currentIndex===============' + currentIndex.toString() + ' time=' +(date.difference(DateTime.now()).inMicroseconds.toString()));

  }

  void reset() {
    for (int index = 0; index < length; index++) {
      list[index].reset();
    }
  }

  dispose(){
    for (int index = 0; index < length; index++) {
      list[index].dispose();
    }
    _disposed = true;
  }

  getItemValue(int i) {
    return list[i].value;
  }

  addListener(Null Function() listener) {
    list.forEach((element) {
      element.addListener(listener);
    });
  }

  void pause() {
    _paused = true;
  }

  void proceed() {
    _paused = false;

    currentIndex --;
    if (currentIndex < 0) {
      currentIndex = 0;
    }
    list[currentIndex].reset();
    list[currentIndex].forward();
    currentIndex ++;
  }
}
