import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

bool? authSignedIn;
String? uid;
String? userEmail;

//FUNCTION FOR REGISTERING THE USER
Future<String?> registerWithEmailPassword(String email, String password) async {
  // Initialize Firebase
  await Firebase.initializeApp();
  try {
    final UserCredential userCredential =
        await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final User? user = userCredential.user;

    if (user != null) {
      uid = user.uid;
      userEmail = user.email;
      signInWithEmailPassword(email, password);
      return 'true';
    }
  } on FirebaseAuthException catch (e) {
    print('@@@@${e.message}');
    return '${e.message}';
  }
}

//FUNCTION FOR USER SIGN - IN && ADDED SHARED PREFERENCES
Future<String?> signInWithEmailPassword(String email, String password) async {
  // Initialize Firebase
  await Firebase.initializeApp();
  try {
    final UserCredential userCredential =
        await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final User? user = userCredential.user;

    if (user != null) {
      // checking if uid or email is null
      // assert(user.uid != null);
      assert(user.email != null);

      uid = user.uid;
      userEmail = user.email;

      assert(!user.isAnonymous);
      // assert(await user.getIdToken() != null);

      final User? currentUser = _auth.currentUser;
      assert(user.uid == currentUser?.uid);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('auth', true);

      // return 'Successfully logged in, User UID: ${user.uid}';
      return 'true';
    }
  } on FirebaseAuthException catch (e) {
    return '${e.message}';
  }
}
