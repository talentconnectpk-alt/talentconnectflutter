import 'package:flutter/material.dart';

class booking extends StatefulWidget {
  const booking({super.key});

  @override
  State<booking> createState() => _BookingState();
}

class _BookingState extends State<booking> {
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

  // ---------------- DATE BASED SLOTS ----------------
  DateTime selectedDate = DateTime.now();

  final Map<String, List<String>> slotsByDate = {
    '2024-07-01': ['09:00 AM - 10:00 AM', '11:00 AM - 12:00 PM'],
    '2024-07-02': ['02:00 PM - 03:00 PM'],
  };

  String dateKey(DateTime date) =>
      "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

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

  // ---------------- DATE PICKER ----------------
  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // ---------------- ADD / EDIT SLOT ----------------
  void showSlotDialog({String? slot, int? index}) {
    final controller = TextEditingController(text: slot);
    final key = dateKey(selectedDate);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(slot == null ? 'Add Slot' : 'Edit Slot'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'e.g. 10:00 AM - 11:00 AM',
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
                slotsByDate.putIfAbsent(key, () => []);
                if (slot == null) {
                  slotsByDate[key]!.add(controller.text);
                } else {
                  slotsByDate[key]![index!] = controller.text;
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
    final key = dateKey(selectedDate);
    final slots = slotsByDate[key] ?? [];

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
          // ---------------- BOOKINGS ----------------
          const Text(
            'Booking Requests',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          ...List.generate(bookings.length, (index) {
            final isExpanded = expandedIndex == index;

            return GestureDetector(
              onTap: () {
                setState(() {
                  expandedIndex = isExpanded ? null : index;
                });
              },
              child: Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
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
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(bookings[index]['date']!,
                          style:
                              const TextStyle(color: Colors.grey)),
                      if (isExpanded) ...[
                        const SizedBox(height: 12),
                        Text(bookings[index]['details']!),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: bookings[index]['status'] ==
                                        'Pending'
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
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: bookings[index]['status'] ==
                                        'Pending'
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
              ),
            );
          }),

          const SizedBox(height: 24),

          // ---------------- SLOTS ----------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Available Slots',
                style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: pickDate,
              ),
            ],
          ),

          Text(
            "Selected Date: ${key}",
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 12),

          if (slots.isEmpty)
            const Text('No slots available for this date'),

          ...List.generate(slots.length, (index) {
            return Card(
              child: ListTile(
                title: Text(slots[index]),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () =>
                          showSlotDialog(slot: slots[index], index: index),
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          slots.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 12),

          ElevatedButton.icon(
            onPressed: () => showSlotDialog(),
            icon: const Icon(Icons.add),
            label: const Text('Add Slot'),
          ),
        ],
      ),
    );
  }
}
