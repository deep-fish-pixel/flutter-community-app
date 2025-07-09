import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insta Image Viewer Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 100,
              height: 140,
              child: InstaImageViewer(
                child: Image(
                  image: Image.network("https://pic.rmb.bdstatic.com/bjh/news/353a5a197489816f99f3c2475ceb84bb.jpeg")
                      .image,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 100,
              height: 140,
              child: InstaImageViewer(
                child: Image(
                  image:
                  Image.network("https://pic.rmb.bdstatic.com/bjh/news/f17dbfadea9bc0541b2ae9db00cf377b.jpeg").image,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}