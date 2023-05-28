import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:timeago/timeago.dart' as timeago;

import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Attendance Management System",
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: AttendanceListScreen(),
    );
  }
}

class AttendanceListScreen extends StatefulWidget {
  @override
  AttendanceListScreenState createState() => AttendanceListScreenState();
}

class AttendanceListScreenState extends State<AttendanceListScreen> {
  List<AttendanceRecord> records = [];
  TextEditingController searchController = TextEditingController();
  bool changeTimeFormat = false;

  @override
  void initState() {
    super.initState();
    loadAttendance();
  }

  void loadAttendance() async {
    String jsonData =
        await DefaultAssetBundle.of(context).loadString("data_set.json");
    List<dynamic> jsonList = json.decode(jsonData);

    List<AttendanceRecord> attendanceRecords = jsonList.map((jsonRecord) {
      return AttendanceRecord(
        jsonRecord['user'],
        DateTime.parse(jsonRecord['check-in']),
        jsonRecord['phone'],
      );
    }).toList();

    setState(() {
      records = attendanceRecords;
    });
  }

  List<AttendanceRecord> searchRecords(String keyword) {
    if (keyword.isEmpty) {
      return records;
    }

    return records
        .where((record) =>
            record.user.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
  }

  Widget buildViewList() {
    List<AttendanceRecord> filteredRecords =
        searchRecords(searchController.text);
    if (filteredRecords.isEmpty) {
      return Center(
        child: Text('No records found.'),
      );
    }

    return ListView.builder(
      itemCount: filteredRecords.length,
      itemBuilder: (context, index) {
        AttendanceRecord record = filteredRecords[index];
        String formattedTime = changeTimeFormat
            ? '${record.time.day} ${record.time.month} ${record.time.year}, ${record.time.hour}:${record.time.minute}'
            : timeago.format(record.time);

        return ListTile(
          title: Text(record.user),
          subtitle: Text(formattedTime),
          onTap: () {},
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Attendance List"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller:searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                  },
                ),
              ),
              onChanged: (keyword) {
                setState(() {});
              },
            ),
          ),
          Expanded(child:buildViewList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: () {},
      ),
    );
  }
}

class AttendanceRecord {
  String user;
  DateTime time;
  String phone;

  AttendanceRecord(
    this.user,
    this.time,
    this.phone,
  );

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'time': time.toIso8601String(),
      'phone': phone,
    };
  }
}
