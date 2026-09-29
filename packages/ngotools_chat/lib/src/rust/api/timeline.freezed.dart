// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timeline.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( EventContent_Text value)?  text,TResult Function( EventContent_Image value)?  image,TResult Function( EventContent_Video value)?  video,TResult Function( EventContent_Audio value)?  audio,TResult Function( EventContent_File value)?  file,TResult Function( EventContent_Redacted value)?  redacted,TResult Function( EventContent_UnableToDecrypt value)?  unableToDecrypt,TResult Function( EventContent_Membership value)?  membership,TResult Function( EventContent_ProfileChange value)?  profileChange,TResult Function( EventContent_RoomState value)?  roomState,TResult Function( EventContent_Unsupported value)?  unsupported,required TResult orElse(),}){
final _that = this;
switch (_that) {
case EventContent_Text() when text != null:
return text(_that);case EventContent_Image() when image != null:
return image(_that);case EventContent_Video() when video != null:
return video(_that);case EventContent_Audio() when audio != null:
return audio(_that);case EventContent_File() when file != null:
return file(_that);case EventContent_Redacted() when redacted != null:
return redacted(_that);case EventContent_UnableToDecrypt() when unableToDecrypt != null:
return unableToDecrypt(_that);case EventContent_Membership() when membership != null:
return membership(_that);case EventContent_ProfileChange() when profileChange != null:
return profileChange(_that);case EventContent_RoomState() when roomState != null:
return roomState(_that);case EventContent_Unsupported() when unsupported != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( EventContent_Text value)  text,required TResult Function( EventContent_Image value)  image,required TResult Function( EventContent_Video value)  video,required TResult Function( EventContent_Audio value)  audio,required TResult Function( EventContent_File value)  file,required TResult Function( EventContent_Redacted value)  redacted,required TResult Function( EventContent_UnableToDecrypt value)  unableToDecrypt,required TResult Function( EventContent_Membership value)  membership,required TResult Function( EventContent_ProfileChange value)  profileChange,required TResult Function( EventContent_RoomState value)  roomState,required TResult Function( EventContent_Unsupported value)  unsupported,}){
final _that = this;
switch (_that) {
case EventContent_Text():
return text(_that);case EventContent_Image():
return image(_that);case EventContent_Video():
return video(_that);case EventContent_Audio():
return audio(_that);case EventContent_File():
return file(_that);case EventContent_Redacted():
return redacted(_that);case EventContent_UnableToDecrypt():
return unableToDecrypt(_that);case EventContent_Membership():
return membership(_that);case EventContent_ProfileChange():
return profileChange(_that);case EventContent_RoomState():
return roomState(_that);case EventContent_Unsupported():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( EventContent_Text value)?  text,TResult? Function( EventContent_Image value)?  image,TResult? Function( EventContent_Video value)?  video,TResult? Function( EventContent_Audio value)?  audio,TResult? Function( EventContent_File value)?  file,TResult? Function( EventContent_Redacted value)?  redacted,TResult? Function( EventContent_UnableToDecrypt value)?  unableToDecrypt,TResult? Function( EventContent_Membership value)?  membership,TResult? Function( EventContent_ProfileChange value)?  profileChange,TResult? Function( EventContent_RoomState value)?  roomState,TResult? Function( EventContent_Unsupported value)?  unsupported,}){
final _that = this;
switch (_that) {
case EventContent_Text() when text != null:
return text(_that);case EventContent_Image() when image != null:
return image(_that);case EventContent_Video() when video != null:
return video(_that);case EventContent_Audio() when audio != null:
return audio(_that);case EventContent_File() when file != null:
return file(_that);case EventContent_Redacted() when redacted != null:
return redacted(_that);case EventContent_UnableToDecrypt() when unableToDecrypt != null:
return unableToDecrypt(_that);case EventContent_Membership() when membership != null:
return membership(_that);case EventContent_ProfileChange() when profileChange != null:
return profileChange(_that);case EventContent_RoomState() when roomState != null:
return roomState(_that);case EventContent_Unsupported() when unsupported != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String body)?  text,TResult Function( String? caption,  String filename,  String media,  String? thumbnail,  int? width,  int? height,  String? blurhash)?  image,TResult Function( String? caption,  String filename,  String media)?  video,TResult Function( String filename,  String media)?  audio,TResult Function( String? caption,  String filename,  String media,  BigInt? size)?  file,TResult Function()?  redacted,TResult Function()?  unableToDecrypt,TResult Function( String userId,  MembershipKind change)?  membership,TResult Function( String userId)?  profileChange,TResult Function( String eventType)?  roomState,TResult Function()?  unsupported,required TResult orElse(),}) {final _that = this;
switch (_that) {
case EventContent_Text() when text != null:
return text(_that.body);case EventContent_Image() when image != null:
return image(_that.caption,_that.filename,_that.media,_that.thumbnail,_that.width,_that.height,_that.blurhash);case EventContent_Video() when video != null:
return video(_that.caption,_that.filename,_that.media);case EventContent_Audio() when audio != null:
return audio(_that.filename,_that.media);case EventContent_File() when file != null:
return file(_that.caption,_that.filename,_that.media,_that.size);case EventContent_Redacted() when redacted != null:
return redacted();case EventContent_UnableToDecrypt() when unableToDecrypt != null:
return unableToDecrypt();case EventContent_Membership() when membership != null:
return membership(_that.userId,_that.change);case EventContent_ProfileChange() when profileChange != null:
return profileChange(_that.userId);case EventContent_RoomState() when roomState != null:
return roomState(_that.eventType);case EventContent_Unsupported() when unsupported != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String body)  text,required TResult Function( String? caption,  String filename,  String media,  String? thumbnail,  int? width,  int? height,  String? blurhash)  image,required TResult Function( String? caption,  String filename,  String media)  video,required TResult Function( String filename,  String media)  audio,required TResult Function( String? caption,  String filename,  String media,  BigInt? size)  file,required TResult Function()  redacted,required TResult Function()  unableToDecrypt,required TResult Function( String userId,  MembershipKind change)  membership,required TResult Function( String userId)  profileChange,required TResult Function( String eventType)  roomState,required TResult Function()  unsupported,}) {final _that = this;
switch (_that) {
case EventContent_Text():
return text(_that.body);case EventContent_Image():
return image(_that.caption,_that.filename,_that.media,_that.thumbnail,_that.width,_that.height,_that.blurhash);case EventContent_Video():
return video(_that.caption,_that.filename,_that.media);case EventContent_Audio():
return audio(_that.filename,_that.media);case EventContent_File():
return file(_that.caption,_that.filename,_that.media,_that.size);case EventContent_Redacted():
return redacted();case EventContent_UnableToDecrypt():
return unableToDecrypt();case EventContent_Membership():
return membership(_that.userId,_that.change);case EventContent_ProfileChange():
return profileChange(_that.userId);case EventContent_RoomState():
return roomState(_that.eventType);case EventContent_Unsupported():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String body)?  text,TResult? Function( String? caption,  String filename,  String media,  String? thumbnail,  int? width,  int? height,  String? blurhash)?  image,TResult? Function( String? caption,  String filename,  String media)?  video,TResult? Function( String filename,  String media)?  audio,TResult? Function( String? caption,  String filename,  String media,  BigInt? size)?  file,TResult? Function()?  redacted,TResult? Function()?  unableToDecrypt,TResult? Function( String userId,  MembershipKind change)?  membership,TResult? Function( String userId)?  profileChange,TResult? Function( String eventType)?  roomState,TResult? Function()?  unsupported,}) {final _that = this;
switch (_that) {
case EventContent_Text() when text != null:
return text(_that.body);case EventContent_Image() when image != null:
return image(_that.caption,_that.filename,_that.media,_that.thumbnail,_that.width,_that.height,_that.blurhash);case EventContent_Video() when video != null:
return video(_that.caption,_that.filename,_that.media);case EventContent_Audio() when audio != null:
return audio(_that.filename,_that.media);case EventContent_File() when file != null:
return file(_that.caption,_that.filename,_that.media,_that.size);case EventContent_Redacted() when redacted != null:
return redacted();case EventContent_UnableToDecrypt() when unableToDecrypt != null:
return unableToDecrypt();case EventContent_Membership() when membership != null:
return membership(_that.userId,_that.change);case EventContent_ProfileChange() when profileChange != null:
return profileChange(_that.userId);case EventContent_RoomState() when roomState != null:
return roomState(_that.eventType);case EventContent_Unsupported() when unsupported != null:
return unsupported();case _:
  return null;

}
}

}

