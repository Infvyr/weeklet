sealed class FilterEvent {
  const FilterEvent();
}

final class FilterDateChanged extends FilterEvent {
  FilterDateChanged({this.month, this.year});

  final int? month;
  final int? year;
}
