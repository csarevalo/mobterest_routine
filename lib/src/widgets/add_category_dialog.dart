import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

import '../database/isar_provider.dart';

class AddCategoryDialog extends StatefulWidget {
  const AddCategoryDialog({
    super.key,
  });

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _textController;
  late final IsarProvider _isarProvider;
  late bool _enAdd;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _isarProvider = Provider.of<IsarProvider>(context, listen: false);
    _enAdd = false;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void addCategory() {
      if (_formKey.currentState!.validate()) {
        _isarProvider.addCategory(_textController.text.trim());
        _textController.clear();
        Navigator.pop(context);
      }
    }

    return AlertDialog(
      title: const Text('Add Category'),
      titleTextStyle: const TextStyle(fontSize: 20),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: TextFormField(
              autofocus: true,
              controller: _textController,
              onEditingComplete: addCategory,
              onChanged: (value) {
                final bool en = _formKey.currentState!.validate();
                if (en != _enAdd) {
                  setState(() {
                    _enAdd = en;
                  });
                }
              },
              validator: (String? value) {
                if (value == null) return 'Missing category name (null)';
                if (value.isEmpty) return 'Missing category name';
                bool isUnique = _isarProvider.verifyUniqueCategory(
                  value.trim(),
                );
                if (!isUnique) return 'Category already exists.';
                return null;
              },
            ),
          ),
        ],
      ),
      actions: [
        PlatformTextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        PlatformTextButton(
          onPressed: _enAdd ? addCategory : null,
          child: const Text('Add'),
        ),
      ],
      actionsPadding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 14.0,
      ),
    );
  }
}

Future<void> showAddCategoryDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return const AddCategoryDialog();
    },
  );
}
