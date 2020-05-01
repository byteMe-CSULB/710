import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
FirebaseUser firebaseUser;

String name;
String email;
String imageUrl;
bool signedIn = false;

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  // Checking if email and name is null
  assert(user.email != null);
  assert(user.displayName != null);
  assert(user.photoUrl != null);

  name = user.displayName;
  email = user.email;
  imageUrl = user.photoUrl;

  // Only taking the first part of the name, i.e., First Name
  if (name.contains(" ")) {
    name = name.substring(0, name.indexOf(" "));
  }

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);
  signedIn = true;
  sharedLoginStatus(signedIn);
  firebaseUser = currentUser;
  addToDatabase(currentUser);
  return 'signInWithGoogle succeeded: $user';
}

Future sharedLoginStatus(bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('signedIn', value);
  if(value) {
    await prefs.setString('gName', name);
    await prefs.setString('gEmail', email);
    await prefs.setString('gImage', imageUrl);
  } else {
    prefs?.clear();
  }
}

void addToDatabase(FirebaseUser currentUser) async {
  var query = 
    await Firestore.instance.collection('userData').where('uuid', isEqualTo: currentUser.uid).getDocuments();
  if(query.documents.length == 0) {        
    await Firestore.instance.collection('userData').document(currentUser.email).setData({
      'uuid' : currentUser.uid
    });
  }
}

void signOutGoogle() async {
  await googleSignIn.signOut();
  signedIn = false;
  sharedLoginStatus(signedIn);
  print("User Sign Out");
}