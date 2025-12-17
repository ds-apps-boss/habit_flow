// core/utils/date_utils.dart

DateTime dateOnlyLocal(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

String yyyyMmDd(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

String completionKey({required String habitId, required DateTime dateLocal}) =>
    '$habitId|${yyyyMmDd(dateLocal)}';
