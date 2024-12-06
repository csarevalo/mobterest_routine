import 'package:isar/isar.dart';
import 'routine.dart';

part 'category.g.dart';

@collection
class Category {
  Id id = Isar.autoIncrement;
  @Index(unique: true, caseSensitive: true) // unique name
  late String name;
  // @Backlink(to: 'category')
  var routines = IsarLinks<Routine>();
}
