// core/providers/sync_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:habit_flow/core/providers/hive_providers.dart';
import 'package:habit_flow/core/services/sync_service.dart';

final supabaseProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(
    supabase: ref.watch(supabaseProvider),
    habits: ref.watch(habitsBoxProvider),
    completions: ref.watch(habitCompletionsBoxProvider),
  );
});