/// @nodoc


class EventContent_Text extends EventContent {
  const EventContent_Text({required this.body}): super._();
  

 final  String body;

/// Create a copy of EventContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventContent_TextCopyWith<EventContent_Text> get copyWith => _$EventContent_TextCopyWithImpl<EventContent_Text>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventContent_Text&&(identical(other.body, body) || other.body == body));
}


@override
int get hashCode => Object.hash(runtimeType,body);

@override
String toString() {
  return 'EventContent.text(body: $body)';
}


}

/// @nodoc
abstract mixin class $EventContent_TextCopyWith<$Res> implements $EventContentCopyWith<$Res> {
  factory $EventContent_TextCopyWith(EventContent_Text value, $Res Function(EventContent_Text) _then) = _$EventContent_TextCopyWithImpl;
@useResult
$Res call({
 String body
});




}
/// @nodoc
class _$EventContent_TextCopyWithImpl<$Res>
    implements $EventContent_TextCopyWith<$Res> {
  _$EventContent_TextCopyWithImpl(this._self, this._then);

  final EventContent_Text _self;
  final $Res Function(EventContent_Text) _then;

/// Create a copy of EventContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? body = null,}) {
  return _then(EventContent_Text(
body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class EventContent_Image extends EventContent {
  const EventContent_Image({this.caption, required this.filename, required this.media, this.thumbnail, this.width, this.height, this.blurhash}): super._();
  

 final  String? caption;
 final  String filename;
/// Opaque media reference for the media API.
 final  String media;
/// Small preview uploaded by the sender (always set for encrypted
/// images sent by this app; fetch it with `fetch_media`).
 final  String? thumbnail;
 final  int? width;
 final  int? height;
 final  String? blurhash;

/// Create a copy of EventContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventContent_ImageCopyWith<EventContent_Image> get copyWith => _$EventContent_ImageCopyWithImpl<EventContent_Image>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventContent_Image&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.media, media) || other.media == media)&&(identical(other.thumbnail, thumbnail) || other.thumbnail == thumbnail)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.blurhash, blurhash) || other.blurhash == blurhash));
}


@override
int get hashCode => Object.hash(runtimeType,caption,filename,media,thumbnail,width,height,blurhash);

@override
String toString() {
  return 'EventContent.image(caption: $caption, filename: $filename, media: $media, thumbnail: $thumbnail, width: $width, height: $height, blurhash: $blurhash)';
}


}

/// @nodoc
abstract mixin class $EventContent_ImageCopyWith<$Res> implements $EventContentCopyWith<$Res> {
  factory $EventContent_ImageCopyWith(EventContent_Image value, $Res Function(EventContent_Image) _then) = _$EventContent_ImageCopyWithImpl;
@useResult
$Res call({
 String? caption, String filename, String media, String? thumbnail, int? width, int? height, String? blurhash
});




}
/// @nodoc
class _$EventContent_ImageCopyWithImpl<$Res>
    implements $EventContent_ImageCopyWith<$Res> {
  _$EventContent_ImageCopyWithImpl(this._self, this._then);

  final EventContent_Image _self;
  final $Res Function(EventContent_Image) _then;

/// Create a copy of EventContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? caption = freezed,Object? filename = null,Object? media = null,Object? thumbnail = freezed,Object? width = freezed,Object? height = freezed,Object? blurhash = freezed,}) {
  return _then(EventContent_Image(
caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,filename: null == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String,media: null == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as String,thumbnail: freezed == thumbnail ? _self.thumbnail : thumbnail // ignore: cast_nullable_to_non_nullable
as String?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,blurhash: freezed == blurhash ? _self.blurhash : blurhash // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class EventContent_Video extends EventContent {
  const EventContent_Video({this.caption, required this.filename, required this.media}): super._();
  

 final  String? caption;
 final  String filename;
 final  String media;

/// Create a copy of EventContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventContent_VideoCopyWith<EventContent_Video> get copyWith => _$EventContent_VideoCopyWithImpl<EventContent_Video>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventContent_Video&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.media, media) || other.media == media));
}


@override
int get hashCode => Object.hash(runtimeType,caption,filename,media);

@override
String toString() {
  return 'EventContent.video(caption: $caption, filename: $filename, media: $media)';
}


}

/// @nodoc
abstract mixin class $EventContent_VideoCopyWith<$Res> implements $EventContentCopyWith<$Res> {
  factory $EventContent_VideoCopyWith(EventContent_Video value, $Res Function(EventContent_Video) _then) = _$EventContent_VideoCopyWithImpl;
@useResult
$Res call({
 String? caption, String filename, String media
});




}
/// @nodoc
class _$EventContent_VideoCopyWithImpl<$Res>
    implements $EventContent_VideoCopyWith<$Res> {
  _$EventContent_VideoCopyWithImpl(this._self, this._then);

  final EventContent_Video _self;
  final $Res Function(EventContent_Video) _then;

/// Create a copy of EventContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? caption = freezed,Object? filename = null,Object? media = null,}) {
  return _then(EventContent_Video(
caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,filename: null == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String,media: null == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class EventContent_Audio extends EventContent {
  const EventContent_Audio({required this.filename, required this.media}): super._();
  

 final  String filename;
 final  String media;

/// Create a copy of EventContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventContent_AudioCopyWith<EventContent_Audio> get copyWith => _$EventContent_AudioCopyWithImpl<EventContent_Audio>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventContent_Audio&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.media, media) || other.media == media));
}


@override
int get hashCode => Object.hash(runtimeType,filename,media);

@override
String toString() {
  return 'EventContent.audio(filename: $filename, media: $media)';
}


}

/// @nodoc
abstract mixin class $EventContent_AudioCopyWith<$Res> implements $EventContentCopyWith<$Res> {
  factory $EventContent_AudioCopyWith(EventContent_Audio value, $Res Function(EventContent_Audio) _then) = _$EventContent_AudioCopyWithImpl;
@useResult
$Res call({
 String filename, String media
});




}
/// @nodoc
class _$EventContent_AudioCopyWithImpl<$Res>
    implements $EventContent_AudioCopyWith<$Res> {
  _$EventContent_AudioCopyWithImpl(this._self, this._then);

  final EventContent_Audio _self;
  final $Res Function(EventContent_Audio) _then;

/// Create a copy of EventContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? filename = null,Object? media = null,}) {
  return _then(EventContent_Audio(
filename: null == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String,media: null == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class EventContent_File extends EventContent {
  const EventContent_File({this.caption, required this.filename, required this.media, this.size}): super._();
  

 final  String? caption;
 final  String filename;
 final  String media;
 final  BigInt? size;

/// Create a copy of EventContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventContent_FileCopyWith<EventContent_File> get copyWith => _$EventContent_FileCopyWithImpl<EventContent_File>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventContent_File&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.media, media) || other.media == media)&&(identical(other.size, size) || other.size == size));
}


@override
int get hashCode => Object.hash(runtimeType,caption,filename,media,size);

@override
String toString() {
  return 'EventContent.file(caption: $caption, filename: $filename, media: $media, size: $size)';
}


}

/// @nodoc
abstract mixin class $EventContent_FileCopyWith<$Res> implements $EventContentCopyWith<$Res> {
  factory $EventContent_FileCopyWith(EventContent_File value, $Res Function(EventContent_File) _then) = _$EventContent_FileCopyWithImpl;
@useResult
$Res call({
 String? caption, String filename, String media, BigInt? size
});




}
/// @nodoc
class _$EventContent_FileCopyWithImpl<$Res>
    implements $EventContent_FileCopyWith<$Res> {
  _$EventContent_FileCopyWithImpl(this._self, this._then);

  final EventContent_File _self;
  final $Res Function(EventContent_File) _then;

/// Create a copy of EventContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? caption = freezed,Object? filename = null,Object? media = null,Object? size = freezed,}) {
  return _then(EventContent_File(
caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,filename: null == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String,media: null == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as String,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as BigInt?,
  ));
}


}

/// @nodoc


class EventContent_Redacted extends EventContent {
  const EventContent_Redacted(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventContent_Redacted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EventContent.redacted()';
}


}




/// @nodoc


class EventContent_UnableToDecrypt extends EventContent {
  const EventContent_UnableToDecrypt(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventContent_UnableToDecrypt);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EventContent.unableToDecrypt()';
}


}




/// @nodoc


class EventContent_Membership extends EventContent {
  const EventContent_Membership({required this.userId, required this.change}): super._();
  

 final  String userId;
 final  MembershipKind change;

/// Create a copy of EventContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventContent_MembershipCopyWith<EventContent_Membership> get copyWith => _$EventContent_MembershipCopyWithImpl<EventContent_Membership>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventContent_Membership&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.change, change) || other.change == change));
}


@override
int get hashCode => Object.hash(runtimeType,userId,change);

@override
String toString() {
  return 'EventContent.membership(userId: $userId, change: $change)';
}


}

/// @nodoc
abstract mixin class $EventContent_MembershipCopyWith<$Res> implements $EventContentCopyWith<$Res> {
  factory $EventContent_MembershipCopyWith(EventContent_Membership value, $Res Function(EventContent_Membership) _then) = _$EventContent_MembershipCopyWithImpl;
@useResult
$Res call({
 String userId, MembershipKind change
});




}
/// @nodoc
class _$EventContent_MembershipCopyWithImpl<$Res>
    implements $EventContent_MembershipCopyWith<$Res> {
  _$EventContent_MembershipCopyWithImpl(this._self, this._then);

  final EventContent_Membership _self;
  final $Res Function(EventContent_Membership) _then;

/// Create a copy of EventContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? change = null,}) {
  return _then(EventContent_Membership(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,change: null == change ? _self.change : change // ignore: cast_nullable_to_non_nullable
as MembershipKind,
  ));
}


}

/// @nodoc


class EventContent_ProfileChange extends EventContent {
  const EventContent_ProfileChange({required this.userId}): super._();
  

 final  String userId;

/// Create a copy of EventContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventContent_ProfileChangeCopyWith<EventContent_ProfileChange> get copyWith => _$EventContent_ProfileChangeCopyWithImpl<EventContent_ProfileChange>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventContent_ProfileChange&&(identical(other.userId, userId) || other.userId == userId));
}


@override
int get hashCode => Object.hash(runtimeType,userId);

@override
String toString() {
  return 'EventContent.profileChange(userId: $userId)';
}


}

/// @nodoc
abstract mixin class $EventContent_ProfileChangeCopyWith<$Res> implements $EventContentCopyWith<$Res> {
  factory $EventContent_ProfileChangeCopyWith(EventContent_ProfileChange value, $Res Function(EventContent_ProfileChange) _then) = _$EventContent_ProfileChangeCopyWithImpl;
@useResult
$Res call({
 String userId
});




}
/// @nodoc
class _$EventContent_ProfileChangeCopyWithImpl<$Res>
    implements $EventContent_ProfileChangeCopyWith<$Res> {
  _$EventContent_ProfileChangeCopyWithImpl(this._self, this._then);

  final EventContent_ProfileChange _self;
  final $Res Function(EventContent_ProfileChange) _then;

/// Create a copy of EventContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? userId = null,}) {
  return _then(EventContent_ProfileChange(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class EventContent_RoomState extends EventContent {
  const EventContent_RoomState({required this.eventType}): super._();
  

 final  String eventType;

/// Create a copy of EventContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventContent_RoomStateCopyWith<EventContent_RoomState> get copyWith => _$EventContent_RoomStateCopyWithImpl<EventContent_RoomState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventContent_RoomState&&(identical(other.eventType, eventType) || other.eventType == eventType));
}


@override
int get hashCode => Object.hash(runtimeType,eventType);

@override
String toString() {
  return 'EventContent.roomState(eventType: $eventType)';
}


}

/// @nodoc
abstract mixin class $EventContent_RoomStateCopyWith<$Res> implements $EventContentCopyWith<$Res> {
  factory $EventContent_RoomStateCopyWith(EventContent_RoomState value, $Res Function(EventContent_RoomState) _then) = _$EventContent_RoomStateCopyWithImpl;
@useResult
$Res call({
 String eventType
});




}
/// @nodoc
class _$EventContent_RoomStateCopyWithImpl<$Res>
    implements $EventContent_RoomStateCopyWith<$Res> {
  _$EventContent_RoomStateCopyWithImpl(this._self, this._then);

  final EventContent_RoomState _self;
  final $Res Function(EventContent_RoomState) _then;

/// Create a copy of EventContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? eventType = null,}) {
  return _then(EventContent_RoomState(
eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class EventContent_Unsupported extends EventContent {
  const EventContent_Unsupported(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventContent_Unsupported);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EventContent.unsupported()';
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( EventKey_Local value)?  local,TResult Function( EventKey_Remote value)?  remote,required TResult orElse(),}){
final _that = this;
switch (_that) {
case EventKey_Local() when local != null:
return local(_that);case EventKey_Remote() when remote != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( EventKey_Local value)  local,required TResult Function( EventKey_Remote value)  remote,}){
final _that = this;
switch (_that) {
case EventKey_Local():
return local(_that);case EventKey_Remote():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( EventKey_Local value)?  local,TResult? Function( EventKey_Remote value)?  remote,}){
final _that = this;
switch (_that) {
case EventKey_Local() when local != null:
return local(_that);case EventKey_Remote() when remote != null:
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
case EventKey_Local() when local != null:
return local(_that.transactionId);case EventKey_Remote() when remote != null:
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
case EventKey_Local():
return local(_that.transactionId);case EventKey_Remote():
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
case EventKey_Local() when local != null:
return local(_that.transactionId);case EventKey_Remote() when remote != null:
return remote(_that.eventId);case _:
  return null;

}
}

}

/// @nodoc


class EventKey_Local extends EventKey {
  const EventKey_Local({required this.transactionId}): super._();
  

 final  String transactionId;

/// Create a copy of EventKey
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventKey_LocalCopyWith<EventKey_Local> get copyWith => _$EventKey_LocalCopyWithImpl<EventKey_Local>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventKey_Local&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId));
}


@override
int get hashCode => Object.hash(runtimeType,transactionId);

@override
String toString() {
  return 'EventKey.local(transactionId: $transactionId)';
}


}

/// @nodoc
abstract mixin class $EventKey_LocalCopyWith<$Res> implements $EventKeyCopyWith<$Res> {
  factory $EventKey_LocalCopyWith(EventKey_Local value, $Res Function(EventKey_Local) _then) = _$EventKey_LocalCopyWithImpl;
@useResult
$Res call({
 String transactionId
});




}
/// @nodoc
class _$EventKey_LocalCopyWithImpl<$Res>
    implements $EventKey_LocalCopyWith<$Res> {
  _$EventKey_LocalCopyWithImpl(this._self, this._then);

  final EventKey_Local _self;
  final $Res Function(EventKey_Local) _then;

/// Create a copy of EventKey
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? transactionId = null,}) {
  return _then(EventKey_Local(
transactionId: null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class EventKey_Remote extends EventKey {
  const EventKey_Remote({required this.eventId}): super._();
  

 final  String eventId;

/// Create a copy of EventKey
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventKey_RemoteCopyWith<EventKey_Remote> get copyWith => _$EventKey_RemoteCopyWithImpl<EventKey_Remote>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventKey_Remote&&(identical(other.eventId, eventId) || other.eventId == eventId));
}


@override
int get hashCode => Object.hash(runtimeType,eventId);

@override
String toString() {
  return 'EventKey.remote(eventId: $eventId)';
}


}

/// @nodoc
abstract mixin class $EventKey_RemoteCopyWith<$Res> implements $EventKeyCopyWith<$Res> {
  factory $EventKey_RemoteCopyWith(EventKey_Remote value, $Res Function(EventKey_Remote) _then) = _$EventKey_RemoteCopyWithImpl;
@useResult
$Res call({
 String eventId
});




}
/// @nodoc
class _$EventKey_RemoteCopyWithImpl<$Res>
    implements $EventKey_RemoteCopyWith<$Res> {
  _$EventKey_RemoteCopyWithImpl(this._self, this._then);

  final EventKey_Remote _self;
  final $Res Function(EventKey_Remote) _then;

/// Create a copy of EventKey
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? eventId = null,}) {
  return _then(EventKey_Remote(
eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MessagePreview_Text value)?  text,TResult Function( MessagePreview_Image value)?  image,TResult Function( MessagePreview_Video value)?  video,TResult Function( MessagePreview_Audio value)?  audio,TResult Function( MessagePreview_File value)?  file,TResult Function( MessagePreview_Location value)?  location,TResult Function( MessagePreview_Poll value)?  poll,TResult Function( MessagePreview_Sticker value)?  sticker,TResult Function( MessagePreview_Redacted value)?  redacted,TResult Function( MessagePreview_UnableToDecrypt value)?  unableToDecrypt,TResult Function( MessagePreview_Other value)?  other,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MessagePreview_Text() when text != null:
return text(_that);case MessagePreview_Image() when image != null:
return image(_that);case MessagePreview_Video() when video != null:
return video(_that);case MessagePreview_Audio() when audio != null:
return audio(_that);case MessagePreview_File() when file != null:
return file(_that);case MessagePreview_Location() when location != null:
return location(_that);case MessagePreview_Poll() when poll != null:
return poll(_that);case MessagePreview_Sticker() when sticker != null:
return sticker(_that);case MessagePreview_Redacted() when redacted != null:
return redacted(_that);case MessagePreview_UnableToDecrypt() when unableToDecrypt != null:
return unableToDecrypt(_that);case MessagePreview_Other() when other != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MessagePreview_Text value)  text,required TResult Function( MessagePreview_Image value)  image,required TResult Function( MessagePreview_Video value)  video,required TResult Function( MessagePreview_Audio value)  audio,required TResult Function( MessagePreview_File value)  file,required TResult Function( MessagePreview_Location value)  location,required TResult Function( MessagePreview_Poll value)  poll,required TResult Function( MessagePreview_Sticker value)  sticker,required TResult Function( MessagePreview_Redacted value)  redacted,required TResult Function( MessagePreview_UnableToDecrypt value)  unableToDecrypt,required TResult Function( MessagePreview_Other value)  other,}){
final _that = this;
switch (_that) {
case MessagePreview_Text():
return text(_that);case MessagePreview_Image():
return image(_that);case MessagePreview_Video():
return video(_that);case MessagePreview_Audio():
return audio(_that);case MessagePreview_File():
return file(_that);case MessagePreview_Location():
return location(_that);case MessagePreview_Poll():
return poll(_that);case MessagePreview_Sticker():
return sticker(_that);case MessagePreview_Redacted():
return redacted(_that);case MessagePreview_UnableToDecrypt():
return unableToDecrypt(_that);case MessagePreview_Other():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MessagePreview_Text value)?  text,TResult? Function( MessagePreview_Image value)?  image,TResult? Function( MessagePreview_Video value)?  video,TResult? Function( MessagePreview_Audio value)?  audio,TResult? Function( MessagePreview_File value)?  file,TResult? Function( MessagePreview_Location value)?  location,TResult? Function( MessagePreview_Poll value)?  poll,TResult? Function( MessagePreview_Sticker value)?  sticker,TResult? Function( MessagePreview_Redacted value)?  redacted,TResult? Function( MessagePreview_UnableToDecrypt value)?  unableToDecrypt,TResult? Function( MessagePreview_Other value)?  other,}){
final _that = this;
switch (_that) {
case MessagePreview_Text() when text != null:
return text(_that);case MessagePreview_Image() when image != null:
return image(_that);case MessagePreview_Video() when video != null:
return video(_that);case MessagePreview_Audio() when audio != null:
return audio(_that);case MessagePreview_File() when file != null:
return file(_that);case MessagePreview_Location() when location != null:
return location(_that);case MessagePreview_Poll() when poll != null:
return poll(_that);case MessagePreview_Sticker() when sticker != null:
return sticker(_that);case MessagePreview_Redacted() when redacted != null:
return redacted(_that);case MessagePreview_UnableToDecrypt() when unableToDecrypt != null:
return unableToDecrypt(_that);case MessagePreview_Other() when other != null:
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
case MessagePreview_Text() when text != null:
return text(_that.body);case MessagePreview_Image() when image != null:
return image();case MessagePreview_Video() when video != null:
return video();case MessagePreview_Audio() when audio != null:
return audio();case MessagePreview_File() when file != null:
return file();case MessagePreview_Location() when location != null:
return location();case MessagePreview_Poll() when poll != null:
return poll();case MessagePreview_Sticker() when sticker != null:
return sticker();case MessagePreview_Redacted() when redacted != null:
return redacted();case MessagePreview_UnableToDecrypt() when unableToDecrypt != null:
return unableToDecrypt();case MessagePreview_Other() when other != null:
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
case MessagePreview_Text():
return text(_that.body);case MessagePreview_Image():
return image();case MessagePreview_Video():
return video();case MessagePreview_Audio():
return audio();case MessagePreview_File():
return file();case MessagePreview_Location():
return location();case MessagePreview_Poll():
return poll();case MessagePreview_Sticker():
return sticker();case MessagePreview_Redacted():
return redacted();case MessagePreview_UnableToDecrypt():
return unableToDecrypt();case MessagePreview_Other():
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
case MessagePreview_Text() when text != null:
return text(_that.body);case MessagePreview_Image() when image != null:
return image();case MessagePreview_Video() when video != null:
return video();case MessagePreview_Audio() when audio != null:
return audio();case MessagePreview_File() when file != null:
return file();case MessagePreview_Location() when location != null:
return location();case MessagePreview_Poll() when poll != null:
return poll();case MessagePreview_Sticker() when sticker != null:
return sticker();case MessagePreview_Redacted() when redacted != null:
return redacted();case MessagePreview_UnableToDecrypt() when unableToDecrypt != null:
return unableToDecrypt();case MessagePreview_Other() when other != null:
return other();case _:
  return null;

}
}

}

