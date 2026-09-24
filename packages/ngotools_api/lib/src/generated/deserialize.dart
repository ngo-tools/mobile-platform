import 'package:ngotools_api/src/generated/model/capabilities_response.dart';
import 'package:ngotools_api/src/generated/model/capability_blocker.dart';
import 'package:ngotools_api/src/generated/model/current_user.dart';
import 'package:ngotools_api/src/generated/model/current_user_response.dart';
import 'package:ngotools_api/src/generated/model/import_capabilities.dart';
import 'package:ngotools_api/src/generated/model/import_capability.dart';
import 'package:ngotools_api/src/generated/model/import_limits.dart';
import 'package:ngotools_api/src/generated/model/problem_details.dart';
import 'package:ngotools_api/src/generated/model/runtime_capabilities.dart';

final _regList = RegExp(r'^List<(.*)>$');
final _regSet = RegExp(r'^Set<(.*)>$');
final _regMap = RegExp(r'^Map<String,(.*)>$');

ReturnType deserialize<ReturnType, BaseType>(
  dynamic value,
  String targetType, {
  bool growable = true,
}) {
  switch (targetType) {
    case 'String':
      return '$value' as ReturnType;
    case 'int':
      return (value is int ? value : int.parse('$value')) as ReturnType;
    case 'bool':
      if (value is bool) {
        return value as ReturnType;
      }
      final valueString = '$value'.toLowerCase();
      return (valueString == 'true' || valueString == '1') as ReturnType;
    case 'double':
      return (value is double ? value : double.parse('$value')) as ReturnType;
    case 'CapabilitiesResponse':
      return CapabilitiesResponse.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'CapabilityBlocker':
      return CapabilityBlocker.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'CurrentUser':
      return CurrentUser.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'CurrentUserResponse':
      return CurrentUserResponse.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'ImportCapabilities':
      return ImportCapabilities.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'ImportCapability':
      return ImportCapability.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'ImportLimits':
      return ImportLimits.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'ProblemDetails':
      return ProblemDetails.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'RuntimeCapabilities':
      return RuntimeCapabilities.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    default:
      RegExpMatch? match;

      if (value is List && (match = _regList.firstMatch(targetType)) != null) {
        targetType = match![1]!; // ignore: parameter_assignments
        return value
                .map<BaseType>(
                  (dynamic v) => deserialize<BaseType, BaseType>(
                    v,
                    targetType,
                    growable: growable,
                  ),
                )
                .toList(growable: growable)
            as ReturnType;
      }
      if (value is Set && (match = _regSet.firstMatch(targetType)) != null) {
        targetType = match![1]!; // ignore: parameter_assignments
        return value
                .map<BaseType>(
                  (dynamic v) => deserialize<BaseType, BaseType>(
                    v,
                    targetType,
                    growable: growable,
                  ),
                )
                .toSet()
            as ReturnType;
      }
      if (value is Map && (match = _regMap.firstMatch(targetType)) != null) {
        targetType = match![1]!.trim(); // ignore: parameter_assignments
        return Map<String, BaseType>.fromIterables(
              value.keys as Iterable<String>,
              value.values.map(
                (dynamic v) => deserialize<BaseType, BaseType>(
                  v,
                  targetType,
                  growable: growable,
                ),
              ),
            )
            as ReturnType;
      }
      break;
  }
  throw Exception('Cannot deserialize');
}
