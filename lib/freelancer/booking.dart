import 'package:flutter/material.dart';

class Booking extends StatelessWidget {
  Booking({super.key});
  final List<Map<String, dynamic>> bookings = [
    {
      'title': 'Booking 1',
      'date': '2024-07-01',
      'details': 'Details of Booking 1',
    },
    {
      'title': 'Booking 2',
      'date': '2024-07-05',
      'details': 'Details of Booking 2',
    },
    {
      'title': 'Booking 3',
      'date': '2024-07-10',
      'details': 'Details of Booking 3',
    },
     {
      'title': 'Booking 4',
      'date': '2024-07-12',
      'details': 'Details of Booking 4',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Booking Screen'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(bookings[index]['title']),
              subtitle: Column(children: [Text(bookings[index]['date'],), Text(bookings[index]['details'])]),
            ),
          );
        },
      ),
    );
  }
}
