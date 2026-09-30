// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EncryptionStatus {

 RecoveryStatus get recovery; bool get deviceVerified;
/// Create a copy of EncryptionStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EncryptionStatusCopyWith<EncryptionStatus> get copyWith => _$EncryptionStatusCopyWithImpl<EncryptionStatus>(this as EncryptionStatus, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EncryptionStatus&&(identical(other.recovery, recovery) || other.recovery == recovery)&&(identical(other.deviceVerified, deviceVerified) || other.deviceVerified == deviceVerified));
}


@override
int get hashCode => Object.hash(runtimeType,recovery,deviceVerified);

@override
String toString() {
  return 'EncryptionStatus(recovery: $recovery, deviceVerified: $deviceVerified)';
}


}

/// @nodoc
abstract mixin class $EncryptionStatusCopyWith<$Res>  {
  factory $EncryptionStatusCopyWith(EncryptionStatus value, $Res Function(EncryptionStatus) _then) = _$EncryptionStatusCopyWithImpl;
@useResult
$Res call({
 RecoveryStatus recovery, bool deviceVerified
});




}
/// @nodoc
class _$EncryptionStatusCopyWithImpl<$Res>
    implements $EncryptionStatusCopyWith<$Res> {
  _$EncryptionStatusCopyWithImpl(this._self, this._then);

  final EncryptionStatus _self;
  final $Res Function(EncryptionStatus) _then;

/// Create a copy of EncryptionStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? recovery = null,Object? deviceVerified = null,}) {
  return _then(_self.copyWith(
recovery: null == recovery ? _self.recovery : recovery // ignore: cast_nullable_to_non_nullable
as RecoveryStatus,deviceVerified: null == deviceVerified ? _self.deviceVerified : deviceVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [EncryptionStatus].
extension EncryptionStatusPatterns on EncryptionStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EncryptionStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EncryptionStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EncryptionStatus value)  $default,){
final _that = this;
switch (_that) {
case _EncryptionStatus():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EncryptionStatus value)?  $default,){
final _that = this;
switch (_that) {
case _EncryptionStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RecoveryStatus recovery,  bool deviceVerified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EncryptionStatus() when $default != null:
return $default(_that.recovery,_that.deviceVerified);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RecoveryStatus recovery,  bool deviceVerified)  $default,) {final _that = this;
switch (_that) {
case _EncryptionStatus():
return $default(_that.recovery,_that.deviceVerified);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RecoveryStatus recovery,  bool deviceVerified)?  $default,) {final _that = this;
switch (_that) {
case _EncryptionStatus() when $default != null:
return $default(_that.recovery,_that.deviceVerified);case _:
  return null;

}
}

}

/// @nodoc


class _EncryptionStatus implements EncryptionStatus {
  const _EncryptionStatus({required this.recovery, required this.deviceVerified});
  

@override final  RecoveryStatus recovery;
@override final  bool deviceVerified;

/// Create a copy of EncryptionStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EncryptionStatusCopyWith<_EncryptionStatus> get copyWith => __$EncryptionStatusCopyWithImpl<_EncryptionStatus>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EncryptionStatus&&(identical(other.recovery, recovery) || other.recovery == recovery)&&(identical(other.deviceVerified, deviceVerified) || other.deviceVerified == deviceVerified));
}


@override
int get hashCode => Object.hash(runtimeType,recovery,deviceVerified);

@override
String toString() {
  return 'EncryptionStatus(recovery: $recovery, deviceVerified: $deviceVerified)';
}


}

/// @nodoc
abstract mixin class _$EncryptionStatusCopyWith<$Res> implements $EncryptionStatusCopyWith<$Res> {
  factory _$EncryptionStatusCopyWith(_EncryptionStatus value, $Res Function(_EncryptionStatus) _then) = __$EncryptionStatusCopyWithImpl;
@override @useResult
$Res call({
 RecoveryStatus recovery, bool deviceVerified
});




}
/// @nodoc
class __$EncryptionStatusCopyWithImpl<$Res>
    implements _$EncryptionStatusCopyWith<$Res> {
  __$EncryptionStatusCopyWithImpl(this._self, this._then);

  final _EncryptionStatus _self;
  final $Res Function(_EncryptionStatus) _then;

/// Create a copy of EncryptionStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? recovery = null,Object? deviceVerified = null,}) {
  return _then(_EncryptionStatus(
recovery: null == recovery ? _self.recovery : recovery // ignore: cast_nullable_to_non_nullable
as RecoveryStatus,deviceVerified: null == deviceVerified ? _self.deviceVerified : deviceVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$ChatAccount {

 String get userId; String get deviceId;
/// Create a copy of ChatAccount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatAccountCopyWith<ChatAccount> get copyWith => _$ChatAccountCopyWithImpl<ChatAccount>(this as ChatAccount, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatAccount&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId));
}


@override
int get hashCode => Object.hash(runtimeType,userId,deviceId);

@override
String toString() {
  return 'ChatAccount(userId: $userId, deviceId: $deviceId)';
}


}

/// @nodoc
abstract mixin class $ChatAccountCopyWith<$Res>  {
  factory $ChatAccountCopyWith(ChatAccount value, $Res Function(ChatAccount) _then) = _$ChatAccountCopyWithImpl;
@useResult
$Res call({
 String userId, String deviceId
});




}
/// @nodoc
class _$ChatAccountCopyWithImpl<$Res>
    implements $ChatAccountCopyWith<$Res> {
  _$ChatAccountCopyWithImpl(this._self, this._then);

  final ChatAccount _self;
  final $Res Function(ChatAccount) _then;

/// Create a copy of ChatAccount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? deviceId = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatAccount].
extension ChatAccountPatterns on ChatAccount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatAccount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatAccount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatAccount value)  $default,){
final _that = this;
switch (_that) {
case _ChatAccount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatAccount value)?  $default,){
final _that = this;
switch (_that) {
case _ChatAccount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String deviceId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatAccount() when $default != null:
return $default(_that.userId,_that.deviceId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String deviceId)  $default,) {final _that = this;
switch (_that) {
case _ChatAccount():
return $default(_that.userId,_that.deviceId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String deviceId)?  $default,) {final _that = this;
switch (_that) {
case _ChatAccount() when $default != null:
return $default(_that.userId,_that.deviceId);case _:
  return null;

}
}

}

/// @nodoc


class _ChatAccount implements ChatAccount {
  const _ChatAccount({required this.userId, required this.deviceId});
  

@override final  String userId;
@override final  String deviceId;

/// Create a copy of ChatAccount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatAccountCopyWith<_ChatAccount> get copyWith => __$ChatAccountCopyWithImpl<_ChatAccount>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatAccount&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId));
}


@override
int get hashCode => Object.hash(runtimeType,userId,deviceId);

@override
String toString() {
  return 'ChatAccount(userId: $userId, deviceId: $deviceId)';
}


}

/// @nodoc
abstract mixin class _$ChatAccountCopyWith<$Res> implements $ChatAccountCopyWith<$Res> {
  factory _$ChatAccountCopyWith(_ChatAccount value, $Res Function(_ChatAccount) _then) = __$ChatAccountCopyWithImpl;
@override @useResult
$Res call({
 String userId, String deviceId
});




}
/// @nodoc
class __$ChatAccountCopyWithImpl<$Res>
    implements _$ChatAccountCopyWith<$Res> {
  __$ChatAccountCopyWithImpl(this._self, this._then);

  final _ChatAccount _self;
  final $Res Function(_ChatAccount) _then;

/// Create a copy of ChatAccount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? deviceId = null,}) {
  return _then(_ChatAccount(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ChatUser {

 String get id; String? get displayName; ChatMedia? get avatar;
/// Create a copy of ChatUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatUserCopyWith<ChatUser> get copyWith => _$ChatUserCopyWithImpl<ChatUser>(this as ChatUser, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatUser&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatar, avatar) || other.avatar == avatar));
}


@override
int get hashCode => Object.hash(runtimeType,id,displayName,avatar);

@override
String toString() {
  return 'ChatUser(id: $id, displayName: $displayName, avatar: $avatar)';
}


}

/// @nodoc
abstract mixin class $ChatUserCopyWith<$Res>  {
  factory $ChatUserCopyWith(ChatUser value, $Res Function(ChatUser) _then) = _$ChatUserCopyWithImpl;
@useResult
$Res call({
 String id, String? displayName, ChatMedia? avatar
});




}
/// @nodoc
class _$ChatUserCopyWithImpl<$Res>
    implements $ChatUserCopyWith<$Res> {
  _$ChatUserCopyWithImpl(this._self, this._then);

  final ChatUser _self;
  final $Res Function(ChatUser) _then;

/// Create a copy of ChatUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? displayName = freezed,Object? avatar = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as ChatMedia?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatUser].
extension ChatUserPatterns on ChatUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatUser value)  $default,){
final _that = this;
switch (_that) {
case _ChatUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatUser value)?  $default,){
final _that = this;
switch (_that) {
case _ChatUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? displayName,  ChatMedia? avatar)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatUser() when $default != null:
return $default(_that.id,_that.displayName,_that.avatar);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? displayName,  ChatMedia? avatar)  $default,) {final _that = this;
switch (_that) {
case _ChatUser():
return $default(_that.id,_that.displayName,_that.avatar);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? displayName,  ChatMedia? avatar)?  $default,) {final _that = this;
switch (_that) {
case _ChatUser() when $default != null:
return $default(_that.id,_that.displayName,_that.avatar);case _:
  return null;

}
}

}

/// @nodoc


class _ChatUser implements ChatUser {
  const _ChatUser({required this.id, this.displayName, this.avatar});
  

@override final  String id;
@override final  String? displayName;
@override final  ChatMedia? avatar;

/// Create a copy of ChatUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatUserCopyWith<_ChatUser> get copyWith => __$ChatUserCopyWithImpl<_ChatUser>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatUser&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatar, avatar) || other.avatar == avatar));
}


@override
int get hashCode => Object.hash(runtimeType,id,displayName,avatar);

@override
String toString() {
  return 'ChatUser(id: $id, displayName: $displayName, avatar: $avatar)';
}


}

/// @nodoc
abstract mixin class _$ChatUserCopyWith<$Res> implements $ChatUserCopyWith<$Res> {
  factory _$ChatUserCopyWith(_ChatUser value, $Res Function(_ChatUser) _then) = __$ChatUserCopyWithImpl;
@override @useResult
$Res call({
 String id, String? displayName, ChatMedia? avatar
});




}
/// @nodoc
class __$ChatUserCopyWithImpl<$Res>
    implements _$ChatUserCopyWith<$Res> {
  __$ChatUserCopyWithImpl(this._self, this._then);

  final _ChatUser _self;
  final $Res Function(_ChatUser) _then;

/// Create a copy of ChatUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayName = freezed,Object? avatar = freezed,}) {
  return _then(_ChatUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as ChatMedia?,
  ));
}


}

/// @nodoc
mixin _$MessagePreview {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessagePreview);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessagePreview()';
}


}

/// @nodoc
class $MessagePreviewCopyWith<$Res>  {
$MessagePreviewCopyWith(MessagePreview _, $Res Function(MessagePreview) __);
}


/// Adds pattern-matching-related methods to [MessagePreview].
extension MessagePreviewPatterns on MessagePreview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TextPreview value)?  text,TResult Function( ImagePreview value)?  image,TResult Function( VideoPreview value)?  video,TResult Function( AudioPreview value)?  audio,TResult Function( FilePreview value)?  file,TResult Function( LocationPreview value)?  location,TResult Function( PollPreview value)?  poll,TResult Function( StickerPreview value)?  sticker,TResult Function( RedactedPreview value)?  redacted,TResult Function( UnableToDecryptPreview value)?  unableToDecrypt,TResult Function( OtherPreview value)?  other,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TextPreview() when text != null:
return text(_that);case ImagePreview() when image != null:
return image(_that);case VideoPreview() when video != null:
return video(_that);case AudioPreview() when audio != null:
return audio(_that);case FilePreview() when file != null:
return file(_that);case LocationPreview() when location != null:
return location(_that);case PollPreview() when poll != null:
return poll(_that);case StickerPreview() when sticker != null:
return sticker(_that);case RedactedPreview() when redacted != null:
return redacted(_that);case UnableToDecryptPreview() when unableToDecrypt != null:
return unableToDecrypt(_that);case OtherPreview() when other != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TextPreview value)  text,required TResult Function( ImagePreview value)  image,required TResult Function( VideoPreview value)  video,required TResult Function( AudioPreview value)  audio,required TResult Function( FilePreview value)  file,required TResult Function( LocationPreview value)  location,required TResult Function( PollPreview value)  poll,required TResult Function( StickerPreview value)  sticker,required TResult Function( RedactedPreview value)  redacted,required TResult Function( UnableToDecryptPreview value)  unableToDecrypt,required TResult Function( OtherPreview value)  other,}){
final _that = this;
switch (_that) {
case TextPreview():
return text(_that);case ImagePreview():
return image(_that);case VideoPreview():
return video(_that);case AudioPreview():
return audio(_that);case FilePreview():
return file(_that);case LocationPreview():
return location(_that);case PollPreview():
return poll(_that);case StickerPreview():
return sticker(_that);case RedactedPreview():
return redacted(_that);case UnableToDecryptPreview():
return unableToDecrypt(_that);case OtherPreview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TextPreview value)?  text,TResult? Function( ImagePreview value)?  image,TResult? Function( VideoPreview value)?  video,TResult? Function( AudioPreview value)?  audio,TResult? Function( FilePreview value)?  file,TResult? Function( LocationPreview value)?  location,TResult? Function( PollPreview value)?  poll,TResult? Function( StickerPreview value)?  sticker,TResult? Function( RedactedPreview value)?  redacted,TResult? Function( UnableToDecryptPreview value)?  unableToDecrypt,TResult? Function( OtherPreview value)?  other,}){
final _that = this;
switch (_that) {
case TextPreview() when text != null:
return text(_that);case ImagePreview() when image != null:
return image(_that);case VideoPreview() when video != null:
return video(_that);case AudioPreview() when audio != null:
return audio(_that);case FilePreview() when file != null:
return file(_that);case LocationPreview() when location != null:
return location(_that);case PollPreview() when poll != null:
return poll(_that);case StickerPreview() when sticker != null:
return sticker(_that);case RedactedPreview() when redacted != null:
return redacted(_that);case UnableToDecryptPreview() when unableToDecrypt != null:
return unableToDecrypt(_that);case OtherPreview() when other != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String body)?  text,TResult Function()?  image,TResult Function()?  video,TResult Function()?  audio,TResult Function()?  file,TResult Function()?  location,TResult Function()?  poll,TResult Function()?  sticker,TResult Function()?  redacted,TResult Function()?  unableToDecrypt,TResult Function()?  other,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TextPreview() when text != null:
return text(_that.body);case ImagePreview() when image != null:
return image();case VideoPreview() when video != null:
return video();case AudioPreview() when audio != null:
return audio();case FilePreview() when file != null:
return file();case LocationPreview() when location != null:
return location();case PollPreview() when poll != null:
return poll();case StickerPreview() when sticker != null:
return sticker();case RedactedPreview() when redacted != null:
return redacted();case UnableToDecryptPreview() when unableToDecrypt != null:
return unableToDecrypt();case OtherPreview() when other != null:
return other();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String body)  text,required TResult Function()  image,required TResult Function()  video,required TResult Function()  audio,required TResult Function()  file,required TResult Function()  location,required TResult Function()  poll,required TResult Function()  sticker,required TResult Function()  redacted,required TResult Function()  unableToDecrypt,required TResult Function()  other,}) {final _that = this;
switch (_that) {
case TextPreview():
return text(_that.body);case ImagePreview():
return image();case VideoPreview():
return video();case AudioPreview():
return audio();case FilePreview():
return file();case LocationPreview():
return location();case PollPreview():
return poll();case StickerPreview():
return sticker();case RedactedPreview():
return redacted();case UnableToDecryptPreview():
return unableToDecrypt();case OtherPreview():
return other();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String body)?  text,TResult? Function()?  image,TResult? Function()?  video,TResult? Function()?  audio,TResult? Function()?  file,TResult? Function()?  location,TResult? Function()?  poll,TResult? Function()?  sticker,TResult? Function()?  redacted,TResult? Function()?  unableToDecrypt,TResult? Function()?  other,}) {final _that = this;
switch (_that) {
case TextPreview() when text != null:
return text(_that.body);case ImagePreview() when image != null:
return image();case VideoPreview() when video != null:
return video();case AudioPreview() when audio != null:
return audio();case FilePreview() when file != null:
return file();case LocationPreview() when location != null:
return location();case PollPreview() when poll != null:
return poll();case StickerPreview() when sticker != null:
return sticker();case RedactedPreview() when redacted != null:
return redacted();case UnableToDecryptPreview() when unableToDecrypt != null:
return unableToDecrypt();case OtherPreview() when other != null:
return other();case _:
  return null;

}
}

}

/// @nodoc


class TextPreview implements MessagePreview {
  const TextPreview(this.body);
  

 final  String body;

/// Create a copy of MessagePreview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TextPreviewCopyWith<TextPreview> get copyWith => _$TextPreviewCopyWithImpl<TextPreview>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TextPreview&&(identical(other.body, body) || other.body == body));
}


@override
int get hashCode => Object.hash(runtimeType,body);

@override
String toString() {
  return 'MessagePreview.text(body: $body)';
}


}

/// @nodoc
abstract mixin class $TextPreviewCopyWith<$Res> implements $MessagePreviewCopyWith<$Res> {
  factory $TextPreviewCopyWith(TextPreview value, $Res Function(TextPreview) _then) = _$TextPreviewCopyWithImpl;
@useResult
$Res call({
 String body
});




}
/// @nodoc
class _$TextPreviewCopyWithImpl<$Res>
    implements $TextPreviewCopyWith<$Res> {
  _$TextPreviewCopyWithImpl(this._self, this._then);

  final TextPreview _self;
  final $Res Function(TextPreview) _then;

/// Create a copy of MessagePreview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? body = null,}) {
  return _then(TextPreview(
null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ImagePreview implements MessagePreview {
  const ImagePreview();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImagePreview);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessagePreview.image()';
}


}




/// @nodoc


class VideoPreview implements MessagePreview {
  const VideoPreview();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoPreview);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessagePreview.video()';
}


}




