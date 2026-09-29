// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatError {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatError()';
}


}

/// @nodoc
class $ChatErrorCopyWith<$Res>  {
$ChatErrorCopyWith(ChatError _, $Res Function(ChatError) __);
}


/// Adds pattern-matching-related methods to [ChatError].
extension ChatErrorPatterns on ChatError {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ChatError_Network value)?  network,TResult Function( ChatError_SessionExpired value)?  sessionExpired,TResult Function( ChatError_AccountLocked value)?  accountLocked,TResult Function( ChatError_Forbidden value)?  forbidden,TResult Function( ChatError_NotFound value)?  notFound,TResult Function( ChatError_RateLimited value)?  rateLimited,TResult Function( ChatError_Crypto value)?  crypto,TResult Function( ChatError_Storage value)?  storage,TResult Function( ChatError_InvalidInput value)?  invalidInput,TResult Function( ChatError_Internal value)?  internal,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ChatError_Network() when network != null:
return network(_that);case ChatError_SessionExpired() when sessionExpired != null:
return sessionExpired(_that);case ChatError_AccountLocked() when accountLocked != null:
return accountLocked(_that);case ChatError_Forbidden() when forbidden != null:
return forbidden(_that);case ChatError_NotFound() when notFound != null:
return notFound(_that);case ChatError_RateLimited() when rateLimited != null:
return rateLimited(_that);case ChatError_Crypto() when crypto != null:
return crypto(_that);case ChatError_Storage() when storage != null:
return storage(_that);case ChatError_InvalidInput() when invalidInput != null:
return invalidInput(_that);case ChatError_Internal() when internal != null:
return internal(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ChatError_Network value)  network,required TResult Function( ChatError_SessionExpired value)  sessionExpired,required TResult Function( ChatError_AccountLocked value)  accountLocked,required TResult Function( ChatError_Forbidden value)  forbidden,required TResult Function( ChatError_NotFound value)  notFound,required TResult Function( ChatError_RateLimited value)  rateLimited,required TResult Function( ChatError_Crypto value)  crypto,required TResult Function( ChatError_Storage value)  storage,required TResult Function( ChatError_InvalidInput value)  invalidInput,required TResult Function( ChatError_Internal value)  internal,}){
final _that = this;
switch (_that) {
case ChatError_Network():
return network(_that);case ChatError_SessionExpired():
return sessionExpired(_that);case ChatError_AccountLocked():
return accountLocked(_that);case ChatError_Forbidden():
return forbidden(_that);case ChatError_NotFound():
return notFound(_that);case ChatError_RateLimited():
return rateLimited(_that);case ChatError_Crypto():
return crypto(_that);case ChatError_Storage():
return storage(_that);case ChatError_InvalidInput():
return invalidInput(_that);case ChatError_Internal():
return internal(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ChatError_Network value)?  network,TResult? Function( ChatError_SessionExpired value)?  sessionExpired,TResult? Function( ChatError_AccountLocked value)?  accountLocked,TResult? Function( ChatError_Forbidden value)?  forbidden,TResult? Function( ChatError_NotFound value)?  notFound,TResult? Function( ChatError_RateLimited value)?  rateLimited,TResult? Function( ChatError_Crypto value)?  crypto,TResult? Function( ChatError_Storage value)?  storage,TResult? Function( ChatError_InvalidInput value)?  invalidInput,TResult? Function( ChatError_Internal value)?  internal,}){
final _that = this;
switch (_that) {
case ChatError_Network() when network != null:
return network(_that);case ChatError_SessionExpired() when sessionExpired != null:
return sessionExpired(_that);case ChatError_AccountLocked() when accountLocked != null:
return accountLocked(_that);case ChatError_Forbidden() when forbidden != null:
return forbidden(_that);case ChatError_NotFound() when notFound != null:
return notFound(_that);case ChatError_RateLimited() when rateLimited != null:
return rateLimited(_that);case ChatError_Crypto() when crypto != null:
return crypto(_that);case ChatError_Storage() when storage != null:
return storage(_that);case ChatError_InvalidInput() when invalidInput != null:
return invalidInput(_that);case ChatError_Internal() when internal != null:
return internal(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  network,TResult Function()?  sessionExpired,TResult Function()?  accountLocked,TResult Function()?  forbidden,TResult Function()?  notFound,TResult Function( BigInt? retryAfterMs)?  rateLimited,TResult Function( String message)?  crypto,TResult Function( String message)?  storage,TResult Function( String message)?  invalidInput,TResult Function( String message)?  internal,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ChatError_Network() when network != null:
return network();case ChatError_SessionExpired() when sessionExpired != null:
return sessionExpired();case ChatError_AccountLocked() when accountLocked != null:
return accountLocked();case ChatError_Forbidden() when forbidden != null:
return forbidden();case ChatError_NotFound() when notFound != null:
return notFound();case ChatError_RateLimited() when rateLimited != null:
return rateLimited(_that.retryAfterMs);case ChatError_Crypto() when crypto != null:
return crypto(_that.message);case ChatError_Storage() when storage != null:
return storage(_that.message);case ChatError_InvalidInput() when invalidInput != null:
return invalidInput(_that.message);case ChatError_Internal() when internal != null:
return internal(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  network,required TResult Function()  sessionExpired,required TResult Function()  accountLocked,required TResult Function()  forbidden,required TResult Function()  notFound,required TResult Function( BigInt? retryAfterMs)  rateLimited,required TResult Function( String message)  crypto,required TResult Function( String message)  storage,required TResult Function( String message)  invalidInput,required TResult Function( String message)  internal,}) {final _that = this;
switch (_that) {
case ChatError_Network():
return network();case ChatError_SessionExpired():
return sessionExpired();case ChatError_AccountLocked():
return accountLocked();case ChatError_Forbidden():
return forbidden();case ChatError_NotFound():
return notFound();case ChatError_RateLimited():
return rateLimited(_that.retryAfterMs);case ChatError_Crypto():
return crypto(_that.message);case ChatError_Storage():
return storage(_that.message);case ChatError_InvalidInput():
return invalidInput(_that.message);case ChatError_Internal():
return internal(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  network,TResult? Function()?  sessionExpired,TResult? Function()?  accountLocked,TResult? Function()?  forbidden,TResult? Function()?  notFound,TResult? Function( BigInt? retryAfterMs)?  rateLimited,TResult? Function( String message)?  crypto,TResult? Function( String message)?  storage,TResult? Function( String message)?  invalidInput,TResult? Function( String message)?  internal,}) {final _that = this;
switch (_that) {
case ChatError_Network() when network != null:
return network();case ChatError_SessionExpired() when sessionExpired != null:
return sessionExpired();case ChatError_AccountLocked() when accountLocked != null:
return accountLocked();case ChatError_Forbidden() when forbidden != null:
return forbidden();case ChatError_NotFound() when notFound != null:
return notFound();case ChatError_RateLimited() when rateLimited != null:
return rateLimited(_that.retryAfterMs);case ChatError_Crypto() when crypto != null:
return crypto(_that.message);case ChatError_Storage() when storage != null:
return storage(_that.message);case ChatError_InvalidInput() when invalidInput != null:
return invalidInput(_that.message);case ChatError_Internal() when internal != null:
return internal(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class ChatError_Network extends ChatError {
  const ChatError_Network(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatError_Network);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatError.network()';
}


}




/// @nodoc


class ChatError_SessionExpired extends ChatError {
  const ChatError_SessionExpired(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatError_SessionExpired);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatError.sessionExpired()';
}


}




/// @nodoc


class ChatError_AccountLocked extends ChatError {
  const ChatError_AccountLocked(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatError_AccountLocked);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatError.accountLocked()';
}


}




/// @nodoc


class ChatError_Forbidden extends ChatError {
  const ChatError_Forbidden(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatError_Forbidden);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatError.forbidden()';
}


}




/// @nodoc


class ChatError_NotFound extends ChatError {
  const ChatError_NotFound(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatError_NotFound);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatError.notFound()';
}


}




/// @nodoc


class ChatError_RateLimited extends ChatError {
  const ChatError_RateLimited({this.retryAfterMs}): super._();
  

 final  BigInt? retryAfterMs;

/// Create a copy of ChatError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatError_RateLimitedCopyWith<ChatError_RateLimited> get copyWith => _$ChatError_RateLimitedCopyWithImpl<ChatError_RateLimited>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatError_RateLimited&&(identical(other.retryAfterMs, retryAfterMs) || other.retryAfterMs == retryAfterMs));
}


@override
int get hashCode => Object.hash(runtimeType,retryAfterMs);

@override
String toString() {
  return 'ChatError.rateLimited(retryAfterMs: $retryAfterMs)';
}


}

