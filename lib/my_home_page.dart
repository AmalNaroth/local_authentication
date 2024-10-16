import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isAuthenticated = false;
  final LocalAuthentication _localAuth = LocalAuthentication();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUi(),
      floatingActionButton: _authButton(),
    );
  }

  Widget _authButton() {
    return FloatingActionButton(
      onPressed: () async {
        if (!_isAuthenticated) {
          try {
            final bool canAuthenticateWithBiocmetrics =
                await _localAuth.canCheckBiometrics;

            if (canAuthenticateWithBiocmetrics) {
              final bool didAuthenticate = await _localAuth.authenticate(
                localizedReason: "Please authenticate to see the bank balance",
                options: const AuthenticationOptions(biometricOnly: true),
              );

              setState(() {
                _isAuthenticated = didAuthenticate;
              });
            }
          } catch (e) {
            log(e.toString());
          }
        } else {
          setState(() {
            _isAuthenticated = false;
          });
        }
        setState(() {
          _isAuthenticated = !_isAuthenticated;
        });
      },
      child: Icon(
          _isAuthenticated ? Icons.lock_open_outlined : Icons.lock_outline),
    );
  }

  Widget _buildUi() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Account Balance",
            style: TextStyle(
                color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          !_isAuthenticated
              ? Text(
                  "45553",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                )
              : SizedBox(),
          _isAuthenticated
              ? Text(
                  "******",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
