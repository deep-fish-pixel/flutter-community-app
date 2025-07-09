import 'package:gardener/components/camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:gardener/constants/themes.dart';

class AwesomeCameraModeSelector extends StatelessWidget {
  final CameraState state;

  const AwesomeCameraModeSelector({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    if (state is VideoRecordingCameraState) {
      return const SizedBox(
        height: 20,
      );
    } else {
      return CameraModePager(
        initialMode: state.captureMode,
        availableModes: state.saveConfig.captureModes,
        onChangeCameraRequest: (mode) {
          state.setState(mode);
        },
      );
    }
  }
}

typedef OnChangeCameraRequest = Function(CaptureMode mode);

class CameraModePager extends StatefulWidget {
  final OnChangeCameraRequest onChangeCameraRequest;

  final List<CaptureMode> availableModes;
  final CaptureMode? initialMode;

  const CameraModePager({
    super.key,
    required this.onChangeCameraRequest,
    required this.availableModes,
    required this.initialMode,
  });

  @override
  State<CameraModePager> createState() => _CameraModePagerState();
}

class _CameraModePagerState extends State<CameraModePager> {
  late PageController _pageController;

  int _index = 0;

  @override
  void initState() {
    super.initState();
    _index = widget.initialMode != null
        ? widget.availableModes.indexOf(widget.initialMode!)
        : 0;
    _pageController =
        PageController(viewportFraction: 0.25, initialPage: _index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.availableModes.length <= 1) {
      return const SizedBox.shrink();
    }
    return Row(
      children: [
        Expanded(
          child: Container(),
        ),
        Expanded(
          flex: 7,
          child: SizedBox(
            height: 80,
            child: Stack(
              alignment:Alignment.center , //指定未定位或部分定位widget的对齐方式
              children: <Widget>[
                Container(
                  width: 66,
                  height: 26,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    color: Colors.white,
                  ),
                ),
                PageView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: _pageController,
                  onPageChanged: (index) {
                    final cameraMode = widget.availableModes[index];
                    widget.onChangeCameraRequest(cameraMode);
                    setState(() {
                      _index = index;
                    });
                  },
                  itemCount: widget.availableModes.length,
                  itemBuilder: ((context, index) {
                    final cameraMode = widget.availableModes[index];
                    return AwesomeBouncingWidget(
                      child: Center(
                        child: Text(
                          captureModeMap[cameraMode.name]!,
                          style: TextStyle(
                            color: index == _index ? Colors.black : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () {
                        _pageController.animateToPage(
                          index,
                          curve: Curves.easeIn,
                          duration: const Duration(milliseconds: 200),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(),
        ),
      ],
    );
  }
}
