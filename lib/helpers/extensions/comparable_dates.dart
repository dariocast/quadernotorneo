extension DateTimeCompareWithTime on DateTime {
  Duration debugDifference(DateTime other) {
    Duration diff = this.difference(other);
    print("Difference between datetimes: ${diff.inMinutes}");
    return diff;
  }
}
