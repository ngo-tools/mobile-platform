// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'threads.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ThreadListDiff {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThreadListDiff);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ThreadListDiff()';
}


}

/// @nodoc
class $ThreadListDiffCopyWith<$Res>  {
$ThreadListDiffCopyWith(ThreadListDiff _, $Res Function(ThreadListDiff) __);
}


/// Adds pattern-matching-related methods to [ThreadListDiff].
extension ThreadListDiffPatterns on ThreadListDiff {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ThreadListDiff_Append value)?  append,TResult Function( ThreadListDiff_Clear value)?  clear,TResult Function( ThreadListDiff_PushFront value)?  pushFront,TResult Function( ThreadListDiff_PushBack value)?  pushBack,TResult Function( ThreadListDiff_PopFront value)?  popFront,TResult Function( ThreadListDiff_PopBack value)?  popBack,TResult Function( ThreadListDiff_Insert value)?  insert,TResult Function( ThreadListDiff_Set value)?  set_,TResult Function( ThreadListDiff_Remove value)?  remove,TResult Function( ThreadListDiff_Truncate value)?  truncate,TResult Function( ThreadListDiff_Reset value)?  reset,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ThreadListDiff_Append() when append != null:
return append(_that);case ThreadListDiff_Clear() when clear != null:
return clear(_that);case ThreadListDiff_PushFront() when pushFront != null:
return pushFront(_that);case ThreadListDiff_PushBack() when pushBack != null:
return pushBack(_that);case ThreadListDiff_PopFront() when popFront != null:
return popFront(_that);case ThreadListDiff_PopBack() when popBack != null:
return popBack(_that);case ThreadListDiff_Insert() when insert != null:
return insert(_that);case ThreadListDiff_Set() when set_ != null:
return set_(_that);case ThreadListDiff_Remove() when remove != null:
return remove(_that);case ThreadListDiff_Truncate() when truncate != null:
return truncate(_that);case ThreadListDiff_Reset() when reset != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ThreadListDiff_Append value)  append,required TResult Function( ThreadListDiff_Clear value)  clear,required TResult Function( ThreadListDiff_PushFront value)  pushFront,required TResult Function( ThreadListDiff_PushBack value)  pushBack,required TResult Function( ThreadListDiff_PopFront value)  popFront,required TResult Function( ThreadListDiff_PopBack value)  popBack,required TResult Function( ThreadListDiff_Insert value)  insert,required TResult Function( ThreadListDiff_Set value)  set_,required TResult Function( ThreadListDiff_Remove value)  remove,required TResult Function( ThreadListDiff_Truncate value)  truncate,required TResult Function( ThreadListDiff_Reset value)  reset,}){
final _that = this;
switch (_that) {
case ThreadListDiff_Append():
return append(_that);case ThreadListDiff_Clear():
return clear(_that);case ThreadListDiff_PushFront():
return pushFront(_that);case ThreadListDiff_PushBack():
return pushBack(_that);case ThreadListDiff_PopFront():
return popFront(_that);case ThreadListDiff_PopBack():
return popBack(_that);case ThreadListDiff_Insert():
return insert(_that);case ThreadListDiff_Set():
return set_(_that);case ThreadListDiff_Remove():
return remove(_that);case ThreadListDiff_Truncate():
return truncate(_that);case ThreadListDiff_Reset():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ThreadListDiff_Append value)?  append,TResult? Function( ThreadListDiff_Clear value)?  clear,TResult? Function( ThreadListDiff_PushFront value)?  pushFront,TResult? Function( ThreadListDiff_PushBack value)?  pushBack,TResult? Function( ThreadListDiff_PopFront value)?  popFront,TResult? Function( ThreadListDiff_PopBack value)?  popBack,TResult? Function( ThreadListDiff_Insert value)?  insert,TResult? Function( ThreadListDiff_Set value)?  set_,TResult? Function( ThreadListDiff_Remove value)?  remove,TResult? Function( ThreadListDiff_Truncate value)?  truncate,TResult? Function( ThreadListDiff_Reset value)?  reset,}){
final _that = this;
switch (_that) {
case ThreadListDiff_Append() when append != null:
return append(_that);case ThreadListDiff_Clear() when clear != null:
return clear(_that);case ThreadListDiff_PushFront() when pushFront != null:
return pushFront(_that);case ThreadListDiff_PushBack() when pushBack != null:
return pushBack(_that);case ThreadListDiff_PopFront() when popFront != null:
return popFront(_that);case ThreadListDiff_PopBack() when popBack != null:
return popBack(_that);case ThreadListDiff_Insert() when insert != null:
return insert(_that);case ThreadListDiff_Set() when set_ != null:
return set_(_that);case ThreadListDiff_Remove() when remove != null:
return remove(_that);case ThreadListDiff_Truncate() when truncate != null:
return truncate(_that);case ThreadListDiff_Reset() when reset != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( List<ThreadInfo> values)?  append,TResult Function()?  clear,TResult Function( ThreadInfo value)?  pushFront,TResult Function( ThreadInfo value)?  pushBack,TResult Function()?  popFront,TResult Function()?  popBack,TResult Function( int index,  ThreadInfo value)?  insert,TResult Function( int index,  ThreadInfo value)?  set_,TResult Function( int index)?  remove,TResult Function( int length)?  truncate,TResult Function( List<ThreadInfo> values)?  reset,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ThreadListDiff_Append() when append != null:
return append(_that.values);case ThreadListDiff_Clear() when clear != null:
return clear();case ThreadListDiff_PushFront() when pushFront != null:
return pushFront(_that.value);case ThreadListDiff_PushBack() when pushBack != null:
return pushBack(_that.value);case ThreadListDiff_PopFront() when popFront != null:
return popFront();case ThreadListDiff_PopBack() when popBack != null:
return popBack();case ThreadListDiff_Insert() when insert != null:
return insert(_that.index,_that.value);case ThreadListDiff_Set() when set_ != null:
return set_(_that.index,_that.value);case ThreadListDiff_Remove() when remove != null:
return remove(_that.index);case ThreadListDiff_Truncate() when truncate != null:
return truncate(_that.length);case ThreadListDiff_Reset() when reset != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( List<ThreadInfo> values)  append,required TResult Function()  clear,required TResult Function( ThreadInfo value)  pushFront,required TResult Function( ThreadInfo value)  pushBack,required TResult Function()  popFront,required TResult Function()  popBack,required TResult Function( int index,  ThreadInfo value)  insert,required TResult Function( int index,  ThreadInfo value)  set_,required TResult Function( int index)  remove,required TResult Function( int length)  truncate,required TResult Function( List<ThreadInfo> values)  reset,}) {final _that = this;
switch (_that) {
case ThreadListDiff_Append():
return append(_that.values);case ThreadListDiff_Clear():
return clear();case ThreadListDiff_PushFront():
return pushFront(_that.value);case ThreadListDiff_PushBack():
return pushBack(_that.value);case ThreadListDiff_PopFront():
return popFront();case ThreadListDiff_PopBack():
return popBack();case ThreadListDiff_Insert():
return insert(_that.index,_that.value);case ThreadListDiff_Set():
return set_(_that.index,_that.value);case ThreadListDiff_Remove():
return remove(_that.index);case ThreadListDiff_Truncate():
return truncate(_that.length);case ThreadListDiff_Reset():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( List<ThreadInfo> values)?  append,TResult? Function()?  clear,TResult? Function( ThreadInfo value)?  pushFront,TResult? Function( ThreadInfo value)?  pushBack,TResult? Function()?  popFront,TResult? Function()?  popBack,TResult? Function( int index,  ThreadInfo value)?  insert,TResult? Function( int index,  ThreadInfo value)?  set_,TResult? Function( int index)?  remove,TResult? Function( int length)?  truncate,TResult? Function( List<ThreadInfo> values)?  reset,}) {final _that = this;
switch (_that) {
case ThreadListDiff_Append() when append != null:
return append(_that.values);case ThreadListDiff_Clear() when clear != null:
return clear();case ThreadListDiff_PushFront() when pushFront != null:
return pushFront(_that.value);case ThreadListDiff_PushBack() when pushBack != null:
return pushBack(_that.value);case ThreadListDiff_PopFront() when popFront != null:
return popFront();case ThreadListDiff_PopBack() when popBack != null:
return popBack();case ThreadListDiff_Insert() when insert != null:
return insert(_that.index,_that.value);case ThreadListDiff_Set() when set_ != null:
return set_(_that.index,_that.value);case ThreadListDiff_Remove() when remove != null:
return remove(_that.index);case ThreadListDiff_Truncate() when truncate != null:
return truncate(_that.length);case ThreadListDiff_Reset() when reset != null:
return reset(_that.values);case _:
  return null;

}
}

}

