import 'dart:math';

import '../files/downloadable_file.dart';
import 'download_source.dart';

/// Shared transfer loop so every source only describes what makes it
/// different: its speed, its handshake and how often it drops.
abstract class BaseDownloadSource implements DownloadSource {
  final Random _random;

  BaseDownloadSource({int seed = 7}) : _random = Random(seed);

  /// 0.0 = never fails, 1.0 = always fails.
  double get failureRate;

  /// Connection / authentication step before any byte moves.
  Future<void> connect();

  @override
  Future<void> download(
    DownloadableFile file,
    void Function(int percent) onProgress,
  ) async {
    await connect();

    var transferred = 0.0;
    while (transferred < file.sizeMb) {
      await Future.delayed(const Duration(milliseconds: 300));

      if (_random.nextDouble() < failureRate) {
        throw Exception("$name lost the connection at "
            "${((transferred / file.sizeMb) * 100).round()}%");
      }

      transferred += speedMbPerTick;
      if (transferred > file.sizeMb) transferred = file.sizeMb;
      onProgress(((transferred / file.sizeMb) * 100).round());
    }
  }
}
