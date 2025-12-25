// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mascot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Mascot _$MascotFromJson(Map<String, dynamic> json) {
  return _Mascot.fromJson(json);
}

/// @nodoc
mixin _$Mascot {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  MascotRarity get rarity => throw _privateConstructorUsedError;

  /// Null if locked, DateTime if unlocked
  DateTime? get unlockDate => throw _privateConstructorUsedError;

  /// Geolocation fields for map positioning
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;

  /// Interaction radius in meters - distance user must be within to discover
  /// Varies by rarity: Common=50m, Rare=30m, Epic=20m, Legendary=15m
  double get interactionRadius => throw _privateConstructorUsedError;

  /// Optional fields for future expansion
  String? get imageUrl => throw _privateConstructorUsedError;

  /// Serializes this Mascot to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Mascot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MascotCopyWith<Mascot> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MascotCopyWith<$Res> {
  factory $MascotCopyWith(Mascot value, $Res Function(Mascot) then) =
      _$MascotCopyWithImpl<$Res, Mascot>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      MascotRarity rarity,
      DateTime? unlockDate,
      double latitude,
      double longitude,
      double interactionRadius,
      String? imageUrl});
}

/// @nodoc
class _$MascotCopyWithImpl<$Res, $Val extends Mascot>
    implements $MascotCopyWith<$Res> {
  _$MascotCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Mascot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? rarity = null,
    Object? unlockDate = freezed,
    Object? latitude = null,
    Object? longitude = null,
    Object? interactionRadius = null,
    Object? imageUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      rarity: null == rarity
          ? _value.rarity
          : rarity // ignore: cast_nullable_to_non_nullable
              as MascotRarity,
      unlockDate: freezed == unlockDate
          ? _value.unlockDate
          : unlockDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      interactionRadius: null == interactionRadius
          ? _value.interactionRadius
          : interactionRadius // ignore: cast_nullable_to_non_nullable
              as double,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MascotImplCopyWith<$Res> implements $MascotCopyWith<$Res> {
  factory _$$MascotImplCopyWith(
          _$MascotImpl value, $Res Function(_$MascotImpl) then) =
      __$$MascotImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      MascotRarity rarity,
      DateTime? unlockDate,
      double latitude,
      double longitude,
      double interactionRadius,
      String? imageUrl});
}

/// @nodoc
class __$$MascotImplCopyWithImpl<$Res>
    extends _$MascotCopyWithImpl<$Res, _$MascotImpl>
    implements _$$MascotImplCopyWith<$Res> {
  __$$MascotImplCopyWithImpl(
      _$MascotImpl _value, $Res Function(_$MascotImpl) _then)
      : super(_value, _then);

  /// Create a copy of Mascot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? rarity = null,
    Object? unlockDate = freezed,
    Object? latitude = null,
    Object? longitude = null,
    Object? interactionRadius = null,
    Object? imageUrl = freezed,
  }) {
    return _then(_$MascotImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      rarity: null == rarity
          ? _value.rarity
          : rarity // ignore: cast_nullable_to_non_nullable
              as MascotRarity,
      unlockDate: freezed == unlockDate
          ? _value.unlockDate
          : unlockDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      interactionRadius: null == interactionRadius
          ? _value.interactionRadius
          : interactionRadius // ignore: cast_nullable_to_non_nullable
              as double,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MascotImpl implements _Mascot {
  const _$MascotImpl(
      {required this.id,
      required this.name,
      required this.description,
      required this.rarity,
      this.unlockDate,
      this.latitude = 0.0,
      this.longitude = 0.0,
      this.interactionRadius = 50.0,
      this.imageUrl});

  factory _$MascotImpl.fromJson(Map<String, dynamic> json) =>
      _$$MascotImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final MascotRarity rarity;

  /// Null if locked, DateTime if unlocked
  @override
  final DateTime? unlockDate;

  /// Geolocation fields for map positioning
  @override
  @JsonKey()
  final double latitude;
  @override
  @JsonKey()
  final double longitude;

  /// Interaction radius in meters - distance user must be within to discover
  /// Varies by rarity: Common=50m, Rare=30m, Epic=20m, Legendary=15m
  @override
  @JsonKey()
  final double interactionRadius;

  /// Optional fields for future expansion
  @override
  final String? imageUrl;

  @override
  String toString() {
    return 'Mascot(id: $id, name: $name, description: $description, rarity: $rarity, unlockDate: $unlockDate, latitude: $latitude, longitude: $longitude, interactionRadius: $interactionRadius, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MascotImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.rarity, rarity) || other.rarity == rarity) &&
            (identical(other.unlockDate, unlockDate) ||
                other.unlockDate == unlockDate) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.interactionRadius, interactionRadius) ||
                other.interactionRadius == interactionRadius) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, description, rarity,
      unlockDate, latitude, longitude, interactionRadius, imageUrl);

  /// Create a copy of Mascot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MascotImplCopyWith<_$MascotImpl> get copyWith =>
      __$$MascotImplCopyWithImpl<_$MascotImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MascotImplToJson(
      this,
    );
  }
}

abstract class _Mascot implements Mascot {
  const factory _Mascot(
      {required final String id,
      required final String name,
      required final String description,
      required final MascotRarity rarity,
      final DateTime? unlockDate,
      final double latitude,
      final double longitude,
      final double interactionRadius,
      final String? imageUrl}) = _$MascotImpl;

  factory _Mascot.fromJson(Map<String, dynamic> json) = _$MascotImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  MascotRarity get rarity;

  /// Null if locked, DateTime if unlocked
  @override
  DateTime? get unlockDate;

  /// Geolocation fields for map positioning
  @override
  double get latitude;
  @override
  double get longitude;

  /// Interaction radius in meters - distance user must be within to discover
  /// Varies by rarity: Common=50m, Rare=30m, Epic=20m, Legendary=15m
  @override
  double get interactionRadius;

  /// Optional fields for future expansion
  @override
  String? get imageUrl;

  /// Create a copy of Mascot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MascotImplCopyWith<_$MascotImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
