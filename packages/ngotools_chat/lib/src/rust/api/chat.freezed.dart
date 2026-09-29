// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MessageKind {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageKind);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessageKind()';
}


}

/// @nodoc
class $MessageKindCopyWith<$Res>  {
$MessageKindCopyWith(MessageKind _, $Res Function(MessageKind) __);
}


/// Adds pattern-matching-related methods to [MessageKind].
extension MessageKindPatterns on MessageKind {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MessageKind_Text value)?  text,TResult Function( MessageKind_Image value)?  image,TResult Function( MessageKind_UnableToDecrypt value)?  unableToDecrypt,TResult Function( MessageKind_Redacted value)?  redacted,TResult Function( MessageKind_Other value)?  other,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MessageKind_Text() when text != null:
return text(_that);case MessageKind_Image() when image != null:
return image(_that);case MessageKind_UnableToDecrypt() when unableToDecrypt != null:
return unableToDecrypt(_that);case MessageKind_Redacted() when redacted != null:
return redacted(_that);case MessageKind_Other() when other != null:
return other(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MessageKind_Text value)  text,required TResult Function( MessageKind_Image value)  image,required TResult Function( MessageKind_UnableToDecrypt value)  unableToDecrypt,required TResult Function( MessageKind_Redacted value)  redacted,required TResult Function( MessageKind_Other value)  other,}){
final _that = this;
switch (_that) {
case MessageKind_Text():
return text(_that);case MessageKind_Image():
return image(_that);case MessageKind_UnableToDecrypt():
return unableToDecrypt(_that);case MessageKind_Redacted():
return redacted(_that);case MessageKind_Other():
return other(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MessageKind_Text value)?  text,TResult? Function( MessageKind_Image value)?  image,TResult? Function( MessageKind_UnableToDecrypt value)?  unableToDecrypt,TResult? Function( MessageKind_Redacted value)?  redacted,TResult? Function( MessageKind_Other value)?  other,}){
final _that = this;
switch (_that) {
case MessageKind_Text() when text != null:
return text(_that);case MessageKind_Image() when image != null:
return image(_that);case MessageKind_UnableToDecrypt() when unableToDecrypt != null:
return unableToDecrypt(_that);case MessageKind_Redacted() when redacted != null:
return redacted(_that);case MessageKind_Other() when other != null:
return other(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String body)?  text,TResult Function( String body,  String sourceJson,  int? width,  int? height)?  image,TResult Function()?  unableToDecrypt,TResult Function()?  redacted,TResult Function( String description)?  other,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MessageKind_Text() when text != null:
return text(_that.body);case MessageKind_Image() when image != null:
return image(_that.body,_that.sourceJson,_that.width,_that.height);case MessageKind_UnableToDecrypt() when unableToDecrypt != null:
return unableToDecrypt();case MessageKind_Redacted() when redacted != null:
return redacted();case MessageKind_Other() when other != null:
return other(_that.description);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String body)  text,required TResult Function( String body,  String sourceJson,  int? width,  int? height)  image,required TResult Function()  unableToDecrypt,required TResult Function()  redacted,required TResult Function( String description)  other,}) {final _that = this;
switch (_that) {
case MessageKind_Text():
return text(_that.body);case MessageKind_Image():
return image(_that.body,_that.sourceJson,_that.width,_that.height);case MessageKind_UnableToDecrypt():
return unableToDecrypt();case MessageKind_Redacted():
return redacted();case MessageKind_Other():
return other(_that.description);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String body)?  text,TResult? Function( String body,  String sourceJson,  int? width,  int? height)?  image,TResult? Function()?  unableToDecrypt,TResult? Function()?  redacted,TResult? Function( String description)?  other,}) {final _that = this;
switch (_that) {
case MessageKind_Text() when text != null:
return text(_that.body);case MessageKind_Image() when image != null:
return image(_that.body,_that.sourceJson,_that.width,_that.height);case MessageKind_UnableToDecrypt() when unableToDecrypt != null:
return unableToDecrypt();case MessageKind_Redacted() when redacted != null:
return redacted();case MessageKind_Other() when other != null:
return other(_that.description);case _:
  return null;

}
}

}

/// @nodoc


class MessageKind_Text extends MessageKind {
  const MessageKind_Text({required this.body}): super._();
  

 final  String body;

/// Create a copy of MessageKind
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageKind_TextCopyWith<MessageKind_Text> get copyWith => _$MessageKind_TextCopyWithImpl<MessageKind_Text>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageKind_Text&&(identical(other.body, body) || other.body == body));
}


