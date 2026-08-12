//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FaceRepairClusterFacesResponseDtoFacesInner {
  /// Returns a new [FaceRepairClusterFacesResponseDtoFacesInner] instance.
  FaceRepairClusterFacesResponseDtoFacesInner({
    required this.assetFaceId,
  });

  String assetFaceId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FaceRepairClusterFacesResponseDtoFacesInner &&
    other.assetFaceId == assetFaceId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (assetFaceId.hashCode);

  @override
  String toString() => 'FaceRepairClusterFacesResponseDtoFacesInner[assetFaceId=$assetFaceId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'assetFaceId'] = this.assetFaceId;
    return json;
  }

  /// Returns a new [FaceRepairClusterFacesResponseDtoFacesInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FaceRepairClusterFacesResponseDtoFacesInner? fromJson(dynamic value) {
    upgradeDto(value, "FaceRepairClusterFacesResponseDtoFacesInner");
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return FaceRepairClusterFacesResponseDtoFacesInner(
        assetFaceId: mapValueOfType<String>(json, r'assetFaceId')!,
      );
    }
    return null;
  }

  static List<FaceRepairClusterFacesResponseDtoFacesInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FaceRepairClusterFacesResponseDtoFacesInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FaceRepairClusterFacesResponseDtoFacesInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FaceRepairClusterFacesResponseDtoFacesInner> mapFromJson(dynamic json) {
    final map = <String, FaceRepairClusterFacesResponseDtoFacesInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FaceRepairClusterFacesResponseDtoFacesInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FaceRepairClusterFacesResponseDtoFacesInner-objects as value to a dart map
  static Map<String, List<FaceRepairClusterFacesResponseDtoFacesInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FaceRepairClusterFacesResponseDtoFacesInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FaceRepairClusterFacesResponseDtoFacesInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'assetFaceId',
  };
}

