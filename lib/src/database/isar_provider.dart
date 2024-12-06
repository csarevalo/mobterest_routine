import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../collections/category.dart';
import '../collections/routine.dart';

class IsarProvider extends ChangeNotifier {
  late final Isar _isar;

  IsarProvider({Isar? isar}) {
    if (isar != null) {
      _isar = isar;
    }
  }

  /// Initialize Isar database.
  Future<void> initIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    debugPrint('Dir: ${dir.toString()}');
    _isar = await Isar.open(
      [RoutineSchema, CategorySchema],
      directory: dir.path,
    );
  }

  /// Add [Category] to Isar db.
  void addCategory(String newCategory) async {
    final category = Category()..name = newCategory;
    await _isar.writeTxn(() async {
      await _isar.categorys.put(category);
    });
  }

  /// Get [categories] from Isar db.
  List<Category> get categories => getCategories();

  /// Read [Category]s from Isar db.
  List<Category> getCategories() {
    final categoryCollection = _isar.categorys;
    return categoryCollection.where().findAllSync();
  }

  /// Verify unique [Category] name before adding to Isar db.
  bool verifyUniqueCategory(String category) {
    final categories = _isar.categorys;
    final cat = categories.where().nameEqualTo(category).findFirstSync();
    if (cat != null) return false;
    return true;
  }

  /// Add [Routine] to Isar db.
  void addRoutine({
    required Category category,
    required String title,
    required DateTime start,
  }) async {
    final routine = Routine()
      ..title = title
      ..start = start
      ..category.value = category;

    await _isar.writeTxn(() async {
      await _isar.routines.put(routine);
      await routine.category.save();
    });
  }

  /// Update [Routine] to Isar db.
  void updateRoutine({required Routine routine}) async {
    await _isar.writeTxn(() async {
      await _isar.routines.put(routine);
      await routine.category.save();
    });
  }

  /// Return [Routine]s upon change in Isar db.
  Stream<List<Routine>> listenToRoutines() async* {
    yield* _isar.routines.where().watch(fireImmediately: true);
  }

  /// Delete [Routine] from Isar db.
  void deleteRoutine(Routine routine) async {
    await _isar.writeTxn(() async {
      await _isar.routines.delete(routine.id);
    });
  }

  /// Query [Routine]s from Isar db.
  List<Routine> queryRoutinesByTitle(String title) {
    return _isar.routines
        .filter()
        .titleContains(title, caseSensitive: false)
        .findAllSync();
  }

  /// Listen to Query [Routine]s from Isar db.
  Stream<List<Routine>> listenToQueryRoutinesByTitle(String title) async* {
    yield* _isar.routines
        .filter()
        .titleContains(title, caseSensitive: false)
        .watch(fireImmediately: true);
  }

  /// Get [routines] from Isar db.
  List<Routine> get routines => getRoutines();

  /// Read [Routine]s from Isar db.
  List<Routine> getRoutines() {
    final routineCollection = _isar.routines;
    return routineCollection.where().findAllSync();
  }
}
