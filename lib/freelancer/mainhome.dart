import 'dart:math' as math;
import 'package:flutter/material.dart';

// --- MAIN ENTRY POINT ---
void main() {
  runApp(const Talentmainhome());
}

// --- APP WIDGET ---
class Talentmainhome extends StatelessWidget {
  const Talentmainhome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Talent Connect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0F13),
        primaryColor: const Color(0xFF8B5CF6),
        useMaterial3: true,
        fontFamily: 'Roboto', // Default fallback, recommend adding 'GoogleFonts.inter()' in real project
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF8B5CF6),
          secondary: Color(0xFFEC4899),
          tertiary: Color(0xFF3B82F6),
          surface: Color(0xFF18181B), // Slightly lighter dark
        ),
      ),
      home: const LandingPage(),
    );
  }
}

// --- LANDING PAGE ---
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _blobController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _blobController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _blobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          // Ambient Background Blobs
          Positioned(
            top: -100,
            left: -100,
            child: _AnimatedBlob(
              controller: _blobController,
              color: const Color(0xFF8B5CF6).withOpacity(0.3),
              offset: 0,
            ),
          ),
          Positioned(
            top: 100,
            right: -100,
            child: _AnimatedBlob(
              controller: _blobController,
              color: const Color(0xFFEC4899).withOpacity(0.3),
              offset: math.pi,
            ),
          ),
           Positioned(
            bottom: -100,
            left: 50,
            child: _AnimatedBlob(
              controller: _blobController,
              color: const Color(0xFF3B82F6).withOpacity(0.3),
              offset: math.pi / 2,
            ),
          ),
          
          // Scrollable Content
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                const SizedBox(height: kToolbarHeight + 40),
                const HeroSection(),
                const SizedBox(height: 100),
                const ProblemSolutionSection(),
                const SizedBox(height: 100),
                const TargetAudienceSection(),
                const SizedBox(height: 100),
                const FeaturesSection(),
                const SizedBox(height: 100),
                const TeamSection(),
                const SizedBox(height: 100),
                const FooterSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent, // Glass effect would require ClipRect and BackdropFilter
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF0F0F13).withOpacity(0.8),
              Colors.transparent,
            ],
          ),
        ),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFEC4899), Color(0xFF8B5CF6)]),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.auto_awesome, size: 20, color: Colors.white),
          ),
          const SizedBox(width: 12),
          const Text(
            'TALENT CONNECT',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2, fontSize: 18),
          ),
        ],
      ),
      actions: [
        if (MediaQuery.of(context).size.width > 800) ...[
          _NavButton(title: 'Vision', onTap: () {}),
          _NavButton(title: 'Features', onTap: () {}),
          _NavButton(title: 'Team', onTap: () {}),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: const StadiumBorder(),
            ),
            child: const Text('Join Now', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 20),
        ] else
          IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
      ],
    );
  }
}

