// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ContactAddress {

 int get id; String? get type; String? get line1; String? get line2; String? get postalCode; String? get city; String? get state; String? get country;
/// Create a copy of ContactAddress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactAddressCopyWith<ContactAddress> get copyWith => _$ContactAddressCopyWithImpl<ContactAddress>(this as ContactAddress, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactAddress&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.line1, line1) || other.line1 == line1)&&(identical(other.line2, line2) || other.line2 == line2)&&(identical(other.postalCode, postalCode) || other.postalCode == postalCode)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.country, country) || other.country == country));
}


@override
int get hashCode => Object.hash(runtimeType,id,type,line1,line2,postalCode,city,state,country);

@override
String toString() {
  return 'ContactAddress(id: $id, type: $type, line1: $line1, line2: $line2, postalCode: $postalCode, city: $city, state: $state, country: $country)';
}


}

/// @nodoc
abstract mixin class $ContactAddressCopyWith<$Res>  {
  factory $ContactAddressCopyWith(ContactAddress value, $Res Function(ContactAddress) _then) = _$ContactAddressCopyWithImpl;
@useResult
$Res call({
 int id, String? type, String? line1, String? line2, String? postalCode, String? city, String? state, String? country
});




}
/// @nodoc
class _$ContactAddressCopyWithImpl<$Res>
    implements $ContactAddressCopyWith<$Res> {
  _$ContactAddressCopyWithImpl(this._self, this._then);

  final ContactAddress _self;
  final $Res Function(ContactAddress) _then;

/// Create a copy of ContactAddress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = freezed,Object? line1 = freezed,Object? line2 = freezed,Object? postalCode = freezed,Object? city = freezed,Object? state = freezed,Object? country = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,line1: freezed == line1 ? _self.line1 : line1 // ignore: cast_nullable_to_non_nullable
as String?,line2: freezed == line2 ? _self.line2 : line2 // ignore: cast_nullable_to_non_nullable
as String?,postalCode: freezed == postalCode ? _self.postalCode : postalCode // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ContactAddress].
extension ContactAddressPatterns on ContactAddress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContactAddress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContactAddress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContactAddress value)  $default,){
final _that = this;
switch (_that) {
case _ContactAddress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContactAddress value)?  $default,){
final _that = this;
switch (_that) {
case _ContactAddress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String? type,  String? line1,  String? line2,  String? postalCode,  String? city,  String? state,  String? country)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContactAddress() when $default != null:
return $default(_that.id,_that.type,_that.line1,_that.line2,_that.postalCode,_that.city,_that.state,_that.country);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String? type,  String? line1,  String? line2,  String? postalCode,  String? city,  String? state,  String? country)  $default,) {final _that = this;
switch (_that) {
case _ContactAddress():
return $default(_that.id,_that.type,_that.line1,_that.line2,_that.postalCode,_that.city,_that.state,_that.country);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String? type,  String? line1,  String? line2,  String? postalCode,  String? city,  String? state,  String? country)?  $default,) {final _that = this;
switch (_that) {
case _ContactAddress() when $default != null:
return $default(_that.id,_that.type,_that.line1,_that.line2,_that.postalCode,_that.city,_that.state,_that.country);case _:
  return null;

}
}

}

/// @nodoc


class _ContactAddress implements ContactAddress {
  const _ContactAddress({required this.id, this.type, this.line1, this.line2, this.postalCode, this.city, this.state, this.country});


@override final  int id;
@override final  String? type;
@override final  String? line1;
@override final  String? line2;
@override final  String? postalCode;
@override final  String? city;
@override final  String? state;
@override final  String? country;

/// Create a copy of ContactAddress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactAddressCopyWith<_ContactAddress> get copyWith => __$ContactAddressCopyWithImpl<_ContactAddress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContactAddress&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.line1, line1) || other.line1 == line1)&&(identical(other.line2, line2) || other.line2 == line2)&&(identical(other.postalCode, postalCode) || other.postalCode == postalCode)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.country, country) || other.country == country));
}


@override
int get hashCode => Object.hash(runtimeType,id,type,line1,line2,postalCode,city,state,country);

@override
String toString() {
  return 'ContactAddress(id: $id, type: $type, line1: $line1, line2: $line2, postalCode: $postalCode, city: $city, state: $state, country: $country)';
}


}

