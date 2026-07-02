import 'package:flower_driver/core/helpers/custom_logger.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class UrlLauncherHelper {
  static Future<void> callPhone(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        await launchUrl(launchUri);
      }
    } catch (e) {
      CustomLogger.bgRed("Could not launch phone: $e");
    }
  }

  static Future<void> launchWhatsApp(String phoneNumber) async {
    final String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    final String whatsappUrl = "https://wa.me/$cleanNumber";
    final Uri launchUri = Uri.parse(whatsappUrl);

    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(launchUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      CustomLogger.bgRed("Could not launch WhatsApp: $e");
    }
  }
}
