class GroupCategoryModel {
  String name;
  List<GroupCategoryModel> children;

  GroupCategoryModel({required this.name, this.children = const []});
}
