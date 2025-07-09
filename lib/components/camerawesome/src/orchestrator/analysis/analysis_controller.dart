import 'dart:async';

import 'package:gardener/components/camerawesome/camerawesome_plugin.dart';
import 'package:gardener/components/camerawesome/src/logger.dart';

class AnalysisController {
  final OnImageForAnalysis? onImageListener;

  final Stream<Map<String, dynamic>>? _images$;

  final AnalysisConfig conf;

  StreamSubscription? imageSubscription;
  bool _analysisEnabled;

  AnalysisController._({
    required Stream<Map<String, dynamic>>? images$,
    required this.conf,
    this.onImageListener,
    required bool analysisEnabled,
  })  : _images$ = images$,
        _analysisEnabled = analysisEnabled;

  factory AnalysisController.fromPlugin({
    OnImageForAnalysis? onImageListener,
    required AnalysisConfig? conf,
  }) =>
      AnalysisController._(
        onImageListener: onImageListener,
        conf: conf ?? AnalysisConfig(),
        images$: CamerawesomePlugin.listenCameraImages(),
        analysisEnabled: conf?.autoStart ?? true,
      );

  Future<void> setup() async {
    if (onImageListener == null) {
      printLog("...AnalysisController off, no onImageListener");
      return;
    }
    if (imageSubscription != null) {
      printLog('AnalysisController controller already started');
      return;
    }

    await CamerawesomePlugin.setupAnalysis(
      format: conf.outputFormat,
      width: conf.width,
      maxFramesPerSecond: conf.maxFramesPerSecond,
      autoStart: conf.autoStart,
    );

    if (conf.autoStart) {
      await start();
    }
    printLog("...AnalysisController setup");
  }

  get enabled => onImageListener != null && _analysisEnabled;

  Future<bool> start() async {
    if (onImageListener == null) {
      return false;
    }
    await CamerawesomePlugin.startAnalysis();
    imageSubscription = _images$?.listen((event) async {
      await onImageListener!(AnalysisImage.from(event));
      await CamerawesomePlugin.receivedImageFromStream();
    });
    _analysisEnabled = true;
    printLog("...AnalysisController started");
    return true;
  }

  Future<void> stop() async {
    _analysisEnabled = false;
    await CamerawesomePlugin.stopAnalysis();
    close();
  }

  close() {
    imageSubscription?.cancel();
    imageSubscription = null;
  }
}