@override
int get hashCode => Object.hash(runtimeType,body);

@override
String toString() {
  return 'MessageKind.text(body: $body)';
}


}

/// @nodoc
abstract mixin class $MessageKind_TextCopyWith<$Res> implements $MessageKindCopyWith<$Res> {
  factory $MessageKind_TextCopyWith(MessageKind_Text value, $Res Function(MessageKind_Text) _then) = _$MessageKind_TextCopyWithImpl;
@useResult
$Res call({
 String body
});




}
/// @nodoc
class _$MessageKind_TextCopyWithImpl<$Res>
    implements $MessageKind_TextCopyWith<$Res> {
  _$MessageKind_TextCopyWithImpl(this._self, this._then);

  final MessageKind_Text _self;
  final $Res Function(MessageKind_Text) _then;

/// Create a copy of MessageKind
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? body = null,}) {
  return _then(MessageKind_Text(
body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class MessageKind_Image extends MessageKind {
  const MessageKind_Image({required this.body, required this.sourceJson, this.width, this.height}): super._();
  

 final  String body;
 final  String sourceJson;
 final  int? width;
 final  int? height;

/// Create a copy of MessageKind
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageKind_ImageCopyWith<MessageKind_Image> get copyWith => _$MessageKind_ImageCopyWithImpl<MessageKind_Image>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageKind_Image&&(identical(other.body, body) || other.body == body)&&(identical(other.sourceJson, sourceJson) || other.sourceJson == sourceJson)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}


@override
int get hashCode => Object.hash(runtimeType,body,sourceJson,width,height);

@override
String toString() {
  return 'MessageKind.image(body: $body, sourceJson: $sourceJson, width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class $MessageKind_ImageCopyWith<$Res> implements $MessageKindCopyWith<$Res> {
  factory $MessageKind_ImageCopyWith(MessageKind_Image value, $Res Function(MessageKind_Image) _then) = _$MessageKind_ImageCopyWithImpl;
@useResult
$Res call({
 String body, String sourceJson, int? width, int? height
});




}
/// @nodoc
class _$MessageKind_ImageCopyWithImpl<$Res>
    implements $MessageKind_ImageCopyWith<$Res> {
  _$MessageKind_ImageCopyWithImpl(this._self, this._then);

  final MessageKind_Image _self;
  final $Res Function(MessageKind_Image) _then;

/// Create a copy of MessageKind
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? body = null,Object? sourceJson = null,Object? width = freezed,Object? height = freezed,}) {
  return _then(MessageKind_Image(
body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,sourceJson: null == sourceJson ? _self.sourceJson : sourceJson // ignore: cast_nullable_to_non_nullable
as String,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class MessageKind_UnableToDecrypt extends MessageKind {
  const MessageKind_UnableToDecrypt(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageKind_UnableToDecrypt);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessageKind.unableToDecrypt()';
}


}




/// @nodoc


class MessageKind_Redacted extends MessageKind {
  const MessageKind_Redacted(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageKind_Redacted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessageKind.redacted()';
}


}




/// @nodoc


class MessageKind_Other extends MessageKind {
  const MessageKind_Other({required this.description}): super._();
  

 final  String description;

/// Create a copy of MessageKind
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageKind_OtherCopyWith<MessageKind_Other> get copyWith => _$MessageKind_OtherCopyWithImpl<MessageKind_Other>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageKind_Other&&(identical(other.description, description) || other.description == description));
}


@override
int get hashCode => Object.hash(runtimeType,description);

@override
String toString() {
  return 'MessageKind.other(description: $description)';
}


}

/// @nodoc
abstract mixin class $MessageKind_OtherCopyWith<$Res> implements $MessageKindCopyWith<$Res> {
  factory $MessageKind_OtherCopyWith(MessageKind_Other value, $Res Function(MessageKind_Other) _then) = _$MessageKind_OtherCopyWithImpl;
@useResult
$Res call({
 String description
});




}
/// @nodoc
class _$MessageKind_OtherCopyWithImpl<$Res>
    implements $MessageKind_OtherCopyWith<$Res> {
  _$MessageKind_OtherCopyWithImpl(this._self, this._then);

  final MessageKind_Other _self;
  final $Res Function(MessageKind_Other) _then;

/// Create a copy of MessageKind
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? description = null,}) {
  return _then(MessageKind_Other(
description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$TimelineEntry {

 String get uniqueId;
/// Create a copy of TimelineEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimelineEntryCopyWith<TimelineEntry> get copyWith => _$TimelineEntryCopyWithImpl<TimelineEntry>(this as TimelineEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineEntry&&(identical(other.uniqueId, uniqueId) || other.uniqueId == uniqueId));
}


@override
int get hashCode => Object.hash(runtimeType,uniqueId);

@override
String toString() {
  return 'TimelineEntry(uniqueId: $uniqueId)';
}


}

/// @nodoc
abstract mixin class $TimelineEntryCopyWith<$Res>  {
  factory $TimelineEntryCopyWith(TimelineEntry value, $Res Function(TimelineEntry) _then) = _$TimelineEntryCopyWithImpl;
@useResult
$Res call({
 String uniqueId
});




}
/// @nodoc
class _$TimelineEntryCopyWithImpl<$Res>
    implements $TimelineEntryCopyWith<$Res> {
  _$TimelineEntryCopyWithImpl(this._self, this._then);

  final TimelineEntry _self;
  final $Res Function(TimelineEntry) _then;

/// Create a copy of TimelineEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uniqueId = null,}) {
  return _then(_self.copyWith(
uniqueId: null == uniqueId ? _self.uniqueId : uniqueId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TimelineEntry].
extension TimelineEntryPatterns on TimelineEntry {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TimelineEntry_Message value)?  message,TResult Function( TimelineEntry_State value)?  state,TResult Function( TimelineEntry_DayDivider value)?  dayDivider,TResult Function( TimelineEntry_ReadMarker value)?  readMarker,TResult Function( TimelineEntry_TimelineStart value)?  timelineStart,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TimelineEntry_Message() when message != null:
return message(_that);case TimelineEntry_State() when state != null:
return state(_that);case TimelineEntry_DayDivider() when dayDivider != null:
return dayDivider(_that);case TimelineEntry_ReadMarker() when readMarker != null:
return readMarker(_that);case TimelineEntry_TimelineStart() when timelineStart != null:
return timelineStart(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TimelineEntry_Message value)  message,required TResult Function( TimelineEntry_State value)  state,required TResult Function( TimelineEntry_DayDivider value)  dayDivider,required TResult Function( TimelineEntry_ReadMarker value)  readMarker,required TResult Function( TimelineEntry_TimelineStart value)  timelineStart,}){
final _that = this;
switch (_that) {
case TimelineEntry_Message():
return message(_that);case TimelineEntry_State():
return state(_that);case TimelineEntry_DayDivider():
return dayDivider(_that);case TimelineEntry_ReadMarker():
return readMarker(_that);case TimelineEntry_TimelineStart():
return timelineStart(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TimelineEntry_Message value)?  message,TResult? Function( TimelineEntry_State value)?  state,TResult? Function( TimelineEntry_DayDivider value)?  dayDivider,TResult? Function( TimelineEntry_ReadMarker value)?  readMarker,TResult? Function( TimelineEntry_TimelineStart value)?  timelineStart,}){
final _that = this;
switch (_that) {
case TimelineEntry_Message() when message != null:
return message(_that);case TimelineEntry_State() when state != null:
return state(_that);case TimelineEntry_DayDivider() when dayDivider != null:
return dayDivider(_that);case TimelineEntry_ReadMarker() when readMarker != null:
return readMarker(_that);case TimelineEntry_TimelineStart() when timelineStart != null:
return timelineStart(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String uniqueId,  String? eventId,  String senderId,  String? senderName,  PlatformInt64 timestampMs,  bool isOwn,  bool isSending,  bool isFailed,  MessageKind kind)?  message,TResult Function( String uniqueId,  String description)?  state,TResult Function( String uniqueId,  PlatformInt64 timestampMs)?  dayDivider,TResult Function( String uniqueId)?  readMarker,TResult Function( String uniqueId)?  timelineStart,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TimelineEntry_Message() when message != null:
return message(_that.uniqueId,_that.eventId,_that.senderId,_that.senderName,_that.timestampMs,_that.isOwn,_that.isSending,_that.isFailed,_that.kind);case TimelineEntry_State() when state != null:
return state(_that.uniqueId,_that.description);case TimelineEntry_DayDivider() when dayDivider != null:
return dayDivider(_that.uniqueId,_that.timestampMs);case TimelineEntry_ReadMarker() when readMarker != null:
return readMarker(_that.uniqueId);case TimelineEntry_TimelineStart() when timelineStart != null:
return timelineStart(_that.uniqueId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String uniqueId,  String? eventId,  String senderId,  String? senderName,  PlatformInt64 timestampMs,  bool isOwn,  bool isSending,  bool isFailed,  MessageKind kind)  message,required TResult Function( String uniqueId,  String description)  state,required TResult Function( String uniqueId,  PlatformInt64 timestampMs)  dayDivider,required TResult Function( String uniqueId)  readMarker,required TResult Function( String uniqueId)  timelineStart,}) {final _that = this;
switch (_that) {
case TimelineEntry_Message():
return message(_that.uniqueId,_that.eventId,_that.senderId,_that.senderName,_that.timestampMs,_that.isOwn,_that.isSending,_that.isFailed,_that.kind);case TimelineEntry_State():
return state(_that.uniqueId,_that.description);case TimelineEntry_DayDivider():
return dayDivider(_that.uniqueId,_that.timestampMs);case TimelineEntry_ReadMarker():
return readMarker(_that.uniqueId);case TimelineEntry_TimelineStart():
return timelineStart(_that.uniqueId);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String uniqueId,  String? eventId,  String senderId,  String? senderName,  PlatformInt64 timestampMs,  bool isOwn,  bool isSending,  bool isFailed,  MessageKind kind)?  message,TResult? Function( String uniqueId,  String description)?  state,TResult? Function( String uniqueId,  PlatformInt64 timestampMs)?  dayDivider,TResult? Function( String uniqueId)?  readMarker,TResult? Function( String uniqueId)?  timelineStart,}) {final _that = this;
switch (_that) {
case TimelineEntry_Message() when message != null:
return message(_that.uniqueId,_that.eventId,_that.senderId,_that.senderName,_that.timestampMs,_that.isOwn,_that.isSending,_that.isFailed,_that.kind);case TimelineEntry_State() when state != null:
return state(_that.uniqueId,_that.description);case TimelineEntry_DayDivider() when dayDivider != null:
return dayDivider(_that.uniqueId,_that.timestampMs);case TimelineEntry_ReadMarker() when readMarker != null:
return readMarker(_that.uniqueId);case TimelineEntry_TimelineStart() when timelineStart != null:
return timelineStart(_that.uniqueId);case _:
  return null;

}
}

}

/// @nodoc


class TimelineEntry_Message extends TimelineEntry {
  const TimelineEntry_Message({required this.uniqueId, this.eventId, required this.senderId, this.senderName, required this.timestampMs, required this.isOwn, required this.isSending, required this.isFailed, required this.kind}): super._();
  

@override final  String uniqueId;
 final  String? eventId;
 final  String senderId;
 final  String? senderName;
 final  PlatformInt64 timestampMs;
 final  bool isOwn;
 final  bool isSending;
 final  bool isFailed;
 final  MessageKind kind;

/// Create a copy of TimelineEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimelineEntry_MessageCopyWith<TimelineEntry_Message> get copyWith => _$TimelineEntry_MessageCopyWithImpl<TimelineEntry_Message>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineEntry_Message&&(identical(other.uniqueId, uniqueId) || other.uniqueId == uniqueId)&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.senderName, senderName) || other.senderName == senderName)&&(identical(other.timestampMs, timestampMs) || other.timestampMs == timestampMs)&&(identical(other.isOwn, isOwn) || other.isOwn == isOwn)&&(identical(other.isSending, isSending) || other.isSending == isSending)&&(identical(other.isFailed, isFailed) || other.isFailed == isFailed)&&(identical(other.kind, kind) || other.kind == kind));
}


@override
int get hashCode => Object.hash(runtimeType,uniqueId,eventId,senderId,senderName,timestampMs,isOwn,isSending,isFailed,kind);

@override
String toString() {
  return 'TimelineEntry.message(uniqueId: $uniqueId, eventId: $eventId, senderId: $senderId, senderName: $senderName, timestampMs: $timestampMs, isOwn: $isOwn, isSending: $isSending, isFailed: $isFailed, kind: $kind)';
}


}

