//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FaceRepairDeclineListDto {
  /// Returns a new [FaceRepairDeclineListDto] instance.
  FaceRepairDeclineListDto({
    this.declines = const [],
  });

  List<FaceRepairDeclineListDtoDeclinesInner> declines;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FaceRepairDeclineListDto &&
    _deepEquality.equals(other.declines, declines);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (declines.hashCode);

  @override
  String toString() => 'FaceRepairDeclineListDto[declines=$declines]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'declines'] = this.declines;
    return json;
  }

  /// Returns a new [FaceRepairDeclineListDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FaceRepairDeclineListDto? fromJson(dynamic value) {
    upgradeDto(value, "FaceRepairDeclineListDto");
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return FaceRepairDeclineListDto(
        declines: FaceRepairDeclineListDtoDeclinesInner.listFromJson(json[r'declines']),
      );
    }
    return null;
  }

  static List<FaceRepairDeclineListDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FaceRepairDeclineListDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FaceRepairDeclineListDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FaceRepairDeclineListDto> mapFromJson(dynamic json) {
    final map = <String, FaceRepairDeclineListDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FaceRepairDeclineListDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FaceRepairDeclineListDto-objects as value to a dart map
  static Map<String, List<FaceRepairDeclineListDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FaceRepairDeclineListDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FaceRepairDeclineListDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'declines',
  };
}