/// @nodoc
abstract mixin class $ChatError_RateLimitedCopyWith<$Res> implements $ChatErrorCopyWith<$Res> {
  factory $ChatError_RateLimitedCopyWith(ChatError_RateLimited value, $Res Function(ChatError_RateLimited) _then) = _$ChatError_RateLimitedCopyWithImpl;
@useResult
$Res call({
 BigInt? retryAfterMs
});




}
/// @nodoc
class _$ChatError_RateLimitedCopyWithImpl<$Res>
    implements $ChatError_RateLimitedCopyWith<$Res> {
  _$ChatError_RateLimitedCopyWithImpl(this._self, this._then);

  final ChatError_RateLimited _self;
  final $Res Function(ChatError_RateLimited) _then;

/// Create a copy of ChatError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? retryAfterMs = freezed,}) {
  return _then(ChatError_RateLimited(
retryAfterMs: freezed == retryAfterMs ? _self.retryAfterMs : retryAfterMs // ignore: cast_nullable_to_non_nullable
as BigInt?,
  ));
}


}

/// @nodoc


class ChatError_Crypto extends ChatError {
  const ChatError_Crypto({required this.message}): super._();
  

 final  String message;

/// Create a copy of ChatError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatError_CryptoCopyWith<ChatError_Crypto> get copyWith => _$ChatError_CryptoCopyWithImpl<ChatError_Crypto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatError_Crypto&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ChatError.crypto(message: $message)';
}


}