/// @nodoc


class MessagePreview_Text extends MessagePreview {
  const MessagePreview_Text({required this.body}): super._();
  

 final  String body;

/// Create a copy of MessagePreview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessagePreview_TextCopyWith<MessagePreview_Text> get copyWith => _$MessagePreview_TextCopyWithImpl<MessagePreview_Text>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessagePreview_Text&&(identical(other.body, body) || other.body == body));
}


@override
int get hashCode => Object.hash(runtimeType,body);

@override
String toString() {
  return 'MessagePreview.text(body: $body)';
}


}

/// @nodoc
abstract mixin class $MessagePreview_TextCopyWith<$Res> implements $MessagePreviewCopyWith<$Res> {
  factory $MessagePreview_TextCopyWith(MessagePreview_Text value, $Res Function(MessagePreview_Text) _then) = _$MessagePreview_TextCopyWithImpl;
@useResult
$Res call({
 String body
});




}
/// @nodoc
class _$MessagePreview_TextCopyWithImpl<$Res>
    implements $MessagePreview_TextCopyWith<$Res> {
  _$MessagePreview_TextCopyWithImpl(this._self, this._then);

  final MessagePreview_Text _self;
  final $Res Function(MessagePreview_Text) _then;

/// Create a copy of MessagePreview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? body = null,}) {
  return _then(MessagePreview_Text(
body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class MessagePreview_Image extends MessagePreview {
  const MessagePreview_Image(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessagePreview_Image);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessagePreview.image()';
}


}




/// @nodoc


class MessagePreview_Video extends MessagePreview {
  const MessagePreview_Video(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessagePreview_Video);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessagePreview.video()';
}


}




/// @nodoc


class MessagePreview_Audio extends MessagePreview {
  const MessagePreview_Audio(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessagePreview_Audio);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessagePreview.audio()';
}


}




