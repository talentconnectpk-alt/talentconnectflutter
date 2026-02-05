import 'package:flutter/material.dart';

class FreelancerPortfolio extends StatefulWidget {
  const FreelancerPortfolio({super.key});

  @override
  State<FreelancerPortfolio> createState() =>
      _EditableFreelancerPortfolioState();
}

class _EditableFreelancerPortfolioState
    extends State<FreelancerPortfolio> {
  bool isPreview = false;

  String name = "Adharsh T K";
  String role = "Photographer | Videographer";
  String bio =
      "Creative visual storyteller specializing in event photography and cinematic videography.";

  bool available = true;

  final List<String> skills = [
    "Event Photography",
    "Videography",
    "Video Editing"
  ];

  final List<Map<String, String>> services = [
    {"title": "Event Photography", "price": "₹8,000"},
    {"title": "Promotional Video", "price": "₹5,000"},
  ];

  // DUMMY MEDIA
  final List<Map<String, String>> media = [];

  final TextEditingController _skillController = TextEditingController();
  final TextEditingController _serviceController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  void addPhoto() {
    setState(() {
      media.add({"type": "photo"});
    });
  }

  void addVideo() {
    setState(() {
      media.add({"type": "video"});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isPreview ? "Portfolio Preview" : "Edit Portfolio"),
        backgroundColor: Colors.deepPurple,
        actions: [
          TextButton(
            onPressed: () => setState(() => isPreview = !isPreview),
            child: Text(
              isPreview ? "EDIT" : "PREVIEW",
              style: const TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: isPreview ? previewView() : editView(),
      ),
    );
  }

  // ================= EDIT VIEW =================
  Widget editView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        profileHeader(),

        sectionTitle("About"),
        editableText("Bio", bio, (v) => bio = v, maxLines: 3),

        sectionTitle("Skills"),
        skillsEditor(),

        sectionTitle("Services"),
        servicesEditor(),

        sectionTitle("Media Upload"),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: addPhoto,
              icon: const Icon(Icons.photo),
              label: const Text("Add Photo"),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: addVideo,
              icon: const Icon(Icons.videocam),
              label: const Text("Add Video"),
            ),
          ],
        ),
        const SizedBox(height: 10),
        mediaGrid(),

        sectionTitle("Availability"),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text("Available for booking"),
          value: available,
          onChanged: (v) => setState(() => available = v),
        ),

        const SizedBox(height: 30),

        // SAVE BUTTON
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Portfolio saved")),
              );
            },
            child: const Text("Save Changes"),
          ),
        ),
      ],
    );
  }

  // ================= PREVIEW VIEW =================
  Widget previewView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        profileHeader(preview: true),

        sectionTitle("About"),
        Text(bio),

        sectionTitle("Skills"),
        Wrap(
          spacing: 8,
          children: skills.map((s) => Chip(label: Text(s))).toList(),
        ),

        sectionTitle("Portfolio Media"),
        mediaGrid(),

        sectionTitle("Services"),
        ...services.map(
          (s) => ListTile(
            title: Text(s["title"]!),
            trailing: Text(
              s["price"]!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  // ================= MEDIA GRID =================
  Widget mediaGrid() {
    if (media.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Text("No media uploaded"),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: media.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (_, index) {
        final isVideo = media[index]["type"] == "video";
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade300,
          ),
          child: Icon(
            isVideo ? Icons.videocam : Icons.photo,
            size: 40,
            color: Colors.grey.shade700,
          ),
        );
      },
    );
  }

  // ================= HELPERS =================
  Widget profileHeader({bool preview = false}) => Center(
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage("https://i.pravatar.cc/300"),
            ),
            const SizedBox(height: 12),
            preview
                ? Text(name,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold))
                : editableText("Name", name, (v) => name = v),
            preview
                ? Text(role, style: const TextStyle(color: Colors.grey))
                : editableText("Role", role, (v) => role = v),
          ],
        ),
      );

  Widget skillsEditor() => Column(
        children: [
          Wrap(
            spacing: 8,
            children: skills
                .map((s) => Chip(
                      label: Text(s),
                      deleteIcon: const Icon(Icons.close),
                      onDeleted: () => setState(() => skills.remove(s)),
                    ))
                .toList(),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _skillController,
                  decoration: const InputDecoration(hintText: "Add skill"),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  if (_skillController.text.isNotEmpty) {
                    setState(() {
                      skills.add(_skillController.text);
                      _skillController.clear();
                    });
                  }
                },
              ),
            ],
          ),
        ],
      );

  Widget servicesEditor() => Column(
        children: [
          ...services.map(
            (s) => ListTile(
              title: Text(s["title"]!),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(s["price"]!),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => setState(() => services.remove(s)),
                  )
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _serviceController,
                  decoration:
                      const InputDecoration(hintText: "Service"),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _priceController,
                  decoration: const InputDecoration(hintText: "Price"),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  if (_serviceController.text.isNotEmpty &&
                      _priceController.text.isNotEmpty) {
                    setState(() {
                      services.add({
                        "title": _serviceController.text,
                        "price": _priceController.text,
                      });
                      _serviceController.clear();
                      _priceController.clear();
                    });
                  }
                },
              ),
            ],
          ),
        ],
      );

  Widget sectionTitle(String text) => Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 8),
        child: Text(text,
            style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      );

  Widget editableText(
    String label,
    String value,
    Function(String) onSave, {
    int maxLines = 1,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: TextField(
          controller: TextEditingController(text: value),
          maxLines: maxLines,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          onChanged: onSave,
        ),
      );
}