/// @nodoc
abstract mixin class $ChatError_CryptoCopyWith<$Res> implements $ChatErrorCopyWith<$Res> {
  factory $ChatError_CryptoCopyWith(ChatError_Crypto value, $Res Function(ChatError_Crypto) _then) = _$ChatError_CryptoCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ChatError_CryptoCopyWithImpl<$Res>
    implements $ChatError_CryptoCopyWith<$Res> {
  _$ChatError_CryptoCopyWithImpl(this._self, this._then);

  final ChatError_Crypto _self;
  final $Res Function(ChatError_Crypto) _then;

/// Create a copy of ChatError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ChatError_Crypto(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ChatError_Storage extends ChatError {
  const ChatError_Storage({required this.message}): super._();
  

 final  String message;

/// Create a copy of ChatError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatError_StorageCopyWith<ChatError_Storage> get copyWith => _$ChatError_StorageCopyWithImpl<ChatError_Storage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatError_Storage&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ChatError.storage(message: $message)';
}


}

/// @nodoc
abstract mixin class $ChatError_StorageCopyWith<$Res> implements $ChatErrorCopyWith<$Res> {
  factory $ChatError_StorageCopyWith(ChatError_Storage value, $Res Function(ChatError_Storage) _then) = _$ChatError_StorageCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ChatError_StorageCopyWithImpl<$Res>
    implements $ChatError_StorageCopyWith<$Res> {
  _$ChatError_StorageCopyWithImpl(this._self, this._then);

  final ChatError_Storage _self;
  final $Res Function(ChatError_Storage) _then;

/// Create a copy of ChatError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ChatError_Storage(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ChatError_InvalidInput extends ChatError {
  const ChatError_InvalidInput({required this.message}): super._();
  

 final  String message;

/// Create a copy of ChatError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatError_InvalidInputCopyWith<ChatError_InvalidInput> get copyWith => _$ChatError_InvalidInputCopyWithImpl<ChatError_InvalidInput>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatError_InvalidInput&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ChatError.invalidInput(message: $message)';
}


}

/// @nodoc
abstract mixin class $ChatError_InvalidInputCopyWith<$Res> implements $ChatErrorCopyWith<$Res> {
  factory $ChatError_InvalidInputCopyWith(ChatError_InvalidInput value, $Res Function(ChatError_InvalidInput) _then) = _$ChatError_InvalidInputCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ChatError_InvalidInputCopyWithImpl<$Res>
    implements $ChatError_InvalidInputCopyWith<$Res> {
  _$ChatError_InvalidInputCopyWithImpl(this._self, this._then);

  final ChatError_InvalidInput _self;
  final $Res Function(ChatError_InvalidInput) _then;

/// Create a copy of ChatError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ChatError_InvalidInput(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ChatError_Internal extends ChatError {
  const ChatError_Internal({required this.message}): super._();
  

 final  String message;

/// Create a copy of ChatError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatError_InternalCopyWith<ChatError_Internal> get copyWith => _$ChatError_InternalCopyWithImpl<ChatError_Internal>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatError_Internal&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ChatError.internal(message: $message)';
}


}

/// @nodoc
abstract mixin class $ChatError_InternalCopyWith<$Res> implements $ChatErrorCopyWith<$Res> {
  factory $ChatError_InternalCopyWith(ChatError_Internal value, $Res Function(ChatError_Internal) _then) = _$ChatError_InternalCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ChatError_InternalCopyWithImpl<$Res>
    implements $ChatError_InternalCopyWith<$Res> {
  _$ChatError_InternalCopyWithImpl(this._self, this._then);

  final ChatError_Internal _self;
  final $Res Function(ChatError_Internal) _then;

/// Create a copy of ChatError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ChatError_Internal(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
