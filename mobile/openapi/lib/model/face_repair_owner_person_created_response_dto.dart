//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FaceRepairOwnerPersonCreatedResponseDto {
  /// Returns a new [FaceRepairOwnerPersonCreatedResponseDto] instance.
  FaceRepairOwnerPersonCreatedResponseDto({
    required this.id,
  });

  String id;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FaceRepairOwnerPersonCreatedResponseDto &&
    other.id == id;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode);

  @override
  String toString() => 'FaceRepairOwnerPersonCreatedResponseDto[id=$id]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
    return json;
  }

  /// Returns a new [FaceRepairOwnerPersonCreatedResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FaceRepairOwnerPersonCreatedResponseDto? fromJson(dynamic value) {
    upgradeDto(value, "FaceRepairOwnerPersonCreatedResponseDto");
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return FaceRepairOwnerPersonCreatedResponseDto(
        id: mapValueOfType<String>(json, r'id')!,
      );
    }
    return null;
  }

  static List<FaceRepairOwnerPersonCreatedResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FaceRepairOwnerPersonCreatedResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FaceRepairOwnerPersonCreatedResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FaceRepairOwnerPersonCreatedResponseDto> mapFromJson(dynamic json) {
    final map = <String, FaceRepairOwnerPersonCreatedResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FaceRepairOwnerPersonCreatedResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FaceRepairOwnerPersonCreatedResponseDto-objects as value to a dart map
  static Map<String, List<FaceRepairOwnerPersonCreatedResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FaceRepairOwnerPersonCreatedResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FaceRepairOwnerPersonCreatedResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
  };
}

