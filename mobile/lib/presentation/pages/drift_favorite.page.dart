import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:immich_mobile/extensions/translate_extensions.dart';
import 'package:immich_mobile/presentation/widgets/bottom_sheet/favorite_bottom_sheet.widget.dart';
import 'package:immich_mobile/presentation/widgets/timeline/timeline.widget.dart';
import 'package:immich_mobile/presentation/widgets/timeline/timeline_grouping_header_sliver.widget.dart';
import 'package:immich_mobile/presentation/widgets/timeline/timeline_route_scope.dart';
import 'package:immich_mobile/providers/infrastructure/timeline.provider.dart';
import 'package:immich_mobile/providers/user.provider.dart';
import 'package:immich_mobile/widgets/common/mesmerizing_sliver_app_bar.dart';

@RoutePage()
class DriftFavoritePage extends StatelessWidget {
  const DriftFavoritePage({super.key});

  static const timelineOverviewControlsEnabled = true;
  static const timelineOverviewTopSliverHeight = kTimelineGroupingHeaderSliverHeight;

  @override
  Widget build(BuildContext context) {
    return TimelineRouteScope(
      timelineServiceBuilder: (ref, scope) {
        final user = ref.watch(currentUserProvider);
        if (user == null) {
          throw Exception('User must be logged in to access favorite');
        }

        return ref.watch(timelineFactoryProvider).favorite(user.id, temporalScope: scope);
      },
      child: Timeline(
        topSliverWidget: const TimelineGroupingHeaderSliver(),
        topSliverWidgetHeight: DriftFavoritePage.timelineOverviewTopSliverHeight,
        appBar: MesmerizingSliverAppBar(
          title: 'favorites'.t(context: context),
          icon: Icons.favorite_outline,
        ),
        bottomSheet: const FavoriteBottomSheet(),
      ),
    );
  }
}
