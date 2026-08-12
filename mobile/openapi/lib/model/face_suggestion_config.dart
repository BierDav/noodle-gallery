//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FaceSuggestionConfig {
  /// Returns a new [FaceSuggestionConfig] instance.
  FaceSuggestionConfig({
    required this.enabled,
    required this.maxDistance,
  });

  /// Whether face suggestions are enabled
  bool enabled;

  /// Maximum embedding distance for a face to be surfaced as a suggestion on a named person
  ///
  /// Minimum value: 0.1
  /// Maximum value: 2
  double maxDistance;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FaceSuggestionConfig &&
    other.enabled == enabled &&
    other.maxDistance == maxDistance;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (enabled.hashCode) +
    (maxDistance.hashCode);

  @override
  String toString() => 'FaceSuggestionConfig[enabled=$enabled, maxDistance=$maxDistance]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'enabled'] = this.enabled;
      json[r'maxDistance'] = this.maxDistance;
    return json;
  }

  /// Returns a new [FaceSuggestionConfig] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FaceSuggestionConfig? fromJson(dynamic value) {
    upgradeDto(value, "FaceSuggestionConfig");
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return FaceSuggestionConfig(
        enabled: mapValueOfType<bool>(json, r'enabled')!,
        maxDistance: mapValueOfType<double>(json, r'maxDistance')!,
      );
    }
    return null;
  }

  static List<FaceSuggestionConfig> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FaceSuggestionConfig>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FaceSuggestionConfig.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FaceSuggestionConfig> mapFromJson(dynamic json) {
    final map = <String, FaceSuggestionConfig>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FaceSuggestionConfig.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FaceSuggestionConfig-objects as value to a dart map
  static Map<String, List<FaceSuggestionConfig>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FaceSuggestionConfig>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FaceSuggestionConfig.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'enabled',
    'maxDistance',
  };
}

