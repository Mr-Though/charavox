// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'character.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VoiceVariant _$VoiceVariantFromJson(Map<String, dynamic> json) {
  return _VoiceVariant.fromJson(json);
}

/// @nodoc
mixin _$VoiceVariant {
  String get variantId => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  String get voicePrompt => throw _privateConstructorUsedError;
  String? get triggerCondition => throw _privateConstructorUsedError;
  List<int>? get chapters => throw _privateConstructorUsedError;

  /// Serializes this VoiceVariant to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VoiceVariant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VoiceVariantCopyWith<VoiceVariant> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VoiceVariantCopyWith<$Res> {
  factory $VoiceVariantCopyWith(
    VoiceVariant value,
    $Res Function(VoiceVariant) then,
  ) = _$VoiceVariantCopyWithImpl<$Res, VoiceVariant>;
  @useResult
  $Res call({
    String variantId,
    String label,
    String voicePrompt,
    String? triggerCondition,
    List<int>? chapters,
  });
}

/// @nodoc
class _$VoiceVariantCopyWithImpl<$Res, $Val extends VoiceVariant>
    implements $VoiceVariantCopyWith<$Res> {
  _$VoiceVariantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VoiceVariant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? variantId = null,
    Object? label = null,
    Object? voicePrompt = null,
    Object? triggerCondition = freezed,
    Object? chapters = freezed,
  }) {
    return _then(
      _value.copyWith(
            variantId: null == variantId
                ? _value.variantId
                : variantId // ignore: cast_nullable_to_non_nullable
                      as String,
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            voicePrompt: null == voicePrompt
                ? _value.voicePrompt
                : voicePrompt // ignore: cast_nullable_to_non_nullable
                      as String,
            triggerCondition: freezed == triggerCondition
                ? _value.triggerCondition
                : triggerCondition // ignore: cast_nullable_to_non_nullable
                      as String?,
            chapters: freezed == chapters
                ? _value.chapters
                : chapters // ignore: cast_nullable_to_non_nullable
                      as List<int>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VoiceVariantImplCopyWith<$Res>
    implements $VoiceVariantCopyWith<$Res> {
  factory _$$VoiceVariantImplCopyWith(
    _$VoiceVariantImpl value,
    $Res Function(_$VoiceVariantImpl) then,
  ) = __$$VoiceVariantImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String variantId,
    String label,
    String voicePrompt,
    String? triggerCondition,
    List<int>? chapters,
  });
}

/// @nodoc
class __$$VoiceVariantImplCopyWithImpl<$Res>
    extends _$VoiceVariantCopyWithImpl<$Res, _$VoiceVariantImpl>
    implements _$$VoiceVariantImplCopyWith<$Res> {
  __$$VoiceVariantImplCopyWithImpl(
    _$VoiceVariantImpl _value,
    $Res Function(_$VoiceVariantImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VoiceVariant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? variantId = null,
    Object? label = null,
    Object? voicePrompt = null,
    Object? triggerCondition = freezed,
    Object? chapters = freezed,
  }) {
    return _then(
      _$VoiceVariantImpl(
        variantId: null == variantId
            ? _value.variantId
            : variantId // ignore: cast_nullable_to_non_nullable
                  as String,
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        voicePrompt: null == voicePrompt
            ? _value.voicePrompt
            : voicePrompt // ignore: cast_nullable_to_non_nullable
                  as String,
        triggerCondition: freezed == triggerCondition
            ? _value.triggerCondition
            : triggerCondition // ignore: cast_nullable_to_non_nullable
                  as String?,
        chapters: freezed == chapters
            ? _value._chapters
            : chapters // ignore: cast_nullable_to_non_nullable
                  as List<int>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VoiceVariantImpl implements _VoiceVariant {
  const _$VoiceVariantImpl({
    required this.variantId,
    required this.label,
    required this.voicePrompt,
    this.triggerCondition,
    final List<int>? chapters,
  }) : _chapters = chapters;

  factory _$VoiceVariantImpl.fromJson(Map<String, dynamic> json) =>
      _$$VoiceVariantImplFromJson(json);

  @override
  final String variantId;
  @override
  final String label;
  @override
  final String voicePrompt;
  @override
  final String? triggerCondition;
  final List<int>? _chapters;
  @override
  List<int>? get chapters {
    final value = _chapters;
    if (value == null) return null;
    if (_chapters is EqualUnmodifiableListView) return _chapters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'VoiceVariant(variantId: $variantId, label: $label, voicePrompt: $voicePrompt, triggerCondition: $triggerCondition, chapters: $chapters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VoiceVariantImpl &&
            (identical(other.variantId, variantId) ||
                other.variantId == variantId) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.voicePrompt, voicePrompt) ||
                other.voicePrompt == voicePrompt) &&
            (identical(other.triggerCondition, triggerCondition) ||
                other.triggerCondition == triggerCondition) &&
            const DeepCollectionEquality().equals(other._chapters, _chapters));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    variantId,
    label,
    voicePrompt,
    triggerCondition,
    const DeepCollectionEquality().hash(_chapters),
  );

  /// Create a copy of VoiceVariant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VoiceVariantImplCopyWith<_$VoiceVariantImpl> get copyWith =>
      __$$VoiceVariantImplCopyWithImpl<_$VoiceVariantImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VoiceVariantImplToJson(this);
  }
}

abstract class _VoiceVariant implements VoiceVariant {
  const factory _VoiceVariant({
    required final String variantId,
    required final String label,
    required final String voicePrompt,
    final String? triggerCondition,
    final List<int>? chapters,
  }) = _$VoiceVariantImpl;

  factory _VoiceVariant.fromJson(Map<String, dynamic> json) =
      _$VoiceVariantImpl.fromJson;

  @override
  String get variantId;
  @override
  String get label;
  @override
  String get voicePrompt;
  @override
  String? get triggerCondition;
  @override
  List<int>? get chapters;

  /// Create a copy of VoiceVariant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VoiceVariantImplCopyWith<_$VoiceVariantImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CharacterInfo _$CharacterInfoFromJson(Map<String, dynamic> json) {
  return _CharacterInfo.fromJson(json);
}

/// @nodoc
mixin _$CharacterInfo {
  String get id => throw _privateConstructorUsedError;
  String get bookId => throw _privateConstructorUsedError;
  String get canonicalName => throw _privateConstructorUsedError;
  List<String> get aliases => throw _privateConstructorUsedError;
  Gender get gender => throw _privateConstructorUsedError;
  AgeGroup get age => throw _privateConstructorUsedError;
  List<String> get personalities => throw _privateConstructorUsedError;
  String? get firstPerson => throw _privateConstructorUsedError;
  List<String>? get sentenceEndings => throw _privateConstructorUsedError;
  String get voicePrompt => throw _privateConstructorUsedError;
  List<VoiceVariant> get voiceVariants => throw _privateConstructorUsedError;
  bool get isNarrator => throw _privateConstructorUsedError;

  /// Serializes this CharacterInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CharacterInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CharacterInfoCopyWith<CharacterInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CharacterInfoCopyWith<$Res> {
  factory $CharacterInfoCopyWith(
    CharacterInfo value,
    $Res Function(CharacterInfo) then,
  ) = _$CharacterInfoCopyWithImpl<$Res, CharacterInfo>;
  @useResult
  $Res call({
    String id,
    String bookId,
    String canonicalName,
    List<String> aliases,
    Gender gender,
    AgeGroup age,
    List<String> personalities,
    String? firstPerson,
    List<String>? sentenceEndings,
    String voicePrompt,
    List<VoiceVariant> voiceVariants,
    bool isNarrator,
  });
}

/// @nodoc
class _$CharacterInfoCopyWithImpl<$Res, $Val extends CharacterInfo>
    implements $CharacterInfoCopyWith<$Res> {
  _$CharacterInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CharacterInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookId = null,
    Object? canonicalName = null,
    Object? aliases = null,
    Object? gender = null,
    Object? age = null,
    Object? personalities = null,
    Object? firstPerson = freezed,
    Object? sentenceEndings = freezed,
    Object? voicePrompt = null,
    Object? voiceVariants = null,
    Object? isNarrator = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            bookId: null == bookId
                ? _value.bookId
                : bookId // ignore: cast_nullable_to_non_nullable
                      as String,
            canonicalName: null == canonicalName
                ? _value.canonicalName
                : canonicalName // ignore: cast_nullable_to_non_nullable
                      as String,
            aliases: null == aliases
                ? _value.aliases
                : aliases // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            gender: null == gender
                ? _value.gender
                : gender // ignore: cast_nullable_to_non_nullable
                      as Gender,
            age: null == age
                ? _value.age
                : age // ignore: cast_nullable_to_non_nullable
                      as AgeGroup,
            personalities: null == personalities
                ? _value.personalities
                : personalities // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            firstPerson: freezed == firstPerson
                ? _value.firstPerson
                : firstPerson // ignore: cast_nullable_to_non_nullable
                      as String?,
            sentenceEndings: freezed == sentenceEndings
                ? _value.sentenceEndings
                : sentenceEndings // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            voicePrompt: null == voicePrompt
                ? _value.voicePrompt
                : voicePrompt // ignore: cast_nullable_to_non_nullable
                      as String,
            voiceVariants: null == voiceVariants
                ? _value.voiceVariants
                : voiceVariants // ignore: cast_nullable_to_non_nullable
                      as List<VoiceVariant>,
            isNarrator: null == isNarrator
                ? _value.isNarrator
                : isNarrator // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CharacterInfoImplCopyWith<$Res>
    implements $CharacterInfoCopyWith<$Res> {
  factory _$$CharacterInfoImplCopyWith(
    _$CharacterInfoImpl value,
    $Res Function(_$CharacterInfoImpl) then,
  ) = __$$CharacterInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String bookId,
    String canonicalName,
    List<String> aliases,
    Gender gender,
    AgeGroup age,
    List<String> personalities,
    String? firstPerson,
    List<String>? sentenceEndings,
    String voicePrompt,
    List<VoiceVariant> voiceVariants,
    bool isNarrator,
  });
}

