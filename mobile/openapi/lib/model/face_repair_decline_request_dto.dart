//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FaceRepairDeclineRequestDto {
  /// Returns a new [FaceRepairDeclineRequestDto] instance.
  FaceRepairDeclineRequestDto({
    this.faces = const Optional.present(const []),
    this.persons = const Optional.present(const []),
  });

  Optional<List<FaceRepairDeclineRemoveRequestDtoFacesInner>?> faces;

  Optional<List<FaceRepairDeclineRequestDtoPersonsInner>?> persons;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FaceRepairDeclineRequestDto &&
    _deepEquality.equals(other.faces, faces) &&
    _deepEquality.equals(other.persons, persons);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (faces.hashCode) +
    (persons.hashCode);

  @override
  String toString() => 'FaceRepairDeclineRequestDto[faces=$faces, persons=$persons]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.faces.isPresent) {
      final value = this.faces.value;
      json[r'faces'] = value;
    }
    if (this.persons.isPresent) {
      final value = this.persons.value;
      json[r'persons'] = value;
    }
    return json;
  }

  /// Returns a new [FaceRepairDeclineRequestDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FaceRepairDeclineRequestDto? fromJson(dynamic value) {
    upgradeDto(value, "FaceRepairDeclineRequestDto");
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return FaceRepairDeclineRequestDto(
        faces: json.containsKey(r'faces') ? Optional.present(FaceRepairDeclineRemoveRequestDtoFacesInner.listFromJson(json[r'faces'])) : const Optional.absent(),
        persons: json.containsKey(r'persons') ? Optional.present(FaceRepairDeclineRequestDtoPersonsInner.listFromJson(json[r'persons'])) : const Optional.absent(),
      );
    }
    return null;
  }

  static List<FaceRepairDeclineRequestDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FaceRepairDeclineRequestDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FaceRepairDeclineRequestDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FaceRepairDeclineRequestDto> mapFromJson(dynamic json) {
    final map = <String, FaceRepairDeclineRequestDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FaceRepairDeclineRequestDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FaceRepairDeclineRequestDto-objects as value to a dart map
  static Map<String, List<FaceRepairDeclineRequestDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FaceRepairDeclineRequestDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FaceRepairDeclineRequestDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