/// @nodoc


class AudioPreview implements MessagePreview {
  const AudioPreview();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AudioPreview);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessagePreview.audio()';
}


}




/// @nodoc


class FilePreview implements MessagePreview {
  const FilePreview();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FilePreview);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessagePreview.file()';
}


}




/// @nodoc


class LocationPreview implements MessagePreview {
  const LocationPreview();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocationPreview);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessagePreview.location()';
}


}




/// @nodoc


class PollPreview implements MessagePreview {
  const PollPreview();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PollPreview);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessagePreview.poll()';
}


}




/// @nodoc


class StickerPreview implements MessagePreview {
  const StickerPreview();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StickerPreview);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessagePreview.sticker()';
}


}




/// @nodoc


class RedactedPreview implements MessagePreview {
  const RedactedPreview();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RedactedPreview);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessagePreview.redacted()';
}


}




/// @nodoc


class UnableToDecryptPreview implements MessagePreview {
  const UnableToDecryptPreview();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnableToDecryptPreview);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessagePreview.unableToDecrypt()';
}


}




/// @nodoc


class OtherPreview implements MessagePreview {
  const OtherPreview();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtherPreview);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessagePreview.other()';
}


}




/// @nodoc
mixin _$LatestEvent {

 ChatUser get sender; bool get isOwn; DateTime get timestamp; MessagePreview get preview;/// Still being sent or failed to send.
 bool get isUnsent;
/// Create a copy of LatestEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LatestEventCopyWith<LatestEvent> get copyWith => _$LatestEventCopyWithImpl<LatestEvent>(this as LatestEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LatestEvent&&(identical(other.sender, sender) || other.sender == sender)&&(identical(other.isOwn, isOwn) || other.isOwn == isOwn)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.preview, preview) || other.preview == preview)&&(identical(other.isUnsent, isUnsent) || other.isUnsent == isUnsent));
}


@override
int get hashCode => Object.hash(runtimeType,sender,isOwn,timestamp,preview,isUnsent);

@override
String toString() {
  return 'LatestEvent(sender: $sender, isOwn: $isOwn, timestamp: $timestamp, preview: $preview, isUnsent: $isUnsent)';
}


}

/// @nodoc
abstract mixin class $LatestEventCopyWith<$Res>  {
  factory $LatestEventCopyWith(LatestEvent value, $Res Function(LatestEvent) _then) = _$LatestEventCopyWithImpl;
@useResult
$Res call({
 ChatUser sender, bool isOwn, DateTime timestamp, MessagePreview preview, bool isUnsent
});


$ChatUserCopyWith<$Res> get sender;$MessagePreviewCopyWith<$Res> get preview;

}
/// @nodoc
class _$LatestEventCopyWithImpl<$Res>
    implements $LatestEventCopyWith<$Res> {
  _$LatestEventCopyWithImpl(this._self, this._then);

  final LatestEvent _self;
  final $Res Function(LatestEvent) _then;

/// Create a copy of LatestEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sender = null,Object? isOwn = null,Object? timestamp = null,Object? preview = null,Object? isUnsent = null,}) {
  return _then(_self.copyWith(
sender: null == sender ? _self.sender : sender // ignore: cast_nullable_to_non_nullable
as ChatUser,isOwn: null == isOwn ? _self.isOwn : isOwn // ignore: cast_nullable_to_non_nullable
as bool,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,preview: null == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as MessagePreview,isUnsent: null == isUnsent ? _self.isUnsent : isUnsent // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of LatestEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatUserCopyWith<$Res> get sender {
  
  return $ChatUserCopyWith<$Res>(_self.sender, (value) {
    return _then(_self.copyWith(sender: value));
  });
}/// Create a copy of LatestEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MessagePreviewCopyWith<$Res> get preview {
  
  return $MessagePreviewCopyWith<$Res>(_self.preview, (value) {
    return _then(_self.copyWith(preview: value));
  });
}
}


/// Adds pattern-matching-related methods to [LatestEvent].
extension LatestEventPatterns on LatestEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LatestEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LatestEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LatestEvent value)  $default,){
final _that = this;
switch (_that) {
case _LatestEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LatestEvent value)?  $default,){
final _that = this;
switch (_that) {
case _LatestEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ChatUser sender,  bool isOwn,  DateTime timestamp,  MessagePreview preview,  bool isUnsent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LatestEvent() when $default != null:
return $default(_that.sender,_that.isOwn,_that.timestamp,_that.preview,_that.isUnsent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ChatUser sender,  bool isOwn,  DateTime timestamp,  MessagePreview preview,  bool isUnsent)  $default,) {final _that = this;
switch (_that) {
case _LatestEvent():
return $default(_that.sender,_that.isOwn,_that.timestamp,_that.preview,_that.isUnsent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ChatUser sender,  bool isOwn,  DateTime timestamp,  MessagePreview preview,  bool isUnsent)?  $default,) {final _that = this;
switch (_that) {
case _LatestEvent() when $default != null:
return $default(_that.sender,_that.isOwn,_that.timestamp,_that.preview,_that.isUnsent);case _:
  return null;

}
}

}

/// @nodoc


class _LatestEvent implements LatestEvent {
  const _LatestEvent({required this.sender, required this.isOwn, required this.timestamp, required this.preview, required this.isUnsent});
  

@override final  ChatUser sender;
@override final  bool isOwn;
@override final  DateTime timestamp;
@override final  MessagePreview preview;
/// Still being sent or failed to send.
@override final  bool isUnsent;

/// Create a copy of LatestEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LatestEventCopyWith<_LatestEvent> get copyWith => __$LatestEventCopyWithImpl<_LatestEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LatestEvent&&(identical(other.sender, sender) || other.sender == sender)&&(identical(other.isOwn, isOwn) || other.isOwn == isOwn)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.preview, preview) || other.preview == preview)&&(identical(other.isUnsent, isUnsent) || other.isUnsent == isUnsent));
}


@override
int get hashCode => Object.hash(runtimeType,sender,isOwn,timestamp,preview,isUnsent);

@override
String toString() {
  return 'LatestEvent(sender: $sender, isOwn: $isOwn, timestamp: $timestamp, preview: $preview, isUnsent: $isUnsent)';
}


}

/// @nodoc
abstract mixin class _$LatestEventCopyWith<$Res> implements $LatestEventCopyWith<$Res> {
  factory _$LatestEventCopyWith(_LatestEvent value, $Res Function(_LatestEvent) _then) = __$LatestEventCopyWithImpl;
@override @useResult
$Res call({
 ChatUser sender, bool isOwn, DateTime timestamp, MessagePreview preview, bool isUnsent
});


@override $ChatUserCopyWith<$Res> get sender;@override $MessagePreviewCopyWith<$Res> get preview;

}
/// @nodoc
class __$LatestEventCopyWithImpl<$Res>
    implements _$LatestEventCopyWith<$Res> {
  __$LatestEventCopyWithImpl(this._self, this._then);

  final _LatestEvent _self;
  final $Res Function(_LatestEvent) _then;

/// Create a copy of LatestEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sender = null,Object? isOwn = null,Object? timestamp = null,Object? preview = null,Object? isUnsent = null,}) {
  return _then(_LatestEvent(
sender: null == sender ? _self.sender : sender // ignore: cast_nullable_to_non_nullable
as ChatUser,isOwn: null == isOwn ? _self.isOwn : isOwn // ignore: cast_nullable_to_non_nullable
as bool,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,preview: null == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as MessagePreview,isUnsent: null == isUnsent ? _self.isUnsent : isUnsent // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of LatestEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatUserCopyWith<$Res> get sender {
  
  return $ChatUserCopyWith<$Res>(_self.sender, (value) {
    return _then(_self.copyWith(sender: value));
  });
}/// Create a copy of LatestEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MessagePreviewCopyWith<$Res> get preview {
  
  return $MessagePreviewCopyWith<$Res>(_self.preview, (value) {
    return _then(_self.copyWith(preview: value));
  });
}
}

/// @nodoc
mixin _$RoomSummary {

 String get id; String get name; ChatMedia? get avatar; RoomKind get kind; Membership get membership; bool get isEncrypted; int get unreadMessages; int get unreadMentions; LatestEvent? get latest;/// Mode chosen for this room; `null` follows the account default.
 NotificationMode? get notificationMode;
/// Create a copy of RoomSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomSummaryCopyWith<RoomSummary> get copyWith => _$RoomSummaryCopyWithImpl<RoomSummary>(this as RoomSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.membership, membership) || other.membership == membership)&&(identical(other.isEncrypted, isEncrypted) || other.isEncrypted == isEncrypted)&&(identical(other.unreadMessages, unreadMessages) || other.unreadMessages == unreadMessages)&&(identical(other.unreadMentions, unreadMentions) || other.unreadMentions == unreadMentions)&&(identical(other.latest, latest) || other.latest == latest)&&(identical(other.notificationMode, notificationMode) || other.notificationMode == notificationMode));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,avatar,kind,membership,isEncrypted,unreadMessages,unreadMentions,latest,notificationMode);

@override
String toString() {
  return 'RoomSummary(id: $id, name: $name, avatar: $avatar, kind: $kind, membership: $membership, isEncrypted: $isEncrypted, unreadMessages: $unreadMessages, unreadMentions: $unreadMentions, latest: $latest, notificationMode: $notificationMode)';
}


}

/// @nodoc
abstract mixin class $RoomSummaryCopyWith<$Res>  {
  factory $RoomSummaryCopyWith(RoomSummary value, $Res Function(RoomSummary) _then) = _$RoomSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String name, ChatMedia? avatar, RoomKind kind, Membership membership, bool isEncrypted, int unreadMessages, int unreadMentions, LatestEvent? latest, NotificationMode? notificationMode
});


$LatestEventCopyWith<$Res>? get latest;

}
/// @nodoc
class _$RoomSummaryCopyWithImpl<$Res>
    implements $RoomSummaryCopyWith<$Res> {
  _$RoomSummaryCopyWithImpl(this._self, this._then);

  final RoomSummary _self;
  final $Res Function(RoomSummary) _then;

/// Create a copy of RoomSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? avatar = freezed,Object? kind = null,Object? membership = null,Object? isEncrypted = null,Object? unreadMessages = null,Object? unreadMentions = null,Object? latest = freezed,Object? notificationMode = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as ChatMedia?,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as RoomKind,membership: null == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as Membership,isEncrypted: null == isEncrypted ? _self.isEncrypted : isEncrypted // ignore: cast_nullable_to_non_nullable
as bool,unreadMessages: null == unreadMessages ? _self.unreadMessages : unreadMessages // ignore: cast_nullable_to_non_nullable
as int,unreadMentions: null == unreadMentions ? _self.unreadMentions : unreadMentions // ignore: cast_nullable_to_non_nullable
as int,latest: freezed == latest ? _self.latest : latest // ignore: cast_nullable_to_non_nullable
as LatestEvent?,notificationMode: freezed == notificationMode ? _self.notificationMode : notificationMode // ignore: cast_nullable_to_non_nullable
as NotificationMode?,
  ));
}
/// Create a copy of RoomSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LatestEventCopyWith<$Res>? get latest {
    if (_self.latest == null) {
    return null;
  }

  return $LatestEventCopyWith<$Res>(_self.latest!, (value) {
    return _then(_self.copyWith(latest: value));
  });
}
}


/// Adds pattern-matching-related methods to [RoomSummary].
extension RoomSummaryPatterns on RoomSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoomSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoomSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoomSummary value)  $default,){
final _that = this;
switch (_that) {
case _RoomSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoomSummary value)?  $default,){
final _that = this;
switch (_that) {
case _RoomSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  ChatMedia? avatar,  RoomKind kind,  Membership membership,  bool isEncrypted,  int unreadMessages,  int unreadMentions,  LatestEvent? latest,  NotificationMode? notificationMode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoomSummary() when $default != null:
return $default(_that.id,_that.name,_that.avatar,_that.kind,_that.membership,_that.isEncrypted,_that.unreadMessages,_that.unreadMentions,_that.latest,_that.notificationMode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  ChatMedia? avatar,  RoomKind kind,  Membership membership,  bool isEncrypted,  int unreadMessages,  int unreadMentions,  LatestEvent? latest,  NotificationMode? notificationMode)  $default,) {final _that = this;
switch (_that) {
case _RoomSummary():
return $default(_that.id,_that.name,_that.avatar,_that.kind,_that.membership,_that.isEncrypted,_that.unreadMessages,_that.unreadMentions,_that.latest,_that.notificationMode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  ChatMedia? avatar,  RoomKind kind,  Membership membership,  bool isEncrypted,  int unreadMessages,  int unreadMentions,  LatestEvent? latest,  NotificationMode? notificationMode)?  $default,) {final _that = this;
switch (_that) {
case _RoomSummary() when $default != null:
return $default(_that.id,_that.name,_that.avatar,_that.kind,_that.membership,_that.isEncrypted,_that.unreadMessages,_that.unreadMentions,_that.latest,_that.notificationMode);case _:
  return null;

}
}

}

/// @nodoc


class _RoomSummary implements RoomSummary {
  const _RoomSummary({required this.id, required this.name, this.avatar, required this.kind, required this.membership, required this.isEncrypted, required this.unreadMessages, required this.unreadMentions, this.latest, this.notificationMode});
  

@override final  String id;
@override final  String name;
@override final  ChatMedia? avatar;
@override final  RoomKind kind;
@override final  Membership membership;
@override final  bool isEncrypted;
@override final  int unreadMessages;
@override final  int unreadMentions;
@override final  LatestEvent? latest;
/// Mode chosen for this room; `null` follows the account default.
@override final  NotificationMode? notificationMode;

/// Create a copy of RoomSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomSummaryCopyWith<_RoomSummary> get copyWith => __$RoomSummaryCopyWithImpl<_RoomSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoomSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.membership, membership) || other.membership == membership)&&(identical(other.isEncrypted, isEncrypted) || other.isEncrypted == isEncrypted)&&(identical(other.unreadMessages, unreadMessages) || other.unreadMessages == unreadMessages)&&(identical(other.unreadMentions, unreadMentions) || other.unreadMentions == unreadMentions)&&(identical(other.latest, latest) || other.latest == latest)&&(identical(other.notificationMode, notificationMode) || other.notificationMode == notificationMode));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,avatar,kind,membership,isEncrypted,unreadMessages,unreadMentions,latest,notificationMode);

@override
String toString() {
  return 'RoomSummary(id: $id, name: $name, avatar: $avatar, kind: $kind, membership: $membership, isEncrypted: $isEncrypted, unreadMessages: $unreadMessages, unreadMentions: $unreadMentions, latest: $latest, notificationMode: $notificationMode)';
}


}

/// @nodoc
abstract mixin class _$RoomSummaryCopyWith<$Res> implements $RoomSummaryCopyWith<$Res> {
  factory _$RoomSummaryCopyWith(_RoomSummary value, $Res Function(_RoomSummary) _then) = __$RoomSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, ChatMedia? avatar, RoomKind kind, Membership membership, bool isEncrypted, int unreadMessages, int unreadMentions, LatestEvent? latest, NotificationMode? notificationMode
});


@override $LatestEventCopyWith<$Res>? get latest;

}
/// @nodoc
class __$RoomSummaryCopyWithImpl<$Res>
    implements _$RoomSummaryCopyWith<$Res> {
  __$RoomSummaryCopyWithImpl(this._self, this._then);

  final _RoomSummary _self;
  final $Res Function(_RoomSummary) _then;

/// Create a copy of RoomSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? avatar = freezed,Object? kind = null,Object? membership = null,Object? isEncrypted = null,Object? unreadMessages = null,Object? unreadMentions = null,Object? latest = freezed,Object? notificationMode = freezed,}) {
  return _then(_RoomSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as ChatMedia?,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as RoomKind,membership: null == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as Membership,isEncrypted: null == isEncrypted ? _self.isEncrypted : isEncrypted // ignore: cast_nullable_to_non_nullable
as bool,unreadMessages: null == unreadMessages ? _self.unreadMessages : unreadMessages // ignore: cast_nullable_to_non_nullable
as int,unreadMentions: null == unreadMentions ? _self.unreadMentions : unreadMentions // ignore: cast_nullable_to_non_nullable
as int,latest: freezed == latest ? _self.latest : latest // ignore: cast_nullable_to_non_nullable
as LatestEvent?,notificationMode: freezed == notificationMode ? _self.notificationMode : notificationMode // ignore: cast_nullable_to_non_nullable
as NotificationMode?,
  ));
}

/// Create a copy of RoomSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LatestEventCopyWith<$Res>? get latest {
    if (_self.latest == null) {
    return null;
  }

  return $LatestEventCopyWith<$Res>(_self.latest!, (value) {
    return _then(_self.copyWith(latest: value));
  });
}
}

/// @nodoc
mixin _$ChatMember {

 ChatUser get user; MemberState get state; MemberRole get role; bool get isOwn;
/// Create a copy of ChatMember
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMemberCopyWith<ChatMember> get copyWith => _$ChatMemberCopyWithImpl<ChatMember>(this as ChatMember, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMember&&(identical(other.user, user) || other.user == user)&&(identical(other.state, state) || other.state == state)&&(identical(other.role, role) || other.role == role)&&(identical(other.isOwn, isOwn) || other.isOwn == isOwn));
}


@override
int get hashCode => Object.hash(runtimeType,user,state,role,isOwn);

@override
String toString() {
  return 'ChatMember(user: $user, state: $state, role: $role, isOwn: $isOwn)';
}


}