/// @nodoc
abstract mixin class _$ContactAddressCopyWith<$Res> implements $ContactAddressCopyWith<$Res> {
  factory _$ContactAddressCopyWith(_ContactAddress value, $Res Function(_ContactAddress) _then) = __$ContactAddressCopyWithImpl;
@override @useResult
$Res call({
 int id, String? type, String? line1, String? line2, String? postalCode, String? city, String? state, String? country
});




}
/// @nodoc
class __$ContactAddressCopyWithImpl<$Res>
    implements _$ContactAddressCopyWith<$Res> {
  __$ContactAddressCopyWithImpl(this._self, this._then);

  final _ContactAddress _self;
  final $Res Function(_ContactAddress) _then;

/// Create a copy of ContactAddress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = freezed,Object? line1 = freezed,Object? line2 = freezed,Object? postalCode = freezed,Object? city = freezed,Object? state = freezed,Object? country = freezed,}) {
  return _then(_ContactAddress(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,line1: freezed == line1 ? _self.line1 : line1 // ignore: cast_nullable_to_non_nullable
as String?,line2: freezed == line2 ? _self.line2 : line2 // ignore: cast_nullable_to_non_nullable
as String?,postalCode: freezed == postalCode ? _self.postalCode : postalCode // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$ContactRecord {

 int get id; ContactKind get kind; String get version; String? get name; String? get firstName; String? get lastName; String? get email; String? get salutation; String? get title; String? get gender; DateTime? get birthday; int? get activeAddressId; DateTime? get updatedAt; List<ContactAddress> get addresses;
/// Create a copy of ContactRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactRecordCopyWith<ContactRecord> get copyWith => _$ContactRecordCopyWithImpl<ContactRecord>(this as ContactRecord, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.version, version) || other.version == version)&&(identical(other.name, name) || other.name == name)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.salutation, salutation) || other.salutation == salutation)&&(identical(other.title, title) || other.title == title)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.birthday, birthday) || other.birthday == birthday)&&(identical(other.activeAddressId, activeAddressId) || other.activeAddressId == activeAddressId)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.addresses, addresses));
}


@override
int get hashCode => Object.hash(runtimeType,id,kind,version,name,firstName,lastName,email,salutation,title,gender,birthday,activeAddressId,updatedAt,const DeepCollectionEquality().hash(addresses));

@override
String toString() {
  return 'ContactRecord(id: $id, kind: $kind, version: $version, name: $name, firstName: $firstName, lastName: $lastName, email: $email, salutation: $salutation, title: $title, gender: $gender, birthday: $birthday, activeAddressId: $activeAddressId, updatedAt: $updatedAt, addresses: $addresses)';
}


}

/// @nodoc
abstract mixin class $ContactRecordCopyWith<$Res>  {
  factory $ContactRecordCopyWith(ContactRecord value, $Res Function(ContactRecord) _then) = _$ContactRecordCopyWithImpl;
@useResult
$Res call({
 int id, ContactKind kind, String version, String? name, String? firstName, String? lastName, String? email, String? salutation, String? title, String? gender, DateTime? birthday, int? activeAddressId, DateTime? updatedAt, List<ContactAddress> addresses
});




}
/// @nodoc
class _$ContactRecordCopyWithImpl<$Res>
    implements $ContactRecordCopyWith<$Res> {
  _$ContactRecordCopyWithImpl(this._self, this._then);

  final ContactRecord _self;
  final $Res Function(ContactRecord) _then;

/// Create a copy of ContactRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? version = null,Object? name = freezed,Object? firstName = freezed,Object? lastName = freezed,Object? email = freezed,Object? salutation = freezed,Object? title = freezed,Object? gender = freezed,Object? birthday = freezed,Object? activeAddressId = freezed,Object? updatedAt = freezed,Object? addresses = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ContactKind,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,salutation: freezed == salutation ? _self.salutation : salutation // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,birthday: freezed == birthday ? _self.birthday : birthday // ignore: cast_nullable_to_non_nullable
as DateTime?,activeAddressId: freezed == activeAddressId ? _self.activeAddressId : activeAddressId // ignore: cast_nullable_to_non_nullable
as int?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,addresses: null == addresses ? _self.addresses : addresses // ignore: cast_nullable_to_non_nullable
as List<ContactAddress>,
  ));
}

}


/// Adds pattern-matching-related methods to [ContactRecord].
extension ContactRecordPatterns on ContactRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContactRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContactRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContactRecord value)  $default,){
final _that = this;
switch (_that) {
case _ContactRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContactRecord value)?  $default,){
final _that = this;
switch (_that) {
case _ContactRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  ContactKind kind,  String version,  String? name,  String? firstName,  String? lastName,  String? email,  String? salutation,  String? title,  String? gender,  DateTime? birthday,  int? activeAddressId,  DateTime? updatedAt,  List<ContactAddress> addresses)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContactRecord() when $default != null:
return $default(_that.id,_that.kind,_that.version,_that.name,_that.firstName,_that.lastName,_that.email,_that.salutation,_that.title,_that.gender,_that.birthday,_that.activeAddressId,_that.updatedAt,_that.addresses);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  ContactKind kind,  String version,  String? name,  String? firstName,  String? lastName,  String? email,  String? salutation,  String? title,  String? gender,  DateTime? birthday,  int? activeAddressId,  DateTime? updatedAt,  List<ContactAddress> addresses)  $default,) {final _that = this;
switch (_that) {
case _ContactRecord():
return $default(_that.id,_that.kind,_that.version,_that.name,_that.firstName,_that.lastName,_that.email,_that.salutation,_that.title,_that.gender,_that.birthday,_that.activeAddressId,_that.updatedAt,_that.addresses);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  ContactKind kind,  String version,  String? name,  String? firstName,  String? lastName,  String? email,  String? salutation,  String? title,  String? gender,  DateTime? birthday,  int? activeAddressId,  DateTime? updatedAt,  List<ContactAddress> addresses)?  $default,) {final _that = this;
switch (_that) {
case _ContactRecord() when $default != null:
return $default(_that.id,_that.kind,_that.version,_that.name,_that.firstName,_that.lastName,_that.email,_that.salutation,_that.title,_that.gender,_that.birthday,_that.activeAddressId,_that.updatedAt,_that.addresses);case _:
  return null;

}
}

}

