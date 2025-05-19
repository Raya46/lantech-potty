class SceneObjectData {
  final String id;
  final String name;
  final String imagePath;
  bool isTarget;
  bool isFound;

  SceneObjectData({
    required this.id,
    required this.name,
    required this.imagePath,
    this.isTarget = false,
    this.isFound = false,
  });

  factory SceneObjectData.fromJson(Map<String, dynamic> json) {
    return SceneObjectData(
      id: json['id'].toString(),
      name: json['name'] ?? 'Unknown',
      imagePath: json['image'] ?? '',
    );
  }
}