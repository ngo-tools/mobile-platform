import 'package:ngotools_api/src/generated/model/capabilities_response.dart';
import 'package:ngotools_api/src/generated/model/capability_blocker.dart';
import 'package:ngotools_api/src/generated/model/contact.dart';
import 'package:ngotools_api/src/generated/model/contact_address.dart';
import 'package:ngotools_api/src/generated/model/contact_collection_response.dart';
import 'package:ngotools_api/src/generated/model/contact_response.dart';
import 'package:ngotools_api/src/generated/model/contact_search_request.dart';
import 'package:ngotools_api/src/generated/model/contact_search_term.dart';
import 'package:ngotools_api/src/generated/model/contact_sort.dart';
import 'package:ngotools_api/src/generated/model/create_contact_request.dart';
import 'package:ngotools_api/src/generated/model/current_user.dart';
import 'package:ngotools_api/src/generated/model/current_user_response.dart';
import 'package:ngotools_api/src/generated/model/import_capabilities.dart';
import 'package:ngotools_api/src/generated/model/import_capability.dart';
import 'package:ngotools_api/src/generated/model/import_limits.dart';
import 'package:ngotools_api/src/generated/model/mobile_app_approved_release.dart';
import 'package:ngotools_api/src/generated/model/mobile_app_release_approval.dart';
import 'package:ngotools_api/src/generated/model/mobile_app_release_poll_request.dart';
import 'package:ngotools_api/src/generated/model/mobile_app_release_poll_response.dart';
import 'package:ngotools_api/src/generated/model/mobile_app_release_request.dart';
import 'package:ngotools_api/src/generated/model/mobile_app_release_start_response.dart';
import 'package:ngotools_api/src/generated/model/pagination_links.dart';
import 'package:ngotools_api/src/generated/model/pagination_meta.dart';
import 'package:ngotools_api/src/generated/model/problem_details.dart';
import 'package:ngotools_api/src/generated/model/runtime_capabilities.dart';
import 'package:ngotools_api/src/generated/model/update_contact_request.dart';

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
    case 'Contact':
      return Contact.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'ContactAddress':
      return ContactAddress.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'ContactCollectionResponse':
      return ContactCollectionResponse.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'ContactResponse':
      return ContactResponse.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'ContactSearchRequest':
      return ContactSearchRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'ContactSearchTerm':
      return ContactSearchTerm.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'ContactSort':
      return ContactSort.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'CreateContactRequest':
      return CreateContactRequest.fromJson(value as Map<String, dynamic>)
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
    case 'MobileAppApprovedRelease':
      return MobileAppApprovedRelease.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'MobileAppReleaseApproval':
      return MobileAppReleaseApproval.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'MobileAppReleasePollRequest':
      return MobileAppReleasePollRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'MobileAppReleasePollResponse':
      return MobileAppReleasePollResponse.fromJson(
            value as Map<String, dynamic>,
          )
          as ReturnType;
    case 'MobileAppReleaseRequest':
      return MobileAppReleaseRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'MobileAppReleaseStartResponse':
      return MobileAppReleaseStartResponse.fromJson(
            value as Map<String, dynamic>,
          )
          as ReturnType;
    case 'PaginationLinks':
      return PaginationLinks.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'PaginationMeta':
      return PaginationMeta.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'ProblemDetails':
      return ProblemDetails.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'RuntimeCapabilities':
      return RuntimeCapabilities.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'UpdateContactRequest':
      return UpdateContactRequest.fromJson(value as Map<String, dynamic>)
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
