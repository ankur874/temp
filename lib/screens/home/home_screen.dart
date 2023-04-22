import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:starz/screens/auth/login/login_page.dart';
import 'package:starz/screens/auth/phone_auth/authentication_screen.dart';
import 'package:starz/screens/privacy&policy/privacy_and_policy.dart';
import 'package:starz/screens/profile/my_profile.dart';

import 'components/contacts_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  static const id = "/";

  @override
  Widget build(BuildContext context) {
    final prefs = GetStorage();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Starz'),
        leading: IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FacebookAuth.i.logOut();
              prefs.remove("user_id");
              Get.offNamed(AuthenticationScreen.id);
            }),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(MyProfileScreen());
              },
              icon: const Icon(Icons.person_rounded)),
          IconButton(
            onPressed: () {
              Get.toNamed(PrivacyAndPolicyPage.id);
            },
            icon: const Icon(Icons.info),
          ),
        ],
      ),
      body: ContactsPage(),
    );
  }
}
