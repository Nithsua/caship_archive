import 'package:freezed_annotation/freezed_annotation.dart';

part 'login.model.freezed.dart';
part 'login.model.g.dart';

@freezed
class LoginModel with _$LoginModel {
  const factory LoginModel({required bool loading}) = _LoginModel;

  factory LoginModel.initial() => const LoginModel(loading: false);

  factory LoginModel.fromJson(Map<String, dynamic> json) =>
      _$LoginModelFromJson(json);
}
