/// A file describes ITSELF. It does not know how to download itself,
/// because the transfer belongs to the download source.
abstract class DownloadableFile {
  final String name;
  final double sizeMb;

  DownloadableFile(this.name, this.sizeMb);

  String get category;

  /// Different file types need different post-download checks.
  bool verify();

  void displayInfo() {
    print("[$category] $name (${sizeMb.toStringAsFixed(1)} MB)");
  }
}
