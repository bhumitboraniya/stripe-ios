import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripe_payment_flutter/payment.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

File? _image;

class _HomePageState extends State<HomePage> {
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  TextEditingController amountController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();

  final formkey1 = GlobalKey<FormState>();
  final formkey2 = GlobalKey<FormState>();
  final formkey3 = GlobalKey<FormState>();
  final formkey4 = GlobalKey<FormState>();
  final formkey5 = GlobalKey<FormState>();
  final formkey6 = GlobalKey<FormState>();
  final formkey7 = GlobalKey<FormState>();
  final formkey8 = GlobalKey<FormState>();

  String selectedCurrency = 'USD';

  bool hasDonated = false;
  String? selectedAmount;

  Future<void> initPaymentSheet() async {
    try {
      // 1. create payment intent on the client side by calling stripe api
      final data = await createPaymentIntent(
          // convert string to double
          amount: (int.parse(amountController.text) * 100).toString(),
          currency: selectedCurrency,
          name: nameController.text,
          email: emailController.text,
          phone: phoneController.text,
          address: addressController.text,
          pin: pincodeController.text,
          city: cityController.text,
          state: stateController.text,
          country: countryController.text);

      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Set to true for custom flow
          customFlow: false,
          // Main params
          merchantDisplayName: 'Test Merchant',
          paymentIntentClientSecret: data['client_secret'],
          // Customer keys
          customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: data['id'],

          style: ThemeMode.dark,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }

  Future<void> sendEmail({
    required String recipientEmail,
    required String subject,
    required String body,
  }) async {
    String username = 'ihmcorp2@gmail.com';

    String password = 'mvke mhsx oqnq zrok';

    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = 'ihmcorp2@gmail.com'
      ..recipients.add(recipientEmail)
      ..subject = subject
      ..text = body;

    try {
      setState(() {
        hasDonated = true;
      });
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email sent successfully')),
      );
    } on MailerException catch (e) {
      print('Message not sent. ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send email: $e')),
      );
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Future uploadPic(BuildContext context) async {
      String fileName =
          "image1_${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
      // Get a reference to the Firebase Storage instance and specify the file path
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child(fileName);
      File imag = _image as File;
      // Start the file upload task
      UploadTask uploadTask = ref.putFile(imag);

      // Wait for the upload task to complete and get the snapshot
      TaskSnapshot taskSnapshot = await uploadTask;

      // Get the download URL of the uploaded file
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      // Update the UI after the upload is complete
      setState(() {
        print("Profile Picture uploaded: $downloadURL");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
      });
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image(
              image: AssetImage("assets/blogo.png"),
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            hasDonated
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your ${amountController.text} $selectedCurrency received, check your mail",
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          "We appreciate your support",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent.shade400),
                            child: Text(
                              "Buy another course?",
                              style: TextStyle(
                                  color: Colors.white,
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            onPressed: () {
                              setState(() {
                                hasDonated = false;
                                amountController.clear();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Payment Portal",
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Column(
                            children: [
                              Container(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  "Select the amount",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              CustomRadioButton(
                                description:
                                    'This course tradeline is 100\$ per month for 24 months. For module 1',
                                title: '3000\$',
                                value: '3000',
                                groupValue: selectedAmount,
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedAmount = value;
                                    amountController.text = value!;
                                  });
                                },
                              ),
                              CustomRadioButton(
                                description:
                                    'This course tradeline is 125\$ per month for 24 months. For module 1 and 2',
                                title: '5000\$ ',
                                value: '5000',
                                groupValue: selectedAmount,
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedAmount = value;
                                    amountController.text = value!;
                                  });
                                },
                              ),
                              CustomRadioButton(
                                description:
                                    'This course tradeline is 150\$ per month for 24 months. For module 1 thru 3',
                                title: '7000\$',
                                value: '7000',
                                groupValue: selectedAmount,
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedAmount = value;
                                    amountController.text = value!;
                                  });
                                },
                              ),
                              CustomRadioButton(
                                description:
                                    'This course tradeline is 200\$ per month for 24 months. For module 1 thru 4',
                                title: '8000\$ ',
                                value: '8000',
                                groupValue: selectedAmount,
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedAmount = value;
                                    amountController.text = value!;
                                  });
                                },
                              ),
                              CustomRadioButton(
                                description:
                                    'This course tradeline is 225\$ per month for 24 months. For module 1 thru 5',
                                title: '9000\$ ',
                                value: '9000',
                                groupValue: selectedAmount,
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedAmount = value;
                                    amountController.text = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                            formkey: formkey1,
                            title: "Name",
                            hint: "Ex. John Doe",
                            controller: nameController,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                            formkey: formkey7,
                            title: "Email",
                            hint: "Ex. john.doe@example.com",
                            controller: emailController,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                            formkey: formkey8,
                            title: "Phone",
                            hint: "Ex. +1234567890",
                            controller: phoneController,
                            isNumber: true,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                            formkey: formkey2,
                            title: "Address Line",
                            hint: "Ex. 123 Main St",
                            controller: addressController,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  flex: 5,
                                  child: CustomTextField(
                                    formkey: formkey3,
                                    title: "City",
                                    hint: "Ex. New Delhi",
                                    controller: cityController,
                                  )),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  flex: 5,
                                  child: CustomTextField(
                                    formkey: formkey4,
                                    title: "State (Short code)",
                                    hint: "Ex. DL for Delhi",
                                    controller: stateController,
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  flex: 5,
                                  child: CustomTextField(
                                    formkey: formkey5,
                                    title: "Country (Short Code)",
                                    hint: "Ex. IN for India",
                                    controller: countryController,
                                  )),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  flex: 5,
                                  child: CustomTextField(
                                    formkey: formkey6,
                                    title: "Pincode",
                                    hint: "Ex. 123456",
                                    controller: pincodeController,
                                    isNumber: true,
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Column(
                            children: [
                              _image == null
                                  ? Text('No image selected.')
                                  : Image.file(_image!, height: 150),
                              SizedBox(
                                height: 12,
                              ),
                              SizedBox(
                                height: 50,
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.blueAccent.shade400),
                                  child: Text(
                                    "Upload Identity Photo",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  onPressed: pickImage,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent.shade400),
                              child: Text(
                                "Proceed to Pay",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              onPressed: () async {
                                if (formkey1.currentState!.validate() &&
                                    formkey2.currentState!.validate() &&
                                    formkey3.currentState!.validate() &&
                                    formkey4.currentState!.validate() &&
                                    formkey5.currentState!.validate() &&
                                    formkey6.currentState!.validate() &&
                                    formkey7.currentState!.validate() &&
                                    formkey8.currentState!.validate()) {
                                  await initPaymentSheet();
                                  uploadPic(context);

                                  try {
                                    await Stripe.instance.presentPaymentSheet();

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                        "Payment Done",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.green,
                                    ));
                                    setState(() {
                                      hasDonated = true;
                                    });

                                    if (amountController.text == '3000') {
                                      await sendEmail(
                                        recipientEmail: emailController.text,
                                        subject: 'Payment Successful',
                                        body:
                                            'Your 3000 USD Course Link: https://docs.google.com/document/d/1iVGmkFvPBhLTRWnBEh0IvfwCL49EaTO08xbmbVmOQng/edit#heading=h.i62jtgc0tm5a',
                                      );
                                    }

                                    if (amountController.text == '5000') {
                                      await sendEmail(
                                        recipientEmail: emailController.text,
                                        subject: 'Payment Successful',
                                        body:
                                            'Your 5000 USD Course Link: https://docs.google.com/document/d/1qaK4Ap5v7Ff0SgMj7Oao2Z8f8Tlb0VIsl04SnVxXbA8/edit#heading=h.i62jtgc0tm5a',
                                      );
                                    }

                                    if (amountController.text == '7000') {
                                      await sendEmail(
                                        recipientEmail: emailController.text,
                                        subject: 'Payment Successful',
                                        body:
                                            'Your 7000 USD Course Link: https://docs.google.com/document/d/1YOeHA2GRCuLNCSgQx0HSozF6uP_luTpKrraN37S1KQU/edit#heading=h.i62jtgc0tm5a',
                                      );
                                    }

                                    if (amountController.text == '8000') {
                                      await sendEmail(
                                        recipientEmail: emailController.text,
                                        subject: 'Payment Successful',
                                        body:
                                            'Your 8000 USD Course Link: https://docs.google.com/document/d/1NjpkQh7vcQZLTR1HfTHPw4_8Uc3li350R682MDQFUHc/edit#heading=h.i62jtgc0tm5a',
                                      );
                                    }

                                    if (amountController.text == '9000') {
                                      await sendEmail(
                                        recipientEmail: emailController.text,
                                        subject: 'Payment Successful',
                                        body:
                                            'Your 9000 USD Course Link: https://docs.google.com/document/d/1SYmt5ZotVl0rI_10AGAWxc3zGEP5tgykUqByR3t6p8s/edit#heading=h.i62jtgc0tm5a',
                                      );
                                    }

                                    setState(
                                      () {
                                        hasDonated = true;
                                        CollectionReference collRef =
                                            FirebaseFirestore.instance
                                                .collection('client');
                                        collRef.add({
                                          'name': nameController.text,
                                          'email': emailController.text,
                                          'mobile': phoneController.text,
                                        });
                                      },
                                    );

                                    amountController.clear();
                                    nameController.clear();
                                    emailController.clear();
                                    phoneController.clear();
                                    addressController.clear();
                                    cityController.clear();
                                    stateController.clear();
                                    _image = null;
                                    countryController.clear();
                                    pincodeController.clear();
                                  } catch (e) {
                                    print("payment sheet failed");
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                        "Payment Failed",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.redAccent,
                                    ));
                                  }
                                }
                              },
                            ),
                          )
                        ])),
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final GlobalKey<FormState> formkey;
  final TextEditingController controller;
  final String title;
  final String hint;
  final bool isNumber;
  final bool isEmail; // added email validation flag

  CustomTextField({
    required this.formkey,
    required this.controller,
    required this.title,
    required this.hint,
    this.isNumber = false,
    this.isEmail = false,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formkey,
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: title,
          labelStyle: TextStyle(fontSize: 18),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $title';
          }
          if (isEmail) {
            final emailRegExp =
                RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
            if (!emailRegExp.hasMatch(value)) {
              return 'Please enter a valid email address';
            }
          }
          return null;
        },
      ),
    );
  }
}

class CustomRadioButton extends StatelessWidget {
  final String title;
  final String description;
  final String value;
  final String? groupValue;
  final Function(String?) onChanged;

  CustomRadioButton({
    required this.title,
    required this.description,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(
          color: groupValue == value ? Colors.blue : Colors.grey,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(title, style: TextStyle(fontSize: 15)),
        subtitle: Text(
          description,
          style: TextStyle(fontSize: 13),
        ),
        leading: Radio<String>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
