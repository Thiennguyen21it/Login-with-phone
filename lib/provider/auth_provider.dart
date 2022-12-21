import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:phone_auths/Utils/util.dart';
import 'package:phone_auths/models/user_%20models.dart';
import 'package:phone_auths/screens/otp_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  bool _isSignIn = false;
  bool get isSignIn => _isSignIn;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _uid;
  String get uid => _uid!;
  UserModel? _userModel;
  UserModel get userModel => _userModel!;

  AuthProvider() {
    checkSignIn();
  }

  //check user sign in or not
  void checkSignIn() async {
    final SharedPreferences sf = await SharedPreferences.getInstance();
    _isSignIn = sf.getBool("is_SignIn") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences sf = await SharedPreferences.getInstance();
    sf.setBool("is_SignIn", true);
    _isSignIn = true;
    notifyListeners();
  }

  //function sign in with phone number
  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            await _firebaseAuth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (error) {
            throw Exception(error);
          },
          codeSent: (verificationId, forceResendingToken) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpScreen(verificationId: verificationId),
              ),
            );
          },
          codeAutoRetrievalTimeout: (verificationID) {});
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }

  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);
      User? user = (await _firebaseAuth.signInWithCredential(creds)).user!;

      // ignore: unnecessary_null_comparison
      if (user != null) {
        //carry out logic
        _uid = user.uid;
        onSuccess();
      }

      _isLoading = false;
    } on FirebaseException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  // DATABASE OPERTAIONS
  Future<bool> checkExistingUser() async {
    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection("users").doc(_uid).get();
    if (snapshot.exists) {
      // ignore: avoid_print
      print("USER EXISTS");
      return true;
    } else {
      // ignore: avoid_print
      print("NEW USER");
      return false;
    }
  }

  void saveUserDataToFirebase({
    required BuildContext context,
    required UserModel userModel,
    required File profilePic,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      //uploading image to fireabe storage
      await storeFileToStorage("ProfilePic/$_uid", profilePic).then((value) {
        userModel.profilePic = value;
        userModel.createdAt = DateTime.now().millisecondsSinceEpoch.toString();
        userModel.phoneNumber = _firebaseAuth.currentUser!.phoneNumber!;
        userModel.uid = _uid!;
      });
      _userModel = userModel;
      //uploading to database
      await _firebaseFirestore
          .collection("users")
          .doc(_uid)
          .set(userModel.toMap())
          .then((value) => onSuccess());
      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> storeFileToStorage(String ref, File file) async {
    UploadTask uploadTask = _firebaseStorage.ref(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future getDataFromFireStore() async {
    await _firebaseFirestore
        .collection("users")
        .doc(_firebaseAuth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      _userModel = UserModel(
        name: snapshot["name"],
        email: snapshot["email"],
        bio: snapshot["bio"],
        profilePic: snapshot["profilePic"],
        createdAt: snapshot["createdAt"],
        phoneNumber: snapshot["phoneNumber"],
        uid: snapshot["uid"],
      );
      _uid = _userModel!.uid;
    });
  }

  // save data to shared preferences
  Future saveUserDataSF() async {
    final SharedPreferences sf = await SharedPreferences.getInstance();
    await sf.setString("user_model", jsonEncode(userModel.toMap()));
  }

  Future getDataFromSF() async {
    final SharedPreferences sf = await SharedPreferences.getInstance();
    String data = sf.getString("user_model") ?? "";
    _userModel = UserModel.fromMap(jsonDecode(data));
    _uid = _userModel!.uid;
    notifyListeners();
  }

  //logout function
  Future userSignOut() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    await _firebaseAuth.signOut();
    _isSignIn = false;
    notifyListeners();
    sf.clear();
  }
}
