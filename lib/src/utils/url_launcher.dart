import 'package:url_launcher/url_launcher.dart';

class UrlLauncher {
  UrlLauncher._();

  static Future<void> openInternally(String url) async {
    final cleanedUri = _removeSpaces(url);
    if (await canLaunchUrl(cleanedUri)) {
      await launchUrl(cleanedUri, mode: LaunchMode.inAppWebView);
    }
  }

  static Future<void> openExternally(String url) async {
    final cleanedUri = _removeSpaces(url);
    if (await canLaunchUrl(cleanedUri)) {
      await launchUrl(cleanedUri, mode: LaunchMode.externalApplication);
    }
  }

  static Uri _removeSpaces(String url) {
    return Uri.parse(url.replaceAll(RegExp('\\s+'), ''));
  }
}
