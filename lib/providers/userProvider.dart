import 'package:caship/models/userModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserNotifier extends StateNotifier<User> {
  UserNotifier(User user) : super(user);

  changeName(String name) {
    state.changeName(name);
  }
}

final userProvider =
    StateNotifierProvider<UserNotifier, User>((ref) => UserNotifier(User(
          id: "0",
          name: "Nivas Muthu M G",
          username: "nithsua",
          createdAt: DateTime.now(),
          lastLogin: DateTime.now(),
        )));
