import 'dart:async';

import 'package:caship/app/presentation/view/home.view.dart';
import 'package:caship/app/presentation/view/login.view.dart';
import 'package:caship/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  StreamSubscription<User?>? _streamSubscription;

  @override
  void initState() {
    super.initState();
    _streamSubscription ??= FirebaseAuth.instance.userChanges().listen((user) {
      if (user == null) {
        navigationKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => LoginScreen()), (route) => false);
      } else {
        navigationKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => HomeScreen()), (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
