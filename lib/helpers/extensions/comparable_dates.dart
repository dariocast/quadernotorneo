import '../../utils/log_helper.dart';

extension DateTimeCompareWithTime on DateTime {
  Duration debugDifference(DateTime other) {
    Duration diff = this.difference(other);
    QTLog.log("Difference between datetimes: ${diff.inMinutes}",
        name: 'helpers.comparable_dates');
    return diff;
  }
}