/// @nodoc


class _ContactRecord extends ContactRecord {
  const _ContactRecord({required this.id, required this.kind, required this.version, this.name, this.firstName, this.lastName, this.email, this.salutation, this.title, this.gender, this.birthday, this.activeAddressId, this.updatedAt, final  List<ContactAddress> addresses = const <ContactAddress>[]}): _addresses = addresses,super._();


@override final  int id;
@override final  ContactKind kind;
@override final  String version;
@override final  String? name;
@override final  String? firstName;
@override final  String? lastName;
@override final  String? email;
@override final  String? salutation;
@override final  String? title;
@override final  String? gender;
@override final  DateTime? birthday;
@override final  int? activeAddressId;
@override final  DateTime? updatedAt;
 final  List<ContactAddress> _addresses;
@override@JsonKey() List<ContactAddress> get addresses {
  if (_addresses is EqualUnmodifiableListView) return _addresses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_addresses);
}


/// Create a copy of ContactRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactRecordCopyWith<_ContactRecord> get copyWith => __$ContactRecordCopyWithImpl<_ContactRecord>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContactRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.version, version) || other.version == version)&&(identical(other.name, name) || other.name == name)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.salutation, salutation) || other.salutation == salutation)&&(identical(other.title, title) || other.title == title)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.birthday, birthday) || other.birthday == birthday)&&(identical(other.activeAddressId, activeAddressId) || other.activeAddressId == activeAddressId)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._addresses, _addresses));
}


@override
int get hashCode => Object.hash(runtimeType,id,kind,version,name,firstName,lastName,email,salutation,title,gender,birthday,activeAddressId,updatedAt,const DeepCollectionEquality().hash(_addresses));

@override
String toString() {
  return 'ContactRecord(id: $id, kind: $kind, version: $version, name: $name, firstName: $firstName, lastName: $lastName, email: $email, salutation: $salutation, title: $title, gender: $gender, birthday: $birthday, activeAddressId: $activeAddressId, updatedAt: $updatedAt, addresses: $addresses)';
}


}

/// @nodoc
abstract mixin class _$ContactRecordCopyWith<$Res> implements $ContactRecordCopyWith<$Res> {
  factory _$ContactRecordCopyWith(_ContactRecord value, $Res Function(_ContactRecord) _then) = __$ContactRecordCopyWithImpl;
@override @useResult
$Res call({
 int id, ContactKind kind, String version, String? name, String? firstName, String? lastName, String? email, String? salutation, String? title, String? gender, DateTime? birthday, int? activeAddressId, DateTime? updatedAt, List<ContactAddress> addresses
});




}
/// @nodoc
class __$ContactRecordCopyWithImpl<$Res>
    implements _$ContactRecordCopyWith<$Res> {
  __$ContactRecordCopyWithImpl(this._self, this._then);

  final _ContactRecord _self;
  final $Res Function(_ContactRecord) _then;

/// Create a copy of ContactRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? version = null,Object? name = freezed,Object? firstName = freezed,Object? lastName = freezed,Object? email = freezed,Object? salutation = freezed,Object? title = freezed,Object? gender = freezed,Object? birthday = freezed,Object? activeAddressId = freezed,Object? updatedAt = freezed,Object? addresses = null,}) {
  return _then(_ContactRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ContactKind,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,salutation: freezed == salutation ? _self.salutation : salutation // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,birthday: freezed == birthday ? _self.birthday : birthday // ignore: cast_nullable_to_non_nullable
as DateTime?,activeAddressId: freezed == activeAddressId ? _self.activeAddressId : activeAddressId // ignore: cast_nullable_to_non_nullable
as int?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,addresses: null == addresses ? _self._addresses : addresses // ignore: cast_nullable_to_non_nullable
as List<ContactAddress>,
  ));
}


}

