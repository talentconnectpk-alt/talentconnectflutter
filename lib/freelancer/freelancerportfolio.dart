import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(const Freelancerportfolio());
}

class Freelancerportfolio extends StatelessWidget {
  const Freelancerportfolio({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeuPortfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFE6EBF2),
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1C1F26),
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system, // We handle theme manually in state for smoother transitions if needed, but app-level is fine.
      home: const PortfolioHome(),
    );
  }
}

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome> with TickerProviderStateMixin {
  bool isDark = true;
  bool isPreview = false;

  // Data
  String name = "Adharsh T K";
  String role = "Photographer | Videographer";
  String bio = "Creative visual storyteller specializing in event photography and cinematic videography.";
  bool available = true;
  List<String> skills = ["Event Photography", "Videography", "Video Editing"];
  List<Map<String, String>> services = [
    {"id": "1", "title": "Event Photography", "price": "8000"},
    {"id": "2", "title": "Promotional Video", "price": "5000"},
  ];
  List<Map<String, String>> media = [];

  // Controllers
  late AnimationController _bgAnimController;

  @override
  void initState() {
    super.initState();
    _bgAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bgAnimController.dispose();
    super.dispose();
  }

  Color get bgColor => isDark ? const Color(0xFF1C1F26) : const Color(0xFFE6EBF2);
  Color get textColor => isDark ? Colors.white : Colors.grey.shade800;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // Animated Background Blobs
          AnimatedBuilder(
            animation: _bgAnimController,
            builder: (context, child) {
              return Stack(
                children: [
                  Positioned(
                    top: -100 + (_bgAnimController.value * 50),
                    left: -100,
                    child: _buildBlob(
                      isDark ? Colors.deepPurple.shade900 : Colors.blue.shade100,
                    ),
                  ),
                  Positioned(
                    bottom: -100 - (_bgAnimController.value * 50),
                    right: -100,
                    child: _buildBlob(
                      isDark ? Colors.blue.shade900 : Colors.purple.shade100,
                    ),
                  ),
                ],
              );
            },
          ),
          
          // Blur Filter
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
            child: Container(color: Colors.transparent),
          ),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.1),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: isPreview
                        ? PreviewView(
                            key: const ValueKey('preview'),
                            isDark: isDark,
                            data: _getPortfolioData(),
                          )
                        : EditView(
                            key: const ValueKey('edit'),
                            isDark: isDark,
                            data: _getPortfolioData(),
                            onUpdate: _updateData,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getPortfolioData() => {
    'name': name,
    'role': role,
    'bio': bio,
    'available': available,
    'skills': skills,
    'services': services,
    'media': media,
  };

  void _updateData(String key, dynamic value) {
    setState(() {
      switch (key) {
        case 'name': name = value; break;
        case 'role': role = value; break;
        case 'bio': bio = value; break;
        case 'available': available = value; break;
        case 'skills': skills = value; break;
        case 'services': services = value; break;
        case 'media': media = value; break;
      }
    });
  }

  Widget _buildBlob(Color color) {
    return Container(
      width: 400,
      height: 400,
      decoration: BoxDecoration(
        color: color.withOpacity(0.4),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            isPreview ? "Portfolio Preview" : "Edit Portfolio",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          Row(
            children: [
              NeuButton(
                isDark: isDark,
                onTap: () => setState(() => isDark = !isDark),
                padding: const EdgeInsets.all(12),
                child: Icon(
                  isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                  color: isDark ? Colors.amber : Colors.grey.shade600,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              NeuButton(
                isDark: isDark,
                onTap: () => setState(() => isPreview = !isPreview),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Icon(
                      isPreview ? Icons.edit_rounded : Icons.remove_red_eye_rounded,
                      color: Colors.deepPurpleAccent,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isPreview ? "Edit" : "Preview",
                      style: const TextStyle(
                        color: Colors.deepPurpleAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// EDIT VIEW
// -----------------------------------------------------------------------------

class EditView extends StatefulWidget {
  final bool isDark;
  final Map<String, dynamic> data;
  final Function(String, dynamic) onUpdate;

  const EditView({
    super.key,
    required this.isDark,
    required this.data,
    required this.onUpdate,
  });

  @override
  State<EditView> createState() => _EditViewState();
}

class _EditViewState extends State<EditView> {
  final TextEditingController _skillCtrl = TextEditingController();
  final TextEditingController _serviceTitleCtrl = TextEditingController();
  final TextEditingController _servicePriceCtrl = TextEditingController();

  Color get textColor => widget.isDark ? Colors.white : Colors.grey.shade800;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      physics: const BouncingScrollPhysics(),
      children: [
        _buildProfileSection(),
        const SizedBox(height: 32),
        _buildSectionTitle("About"),
        NeuInput(
          isDark: widget.isDark,
          initialValue: widget.data['bio'],
          maxLines: 4,
          label: "Bio",
          onChanged: (v) => widget.onUpdate('bio', v),
        ),
        const SizedBox(height: 32),
        _buildSectionTitle("Skills"),
        _buildSkillsEditor(),
        const SizedBox(height: 32),
        _buildSectionTitle("Services"),
        _buildServicesEditor(),
        const SizedBox(height: 32),
        _buildSectionTitle("Media"),
        _buildMediaEditor(),
        const SizedBox(height: 32),
        _buildAvailabilitySwitch(),
        const SizedBox(height: 48),
        NeuButton(
          isDark: widget.isDark,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 10),
                    Text("Portfolio Saved!"),
                  ],
                ),
                backgroundColor: Colors.deepPurple,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          },
          child: const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                "Save Changes",
                style: TextStyle(
                  color: Colors.deepPurpleAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 4),
      child: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      children: [
        NeuCard(
          isDark: widget.isDark,
          padding: const EdgeInsets.all(8),
          isCircle: true,
          child: const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage("https://picsum.photos/200"),
          ),
        ),
        const SizedBox(height: 24),
        NeuInput(
          isDark: widget.isDark,
          initialValue: widget.data['name'],
          label: "Full Name",
          onChanged: (v) => widget.onUpdate('name', v),
        ),
        const SizedBox(height: 16),
        NeuInput(
          isDark: widget.isDark,
          initialValue: widget.data['role'],
          label: "Role",
          onChanged: (v) => widget.onUpdate('role', v),
        ),
      ],
    );
  }

  Widget _buildSkillsEditor() {
    final skills = widget.data['skills'] as List<String>;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: skills.map((s) => _buildChip(s)).toList(),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: NeuInput(
                isDark: widget.isDark,
                controller: _skillCtrl,
                hint: "Add new skill...",
              ),
            ),
            const SizedBox(width: 12),
            NeuButton(
              isDark: widget.isDark,
              onTap: () {
                if (_skillCtrl.text.isNotEmpty) {
                  final newSkills = List<String>.from(skills)..add(_skillCtrl.text);
                  widget.onUpdate('skills', newSkills);
                  _skillCtrl.clear();
                }
              },
              padding: const EdgeInsets.all(16),
              child: const Icon(Icons.add_rounded, color: Colors.deepPurpleAccent),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChip(String label) {
    return NeuButton(
      isDark: widget.isDark,
      onTap: () {
        final newSkills = List<String>.from(widget.data['skills'])..remove(label);
        widget.onUpdate('skills', newSkills);
      },
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(color: textColor, fontSize: 13)),
          const SizedBox(width: 6),
          Icon(Icons.close_rounded, size: 14, color: Colors.red.shade400),
        ],
      ),
    );
  }

  Widget _buildServicesEditor() {
    final services = widget.data['services'] as List<Map<String, String>>;
    return Column(
      children: [
        ...services.map((s) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: NeuCard(
            isDark: widget.isDark,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(s['title']!, style: TextStyle(color: textColor, fontWeight: FontWeight.w600)),
                ),
                Text("₹${s['price']}", style: const TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold)),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    final newServices = List<Map<String, String>>.from(services)..remove(s);
                    widget.onUpdate('services', newServices);
                  },
                  child: Icon(Icons.delete_outline_rounded, size: 20, color: Colors.red.shade400),
                ),
              ],
            ),
          ),
        )),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: NeuInput(
                isDark: widget.isDark,
                controller: _serviceTitleCtrl,
                hint: "Service",
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: NeuInput(
                isDark: widget.isDark,
                controller: _servicePriceCtrl,
                hint: "Price",
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 8),
            NeuButton(
              isDark: widget.isDark,
              onTap: () {
                if (_serviceTitleCtrl.text.isNotEmpty && _servicePriceCtrl.text.isNotEmpty) {
                  final newServices = List<Map<String, String>>.from(services)
                    ..add({
                      "id": DateTime.now().toString(),
                      "title": _serviceTitleCtrl.text,
                      "price": _servicePriceCtrl.text
                    });
                  widget.onUpdate('services', newServices);
                  _serviceTitleCtrl.clear();
                  _servicePriceCtrl.clear();
                }
              },
              padding: const EdgeInsets.all(16),
              child: const Icon(Icons.add_rounded, color: Colors.deepPurpleAccent),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMediaEditor() {
    final media = widget.data['media'] as List<Map<String, String>>;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: NeuButton(
                isDark: widget.isDark,
                onTap: () {
                  final newMedia = List<Map<String, String>>.from(media)..add({"type": "photo"});
                  widget.onUpdate('media', newMedia);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Icon(Icons.image_rounded, color: Colors.blueAccent),
                      SizedBox(height: 8),
                      Text("Add Photo", style: TextStyle(fontSize: 12, color: Colors.blueAccent)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: NeuButton(
                isDark: widget.isDark,
                onTap: () {
                  final newMedia = List<Map<String, String>>.from(media)..add({"type": "video"});
                  widget.onUpdate('media', newMedia);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Icon(Icons.videocam_rounded, color: Colors.pinkAccent),
                      SizedBox(height: 8),
                      Text("Add Video", style: TextStyle(fontSize: 12, color: Colors.pinkAccent)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        if (media.isNotEmpty) ...[
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: media.length,
            itemBuilder: (context, index) {
              final item = media[index];
              final isVideo = item['type'] == 'video';
              return NeuCard(
                isDark: widget.isDark,
                padding: EdgeInsets.zero,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      isVideo ? Icons.videocam_rounded : Icons.image_rounded,
                      color: (isVideo ? Colors.pinkAccent : Colors.blueAccent).withOpacity(0.5),
                      size: 32,
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          final newMedia = List<Map<String, String>>.from(media)..removeAt(index);
                          widget.onUpdate('media', newMedia);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close, size: 10, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ],
    );
  }

  Widget _buildAvailabilitySwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Available for booking", style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w500)),
        GestureDetector(
          onTap: () => widget.onUpdate('available', !widget.data['available']),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 60,
            height: 32,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: widget.isDark ? const Color(0xFF1C1F26) : const Color(0xFFE6EBF2),
              borderRadius: BorderRadius.circular(20),
              boxShadow: widget.data['available']
                    ? [
                        BoxShadow(color: Colors.deepPurpleAccent.withOpacity(0.3), blurRadius: 8, spreadRadius: -8),
                        const BoxShadow(color: Colors.white10, offset: Offset(-2, -2), blurRadius: 4, spreadRadius: -4),
                      ]
                  : [
                      BoxShadow(color: widget.isDark ? const Color(0xff12141a) : const Color(0xffa3b1c6), offset: const Offset(4, 4), blurRadius: 6),
                      BoxShadow(color: widget.isDark ? const Color(0xff2a2d36) : Colors.white, offset: const Offset(-4, -4), blurRadius: 6),
                    ],
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutBack,
              alignment: widget.data['available'] ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.data['available'] ? Colors.deepPurpleAccent : Colors.grey,
                  boxShadow: [
                    BoxShadow(
                      color: (widget.data['available'] ? Colors.deepPurpleAccent : Colors.grey).withOpacity(0.5),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// PREVIEW VIEW
// -----------------------------------------------------------------------------

class PreviewView extends StatefulWidget {
  final bool isDark;
  final Map<String, dynamic> data;

  const PreviewView({super.key, required this.isDark, required this.data});

  @override
  State<PreviewView> createState() => _PreviewViewState();
}

class _PreviewViewState extends State<PreviewView> with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Color get textColor => widget.isDark ? Colors.white : Colors.grey.shade800;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      physics: const BouncingScrollPhysics(),
      children: [
        _animatedItem(0, _buildHeaderCard()),
        const SizedBox(height: 32),
        _animatedItem(1, _buildSection("About Me", widget.data['bio'] ?? "")),
        const SizedBox(height: 32),
        _animatedItem(2, _buildSkillsSection()),
        const SizedBox(height: 32),
        _animatedItem(3, _buildServicesSection()),
        const SizedBox(height: 32),
        _animatedItem(4, _buildPortfolioGrid()),
        const SizedBox(height: 50),
        _animatedItem(5, Center(child: Text("© ${DateTime.now().year} ${widget.data['name']}. All rights reserved.", style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 12)))),
      ],
    );
  }

  Widget _animatedItem(int index, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _animController,
          curve: Interval(index * 0.1, 1.0, curve: Curves.easeOutBack),
        ),
      ),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: _animController,
          curve: Interval(index * 0.1, 1.0, curve: Curves.easeIn),
        ),
        child: child,
      ),
    );
  }

  Widget _buildHeaderCard() {
    final available = widget.data['available'];
    return NeuCard(
      isDark: widget.isDark,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: (available ? Colors.green : Colors.red).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: (available ? Colors.green : Colors.red).withOpacity(0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: available ? Colors.green : Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    available ? "AVAILABLE" : "BUSY",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: available ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              if (available)
                const PulseRing(color: Colors.deepPurpleAccent),
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: widget.isDark ? Colors.white10 : Colors.black12, width: 4),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))
                  ],
                ),
                child: const CircleAvatar(
                  backgroundImage: NetworkImage("https://picsum.photos/200"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.data['name'],
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
          ),
          const SizedBox(height: 4),
          Text(
            widget.data['role'],
            style: TextStyle(fontSize: 14, color: textColor.withOpacity(0.6)),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: NeuButton(
                  isDark: widget.isDark,
                  onTap: () {},
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.mail_outline_rounded, size: 18, color: Colors.deepPurpleAccent),
                        SizedBox(width: 8),
                        Text("Contact", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurpleAccent)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: NeuButton(
                  isDark: widget.isDark,
                  onTap: () {},
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star_outline_rounded, size: 18, color: Colors.amber),
                        SizedBox(width: 8),
                        Text("Rate", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
        const SizedBox(height: 12),
        NeuCard(
          isDark: widget.isDark,
          padding: const EdgeInsets.all(20),
          child: Text(
            content.isEmpty ? "No information." : content,
            style: TextStyle(fontSize: 15, height: 1.6, color: textColor.withOpacity(0.8)),
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsSection() {
    final skills = widget.data['skills'] as List<String>;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Skills", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: skills.map((s) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: widget.isDark ? const Color(0xFF1C1F26) : const Color(0xFFE6EBF2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: widget.isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
              boxShadow: [
                 BoxShadow(color: widget.isDark ? Colors.black26 : Colors.black12, offset: const Offset(2, 2), blurRadius: 4),
                 BoxShadow(color: widget.isDark ? Colors.white.withOpacity(0.05) : Colors.white, offset: const Offset(-2, -2), blurRadius: 4),
              ]
            ),
            child: Text(s, style: TextStyle(color: textColor.withOpacity(0.9), fontWeight: FontWeight.w500)),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildServicesSection() {
    final services = widget.data['services'] as List<Map<String, String>>;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Services & Pricing", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
        const SizedBox(height: 12),
        ...services.map((s) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: NeuCard(
            isDark: widget.isDark,
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.deepPurpleAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.check_circle_outline_rounded, color: Colors.deepPurpleAccent, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text(s['title']!, style: TextStyle(fontWeight: FontWeight.w600, color: textColor)),
                  ],
                ),
                Text("₹${s['price']}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor.withOpacity(0.8))),
              ],
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildPortfolioGrid() {
    final media = widget.data['media'] as List<Map<String, String>>;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Recent Work", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
        const SizedBox(height: 12),
        if (media.isEmpty)
          Padding(padding: const EdgeInsets.all(8.0), child: Text("No work uploaded yet.", style: TextStyle(fontStyle: FontStyle.italic, color: textColor.withOpacity(0.5)))),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: media.length,
          itemBuilder: (context, index) {
            final item = media[index];
            final isVideo = item['type'] == 'video';
            return NeuCard(
              isDark: widget.isDark,
              padding: EdgeInsets.zero,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: isVideo ? Colors.pinkAccent.withOpacity(0.1) : Colors.blueAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  Center(
                    child: Icon(
                      isVideo ? Icons.play_circle_fill_rounded : Icons.photo_library_rounded,
                      size: 40,
                      color: isVideo ? Colors.pinkAccent : Colors.blueAccent,
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Text(
                      item['type']!.toUpperCase(),
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textColor.withOpacity(0.4)),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// NEUMORPHIC CORE COMPONENTS
// -----------------------------------------------------------------------------

class NeuCard extends StatelessWidget {
  final bool isDark;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool isCircle;

  const NeuCard({
    super.key,
    required this.isDark,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.isCircle = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bg = isDark ? const Color(0xff1c1f26) : const Color(0xffe6ebf2);
    Color lightShadow = isDark ? const Color(0xff2a2d36) : Colors.white;
    Color darkShadow = isDark ? const Color(0xff12141a) : const Color(0xffa3b1c6);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bg,
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle ? null : BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: darkShadow,
            offset: const Offset(5, 5),
            blurRadius: 10,
          ),
          BoxShadow(
            color: lightShadow,
            offset: const Offset(-5, -5),
            blurRadius: 10,
          ),
        ],
      ),
      child: child,
    );
  }
}

class NeuButton extends StatefulWidget {
  final bool isDark;
  final Widget child;
  final VoidCallback onTap;
  final EdgeInsetsGeometry padding;

  const NeuButton({
    super.key,
    required this.isDark,
    required this.child,
    required this.onTap,
    this.padding = EdgeInsets.zero,
  });

  @override
  State<NeuButton> createState() => _NeuButtonState();
}

class _NeuButtonState extends State<NeuButton> with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    Color bg = widget.isDark ? const Color(0xff1c1f26) : const Color(0xffe6ebf2);
    Color lightShadow = widget.isDark ? const Color(0xff2a2d36) : Colors.white;
    Color darkShadow = widget.isDark ? const Color(0xff12141a) : const Color(0xffa3b1c6);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: widget.padding,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            boxShadow: _isPressed
                ? [ // Simulated inset effect or just flat
                    BoxShadow(color: widget.isDark ? Colors.black12 : Colors.grey.shade300, offset: const Offset(2, 2), blurRadius: 4, spreadRadius: -2),
                  ]
                : [
                    BoxShadow(color: darkShadow, offset: const Offset(4, 4), blurRadius: 8),
                    BoxShadow(color: lightShadow, offset: const Offset(-4, -4), blurRadius: 8),
                  ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

class NeuInput extends StatelessWidget {
  final bool isDark;
  final String? label;
  final String? initialValue;
  final String? hint;
  final int maxLines;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  const NeuInput({
    super.key,
    required this.isDark,
    this.label,
    this.initialValue,
    this.hint,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // Inset look: Darker background or inner shadow simulation
    // Since true inner shadow is hard in single file, we use color manipulation
    Color bg = isDark ? const Color(0xff15171c) : const Color(0xffdbe1e8);
    Color textColor = isDark ? Colors.white : Colors.grey.shade800;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: Text(label!, style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            // Inner shadow simulation using border
            border: Border.all(color: isDark ? Colors.white10 : Colors.black12, width: 1),
            boxShadow: [
              BoxShadow(color: isDark ? Colors.black54 : Colors.grey.shade400, offset: const Offset(2, 2), blurRadius: 4, spreadRadius: -4),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: TextFormField(
            controller: controller,
            initialValue: controller == null ? initialValue : null,
            style: TextStyle(color: textColor),
            maxLines: maxLines,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(color: textColor.withOpacity(0.3)),
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class PulseRing extends StatefulWidget {
  final Color color;
  const PulseRing({super.key, required this.color});

  @override
  State<PulseRing> createState() => _PulseRingState();
}

class _PulseRingState extends State<PulseRing> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
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
        return Container(
          width: 110 + (_controller.value * 20),
          height: 110 + (_controller.value * 20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: widget.color.withOpacity(1 - _controller.value),
              width: 2,
            ),
          ),
        );
      },
    );
  }
}