/// @nodoc


class MessagePreview_File extends MessagePreview {
  const MessagePreview_File(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessagePreview_File);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessagePreview.file()';
}


}




/// @nodoc


class MessagePreview_Location extends MessagePreview {
  const MessagePreview_Location(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessagePreview_Location);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessagePreview.location()';
}


}




/// @nodoc


class MessagePreview_Poll extends MessagePreview {
  const MessagePreview_Poll(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessagePreview_Poll);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessagePreview.poll()';
}


}




/// @nodoc


class MessagePreview_Sticker extends MessagePreview {
  const MessagePreview_Sticker(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessagePreview_Sticker);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessagePreview.sticker()';
}


}




/// @nodoc


class MessagePreview_Redacted extends MessagePreview {
  const MessagePreview_Redacted(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessagePreview_Redacted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessagePreview.redacted()';
}


}




/// @nodoc


class MessagePreview_UnableToDecrypt extends MessagePreview {
  const MessagePreview_UnableToDecrypt(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessagePreview_UnableToDecrypt);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessagePreview.unableToDecrypt()';
}


}




/// @nodoc


class MessagePreview_Other extends MessagePreview {
  const MessagePreview_Other(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessagePreview_Other);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessagePreview.other()';
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SendState_Sending value)?  sending,TResult Function( SendState_Sent value)?  sent,TResult Function( SendState_Failed value)?  failed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SendState_Sending() when sending != null:
return sending(_that);case SendState_Sent() when sent != null:
return sent(_that);case SendState_Failed() when failed != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SendState_Sending value)  sending,required TResult Function( SendState_Sent value)  sent,required TResult Function( SendState_Failed value)  failed,}){
final _that = this;
switch (_that) {
case SendState_Sending():
return sending(_that);case SendState_Sent():
return sent(_that);case SendState_Failed():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SendState_Sending value)?  sending,TResult? Function( SendState_Sent value)?  sent,TResult? Function( SendState_Failed value)?  failed,}){
final _that = this;
switch (_that) {
case SendState_Sending() when sending != null:
return sending(_that);case SendState_Sent() when sent != null:
return sent(_that);case SendState_Failed() when failed != null:
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
case SendState_Sending() when sending != null:
return sending(_that.progress);case SendState_Sent() when sent != null:
return sent();case SendState_Failed() when failed != null:
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
case SendState_Sending():
return sending(_that.progress);case SendState_Sent():
return sent();case SendState_Failed():
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
case SendState_Sending() when sending != null:
return sending(_that.progress);case SendState_Sent() when sent != null:
return sent();case SendState_Failed() when failed != null:
return failed(_that.recoverable);case _:
  return null;

}
}

}

