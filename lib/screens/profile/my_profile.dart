import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:starz/controllers/ProfileController.dart';
import 'package:starz/screens/profile/ProfileOptions.dart';
import 'package:starz/screens/profile/profile_header.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ProfileController profileController = Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => profileController.isLoading.value == true
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    const SizedBox(
                      height: 35,
                    ),
                    ProfileHeader(
                        image: profileController.profileURL.value,
                        email: profileController.email.value,
                        name: profileController.about.value),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      height: 1,
                      color: Colors.black.withOpacity(0.1),
                    ),
                    ProfileOptions()
                  ],
                ),
        ),
      ),
    );
  }
}
