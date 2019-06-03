
class User{
  String _uid;
  String _name;
  String _familyName;
  String _gender;

  User(this._uid);

  String get gender => _gender;

  set gender(String value) {
    _gender = value;
  }

  String get familyName => _familyName;

  set familyName(String value) {
    _familyName = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get uid => _uid;

  set uid(String value) {
    _uid = value;
  }


}

