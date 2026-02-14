import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

void main() {
  runApp(const TalentConnectlogin());
}

class TalentConnectlogin extends StatelessWidget {
  const TalentConnectlogin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Talent Connect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFDB2777), // Brand Pink
          secondary: Color(0xFF7C3AED), // Brand Purple
          tertiary: Color(0xFF2563EB), // Brand Blue
          surface: Color(0xFF1E293B),
        ),
      ),
      home: const LoginPage(),
    );
  }
}

// --- Background Components ---

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> with TickerProviderStateMixin {
  late AnimationController _blobController;
  final List<FloatingIconData> _icons = [];

  @override
  void initState() {
    super.initState();
    _blobController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // Initialize random floating icons
    final iconList = [
      LucideIcons.camera, LucideIcons.music, LucideIcons.palette, 
      LucideIcons.video, LucideIcons.mic, LucideIcons.penTool, 
      LucideIcons.aperture, LucideIcons.headphones, LucideIcons.film
    ];
    
    for (int i = 0; i < 20; i++) {
      _icons.add(FloatingIconData(
        icon: iconList[i % iconList.length],
        x: math.Random().nextDouble(),
        y: math.Random().nextDouble(),
        scale: 0.5 + math.Random().nextDouble() * 1.5,
        speed: 0.05 + math.Random().nextDouble() * 0.05,
        offset: math.Random().nextDouble() * 2 * math.pi,
      ));
    }
  }

  @override
  void dispose() {
    _blobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Color
        Container(color: const Color(0xFF0F172A)),
        
        // Animated Blobs
        AnimatedBuilder(
          animation: _blobController,
          builder: (context, child) {
            return Stack(
              children: [
                _buildBlob(
                  color: const Color(0xFF7C3AED).withOpacity(0.2),
                  alignment: Alignment(-0.5 + 0.2 * math.sin(_blobController.value * 2 * math.pi), -0.5),
                  scale: 1.2,
                ),
                _buildBlob(
                  color: const Color(0xFFDB2777).withOpacity(0.2),
                  alignment: Alignment(0.5 + 0.3 * math.cos(_blobController.value * 2 * math.pi), 0.2),
                  scale: 1.5,
                ),
                _buildBlob(
                  color: const Color(0xFF2563EB).withOpacity(0.2),
                  alignment: Alignment(-0.2, 0.8 + 0.2 * math.sin(_blobController.value * 2 * math.pi + 1)),
                  scale: 1.3,
                ),
              ],
            );
          },
        ),

        // Floating Icons
        ..._icons.map((data) => FloatingIcon(data: data)),

        // Noise Overlay (Simulated with simple pattern or image asset)
        IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.02),
                  Colors.black.withOpacity(0.02),
                ],
                stops: const [0.0, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBlob({required Color color, required Alignment alignment, required double scale}) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 400 * scale,
        height: 400 * scale,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
          child: Container(color: Colors.transparent),
        ),
      ),
    );
  }
}

class FloatingIconData {
  final IconData icon;
  final double x; // 0.0 to 1.0
  final double y; // 0.0 to 1.0
  final double scale;
  final double speed;
  final double offset;

  FloatingIconData({
    required this.icon,
    required this.x,
    required this.y,
    required this.scale,
    required this.speed,
    required this.offset,
  });
}

class FloatingIcon extends StatefulWidget {
  final FloatingIconData data;

  const FloatingIcon({super.key, required this.data});

  @override
  State<FloatingIcon> createState() => _FloatingIconState();
}

class _FloatingIconState extends State<FloatingIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: (10 / widget.data.speed).round()),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double wobbleY = math.sin(_controller.value * 2 * math.pi + widget.data.offset) * 0.05;
        final double wobbleX = math.cos(_controller.value * 2 * math.pi + widget.data.offset) * 0.02;
        
        return Positioned(
          left: MediaQuery.of(context).size.width * (widget.data.x + wobbleX),
          top: MediaQuery.of(context).size.height * (widget.data.y + wobbleY),
          child: Opacity(
            opacity: 0.1 + 0.1 * math.sin(_controller.value * math.pi), // Pulse opacity
            child: Transform.rotate(
              angle: math.sin(_controller.value * 2 * math.pi) * 0.2,
              child: Icon(
                widget.data.icon,
                color: Colors.white,
                size: 40 * widget.data.scale,
              ),
            ),
          ),
        );
      },
    );
  }
}

