//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FaceRepairClusterFacesRequestDto {
  /// Returns a new [FaceRepairClusterFacesRequestDto] instance.
  FaceRepairClusterFacesRequestDto({
    this.excludeFaceIds = const Optional.present(const []),
    required this.page,
    required this.size,
  });

  Optional<List<String>?> excludeFaceIds;

  /// Minimum value: 0
  /// Maximum value: 9007199254740991
  int page;

  /// Minimum value: 1
  /// Maximum value: 200
  int size;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FaceRepairClusterFacesRequestDto &&
    _deepEquality.equals(other.excludeFaceIds, excludeFaceIds) &&
    other.page == page &&
    other.size == size;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (excludeFaceIds.hashCode) +
    (page.hashCode) +
    (size.hashCode);

  @override
  String toString() => 'FaceRepairClusterFacesRequestDto[excludeFaceIds=$excludeFaceIds, page=$page, size=$size]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.excludeFaceIds.isPresent) {
      final value = this.excludeFaceIds.value;
      json[r'excludeFaceIds'] = value;
    }
      json[r'page'] = this.page;
      json[r'size'] = this.size;
    return json;
  }

  /// Returns a new [FaceRepairClusterFacesRequestDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FaceRepairClusterFacesRequestDto? fromJson(dynamic value) {
    upgradeDto(value, "FaceRepairClusterFacesRequestDto");
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return FaceRepairClusterFacesRequestDto(
        excludeFaceIds: json.containsKey(r'excludeFaceIds') ? Optional.present(json[r'excludeFaceIds'] is Iterable
            ? (json[r'excludeFaceIds'] as Iterable).cast<String>().toList(growable: false)
            : const []) : const Optional.absent(),
        page: mapValueOfType<int>(json, r'page')!,
        size: mapValueOfType<int>(json, r'size')!,
      );
    }
    return null;
  }

  static List<FaceRepairClusterFacesRequestDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FaceRepairClusterFacesRequestDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FaceRepairClusterFacesRequestDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FaceRepairClusterFacesRequestDto> mapFromJson(dynamic json) {
    final map = <String, FaceRepairClusterFacesRequestDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FaceRepairClusterFacesRequestDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FaceRepairClusterFacesRequestDto-objects as value to a dart map
  static Map<String, List<FaceRepairClusterFacesRequestDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FaceRepairClusterFacesRequestDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FaceRepairClusterFacesRequestDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'page',
    'size',
  };
}

