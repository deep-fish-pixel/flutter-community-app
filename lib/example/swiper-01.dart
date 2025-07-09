import 'dart:ui';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

const images = <String>[
  'https://img.xiumi.us/xmi/ua/3wa69/i/46f57d0ad7cbb1c8083786a54c0f5fab-sz_164023.jpg?x-oss-process=style/xmwebp',
  'https://img.xiumi.us/xmi/ua/3wa69/i/4fe7a06fe9ae6077be9498dea96b0e58-sz_207283.jpg?x-oss-process=image/resize,limit_1,m_lfit,w_1080/crop,h_810,w_810,x_135,y_0/format,webp',
  'https://img.xiumi.us/xmi/ua/3wa69/i/65e1e8689e829901b04b1bfa5ba96a40-sz_139219.jpg?x-oss-process=style/xmwebp',
  'https://img.xiumi.us/xmi/ua/3wa69/i/4cf7841f92d13a67c0f25738ba1d3266-sz_125868.jpg?x-oss-process=style/xmwebp',
  'https://img.xiumi.us/xmi/ua/3wa69/i/3553a9363cf990862c6f236559fc98ca-sz_195633.jpg?x-oss-process=style/xmwebp',
  'https://img.xiumi.us/xmi/ua/3wa69/i/73414e98d6debe9f42526875cb8658cf-sz_224834.jpg?x-oss-process=image/resize,limit_1,m_lfit,w_1080/crop,h_1050,w_1050,x_0,y_175/format,webp',
  'https://img.xiumi.us/xmi/ua/3wa69/i/f80f3fc92d07972d039c74b8475ea562-sz_193955.jpg?x-oss-process=style/xmwebp',
  'https://img.xiumi.us/xmi/ua/3wa69/i/69eb48fe55532c85934cdf24807fc3f8-sz_181952.jpg?x-oss-process=style/xmwebp',
  'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Ffile02.16sucai.com%2Fd%2Ffile%2F2014%2F0814%2F17c8e8c3c106b879aa9f4e9189601c3b.jpg&refer=http%3A%2F%2Ffile02.16sucai.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1663541917&t=a9a98cdae0ef8d8c280fe105ac01f852'
];

void main() => runApp(const MyApp());

class MyScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyScrollBehavior(),
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      home: const MyHomePage(title: 'Flutter Swiper'),
      routes: {
        '/example01': (context) => const ExampleHorizontal(),
        '/example02': (context) => const ExampleVertical(),
        '/example03': (context) => const ExampleFraction(),
        '/example04': (context) => const ExampleCustomPagination(),
        '/example05': (context) => const ExamplePhone(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> render(BuildContext context, List<List<String>> children) {
    return ListTile.divideTiles(
      context: context,
      tiles: children.map((data) {
        return buildListTile(context, data[0], data[1], data[2]);
      }),
    ).toList();
  }

  Widget buildListTile(
      BuildContext context, String title, String subtitle, String url) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed(url);
      },
      isThreeLine: true,
      dense: false,
      leading: null,
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(
        Icons.arrow_right,
        color: Colors.blueAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // DateTime moonLanding = DateTime.parse("1969-07-20");

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: render(context, [
          ['Horizontal', 'Scroll Horizontal', '/example01'],
          ['Vertical', 'Scroll Vertical', '/example02'],
          ['Fraction', 'Fraction style', '/example03'],
          ['Custom Pagination', 'Custom Pagination', '/example04'],
          ['Phone', 'Phone view', '/example05'],
          ['ScrollView ', 'In a ScrollView', '/example06'],
          ['Custom', 'Custom all properties', '/example07']
        ]),
      ),
    );
  }
}

const List<String> titles = [
  'Flutter Swiper is awesome',
  'Really nice',
  'Yeah'
];

class ExampleHorizontal extends StatelessWidget {
  const ExampleHorizontal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ExampleHorizontal'),
      ),
      body: Swiper(
        itemBuilder: (context, index) {
          final image = images[index];
          return Image(
              alignment: Alignment.center,
              fit: BoxFit.fill,
              image: NetworkImage(
                  images[index]
              )
          );
        },
        indicatorLayout: PageIndicatorLayout.COLOR,
        autoplay: true,
        itemCount: images.length,
        pagination: const SwiperPagination(),
        control: const SwiperControl(),
      ),
    );
  }
}

