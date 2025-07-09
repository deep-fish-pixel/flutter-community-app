/// A library to easily display images in a full-screen dialog.
/// It supports pinch & zoom, and paging through multiple images.
library easy_image_viewer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gardener/components/easy_image_video_viewer/src/easy_view_child.dart';

import 'src/easy_image_provider.dart';
import 'src/easy_image_viewer_dismissible_dialog.dart';
import 'src/single_image_provider.dart';

export 'src/easy_image_provider.dart' show EasyImageProvider;
export 'src/single_image_provider.dart' show SingleImageProvider;
export 'src/multi_image_provider.dart' show MultiImageProvider;

export 'src/easy_image_view.dart' show EasyImageView;
export 'src/easy_image_view_pager.dart' show EasyImageViewPager;

// Defined here so we don't repeat ourselves
const _defaultBackgroundColor = Colors.black;
const _defaultCloseButtonColor = Colors.white;
const _defaultCloseButtonTooltip = 'Close';

/// Shows the given [imageProvider] in a full-screen [Dialog].
/// Setting [immersive] to false will prevent the top and bottom bars from being hidden.
/// The optional [onViewerDismissed] callback function is called when the dialog is closed.
/// The optional [useSafeArea] boolean defaults to false and is passed to [showDialog].
/// The optional [swipeDismissible] boolean defaults to false allows swipe-down-to-dismiss.
/// The [backgroundColor] defaults to black, but can be set to any other color.
/// The [closeButtonTooltip] text is displayed when the user long-presses on the
/// close button and is used for accessibility.
/// The [closeButtonColor] defaults to white, but can be set to any other color.
/*Future<Dialog?> showImageViewer(
    BuildContext context, Image imageProvider,
    {bool immersive = true,
    void Function()? onViewerDismissed,
    bool useSafeArea = false,
    bool swipeDismissible = false,
    Color backgroundColor = _defaultBackgroundColor,
    String closeButtonTooltip = _defaultCloseButtonTooltip,
    Color closeButtonColor = _defaultCloseButtonColor}) {
  return showImageViewerPager(context, SingleImageProvider(imageProvider),
      immersive: immersive,
      onViewerDismissed:
          onViewerDismissed != null ? (_) => onViewerDismissed() : null,
      useSafeArea: useSafeArea,
      swipeDismissible: swipeDismissible,
      backgroundColor: backgroundColor,
      closeButtonTooltip: closeButtonTooltip,
      closeButtonColor: closeButtonColor);
}*/

/// Shows the images provided by the [imageProvider] in a full-screen PageView [Dialog].
/// Setting [immersive] to false will prevent the top and bottom bars from being hidden.
/// The optional [onPageChanged] callback function is called with the index of
/// the image when the user has swiped to another image.
/// The optional [onViewerDismissed] callback function is called with the index of
/// the image that is displayed when the dialog is closed.
/// The optional [useSafeArea] boolean defaults to false and is passed to [showDialog].
/// The optional [swipeDismissible] boolean defaults to false allows swipe-down-to-dismiss.
/// The [backgroundColor] defaults to black, but can be set to any other color.
/// The [closeButtonTooltip] text is displayed when the user long-presses on the
/// close button and is used for accessibility.
/// The [closeButtonColor] defaults to white, but can be set to any other color.
showImageViewerPager(
  BuildContext context,
  {
    required List<EasyViewerChild> children,
    int showIndex = -1,
    bool immersive = true,
    void Function(int)? onPageChanged,
    void Function(int)? onViewerDismissed,
    bool useSafeArea = false,
    bool swipeDismissible = false,
    Color backgroundColor = _defaultBackgroundColor,
    String closeButtonTooltip = _defaultCloseButtonTooltip,
    Color closeButtonColor = _defaultCloseButtonColor,
    UniqueKey? tag,
  }) {
    if (immersive) {
      // Hide top and bottom bars
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    }

    if (showIndex == -1) {
      showIndex = children.length - 1;
    }

    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        barrierColor: backgroundColor,
        pageBuilder: (BuildContext context, _, __) {
          return EasyImageViewerDismissibleDialog(
            children: children,
            showIndex: showIndex,
            immersive: immersive,
            onPageChanged: onPageChanged,
            onViewerDismissed: onViewerDismissed,
            tag: tag,
            useSafeArea: useSafeArea,
            swipeDismissible: swipeDismissible,
            backgroundColor: backgroundColor,
            closeButtonColor: closeButtonColor,
            closeButtonTooltip: closeButtonTooltip
          );
        }
      )
    );

    /*return showDialog<Dialog>(
      context: context,
      useSafeArea: useSafeArea,
      builder: (context) {
        return EasyImageViewerDismissibleDialog(imageProvider,
            immersive: immersive,
            tag: tag,
            onPageChanged: onPageChanged,
            onViewerDismissed: onViewerDismissed,
            useSafeArea: useSafeArea,
            swipeDismissible: swipeDismissible,
            backgroundColor: backgroundColor,
            closeButtonColor: closeButtonColor,
            closeButtonTooltip: closeButtonTooltip
        );
      }
    );*/
}




