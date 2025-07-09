import 'dart:io';

import 'package:wechat_assets_picker/wechat_assets_picker.dart';

Socket? socket;

var mediaList = [
  'test-video-10.MP4',
  [
    'https://img.xiumi.us/xmi/ua/3wa69/i/46f57d0ad7cbb1c8083786a54c0f5fab-sz_164023.jpg?x-oss-process=style/xmwebp',
    'https://img.xiumi.us/xmi/ua/3wa69/i/4fe7a06fe9ae6077be9498dea96b0e58-sz_207283.jpg?x-oss-process=image/resize,limit_1,m_lfit,w_1080/crop,h_810,w_810,x_135,y_0/format,webp',
  ],
  /*[
    'https://img.xiumi.us/xmi/ua/3wa69/i/46f57d0ad7cbb1c8083786a54c0f5fab-sz_164023.jpg?x-oss-process=style/xmwebp',
    'https://img.xiumi.us/xmi/ua/3wa69/i/4fe7a06fe9ae6077be9498dea96b0e58-sz_207283.jpg?x-oss-process=image/resize,limit_1,m_lfit,w_1080/crop,h_810,w_810,x_135,y_0/format,webp',
    'https://img.xiumi.us/xmi/ua/3wa69/i/65e1e8689e829901b04b1bfa5ba96a40-sz_139219.jpg?x-oss-process=style/xmwebp',
    'https://img.xiumi.us/xmi/ua/3wa69/i/4cf7841f92d13a67c0f25738ba1d3266-sz_125868.jpg?x-oss-process=style/xmwebp',
    'https://img.xiumi.us/xmi/ua/3wa69/i/3553a9363cf990862c6f236559fc98ca-sz_195633.jpg?x-oss-process=style/xmwebp',
  ],*/
  'test-video-6.mp4',
  'test-video-9.MP4',
  'test-video-8.MP4',
  'test-video-7.MP4',
  'test-video-1.mp4',
  'test-video-2.mp4',
  'test-video-3.mp4',
  'test-video-4.mp4'
];

class UserMedia {
  final String? url;
  final String? image;
  final List<String>? images;
  final String? desc;

  UserMedia({
    this.url,
    this.image,
    this.images,
    this.desc,
  });

  static List<UserMedia> fetchMedia({required type}) {
    var typeList = type == AssetType.video ? mediaList : mediaList.sublist(1);
    List<UserMedia> list = typeList.map((e) {
      var isImages = e is List;
      return UserMedia(
          url: isImages ? null : 'https://static.ybhospital.net/$e',
          images: isImages ? e as List<String> : null,
          image: '',
      );
    }).toList();
    return list;
  }

  isVideo(){
    return url != null;
  }

  isImage(){
    return images != null;
  }



  @override
  String toString() {
    return 'image:$image' '\nvideo:$url';
  }
}
