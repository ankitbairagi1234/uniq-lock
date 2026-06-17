import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zlock_smart_finance/app/constants/app_colors.dart';
import 'contact_support_controller.dart';

class ContactSupportScreen extends StatelessWidget {
  ContactSupportScreen({super.key});

  final ContactSupportController c = Get.put(ContactSupportController());

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            // gradient: AppColors.bgTopGradient,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1B1B1B),
                Color(0xFF0A0A0A),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF151515),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0x55D9B65A),
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 18,
                      color: Color(0xFFD9B65A),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  "Contact Support",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFF4E19C),
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Can't find what you're looking for? Reach out to our support team",
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.4,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 30),

                // EMAIL
                _supportTile(
                  icon: Icons.mail_outline,
                  title: "Email",
                  subtitle: c.supportEmail,
                  onTap: c.openEmail,
                ),

                const SizedBox(height: 20),

                // PHONE
                // _supportTile(
                //   icon: Icons.phone_outlined,
                //   title: "Phone",
                //   subtitle: "Call us at ${c.supportPhone}",
                //   onTap: c.openPhone,
                // ),
                _supportTile(
                  icon: Icons.phone_outlined,
                  title: "Phone",
                  subtitle: "Call us at ${c.supportPhone}",
                  onTap: () => c.openPhone(c.supportPhone),
                ),

                const SizedBox(height: 20),



                // WHATSAPP
                // _supportTile(
                //   icon: Icons.message,
                //   title: "WhatsApp",
                //   subtitle: "Message on ${c.supportPhone}",
                //   onTap: c.openWhatsApp,
                // ),
                _supportTile(
                  icon: Icons.message,
                  title: "WhatsApp",
                  subtitle: "Message on ${c.supportPhone}",
                  onTap: () => c.openWhatsApp(c.supportPhone),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _supportTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1B1B1B),
              Color(0xFF0A0A0A),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0x55D9B65A),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD9B65A).withOpacity(.10),
              blurRadius: 12,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0x22D9B65A),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 22,
                color: const Color(0xFFD9B65A),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFF4E19C),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xFFD9B65A),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
