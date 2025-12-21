// core/providers/hive_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import '../models/habit.dart';
import '../models/habit_completion.dart';

final habitsBoxProvider = Provider<Box<Habit>>((ref) {
  return Hive.box<Habit>('habits');
});

final habitCompletionsBoxProvider = Provider<Box<HabitCompletion>>((ref) {
  return Hive.box<HabitCompletion>('habit_completions');
});
