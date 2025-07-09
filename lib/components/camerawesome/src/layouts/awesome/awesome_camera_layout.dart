import 'package:camera/camera.dart';
import 'package:gardener/components/camerawesome/src/layouts/awesome/widgets/awesome_filter_button.dart';
import 'package:gardener/components/camerawesome/src/layouts/awesome/widgets/awesome_filter_name_indicator.dart';
import 'package:gardener/components/camerawesome/src/layouts/awesome/widgets/awesome_filter_selector.dart';
import 'package:flutter/material.dart';
import 'package:gardener/components/camerawesome/src/layouts/awesome/widgets/utils/awesome_circle_icon_button.dart';
import 'package:gardener/constants/themes.dart';
import 'package:gardener/routes/generate_route.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:gardener/pages/message/chat/chat_more_tab_picker_builder.dart';

import '../../../camerawesome_plugin.dart';

/// This widget doesn't handle [PreparingCameraState]
class AwesomeCameraLayout extends StatelessWidget {
  final CameraState state;
  final OnMediaTap onMediaTap;
  final Function(String?) onVideoCreated;
  final Function(String?) onPhotoCreated;

  const AwesomeCameraLayout({
    super.key,
    required this.state,
    this.onMediaTap,
    required this.onVideoCreated,
    required this.onPhotoCreated,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          const SizedBox(height: 16),
          AwesomeTopActions(state: state),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: Stack(
              children: [
                SizedBox(
                  height: 150,
                  child: StreamBuilder<bool>(
                    stream: state.filterSelectorOpened$,
                    builder: (_, snapshot) {
                      return snapshot.data == true
                          ? Align(
                              alignment: Alignment.bottomCenter,
                              child: AwesomeFilterNameIndicator(state: state))
                          : Center(
                              child: AwesomeSensorTypeSelector(state: state));
                    },
                  ),
                ),
                AnimatedPositioned(
                  bottom: state.captureMode == CaptureMode.photo ? 70 : 0,
                  right: 20,
                  curve: Curves.ease,
                  duration: const Duration(milliseconds: 200),
                  child: AwesomeFlashButton(state: state)
                ),
                Positioned(
                  bottom: 0,
                  right: 20,
                  child: AnimatedOpacity(
                    curve: Curves.ease,
                    duration: const Duration(milliseconds: 500),
                    opacity: state.captureMode == CaptureMode.photo ? 1 : 0,
                    child: AwesomeFilterButton(state: state),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 12),
          AwesomeBackground(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 700),
              curve: Curves.fastLinearToSlowEaseIn,
              child: StreamBuilder<bool>(
                stream: state.filterSelectorOpened$,
                builder: (_, snapshot) {
                  return snapshot.data == true
                      ? AwesomeFilterSelector(state: state)
                      : const SizedBox(
                          width: double.infinity,
                        );
                },
              ),
            ),
          ),
          AwesomeBackground(
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  AwesomeCameraModeSelector(state: state),
                  AwesomeBottomActions(
                    state: state,
                    onMediaTap: onMediaTap,
                    onPhotoCreated: onPhotoCreated,
                    onVideoCreated: onVideoCreated,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AwesomeTopActions extends StatelessWidget {
  final CameraState state;

  const AwesomeTopActions({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    if (state is VideoRecordingCameraState) {
      return const SizedBox.shrink();
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AwesomeBouncingWidget(
              onTap: () => {
                RouteUtil.pop(context)
              },
              child: const SizedBox(
                height: 50,
                width: 50,
                child: Icon(
                  Icons.close_outlined,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ),
            // AwesomeLocationButton(state: state),
          ],
        ),
      );
    }
  }
}

class AwesomeBottomActions extends StatelessWidget {
  final CameraState state;
  final OnMediaTap onMediaTap;
  final ImagePicker imagePicker = ImagePicker();
  final int maxAssets = 9;
  List<AssetEntity> entities = <AssetEntity>[];
  late final ThemeData theme = AssetPicker.themeData(ThemeColors.main, light: false);
  final Function(String?) onVideoCreated;
  final Function(String?) onPhotoCreated;

  AwesomeBottomActions({
    super.key,
    required this.state,
    this.onMediaTap,
    required this.onVideoCreated,
    required this.onPhotoCreated,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          child: state is VideoRecordingCameraState
              ? AwesomePauseResumeButton(
                  state: state as VideoRecordingCameraState)
              : AwesomeCameraSwitchButton(state: state),
        ),
        // Spacer(),
        AwesomeCaptureButton(
          state: state,
          onPhotoCreated: onPhotoCreated,
          onVideoCreated: onVideoCreated,
        ),
        // Spacer(),
        Flexible(
          child: AwesomeCircleButton(
            onTap: () {
              pickPhoto(context);
            },
            size: 60,
            iconSize: 28,
            icon: Icons.filter,
          ),
        ),
        //预览图片
        /*Flexible(
          child: state is VideoRecordingCameraState
              ? const SizedBox(width: 48)
              : StreamBuilder<MediaCapture?>(
            stream: state.captureState$,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox(width: 60, height: 60);
              }
              return SizedBox(
                width: 60,
                child: AwesomeMediaPreview(
                  mediaCapture: snapshot.requireData,
                  onMediaTap: onMediaTap,
                ),
              );
            },
          ),
        ),*/
      ],
    );
  }

  Future<void> pickPhoto(BuildContext context) async {
    final PermissionState ps = await AssetPicker.permissionCheck();

    final DefaultAssetPickerProvider provider = DefaultAssetPickerProvider(
        selectedAssets: entities,
        maxAssets: maxAssets,
        requestType: RequestType.common
    );
    final DefaultAssetPickerProvider imagesProvider =
    DefaultAssetPickerProvider(
      selectedAssets: entities,
      maxAssets: maxAssets,
    );
    final DefaultAssetPickerProvider videosProvider =
    DefaultAssetPickerProvider(
      selectedAssets: entities,
      maxAssets: maxAssets,
      requestType: RequestType.video,
    );
    final MultiTabAssetPickerBuilder builder = MultiTabAssetPickerBuilder(
      provider: provider,
      imagesProvider: imagesProvider,
      videosProvider: videosProvider,
      initialPermission: ps,
      pickerTheme: theme,
      locale: Localizations.maybeLocaleOf(context),
    );
    final List<AssetEntity>? result = await AssetPicker.pickAssetsWithDelegate(
      context,
      delegate: builder,
    );
    /*if (result != null && widget.onSelectedImageCallBack != null) {
      widget.onSelectedImageCallBack!(result);
    }*/
  }
}

class AwesomeBackground extends StatelessWidget {
  final Widget child;

  const AwesomeBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
    );
  }
}
