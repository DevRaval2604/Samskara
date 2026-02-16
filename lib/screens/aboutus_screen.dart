import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart'; 
import 'contactus_screen.dart'; 

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final double sw = size.width;
    final double sh = size.height;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('About Us', 
          style: TextStyle(color: primaryColor, fontFamily: 'Serif', fontWeight: FontWeight.bold, fontSize: sw * 0.06)
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: sw * 0.07),
        child: Column(
          children: [
            SizedBox(height: sh * 0.02),
            const SamskaraLogo(), 
            SizedBox(height: sh * 0.04),

            // 1. THE HOOK
            Text(
              "The Path of Samskara", 
              textAlign: TextAlign.center,
              style: TextStyle(
                color: primaryColor,
                fontSize: sw * 0.07,
                fontFamily: 'Serif',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: sh * 0.03),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sw * 0.02), // Extra breathing room for justification
              child: Text(
                "Samskara is more than an app; it is a bridge between the eternal and the everyday. We believe that the depth of our heritage holds the keys to modern peace. Our mission is to curate the profound essence of Indian culture—from the wisdom of the Gita and the daily ritual of a sacred shloka, to the rhythm of our festivals and the valor of our icons—and present it as a living guide for the contemporary soul.",
                textAlign: TextAlign.justify, // Changes from center to justified
                style: TextStyle(
                  color: primaryColor.withValues(alpha: 0.8),
                  fontSize: sw * 0.042,
                  height: 1.4, // Increases line spacing for better readability
                  letterSpacing: 0.2, // Adds a tiny bit of space between letters to aid justification
                ),
              ),
            ),

            SizedBox(height: sh * 0.04),
            const Divider(color: primaryColor, thickness: 0.5),
            SizedBox(height: sh * 0.04),

            // 2. THE PILLARS (Based on your notes)
            _buildSectionHeader("The Samskara Experience", sw),
            SizedBox(height: sh * 0.03),

            _buildValuePoint(
              "Nourishment for the Soul", 
              "True growth doesn't come from a single feast, but from a daily drop of nectar. By delivering a solitary, focused spark of wisdom every day, we transform ancient philosophy into a sustainable spiritual habit for the modern mind.", 
              sw
            ),
            SizedBox(height: sh * 0.025),
            
            _buildValuePoint(
              "Bridging Eras with Intelligence", 
              "We believe that ancient wisdom shouldn't be a relic of the past. By integrating modern technology, we translate timeless spiritual insights into practical guidance for the contemporary seeker.", 
              sw
            ),
            SizedBox(height: sh * 0.025),

            _buildValuePoint(
              "Preserving Cultural Diversity", 
              "Samskara honors the vast tapestry of Indian traditions. We strive to bring regional depth and cultural awareness to the forefront, ensuring that the unique rituals of every corner of the country are celebrated.", 
              sw
            ),
            SizedBox(height: sh * 0.025),

            _buildValuePoint(
              "Character Through Heritage", 
              "At our core, we are storytellers. By revisiting the lives of great icons and historical figures, we aim to instill the values of courage, integrity, and mindfulness in the hearts of our community.", 
              sw
            ),

            SizedBox(height: sh * 0.04),
            const Divider(color: primaryColor, thickness: 0.5),
            SizedBox(height: sh * 0.04),

            // 3. THE MINDS
            _buildSectionHeader("The Minds Behind Samskara", sw),
            SizedBox(height: sh * 0.03),
            _buildTeamMember("Dev Raval", "DR", sw),
            SizedBox(height: sh * 0.03),
            _buildTeamMember("Himani Shah", "HS", sw),
            
            SizedBox(height: sh * 0.04),

            Text(
              "Have questions or suggestions?",
              style: TextStyle(color: primaryColor.withValues(alpha: 0.6), fontSize: sw * 0.035),
            ),
            
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 200),
                    pageBuilder: (context, animation, secondaryAnimation) => const ContactUsScreen(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: primaryColor, width: 1.2),
                  ),
                ),
                child: const Text(
                  "Visit Contact Us",
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: sh * 0.04),
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildSectionHeader(String title, double sw) {
    return Text(
      title,
      style: TextStyle(
        color: primaryColor,
        fontSize: sw * 0.055,
        fontFamily: 'Serif',
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildValuePoint(String title, String description, double sw) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.auto_awesome, color: primaryColor, size: sw * 0.04), 
            SizedBox(width: sw * 0.02),
            Text(title, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: sw * 0.042)),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: sw * 0.06, top: 4),
          child: Text(
            description,
            style: TextStyle(color: primaryColor.withValues(alpha: 0.7), fontSize: sw * 0.038, height: 1.4),
          ),
        ),
      ],
    );
  }

  Widget _buildTeamMember(String name, String initial, double sw) {
    return Row(
      children: [
        CircleAvatar(
          radius: sw * 0.08,
          backgroundColor: primaryColor,
          child: Text(initial, style: TextStyle(color: backgroundColor, fontSize: sw * 0.06, fontWeight: FontWeight.bold)),
        ),
        SizedBox(width: sw * 0.05),
        Text(
          name, 
          style: TextStyle(
            color: primaryColor, 
            fontSize: sw * 0.045, 
            fontWeight: FontWeight.bold,
            fontFamily: 'Serif'
          )
        ),
      ],
    );
  }
}