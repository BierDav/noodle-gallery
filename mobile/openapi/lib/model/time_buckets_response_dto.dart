//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class TimeBucketsResponseDto {
  /// Returns a new [TimeBucketsResponseDto] instance.
  TimeBucketsResponseDto({
    required this.count,
    this.representativeAssetId = const Optional.absent(),
    this.representativeRatio = const Optional.absent(),
    this.representativeThumbhash = const Optional.absent(),
    required this.timeBucket,
  });

  /// Number of assets in this time bucket
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int count;

  /// Representative asset ID for this bucket
  Optional<String?> representativeAssetId;

  /// Representative asset width/height ratio
  Optional<num?> representativeRatio;

  /// Representative asset thumbhash, base64 encoded
  Optional<String?> representativeThumbhash;

  /// Time bucket identifier in YYYY-MM-DD format representing the start of the time period
  String timeBucket;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TimeBucketsResponseDto &&
    other.count == count &&
    other.representativeAssetId == representativeAssetId &&
    other.representativeRatio == representativeRatio &&
    other.representativeThumbhash == representativeThumbhash &&
    other.timeBucket == timeBucket;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (count.hashCode) +
    (representativeAssetId == null ? 0 : representativeAssetId!.hashCode) +
    (representativeRatio == null ? 0 : representativeRatio!.hashCode) +
    (representativeThumbhash == null ? 0 : representativeThumbhash!.hashCode) +
    (timeBucket.hashCode);

  @override
  String toString() => 'TimeBucketsResponseDto[count=$count, representativeAssetId=$representativeAssetId, representativeRatio=$representativeRatio, representativeThumbhash=$representativeThumbhash, timeBucket=$timeBucket]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'count'] = this.count;
    if (this.representativeAssetId.isPresent) {
      final value = this.representativeAssetId.value;
      json[r'representativeAssetId'] = value;
    }
    if (this.representativeRatio.isPresent) {
      final value = this.representativeRatio.value;
      json[r'representativeRatio'] = value;
    }
    if (this.representativeThumbhash.isPresent) {
      final value = this.representativeThumbhash.value;
      json[r'representativeThumbhash'] = value;
    }
      json[r'timeBucket'] = this.timeBucket;
    return json;
  }

  /// Returns a new [TimeBucketsResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static TimeBucketsResponseDto? fromJson(dynamic value) {
    upgradeDto(value, "TimeBucketsResponseDto");
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return TimeBucketsResponseDto(
        count: mapValueOfType<int>(json, r'count')!,
        representativeAssetId: json.containsKey(r'representativeAssetId') ? Optional.present(mapValueOfType<String>(json, r'representativeAssetId')) : const Optional.absent(),
        representativeRatio: json.containsKey(r'representativeRatio') ? Optional.present(json[r'representativeRatio'] == null ? null : num.parse('${json[r'representativeRatio']}')) : const Optional.absent(),
        representativeThumbhash: json.containsKey(r'representativeThumbhash') ? Optional.present(mapValueOfType<String>(json, r'representativeThumbhash')) : const Optional.absent(),
        timeBucket: mapValueOfType<String>(json, r'timeBucket')!,
      );
    }
    return null;
  }

  static List<TimeBucketsResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TimeBucketsResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TimeBucketsResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TimeBucketsResponseDto> mapFromJson(dynamic json) {
    final map = <String, TimeBucketsResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = TimeBucketsResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TimeBucketsResponseDto-objects as value to a dart map
  static Map<String, List<TimeBucketsResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TimeBucketsResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TimeBucketsResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'count',
    'timeBucket',
  };
}

