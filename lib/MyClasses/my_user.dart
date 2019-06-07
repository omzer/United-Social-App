class User {
  String _uid;
  String _name;
  String _familyName;
  String _gender;

  User(this._uid);

  String get uid => _uid;

  set uid(String value) {
    _uid = value;
  }
}
