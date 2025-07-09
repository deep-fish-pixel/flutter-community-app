import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:provider/provider.dart';

class MultiTabAssetPickerBuilder extends DefaultAssetPickerBuilderDelegate {
  MultiTabAssetPickerBuilder({
    required super.provider,
    required this.videosProvider,
    required this.imagesProvider,
    required super.initialPermission,
    super.gridCount = 3,
    super.pickerTheme,
    super.themeColor,
    super.textDelegate,
    super.locale,
  }) : super(shouldRevertGrid: false);

  final DefaultAssetPickerProvider videosProvider;
  final DefaultAssetPickerProvider imagesProvider;

  late final TabController _tabController;

  @override
  void initState(AssetPickerState<AssetEntity, AssetPathEntity> state) {
    super.initState(state);
    _tabController = TabController(length: 3, vsync: state);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget pathEntitySelector(BuildContext context) {
    Widget selector(BuildContext context) {
      return UnconstrainedBox(
        child: GestureDetector(
          onTap: () {
            Feedback.forTap(context);
            isSwitchingPath.value = !isSwitchingPath.value;
          },
          child: Container(
            height: appBarItemHeight,
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.5,
            ),
            padding: const EdgeInsetsDirectional.only(start: 12, end: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: theme.dividerColor,
            ),
            child: Selector<DefaultAssetPickerProvider,
                PathWrapper<AssetPathEntity>?>(
              selector: (_, DefaultAssetPickerProvider p) => p.currentPath,
              builder: (_, PathWrapper<AssetPathEntity>? p, Widget? w) => Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (p != null)
                    Flexible(
                      child: Text(
                        isPermissionLimited && p.path.isAll
                            ? textDelegate.accessiblePathName
                            : p.path.name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.normal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  w!,
                ],
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.only(start: 5),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.iconTheme.color!.withOpacity(0.5),
                  ),
                  child: ValueListenableBuilder<bool>(
                    valueListenable: isSwitchingPath,
                    builder: (_, bool isSwitchingPath, Widget? w) {
                      return Transform.rotate(
                        angle: isSwitchingPath ? math.pi : 0,
                        child: w,
                      );
                    },
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return ChangeNotifierProvider<TabController>.value(
      value: _tabController,
      builder: (_, __) => Selector<TabController, int>(
        selector: (_, TabController p) => p.index,
        builder: (_, int index, __) {
          final DefaultAssetPickerProvider pickerProvider;
          switch (index) {
            case 1:
              pickerProvider = videosProvider;
              break;
            case 2:
              pickerProvider = imagesProvider;
              break;
            default:
              pickerProvider = provider;
          }
          return ChangeNotifierProvider<DefaultAssetPickerProvider>.value(
            value: pickerProvider,
            builder: (BuildContext c, _) => selector(c),
          );
        },
      ),
    );
  }

  @override
  Widget confirmButton(BuildContext context) {
    final Widget button = Consumer<DefaultAssetPickerProvider>(
      builder: (_, DefaultAssetPickerProvider p, __) {
        return MaterialButton(
          minWidth: p.isSelectedNotEmpty ? 48 : 20,
          height: appBarItemHeight,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          disabledColor: theme.dividerColor,
          color: p.isSelectedNotEmpty ? themeColor : theme.dividerColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3),
          ),
          onPressed: p.isSelectedNotEmpty
              ? () => Navigator.of(context).maybePop(p.selectedAssets)
              : null,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          child: Text(
            p.isSelectedNotEmpty && !isSingleAssetMode
                ? '${textDelegate.confirm}'
                ' (${p.selectedAssets.length}/${p.maxAssets})'
                : textDelegate.confirm,
            style: TextStyle(
              color: p.isSelectedNotEmpty
                  ? theme.textTheme.bodyText1?.color
                  : theme.textTheme.caption?.color,
              fontSize: 17,
              fontWeight: FontWeight.normal,
            ),
          ),
        );
      },
    );
    return ChangeNotifierProvider<TabController>.value(
      value: _tabController,
      builder: (_, __) => Selector<TabController, int>(
        selector: (_, TabController p) => p.index,
        builder: (_, int index, __) {
          final DefaultAssetPickerProvider pickerProvider;
          switch (index) {
            case 1:
              pickerProvider = videosProvider;
              break;
            case 2:
              pickerProvider = imagesProvider;
              break;
            default:
              pickerProvider = provider;
          }
          return ChangeNotifierProvider<DefaultAssetPickerProvider>.value(
            value: pickerProvider,
            builder: (_, __) => button,
          );
        },
      ),
    );
  }

  @override
  AssetPickerAppBar appBar(BuildContext context) {
    return AssetPickerAppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      centerTitle: isAppleOS,
      title: Semantics(
        onTapHint: textDelegate.sActionSwitchPathLabel,
        child: pathEntitySelector(context),
      ),
      leading: backButton(context),
      actions: <Widget>[if (!isAppleOS) confirmButton(context)],
      actionsPadding: const EdgeInsetsDirectional.only(end: 14),
      blurRadius: isAppleOS ? appleOSBlurRadius : 0,
      bottom: TabBar(
        controller: _tabController,
        tabs: const <Tab>[
          Tab(text: '全部'),
          Tab(text: '视频'),
          Tab(text: '图片'),
        ],
      ),
    );
  }

  @override
  Widget androidLayout(BuildContext context) {
    return AssetPickerAppBarWrapper(
      appBar: appBar(context),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          ChangeNotifierProvider<DefaultAssetPickerProvider>.value(
            value: provider,
            builder: (BuildContext context, _) => _buildGrid(context),
          ),
          ChangeNotifierProvider<DefaultAssetPickerProvider>.value(
            value: videosProvider,
            builder: (BuildContext context, _) => _buildGrid(context),
          ),
          ChangeNotifierProvider<DefaultAssetPickerProvider>.value(
            value: imagesProvider,
            builder: (BuildContext context, _) => _buildGrid(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget appleOSLayout(BuildContext context) => androidLayout(context);

  Widget _buildGrid(BuildContext context) {
    return Selector<DefaultAssetPickerProvider, bool>(
      selector: (_, DefaultAssetPickerProvider p) => p.hasAssetsToDisplay,
      builder: (_, bool hasAssetsToDisplay, __) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: hasAssetsToDisplay
              ? Stack(
            children: <Widget>[
              RepaintBoundary(
                child: Column(
                  children: <Widget>[
                    Expanded(child: assetsGridBuilder(context)),
                    if (isPreviewEnabled)
                      bottomActionBar(context),
                  ],
                ),
              ),
              pathEntityListBackdrop(context),
              pathEntityListWidget(context),
            ],
          )
              : loadingIndicator(context),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Theme(
        data: theme,
        child: Material(
          color: theme.canvasColor,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              if (isAppleOS) appleOSLayout(context) else androidLayout(context),
              if (Platform.isIOS) iOSPermissionOverlay(context),
            ],
          ),
        ),
      ),
    );
  }
}
