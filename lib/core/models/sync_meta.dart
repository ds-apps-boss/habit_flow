// core/models/sync_meta.dart

import 'package:hive_ce/hive.dart';

part 'sync_meta.g.dart';

@HiveType(typeId: 31)
enum SyncMode {
  @HiveField(0)
  manual,

  @HiveField(1)
  scheduled,

  @HiveField(2)
  automatic,
}

@HiveType(typeId: 30)
class SyncMeta {
  @HiveField(0)
  final DateTime? lastSyncAt;

  @HiveField(1)
  final SyncMode mode;

  @HiveField(2)
  final int scheduledSyncInMinutes;

  const SyncMeta({
    required this.lastSyncAt,
    required this.mode,
    required this.scheduledSyncInMinutes,
  });

  SyncMeta copyWith({
    DateTime? lastSyncAt,
    SyncMode? mode,
    int? scheduledSyncInMinutes,
  }) {
    return SyncMeta(
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      mode: mode ?? this.mode,
      scheduledSyncInMinutes:
          scheduledSyncInMinutes ?? this.scheduledSyncInMinutes,
    );
  }
}