/// @nodoc
abstract mixin class $ChatMemberCopyWith<$Res>  {
  factory $ChatMemberCopyWith(ChatMember value, $Res Function(ChatMember) _then) = _$ChatMemberCopyWithImpl;
@useResult
$Res call({
 ChatUser user, MemberState state, MemberRole role, bool isOwn
});


$ChatUserCopyWith<$Res> get user;

}
/// @nodoc
class _$ChatMemberCopyWithImpl<$Res>
    implements $ChatMemberCopyWith<$Res> {
  _$ChatMemberCopyWithImpl(this._self, this._then);

  final ChatMember _self;
  final $Res Function(ChatMember) _then;

/// Create a copy of ChatMember
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user = null,Object? state = null,Object? role = null,Object? isOwn = null,}) {
  return _then(_self.copyWith(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as ChatUser,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as MemberState,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as MemberRole,isOwn: null == isOwn ? _self.isOwn : isOwn // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of ChatMember
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatUserCopyWith<$Res> get user {
  
  return $ChatUserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChatMember].
extension ChatMemberPatterns on ChatMember {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMember value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMember() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMember value)  $default,){
final _that = this;
switch (_that) {
case _ChatMember():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMember value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMember() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ChatUser user,  MemberState state,  MemberRole role,  bool isOwn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMember() when $default != null:
return $default(_that.user,_that.state,_that.role,_that.isOwn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ChatUser user,  MemberState state,  MemberRole role,  bool isOwn)  $default,) {final _that = this;
switch (_that) {
case _ChatMember():
return $default(_that.user,_that.state,_that.role,_that.isOwn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ChatUser user,  MemberState state,  MemberRole role,  bool isOwn)?  $default,) {final _that = this;
switch (_that) {
case _ChatMember() when $default != null:
return $default(_that.user,_that.state,_that.role,_that.isOwn);case _:
  return null;

}
}

}

/// @nodoc


class _ChatMember implements ChatMember {
  const _ChatMember({required this.user, required this.state, required this.role, required this.isOwn});
  

@override final  ChatUser user;
@override final  MemberState state;
@override final  MemberRole role;
@override final  bool isOwn;

/// Create a copy of ChatMember
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMemberCopyWith<_ChatMember> get copyWith => __$ChatMemberCopyWithImpl<_ChatMember>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMember&&(identical(other.user, user) || other.user == user)&&(identical(other.state, state) || other.state == state)&&(identical(other.role, role) || other.role == role)&&(identical(other.isOwn, isOwn) || other.isOwn == isOwn));
}


@override
int get hashCode => Object.hash(runtimeType,user,state,role,isOwn);

@override
String toString() {
  return 'ChatMember(user: $user, state: $state, role: $role, isOwn: $isOwn)';
}


}

/// @nodoc
abstract mixin class _$ChatMemberCopyWith<$Res> implements $ChatMemberCopyWith<$Res> {
  factory _$ChatMemberCopyWith(_ChatMember value, $Res Function(_ChatMember) _then) = __$ChatMemberCopyWithImpl;
@override @useResult
$Res call({
 ChatUser user, MemberState state, MemberRole role, bool isOwn
});


@override $ChatUserCopyWith<$Res> get user;

}
/// @nodoc
class __$ChatMemberCopyWithImpl<$Res>
    implements _$ChatMemberCopyWith<$Res> {
  __$ChatMemberCopyWithImpl(this._self, this._then);

  final _ChatMember _self;
  final $Res Function(_ChatMember) _then;

/// Create a copy of ChatMember
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user = null,Object? state = null,Object? role = null,Object? isOwn = null,}) {
  return _then(_ChatMember(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as ChatUser,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as MemberState,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as MemberRole,isOwn: null == isOwn ? _self.isOwn : isOwn // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of ChatMember
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatUserCopyWith<$Res> get user {
  
  return $ChatUserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

/// @nodoc
mixin _$RoomNotificationSettings {

 NotificationMode get mode;/// True when the room follows the account default for its kind.
 bool get isDefault;
/// Create a copy of RoomNotificationSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomNotificationSettingsCopyWith<RoomNotificationSettings> get copyWith => _$RoomNotificationSettingsCopyWithImpl<RoomNotificationSettings>(this as RoomNotificationSettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomNotificationSettings&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}


@override
int get hashCode => Object.hash(runtimeType,mode,isDefault);

@override
String toString() {
  return 'RoomNotificationSettings(mode: $mode, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class $RoomNotificationSettingsCopyWith<$Res>  {
  factory $RoomNotificationSettingsCopyWith(RoomNotificationSettings value, $Res Function(RoomNotificationSettings) _then) = _$RoomNotificationSettingsCopyWithImpl;
@useResult
$Res call({
 NotificationMode mode, bool isDefault
});




}
/// @nodoc
class _$RoomNotificationSettingsCopyWithImpl<$Res>
    implements $RoomNotificationSettingsCopyWith<$Res> {
  _$RoomNotificationSettingsCopyWithImpl(this._self, this._then);

  final RoomNotificationSettings _self;
  final $Res Function(RoomNotificationSettings) _then;

/// Create a copy of RoomNotificationSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? isDefault = null,}) {
  return _then(_self.copyWith(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as NotificationMode,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RoomNotificationSettings].
extension RoomNotificationSettingsPatterns on RoomNotificationSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoomNotificationSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoomNotificationSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoomNotificationSettings value)  $default,){
final _that = this;
switch (_that) {
case _RoomNotificationSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoomNotificationSettings value)?  $default,){
final _that = this;
switch (_that) {
case _RoomNotificationSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( NotificationMode mode,  bool isDefault)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoomNotificationSettings() when $default != null:
return $default(_that.mode,_that.isDefault);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( NotificationMode mode,  bool isDefault)  $default,) {final _that = this;
switch (_that) {
case _RoomNotificationSettings():
return $default(_that.mode,_that.isDefault);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( NotificationMode mode,  bool isDefault)?  $default,) {final _that = this;
switch (_that) {
case _RoomNotificationSettings() when $default != null:
return $default(_that.mode,_that.isDefault);case _:
  return null;

}
}

}

/// @nodoc


class _RoomNotificationSettings implements RoomNotificationSettings {
  const _RoomNotificationSettings({required this.mode, required this.isDefault});
  

@override final  NotificationMode mode;
/// True when the room follows the account default for its kind.
@override final  bool isDefault;

/// Create a copy of RoomNotificationSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomNotificationSettingsCopyWith<_RoomNotificationSettings> get copyWith => __$RoomNotificationSettingsCopyWithImpl<_RoomNotificationSettings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoomNotificationSettings&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}


@override
int get hashCode => Object.hash(runtimeType,mode,isDefault);

@override
String toString() {
  return 'RoomNotificationSettings(mode: $mode, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class _$RoomNotificationSettingsCopyWith<$Res> implements $RoomNotificationSettingsCopyWith<$Res> {
  factory _$RoomNotificationSettingsCopyWith(_RoomNotificationSettings value, $Res Function(_RoomNotificationSettings) _then) = __$RoomNotificationSettingsCopyWithImpl;
@override @useResult
$Res call({
 NotificationMode mode, bool isDefault
});




}
/// @nodoc
class __$RoomNotificationSettingsCopyWithImpl<$Res>
    implements _$RoomNotificationSettingsCopyWith<$Res> {
  __$RoomNotificationSettingsCopyWithImpl(this._self, this._then);

  final _RoomNotificationSettings _self;
  final $Res Function(_RoomNotificationSettings) _then;

/// Create a copy of RoomNotificationSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? isDefault = null,}) {
  return _then(_RoomNotificationSettings(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as NotificationMode,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$EventKey {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventKey);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EventKey()';
}


}

/// @nodoc
class $EventKeyCopyWith<$Res>  {
$EventKeyCopyWith(EventKey _, $Res Function(EventKey) __);
}


/// Adds pattern-matching-related methods to [EventKey].
extension EventKeyPatterns on EventKey {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LocalEventKey value)?  local,TResult Function( RemoteEventKey value)?  remote,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LocalEventKey() when local != null:
return local(_that);case RemoteEventKey() when remote != null:
return remote(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LocalEventKey value)  local,required TResult Function( RemoteEventKey value)  remote,}){
final _that = this;
switch (_that) {
case LocalEventKey():
return local(_that);case RemoteEventKey():
return remote(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LocalEventKey value)?  local,TResult? Function( RemoteEventKey value)?  remote,}){
final _that = this;
switch (_that) {
case LocalEventKey() when local != null:
return local(_that);case RemoteEventKey() when remote != null:
return remote(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String transactionId)?  local,TResult Function( String eventId)?  remote,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LocalEventKey() when local != null:
return local(_that.transactionId);case RemoteEventKey() when remote != null:
return remote(_that.eventId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String transactionId)  local,required TResult Function( String eventId)  remote,}) {final _that = this;
switch (_that) {
case LocalEventKey():
return local(_that.transactionId);case RemoteEventKey():
return remote(_that.eventId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String transactionId)?  local,TResult? Function( String eventId)?  remote,}) {final _that = this;
switch (_that) {
case LocalEventKey() when local != null:
return local(_that.transactionId);case RemoteEventKey() when remote != null:
return remote(_that.eventId);case _:
  return null;

}
}

}

/// @nodoc


class LocalEventKey implements EventKey {
  const LocalEventKey(this.transactionId);
  

 final  String transactionId;

/// Create a copy of EventKey
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocalEventKeyCopyWith<LocalEventKey> get copyWith => _$LocalEventKeyCopyWithImpl<LocalEventKey>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocalEventKey&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId));
}


@override
int get hashCode => Object.hash(runtimeType,transactionId);

@override
String toString() {
  return 'EventKey.local(transactionId: $transactionId)';
}


}

/// @nodoc
abstract mixin class $LocalEventKeyCopyWith<$Res> implements $EventKeyCopyWith<$Res> {
  factory $LocalEventKeyCopyWith(LocalEventKey value, $Res Function(LocalEventKey) _then) = _$LocalEventKeyCopyWithImpl;
@useResult
$Res call({
 String transactionId
});




}
/// @nodoc
class _$LocalEventKeyCopyWithImpl<$Res>
    implements $LocalEventKeyCopyWith<$Res> {
  _$LocalEventKeyCopyWithImpl(this._self, this._then);

  final LocalEventKey _self;
  final $Res Function(LocalEventKey) _then;

/// Create a copy of EventKey
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? transactionId = null,}) {
  return _then(LocalEventKey(
null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class RemoteEventKey implements EventKey {
  const RemoteEventKey(this.eventId);
  

 final  String eventId;

/// Create a copy of EventKey
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemoteEventKeyCopyWith<RemoteEventKey> get copyWith => _$RemoteEventKeyCopyWithImpl<RemoteEventKey>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoteEventKey&&(identical(other.eventId, eventId) || other.eventId == eventId));
}


@override
int get hashCode => Object.hash(runtimeType,eventId);

@override
String toString() {
  return 'EventKey.remote(eventId: $eventId)';
}


}

/// @nodoc
abstract mixin class $RemoteEventKeyCopyWith<$Res> implements $EventKeyCopyWith<$Res> {
  factory $RemoteEventKeyCopyWith(RemoteEventKey value, $Res Function(RemoteEventKey) _then) = _$RemoteEventKeyCopyWithImpl;
@useResult
$Res call({
 String eventId
});




}
/// @nodoc
class _$RemoteEventKeyCopyWithImpl<$Res>
    implements $RemoteEventKeyCopyWith<$Res> {
  _$RemoteEventKeyCopyWithImpl(this._self, this._then);

  final RemoteEventKey _self;
  final $Res Function(RemoteEventKey) _then;

/// Create a copy of EventKey
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? eventId = null,}) {
  return _then(RemoteEventKey(
null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$UploadProgress {

 int get currentBytes; int get totalBytes;
/// Create a copy of UploadProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UploadProgressCopyWith<UploadProgress> get copyWith => _$UploadProgressCopyWithImpl<UploadProgress>(this as UploadProgress, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UploadProgress&&(identical(other.currentBytes, currentBytes) || other.currentBytes == currentBytes)&&(identical(other.totalBytes, totalBytes) || other.totalBytes == totalBytes));
}


@override
int get hashCode => Object.hash(runtimeType,currentBytes,totalBytes);

@override
String toString() {
  return 'UploadProgress(currentBytes: $currentBytes, totalBytes: $totalBytes)';
}


}

/// @nodoc
abstract mixin class $UploadProgressCopyWith<$Res>  {
  factory $UploadProgressCopyWith(UploadProgress value, $Res Function(UploadProgress) _then) = _$UploadProgressCopyWithImpl;
@useResult
$Res call({
 int currentBytes, int totalBytes
});




}
/// @nodoc
class _$UploadProgressCopyWithImpl<$Res>
    implements $UploadProgressCopyWith<$Res> {
  _$UploadProgressCopyWithImpl(this._self, this._then);

  final UploadProgress _self;
  final $Res Function(UploadProgress) _then;

/// Create a copy of UploadProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentBytes = null,Object? totalBytes = null,}) {
  return _then(_self.copyWith(
currentBytes: null == currentBytes ? _self.currentBytes : currentBytes // ignore: cast_nullable_to_non_nullable
as int,totalBytes: null == totalBytes ? _self.totalBytes : totalBytes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UploadProgress].
extension UploadProgressPatterns on UploadProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UploadProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UploadProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UploadProgress value)  $default,){
final _that = this;
switch (_that) {
case _UploadProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UploadProgress value)?  $default,){
final _that = this;
switch (_that) {
case _UploadProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int currentBytes,  int totalBytes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UploadProgress() when $default != null:
return $default(_that.currentBytes,_that.totalBytes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int currentBytes,  int totalBytes)  $default,) {final _that = this;
switch (_that) {
case _UploadProgress():
return $default(_that.currentBytes,_that.totalBytes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int currentBytes,  int totalBytes)?  $default,) {final _that = this;
switch (_that) {
case _UploadProgress() when $default != null:
return $default(_that.currentBytes,_that.totalBytes);case _:
  return null;

}
}

}

/// @nodoc


class _UploadProgress implements UploadProgress {
  const _UploadProgress({required this.currentBytes, required this.totalBytes});
  

@override final  int currentBytes;
@override final  int totalBytes;

/// Create a copy of UploadProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UploadProgressCopyWith<_UploadProgress> get copyWith => __$UploadProgressCopyWithImpl<_UploadProgress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UploadProgress&&(identical(other.currentBytes, currentBytes) || other.currentBytes == currentBytes)&&(identical(other.totalBytes, totalBytes) || other.totalBytes == totalBytes));
}


@override
int get hashCode => Object.hash(runtimeType,currentBytes,totalBytes);

@override
String toString() {
  return 'UploadProgress(currentBytes: $currentBytes, totalBytes: $totalBytes)';
}


}

/// @nodoc
abstract mixin class _$UploadProgressCopyWith<$Res> implements $UploadProgressCopyWith<$Res> {
  factory _$UploadProgressCopyWith(_UploadProgress value, $Res Function(_UploadProgress) _then) = __$UploadProgressCopyWithImpl;
@override @useResult
$Res call({
 int currentBytes, int totalBytes
});




}
/// @nodoc
class __$UploadProgressCopyWithImpl<$Res>
    implements _$UploadProgressCopyWith<$Res> {
  __$UploadProgressCopyWithImpl(this._self, this._then);

  final _UploadProgress _self;
  final $Res Function(_UploadProgress) _then;

/// Create a copy of UploadProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentBytes = null,Object? totalBytes = null,}) {
  return _then(_UploadProgress(
currentBytes: null == currentBytes ? _self.currentBytes : currentBytes // ignore: cast_nullable_to_non_nullable
as int,totalBytes: null == totalBytes ? _self.totalBytes : totalBytes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$SendState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SendState()';
}


}

/// @nodoc
class $SendStateCopyWith<$Res>  {
$SendStateCopyWith(SendState _, $Res Function(SendState) __);
}


/// Adds pattern-matching-related methods to [SendState].
extension SendStatePatterns on SendState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( Sending value)?  sending,TResult Function( Sent value)?  sent,TResult Function( SendFailed value)?  failed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case Sending() when sending != null:
return sending(_that);case Sent() when sent != null:
return sent(_that);case SendFailed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( Sending value)  sending,required TResult Function( Sent value)  sent,required TResult Function( SendFailed value)  failed,}){
final _that = this;
switch (_that) {
case Sending():
return sending(_that);case Sent():
return sent(_that);case SendFailed():
return failed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( Sending value)?  sending,TResult? Function( Sent value)?  sent,TResult? Function( SendFailed value)?  failed,}){
final _that = this;
switch (_that) {
case Sending() when sending != null:
return sending(_that);case Sent() when sent != null:
return sent(_that);case SendFailed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( UploadProgress? progress)?  sending,TResult Function()?  sent,TResult Function( bool recoverable)?  failed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case Sending() when sending != null:
return sending(_that.progress);case Sent() when sent != null:
return sent();case SendFailed() when failed != null:
return failed(_that.recoverable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( UploadProgress? progress)  sending,required TResult Function()  sent,required TResult Function( bool recoverable)  failed,}) {final _that = this;
switch (_that) {
case Sending():
return sending(_that.progress);case Sent():
return sent();case SendFailed():
return failed(_that.recoverable);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( UploadProgress? progress)?  sending,TResult? Function()?  sent,TResult? Function( bool recoverable)?  failed,}) {final _that = this;
switch (_that) {
case Sending() when sending != null:
return sending(_that.progress);case Sent() when sent != null:
return sent();case SendFailed() when failed != null:
return failed(_that.recoverable);case _:
  return null;

}
}

}

/// @nodoc


class Sending implements SendState {
  const Sending({this.progress});
  

 final  UploadProgress? progress;

/// Create a copy of SendState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SendingCopyWith<Sending> get copyWith => _$SendingCopyWithImpl<Sending>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Sending&&(identical(other.progress, progress) || other.progress == progress));
}


@override
int get hashCode => Object.hash(runtimeType,progress);

@override
String toString() {
  return 'SendState.sending(progress: $progress)';
}


}

/// @nodoc
abstract mixin class $SendingCopyWith<$Res> implements $SendStateCopyWith<$Res> {
  factory $SendingCopyWith(Sending value, $Res Function(Sending) _then) = _$SendingCopyWithImpl;
@useResult
$Res call({
 UploadProgress? progress
});


$UploadProgressCopyWith<$Res>? get progress;

}
/// @nodoc
class _$SendingCopyWithImpl<$Res>
    implements $SendingCopyWith<$Res> {
  _$SendingCopyWithImpl(this._self, this._then);

  final Sending _self;
  final $Res Function(Sending) _then;

/// Create a copy of SendState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? progress = freezed,}) {
  return _then(Sending(
progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as UploadProgress?,
  ));
}

/// Create a copy of SendState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UploadProgressCopyWith<$Res>? get progress {
    if (_self.progress == null) {
    return null;
  }

  return $UploadProgressCopyWith<$Res>(_self.progress!, (value) {
    return _then(_self.copyWith(progress: value));
  });
}
}

