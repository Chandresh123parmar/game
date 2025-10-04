import 'package:hive/hive.dart';

//part 'game_stat.g.dart';

@HiveType(typeId: 0)
class GameStat {
  @HiveField(0)
  String result; // Win / Lose / Draw

  @HiveField(1)
  String player; // X or O

  @HiveField(2)
  DateTime date;

  GameStat({required this.result, required this.player, required this.date});
}
