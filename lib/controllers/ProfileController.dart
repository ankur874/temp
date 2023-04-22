import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:starz/api/whatsapp_api.dart';
import 'package:http/http.dart' as http;
import 'package:starz/config.dart';
import 'package:starz/models/ProfileModel.dart';

class ProfileController extends GetxController {
  RxString about = "".obs;
  RxString address = "".obs;
  RxString description = "".obs;
  RxString email = "".obs;
  RxString profileURL = "".obs;
  RxList<String> websites = <String>[].obs;
  RxString businessType = "".obs;
  RxBool isLoading = false.obs;
  @override
  void onInit() {
    getUserProfile();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getUserProfile() async {
    try {
      isLoading.value = true;
      print("------------------hello-");
      var _headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${AppConfig.apiKey}"
      };
      var url =
          'https://graph.facebook.com/v15.0/${AppConfig.phoneNoID}/whatsapp_business_profile?fields=about,address,description,email,profile_picture_url,websites,vertical';

      var response = await http.get(Uri.parse(url), headers: _headers);
      ProfileModel profile = ProfileModel.fromJson(jsonDecode(response.body));
      print("-------------");
      print(profile.toJson());
      if (profile.data![0].about != null) about.value = profile.data![0].about!;
      if (profile.data![0].address != null)
        address.value = profile.data![0].address!;
      if (profile.data![0].description != null)
        description.value = profile.data![0].description!;
      if (profile.data![0].email != null) email.value = profile.data![0].email!;
      if (profile.data![0].profilePictureUrl != null)
        profileURL.value = profile.data![0].profilePictureUrl!;
      if (profile.data![0].websites != null)
        websites.value = profile.data![0].websites!;
      if (profile.data![0].vertical != null)
        businessType.value = profile.data![0].vertical!;
      isLoading.value = false;
      print("------------");
    } catch (e) {
      print(e);
    }
  }
}
