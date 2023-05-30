import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:timeago/timeago.dart' as timeago;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'onboarding_page.dart';
import 'record_details_screen.dart';

class AttendanceListScreen extends StatefulWidget {
  const AttendanceListScreen({super.key});

  @override
  AttendanceListScreenState createState() => AttendanceListScreenState();
}

class AttendanceListScreenState extends State<AttendanceListScreen> {
  List<AttendanceRecord> records = [];
  TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool changeTimeFormat = false;
  final formKey = GlobalKey<FormState>();
  String username = " ";
  String phone = " ";

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
        jsonRecord['phone'],
        DateTime.parse(jsonRecord['check-in']),
      );
    }).toList();

    attendanceRecords.sort((a, b) => a.user.compareTo(b.user));

    setState(() {
      records = attendanceRecords;
    });
  }

  void addNewAttendance(String user, String phone) async {
    DateTime now = DateTime.now();
    AttendanceRecord newRecord = AttendanceRecord(user, phone, now);
    List<AttendanceRecord> updatedRecords = List.from(records)
      ..insert(0, newRecord);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> recordStrings =
        updatedRecords.map((record) => json.encode(record.toJson())).toList();
    await prefs.setStringList('attendance_records', recordStrings);

    String jsonData = json.encode(recordStrings);
    File jsonFile = File('data_set.json');
    await jsonFile.writeAsString(jsonData);

    setState(() {
      records = updatedRecords;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Record added successfully!')),
    );
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

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      Fluttertoast.showToast(msg: 'You have reached the end of the list');
    }
  }

  Widget buildViewList() {
    List<AttendanceRecord> filteredRecords =
        searchRecords(searchController.text);
    if (filteredRecords.isEmpty) {
      return const Center(
        child: Text('No records found.'),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: filteredRecords.length,
      itemBuilder: (context, index) {
        AttendanceRecord record = filteredRecords[index];
        String formattedTime = changeTimeFormat
            ? '${record.time.day} ${record.time.month} ${record.time.year}, ${record.time.hour}:${record.time.minute}'
            : timeago.format(record.time);

        return ListTile(
          title: Text(record.user),
          subtitle: Text(formattedTime),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RecordDetailsScreen(record)),
            );
          },
        );
      },
    );
  }

  Widget buildUsername() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'Username',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter correct name';
          }
          return null;
        },
        onChanged: (value) => setState(() => username = value),
      );

  Widget buildPhone() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'Phone',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter correct phone';
          }
          return null;
        },
        onChanged: (value) => setState(() => phone = value),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance List"),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.toggle_on),
            onPressed: () {
              setState(() {
                changeTimeFormat = !changeTimeFormat;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => OnboardingPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
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
          Expanded(child: buildViewList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Add Attendance Record'),
                content: SizedBox(
                  width: 300,
                  height: 200,
                  child: Form(
                    key: formKey,
                    child: ListView(
                        padding: const EdgeInsets.all(16.0),
                        children: [
                          buildUsername(),
                          const SizedBox(height: 8),
                          buildPhone(),
                        ]),
                  ),
                ),
                actions: [
                  TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  TextButton(
                      child: const Text('Add'),
                      onPressed: () {
                        final isValid =
                            formKey.currentState?.validate() ?? false;

                        if (isValid) {
                          addNewAttendance(username, phone);
                          Navigator.pop(context);
                        }
                      }),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AttendanceRecord {
  String user;
  String phone;
  DateTime time;

  AttendanceRecord(
    this.user,
    this.phone,
    this.time,
  );

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'phone': phone,
      'time': time.toIso8601String(),
    };
  }
}
