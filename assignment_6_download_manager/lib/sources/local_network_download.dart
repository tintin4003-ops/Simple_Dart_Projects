import 'base_download_source.dart';

class LocalNetworkDownload extends BaseDownloadSource {
  final String machine;

  LocalNetworkDownload(this.machine) : super(seed: 1);

  @override
  String get name => "Local Network ($machine)";

  @override
  double get speedMbPerTick => 25;

  @override
  double get failureRate => 0.0;

  @override
  Future<void> connect() async {
    print("   Reaching $machine on the LAN ...");
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
