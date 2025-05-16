class PuzzleItem {
  final int id;
  final String name;
  final String image;

  PuzzleItem({required this.id, required this.name, required this.image});

  factory PuzzleItem.fromJson(Map<String, dynamic> json) {
    return PuzzleItem(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String,
    );
  }
}
