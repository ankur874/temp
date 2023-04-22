import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:starz/controllers/conctacts_controller.dart';
import 'package:starz/firebase_options.dart';
import 'package:get/get.dart';
import 'package:starz/screens/auth/login/login_page.dart';
import 'package:starz/screens/auth/login/otp/otp_login_page.dart';
import 'package:starz/screens/auth/phone_auth/authentication_screen.dart';

import 'package:starz/screens/chat/chat_page.dart';
import 'package:starz/screens/privacy&policy/privacy_and_policy.dart';
import 'package:starz/screens/video_player/video_player_screen.dart';
import 'package:starz/screens/home/home_screen.dart';
import 'package:starz/screens/page_chooser/page_chooser.dart';
import 'package:starz/screens/phone_contacts/phoneContactspage.dart';
import 'screens/register/register_screen.dart';

Widget _defaultHome = const RegisterScreen();

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prefs = GetStorage();
    var userId = prefs.read('user_id');
    print(userId.toString());
    return Sizer(
      builder: (context, orientation, devicetype) => GetMaterialApp(
        initialRoute: AuthenticationScreen.id,
        debugShowCheckedModeBanner: false,
        title: 'Starz App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        //home: const RegisterPage(),
        getPages: [
          GetPage(
              name: AuthenticationScreen.id,
              page: () => AuthenticationScreen()),
          GetPage(name: HomeScreen.id, page: () => HomeScreen()),
          GetPage(name: RegisterScreen.id, page: () => RegisterScreen()),
          GetPage(name: ChatPage.id, page: () => ChatPage()),
          GetPage(name: LoginPage.id, page: () => LoginPage()),
          GetPage(name: PageChooser.id, page: () => PageChooser()),
          GetPage(name: PhoneContactsPage.id, page: () => PhoneContactsPage()),
          GetPage(name: VideoPlayerScreen.id, page: () => VideoPlayerScreen()),
          GetPage(
              name: PrivacyAndPolicyPage.id,
              page: () => PrivacyAndPolicyPage()),
          GetPage(name: OtpLoginPage.id, page: () => OtpLoginPage()),
        ],
        initialBinding: BindingsBuilder(() {
          Get.lazyPut(() => ConctactsController(), fenix: true);
        }),
      ),
    );
  }
}

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Create a stream to listen for changes in authentication state
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Send an OTP code to the user's phone number
  Future<void> sendOtp(String phoneNumber) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _firebaseAuth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        // Navigate to the OTP verification page
        Get.toNamed(OtpLoginPage.id, arguments: {
          'verificationId': verificationId,
          'phoneNumber': phoneNumber,
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  // Verify the OTP code entered by the user
}