/// @nodoc


class ThreadListDiff_Append extends ThreadListDiff {
  const ThreadListDiff_Append({required final  List<ThreadInfo> values}): _values = values,super._();
  

 final  List<ThreadInfo> _values;
 List<ThreadInfo> get values {
  if (_values is EqualUnmodifiableListView) return _values;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_values);
}


/// Create a copy of ThreadListDiff
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ThreadListDiff_AppendCopyWith<ThreadListDiff_Append> get copyWith => _$ThreadListDiff_AppendCopyWithImpl<ThreadListDiff_Append>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThreadListDiff_Append&&const DeepCollectionEquality().equals(other._values, _values));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_values));

@override
String toString() {
  return 'ThreadListDiff.append(values: $values)';
}


}

/// @nodoc
abstract mixin class $ThreadListDiff_AppendCopyWith<$Res> implements $ThreadListDiffCopyWith<$Res> {
  factory $ThreadListDiff_AppendCopyWith(ThreadListDiff_Append value, $Res Function(ThreadListDiff_Append) _then) = _$ThreadListDiff_AppendCopyWithImpl;
@useResult
$Res call({
 List<ThreadInfo> values
});




}
/// @nodoc
class _$ThreadListDiff_AppendCopyWithImpl<$Res>
    implements $ThreadListDiff_AppendCopyWith<$Res> {
  _$ThreadListDiff_AppendCopyWithImpl(this._self, this._then);

  final ThreadListDiff_Append _self;
  final $Res Function(ThreadListDiff_Append) _then;

/// Create a copy of ThreadListDiff
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? values = null,}) {
  return _then(ThreadListDiff_Append(
values: null == values ? _self._values : values // ignore: cast_nullable_to_non_nullable
as List<ThreadInfo>,
  ));
}


}

