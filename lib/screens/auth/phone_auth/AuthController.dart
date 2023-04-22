import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:starz/config.dart';
import 'package:starz/screens/home/home_screen.dart';

class AuthController extends GetxController {
  // TextEditingController fullNameController = TextEditingController();
  // TextEditingController emailController = TextEditingController();
  // TextEditingController bioController = TextEditingController();
  // TextEditingController usernameController = TextEditingController();
  // TextEditingController passwordController = TextEditingController();
  // TextEditingController confirmPasswordController = TextEditingController();
  var isLoading = false.obs;
  var verificationId = "".obs;
  var phoneNumber = "".obs;
  var otpControllers = List.generate(6, (index) => TextEditingController());
  var fullName = "".obs;
  var email = "".obs;
  var bio = "".obs;
  var dataOfBirth = "".obs;
  var gender = "".obs;
  var username = "".obs;
  var password = "".obs;
  var user_id = "".obs;
  var prefs = GetStorage();

  FirebaseAuth auth = FirebaseAuth.instance;
  Future<bool> signUpWithPhoneNumber(String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
          print("singup complete");
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
          if (e.code == 'phone-already-in-use') {
            // The phone number is already registered
            Get.snackbar("Error", "Phone number already in use please sign-in");
            return;
          }
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
          }
        },
        codeSent: (String? verificationId, int? resendToken) async {
          this.verificationId.value = verificationId!;
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
      return true;
    } catch (err) {
      return false;
    }
  }

  void verifyOTP(String otp) async {
    try {
      var credential = await auth.signInWithCredential(
          PhoneAuthProvider.credential(
              verificationId: verificationId.value, smsCode: otp));
      // await Future.delayed(Duration(seconds: 5));
      user_id.value = credential.user?.uid ?? "";
      String temp = user_id.value.toString();
      await prefs.write('user_id', temp);
      print(prefs.read('user_id') + "------");
      // if (credential.additionalUserInfo!.isNewUser) {
      //   Get.offAll(NewUserScreen());
      // } else {
      //   Get.offAll(WelcomeBackScreen());
      // }
      FirebaseFirestore.instance
          .collection("accounts")
          .doc(AppConfig.phoneNoID)
          .set({"phoneNumber": phoneNumber.toString()});
      Get.offAll(HomeScreen());
    } catch (err) {
      Get.rawSnackbar(
          title: "Error",
          message: "Wrong OTP or expired, try again" + err.toString());
    }
    // isLoading.value = false;
  }

  // Future<void> addUserToFirestore({
  //   required String fullname,
  //   required String username,
  //   required String email,
  //   required String password,
  //   required String dateOfBirth,
  //   required String gender,
  //   required String bio,
  //   required String profilePhoto,
  // }) async {
  //   try {
  //     // Get a reference to the Firestore collection
  //     CollectionReference users =
  //         FirebaseFirestore.instance.collection('users');

  //     var id = prefs.read("user_id");
  //     // Add a new user to the collection
  //     await users.doc(id).set({
  //       'fullname': fullname,
  //       'username': username,
  //       'email': email,
  //       'password': password,
  //       'dateOfBirth': dateOfBirth,
  //       'gender': gender,
  //       'bio': bio,
  //       'profilePhoto': profilePhoto,
  //       'followers': [],
  //       'following': []
  //     });

  //     print('User added to Firestore successfully');
  //   } catch (e) {
  //     print('Error adding user to Firestore: $e');
  //   }
  // }
}
