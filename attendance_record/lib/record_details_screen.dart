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
            Center(
              child: CircleAvatar(
                radius:50,
                backgroundColor: Colors.blue,
                child: Text(
                  record.user.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize:26,
                    ),
                  ),
                ),
            ),
            Divider(
              height:90,
              color:Colors.grey[800],
            ),
            const Text('USER:',
            style:TextStyle(
              letterSpacing: 2.0,
              color:Colors.grey,
            ),),
            SizedBox(height:10),
            Text('${record.user}',
            style:TextStyle(
              fontSize:26,
              fontWeight:FontWeight.bold,

            ),),
            SizedBox(height:10),
            Text('TIME:',
            style:TextStyle(
              letterSpacing: 2.0,
              color:Colors.grey,
            ),),
            SizedBox(height:10),
            Text('${record.time}',
            style:TextStyle(
              fontSize:26,
              fontWeight:FontWeight.bold,

            ),),
            SizedBox(height:10),
            Text('PHONE:',
            style:TextStyle(
              letterSpacing: 2.0,
              color:Colors.grey,
            ),),
            SizedBox(height:10),
            Text('${record.phone}',
            style:TextStyle(
              fontSize:26,
              fontWeight:FontWeight.bold,

            ),),
            SizedBox(height:10),
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
