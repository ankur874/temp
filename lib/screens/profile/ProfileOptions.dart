import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starz/controllers/ProfileController.dart';

import 'Option.dart';

class ProfileOptions extends StatelessWidget {
  const ProfileOptions({super.key});

  @override
  Widget build(BuildContext context) {
    ProfileController profileController = Get.find();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Obx(
        () => Column(
          children: [
            Option(title: "Address", value: profileController.address.value),
            Option(
                title: "Description",
                value: profileController.description.value),
            Option(
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
          ],
        ),
      ),
    );
  }
}