/// @nodoc


class Sent implements SendState {
  const Sent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Sent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SendState.sent()';
}


}




/// @nodoc


class SendFailed implements SendState {
  const SendFailed({required this.recoverable});
  

 final  bool recoverable;

/// Create a copy of SendState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SendFailedCopyWith<SendFailed> get copyWith => _$SendFailedCopyWithImpl<SendFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendFailed&&(identical(other.recoverable, recoverable) || other.recoverable == recoverable));
}


@override
int get hashCode => Object.hash(runtimeType,recoverable);

@override
String toString() {
  return 'SendState.failed(recoverable: $recoverable)';
}


}

/// @nodoc
abstract mixin class $SendFailedCopyWith<$Res> implements $SendStateCopyWith<$Res> {
  factory $SendFailedCopyWith(SendFailed value, $Res Function(SendFailed) _then) = _$SendFailedCopyWithImpl;
@useResult
$Res call({
 bool recoverable
});




}
/// @nodoc
class _$SendFailedCopyWithImpl<$Res>
    implements $SendFailedCopyWith<$Res> {
  _$SendFailedCopyWithImpl(this._self, this._then);

  final SendFailed _self;
  final $Res Function(SendFailed) _then;

/// Create a copy of SendState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? recoverable = null,}) {
  return _then(SendFailed(
recoverable: null == recoverable ? _self.recoverable : recoverable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$EventContent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventContent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EventContent()';
}


}

/// @nodoc
class $EventContentCopyWith<$Res>  {
$EventContentCopyWith(EventContent _, $Res Function(EventContent) __);
}


/// Adds pattern-matching-related methods to [EventContent].
extension EventContentPatterns on EventContent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TextContent value)?  text,TResult Function( ImageContent value)?  image,TResult Function( VideoContent value)?  video,TResult Function( AudioContent value)?  audio,TResult Function( FileContent value)?  file,TResult Function( RedactedContent value)?  redacted,TResult Function( UnableToDecryptContent value)?  unableToDecrypt,TResult Function( MembershipContent value)?  membership,TResult Function( ProfileChangeContent value)?  profileChange,TResult Function( RoomStateContent value)?  roomState,TResult Function( UnsupportedContent value)?  unsupported,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TextContent() when text != null:
return text(_that);case ImageContent() when image != null:
return image(_that);case VideoContent() when video != null:
return video(_that);case AudioContent() when audio != null:
return audio(_that);case FileContent() when file != null:
return file(_that);case RedactedContent() when redacted != null:
return redacted(_that);case UnableToDecryptContent() when unableToDecrypt != null:
return unableToDecrypt(_that);case MembershipContent() when membership != null:
return membership(_that);case ProfileChangeContent() when profileChange != null:
return profileChange(_that);case RoomStateContent() when roomState != null:
return roomState(_that);case UnsupportedContent() when unsupported != null:
return unsupported(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TextContent value)  text,required TResult Function( ImageContent value)  image,required TResult Function( VideoContent value)  video,required TResult Function( AudioContent value)  audio,required TResult Function( FileContent value)  file,required TResult Function( RedactedContent value)  redacted,required TResult Function( UnableToDecryptContent value)  unableToDecrypt,required TResult Function( MembershipContent value)  membership,required TResult Function( ProfileChangeContent value)  profileChange,required TResult Function( RoomStateContent value)  roomState,required TResult Function( UnsupportedContent value)  unsupported,}){
final _that = this;
switch (_that) {
case TextContent():
return text(_that);case ImageContent():
return image(_that);case VideoContent():
return video(_that);case AudioContent():
return audio(_that);case FileContent():
return file(_that);case RedactedContent():
return redacted(_that);case UnableToDecryptContent():
return unableToDecrypt(_that);case MembershipContent():
return membership(_that);case ProfileChangeContent():
return profileChange(_that);case RoomStateContent():
return roomState(_that);case UnsupportedContent():
return unsupported(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TextContent value)?  text,TResult? Function( ImageContent value)?  image,TResult? Function( VideoContent value)?  video,TResult? Function( AudioContent value)?  audio,TResult? Function( FileContent value)?  file,TResult? Function( RedactedContent value)?  redacted,TResult? Function( UnableToDecryptContent value)?  unableToDecrypt,TResult? Function( MembershipContent value)?  membership,TResult? Function( ProfileChangeContent value)?  profileChange,TResult? Function( RoomStateContent value)?  roomState,TResult? Function( UnsupportedContent value)?  unsupported,}){
final _that = this;
switch (_that) {
case TextContent() when text != null:
return text(_that);case ImageContent() when image != null:
return image(_that);case VideoContent() when video != null:
return video(_that);case AudioContent() when audio != null:
return audio(_that);case FileContent() when file != null:
return file(_that);case RedactedContent() when redacted != null:
return redacted(_that);case UnableToDecryptContent() when unableToDecrypt != null:
return unableToDecrypt(_that);case MembershipContent() when membership != null:
return membership(_that);case ProfileChangeContent() when profileChange != null:
return profileChange(_that);case RoomStateContent() when roomState != null:
return roomState(_that);case UnsupportedContent() when unsupported != null:
return unsupported(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String body)?  text,TResult Function( String? caption,  String filename,  ChatMedia media,  ChatMedia? thumbnail,  int? width,  int? height,  String? blurhash)?  image,TResult Function( String? caption,  String filename,  ChatMedia media)?  video,TResult Function( String filename,  ChatMedia media)?  audio,TResult Function( String? caption,  String filename,  ChatMedia media,  int? size)?  file,TResult Function()?  redacted,TResult Function( DecryptionFailure reason)?  unableToDecrypt,TResult Function( String userId,  MembershipChange change)?  membership,TResult Function( String userId)?  profileChange,TResult Function( String eventType)?  roomState,TResult Function()?  unsupported,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TextContent() when text != null:
return text(_that.body);case ImageContent() when image != null:
return image(_that.caption,_that.filename,_that.media,_that.thumbnail,_that.width,_that.height,_that.blurhash);case VideoContent() when video != null:
return video(_that.caption,_that.filename,_that.media);case AudioContent() when audio != null:
return audio(_that.filename,_that.media);case FileContent() when file != null:
return file(_that.caption,_that.filename,_that.media,_that.size);case RedactedContent() when redacted != null:
return redacted();case UnableToDecryptContent() when unableToDecrypt != null:
return unableToDecrypt(_that.reason);case MembershipContent() when membership != null:
return membership(_that.userId,_that.change);case ProfileChangeContent() when profileChange != null:
return profileChange(_that.userId);case RoomStateContent() when roomState != null:
return roomState(_that.eventType);case UnsupportedContent() when unsupported != null:
return unsupported();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String body)  text,required TResult Function( String? caption,  String filename,  ChatMedia media,  ChatMedia? thumbnail,  int? width,  int? height,  String? blurhash)  image,required TResult Function( String? caption,  String filename,  ChatMedia media)  video,required TResult Function( String filename,  ChatMedia media)  audio,required TResult Function( String? caption,  String filename,  ChatMedia media,  int? size)  file,required TResult Function()  redacted,required TResult Function( DecryptionFailure reason)  unableToDecrypt,required TResult Function( String userId,  MembershipChange change)  membership,required TResult Function( String userId)  profileChange,required TResult Function( String eventType)  roomState,required TResult Function()  unsupported,}) {final _that = this;
switch (_that) {
case TextContent():
return text(_that.body);case ImageContent():
return image(_that.caption,_that.filename,_that.media,_that.thumbnail,_that.width,_that.height,_that.blurhash);case VideoContent():
return video(_that.caption,_that.filename,_that.media);case AudioContent():
return audio(_that.filename,_that.media);case FileContent():
return file(_that.caption,_that.filename,_that.media,_that.size);case RedactedContent():
return redacted();case UnableToDecryptContent():
return unableToDecrypt(_that.reason);case MembershipContent():
return membership(_that.userId,_that.change);case ProfileChangeContent():
return profileChange(_that.userId);case RoomStateContent():
return roomState(_that.eventType);case UnsupportedContent():
return unsupported();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String body)?  text,TResult? Function( String? caption,  String filename,  ChatMedia media,  ChatMedia? thumbnail,  int? width,  int? height,  String? blurhash)?  image,TResult? Function( String? caption,  String filename,  ChatMedia media)?  video,TResult? Function( String filename,  ChatMedia media)?  audio,TResult? Function( String? caption,  String filename,  ChatMedia media,  int? size)?  file,TResult? Function()?  redacted,TResult? Function( DecryptionFailure reason)?  unableToDecrypt,TResult? Function( String userId,  MembershipChange change)?  membership,TResult? Function( String userId)?  profileChange,TResult? Function( String eventType)?  roomState,TResult? Function()?  unsupported,}) {final _that = this;
switch (_that) {
case TextContent() when text != null:
return text(_that.body);case ImageContent() when image != null:
return image(_that.caption,_that.filename,_that.media,_that.thumbnail,_that.width,_that.height,_that.blurhash);case VideoContent() when video != null:
return video(_that.caption,_that.filename,_that.media);case AudioContent() when audio != null:
return audio(_that.filename,_that.media);case FileContent() when file != null:
return file(_that.caption,_that.filename,_that.media,_that.size);case RedactedContent() when redacted != null:
return redacted();case UnableToDecryptContent() when unableToDecrypt != null:
return unableToDecrypt(_that.reason);case MembershipContent() when membership != null:
return membership(_that.userId,_that.change);case ProfileChangeContent() when profileChange != null:
return profileChange(_that.userId);case RoomStateContent() when roomState != null:
return roomState(_that.eventType);case UnsupportedContent() when unsupported != null:
return unsupported();case _:
  return null;

}
}

}

/// @nodoc


class TextContent implements EventContent {
  const TextContent(this.body);
  

 final  String body;

/// Create a copy of EventContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TextContentCopyWith<TextContent> get copyWith => _$TextContentCopyWithImpl<TextContent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TextContent&&(identical(other.body, body) || other.body == body));
}


@override
int get hashCode => Object.hash(runtimeType,body);

@override
String toString() {
  return 'EventContent.text(body: $body)';
}


}

/// @nodoc
abstract mixin class $TextContentCopyWith<$Res> implements $EventContentCopyWith<$Res> {
  factory $TextContentCopyWith(TextContent value, $Res Function(TextContent) _then) = _$TextContentCopyWithImpl;
@useResult
$Res call({
 String body
});




}
/// @nodoc
class _$TextContentCopyWithImpl<$Res>
    implements $TextContentCopyWith<$Res> {
  _$TextContentCopyWithImpl(this._self, this._then);

  final TextContent _self;
  final $Res Function(TextContent) _then;

/// Create a copy of EventContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? body = null,}) {
  return _then(TextContent(
null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ImageContent implements EventContent {
  const ImageContent({this.caption, required this.filename, required this.media, this.thumbnail, this.width, this.height, this.blurhash});
  

 final  String? caption;
 final  String filename;
 final  ChatMedia media;
/// Small preview; prefer it for display when set.
 final  ChatMedia? thumbnail;
 final  int? width;
 final  int? height;
 final  String? blurhash;

/// Create a copy of EventContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImageContentCopyWith<ImageContent> get copyWith => _$ImageContentCopyWithImpl<ImageContent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImageContent&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.media, media) || other.media == media)&&(identical(other.thumbnail, thumbnail) || other.thumbnail == thumbnail)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.blurhash, blurhash) || other.blurhash == blurhash));
}


@override
int get hashCode => Object.hash(runtimeType,caption,filename,media,thumbnail,width,height,blurhash);

@override
String toString() {
  return 'EventContent.image(caption: $caption, filename: $filename, media: $media, thumbnail: $thumbnail, width: $width, height: $height, blurhash: $blurhash)';
}


}

/// @nodoc
abstract mixin class $ImageContentCopyWith<$Res> implements $EventContentCopyWith<$Res> {
  factory $ImageContentCopyWith(ImageContent value, $Res Function(ImageContent) _then) = _$ImageContentCopyWithImpl;
@useResult
$Res call({
 String? caption, String filename, ChatMedia media, ChatMedia? thumbnail, int? width, int? height, String? blurhash
});




}
/// @nodoc
class _$ImageContentCopyWithImpl<$Res>
    implements $ImageContentCopyWith<$Res> {
  _$ImageContentCopyWithImpl(this._self, this._then);

  final ImageContent _self;
  final $Res Function(ImageContent) _then;

/// Create a copy of EventContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? caption = freezed,Object? filename = null,Object? media = null,Object? thumbnail = freezed,Object? width = freezed,Object? height = freezed,Object? blurhash = freezed,}) {
  return _then(ImageContent(
caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,filename: null == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String,media: null == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as ChatMedia,thumbnail: freezed == thumbnail ? _self.thumbnail : thumbnail // ignore: cast_nullable_to_non_nullable
as ChatMedia?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,blurhash: freezed == blurhash ? _self.blurhash : blurhash // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class VideoContent implements EventContent {
  const VideoContent({this.caption, required this.filename, required this.media});
  

 final  String? caption;
 final  String filename;
 final  ChatMedia media;

/// Create a copy of EventContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideoContentCopyWith<VideoContent> get copyWith => _$VideoContentCopyWithImpl<VideoContent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoContent&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.media, media) || other.media == media));
}


@override
int get hashCode => Object.hash(runtimeType,caption,filename,media);

@override
String toString() {
  return 'EventContent.video(caption: $caption, filename: $filename, media: $media)';
}


}

/// @nodoc
abstract mixin class $VideoContentCopyWith<$Res> implements $EventContentCopyWith<$Res> {
  factory $VideoContentCopyWith(VideoContent value, $Res Function(VideoContent) _then) = _$VideoContentCopyWithImpl;
@useResult
$Res call({
 String? caption, String filename, ChatMedia media
});




}
/// @nodoc
class _$VideoContentCopyWithImpl<$Res>
    implements $VideoContentCopyWith<$Res> {
  _$VideoContentCopyWithImpl(this._self, this._then);

  final VideoContent _self;
  final $Res Function(VideoContent) _then;

/// Create a copy of EventContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? caption = freezed,Object? filename = null,Object? media = null,}) {
  return _then(VideoContent(
caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,filename: null == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String,media: null == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as ChatMedia,
  ));
}


}

/// @nodoc


class AudioContent implements EventContent {
  const AudioContent({required this.filename, required this.media});
  

 final  String filename;
 final  ChatMedia media;

/// Create a copy of EventContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AudioContentCopyWith<AudioContent> get copyWith => _$AudioContentCopyWithImpl<AudioContent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AudioContent&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.media, media) || other.media == media));
}


@override
int get hashCode => Object.hash(runtimeType,filename,media);

@override
String toString() {
  return 'EventContent.audio(filename: $filename, media: $media)';
}


}

/// @nodoc
abstract mixin class $AudioContentCopyWith<$Res> implements $EventContentCopyWith<$Res> {
  factory $AudioContentCopyWith(AudioContent value, $Res Function(AudioContent) _then) = _$AudioContentCopyWithImpl;
@useResult
$Res call({
 String filename, ChatMedia media
});




}
/// @nodoc
class _$AudioContentCopyWithImpl<$Res>
    implements $AudioContentCopyWith<$Res> {
  _$AudioContentCopyWithImpl(this._self, this._then);

  final AudioContent _self;
  final $Res Function(AudioContent) _then;

/// Create a copy of EventContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? filename = null,Object? media = null,}) {
  return _then(AudioContent(
filename: null == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String,media: null == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as ChatMedia,
  ));
}


}

/// @nodoc


class FileContent implements EventContent {
  const FileContent({this.caption, required this.filename, required this.media, this.size});
  

 final  String? caption;
 final  String filename;
 final  ChatMedia media;
 final  int? size;

/// Create a copy of EventContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FileContentCopyWith<FileContent> get copyWith => _$FileContentCopyWithImpl<FileContent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileContent&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.media, media) || other.media == media)&&(identical(other.size, size) || other.size == size));
}


@override
int get hashCode => Object.hash(runtimeType,caption,filename,media,size);

@override
String toString() {
  return 'EventContent.file(caption: $caption, filename: $filename, media: $media, size: $size)';
}


}

/// @nodoc
abstract mixin class $FileContentCopyWith<$Res> implements $EventContentCopyWith<$Res> {
  factory $FileContentCopyWith(FileContent value, $Res Function(FileContent) _then) = _$FileContentCopyWithImpl;
@useResult
$Res call({
 String? caption, String filename, ChatMedia media, int? size
});




}
/// @nodoc
class _$FileContentCopyWithImpl<$Res>
    implements $FileContentCopyWith<$Res> {
  _$FileContentCopyWithImpl(this._self, this._then);

  final FileContent _self;
  final $Res Function(FileContent) _then;

/// Create a copy of EventContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? caption = freezed,Object? filename = null,Object? media = null,Object? size = freezed,}) {
  return _then(FileContent(
caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,filename: null == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String,media: null == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as ChatMedia,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class RedactedContent implements EventContent {
  const RedactedContent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RedactedContent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EventContent.redacted()';
}


}




/// @nodoc


class UnableToDecryptContent implements EventContent {
  const UnableToDecryptContent({this.reason = DecryptionFailure.unknown});
  

@JsonKey() final  DecryptionFailure reason;

/// Create a copy of EventContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnableToDecryptContentCopyWith<UnableToDecryptContent> get copyWith => _$UnableToDecryptContentCopyWithImpl<UnableToDecryptContent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnableToDecryptContent&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,reason);

@override
String toString() {
  return 'EventContent.unableToDecrypt(reason: $reason)';
}


}

/// @nodoc
abstract mixin class $UnableToDecryptContentCopyWith<$Res> implements $EventContentCopyWith<$Res> {
  factory $UnableToDecryptContentCopyWith(UnableToDecryptContent value, $Res Function(UnableToDecryptContent) _then) = _$UnableToDecryptContentCopyWithImpl;
@useResult
$Res call({
 DecryptionFailure reason
});




}
/// @nodoc
class _$UnableToDecryptContentCopyWithImpl<$Res>
    implements $UnableToDecryptContentCopyWith<$Res> {
  _$UnableToDecryptContentCopyWithImpl(this._self, this._then);

  final UnableToDecryptContent _self;
  final $Res Function(UnableToDecryptContent) _then;

/// Create a copy of EventContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reason = null,}) {
  return _then(UnableToDecryptContent(
reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as DecryptionFailure,
  ));
}


}

/// @nodoc


class MembershipContent implements EventContent {
  const MembershipContent({required this.userId, required this.change});
  

 final  String userId;
 final  MembershipChange change;

/// Create a copy of EventContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MembershipContentCopyWith<MembershipContent> get copyWith => _$MembershipContentCopyWithImpl<MembershipContent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MembershipContent&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.change, change) || other.change == change));
}


@override
int get hashCode => Object.hash(runtimeType,userId,change);

@override
String toString() {
  return 'EventContent.membership(userId: $userId, change: $change)';
}


}

