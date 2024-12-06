import 'package:flutter/material.dart';
import '../collections/category.dart';

class SelectCategoryDropdown extends StatefulWidget {
  final List<Category> categories;
  final void Function()? onPressedAdd;
  final void Function(String?)? onChangedCategory;
  final Category? initCategory;

  const SelectCategoryDropdown({
    super.key,
    required this.categories,
    this.onPressedAdd,
    this.onChangedCategory,
    this.initCategory,
  });

  @override
  State<SelectCategoryDropdown> createState() => SelectCategoryDropdownState();
}

class SelectCategoryDropdownState extends State<SelectCategoryDropdown> {
  late String? selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.initCategory?.name;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Category',
            style: TextStyle(fontSize: 14),
          ),
          Row(
            children: [
              DropdownButton<String>(
                // underline: const SizedBox.shrink(),
                hint: const Text('Select Category'),
                items: widget.categories
                    .map<DropdownMenuItem<String>>(
                      (Category value) => DropdownMenuItem(
                        value: value.name,
                        child: Text(value.name),
                      ),
                    )
                    .toList(),
                value: selectedCategory,
                onChanged: (String? value) {
                  setState(() {
                    selectedCategory = value;
                  });
                  if (widget.onChangedCategory != null) {
                    widget.onChangedCategory!(value);
                  }
                },
              ),
              const SizedBox(width: 8.0),
              IconButton(
                onPressed: widget.onPressedAdd,
                icon: const Icon(Icons.add),
              ),
            ],
          )
        ],
      ),
    );
  }
}
