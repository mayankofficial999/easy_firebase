// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// A utility class to handle various authentication methods including
/// email, Google, Facebook, and anonymous sign-ins, as well as user management functions.
class Authentication {

  /// Signs in a user using their Facebook account.
  /// 
  /// This method requests public profile and email permissions, and handles the
  /// authentication flow for Facebook login. It prints the status, access token,
  /// user profile details, profile image URL, and email address if available.
  Future<FacebookLogin> signInWithFacebook() async {
    final fb = FacebookLogin();
    final res = await fb.logIn(permissions: [FacebookPermission.publicProfile, FacebookPermission.email,]);
    switch (res.status) {
      case FacebookLoginStatus.success:
        print("Facebook Log-In Successfull");
        final accessToken = res.accessToken;
        print('Access Token: ${accessToken?.token}');
        final profile = await fb.getUserProfile();
        print('Hello, ${profile?.name}! You ID: ${profile?.userId}');
        final imageUrl = await fb.getProfileImageUrl(width: 100);
        print('Your profile image: $imageUrl');
        final email = await fb.getUserEmail();
        if (email != null) {
          print('And your email is $email');
        }
        break;
      case FacebookLoginStatus.cancel:
        break;
      case FacebookLoginStatus.error:
        print('Error while log in: ${res.error}');
        break;
    }
    return fb;
  }

  /// Signs in a user using their Google account.
  /// 
  /// Initiates a Google sign-in process, retrieves authentication details, and
  /// signs the user in with those credentials. Returns the [GoogleSignInAccount]
  /// for the signed-in user.
  Future<GoogleSignInAccount?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
    return googleUser;
  }

  /// Registers a new user with an email and password.
  /// 
  /// On successful registration, returns the [User] object for the registered user.
  /// Prints any errors encountered during the sign-up process.
  Future<User?> signupMail(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e){
      print(e);
    }
    return null;
  }

  /// Sends an email verification to the current user.
  ///
  /// Only sends the email if the user's email has not been verified yet.
  /// Handles any errors that occur during the process.
  Future<void> mailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification().onError((error, stackTrace) {
        print(error);
      });
      print("User Verification Mail Sent");
      print(user.emailVerified);
    }
  }

  /// Signs in a user anonymously.
  ///
  /// Returns the [User] object for the anonymously signed-in user.
  Future<User?> signInAnonymously() async {
    UserCredential userCredential= await FirebaseAuth.instance.signInAnonymously();
    print("Anonymous sign in succesfull");
    return userCredential.user;
  }

  /// Re-authenticates the current user with their email and password.
  ///
  /// Necessary before performing sensitive operations such as deleting an account.
  Future<UserCredential> reauthenticate(String email, String password) async {
    AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
    return await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(credential);
  }

  /// Deletes the current user after re-authentication.
  ///
  /// Returns the [User] object if the deletion is not completed, usually due to
  /// failed re-authentication.
  Future<User?> deleteUser(String email, String password) async {
    try {
      await reauthenticate(email, password);
      print("Reauthenticated");
      await FirebaseAuth.instance.currentUser!.delete();
      print("User Deleted Successfully");
      return FirebaseAuth.instance.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print('The user must reauthenticate before this operation can be executed.');
      }
    }
    return null;
  }

  /// Signs in a user using an email and password.
  ///
  /// On successful sign-in, returns the [User] object for the user. Prints any errors encountered.
  Future<User?> signinMail(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    return null;
  }

  /// Initiates a phone number authentication using OTP.
  ///
  /// Displays a dialog for the user to enter the SMS code sent to their phone.
  /// Handles the completion, failure, and timeout of the OTP verification process.
  Future<FirebaseAuth> otpLogin(String mobile, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    final _codeController = TextEditingController();
    await _auth.verifyPhoneNumber(
      phoneNumber: mobile,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (AuthCredential authCredential) async {
        await _auth.signInWithCredential(authCredential);
      },
      verificationFailed: (FirebaseAuthException authException) {
        print(authException.message);
      },
      codeSent: (String verificationId, int? forceResendingToken) {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => AlertDialog(
            title: const Text("Enter SMS Code"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(controller: _codeController),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text("Done"),
                onPressed: () async {
                  FirebaseAuth auth = FirebaseAuth.instance;
                  var smsCode = _codeController.text.trim();
                  PhoneAuthCredential _credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
                  await auth.signInWithCredential(_credential);
                  print("OTP Login Successful");
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("OTP Login Successful")));
                },
              )
            ],
          )
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        verificationId = verificationId;
        print("Timout");
      }
    );
    return _auth;
  }

  /// Signs out the current user from their email account.
  Future<void> signOutEmail() async {
    await FirebaseAuth.instance.signOut();
    print('Email Account Logged out');
  }

  /// Signs out the current user from their Google account.
  Future<void> signOutGoogle() async {
    await GoogleSignIn().signOut();
    print("Google Logged out");
  }

  /// Signs out the current user from their Facebook account.
  Future<void> signOutFacebook() async {
    final fb = FacebookLogin();
    await fb.logOut();
    print("Facebook Logged out");
  }

  /// Signs out the current user from all accounts: email, Google, and Facebook.
  Future<void> signOut() async {
    await signOutEmail();
    await signOutGoogle();
    await signOutFacebook();
    print('Logged out of all accounts');
  }

}
