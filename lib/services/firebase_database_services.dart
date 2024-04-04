import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erp_teacher/Models/student_model.dart';
import 'package:erp_teacher/services/firebase_messaging_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseDatabaseServices {
  final db = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> storeTokenToDb(String uid) async {
    String busNumber = "";
    await db
        .collection("User-Teacher")
        .doc(uid)
        .get()
        .then((value) => {busNumber = value.data()!["busAllocated"]});
    if (busNumber == "") {
      return;
    } else {
      String driverUid = "";
      await db
          .collection("User-Driver")
          .limit(1)
          .where("busNumber", isEqualTo: busNumber)
          .get()
          .then((value) {
        for (var doc in value.docs) {
          driverUid = doc.id;
        }
      });
      if (driverUid != "") {
        await db
            .collection("User-Driver")
            .doc(driverUid)
            .collection("tokens")
            .doc(uid)
            .set({"token": await NotificationServices().getToken()});
      }
    }
  }

  Future<List<dynamic>> getListOfClasses() async {
    List<dynamic> classes = [];
    var snapshot = await db
        .collection("User-Teacher")
        .doc(uid)
        .collection("classes")
        .doc("classes")
        .get();
    classes = snapshot.data()!["classes"];
    return classes;
  }

  Future<List<String>> getSubjects(String cls) async {
    List<String> subjects = [];

    var snapShots = await db
        .collection("User-Teacher")
        .doc(uid)
        .collection("classes")
        .doc("classes")
        .collection(cls)
        .get();

    for (var element in snapShots.docs) {
      subjects.add(element.data()["subjectName"]);
    }
    return subjects;
  }

  Future<List<StudentModel>> getListOfStudents(String cls) async {
    List<StudentModel> students = [];
    var snapshot = await db
        .collection("User-Student")
        .where("section", isEqualTo: cls)
        .get();
    for (var element in snapshot.docs) {
      students.add(StudentModel.fromJson(element.data()));
    }
    return students;
  }

  markAttendance(
      String cls, String sub, DateTime date, Map<String, String> json) async {
    await db
        .collection("Attendance")
        .doc(cls)
        .collection(sub)
        .doc("${date.day}-${date.month}-${date.year}")
        .set(json);
  }

  uploadNotes(String url, String title, String content, String cls) async {
    await db
        .collection("Notes")
        .doc("classes")
        .collection(cls)
        .add({"title": title, "content": content, "url": url});
  }
}
