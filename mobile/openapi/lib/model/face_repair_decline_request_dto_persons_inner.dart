//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FaceRepairDeclineRequestDtoPersonsInner {
  /// Returns a new [FaceRepairDeclineRequestDtoPersonsInner] instance.
  FaceRepairDeclineRequestDtoPersonsInner({
    required this.personId,
    this.suspectedOwnerIds = const [],
  });

  String personId;

  List<String> suspectedOwnerIds;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FaceRepairDeclineRequestDtoPersonsInner &&
    other.personId == personId &&
    _deepEquality.equals(other.suspectedOwnerIds, suspectedOwnerIds);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (personId.hashCode) +
    (suspectedOwnerIds.hashCode);

  @override
  String toString() => 'FaceRepairDeclineRequestDtoPersonsInner[personId=$personId, suspectedOwnerIds=$suspectedOwnerIds]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'personId'] = this.personId;
      json[r'suspectedOwnerIds'] = this.suspectedOwnerIds;
    return json;
  }

  /// Returns a new [FaceRepairDeclineRequestDtoPersonsInner] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FaceRepairDeclineRequestDtoPersonsInner? fromJson(dynamic value) {
    upgradeDto(value, "FaceRepairDeclineRequestDtoPersonsInner");
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return FaceRepairDeclineRequestDtoPersonsInner(
        personId: mapValueOfType<String>(json, r'personId')!,
        suspectedOwnerIds: json[r'suspectedOwnerIds'] is Iterable
            ? (json[r'suspectedOwnerIds'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<FaceRepairDeclineRequestDtoPersonsInner> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FaceRepairDeclineRequestDtoPersonsInner>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FaceRepairDeclineRequestDtoPersonsInner.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FaceRepairDeclineRequestDtoPersonsInner> mapFromJson(dynamic json) {
    final map = <String, FaceRepairDeclineRequestDtoPersonsInner>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FaceRepairDeclineRequestDtoPersonsInner.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FaceRepairDeclineRequestDtoPersonsInner-objects as value to a dart map
  static Map<String, List<FaceRepairDeclineRequestDtoPersonsInner>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FaceRepairDeclineRequestDtoPersonsInner>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FaceRepairDeclineRequestDtoPersonsInner.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'personId',
    'suspectedOwnerIds',
  };
}

