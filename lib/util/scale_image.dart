class AssetSize{
  double height;
  double width;

  AssetSize({ required this.height, required this.width });
}

AssetSize assetEqualProportion(maxWidth, maxHeight, width, height) {
  // 用于设定图片的宽度和高度
  double tempWidth = 0;
  double tempHeight = 0;

  if(width > 0 && height > 0){
    //原图片宽高比例 大于 指定的宽高比例，这就说明了原图片的宽度必然 > 高度
    if (width/height >= maxWidth/maxHeight) {
      if (width > maxWidth) {
        tempWidth = maxWidth;
        // 按原图片的比例进行缩放
        tempHeight = (height * maxWidth) / width;
      } else {
        // 按原图片的大小进行缩放
        tempWidth = width;
        tempHeight = height;
      }
    } else {// 原图片的高度必然 > 宽度
      if (height > maxHeight) {
        tempHeight = maxHeight;
        // 按原图片的比例进行缩放
        tempWidth = (width * maxHeight) / height;
      } else {
        // 按原图片的大小进行缩放
        tempWidth = width;
        tempHeight = height;
      }
    }
  }
  return AssetSize(width: tempWidth, height: tempHeight);
}