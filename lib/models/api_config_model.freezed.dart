// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_config_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ApiConfig _$ApiConfigFromJson(Map<String, dynamic> json) {
  return _ApiConfig.fromJson(json);
}

/// @nodoc
mixin _$ApiConfig {
  String get llmBaseUrl => throw _privateConstructorUsedError;
  String get llmApiKey => throw _privateConstructorUsedError;
  String get llmModel => throw _privateConstructorUsedError;
  String get ttsBaseUrl => throw _privateConstructorUsedError;
  String get ttsApiKey => throw _privateConstructorUsedError;
  String get ttsModel => throw _privateConstructorUsedError;

  /// Serializes this ApiConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApiConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiConfigCopyWith<ApiConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiConfigCopyWith<$Res> {
  factory $ApiConfigCopyWith(ApiConfig value, $Res Function(ApiConfig) then) =
      _$ApiConfigCopyWithImpl<$Res, ApiConfig>;
  @useResult
  $Res call({
    String llmBaseUrl,
    String llmApiKey,
    String llmModel,
    String ttsBaseUrl,
    String ttsApiKey,
    String ttsModel,
  });
}

/// @nodoc
class _$ApiConfigCopyWithImpl<$Res, $Val extends ApiConfig>
    implements $ApiConfigCopyWith<$Res> {
  _$ApiConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? llmBaseUrl = null,
    Object? llmApiKey = null,
    Object? llmModel = null,
    Object? ttsBaseUrl = null,
    Object? ttsApiKey = null,
    Object? ttsModel = null,
  }) {
    return _then(
      _value.copyWith(
            llmBaseUrl: null == llmBaseUrl
                ? _value.llmBaseUrl
                : llmBaseUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            llmApiKey: null == llmApiKey
                ? _value.llmApiKey
                : llmApiKey // ignore: cast_nullable_to_non_nullable
                      as String,
            llmModel: null == llmModel
                ? _value.llmModel
                : llmModel // ignore: cast_nullable_to_non_nullable
                      as String,
            ttsBaseUrl: null == ttsBaseUrl
                ? _value.ttsBaseUrl
                : ttsBaseUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            ttsApiKey: null == ttsApiKey
                ? _value.ttsApiKey
                : ttsApiKey // ignore: cast_nullable_to_non_nullable
                      as String,
            ttsModel: null == ttsModel
                ? _value.ttsModel
                : ttsModel // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ApiConfigImplCopyWith<$Res>
    implements $ApiConfigCopyWith<$Res> {
  factory _$$ApiConfigImplCopyWith(
    _$ApiConfigImpl value,
    $Res Function(_$ApiConfigImpl) then,
  ) = __$$ApiConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String llmBaseUrl,
    String llmApiKey,
    String llmModel,
    String ttsBaseUrl,
    String ttsApiKey,
    String ttsModel,
  });
}

/// @nodoc
class __$$ApiConfigImplCopyWithImpl<$Res>
    extends _$ApiConfigCopyWithImpl<$Res, _$ApiConfigImpl>
    implements _$$ApiConfigImplCopyWith<$Res> {
  __$$ApiConfigImplCopyWithImpl(
    _$ApiConfigImpl _value,
    $Res Function(_$ApiConfigImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApiConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? llmBaseUrl = null,
    Object? llmApiKey = null,
    Object? llmModel = null,
    Object? ttsBaseUrl = null,
    Object? ttsApiKey = null,
    Object? ttsModel = null,
  }) {
    return _then(
      _$ApiConfigImpl(
        llmBaseUrl: null == llmBaseUrl
            ? _value.llmBaseUrl
            : llmBaseUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        llmApiKey: null == llmApiKey
            ? _value.llmApiKey
            : llmApiKey // ignore: cast_nullable_to_non_nullable
                  as String,
        llmModel: null == llmModel
            ? _value.llmModel
            : llmModel // ignore: cast_nullable_to_non_nullable
                  as String,
        ttsBaseUrl: null == ttsBaseUrl
            ? _value.ttsBaseUrl
            : ttsBaseUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        ttsApiKey: null == ttsApiKey
            ? _value.ttsApiKey
            : ttsApiKey // ignore: cast_nullable_to_non_nullable
                  as String,
        ttsModel: null == ttsModel
            ? _value.ttsModel
            : ttsModel // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiConfigImpl implements _ApiConfig {
  const _$ApiConfigImpl({
    required this.llmBaseUrl,
    required this.llmApiKey,
    required this.llmModel,
    required this.ttsBaseUrl,
    required this.ttsApiKey,
    required this.ttsModel,
  });

  factory _$ApiConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiConfigImplFromJson(json);

  @override
  final String llmBaseUrl;
  @override
  final String llmApiKey;
  @override
  final String llmModel;
  @override
  final String ttsBaseUrl;
  @override
  final String ttsApiKey;
  @override
  final String ttsModel;

  @override
  String toString() {
    return 'ApiConfig(llmBaseUrl: $llmBaseUrl, llmApiKey: $llmApiKey, llmModel: $llmModel, ttsBaseUrl: $ttsBaseUrl, ttsApiKey: $ttsApiKey, ttsModel: $ttsModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiConfigImpl &&
            (identical(other.llmBaseUrl, llmBaseUrl) ||
                other.llmBaseUrl == llmBaseUrl) &&
            (identical(other.llmApiKey, llmApiKey) ||
                other.llmApiKey == llmApiKey) &&
            (identical(other.llmModel, llmModel) ||
                other.llmModel == llmModel) &&
            (identical(other.ttsBaseUrl, ttsBaseUrl) ||
                other.ttsBaseUrl == ttsBaseUrl) &&
            (identical(other.ttsApiKey, ttsApiKey) ||
                other.ttsApiKey == ttsApiKey) &&
            (identical(other.ttsModel, ttsModel) ||
                other.ttsModel == ttsModel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    llmBaseUrl,
    llmApiKey,
    llmModel,
    ttsBaseUrl,
    ttsApiKey,
    ttsModel,
  );

  /// Create a copy of ApiConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiConfigImplCopyWith<_$ApiConfigImpl> get copyWith =>
      __$$ApiConfigImplCopyWithImpl<_$ApiConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiConfigImplToJson(this);
  }
}

abstract class _ApiConfig implements ApiConfig {
  const factory _ApiConfig({
    required final String llmBaseUrl,
    required final String llmApiKey,
    required final String llmModel,
    required final String ttsBaseUrl,
    required final String ttsApiKey,
    required final String ttsModel,
  }) = _$ApiConfigImpl;

  factory _ApiConfig.fromJson(Map<String, dynamic> json) =
      _$ApiConfigImpl.fromJson;

  @override
  String get llmBaseUrl;
  @override
  String get llmApiKey;
  @override
  String get llmModel;
  @override
  String get ttsBaseUrl;
  @override
  String get ttsApiKey;
  @override
  String get ttsModel;

  /// Create a copy of ApiConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiConfigImplCopyWith<_$ApiConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
