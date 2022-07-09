import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future onGoogleSignIn() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
    _user = googleUser;
    print("googleUser");
    print(googleUser);
    final googleAuth = await googleUser.authentication;
    // // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // print("credential");
    // print(credential);
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  onGoogleLogout() async {
    googleSignIn.disconnect();
    googleSignIn.signOut();
    // await FirebaseAuth.instance.signOut().whenComplete(() => {
    //   print("Log Out COmplete"),
    // });
    // await FirebaseAuth.instance.signOut().then((value) => {
    //   print("value"),
    //
    // });
  }
}
