//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FaceRepairResolutionsListDto {
  /// Returns a new [FaceRepairResolutionsListDto] instance.
  FaceRepairResolutionsListDto({
    this.resolutions = const [],
    required this.total,
  });

  List<FaceRepairResolutionsListDtoResolutionsInner> resolutions;

  /// Minimum value: 0
  /// Maximum value: 9007199254740991
  int total;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FaceRepairResolutionsListDto &&
    _deepEquality.equals(other.resolutions, resolutions) &&
    other.total == total;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (resolutions.hashCode) +
    (total.hashCode);

  @override
  String toString() => 'FaceRepairResolutionsListDto[resolutions=$resolutions, total=$total]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'resolutions'] = this.resolutions;
      json[r'total'] = this.total;
    return json;
  }

  /// Returns a new [FaceRepairResolutionsListDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FaceRepairResolutionsListDto? fromJson(dynamic value) {
    upgradeDto(value, "FaceRepairResolutionsListDto");
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return FaceRepairResolutionsListDto(
        resolutions: FaceRepairResolutionsListDtoResolutionsInner.listFromJson(json[r'resolutions']),
        total: mapValueOfType<int>(json, r'total')!,
      );
    }
    return null;
  }

  static List<FaceRepairResolutionsListDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FaceRepairResolutionsListDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FaceRepairResolutionsListDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FaceRepairResolutionsListDto> mapFromJson(dynamic json) {
    final map = <String, FaceRepairResolutionsListDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FaceRepairResolutionsListDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FaceRepairResolutionsListDto-objects as value to a dart map
  static Map<String, List<FaceRepairResolutionsListDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FaceRepairResolutionsListDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FaceRepairResolutionsListDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'resolutions',
    'total',
  };
}