/// @nodoc
abstract mixin class $TimelineEntry_MessageCopyWith<$Res> implements $TimelineEntryCopyWith<$Res> {
  factory $TimelineEntry_MessageCopyWith(TimelineEntry_Message value, $Res Function(TimelineEntry_Message) _then) = _$TimelineEntry_MessageCopyWithImpl;
@override @useResult
$Res call({
 String uniqueId, String? eventId, String senderId, String? senderName, PlatformInt64 timestampMs, bool isOwn, bool isSending, bool isFailed, MessageKind kind
});


$MessageKindCopyWith<$Res> get kind;

}
/// @nodoc
class _$TimelineEntry_MessageCopyWithImpl<$Res>
    implements $TimelineEntry_MessageCopyWith<$Res> {
  _$TimelineEntry_MessageCopyWithImpl(this._self, this._then);

  final TimelineEntry_Message _self;
  final $Res Function(TimelineEntry_Message) _then;

/// Create a copy of TimelineEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uniqueId = null,Object? eventId = freezed,Object? senderId = null,Object? senderName = freezed,Object? timestampMs = null,Object? isOwn = null,Object? isSending = null,Object? isFailed = null,Object? kind = null,}) {
  return _then(TimelineEntry_Message(
uniqueId: null == uniqueId ? _self.uniqueId : uniqueId // ignore: cast_nullable_to_non_nullable
as String,eventId: freezed == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String?,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,senderName: freezed == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String?,timestampMs: null == timestampMs ? _self.timestampMs : timestampMs // ignore: cast_nullable_to_non_nullable
as PlatformInt64,isOwn: null == isOwn ? _self.isOwn : isOwn // ignore: cast_nullable_to_non_nullable
as bool,isSending: null == isSending ? _self.isSending : isSending // ignore: cast_nullable_to_non_nullable
as bool,isFailed: null == isFailed ? _self.isFailed : isFailed // ignore: cast_nullable_to_non_nullable
as bool,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as MessageKind,
  ));
}