// --- SECTIONS ---

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 900;
          
          return Flex(
            direction: isDesktop ? Axis.horizontal : Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Text Content
              Expanded(
                flex: isDesktop ? 5 : 0,
                child: Column(
                  crossAxisAlignment: isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle)),
                          const SizedBox(width: 8),
                          const Text('The Future of Freelancing', style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFFEC4899), Color(0xFF8B5CF6), Color(0xFF3B82F6)],
                      ).createShader(bounds),
                      child: Text(
                        'Connecting\nCreative Souls\nto Visionaries.',
                        textAlign: isDesktop ? TextAlign.left : TextAlign.center,
                        style: const TextStyle(
                          fontSize: 48,
                          height: 1.1,
                          fontWeight: FontWeight.w900,
                          color: Colors.white, // Required for shader
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'The ultimate digital platform for Photographers, Artists, Singers, and Videographers to showcase talent, manage gigs, and get booked securely.',
                      textAlign: isDesktop ? TextAlign.left : TextAlign.center,
                      style: const TextStyle(fontSize: 18, color: Colors.grey, height: 1.5),
                    ),
                    const SizedBox(height: 32),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.search),
                          label: const Text('Find Talent'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: const StadiumBorder(),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                            side: const BorderSide(color: Colors.white24),
                            foregroundColor: Colors.white,
                            shape: const StadiumBorder(),
                          ),
                          child: const Text('Join as Freelancer'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isDesktop) ...[
                const SizedBox(width: 40),
                Expanded(
                  flex: 5,
                  child: SizedBox(
                    height: 500,
                    child: Stack(
                      children: [
                        _FloatingCard(
                          top: 20, right: 20,
                          icon: Icons.palette, color: Colors.pink,
                          title: 'Digital Artist', subtitle: '\$50/hr',
                        ),
                        _FloatingCard(
                          top: 180, left: 20,
                          icon: Icons.camera_alt, color: Colors.purple,
                          title: 'Photographer', subtitle: '\$120/hr',
                          delay: const Duration(milliseconds: 1000),
                        ),
                        _FloatingCard(
                          bottom: 40, right: 80,
                          icon: Icons.videocam, color: Colors.blue,
                          title: 'Videographer', subtitle: 'Top Rated',
                          delay: const Duration(milliseconds: 2000),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class ProblemSolutionSection extends StatelessWidget {
  const ProblemSolutionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      color: Colors.white.withOpacity(0.02),
      child: Column(
        children: [
          const Text(
            'WHY TALENT CONNECT?',
            style: TextStyle(color: Color(0xFF8B5CF6), fontWeight: FontWeight.bold, letterSpacing: 1.5),
          ),
          const SizedBox(height: 16),
          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Roboto'),
              children: [
                TextSpan(text: 'Bridging the Gap in the\n'),
                TextSpan(text: 'Gig Economy', style: TextStyle(color: Color(0xFFEC4899))),
              ],
            ),
          ),
          const SizedBox(height: 60),
          LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: [
                  _InfoCard(
                    title: 'The Struggle',
                    icon: Icons.warning_amber_rounded,
                    color: Colors.redAccent,
                    points: const [
                      'Low Visibility for creatives',
                      'Unreliable Clients & payments',
                      'Difficulty verifying skills',
                    ],
                    width: constraints.maxWidth > 800 ? 350 : constraints.maxWidth,
                  ),
                  _InfoCard(
                    title: 'The Solution',
                    icon: Icons.check_circle_outline,
                    color: Colors.greenAccent,
                    points: const [
                      'Centralized Creative Hub',
                      'Secure Payment Handling',
                      'Professional Portfolios',
                    ],
                    width: constraints.maxWidth > 800 ? 350 : constraints.maxWidth,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class TargetAudienceSection extends StatefulWidget {
  const TargetAudienceSection({super.key});

  @override
  State<TargetAudienceSection> createState() => _TargetAudienceSectionState();
}

class _TargetAudienceSectionState extends State<TargetAudienceSection> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Text('Built for the Creator Economy', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _TabButton(
                  title: "I'm a Freelancer",
                  isActive: _selectedIndex == 0,
                  onTap: () => setState(() => _selectedIndex = 0),
                  activeColor: const Color(0xFF8B5CF6),
                ),
                _TabButton(
                  title: "I'm a Client",
                  isActive: _selectedIndex == 1,
                  onTap: () => setState(() => _selectedIndex = 1),
                  activeColor: const Color(0xFF3B82F6),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: _selectedIndex == 0
                ? _AudienceCard(
                    key: const ValueKey(0),
                    title: 'Showcase Your Art',
                    description: 'Focus on your craft. Talent Connect gives you the platform to manage your portfolio, availability, and payments.',
                    color: const Color(0xFF8B5CF6),
                    icon: Icons.brush,
                  )
                : _AudienceCard(
                    key: const ValueKey(1),
                    title: 'Find Perfect Talent',
                    description: 'Browse verified portfolios. Compare rates, read reviews, and book services for your events instantly.',
                    color: const Color(0xFF3B82F6),
                    icon: Icons.person_search,
                  ),
          ),
        ],
      ),
    );
  }
}

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      {'icon': Icons.search, 'title': 'Smart Discovery', 'desc': 'Find freelancers by category and skill.'},
      {'icon': Icons.image, 'title': 'Portfolios', 'desc': 'High-quality gallery uploads.'},
      {'icon': Icons.calendar_today, 'title': 'Easy Booking', 'desc': 'Real-time availability calendar.'},
      {'icon': Icons.chat_bubble_outline, 'title': 'Direct Chat', 'desc': 'Seamless communication.'},
      {'icon': Icons.credit_card, 'title': 'Secure Payments', 'desc': 'Transaction processing.'},
      {'icon': Icons.verified_user, 'title': 'Rating System', 'desc': 'Build trust with reviews.'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Text('Empowering Creativity', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Text('Everything you need to succeed.', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 60),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: features.map((f) => _FeatureCard(
              icon: f['icon'] as IconData,
              title: f['title'] as String,
              description: f['desc'] as String,
            )).toList(),
          ),
        ],
      ),
    );
  }
}

class TeamSection extends StatelessWidget {
  const TeamSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('THE MINDS BEHIND', style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 40),
        Wrap(
          spacing: 40,
          runSpacing: 40,
          alignment: WrapAlignment.center,
          children: const [
            _MemberAvatar(name: 'Adharsh T K', role: 'Team Member'),
            _MemberAvatar(name: 'Adhiraj C', role: 'Team Member'),
            _MemberAvatar(name: 'Adith M C', role: 'Team Member'),
          ],
        ),
      ],
    );
  }
}

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      color: Colors.black,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.auto_awesome, color: Color(0xFF8B5CF6)),
              SizedBox(width: 8),
              Text('TALENT CONNECT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ],
          ),
          const SizedBox(height: 20),
          const Text('© 2024 Talent Connect. All rights reserved.', style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}

