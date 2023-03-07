import 'dart:math';

import 'package:flutter/foundation.dart';

bool listRoughlyEquals(Iterable list1, Iterable list2) {
  double roundDouble(double value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  final normalizedList1 = list1.map((e) => roundDouble(e, 2)).toList();
  final normalizedList2 = list2.map((e) => roundDouble(e, 2)).toList();

  return listEquals(normalizedList1, normalizedList2);
}
