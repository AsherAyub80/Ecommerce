import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hackathon_project/Widgets/auth_button.dart';
import 'package:hackathon_project/Widgets/text_field_widget.dart';
import 'package:hackathon_project/components/social_list.dart';
import 'package:hackathon_project/services/auth/auth_service.dart';
import 'package:hackathon_project/services/auth/sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, this.onTap});
  final Function()? onTap;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

CollectionReference users = FirebaseFirestore.instance.collection('users');

TextEditingController email = TextEditingController();
TextEditingController pass = TextEditingController();
TextEditingController name = TextEditingController();
TextEditingController confirmPass = TextEditingController();

bool isConfrim = true;
bool isPassword = true;

void signUp(BuildContext context) async {
  final authService = AuthService();
  try {
    if (pass.text == confirmPass.text) {
      if (name.text.isNotEmpty) {
        await authService.signUpWithEmailPassword(
            email.text, pass.text, name.text);
        email.clear();
        pass.clear();
        name.clear();
        confirmPass.clear();

        showDialog(
          context: context,
          builder: (context) => const CircularProgressIndicator(),
          barrierDismissible: false,
        );
        Navigator.of(context).pop;
      } else {
        showDialog(
            context: context,
            builder: (context) => const AlertDialog(
                  title: Text("Error"),
                  content: Text("Please enter user name"),
                ));
      }
    } else {
      Navigator.of(context).pop;
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                title: Text("Invallid Credinential"),
                content: Text("Password don't match"),
              ));
    }
  } catch (e) {
    print(e);
  }
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  void dispose() {
    super.dispose();
    email.dispose();
    name.dispose();
    pass.dispose();
    confirmPass.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 80,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: WelcomeText(
                welcome: 'Hello! Register to get\nstarted',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFieldWidget(
              obsecure: false,
              label: 'User name',
              controller: name,
            ),
            TextFieldWidget(
              obsecure: false,
              controller: email,
              label: 'Enter your email',
            ),
            TextFieldWidget(
              controller: pass,
              label: 'Enter your password',
              obsecure: isPassword,
              icon: GestureDetector(
                  onTap: () {
                    setState(() {
                      isPassword = !isPassword;
                    });
                  },
                  child: FaIcon(isPassword
                      ? FontAwesomeIcons.eyeSlash
                      : FontAwesomeIcons.eye)),
            ),
            TextFieldWidget(
              controller: confirmPass,
              icon: GestureDetector(
                  onTap: () {
                    setState(() {
                      isConfrim = !isConfrim;
                    });
                  },
                  child: FaIcon(isConfrim
                      ? FontAwesomeIcons.eyeSlash
                      : FontAwesomeIcons.eye)),
              obsecure: isConfrim,
              label: 'Confirm your password',
            ),
            const SizedBox(
              height: 30,
            ),
            AuthButton(
              text: 'Sign Up',
              onTap: () {
                signUp(context);
              },
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child:
                          Divider(thickness: 1, color: Colors.grey.shade300)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'or Sign up with',
                      style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                      child:
                          Divider(thickness: 1, color: Colors.grey.shade300)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(social.length, (index) {
                  return Container(
                    height: 70,
                    width: 100,
                    decoration: BoxDecoration(
                      boxShadow: [
                        const BoxShadow(
                          blurRadius: 1.5,
                          blurStyle: BlurStyle.outer,
                          color: Colors.grey,
                        )
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: social[index],
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account?',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: const Text(
                    'Sign in Now',
                    style: TextStyle(
                        color: Color(0xff35C2C1),
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
