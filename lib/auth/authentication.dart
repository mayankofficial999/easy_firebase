import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {

  Future<FacebookLogin> signInWithFacebook() async {
    final fb = FacebookLogin();
    final res = await fb.logIn(permissions: [FacebookPermission.publicProfile, FacebookPermission.email,]);
    switch (res.status) {
      case FacebookLoginStatus.success:
        print("Facebook Log-In Successfull");
        // Logged in
        // Send this access token to server for validation and auth
        final accessToken = res.accessToken;
        print('Access Token: ${accessToken?.token}');
        // Get profile data
        final profile = await fb.getUserProfile();
        print('Hello, ${profile?.name}! You ID: ${profile?.userId}');
        // Get profile image url
        // Get user profile image url
        final imageUrl = await fb.getProfileImageUrl(width: 100);
        print('Your profile image: $imageUrl');
        // Get email (since we request email permission)
        final email = await fb.getUserEmail();
        // But user can decline permission
        if (email != null)
          print('And your email is $email');
        break;
      case FacebookLoginStatus.cancel:
        // User cancel log in
        break;
      case FacebookLoginStatus.error:
        // Log in failed
        print('Error while log in: ${res.error}');
        break;
    }
    return fb;
  }

  Future<GoogleSignInAccount?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    return googleUser;
  }

  Future<User?> signupMail(String a,String b) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: a,
      password:b
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e){
      print(e);
    }
  }

  Future<void> mailVerification() async{
      User? user = FirebaseAuth.instance.currentUser;
      if (user!= null && !user.emailVerified) {
        await user.sendEmailVerification().onError((error, stackTrace) {
          print(error);
        });
        print("User Verification Mail Sent");
        print(user.emailVerified);
      }
  }

  Future<User?> signInAnonymously() async {
    UserCredential userCredential= await FirebaseAuth.instance.signInAnonymously();
    print("Anonymous sign in succesfull");
    return FirebaseAuth.instance.currentUser;
  }

  Future<UserCredential> reauthenticate(mail,pass) async {
    // Prompt the user to enter their email and password
    String email = mail;
    String password = pass;

    // Create a credential
    AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);

    // Reauthenticate
    return await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(credential);
  }

  Future<User?> deleteUser(mail,pass) async {
    try {
      await reauthenticate(mail, pass);
      print("Reauthenticated");
      await FirebaseAuth.instance.currentUser!.delete();
      print("User Deleted Successfully");
      return FirebaseAuth.instance.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print('The user must reauthenticate before this operation can be executed.');
      }
    }
  }

  Future<User?> signinMail(String a,String b) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: a,
        password: b
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  Future<FirebaseAuth> otpLogin(String mobile, BuildContext context) async{

    FirebaseAuth _auth = FirebaseAuth.instance;
    final _codeController = TextEditingController();
    await _auth.verifyPhoneNumber(
      phoneNumber: mobile,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (AuthCredential authCredential) async{
        await _auth.signInWithCredential(authCredential)
        .catchError((e){
          print(e);
        });
      },
      verificationFailed: (FirebaseAuthException authException) {
        print(authException.message);
      },
      codeSent: (String verificationId, int? forceResendingToken){
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text("Enter SMS Code"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _codeController,
                ),

              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text("Done"),
                onPressed: () async {
                  FirebaseAuth auth = FirebaseAuth.instance;
                  var smsCode = _codeController.text.trim();
                  PhoneAuthCredential _credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
                  await auth.signInWithCredential(_credential)
                  .catchError((e){
                    print(e);
                  });
                  print("OTP Login Successful");
                },
              )
            ],
          )
        );
      },
      codeAutoRetrievalTimeout: (String verificationId){
        verificationId = verificationId;
        print(verificationId);
        print("Timout");
      }
    );
    return _auth;
  }

  Future<void> signOutEmail() async {
    await FirebaseAuth.instance.signOut();
    print('Email Account Logged out');
  }

  Future<void> signOutGoogle() async {
    await GoogleSignIn().signOut();
    print("Google Logged out");
  }

  Future<void> signOutFacebook() async {
    final fb = FacebookLogin();
    await fb.logOut();
    print("Facebook Logged out");
  }

  Future<void> signOut() async {
    await signOutEmail();
    await signOutGoogle();
    await signOutFacebook();
    print('Logged out of all accounts');
  }

}
