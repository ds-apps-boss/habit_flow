// core/widgets/app_bar.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:habit_flow/core/router/app_router.dart';
//import 'package:habit_flow/core/services/sync_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_flow/core/providers/sync_provider.dart';

/*
class HabitAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HabitAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);


  @override
  Widget build(BuildContext context) {
    final syncService = SyncService(Supabase.instance.client);

    return AppBar(
      title: const Text('Habit Flow'),
      actions: [
        IconButton(
          icon: const Icon(Icons.sync),
          onPressed: () async {
            try {
              if (!await syncService.hasSession()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Nicht angemeldet – Sync nicht möglich'),
                  ),
                );
                return;
              }

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Sync läuft...')));

              await syncService.pushAllToSupabase();

              if (!context.mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Sync OK')));
            } catch (e) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Sync Fehler: $e')));
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await Supabase.instance.client.auth.signOut();
            if (context.mounted) context.go(AppRoutes.auth);
          },
        ),å
      ],
    );
  }
}
*/
class HabitAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HabitAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: const Text('Habit Flow'),
      actions: [
        IconButton(
          icon: const Icon(Icons.sync),
          onPressed: () async {
            try {
              final session = Supabase.instance.client.auth.currentSession;
              if (session == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No login — no sync')),
                );
                return;
              }

              await ref.read(syncServiceProvider).syncNow();

              if (!context.mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Sync OK')));
            } catch (e) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Sync Fehler: $e')));
            }
          },
        ),

        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await Supabase.instance.client.auth.signOut();
            if (!context.mounted) return;
            context.go(AppRoutes.auth);
          },
        ),
      ],
    );
  }
}
