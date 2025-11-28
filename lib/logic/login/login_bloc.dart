import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repository/auth_repository.dart';
import 'login_state.dart';

part 'login_event.dart';



class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository repo;

  LoginBloc(this.repo) : super(const LoginState()) {
    on<LoginSubmitEvent>((event, emit) async {
      emit(state.copyWith(loading: true, error: null));

      try {
        await repo.login(event.email, event.password);
        emit(state.copyWith(loading: false, success: true));
      } catch (e) {
        emit(state.copyWith(loading: false, error: e.toString()));
      }
    });
  }
}
