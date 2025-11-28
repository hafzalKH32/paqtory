import 'package:meta/meta.dart';

import '../../data/models/message_model.dart';
import '../../data/models/product_model.dart';

@immutable
class LiveState {
  final List<MessageModel> messages;
  final Product? product;
  final bool loading;

  const LiveState({
    this.messages = const [],
    this.product,
    this.loading = false,
  });

  LiveState copyWith({
    List<MessageModel>? messages,
    Product? product,
    bool? loading,
  }) {
    return LiveState(
      messages: messages ?? this.messages,
      product: product ?? this.product,
      loading: loading ?? this.loading,
    );
  }
}
