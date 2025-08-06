import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controller/contact_controller.dart';

class ImportantContactsPage extends StatelessWidget {
  ImportantContactsPage({super.key});

  final controller = Get.put(ImportantContactController());

  void _callNumber(String number) async {
    final uri = Uri.parse('tel:$number');
    if (!await launchUrl(uri)) {
      Get.snackbar("Error", "Could not launch dialer");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Important Contacts")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.contacts.isEmpty) {
          return const Center(child: Text("No contacts found"));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: controller.contacts.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final contact = controller.contacts[index];
            return Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 3,
              child: ListTile(
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                //leading: const Icon(Icons.phone, color: Colors.redAccent),
                title: Text(contact.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                subtitle:  Text(contact.phone,
                    style: const TextStyle(
                         fontSize: 12,color: Colors.black87)),
                trailing: IconButton(
                  icon: const Icon(Icons.call, color: Colors.green),
                  onPressed: () => _callNumber(contact.phone),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
