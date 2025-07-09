import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gardener/components/app_navigator_observer.dart';
import 'package:gardener/pages/loading_page.dart';
import 'package:gardener/util/shared_util.dart';
import 'package:gardener/provider/global_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:toast/toast.dart';

import 'constants/themes.dart';
import 'language/chinese_cupertino_localizations.dart';
import 'routes/generate_route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    // 强制竖屏
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  await SharedUtil.initSP();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GlobalModel()),
      ],
      child: const AppPage(),
    ),
  );
  configLoading();
}

class AppPage extends StatefulWidget {
  const AppPage({Key? key}) : super(key: key);

  @override
  _AppPageState createState() => _AppPageState();
}


class _AppPageState extends State<AppPage> {
  @override
  void initState() {
    super.initState();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<GlobalModel>(context);
    ToastContext().init(context);
    model.setContext(context, notify: false);

    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        ChineseCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('zh', 'CN'),
        // Locale.fromSubtags( languageCode: 'zh', scriptCode: 'Hans', countryCode: 'HK'),
        // const Locale('en', 'US'),
      ],
      title: 'Flutter Demo',
      theme: ThemeData(
        platform: TargetPlatform.iOS,
        primarySwatch: Colors.deepOrange,
        primaryTextTheme: const TextTheme(
          titleLarge: TextStyle(color: ThemeColors.mainBlack),
        ),
        appBarTheme: const AppBarTheme(
            centerTitle: true,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: ThemeColors.mainBlack),
            titleTextStyle: TextStyle(color: ThemeColors.mainBlack, fontSize: 18, fontWeight: FontWeight.w700),
            elevation: 0,  //隐藏AppBar底部的阴影分割线
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark
            ) // 设置状态栏的背景
        ),
      ),
      onGenerateRoute: generateRoute(context),
      navigatorObservers: [AppNavigatorObserver()],
      builder: EasyLoading.init(),
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.cubeGrid
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 36.0
    ..radius = 6.0
    ..lineWidth = 2
    ..maskType = EasyLoadingMaskType.clear
    // ..progressColor = Colors.yellow
    // ..backgroundColor = Colors.green
    // ..indicatorColor = Colors.yellow
    // ..textColor = Colors.yellow
    // ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false
    ..contentPadding = const EdgeInsets.symmetric(
      vertical: 20.0,
      horizontal: 20.0,
    );
}


