// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mobile_auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MobileAuthFailure {

 MobileAuthFailureCode get code; bool get retriable;
/// Create a copy of MobileAuthFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MobileAuthFailureCopyWith<MobileAuthFailure> get copyWith => _$MobileAuthFailureCopyWithImpl<MobileAuthFailure>(this as MobileAuthFailure, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MobileAuthFailure&&(identical(other.code, code) || other.code == code)&&(identical(other.retriable, retriable) || other.retriable == retriable));
}


@override
int get hashCode => Object.hash(runtimeType,code,retriable);

@override
String toString() {
  return 'MobileAuthFailure(code: $code, retriable: $retriable)';
}


}

/// @nodoc
abstract mixin class $MobileAuthFailureCopyWith<$Res>  {
  factory $MobileAuthFailureCopyWith(MobileAuthFailure value, $Res Function(MobileAuthFailure) _then) = _$MobileAuthFailureCopyWithImpl;
@useResult
$Res call({
 MobileAuthFailureCode code, bool retriable
});




}
/// @nodoc
class _$MobileAuthFailureCopyWithImpl<$Res>
    implements $MobileAuthFailureCopyWith<$Res> {
  _$MobileAuthFailureCopyWithImpl(this._self, this._then);

  final MobileAuthFailure _self;
  final $Res Function(MobileAuthFailure) _then;

/// Create a copy of MobileAuthFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? retriable = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as MobileAuthFailureCode,retriable: null == retriable ? _self.retriable : retriable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MobileAuthFailure].
extension MobileAuthFailurePatterns on MobileAuthFailure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MobileAuthFailure value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MobileAuthFailure() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MobileAuthFailure value)  $default,){
final _that = this;
switch (_that) {
case _MobileAuthFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MobileAuthFailure value)?  $default,){
final _that = this;
switch (_that) {
case _MobileAuthFailure() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MobileAuthFailureCode code,  bool retriable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MobileAuthFailure() when $default != null:
return $default(_that.code,_that.retriable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MobileAuthFailureCode code,  bool retriable)  $default,) {final _that = this;
switch (_that) {
case _MobileAuthFailure():
return $default(_that.code,_that.retriable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MobileAuthFailureCode code,  bool retriable)?  $default,) {final _that = this;
switch (_that) {
case _MobileAuthFailure() when $default != null:
return $default(_that.code,_that.retriable);case _:
  return null;

}
}

}

/// @nodoc


class _MobileAuthFailure implements MobileAuthFailure {
  const _MobileAuthFailure({required this.code, this.retriable = false});


@override final  MobileAuthFailureCode code;
@override@JsonKey() final  bool retriable;

/// Create a copy of MobileAuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MobileAuthFailureCopyWith<_MobileAuthFailure> get copyWith => __$MobileAuthFailureCopyWithImpl<_MobileAuthFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MobileAuthFailure&&(identical(other.code, code) || other.code == code)&&(identical(other.retriable, retriable) || other.retriable == retriable));
}


@override
int get hashCode => Object.hash(runtimeType,code,retriable);

@override
String toString() {
  return 'MobileAuthFailure(code: $code, retriable: $retriable)';
}


}

