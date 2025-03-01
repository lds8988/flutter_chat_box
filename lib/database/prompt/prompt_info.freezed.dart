// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prompt_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PromptInfo _$PromptInfoFromJson(Map<String, dynamic> json) {
  return _PromptInfo.fromJson(json);
}

/// @nodoc
mixin _$PromptInfo {
  int? get id => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'assistant_id')
  String get robotId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PromptInfoCopyWith<PromptInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PromptInfoCopyWith<$Res> {
  factory $PromptInfoCopyWith(
          PromptInfo value, $Res Function(PromptInfo) then) =
      _$PromptInfoCopyWithImpl<$Res, PromptInfo>;
  @useResult
  $Res call(
      {int? id, String content, @JsonKey(name: 'assistant_id') String robotId});
}

/// @nodoc
class _$PromptInfoCopyWithImpl<$Res, $Val extends PromptInfo>
    implements $PromptInfoCopyWith<$Res> {
  _$PromptInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? content = null,
    Object? robotId = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      robotId: null == robotId
          ? _value.robotId
          : robotId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PromptInfoCopyWith<$Res>
    implements $PromptInfoCopyWith<$Res> {
  factory _$$_PromptInfoCopyWith(
          _$_PromptInfo value, $Res Function(_$_PromptInfo) then) =
      __$$_PromptInfoCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id, String content, @JsonKey(name: 'assistant_id') String robotId});
}

/// @nodoc
class __$$_PromptInfoCopyWithImpl<$Res>
    extends _$PromptInfoCopyWithImpl<$Res, _$_PromptInfo>
    implements _$$_PromptInfoCopyWith<$Res> {
  __$$_PromptInfoCopyWithImpl(
      _$_PromptInfo _value, $Res Function(_$_PromptInfo) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? content = null,
    Object? robotId = null,
  }) {
    return _then(_$_PromptInfo(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      robotId: null == robotId
          ? _value.robotId
          : robotId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_PromptInfo implements _PromptInfo {
  _$_PromptInfo(
      {this.id,
      required this.content,
      @JsonKey(name: 'assistant_id') required this.robotId});

  factory _$_PromptInfo.fromJson(Map<String, dynamic> json) =>
      _$$_PromptInfoFromJson(json);

  @override
  final int? id;
  @override
  final String content;
  @override
  @JsonKey(name: 'assistant_id')
  final String robotId;

  @override
  String toString() {
    return 'PromptInfo(id: $id, content: $content, robotId: $robotId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PromptInfo &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.robotId, robotId) || other.robotId == robotId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, content, robotId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PromptInfoCopyWith<_$_PromptInfo> get copyWith =>
      __$$_PromptInfoCopyWithImpl<_$_PromptInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PromptInfoToJson(
      this,
    );
  }
}

abstract class _PromptInfo implements PromptInfo {
  factory _PromptInfo(
          {final int? id,
          required final String content,
          @JsonKey(name: 'assistant_id') required final String robotId}) =
      _$_PromptInfo;

  factory _PromptInfo.fromJson(Map<String, dynamic> json) =
      _$_PromptInfo.fromJson;

  @override
  int? get id;
  @override
  String get content;
  @override
  @JsonKey(name: 'assistant_id')
  String get robotId;
  @override
  @JsonKey(ignore: true)
  _$$_PromptInfoCopyWith<_$_PromptInfo> get copyWith =>
      throw _privateConstructorUsedError;
}
