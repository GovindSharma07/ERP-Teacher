import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erp_teacher/Models/student_model.dart';
import 'package:erp_teacher/services/firebase_messaging_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseDatabaseServices {
  final db = FirebaseFirestore.instance;

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

  Future<List<String>> getSubjects(String cls) async {
    List<String> subjects = [];

    var snapShots = await db
        .collection("User-Teacher")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("classes")
        .doc("classes")
        .collection(cls)
        .get();
    
    snapShots.docs.forEach((element) {subjects.add(element.data()["subjectName"]); });
    return subjects;
  }

  Future<List<StudentModel>> getListOfStudents(String cls)async{
    List<StudentModel> students = [];
    var snapshot  = await db.collection("User-Student").where("section",isEqualTo: cls).get();
    snapshot.docs.forEach((element) {students.add(StudentModel.fromJson(element.data()));});
    print(students);
    return students;
  }

  markAttendance(String cls,String sub,DateTime date,Map<String,String> json)async{
    await db.collection("Attendance").doc(cls).collection(sub).doc("${date.day}-${date.month}-${date.year}").set(json);
  }
}