// --- UI Components ---

class CustomInput extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isPassword;
  final TextEditingController? controller;

  const CustomInput({
    super.key,
    required this.label,
    required this.icon,
    this.isPassword = false,
    this.controller,
  });

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  bool _isFocused = false;
  bool _showPassword = false;
  late FocusNode _focusNode;
  final TextEditingController _internalController = TextEditingController();

  TextEditingController get _effectiveController => widget.controller ?? _internalController;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    if (widget.controller == null) _internalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = _effectiveController.text.isNotEmpty;
    final active = _isFocused || hasValue;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Stack(
        children: [
          // Background and Border Container
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B).withOpacity(0.3),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              border: Border(
                bottom: BorderSide(
                  color: _isFocused ? primaryColor : const Color(0xFF334155),
                  width: 2,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  widget.icon,
                  color: _isFocused ? primaryColor : const Color(0xFF64748B),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _effectiveController,
                    focusNode: _focusNode,
                    obscureText: widget.isPassword && !_showPassword,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(top: 16, bottom: 4),
                      isDense: true,
                    ),
                    onChanged: (v) => setState(() {}), // Trigger label update
                  ),
                ),
                if (widget.isPassword)
                  GestureDetector(
                    onTap: () => setState(() => _showPassword = !_showPassword),
                    child: Icon(
                      _showPassword ? LucideIcons.eyeOff : LucideIcons.eye,
                      color: const Color(0xFF64748B),
                      size: 18,
                    ),
                  ),
              ],
            ),
          ),

          // Floating Label
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            left: 44,
            top: active ? 4 : 16,
            child: AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: active ? 0.85 : 1.0,
              alignment: Alignment.centerLeft,
              child: Text(
                widget.label,
                style: TextStyle(
                  color: active ? primaryColor : const Color(0xFF94A3B8),
                  fontWeight: active ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
          ),

          // Animated Gradient Line
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 2,
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _isFocused ? MediaQuery.of(context).size.width : 0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).colorScheme.primary,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Main Pages ---

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? _userType; // 'freelancer' | 'client' | null
  bool _isLogin = true;

  void _setUserType(String? type) {
    setState(() {
      _userType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AnimatedBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo Header
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: Opacity(
                            opacity: value,
                            child: child,
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(LucideIcons.sparkles, color: Theme.of(context).colorScheme.primary, size: 32),
                              const SizedBox(width: 12),
                              ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [
                                    Theme.of(context).colorScheme.secondary,
                                    Theme.of(context).colorScheme.primary,
                                    Theme.of(context).colorScheme.tertiary,
                                  ],
                                ).createShader(bounds),
                                child: Text(
                                  'Talent Connect',
                                  style: GoogleFonts.outfit(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Where Creativity Meets Opportunity',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.8),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 48),

                    // Content Switcher
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: _userType == null
                          ? _buildSelectionScreen()
                          : _buildFormScreen(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Footer
          const Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                '© 2025 Talent Connect. All rights reserved.',
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionScreen() {
    return Container(
      key: const ValueKey('selection'),
      constraints: const BoxConstraints(maxWidth: 800),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 600;
          return Flex(
            direction: isDesktop ? Axis.horizontal : Axis.vertical,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: UserTypeCard(
                  title: "I'm a Freelancer",
                  description: "I want to showcase my portfolio and find gigs.",
                  icon: LucideIcons.user,
                  gradient: [const Color(0xFF7C3AED), const Color(0xFF2563EB)],
                  shadowColor: const Color(0xFF2563EB),
                  onTap: () => _setUserType('freelancer'),
                ),
              ),
              SizedBox(width: isDesktop ? 24 : 0, height: isDesktop ? 0 : 24),
              Flexible(
                child: UserTypeCard(
                  title: "I'm a Client",
                  description: "I'm looking to hire talent for my projects.",
                  icon: LucideIcons.briefcase,
                  gradient: [const Color(0xFFDB2777), const Color(0xFF7C3AED)],
                  shadowColor: const Color(0xFFDB2777),
                  onTap: () => _setUserType('client'),
                ),
              ),
            ],
          );
        }
      ),
    );
  }

  Widget _buildFormScreen() {
    final isFreelancer = _userType == 'freelancer';
    final primaryGradient = isFreelancer
        ? const LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFF2563EB)])
        : const LinearGradient(colors: [Color(0xFFDB2777), Color(0xFF7C3AED)]);

    return Container(
      key: const ValueKey('form'),
      constraints: const BoxConstraints(maxWidth: 440),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withOpacity(0.8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => _setUserType(null),
              icon: const Icon(Icons.arrow_back, size: 16),
              label: const Text('Back to selection'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white54,
                padding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _isLogin ? 'Welcome Back' : 'Join the Community',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            _isLogin 
                ? 'Log in as a ${isFreelancer ? 'Creative' : 'Client'}'
                : 'Create your $_userType account',
            style: const TextStyle(color: Colors.white54),
          ),
          const SizedBox(height: 32),
          
          if (!_isLogin)
            const CustomInput(label: 'Full Name', icon: LucideIcons.user),
          
          const CustomInput(label: 'Email Address', icon: LucideIcons.mail),
          const CustomInput(label: 'Password', icon: LucideIcons.lock, isPassword: true),

          const SizedBox(height: 24),
          
          // Submit Button
          Container(
            height: 56,
            decoration: BoxDecoration(
              gradient: primaryGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: (isFreelancer ? const Color(0xFF2563EB) : const Color(0xFFDB2777)).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(16),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isLogin ? 'Sign In' : 'Create Account',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(LucideIcons.arrowRight, size: 20, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
          
          Row(
            children: [
              Expanded(child: Container(height: 1, color: Colors.white10)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('Or continue with', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13)),
              ),
              Expanded(child: Container(height: 1, color: Colors.white10)),
            ],
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(child: SocialButton(icon: LucideIcons.github, label: 'GitHub')),
              const SizedBox(width: 16),
              Expanded(child: SocialButton(icon: LucideIcons.chrome, label: 'Google')),
            ],
          ),

          const SizedBox(height: 32),

          Center(
            child: GestureDetector(
              onTap: () => setState(() => _isLogin = !_isLogin),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.white54),
                  children: [
                    TextSpan(text: _isLogin ? "Don't have an account? " : "Already have an account? "),
                    TextSpan(
                      text: _isLogin ? 'Sign Up' : 'Log In',
                      style: TextStyle(
                        color: isFreelancer ? const Color(0xFF2563EB) : const Color(0xFFDB2777),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserTypeCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradient;
  final Color shadowColor;
  final VoidCallback onTap;

  const UserTypeCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
    required this.shadowColor,
    required this.onTap,
  });

  @override
  State<UserTypeCard> createState() => _UserTypeCardState();
}

class _UserTypeCardState extends State<UserTypeCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()..scale(_isHovered ? 1.02 : 1.0),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B).withOpacity(0.5),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _isHovered ? Colors.white.withOpacity(0.2) : Colors.white.withOpacity(0.05),
            ),
            gradient: _isHovered 
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.gradient[0].withOpacity(0.1),
                    Colors.transparent,
                  ],
                )
              : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: widget.gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: _isHovered ? widget.shadowColor.withOpacity(0.5) : Colors.transparent,
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(widget.icon, color: Colors.white, size: 32),
              ),
              const SizedBox(height: 24),
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.description,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white54,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SocialButton extends StatefulWidget {
  final IconData icon;
  final String label;

  const SocialButton({super.key, required this.icon, required this.label});

  @override
  State<SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<SocialButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: _isHovered ? Colors.white.withOpacity(0.1) : const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, size: 18, color: Colors.white70),
            const SizedBox(width: 8),
            Text(
              widget.label,
              style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
