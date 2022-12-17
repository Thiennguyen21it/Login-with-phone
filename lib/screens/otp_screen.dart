import 'package:flutter/material.dart';
import 'package:phone_auths/Utils/util.dart';
import 'package:phone_auths/provider/auth_provider.dart';
import 'package:phone_auths/screens/user_infor_screen.dart';
import 'package:phone_auths/widgets/custom_button.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  const OtpScreen({super.key, required this.verificationId});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? otpCode;
  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
      body: isLoading == true
          ? const Center(
              child: CircularProgressIndicator(color: Colors.purple),
            )
          : SingleChildScrollView(
              child: SafeArea(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 30),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop,
                            child: const Icon(Icons.arrow_back),
                          ),
                        ),
                        Container(
                          width: 200,
                          height: 200,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset("assets/image2.png"),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Verification",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Enter the OTP send to your phone number",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Pinput(
                          length: 6,
                          showCursor: true,
                          defaultPinTheme: PinTheme(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.purple.shade200),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onSubmitted: (value) {
                            setState(() {
                              otpCode = value;
                            });
                          },
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: CustomButton(
                            text: "verify",
                            onPressed: () {
                              if (otpCode != null) {
                                verifyOtp(context, otpCode!);
                              } else {
                                showSnackBar(context, "Enter 6-Digit code");
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Didn't receive any code",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black38,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Resend New Code",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[300],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  void verifyOtp(BuildContext context, String userOtp) {
    final app = Provider.of<AuthProvider>(context, listen: false);
    app.verifyOtp(
        context: context,
        verificationId: widget.verificationId,
        userOtp: userOtp,
        onSuccess: () {
          //checking if user exist in databse
          app.checkExistingUser().then((value) => {
                if (value == true)
                  {
                    // exist user in our app
                  }
                else
                  {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserInforPage()),
                        (route) => false)
                  }
              });
        });
  }
}