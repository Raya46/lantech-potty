import 'package:isar/isar.dart';
part 'player.g.dart';

@collection
class Player {
  Player(this.level);
  Id id = Isar.autoIncrement;
  int? level;
  bool? isFocused;
  String? gender;
  int? level1Score;
  int? level2Score;
  int? level3Score;
  int? level4Score;
  int? level5Score;
}
