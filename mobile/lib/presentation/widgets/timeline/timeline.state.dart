import 'dart:math' as math;

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immich_mobile/domain/models/timeline.model.dart';
import 'package:immich_mobile/presentation/widgets/timeline/constants.dart';
import 'package:immich_mobile/presentation/widgets/timeline/fixed/segment_builder.dart';
import 'package:immich_mobile/presentation/widgets/timeline/overview/overview_segment_builder.dart';
import 'package:immich_mobile/presentation/widgets/timeline/segment.model.dart';
import 'package:immich_mobile/providers/infrastructure/timeline.provider.dart';
import 'package:immich_mobile/providers/timeline/timeline_grouping.provider.dart';

class TimelineArgs {
  final double maxWidth;
  final double maxHeight;
  final double spacing;
  final int columnCount;
  final bool showStorageIndicator;
  final bool withStack;
  final GroupAssetsBy? groupBy;

  const TimelineArgs({
    required this.maxWidth,
    required this.maxHeight,
    this.spacing = kTimelineSpacing,
    this.columnCount = kTimelineColumnCount,
    this.showStorageIndicator = false,
    this.withStack = false,
    this.groupBy,
  });

  @override
  bool operator ==(covariant TimelineArgs other) {
    return spacing == other.spacing &&
        maxWidth == other.maxWidth &&
        maxHeight == other.maxHeight &&
        columnCount == other.columnCount &&
        showStorageIndicator == other.showStorageIndicator &&
        withStack == other.withStack &&
        groupBy == other.groupBy;
  }

  @override
  int get hashCode =>
      maxWidth.hashCode ^
      maxHeight.hashCode ^
      spacing.hashCode ^
      columnCount.hashCode ^
      showStorageIndicator.hashCode ^
      withStack.hashCode ^
      groupBy.hashCode;
}

class TimelineState {
  final bool isScrubbing;
  final bool isScrolling;

  const TimelineState({this.isScrubbing = false, this.isScrolling = false});

  bool get isInteracting => isScrubbing || isScrolling;

  @override
  bool operator ==(covariant TimelineState other) {
    return isScrubbing == other.isScrubbing && isScrolling == other.isScrolling;
  }

  @override
  int get hashCode => isScrubbing.hashCode ^ isScrolling.hashCode;

  TimelineState copyWith({bool? isScrubbing, bool? isScrolling}) {
    return TimelineState(isScrubbing: isScrubbing ?? this.isScrubbing, isScrolling: isScrolling ?? this.isScrolling);
  }
}

class TimelineStateNotifier extends Notifier<TimelineState> {
  void setScrubbing(bool isScrubbing) {
    state = state.copyWith(isScrubbing: isScrubbing);
  }

  void setScrolling(bool isScrolling) {
    state = state.copyWith(isScrolling: isScrolling);
  }

  @override
  TimelineState build() => const TimelineState(isScrubbing: false, isScrolling: false);
}

// This provider watches the buckets from the timeline service & args and serves the segments.
// It should be used only after the timeline service and timeline args provider is overridden
final timelineSegmentProvider = StreamProvider.autoDispose<List<Segment>>((ref) async* {
  // maxHeight is left out on purpose, a height-only change must not restart the bucket stream
  final (maxWidth, columnCount, spacing, groupByArg) = ref.watch(
    timelineArgsProvider.select((args) => (args.maxWidth, args.columnCount, args.spacing, args.groupBy)),
  );
  final availableTileWidth = maxWidth - (spacing * (columnCount - 1));
  final tileExtent = math.max(0, availableTileWidth) / columnCount;

  final GroupAssetsBy groupBy = groupByArg ?? ref.watch(timelineGroupingProvider);

  final timelineService = ref.watch(timelineServiceProvider);
  yield* timelineService.watchBuckets().map((buckets) {
    // A date-less bucket source (e.g. relevance-sorted search, or a `fromAssets` timeline) cannot
    // render the year/month overview — fall back to the flat grid regardless of the grouping setting.
    final isDateless = buckets.isNotEmpty && buckets.first is! TimeBucket;
    final effectiveGroupBy = isDateless ? GroupAssetsBy.day : groupBy;
    if (effectiveGroupBy == GroupAssetsBy.year || effectiveGroupBy == GroupAssetsBy.month) {
      return TimelineOverviewSegmentBuilder(buckets: buckets, groupBy: effectiveGroupBy).generate();
    }

    return FixedSegmentBuilder(
      buckets: buckets,
      tileHeight: tileExtent,
      columnCount: columnCount,
      spacing: spacing,
      groupBy: effectiveGroupBy,
    ).generate();
  });
  // timelineGroupingProvider must be listed so the auto-scoped copy of this provider
  // inside a TimelineRouteScope resolves the ROUTE-LOCAL grouping override; without it
  // the copy reads the root (persisted) grouping and detail routes silently render
  // the persisted grouping instead of their own.
}, dependencies: [timelineServiceProvider, timelineArgsProvider, timelineGroupingProvider]);

final timelineStateProvider = NotifierProvider<TimelineStateNotifier, TimelineState>(TimelineStateNotifier.new);
