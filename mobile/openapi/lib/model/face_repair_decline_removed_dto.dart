//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FaceRepairDeclineRemovedDto {
  /// Returns a new [FaceRepairDeclineRemovedDto] instance.
  FaceRepairDeclineRemovedDto({
    required this.removed,
  });

  num removed;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FaceRepairDeclineRemovedDto &&
    other.removed == removed;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (removed.hashCode);

  @override
  String toString() => 'FaceRepairDeclineRemovedDto[removed=$removed]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'removed'] = this.removed;
    return json;
  }

  /// Returns a new [FaceRepairDeclineRemovedDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FaceRepairDeclineRemovedDto? fromJson(dynamic value) {
    upgradeDto(value, "FaceRepairDeclineRemovedDto");
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return FaceRepairDeclineRemovedDto(
        removed: num.parse('${json[r'removed']}'),
      );
    }
    return null;
  }

  static List<FaceRepairDeclineRemovedDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FaceRepairDeclineRemovedDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FaceRepairDeclineRemovedDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FaceRepairDeclineRemovedDto> mapFromJson(dynamic json) {
    final map = <String, FaceRepairDeclineRemovedDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FaceRepairDeclineRemovedDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FaceRepairDeclineRemovedDto-objects as value to a dart map
  static Map<String, List<FaceRepairDeclineRemovedDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FaceRepairDeclineRemovedDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FaceRepairDeclineRemovedDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'removed',
  };
}

