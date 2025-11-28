import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:PAQTORY/data/models/message_model.dart';
import 'package:PAQTORY/data/models/product_model.dart';
import 'package:PAQTORY/data/models/session_model.dart';
import 'package:PAQTORY/logic/cart/cart_bloc.dart';
import 'package:PAQTORY/logic/cart/cart_state.dart';
import 'package:PAQTORY/logic/live/live_bloc.dart';
import 'package:PAQTORY/logic/live/live_state.dart';
import 'package:PAQTORY/ui/live/widgets/chat_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LiveSessionScreen extends StatefulWidget {
  const LiveSessionScreen({super.key});

  @override
  State<LiveSessionScreen> createState() => _LiveSessionScreenState();
}

class _LiveSessionScreenState extends State<LiveSessionScreen> {
  final TextEditingController msgCtrl = TextEditingController();
  final ScrollController scrollCtrl = ScrollController();

  /// To know when a product is newly added
  bool _productsInitialized = false;
  int _lastProductCount = 0;

  /// Whether to show the top highlight panel
  bool _showHighlightPanel = false;

  @override
  void dispose() {
    msgCtrl.dispose();
    scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SessionModel session =
    ModalRoute.of(context)!.settings.arguments as SessionModel;

    return BlocProvider(
      create: (_) => LiveBloc(sessionId: session.id)..add(StartLiveEvent()),
      child: Builder(
        builder: (blocContext) {
          const bool isHost = true;

          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF050505), Color(0xFF101010)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // 🔹 CUSTOM APP BAR
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Row(
                        children: [
                          // Back button
                          IconButton(
                            icon:
                            const Icon(Icons.arrow_back_ios_new, size: 18),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const SizedBox(width: 4),

                          // Title + LIVE + viewers
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  session.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(999),
                                        gradient: const LinearGradient(
                                          colors: [Colors.red, Colors.orange],
                                        ),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.fiber_manual_record,
                                            size: 10,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            'LIVE',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 1.1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.remove_red_eye,
                                      size: 14,
                                      color: Colors.white54,
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      '124 watching',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.white60,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 4),
                          BlocBuilder<CartBloc, CartState>(
                            builder: (context, state) {
                              final itemCount = state.items.length;
                              return Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.shopping_bag_outlined,
                                      size: 22,
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/cart');
                                    },
                                  ),
                                  if (itemCount > 0)
                                    Positioned(
                                      top: 6,
                                      right: 4,
                                      child: Container(
                                        padding: const EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          color: Colors.redAccent,
                                          borderRadius:
                                          BorderRadius.circular(999),
                                        ),
                                        constraints: const BoxConstraints(
                                          minWidth: 16,
                                          minHeight: 16,
                                        ),
                                        child: Text(
                                          '$itemCount',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const Divider(
                      color: Colors.white12,
                      height: 1,
                      thickness: 1,
                    ),

                    // 🔹 Section header row
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.chat_bubble_outline,
                              size: 18, color: Colors.white70),
                          const SizedBox(width: 6),
                          const Text(
                            'Live chat',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: () {
                              Navigator.pushNamed(context, '/products');
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
                              ),
                              foregroundColor: Colors.white70,
                            ),
                            icon: const Icon(
                              Icons.storefront_outlined,
                              size: 18,
                            ),
                            label: const Text(
                              'View products',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 🔹 Highlight panel (only when show = true + product exists)
                    BlocBuilder<LiveBloc, LiveState>(
                      buildWhen: (p, c) => p.product != c.product,
                      builder: (context, state) {
                        final Product? product = state.product;

                        if (!_showHighlightPanel || product == null) {
                          return const SizedBox.shrink();
                        }

                        return Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF1E1E1E), Color(0xFF151515)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.9),
                                width: 1.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.18),
                                  blurRadius: 18,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: product.image.isNotEmpty
                                      ? Image.network(
                                    product.image,
                                    width: 64,
                                    height: 64,
                                    fit: BoxFit.cover,
                                  )
                                      : Container(
                                    width: 64,
                                    height: 64,
                                    color: Colors.white10,
                                    child: const Icon(
                                      Icons.shopping_bag_outlined,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(999),
                                              color: Colors.white
                                                  .withOpacity(0.06),
                                              border: Border.all(
                                                  color: Colors.white24),
                                            ),
                                            child: const Text(
                                              'Creator highlight',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.white70,
                                                letterSpacing: 0.4,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        product.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '₹${product.price.toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    // 🔹 Chat + products & input
                    Expanded(
                      child: Column(
                        children: [
                          // CHAT LIST
                          Expanded(
                            child: Container(
                              margin:
                              const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF050505),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white12,
                                  width: 1,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: BlocConsumer<LiveBloc, LiveState>(
                                  listener: (context, state) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      if (scrollCtrl.hasClients) {
                                        scrollCtrl.animateTo(
                                          scrollCtrl
                                              .position.maxScrollExtent,
                                          duration: const Duration(
                                              milliseconds: 250),
                                          curve: Curves.easeOut,
                                        );
                                      }
                                    });
                                  },
                                  builder: (context, state) {
                                    final messages = state.messages;
                                    if (messages.isEmpty) {
                                      return const Center(
                                        child: Text(
                                          'No messages yet.\nSay hi to start the conversation!',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white60,
                                          ),
                                        ),
                                      );
                                    }

                                    final currentUid = FirebaseAuth
                                        .instance.currentUser
                                        ?.uid;

                                    return ListView.builder(
                                      controller: scrollCtrl,
                                      padding: const EdgeInsets.fromLTRB(
                                          12, 10, 12, 10),
                                      itemCount: messages.length,
                                      itemBuilder: (_, i) {
                                        final m = messages[i];
                                        final isMe = m.senderId != null &&
                                            m.senderId == currentUid;
                                        final time =
                                            '${m.time.hour.toString().padLeft(2, '0')}:${m.time.minute.toString().padLeft(2, '0')}';

                                        return ChatBubble(
                                          message: m.message,
                                          sender: m.sender,
                                          time: time,
                                          isMe: isMe,
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // BOTTOM PRODUCTS STRIP (HOST)
                          if (isHost)
                            SizedBox(
                              height: 90,
                              child: StreamBuilder<
                                  QuerySnapshot<Map<String, dynamic>>>(
                                stream: FirebaseFirestore.instance
                                    .collection('products')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return const Center(
                                      child: Text('Error loading products'),
                                    );
                                  }
                                  if (!snapshot.hasData) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  final docs = snapshot.data!.docs;

                                  // firestore order: oldest → newest
                                  final originalProducts = docs.map((d) {
                                    final data = d.data();
                                    return Product(
                                      id: d.id,
                                      name: data['name'] ?? '',
                                      image: data['image'] ?? '',
                                      price:
                                      (data['price'] ?? 0).toDouble(),
                                    );
                                  }).toList();

                                  // UI order: newest first
                                  final products =
                                  originalProducts.reversed.toList();

                                  // Detect newly added product
                                  if (!_productsInitialized) {
                                    _productsInitialized = true;
                                    _lastProductCount =
                                        originalProducts.length;
                                  } else if (originalProducts.length >
                                      _lastProductCount) {
                                    _lastProductCount =
                                        originalProducts.length;
                                    final newItem =
                                        originalProducts.last; // newest

                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      if (!mounted) return;
                                      setState(() {
                                        _showHighlightPanel = true;
                                      });
                                      _setHighlight(
                                          blocContext, session, newItem);
                                    });
                                  } else {
                                    _lastProductCount =
                                        originalProducts.length;
                                  }

                                  if (products.isEmpty) {
                                    return const Center(
                                      child: Text(
                                        'No products yet.\nAdd some products to start highlighting.',
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  }

                                  return ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 6,
                                    ),
                                    itemCount: products.length,
                                    separatorBuilder: (_, __) =>
                                    const SizedBox(width: 10),
                                    itemBuilder: (_, i) {
                                      final p = products[i];

                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, '/products');
                                        },
                                        child: Container(
                                          width: 160,
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF141414),
                                            borderRadius:
                                            BorderRadius.circular(14),
                                            border: Border.all(
                                              color: Colors.white24,
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                child: p.image.isNotEmpty
                                                    ? Image.network(
                                                  p.image,
                                                  width: 40,
                                                  height: 40,
                                                  fit: BoxFit.cover,
                                                )
                                                    : Container(
                                                  width: 40,
                                                  height: 40,
                                                  color:
                                                  Colors.white10,
                                                  child: const Icon(
                                                    Icons
                                                        .shopping_bag_outlined,
                                                    color:
                                                    Colors.white70,
                                                    size: 18,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .center,
                                                  children: [
                                                    Text(
                                                      p.name,
                                                      maxLines: 2,
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                      style:
                                                      const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.w500,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                        height: 4),
                                                    Text(
                                                      '₹${p.price.toStringAsFixed(0)}',
                                                      style:
                                                      const TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                        color:
                                                        Colors.white70,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),

                          // 🔹 INPUT BAR
                          Container(
                            padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
                            decoration: const BoxDecoration(
                              color: Color(0xFF050505),
                              border: Border(
                                top: BorderSide(
                                  color: Colors.white12,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                // 👉 INNER CONTAINER FOR TEXTFIELD STYLE
                                Expanded(
                                  child: TextField(
                                    controller: msgCtrl,
                                    style: const TextStyle(
                                        color: Colors.white),
                                    decoration: const InputDecoration(
                                      hintText: 'Send a message...',
                                      hintStyle: TextStyle(
                                          color: Colors.white54),
                                      border: InputBorder.none,
                                    ),
                                    onSubmitted: (_) =>
                                        _sendMessage(blocContext),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: IconButton(
                                    icon:
                                    const Icon(Icons.send, size: 18),
                                    color: Colors.black,
                                    onPressed: () =>
                                        _sendMessage(blocContext),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _sendMessage(BuildContext blocContext) {
    final text = msgCtrl.text.trim();
    if (text.isEmpty) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final msg = MessageModel(
      sender: user.email ?? 'Anonymous',
      message: text,
      time: DateTime.now(),
      senderId: user.uid,
    );

    blocContext.read<LiveBloc>().add(SendMessageEvent(msg));
    msgCtrl.clear();
  }

  /// Writes highlight to Firestore (everyone sees it)
  Future<void> _setHighlight(
      BuildContext context,
      SessionModel session,
      Product product,
      ) async {
    try {
      await FirebaseFirestore.instance
          .collection('live_sessions')
          .doc(session.id)
          .collection('highlights')
          .doc('active')
          .set({
        'productId': product.id,
        'name': product.name,
        'image': product.image,
        'price': product.price,
      }, SetOptions(merge: true));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to set highlight: $e')),
      );
    }
  }
}

