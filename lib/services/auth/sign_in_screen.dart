import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hackathon_project/Widgets/auth_button.dart';
import 'package:hackathon_project/Widgets/text_field_widget.dart';
import 'package:hackathon_project/components/social_list.dart';
import 'package:hackathon_project/services/auth/auth_service.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key, this.onTap});
  final Function()? onTap;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

TextEditingController email = TextEditingController();
TextEditingController pass = TextEditingController();

void login(BuildContext context) async {
  //get instance
  final authService = AuthService();

  //try sign in
  try {
    await authService.signInWithEmailPassword(email.text, pass.text);
  } //dsiplay any error
  catch (e) {
    showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => AlertDialog(
              title: Text(e.toString()),
            ));
  }
}

bool isVisible = true;

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 80,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: WelcomeText(
                welcome: 'Welcome back! Glad\nto see you, Again',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFieldWidget(
              label: 'Enter your email',
              obsecure: false,
              controller: email,
            ),
            TextFieldWidget(
              obsecure: isVisible,
              label: 'Enter your password',
              icon: GestureDetector(
                  onTap: () {
                    setState(() {
                      isVisible = !isVisible;
                    });
                  },
                  child: FaIcon(isVisible
                      ? FontAwesomeIcons.eyeSlash
                      : FontAwesomeIcons.eye)),
              controller: pass,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15.0, top: 5),
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            AuthButton(
              text: 'Login',
              onTap: () {
                login(context);
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
                      'or Login with',
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
                        BoxShadow(
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
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don’t have an account?',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    'Register Now',
                    style: TextStyle(
                        color: Color(0xff35C2C1),
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WelcomeText extends StatelessWidget {
  const WelcomeText({
    super.key,
    required this.welcome,
  });
  final String welcome;
  @override
  Widget build(BuildContext context) {
    return Text(
      welcome,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28, height: 1.3),
    );
  }
}
