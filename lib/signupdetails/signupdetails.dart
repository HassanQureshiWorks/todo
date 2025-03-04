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
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController otherProfessionController = TextEditingController(); // Controller for custom profession

  String? selectedProfession; // Holds selected dropdown value
  bool isOtherSelected = false; // Track if "Other" is selected

  List<String> professions = [
    "Doctor",
    "Engineer",
    "Teacher",
    "Businessman",
    "Student",
    "Freelancer",
    "Other"
  ];

  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    addressController.dispose();
    otherProfessionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 80,),
                Text(
                  "Let's Sign up",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: _buildTextField(Icons.person, "Firstname", firstnameController),
                    ),
                    SizedBox(width: 16),
                    Flexible(
                      flex: 1,
                      child: _buildTextField(Icons.person, "Lastname", lastnameController),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                _buildTextField(Icons.email, "Enter your email", emailController, validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email cannot be empty';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                }),
                SizedBox(height: 10),
                _buildTextField(Icons.lock, "Enter Password", passwordController, obscureText: true, validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password cannot be empty';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                }),
                SizedBox(height: 10),

                // Profession Drop-down
                _buildProfessionDropdown(),

                // Custom Profession Text Field (Appears if "Other" is selected)
                if (isOtherSelected)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: _buildTextField(Icons.work, "Enter your profession", otherProfessionController),
                  ),

                SizedBox(height: 10),
                _buildTextField(Icons.location_on, "Address", addressController),
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
        ),
      ),
    );
  }

  // Profession Dropdown
  Widget _buildProfessionDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedProfession,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.work),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
      ),
      hint: Text("Select your profession"),
      items: professions.map((String profession) {
        return DropdownMenuItem<String>(
          value: profession,
          child: Text(profession),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedProfession = value;
          isOtherSelected = value == "Other"; // Show text field if "Other" is selected
        });
      },
      validator: (value) => value == null ? "Please select a profession" : null,
    );
  }

  // Text Field Builder
  Widget _buildTextField(IconData icon, String hint, TextEditingController controller,
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

  // Signup Button
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
          if (_formKey.currentState!.validate()) _signup(context);
        },
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  // Google Sign-Up Button
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

  // Signup Function
  void _signup(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    try {
      User? user = await _auth.signUpWithEmailAndPassword(email, password);

      if (user != null) {
        print("User successfully created");

        String profession = isOtherSelected ? otherProfessionController.text : selectedProfession!;

        adduserdetails(
          firstnameController.text,
          lastnameController.text,
          emailController.text,
          profession,
          addressController.text,
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Home()),
        );
      }
    } catch (e) {
      showError(context, e.toString());
    }
  }

  // Show Error Dialog
  void showError(BuildContext context, String errorMessage) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      headerAnimationLoop: false,
      animType: AnimType.bottomSlide,
      title: 'Error',
      desc: errorMessage,
      buttonsTextStyle: const TextStyle(color: Colors.black),
      showCloseIcon: true,
      btnCancelOnPress: () {},
      btnOkOnPress: () {},
    ).show();
  }
}

// Firestore: Store User Data
Future adduserdetails(String firstname, String lastname, String email, String profession, String address) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'profession': profession,
      'address': address,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
