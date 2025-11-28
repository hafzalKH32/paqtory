part of 'session_bloc.dart';

@immutable
class SessionsState {
  final bool loading;
  final List<SessionModel> sessions;
  final String? error;

  const SessionsState({
    this.loading = false,
    this.sessions = const [],
    this.error,
  });

  SessionsState copyWith({
    bool? loading,
    List<SessionModel>? sessions,
    String? error,
  }) {
    return SessionsState(
      loading: loading ?? this.loading,
      sessions: sessions ?? this.sessions,
      error: error,
    );
  }
}
