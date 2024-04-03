import "dart:convert";

import "package:firebase_auth/firebase_auth.dart";
import "package:http/http.dart" as http;

class AttendanceFunctions{
  Future<List<dynamic>> getListOfClasses() async{
    var url = Uri.parse("https://fcm-notification-server.onrender.com/api/user/getListOfClasses");

    var response =  await http.post(url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"uid": FirebaseAuth.instance.currentUser!.uid}));
    return jsonDecode(response.body);
  }
}