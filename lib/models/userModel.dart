class User {
  late final String _id;
  late String _name;
  late final String _username;
  late final DateTime _lastLogin;
  late final DateTime _createdAt;

  User(
      {required String id,
      required String name,
      required String username,
      required DateTime createdAt,
      required DateTime lastLogin}) {
    _id = id;
    _name = name;
    _username = username;
    _createdAt = createdAt;
    _lastLogin = lastLogin;
  }

  changeName(String newName) => _name = newName;

  String get name => _name;
  String get id => _id;
  String get username => _username;
  DateTime get createdAt => _createdAt;
  DateTime get lastLogin => _lastLogin;
}
