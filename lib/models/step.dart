class ToiletStep {
  final int id;
  final String name;
  final String image;
  final bool focus;
  final String gender;

  ToiletStep({
    required this.id,
    required this.name,
    required this.image,
    required this.focus,
    required this.gender,
  });

  factory ToiletStep.fromJson(Map<String, dynamic> json) {
    return ToiletStep(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      focus: json['focus'],
      gender: json['gender'],
    );
  }
}
