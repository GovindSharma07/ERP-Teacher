import 'package:flutter/material.dart';

class AttendanceWidget extends StatefulWidget {
  final String studentName;
  final String attendance;
  final Function(String) onAttendanceChange;

  const AttendanceWidget({
    super.key,
    required this.studentName,
    required this.attendance,
    required this.onAttendanceChange,
  });

  @override
  State<AttendanceWidget> createState() => _AttendanceWidgetState();
}

class _AttendanceWidgetState extends State<AttendanceWidget> {
  String selectedAttendance = 'A'; // Initially selected attendance

  @override
  void initState() {
    super.initState();
    selectedAttendance = widget.attendance;
  }

  void updateAttendance(String newAttendance) {
    setState(() {
      selectedAttendance = newAttendance;
    });
    // Call the onAttendanceChange function provided by the parent widget (AttendanceState)
    widget.onAttendanceChange(newAttendance); // Pass the new attendance value
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.studentName),
            Row(
              children: [
                ChoiceChip(
                    label: const Text('Present (P)'),
                    selected: selectedAttendance == 'P',
                    onSelected: (value) =>
                        updateAttendance('P'),
                    selectedColor: Colors.green,
                    // Set selected color for Present
                    backgroundColor: Colors.greenAccent[100]),
                const SizedBox(width: 10),
                ChoiceChip(
                    label: const Text('Absent (A)'),
                    selected: selectedAttendance == 'A',
                    onSelected: (value) =>
                        updateAttendance('A'),
                    selectedColor: Colors.red,
                    // Set selected color for Absent
                    backgroundColor: Colors.redAccent[100]),
                const SizedBox(width: 10),
                ChoiceChip(
                  label: const Text('Leave (L)'),
                  selected: selectedAttendance == 'L',
                  onSelected: (value) =>updateAttendance('L'),
                  selectedColor: Colors.blue,
                  // Set selected color for Leave
                  backgroundColor: Colors.blueAccent[100],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
