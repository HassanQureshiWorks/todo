import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_hassan/dialog.dart';
import 'package:todo_hassan/firebase-auth_implementatin/firebase_auth_services.dart';
import 'package:todo_hassan/home/home.dart';
import '../signin/signin.dart';

class Signupdetails extends StatefulWidget {

  @override
  State<Signupdetails> createState() => SignupdetailsState();
}

class SignupdetailsState extends State<Signupdetails> {

  final _formKey = GlobalKey<FormState>(); // Form key for validation

  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController professionController = TextEditingController();

  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    professionController.dispose();


    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            // Background Image
            // Positioned.fill(
            //   child: Image.asset(
            //     'assets/background.png',
            //     fit: BoxFit.cover,
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Let's Sign up",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: _buildTextField(Icons.person, "Firstname", firstnameController),
                      ),
                      SizedBox(width: 16), // Adjust the spacing here
                      Flexible(
                        flex: 2,
                        child: _buildTextField(Icons.person, "Lastname", lastnameController),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),
                  _buildTextField(Icons.email, "Enter your email",emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email cannot be empty';
                        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      } ),
                  SizedBox(height: 10),
                  _buildTextField(Icons.lock, "Enter Password",passwordController ,obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password cannot be empty';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      }),
                  SizedBox(height: 10),
                  _buildTextField(Icons.person, "Enter profession",professionController,),
                  SizedBox(height: 10),
                  SizedBox(height: 20),
                  _buildButton("Sign up", Colors.green),
                  SizedBox(height: 10),
                  Center(child: Text("OR")),
                  SizedBox(height: 10),
                  _buildGoogleButton(),
                  SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => Signin()),
                        );
                      },
                      child: Text("Already have an account? Sign in"),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(IconData icon, String hint,TextEditingController controller,
      {bool obscureText = false, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      textCapitalization: TextCapitalization.words,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
      ),
      validator: validator,
    );
  }

  Widget _buildButton(String text, Color color) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate())
          _signup(context);
        },
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildGoogleButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        },
        icon: Image.asset('assets/images/google_logo.png', height: 24),
        label: Text(
          "Sign up with Google",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  void _signup(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    if (user != null) { // ✅ Correct variable name
      print("User is successfully created");
      adduserdetails(
          firstnameController.text,
          lastnameController.text,
          emailController.text,
          professionController.text);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Home()), // ✅ Ensure correct navigation
      );
    } else {
      showError(context);
      print("Some error happened");

    }
  }


  void showError(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      headerAnimationLoop: false,
      animType: AnimType.bottomSlide,
      title: 'Error',
      desc: FirebaseAuthService.error,
      buttonsTextStyle: const TextStyle(color: Colors.black),
      showCloseIcon: true,
      btnCancelOnPress: () {},
      btnOkOnPress: () {},
    ).show();
  }
}
Future adduserdetails(String firstname,String lastname, String email, String profession) async{
  await FirebaseFirestore.instance.collection('users').add({
    'firstname' : firstname,
    'lastname' : firstname,
    'email' : email,
    'profession': profession,
  });
}
