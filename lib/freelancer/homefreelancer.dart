import 'package:flutter/material.dart';
import 'package:talentconnect/freelancer/booking.dart';
import 'package:talentconnect/freelancer/chatfreelancer.dart';
import 'package:talentconnect/freelancer/feedbackrating.dart';
import 'package:talentconnect/freelancer/freelancerportfolio.dart';
import 'package:talentconnect/freelancer/payment.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _homeButton(
              icon: Icons.payment,
              label: "Payment",
              color: Colors.green,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => Booking()));
              },
            ),
            _homeButton(
              icon: Icons.chat,
              label: "Chat",
              color: Colors.blue,
              onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (_) => Chatfreelancer()));
              },
            ),
            _homeButton(
              icon: Icons.work,
              label: "Portfolio",
              color: Colors.orange,
              onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (_) => FreelancerPortfolio()));
              },
            ),
            _homeButton(
              icon: Icons.star_rate,
              label: "Feedback & Rating",
              color: Colors.amber,
              onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (_) => FreelancerReviewsPage()));
              },
            ),
            _homeButton(
              icon: Icons.calendar_month,
              label: "Booking",
              color: Colors.purple,
              onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (_) => booking()));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _homeButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: 1.2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
