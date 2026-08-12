//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FaceSuggestionActionResponseDto {
  /// Returns a new [FaceSuggestionActionResponseDto] instance.
  FaceSuggestionActionResponseDto({
    required this.acted,
  });

  /// Whether the call changed anything. False when the suggestion was already resolved.
  bool acted;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FaceSuggestionActionResponseDto &&
    other.acted == acted;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (acted.hashCode);

  @override
  String toString() => 'FaceSuggestionActionResponseDto[acted=$acted]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'acted'] = this.acted;
    return json;
  }

  /// Returns a new [FaceSuggestionActionResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FaceSuggestionActionResponseDto? fromJson(dynamic value) {
    upgradeDto(value, "FaceSuggestionActionResponseDto");
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return FaceSuggestionActionResponseDto(
        acted: mapValueOfType<bool>(json, r'acted')!,
      );
    }
    return null;
  }

  static List<FaceSuggestionActionResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FaceSuggestionActionResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FaceSuggestionActionResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FaceSuggestionActionResponseDto> mapFromJson(dynamic json) {
    final map = <String, FaceSuggestionActionResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FaceSuggestionActionResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FaceSuggestionActionResponseDto-objects as value to a dart map
  static Map<String, List<FaceSuggestionActionResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FaceSuggestionActionResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FaceSuggestionActionResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'acted',
  };
}

