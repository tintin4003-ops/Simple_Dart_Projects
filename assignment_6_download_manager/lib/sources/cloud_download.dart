import 'base_download_source.dart';

class CloudDownload extends BaseDownloadSource {
  final String provider;
  final String token;

  CloudDownload(this.provider, this.token, {int seed = 3}) : super(seed: seed);

  @override
  String get name => "Cloud ($provider)";

  @override
  double get speedMbPerTick => 12;

  @override
  double get failureRate => 0.1;

  @override
  Future<void> connect() async {
    print("   Authenticating with $provider ...");
    await Future.delayed(const Duration(milliseconds: 800));
    if (token.isEmpty) {
      throw Exception("$provider rejected an empty access token");
    }
  }
}
