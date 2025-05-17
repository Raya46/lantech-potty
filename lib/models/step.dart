class ToiletStep {
  final int id;
  final String name;
  final String image;
  final bool focus;
  final String gender;
  final String? type;

  ToiletStep({
    required this.id,
    required this.name,
    required this.image,
    required this.focus,
    required this.gender,
    this.type,
  });

  factory ToiletStep.fromJson(Map<String, dynamic> json) {
    return ToiletStep(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      focus: json['focus'] ?? false,
      gender: json['gender'],
      type: json['type'],
    );
  }
}
