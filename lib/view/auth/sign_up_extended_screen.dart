import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gram_sanjog/controller/auth/auth_controller.dart';

import '../../common/theme/theme.dart';

class SignUpPageExtended extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();
  final AuthController authController = Get.find<AuthController>();

  final whatsappController = TextEditingController();
  final countryController = TextEditingController();
  final stateController = TextEditingController();
  final districtController = TextEditingController();
  final blockController = TextEditingController();
  final gpController = TextEditingController();
  final villageController = TextEditingController();

  SignUpPageExtended({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Additional Details", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              _buildTextField("WhatsApp Number", whatsappController,
                  keyboardType: TextInputType.phone),
              _buildTextField("Country*", countryController),
              _buildTextField("State*", stateController),
              _buildTextField("District*", districtController),
              _buildTextField("Block*", blockController),
              _buildTextField("GP/Ward*", gpController),
              _buildTextField("Village/Address*", villageController),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.highlight,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      authController.signupData.whatsappNumber =
                          whatsappController.text;
                      authController.signupData.country =
                          countryController.text;
                      authController.signupData.state = stateController.text;
                      authController.signupData.district =
                          districtController.text;
                      authController.signupData.block = blockController.text;
                      authController.signupData.gpWard = gpController.text;
                      authController.signupData.block = blockController.text;

                      authController.signup(authController.signupData);
                    }
                  },
                  child: const Text(
                      "Register", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

Widget _buildTextField(String label, TextEditingController controller,
    {IconData? prefixIcon,
      bool obscure = false,
      TextInputType keyboardType = TextInputType.text,
      String? Function(String?)? validator}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: label,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey.shade900,
        prefixIcon: Icon(prefixIcon, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      obscureText: obscure,
      validator: validator,
    ),
  );
}
