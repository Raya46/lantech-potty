class BathroomItem {
  final int id;
  final String name;
  final String image;

  BathroomItem({required this.id, required this.name, required this.image});

  factory BathroomItem.fromJson(Map<String, dynamic> json) {
    return BathroomItem(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}