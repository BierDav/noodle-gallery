//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FaceRepairUnconfirmRequestDto {
  /// Returns a new [FaceRepairUnconfirmRequestDto] instance.
  FaceRepairUnconfirmRequestDto({
    this.assetFaceIds = const [],
  });

  List<String> assetFaceIds;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FaceRepairUnconfirmRequestDto &&
    _deepEquality.equals(other.assetFaceIds, assetFaceIds);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (assetFaceIds.hashCode);

  @override
  String toString() => 'FaceRepairUnconfirmRequestDto[assetFaceIds=$assetFaceIds]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'assetFaceIds'] = this.assetFaceIds;
    return json;
  }

  /// Returns a new [FaceRepairUnconfirmRequestDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FaceRepairUnconfirmRequestDto? fromJson(dynamic value) {
    upgradeDto(value, "FaceRepairUnconfirmRequestDto");
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return FaceRepairUnconfirmRequestDto(
        assetFaceIds: json[r'assetFaceIds'] is Iterable
            ? (json[r'assetFaceIds'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<FaceRepairUnconfirmRequestDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FaceRepairUnconfirmRequestDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FaceRepairUnconfirmRequestDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FaceRepairUnconfirmRequestDto> mapFromJson(dynamic json) {
    final map = <String, FaceRepairUnconfirmRequestDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FaceRepairUnconfirmRequestDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FaceRepairUnconfirmRequestDto-objects as value to a dart map
  static Map<String, List<FaceRepairUnconfirmRequestDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FaceRepairUnconfirmRequestDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FaceRepairUnconfirmRequestDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'assetFaceIds',
  };
}

