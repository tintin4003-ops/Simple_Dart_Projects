import '../files/downloadable_file.dart';
import '../sources/download_source.dart';
import 'download_status.dart';
import 'download_task.dart';

class DownloadManager {
  final List<DownloadTask> _tasks = [];
  int _nextId = 1;

  /// The manager accepts ANY source; it is never bound to a specific one.
  DownloadTask addTask(DownloadableFile file, DownloadSource source,
      {int maxRetries = 2}) {
    final task = DownloadTask(_nextId++, file, source, maxRetries: maxRetries);
    _tasks.add(task);
    print("Queued task #${task.id}: ${file.name} via ${source.name}");
    return task;
  }

  /// Sequential: one after another.
  Future<void> startAll() async {
    for (final task in _tasks) {
      if (task.status == DownloadStatus.pending) {
        await task.start();
        print("");
      }
    }
  }

  /// Concurrent: all pending downloads at the same time.
  Future<void> startAllConcurrently() async {
    final pending = _tasks
        .where((t) => t.status == DownloadStatus.pending)
        .map((t) => t.start())
        .toList();
    await Future.wait(pending);
  }

  Future<void> retryFailed() async {
    final failed = _tasks.where((t) => t.status == DownloadStatus.failed).toList();
    if (failed.isEmpty) {
      print("Nothing to retry.");
      return;
    }
    for (final task in failed) {
      print("Manual retry of task #${task.id} ...");
      await task.start();
      print("");
    }
  }

  void showStatus() {
    if (_tasks.isEmpty) {
      print("No download tasks.");
      return;
    }
    print("--- Download status ---");
    for (final task in _tasks) {
      task.displayInfo();
    }
    final done = _tasks.where((t) => t.status == DownloadStatus.completed).length;
    print("Completed $done of ${_tasks.length}.");
  }
}
