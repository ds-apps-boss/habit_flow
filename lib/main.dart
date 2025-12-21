// main.dart

import 'package:flutter/material.dart';
import 'package:habit_flow/app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//import 'package:hive_ce/hive.dart';
import 'package:habit_flow/core/models/habit.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:habit_flow/core/models/habit_completion.dart';
import 'package:habit_flow/core/models/sync_meta.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Hive.initFlutter();

  Hive.registerAdapter(HabitAdapter());
  Hive.registerAdapter(HabitCompletionAdapter());
  Hive.registerAdapter(SyncModeAdapter());
  Hive.registerAdapter(SyncMetaAdapter());

  await Hive.openBox<Habit>('habits');
  await Hive.openBox<HabitCompletion>('habit_completions');
  await Hive.openBox<SyncMeta>('sync_meta');

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  //runApp(const App());
  runApp(const ProviderScope(child: App()));
}
