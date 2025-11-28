part of 'session_bloc.dart';

@immutable
sealed class SessionsEvent {}

class LoadSessionsEvent extends SessionsEvent {}
