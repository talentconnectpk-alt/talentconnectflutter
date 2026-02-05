import 'package:flutter/material.dart';

class Booking extends StatefulWidget {
  const Booking({super.key});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  // ---------------- BOOKINGS ----------------
  final List<Map<String, String>> bookings = [
    {
      'title': 'Booking 1',
      'date': '01 Jul 2024',
      'details': 'Details of Booking 1',
      'status': 'Pending',
    },
    {
      'title': 'Booking 2',
      'date': '05 Jul 2024',
      'details': 'Details of Booking 2',
      'status': 'Pending',
    },
  ];

  int? expandedIndex;

  // ---------------- SLOTS ----------------
  final List<String> availableSlots = [
    '09:00 AM - 10:00 AM',
    '11:00 AM - 12:00 PM',
  ];

  // ---------------- STATUS CHIP ----------------
  Widget statusChip(String status) {
    Color color = status == 'Accepted'
        ? Colors.green
        : status == 'Rejected'
            ? Colors.red
            : Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ---------------- ADD / EDIT SLOT ----------------
  void showSlotDialog({String? existingSlot, int? index}) {
    final controller = TextEditingController(text: existingSlot);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(existingSlot == null ? 'Add Slot' : 'Edit Slot'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'e.g. 02:00 PM - 03:00 PM',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (existingSlot == null) {
                  availableSlots.add(controller.text);
                } else {
                  availableSlots[index!] = controller.text;
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Booking Manager'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Booking Requests',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // ---------------- BOOKINGS LIST ----------------
          ...List.generate(bookings.length, (index) {
            final isExpanded = expandedIndex == index;

            return GestureDetector(
              onTap: () {
                setState(() {
                  expandedIndex = isExpanded ? null : index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            bookings[index]['title']!,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        statusChip(bookings[index]['status']!),
                        const SizedBox(width: 6),
                        Icon(isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      bookings[index]['date']!,
                      style: const TextStyle(color: Colors.grey),
                    ),

                    if (isExpanded) ...[
                      const SizedBox(height: 12),
                      Text(bookings[index]['details']!),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed:
                                  bookings[index]['status'] == 'Pending'
                                      ? () {
                                          setState(() {
                                            bookings[index]['status'] =
                                                'Accepted';
                                          });
                                        }
                                      : null,
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green),
                              child: const Text('Accept'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed:
                                  bookings[index]['status'] == 'Pending'
                                      ? () {
                                          setState(() {
                                            bookings[index]['status'] =
                                                'Rejected';
                                          });
                                        }
                                      : null,
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              child: const Text('Reject'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 20),

          // ---------------- SLOTS SECTION ----------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Available Slots',
                style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => showSlotDialog(),
                icon: const Icon(Icons.add_circle, color: Colors.blue),
              ),
            ],
          ),
          const SizedBox(height: 8),

          ...List.generate(availableSlots.length, (index) {
            return Card(
              child: ListTile(
                title: Text(availableSlots[index]),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => showSlotDialog(
                        existingSlot: availableSlots[index],
                        index: index,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          availableSlots.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
