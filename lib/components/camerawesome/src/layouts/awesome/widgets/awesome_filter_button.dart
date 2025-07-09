import 'package:gardener/components/camerawesome/camerawesome_plugin.dart';
import 'package:gardener/components/camerawesome/src/layouts/awesome/widgets/utils/awesome_circle_icon_button.dart';
import 'package:flutter/material.dart';

class AwesomeFilterButton extends StatelessWidget {
  final CameraState state;

  const AwesomeFilterButton({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return state.when(onPhotoMode: (pm) {
      return AwesomeCircleButton(
        icon: Icons.filter_b_and_w_outlined,
        onTap: state.toggleFilterSelector,
      );
    }, onPreparingCamera: (_) {
      return const SizedBox.shrink();
    }, onVideoMode: (_) {
      return const SizedBox.shrink();
    }, onVideoRecordingMode: (_) {
      return const SizedBox.shrink();
    });
  }
}
