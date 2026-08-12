//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FaceRepairPersonFacesDto {
  /// Returns a new [FaceRepairPersonFacesDto] instance.
  FaceRepairPersonFacesDto({
    this.flaggedFaces = const [],
    required this.personId,
  });

  List<FaceRepairPersonFacesDtoFlaggedFacesInner> flaggedFaces;

  String personId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FaceRepairPersonFacesDto &&
    _deepEquality.equals(other.flaggedFaces, flaggedFaces) &&
    other.personId == personId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (flaggedFaces.hashCode) +
    (personId.hashCode);

  @override
  String toString() => 'FaceRepairPersonFacesDto[flaggedFaces=$flaggedFaces, personId=$personId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'flaggedFaces'] = this.flaggedFaces;
      json[r'personId'] = this.personId;
    return json;
  }

  /// Returns a new [FaceRepairPersonFacesDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FaceRepairPersonFacesDto? fromJson(dynamic value) {
    upgradeDto(value, "FaceRepairPersonFacesDto");
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return FaceRepairPersonFacesDto(
        flaggedFaces: FaceRepairPersonFacesDtoFlaggedFacesInner.listFromJson(json[r'flaggedFaces']),
        personId: mapValueOfType<String>(json, r'personId')!,
      );
    }
    return null;
  }

  static List<FaceRepairPersonFacesDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FaceRepairPersonFacesDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FaceRepairPersonFacesDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FaceRepairPersonFacesDto> mapFromJson(dynamic json) {
    final map = <String, FaceRepairPersonFacesDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FaceRepairPersonFacesDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FaceRepairPersonFacesDto-objects as value to a dart map
  static Map<String, List<FaceRepairPersonFacesDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FaceRepairPersonFacesDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FaceRepairPersonFacesDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'flaggedFaces',
    'personId',
  };
}

