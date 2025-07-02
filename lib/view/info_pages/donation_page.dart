import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/theme/theme.dart';

class DonationPage extends StatelessWidget {
  const DonationPage({super.key});

  final String whatsappNumber = "+916370793232";

  Future<void> _openWhatsApp() async {
    final Uri url = Uri.parse("https://wa.me/${whatsappNumber.replaceAll('+', '')}");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open WhatsApp';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Donate & Support"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Donation & Social Work:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text("Bank: UCO Bank", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            const Text("Account Number: 25280110062951", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            const Text(
              "Name: SRI SRI RADHAKRUSHNA SWAMI COMMITEE",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 32),
            const Text("Donate for:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("1. Free food"),
            const Text("2. Temple development"),
            const Text("3. Help to needy people"),
            const Text("4. Village culture, development work and more..."),
            const SizedBox(height: 24),
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                children: [
                  const TextSpan(text: "After donation, please share a screenshot of payment on WhatsApp "),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: GestureDetector(
                      onTap: _openWhatsApp,
                      child: const Text(
                        "Click here",
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "NOTE: Be aware of frauds. No other mode of payment & no payment to any individual person.",
              style: TextStyle(fontSize: 14, color: Colors.red, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
