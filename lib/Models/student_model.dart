class StudentModel {
  String uid;
  String email;
  String fName;
  String lName;
  String rollNo;
  String dateOfBirth;
  String gender;
  String annualFees;
  String feesPaid;
  String busAllocated;
  String studentContact;
  String parentContact;
  String address;
  String course;
  String section;

  StudentModel({
    required this.uid,
    required this.email,
    required this.fName,
    required this.lName,
    required this.rollNo,
    required this.dateOfBirth,
    required this.gender,
    required this.annualFees,
    this.feesPaid = "0",
    required this.busAllocated,
    required this.studentContact,
    required this.parentContact,
    required this.address,
    required this.course,
    required this.section,
  });

  Map<String, String> toJson() {
    return {
      "uid": uid,
      "email": email,
      "fName": fName,
      "lName": lName,
      "rollNo": rollNo,
      "dateOfBirth": dateOfBirth,
      "gender": gender,
      "annualFees": annualFees,
      "feesPaid" : feesPaid,
      "busAllocated": busAllocated,
      "studentContact": studentContact,
      "parentContact": parentContact,
      "address": address,
      "course": course,
      "section": section
    };
  }

  factory StudentModel.fromJson(Map<String, dynamic> json){
    return StudentModel(uid: json["uid"]!,
        email: json["email"]!,
        fName: json["fName"]!,
        lName: json["lName"]!,
        rollNo: json["rollNo"]!,
        dateOfBirth: json["dateOfBirth"]!,
        gender: json["gender"]!,
        annualFees: json["annualFees"]!,
        feesPaid: json["feesPaid"] ?? "0",
        busAllocated: json["busAllocated"]!,
        studentContact: json["studentContact"]!,
        parentContact: json["parentContact"]!,
        address: json["address"]!,
        course: json["course"]!,
        section: json["section"]!);
  }
}
