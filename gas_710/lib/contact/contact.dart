import 'global_contact.dart' as gc;

class Contact {

  int _id;
  String _fName;
  String _lName;
  //////////////////
  // Constructors

  Contact(this._fName, this._lName)
      :assert(_fName != null, _lName != null);

  // Translate from Map to Contact
  Contact.fromMap(Map<String, dynamic> map)
    : _id = map[gc.colID],
      _fName = map[gc.colFName],
      _lName = map[gc.colLName];

  ////////////////
  // Database

  // Mapping for Database
  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['id'] ??= _id;
    map.addAll({
      'fName' : _fName,
      'lName' : _lName,
    });

    return map;
  }

  //////////////////
  // Get Functions

  int get id => _id;
  String get fName => _fName;
  String get lName => _lName;
  // Get Full Name
  String get name => '$_fName $_lName';

  //////////////////
  // Set Functions

  // First Name
  set fName(String newName){
    if(newName.length <= 255){
      _fName = newName;
    }
  }
  // Last Name
  set lName(String newName){
    if(newName.length <= 255) {
      _lName = newName;
    }
  }

  ///////////////
  // Overrides
  @override
  String toString(){
    return 'ID: $id, First Name: $fName, Last Name: $lName\n';
  }
}