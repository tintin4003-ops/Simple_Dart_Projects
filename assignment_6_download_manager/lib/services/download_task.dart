import '../files/downloadable_file.dart';
import '../sources/download_source.dart';
import 'download_status.dart';

/// The task owns the STATUS, the progress and the retry policy.
/// Neither the file nor the source has to care about them.
class DownloadTask {
  final int id;
  final DownloadableFile file;
  final DownloadSource source;
  final int maxRetries;

  DownloadStatus status = DownloadStatus.pending;
  int progress = 0;
  int attempts = 0;
  String? error;

  DownloadTask(this.id, this.file, this.source, {this.maxRetries = 2});

  Future<void> start() async {
    for (attempts = 1; attempts <= maxRetries + 1; attempts++) {
      status = DownloadStatus.downloading;
      progress = 0;
      error = null;

      print("Task #$id: downloading ${file.name} from ${source.name} "
          "(attempt $attempts)");

      try {
        await source.download(file, (percent) {
          progress = percent;
          print("   ${file.name}: $percent%");
        });

        if (!file.verify()) {
          status = DownloadStatus.failed;
          error = "verification failed";
          return;
        }

        status = DownloadStatus.completed;
        print("Task #$id: ${file.name} completed.");
        return;
      } catch (e) {
        error = e.toString();
        status = DownloadStatus.failed;
        print("Task #$id failed: $error");
        if (attempts <= maxRetries) {
          print("   Retrying in 1 second ...");
          await Future.delayed(const Duration(seconds: 1));
        }
      }
    }
    print("Task #$id gave up after ${maxRetries + 1} attempts.");
  }

  void displayInfo() {
    final label = status.name.toUpperCase();
    final line = StringBuffer();
    line.write("Task #$id | ${file.category} ${file.name} | ${source.name} | ");
    line.write("$label ($progress%)");
    if (status == DownloadStatus.failed && error != null) {
      line.write(" | $error");
    }
    print(line.toString());
  }
}
