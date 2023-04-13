// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'config_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ConfigInfo _$ConfigInfoFromJson(Map<String, dynamic> json) {
  return _ConfigInfo.fromJson(json);
}

/// @nodoc
mixin _$ConfigInfo {
  bool get isDark => throw _privateConstructorUsedError;
  String get localeStr => throw _privateConstructorUsedError;
  String get key => throw _privateConstructorUsedError;
  String get baseUrl => throw _privateConstructorUsedError;
  bool get useStream => throw _privateConstructorUsedError;
  String get gptModel => throw _privateConstructorUsedError;
  String get ip => throw _privateConstructorUsedError;
  String get port => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ConfigInfoCopyWith<ConfigInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConfigInfoCopyWith<$Res> {
  factory $ConfigInfoCopyWith(
          ConfigInfo value, $Res Function(ConfigInfo) then) =
      _$ConfigInfoCopyWithImpl<$Res, ConfigInfo>;
  @useResult
  $Res call(
      {bool isDark,
      String localeStr,
      String key,
      String baseUrl,
      bool useStream,
      String gptModel,
      String ip,
      String port});
}

/// @nodoc
class _$ConfigInfoCopyWithImpl<$Res, $Val extends ConfigInfo>
    implements $ConfigInfoCopyWith<$Res> {
  _$ConfigInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isDark = null,
    Object? localeStr = null,
    Object? key = null,
    Object? baseUrl = null,
    Object? useStream = null,
    Object? gptModel = null,
    Object? ip = null,
    Object? port = null,
  }) {
    return _then(_value.copyWith(
      isDark: null == isDark
          ? _value.isDark
          : isDark // ignore: cast_nullable_to_non_nullable
              as bool,
      localeStr: null == localeStr
          ? _value.localeStr
          : localeStr // ignore: cast_nullable_to_non_nullable
              as String,
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      baseUrl: null == baseUrl
          ? _value.baseUrl
          : baseUrl // ignore: cast_nullable_to_non_nullable
              as String,
      useStream: null == useStream
          ? _value.useStream
          : useStream // ignore: cast_nullable_to_non_nullable
              as bool,
      gptModel: null == gptModel
          ? _value.gptModel
          : gptModel // ignore: cast_nullable_to_non_nullable
              as String,
      ip: null == ip
          ? _value.ip
          : ip // ignore: cast_nullable_to_non_nullable
              as String,
      port: null == port
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ConfigInfoCopyWith<$Res>
    implements $ConfigInfoCopyWith<$Res> {
  factory _$$_ConfigInfoCopyWith(
          _$_ConfigInfo value, $Res Function(_$_ConfigInfo) then) =
      __$$_ConfigInfoCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isDark,
      String localeStr,
      String key,
      String baseUrl,
      bool useStream,
      String gptModel,
      String ip,
      String port});
}

/// @nodoc
class __$$_ConfigInfoCopyWithImpl<$Res>
    extends _$ConfigInfoCopyWithImpl<$Res, _$_ConfigInfo>
    implements _$$_ConfigInfoCopyWith<$Res> {
  __$$_ConfigInfoCopyWithImpl(
      _$_ConfigInfo _value, $Res Function(_$_ConfigInfo) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isDark = null,
    Object? localeStr = null,
    Object? key = null,
    Object? baseUrl = null,
    Object? useStream = null,
    Object? gptModel = null,
    Object? ip = null,
    Object? port = null,
  }) {
    return _then(_$_ConfigInfo(
      isDark: null == isDark
          ? _value.isDark
          : isDark // ignore: cast_nullable_to_non_nullable
              as bool,
      localeStr: null == localeStr
          ? _value.localeStr
          : localeStr // ignore: cast_nullable_to_non_nullable
              as String,
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      baseUrl: null == baseUrl
          ? _value.baseUrl
          : baseUrl // ignore: cast_nullable_to_non_nullable
              as String,
      useStream: null == useStream
          ? _value.useStream
          : useStream // ignore: cast_nullable_to_non_nullable
              as bool,
      gptModel: null == gptModel
          ? _value.gptModel
          : gptModel // ignore: cast_nullable_to_non_nullable
              as String,
      ip: null == ip
          ? _value.ip
          : ip // ignore: cast_nullable_to_non_nullable
              as String,
      port: null == port
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ConfigInfo extends _ConfigInfo {
  const _$_ConfigInfo(
      {this.isDark = false,
      this.localeStr = "en",
      this.key = "",
      this.baseUrl = "https://api.openai.com",
      this.useStream = false,
      this.gptModel = "gpt-3.5-turbo",
      this.ip = "",
      this.port = ""})
      : super._();

  factory _$_ConfigInfo.fromJson(Map<String, dynamic> json) =>
      _$$_ConfigInfoFromJson(json);

  @override
  @JsonKey()
  final bool isDark;
  @override
  @JsonKey()
  final String localeStr;
  @override
  @JsonKey()
  final String key;
  @override
  @JsonKey()
  final String baseUrl;
  @override
  @JsonKey()
  final bool useStream;
  @override
  @JsonKey()
  final String gptModel;
  @override
  @JsonKey()
  final String ip;
  @override
  @JsonKey()
  final String port;

  @override
  String toString() {
    return 'ConfigInfo(isDark: $isDark, localeStr: $localeStr, key: $key, baseUrl: $baseUrl, useStream: $useStream, gptModel: $gptModel, ip: $ip, port: $port)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ConfigInfo &&
            (identical(other.isDark, isDark) || other.isDark == isDark) &&
            (identical(other.localeStr, localeStr) ||
                other.localeStr == localeStr) &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl) &&
            (identical(other.useStream, useStream) ||
                other.useStream == useStream) &&
            (identical(other.gptModel, gptModel) ||
                other.gptModel == gptModel) &&
            (identical(other.ip, ip) || other.ip == ip) &&
            (identical(other.port, port) || other.port == port));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, isDark, localeStr, key, baseUrl,
      useStream, gptModel, ip, port);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ConfigInfoCopyWith<_$_ConfigInfo> get copyWith =>
      __$$_ConfigInfoCopyWithImpl<_$_ConfigInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ConfigInfoToJson(
      this,
    );
  }
}

abstract class _ConfigInfo extends ConfigInfo {
  const factory _ConfigInfo(
      {final bool isDark,
      final String localeStr,
      final String key,
      final String baseUrl,
      final bool useStream,
      final String gptModel,
      final String ip,
      final String port}) = _$_ConfigInfo;
  const _ConfigInfo._() : super._();

  factory _ConfigInfo.fromJson(Map<String, dynamic> json) =
      _$_ConfigInfo.fromJson;

  @override
  bool get isDark;
  @override
  String get localeStr;
  @override
  String get key;
  @override
  String get baseUrl;
  @override
  bool get useStream;
  @override
  String get gptModel;
  @override
  String get ip;
  @override
  String get port;
  @override
  @JsonKey(ignore: true)
  _$$_ConfigInfoCopyWith<_$_ConfigInfo> get copyWith =>
      throw _privateConstructorUsedError;
}
