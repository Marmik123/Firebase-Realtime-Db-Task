import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rootally_task/app/components/circular_loader.dart';
import 'package:rootally_task/app/components/snackbar.dart';
import 'package:rootally_task/app/components/textfield.dart';
import 'package:rootally_task/app/utils/authentication.dart';
import 'package:rootally_task/app/view/home_screen.dart';

class EmailLogin extends StatefulWidget {
  const EmailLogin({Key? key}) : super(key: key);

  @override
  State<EmailLogin> createState() => _EmailLoginState();
}

class _EmailLoginState extends State<EmailLogin> {
  GlobalKey<FormState> loginKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  bool hidePassword = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: ListView(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
        physics: const NeverScrollableScrollPhysics(),
        // mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.5,
              padding: const EdgeInsets.only(
                left: 30,
                right: 30,
              ),
              child: Form(
                key: loginKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 6,
                      height: MediaQuery.of(context).size.height / 12,
                      child: Image.asset('assets/images/img.png'),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text(
                          'Sign in ',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Icon(Icons.login_sharp),
                      ],
                    ),
                    //COMMON TEXT FIELD WITH SAME STYLE FORMATTING.
                    textfield(
                      ctrl: email,
                      passwordCheck: false,
                      hintText: 'Email Address',
                      errorMsg: 'Please enter a valid Email id',
                      applyRegExp: true,
                      regExpPattern: RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"),
                    ),
                    textfield(
                      ctrl: password,
                      hintText: 'Password',
                      passwordCheck: true,
                      errorMsg: 'Length must be greater than 6',
                      obscureText: hidePassword,
                      applyRegExp: false,
                      suffixIcon: IconButton(
                        padding: EdgeInsets.zero,
                        color: Colors.grey,
                        onPressed: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                        icon: hidePassword
                            ? const Icon(Icons.visibility_off_rounded)
                            : const Icon(Icons.visibility_rounded),
                      ),
                    ),
                    const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Color(0xff9D9C9B),
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 30.0,
              right: 30.0,
              top: 30,
            ),
            child: ElevatedButton(
              onPressed: () async {
                if (loginKey.currentState!.validate()) {
                  setState(() {
                    isLoading = true;
                  });
                  var firebase = FirebaseAuth.instance;
                  print(firebase.currentUser?.email ?? '-');
                  var status = await firebase.currentUser?.email != null
                      ? await signInWithEmailPassword(email.text, password.text)
                      : registerWithEmailPassword(
                          email.text,
                          password.text,
                        );
                  if (status == 'true') {
                    setState(() {
                      isLoading = false;
                    });
                    showSnackBar(
                        context: context,
                        messg: 'Successfully registered,Signing in...');
                    var signIn = await signInWithEmailPassword(
                      email.text,
                      password.text,
                    );
                    print('Sign IN FACILTY $signIn');
                    Future.delayed(const Duration(seconds: 4), () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (c) => Home()));
                    });
                  } else {
                    setState(() {
                      isLoading = false;
                    });
                    showSnackBar(context: context, messg: '$status');
                  }
                }
                /* Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()));
            */
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                side: MaterialStateProperty.all(
                  const BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                fixedSize: MaterialStateProperty.all(
                  Size(MediaQuery.of(context).size.width,
                      MediaQuery.of(context).size.height / 18),
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                    side: BorderSide.none,
                  ),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: isLoading
                    ? buildLoader()
                    : const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height / 5,
              bottom: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Icon(
                  Icons.wifi_calling_sharp,
                  color: Colors.blue,
                  size: 15,
                ),
                Text(
                  '  Contact Us',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    email.dispose();
    password.dispose();
  }
}