/// @nodoc
mixin _$ContactDraft {

 String get localId; String get idempotencyKey; ContactDraftKind get kind; DateTime get createdAt; DateTime get updatedAt; int? get contactId; String? get baseVersion; String? get name; String? get firstName; String? get lastName; String? get email; String? get salutation; String? get title; String? get gender; DateTime? get birthday; ContactDraftState get state;
/// Create a copy of ContactDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactDraftCopyWith<ContactDraft> get copyWith => _$ContactDraftCopyWithImpl<ContactDraft>(this as ContactDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactDraft&&(identical(other.localId, localId) || other.localId == localId)&&(identical(other.idempotencyKey, idempotencyKey) || other.idempotencyKey == idempotencyKey)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.contactId, contactId) || other.contactId == contactId)&&(identical(other.baseVersion, baseVersion) || other.baseVersion == baseVersion)&&(identical(other.name, name) || other.name == name)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.salutation, salutation) || other.salutation == salutation)&&(identical(other.title, title) || other.title == title)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.birthday, birthday) || other.birthday == birthday)&&(identical(other.state, state) || other.state == state));
}


@override
int get hashCode => Object.hash(runtimeType,localId,idempotencyKey,kind,createdAt,updatedAt,contactId,baseVersion,name,firstName,lastName,email,salutation,title,gender,birthday,state);

@override
String toString() {
  return 'ContactDraft(localId: $localId, idempotencyKey: $idempotencyKey, kind: $kind, createdAt: $createdAt, updatedAt: $updatedAt, contactId: $contactId, baseVersion: $baseVersion, name: $name, firstName: $firstName, lastName: $lastName, email: $email, salutation: $salutation, title: $title, gender: $gender, birthday: $birthday, state: $state)';
}


}

/// @nodoc
abstract mixin class $ContactDraftCopyWith<$Res>  {
  factory $ContactDraftCopyWith(ContactDraft value, $Res Function(ContactDraft) _then) = _$ContactDraftCopyWithImpl;
@useResult
$Res call({
 String localId, String idempotencyKey, ContactDraftKind kind, DateTime createdAt, DateTime updatedAt, int? contactId, String? baseVersion, String? name, String? firstName, String? lastName, String? email, String? salutation, String? title, String? gender, DateTime? birthday, ContactDraftState state
});




}
/// @nodoc
class _$ContactDraftCopyWithImpl<$Res>
    implements $ContactDraftCopyWith<$Res> {
  _$ContactDraftCopyWithImpl(this._self, this._then);

  final ContactDraft _self;
  final $Res Function(ContactDraft) _then;

/// Create a copy of ContactDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? localId = null,Object? idempotencyKey = null,Object? kind = null,Object? createdAt = null,Object? updatedAt = null,Object? contactId = freezed,Object? baseVersion = freezed,Object? name = freezed,Object? firstName = freezed,Object? lastName = freezed,Object? email = freezed,Object? salutation = freezed,Object? title = freezed,Object? gender = freezed,Object? birthday = freezed,Object? state = null,}) {
  return _then(_self.copyWith(
localId: null == localId ? _self.localId : localId // ignore: cast_nullable_to_non_nullable
as String,idempotencyKey: null == idempotencyKey ? _self.idempotencyKey : idempotencyKey // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ContactDraftKind,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,contactId: freezed == contactId ? _self.contactId : contactId // ignore: cast_nullable_to_non_nullable
as int?,baseVersion: freezed == baseVersion ? _self.baseVersion : baseVersion // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,salutation: freezed == salutation ? _self.salutation : salutation // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,birthday: freezed == birthday ? _self.birthday : birthday // ignore: cast_nullable_to_non_nullable
as DateTime?,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as ContactDraftState,
  ));
}

}


/// Adds pattern-matching-related methods to [ContactDraft].
extension ContactDraftPatterns on ContactDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContactDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContactDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContactDraft value)  $default,){
final _that = this;
switch (_that) {
case _ContactDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContactDraft value)?  $default,){
final _that = this;
switch (_that) {
case _ContactDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String localId,  String idempotencyKey,  ContactDraftKind kind,  DateTime createdAt,  DateTime updatedAt,  int? contactId,  String? baseVersion,  String? name,  String? firstName,  String? lastName,  String? email,  String? salutation,  String? title,  String? gender,  DateTime? birthday,  ContactDraftState state)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContactDraft() when $default != null:
return $default(_that.localId,_that.idempotencyKey,_that.kind,_that.createdAt,_that.updatedAt,_that.contactId,_that.baseVersion,_that.name,_that.firstName,_that.lastName,_that.email,_that.salutation,_that.title,_that.gender,_that.birthday,_that.state);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String localId,  String idempotencyKey,  ContactDraftKind kind,  DateTime createdAt,  DateTime updatedAt,  int? contactId,  String? baseVersion,  String? name,  String? firstName,  String? lastName,  String? email,  String? salutation,  String? title,  String? gender,  DateTime? birthday,  ContactDraftState state)  $default,) {final _that = this;
switch (_that) {
case _ContactDraft():
return $default(_that.localId,_that.idempotencyKey,_that.kind,_that.createdAt,_that.updatedAt,_that.contactId,_that.baseVersion,_that.name,_that.firstName,_that.lastName,_that.email,_that.salutation,_that.title,_that.gender,_that.birthday,_that.state);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String localId,  String idempotencyKey,  ContactDraftKind kind,  DateTime createdAt,  DateTime updatedAt,  int? contactId,  String? baseVersion,  String? name,  String? firstName,  String? lastName,  String? email,  String? salutation,  String? title,  String? gender,  DateTime? birthday,  ContactDraftState state)?  $default,) {final _that = this;
switch (_that) {
case _ContactDraft() when $default != null:
return $default(_that.localId,_that.idempotencyKey,_that.kind,_that.createdAt,_that.updatedAt,_that.contactId,_that.baseVersion,_that.name,_that.firstName,_that.lastName,_that.email,_that.salutation,_that.title,_that.gender,_that.birthday,_that.state);case _:
  return null;

}
}

}