/// @nodoc
abstract mixin class $MembershipContentCopyWith<$Res> implements $EventContentCopyWith<$Res> {
  factory $MembershipContentCopyWith(MembershipContent value, $Res Function(MembershipContent) _then) = _$MembershipContentCopyWithImpl;
@useResult
$Res call({
 String userId, MembershipChange change
});




}
/// @nodoc
class _$MembershipContentCopyWithImpl<$Res>
    implements $MembershipContentCopyWith<$Res> {
  _$MembershipContentCopyWithImpl(this._self, this._then);

  final MembershipContent _self;
  final $Res Function(MembershipContent) _then;

/// Create a copy of EventContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? change = null,}) {
  return _then(MembershipContent(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,change: null == change ? _self.change : change // ignore: cast_nullable_to_non_nullable
as MembershipChange,
  ));
}


}

/// @nodoc


class ProfileChangeContent implements EventContent {
  const ProfileChangeContent(this.userId);
  

 final  String userId;

/// Create a copy of EventContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileChangeContentCopyWith<ProfileChangeContent> get copyWith => _$ProfileChangeContentCopyWithImpl<ProfileChangeContent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileChangeContent&&(identical(other.userId, userId) || other.userId == userId));
}


@override
int get hashCode => Object.hash(runtimeType,userId);

@override
String toString() {
  return 'EventContent.profileChange(userId: $userId)';
}


}

/// @nodoc
abstract mixin class $ProfileChangeContentCopyWith<$Res> implements $EventContentCopyWith<$Res> {
  factory $ProfileChangeContentCopyWith(ProfileChangeContent value, $Res Function(ProfileChangeContent) _then) = _$ProfileChangeContentCopyWithImpl;
@useResult
$Res call({
 String userId
});




}
/// @nodoc
class _$ProfileChangeContentCopyWithImpl<$Res>
    implements $ProfileChangeContentCopyWith<$Res> {
  _$ProfileChangeContentCopyWithImpl(this._self, this._then);

  final ProfileChangeContent _self;
  final $Res Function(ProfileChangeContent) _then;

/// Create a copy of EventContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? userId = null,}) {
  return _then(ProfileChangeContent(
null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class RoomStateContent implements EventContent {
  const RoomStateContent(this.eventType);
  

 final  String eventType;

/// Create a copy of EventContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomStateContentCopyWith<RoomStateContent> get copyWith => _$RoomStateContentCopyWithImpl<RoomStateContent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomStateContent&&(identical(other.eventType, eventType) || other.eventType == eventType));
}


@override
int get hashCode => Object.hash(runtimeType,eventType);

@override
String toString() {
  return 'EventContent.roomState(eventType: $eventType)';
}


}

/// @nodoc
abstract mixin class $RoomStateContentCopyWith<$Res> implements $EventContentCopyWith<$Res> {
  factory $RoomStateContentCopyWith(RoomStateContent value, $Res Function(RoomStateContent) _then) = _$RoomStateContentCopyWithImpl;
@useResult
$Res call({
 String eventType
});




}
/// @nodoc
class _$RoomStateContentCopyWithImpl<$Res>
    implements $RoomStateContentCopyWith<$Res> {
  _$RoomStateContentCopyWithImpl(this._self, this._then);

  final RoomStateContent _self;
  final $Res Function(RoomStateContent) _then;

/// Create a copy of EventContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? eventType = null,}) {
  return _then(RoomStateContent(
null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class UnsupportedContent implements EventContent {
  const UnsupportedContent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnsupportedContent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EventContent.unsupported()';
}


}




/// @nodoc
mixin _$ReplyPreview {

 String get eventId;/// `null` until loaded (`TimelineController.loadReplyDetails`).
 ChatUser? get sender; MessagePreview? get preview;
/// Create a copy of ReplyPreview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReplyPreviewCopyWith<ReplyPreview> get copyWith => _$ReplyPreviewCopyWithImpl<ReplyPreview>(this as ReplyPreview, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReplyPreview&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.sender, sender) || other.sender == sender)&&(identical(other.preview, preview) || other.preview == preview));
}


@override
int get hashCode => Object.hash(runtimeType,eventId,sender,preview);

@override
String toString() {
  return 'ReplyPreview(eventId: $eventId, sender: $sender, preview: $preview)';
}


}

/// @nodoc
abstract mixin class $ReplyPreviewCopyWith<$Res>  {
  factory $ReplyPreviewCopyWith(ReplyPreview value, $Res Function(ReplyPreview) _then) = _$ReplyPreviewCopyWithImpl;
@useResult
$Res call({
 String eventId, ChatUser? sender, MessagePreview? preview
});


$ChatUserCopyWith<$Res>? get sender;$MessagePreviewCopyWith<$Res>? get preview;

}
/// @nodoc
class _$ReplyPreviewCopyWithImpl<$Res>
    implements $ReplyPreviewCopyWith<$Res> {
  _$ReplyPreviewCopyWithImpl(this._self, this._then);

  final ReplyPreview _self;
  final $Res Function(ReplyPreview) _then;

/// Create a copy of ReplyPreview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? eventId = null,Object? sender = freezed,Object? preview = freezed,}) {
  return _then(_self.copyWith(
eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,sender: freezed == sender ? _self.sender : sender // ignore: cast_nullable_to_non_nullable
as ChatUser?,preview: freezed == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as MessagePreview?,
  ));
}
/// Create a copy of ReplyPreview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatUserCopyWith<$Res>? get sender {
    if (_self.sender == null) {
    return null;
  }

  return $ChatUserCopyWith<$Res>(_self.sender!, (value) {
    return _then(_self.copyWith(sender: value));
  });
}/// Create a copy of ReplyPreview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MessagePreviewCopyWith<$Res>? get preview {
    if (_self.preview == null) {
    return null;
  }

  return $MessagePreviewCopyWith<$Res>(_self.preview!, (value) {
    return _then(_self.copyWith(preview: value));
  });
}
}


/// Adds pattern-matching-related methods to [ReplyPreview].
extension ReplyPreviewPatterns on ReplyPreview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReplyPreview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReplyPreview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReplyPreview value)  $default,){
final _that = this;
switch (_that) {
case _ReplyPreview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReplyPreview value)?  $default,){
final _that = this;
switch (_that) {
case _ReplyPreview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String eventId,  ChatUser? sender,  MessagePreview? preview)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReplyPreview() when $default != null:
return $default(_that.eventId,_that.sender,_that.preview);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String eventId,  ChatUser? sender,  MessagePreview? preview)  $default,) {final _that = this;
switch (_that) {
case _ReplyPreview():
return $default(_that.eventId,_that.sender,_that.preview);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String eventId,  ChatUser? sender,  MessagePreview? preview)?  $default,) {final _that = this;
switch (_that) {
case _ReplyPreview() when $default != null:
return $default(_that.eventId,_that.sender,_that.preview);case _:
  return null;

}
}

}

/// @nodoc


class _ReplyPreview implements ReplyPreview {
  const _ReplyPreview({required this.eventId, this.sender, this.preview});
  

@override final  String eventId;
/// `null` until loaded (`TimelineController.loadReplyDetails`).
@override final  ChatUser? sender;
@override final  MessagePreview? preview;

/// Create a copy of ReplyPreview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReplyPreviewCopyWith<_ReplyPreview> get copyWith => __$ReplyPreviewCopyWithImpl<_ReplyPreview>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReplyPreview&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.sender, sender) || other.sender == sender)&&(identical(other.preview, preview) || other.preview == preview));
}


@override
int get hashCode => Object.hash(runtimeType,eventId,sender,preview);

@override
String toString() {
  return 'ReplyPreview(eventId: $eventId, sender: $sender, preview: $preview)';
}


}

/// @nodoc
abstract mixin class _$ReplyPreviewCopyWith<$Res> implements $ReplyPreviewCopyWith<$Res> {
  factory _$ReplyPreviewCopyWith(_ReplyPreview value, $Res Function(_ReplyPreview) _then) = __$ReplyPreviewCopyWithImpl;
@override @useResult
$Res call({
 String eventId, ChatUser? sender, MessagePreview? preview
});


@override $ChatUserCopyWith<$Res>? get sender;@override $MessagePreviewCopyWith<$Res>? get preview;

}
/// @nodoc
class __$ReplyPreviewCopyWithImpl<$Res>
    implements _$ReplyPreviewCopyWith<$Res> {
  __$ReplyPreviewCopyWithImpl(this._self, this._then);

  final _ReplyPreview _self;
  final $Res Function(_ReplyPreview) _then;

/// Create a copy of ReplyPreview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? eventId = null,Object? sender = freezed,Object? preview = freezed,}) {
  return _then(_ReplyPreview(
eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,sender: freezed == sender ? _self.sender : sender // ignore: cast_nullable_to_non_nullable
as ChatUser?,preview: freezed == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as MessagePreview?,
  ));
}

/// Create a copy of ReplyPreview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatUserCopyWith<$Res>? get sender {
    if (_self.sender == null) {
    return null;
  }

  return $ChatUserCopyWith<$Res>(_self.sender!, (value) {
    return _then(_self.copyWith(sender: value));
  });
}/// Create a copy of ReplyPreview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MessagePreviewCopyWith<$Res>? get preview {
    if (_self.preview == null) {
    return null;
  }

  return $MessagePreviewCopyWith<$Res>(_self.preview!, (value) {
    return _then(_self.copyWith(preview: value));
  });
}
}

/// @nodoc
mixin _$Reaction {

 String get key; int get count; bool get byMe;
/// Create a copy of Reaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReactionCopyWith<Reaction> get copyWith => _$ReactionCopyWithImpl<Reaction>(this as Reaction, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Reaction&&(identical(other.key, key) || other.key == key)&&(identical(other.count, count) || other.count == count)&&(identical(other.byMe, byMe) || other.byMe == byMe));
}


@override
int get hashCode => Object.hash(runtimeType,key,count,byMe);

@override
String toString() {
  return 'Reaction(key: $key, count: $count, byMe: $byMe)';
}


}

/// @nodoc
abstract mixin class $ReactionCopyWith<$Res>  {
  factory $ReactionCopyWith(Reaction value, $Res Function(Reaction) _then) = _$ReactionCopyWithImpl;
@useResult
$Res call({
 String key, int count, bool byMe
});




}
/// @nodoc
class _$ReactionCopyWithImpl<$Res>
    implements $ReactionCopyWith<$Res> {
  _$ReactionCopyWithImpl(this._self, this._then);

  final Reaction _self;
  final $Res Function(Reaction) _then;

/// Create a copy of Reaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? count = null,Object? byMe = null,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,byMe: null == byMe ? _self.byMe : byMe // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Reaction].
extension ReactionPatterns on Reaction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Reaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Reaction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Reaction value)  $default,){
final _that = this;
switch (_that) {
case _Reaction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Reaction value)?  $default,){
final _that = this;
switch (_that) {
case _Reaction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  int count,  bool byMe)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Reaction() when $default != null:
return $default(_that.key,_that.count,_that.byMe);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  int count,  bool byMe)  $default,) {final _that = this;
switch (_that) {
case _Reaction():
return $default(_that.key,_that.count,_that.byMe);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  int count,  bool byMe)?  $default,) {final _that = this;
switch (_that) {
case _Reaction() when $default != null:
return $default(_that.key,_that.count,_that.byMe);case _:
  return null;

}
}

}

/// @nodoc


class _Reaction implements Reaction {
  const _Reaction({required this.key, required this.count, required this.byMe});
  

@override final  String key;
@override final  int count;
@override final  bool byMe;

/// Create a copy of Reaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReactionCopyWith<_Reaction> get copyWith => __$ReactionCopyWithImpl<_Reaction>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Reaction&&(identical(other.key, key) || other.key == key)&&(identical(other.count, count) || other.count == count)&&(identical(other.byMe, byMe) || other.byMe == byMe));
}


@override
int get hashCode => Object.hash(runtimeType,key,count,byMe);

@override
String toString() {
  return 'Reaction(key: $key, count: $count, byMe: $byMe)';
}


}

/// @nodoc
abstract mixin class _$ReactionCopyWith<$Res> implements $ReactionCopyWith<$Res> {
  factory _$ReactionCopyWith(_Reaction value, $Res Function(_Reaction) _then) = __$ReactionCopyWithImpl;
@override @useResult
$Res call({
 String key, int count, bool byMe
});




}
/// @nodoc
class __$ReactionCopyWithImpl<$Res>
    implements _$ReactionCopyWith<$Res> {
  __$ReactionCopyWithImpl(this._self, this._then);

  final _Reaction _self;
  final $Res Function(_Reaction) _then;

/// Create a copy of Reaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? count = null,Object? byMe = null,}) {
  return _then(_Reaction(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,byMe: null == byMe ? _self.byMe : byMe // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$ThreadSummary {

 int get replyCount; ChatUser? get latestSender; MessagePreview? get latestPreview;
/// Create a copy of ThreadSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ThreadSummaryCopyWith<ThreadSummary> get copyWith => _$ThreadSummaryCopyWithImpl<ThreadSummary>(this as ThreadSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThreadSummary&&(identical(other.replyCount, replyCount) || other.replyCount == replyCount)&&(identical(other.latestSender, latestSender) || other.latestSender == latestSender)&&(identical(other.latestPreview, latestPreview) || other.latestPreview == latestPreview));
}


@override
int get hashCode => Object.hash(runtimeType,replyCount,latestSender,latestPreview);

@override
String toString() {
  return 'ThreadSummary(replyCount: $replyCount, latestSender: $latestSender, latestPreview: $latestPreview)';
}


}

/// @nodoc
abstract mixin class $ThreadSummaryCopyWith<$Res>  {
  factory $ThreadSummaryCopyWith(ThreadSummary value, $Res Function(ThreadSummary) _then) = _$ThreadSummaryCopyWithImpl;
@useResult
$Res call({
 int replyCount, ChatUser? latestSender, MessagePreview? latestPreview
});


$ChatUserCopyWith<$Res>? get latestSender;$MessagePreviewCopyWith<$Res>? get latestPreview;

}
/// @nodoc
class _$ThreadSummaryCopyWithImpl<$Res>
    implements $ThreadSummaryCopyWith<$Res> {
  _$ThreadSummaryCopyWithImpl(this._self, this._then);

  final ThreadSummary _self;
  final $Res Function(ThreadSummary) _then;

/// Create a copy of ThreadSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? replyCount = null,Object? latestSender = freezed,Object? latestPreview = freezed,}) {
  return _then(_self.copyWith(
replyCount: null == replyCount ? _self.replyCount : replyCount // ignore: cast_nullable_to_non_nullable
as int,latestSender: freezed == latestSender ? _self.latestSender : latestSender // ignore: cast_nullable_to_non_nullable
as ChatUser?,latestPreview: freezed == latestPreview ? _self.latestPreview : latestPreview // ignore: cast_nullable_to_non_nullable
as MessagePreview?,
  ));
}
/// Create a copy of ThreadSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatUserCopyWith<$Res>? get latestSender {
    if (_self.latestSender == null) {
    return null;
  }

  return $ChatUserCopyWith<$Res>(_self.latestSender!, (value) {
    return _then(_self.copyWith(latestSender: value));
  });
}/// Create a copy of ThreadSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MessagePreviewCopyWith<$Res>? get latestPreview {
    if (_self.latestPreview == null) {
    return null;
  }

  return $MessagePreviewCopyWith<$Res>(_self.latestPreview!, (value) {
    return _then(_self.copyWith(latestPreview: value));
  });
}
}


/// Adds pattern-matching-related methods to [ThreadSummary].
extension ThreadSummaryPatterns on ThreadSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ThreadSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ThreadSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ThreadSummary value)  $default,){
final _that = this;
switch (_that) {
case _ThreadSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ThreadSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ThreadSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int replyCount,  ChatUser? latestSender,  MessagePreview? latestPreview)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ThreadSummary() when $default != null:
return $default(_that.replyCount,_that.latestSender,_that.latestPreview);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int replyCount,  ChatUser? latestSender,  MessagePreview? latestPreview)  $default,) {final _that = this;
switch (_that) {
case _ThreadSummary():
return $default(_that.replyCount,_that.latestSender,_that.latestPreview);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int replyCount,  ChatUser? latestSender,  MessagePreview? latestPreview)?  $default,) {final _that = this;
switch (_that) {
case _ThreadSummary() when $default != null:
return $default(_that.replyCount,_that.latestSender,_that.latestPreview);case _:
  return null;

}
}

}

/// @nodoc


class _ThreadSummary implements ThreadSummary {
  const _ThreadSummary({required this.replyCount, this.latestSender, this.latestPreview});
  

@override final  int replyCount;
@override final  ChatUser? latestSender;
@override final  MessagePreview? latestPreview;

/// Create a copy of ThreadSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ThreadSummaryCopyWith<_ThreadSummary> get copyWith => __$ThreadSummaryCopyWithImpl<_ThreadSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ThreadSummary&&(identical(other.replyCount, replyCount) || other.replyCount == replyCount)&&(identical(other.latestSender, latestSender) || other.latestSender == latestSender)&&(identical(other.latestPreview, latestPreview) || other.latestPreview == latestPreview));
}


@override
int get hashCode => Object.hash(runtimeType,replyCount,latestSender,latestPreview);

@override
String toString() {
  return 'ThreadSummary(replyCount: $replyCount, latestSender: $latestSender, latestPreview: $latestPreview)';
}


}

