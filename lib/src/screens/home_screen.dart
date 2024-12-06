import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../collections/routine.dart';
import '../database/isar_provider.dart';
import '../widgets/routine_tile.dart';
import 'routine_bottom_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  static const String route = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Routine'),
      ),
      body: const RoutinesBuilder(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showRoutineBottomSheet(context),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}

class RoutinesBuilder extends StatefulWidget {
  const RoutinesBuilder({
    super.key,
  });

  @override
  State<RoutinesBuilder> createState() => _RoutinesBuilderState();
}

class _RoutinesBuilderState extends State<RoutinesBuilder> {
  late final IsarProvider isarProvider;
  late List<Routine> routines;
  late Widget searchBar;
  late TextEditingController searchController;

  @override
  void initState() {
    isarProvider = Provider.of<IsarProvider>(context, listen: false);
    routines = isarProvider.routines;
    searchController = TextEditingController();
    searchBar = Padding(
      padding: const EdgeInsets.all(8.0),
      child: SearchBar(
        controller: searchController,
        hintText: 'Search routines',
        onChanged: (String value) {
          routines = isarProvider.queryRoutinesByTitle(value);
          setState(() {});
        },
        leading: const Icon(Icons.search),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        ),
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Routine>>(
        initialData: routines,
        stream: isarProvider.listenToRoutines(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            AlertDialog(
              content: Text(snapshot.error.toString()),
            );
          } else if (snapshot.hasData) {
            var data =
                searchController.text.isEmpty ? snapshot.data! : routines;
            return _RoutinesListView(
              routines: data,
              searchBar: searchBar,
              isarProvider: isarProvider,
            );
          } else {
            return const Center(
              child: Text('No data found!'),
            );
          }
          return const CircularProgressIndicator.adaptive();
        });
  }
}

class _RoutinesListView extends StatelessWidget {
  const _RoutinesListView({
    super.key,
    required this.routines,
    required this.searchBar,
    required this.isarProvider,
  });

  final List<Routine> routines;
  final Widget searchBar;
  final IsarProvider isarProvider;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: routines.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) return searchBar;
        final routine = routines[index - 1];
        return RoutineTile(
          title: routine.title,
          start: routine.start,
          categoryName: routine.category.value?.name ?? 'None',
          onTap: () => showRoutineBottomSheet(context, routine: routine),
          onDelete: () => isarProvider.deleteRoutine(routine),
        );
      },
    );
  }
}
