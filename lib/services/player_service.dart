import 'package:isar/isar.dart';
import 'package:toilet_training/models/player.dart';
import 'package:path_provider/path_provider.dart';

late Future<Isar> db;

Future<Isar> openDB() async {
  var dir = await getApplicationDocumentsDirectory();
  if (Isar.instanceNames.isEmpty) {
    return await Isar.open([PlayerSchema], directory: dir.path);
  }
  return Future.value(Isar.getInstance());
}

Future<Player> getPlayer() async {
  final isar = await db;
  return isar.players.where().findFirstSync()!;
}

Future<void> savePlayer(Player newPlayer) async {
  final isar = await db;
  isar.writeTxnSync(() => isar.players.putSync(newPlayer));
}

Future<void> updatePlayer(Player newPlayer) async {
  final isar = await db;
  isar.writeTxnSync(() async {
    await isar.players.put(newPlayer);
  });
}
