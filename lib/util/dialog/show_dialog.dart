showDialog( //通过showDialog方法展示alert弹框
  context: context,
  builder: (context) {
  return CupertinoAlertDialog(
  title: Text('提示'), //弹框标题
  content: Text('是否想放弃学习Flutter'), //弹框内容
  actions: <Widget>[ //操作控件
  CupertinoDialogAction(
  onPressed: () { //控件点击监听
  print("我不会放弃的");
  Navigator.pop(context);
  },
  textStyle: TextStyle(fontSize: 18, color: Colors.blueAccent), //按钮上的文本风格
  child: Text('取消'), //控件显示内容
  ),
  CupertinoDialogAction(
  onPressed: () {
  print("我投降");
  Navigator.pop(context);
  },
  textStyle: TextStyle(fontSize: 18, color: Colors.grey),
  child: Text('确定'),
  ),
  ],
  );
  },
);