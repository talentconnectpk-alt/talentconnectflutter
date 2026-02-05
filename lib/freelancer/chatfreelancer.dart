import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class Chatfreelancer extends StatefulWidget {
  const Chatfreelancer({super.key});

  @override
  State<Chatfreelancer> createState() =>
      _FreelancerClientChatPageState();
}

class _FreelancerClientChatPageState
    extends State<Chatfreelancer> {
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

    // Simulate read
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        messages.last["isRead"] = true;
      });
    });
  }

  void sendImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
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
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Widget buildMessage(Map<String, dynamic> msg) {
    bool isMe = msg["isMe"];

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(10),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (msg["type"] == "text")
              Text(
                msg["content"],
                style: TextStyle(
                    color: isMe ? Colors.white : Colors.black),
              ),

            if (msg["type"] == "image")
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(File(msg["content"]), height: 150),
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

            const SizedBox(height: 4),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  msg["time"],
                  style: TextStyle(
                    fontSize: 10,
                    color: isMe ? Colors.white70 : Colors.black54,
                  ),
                ),
                if (isMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    msg["isRead"] ? Icons.done_all : Icons.check,
                    size: 14,
                    color:
                        msg["isRead"] ? Colors.greenAccent : Colors.white70,
                  )
                ]
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Client"),
            Text(
              isTyping
                  ? "typing..."
                  : isClientOnline
                      ? "online"
                      : "offline",
              style: const TextStyle(fontSize: 12),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) =>
                  buildMessage(messages[index]),
            ),
          ),

          SafeArea(
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: sendImage,
                ),
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: sendFile,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    onChanged: (v) {
                      setState(() => isTyping = v.isNotEmpty);
                    },
                    decoration: const InputDecoration(
                      hintText: "Type message...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendTextMessage,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
