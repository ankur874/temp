import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:starz/screens/auth/phone_auth/AuthController.dart';
import 'package:starz/screens/auth/phone_auth/ColoredButton.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController controller = Get.find();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            )),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: const Text(
                "OTP sent",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: const Text(
                "Enter the otp sent to you",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Container(
              margin: EdgeInsets.all(30),
              child: Form(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      6,
                      (index) => Expanded(
                        // height: 68,
                        // width: 64,
                        child: Container(
                          margin: EdgeInsets.all(6),
                          child: TextField(
                            controller: controller.otpControllers[index],
                            onChanged: (value) {
                              if (value.length == 1 && index < 5) {
                                FocusScope.of(context).nextFocus();
                              } else if (value.isEmpty && index > 0) {
                                FocusScope.of(context).previousFocus();
                              }
                            },
                            decoration: const InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                      ),
                    )),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.44,
            ),
            GestureDetector(
                onTap: () {
                  String pin = "";
                  for (int i = 0; i < 6; i++) {
                    pin += controller.otpControllers[i].text;
                  }

                  for (int i = 0; i < 6; i++) {
                    controller.otpControllers[i].text = "";
                  }
                  controller.verifyOTP(pin);
                },
                child: const ColoredButton()),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an accouunt?",
                  style: TextStyle(fontSize: 15),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    " Sign-in",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
