enum Sensors {
  back,
  front,
}

enum CameraAspectRatios {
  ratio_max_max,
  ratio_16_9,
  ratio_4_3,
  ratio_1_1; // only for iOS

  CameraAspectRatios get defaultRatio => CameraAspectRatios.ratio_max_max;
}