/// @nodoc
abstract mixin class _$ThreadSummaryCopyWith<$Res> implements $ThreadSummaryCopyWith<$Res> {
  factory _$ThreadSummaryCopyWith(_ThreadSummary value, $Res Function(_ThreadSummary) _then) = __$ThreadSummaryCopyWithImpl;
@override @useResult
$Res call({
 int replyCount, ChatUser? latestSender, MessagePreview? latestPreview
});


@override $ChatUserCopyWith<$Res>? get latestSender;@override $MessagePreviewCopyWith<$Res>? get latestPreview;

}
/// @nodoc
class __$ThreadSummaryCopyWithImpl<$Res>
    implements _$ThreadSummaryCopyWith<$Res> {
  __$ThreadSummaryCopyWithImpl(this._self, this._then);

  final _ThreadSummary _self;
  final $Res Function(_ThreadSummary) _then;

/// Create a copy of ThreadSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? replyCount = null,Object? latestSender = freezed,Object? latestPreview = freezed,}) {
  return _then(_ThreadSummary(
replyCount: null == replyCount ? _self.replyCount : replyCount // ignore: cast_nullable_to_non_nullable
as int,latestSender: freezed == latestSender ? _self.latestSender : latestSender // ignore: cast_nullable_to_non_nullable
as ChatUser?,latestPreview: freezed == latestPreview ? _self.latestPreview : latestPreview // ignore: cast_nullable_to_non_nullable
as MessagePreview?,
  ));
}

/// Create a copy of ThreadSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatUserCopyWith<$Res>? get latestSender {
    if (_self.latestSender == null) {
    return null;
  }

  return $ChatUserCopyWith<$Res>(_self.latestSender!, (value) {
    return _then(_self.copyWith(latestSender: value));
  });
}/// Create a copy of ThreadSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MessagePreviewCopyWith<$Res>? get latestPreview {
    if (_self.latestPreview == null) {
    return null;
  }

  return $MessagePreviewCopyWith<$Res>(_self.latestPreview!, (value) {
    return _then(_self.copyWith(latestPreview: value));
  });
}
}

/// @nodoc
mixin _$EventItem {

 EventKey get key;/// Not unique across items: the SDK may keep a local echo next to its
/// remote echo for a while. Key widgets by `TimelineItem.id`.
 String? get eventId; ChatUser get sender; DateTime get timestamp; bool get isOwn; bool get canEdit; bool get canReply; SendState get sendState; EventContent get content; ReplyPreview? get replyTo; List<Reaction> get reactions; bool get isEdited;/// Root event id when this message belongs to a thread.
 String? get threadRoot;/// Set on thread roots.
 ThreadSummary? get thread;
/// Create a copy of EventItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventItemCopyWith<EventItem> get copyWith => _$EventItemCopyWithImpl<EventItem>(this as EventItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventItem&&(identical(other.key, key) || other.key == key)&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.sender, sender) || other.sender == sender)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.isOwn, isOwn) || other.isOwn == isOwn)&&(identical(other.canEdit, canEdit) || other.canEdit == canEdit)&&(identical(other.canReply, canReply) || other.canReply == canReply)&&(identical(other.sendState, sendState) || other.sendState == sendState)&&(identical(other.content, content) || other.content == content)&&(identical(other.replyTo, replyTo) || other.replyTo == replyTo)&&const DeepCollectionEquality().equals(other.reactions, reactions)&&(identical(other.isEdited, isEdited) || other.isEdited == isEdited)&&(identical(other.threadRoot, threadRoot) || other.threadRoot == threadRoot)&&(identical(other.thread, thread) || other.thread == thread));
}


@override
int get hashCode => Object.hash(runtimeType,key,eventId,sender,timestamp,isOwn,canEdit,canReply,sendState,content,replyTo,const DeepCollectionEquality().hash(reactions),isEdited,threadRoot,thread);

@override
String toString() {
  return 'EventItem(key: $key, eventId: $eventId, sender: $sender, timestamp: $timestamp, isOwn: $isOwn, canEdit: $canEdit, canReply: $canReply, sendState: $sendState, content: $content, replyTo: $replyTo, reactions: $reactions, isEdited: $isEdited, threadRoot: $threadRoot, thread: $thread)';
}


}

/// @nodoc
abstract mixin class $EventItemCopyWith<$Res>  {
  factory $EventItemCopyWith(EventItem value, $Res Function(EventItem) _then) = _$EventItemCopyWithImpl;
@useResult
$Res call({
 EventKey key, String? eventId, ChatUser sender, DateTime timestamp, bool isOwn, bool canEdit, bool canReply, SendState sendState, EventContent content, ReplyPreview? replyTo, List<Reaction> reactions, bool isEdited, String? threadRoot, ThreadSummary? thread
});


$EventKeyCopyWith<$Res> get key;$ChatUserCopyWith<$Res> get sender;$SendStateCopyWith<$Res> get sendState;$EventContentCopyWith<$Res> get content;$ReplyPreviewCopyWith<$Res>? get replyTo;$ThreadSummaryCopyWith<$Res>? get thread;

}
/// @nodoc
class _$EventItemCopyWithImpl<$Res>
    implements $EventItemCopyWith<$Res> {
  _$EventItemCopyWithImpl(this._self, this._then);

  final EventItem _self;
  final $Res Function(EventItem) _then;

/// Create a copy of EventItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? eventId = freezed,Object? sender = null,Object? timestamp = null,Object? isOwn = null,Object? canEdit = null,Object? canReply = null,Object? sendState = null,Object? content = null,Object? replyTo = freezed,Object? reactions = null,Object? isEdited = null,Object? threadRoot = freezed,Object? thread = freezed,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as EventKey,eventId: freezed == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String?,sender: null == sender ? _self.sender : sender // ignore: cast_nullable_to_non_nullable
as ChatUser,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,isOwn: null == isOwn ? _self.isOwn : isOwn // ignore: cast_nullable_to_non_nullable
as bool,canEdit: null == canEdit ? _self.canEdit : canEdit // ignore: cast_nullable_to_non_nullable
as bool,canReply: null == canReply ? _self.canReply : canReply // ignore: cast_nullable_to_non_nullable
as bool,sendState: null == sendState ? _self.sendState : sendState // ignore: cast_nullable_to_non_nullable
as SendState,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as EventContent,replyTo: freezed == replyTo ? _self.replyTo : replyTo // ignore: cast_nullable_to_non_nullable
as ReplyPreview?,reactions: null == reactions ? _self.reactions : reactions // ignore: cast_nullable_to_non_nullable
as List<Reaction>,isEdited: null == isEdited ? _self.isEdited : isEdited // ignore: cast_nullable_to_non_nullable
as bool,threadRoot: freezed == threadRoot ? _self.threadRoot : threadRoot // ignore: cast_nullable_to_non_nullable
as String?,thread: freezed == thread ? _self.thread : thread // ignore: cast_nullable_to_non_nullable
as ThreadSummary?,
  ));
}
/// Create a copy of EventItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventKeyCopyWith<$Res> get key {
  
  return $EventKeyCopyWith<$Res>(_self.key, (value) {
    return _then(_self.copyWith(key: value));
  });
}/// Create a copy of EventItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatUserCopyWith<$Res> get sender {
  
  return $ChatUserCopyWith<$Res>(_self.sender, (value) {
    return _then(_self.copyWith(sender: value));
  });
}/// Create a copy of EventItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SendStateCopyWith<$Res> get sendState {
  
  return $SendStateCopyWith<$Res>(_self.sendState, (value) {
    return _then(_self.copyWith(sendState: value));
  });
}/// Create a copy of EventItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventContentCopyWith<$Res> get content {
  
  return $EventContentCopyWith<$Res>(_self.content, (value) {
    return _then(_self.copyWith(content: value));
  });
}/// Create a copy of EventItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReplyPreviewCopyWith<$Res>? get replyTo {
    if (_self.replyTo == null) {
    return null;
  }

  return $ReplyPreviewCopyWith<$Res>(_self.replyTo!, (value) {
    return _then(_self.copyWith(replyTo: value));
  });
}/// Create a copy of EventItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ThreadSummaryCopyWith<$Res>? get thread {
    if (_self.thread == null) {
    return null;
  }

  return $ThreadSummaryCopyWith<$Res>(_self.thread!, (value) {
    return _then(_self.copyWith(thread: value));
  });
}
}


/// Adds pattern-matching-related methods to [EventItem].
extension EventItemPatterns on EventItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventItem value)  $default,){
final _that = this;
switch (_that) {
case _EventItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventItem value)?  $default,){
final _that = this;
switch (_that) {
case _EventItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EventKey key,  String? eventId,  ChatUser sender,  DateTime timestamp,  bool isOwn,  bool canEdit,  bool canReply,  SendState sendState,  EventContent content,  ReplyPreview? replyTo,  List<Reaction> reactions,  bool isEdited,  String? threadRoot,  ThreadSummary? thread)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventItem() when $default != null:
return $default(_that.key,_that.eventId,_that.sender,_that.timestamp,_that.isOwn,_that.canEdit,_that.canReply,_that.sendState,_that.content,_that.replyTo,_that.reactions,_that.isEdited,_that.threadRoot,_that.thread);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EventKey key,  String? eventId,  ChatUser sender,  DateTime timestamp,  bool isOwn,  bool canEdit,  bool canReply,  SendState sendState,  EventContent content,  ReplyPreview? replyTo,  List<Reaction> reactions,  bool isEdited,  String? threadRoot,  ThreadSummary? thread)  $default,) {final _that = this;
switch (_that) {
case _EventItem():
return $default(_that.key,_that.eventId,_that.sender,_that.timestamp,_that.isOwn,_that.canEdit,_that.canReply,_that.sendState,_that.content,_that.replyTo,_that.reactions,_that.isEdited,_that.threadRoot,_that.thread);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EventKey key,  String? eventId,  ChatUser sender,  DateTime timestamp,  bool isOwn,  bool canEdit,  bool canReply,  SendState sendState,  EventContent content,  ReplyPreview? replyTo,  List<Reaction> reactions,  bool isEdited,  String? threadRoot,  ThreadSummary? thread)?  $default,) {final _that = this;
switch (_that) {
case _EventItem() when $default != null:
return $default(_that.key,_that.eventId,_that.sender,_that.timestamp,_that.isOwn,_that.canEdit,_that.canReply,_that.sendState,_that.content,_that.replyTo,_that.reactions,_that.isEdited,_that.threadRoot,_that.thread);case _:
  return null;

}
}

}

/// @nodoc


class _EventItem implements EventItem {
  const _EventItem({required this.key, this.eventId, required this.sender, required this.timestamp, required this.isOwn, required this.canEdit, required this.canReply, required this.sendState, required this.content, this.replyTo, final  List<Reaction> reactions = const <Reaction>[], required this.isEdited, this.threadRoot, this.thread}): _reactions = reactions;
  

@override final  EventKey key;
/// Not unique across items: the SDK may keep a local echo next to its
/// remote echo for a while. Key widgets by `TimelineItem.id`.
@override final  String? eventId;
@override final  ChatUser sender;
@override final  DateTime timestamp;
@override final  bool isOwn;
@override final  bool canEdit;
@override final  bool canReply;
@override final  SendState sendState;
@override final  EventContent content;
@override final  ReplyPreview? replyTo;
 final  List<Reaction> _reactions;
@override@JsonKey() List<Reaction> get reactions {
  if (_reactions is EqualUnmodifiableListView) return _reactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reactions);
}

@override final  bool isEdited;
/// Root event id when this message belongs to a thread.
@override final  String? threadRoot;
/// Set on thread roots.
@override final  ThreadSummary? thread;

/// Create a copy of EventItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventItemCopyWith<_EventItem> get copyWith => __$EventItemCopyWithImpl<_EventItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventItem&&(identical(other.key, key) || other.key == key)&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.sender, sender) || other.sender == sender)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.isOwn, isOwn) || other.isOwn == isOwn)&&(identical(other.canEdit, canEdit) || other.canEdit == canEdit)&&(identical(other.canReply, canReply) || other.canReply == canReply)&&(identical(other.sendState, sendState) || other.sendState == sendState)&&(identical(other.content, content) || other.content == content)&&(identical(other.replyTo, replyTo) || other.replyTo == replyTo)&&const DeepCollectionEquality().equals(other._reactions, _reactions)&&(identical(other.isEdited, isEdited) || other.isEdited == isEdited)&&(identical(other.threadRoot, threadRoot) || other.threadRoot == threadRoot)&&(identical(other.thread, thread) || other.thread == thread));
}


@override
int get hashCode => Object.hash(runtimeType,key,eventId,sender,timestamp,isOwn,canEdit,canReply,sendState,content,replyTo,const DeepCollectionEquality().hash(_reactions),isEdited,threadRoot,thread);

@override
String toString() {
  return 'EventItem(key: $key, eventId: $eventId, sender: $sender, timestamp: $timestamp, isOwn: $isOwn, canEdit: $canEdit, canReply: $canReply, sendState: $sendState, content: $content, replyTo: $replyTo, reactions: $reactions, isEdited: $isEdited, threadRoot: $threadRoot, thread: $thread)';
}


}

/// @nodoc
abstract mixin class _$EventItemCopyWith<$Res> implements $EventItemCopyWith<$Res> {
  factory _$EventItemCopyWith(_EventItem value, $Res Function(_EventItem) _then) = __$EventItemCopyWithImpl;
@override @useResult
$Res call({
 EventKey key, String? eventId, ChatUser sender, DateTime timestamp, bool isOwn, bool canEdit, bool canReply, SendState sendState, EventContent content, ReplyPreview? replyTo, List<Reaction> reactions, bool isEdited, String? threadRoot, ThreadSummary? thread
});


@override $EventKeyCopyWith<$Res> get key;@override $ChatUserCopyWith<$Res> get sender;@override $SendStateCopyWith<$Res> get sendState;@override $EventContentCopyWith<$Res> get content;@override $ReplyPreviewCopyWith<$Res>? get replyTo;@override $ThreadSummaryCopyWith<$Res>? get thread;

}
/// @nodoc
class __$EventItemCopyWithImpl<$Res>
    implements _$EventItemCopyWith<$Res> {
  __$EventItemCopyWithImpl(this._self, this._then);

  final _EventItem _self;
  final $Res Function(_EventItem) _then;

/// Create a copy of EventItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? eventId = freezed,Object? sender = null,Object? timestamp = null,Object? isOwn = null,Object? canEdit = null,Object? canReply = null,Object? sendState = null,Object? content = null,Object? replyTo = freezed,Object? reactions = null,Object? isEdited = null,Object? threadRoot = freezed,Object? thread = freezed,}) {
  return _then(_EventItem(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as EventKey,eventId: freezed == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String?,sender: null == sender ? _self.sender : sender // ignore: cast_nullable_to_non_nullable
as ChatUser,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,isOwn: null == isOwn ? _self.isOwn : isOwn // ignore: cast_nullable_to_non_nullable
as bool,canEdit: null == canEdit ? _self.canEdit : canEdit // ignore: cast_nullable_to_non_nullable
as bool,canReply: null == canReply ? _self.canReply : canReply // ignore: cast_nullable_to_non_nullable
as bool,sendState: null == sendState ? _self.sendState : sendState // ignore: cast_nullable_to_non_nullable
as SendState,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as EventContent,replyTo: freezed == replyTo ? _self.replyTo : replyTo // ignore: cast_nullable_to_non_nullable
as ReplyPreview?,reactions: null == reactions ? _self._reactions : reactions // ignore: cast_nullable_to_non_nullable
as List<Reaction>,isEdited: null == isEdited ? _self.isEdited : isEdited // ignore: cast_nullable_to_non_nullable
as bool,threadRoot: freezed == threadRoot ? _self.threadRoot : threadRoot // ignore: cast_nullable_to_non_nullable
as String?,thread: freezed == thread ? _self.thread : thread // ignore: cast_nullable_to_non_nullable
as ThreadSummary?,
  ));
}

/// Create a copy of EventItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventKeyCopyWith<$Res> get key {
  
  return $EventKeyCopyWith<$Res>(_self.key, (value) {
    return _then(_self.copyWith(key: value));
  });
}/// Create a copy of EventItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatUserCopyWith<$Res> get sender {
  
  return $ChatUserCopyWith<$Res>(_self.sender, (value) {
    return _then(_self.copyWith(sender: value));
  });
}/// Create a copy of EventItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SendStateCopyWith<$Res> get sendState {
  
  return $SendStateCopyWith<$Res>(_self.sendState, (value) {
    return _then(_self.copyWith(sendState: value));
  });
}/// Create a copy of EventItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventContentCopyWith<$Res> get content {
  
  return $EventContentCopyWith<$Res>(_self.content, (value) {
    return _then(_self.copyWith(content: value));
  });
}/// Create a copy of EventItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReplyPreviewCopyWith<$Res>? get replyTo {
    if (_self.replyTo == null) {
    return null;
  }

  return $ReplyPreviewCopyWith<$Res>(_self.replyTo!, (value) {
    return _then(_self.copyWith(replyTo: value));
  });
}/// Create a copy of EventItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ThreadSummaryCopyWith<$Res>? get thread {
    if (_self.thread == null) {
    return null;
  }

  return $ThreadSummaryCopyWith<$Res>(_self.thread!, (value) {
    return _then(_self.copyWith(thread: value));
  });
}
}

/// @nodoc
mixin _$TimelineItem {

 String get id;
/// Create a copy of TimelineItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimelineItemCopyWith<TimelineItem> get copyWith => _$TimelineItemCopyWithImpl<TimelineItem>(this as TimelineItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineItem&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'TimelineItem(id: $id)';
}


}

