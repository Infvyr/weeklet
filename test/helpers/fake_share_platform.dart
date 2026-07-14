import 'package:share_plus_platform_interface/share_plus_platform_interface.dart';

/// A settable [SharePlatform] fake that records `share()` calls instead of
/// hitting a real platform channel.
///
/// Extends [SharePlatform] directly (no `MockPlatformInterfaceMixin`) — the
/// default no-arg constructor already calls `super(token: _token)`, which
/// satisfies `PlatformInterface`'s token check.
class FakeSharePlatform extends SharePlatform {
  final List<ShareParams> shareCalls = [];

  @override
  Future<ShareResult> share(ShareParams params) async {
    shareCalls.add(params);
    return const ShareResult('', ShareResultStatus.dismissed);
  }
}
