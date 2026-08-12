//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FaceRepairResolutionsListDtoResolutionsInner {
  /// Returns a new [FaceRepairResolutionsListDtoResolutionsInner] instance.
  FaceRepairResolutionsListDtoResolutionsInner({
    required this.actorId,
    required this.actorName,
    required this.assetFaceId,
    required this.createdAt,
    required this.id,
    required this.personId,
    required this.personName,
    required this.personThumbnailFaceId,
    required this.source_,
    required this.spaceName,
    required this.spacePersonId,
    required this.spacePersonName,
    required this.spacePersonThumbnailFaceId,
    required this.status,
  });

  String? actorId;

  String? actorName;

  String assetFaceId;

  DateTime createdAt;

  String id;

  String? personId;

  String? personName;

  String? personThumbnailFaceId;

  String source_;

  String? spaceName;

  String? spacePersonId;

  String? spacePersonName;

  String? spacePersonThumbnailFaceId;

  String status;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FaceRepairResolutionsListDtoResolutionsInner &&
    other.actorId == actorId &&
    other.actorName == actorName &&
    other.assetFaceId == assetFaceId &&
    other.createdAt == createdAt &&
    other.id == id &&
    other.personId == personId &&
    other.personName == personName &&
    other.personThumbnailFaceId == personThumbnailFaceId &&
    other.source_ == source_ &&
    other.spaceName == spaceName &&
    other.spacePersonId == spacePersonId &&
    other.spacePersonName == spacePersonName &&
    other.spacePersonThumbnailFaceId == spacePersonThumbnailFaceId &&
    other.status == status;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (actorId == null ? 0 : actorId!.hashCode) +
    (actorName == null ? 0 : actorName!.hashCode) +
    (assetFaceId.hashCode) +
    (createdAt.hashCode) +
    (id.hashCode) +
    (personId == null ? 0 : personId!.hashCode) +
    (personName == null ? 0 : personName!.hashCode) +
    (personThumbnailFaceId == null ? 0 : personThumbnailFaceId!.hashCode) +
    (source_.hashCode) +
    (spaceName == null ? 0 : spaceName!.hashCode) +
    (spacePersonId == null ? 0 : spacePersonId!.hashCode) +
    (spacePersonName == null ? 0 : spacePersonName!.hashCode) +
    (spacePersonThumbnailFaceId == null ? 0 : spacePersonThumbnailFaceId!.hashCode) +
    (status.hashCode);

  @override
  String toString() => 'FaceRepairResolutionsListDtoResolutionsInner[actorId=$actorId, actorName=$actorName, assetFaceId=$assetFaceId, createdAt=$createdAt, id=$id, personId=$personId, personName=$personName, personThumbnailFaceId=$personThumbnailFaceId, source_=$source_, spaceName=$spaceName, spacePersonId=$spacePersonId, spacePersonName=$spacePersonName, spacePersonThumbnailFaceId=$spacePersonThumbnailFaceId, status=$status]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.actorId != null) {
      json[r'actorId'] = this.actorId;
    } else {
      json[r'actorId'] = null;
    }
    if (this.actorName != null) {
      json[r'actorName'] = this.actorName;
    } else {
      json[r'actorName'] = null;
    }
      json[r'assetFaceId'] = this.assetFaceId;
      json[r'createdAt'] = this.createdAt.toUtc().toIso8601String();
      json[r'id'] = this.id;
    if (this.personId != null) {
      json[r'personId'] = this.personId;
    } else {
      json[r'personId'] = null;
    }
    if (this.personName != null) {
      json[r'personName'] = this.personName;
    } else {
      json[r'personName'] = null;
    }
    if (this.personThumbnailFaceId != null) {
      json[r'personThumbnailFaceId'] = this.personThumbnailFaceId;
    } else {
      json[r'personThumbnailFaceId'] = null;
    }
      json[r'source'] = this.source_;
    if (this.spaceName != null) {
      json[r'spaceName'] = this.spaceName;
    } else {
      json[r'spaceName'] = null;
    }
    if (this.spacePersonId != null) {
      json[r'spacePersonId'] = this.spacePersonId;
    } else {
      json[r'spacePersonId'] = null;
    }
    if (this.spacePersonName != null) {
      json[r'spacePersonName'] = this.spacePersonName;
    } else {
      json[r'spacePersonName'] = null;
    }
    if (this.spacePersonThumbnailFaceId != null) {
      json[r'spacePersonThumbnailFaceId'] = this.spacePersonThumbnailFaceId;
    } else {
      json[r'spacePersonThumbnailFaceId'] = null;
    }
      json[r'status'] = this.status;
    return json;
  }

  /// Returns a new [FaceRepairResolutionsListDtoResolutionsInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FaceRepairResolutionsListDtoResolutionsInner? fromJson(dynamic value) {
    upgradeDto(value, "FaceRepairResolutionsListDtoResolutionsInner");
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return FaceRepairResolutionsListDtoResolutionsInner(
        actorId: mapValueOfType<String>(json, r'actorId'),
        actorName: mapValueOfType<String>(json, r'actorName'),
        assetFaceId: mapValueOfType<String>(json, r'assetFaceId')!,
        createdAt: mapDateTime(json, r'createdAt', r'')!,
        id: mapValueOfType<String>(json, r'id')!,
        personId: mapValueOfType<String>(json, r'personId'),
        personName: mapValueOfType<String>(json, r'personName'),
        personThumbnailFaceId: mapValueOfType<String>(json, r'personThumbnailFaceId'),
        source_: mapValueOfType<String>(json, r'source')!,
        spaceName: mapValueOfType<String>(json, r'spaceName'),
        spacePersonId: mapValueOfType<String>(json, r'spacePersonId'),
        spacePersonName: mapValueOfType<String>(json, r'spacePersonName'),
        spacePersonThumbnailFaceId: mapValueOfType<String>(json, r'spacePersonThumbnailFaceId'),
        status: mapValueOfType<String>(json, r'status')!,
      );
    }
    return null;
  }

  static List<FaceRepairResolutionsListDtoResolutionsInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FaceRepairResolutionsListDtoResolutionsInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FaceRepairResolutionsListDtoResolutionsInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FaceRepairResolutionsListDtoResolutionsInner> mapFromJson(dynamic json) {
    final map = <String, FaceRepairResolutionsListDtoResolutionsInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FaceRepairResolutionsListDtoResolutionsInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FaceRepairResolutionsListDtoResolutionsInner-objects as value to a dart map
  static Map<String, List<FaceRepairResolutionsListDtoResolutionsInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FaceRepairResolutionsListDtoResolutionsInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FaceRepairResolutionsListDtoResolutionsInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'actorId',
    'actorName',
    'assetFaceId',
    'createdAt',
    'id',
    'personId',
    'personName',
    'personThumbnailFaceId',
    'source',
    'spaceName',
    'spacePersonId',
    'spacePersonName',
    'spacePersonThumbnailFaceId',
    'status',
  };
}