/// @nodoc
abstract mixin class $TimelineItemCopyWith<$Res>  {
  factory $TimelineItemCopyWith(TimelineItem value, $Res Function(TimelineItem) _then) = _$TimelineItemCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class _$TimelineItemCopyWithImpl<$Res>
    implements $TimelineItemCopyWith<$Res> {
  _$TimelineItemCopyWithImpl(this._self, this._then);

  final TimelineItem _self;
  final $Res Function(TimelineItem) _then;

/// Create a copy of TimelineItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TimelineItem].
extension TimelineItemPatterns on TimelineItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( EventTimelineItem value)?  event,TResult Function( DateDividerItem value)?  dateDivider,TResult Function( ReadMarkerItem value)?  readMarker,TResult Function( TimelineStartItem value)?  timelineStart,required TResult orElse(),}){
final _that = this;
switch (_that) {
case EventTimelineItem() when event != null:
return event(_that);case DateDividerItem() when dateDivider != null:
return dateDivider(_that);case ReadMarkerItem() when readMarker != null:
return readMarker(_that);case TimelineStartItem() when timelineStart != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( EventTimelineItem value)  event,required TResult Function( DateDividerItem value)  dateDivider,required TResult Function( ReadMarkerItem value)  readMarker,required TResult Function( TimelineStartItem value)  timelineStart,}){
final _that = this;
switch (_that) {
case EventTimelineItem():
return event(_that);case DateDividerItem():
return dateDivider(_that);case ReadMarkerItem():
return readMarker(_that);case TimelineStartItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( EventTimelineItem value)?  event,TResult? Function( DateDividerItem value)?  dateDivider,TResult? Function( ReadMarkerItem value)?  readMarker,TResult? Function( TimelineStartItem value)?  timelineStart,}){
final _that = this;
switch (_that) {
case EventTimelineItem() when event != null:
return event(_that);case DateDividerItem() when dateDivider != null:
return dateDivider(_that);case ReadMarkerItem() when readMarker != null:
return readMarker(_that);case TimelineStartItem() when timelineStart != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String id,  EventItem event)?  event,TResult Function( String id,  DateTime date)?  dateDivider,TResult Function( String id)?  readMarker,TResult Function( String id)?  timelineStart,required TResult orElse(),}) {final _that = this;
switch (_that) {
case EventTimelineItem() when event != null:
return event(_that.id,_that.event);case DateDividerItem() when dateDivider != null:
return dateDivider(_that.id,_that.date);case ReadMarkerItem() when readMarker != null:
return readMarker(_that.id);case TimelineStartItem() when timelineStart != null:
return timelineStart(_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String id,  EventItem event)  event,required TResult Function( String id,  DateTime date)  dateDivider,required TResult Function( String id)  readMarker,required TResult Function( String id)  timelineStart,}) {final _that = this;
switch (_that) {
case EventTimelineItem():
return event(_that.id,_that.event);case DateDividerItem():
return dateDivider(_that.id,_that.date);case ReadMarkerItem():
return readMarker(_that.id);case TimelineStartItem():
return timelineStart(_that.id);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String id,  EventItem event)?  event,TResult? Function( String id,  DateTime date)?  dateDivider,TResult? Function( String id)?  readMarker,TResult? Function( String id)?  timelineStart,}) {final _that = this;
switch (_that) {
case EventTimelineItem() when event != null:
return event(_that.id,_that.event);case DateDividerItem() when dateDivider != null:
return dateDivider(_that.id,_that.date);case ReadMarkerItem() when readMarker != null:
return readMarker(_that.id);case TimelineStartItem() when timelineStart != null:
return timelineStart(_that.id);case _:
  return null;

}
}

}

/// @nodoc


class EventTimelineItem implements TimelineItem {
  const EventTimelineItem({required this.id, required this.event});
  

@override final  String id;
 final  EventItem event;

/// Create a copy of TimelineItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventTimelineItemCopyWith<EventTimelineItem> get copyWith => _$EventTimelineItemCopyWithImpl<EventTimelineItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventTimelineItem&&(identical(other.id, id) || other.id == id)&&(identical(other.event, event) || other.event == event));
}


@override
int get hashCode => Object.hash(runtimeType,id,event);

@override
String toString() {
  return 'TimelineItem.event(id: $id, event: $event)';
}


}

/// @nodoc
abstract mixin class $EventTimelineItemCopyWith<$Res> implements $TimelineItemCopyWith<$Res> {
  factory $EventTimelineItemCopyWith(EventTimelineItem value, $Res Function(EventTimelineItem) _then) = _$EventTimelineItemCopyWithImpl;
@override @useResult
$Res call({
 String id, EventItem event
});


$EventItemCopyWith<$Res> get event;

}
/// @nodoc
class _$EventTimelineItemCopyWithImpl<$Res>
    implements $EventTimelineItemCopyWith<$Res> {
  _$EventTimelineItemCopyWithImpl(this._self, this._then);

  final EventTimelineItem _self;
  final $Res Function(EventTimelineItem) _then;

/// Create a copy of TimelineItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? event = null,}) {
  return _then(EventTimelineItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as EventItem,
  ));
}

/// Create a copy of TimelineItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventItemCopyWith<$Res> get event {
  
  return $EventItemCopyWith<$Res>(_self.event, (value) {
    return _then(_self.copyWith(event: value));
  });
}
}

/// @nodoc


class DateDividerItem implements TimelineItem {
  const DateDividerItem({required this.id, required this.date});
  

@override final  String id;
 final  DateTime date;

/// Create a copy of TimelineItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DateDividerItemCopyWith<DateDividerItem> get copyWith => _$DateDividerItemCopyWithImpl<DateDividerItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DateDividerItem&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date));
}


@override
int get hashCode => Object.hash(runtimeType,id,date);

@override
String toString() {
  return 'TimelineItem.dateDivider(id: $id, date: $date)';
}


}

/// @nodoc
abstract mixin class $DateDividerItemCopyWith<$Res> implements $TimelineItemCopyWith<$Res> {
  factory $DateDividerItemCopyWith(DateDividerItem value, $Res Function(DateDividerItem) _then) = _$DateDividerItemCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime date
});




}
/// @nodoc
class _$DateDividerItemCopyWithImpl<$Res>
    implements $DateDividerItemCopyWith<$Res> {
  _$DateDividerItemCopyWithImpl(this._self, this._then);

  final DateDividerItem _self;
  final $Res Function(DateDividerItem) _then;

/// Create a copy of TimelineItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? date = null,}) {
  return _then(DateDividerItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc


class ReadMarkerItem implements TimelineItem {
  const ReadMarkerItem({required this.id});
  

@override final  String id;

/// Create a copy of TimelineItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReadMarkerItemCopyWith<ReadMarkerItem> get copyWith => _$ReadMarkerItemCopyWithImpl<ReadMarkerItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReadMarkerItem&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'TimelineItem.readMarker(id: $id)';
}


}

/// @nodoc
abstract mixin class $ReadMarkerItemCopyWith<$Res> implements $TimelineItemCopyWith<$Res> {
  factory $ReadMarkerItemCopyWith(ReadMarkerItem value, $Res Function(ReadMarkerItem) _then) = _$ReadMarkerItemCopyWithImpl;
@override @useResult
$Res call({
 String id
});




}
/// @nodoc
class _$ReadMarkerItemCopyWithImpl<$Res>
    implements $ReadMarkerItemCopyWith<$Res> {
  _$ReadMarkerItemCopyWithImpl(this._self, this._then);

  final ReadMarkerItem _self;
  final $Res Function(ReadMarkerItem) _then;

/// Create a copy of TimelineItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(ReadMarkerItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class TimelineStartItem implements TimelineItem {
  const TimelineStartItem({required this.id});
  

@override final  String id;

/// Create a copy of TimelineItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimelineStartItemCopyWith<TimelineStartItem> get copyWith => _$TimelineStartItemCopyWithImpl<TimelineStartItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineStartItem&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'TimelineItem.timelineStart(id: $id)';
}


}

/// @nodoc
abstract mixin class $TimelineStartItemCopyWith<$Res> implements $TimelineItemCopyWith<$Res> {
  factory $TimelineStartItemCopyWith(TimelineStartItem value, $Res Function(TimelineStartItem) _then) = _$TimelineStartItemCopyWithImpl;
@override @useResult
$Res call({
 String id
});




}
/// @nodoc
class _$TimelineStartItemCopyWithImpl<$Res>
    implements $TimelineStartItemCopyWith<$Res> {
  _$TimelineStartItemCopyWithImpl(this._self, this._then);

  final TimelineStartItem _self;
  final $Res Function(TimelineStartItem) _then;

/// Create a copy of TimelineItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(TimelineStartItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ThreadEvent {

 String get eventId; ChatUser get sender; DateTime get timestamp; bool get isOwn;/// `null` while the content is unknown (e.g. not yet decrypted).
 MessagePreview? get preview;
/// Create a copy of ThreadEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ThreadEventCopyWith<ThreadEvent> get copyWith => _$ThreadEventCopyWithImpl<ThreadEvent>(this as ThreadEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThreadEvent&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.sender, sender) || other.sender == sender)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.isOwn, isOwn) || other.isOwn == isOwn)&&(identical(other.preview, preview) || other.preview == preview));
}


@override
int get hashCode => Object.hash(runtimeType,eventId,sender,timestamp,isOwn,preview);

@override
String toString() {
  return 'ThreadEvent(eventId: $eventId, sender: $sender, timestamp: $timestamp, isOwn: $isOwn, preview: $preview)';
}


}

/// @nodoc
abstract mixin class $ThreadEventCopyWith<$Res>  {
  factory $ThreadEventCopyWith(ThreadEvent value, $Res Function(ThreadEvent) _then) = _$ThreadEventCopyWithImpl;
@useResult
$Res call({
 String eventId, ChatUser sender, DateTime timestamp, bool isOwn, MessagePreview? preview
});


$ChatUserCopyWith<$Res> get sender;$MessagePreviewCopyWith<$Res>? get preview;

}
/// @nodoc
class _$ThreadEventCopyWithImpl<$Res>
    implements $ThreadEventCopyWith<$Res> {
  _$ThreadEventCopyWithImpl(this._self, this._then);

  final ThreadEvent _self;
  final $Res Function(ThreadEvent) _then;

/// Create a copy of ThreadEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? eventId = null,Object? sender = null,Object? timestamp = null,Object? isOwn = null,Object? preview = freezed,}) {
  return _then(_self.copyWith(
eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,sender: null == sender ? _self.sender : sender // ignore: cast_nullable_to_non_nullable
as ChatUser,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,isOwn: null == isOwn ? _self.isOwn : isOwn // ignore: cast_nullable_to_non_nullable
as bool,preview: freezed == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as MessagePreview?,
  ));
}
/// Create a copy of ThreadEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatUserCopyWith<$Res> get sender {
  
  return $ChatUserCopyWith<$Res>(_self.sender, (value) {
    return _then(_self.copyWith(sender: value));
  });
}/// Create a copy of ThreadEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MessagePreviewCopyWith<$Res>? get preview {
    if (_self.preview == null) {
    return null;
  }

  return $MessagePreviewCopyWith<$Res>(_self.preview!, (value) {
    return _then(_self.copyWith(preview: value));
  });
}
}


/// Adds pattern-matching-related methods to [ThreadEvent].
extension ThreadEventPatterns on ThreadEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ThreadEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ThreadEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ThreadEvent value)  $default,){
final _that = this;
switch (_that) {
case _ThreadEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ThreadEvent value)?  $default,){
final _that = this;
switch (_that) {
case _ThreadEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String eventId,  ChatUser sender,  DateTime timestamp,  bool isOwn,  MessagePreview? preview)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ThreadEvent() when $default != null:
return $default(_that.eventId,_that.sender,_that.timestamp,_that.isOwn,_that.preview);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String eventId,  ChatUser sender,  DateTime timestamp,  bool isOwn,  MessagePreview? preview)  $default,) {final _that = this;
switch (_that) {
case _ThreadEvent():
return $default(_that.eventId,_that.sender,_that.timestamp,_that.isOwn,_that.preview);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String eventId,  ChatUser sender,  DateTime timestamp,  bool isOwn,  MessagePreview? preview)?  $default,) {final _that = this;
switch (_that) {
case _ThreadEvent() when $default != null:
return $default(_that.eventId,_that.sender,_that.timestamp,_that.isOwn,_that.preview);case _:
  return null;

}
}

}

/// @nodoc


class _ThreadEvent implements ThreadEvent {
  const _ThreadEvent({required this.eventId, required this.sender, required this.timestamp, required this.isOwn, this.preview});
  

@override final  String eventId;
@override final  ChatUser sender;
@override final  DateTime timestamp;
@override final  bool isOwn;
/// `null` while the content is unknown (e.g. not yet decrypted).
@override final  MessagePreview? preview;

/// Create a copy of ThreadEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ThreadEventCopyWith<_ThreadEvent> get copyWith => __$ThreadEventCopyWithImpl<_ThreadEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ThreadEvent&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.sender, sender) || other.sender == sender)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.isOwn, isOwn) || other.isOwn == isOwn)&&(identical(other.preview, preview) || other.preview == preview));
}


@override
int get hashCode => Object.hash(runtimeType,eventId,sender,timestamp,isOwn,preview);

@override
String toString() {
  return 'ThreadEvent(eventId: $eventId, sender: $sender, timestamp: $timestamp, isOwn: $isOwn, preview: $preview)';
}


}

/// @nodoc
abstract mixin class _$ThreadEventCopyWith<$Res> implements $ThreadEventCopyWith<$Res> {
  factory _$ThreadEventCopyWith(_ThreadEvent value, $Res Function(_ThreadEvent) _then) = __$ThreadEventCopyWithImpl;
@override @useResult
$Res call({
 String eventId, ChatUser sender, DateTime timestamp, bool isOwn, MessagePreview? preview
});


@override $ChatUserCopyWith<$Res> get sender;@override $MessagePreviewCopyWith<$Res>? get preview;

}
/// @nodoc
class __$ThreadEventCopyWithImpl<$Res>
    implements _$ThreadEventCopyWith<$Res> {
  __$ThreadEventCopyWithImpl(this._self, this._then);

  final _ThreadEvent _self;
  final $Res Function(_ThreadEvent) _then;

/// Create a copy of ThreadEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? eventId = null,Object? sender = null,Object? timestamp = null,Object? isOwn = null,Object? preview = freezed,}) {
  return _then(_ThreadEvent(
eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,sender: null == sender ? _self.sender : sender // ignore: cast_nullable_to_non_nullable
as ChatUser,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,isOwn: null == isOwn ? _self.isOwn : isOwn // ignore: cast_nullable_to_non_nullable
as bool,preview: freezed == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as MessagePreview?,
  ));
}

/// Create a copy of ThreadEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatUserCopyWith<$Res> get sender {
  
  return $ChatUserCopyWith<$Res>(_self.sender, (value) {
    return _then(_self.copyWith(sender: value));
  });
}/// Create a copy of ThreadEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MessagePreviewCopyWith<$Res>? get preview {
    if (_self.preview == null) {
    return null;
  }

  return $MessagePreviewCopyWith<$Res>(_self.preview!, (value) {
    return _then(_self.copyWith(preview: value));
  });
}
}

/// @nodoc
mixin _$ThreadInfo {

 ThreadEvent get root; ThreadEvent? get latest; int get replyCount;
/// Create a copy of ThreadInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ThreadInfoCopyWith<ThreadInfo> get copyWith => _$ThreadInfoCopyWithImpl<ThreadInfo>(this as ThreadInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThreadInfo&&(identical(other.root, root) || other.root == root)&&(identical(other.latest, latest) || other.latest == latest)&&(identical(other.replyCount, replyCount) || other.replyCount == replyCount));
}


@override
int get hashCode => Object.hash(runtimeType,root,latest,replyCount);

@override
String toString() {
  return 'ThreadInfo(root: $root, latest: $latest, replyCount: $replyCount)';
}


}

/// @nodoc
abstract mixin class $ThreadInfoCopyWith<$Res>  {
  factory $ThreadInfoCopyWith(ThreadInfo value, $Res Function(ThreadInfo) _then) = _$ThreadInfoCopyWithImpl;
@useResult
$Res call({
 ThreadEvent root, ThreadEvent? latest, int replyCount
});


$ThreadEventCopyWith<$Res> get root;$ThreadEventCopyWith<$Res>? get latest;

}
/// @nodoc
class _$ThreadInfoCopyWithImpl<$Res>
    implements $ThreadInfoCopyWith<$Res> {
  _$ThreadInfoCopyWithImpl(this._self, this._then);

  final ThreadInfo _self;
  final $Res Function(ThreadInfo) _then;

/// Create a copy of ThreadInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? root = null,Object? latest = freezed,Object? replyCount = null,}) {
  return _then(_self.copyWith(
root: null == root ? _self.root : root // ignore: cast_nullable_to_non_nullable
as ThreadEvent,latest: freezed == latest ? _self.latest : latest // ignore: cast_nullable_to_non_nullable
as ThreadEvent?,replyCount: null == replyCount ? _self.replyCount : replyCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of ThreadInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ThreadEventCopyWith<$Res> get root {
  
  return $ThreadEventCopyWith<$Res>(_self.root, (value) {
    return _then(_self.copyWith(root: value));
  });
}/// Create a copy of ThreadInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ThreadEventCopyWith<$Res>? get latest {
    if (_self.latest == null) {
    return null;
  }

  return $ThreadEventCopyWith<$Res>(_self.latest!, (value) {
    return _then(_self.copyWith(latest: value));
  });
}
}


/// Adds pattern-matching-related methods to [ThreadInfo].
extension ThreadInfoPatterns on ThreadInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ThreadInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ThreadInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ThreadInfo value)  $default,){
final _that = this;
switch (_that) {
case _ThreadInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ThreadInfo value)?  $default,){
final _that = this;
switch (_that) {
case _ThreadInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ThreadEvent root,  ThreadEvent? latest,  int replyCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ThreadInfo() when $default != null:
return $default(_that.root,_that.latest,_that.replyCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ThreadEvent root,  ThreadEvent? latest,  int replyCount)  $default,) {final _that = this;
switch (_that) {
case _ThreadInfo():
return $default(_that.root,_that.latest,_that.replyCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ThreadEvent root,  ThreadEvent? latest,  int replyCount)?  $default,) {final _that = this;
switch (_that) {
case _ThreadInfo() when $default != null:
return $default(_that.root,_that.latest,_that.replyCount);case _:
  return null;

}
}

}

/// @nodoc


class _ThreadInfo implements ThreadInfo {
  const _ThreadInfo({required this.root, this.latest, required this.replyCount});
  

@override final  ThreadEvent root;
@override final  ThreadEvent? latest;
@override final  int replyCount;

/// Create a copy of ThreadInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ThreadInfoCopyWith<_ThreadInfo> get copyWith => __$ThreadInfoCopyWithImpl<_ThreadInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ThreadInfo&&(identical(other.root, root) || other.root == root)&&(identical(other.latest, latest) || other.latest == latest)&&(identical(other.replyCount, replyCount) || other.replyCount == replyCount));
}


@override
int get hashCode => Object.hash(runtimeType,root,latest,replyCount);

@override
String toString() {
  return 'ThreadInfo(root: $root, latest: $latest, replyCount: $replyCount)';
}


}

