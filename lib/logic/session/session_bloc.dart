import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../data/repository/session_repository.dart';
import '../../data/models/session_model.dart';

part 'session_event.dart';
part 'session_state.dart';

class SessionsBloc extends Bloc<SessionsEvent, SessionsState> {
  final SessionRepository repo;

  SessionsBloc(this.repo) : super(const SessionsState(loading: true)) {
    on<LoadSessionsEvent>(_onLoadSessions);
  }

  Future<void> _onLoadSessions(
      LoadSessionsEvent event,
      Emitter<SessionsState> emit,
      ) async {
    emit(state.copyWith(loading: true, error: null));

    try {
      final sessions = await repo.fetchSessions();
      emit(state.copyWith(
        loading: false,
        sessions: sessions,
      ));
    } catch (e) {
      emit(state.copyWith(
        loading: false,
        error: e.toString(),
      ));
    }
  }
}
