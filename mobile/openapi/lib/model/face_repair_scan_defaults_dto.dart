//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FaceRepairScanDefaultsDto {
  /// Returns a new [FaceRepairScanDefaultsDto] instance.
  FaceRepairScanDefaultsDto({
    required this.maxDistance,
    required this.maxFlaggedFraction,
    required this.minFaces,
  });

  num maxDistance;

  num maxFlaggedFraction;

  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int minFaces;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FaceRepairScanDefaultsDto &&
    other.maxDistance == maxDistance &&
    other.maxFlaggedFraction == maxFlaggedFraction &&
    other.minFaces == minFaces;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (maxDistance.hashCode) +
    (maxFlaggedFraction.hashCode) +
    (minFaces.hashCode);

  @override
  String toString() => 'FaceRepairScanDefaultsDto[maxDistance=$maxDistance, maxFlaggedFraction=$maxFlaggedFraction, minFaces=$minFaces]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'maxDistance'] = this.maxDistance;
      json[r'maxFlaggedFraction'] = this.maxFlaggedFraction;
      json[r'minFaces'] = this.minFaces;
    return json;
  }

  /// Returns a new [FaceRepairScanDefaultsDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FaceRepairScanDefaultsDto? fromJson(dynamic value) {
    upgradeDto(value, "FaceRepairScanDefaultsDto");
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return FaceRepairScanDefaultsDto(
        maxDistance: num.parse('${json[r'maxDistance']}'),
        maxFlaggedFraction: num.parse('${json[r'maxFlaggedFraction']}'),
        minFaces: mapValueOfType<int>(json, r'minFaces')!,
      );
    }
    return null;
  }

  static List<FaceRepairScanDefaultsDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FaceRepairScanDefaultsDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FaceRepairScanDefaultsDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FaceRepairScanDefaultsDto> mapFromJson(dynamic json) {
    final map = <String, FaceRepairScanDefaultsDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FaceRepairScanDefaultsDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FaceRepairScanDefaultsDto-objects as value to a dart map
  static Map<String, List<FaceRepairScanDefaultsDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FaceRepairScanDefaultsDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FaceRepairScanDefaultsDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'maxDistance',
    'maxFlaggedFraction',
    'minFaces',
  };
}