/// @nodoc


class SendState_Sending extends SendState {
  const SendState_Sending({this.progress}): super._();
  

 final  UploadProgress? progress;

/// Create a copy of SendState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SendState_SendingCopyWith<SendState_Sending> get copyWith => _$SendState_SendingCopyWithImpl<SendState_Sending>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendState_Sending&&(identical(other.progress, progress) || other.progress == progress));
}


@override
int get hashCode => Object.hash(runtimeType,progress);

@override
String toString() {
  return 'SendState.sending(progress: $progress)';
}


}

/// @nodoc
abstract mixin class $SendState_SendingCopyWith<$Res> implements $SendStateCopyWith<$Res> {
  factory $SendState_SendingCopyWith(SendState_Sending value, $Res Function(SendState_Sending) _then) = _$SendState_SendingCopyWithImpl;
@useResult
$Res call({
 UploadProgress? progress
});




}
/// @nodoc
class _$SendState_SendingCopyWithImpl<$Res>
    implements $SendState_SendingCopyWith<$Res> {
  _$SendState_SendingCopyWithImpl(this._self, this._then);

  final SendState_Sending _self;
  final $Res Function(SendState_Sending) _then;

/// Create a copy of SendState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? progress = freezed,}) {
  return _then(SendState_Sending(
progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as UploadProgress?,
  ));
}


}

/// @nodoc


class SendState_Sent extends SendState {
  const SendState_Sent(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendState_Sent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SendState.sent()';
}


}




/// @nodoc


class SendState_Failed extends SendState {
  const SendState_Failed({required this.recoverable}): super._();
  

 final  bool recoverable;

/// Create a copy of SendState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SendState_FailedCopyWith<SendState_Failed> get copyWith => _$SendState_FailedCopyWithImpl<SendState_Failed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendState_Failed&&(identical(other.recoverable, recoverable) || other.recoverable == recoverable));
}


@override
int get hashCode => Object.hash(runtimeType,recoverable);

@override
String toString() {
  return 'SendState.failed(recoverable: $recoverable)';
}


}

