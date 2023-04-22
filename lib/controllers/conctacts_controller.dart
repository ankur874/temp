import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:starz/api/whatsapp_api.dart';
import 'package:starz/config.dart';

class ConctactsController extends GetxController {
  RxList<Contact> contacts = <Contact>[].obs;
  RxList<Contact> filteredContacts = <Contact>[].obs;
  TextEditingController searchQuery = TextEditingController();
  WhatsAppApi whatsapp = WhatsAppApi();

  @override
  void onInit() {
    super.onInit();
    getInitialContacts();
    whatsapp.setup(
        accessToken: AppConfig.apiKey,
        fromNumberId: int.parse(AppConfig.phoneNoID));
  }

  @override
  void dispose() {
    searchQuery.dispose();
    super.dispose();
  }

  Future<void> getInitialContacts() async {
    if (await FlutterContacts.requestPermission()) {
      contacts.value = await FlutterContacts.getContacts(withProperties: true);
      filteredContacts.value = contacts.value;
      contacts.refresh();
      filteredContacts.refresh();
    }
  }

  void updateFilteredContacts() {
    filteredContacts.value = [];
    if (isNumeric(searchQuery.text)) {
      filteredContacts.value = [];
      for (int i = 0; i < contacts.length; i++) {
        if (contacts[i].phones.length != 0) {
          if (contacts[i].phones.first.number.contains(searchQuery.text)) {
            filteredContacts.add(contacts[i]);
          }
        }
      }
      return;
    }
    filteredContacts.value = contacts
        .where((contact) =>
            contact.name.first
                .toLowerCase()
                .contains(searchQuery.text.toLowerCase()) ||
            contact.name.last
                .toLowerCase()
                .contains(searchQuery.text.toLowerCase()))
        .toList();
  }
}

bool isNumeric(String s) {
  bool isValue = double.tryParse(s) != null;
  print(isValue);
  return isValue;
}
