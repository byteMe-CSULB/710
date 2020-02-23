
import 'global_contact.dart' as gc;

class Contact {

  int _id;
  String _name;
  String _phone;
  String _email;
  double _fraction;

  //////////////////
  // Constructors
  //////////////////
  Contact(this._name, {String phone, String email}) {
    _phone = phone;
    _email = email;
  }

  // Translate from Map to Contact
  Contact.fromMap(Map<String, dynamic> map)
    : _id = map[gc.colID],
      _name = map[gc.colName],
      _phone = map[gc.colPhone],
      _email = map[gc.colEmail],
      _fraction = map[gc.colFraction];

  ////////////////
  // Database
  ////////////////
  // Mapping for Database
  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map[gc.colID] ??= _id;
    map.addAll({
      gc.colName : _name,
      gc.colPhone : _phone,
      gc.colEmail : _email,
      gc.colFraction : _fraction
    });

    return map;
  }

  //////////////////
  // Get Functions
  //////////////////

  int get id => _id;
  String get name => _name;
  String get phone => _phone;
  String get email => _email;
  double get fraction => _fraction;
  double get percent => _fraction * 100;


  //////////////////
  // Set Functions
  //////////////////

  set name(String newName){
    // New name length should be less than or equal to 255.
    assert(newName.length < 255, "New name length is greater than 255.");
    _name = newName;
  }

  set phone(String newPhone){
    assert(newPhone.length < 255, "New phone length is greater than 255.");
    _phone = newPhone;
  }

  set email(String newEmail){
    assert(newEmail.length < 255, "New email length is greater than 255.");
    _email = newEmail;
  }

  set fraction (double newFraction){
    assert(newFraction <= 1 && newFraction >=0, "Fraction needs to be between 0 and 1.");
    _fraction = newFraction;
  }

  set percent (double newPercent){
    assert(newPercent <= 100 && newPercent >=0, "Percent needs to be between 0 and 100.");
      _fraction = newPercent/100;
  }

  ///////////////
  // Overrides
  @override
  String toString(){
    return 'ID: $_id, Name: $_name, Phone: $_phone, Email: $_email, Fraction: $_fraction\n';
  }

}