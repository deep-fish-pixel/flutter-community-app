import 'dart:async';
import 'dart:math';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:gardener/pages/information/video_image/components/video/tiktok/mock/media.dart';
import 'package:video_player/video_player.dart';

import 'package:gardener/pages/information/video_image/components/video/tiktok/mock/video.dart';

typedef LoadMoreVideo = Future<List<TikTokMediaController>> Function(
  int index,
  List<TikTokMediaController> list,
);

/// TikTokVideoListController是一系列视频的控制器，内部管理了视频控制器数组
/// 提供了预加载/释放/加载更多功能
class TikTokVideoListController extends ChangeNotifier {
  TikTokVideoListController({
    this.loadMoreCount = 1,
    this.preloadCount = 2,

    /// TODO: VideoPlayer有bug(安卓)，当前只能设置为0
    /// 设置为0后，任何不在画面内的视频都会被释放
    /// 若不设置为0，安卓将会无法加载第三个开始的视频
    this.disposeCount = 0,
  });

  /// 到第几个触发预加载，例如：1:最后一个，2:倒数第二个
  final int loadMoreCount;

  /// 预加载多少个视频
  final int preloadCount;

  /// 超出多少个，就释放视频
  final int disposeCount;

  /// 提供视频的builder
  LoadMoreVideo? _videoProvider;

  bool disposed = false;

  loadIndex(int target, {bool reload = false}) {
    if (!reload) {
      if (index.value == target) return;
    }
    // 播放当前的，暂停其他的
    var oldIndex = index.value;
    var newIndex = target;

    // 暂停之前的视频
    if (!(oldIndex == 0 && newIndex == 0)) {
      playerOfIndex(oldIndex)?.controller.seekTo(Duration.zero);
      // playerOfIndex(oldIndex)?.controller.addListener(_didUpdateValue);
      // playerOfIndex(oldIndex)?.showPauseIcon.addListener(_didUpdateValue);
      playerOfIndex(oldIndex)?.pause();
      print('暂停$oldIndex');
    }
    // 开始播放当前的视频
    playerOfIndex(newIndex)?.controller?.addListener(_didUpdateValue);
    playerOfIndex(newIndex)?.showPauseIcon.addListener(_didUpdateValue);
    playerOfIndex(newIndex)?.play();
    print('播放$newIndex');
    // 处理预加载/释放内存
    for (var i = 0; i < playerList.length; i++) {
      /// 需要释放[disposeCount]之前的视频
      /// i < newIndex - disposeCount 向下滑动时释放视频
      /// i > newIndex + disposeCount 向上滑动，同时避免disposeCount设置为0时失去视频预加载功能
      if (i < newIndex - disposeCount || i > newIndex + max(disposeCount, 2)) {
        print('释放$i');
        playerOfIndex(i)?.controller?.removeListener(_didUpdateValue);
        playerOfIndex(i)?.showPauseIcon.removeListener(_didUpdateValue);
        playerOfIndex(i)?.dispose();
        continue;
      }
      // 需要预加载
      if (i > newIndex && i < newIndex + preloadCount) {
        print('预加载$i');
        playerOfIndex(i)?.init();
        continue;
      }
    }
    // 快到最底部，添加更多视频
    if (playerList.length - newIndex <= loadMoreCount + 1) {
      _videoProvider?.call(newIndex, playerList).then(
        (list) async {
          playerList.addAll(list);
          notifyListeners();
        },
      );
    }

    // 完成
    index.value = target;
  }

  _didUpdateValue() {
    notifyListeners();
  }

  /// 获取指定index的player
  TikTokMediaController? playerOfIndex(int index) {
    if (index < 0 || index > playerList.length - 1) {
      return null;
    }
    return playerList[index];
  }

  /// 视频总数目
  int get videoCount => playerList.length;

  /// 初始化
  init({
    required PageController pageController,
    required List<TikTokMediaController> initialList,
    required LoadMoreVideo videoProvider,
  }) async {
    playerList.addAll(initialList);
    _videoProvider = videoProvider;
    pageController.addListener(() {
      var p = pageController.page!;
      if (p % 1 == 0) {
        loadIndex(p ~/ 1);
      }
    });
    loadIndex(0, reload: true);
    notifyListeners();
  }

  /// 目前的视频序号
  ValueNotifier<int> index = ValueNotifier<int>(0);

  /// 视频列表
  List<TikTokMediaController> playerList = [];

  ///
  TikTokMediaController get currentPlayer => playerList[index.value];

  /// 销毁全部
  void dispose() {
    disposed = true;
    // 销毁全部
    for (var player in playerList) {
      player.showPauseIcon.dispose();
      player.dispose();
    }
    playerList = [];
    super.dispose();
  }
}

typedef ControllerSetter<T> = Future<void> Function(T controller);
typedef ControllerBuilder<T> = T Function();

enum PlayerChangeType{
  unknown,
  playing,
  paused,
  disposed
}

/// 抽象类，作为视频控制器必须实现这些方法
abstract class TikTokMediaController extends ChangeNotifier  {
  PlayerChangeType changeValue = PlayerChangeType.unknown;

  /// 获取当前的控制器实例
  get controller;

  UserMedia get mediaInfo;

  /// 是否显示暂停按钮
  ValueNotifier<bool> get showPauseIcon;

