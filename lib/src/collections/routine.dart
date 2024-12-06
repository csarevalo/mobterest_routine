import 'package:isar/isar.dart';

import 'category.dart';

part 'routine.g.dart';

@collection
class Routine {
  Id id = Isar.autoIncrement;
  late String title;
  @Index() //sort collection by start (asc)
  late DateTime start;
  @Index(composite: [CompositeIndex('title')])
  // @Backlink(to: 'routine')
  var category = IsarLink<Category>();
}
