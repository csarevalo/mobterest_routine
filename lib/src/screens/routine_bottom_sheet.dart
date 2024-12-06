import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../collections/category.dart';
import '../collections/routine.dart';
import '../widgets/add_category_dialog.dart';
import '../widgets/routine_start_date_time_button.dart';
import '../widgets/select_category_dropdown.dart';
import '../database/isar_provider.dart';

Future<void> showRoutineBottomSheet(BuildContext context, {Routine? routine}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true, //expands content
    showDragHandle: true,
    builder: (ctx) {
      return RoutineBottomSheet(routine: routine);
    },
  );
}

class RoutineBottomSheet extends StatefulWidget {
  final Routine? routine;

  const RoutineBottomSheet({
    super.key,
    this.routine,
  });

  @override
  State<RoutineBottomSheet> createState() => _RoutineBottomSheetState();
}

class _RoutineBottomSheetState extends State<RoutineBottomSheet> {
  late final IsarProvider _isarProvider;
  late List<Category> categories;
  late String? selectedCategory;
  late String? routineTitle;
  late DateTime? routineStartDT;
  late bool startHasTime;
  late bool _enAdd;
  late TextEditingController textController;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.routine?.category.value?.name;
    routineTitle = widget.routine?.title;
    textController = TextEditingController(text: routineTitle);
    routineStartDT = widget.routine?.start;
    startHasTime = false; // by default no time for start_dt
    categories = []; // init empty, then update
    _enAdd = false; // default disable add button
    _isarProvider = Provider.of<IsarProvider>(context, listen: false);
    getCategories(context);
  }

  void getCategories(BuildContext context) {
    categories = _isarProvider.categories;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SelectCategoryDropdown(
            categories: categories,
            initCategory: widget.routine?.category.value,
            onPressedAdd: () => showAddCategoryDialog(context),
            onChangedCategory: (String? newCategory) {
              selectedCategory = newCategory!;
              _validateRoutineForm();
            },
          ),
          Card(
            elevation: 0,
            child: TextField(
              controller: textController,
              onChanged: (value) {
                routineTitle = value;
                _validateRoutineForm();
              },
              decoration: const InputDecoration(
                labelText: 'Title',
                floatingLabelStyle: TextStyle(fontSize: 20),
                alignLabelWithHint: true,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintText: 'Enter a title',
              ),
            ),
          ),
          RoutineStartDateTimeButton(
            start: routineStartDT,
            onUpdate: (dt, {required hasTime}) {
              routineStartDT = dt;
              startHasTime = hasTime;
              _validateRoutineForm();
            },
            onClear: (dt, {required hasTime}) {
              routineStartDT = dt;
              startHasTime = hasTime;
              _validateRoutineForm();
            },
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: !_enAdd ? null : () => submit(context),
                child: widget.routine != null
                    ? const Text('Update')
                    : const Text('Add'),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _validateRoutineForm() {
    bool isCategoryValid = routineTitle != null;
    bool isTitleValid = routineTitle == null ? false : routineTitle!.isNotEmpty;
    bool isStartDtValid = routineStartDT != null;
    if (_enAdd != (isTitleValid && isStartDtValid && isCategoryValid)) {
      setState(() {
        _enAdd = (isTitleValid && isStartDtValid && isCategoryValid);
      });
    }
  }

  void _addRoutine() {
    final Category category =
        categories.where((c) => c.name == selectedCategory).first;
    _isarProvider.addRoutine(
      category: category,
      title: routineTitle!,
      start: routineStartDT!,
    );
  }

  void _updateRoutine(Routine routine) {
    final Category category =
        categories.where((c) => c.name == selectedCategory).first;
    if (category.name != routine.category.value!.name) {
      routine.category.value = category;
    }
    if (routineTitle != routine.title) {
      routine.title = routineTitle!;
    }
    if (routineStartDT != routine.start) {
      routine.start = routineStartDT!;
    }
    _isarProvider.updateRoutine(routine: routine);
  }

  void submit(BuildContext context) {
    bool isCategoryValid = routineTitle != null;
    bool isTitleValid = routineTitle == null ? false : routineTitle!.isNotEmpty;
    bool isStartDtValid = routineStartDT != null;
    if (_enAdd == (isTitleValid && isStartDtValid && isCategoryValid)) {
      widget.routine != null ? _updateRoutine(widget.routine!) : _addRoutine();
      Navigator.pop(context);
    }
  }
}
