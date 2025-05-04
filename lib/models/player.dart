import 'package:isar/isar.dart';
part 'player.g.dart';

@collection
class Player {
  Player(this.level);
  Id id = Isar.autoIncrement;
  int? level;
  bool? isFocused;
  String? gender;
}
