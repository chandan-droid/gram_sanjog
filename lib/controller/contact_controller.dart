import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/contact_model.dart';

class ImportantContactController extends GetxController {
  final RxList<ImportantContact> contacts = <ImportantContact>[].obs;
  final RxBool isLoading = true.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchContacts();
  }

  void fetchContacts() async {
    try {
      isLoading.value = true;

      final snapshot = await _firestore
          .collection('important_contacts')
          .orderBy('name')
          .get();

      final fetchedContacts = snapshot.docs
          .map((doc) => ImportantContact.fromMap(doc.data()))
          .toList();

      contacts.assignAll(fetchedContacts);
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch contacts: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
