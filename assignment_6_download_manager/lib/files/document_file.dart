import 'downloadable_file.dart';

class DocumentFile extends DownloadableFile {
  DocumentFile(String name, double sizeMb) : super(name, sizeMb);

  @override
  String get category => "Document";

  @override
  bool verify() {
    final ok = name.endsWith(".pdf") || name.endsWith(".docx") || name.endsWith(".txt");
    if (!ok) print("   Verification failed: $name is not a document.");
    return ok;
  }
}
