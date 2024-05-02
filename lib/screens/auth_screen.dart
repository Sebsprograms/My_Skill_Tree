import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_skill_tree/resources/firebase_auth.dart';
import 'package:my_skill_tree/utils/globals.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    super.key,
    required this.setUiColor,
    required this.uiColor,
  });

  final void Function(Color color) setUiColor;
  final Color uiColor;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = false;
  bool _isAuthenticating = false;
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _name = '';

  void _submit(BuildContext context) async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) return;

    _formKey.currentState!.save();

    setState(() {
      _isAuthenticating = true;
    });
    String response = 'something went wrong';
    if (_isLogin) {
      response = await AuthMethods().loginUser(
        email: _email,
        password: _password,
      );
    } else {
      String uiColor = appColors.entries
          .firstWhere((element) => element.value == widget.uiColor)
          .key;
      response = await AuthMethods().signUpUser(
        email: _email,
        password: _password,
        name: _name,
        uiColor: uiColor,
      );
    }
    setState(() {
      _isAuthenticating = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'My Skill Tree',
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _isLogin ? 'Login' : 'Signup',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        if (!_isLogin)
                          DropdownButtonFormField(
                            value: widget.uiColor,
                            decoration: const InputDecoration(
                              labelText: 'Choose a color for the app',
                            ),
                            items: [
                              for (final color in appColors.entries)
                                DropdownMenuItem(
                                  value: color.value,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 16,
                                        height: 16,
                                        color: color.value,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(color.key),
                                    ],
                                  ),
                                ),
                            ],
                            onChanged: (value) {
                              widget.setUiColor(value as Color);
                            },
                          ),
                        if (!_isLogin) const SizedBox(height: 12),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Email Address'),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains('@')) {
                              return 'Please enter a valid email address.';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _email = newValue!;
                          },
                        ),
                        if (!_isLogin)
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Name'),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your name.';
                              }
                              if (value.length < 2) {
                                return 'Username must be at least 2 characters long.';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _name = newValue!;
                            },
                          ),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.trim().length < 7) {
                              return 'password must be at least 7 characters long.';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _password = newValue!;
                          },
                        ),
                        const SizedBox(height: 12),
                        if (_isAuthenticating)
                          const CircularProgressIndicator()
                        else
                          ElevatedButton(
                            onPressed: () => _submit(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                            child: Text(_isLogin ? 'Login' : 'Signup'),
                          ),
                        if (_isAuthenticating)
                          const CircularProgressIndicator()
                        else
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child: Text(_isLogin
                                ? 'Create an account'
                                : 'I already have an account'),
                          ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
