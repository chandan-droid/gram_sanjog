import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controller/link_controller.dart';
import '../../model/link_model.dart';

class ImportantLinksPage extends StatelessWidget {
  ImportantLinksPage({super.key});

  final LinksController controller = Get.put(LinksController());

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar('Error', 'Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Important Links'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.links.isEmpty) {
          return const Center(child: Text('No links available.'));
        }

        return ListView.builder(
          itemCount: controller.links.length,
          itemBuilder: (context, index) {
            final LinkModel link = controller.links[index];
            return ListTile(
              leading: const Icon(Icons.link),
              title: Text(
                link.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                link.url,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  decoration: TextDecoration.underline,
                ),
              ),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => _launchURL(link.url),
            );
          },
        );
      }),
    );
  }
}
