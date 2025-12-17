// core/models/habit_completion.dart

import 'package:hive_ce/hive.dart';

part 'habit_completion.g.dart';

@HiveType(typeId: 21)
class HabitCompletion {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String habitId;

  /// date-only, normalized to 00:00 local
  @HiveField(2)
  final DateTime dateLocal;

  @HiveField(3)
  final bool isDone;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final DateTime updatedAt;

  const HabitCompletion({
    required this.id,
    required this.habitId,
    required this.dateLocal,
    required this.isDone,
    required this.createdAt,
    required this.updatedAt,
  });

  HabitCompletion copyWith({bool? isDone, DateTime? updatedAt}) {
    return HabitCompletion(
      id: id,
      habitId: habitId,
      dateLocal: dateLocal,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
