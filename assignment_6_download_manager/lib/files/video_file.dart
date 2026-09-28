import 'downloadable_file.dart';

class VideoFile extends DownloadableFile {
  VideoFile(String name, double sizeMb) : super(name, sizeMb);

  @override
  String get category => "Video";

  @override
  bool verify() {
    final ok = name.endsWith(".mp4") || name.endsWith(".mkv");
    if (!ok) print("   Verification failed: $name is not a video.");
    return ok;
  }
}