/// @nodoc
abstract mixin class _$MobileAuthFailureCopyWith<$Res> implements $MobileAuthFailureCopyWith<$Res> {
  factory _$MobileAuthFailureCopyWith(_MobileAuthFailure value, $Res Function(_MobileAuthFailure) _then) = __$MobileAuthFailureCopyWithImpl;
@override @useResult
$Res call({
 MobileAuthFailureCode code, bool retriable
});




}
/// @nodoc
class __$MobileAuthFailureCopyWithImpl<$Res>
    implements _$MobileAuthFailureCopyWith<$Res> {
  __$MobileAuthFailureCopyWithImpl(this._self, this._then);

  final _MobileAuthFailure _self;
  final $Res Function(_MobileAuthFailure) _then;

/// Create a copy of MobileAuthFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? retriable = null,}) {
  return _then(_MobileAuthFailure(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as MobileAuthFailureCode,retriable: null == retriable ? _self.retriable : retriable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$MobileAuthState {

 MobileAuthStatus get status; MobileIdentity? get identity; MobileAuthFailure? get failure;
/// Create a copy of MobileAuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MobileAuthStateCopyWith<MobileAuthState> get copyWith => _$MobileAuthStateCopyWithImpl<MobileAuthState>(this as MobileAuthState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MobileAuthState&&(identical(other.status, status) || other.status == status)&&(identical(other.identity, identity) || other.identity == identity)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,identity,failure);

@override
String toString() {
  return 'MobileAuthState(status: $status, identity: $identity, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $MobileAuthStateCopyWith<$Res>  {
  factory $MobileAuthStateCopyWith(MobileAuthState value, $Res Function(MobileAuthState) _then) = _$MobileAuthStateCopyWithImpl;
@useResult
$Res call({
 MobileAuthStatus status, MobileIdentity? identity, MobileAuthFailure? failure
});


$MobileAuthFailureCopyWith<$Res>? get failure;

}
/// @nodoc
class _$MobileAuthStateCopyWithImpl<$Res>
    implements $MobileAuthStateCopyWith<$Res> {
  _$MobileAuthStateCopyWithImpl(this._self, this._then);

  final MobileAuthState _self;
  final $Res Function(MobileAuthState) _then;

/// Create a copy of MobileAuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? identity = freezed,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MobileAuthStatus,identity: freezed == identity ? _self.identity : identity // ignore: cast_nullable_to_non_nullable
as MobileIdentity?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as MobileAuthFailure?,
  ));
}
/// Create a copy of MobileAuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MobileAuthFailureCopyWith<$Res>? get failure {
    if (_self.failure == null) {
    return null;
  }

  return $MobileAuthFailureCopyWith<$Res>(_self.failure!, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}


/// Adds pattern-matching-related methods to [MobileAuthState].
extension MobileAuthStatePatterns on MobileAuthState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MobileAuthState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MobileAuthState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MobileAuthState value)  $default,){
final _that = this;
switch (_that) {
case _MobileAuthState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MobileAuthState value)?  $default,){
final _that = this;
switch (_that) {
case _MobileAuthState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MobileAuthStatus status,  MobileIdentity? identity,  MobileAuthFailure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MobileAuthState() when $default != null:
return $default(_that.status,_that.identity,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MobileAuthStatus status,  MobileIdentity? identity,  MobileAuthFailure? failure)  $default,) {final _that = this;
switch (_that) {
case _MobileAuthState():
return $default(_that.status,_that.identity,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MobileAuthStatus status,  MobileIdentity? identity,  MobileAuthFailure? failure)?  $default,) {final _that = this;
switch (_that) {
case _MobileAuthState() when $default != null:
return $default(_that.status,_that.identity,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _MobileAuthState implements MobileAuthState {
  const _MobileAuthState({this.status = MobileAuthStatus.signedOut, this.identity, this.failure});


@override@JsonKey() final  MobileAuthStatus status;
@override final  MobileIdentity? identity;
@override final  MobileAuthFailure? failure;

/// Create a copy of MobileAuthState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MobileAuthStateCopyWith<_MobileAuthState> get copyWith => __$MobileAuthStateCopyWithImpl<_MobileAuthState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MobileAuthState&&(identical(other.status, status) || other.status == status)&&(identical(other.identity, identity) || other.identity == identity)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,identity,failure);

@override
String toString() {
  return 'MobileAuthState(status: $status, identity: $identity, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$MobileAuthStateCopyWith<$Res> implements $MobileAuthStateCopyWith<$Res> {
  factory _$MobileAuthStateCopyWith(_MobileAuthState value, $Res Function(_MobileAuthState) _then) = __$MobileAuthStateCopyWithImpl;
@override @useResult
$Res call({
 MobileAuthStatus status, MobileIdentity? identity, MobileAuthFailure? failure
});


@override $MobileAuthFailureCopyWith<$Res>? get failure;

}
/// @nodoc
class __$MobileAuthStateCopyWithImpl<$Res>
    implements _$MobileAuthStateCopyWith<$Res> {
  __$MobileAuthStateCopyWithImpl(this._self, this._then);

  final _MobileAuthState _self;
  final $Res Function(_MobileAuthState) _then;

/// Create a copy of MobileAuthState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? identity = freezed,Object? failure = freezed,}) {
  return _then(_MobileAuthState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MobileAuthStatus,identity: freezed == identity ? _self.identity : identity // ignore: cast_nullable_to_non_nullable
as MobileIdentity?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as MobileAuthFailure?,
  ));
}

/// Create a copy of MobileAuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MobileAuthFailureCopyWith<$Res>? get failure {
    if (_self.failure == null) {
    return null;
  }

  return $MobileAuthFailureCopyWith<$Res>(_self.failure!, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

// dart format on
