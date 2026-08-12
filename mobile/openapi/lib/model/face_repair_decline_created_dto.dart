//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FaceRepairDeclineCreatedDto {
  /// Returns a new [FaceRepairDeclineCreatedDto] instance.
  FaceRepairDeclineCreatedDto({
    required this.created,
  });

  num created;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FaceRepairDeclineCreatedDto &&
    other.created == created;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (created.hashCode);

  @override
  String toString() => 'FaceRepairDeclineCreatedDto[created=$created]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'created'] = this.created;
    return json;
  }

  /// Returns a new [FaceRepairDeclineCreatedDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FaceRepairDeclineCreatedDto? fromJson(dynamic value) {
    upgradeDto(value, "FaceRepairDeclineCreatedDto");
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return FaceRepairDeclineCreatedDto(
        created: num.parse('${json[r'created']}'),
      );
    }
    return null;
  }

  static List<FaceRepairDeclineCreatedDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FaceRepairDeclineCreatedDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FaceRepairDeclineCreatedDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FaceRepairDeclineCreatedDto> mapFromJson(dynamic json) {
    final map = <String, FaceRepairDeclineCreatedDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FaceRepairDeclineCreatedDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FaceRepairDeclineCreatedDto-objects as value to a dart map
  static Map<String, List<FaceRepairDeclineCreatedDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FaceRepairDeclineCreatedDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FaceRepairDeclineCreatedDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'created',
  };
}

