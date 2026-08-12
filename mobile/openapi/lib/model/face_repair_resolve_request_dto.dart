//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FaceRepairResolveRequestDto {
  /// Returns a new [FaceRepairResolveRequestDto] instance.
  FaceRepairResolveRequestDto({
    this.detach = const Optional.present(const []),
    this.entireCluster = const Optional.absent(),
    this.lock = const Optional.present(const []),
    this.moveToPerson = const Optional.present(const []),
    required this.personId,
    this.stay = const Optional.present(const []),
    this.unknown = const Optional.present(const []),
  });

  Optional<List<String>?> detach;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Optional<FaceRepairResolveRequestDtoEntireCluster?> entireCluster;

  Optional<List<String>?> lock;

  Optional<List<FaceRepairResolveRequestDtoMoveToPersonInner>?> moveToPerson;

  String personId;

  Optional<List<String>?> stay;

  Optional<List<String>?> unknown;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FaceRepairResolveRequestDto &&
    _deepEquality.equals(other.detach, detach) &&
    other.entireCluster == entireCluster &&
    _deepEquality.equals(other.lock, lock) &&
    _deepEquality.equals(other.moveToPerson, moveToPerson) &&
    other.personId == personId &&
    _deepEquality.equals(other.stay, stay) &&
    _deepEquality.equals(other.unknown, unknown);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (detach.hashCode) +
    (entireCluster == null ? 0 : entireCluster!.hashCode) +
    (lock.hashCode) +
    (moveToPerson.hashCode) +
    (personId.hashCode) +
    (stay.hashCode) +
    (unknown.hashCode);

  @override
  String toString() => 'FaceRepairResolveRequestDto[detach=$detach, entireCluster=$entireCluster, lock=$lock, moveToPerson=$moveToPerson, personId=$personId, stay=$stay, unknown=$unknown]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.detach.isPresent) {
      final value = this.detach.value;
      json[r'detach'] = value;
    }
    if (this.entireCluster.isPresent) {
      final value = this.entireCluster.value;
      json[r'entireCluster'] = value;
    }
    if (this.lock.isPresent) {
      final value = this.lock.value;
      json[r'lock'] = value;
    }
    if (this.moveToPerson.isPresent) {
      final value = this.moveToPerson.value;
      json[r'moveToPerson'] = value;
    }
      json[r'personId'] = this.personId;
    if (this.stay.isPresent) {
      final value = this.stay.value;
      json[r'stay'] = value;
    }
    if (this.unknown.isPresent) {
      final value = this.unknown.value;
      json[r'unknown'] = value;
    }
    return json;
  }

  /// Returns a new [FaceRepairResolveRequestDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FaceRepairResolveRequestDto? fromJson(dynamic value) {
    upgradeDto(value, "FaceRepairResolveRequestDto");
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return FaceRepairResolveRequestDto(
        detach: json.containsKey(r'detach') ? Optional.present(json[r'detach'] is Iterable
            ? (json[r'detach'] as Iterable).cast<String>().toList(growable: false)
            : const []) : const Optional.absent(),
        entireCluster: json.containsKey(r'entireCluster') ? Optional.present(FaceRepairResolveRequestDtoEntireCluster.fromJson(json[r'entireCluster'])) : const Optional.absent(),
        lock: json.containsKey(r'lock') ? Optional.present(json[r'lock'] is Iterable
            ? (json[r'lock'] as Iterable).cast<String>().toList(growable: false)
            : const []) : const Optional.absent(),
        moveToPerson: json.containsKey(r'moveToPerson') ? Optional.present(FaceRepairResolveRequestDtoMoveToPersonInner.listFromJson(json[r'moveToPerson'])) : const Optional.absent(),
        personId: mapValueOfType<String>(json, r'personId')!,
        stay: json.containsKey(r'stay') ? Optional.present(json[r'stay'] is Iterable
            ? (json[r'stay'] as Iterable).cast<String>().toList(growable: false)
            : const []) : const Optional.absent(),
        unknown: json.containsKey(r'unknown') ? Optional.present(json[r'unknown'] is Iterable
            ? (json[r'unknown'] as Iterable).cast<String>().toList(growable: false)
            : const []) : const Optional.absent(),
      );
    }
    return null;
  }

  static List<FaceRepairResolveRequestDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FaceRepairResolveRequestDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FaceRepairResolveRequestDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FaceRepairResolveRequestDto> mapFromJson(dynamic json) {
    final map = <String, FaceRepairResolveRequestDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FaceRepairResolveRequestDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FaceRepairResolveRequestDto-objects as value to a dart map
  static Map<String, List<FaceRepairResolveRequestDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FaceRepairResolveRequestDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FaceRepairResolveRequestDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'personId',
  };
}

