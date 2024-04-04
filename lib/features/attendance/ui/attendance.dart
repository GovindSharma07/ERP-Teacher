import 'package:erp_teacher/services/firebase_database_services.dart';
import 'package:erp_teacher/widgets/done.dart';
import 'package:flutter/material.dart';

import '../../../widgets/attendance_bubble.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  bool selecting = true;
  String? _class;
  bool _classesSelected = false;
  String? _subject;
  DateTime _date = DateTime.now();
  int once = 1;

  final Map<String, String> attendanceMap = {};

  void updateAttendance(String name, String status) {
    setState(() {
      attendanceMap[name] = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Attendance"),
          centerTitle: true,
        ),
        body: (selecting)
            ? SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: FutureBuilder(
                              future:
                                  FirebaseDatabaseServices().getListOfClasses(),
                              builder: (context, snapShot) {
                                if (snapShot.hasData) {
                                  return DropdownMenu<String>(
                                    width: 300,
                                    hintText: "Select Class",
                                    dropdownMenuEntries: snapShot.data!
                                        .map<DropdownMenuEntry<String>>((e) =>
                                            DropdownMenuEntry(
                                                value: e, label: e))
                                        .toList(),
                                    onSelected: (value) {
                                      _class = value;
                                      _classesSelected = true;
                                      setState(() {});
                                    },
                                  );
                                } else if (snapShot.hasError) {
                                  return Center(
                                    child: Text(snapShot.error.toString()),
                                  );
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              },
                            ),
                          ),
                          (_classesSelected)
                              ? FutureBuilder(
                                  future: FirebaseDatabaseServices()
                                      .getSubjects(_class ?? ""),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: DropdownMenu<String>(
                                          width: 300,
                                          hintText: "Select Subject",
                                          dropdownMenuEntries: snapshot.data!
                                              .map<DropdownMenuEntry<String>>(
                                                  (e) => DropdownMenuEntry(
                                                      value: e, label: e))
                                              .toList(),
                                          onSelected: (value) {
                                            _subject = value;
                                          },
                                        ),
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  },
                                )
                              : const SizedBox(),
                          Container(
                              width: double.maxFinite,
                              margin: const EdgeInsets.all(20),
                              child: ElevatedButton(
                                  onPressed: () async {
                                    var newDate = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2099),
                                      initialDate: _date,
                                    );

                                    if (newDate == null) return;
                                    setState(() {
                                      _date = newDate;
                                    });
                                  },
                                  child: Text(
                                      "Date :- ${_date.day}/${_date.month}/${_date.year}")))
                        ],
                      ),
                    ),
                    Container(
                      width: double.maxFinite,
                      margin: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_class != null && _subject != null) {
                            setState(() {
                              selecting = false;
                            });
                          }
                        },
                        child: const Text(
                          "Next",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: FutureBuilder(
                        future: FirebaseDatabaseServices()
                            .getListOfStudents(_class!),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (once == 1) {
                              for (var student in snapshot.data!) {
                                attendanceMap[student.uid] = 'A';
                              }
                              once--;
                            }
                            return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return AttendanceWidget(
                                  studentName: snapshot.data![index].fName,
                                  attendance: attendanceMap[
                                          snapshot.data![index].uid] ??
                                      "A",
                                  onAttendanceChange: (status) =>
                                      updateAttendance(
                                          snapshot.data![index].uid, status),
                                );
                              },
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text(snapshot.error.toString()));
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        }),
                  ),
                  Container(
                    width: double.maxFinite,
                    margin: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: () {
                        FirebaseDatabaseServices().markAttendance(
                            _class!, _subject!, _date, attendanceMap);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Done()));
                      },
                      child: const Text("Submit"),
                    ),
                  )
                ],
              ));
  }
}
