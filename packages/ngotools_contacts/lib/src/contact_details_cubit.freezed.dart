// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_details_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ContactDetailsState {

 ContactDetailsStatus get status; ContactRecord? get contact; ContactDataSource get source; DateTime? get cachedAt; ContactsFailureCode? get failure;
/// Create a copy of ContactDetailsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactDetailsStateCopyWith<ContactDetailsState> get copyWith => _$ContactDetailsStateCopyWithImpl<ContactDetailsState>(this as ContactDetailsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactDetailsState&&(identical(other.status, status) || other.status == status)&&(identical(other.contact, contact) || other.contact == contact)&&(identical(other.source, source) || other.source == source)&&(identical(other.cachedAt, cachedAt) || other.cachedAt == cachedAt)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,contact,source,cachedAt,failure);

@override
String toString() {
  return 'ContactDetailsState(status: $status, contact: $contact, source: $source, cachedAt: $cachedAt, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $ContactDetailsStateCopyWith<$Res>  {
  factory $ContactDetailsStateCopyWith(ContactDetailsState value, $Res Function(ContactDetailsState) _then) = _$ContactDetailsStateCopyWithImpl;
@useResult
$Res call({
 ContactDetailsStatus status, ContactRecord? contact, ContactDataSource source, DateTime? cachedAt, ContactsFailureCode? failure
});


$ContactRecordCopyWith<$Res>? get contact;

}
/// @nodoc
class _$ContactDetailsStateCopyWithImpl<$Res>
    implements $ContactDetailsStateCopyWith<$Res> {
  _$ContactDetailsStateCopyWithImpl(this._self, this._then);

  final ContactDetailsState _self;
  final $Res Function(ContactDetailsState) _then;

/// Create a copy of ContactDetailsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? contact = freezed,Object? source = null,Object? cachedAt = freezed,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ContactDetailsStatus,contact: freezed == contact ? _self.contact : contact // ignore: cast_nullable_to_non_nullable
as ContactRecord?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ContactDataSource,cachedAt: freezed == cachedAt ? _self.cachedAt : cachedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as ContactsFailureCode?,
  ));
}
/// Create a copy of ContactDetailsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContactRecordCopyWith<$Res>? get contact {
    if (_self.contact == null) {
    return null;
  }

  return $ContactRecordCopyWith<$Res>(_self.contact!, (value) {
    return _then(_self.copyWith(contact: value));
  });
}
}


/// Adds pattern-matching-related methods to [ContactDetailsState].
extension ContactDetailsStatePatterns on ContactDetailsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContactDetailsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContactDetailsState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContactDetailsState value)  $default,){
final _that = this;
switch (_that) {
case _ContactDetailsState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContactDetailsState value)?  $default,){
final _that = this;
switch (_that) {
case _ContactDetailsState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ContactDetailsStatus status,  ContactRecord? contact,  ContactDataSource source,  DateTime? cachedAt,  ContactsFailureCode? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContactDetailsState() when $default != null:
return $default(_that.status,_that.contact,_that.source,_that.cachedAt,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ContactDetailsStatus status,  ContactRecord? contact,  ContactDataSource source,  DateTime? cachedAt,  ContactsFailureCode? failure)  $default,) {final _that = this;
switch (_that) {
case _ContactDetailsState():
return $default(_that.status,_that.contact,_that.source,_that.cachedAt,_that.failure);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ContactDetailsStatus status,  ContactRecord? contact,  ContactDataSource source,  DateTime? cachedAt,  ContactsFailureCode? failure)?  $default,) {final _that = this;
switch (_that) {
case _ContactDetailsState() when $default != null:
return $default(_that.status,_that.contact,_that.source,_that.cachedAt,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _ContactDetailsState implements ContactDetailsState {
  const _ContactDetailsState({this.status = ContactDetailsStatus.initial, this.contact, this.source = ContactDataSource.remote, this.cachedAt, this.failure});


@override@JsonKey() final  ContactDetailsStatus status;
@override final  ContactRecord? contact;
@override@JsonKey() final  ContactDataSource source;
@override final  DateTime? cachedAt;
@override final  ContactsFailureCode? failure;

/// Create a copy of ContactDetailsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactDetailsStateCopyWith<_ContactDetailsState> get copyWith => __$ContactDetailsStateCopyWithImpl<_ContactDetailsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContactDetailsState&&(identical(other.status, status) || other.status == status)&&(identical(other.contact, contact) || other.contact == contact)&&(identical(other.source, source) || other.source == source)&&(identical(other.cachedAt, cachedAt) || other.cachedAt == cachedAt)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,contact,source,cachedAt,failure);

@override
String toString() {
  return 'ContactDetailsState(status: $status, contact: $contact, source: $source, cachedAt: $cachedAt, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$ContactDetailsStateCopyWith<$Res> implements $ContactDetailsStateCopyWith<$Res> {
  factory _$ContactDetailsStateCopyWith(_ContactDetailsState value, $Res Function(_ContactDetailsState) _then) = __$ContactDetailsStateCopyWithImpl;
@override @useResult
$Res call({
 ContactDetailsStatus status, ContactRecord? contact, ContactDataSource source, DateTime? cachedAt, ContactsFailureCode? failure
});


@override $ContactRecordCopyWith<$Res>? get contact;

}
/// @nodoc
class __$ContactDetailsStateCopyWithImpl<$Res>
    implements _$ContactDetailsStateCopyWith<$Res> {
  __$ContactDetailsStateCopyWithImpl(this._self, this._then);

  final _ContactDetailsState _self;
  final $Res Function(_ContactDetailsState) _then;

/// Create a copy of ContactDetailsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? contact = freezed,Object? source = null,Object? cachedAt = freezed,Object? failure = freezed,}) {
  return _then(_ContactDetailsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ContactDetailsStatus,contact: freezed == contact ? _self.contact : contact // ignore: cast_nullable_to_non_nullable
as ContactRecord?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ContactDataSource,cachedAt: freezed == cachedAt ? _self.cachedAt : cachedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as ContactsFailureCode?,
  ));
}

/// Create a copy of ContactDetailsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContactRecordCopyWith<$Res>? get contact {
    if (_self.contact == null) {
    return null;
  }

  return $ContactRecordCopyWith<$Res>(_self.contact!, (value) {
    return _then(_self.copyWith(contact: value));
  });
}
}

// dart format on
