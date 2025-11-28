import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/message_model.dart';
import '../../data/models/product_model.dart';
import 'live_state.dart';

part 'live_event.dart';

class LiveBloc extends Bloc<LiveEvent, LiveState> {
  final String sessionId;
  final FirebaseFirestore _firestore;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _chatSub;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _highlightSub;

  LiveBloc({
    required this.sessionId,
    FirebaseFirestore? firestore,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        super(const LiveState()) {
    on<StartLiveEvent>(_onStartLive);
    on<SendMessageEvent>(_onSendMessage);
    on<_ChatUpdatedEvent>(_onChatUpdated);
    on<_HighlightUpdatedEvent>(_onHighlightUpdated);
  }

  Future<void> _onStartLive(
      StartLiveEvent event,
      Emitter<LiveState> emit,
      ) async {
    emit(state.copyWith(loading: true));

    // 🔹 Chat subscription
    final chatQuery = _firestore
        .collection('live_sessions')
        .doc(sessionId)
        .collection('messages')
        .orderBy('time', descending: false);

    _chatSub = chatQuery.snapshots().listen((snapshot) {
      add(_ChatUpdatedEvent(snapshot));
    });

    // 🔹 Highlight subscription
    final highlightDoc = _firestore
        .collection('live_sessions')
        .doc(sessionId)
        .collection('highlights')
        .doc('active');

    _highlightSub = highlightDoc.snapshots().listen((doc) {
      if (doc.exists) {
        add(_HighlightUpdatedEvent(doc));
      }
    });

    emit(state.copyWith(loading: false));
  }

  Future<void> _onSendMessage(
      SendMessageEvent event,
      Emitter<LiveState> emit,
      ) async {
    // 1) Optimistic UI update – show immediately
    final updatedMessages = List<MessageModel>.from(state.messages)
      ..add(event.message);
    emit(state.copyWith(messages: updatedMessages));

    // 2) Persist to Firestore
    final ref = _firestore
        .collection('live_sessions')
        .doc(sessionId)
        .collection('messages');

    await ref.add(event.message.toJson());
    // When Firestore snapshot updates, _ChatUpdatedEvent will refresh from server
  }

  void _onChatUpdated(
      _ChatUpdatedEvent event,
      Emitter<LiveState> emit,
      ) {
    final messages = event.snapshot.docs
        .map((d) => MessageModel.fromJson(d.data()))
        .toList();

    emit(state.copyWith(messages: messages));
  }

  void _onHighlightUpdated(
      _HighlightUpdatedEvent event,
      Emitter<LiveState> emit,
      ) {
    final data = event.doc.data();
    if (data == null || data.isEmpty) return;

    final product = Product(
      id: data['productId'] ?? '',
      name: data['name'] ?? '',
      image: data['image'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
    );

    emit(state.copyWith(product: product));
  }

  @override
  Future<void> close() {
    _chatSub?.cancel();
    _highlightSub?.cancel();
    return super.close();
  }
}
