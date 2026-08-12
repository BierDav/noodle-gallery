//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FaceRepairResolveResponseDto {
  /// Returns a new [FaceRepairResolveResponseDto] instance.
  FaceRepairResolveResponseDto({
    required this.declined,
    required this.detached,
    required this.locked,
    required this.moved,
    required this.skipped,
    required this.unknown,
  });

  num declined;

  num detached;

  num locked;

  num moved;

  num skipped;

  num unknown;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FaceRepairResolveResponseDto &&
    other.declined == declined &&
    other.detached == detached &&
    other.locked == locked &&
    other.moved == moved &&
    other.skipped == skipped &&
    other.unknown == unknown;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (declined.hashCode) +
    (detached.hashCode) +
    (locked.hashCode) +
    (moved.hashCode) +
    (skipped.hashCode) +
    (unknown.hashCode);

  @override
  String toString() => 'FaceRepairResolveResponseDto[declined=$declined, detached=$detached, locked=$locked, moved=$moved, skipped=$skipped, unknown=$unknown]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'declined'] = this.declined;
      json[r'detached'] = this.detached;
      json[r'locked'] = this.locked;
      json[r'moved'] = this.moved;
      json[r'skipped'] = this.skipped;
      json[r'unknown'] = this.unknown;
    return json;
  }

  /// Returns a new [FaceRepairResolveResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FaceRepairResolveResponseDto? fromJson(dynamic value) {
    upgradeDto(value, "FaceRepairResolveResponseDto");
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return FaceRepairResolveResponseDto(
        declined: num.parse('${json[r'declined']}'),
        detached: num.parse('${json[r'detached']}'),
        locked: num.parse('${json[r'locked']}'),
        moved: num.parse('${json[r'moved']}'),
        skipped: num.parse('${json[r'skipped']}'),
        unknown: num.parse('${json[r'unknown']}'),
      );
    }
    return null;
  }

  static List<FaceRepairResolveResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FaceRepairResolveResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FaceRepairResolveResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FaceRepairResolveResponseDto> mapFromJson(dynamic json) {
    final map = <String, FaceRepairResolveResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FaceRepairResolveResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FaceRepairResolveResponseDto-objects as value to a dart map
  static Map<String, List<FaceRepairResolveResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FaceRepairResolveResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FaceRepairResolveResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'declined',
    'detached',
    'locked',
    'moved',
    'skipped',
    'unknown',
  };
}