/// @nodoc


class ThreadListDiff_Clear extends ThreadListDiff {
  const ThreadListDiff_Clear(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThreadListDiff_Clear);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ThreadListDiff.clear()';
}


}




/// @nodoc


class ThreadListDiff_PushFront extends ThreadListDiff {
  const ThreadListDiff_PushFront({required this.value}): super._();
  

 final  ThreadInfo value;

/// Create a copy of ThreadListDiff
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ThreadListDiff_PushFrontCopyWith<ThreadListDiff_PushFront> get copyWith => _$ThreadListDiff_PushFrontCopyWithImpl<ThreadListDiff_PushFront>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThreadListDiff_PushFront&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'ThreadListDiff.pushFront(value: $value)';
}


}

/// @nodoc
abstract mixin class $ThreadListDiff_PushFrontCopyWith<$Res> implements $ThreadListDiffCopyWith<$Res> {
  factory $ThreadListDiff_PushFrontCopyWith(ThreadListDiff_PushFront value, $Res Function(ThreadListDiff_PushFront) _then) = _$ThreadListDiff_PushFrontCopyWithImpl;
@useResult
$Res call({
 ThreadInfo value
});




}
/// @nodoc
class _$ThreadListDiff_PushFrontCopyWithImpl<$Res>
    implements $ThreadListDiff_PushFrontCopyWith<$Res> {
  _$ThreadListDiff_PushFrontCopyWithImpl(this._self, this._then);

  final ThreadListDiff_PushFront _self;
  final $Res Function(ThreadListDiff_PushFront) _then;

/// Create a copy of ThreadListDiff
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(ThreadListDiff_PushFront(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as ThreadInfo,
  ));
}


}

/// @nodoc


class ThreadListDiff_PushBack extends ThreadListDiff {
  const ThreadListDiff_PushBack({required this.value}): super._();
  

 final  ThreadInfo value;

/// Create a copy of ThreadListDiff
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ThreadListDiff_PushBackCopyWith<ThreadListDiff_PushBack> get copyWith => _$ThreadListDiff_PushBackCopyWithImpl<ThreadListDiff_PushBack>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThreadListDiff_PushBack&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'ThreadListDiff.pushBack(value: $value)';
}


}

/// @nodoc
abstract mixin class $ThreadListDiff_PushBackCopyWith<$Res> implements $ThreadListDiffCopyWith<$Res> {
  factory $ThreadListDiff_PushBackCopyWith(ThreadListDiff_PushBack value, $Res Function(ThreadListDiff_PushBack) _then) = _$ThreadListDiff_PushBackCopyWithImpl;
@useResult
$Res call({
 ThreadInfo value
});




}
/// @nodoc
class _$ThreadListDiff_PushBackCopyWithImpl<$Res>
    implements $ThreadListDiff_PushBackCopyWith<$Res> {
  _$ThreadListDiff_PushBackCopyWithImpl(this._self, this._then);

  final ThreadListDiff_PushBack _self;
  final $Res Function(ThreadListDiff_PushBack) _then;

/// Create a copy of ThreadListDiff
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(ThreadListDiff_PushBack(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as ThreadInfo,
  ));
}


}

