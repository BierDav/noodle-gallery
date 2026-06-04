import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immich_mobile/providers/api.provider.dart';
import 'package:immich_mobile/providers/app_life_cycle.provider.dart';
import 'package:immich_mobile/services/api.service.dart';
import 'package:mocktail/mocktail.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  late MockApiService apiService;
  late ProviderContainer container;
  late AppLifeCycleNotifier sut;

  setUp(() {
    apiService = MockApiService();
    when(() => apiService.refreshConnection()).thenAnswer((_) async {});
    container = ProviderContainer(overrides: [apiServiceProvider.overrideWithValue(apiService)]);
    sut = container.read(appStateProvider.notifier);
  });

  tearDown(() {
    container.dispose();
    debugDefaultTargetPlatformOverride = null;
  });

  test('refreshes the connection on iOS resume after a pause', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    await sut.refreshConnectionAfterResume(true);

    verify(() => apiService.refreshConnection()).called(1);
  });

  test('does not refresh when the app was not paused', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    await sut.refreshConnectionAfterResume(false);

    verifyNever(() => apiService.refreshConnection());
  });

  test('does not refresh on Android', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;

    await sut.refreshConnectionAfterResume(true);

    verifyNever(() => apiService.refreshConnection());
  });

  test('swallows refresh errors so resume can continue', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    when(() => apiService.refreshConnection()).thenThrow(Exception('boom'));

    await expectLater(sut.refreshConnectionAfterResume(true), completes);
    verify(() => apiService.refreshConnection()).called(1);
  });
}
