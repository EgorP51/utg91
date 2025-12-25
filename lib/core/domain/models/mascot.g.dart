// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mascot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MascotImpl _$$MascotImplFromJson(Map<String, dynamic> json) => _$MascotImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      rarity: $enumDecode(_$MascotRarityEnumMap, json['rarity']),
      unlockDate: json['unlockDate'] == null
          ? null
          : DateTime.parse(json['unlockDate'] as String),
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$$MascotImplToJson(_$MascotImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'rarity': _$MascotRarityEnumMap[instance.rarity]!,
      'unlockDate': instance.unlockDate?.toIso8601String(),
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'imageUrl': instance.imageUrl,
    };

const _$MascotRarityEnumMap = {
  MascotRarity.common: 'common',
  MascotRarity.rare: 'rare',
  MascotRarity.epic: 'epic',
  MascotRarity.legendary: 'legendary',
};