/// @nodoc


class ThreadListDiff_PopFront extends ThreadListDiff {
  const ThreadListDiff_PopFront(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThreadListDiff_PopFront);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ThreadListDiff.popFront()';
}


}




/// @nodoc


class ThreadListDiff_PopBack extends ThreadListDiff {
  const ThreadListDiff_PopBack(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThreadListDiff_PopBack);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ThreadListDiff.popBack()';
}


}




/// @nodoc


class ThreadListDiff_Insert extends ThreadListDiff {
  const ThreadListDiff_Insert({required this.index, required this.value}): super._();
  

 final  int index;
 final  ThreadInfo value;

/// Create a copy of ThreadListDiff
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ThreadListDiff_InsertCopyWith<ThreadListDiff_Insert> get copyWith => _$ThreadListDiff_InsertCopyWithImpl<ThreadListDiff_Insert>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThreadListDiff_Insert&&(identical(other.index, index) || other.index == index)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,index,value);

@override
String toString() {
  return 'ThreadListDiff.insert(index: $index, value: $value)';
}


}

/// @nodoc
abstract mixin class $ThreadListDiff_InsertCopyWith<$Res> implements $ThreadListDiffCopyWith<$Res> {
  factory $ThreadListDiff_InsertCopyWith(ThreadListDiff_Insert value, $Res Function(ThreadListDiff_Insert) _then) = _$ThreadListDiff_InsertCopyWithImpl;
@useResult
$Res call({
 int index, ThreadInfo value
});




}
/// @nodoc
class _$ThreadListDiff_InsertCopyWithImpl<$Res>
    implements $ThreadListDiff_InsertCopyWith<$Res> {
  _$ThreadListDiff_InsertCopyWithImpl(this._self, this._then);

  final ThreadListDiff_Insert _self;
  final $Res Function(ThreadListDiff_Insert) _then;

/// Create a copy of ThreadListDiff
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? index = null,Object? value = null,}) {
  return _then(ThreadListDiff_Insert(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as ThreadInfo,
  ));
}


}

/// @nodoc


class ThreadListDiff_Set extends ThreadListDiff {
  const ThreadListDiff_Set({required this.index, required this.value}): super._();
  

 final  int index;
 final  ThreadInfo value;

/// Create a copy of ThreadListDiff
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ThreadListDiff_SetCopyWith<ThreadListDiff_Set> get copyWith => _$ThreadListDiff_SetCopyWithImpl<ThreadListDiff_Set>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThreadListDiff_Set&&(identical(other.index, index) || other.index == index)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,index,value);

@override
String toString() {
  return 'ThreadListDiff.set_(index: $index, value: $value)';
}


}

/// @nodoc
abstract mixin class $ThreadListDiff_SetCopyWith<$Res> implements $ThreadListDiffCopyWith<$Res> {
  factory $ThreadListDiff_SetCopyWith(ThreadListDiff_Set value, $Res Function(ThreadListDiff_Set) _then) = _$ThreadListDiff_SetCopyWithImpl;
@useResult
$Res call({
 int index, ThreadInfo value
});




}
/// @nodoc
class _$ThreadListDiff_SetCopyWithImpl<$Res>
    implements $ThreadListDiff_SetCopyWith<$Res> {
  _$ThreadListDiff_SetCopyWithImpl(this._self, this._then);

  final ThreadListDiff_Set _self;
  final $Res Function(ThreadListDiff_Set) _then;

/// Create a copy of ThreadListDiff
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? index = null,Object? value = null,}) {
  return _then(ThreadListDiff_Set(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as ThreadInfo,
  ));
}


}

/// @nodoc


class ThreadListDiff_Remove extends ThreadListDiff {
  const ThreadListDiff_Remove({required this.index}): super._();
  

 final  int index;

/// Create a copy of ThreadListDiff
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ThreadListDiff_RemoveCopyWith<ThreadListDiff_Remove> get copyWith => _$ThreadListDiff_RemoveCopyWithImpl<ThreadListDiff_Remove>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThreadListDiff_Remove&&(identical(other.index, index) || other.index == index));
}


