import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:talentconnect/freelancer/booking.dart';
import 'package:talentconnect/freelancer/chatfreelancer.dart';
import 'package:talentconnect/freelancer/feedbackrating.dart';
import 'package:talentconnect/freelancer/freelancerportfolio.dart';

// --- MAIN ENTRY POINT ---
void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const talentfreelancerhome());
}

// --- APP CONFIGURATION ---
class AppColors {
  static const Color brandDark = Color(0xFF0F0F13);
  static const Color brandPurple = Color(0xFF8B5CF6);
  static const Color brandPink = Color(0xFFEC4899);
  static const Color brandBlue = Color(0xFF3B82F6);
  static const Color cardBg = Color(0xFF18181B);
}

// --- APP WIDGET ---
class talentfreelancerhome extends StatelessWidget {
  const talentfreelancerhome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Talent Connect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.brandDark,
        primaryColor: AppColors.brandPurple,
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: const ColorScheme.dark(
          primary: AppColors.brandPurple,
          secondary: AppColors.brandPink,
          tertiary: AppColors.brandBlue,
          surface: AppColors.cardBg,
        ),
      ),
      home: const DashboardFrontPage(),
    );
  }
}

// --- DASHBOARD FRONT PAGE ---
class DashboardFrontPage extends StatefulWidget {
  const DashboardFrontPage({super.key});

  @override
  State<DashboardFrontPage> createState() => _DashboardFrontPageState();
}

class _DashboardFrontPageState extends State<DashboardFrontPage> with SingleTickerProviderStateMixin {
  late AnimationController _blobController;

  // Mock Data placeholders - Connect your Backend here
  final String _userName = "Alex";
  final String _earnings = "\$12,450";
  final String _views = "1,203";
  final String _rating = "4.9";

  @override
  void initState() {
    super.initState();
    _blobController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _blobController.dispose();
    super.dispose();
  }

