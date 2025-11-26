extension DateTimeExtension on DateTime {
  DateTime get dateOnly => DateTime(year, month, day);

  // Calculate week start (Monday, time 00:00:00)
  DateTime startOfWeek({int firstDayOfWeek = 1}) {
    final now = dateOnly;
    final currentDay = now.weekday;
    final daysToSubtract = (currentDay - firstDayOfWeek) % 7;
    return now.subtract(Duration(days: daysToSubtract));
  }

  // Calculate week end (Sunday, ora 23:59:59)
  DateTime endOfWeek({int firstDayOfWeek = 1}) {
    final start = startOfWeek(firstDayOfWeek: firstDayOfWeek);
    return start.add(
      const Duration(
        days: 6,
        hours: 23,
        minutes: 59,
        seconds: 59,
      ),
    );
  }
}
