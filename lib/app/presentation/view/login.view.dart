import 'package:caship/app/viewmodel/login.viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neopop/neopop.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      loginViewModelProvider,
      (previous, next) {},
      onError: (_, __) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Something went wrong while signing you in')));
      },
    );
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NeoPopButton(
                color: Colors.white,
                onTapUp: () => onTapUp(ref),
                onTapDown: onTapDown,
                onLongPress: onLongPress,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Sign In with Google',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void onTapUp(WidgetRef ref) {
    HapticFeedback.lightImpact();
    ref.read(loginViewModelProvider.notifier).signIn();
  }

  void onTapDown() {
    HapticFeedback.lightImpact();
  }

  void onLongPress() {
    HapticFeedback.heavyImpact();
  }
}