@override
int get hashCode => Object.hash(runtimeType,index);

@override
String toString() {
  return 'ThreadListDiff.remove(index: $index)';
}


}

/// @nodoc
abstract mixin class $ThreadListDiff_RemoveCopyWith<$Res> implements $ThreadListDiffCopyWith<$Res> {
  factory $ThreadListDiff_RemoveCopyWith(ThreadListDiff_Remove value, $Res Function(ThreadListDiff_Remove) _then) = _$ThreadListDiff_RemoveCopyWithImpl;
@useResult
$Res call({
 int index
});




}
/// @nodoc
class _$ThreadListDiff_RemoveCopyWithImpl<$Res>
    implements $ThreadListDiff_RemoveCopyWith<$Res> {
  _$ThreadListDiff_RemoveCopyWithImpl(this._self, this._then);

  final ThreadListDiff_Remove _self;
  final $Res Function(ThreadListDiff_Remove) _then;

/// Create a copy of ThreadListDiff
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? index = null,}) {
  return _then(ThreadListDiff_Remove(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class ThreadListDiff_Truncate extends ThreadListDiff {
  const ThreadListDiff_Truncate({required this.length}): super._();
  

 final  int length;

/// Create a copy of ThreadListDiff
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ThreadListDiff_TruncateCopyWith<ThreadListDiff_Truncate> get copyWith => _$ThreadListDiff_TruncateCopyWithImpl<ThreadListDiff_Truncate>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThreadListDiff_Truncate&&(identical(other.length, length) || other.length == length));
}


@override
int get hashCode => Object.hash(runtimeType,length);

@override
String toString() {
  return 'ThreadListDiff.truncate(length: $length)';
}


}

/// @nodoc
abstract mixin class $ThreadListDiff_TruncateCopyWith<$Res> implements $ThreadListDiffCopyWith<$Res> {
  factory $ThreadListDiff_TruncateCopyWith(ThreadListDiff_Truncate value, $Res Function(ThreadListDiff_Truncate) _then) = _$ThreadListDiff_TruncateCopyWithImpl;
@useResult
$Res call({
 int length
});




}
/// @nodoc
class _$ThreadListDiff_TruncateCopyWithImpl<$Res>
    implements $ThreadListDiff_TruncateCopyWith<$Res> {
  _$ThreadListDiff_TruncateCopyWithImpl(this._self, this._then);

  final ThreadListDiff_Truncate _self;
  final $Res Function(ThreadListDiff_Truncate) _then;

/// Create a copy of ThreadListDiff
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? length = null,}) {
  return _then(ThreadListDiff_Truncate(
length: null == length ? _self.length : length // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class ThreadListDiff_Reset extends ThreadListDiff {
  const ThreadListDiff_Reset({required final  List<ThreadInfo> values}): _values = values,super._();
  

 final  List<ThreadInfo> _values;
 List<ThreadInfo> get values {
  if (_values is EqualUnmodifiableListView) return _values;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_values);
}


/// Create a copy of ThreadListDiff
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ThreadListDiff_ResetCopyWith<ThreadListDiff_Reset> get copyWith => _$ThreadListDiff_ResetCopyWithImpl<ThreadListDiff_Reset>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThreadListDiff_Reset&&const DeepCollectionEquality().equals(other._values, _values));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_values));

@override
String toString() {
  return 'ThreadListDiff.reset(values: $values)';
}


}

/// @nodoc
abstract mixin class $ThreadListDiff_ResetCopyWith<$Res> implements $ThreadListDiffCopyWith<$Res> {
  factory $ThreadListDiff_ResetCopyWith(ThreadListDiff_Reset value, $Res Function(ThreadListDiff_Reset) _then) = _$ThreadListDiff_ResetCopyWithImpl;
@useResult
$Res call({
 List<ThreadInfo> values
});




}
/// @nodoc
class _$ThreadListDiff_ResetCopyWithImpl<$Res>
    implements $ThreadListDiff_ResetCopyWith<$Res> {
  _$ThreadListDiff_ResetCopyWithImpl(this._self, this._then);

  final ThreadListDiff_Reset _self;
  final $Res Function(ThreadListDiff_Reset) _then;

/// Create a copy of ThreadListDiff
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? values = null,}) {
  return _then(ThreadListDiff_Reset(
values: null == values ? _self._values : values // ignore: cast_nullable_to_non_nullable
as List<ThreadInfo>,
  ));
}


}

// dart format on