/// @nodoc


class _ContactDraft implements ContactDraft {
  const _ContactDraft({required this.localId, required this.idempotencyKey, required this.kind, required this.createdAt, required this.updatedAt, this.contactId, this.baseVersion, this.name, this.firstName, this.lastName, this.email, this.salutation, this.title, this.gender, this.birthday, this.state = ContactDraftState.local});


@override final  String localId;
@override final  String idempotencyKey;
@override final  ContactDraftKind kind;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  int? contactId;
@override final  String? baseVersion;
@override final  String? name;
@override final  String? firstName;
@override final  String? lastName;
@override final  String? email;
@override final  String? salutation;
@override final  String? title;
@override final  String? gender;
@override final  DateTime? birthday;
@override@JsonKey() final  ContactDraftState state;

/// Create a copy of ContactDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactDraftCopyWith<_ContactDraft> get copyWith => __$ContactDraftCopyWithImpl<_ContactDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContactDraft&&(identical(other.localId, localId) || other.localId == localId)&&(identical(other.idempotencyKey, idempotencyKey) || other.idempotencyKey == idempotencyKey)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.contactId, contactId) || other.contactId == contactId)&&(identical(other.baseVersion, baseVersion) || other.baseVersion == baseVersion)&&(identical(other.name, name) || other.name == name)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.salutation, salutation) || other.salutation == salutation)&&(identical(other.title, title) || other.title == title)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.birthday, birthday) || other.birthday == birthday)&&(identical(other.state, state) || other.state == state));
}


@override
int get hashCode => Object.hash(runtimeType,localId,idempotencyKey,kind,createdAt,updatedAt,contactId,baseVersion,name,firstName,lastName,email,salutation,title,gender,birthday,state);

@override
String toString() {
  return 'ContactDraft(localId: $localId, idempotencyKey: $idempotencyKey, kind: $kind, createdAt: $createdAt, updatedAt: $updatedAt, contactId: $contactId, baseVersion: $baseVersion, name: $name, firstName: $firstName, lastName: $lastName, email: $email, salutation: $salutation, title: $title, gender: $gender, birthday: $birthday, state: $state)';
}


}

/// @nodoc
abstract mixin class _$ContactDraftCopyWith<$Res> implements $ContactDraftCopyWith<$Res> {
  factory _$ContactDraftCopyWith(_ContactDraft value, $Res Function(_ContactDraft) _then) = __$ContactDraftCopyWithImpl;
@override @useResult
$Res call({
 String localId, String idempotencyKey, ContactDraftKind kind, DateTime createdAt, DateTime updatedAt, int? contactId, String? baseVersion, String? name, String? firstName, String? lastName, String? email, String? salutation, String? title, String? gender, DateTime? birthday, ContactDraftState state
});




}
/// @nodoc
class __$ContactDraftCopyWithImpl<$Res>
    implements _$ContactDraftCopyWith<$Res> {
  __$ContactDraftCopyWithImpl(this._self, this._then);

  final _ContactDraft _self;
  final $Res Function(_ContactDraft) _then;

/// Create a copy of ContactDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? localId = null,Object? idempotencyKey = null,Object? kind = null,Object? createdAt = null,Object? updatedAt = null,Object? contactId = freezed,Object? baseVersion = freezed,Object? name = freezed,Object? firstName = freezed,Object? lastName = freezed,Object? email = freezed,Object? salutation = freezed,Object? title = freezed,Object? gender = freezed,Object? birthday = freezed,Object? state = null,}) {
  return _then(_ContactDraft(
localId: null == localId ? _self.localId : localId // ignore: cast_nullable_to_non_nullable
as String,idempotencyKey: null == idempotencyKey ? _self.idempotencyKey : idempotencyKey // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ContactDraftKind,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,contactId: freezed == contactId ? _self.contactId : contactId // ignore: cast_nullable_to_non_nullable
as int?,baseVersion: freezed == baseVersion ? _self.baseVersion : baseVersion // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,salutation: freezed == salutation ? _self.salutation : salutation // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,birthday: freezed == birthday ? _self.birthday : birthday // ignore: cast_nullable_to_non_nullable
as DateTime?,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as ContactDraftState,
  ));
}


}

