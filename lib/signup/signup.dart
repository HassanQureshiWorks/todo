import 'package:flutter/material.dart';
import 'package:todo_hassan/signin/signin.dart';

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/signup_background.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sign up",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              _buildSignUpOption("Sign up as Kiraya Daar", Icons.home, () {}),
              SizedBox(height: 10),
              _buildSignUpOption("Sign up as Makan Malik", Icons.apartment, () {}),
              SizedBox(height: 10),
              _buildSignUpOption("Sign up as Dealer", Icons.business, () {}),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Signin()),
                  );
                },
                child: Text("Don't have an account? Register"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpOption(String text, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.black),
          ),
          padding: EdgeInsets.symmetric(vertical: 15),
        ),
        onPressed: onTap,
        icon: Icon(icon, color: Colors.black),
        label: Text(
          text,
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
    );
  }
}
