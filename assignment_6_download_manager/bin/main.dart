import '../lib/console/input.dart';
import '../lib/files/document_file.dart';
import '../lib/files/downloadable_file.dart';
import '../lib/files/image_file.dart';
import '../lib/files/video_file.dart';
import '../lib/services/download_manager.dart';
import '../lib/sources/cloud_download.dart';
import '../lib/sources/download_source.dart';
import '../lib/sources/local_network_download.dart';
import '../lib/sources/server_download.dart';

Future<void> main() async {
  print("=== Smart File Download Manager ===");
  final manager = DownloadManager();

  final fileTypes = <MenuOption<DownloadableFile Function(String, double)>>[
    MenuOption("Document (.pdf .docx .txt)", DocumentFile.new),
    MenuOption("Image (.png .jpg .jpeg)", ImageFile.new),
    MenuOption("Video (.mp4 .mkv)", VideoFile.new),
  ];

  // Each source asks for what it needs. GoogleDriveDownload / DropboxDownload
  // later = one more entry here + its class.
  final sourceOptions = <MenuOption<DownloadSource Function()>>[
    MenuOption("Server download", () {
      final host = Input.text("Server host (e.g. files.company.com)");
      final seed = DateTime.now().millisecondsSinceEpoch % 100000;
      return ServerDownload(host, seed: seed);
    }),
    MenuOption("Cloud download", () {
      final provider = Input.text("Cloud provider");
      final token = Input.optional("Access token (leave empty to see a failure)");
      final seed = DateTime.now().millisecondsSinceEpoch % 100000;
      return CloudDownload(provider, token, seed: seed);
    }),
    MenuOption("Local network download", () {
      final machine = Input.text("Machine name on the network");
      return LocalNetworkDownload(machine);
    }),
  ];

  await Input.runMenu("Download Manager Menu", [
    MenuAction("Add a download", () async {
      final createFile = Input.pick("File type", fileTypes);
      final name = Input.text("File name with extension (e.g. notes.pdf)");
      final size = Input.number("File size (MB)", min: 0.1);
      final createSource = Input.pick("Download source", sourceOptions);
      final retries = Input.integer("Maximum automatic retries (0-5)", min: 0, max: 5);
      manager.addTask(createFile(name, size), createSource(), maxRetries: retries);
    }),
    MenuAction("Start all pending downloads (one by one)", () async {
      await manager.startAll();
    }),
    MenuAction("Start all pending downloads (at the same time)", () async {
      await manager.startAllConcurrently();
    }),
    MenuAction("Retry failed downloads", () async {
      await manager.retryFailed();
    }),
    MenuAction("Show download status", () async => manager.showStatus()),
  ]);

  print("Goodbye!");
}