/// @nodoc
mixin _$ContactPage {

 List<ContactRecord> get items; int get page; int get perPage; int get total; int get lastPage; ContactDataSource get source; DateTime? get cachedAt;
/// Create a copy of ContactPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactPageCopyWith<ContactPage> get copyWith => _$ContactPageCopyWithImpl<ContactPage>(this as ContactPage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactPage&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.page, page) || other.page == page)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&(identical(other.total, total) || other.total == total)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&(identical(other.source, source) || other.source == source)&&(identical(other.cachedAt, cachedAt) || other.cachedAt == cachedAt));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),page,perPage,total,lastPage,source,cachedAt);

@override
String toString() {
  return 'ContactPage(items: $items, page: $page, perPage: $perPage, total: $total, lastPage: $lastPage, source: $source, cachedAt: $cachedAt)';
}


}

/// @nodoc
abstract mixin class $ContactPageCopyWith<$Res>  {
  factory $ContactPageCopyWith(ContactPage value, $Res Function(ContactPage) _then) = _$ContactPageCopyWithImpl;
@useResult
$Res call({
 List<ContactRecord> items, int page, int perPage, int total, int lastPage, ContactDataSource source, DateTime? cachedAt
});




}
/// @nodoc
class _$ContactPageCopyWithImpl<$Res>
    implements $ContactPageCopyWith<$Res> {
  _$ContactPageCopyWithImpl(this._self, this._then);

  final ContactPage _self;
  final $Res Function(ContactPage) _then;

/// Create a copy of ContactPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? page = null,Object? perPage = null,Object? total = null,Object? lastPage = null,Object? source = null,Object? cachedAt = freezed,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ContactRecord>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,lastPage: null == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ContactDataSource,cachedAt: freezed == cachedAt ? _self.cachedAt : cachedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ContactPage].
extension ContactPagePatterns on ContactPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContactPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContactPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContactPage value)  $default,){
final _that = this;
switch (_that) {
case _ContactPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContactPage value)?  $default,){
final _that = this;
switch (_that) {
case _ContactPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ContactRecord> items,  int page,  int perPage,  int total,  int lastPage,  ContactDataSource source,  DateTime? cachedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContactPage() when $default != null:
return $default(_that.items,_that.page,_that.perPage,_that.total,_that.lastPage,_that.source,_that.cachedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ContactRecord> items,  int page,  int perPage,  int total,  int lastPage,  ContactDataSource source,  DateTime? cachedAt)  $default,) {final _that = this;
switch (_that) {
case _ContactPage():
return $default(_that.items,_that.page,_that.perPage,_that.total,_that.lastPage,_that.source,_that.cachedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ContactRecord> items,  int page,  int perPage,  int total,  int lastPage,  ContactDataSource source,  DateTime? cachedAt)?  $default,) {final _that = this;
switch (_that) {
case _ContactPage() when $default != null:
return $default(_that.items,_that.page,_that.perPage,_that.total,_that.lastPage,_that.source,_that.cachedAt);case _:
  return null;

}
}

}

/// @nodoc


class _ContactPage extends ContactPage {
  const _ContactPage({required final  List<ContactRecord> items, required this.page, required this.perPage, required this.total, required this.lastPage, this.source = ContactDataSource.remote, this.cachedAt}): _items = items,super._();


 final  List<ContactRecord> _items;
@override List<ContactRecord> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int page;
@override final  int perPage;
@override final  int total;
@override final  int lastPage;
@override@JsonKey() final  ContactDataSource source;
@override final  DateTime? cachedAt;

/// Create a copy of ContactPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactPageCopyWith<_ContactPage> get copyWith => __$ContactPageCopyWithImpl<_ContactPage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContactPage&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.page, page) || other.page == page)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&(identical(other.total, total) || other.total == total)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&(identical(other.source, source) || other.source == source)&&(identical(other.cachedAt, cachedAt) || other.cachedAt == cachedAt));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),page,perPage,total,lastPage,source,cachedAt);

@override
String toString() {
  return 'ContactPage(items: $items, page: $page, perPage: $perPage, total: $total, lastPage: $lastPage, source: $source, cachedAt: $cachedAt)';
}


}

/// @nodoc
abstract mixin class _$ContactPageCopyWith<$Res> implements $ContactPageCopyWith<$Res> {
  factory _$ContactPageCopyWith(_ContactPage value, $Res Function(_ContactPage) _then) = __$ContactPageCopyWithImpl;
@override @useResult
$Res call({
 List<ContactRecord> items, int page, int perPage, int total, int lastPage, ContactDataSource source, DateTime? cachedAt
});




}
/// @nodoc
class __$ContactPageCopyWithImpl<$Res>
    implements _$ContactPageCopyWith<$Res> {
  __$ContactPageCopyWithImpl(this._self, this._then);

  final _ContactPage _self;
  final $Res Function(_ContactPage) _then;

/// Create a copy of ContactPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? page = null,Object? perPage = null,Object? total = null,Object? lastPage = null,Object? source = null,Object? cachedAt = freezed,}) {
  return _then(_ContactPage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ContactRecord>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,lastPage: null == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ContactDataSource,cachedAt: freezed == cachedAt ? _self.cachedAt : cachedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$ContactSnapshot {

 ContactRecord get contact; ContactDataSource get source; DateTime? get cachedAt;
/// Create a copy of ContactSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactSnapshotCopyWith<ContactSnapshot> get copyWith => _$ContactSnapshotCopyWithImpl<ContactSnapshot>(this as ContactSnapshot, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactSnapshot&&(identical(other.contact, contact) || other.contact == contact)&&(identical(other.source, source) || other.source == source)&&(identical(other.cachedAt, cachedAt) || other.cachedAt == cachedAt));
}


@override
int get hashCode => Object.hash(runtimeType,contact,source,cachedAt);

@override
String toString() {
  return 'ContactSnapshot(contact: $contact, source: $source, cachedAt: $cachedAt)';
}


}

/// @nodoc
abstract mixin class $ContactSnapshotCopyWith<$Res>  {
  factory $ContactSnapshotCopyWith(ContactSnapshot value, $Res Function(ContactSnapshot) _then) = _$ContactSnapshotCopyWithImpl;
@useResult
$Res call({
 ContactRecord contact, ContactDataSource source, DateTime? cachedAt
});


$ContactRecordCopyWith<$Res> get contact;

}
/// @nodoc
class _$ContactSnapshotCopyWithImpl<$Res>
    implements $ContactSnapshotCopyWith<$Res> {
  _$ContactSnapshotCopyWithImpl(this._self, this._then);

  final ContactSnapshot _self;
  final $Res Function(ContactSnapshot) _then;

/// Create a copy of ContactSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? contact = null,Object? source = null,Object? cachedAt = freezed,}) {
  return _then(_self.copyWith(
contact: null == contact ? _self.contact : contact // ignore: cast_nullable_to_non_nullable
as ContactRecord,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ContactDataSource,cachedAt: freezed == cachedAt ? _self.cachedAt : cachedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of ContactSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContactRecordCopyWith<$Res> get contact {

  return $ContactRecordCopyWith<$Res>(_self.contact, (value) {
    return _then(_self.copyWith(contact: value));
  });
}
}


/// Adds pattern-matching-related methods to [ContactSnapshot].
extension ContactSnapshotPatterns on ContactSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContactSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContactSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContactSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _ContactSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContactSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _ContactSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ContactRecord contact,  ContactDataSource source,  DateTime? cachedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContactSnapshot() when $default != null:
return $default(_that.contact,_that.source,_that.cachedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ContactRecord contact,  ContactDataSource source,  DateTime? cachedAt)  $default,) {final _that = this;
switch (_that) {
case _ContactSnapshot():
return $default(_that.contact,_that.source,_that.cachedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ContactRecord contact,  ContactDataSource source,  DateTime? cachedAt)?  $default,) {final _that = this;
switch (_that) {
case _ContactSnapshot() when $default != null:
return $default(_that.contact,_that.source,_that.cachedAt);case _:
  return null;

}
}

}

/// @nodoc


class _ContactSnapshot implements ContactSnapshot {
  const _ContactSnapshot({required this.contact, this.source = ContactDataSource.remote, this.cachedAt});


@override final  ContactRecord contact;
@override@JsonKey() final  ContactDataSource source;
@override final  DateTime? cachedAt;

/// Create a copy of ContactSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactSnapshotCopyWith<_ContactSnapshot> get copyWith => __$ContactSnapshotCopyWithImpl<_ContactSnapshot>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContactSnapshot&&(identical(other.contact, contact) || other.contact == contact)&&(identical(other.source, source) || other.source == source)&&(identical(other.cachedAt, cachedAt) || other.cachedAt == cachedAt));
}


@override
int get hashCode => Object.hash(runtimeType,contact,source,cachedAt);

@override
String toString() {
  return 'ContactSnapshot(contact: $contact, source: $source, cachedAt: $cachedAt)';
}


}

/// @nodoc
abstract mixin class _$ContactSnapshotCopyWith<$Res> implements $ContactSnapshotCopyWith<$Res> {
  factory _$ContactSnapshotCopyWith(_ContactSnapshot value, $Res Function(_ContactSnapshot) _then) = __$ContactSnapshotCopyWithImpl;
@override @useResult
$Res call({
 ContactRecord contact, ContactDataSource source, DateTime? cachedAt
});


@override $ContactRecordCopyWith<$Res> get contact;

}
/// @nodoc
class __$ContactSnapshotCopyWithImpl<$Res>
    implements _$ContactSnapshotCopyWith<$Res> {
  __$ContactSnapshotCopyWithImpl(this._self, this._then);

  final _ContactSnapshot _self;
  final $Res Function(_ContactSnapshot) _then;

/// Create a copy of ContactSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? contact = null,Object? source = null,Object? cachedAt = freezed,}) {
  return _then(_ContactSnapshot(
contact: null == contact ? _self.contact : contact // ignore: cast_nullable_to_non_nullable
as ContactRecord,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ContactDataSource,cachedAt: freezed == cachedAt ? _self.cachedAt : cachedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of ContactSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContactRecordCopyWith<$Res> get contact {

  return $ContactRecordCopyWith<$Res>(_self.contact, (value) {
    return _then(_self.copyWith(contact: value));
  });
}
}

/// @nodoc
mixin _$ContactSearch {

 String get query; int get page; int get perPage; ContactsSort get sort;
/// Create a copy of ContactSearch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactSearchCopyWith<ContactSearch> get copyWith => _$ContactSearchCopyWithImpl<ContactSearch>(this as ContactSearch, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactSearch&&(identical(other.query, query) || other.query == query)&&(identical(other.page, page) || other.page == page)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&(identical(other.sort, sort) || other.sort == sort));
}


@override
int get hashCode => Object.hash(runtimeType,query,page,perPage,sort);

@override
String toString() {
  return 'ContactSearch(query: $query, page: $page, perPage: $perPage, sort: $sort)';
}


}

/// @nodoc
abstract mixin class $ContactSearchCopyWith<$Res>  {
  factory $ContactSearchCopyWith(ContactSearch value, $Res Function(ContactSearch) _then) = _$ContactSearchCopyWithImpl;
@useResult
$Res call({
 String query, int page, int perPage, ContactsSort sort
});




}
/// @nodoc
class _$ContactSearchCopyWithImpl<$Res>
    implements $ContactSearchCopyWith<$Res> {
  _$ContactSearchCopyWithImpl(this._self, this._then);

  final ContactSearch _self;
  final $Res Function(ContactSearch) _then;

/// Create a copy of ContactSearch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? query = null,Object? page = null,Object? perPage = null,Object? sort = null,}) {
  return _then(_self.copyWith(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as ContactsSort,
  ));
}

}


/// Adds pattern-matching-related methods to [ContactSearch].
extension ContactSearchPatterns on ContactSearch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContactSearch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContactSearch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContactSearch value)  $default,){
final _that = this;
switch (_that) {
case _ContactSearch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContactSearch value)?  $default,){
final _that = this;
switch (_that) {
case _ContactSearch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String query,  int page,  int perPage,  ContactsSort sort)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContactSearch() when $default != null:
return $default(_that.query,_that.page,_that.perPage,_that.sort);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String query,  int page,  int perPage,  ContactsSort sort)  $default,) {final _that = this;
switch (_that) {
case _ContactSearch():
return $default(_that.query,_that.page,_that.perPage,_that.sort);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String query,  int page,  int perPage,  ContactsSort sort)?  $default,) {final _that = this;
switch (_that) {
case _ContactSearch() when $default != null:
return $default(_that.query,_that.page,_that.perPage,_that.sort);case _:
  return null;

}
}

}