  void _handleNavigation(String route, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page,));
    // TODO: Connect your routing logic here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Navigate to $route (Backend Integration Needed)"),
        backgroundColor: AppColors.brandPurple,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          // --- Animated Background Blobs ---
          Positioned(
            top: -100,
            left: -100,
            child: _AnimatedBlob(
              controller: _blobController,
              color: AppColors.brandPurple.withOpacity(0.15),
              offset: 0,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4,
            right: -100,
            child: _AnimatedBlob(
              controller: _blobController,
              color: AppColors.brandPink.withOpacity(0.15),
              offset: math.pi,
            ),
          ),
           Positioned(
            bottom: -100,
            left: 50,
            child: _AnimatedBlob(
              controller: _blobController,
              color: AppColors.brandBlue.withOpacity(0.15),
              offset: math.pi / 2,
            ),
          ),

          // --- Main Content ---
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  
                  // 1. Welcome Header
                  _buildHeader(),
                  
                  const SizedBox(height: 32),

                  // 2. Statistics Row
                  _buildStatsRow(),

                  const SizedBox(height: 32),

                  // 3. Quick Actions Grid (The Buttons)
                  _buildActionGrid(),

                  const SizedBox(height: 32),

                  // 4. Recent Activity Feed
                  _buildActivitySection(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.brandDark.withOpacity(0.7),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05))),
        ),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.brandPink, AppColors.brandPurple]),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.auto_awesome, size: 20, color: Colors.white),
          ),
          const SizedBox(width: 12),
          const Text(
            'TALENT CONNECT',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2, fontSize: 16),
          ),
        ],
      ),
      actions: [
        // IconButton(
        //   onPressed: () => _handleNavigation('Notifications',),
        //   icon: const Icon(Icons.notifications_none),
        // ),
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            backgroundColor: AppColors.brandPurple,
            radius: 18,
            child: const Icon(Icons.person, size: 20, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard',
              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
                children: [
                  const TextSpan(text: 'Hello, '),
                  TextSpan(text: _userName, style: const TextStyle(color: AppColors.brandPurple)),
                ],
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {} ,
          // _handleNavigation('New Project'),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('New Project'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.brandPurple,
            foregroundColor: Colors.white,
            elevation: 8,
            shadowColor: AppColors.brandPurple.withOpacity(0.4),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 600;
        return Flex(
          direction: isSmall ? Axis.vertical : Axis.horizontal,
          children: [
            Expanded(
              flex: isSmall ? 0 : 1,
              child: _StatCard(
                icon: Icons.account_balance_wallet,
                label: 'Earnings',
                value: _earnings,
                trend: '+15%',
                color: Colors.green,
              ),
            ),
            SizedBox(width: isSmall ? 0 : 16, height: isSmall ? 16 : 0),
            Expanded(
              flex: isSmall ? 0 : 1,
              child: _StatCard(
                icon: Icons.visibility,
                label: 'Views',
                value: _views,
                trend: '+5%',
                color: AppColors.brandBlue,
              ),
            ),
            SizedBox(width: isSmall ? 0 : 16, height: isSmall ? 16 : 0),
            Expanded(
              flex: isSmall ? 0 : 1,
              child: _StatCard(
                icon: Icons.star,
                label: 'Rating',
                value: _rating,
                trend: 'Top',
                color: AppColors.brandPink,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Adaptive Grid: 1 column on very small, 2 on mobile/tablet, 4 on desktop
        int crossAxisCount = constraints.maxWidth > 900 ? 4 : constraints.maxWidth > 500 ? 2 : 1;
        
        return GridView.count(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.4,
          children: [
            _ActionCard(
              title: 'Bookings',
              subtitle: '3 Requests',
              icon: Icons.calendar_today_rounded,
              gradientColors: const [Color(0xFF2563EB), Color(0xFF06B6D4)],
              onTap: () => _handleNavigation('Bookings', booking()),
            ),
            _ActionCard(
              title: 'Chat',
              subtitle: '5 Messages',
              icon: Icons.chat_bubble_rounded,
              gradientColors: const [Color(0xFF9333EA), Color(0xFFDB2777)],
              onTap: () => _handleNavigation('Chat', Chatfreelancer()),
            ),
            _ActionCard(
              title: 'Feedback',
              subtitle: '4.9 Rating',
              icon: Icons.star_rounded,
              gradientColors: const [Color(0xFFD97706), Color(0xFFEA580C)],
              onTap: () => _handleNavigation('Feedback', Freelancerfeedback()),
            ),
            _ActionCard(
              title: 'Portfolio',
              subtitle: 'Manage Gallery',
              icon: Icons.grid_view_rounded,
              gradientColors: const [Color(0xFF059669), Color(0xFF14B8A6)],
              onTap: () => _handleNavigation('Portfolio', Freelancerportfolio()),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActivitySection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recent Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () => _handleNavigation('Activity Log', const SizedBox()),
                child: const Text('View All', style: TextStyle(color: AppColors.brandPurple)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // TODO: Map your backend activity list here
          const _ActivityItem(
            title: 'New Booking Request',
            desc: 'Photography for Wedding Event',
            time: '2h ago',
            icon: Icons.calendar_month,
            color: AppColors.brandBlue,
          ),
          const Divider(color: Colors.white10, height: 24),
          const _ActivityItem(
            title: 'Payment Received',
            desc: 'From Sarah J. for Portrait Session',
            time: '5h ago',
            icon: Icons.attach_money,
            color: Colors.green,
          ),
          const Divider(color: Colors.white10, height: 24),
          const _ActivityItem(
            title: 'New 5 Star Review',
            desc: 'Great work on the video editing!',
            time: '1d ago',
            icon: Icons.star_rate,
            color: Colors.amber,
          ),
        ],
      ),
    );
  }
}

// --- REUSABLE WIDGETS ---

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String trend;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.trend,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.trending_up, color: Colors.green, size: 14),
                    const SizedBox(width: 4),
                    Text(trend, style: const TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: gradientColors[0].withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Decorative circles
              Positioned(
                bottom: -20,
                right: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(icon, color: Colors.white, size: 22),
                        ),
                        Icon(Icons.arrow_forward_rounded, color: Colors.white.withOpacity(0.8), size: 20),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.8)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final String title;
  final String desc;
  final String time;
  final IconData icon;
  final Color color;

  const _ActivityItem({
    required this.title,
    required this.desc,
    required this.time,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 4),
              Text(desc, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
            ],
          ),
        ),
        Text(time, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12)),
      ],
    );
  }
}

class _AnimatedBlob extends StatelessWidget {
  final AnimationController controller;
  final Color color;
  final double offset;

  const _AnimatedBlob({required this.controller, required this.color, required this.offset});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            math.sin(controller.value * 2 * math.pi + offset) * 30,
            math.cos(controller.value * 2 * math.pi + offset) * 30,
          ),
          child: Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color,
                  blurRadius: 120,
                  spreadRadius: 60,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}