  /// 加载视频，在init后，应当开始下载视频内容
  Future<void> init({ControllerSetter? afterInit});

  /// 视频销毁，在dispose后，应当释放任何内存资源
  Future<void> dispose();

  /// 播放
  Future<void> play();

  /// 暂停
  Future<void> pause({bool showPauseIcon: false});

  bool isVideo();

  bool isImage();
}

/// 异步方法并发锁
Completer<void>? _syncLock;

class VPVideoController extends TikTokMediaController{
  VideoPlayerController? _controller;
  final ValueNotifier<bool> _showPauseIcon = ValueNotifier<bool>(false);

  @override
  final UserMedia mediaInfo;

  final ControllerBuilder<VideoPlayerController> _builder;
  final ControllerSetter<VideoPlayerController>? _afterInit;
  VPVideoController({
    required this.mediaInfo,
    required ControllerBuilder<VideoPlayerController> builder,
    ControllerSetter<VideoPlayerController>? afterInit,
  }) : _builder = builder, _afterInit = afterInit;

  @override
  VideoPlayerController get controller {
    _controller ??= _builder.call();
    return _controller!;
  }

  bool get isDispose => _disposeLock != null;
  bool get prepared => _prepared;
  bool _prepared = false;

  Completer<void>? _disposeLock;


  @override
  Future<void> init({
    ControllerSetter<VideoPlayerController>? afterInit,
  }) async {
    if (prepared) return;
    await _syncCall(() async {
      print('+++initialize ${this.hashCode}');
      await controller.initialize();
      await controller.setLooping(true);
      afterInit ??= this._afterInit;
      await afterInit?.call(this.controller);
      print('+++==initialize ${this.hashCode}');
      _prepared = true;
    });
    if (_disposeLock != null) {
      _disposeLock?.complete();
      _disposeLock = null;
    }
  }

  @override
  Future<void> play() async {
    changeValue = PlayerChangeType.playing;
    await init();
    if (!prepared) return;
    if (_disposeLock != null) {
      await _disposeLock?.future;
    }
    await controller.play();
    _showPauseIcon.value = false;
    this.notifyListeners();
  }

  @override
  Future<void> pause({bool showPauseIcon: false}) async {
    changeValue = PlayerChangeType.paused;
    await init();
    if (!prepared) return;
    if (_disposeLock != null) {
      await _disposeLock?.future;
    }
    await controller.pause();
    _showPauseIcon.value = true;
    this.notifyListeners();
  }

  @override
  Future<void> dispose() async {
    if (!prepared) return;
    // super.dispose();
    changeValue = PlayerChangeType.disposed;
    _prepared = false;
    await _syncCall(() async {
      print('+++dispose ${this.hashCode}');
      await this.controller.dispose();
      _controller = null;
      print('+++==dispose ${this.hashCode}');
      _disposeLock = Completer<void>();
      // this.notifyListeners();
    });
  }

  /// 防止异步方法并发
  Future<void> _syncCall(Future Function()? fn) async {
    // 设置同步等待
    var lastCompleter = _syncLock;
    var completer = Completer<void>();
    _syncLock = completer;
    // 等待其他同步任务完成
    await lastCompleter?.future;
    // 主任务
    await fn?.call();
    // 结束
    completer.complete();
  }

  @override
  ValueNotifier<bool> get showPauseIcon => _showPauseIcon;

  @override
  bool isVideo() {
    return true;
  }

  @override
  bool isImage() {
    return true;
  }


}



class VPImageController extends TikTokMediaController {
  ValueNotifier<bool> _showPauseIcon = ValueNotifier<bool>(false);
  ImagePlayerController? _controller;
  final ControllerBuilder<ImagePlayerController> builder;

  @override
  final UserMedia mediaInfo;

  VPImageController({
    required this.builder,
    required this.mediaInfo,
  });

  @override
  Future<void> dispose() async {
    controller.dispose();
  }

  @override
  Future<void> init({
    ControllerSetter<ImagePlayerController>? afterInit,
  }) async {

  }

  @override
  Future<void> pause({bool showPauseIcon: false}) async {
    controller.pause();
  }

  @override
  Future<void> play() async {
    controller.play();
  }

  @override
  bool isVideo() {
    return false;
  }

  @override
  bool isImage() {
    return true;
  }

  @override
  ValueNotifier<bool> get showPauseIcon => _showPauseIcon;

  @override
  ImagePlayerController get controller {
    return getController();
  }


  void setSwiperController(SwiperController controller) {
    _controller?.setSwiperController(controller);
  }

  ImagePlayerController getController() {
    return _controller ??= builder.call();
  }
}

class ImagePlayerController {
  SwiperController? swiperController;
  bool _disposed = false;

  ImagePlayerController({
    this.swiperController,
  });

  void play() {
    Future.delayed(const Duration(milliseconds: 500), () {
      swiperController?.startAutoplay();
    });

  }

  void pause() {
    if (!_disposed) {
      swiperController?.stopAutoplay();
    }
  }

  void dispose() {
    _disposed = true;
    // swiperController?.dispose();
  }

  void addListener(VoidCallback listener) {

  }

  void removeListener(VoidCallback listener) {

  }

  Future<void> seekTo(Duration position) async {

  }

  void setSwiperController(SwiperController controller) {
    swiperController = controller;
  }

}