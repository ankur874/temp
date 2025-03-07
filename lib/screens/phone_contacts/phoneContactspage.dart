import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:get/get.dart';
import 'package:starz/api/api_service.dart';
import 'package:starz/api/whatsapp_api.dart';
import 'package:starz/controllers/conctacts_controller.dart';
import 'package:sizer/sizer.dart';

import '../../config.dart';

class PhoneContactsPage extends GetView<ConctactsController> {
  PhoneContactsPage({super.key});

  static const id = "/phone_contacts";
  bool fromChat = Get.arguments['fromChat'];
  int? to = Get.arguments['to'];
  WhatsAppApi? whatsApp = Get.arguments['whatsAppApi'];
  String? swipedMessageId = Get.arguments['swipedMessageId'];

  sendContact(message, fullName) async {
    if (to != null) {
      var value;
      if (swipedMessageId == null) {
        value = await whatsApp?.messagesContacts(
            to: to, phoneNumber: message, fullName: fullName);
      } else {
        value = await whatsApp?.messagesContactsReply(
            to: to,
            phoneNumber: message,
            fullName: fullName,
            messageId: swipedMessageId);
      }

      Map<String, dynamic> firestoreObject = {};

      if (swipedMessageId == null) {
        firestoreObject = {
          "from": AppConfig.phoneNoID,
          "id": value['messages'][0]['id'],
          "contacts": [
            {
              'name': {'first_name': fullName, 'formatted_name': fullName},
              'phones': [
                {'phone': message, 'type': 'Mobile'}
              ],
            }
          ],
          "type": "contacts",
          "timestamp": DateTime.now()
        };
      } else {
        firestoreObject = {
          "from": AppConfig.phoneNoID,
          "id": value['messages'][0]['id'],
          "context": {'from': AppConfig.phoneNoID, "id": swipedMessageId},
          "contacts": [
            {
              'name': {'first_name': fullName, 'formatted_name': fullName},
              'phones': [
                {'phone': message, 'type': 'Mobile'}
              ],
            }
          ],
          "type": "contacts",
          "timestamp": DateTime.now()
        };
      }

      await FirebaseFirestore.instance
          .collection("accounts")
          .doc(AppConfig.WABAID)
          .collection("discussion")
          .doc(to.toString())
          .collection("messages")
          .add(firestoreObject);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent.shade200,
          title: const Text("My contacts")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: const InputDecoration(
                  hintText: "Search...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder()),
              controller: controller.searchQuery,
              onChanged: (value) {
                print(value);
                controller.updateFilteredContacts();
              },
            ),
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: controller.filteredContacts.length,
                itemBuilder: (context, index) {
                  Contact currentContact = controller.filteredContacts[index];
                  // print(currentContact);
                  return Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          await Get.defaultDialog(
                            radius: 10,
                            title: fromChat ? "Send Contact?" : "Add contact?",
                            middleText: fromChat
                                ? "Would you like to share the following number : ${currentContact.phones.first.number.removeAllWhitespace}"
                                : "Would you like to add the following number : ${currentContact.phones.first.number.removeAllWhitespace}",
                            confirm: GestureDetector(
                                onTap: () async {
                                  int to = 0;
                                  if (currentContact
                                      .phones.first.number.removeAllWhitespace
                                      .startsWith("+")) {
                                    to = int.parse(currentContact
                                        .phones.first.number.removeAllWhitespace
                                        .substring(1));
                                  } else {
                                    to = int.parse(
                                        "91${currentContact.phones.first.number.removeAllWhitespace}");
                                  }

                                  if (fromChat) {
                                    sendContact('+$to',
                                        "${currentContact.name.first} ${currentContact.name.last}");
                                  } else {
                                    await controller.whatsapp.messagesTemplate(
                                        templateName: "hello_world", to: to);
                                  }
                                  Get.back();
                                  Get.showSnackbar(const GetSnackBar(
                                    duration: Duration(seconds: 2),
                                    messageText: Text(
                                      "Message Sent",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  color: Colors.deepPurpleAccent[200],
                                  width: double.infinity,
                                  child: Center(
                                      child: Text(
                                    "Yes",
                                    style: TextStyle(color: Colors.white),
                                  )),
                                )),
                            cancel: OutlinedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  // decoration: BoxDecoration(
                                  //     border: Border.all(width: 1)),

                                  width: double.infinity,
                                  child: Center(
                                      child: Text(
                                    "No",
                                    style: TextStyle(
                                      color: Colors.deepPurpleAccent[200],
                                    ),
                                  )),
                                )),
                          );
                        },
                        child: ListTile(
                          title: Text(
                              "${currentContact.name.first} ${currentContact.name.last}"),
                          subtitle: currentContact.phones.length == 0
                              ? Text("No number added")
                              : Text(currentContact.phones.first.number),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: const Divider(
                          thickness: 1,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