class ExampleVertical extends StatelessWidget {
  const ExampleVertical({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ExampleVertical'),
        ),
        body: Swiper(
          itemBuilder: (context, index) {
            return Image.asset(
              images[index],
              fit: BoxFit.fill,
            );
          },
          autoplay: true,
          itemCount: images.length,
          scrollDirection: Axis.vertical,
          pagination: const SwiperPagination(alignment: Alignment.centerRight),
          control: const SwiperControl(),
        ));
  }
}

class ExampleFraction extends StatelessWidget {
  const ExampleFraction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ExampleFraction'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
                child: Swiper(
                  itemBuilder: (context, index) {
                    return Image.asset(
                      images[index],
                      fit: BoxFit.fill,
                    );
                  },
                  autoplay: true,
                  itemCount: images.length,
                  pagination:
                  const SwiperPagination(builder: SwiperPagination.fraction),
                  control: const SwiperControl(),
                )),
            Expanded(
                child: Swiper(
                  itemBuilder: (context, index) {
                    return Image.asset(
                      images[index],
                      fit: BoxFit.fill,
                    );
                  },
                  autoplay: true,
                  itemCount: images.length,
                  scrollDirection: Axis.vertical,
                  pagination: const SwiperPagination(
                      alignment: Alignment.centerRight,
                      builder: SwiperPagination.fraction),
                ))
          ],
        ));
  }
}

class ExampleCustomPagination extends StatelessWidget {
  const ExampleCustomPagination({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Custom Pagination'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Swiper(
                itemBuilder: (context, index) {
                  return Image.asset(
                    images[index],
                    fit: BoxFit.fill,
                  );
                },
                autoplay: true,
                itemCount: images.length,
                pagination: SwiperPagination(
                    margin: EdgeInsets.zero,
                    builder: SwiperCustomPagination(builder: (context, config) {
                      return ConstrainedBox(
                        child: Container(
                          color: Colors.white,
                          child: Text(
                            '${titles[config.activeIndex]} ${config.activeIndex + 1}/${config.itemCount}',
                            style: const TextStyle(fontSize: 20.0),
                          ),
                        ),
                        constraints: const BoxConstraints.expand(height: 50.0),
                      );
                    })),
                control: const SwiperControl(),
              ),
            ),
            Expanded(
              child: Swiper(
                itemBuilder: (context, index) {
                  return Image.asset(
                    images[index],
                    fit: BoxFit.fill,
                  );
                },
                autoplay: true,
                itemCount: images.length,
                pagination: SwiperPagination(
                    margin: EdgeInsets.zero,
                    builder: SwiperCustomPagination(builder: (context, config) {
                      return ConstrainedBox(
                        child: Row(
                          children: <Widget>[
                            Text(
                              '${titles[config.activeIndex]} ${config.activeIndex + 1}/${config.itemCount}',
                              style: const TextStyle(fontSize: 20.0),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: const DotSwiperPaginationBuilder(
                                    color: Colors.black12,
                                    activeColor: Colors.black,
                                    size: 10.0,
                                    activeSize: 20.0)
                                    .build(context, config),
                              ),
                            )
                          ],
                        ),
                        constraints: const BoxConstraints.expand(height: 50.0),
                      );
                    })),
                control: const SwiperControl(color: Colors.redAccent),
              ),
            )
          ],
        ));
  }
}

class ExamplePhone extends StatelessWidget {
  const ExamplePhone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone'),
      ),
      body: Stack(
        children: <Widget>[
          ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: Image.asset(
              'images/bg.jpeg',
              fit: BoxFit.fill,
            ),
          ),
          Swiper.children(
            autoplay: false,
            pagination: const SwiperPagination(
                margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 30.0),
                builder: DotSwiperPaginationBuilder(
                    color: Colors.white30,
                    activeColor: Colors.white,
                    size: 20.0,
                    activeSize: 20.0)),
            children: <Widget>[
              Image.asset(
                'images/1.png',
                fit: BoxFit.contain,
              ),
              Image.asset(
                'images/2.png',
                fit: BoxFit.contain,
              ),
              Image.asset('images/3.png', fit: BoxFit.contain)
            ],
          )
        ],
      ),
    );
  }
}

class ScaffoldWidget extends StatelessWidget {
  final Widget child;
  final String title;
  final List<Widget>? actions;

  const ScaffoldWidget({
    Key? key,
    required this.title,
    required this.child,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
      ),
      body: child,
    );
  }
}