/// @nodoc


class _ContactSearch implements ContactSearch {
  const _ContactSearch({this.query = '', this.page = 1, this.perPage = 25, this.sort = ContactsSort.lastName});


@override@JsonKey() final  String query;
@override@JsonKey() final  int page;
@override@JsonKey() final  int perPage;
@override@JsonKey() final  ContactsSort sort;

/// Create a copy of ContactSearch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactSearchCopyWith<_ContactSearch> get copyWith => __$ContactSearchCopyWithImpl<_ContactSearch>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContactSearch&&(identical(other.query, query) || other.query == query)&&(identical(other.page, page) || other.page == page)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&(identical(other.sort, sort) || other.sort == sort));
}


@override
int get hashCode => Object.hash(runtimeType,query,page,perPage,sort);

@override
String toString() {
  return 'ContactSearch(query: $query, page: $page, perPage: $perPage, sort: $sort)';
}


}

/// @nodoc
abstract mixin class _$ContactSearchCopyWith<$Res> implements $ContactSearchCopyWith<$Res> {
  factory _$ContactSearchCopyWith(_ContactSearch value, $Res Function(_ContactSearch) _then) = __$ContactSearchCopyWithImpl;
@override @useResult
$Res call({
 String query, int page, int perPage, ContactsSort sort
});




}
/// @nodoc
class __$ContactSearchCopyWithImpl<$Res>
    implements _$ContactSearchCopyWith<$Res> {
  __$ContactSearchCopyWithImpl(this._self, this._then);

  final _ContactSearch _self;
  final $Res Function(_ContactSearch) _then;

/// Create a copy of ContactSearch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? query = null,Object? page = null,Object? perPage = null,Object? sort = null,}) {
  return _then(_ContactSearch(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as ContactsSort,
  ));
}


}

// dart format on