// --- HELPER WIDGETS ---

class _NavButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const _NavButton({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(title, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w500)),
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
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [BoxShadow(color: color, blurRadius: 100, spreadRadius: 50)],
            ),
          ),
        );
      },
    );
  }
}

class _FloatingCard extends StatefulWidget {
  final double? top, bottom, left, right;
  final IconData icon;
  final Color color;
  final String title, subtitle;
  final Duration delay;

  const _FloatingCard({
    this.top, this.bottom, this.left, this.right,
    required this.icon, required this.color, required this.title, required this.subtitle,
    this.delay = Duration.zero,
  });

  @override
  State<_FloatingCard> createState() => _FloatingCardState();
}

class _FloatingCardState extends State<_FloatingCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.top, bottom: widget.bottom, left: widget.left, right: widget.right,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, math.sin(_controller.value * math.pi * 2 + (widget.delay.inMilliseconds / 1000)) * 10),
            child: child,
          );
        },
        child: Container(
          width: 220,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF18181B).withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, offset: const Offset(0, 10))],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: widget.color.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                child: Icon(widget.icon, color: widget.color, size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(widget.subtitle, style: const TextStyle(color: Colors.greenAccent, fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<String> points;
  final double width;

  const _InfoCard({required this.title, required this.icon, required this.color, required this.points, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        border: Border.all(color: color.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 48),
          const SizedBox(height: 24),
          Text(title, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...points.map((p) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                const SizedBox(width: 12),
                Expanded(child: Text(p, style: const TextStyle(color: Colors.white70))),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;
  final Color activeColor;

  const _TabButton({required this.title, required this.isActive, required this.onTap, required this.activeColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(title, style: TextStyle(color: isActive ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _AudienceCard extends StatelessWidget {
  final String title, description;
  final Color color;
  final IconData icon;

  const _AudienceCard({super.key, required this.title, required this.description, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 800),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color.withOpacity(0.1), Colors.transparent], begin: Alignment.topLeft, end: Alignment.bottomRight),
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Text(description, style: const TextStyle(color: Colors.white70, fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(24)),
            child: Icon(icon, size: 64, color: color),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title, description;

  const _FeatureCard({required this.icon, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        border: Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, color: const Color(0xFF8B5CF6), size: 32),
          ),
          const SizedBox(height: 24),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(description, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      ),
    );
  }
}

class _MemberAvatar extends StatelessWidget {
  final String name, role;
  const _MemberAvatar({required this.name, required this.role});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100, height: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.grey, Color(0xFF18181B)]),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF8B5CF6).withOpacity(0.5), width: 2),
          ),
          child: Text(name[0], style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white30)),
        ),
        const SizedBox(height: 16),
        Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(role, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}