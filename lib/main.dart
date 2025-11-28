import 'package:PAQTORY/data/repository/product_repository.dart';
import 'package:PAQTORY/logic/product/product_bloc.dart';
import 'package:PAQTORY/ui/live/live_screen.dart';
import 'package:PAQTORY/ui/product/product_screen.dart';
import 'package:PAQTORY/ui/session/session_screen.dart';
import 'package:PAQTORY/ui/splash/splash_screen.dart';
import 'package:PAQTORY/ui/success/success_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'data/repository/auth_repository.dart';
import 'logic/cart/cart_bloc.dart';
import 'logic/login/login_bloc.dart';
import 'ui/login/login_screen.dart';
import 'ui/cart/cart_screen.dart' hide LiveSessionScreen;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// App startup: Firebase init + auth check + (optional) other data loads
  Future<bool> _initApp() async {
    // 1. Init Firebase
    await Firebase.initializeApp();

    // 2. TODO: load any initial data here (Firestore, repos, etc.)
    // await ProductRepository().preloadSomething();
    // await Future.delayed(const Duration(seconds: 1)); // demo delay

    // 3. Check if user is already logged in
    final user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CartBloc>(
          create: (_) => CartBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Co-Shopping',
        theme: _buildDarkTheme(),

        // We control the first screen with FutureBuilder
        home: FutureBuilder<bool>(
          future: _initApp(),
          builder: (context, snapshot) {


            if (snapshot.hasError) {
              // Optional simple error UI
              return Scaffold(
                body: Center(
                  child: Text(
                    'Something went wrong:\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final bool isLoggedIn = snapshot.data ?? false;

            // Decide first screen AFTER Firebase + auth are ready
            if (isLoggedIn) {
              return const SessionsScreen();
            } else {
              return BlocProvider<LoginBloc>(
                create: (_) => LoginBloc(AuthRepository()),
                child: const LoginScreen(),
              );
            }
          },
        ),

        // You can still use routes as usual
        routes: {
          '/login': (_) => BlocProvider<LoginBloc>(
            create: (_) => LoginBloc(AuthRepository()),
            child: const LoginScreen(),
          ),
          '/sessions': (_) => const SessionsScreen(),
          '/live': (context) => BlocProvider.value(
            value: BlocProvider.of<CartBloc>(context),
            child: const LiveSessionScreen(),
          ),
          '/cart': (_) => const CartScreen(),
          '/products': (_) => BlocProvider(
            create: (_) => ProductBloc(ProductRepository())
              ..add(LoadProductsEvent()),
            child: const ProductScreen(),
          ),
          '/success': (_) => const SuccessScreen(),
        },
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: false,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF111111),
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: const Color(0xFF111111),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white, width: 1.2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1A1A1A),
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.white24, width: 1),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        textColor: Colors.white,
        iconColor: Colors.white70,
      ),
    );
  }
}
