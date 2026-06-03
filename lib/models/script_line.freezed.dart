// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'script_line.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ScriptLine _$ScriptLineFromJson(Map<String, dynamic> json) {
  return _ScriptLine.fromJson(json);
}

/// @nodoc
mixin _$ScriptLine {
  int get id => throw _privateConstructorUsedError;
  String get bookId => throw _privateConstructorUsedError;
  int get chapterIndex => throw _privateConstructorUsedError;
  int get lineIndex => throw _privateConstructorUsedError;
  String get speakerId => throw _privateConstructorUsedError;
  String? get voiceVariantId => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  String? get emotion => throw _privateConstructorUsedError;
  LineType get type => throw _privateConstructorUsedError;
  int? get mergedGroupId => throw _privateConstructorUsedError;

  /// Serializes this ScriptLine to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScriptLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScriptLineCopyWith<ScriptLine> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScriptLineCopyWith<$Res> {
  factory $ScriptLineCopyWith(
    ScriptLine value,
    $Res Function(ScriptLine) then,
  ) = _$ScriptLineCopyWithImpl<$Res, ScriptLine>;
  @useResult
  $Res call({
    int id,
    String bookId,
    int chapterIndex,
    int lineIndex,
    String speakerId,
    String? voiceVariantId,
    String text,
    String? emotion,
    LineType type,
    int? mergedGroupId,
  });
}

/// @nodoc
class _$ScriptLineCopyWithImpl<$Res, $Val extends ScriptLine>
    implements $ScriptLineCopyWith<$Res> {
  _$ScriptLineCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScriptLine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookId = null,
    Object? chapterIndex = null,
    Object? lineIndex = null,
    Object? speakerId = null,
    Object? voiceVariantId = freezed,
    Object? text = null,
    Object? emotion = freezed,
    Object? type = null,
    Object? mergedGroupId = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            bookId: null == bookId
                ? _value.bookId
                : bookId // ignore: cast_nullable_to_non_nullable
                      as String,
            chapterIndex: null == chapterIndex
                ? _value.chapterIndex
                : chapterIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            lineIndex: null == lineIndex
                ? _value.lineIndex
                : lineIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            speakerId: null == speakerId
                ? _value.speakerId
                : speakerId // ignore: cast_nullable_to_non_nullable
                      as String,
            voiceVariantId: freezed == voiceVariantId
                ? _value.voiceVariantId
                : voiceVariantId // ignore: cast_nullable_to_non_nullable
                      as String?,
            text: null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String,
            emotion: freezed == emotion
                ? _value.emotion
                : emotion // ignore: cast_nullable_to_non_nullable
                      as String?,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as LineType,
            mergedGroupId: freezed == mergedGroupId
                ? _value.mergedGroupId
                : mergedGroupId // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ScriptLineImplCopyWith<$Res>
    implements $ScriptLineCopyWith<$Res> {
  factory _$$ScriptLineImplCopyWith(
    _$ScriptLineImpl value,
    $Res Function(_$ScriptLineImpl) then,
  ) = __$$ScriptLineImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String bookId,
    int chapterIndex,
    int lineIndex,
    String speakerId,
    String? voiceVariantId,
    String text,
    String? emotion,
    LineType type,
    int? mergedGroupId,
  });
}

