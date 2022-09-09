import 'package:hive/hive.dart';

part 'item.g.dart';

@HiveType(typeId: 1)
class Item {
  @HiveField(0)
  String title;
  @HiveField(1)
  int count;

  Item({
    required this.title,
    required this.count,
  });
}
