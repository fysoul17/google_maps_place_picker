import 'package:flutter/foundation.dart';
import 'package:stack_trace/stack_trace.dart';

void debug(Object object) {
  var output = "${Trace.current().frames[1].location} | $object";
  final pattern = RegExp('.{1,1000}');
  pattern.allMatches(output).forEach((match) => debugPrint(match.group(0)));
}
