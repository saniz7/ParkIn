import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
  });
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  //textcontroller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateNull(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    // Additional email validation logic can be implemented here
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: tFormHeight - 10),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      prefix: Icon(Icons.person_outline_outlined),
                      labelText: tEmail,
                      hintText: tEmail,
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateNull,
                  ),
                  const SizedBox(
                    height: tFormHeight - 20,
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      prefix: Icon(Icons.fingerprint),
                      labelText: tPassword,
                      hintText: tPassword,
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: null,
                        icon: Icon(Icons.remove_red_eye_sharp),
                      ),
                    ),
                    validator: _validateNull,
                  ),
                  const SizedBox(
                    height: tFormHeight - 20,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () {}, child: Text(tForgetPassword)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: GestureDetector(
                      onTap: () {
                        if (_formKey.currentState?.validate() == true) {
                          signIn();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.all(14.0),
                            child: Text('Sign In',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
