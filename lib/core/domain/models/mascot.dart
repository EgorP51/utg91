import 'package:freezed_annotation/freezed_annotation.dart';

part 'mascot.freezed.dart';
part 'mascot.g.dart';

/// Domain model for mascot entities
/// Immutable, serializable, with full equality support via freezed
@freezed
class Mascot with _$Mascot {
  const factory Mascot({
    required String id,
    required String name,
    required String description,
    required MascotRarity rarity,

    /// Null if locked, DateTime if unlocked
    DateTime? unlockDate,

    /// Optional fields for future expansion
    @Default(0.0) double latitude,
    @Default(0.0) double longitude,
    String? imageUrl,
  }) = _Mascot;

  factory Mascot.fromJson(Map<String, dynamic> json) => _$MascotFromJson(json);
}

/// Enum for mascot rarity levels
/// Impacts UI styling and unlock probability
enum MascotRarity {
  @JsonValue('common')
  common,

  @JsonValue('rare')
  rare,

  @JsonValue('epic')
  epic,

  @JsonValue('legendary')
  legendary;

  /// Returns color-coded rarity for UI theming
  String get displayName {
    switch (this) {
      case MascotRarity.common:
        return 'Common';
      case MascotRarity.rare:
        return 'Rare';
      case MascotRarity.epic:
        return 'Epic';
      case MascotRarity.legendary:
        return 'Legendary';
    }
  }
}
