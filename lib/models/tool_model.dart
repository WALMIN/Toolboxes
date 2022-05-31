class ToolModel {
  String id;
  String name;
  String storagePlace;
  String borrowedBy;
  String borrowedAt;
  String bought;
  String boughtAt;

  ToolModel(
      {required this.id,
      required this.name,
      required this.storagePlace,
      required this.borrowedBy,
      required this.borrowedAt,
      required this.bought,
      required this.boughtAt});
}
