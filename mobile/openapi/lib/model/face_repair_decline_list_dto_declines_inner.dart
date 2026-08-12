//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FaceRepairDeclineListDtoDeclinesInner {
  /// Returns a new [FaceRepairDeclineListDtoDeclinesInner] instance.
  FaceRepairDeclineListDtoDeclinesInner({
    required this.assetFaceId,
    required this.createdAt,
    required this.id,
    required this.personId,
    required this.personName,
    required this.personThumbnailFaceId,
    required this.suspectedOwnerId,
    required this.suspectedOwnerName,
    required this.suspectedOwnerThumbnailFaceId,
    required this.type,
  });

  String? assetFaceId;

  DateTime createdAt;

  String id;

  String? personId;

  String? personName;

  String? personThumbnailFaceId;

  String? suspectedOwnerId;

  String? suspectedOwnerName;

  String? suspectedOwnerThumbnailFaceId;

  String type;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FaceRepairDeclineListDtoDeclinesInner &&
    other.assetFaceId == assetFaceId &&
    other.createdAt == createdAt &&
    other.id == id &&
    other.personId == personId &&
    other.personName == personName &&
    other.personThumbnailFaceId == personThumbnailFaceId &&
    other.suspectedOwnerId == suspectedOwnerId &&
    other.suspectedOwnerName == suspectedOwnerName &&
    other.suspectedOwnerThumbnailFaceId == suspectedOwnerThumbnailFaceId &&
    other.type == type;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (assetFaceId == null ? 0 : assetFaceId!.hashCode) +
    (createdAt.hashCode) +
    (id.hashCode) +
    (personId == null ? 0 : personId!.hashCode) +
    (personName == null ? 0 : personName!.hashCode) +
    (personThumbnailFaceId == null ? 0 : personThumbnailFaceId!.hashCode) +
    (suspectedOwnerId == null ? 0 : suspectedOwnerId!.hashCode) +
    (suspectedOwnerName == null ? 0 : suspectedOwnerName!.hashCode) +
    (suspectedOwnerThumbnailFaceId == null ? 0 : suspectedOwnerThumbnailFaceId!.hashCode) +
    (type.hashCode);

  @override
  String toString() => 'FaceRepairDeclineListDtoDeclinesInner[assetFaceId=$assetFaceId, createdAt=$createdAt, id=$id, personId=$personId, personName=$personName, personThumbnailFaceId=$personThumbnailFaceId, suspectedOwnerId=$suspectedOwnerId, suspectedOwnerName=$suspectedOwnerName, suspectedOwnerThumbnailFaceId=$suspectedOwnerThumbnailFaceId, type=$type]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.assetFaceId != null) {
      json[r'assetFaceId'] = this.assetFaceId;
    } else {
      json[r'assetFaceId'] = null;
    }
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
    if (this.suspectedOwnerId != null) {
      json[r'suspectedOwnerId'] = this.suspectedOwnerId;
    } else {
      json[r'suspectedOwnerId'] = null;
    }
    if (this.suspectedOwnerName != null) {
      json[r'suspectedOwnerName'] = this.suspectedOwnerName;
    } else {
      json[r'suspectedOwnerName'] = null;
    }
    if (this.suspectedOwnerThumbnailFaceId != null) {
      json[r'suspectedOwnerThumbnailFaceId'] = this.suspectedOwnerThumbnailFaceId;
    } else {
      json[r'suspectedOwnerThumbnailFaceId'] = null;
    }
      json[r'type'] = this.type;
    return json;
  }

  /// Returns a new [FaceRepairDeclineListDtoDeclinesInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FaceRepairDeclineListDtoDeclinesInner? fromJson(dynamic value) {
    upgradeDto(value, "FaceRepairDeclineListDtoDeclinesInner");
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return FaceRepairDeclineListDtoDeclinesInner(
        assetFaceId: mapValueOfType<String>(json, r'assetFaceId'),
        createdAt: mapDateTime(json, r'createdAt', r'')!,
        id: mapValueOfType<String>(json, r'id')!,
        personId: mapValueOfType<String>(json, r'personId'),
        personName: mapValueOfType<String>(json, r'personName'),
        personThumbnailFaceId: mapValueOfType<String>(json, r'personThumbnailFaceId'),
        suspectedOwnerId: mapValueOfType<String>(json, r'suspectedOwnerId'),
        suspectedOwnerName: mapValueOfType<String>(json, r'suspectedOwnerName'),
        suspectedOwnerThumbnailFaceId: mapValueOfType<String>(json, r'suspectedOwnerThumbnailFaceId'),
        type: mapValueOfType<String>(json, r'type')!,
      );
    }
    return null;
  }

  static List<FaceRepairDeclineListDtoDeclinesInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FaceRepairDeclineListDtoDeclinesInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FaceRepairDeclineListDtoDeclinesInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FaceRepairDeclineListDtoDeclinesInner> mapFromJson(dynamic json) {
    final map = <String, FaceRepairDeclineListDtoDeclinesInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FaceRepairDeclineListDtoDeclinesInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FaceRepairDeclineListDtoDeclinesInner-objects as value to a dart map
  static Map<String, List<FaceRepairDeclineListDtoDeclinesInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FaceRepairDeclineListDtoDeclinesInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FaceRepairDeclineListDtoDeclinesInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'assetFaceId',
    'createdAt',
    'id',
    'personId',
    'personName',
    'personThumbnailFaceId',
    'suspectedOwnerId',
    'suspectedOwnerName',
    'suspectedOwnerThumbnailFaceId',
    'type',
  };
}

