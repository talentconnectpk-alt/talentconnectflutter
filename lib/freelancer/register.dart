import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const TalentConnectregister());
}

class TalentConnectregister extends StatelessWidget {
  const TalentConnectregister({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Talent Connect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF020617), // slate-950
        primaryColor: const Color(0xFF9333EA), // purple-600
        textTheme: Typography.whiteMountainView.apply(fontFamily: 'Space Grotesk'), 
        // Note: You would need to add google_fonts or assets for the font
      ),
      home: const RegisterScreen(),
    );
  }
}

enum UserRole { freelancer, client }

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with TickerProviderStateMixin {
  UserRole _role = UserRole.freelancer;
  bool _isLoading = false;
  bool _isSuccess = false;
  String? _focusedField;

  // Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _jobController = TextEditingController();
  final _skillsController = TextEditingController();
  final _serviceController = TextEditingController();

  late AnimationController _entranceController;
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoading = false;
      _isSuccess = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 1024;

    return Scaffold(
      body: Stack(
        children: [
          // 1. Animated Background
          const BackgroundParticles(),

          // 2. Main Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: _isSuccess ? _buildSuccessView() : _buildMainContent(isDesktop),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Container(
            padding: const EdgeInsets.all(48),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A).withOpacity(0.8), // slate-900/80
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF334155)), // slate-700
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle_outline, color: Colors.green, size: 48),
                ),
                const SizedBox(height: 24),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFF4ADE80), Color(0xFF059669)],
                  ).createShader(bounds),
                  child: const Text(
                    "Welcome Aboard!",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Your ${_role == UserRole.freelancer ? 'creator' : 'client'} profile is ready.",
                  style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 16),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => setState(() => _isSuccess = false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E293B),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Enter Dashboard"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainContent(bool isDesktop) {
    return Flex(
      direction: isDesktop ? Axis.horizontal : Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left Column (Info)
        if (isDesktop) ...[
          Expanded(child: _buildLeftColumn()),
          const SizedBox(width: 64),
        ],
        
        // Right Column (Form)
        isDesktop 
          ? Expanded(child: _buildRegisterForm()) 
          : _buildRegisterForm(),
      ],
    );
  }

  Widget _buildLeftColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAnimatedText(),
        const SizedBox(height: 24),
        Text(
          "The premier ecosystem for ${_role == UserRole.freelancer ? 'visionary creators' : 'ambitious brands'}. ${_role == UserRole.freelancer ? 'Monetize your passion.' : 'Find the perfect talent.'}",
          style: const TextStyle(fontSize: 20, color: Color(0xFFCBD5E1), height: 1.5),
        ),
        const SizedBox(height: 40),
        _buildFeatureRow(Icons.auto_awesome, _role == UserRole.freelancer ? "AI-powered portfolio matching" : "AI-driven talent recommendations", 0),
        const SizedBox(height: 16),
        _buildFeatureRow(Icons.flash_on, "Instant contracts & payments", 200),
        const SizedBox(height: 16),
        _buildFeatureRow(Icons.star, "Elite community access", 400),
      ],
    );
  }

  Widget _buildAnimatedText() {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Color(0xFFC084FC), Color(0xFFEC4899), Color(0xFFEF4444)],
      ).createShader(bounds),
      child: const Text(
        "Talent\nConnect.",
        style: TextStyle(
          fontSize: 72,
          fontWeight: FontWeight.bold,
          height: 1.1,
          color: Colors.white, // Required for ShaderMask
        ),
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text, int delayMs) {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(-0.1, 0), end: Offset.zero).animate(
        CurvedAnimation(parent: _entranceController, curve: Interval(0.4, 1.0, curve: Curves.easeOut)),
      ),
      child: FadeTransition(
        opacity: CurvedAnimation(parent: _entranceController, curve: Interval(0.4, 1.0, curve: Curves.easeIn)),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Icon(icon, color: const Color(0xFFC084FC), size: 20),
            ),
            const SizedBox(width: 16),
            Text(text, style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterForm() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: const Color(0xFF020617).withOpacity(0.6),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: const Color(0xFF1E293B)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
               const Center(
                 child: Text("Join Now", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
               ),
               const SizedBox(height: 8),
               Center(
                 child: Text(
                   "Customize your ${_role == UserRole.freelancer ? 'Freelancer' : 'Client'} experience",
                   style: const TextStyle(color: Color(0xFF94A3B8)),
                 ),
               ),
               const SizedBox(height: 32),
               
               // Role Switcher
               Container(
                 padding: const EdgeInsets.all(4),
                 decoration: BoxDecoration(
                   color: const Color(0xFF0F172A),
                   borderRadius: BorderRadius.circular(16),
                   border: Border.all(color: const Color(0xFF1E293B)),
                 ),
                 child: LayoutBuilder(
                   builder: (context, constraints) {
                     return Stack(
                       children: [
                         AnimatedAlign(
                           duration: const Duration(milliseconds: 300),
                           curve: Curves.easeInOut,
                           alignment: _role == UserRole.freelancer ? Alignment.centerLeft : Alignment.centerRight,
                           child: Container(
                             width: constraints.maxWidth / 2,
                             height: 48,
                             decoration: BoxDecoration(
                               color: const Color(0xFF334155),
                               borderRadius: BorderRadius.circular(12),
                             ),
                           ),
                         ),
                         Row(
                           children: [
                             _buildRoleButton(UserRole.freelancer, "Freelancer", Icons.work_outline),
                             _buildRoleButton(UserRole.client, "Client", Icons.person_outline),
                           ],
                         ),
                       ],
                     );
                   }
                 ),
               ),
               
               const SizedBox(height: 32),
               
               // Form Fields
               Row(
                 children: [
                   Expanded(child: _buildInput(Icons.person, "Full Name", _nameController, "name")),
                   const SizedBox(width: 16),
                   Expanded(child: _buildInput(Icons.phone, "Phone", _phoneController, "phone")),
                 ],
               ),
               const SizedBox(height: 16),
               _buildInput(Icons.email, "Email Address", _emailController, "email"),
               const SizedBox(height: 16),
               
               AnimatedSize(
                 duration: const Duration(milliseconds: 300),
                 child: Column(
                   children: [
                     if (_role == UserRole.freelancer) ...[
                       _buildInput(Icons.description, "Job Description / Title", _jobController, "job"),
                       const SizedBox(height: 16),
                       _buildInput(Icons.star_outline, "Core Skills", _skillsController, "skills"),
                     ] else ...[
                       _buildInput(Icons.search, "Service Looking For", _serviceController, "service"),
                     ],
                   ],
                 ),
               ),
               
               const SizedBox(height: 16),
               _buildInput(Icons.lock_outline, "Password", _passwordController, "password", isPassword: true),
               
               const SizedBox(height: 32),
               
               // Submit Button
               MouseRegion(
                 cursor: SystemMouseCursors.click,
                 child: GestureDetector(
                   onTap: _isLoading ? null : _handleSubmit,
                   child: AnimatedContainer(
                     duration: const Duration(milliseconds: 200),
                     height: 56,
                     decoration: BoxDecoration(
                       gradient: LinearGradient(
                         colors: _role == UserRole.freelancer 
                           ? [const Color(0xFF9333EA), const Color(0xFF4F46E5)]
                           : [const Color(0xFFDB2777), const Color(0xFFE11D48)],
                       ),
                       borderRadius: BorderRadius.circular(12),
                       boxShadow: [
                         BoxShadow(
                           color: (_role == UserRole.freelancer ? const Color(0xFF9333EA) : const Color(0xFFDB2777)).withOpacity(0.3),
                           blurRadius: 12,
                           offset: const Offset(0, 4),
                         )
                       ]
                     ),
                     child: Stack(
                       children: [
                         // Shimmer
                         AnimatedBuilder(
                           animation: _shimmerController,
                           builder: (context, child) {
                             return Positioned.fill(
                               child: FractionallySizedBox(
                                 widthFactor: 0.5,
                                 alignment: Alignment((_shimmerController.value * 4) - 2, 0),
                                 child: Container(
                                   decoration: BoxDecoration(
                                     gradient: LinearGradient(
                                       colors: [
                                         Colors.white.withOpacity(0),
                                         Colors.white.withOpacity(0.2),
                                         Colors.white.withOpacity(0),
                                       ],
                                     ),
                                   ),
                                 ),
                               ),
                             );
                           },
                         ),
                         Center(
                           child: _isLoading 
                             ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                             : Row(
                                 mainAxisSize: MainAxisSize.min,
                                 children: [
                                   Text(
                                     "Create ${_role == UserRole.freelancer ? 'Freelancer' : 'Client'} Account",
                                     style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                   ),
                                   const SizedBox(width: 8),
                                   const Icon(Icons.arrow_forward, size: 20),
                                 ],
                               ),
                         ),
                       ],
                     ),
                   ),
                 ),
               ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton(UserRole role, String label, IconData icon) {
    final isSelected = _role == role;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _role = role),
        behavior: HitTestBehavior.translucent,
        child: SizedBox(
          height: 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: isSelected ? Colors.white : Colors.grey),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(IconData icon, String hint, TextEditingController controller, String key, {bool isPassword = false}) {
    final isFocused = _focusedField == key;
    return Focus(
      onFocusChange: (hasFocus) => setState(() => _focusedField = hasFocus ? key : null),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isFocused ? const Color(0xFFC084FC) : const Color(0xFF1E293B),
            width: 1,
          ),
          boxShadow: isFocused ? [BoxShadow(color: const Color(0xFFC084FC).withOpacity(0.2), blurRadius: 8)] : [],
        ),
        child: TextFormField(
          controller: controller,
          obscureText: isPassword,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF475569)),
            prefixIcon: Icon(icon, color: isFocused ? Colors.white : const Color(0xFF64748B), size: 20),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ),
    );
  }
}

class BackgroundParticles extends StatelessWidget {
  const BackgroundParticles({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Blobs
        Positioned(
          top: -100,
          left: -100,
          child: _buildBlob(const Color(0xFF9333EA)),
        ),
        Positioned(
          top: -100,
          right: -100,
          child: _buildBlob(const Color(0xFF3B82F6)),
        ),
        Positioned(
          bottom: -100,
          left: 100,
          child: _buildBlob(const Color(0xFFEC4899)),
        ),
        
        // Noise Overlay (Simulated with minimal opacity container in Flutter or custom shader)
        Container(color: Colors.black.withOpacity(0.1)),
      ],
    );
  }

  Widget _buildBlob(Color color) {
    return Container(
      width: 400,
      height: 400,
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
        child: Container(color: Colors.transparent),
      ),
    );
  }
}