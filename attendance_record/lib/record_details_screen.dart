import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'attendance_list_screen.dart';

class RecordDetailsScreen extends StatelessWidget {
  final AttendanceRecord record;

  const RecordDetailsScreen(this.record, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Record Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User: ${record.user}'),
            Text('Time: ${record.time}'),
            if (record.phone != null) Text('Phone: ${record.phone}'),
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                String contactInfo = 'User: ${record.user}\n';
                contactInfo += 'Time: ${record.time}\n';
                contactInfo += 'Phone: ${record.phone}\n';
                Share.share(contactInfo); // Share the contact information
              },
            ),
          ],
        ),
      ),
    );
  }
}
