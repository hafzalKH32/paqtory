part of 'live_bloc.dart';

@immutable
sealed class LiveEvent {}

class StartLiveEvent extends LiveEvent {}

class SendMessageEvent extends LiveEvent {
  final MessageModel message;
  SendMessageEvent(this.message);
}

// 🔒 Internal events – used only inside bloc
class _ChatUpdatedEvent extends LiveEvent {
  final QuerySnapshot<Map<String, dynamic>> snapshot;
  _ChatUpdatedEvent(this.snapshot);
}

class _HighlightUpdatedEvent extends LiveEvent {
  final DocumentSnapshot<Map<String, dynamic>> doc;
  _HighlightUpdatedEvent(this.doc);
}
