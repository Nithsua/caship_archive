import 'package:caship/app/model/view/login.model.dart';
import 'package:caship/app/service/authentication.service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginViewModel extends StateNotifier<LoginModel> {
  final authenticationService = AuthenticationService();
  LoginViewModel() : super(LoginModel.initial());

  Future<void> signIn() async {
    state = state.copyWith(loading: true);
    await authenticationService.signInWithGoogle().onError((_, __) {});
    state = state.copyWith(loading: true);
  }
}

final loginViewModelProvider = StateNotifierProvider((ref) {
  return LoginViewModel();
});
