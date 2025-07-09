import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EasyImageViewer Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'EasyImageViewer Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _pageController = PageController();
  static const _kDuration = Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;

  final List<ImageProvider> _imageProviders = [
    Image.network("https://img.xiumi.us/xmi/ua/3wa69/i/46f57d0ad7cbb1c8083786a54c0f5fab-sz_164023.jpg?x-oss-process=style/xmwebp").image,
    Image.network("https://img.xiumi.us/xmi/ua/3wa69/i/65e1e8689e829901b04b1bfa5ba96a40-sz_139219.jpg?x-oss-process=style/xmwebp").image,
    Image.network("https://img.xiumi.us/xmi/ua/3wa69/i/4cf7841f92d13a67c0f25738ba1d3266-sz_125868.jpg?x-oss-process=style/xmwebp").image,
    Image.network("https://img.xiumi.us/xmi/ua/3wa69/i/f80f3fc92d07972d039c74b8475ea562-sz_193955.jpg?x-oss-process=style/xmwebp").image
  ];

  late final _easyEmbeddedImageProvider = MultiImageProvider(_imageProviders);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  child: const Text("Show Single Image"),
                  onPressed: () {
                    showImageViewer(
                        context,
                        Image.network("https://img.xiumi.us/xmi/ua/3wa69/i/46f57d0ad7cbb1c8083786a54c0f5fab-sz_164023.jpg?x-oss-process=style/xmwebp")
                            .image,
                        swipeDismissible: true);
                  }),
              ElevatedButton(
                  child: const Text("Show Multiple Images (Simple)"),
                  onPressed: () {
                    MultiImageProvider multiImageProvider =
                    MultiImageProvider(_imageProviders);
                    showImageViewerPager(context, multiImageProvider,
                        swipeDismissible: true);
                  }),
              ElevatedButton(
                  child: const Text("Show Multiple Images (Custom)"),
                  onPressed: () {
                    CustomImageProvider customImageProvider = CustomImageProvider(
                        imageUrls: [
                          'https://img.xiumi.us/xmi/ua/3wa69/i/46f57d0ad7cbb1c8083786a54c0f5fab-sz_164023.jpg?x-oss-process=style/xmwebp',
                          'https://img.xiumi.us/xmi/ua/3wa69/i/4fe7a06fe9ae6077be9498dea96b0e58-sz_207283.jpg?x-oss-process=image/resize,limit_1,m_lfit,w_1080/crop,h_810,w_810,x_135,y_0/format,webp',
                          'https://img.xiumi.us/xmi/ua/3wa69/i/65e1e8689e829901b04b1bfa5ba96a40-sz_139219.jpg?x-oss-process=style/xmwebp',
                          'https://img.xiumi.us/xmi/ua/3wa69/i/4cf7841f92d13a67c0f25738ba1d3266-sz_125868.jpg?x-oss-process=style/xmwebp',
                          'https://img.xiumi.us/xmi/ua/3wa69/i/3553a9363cf990862c6f236559fc98ca-sz_195633.jpg?x-oss-process=style/xmwebp',
                          'https://img.xiumi.us/xmi/ua/3wa69/i/73414e98d6debe9f42526875cb8658cf-sz_224834.jpg?x-oss-process=image/resize,limit_1,m_lfit,w_1080/crop,h_1050,w_1050,x_0,y_175/format,webp',
                          'https://img.xiumi.us/xmi/ua/3wa69/i/f80f3fc92d07972d039c74b8475ea562-sz_193955.jpg?x-oss-process=style/xmwebp',
                          'https://img.xiumi.us/xmi/ua/3wa69/i/69eb48fe55532c85934cdf24807fc3f8-sz_181952.jpg?x-oss-process=style/xmwebp',
                          'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Ffile02.16sucai.com%2Fd%2Ffile%2F2014%2F0814%2F17c8e8c3c106b879aa9f4e9189601c3b.jpg&refer=http%3A%2F%2Ffile02.16sucai.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1663541917&t=a9a98cdae0ef8d8c280fe105ac01f852'
                        ].toList(),
                        initialIndex: 2);
                    showImageViewerPager(context, customImageProvider,
                        onPageChanged: (page) {
                          // print("Page changed to $page");
                        }, onViewerDismissed: (page) {
                          // print("Dismissed while on page $page");
                        });
                  }),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.0,
                child: EasyImageViewPager(
                    easyImageProvider: _easyEmbeddedImageProvider,
                    pageController: _pageController),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      child: const Text("<< Prev"),
                      onPressed: () {
                        final currentPage = _pageController.page?.toInt() ?? 0;
                        _pageController.animateToPage(
                            currentPage > 0 ? currentPage - 1 : 0,
                            duration: _kDuration,
                            curve: _kCurve);
                      }),
                  ElevatedButton(
                      child: const Text("Next >>"),
                      onPressed: () {
                        final currentPage = _pageController.page?.toInt() ?? 0;
                        final lastPage = _easyEmbeddedImageProvider.imageCount - 1;
                        _pageController.animateToPage(
                            currentPage < lastPage ? currentPage + 1 : lastPage,
                            duration: _kDuration,
                            curve: _kCurve);
                      }),
                ],
              )
            ],
          )),
    );
  }
}

class CustomImageProvider extends EasyImageProvider {
  @override
  final int initialIndex;
  final List<String> imageUrls;

  CustomImageProvider({required this.imageUrls, this.initialIndex = 0})
      : super();

  @override
  ImageProvider<Object> imageBuilder(BuildContext context, int index) {
    return NetworkImage(imageUrls[index]);
  }

  @override
  int get imageCount => imageUrls.length;
}