/// @nodoc
abstract mixin class $SendState_FailedCopyWith<$Res> implements $SendStateCopyWith<$Res> {
  factory $SendState_FailedCopyWith(SendState_Failed value, $Res Function(SendState_Failed) _then) = _$SendState_FailedCopyWithImpl;
@useResult
$Res call({
 bool recoverable
});




}
/// @nodoc
class _$SendState_FailedCopyWithImpl<$Res>
    implements $SendState_FailedCopyWith<$Res> {
  _$SendState_FailedCopyWithImpl(this._self, this._then);

  final SendState_Failed _self;
  final $Res Function(SendState_Failed) _then;

/// Create a copy of SendState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? recoverable = null,}) {
  return _then(SendState_Failed(
recoverable: null == recoverable ? _self.recoverable : recoverable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$TimelineDiff {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineDiff);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TimelineDiff()';
}


}

/// @nodoc
class $TimelineDiffCopyWith<$Res>  {
$TimelineDiffCopyWith(TimelineDiff _, $Res Function(TimelineDiff) __);
}


/// Adds pattern-matching-related methods to [TimelineDiff].
extension TimelineDiffPatterns on TimelineDiff {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TimelineDiff_Append value)?  append,TResult Function( TimelineDiff_Clear value)?  clear,TResult Function( TimelineDiff_PushFront value)?  pushFront,TResult Function( TimelineDiff_PushBack value)?  pushBack,TResult Function( TimelineDiff_PopFront value)?  popFront,TResult Function( TimelineDiff_PopBack value)?  popBack,TResult Function( TimelineDiff_Insert value)?  insert,TResult Function( TimelineDiff_Set value)?  set_,TResult Function( TimelineDiff_Remove value)?  remove,TResult Function( TimelineDiff_Truncate value)?  truncate,TResult Function( TimelineDiff_Reset value)?  reset,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TimelineDiff_Append() when append != null:
return append(_that);case TimelineDiff_Clear() when clear != null:
return clear(_that);case TimelineDiff_PushFront() when pushFront != null:
return pushFront(_that);case TimelineDiff_PushBack() when pushBack != null:
return pushBack(_that);case TimelineDiff_PopFront() when popFront != null:
return popFront(_that);case TimelineDiff_PopBack() when popBack != null:
return popBack(_that);case TimelineDiff_Insert() when insert != null:
return insert(_that);case TimelineDiff_Set() when set_ != null:
return set_(_that);case TimelineDiff_Remove() when remove != null:
return remove(_that);case TimelineDiff_Truncate() when truncate != null:
return truncate(_that);case TimelineDiff_Reset() when reset != null:
return reset(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TimelineDiff_Append value)  append,required TResult Function( TimelineDiff_Clear value)  clear,required TResult Function( TimelineDiff_PushFront value)  pushFront,required TResult Function( TimelineDiff_PushBack value)  pushBack,required TResult Function( TimelineDiff_PopFront value)  popFront,required TResult Function( TimelineDiff_PopBack value)  popBack,required TResult Function( TimelineDiff_Insert value)  insert,required TResult Function( TimelineDiff_Set value)  set_,required TResult Function( TimelineDiff_Remove value)  remove,required TResult Function( TimelineDiff_Truncate value)  truncate,required TResult Function( TimelineDiff_Reset value)  reset,}){
final _that = this;
switch (_that) {
case TimelineDiff_Append():
return append(_that);case TimelineDiff_Clear():
return clear(_that);case TimelineDiff_PushFront():
return pushFront(_that);case TimelineDiff_PushBack():
return pushBack(_that);case TimelineDiff_PopFront():
return popFront(_that);case TimelineDiff_PopBack():
return popBack(_that);case TimelineDiff_Insert():
return insert(_that);case TimelineDiff_Set():
return set_(_that);case TimelineDiff_Remove():
return remove(_that);case TimelineDiff_Truncate():
return truncate(_that);case TimelineDiff_Reset():
return reset(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TimelineDiff_Append value)?  append,TResult? Function( TimelineDiff_Clear value)?  clear,TResult? Function( TimelineDiff_PushFront value)?  pushFront,TResult? Function( TimelineDiff_PushBack value)?  pushBack,TResult? Function( TimelineDiff_PopFront value)?  popFront,TResult? Function( TimelineDiff_PopBack value)?  popBack,TResult? Function( TimelineDiff_Insert value)?  insert,TResult? Function( TimelineDiff_Set value)?  set_,TResult? Function( TimelineDiff_Remove value)?  remove,TResult? Function( TimelineDiff_Truncate value)?  truncate,TResult? Function( TimelineDiff_Reset value)?  reset,}){
final _that = this;
switch (_that) {
case TimelineDiff_Append() when append != null:
return append(_that);case TimelineDiff_Clear() when clear != null:
return clear(_that);case TimelineDiff_PushFront() when pushFront != null:
return pushFront(_that);case TimelineDiff_PushBack() when pushBack != null:
return pushBack(_that);case TimelineDiff_PopFront() when popFront != null:
return popFront(_that);case TimelineDiff_PopBack() when popBack != null:
return popBack(_that);case TimelineDiff_Insert() when insert != null:
return insert(_that);case TimelineDiff_Set() when set_ != null:
return set_(_that);case TimelineDiff_Remove() when remove != null:
return remove(_that);case TimelineDiff_Truncate() when truncate != null:
return truncate(_that);case TimelineDiff_Reset() when reset != null:
return reset(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( List<TimelineItem> values)?  append,TResult Function()?  clear,TResult Function( TimelineItem value)?  pushFront,TResult Function( TimelineItem value)?  pushBack,TResult Function()?  popFront,TResult Function()?  popBack,TResult Function( int index,  TimelineItem value)?  insert,TResult Function( int index,  TimelineItem value)?  set_,TResult Function( int index)?  remove,TResult Function( int length)?  truncate,TResult Function( List<TimelineItem> values)?  reset,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TimelineDiff_Append() when append != null:
return append(_that.values);case TimelineDiff_Clear() when clear != null:
return clear();case TimelineDiff_PushFront() when pushFront != null:
return pushFront(_that.value);case TimelineDiff_PushBack() when pushBack != null:
return pushBack(_that.value);case TimelineDiff_PopFront() when popFront != null:
return popFront();case TimelineDiff_PopBack() when popBack != null:
return popBack();case TimelineDiff_Insert() when insert != null:
return insert(_that.index,_that.value);case TimelineDiff_Set() when set_ != null:
return set_(_that.index,_that.value);case TimelineDiff_Remove() when remove != null:
return remove(_that.index);case TimelineDiff_Truncate() when truncate != null:
return truncate(_that.length);case TimelineDiff_Reset() when reset != null:
return reset(_that.values);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( List<TimelineItem> values)  append,required TResult Function()  clear,required TResult Function( TimelineItem value)  pushFront,required TResult Function( TimelineItem value)  pushBack,required TResult Function()  popFront,required TResult Function()  popBack,required TResult Function( int index,  TimelineItem value)  insert,required TResult Function( int index,  TimelineItem value)  set_,required TResult Function( int index)  remove,required TResult Function( int length)  truncate,required TResult Function( List<TimelineItem> values)  reset,}) {final _that = this;
switch (_that) {
case TimelineDiff_Append():
return append(_that.values);case TimelineDiff_Clear():
return clear();case TimelineDiff_PushFront():
return pushFront(_that.value);case TimelineDiff_PushBack():
return pushBack(_that.value);case TimelineDiff_PopFront():
return popFront();case TimelineDiff_PopBack():
return popBack();case TimelineDiff_Insert():
return insert(_that.index,_that.value);case TimelineDiff_Set():
return set_(_that.index,_that.value);case TimelineDiff_Remove():
return remove(_that.index);case TimelineDiff_Truncate():
return truncate(_that.length);case TimelineDiff_Reset():
return reset(_that.values);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( List<TimelineItem> values)?  append,TResult? Function()?  clear,TResult? Function( TimelineItem value)?  pushFront,TResult? Function( TimelineItem value)?  pushBack,TResult? Function()?  popFront,TResult? Function()?  popBack,TResult? Function( int index,  TimelineItem value)?  insert,TResult? Function( int index,  TimelineItem value)?  set_,TResult? Function( int index)?  remove,TResult? Function( int length)?  truncate,TResult? Function( List<TimelineItem> values)?  reset,}) {final _that = this;
switch (_that) {
case TimelineDiff_Append() when append != null:
return append(_that.values);case TimelineDiff_Clear() when clear != null:
return clear();case TimelineDiff_PushFront() when pushFront != null:
return pushFront(_that.value);case TimelineDiff_PushBack() when pushBack != null:
return pushBack(_that.value);case TimelineDiff_PopFront() when popFront != null:
return popFront();case TimelineDiff_PopBack() when popBack != null:
return popBack();case TimelineDiff_Insert() when insert != null:
return insert(_that.index,_that.value);case TimelineDiff_Set() when set_ != null:
return set_(_that.index,_that.value);case TimelineDiff_Remove() when remove != null:
return remove(_that.index);case TimelineDiff_Truncate() when truncate != null:
return truncate(_that.length);case TimelineDiff_Reset() when reset != null:
return reset(_that.values);case _:
  return null;

}
}

}

/// @nodoc


class TimelineDiff_Append extends TimelineDiff {
  const TimelineDiff_Append({required final  List<TimelineItem> values}): _values = values,super._();
  

 final  List<TimelineItem> _values;
 List<TimelineItem> get values {
  if (_values is EqualUnmodifiableListView) return _values;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_values);
}


/// Create a copy of TimelineDiff
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimelineDiff_AppendCopyWith<TimelineDiff_Append> get copyWith => _$TimelineDiff_AppendCopyWithImpl<TimelineDiff_Append>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineDiff_Append&&const DeepCollectionEquality().equals(other._values, _values));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_values));

@override
String toString() {
  return 'TimelineDiff.append(values: $values)';
}


}

/// @nodoc
abstract mixin class $TimelineDiff_AppendCopyWith<$Res> implements $TimelineDiffCopyWith<$Res> {
  factory $TimelineDiff_AppendCopyWith(TimelineDiff_Append value, $Res Function(TimelineDiff_Append) _then) = _$TimelineDiff_AppendCopyWithImpl;
@useResult
$Res call({
 List<TimelineItem> values
});




}
/// @nodoc
class _$TimelineDiff_AppendCopyWithImpl<$Res>
    implements $TimelineDiff_AppendCopyWith<$Res> {
  _$TimelineDiff_AppendCopyWithImpl(this._self, this._then);

  final TimelineDiff_Append _self;
  final $Res Function(TimelineDiff_Append) _then;

/// Create a copy of TimelineDiff
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? values = null,}) {
  return _then(TimelineDiff_Append(
values: null == values ? _self._values : values // ignore: cast_nullable_to_non_nullable
as List<TimelineItem>,
  ));
}


}

/// @nodoc


class TimelineDiff_Clear extends TimelineDiff {
  const TimelineDiff_Clear(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineDiff_Clear);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TimelineDiff.clear()';
}


}




/// @nodoc


class TimelineDiff_PushFront extends TimelineDiff {
  const TimelineDiff_PushFront({required this.value}): super._();
  

 final  TimelineItem value;

/// Create a copy of TimelineDiff
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimelineDiff_PushFrontCopyWith<TimelineDiff_PushFront> get copyWith => _$TimelineDiff_PushFrontCopyWithImpl<TimelineDiff_PushFront>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineDiff_PushFront&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'TimelineDiff.pushFront(value: $value)';
}


}

/// @nodoc
abstract mixin class $TimelineDiff_PushFrontCopyWith<$Res> implements $TimelineDiffCopyWith<$Res> {
  factory $TimelineDiff_PushFrontCopyWith(TimelineDiff_PushFront value, $Res Function(TimelineDiff_PushFront) _then) = _$TimelineDiff_PushFrontCopyWithImpl;
@useResult
$Res call({
 TimelineItem value
});




}
/// @nodoc
class _$TimelineDiff_PushFrontCopyWithImpl<$Res>
    implements $TimelineDiff_PushFrontCopyWith<$Res> {
  _$TimelineDiff_PushFrontCopyWithImpl(this._self, this._then);

  final TimelineDiff_PushFront _self;
  final $Res Function(TimelineDiff_PushFront) _then;

/// Create a copy of TimelineDiff
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(TimelineDiff_PushFront(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as TimelineItem,
  ));
}


}

/// @nodoc


class TimelineDiff_PushBack extends TimelineDiff {
  const TimelineDiff_PushBack({required this.value}): super._();
  

