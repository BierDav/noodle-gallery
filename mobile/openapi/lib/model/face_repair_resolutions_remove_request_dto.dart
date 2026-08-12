//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FaceRepairResolutionsRemoveRequestDto {
  /// Returns a new [FaceRepairResolutionsRemoveRequestDto] instance.
  FaceRepairResolutionsRemoveRequestDto({
    this.clusterMuteIds = const Optional.present(const []),
    this.verdictIds = const Optional.present(const []),
  });

  Optional<List<String>?> clusterMuteIds;

  Optional<List<String>?> verdictIds;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FaceRepairResolutionsRemoveRequestDto &&
    _deepEquality.equals(other.clusterMuteIds, clusterMuteIds) &&
    _deepEquality.equals(other.verdictIds, verdictIds);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (clusterMuteIds.hashCode) +
    (verdictIds.hashCode);

  @override
  String toString() => 'FaceRepairResolutionsRemoveRequestDto[clusterMuteIds=$clusterMuteIds, verdictIds=$verdictIds]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.clusterMuteIds.isPresent) {
      final value = this.clusterMuteIds.value;
      json[r'clusterMuteIds'] = value;
    }
    if (this.verdictIds.isPresent) {
      final value = this.verdictIds.value;
      json[r'verdictIds'] = value;
    }
    return json;
  }

  /// Returns a new [FaceRepairResolutionsRemoveRequestDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FaceRepairResolutionsRemoveRequestDto? fromJson(dynamic value) {
    upgradeDto(value, "FaceRepairResolutionsRemoveRequestDto");
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return FaceRepairResolutionsRemoveRequestDto(
        clusterMuteIds: json.containsKey(r'clusterMuteIds') ? Optional.present(json[r'clusterMuteIds'] is Iterable
            ? (json[r'clusterMuteIds'] as Iterable).cast<String>().toList(growable: false)
            : const []) : const Optional.absent(),
        verdictIds: json.containsKey(r'verdictIds') ? Optional.present(json[r'verdictIds'] is Iterable
            ? (json[r'verdictIds'] as Iterable).cast<String>().toList(growable: false)
            : const []) : const Optional.absent(),
      );
    }
    return null;
  }

  static List<FaceRepairResolutionsRemoveRequestDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FaceRepairResolutionsRemoveRequestDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FaceRepairResolutionsRemoveRequestDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FaceRepairResolutionsRemoveRequestDto> mapFromJson(dynamic json) {
    final map = <String, FaceRepairResolutionsRemoveRequestDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FaceRepairResolutionsRemoveRequestDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FaceRepairResolutionsRemoveRequestDto-objects as value to a dart map
  static Map<String, List<FaceRepairResolutionsRemoveRequestDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FaceRepairResolutionsRemoveRequestDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FaceRepairResolutionsRemoveRequestDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

