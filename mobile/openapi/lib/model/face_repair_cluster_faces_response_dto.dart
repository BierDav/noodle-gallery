//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FaceRepairClusterFacesResponseDto {
  /// Returns a new [FaceRepairClusterFacesResponseDto] instance.
  FaceRepairClusterFacesResponseDto({
    this.faces = const [],
    required this.hasMore,
    required this.total,
  });

  List<FaceRepairClusterFacesResponseDtoFacesInner> faces;

  bool hasMore;

  num total;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FaceRepairClusterFacesResponseDto &&
    _deepEquality.equals(other.faces, faces) &&
    other.hasMore == hasMore &&
    other.total == total;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (faces.hashCode) +
    (hasMore.hashCode) +
    (total.hashCode);

  @override
  String toString() => 'FaceRepairClusterFacesResponseDto[faces=$faces, hasMore=$hasMore, total=$total]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'faces'] = this.faces;
      json[r'hasMore'] = this.hasMore;
      json[r'total'] = this.total;
    return json;
  }

  /// Returns a new [FaceRepairClusterFacesResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FaceRepairClusterFacesResponseDto? fromJson(dynamic value) {
    upgradeDto(value, "FaceRepairClusterFacesResponseDto");
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return FaceRepairClusterFacesResponseDto(
        faces: FaceRepairClusterFacesResponseDtoFacesInner.listFromJson(json[r'faces']),
        hasMore: mapValueOfType<bool>(json, r'hasMore')!,
        total: num.parse('${json[r'total']}'),
      );
    }
    return null;
  }

  static List<FaceRepairClusterFacesResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FaceRepairClusterFacesResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FaceRepairClusterFacesResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FaceRepairClusterFacesResponseDto> mapFromJson(dynamic json) {
    final map = <String, FaceRepairClusterFacesResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FaceRepairClusterFacesResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FaceRepairClusterFacesResponseDto-objects as value to a dart map
  static Map<String, List<FaceRepairClusterFacesResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FaceRepairClusterFacesResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FaceRepairClusterFacesResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'faces',
    'hasMore',
    'total',
  };
}

