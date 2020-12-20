import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                    ),
                  ), //Email
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Username',
                    ),
                  ), //User Name
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                  ), //Password
                  SizedBox(
                    height: 12,
                  ),
                  RaisedButton(
                    onPressed: () {},
                    child: Text('Login'),
                  ),
                  FlatButton(
                    onPressed: () {},
                    child: Text('Create new account'),
                  ),
                ],
              ),
            ),
          ),
        ),
        margin: const EdgeInsets.all(20),
      ),
    );
  }
}
