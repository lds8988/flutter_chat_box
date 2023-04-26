// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assistant_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

AssistantInfo _$AssistantInfoFromJson(Map<String, dynamic> json) {
  return _AssistantInfo.fromJson(json);
}

/// @nodoc
mixin _$AssistantInfo {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get desc => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AssistantInfoCopyWith<AssistantInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssistantInfoCopyWith<$Res> {
  factory $AssistantInfoCopyWith(
          AssistantInfo value, $Res Function(AssistantInfo) then) =
      _$AssistantInfoCopyWithImpl<$Res, AssistantInfo>;
  @useResult
  $Res call({String id, String title, String desc});
}

/// @nodoc
class _$AssistantInfoCopyWithImpl<$Res, $Val extends AssistantInfo>
    implements $AssistantInfoCopyWith<$Res> {
  _$AssistantInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? desc = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      desc: null == desc
          ? _value.desc
          : desc // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AssistantInfoCopyWith<$Res>
    implements $AssistantInfoCopyWith<$Res> {
  factory _$$_AssistantInfoCopyWith(
          _$_AssistantInfo value, $Res Function(_$_AssistantInfo) then) =
      __$$_AssistantInfoCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String title, String desc});
}

/// @nodoc
class __$$_AssistantInfoCopyWithImpl<$Res>
    extends _$AssistantInfoCopyWithImpl<$Res, _$_AssistantInfo>
    implements _$$_AssistantInfoCopyWith<$Res> {
  __$$_AssistantInfoCopyWithImpl(
      _$_AssistantInfo _value, $Res Function(_$_AssistantInfo) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? desc = null,
  }) {
    return _then(_$_AssistantInfo(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      desc: null == desc
          ? _value.desc
          : desc // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_AssistantInfo implements _AssistantInfo {
  _$_AssistantInfo({required this.id, required this.title, required this.desc});

  factory _$_AssistantInfo.fromJson(Map<String, dynamic> json) =>
      _$$_AssistantInfoFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String desc;

  @override
  String toString() {
    return 'AssistantInfo(id: $id, title: $title, desc: $desc)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AssistantInfo &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.desc, desc) || other.desc == desc));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, desc);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AssistantInfoCopyWith<_$_AssistantInfo> get copyWith =>
      __$$_AssistantInfoCopyWithImpl<_$_AssistantInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AssistantInfoToJson(
      this,
    );
  }
}

abstract class _AssistantInfo implements AssistantInfo {
  factory _AssistantInfo(
      {required final String id,
      required final String title,
      required final String desc}) = _$_AssistantInfo;

  factory _AssistantInfo.fromJson(Map<String, dynamic> json) =
      _$_AssistantInfo.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get desc;
  @override
  @JsonKey(ignore: true)
  _$$_AssistantInfoCopyWith<_$_AssistantInfo> get copyWith =>
      throw _privateConstructorUsedError;
}
