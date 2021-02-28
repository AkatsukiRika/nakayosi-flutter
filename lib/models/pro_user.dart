class ProUser {
  String realName;
  String idNumber;
  String phoneNumber;
  String email;
  String richText;
  String password;

  @override
  String toString() {
    return "ProUser(realName='$realName', idNumber='$idNumber', phoneNumber='$phoneNumber', "
        "email='$email', richText='$richText', password='$password')";
  }

  Map<String, String> toMap() {
    Map<String, String> map = {
      'realName': realName,
      'idNumber': idNumber,
      'phoneNumber': phoneNumber,
      'email': email,
      'richText': richText
    };
    if (password != null) {
      map.addAll({
        'password': password
      });
    }
    return map;
  }
}