/// @nodoc
class __$$CharacterInfoImplCopyWithImpl<$Res>
    extends _$CharacterInfoCopyWithImpl<$Res, _$CharacterInfoImpl>
    implements _$$CharacterInfoImplCopyWith<$Res> {
  __$$CharacterInfoImplCopyWithImpl(
    _$CharacterInfoImpl _value,
    $Res Function(_$CharacterInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CharacterInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookId = null,
    Object? canonicalName = null,
    Object? aliases = null,
    Object? gender = null,
    Object? age = null,
    Object? personalities = null,
    Object? firstPerson = freezed,
    Object? sentenceEndings = freezed,
    Object? voicePrompt = null,
    Object? voiceVariants = null,
    Object? isNarrator = null,
  }) {
    return _then(
      _$CharacterInfoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        bookId: null == bookId
            ? _value.bookId
            : bookId // ignore: cast_nullable_to_non_nullable
                  as String,
        canonicalName: null == canonicalName
            ? _value.canonicalName
            : canonicalName // ignore: cast_nullable_to_non_nullable
                  as String,
        aliases: null == aliases
            ? _value._aliases
            : aliases // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        gender: null == gender
            ? _value.gender
            : gender // ignore: cast_nullable_to_non_nullable
                  as Gender,
        age: null == age
            ? _value.age
            : age // ignore: cast_nullable_to_non_nullable
                  as AgeGroup,
        personalities: null == personalities
            ? _value._personalities
            : personalities // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        firstPerson: freezed == firstPerson
            ? _value.firstPerson
            : firstPerson // ignore: cast_nullable_to_non_nullable
                  as String?,
        sentenceEndings: freezed == sentenceEndings
            ? _value._sentenceEndings
            : sentenceEndings // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        voicePrompt: null == voicePrompt
            ? _value.voicePrompt
            : voicePrompt // ignore: cast_nullable_to_non_nullable
                  as String,
        voiceVariants: null == voiceVariants
            ? _value._voiceVariants
            : voiceVariants // ignore: cast_nullable_to_non_nullable
                  as List<VoiceVariant>,
        isNarrator: null == isNarrator
            ? _value.isNarrator
            : isNarrator // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CharacterInfoImpl implements _CharacterInfo {
  const _$CharacterInfoImpl({
    required this.id,
    required this.bookId,
    required this.canonicalName,
    final List<String> aliases = const [],
    this.gender = Gender.unknown,
    this.age = AgeGroup.unknown,
    final List<String> personalities = const [],
    this.firstPerson,
    final List<String>? sentenceEndings,
    required this.voicePrompt,
    final List<VoiceVariant> voiceVariants = const [],
    this.isNarrator = false,
  }) : _aliases = aliases,
       _personalities = personalities,
       _sentenceEndings = sentenceEndings,
       _voiceVariants = voiceVariants;

  factory _$CharacterInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CharacterInfoImplFromJson(json);

  @override
  final String id;
  @override
  final String bookId;
  @override
  final String canonicalName;
  final List<String> _aliases;
  @override
  @JsonKey()
  List<String> get aliases {
    if (_aliases is EqualUnmodifiableListView) return _aliases;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_aliases);
  }

  @override
  @JsonKey()
  final Gender gender;
  @override
  @JsonKey()
  final AgeGroup age;
  final List<String> _personalities;
  @override
  @JsonKey()
  List<String> get personalities {
    if (_personalities is EqualUnmodifiableListView) return _personalities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_personalities);
  }

  @override
  final String? firstPerson;
  final List<String>? _sentenceEndings;
  @override
  List<String>? get sentenceEndings {
    final value = _sentenceEndings;
    if (value == null) return null;
    if (_sentenceEndings is EqualUnmodifiableListView) return _sentenceEndings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String voicePrompt;
  final List<VoiceVariant> _voiceVariants;
  @override
  @JsonKey()
  List<VoiceVariant> get voiceVariants {
    if (_voiceVariants is EqualUnmodifiableListView) return _voiceVariants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_voiceVariants);
  }

  @override
  @JsonKey()
  final bool isNarrator;

  @override
  String toString() {
    return 'CharacterInfo(id: $id, bookId: $bookId, canonicalName: $canonicalName, aliases: $aliases, gender: $gender, age: $age, personalities: $personalities, firstPerson: $firstPerson, sentenceEndings: $sentenceEndings, voicePrompt: $voicePrompt, voiceVariants: $voiceVariants, isNarrator: $isNarrator)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CharacterInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.canonicalName, canonicalName) ||
                other.canonicalName == canonicalName) &&
            const DeepCollectionEquality().equals(other._aliases, _aliases) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.age, age) || other.age == age) &&
            const DeepCollectionEquality().equals(
              other._personalities,
              _personalities,
            ) &&
            (identical(other.firstPerson, firstPerson) ||
                other.firstPerson == firstPerson) &&
            const DeepCollectionEquality().equals(
              other._sentenceEndings,
              _sentenceEndings,
            ) &&
            (identical(other.voicePrompt, voicePrompt) ||
                other.voicePrompt == voicePrompt) &&
            const DeepCollectionEquality().equals(
              other._voiceVariants,
              _voiceVariants,
            ) &&
            (identical(other.isNarrator, isNarrator) ||
                other.isNarrator == isNarrator));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    bookId,
    canonicalName,
    const DeepCollectionEquality().hash(_aliases),
    gender,
    age,
    const DeepCollectionEquality().hash(_personalities),
    firstPerson,
    const DeepCollectionEquality().hash(_sentenceEndings),
    voicePrompt,
    const DeepCollectionEquality().hash(_voiceVariants),
    isNarrator,
  );

  /// Create a copy of CharacterInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CharacterInfoImplCopyWith<_$CharacterInfoImpl> get copyWith =>
      __$$CharacterInfoImplCopyWithImpl<_$CharacterInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CharacterInfoImplToJson(this);
  }
}

abstract class _CharacterInfo implements CharacterInfo {
  const factory _CharacterInfo({
    required final String id,
    required final String bookId,
    required final String canonicalName,
    final List<String> aliases,
    final Gender gender,
    final AgeGroup age,
    final List<String> personalities,
    final String? firstPerson,
    final List<String>? sentenceEndings,
    required final String voicePrompt,
    final List<VoiceVariant> voiceVariants,
    final bool isNarrator,
  }) = _$CharacterInfoImpl;

  factory _CharacterInfo.fromJson(Map<String, dynamic> json) =
      _$CharacterInfoImpl.fromJson;

  @override
  String get id;
  @override
  String get bookId;
  @override
  String get canonicalName;
  @override
  List<String> get aliases;
  @override
  Gender get gender;
  @override
  AgeGroup get age;
  @override
  List<String> get personalities;
  @override
  String? get firstPerson;
  @override
  List<String>? get sentenceEndings;
  @override
  String get voicePrompt;
  @override
  List<VoiceVariant> get voiceVariants;
  @override
  bool get isNarrator;

  /// Create a copy of CharacterInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CharacterInfoImplCopyWith<_$CharacterInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
