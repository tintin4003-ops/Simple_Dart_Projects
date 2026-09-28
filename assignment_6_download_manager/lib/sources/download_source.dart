import '../files/downloadable_file.dart';

/// The source performs the transfer. DownloadManager depends on this
/// contract only, so GoogleDriveDownload or DropboxDownload can be added
/// later without touching the manager.
abstract interface class DownloadSource {
  String get name;

  /// Megabytes transferred per tick. Used to simulate speed.
  double get speedMbPerTick;

  /// Throws when the transfer fails, so the task can decide to retry.
  Future<void> download(
    DownloadableFile file,
    void Function(int percent) onProgress,
  );
}
