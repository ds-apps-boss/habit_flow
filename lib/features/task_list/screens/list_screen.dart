// features/task_list/screens/list_screen.dart

import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:habit_flow/core/models/habit.dart';
import 'package:habit_flow/core/models/habit_completion.dart';
import 'package:habit_flow/core/utils/date_utils.dart';
import 'package:habit_flow/core/widgets/app_bar.dart';
import 'package:habit_flow/features/task_list/widgets/empty_content.dart';
import 'package:habit_flow/features/task_list/widgets/item_list.dart';
import 'package:uuid/uuid.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final _uuid = const Uuid();

  late final Box<Habit> habitsBox;
  late final Box<HabitCompletion> completionsBox;

  @override
  void initState() {
    super.initState();
    habitsBox = Hive.box<Habit>('habits');
    completionsBox = Hive.box<HabitCompletion>('habit_completions');
  }

  Future<void> addHabit() async {
    final controller = TextEditingController();

    final name = await showDialog<String?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Task hinzufügen'),
        content: TextField(
          autofocus: true,
          controller: controller,
          decoration: const InputDecoration(hintText: 'Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Speichern'),
          ),
        ],
      ),
    );

    final trimmed = (name ?? '').trim();
    if (trimmed.isEmpty) return;

    final now = DateTime.now();
    final habit = Habit(
      id: _uuid.v4(),
      name: trimmed,
      isActive: true,
      createdAt: now,
      updatedAt: now,
      deleted: false,
    );

    await habitsBox.put(habit.id, habit); // key = id
  }

  Future<void> editHabit(Habit habit) async {
    final controller = TextEditingController(text: habit.name);

    final newName = await showDialog<String?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Task bearbeiten'),
        content: TextField(
          autofocus: true,
          controller: controller,
          decoration: const InputDecoration(hintText: 'Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Speichern'),
          ),
        ],
      ),
    );

    final trimmed = (newName ?? '').trim();
    if (trimmed.isEmpty) return;

    await habitsBox.put(
      habit.id,
      habit.copyWith(name: trimmed, updatedAt: DateTime.now()),
    );
  }

  Future<void> deleteHabit(Habit habit) async {
    await habitsBox.delete(habit.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HabitAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: addHabit,
        child: const Icon(Icons.add),
      ),
      body: ValueListenableBuilder(
        valueListenable: habitsBox.listenable(),
        builder: (context, Box<Habit> habitsBox, _) {
          // чтобы UI реагировал и на изменения completions тоже:
          return ValueListenableBuilder(
            valueListenable: completionsBox.listenable(),
            builder: (context, Box<HabitCompletion> completionsBox, __) {
              final habits = habitsBox.values.where((h) => !h.deleted).toList()
                ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

              if (habits.isEmpty) return const EmptyContent();

              final today = dateOnlyLocal(DateTime.now());

              bool doneToday(Habit habit) {
                final key = completionKey(habitId: habit.id, dateLocal: today);
                return completionsBox.get(key)?.isDone ?? false;
              }

              Future<void> toggleDoneToday(Habit habit) async {
                final key = completionKey(habitId: habit.id, dateLocal: today);
                final existing = completionsBox.get(key);
                final now = DateTime.now();

                if (existing == null) {
                  await completionsBox.put(
                    key,
                    HabitCompletion(
                      id: key, // ок для 1 раза в день
                      habitId: habit.id,
                      dateLocal: today,
                      isDone: true,
                      createdAt: now,
                      updatedAt: now,
                    ),
                  );
                } else {
                  await completionsBox.put(
                    key,
                    existing.copyWith(isDone: !existing.isDone, updatedAt: now),
                  );
                }
              }

              return ItemList(
                items: habits,
                isDoneToday: doneToday,
                onToggleDoneToday: toggleDoneToday,
                onEdit: (habit, newName) async {
                  final trimmed = newName.trim();
                  if (trimmed.isEmpty) return;
                  await habitsBox.put(
                    habit.id,
                    habit.copyWith(name: trimmed, updatedAt: DateTime.now()),
                  );
                },
                onDelete: (habit) async => habitsBox.delete(habit.id),
              );
            },
          );
        },
      ),
    );
  }
}
