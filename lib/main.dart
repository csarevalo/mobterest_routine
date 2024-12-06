import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/database/isar_provider.dart';
import 'src/routine_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isarProvider = IsarProvider();
  await isarProvider.initIsar();
  runApp(
    ChangeNotifierProvider.value(
      value: isarProvider,
      builder: (context, _) {
        return const RoutineApp();
      },
    ),
  );
}
