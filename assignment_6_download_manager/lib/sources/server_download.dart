import 'base_download_source.dart';

class ServerDownload extends BaseDownloadSource {
  final String host;

  ServerDownload(this.host, {int seed = 7}) : super(seed: seed);

  @override
  String get name => "Server ($host)";

  @override
  double get speedMbPerTick => 8;

  @override
  double get failureRate => 0.25;

  @override
  Future<void> connect() async {
    print("   Connecting to $host ...");
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
