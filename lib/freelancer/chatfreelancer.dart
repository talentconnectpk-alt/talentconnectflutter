import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class Chatfreelancer extends StatefulWidget {
  const Chatfreelancer({super.key});

  @override
  State<Chatfreelancer> createState() => _ChatfreelancerState();
}

class _ChatfreelancerState extends State<Chatfreelancer>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool isClientOnline = true;
  bool isTyping = false;

  List<Map<String, dynamic>> messages = [];

  void sendTextMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      messages.add({
        "type": "text",
        "content": _messageController.text.trim(),
        "isMe": true,
        "isRead": false,
        "time": TimeOfDay.now().format(context),
      });
      isTyping = false;
    });

    _messageController.clear();
    scrollDown();

    Future.delayed(const Duration(seconds: 2), () {
      setState(() => messages.last["isRead"] = true);
    });
  }

  void sendImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() {
      messages.add({
        "type": "image",
        "content": image.path,
        "isMe": true,
        "isRead": false,
        "time": TimeOfDay.now().format(context),
      });
    });

    scrollDown();
  }

  void sendFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      messages.add({
        "type": "file",
        "content": result.files.single.name,
        "isMe": true,
        "isRead": false,
        "time": TimeOfDay.now().format(context),
      });
    });

    scrollDown();
  }

  void scrollDown() {
    Future.delayed(const Duration(milliseconds: 200), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 120,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutExpo,
      );
    });
  }

  Widget buildMessage(Map<String, dynamic> msg, int index) {
    bool isMe = msg["isMe"];

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(isMe ? 80 * (1 - value) : -80 * (1 - value), 0),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(12),
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75),
          decoration: BoxDecoration(
            gradient: isMe
                ? const LinearGradient(
                    colors: [Color(0xff4facfe), Color(0xff00f2fe)],
                  )
                : LinearGradient(
                    colors: [Colors.grey.shade300, Colors.grey.shade200]),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (msg["type"] == "text")
                Text(
                  msg["content"],
                  style: TextStyle(
                      color: isMe ? Colors.white : Colors.black87,
                      fontSize: 15),
                ),

              if (msg["type"] == "image")
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(File(msg["content"]), height: 160),
                ),

              if (msg["type"] == "file")
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.insert_drive_file),
                    const SizedBox(width: 6),
                    Text(msg["content"]),
                  ],
                ),

              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    msg["time"],
                    style: TextStyle(
                        fontSize: 10,
                        color:
                            isMe ? Colors.white70 : Colors.black54),
                  ),
                  if (isMe) ...[
                    const SizedBox(width: 4),
                    Icon(
                      msg["isRead"] ? Icons.done_all : Icons.check,
                      size: 14,
                      color: msg["isRead"]
                          ? Colors.greenAccent
                          : Colors.white70,
                    )
                  ]
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget typingIndicator() {
    return AnimatedOpacity(
      opacity: isTyping ? 1 : 0,
      duration: const Duration(milliseconds: 300),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, bottom: 8),
        child: Row(
          children: List.generate(
            3,
            (i) => AnimatedContainer(
              duration: Duration(milliseconds: 300 + i * 150),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fa),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Client", style: TextStyle(color: Colors.black)),
            Text(
              isTyping
                  ? "typing..."
                  : isClientOnline
                      ? "online"
                      : "offline",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            )
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) =>
                  buildMessage(messages[index], index),
            ),
          ),
          typingIndicator(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    color: Colors.white.withOpacity(0.85),
                    child: Row(
                      children: [
                        IconButton(
                            icon: const Icon(Icons.image),
                            onPressed: sendImage),
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            onChanged: (v) =>
                                setState(() => isTyping = v.isNotEmpty),
                            decoration: const InputDecoration(
                              hintText: "Type a message...",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: sendTextMessage,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue,
                            ),
                            child: const Icon(Icons.send,
                                color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