/// Create a copy of TimelineEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MessageKindCopyWith<$Res> get kind {
  
  return $MessageKindCopyWith<$Res>(_self.kind, (value) {
    return _then(_self.copyWith(kind: value));
  });
}
}

/// @nodoc


class TimelineEntry_State extends TimelineEntry {
  const TimelineEntry_State({required this.uniqueId, required this.description}): super._();
  

@override final  String uniqueId;
 final  String description;

/// Create a copy of TimelineEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimelineEntry_StateCopyWith<TimelineEntry_State> get copyWith => _$TimelineEntry_StateCopyWithImpl<TimelineEntry_State>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineEntry_State&&(identical(other.uniqueId, uniqueId) || other.uniqueId == uniqueId)&&(identical(other.description, description) || other.description == description));
}


@override
int get hashCode => Object.hash(runtimeType,uniqueId,description);

@override
String toString() {
  return 'TimelineEntry.state(uniqueId: $uniqueId, description: $description)';
}


}

/// @nodoc
abstract mixin class $TimelineEntry_StateCopyWith<$Res> implements $TimelineEntryCopyWith<$Res> {
  factory $TimelineEntry_StateCopyWith(TimelineEntry_State value, $Res Function(TimelineEntry_State) _then) = _$TimelineEntry_StateCopyWithImpl;
@override @useResult
$Res call({
 String uniqueId, String description
});




}
/// @nodoc
class _$TimelineEntry_StateCopyWithImpl<$Res>
    implements $TimelineEntry_StateCopyWith<$Res> {
  _$TimelineEntry_StateCopyWithImpl(this._self, this._then);

  final TimelineEntry_State _self;
  final $Res Function(TimelineEntry_State) _then;

/// Create a copy of TimelineEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uniqueId = null,Object? description = null,}) {
  return _then(TimelineEntry_State(
uniqueId: null == uniqueId ? _self.uniqueId : uniqueId // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class TimelineEntry_DayDivider extends TimelineEntry {
  const TimelineEntry_DayDivider({required this.uniqueId, required this.timestampMs}): super._();
  

@override final  String uniqueId;
 final  PlatformInt64 timestampMs;

/// Create a copy of TimelineEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimelineEntry_DayDividerCopyWith<TimelineEntry_DayDivider> get copyWith => _$TimelineEntry_DayDividerCopyWithImpl<TimelineEntry_DayDivider>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineEntry_DayDivider&&(identical(other.uniqueId, uniqueId) || other.uniqueId == uniqueId)&&(identical(other.timestampMs, timestampMs) || other.timestampMs == timestampMs));
}


@override
int get hashCode => Object.hash(runtimeType,uniqueId,timestampMs);

@override
String toString() {
  return 'TimelineEntry.dayDivider(uniqueId: $uniqueId, timestampMs: $timestampMs)';
}


}

/// @nodoc
abstract mixin class $TimelineEntry_DayDividerCopyWith<$Res> implements $TimelineEntryCopyWith<$Res> {
  factory $TimelineEntry_DayDividerCopyWith(TimelineEntry_DayDivider value, $Res Function(TimelineEntry_DayDivider) _then) = _$TimelineEntry_DayDividerCopyWithImpl;
@override @useResult
$Res call({
 String uniqueId, PlatformInt64 timestampMs
});




}
/// @nodoc
class _$TimelineEntry_DayDividerCopyWithImpl<$Res>
    implements $TimelineEntry_DayDividerCopyWith<$Res> {
  _$TimelineEntry_DayDividerCopyWithImpl(this._self, this._then);

  final TimelineEntry_DayDivider _self;
  final $Res Function(TimelineEntry_DayDivider) _then;

/// Create a copy of TimelineEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uniqueId = null,Object? timestampMs = null,}) {
  return _then(TimelineEntry_DayDivider(
uniqueId: null == uniqueId ? _self.uniqueId : uniqueId // ignore: cast_nullable_to_non_nullable
as String,timestampMs: null == timestampMs ? _self.timestampMs : timestampMs // ignore: cast_nullable_to_non_nullable
as PlatformInt64,
  ));
}


}

