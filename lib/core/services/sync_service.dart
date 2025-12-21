import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:habit_flow/core/models/habit.dart';
import 'package:habit_flow/core/models/habit_completion.dart';
//import 'package:habit_flow/core/models/sync_meta.dart';
import 'package:habit_flow/core/utils/date_utils.dart';

/*
class SyncService {
  SyncService(this._client);

  final SupabaseClient _client;

  Future<bool> hasSession() async {
    return _client.auth.currentSession != null;
  }

  Future<void> pushAllToSupabase() async {
    final session = _client.auth.currentSession;
    if (session == null) {
      throw Exception('Nicht angemeldet – Sync ist nicht möglich');
    }

    final userId = session.user.id;

    final habitsBox = Hive.box<Habit>('habits');
    final completionsBox = Hive.box<HabitCompletion>('habit_completions');
    final metaBox = Hive.box<SyncMeta>('sync_meta');

    // 1) habits -> upsert
    final habits = habitsBox.values.toList();
    final habitRows = habits.map((h) => h.toMap(userId: userId)).toList();

    if (habitRows.isNotEmpty) {
      await _client.from('habits').upsert(habitRows);
    }

    // 2) completions -> upsert
    final completions = completionsBox.values.toList();
    final completionRows = completions
        .map((c) => c.toMap(userId: userId))
        .toList();

    if (completionRows.isNotEmpty) {
      await _client.from('habit_completions').upsert(completionRows);
    }

    // 3) update sync meta locally
    final now = DateTime.now();
    final current = metaBox.get('meta');
    final updated =
        (current ??
                const SyncMeta(
                  lastSyncAt: null,
                  mode: SyncMode.manual,
                  scheduledSyncInMinutes: 60,
                ))
            .copyWith(lastSyncAt: now);

    await metaBox.put('meta', updated);
  }
}
*/

class SyncService {
  final SupabaseClient supabase;
  final Box<Habit> habits;
  final Box<HabitCompletion> completions;

  SyncService({
    required this.supabase,
    required this.habits,
    required this.completions,
  });

  Future<void> syncNow() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('no logiin - no sync!');
    }
    final uid = user.id;

    // --- HABITS ---
    final habitRows = habits.values
        .map(
          (h) => {
            'id': h.id,
            'user_id': uid,
            'name': h.name,
            'is_active': h.isActive,
            'deleted': h.deleted,
            'created_at': h.createdAt.toIso8601String(),
            'updated_at': h.updatedAt.toIso8601String(),
          },
        )
        .toList();

    if (habitRows.isNotEmpty) {
      await supabase.from('habits').upsert(habitRows);
    }

    // --- COMPLETIONS ---
    String hhMmSs(DateTime dt) =>
        '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}:'
        '${dt.second.toString().padLeft(2, '0')}';

    final completionRows = completions.values
        .map(
          (c) => {
            'id': c.id,
            'user_id': uid,
            'habit_id': c.habitId,
            'date_local': yyyyMmDd(c.dateLocal),
            'time_local': hhMmSs(c.dateLocal),
            'is_done': c.isDone,
            'created_at': c.createdAt.toIso8601String(),
            'updated_at': c.updatedAt.toIso8601String(),
          },
        )
        .toList();

    if (completionRows.isNotEmpty) {
      await supabase.from('habit_completions').upsert(completionRows);
    }
  }
}
