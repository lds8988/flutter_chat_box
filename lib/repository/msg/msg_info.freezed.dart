// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'msg_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MsgInfo _$MsgInfoFromJson(Map<String, dynamic> json) {
  return _MsgInfo.fromJson(json);
}

/// @nodoc
mixin _$MsgInfo {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'uuid')
  String get conversationId => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  @JsonKey(name: 'role')
  int get roleInt => throw _privateConstructorUsedError;
  @JsonKey(name: "state")
  int get stateInt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MsgInfoCopyWith<MsgInfo> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MsgInfoCopyWith<$Res> {
  factory $MsgInfoCopyWith(MsgInfo value, $Res Function(MsgInfo) then) =
      _$MsgInfoCopyWithImpl<$Res, MsgInfo>;
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'uuid') String conversationId,
      String text,
      @JsonKey(name: 'role') int roleInt,
      @JsonKey(name: "state") int stateInt});
}

/// @nodoc
class _$MsgInfoCopyWithImpl<$Res, $Val extends MsgInfo>
    implements $MsgInfoCopyWith<$Res> {
  _$MsgInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? conversationId = null,
    Object? text = null,
    Object? roleInt = null,
    Object? stateInt = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      roleInt: null == roleInt
          ? _value.roleInt
          : roleInt // ignore: cast_nullable_to_non_nullable
              as int,
      stateInt: null == stateInt
          ? _value.stateInt
          : stateInt // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_MsgInfoCopyWith<$Res> implements $MsgInfoCopyWith<$Res> {
  factory _$$_MsgInfoCopyWith(
          _$_MsgInfo value, $Res Function(_$_MsgInfo) then) =
      __$$_MsgInfoCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'uuid') String conversationId,
      String text,
      @JsonKey(name: 'role') int roleInt,
      @JsonKey(name: "state") int stateInt});
}

/// @nodoc
class __$$_MsgInfoCopyWithImpl<$Res>
    extends _$MsgInfoCopyWithImpl<$Res, _$_MsgInfo>
    implements _$$_MsgInfoCopyWith<$Res> {
  __$$_MsgInfoCopyWithImpl(_$_MsgInfo _value, $Res Function(_$_MsgInfo) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? conversationId = null,
    Object? text = null,
    Object? roleInt = null,
    Object? stateInt = null,
  }) {
    return _then(_$_MsgInfo(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      roleInt: null == roleInt
          ? _value.roleInt
          : roleInt // ignore: cast_nullable_to_non_nullable
              as int,
      stateInt: null == stateInt
          ? _value.stateInt
          : stateInt // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_MsgInfo extends _MsgInfo {
  _$_MsgInfo(
      {this.id,
      @JsonKey(name: 'uuid') required this.conversationId,
      required this.text,
      @JsonKey(name: 'role') required this.roleInt,
      @JsonKey(name: "state") required this.stateInt})
      : super._();

  factory _$_MsgInfo.fromJson(Map<String, dynamic> json) =>
      _$$_MsgInfoFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey(name: 'uuid')
  final String conversationId;
  @override
  final String text;
  @override
  @JsonKey(name: 'role')
  final int roleInt;
  @override
  @JsonKey(name: "state")
  final int stateInt;

  @override
  String toString() {
    return 'MsgInfo(id: $id, conversationId: $conversationId, text: $text, roleInt: $roleInt, stateInt: $stateInt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MsgInfo &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.roleInt, roleInt) || other.roleInt == roleInt) &&
            (identical(other.stateInt, stateInt) ||
                other.stateInt == stateInt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, conversationId, text, roleInt, stateInt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MsgInfoCopyWith<_$_MsgInfo> get copyWith =>
      __$$_MsgInfoCopyWithImpl<_$_MsgInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MsgInfoToJson(
      this,
    );
  }
}

abstract class _MsgInfo extends MsgInfo {
  factory _MsgInfo(
      {final int? id,
      @JsonKey(name: 'uuid') required final String conversationId,
      required final String text,
      @JsonKey(name: 'role') required final int roleInt,
      @JsonKey(name: "state") required final int stateInt}) = _$_MsgInfo;
  _MsgInfo._() : super._();

  factory _MsgInfo.fromJson(Map<String, dynamic> json) = _$_MsgInfo.fromJson;

  @override
  int? get id;
  @override
  @JsonKey(name: 'uuid')
  String get conversationId;
  @override
  String get text;
  @override
  @JsonKey(name: 'role')
  int get roleInt;
  @override
  @JsonKey(name: "state")
  int get stateInt;
  @override
  @JsonKey(ignore: true)
  _$$_MsgInfoCopyWith<_$_MsgInfo> get copyWith =>
      throw _privateConstructorUsedError;
}