/// @nodoc
abstract mixin class _$ThreadInfoCopyWith<$Res> implements $ThreadInfoCopyWith<$Res> {
  factory _$ThreadInfoCopyWith(_ThreadInfo value, $Res Function(_ThreadInfo) _then) = __$ThreadInfoCopyWithImpl;
@override @useResult
$Res call({
 ThreadEvent root, ThreadEvent? latest, int replyCount
});


@override $ThreadEventCopyWith<$Res> get root;@override $ThreadEventCopyWith<$Res>? get latest;

}
/// @nodoc
class __$ThreadInfoCopyWithImpl<$Res>
    implements _$ThreadInfoCopyWith<$Res> {
  __$ThreadInfoCopyWithImpl(this._self, this._then);

  final _ThreadInfo _self;
  final $Res Function(_ThreadInfo) _then;

/// Create a copy of ThreadInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? root = null,Object? latest = freezed,Object? replyCount = null,}) {
  return _then(_ThreadInfo(
root: null == root ? _self.root : root // ignore: cast_nullable_to_non_nullable
as ThreadEvent,latest: freezed == latest ? _self.latest : latest // ignore: cast_nullable_to_non_nullable
as ThreadEvent?,replyCount: null == replyCount ? _self.replyCount : replyCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of ThreadInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ThreadEventCopyWith<$Res> get root {
  
  return $ThreadEventCopyWith<$Res>(_self.root, (value) {
    return _then(_self.copyWith(root: value));
  });
}/// Create a copy of ThreadInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ThreadEventCopyWith<$Res>? get latest {
    if (_self.latest == null) {
    return null;
  }

  return $ThreadEventCopyWith<$Res>(_self.latest!, (value) {
    return _then(_self.copyWith(latest: value));
  });
}
}

/// @nodoc
mixin _$ImageThumbnail {

 Uint8List get data; String get mimeType; int get width; int get height;
/// Create a copy of ImageThumbnail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImageThumbnailCopyWith<ImageThumbnail> get copyWith => _$ImageThumbnailCopyWithImpl<ImageThumbnail>(this as ImageThumbnail, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImageThumbnail&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data),mimeType,width,height);

@override
String toString() {
  return 'ImageThumbnail(data: $data, mimeType: $mimeType, width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class $ImageThumbnailCopyWith<$Res>  {
  factory $ImageThumbnailCopyWith(ImageThumbnail value, $Res Function(ImageThumbnail) _then) = _$ImageThumbnailCopyWithImpl;
@useResult
$Res call({
 Uint8List data, String mimeType, int width, int height
});




}
/// @nodoc
class _$ImageThumbnailCopyWithImpl<$Res>
    implements $ImageThumbnailCopyWith<$Res> {
  _$ImageThumbnailCopyWithImpl(this._self, this._then);

  final ImageThumbnail _self;
  final $Res Function(ImageThumbnail) _then;

/// Create a copy of ImageThumbnail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,Object? mimeType = null,Object? width = null,Object? height = null,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Uint8List,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ImageThumbnail].
extension ImageThumbnailPatterns on ImageThumbnail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImageThumbnail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImageThumbnail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImageThumbnail value)  $default,){
final _that = this;
switch (_that) {
case _ImageThumbnail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImageThumbnail value)?  $default,){
final _that = this;
switch (_that) {
case _ImageThumbnail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Uint8List data,  String mimeType,  int width,  int height)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImageThumbnail() when $default != null:
return $default(_that.data,_that.mimeType,_that.width,_that.height);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Uint8List data,  String mimeType,  int width,  int height)  $default,) {final _that = this;
switch (_that) {
case _ImageThumbnail():
return $default(_that.data,_that.mimeType,_that.width,_that.height);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Uint8List data,  String mimeType,  int width,  int height)?  $default,) {final _that = this;
switch (_that) {
case _ImageThumbnail() when $default != null:
return $default(_that.data,_that.mimeType,_that.width,_that.height);case _:
  return null;

}
}

}

/// @nodoc


class _ImageThumbnail implements ImageThumbnail {
  const _ImageThumbnail({required this.data, required this.mimeType, required this.width, required this.height});
  

@override final  Uint8List data;
@override final  String mimeType;
@override final  int width;
@override final  int height;

/// Create a copy of ImageThumbnail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImageThumbnailCopyWith<_ImageThumbnail> get copyWith => __$ImageThumbnailCopyWithImpl<_ImageThumbnail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImageThumbnail&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data),mimeType,width,height);

@override
String toString() {
  return 'ImageThumbnail(data: $data, mimeType: $mimeType, width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class _$ImageThumbnailCopyWith<$Res> implements $ImageThumbnailCopyWith<$Res> {
  factory _$ImageThumbnailCopyWith(_ImageThumbnail value, $Res Function(_ImageThumbnail) _then) = __$ImageThumbnailCopyWithImpl;
@override @useResult
$Res call({
 Uint8List data, String mimeType, int width, int height
});




}
/// @nodoc
class __$ImageThumbnailCopyWithImpl<$Res>
    implements _$ImageThumbnailCopyWith<$Res> {
  __$ImageThumbnailCopyWithImpl(this._self, this._then);

  final _ImageThumbnail _self;
  final $Res Function(_ImageThumbnail) _then;

/// Create a copy of ImageThumbnail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,Object? mimeType = null,Object? width = null,Object? height = null,}) {
  return _then(_ImageThumbnail(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Uint8List,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$ImageAttachment {

 String get filePath; String get mimeType; String? get caption; int? get width; int? get height; String? get blurhash; ImageThumbnail? get thumbnail;
/// Create a copy of ImageAttachment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImageAttachmentCopyWith<ImageAttachment> get copyWith => _$ImageAttachmentCopyWithImpl<ImageAttachment>(this as ImageAttachment, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImageAttachment&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.blurhash, blurhash) || other.blurhash == blurhash)&&(identical(other.thumbnail, thumbnail) || other.thumbnail == thumbnail));
}


@override
int get hashCode => Object.hash(runtimeType,filePath,mimeType,caption,width,height,blurhash,thumbnail);

@override
String toString() {
  return 'ImageAttachment(filePath: $filePath, mimeType: $mimeType, caption: $caption, width: $width, height: $height, blurhash: $blurhash, thumbnail: $thumbnail)';
}


}

/// @nodoc
abstract mixin class $ImageAttachmentCopyWith<$Res>  {
  factory $ImageAttachmentCopyWith(ImageAttachment value, $Res Function(ImageAttachment) _then) = _$ImageAttachmentCopyWithImpl;
@useResult
$Res call({
 String filePath, String mimeType, String? caption, int? width, int? height, String? blurhash, ImageThumbnail? thumbnail
});


$ImageThumbnailCopyWith<$Res>? get thumbnail;

}
/// @nodoc
class _$ImageAttachmentCopyWithImpl<$Res>
    implements $ImageAttachmentCopyWith<$Res> {
  _$ImageAttachmentCopyWithImpl(this._self, this._then);

  final ImageAttachment _self;
  final $Res Function(ImageAttachment) _then;

/// Create a copy of ImageAttachment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? filePath = null,Object? mimeType = null,Object? caption = freezed,Object? width = freezed,Object? height = freezed,Object? blurhash = freezed,Object? thumbnail = freezed,}) {
  return _then(_self.copyWith(
filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,blurhash: freezed == blurhash ? _self.blurhash : blurhash // ignore: cast_nullable_to_non_nullable
as String?,thumbnail: freezed == thumbnail ? _self.thumbnail : thumbnail // ignore: cast_nullable_to_non_nullable
as ImageThumbnail?,
  ));
}
/// Create a copy of ImageAttachment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ImageThumbnailCopyWith<$Res>? get thumbnail {
    if (_self.thumbnail == null) {
    return null;
  }

  return $ImageThumbnailCopyWith<$Res>(_self.thumbnail!, (value) {
    return _then(_self.copyWith(thumbnail: value));
  });
}
}


/// Adds pattern-matching-related methods to [ImageAttachment].
extension ImageAttachmentPatterns on ImageAttachment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImageAttachment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImageAttachment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImageAttachment value)  $default,){
final _that = this;
switch (_that) {
case _ImageAttachment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImageAttachment value)?  $default,){
final _that = this;
switch (_that) {
case _ImageAttachment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String filePath,  String mimeType,  String? caption,  int? width,  int? height,  String? blurhash,  ImageThumbnail? thumbnail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImageAttachment() when $default != null:
return $default(_that.filePath,_that.mimeType,_that.caption,_that.width,_that.height,_that.blurhash,_that.thumbnail);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String filePath,  String mimeType,  String? caption,  int? width,  int? height,  String? blurhash,  ImageThumbnail? thumbnail)  $default,) {final _that = this;
switch (_that) {
case _ImageAttachment():
return $default(_that.filePath,_that.mimeType,_that.caption,_that.width,_that.height,_that.blurhash,_that.thumbnail);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String filePath,  String mimeType,  String? caption,  int? width,  int? height,  String? blurhash,  ImageThumbnail? thumbnail)?  $default,) {final _that = this;
switch (_that) {
case _ImageAttachment() when $default != null:
return $default(_that.filePath,_that.mimeType,_that.caption,_that.width,_that.height,_that.blurhash,_that.thumbnail);case _:
  return null;

}
}

}

/// @nodoc


class _ImageAttachment implements ImageAttachment {
  const _ImageAttachment({required this.filePath, required this.mimeType, this.caption, this.width, this.height, this.blurhash, this.thumbnail});
  

@override final  String filePath;
@override final  String mimeType;
@override final  String? caption;
@override final  int? width;
@override final  int? height;
@override final  String? blurhash;
@override final  ImageThumbnail? thumbnail;

/// Create a copy of ImageAttachment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImageAttachmentCopyWith<_ImageAttachment> get copyWith => __$ImageAttachmentCopyWithImpl<_ImageAttachment>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImageAttachment&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.blurhash, blurhash) || other.blurhash == blurhash)&&(identical(other.thumbnail, thumbnail) || other.thumbnail == thumbnail));
}


@override
int get hashCode => Object.hash(runtimeType,filePath,mimeType,caption,width,height,blurhash,thumbnail);

@override
String toString() {
  return 'ImageAttachment(filePath: $filePath, mimeType: $mimeType, caption: $caption, width: $width, height: $height, blurhash: $blurhash, thumbnail: $thumbnail)';
}


}

/// @nodoc
abstract mixin class _$ImageAttachmentCopyWith<$Res> implements $ImageAttachmentCopyWith<$Res> {
  factory _$ImageAttachmentCopyWith(_ImageAttachment value, $Res Function(_ImageAttachment) _then) = __$ImageAttachmentCopyWithImpl;
@override @useResult
$Res call({
 String filePath, String mimeType, String? caption, int? width, int? height, String? blurhash, ImageThumbnail? thumbnail
});


@override $ImageThumbnailCopyWith<$Res>? get thumbnail;

}
/// @nodoc
class __$ImageAttachmentCopyWithImpl<$Res>
    implements _$ImageAttachmentCopyWith<$Res> {
  __$ImageAttachmentCopyWithImpl(this._self, this._then);

  final _ImageAttachment _self;
  final $Res Function(_ImageAttachment) _then;

/// Create a copy of ImageAttachment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? filePath = null,Object? mimeType = null,Object? caption = freezed,Object? width = freezed,Object? height = freezed,Object? blurhash = freezed,Object? thumbnail = freezed,}) {
  return _then(_ImageAttachment(
filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,blurhash: freezed == blurhash ? _self.blurhash : blurhash // ignore: cast_nullable_to_non_nullable
as String?,thumbnail: freezed == thumbnail ? _self.thumbnail : thumbnail // ignore: cast_nullable_to_non_nullable
as ImageThumbnail?,
  ));
}

/// Create a copy of ImageAttachment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ImageThumbnailCopyWith<$Res>? get thumbnail {
    if (_self.thumbnail == null) {
    return null;
  }

  return $ImageThumbnailCopyWith<$Res>(_self.thumbnail!, (value) {
    return _then(_self.copyWith(thumbnail: value));
  });
}
}

/// @nodoc
mixin _$ChatNotification {

 String get roomName; String? get senderName; String get body; bool get isDirect; bool? get isEncrypted;
/// Create a copy of ChatNotification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatNotificationCopyWith<ChatNotification> get copyWith => _$ChatNotificationCopyWithImpl<ChatNotification>(this as ChatNotification, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatNotification&&(identical(other.roomName, roomName) || other.roomName == roomName)&&(identical(other.senderName, senderName) || other.senderName == senderName)&&(identical(other.body, body) || other.body == body)&&(identical(other.isDirect, isDirect) || other.isDirect == isDirect)&&(identical(other.isEncrypted, isEncrypted) || other.isEncrypted == isEncrypted));
}


@override
int get hashCode => Object.hash(runtimeType,roomName,senderName,body,isDirect,isEncrypted);

@override
String toString() {
  return 'ChatNotification(roomName: $roomName, senderName: $senderName, body: $body, isDirect: $isDirect, isEncrypted: $isEncrypted)';
}


}

/// @nodoc
abstract mixin class $ChatNotificationCopyWith<$Res>  {
  factory $ChatNotificationCopyWith(ChatNotification value, $Res Function(ChatNotification) _then) = _$ChatNotificationCopyWithImpl;
@useResult
$Res call({
 String roomName, String? senderName, String body, bool isDirect, bool? isEncrypted
});




}
/// @nodoc
class _$ChatNotificationCopyWithImpl<$Res>
    implements $ChatNotificationCopyWith<$Res> {
  _$ChatNotificationCopyWithImpl(this._self, this._then);

  final ChatNotification _self;
  final $Res Function(ChatNotification) _then;

/// Create a copy of ChatNotification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? roomName = null,Object? senderName = freezed,Object? body = null,Object? isDirect = null,Object? isEncrypted = freezed,}) {
  return _then(_self.copyWith(
roomName: null == roomName ? _self.roomName : roomName // ignore: cast_nullable_to_non_nullable
as String,senderName: freezed == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String?,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,isDirect: null == isDirect ? _self.isDirect : isDirect // ignore: cast_nullable_to_non_nullable
as bool,isEncrypted: freezed == isEncrypted ? _self.isEncrypted : isEncrypted // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatNotification].
extension ChatNotificationPatterns on ChatNotification {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatNotification value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatNotification() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatNotification value)  $default,){
final _that = this;
switch (_that) {
case _ChatNotification():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatNotification value)?  $default,){
final _that = this;
switch (_that) {
case _ChatNotification() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String roomName,  String? senderName,  String body,  bool isDirect,  bool? isEncrypted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatNotification() when $default != null:
return $default(_that.roomName,_that.senderName,_that.body,_that.isDirect,_that.isEncrypted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String roomName,  String? senderName,  String body,  bool isDirect,  bool? isEncrypted)  $default,) {final _that = this;
switch (_that) {
case _ChatNotification():
return $default(_that.roomName,_that.senderName,_that.body,_that.isDirect,_that.isEncrypted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String roomName,  String? senderName,  String body,  bool isDirect,  bool? isEncrypted)?  $default,) {final _that = this;
switch (_that) {
case _ChatNotification() when $default != null:
return $default(_that.roomName,_that.senderName,_that.body,_that.isDirect,_that.isEncrypted);case _:
  return null;

}
}

}

/// @nodoc


class _ChatNotification implements ChatNotification {
  const _ChatNotification({required this.roomName, this.senderName, required this.body, required this.isDirect, this.isEncrypted});
  

@override final  String roomName;
@override final  String? senderName;
@override final  String body;
@override final  bool isDirect;
@override final  bool? isEncrypted;

/// Create a copy of ChatNotification
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatNotificationCopyWith<_ChatNotification> get copyWith => __$ChatNotificationCopyWithImpl<_ChatNotification>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatNotification&&(identical(other.roomName, roomName) || other.roomName == roomName)&&(identical(other.senderName, senderName) || other.senderName == senderName)&&(identical(other.body, body) || other.body == body)&&(identical(other.isDirect, isDirect) || other.isDirect == isDirect)&&(identical(other.isEncrypted, isEncrypted) || other.isEncrypted == isEncrypted));
}


@override
int get hashCode => Object.hash(runtimeType,roomName,senderName,body,isDirect,isEncrypted);

@override
String toString() {
  return 'ChatNotification(roomName: $roomName, senderName: $senderName, body: $body, isDirect: $isDirect, isEncrypted: $isEncrypted)';
}


}

/// @nodoc
abstract mixin class _$ChatNotificationCopyWith<$Res> implements $ChatNotificationCopyWith<$Res> {
  factory _$ChatNotificationCopyWith(_ChatNotification value, $Res Function(_ChatNotification) _then) = __$ChatNotificationCopyWithImpl;
@override @useResult
$Res call({
 String roomName, String? senderName, String body, bool isDirect, bool? isEncrypted
});




}
/// @nodoc
class __$ChatNotificationCopyWithImpl<$Res>
    implements _$ChatNotificationCopyWith<$Res> {
  __$ChatNotificationCopyWithImpl(this._self, this._then);

  final _ChatNotification _self;
  final $Res Function(_ChatNotification) _then;

/// Create a copy of ChatNotification
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? roomName = null,Object? senderName = freezed,Object? body = null,Object? isDirect = null,Object? isEncrypted = freezed,}) {
  return _then(_ChatNotification(
roomName: null == roomName ? _self.roomName : roomName // ignore: cast_nullable_to_non_nullable
as String,senderName: freezed == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String?,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,isDirect: null == isDirect ? _self.isDirect : isDirect // ignore: cast_nullable_to_non_nullable
as bool,isEncrypted: freezed == isEncrypted ? _self.isEncrypted : isEncrypted // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
