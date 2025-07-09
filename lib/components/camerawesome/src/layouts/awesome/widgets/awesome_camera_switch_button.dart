import 'package:gardener/components/camerawesome/src/layouts/awesome/widgets/utils/awesome_circle_icon_button.dart';
import 'package:gardener/components/camerawesome/src/orchestrator/states/camera_state.dart';
import 'package:flutter/material.dart';

class AwesomeCameraSwitchButton extends StatelessWidget {
  final CameraState state;

  const AwesomeCameraSwitchButton({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return AwesomeCircleButton(
      onTap: state.switchCameraSensor,
      size: 60,
      iconSize: 28,
      icon: Icons.cameraswitch,
    );
  }
}