 final  TimelineItem value;

/// Create a copy of TimelineDiff
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimelineDiff_PushBackCopyWith<TimelineDiff_PushBack> get copyWith => _$TimelineDiff_PushBackCopyWithImpl<TimelineDiff_PushBack>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineDiff_PushBack&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'TimelineDiff.pushBack(value: $value)';
}


}

/// @nodoc
abstract mixin class $TimelineDiff_PushBackCopyWith<$Res> implements $TimelineDiffCopyWith<$Res> {
  factory $TimelineDiff_PushBackCopyWith(TimelineDiff_PushBack value, $Res Function(TimelineDiff_PushBack) _then) = _$TimelineDiff_PushBackCopyWithImpl;
@useResult
$Res call({
 TimelineItem value
});




}
/// @nodoc
class _$TimelineDiff_PushBackCopyWithImpl<$Res>
    implements $TimelineDiff_PushBackCopyWith<$Res> {
  _$TimelineDiff_PushBackCopyWithImpl(this._self, this._then);

  final TimelineDiff_PushBack _self;
  final $Res Function(TimelineDiff_PushBack) _then;

/// Create a copy of TimelineDiff
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(TimelineDiff_PushBack(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as TimelineItem,
  ));
}


}

/// @nodoc


class TimelineDiff_PopFront extends TimelineDiff {
  const TimelineDiff_PopFront(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineDiff_PopFront);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TimelineDiff.popFront()';
}


}




/// @nodoc


class TimelineDiff_PopBack extends TimelineDiff {
  const TimelineDiff_PopBack(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineDiff_PopBack);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TimelineDiff.popBack()';
}


}




/// @nodoc


class TimelineDiff_Insert extends TimelineDiff {
  const TimelineDiff_Insert({required this.index, required this.value}): super._();
  

 final  int index;
 final  TimelineItem value;

/// Create a copy of TimelineDiff
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimelineDiff_InsertCopyWith<TimelineDiff_Insert> get copyWith => _$TimelineDiff_InsertCopyWithImpl<TimelineDiff_Insert>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineDiff_Insert&&(identical(other.index, index) || other.index == index)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,index,value);

@override
String toString() {
  return 'TimelineDiff.insert(index: $index, value: $value)';
}


}

/// @nodoc
abstract mixin class $TimelineDiff_InsertCopyWith<$Res> implements $TimelineDiffCopyWith<$Res> {
  factory $TimelineDiff_InsertCopyWith(TimelineDiff_Insert value, $Res Function(TimelineDiff_Insert) _then) = _$TimelineDiff_InsertCopyWithImpl;
@useResult
$Res call({
 int index, TimelineItem value
});




}
/// @nodoc
class _$TimelineDiff_InsertCopyWithImpl<$Res>
    implements $TimelineDiff_InsertCopyWith<$Res> {
  _$TimelineDiff_InsertCopyWithImpl(this._self, this._then);

  final TimelineDiff_Insert _self;
  final $Res Function(TimelineDiff_Insert) _then;

/// Create a copy of TimelineDiff
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? index = null,Object? value = null,}) {
  return _then(TimelineDiff_Insert(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as TimelineItem,
  ));
}


}

/// @nodoc


class TimelineDiff_Set extends TimelineDiff {
  const TimelineDiff_Set({required this.index, required this.value}): super._();
  

 final  int index;
 final  TimelineItem value;

/// Create a copy of TimelineDiff
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimelineDiff_SetCopyWith<TimelineDiff_Set> get copyWith => _$TimelineDiff_SetCopyWithImpl<TimelineDiff_Set>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineDiff_Set&&(identical(other.index, index) || other.index == index)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,index,value);

@override
String toString() {
  return 'TimelineDiff.set_(index: $index, value: $value)';
}


}

/// @nodoc
abstract mixin class $TimelineDiff_SetCopyWith<$Res> implements $TimelineDiffCopyWith<$Res> {
  factory $TimelineDiff_SetCopyWith(TimelineDiff_Set value, $Res Function(TimelineDiff_Set) _then) = _$TimelineDiff_SetCopyWithImpl;
@useResult
$Res call({
 int index, TimelineItem value
});




}
/// @nodoc
class _$TimelineDiff_SetCopyWithImpl<$Res>
    implements $TimelineDiff_SetCopyWith<$Res> {
  _$TimelineDiff_SetCopyWithImpl(this._self, this._then);

  final TimelineDiff_Set _self;
  final $Res Function(TimelineDiff_Set) _then;

/// Create a copy of TimelineDiff
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? index = null,Object? value = null,}) {
  return _then(TimelineDiff_Set(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as TimelineItem,
  ));
}


}

/// @nodoc


class TimelineDiff_Remove extends TimelineDiff {
  const TimelineDiff_Remove({required this.index}): super._();
  

 final  int index;

/// Create a copy of TimelineDiff
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimelineDiff_RemoveCopyWith<TimelineDiff_Remove> get copyWith => _$TimelineDiff_RemoveCopyWithImpl<TimelineDiff_Remove>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineDiff_Remove&&(identical(other.index, index) || other.index == index));
}


@override
int get hashCode => Object.hash(runtimeType,index);

@override
String toString() {
  return 'TimelineDiff.remove(index: $index)';
}


}

/// @nodoc
abstract mixin class $TimelineDiff_RemoveCopyWith<$Res> implements $TimelineDiffCopyWith<$Res> {
  factory $TimelineDiff_RemoveCopyWith(TimelineDiff_Remove value, $Res Function(TimelineDiff_Remove) _then) = _$TimelineDiff_RemoveCopyWithImpl;
@useResult
$Res call({
 int index
});




}
/// @nodoc
class _$TimelineDiff_RemoveCopyWithImpl<$Res>
    implements $TimelineDiff_RemoveCopyWith<$Res> {
  _$TimelineDiff_RemoveCopyWithImpl(this._self, this._then);

  final TimelineDiff_Remove _self;
  final $Res Function(TimelineDiff_Remove) _then;

/// Create a copy of TimelineDiff
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? index = null,}) {
  return _then(TimelineDiff_Remove(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class TimelineDiff_Truncate extends TimelineDiff {
  const TimelineDiff_Truncate({required this.length}): super._();
  

 final  int length;

/// Create a copy of TimelineDiff
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimelineDiff_TruncateCopyWith<TimelineDiff_Truncate> get copyWith => _$TimelineDiff_TruncateCopyWithImpl<TimelineDiff_Truncate>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineDiff_Truncate&&(identical(other.length, length) || other.length == length));
}


@override
int get hashCode => Object.hash(runtimeType,length);

@override
String toString() {
  return 'TimelineDiff.truncate(length: $length)';
}


}

/// @nodoc
abstract mixin class $TimelineDiff_TruncateCopyWith<$Res> implements $TimelineDiffCopyWith<$Res> {
  factory $TimelineDiff_TruncateCopyWith(TimelineDiff_Truncate value, $Res Function(TimelineDiff_Truncate) _then) = _$TimelineDiff_TruncateCopyWithImpl;
@useResult
$Res call({
 int length
});




}
/// @nodoc
class _$TimelineDiff_TruncateCopyWithImpl<$Res>
    implements $TimelineDiff_TruncateCopyWith<$Res> {
  _$TimelineDiff_TruncateCopyWithImpl(this._self, this._then);

  final TimelineDiff_Truncate _self;
  final $Res Function(TimelineDiff_Truncate) _then;

/// Create a copy of TimelineDiff
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? length = null,}) {
  return _then(TimelineDiff_Truncate(
length: null == length ? _self.length : length // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class TimelineDiff_Reset extends TimelineDiff {
  const TimelineDiff_Reset({required final  List<TimelineItem> values}): _values = values,super._();
  

 final  List<TimelineItem> _values;
 List<TimelineItem> get values {
  if (_values is EqualUnmodifiableListView) return _values;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_values);
}


/// Create a copy of TimelineDiff
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimelineDiff_ResetCopyWith<TimelineDiff_Reset> get copyWith => _$TimelineDiff_ResetCopyWithImpl<TimelineDiff_Reset>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineDiff_Reset&&const DeepCollectionEquality().equals(other._values, _values));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_values));

@override
String toString() {
  return 'TimelineDiff.reset(values: $values)';
}


}

