import 'package:ngotools_api/src/generated/model/capabilities_response.dart';
import 'package:ngotools_api/src/generated/model/capability_blocker.dart';
import 'package:ngotools_api/src/generated/model/chat_account.dart';
import 'package:ngotools_api/src/generated/model/chat_account_response.dart';
import 'package:ngotools_api/src/generated/model/chat_person.dart';
import 'package:ngotools_api/src/generated/model/chat_person_collection_response.dart';
import 'package:ngotools_api/src/generated/model/chat_session.dart';
import 'package:ngotools_api/src/generated/model/chat_session_response.dart';
import 'package:ngotools_api/src/generated/model/contact.dart';
import 'package:ngotools_api/src/generated/model/contact_address.dart';
import 'package:ngotools_api/src/generated/model/contact_collection_response.dart';
import 'package:ngotools_api/src/generated/model/contact_response.dart';
import 'package:ngotools_api/src/generated/model/contact_search_request.dart';
import 'package:ngotools_api/src/generated/model/contact_search_term.dart';
import 'package:ngotools_api/src/generated/model/contact_sort.dart';
import 'package:ngotools_api/src/generated/model/create_chat_session_request.dart';
import 'package:ngotools_api/src/generated/model/create_contact_request.dart';
import 'package:ngotools_api/src/generated/model/current_user.dart';
import 'package:ngotools_api/src/generated/model/current_user_response.dart';
import 'package:ngotools_api/src/generated/model/event_agenda.dart';
import 'package:ngotools_api/src/generated/model/event_agenda_entry.dart';
import 'package:ngotools_api/src/generated/model/event_agenda_sub_item.dart';
import 'package:ngotools_api/src/generated/model/event_assignment.dart';
import 'package:ngotools_api/src/generated/model/event_assignment_collection_response.dart';
import 'package:ngotools_api/src/generated/model/event_availability.dart';
import 'package:ngotools_api/src/generated/model/event_availability_collection_response.dart';
import 'package:ngotools_api/src/generated/model/event_availability_response.dart';
import 'package:ngotools_api/src/generated/model/event_collection_response.dart';
import 'package:ngotools_api/src/generated/model/event_detail.dart';
import 'package:ngotools_api/src/generated/model/event_person.dart';
import 'package:ngotools_api/src/generated/model/event_reference.dart';
import 'package:ngotools_api/src/generated/model/event_response.dart';
import 'package:ngotools_api/src/generated/model/event_service_reference.dart';
import 'package:ngotools_api/src/generated/model/event_summary.dart';
import 'package:ngotools_api/src/generated/model/event_team_slot.dart';
import 'package:ngotools_api/src/generated/model/event_type_reference.dart';
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
import 'package:ngotools_api/src/generated/model/update_event_availability_request.dart';

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
    case 'ChatAccount':
      return ChatAccount.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'ChatAccountResponse':
      return ChatAccountResponse.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'ChatPerson':
      return ChatPerson.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'ChatPersonCollectionResponse':
      return ChatPersonCollectionResponse.fromJson(
            value as Map<String, dynamic>,
          )
          as ReturnType;
    case 'ChatSession':
      return ChatSession.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'ChatSessionResponse':
      return ChatSessionResponse.fromJson(value as Map<String, dynamic>)
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
    case 'CreateChatSessionRequest':
      return CreateChatSessionRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'CreateContactRequest':
      return CreateContactRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'CurrentUser':
      return CurrentUser.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'CurrentUserResponse':
      return CurrentUserResponse.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'EventAgenda':
      return EventAgenda.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'EventAgendaEntry':
      return EventAgendaEntry.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'EventAgendaSubItem':
      return EventAgendaSubItem.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'EventAssignment':
      return EventAssignment.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'EventAssignmentCollectionResponse':
      return EventAssignmentCollectionResponse.fromJson(
            value as Map<String, dynamic>,
          )
          as ReturnType;
    case 'EventAvailability':
      return EventAvailability.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'EventAvailabilityCollectionResponse':
      return EventAvailabilityCollectionResponse.fromJson(
            value as Map<String, dynamic>,
          )
          as ReturnType;
    case 'EventAvailabilityResponse':
      return EventAvailabilityResponse.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'EventCollectionResponse':
      return EventCollectionResponse.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'EventDetail':
      return EventDetail.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'EventPerson':
      return EventPerson.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'EventReference':
      return EventReference.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'EventResponse':
      return EventResponse.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'EventServiceReference':
      return EventServiceReference.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'EventSummary':
      return EventSummary.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'EventTeamSlot':
      return EventTeamSlot.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'EventTypeReference':
      return EventTypeReference.fromJson(value as Map<String, dynamic>)
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
    case 'UpdateEventAvailabilityRequest':
      return UpdateEventAvailabilityRequest.fromJson(
            value as Map<String, dynamic>,
          )
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
