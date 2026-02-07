import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart'; 
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  // RESTORED: Robust Launcher logic
  Future<void> _launchURL(String url) async {
    final String cleanUrl = url.contains('tel:') 
        ? url.replaceAll(RegExp(r'\s+'), '') 
        : url;

    final Uri uri = Uri.parse(cleanUrl);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri, 
          mode: LaunchMode.externalApplication,
        );
      } else {
        debugPrint("Could not launch $cleanUrl");
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final double sw = size.width;
    final double sh = size.height;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true, 
        title: Text(
          "Contact Us",
          style: TextStyle(
            color: primaryColor,
            fontFamily: 'Serif',
            fontWeight: FontWeight.bold,
            fontSize: sw * 0.06,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // RESTORED: Profile-style Centering Logic
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: SizedBox(
                  width: double.infinity, 
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Vertically center
                    crossAxisAlignment: CrossAxisAlignment.center, // Horizontally center
                    children: [
                      SizedBox(height: sh * 0.02),
                      const SamskaraLogo(),
                      SizedBox(height: sh * 0.04),
                      
                      _buildContactCard(
                        context,
                        sw,
                        name: "Dev Raval",
                        email: "devraval2004@gmail.com",
                        phone: "+91 99043 25939",
                      ),

                      SizedBox(height: sh * 0.03),

                      _buildContactCard(
                        context,
                        sw,
                        name: "Himani Shah",
                        email: "shahhimani703@gmail.com",
                        phone: "+91 79843 73949",
                      ),
                      
                      SizedBox(height: sh * 0.04),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContactCard(BuildContext context, double sw, 
      {required String name, required String email, required String phone}) {
    return Container(
      width: sw * 0.85,
      padding: EdgeInsets.symmetric(vertical: sw * 0.06, horizontal: sw * 0.06),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: primaryColor.withValues(alpha: 0.15), width: 1), 
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.12),
            blurRadius: 25,
            spreadRadius: 1,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.5),
            blurRadius: 10,
            offset: const Offset(-5, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: primaryColor,
              fontSize: sw * 0.06,
              fontWeight: FontWeight.bold,
              fontFamily: 'Serif',
            ),
          ),
          SizedBox(height: sw * 0.01),
          Center(
            child: SizedBox(
              width: sw * 0.4,
              child: Divider(color: primaryColor.withValues(alpha: 0.4), thickness: 1),
            ),
          ),
          SizedBox(height: sw * 0.04),
          
          // RESTORED: Clickable Email Row
          _buildInfoRow(
            icon: Icons.mail_outline_rounded,
            text: email,
            sw: sw,
            onTap: () => _launchURL("mailto:$email"),
          ),
          SizedBox(height: sw * 0.02),
          // RESTORED: Clickable Phone Row
          _buildInfoRow(
            icon: Icons.phone_iphone_outlined,
            text: phone,
            sw: sw,
            onTap: () => _launchURL("tel:$phone"),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String text, required double sw, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap, // RESTORED: Interaction
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start, 
          children: [
            Icon(icon, color: primaryColor, size: sw * 0.045),
            SizedBox(width: sw * 0.04),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: primaryColor.withValues(alpha: 0.85),
                  fontSize: sw * 0.038,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}