/// @nodoc
abstract mixin class $TimelineDiff_ResetCopyWith<$Res> implements $TimelineDiffCopyWith<$Res> {
  factory $TimelineDiff_ResetCopyWith(TimelineDiff_Reset value, $Res Function(TimelineDiff_Reset) _then) = _$TimelineDiff_ResetCopyWithImpl;
@useResult
$Res call({
 List<TimelineItem> values
});




}
/// @nodoc
class _$TimelineDiff_ResetCopyWithImpl<$Res>
    implements $TimelineDiff_ResetCopyWith<$Res> {
  _$TimelineDiff_ResetCopyWithImpl(this._self, this._then);

  final TimelineDiff_Reset _self;
  final $Res Function(TimelineDiff_Reset) _then;

/// Create a copy of TimelineDiff
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? values = null,}) {
  return _then(TimelineDiff_Reset(
values: null == values ? _self._values : values // ignore: cast_nullable_to_non_nullable
as List<TimelineItem>,
  ));
}


}

/// @nodoc
mixin _$TimelineItemKind {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineItemKind);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TimelineItemKind()';
}


}

/// @nodoc
class $TimelineItemKindCopyWith<$Res>  {
$TimelineItemKindCopyWith(TimelineItemKind _, $Res Function(TimelineItemKind) __);
}


/// Adds pattern-matching-related methods to [TimelineItemKind].
extension TimelineItemKindPatterns on TimelineItemKind {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TimelineItemKind_Event value)?  event,TResult Function( TimelineItemKind_DateDivider value)?  dateDivider,TResult Function( TimelineItemKind_ReadMarker value)?  readMarker,TResult Function( TimelineItemKind_TimelineStart value)?  timelineStart,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TimelineItemKind_Event() when event != null:
return event(_that);case TimelineItemKind_DateDivider() when dateDivider != null:
return dateDivider(_that);case TimelineItemKind_ReadMarker() when readMarker != null:
return readMarker(_that);case TimelineItemKind_TimelineStart() when timelineStart != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TimelineItemKind_Event value)  event,required TResult Function( TimelineItemKind_DateDivider value)  dateDivider,required TResult Function( TimelineItemKind_ReadMarker value)  readMarker,required TResult Function( TimelineItemKind_TimelineStart value)  timelineStart,}){
final _that = this;
switch (_that) {
case TimelineItemKind_Event():
return event(_that);case TimelineItemKind_DateDivider():
return dateDivider(_that);case TimelineItemKind_ReadMarker():
return readMarker(_that);case TimelineItemKind_TimelineStart():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TimelineItemKind_Event value)?  event,TResult? Function( TimelineItemKind_DateDivider value)?  dateDivider,TResult? Function( TimelineItemKind_ReadMarker value)?  readMarker,TResult? Function( TimelineItemKind_TimelineStart value)?  timelineStart,}){
final _that = this;
switch (_that) {
case TimelineItemKind_Event() when event != null:
return event(_that);case TimelineItemKind_DateDivider() when dateDivider != null:
return dateDivider(_that);case TimelineItemKind_ReadMarker() when readMarker != null:
return readMarker(_that);case TimelineItemKind_TimelineStart() when timelineStart != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( EventItem event)?  event,TResult Function( PlatformInt64 timestampMs)?  dateDivider,TResult Function()?  readMarker,TResult Function()?  timelineStart,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TimelineItemKind_Event() when event != null:
return event(_that.event);case TimelineItemKind_DateDivider() when dateDivider != null:
return dateDivider(_that.timestampMs);case TimelineItemKind_ReadMarker() when readMarker != null:
return readMarker();case TimelineItemKind_TimelineStart() when timelineStart != null:
return timelineStart();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( EventItem event)  event,required TResult Function( PlatformInt64 timestampMs)  dateDivider,required TResult Function()  readMarker,required TResult Function()  timelineStart,}) {final _that = this;
switch (_that) {
case TimelineItemKind_Event():
return event(_that.event);case TimelineItemKind_DateDivider():
return dateDivider(_that.timestampMs);case TimelineItemKind_ReadMarker():
return readMarker();case TimelineItemKind_TimelineStart():
return timelineStart();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( EventItem event)?  event,TResult? Function( PlatformInt64 timestampMs)?  dateDivider,TResult? Function()?  readMarker,TResult? Function()?  timelineStart,}) {final _that = this;
switch (_that) {
case TimelineItemKind_Event() when event != null:
return event(_that.event);case TimelineItemKind_DateDivider() when dateDivider != null:
return dateDivider(_that.timestampMs);case TimelineItemKind_ReadMarker() when readMarker != null:
return readMarker();case TimelineItemKind_TimelineStart() when timelineStart != null:
return timelineStart();case _:
  return null;

}
}

}

/// @nodoc


class TimelineItemKind_Event extends TimelineItemKind {
  const TimelineItemKind_Event({required this.event}): super._();
  

 final  EventItem event;

/// Create a copy of TimelineItemKind
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimelineItemKind_EventCopyWith<TimelineItemKind_Event> get copyWith => _$TimelineItemKind_EventCopyWithImpl<TimelineItemKind_Event>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineItemKind_Event&&(identical(other.event, event) || other.event == event));
}


@override
int get hashCode => Object.hash(runtimeType,event);

@override
String toString() {
  return 'TimelineItemKind.event(event: $event)';
}


}

/// @nodoc
abstract mixin class $TimelineItemKind_EventCopyWith<$Res> implements $TimelineItemKindCopyWith<$Res> {
  factory $TimelineItemKind_EventCopyWith(TimelineItemKind_Event value, $Res Function(TimelineItemKind_Event) _then) = _$TimelineItemKind_EventCopyWithImpl;
@useResult
$Res call({
 EventItem event
});




}
/// @nodoc
class _$TimelineItemKind_EventCopyWithImpl<$Res>
    implements $TimelineItemKind_EventCopyWith<$Res> {
  _$TimelineItemKind_EventCopyWithImpl(this._self, this._then);

  final TimelineItemKind_Event _self;
  final $Res Function(TimelineItemKind_Event) _then;

/// Create a copy of TimelineItemKind
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? event = null,}) {
  return _then(TimelineItemKind_Event(
event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as EventItem,
  ));
}


}

/// @nodoc


class TimelineItemKind_DateDivider extends TimelineItemKind {
  const TimelineItemKind_DateDivider({required this.timestampMs}): super._();
  

 final  PlatformInt64 timestampMs;

/// Create a copy of TimelineItemKind
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimelineItemKind_DateDividerCopyWith<TimelineItemKind_DateDivider> get copyWith => _$TimelineItemKind_DateDividerCopyWithImpl<TimelineItemKind_DateDivider>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineItemKind_DateDivider&&(identical(other.timestampMs, timestampMs) || other.timestampMs == timestampMs));
}


@override
int get hashCode => Object.hash(runtimeType,timestampMs);

@override
String toString() {
  return 'TimelineItemKind.dateDivider(timestampMs: $timestampMs)';
}


}

/// @nodoc
abstract mixin class $TimelineItemKind_DateDividerCopyWith<$Res> implements $TimelineItemKindCopyWith<$Res> {
  factory $TimelineItemKind_DateDividerCopyWith(TimelineItemKind_DateDivider value, $Res Function(TimelineItemKind_DateDivider) _then) = _$TimelineItemKind_DateDividerCopyWithImpl;
@useResult
$Res call({
 PlatformInt64 timestampMs
});




}
/// @nodoc
class _$TimelineItemKind_DateDividerCopyWithImpl<$Res>
    implements $TimelineItemKind_DateDividerCopyWith<$Res> {
  _$TimelineItemKind_DateDividerCopyWithImpl(this._self, this._then);

  final TimelineItemKind_DateDivider _self;
  final $Res Function(TimelineItemKind_DateDivider) _then;

/// Create a copy of TimelineItemKind
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? timestampMs = null,}) {
  return _then(TimelineItemKind_DateDivider(
timestampMs: null == timestampMs ? _self.timestampMs : timestampMs // ignore: cast_nullable_to_non_nullable
as PlatformInt64,
  ));
}


}

/// @nodoc


class TimelineItemKind_ReadMarker extends TimelineItemKind {
  const TimelineItemKind_ReadMarker(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineItemKind_ReadMarker);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TimelineItemKind.readMarker()';
}


}




/// @nodoc


class TimelineItemKind_TimelineStart extends TimelineItemKind {
  const TimelineItemKind_TimelineStart(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineItemKind_TimelineStart);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TimelineItemKind.timelineStart()';
}


}




// dart format on
