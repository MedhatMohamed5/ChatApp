import 'dart:io';

import 'package:flutter/material.dart';
import '../pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final bool isLoading;
  final void Function(
    String email,
    String password,
    String username,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) submitForm;
  AuthForm(this.isLoading, this.submitForm);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  File _pickedImage;

  void _pickImage(File image) {
    _pickedImage = image;
  }

  void _trySubmit() {
    FocusScope.of(context).unfocus();

    if (_pickedImage == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: Text(
            'Please Pick an Image',
          ),
        ),
      );

      return;
    }

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      widget.submitForm(_userEmail, _userPassword, _userName, _pickedImage,
          _isLogin, context);
      print(_userName);
      print(_userEmail);
      print(_userPassword);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin) UserImagePicker(_pickImage),
                  TextFormField(
                    key: ValueKey('email'),
                    autocorrect: false,
                    validator: (value) {
                      if (value.trim().isEmpty || !value.trim().contains('@'))
                        return 'Please enter a vaild email address';
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                    ),
                    onSaved: (value) {
                      _userEmail = value.trim();
                    },
                  ), //Email
                  if (!_isLogin)
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      key: ValueKey('username'),
                      validator: (value) {
                        if (value.trim().isEmpty || value.trim().length < 4)
                          return 'Please enter a valid username';
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Username',
                      ),
                      onSaved: (value) {
                        _userName = value.trim();
                      },
                    ), //User Name
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value.trim().isEmpty || value.trim().length < 8)
                        return 'Please enter a strong password at least 8 characters without spaces';
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    onSaved: (value) {
                      _userPassword = value.trim();
                    },
                    onChanged: (value) {
                      _userPassword = value.trim();
                    },
                  ), //Password
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('passwordConfirm'),
                      validator: (value) {
                        if (value.trim().isEmpty)
                          return 'Please enter a confirmed password at least 8 characters without spaces';
                        if (value.trim() != _userPassword)
                          return 'Not matched!';
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                      ),
                    ), //Confirm Password

                  SizedBox(
                    height: 12,
                  ),
                  widget.isLoading
                      ? CircularProgressIndicator()
                      : RaisedButton(
                          onPressed: _trySubmit,
                          child: Text(_isLogin ? 'Login' : 'Sign up'),
                        ),
                  if (!widget.isLoading)
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'Have account? Login'),
                      textColor: Theme.of(context).primaryColor,
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