/// @nodoc
class __$$ScriptLineImplCopyWithImpl<$Res>
    extends _$ScriptLineCopyWithImpl<$Res, _$ScriptLineImpl>
    implements _$$ScriptLineImplCopyWith<$Res> {
  __$$ScriptLineImplCopyWithImpl(
    _$ScriptLineImpl _value,
    $Res Function(_$ScriptLineImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ScriptLine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookId = null,
    Object? chapterIndex = null,
    Object? lineIndex = null,
    Object? speakerId = null,
    Object? voiceVariantId = freezed,
    Object? text = null,
    Object? emotion = freezed,
    Object? type = null,
    Object? mergedGroupId = freezed,
  }) {
    return _then(
      _$ScriptLineImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        bookId: null == bookId
            ? _value.bookId
            : bookId // ignore: cast_nullable_to_non_nullable
                  as String,
        chapterIndex: null == chapterIndex
            ? _value.chapterIndex
            : chapterIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        lineIndex: null == lineIndex
            ? _value.lineIndex
            : lineIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        speakerId: null == speakerId
            ? _value.speakerId
            : speakerId // ignore: cast_nullable_to_non_nullable
                  as String,
        voiceVariantId: freezed == voiceVariantId
            ? _value.voiceVariantId
            : voiceVariantId // ignore: cast_nullable_to_non_nullable
                  as String?,
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
        emotion: freezed == emotion
            ? _value.emotion
            : emotion // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as LineType,
        mergedGroupId: freezed == mergedGroupId
            ? _value.mergedGroupId
            : mergedGroupId // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ScriptLineImpl implements _ScriptLine {
  const _$ScriptLineImpl({
    required this.id,
    required this.bookId,
    required this.chapterIndex,
    required this.lineIndex,
    required this.speakerId,
    this.voiceVariantId,
    required this.text,
    this.emotion,
    this.type = LineType.narration,
    this.mergedGroupId,
  });

  factory _$ScriptLineImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScriptLineImplFromJson(json);

  @override
  final int id;
  @override
  final String bookId;
  @override
  final int chapterIndex;
  @override
  final int lineIndex;
  @override
  final String speakerId;
  @override
  final String? voiceVariantId;
  @override
  final String text;
  @override
  final String? emotion;
  @override
  @JsonKey()
  final LineType type;
  @override
  final int? mergedGroupId;

  @override
  String toString() {
    return 'ScriptLine(id: $id, bookId: $bookId, chapterIndex: $chapterIndex, lineIndex: $lineIndex, speakerId: $speakerId, voiceVariantId: $voiceVariantId, text: $text, emotion: $emotion, type: $type, mergedGroupId: $mergedGroupId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScriptLineImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.chapterIndex, chapterIndex) ||
                other.chapterIndex == chapterIndex) &&
            (identical(other.lineIndex, lineIndex) ||
                other.lineIndex == lineIndex) &&
            (identical(other.speakerId, speakerId) ||
                other.speakerId == speakerId) &&
            (identical(other.voiceVariantId, voiceVariantId) ||
                other.voiceVariantId == voiceVariantId) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.emotion, emotion) || other.emotion == emotion) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.mergedGroupId, mergedGroupId) ||
                other.mergedGroupId == mergedGroupId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    bookId,
    chapterIndex,
    lineIndex,
    speakerId,
    voiceVariantId,
    text,
    emotion,
    type,
    mergedGroupId,
  );

  /// Create a copy of ScriptLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScriptLineImplCopyWith<_$ScriptLineImpl> get copyWith =>
      __$$ScriptLineImplCopyWithImpl<_$ScriptLineImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScriptLineImplToJson(this);
  }
}

abstract class _ScriptLine implements ScriptLine {
  const factory _ScriptLine({
    required final int id,
    required final String bookId,
    required final int chapterIndex,
    required final int lineIndex,
    required final String speakerId,
    final String? voiceVariantId,
    required final String text,
    final String? emotion,
    final LineType type,
    final int? mergedGroupId,
  }) = _$ScriptLineImpl;

  factory _ScriptLine.fromJson(Map<String, dynamic> json) =
      _$ScriptLineImpl.fromJson;

  @override
  int get id;
  @override
  String get bookId;
  @override
  int get chapterIndex;
  @override
  int get lineIndex;
  @override
  String get speakerId;
  @override
  String? get voiceVariantId;
  @override
  String get text;
  @override
  String? get emotion;
  @override
  LineType get type;
  @override
  int? get mergedGroupId;

  /// Create a copy of ScriptLine
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScriptLineImplCopyWith<_$ScriptLineImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
