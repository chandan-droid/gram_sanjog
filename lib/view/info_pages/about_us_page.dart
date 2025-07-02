import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../common/theme/theme.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  void _shareApp() {
    SharePlus.instance.share(
          ShareParams(
            text:  '📲 Check out GramSanjog - A Centralized Information Platform for verified news and community updates.\n\nDownload the app now and stay informed!\n\nhttps://yourappdownloadlink.com',
              subject: 'Join GramSanjog!',
          ),

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text("About GramSanjog"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/logo/gram_sanjog_app_icon.png',
                      height: 90,
                      width: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              const Text(
                "GramSanjog - A Centralized Information Platform",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Our platform is designed to enable users to organize and access similar types of information under unified categories. "
                    "The goal is to ensure clarity, reliability, and ease of comparison for everyone using the platform.",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: AppColors.textSecondary,
                ),
              ),
              const Divider(height: 40, thickness: 1.2),
              const Row(
                children: [
                  Icon(Icons.extension, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text("How It Works", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 20),

              _buildStep(
                icon: Icons.person_add_alt,
                title: "1. User-Contributed Contents",
                description:
                "Users can submit content focused on specific topics or categories. "
                    "The idea is to group similar content into one article for easy access, comparison, and understanding.",
              ),
              const SizedBox(height: 20),

              _buildStep(
                icon: Icons.verified_user,
                title: "2. Manual Verification Process",
                description:
                "Each piece of information is manually verified by our team. "
                    "We validate the original source before making it public on the platform.",
              ),
              const SizedBox(height: 20),

              _buildStep(
                icon: Icons.source,
                title: "3. Source-Based Transparency",
                description:
                "Original sources are always listed with verified content, promoting trust, transparency, and accountability.",
              ),

              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.highlight.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.highlight.withOpacity(0.3)),
                ),
                child:  const Row(
                  children: [
                    Icon(Icons.info_outline, color:AppColors.textSecondary ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "We believe in building a community informed by facts, verified sources, and responsible sharing.",
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // const SizedBox(height: 30),
              // Center(
              //   child: ElevatedButton.icon(
              //     onPressed: _shareApp,
              //     icon: const Icon(Icons.share, color: Colors.white),
              //     label: const Text("Share This App", style: TextStyle(color: Colors.white)),
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: AppColors.primary,
              //       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(description,
                  style: TextStyle(
                      fontSize: 14, color: AppColors.textMuted, height: 1.5)),
            ],
          ),
        ),
      ],
    );
  }
}