/// @nodoc


class TimelineEntry_ReadMarker extends TimelineEntry {
  const TimelineEntry_ReadMarker({required this.uniqueId}): super._();
  

@override final  String uniqueId;

/// Create a copy of TimelineEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimelineEntry_ReadMarkerCopyWith<TimelineEntry_ReadMarker> get copyWith => _$TimelineEntry_ReadMarkerCopyWithImpl<TimelineEntry_ReadMarker>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineEntry_ReadMarker&&(identical(other.uniqueId, uniqueId) || other.uniqueId == uniqueId));
}


@override
int get hashCode => Object.hash(runtimeType,uniqueId);

@override
String toString() {
  return 'TimelineEntry.readMarker(uniqueId: $uniqueId)';
}


}

/// @nodoc
abstract mixin class $TimelineEntry_ReadMarkerCopyWith<$Res> implements $TimelineEntryCopyWith<$Res> {
  factory $TimelineEntry_ReadMarkerCopyWith(TimelineEntry_ReadMarker value, $Res Function(TimelineEntry_ReadMarker) _then) = _$TimelineEntry_ReadMarkerCopyWithImpl;
@override @useResult
$Res call({
 String uniqueId
});




}
/// @nodoc
class _$TimelineEntry_ReadMarkerCopyWithImpl<$Res>
    implements $TimelineEntry_ReadMarkerCopyWith<$Res> {
  _$TimelineEntry_ReadMarkerCopyWithImpl(this._self, this._then);

  final TimelineEntry_ReadMarker _self;
  final $Res Function(TimelineEntry_ReadMarker) _then;

/// Create a copy of TimelineEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uniqueId = null,}) {
  return _then(TimelineEntry_ReadMarker(
uniqueId: null == uniqueId ? _self.uniqueId : uniqueId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class TimelineEntry_TimelineStart extends TimelineEntry {
  const TimelineEntry_TimelineStart({required this.uniqueId}): super._();
  

@override final  String uniqueId;

/// Create a copy of TimelineEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimelineEntry_TimelineStartCopyWith<TimelineEntry_TimelineStart> get copyWith => _$TimelineEntry_TimelineStartCopyWithImpl<TimelineEntry_TimelineStart>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineEntry_TimelineStart&&(identical(other.uniqueId, uniqueId) || other.uniqueId == uniqueId));
}


@override
int get hashCode => Object.hash(runtimeType,uniqueId);

@override
String toString() {
  return 'TimelineEntry.timelineStart(uniqueId: $uniqueId)';
}


}

/// @nodoc
abstract mixin class $TimelineEntry_TimelineStartCopyWith<$Res> implements $TimelineEntryCopyWith<$Res> {
  factory $TimelineEntry_TimelineStartCopyWith(TimelineEntry_TimelineStart value, $Res Function(TimelineEntry_TimelineStart) _then) = _$TimelineEntry_TimelineStartCopyWithImpl;
@override @useResult
$Res call({
 String uniqueId
});




}
/// @nodoc
class _$TimelineEntry_TimelineStartCopyWithImpl<$Res>
    implements $TimelineEntry_TimelineStartCopyWith<$Res> {
  _$TimelineEntry_TimelineStartCopyWithImpl(this._self, this._then);

  final TimelineEntry_TimelineStart _self;
  final $Res Function(TimelineEntry_TimelineStart) _then;

/// Create a copy of TimelineEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uniqueId = null,}) {
  return _then(TimelineEntry_TimelineStart(
uniqueId: null == uniqueId ? _self.uniqueId : uniqueId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
