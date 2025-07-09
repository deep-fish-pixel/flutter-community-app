class ActivityItemModel {
  String title = '';
  String value = '';
  bool hasMap = false;

  ActivityItemModel({
    required this.title,
    required this.value,
    this.hasMap = false
  });

  ActivityItemModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['value'] = this.value;
    return data;
  }
}
