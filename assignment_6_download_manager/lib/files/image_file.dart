import 'downloadable_file.dart';

class ImageFile extends DownloadableFile {
  ImageFile(String name, double sizeMb) : super(name, sizeMb);

  @override
  String get category => "Image";

  @override
  bool verify() {
    final ok = name.endsWith(".png") || name.endsWith(".jpg") || name.endsWith(".jpeg");
    if (!ok) print("   Verification failed: $name is not an image.");
    return ok;
  }
}
