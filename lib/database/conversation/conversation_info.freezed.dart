// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ConversationInfo _$ConversationInfoFromJson(Map<String, dynamic> json) {
  return _ConversationInfo.fromJson(json);
}

/// @nodoc
mixin _$ConversationInfo {
  String get name => throw _privateConstructorUsedError;
  String get uuid => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ConversationInfoCopyWith<ConversationInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationInfoCopyWith<$Res> {
  factory $ConversationInfoCopyWith(
          ConversationInfo value, $Res Function(ConversationInfo) then) =
      _$ConversationInfoCopyWithImpl<$Res, ConversationInfo>;
  @useResult
  $Res call({String name, String uuid});
}

/// @nodoc
class _$ConversationInfoCopyWithImpl<$Res, $Val extends ConversationInfo>
    implements $ConversationInfoCopyWith<$Res> {
  _$ConversationInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? uuid = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ConversationInfoCopyWith<$Res>
    implements $ConversationInfoCopyWith<$Res> {
  factory _$$_ConversationInfoCopyWith(
          _$_ConversationInfo value, $Res Function(_$_ConversationInfo) then) =
      __$$_ConversationInfoCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String uuid});
}

/// @nodoc
class __$$_ConversationInfoCopyWithImpl<$Res>
    extends _$ConversationInfoCopyWithImpl<$Res, _$_ConversationInfo>
    implements _$$_ConversationInfoCopyWith<$Res> {
  __$$_ConversationInfoCopyWithImpl(
      _$_ConversationInfo _value, $Res Function(_$_ConversationInfo) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? uuid = null,
  }) {
    return _then(_$_ConversationInfo(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ConversationInfo implements _ConversationInfo {
  _$_ConversationInfo({required this.name, required this.uuid});

  factory _$_ConversationInfo.fromJson(Map<String, dynamic> json) =>
      _$$_ConversationInfoFromJson(json);

  @override
  final String name;
  @override
  final String uuid;

  @override
  String toString() {
    return 'ConversationInfo(name: $name, uuid: $uuid)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ConversationInfo &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.uuid, uuid) || other.uuid == uuid));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, uuid);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ConversationInfoCopyWith<_$_ConversationInfo> get copyWith =>
      __$$_ConversationInfoCopyWithImpl<_$_ConversationInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ConversationInfoToJson(
      this,
    );
  }
}

abstract class _ConversationInfo implements ConversationInfo {
  factory _ConversationInfo(
      {required final String name,
      required final String uuid}) = _$_ConversationInfo;

  factory _ConversationInfo.fromJson(Map<String, dynamic> json) =
      _$_ConversationInfo.fromJson;

  @override
  String get name;
  @override
  String get uuid;
  @override
  @JsonKey(ignore: true)
  _$$_ConversationInfoCopyWith<_$_ConversationInfo> get copyWith =>
      throw _privateConstructorUsedError;
}
