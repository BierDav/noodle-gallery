//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FaceRepairScanTriggerResponseDto {
  /// Returns a new [FaceRepairScanTriggerResponseDto] instance.
  FaceRepairScanTriggerResponseDto({
    required this.scanId,
  });

  String scanId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FaceRepairScanTriggerResponseDto &&
    other.scanId == scanId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (scanId.hashCode);

  @override
  String toString() => 'FaceRepairScanTriggerResponseDto[scanId=$scanId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'scanId'] = this.scanId;
    return json;
  }

  /// Returns a new [FaceRepairScanTriggerResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FaceRepairScanTriggerResponseDto? fromJson(dynamic value) {
    upgradeDto(value, "FaceRepairScanTriggerResponseDto");
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return FaceRepairScanTriggerResponseDto(
        scanId: mapValueOfType<String>(json, r'scanId')!,
      );
    }
    return null;
  }

  static List<FaceRepairScanTriggerResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FaceRepairScanTriggerResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FaceRepairScanTriggerResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FaceRepairScanTriggerResponseDto> mapFromJson(dynamic json) {
    final map = <String, FaceRepairScanTriggerResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FaceRepairScanTriggerResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FaceRepairScanTriggerResponseDto-objects as value to a dart map
  static Map<String, List<FaceRepairScanTriggerResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FaceRepairScanTriggerResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FaceRepairScanTriggerResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'scanId',
  };
}

