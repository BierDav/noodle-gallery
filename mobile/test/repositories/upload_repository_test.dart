import 'dart:async';
import 'dart:convert';

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:immich_mobile/constants/constants.dart';
import 'package:immich_mobile/repositories/upload.repository.dart';

import '../test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  TestUtils.init();

  group('UploadRepository', () {
    test('can disable and restore the background downloader holding queue', () async {
      final configurations = <List<(String, dynamic)>>[];
      final repository = UploadRepository.forTesting(
        backgroundDownloaderMethodInvoker: (_, _) => Future<void>.value(),
        backgroundDownloaderConfigurator: (globalConfig) async {
          configurations.add(globalConfig);
        },
      );

      await repository.disableHoldingQueue();
      await repository.restoreDefaultHoldingQueue();

      expect(configurations, [
        [(Config.holdingQueue, Config.never)],
        [(Config.holdingQueue, (6, 6, 3))],
      ]);
    });

    test('updateNotification posts the backup group notification without waiting for the native reply', () async {
      final calls = <({String method, Object? arguments})>[];
      final nativeReply = Completer<void>();

      final repository = UploadRepository.forTesting(
        backgroundDownloaderMethodInvoker: (method, arguments) {
          calls.add((method: method, arguments: arguments));
          return nativeReply.future;
        },
      );
      final task = UploadTask(
        taskId: 'asset-1',
        url: 'http://test-server.com/assets',
        filename: 'asset.jpg',
        baseDirectory: BaseDirectory.temporary,
        group: kBackupLivePhotoGroup,
      );

      final returned = repository.updateNotification(task, TaskStatus.enqueued);

      try {
        await returned.timeout(const Duration(milliseconds: 100));
      } finally {
        if (!nativeReply.isCompleted) {
          nativeReply.complete();
        }
      }
      await Future<void>.delayed(Duration.zero);

      expect(calls, hasLength(1));
      expect(calls.single.method, 'updateNotification');

      final args = calls.single.arguments as List<Object?>;
      expect(jsonDecode(args[0]! as String)['taskId'], 'asset-1');
      final notificationConfigJson = jsonDecode(args[1]! as String) as Map<String, dynamic>;
      expect(notificationConfigJson['groupNotificationId'], kBackupGroup);
      expect(notificationConfigJson['running'], {
        'title': 'uploading_media',
        'body': 'backup_background_service_in_progress_notification',
      });
      expect(notificationConfigJson['complete'], {
        'title': 'upload_finished',
        'body': 'backup_background_service_complete_notification',
      });
      expect(notificationConfigJson['error'], {
        'title': 'backup_background_service_error_title',
        'body': 'backup_background_service_backup_failed_message',
      });
      expect(args[2], TaskStatus.enqueued.index);
    });

    test('updateNotification consumes asynchronous native failures', () async {
      final repository = UploadRepository.forTesting(
        backgroundDownloaderMethodInvoker: (_, _) => Future<void>.error(Exception('notification unavailable')),
      );
      final task = UploadTask(
        taskId: 'asset-1',
        url: 'http://test-server.com/assets',
        filename: 'asset.jpg',
        baseDirectory: BaseDirectory.temporary,
        group: kBackupGroup,
      );

      await repository.updateNotification(task, TaskStatus.enqueued);
      await Future<void>.delayed(Duration.zero);
    });
  });
}
