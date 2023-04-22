import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starz/config.dart';
import 'package:starz/controllers/ProfileController.dart';

import 'Option.dart';

class ProfileOptions extends StatelessWidget {
  const ProfileOptions({super.key});

  @override
  Widget build(BuildContext context) {
    // DocumentSnapshot curr =  FirebaseFirestore.instance
    //     .collection("accounts")
    //     .doc(AppConfig.phoneNoID).get();
    ProfileController profileController = Get.find();
    profileController.getPhoneNumber(AppConfig.phoneNoID);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Obx(
        () => Column(
          children: [
            profileController.address.value.isEmpty
                ? SizedBox()
                : Option(
                    title: "Address", value: profileController.address.value),
            profileController.description.value.isEmpty
                ? SizedBox()
                : Option(
                    title: "Description",
                    value: profileController.description.value),
            profileController.businessType.value.isEmpty
                ? SizedBox()
                : Option(
                    title: "Business Type",
                    value: profileController.businessType.value),
            ListView.builder(
              shrinkWrap: true,
              itemCount: profileController.websites.length,
              itemBuilder: (context, index) {
                return Option(
                    title: "Website ${index + 1}",
                    value: profileController.websites[index]);
              },
            ),
            profileController.phoneNumber.value.isEmpty
                ? SizedBox()
                : Option(
                    title: "Phone number",
                    value: profileController.phoneNumber.value)
          ],
        ),
      ),
    );
  }
}
