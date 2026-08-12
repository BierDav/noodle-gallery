//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FaceRepairResolutionsRemovedDto {
  /// Returns a new [FaceRepairResolutionsRemovedDto] instance.
  FaceRepairResolutionsRemovedDto({
    required this.removed,
  });

  num removed;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FaceRepairResolutionsRemovedDto &&
    other.removed == removed;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (removed.hashCode);

  @override
  String toString() => 'FaceRepairResolutionsRemovedDto[removed=$removed]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'removed'] = this.removed;
    return json;
  }

  /// Returns a new [FaceRepairResolutionsRemovedDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FaceRepairResolutionsRemovedDto? fromJson(dynamic value) {
    upgradeDto(value, "FaceRepairResolutionsRemovedDto");
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return FaceRepairResolutionsRemovedDto(
        removed: num.parse('${json[r'removed']}'),
      );
    }
    return null;
  }

  static List<FaceRepairResolutionsRemovedDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FaceRepairResolutionsRemovedDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FaceRepairResolutionsRemovedDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FaceRepairResolutionsRemovedDto> mapFromJson(dynamic json) {
    final map = <String, FaceRepairResolutionsRemovedDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FaceRepairResolutionsRemovedDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FaceRepairResolutionsRemovedDto-objects as value to a dart map
  static Map<String, List<FaceRepairResolutionsRemovedDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FaceRepairResolutionsRemovedDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FaceRepairResolutionsRemovedDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'removed',
  };
}

