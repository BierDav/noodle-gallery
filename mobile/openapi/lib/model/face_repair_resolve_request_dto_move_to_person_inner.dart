//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FaceRepairResolveRequestDtoMoveToPersonInner {
  /// Returns a new [FaceRepairResolveRequestDtoMoveToPersonInner] instance.
  FaceRepairResolveRequestDtoMoveToPersonInner({
    required this.destinationPersonId,
    this.faceIds = const [],
    this.lock = const Optional.present(false),
  });

  String destinationPersonId;

  List<String> faceIds;

  Optional<bool?> lock;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FaceRepairResolveRequestDtoMoveToPersonInner &&
    other.destinationPersonId == destinationPersonId &&
    _deepEquality.equals(other.faceIds, faceIds) &&
    other.lock == lock;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (destinationPersonId.hashCode) +
    (faceIds.hashCode) +
    (lock.hashCode);

  @override
  String toString() => 'FaceRepairResolveRequestDtoMoveToPersonInner[destinationPersonId=$destinationPersonId, faceIds=$faceIds, lock=$lock]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'destinationPersonId'] = this.destinationPersonId;
      json[r'faceIds'] = this.faceIds;
    if (this.lock.isPresent) {
      final value = this.lock.value;
      json[r'lock'] = value;
    }
    return json;
  }

  /// Returns a new [FaceRepairResolveRequestDtoMoveToPersonInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FaceRepairResolveRequestDtoMoveToPersonInner? fromJson(dynamic value) {
    upgradeDto(value, "FaceRepairResolveRequestDtoMoveToPersonInner");
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return FaceRepairResolveRequestDtoMoveToPersonInner(
        destinationPersonId: mapValueOfType<String>(json, r'destinationPersonId')!,
        faceIds: json[r'faceIds'] is Iterable
            ? (json[r'faceIds'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        lock: json.containsKey(r'lock') ? Optional.present(mapValueOfType<bool>(json, r'lock')) : const Optional.absent(),
      );
    }
    return null;
  }

  static List<FaceRepairResolveRequestDtoMoveToPersonInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FaceRepairResolveRequestDtoMoveToPersonInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FaceRepairResolveRequestDtoMoveToPersonInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FaceRepairResolveRequestDtoMoveToPersonInner> mapFromJson(dynamic json) {
    final map = <String, FaceRepairResolveRequestDtoMoveToPersonInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FaceRepairResolveRequestDtoMoveToPersonInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FaceRepairResolveRequestDtoMoveToPersonInner-objects as value to a dart map
  static Map<String, List<FaceRepairResolveRequestDtoMoveToPersonInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FaceRepairResolveRequestDtoMoveToPersonInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FaceRepairResolveRequestDtoMoveToPersonInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'destinationPersonId',
    'faceIds',
  };
}

