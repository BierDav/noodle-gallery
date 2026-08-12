//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FaceRepairOwnerPeopleResponseDtoPeopleInner {
  /// Returns a new [FaceRepairOwnerPeopleResponseDtoPeopleInner] instance.
  FaceRepairOwnerPeopleResponseDtoPeopleInner({
    required this.faceCount,
    required this.id,
    required this.name,
    required this.thumbnailFaceId,
  });

  num faceCount;

  String id;

  String name;

  String? thumbnailFaceId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FaceRepairOwnerPeopleResponseDtoPeopleInner &&
    other.faceCount == faceCount &&
    other.id == id &&
    other.name == name &&
    other.thumbnailFaceId == thumbnailFaceId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (faceCount.hashCode) +
    (id.hashCode) +
    (name.hashCode) +
    (thumbnailFaceId == null ? 0 : thumbnailFaceId!.hashCode);

  @override
  String toString() => 'FaceRepairOwnerPeopleResponseDtoPeopleInner[faceCount=$faceCount, id=$id, name=$name, thumbnailFaceId=$thumbnailFaceId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'faceCount'] = this.faceCount;
      json[r'id'] = this.id;
      json[r'name'] = this.name;
    if (this.thumbnailFaceId != null) {
      json[r'thumbnailFaceId'] = this.thumbnailFaceId;
    } else {
      json[r'thumbnailFaceId'] = null;
    }
    return json;
  }

  /// Returns a new [FaceRepairOwnerPeopleResponseDtoPeopleInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FaceRepairOwnerPeopleResponseDtoPeopleInner? fromJson(dynamic value) {
    upgradeDto(value, "FaceRepairOwnerPeopleResponseDtoPeopleInner");
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return FaceRepairOwnerPeopleResponseDtoPeopleInner(
        faceCount: num.parse('${json[r'faceCount']}'),
        id: mapValueOfType<String>(json, r'id')!,
        name: mapValueOfType<String>(json, r'name')!,
        thumbnailFaceId: mapValueOfType<String>(json, r'thumbnailFaceId'),
      );
    }
    return null;
  }

  static List<FaceRepairOwnerPeopleResponseDtoPeopleInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FaceRepairOwnerPeopleResponseDtoPeopleInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FaceRepairOwnerPeopleResponseDtoPeopleInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FaceRepairOwnerPeopleResponseDtoPeopleInner> mapFromJson(dynamic json) {
    final map = <String, FaceRepairOwnerPeopleResponseDtoPeopleInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FaceRepairOwnerPeopleResponseDtoPeopleInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FaceRepairOwnerPeopleResponseDtoPeopleInner-objects as value to a dart map
  static Map<String, List<FaceRepairOwnerPeopleResponseDtoPeopleInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FaceRepairOwnerPeopleResponseDtoPeopleInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FaceRepairOwnerPeopleResponseDtoPeopleInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'faceCount',
    'id',
    'name',
    'thumbnailFaceId',
  };
}

