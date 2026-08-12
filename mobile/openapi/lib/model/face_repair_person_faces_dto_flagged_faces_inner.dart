//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FaceRepairPersonFacesDtoFlaggedFacesInner {
  /// Returns a new [FaceRepairPersonFacesDtoFlaggedFacesInner] instance.
  FaceRepairPersonFacesDtoFlaggedFacesInner({
    required this.assetFaceId,
    required this.suspectedOwnerId,
  });

  String assetFaceId;

  String suspectedOwnerId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FaceRepairPersonFacesDtoFlaggedFacesInner &&
    other.assetFaceId == assetFaceId &&
    other.suspectedOwnerId == suspectedOwnerId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (assetFaceId.hashCode) +
    (suspectedOwnerId.hashCode);

  @override
  String toString() => 'FaceRepairPersonFacesDtoFlaggedFacesInner[assetFaceId=$assetFaceId, suspectedOwnerId=$suspectedOwnerId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'assetFaceId'] = this.assetFaceId;
      json[r'suspectedOwnerId'] = this.suspectedOwnerId;
    return json;
  }

  /// Returns a new [FaceRepairPersonFacesDtoFlaggedFacesInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FaceRepairPersonFacesDtoFlaggedFacesInner? fromJson(dynamic value) {
    upgradeDto(value, "FaceRepairPersonFacesDtoFlaggedFacesInner");
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return FaceRepairPersonFacesDtoFlaggedFacesInner(
        assetFaceId: mapValueOfType<String>(json, r'assetFaceId')!,
        suspectedOwnerId: mapValueOfType<String>(json, r'suspectedOwnerId')!,
      );
    }
    return null;
  }

  static List<FaceRepairPersonFacesDtoFlaggedFacesInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FaceRepairPersonFacesDtoFlaggedFacesInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FaceRepairPersonFacesDtoFlaggedFacesInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FaceRepairPersonFacesDtoFlaggedFacesInner> mapFromJson(dynamic json) {
    final map = <String, FaceRepairPersonFacesDtoFlaggedFacesInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FaceRepairPersonFacesDtoFlaggedFacesInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FaceRepairPersonFacesDtoFlaggedFacesInner-objects as value to a dart map
  static Map<String, List<FaceRepairPersonFacesDtoFlaggedFacesInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FaceRepairPersonFacesDtoFlaggedFacesInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FaceRepairPersonFacesDtoFlaggedFacesInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'assetFaceId',
    'suspectedOwnerId',
  };
}

